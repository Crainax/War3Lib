#ifndef GuarderIncluded
#define GuarderIncluded

//! zinc
/*
召唤物守护系统
按玩家管理，每个玩家一个主人单位，召唤物围绕主人进行智能AI
使用 BeyondSpeed 的超级移速配合状态机实现移动/追击
*/

// 可调参数
#define GUARD_TICK                   0.20   // AI 更新周期（秒）：每 0.20 秒执行一次守卫 AI 逻辑
#define GUARD_SEARCH_RADIUS          1200.0 // 敌人搜索半径（码）：以主人为中心，在此范围内搜索敌人
#define GUARD_ATTACK_RANGE           500.0  // 攻击判定范围（码）：守卫与敌人距离 ≤ 此值时，下达 attack 命令
#define GUARD_RING_RADIUS            400.0  // 环形站位半径（码）：无敌人时，守卫围绕主人形成环形阵型的半径
#define GUARD_SUPER_SPEED_BONUS      800    // 超级移速加成（整数）：守卫加入时获得的额外移速（突破 522 上限）
#define GUARD_MOVE_POINT_EPS         50.0   // 移动指令更新阈值（码）：move 目标点变化超过此值才重新下达 move 命令（避免频繁刷屏）
#define GUARD_MAX_PETS_PER_PLAYER    1300   // 每玩家最大守卫数量：单个玩家最多可拥有的守卫数量上限
#define GUARD_FREE_RADIUS            600.0  // 主人附近自由活动半径：主人在这个距离内小范围移动时，pet 不需要重新排队跟着转
#define GUARD_RETURN_RADIUS          1200.0 // 超过这个距离开始“正常跑回”主人附近
#define GUARD_TELEPORT_RADIUS        2200.0 // 超过这个距离不再跑，直接瞬移回主人附近
#define GUARD_TELEPORT_OFFSET        150.0  // 瞬移回主人附近的随机偏移半径，避免所有宠物叠在一个点
#define GUARD_IDLE_OWNER_MOVE_EPS    400.0  // 主人小幅移动时，idle 环绕不更新的阈值


// 状态枚举
#define GUARDER_STATE_NONE  0
#define GUARDER_STATE_IDLE_RING  1
#define GUARDER_STATE_MOVE  2
#define GUARDER_STATE_ATTACK  3
#define GUARDER_STATE_PAUSED  4


library Guarder requires BeyondSpeed, Geometry, GroupUtils, UnitFilter {

    // 数据结构：按玩家紧凑数组
    private struct GuarderData []{
        // 每玩家主人单位
        private static unit owner[];

        // 该玩家的召唤物列表（紧凑，1..size）
        private static unit pet[MAX_PLAYER_COUNT][GUARD_MAX_PETS_PER_PLAYER];
        private static integer size[];

        // 状态机状态码
        private static integer state[MAX_PLAYER_COUNT][GUARD_MAX_PETS_PER_PLAYER];

        // 当前目标缓存
        private static unit target[MAX_PLAYER_COUNT][GUARD_MAX_PETS_PER_PLAYER];

        // 最近一次下达的 move 目的地
        private static real moveX[MAX_PLAYER_COUNT][GUARD_MAX_PETS_PER_PLAYER];
        private static real moveY[MAX_PLAYER_COUNT][GUARD_MAX_PETS_PER_PLAYER];

        // 本 tick（单个 pid）用到的临时敌人列表（JASS 不支持数组传参，因此用静态变量中转）
        private static unit enemies[];
        private static integer enemyCount = 0;

        // idle 环绕时记录“上一次环绕中心的主人坐标”（按玩家）
        private static real ringOwnerX[];
        private static real ringOwnerY[];

        // 外部暂停标志（用于特殊剧情/复活等）
        private static boolean paused[];

        // 周期 tick timer
        private static timer tickTimer;

        // 检查玩家ID有效性
        private static method isValidPid(integer pid) -> boolean {
            return pid >= 1 && pid <= MAX_PLAYER_COUNT;
        }

        // 检查索引有效性
        private static method isValidIdx(integer pid, integer idx) -> boolean {
            return GuarderData.isValidPid(pid) && idx >= 1 && idx <= GuarderData.size[pid];
        }

        // 初始化主人单位
        public static method initOwner(player p, unit ownerUnit) {
            integer pid;

            if (p == null || ownerUnit == null) { return; }

            pid = GetConvertedPlayerId(p);
            if (!GuarderData.isValidPid(pid)) { return; }

            GuarderData.owner[pid] = ownerUnit;
        }

        // 添加召唤物
        public static method addPet(player p, unit petUnit) -> boolean {
            integer pid; integer idx;

            if (p == null || petUnit == null) { return false; }

            pid = GetConvertedPlayerId(p);
            if (!GuarderData.isValidPid(pid)) { return false; }

            // 检查是否已存在
            for (1 <= idx <= GuarderData.size[pid]) {
                if (GuarderData.pet[pid][idx] == petUnit) {
                    return false; // 已存在
                }
            }

            // 检查容量
            if (GuarderData.size[pid] >= GUARD_MAX_PETS_PER_PLAYER) {
                return false; // 容量已满
            }

            // 紧凑追加
            GuarderData.size[pid] = GuarderData.size[pid] + 1;
            idx = GuarderData.size[pid];
            GuarderData.pet[pid][idx] = petUnit;
            GuarderData.state[pid][idx] = GUARDER_STATE_NONE;
            GuarderData.target[pid][idx] = null;
            GuarderData.moveX[pid][idx] = 0.0;
            GuarderData.moveY[pid][idx] = 0.0;

            AddUnitSuperSpeed(petUnit, GUARD_SUPER_SPEED_BONUS);

            return true;
        }

        // 移除召唤物（线性查找并紧凑删除）
        public static method removePet(player p, unit petUnit) -> boolean {
            integer pid; integer idx; integer last;

            if (p == null || petUnit == null) { return false; }

            pid = GetConvertedPlayerId(p);
            if (!GuarderData.isValidPid(pid)) { return false; }

            // 线性查找
            for (1 <= idx <= GuarderData.size[pid]) {
                if (GuarderData.pet[pid][idx] == petUnit) {
                    AddUnitSuperSpeed(petUnit, -GUARD_SUPER_SPEED_BONUS);

                    // 紧凑删除
                    last = GuarderData.size[pid];
                    if (idx != last) {
                        // 将最后元素移到当前位置
                        GuarderData.pet[pid][idx] = GuarderData.pet[pid][last];
                        GuarderData.state[pid][idx] = GuarderData.state[pid][last];
                        GuarderData.target[pid][idx] = GuarderData.target[pid][last];
                        GuarderData.moveX[pid][idx] = GuarderData.moveX[pid][last];
                        GuarderData.moveY[pid][idx] = GuarderData.moveY[pid][last];
                    }
                    // 清空最后位置
                    GuarderData.pet[pid][last] = null;
                    GuarderData.state[pid][last] = GUARDER_STATE_NONE;
                    GuarderData.target[pid][last] = null;
                    GuarderData.moveX[pid][last] = 0.0;
                    GuarderData.moveY[pid][last] = 0.0;
                    GuarderData.size[pid] = GuarderData.size[pid] - 1;
                    return true;
                }
            }

            return false; // 未找到
        }

        // 清空该玩家全部 pet（不负责删除单位，仅解绑/清空引用）
        public static method clear(player p) {
            integer pid; integer idx;

            if (p == null) { return; }

            pid = GetConvertedPlayerId(p);
            if (!GuarderData.isValidPid(pid)) { return; }

            for (1 <= idx <= GuarderData.size[pid]) {
                if (GuarderData.pet[pid][idx] != null) {
                    AddUnitSuperSpeed(GuarderData.pet[pid][idx], -GUARD_SUPER_SPEED_BONUS);
                    GuarderData.pet[pid][idx] = null;
                }
                GuarderData.state[pid][idx] = GUARDER_STATE_NONE;
                GuarderData.target[pid][idx] = null;
                GuarderData.moveX[pid][idx] = 0.0;
                GuarderData.moveY[pid][idx] = 0.0;
            }

            GuarderData.size[pid] = 0;
        }

        // 外部强制暂停/恢复
        public static method setPaused(player p, boolean paused) {
            integer pid;

            if (p == null) { return; }

            pid = GetConvertedPlayerId(p);
            if (!GuarderData.isValidPid(pid)) { return; }

            GuarderData.paused[pid] = paused;
        }

        // 记录 move 指令，避免重复下达
        private static method orderMove(integer pid, integer idx, unit petUnit, real x, real y, integer newState, unit newTarget) {
            real lastX; real lastY; boolean needOrder; real diff;

            lastX = GuarderData.moveX[pid][idx];
            lastY = GuarderData.moveY[pid][idx];
            diff = GetDistance(lastX, lastY, x, y);
            needOrder = (GuarderData.state[pid][idx] != newState) || (GuarderData.target[pid][idx] != newTarget) || (diff > GUARD_MOVE_POINT_EPS);

            if (needOrder) {
                IssuePointOrder(petUnit, "move", x, y);
                GuarderData.moveX[pid][idx] = x;
                GuarderData.moveY[pid][idx] = y;
                GuarderData.state[pid][idx] = newState;
                GuarderData.target[pid][idx] = newTarget;
            }
        }

        // 下达 stop，避免重复打断
        private static method orderStop(integer pid, integer idx, unit petUnit, integer newState) {
            boolean needOrder;
            needOrder = (GuarderData.state[pid][idx] != newState) || (GuarderData.target[pid][idx] != null) || (GuarderData.moveX[pid][idx] != 0.0) || (GuarderData.moveY[pid][idx] != 0.0);
            if (needOrder) {
                IssueImmediateOrder(petUnit, "stop");
                GuarderData.state[pid][idx] = newState;
                GuarderData.target[pid][idx] = null;
                GuarderData.moveX[pid][idx] = 0.0;
                GuarderData.moveY[pid][idx] = 0.0;
            }
        }

        // 计算环绕角度（角度随当前玩家 pet 数量自适应：2=>180°,3=>120°,8=>45°）
        private static method getRingAngle(integer pid, integer idx) -> real {
            integer count;
            count = GuarderData.size[pid];
            if (count <= 0) { count = 1; }
            return (360.0 / I2R(count)) * I2R(idx - 1);
        }

        // 处理单个 pet 的 AI
        private static method updatePetWithEnemies(integer pid, integer idx) {
            unit petUnit; unit ownerUnit; unit targetUnit; unit bestTarget; unit enemyUnit; player ownerPlayer;
            integer state; integer i; integer enemyCount;
            real px; real py; real ox; real oy; real distToOwner;
            real nx; real ny; real angle; real tx; real ty;
            real bestDist; real dist; real dx; real dy; boolean ownerPaused;
            real ownerMoveDist;

            if (!GuarderData.isValidIdx(pid, idx)) { return; }

            petUnit = GuarderData.pet[pid][idx];
            if (petUnit == null || GetUnitTypeId(petUnit) == 0) { return; }

            ownerUnit = GuarderData.owner[pid];
            if (ownerUnit == null || !IsUnitAliveBJ(ownerUnit)) {
                GuarderData.removePet(ConvertedPlayer(pid), petUnit);
                petUnit = null;
                ownerUnit = null;
                return;
            }

            state = GuarderData.state[pid][idx];
            targetUnit = GuarderData.target[pid][idx];

            px = GetUnitX(petUnit);
            py = GetUnitY(petUnit);
            ox = GetUnitX(ownerUnit);
            oy = GetUnitY(ownerUnit);
            distToOwner = GetDistance(px, py, ox, oy);

            ownerPaused = GuarderData.paused[pid] || IsUnitPaused(ownerUnit);
            if (ownerPaused) {
                if (state != GUARDER_STATE_PAUSED) {
                    PauseUnit(petUnit, true);
                    GuarderData.state[pid][idx] = GUARDER_STATE_PAUSED;
                    GuarderData.target[pid][idx] = null;
                }
                petUnit = null;
                ownerUnit = null;
                targetUnit = null;
                return;
            } else if (IsUnitPaused(petUnit)) {
                PauseUnit(petUnit, false);
            }

            enemyCount = GuarderData.enemyCount;

            // 1) 瞬移区：太远直接瞬移回主人附近随机点，并重置为 idle
            if (distToOwner > GUARD_TELEPORT_RADIUS) {
                angle = GetRandomReal(0.0, 360.0);
                nx = ox + Cos(angle * bj_DEGTORAD) * GUARD_TELEPORT_OFFSET;
                ny = oy + Sin(angle * bj_DEGTORAD) * GUARD_TELEPORT_OFFSET;

                SetUnitX(petUnit, nx);
                SetUnitY(petUnit, ny);

                GuarderData.state[pid][idx] = GUARDER_STATE_IDLE_RING;
                GuarderData.target[pid][idx] = null;
                GuarderData.moveX[pid][idx] = 0.0;
                GuarderData.moveY[pid][idx] = 0.0;
                IssueImmediateOrder(petUnit, "stop");

                petUnit = null;
                ownerUnit = null;
                targetUnit = null;
                return;
            }

            // 2) 召回区：停止继续追远目标，跑回主人附近（用环绕点分散）
            if (distToOwner > GUARD_RETURN_RADIUS) {
                GuarderData.target[pid][idx] = null;
                angle = GuarderData.getRingAngle(pid, idx);
                nx = ox + Cos(angle * bj_DEGTORAD) * GUARD_RING_RADIUS;
                ny = oy + Sin(angle * bj_DEGTORAD) * GUARD_RING_RADIUS;
                GuarderData.orderMove(pid, idx, petUnit, nx, ny, GUARDER_STATE_MOVE, null);
                petUnit = null;
                ownerUnit = null;
                targetUnit = null;
                return;
            }

            if (enemyCount <= 0) {
                // 自由区：主人小范围移动时，不要重算环绕并下达新的 move
                if (distToOwner <= GUARD_FREE_RADIUS) {
                    // 如果之前在路上，打断一次避免“跟着跑”
                    if (state == GUARDER_STATE_MOVE) {
                        GuarderData.orderStop(pid, idx, petUnit, GUARDER_STATE_IDLE_RING);
                    }
                    petUnit = null;
                    ownerUnit = null;
                    targetUnit = null;
                    return;
                }

                // 可选加强：主人相对上次环绕中心移动不大，则不更新环绕
                ownerMoveDist = GetDistance(ox, oy, GuarderData.ringOwnerX[pid], GuarderData.ringOwnerY[pid]);
                if (state == GUARDER_STATE_IDLE_RING && ownerMoveDist <= GUARD_IDLE_OWNER_MOVE_EPS) {
                    petUnit = null;
                    ownerUnit = null;
                    targetUnit = null;
                    return;
                }

                angle = GuarderData.getRingAngle(pid, idx);
                nx = ox + Cos(angle * bj_DEGTORAD) * GUARD_RING_RADIUS;
                ny = oy + Sin(angle * bj_DEGTORAD) * GUARD_RING_RADIUS;
                GuarderData.orderMove(pid, idx, petUnit, nx, ny, GUARDER_STATE_IDLE_RING, null);
                GuarderData.ringOwnerX[pid] = ox;
                GuarderData.ringOwnerY[pid] = oy;
                petUnit = null;
                ownerUnit = null;
                return;
            }

            // 自由战斗区：优先延续当前目标（避免因主人微动频繁换目标）
            bestTarget = null;
            if (distToOwner <= GUARD_FREE_RADIUS && targetUnit != null) {
                ownerPlayer = GetOwningPlayer(ownerUnit);
                if (IsUnitAliveBJ(targetUnit) && IsUnitEnemy(targetUnit, ownerPlayer) && GetUnitAbilityLevel(targetUnit, 'Avul') == 0) {
                    bestTarget = targetUnit;
                }
                ownerPlayer = null;
            }
            bestDist = 0.0;
            if (bestTarget == null) {
                for (1 <= i <= enemyCount) {
                    enemyUnit = GuarderData.enemies[i];
                    if (enemyUnit != null && IsUnitAliveBJ(enemyUnit)) {
                        tx = GetUnitX(enemyUnit);
                        ty = GetUnitY(enemyUnit);
                        dx = tx - px;
                        dy = ty - py;
                        dist = dx * dx + dy * dy;
                        if (bestTarget == null || dist < bestDist) {
                            bestTarget = enemyUnit;
                            bestDist = dist;
                        }
                    }
                }
            }
            enemyUnit = null;

            if (bestTarget == null) {
                // 有敌人但没选到目标（极少）：自由区保持；否则回环绕
                if (distToOwner <= GUARD_FREE_RADIUS) {
                    petUnit = null;
                    ownerUnit = null;
                    targetUnit = null;
                    return;
                }
                angle = GuarderData.getRingAngle(pid, idx);
                nx = ox + Cos(angle * bj_DEGTORAD) * GUARD_RING_RADIUS;
                ny = oy + Sin(angle * bj_DEGTORAD) * GUARD_RING_RADIUS;
                GuarderData.orderMove(pid, idx, petUnit, nx, ny, GUARDER_STATE_IDLE_RING, null);
                GuarderData.ringOwnerX[pid] = ox;
                GuarderData.ringOwnerY[pid] = oy;
            } else {
                dist = GetDistance(px, py, GetUnitX(bestTarget), GetUnitY(bestTarget));
                if (dist <= GUARD_ATTACK_RANGE) {
                    if (state != GUARDER_STATE_ATTACK || targetUnit != bestTarget) {
                        GuarderData.state[pid][idx] = GUARDER_STATE_ATTACK;
                        GuarderData.target[pid][idx] = bestTarget;
                        GuarderData.moveX[pid][idx] = 0.0;
                        GuarderData.moveY[pid][idx] = 0.0;
                        IssueTargetOrder(petUnit, "attack", bestTarget);
                    }
                } else {
                    // D3 风格：不再用 activity 半径限制目标（只在超出 RETURN_RADIUS 时由召回区强制拉回）
                    nx = GetUnitX(bestTarget);
                    ny = GetUnitY(bestTarget);
                    GuarderData.orderMove(pid, idx, petUnit, nx, ny, GUARDER_STATE_MOVE, bestTarget);
                }
            }

            petUnit = null;
            ownerUnit = null;
            targetUnit = null;
            bestTarget = null;
        }

        // 枚举敌人列表并驱动该玩家所有守卫
        private static method updatePlayerAI(integer pid) {
            unit ownerUnit; player ownerPlayer; group enumGrp; unit enumUnit;
            integer enemyCount; integer idx;
            real ox; real oy;

            ownerUnit = GuarderData.owner[pid];
            if (ownerUnit == null || !IsUnitAliveBJ(ownerUnit)) { return; }

            ownerPlayer = GetOwningPlayer(ownerUnit);
            ox = GetUnitX(ownerUnit);
            oy = GetUnitY(ownerUnit);

            enemyCount = 0;
            enumGrp = CreateGroup();
            GroupEnumUnitsInRangeEx(enumGrp, ox, oy, GUARD_SEARCH_RADIUS, null);

            enumUnit = FirstOfGroup(enumGrp);
            while (enumUnit != null) {
                GroupRemoveUnit(enumGrp, enumUnit);
                if (enumUnit != ownerUnit && IsUnitAliveBJ(enumUnit) && IsUnitEnemy(enumUnit, ownerPlayer) && GetUnitAbilityLevel(enumUnit, 'Avul') == 0) {
                    enemyCount = enemyCount + 1;
                    GuarderData.enemies[enemyCount] = enumUnit;
                }
                enumUnit = FirstOfGroup(enumGrp);
            }

            DestroyGroup(enumGrp);
            enumGrp = null;
            ownerPlayer = null;

            GuarderData.enemyCount = enemyCount;
            for (1 <= idx <= GuarderData.size[pid]) {
                GuarderData.updatePetWithEnemies(pid, idx);
            }

            if (enemyCount > 0) {
                for (1 <= idx <= enemyCount) {
                    GuarderData.enemies[idx] = null;
                }
            }
            GuarderData.enemyCount = 0;

            ownerUnit = null;
            enumUnit = null;
        }

        // 周期 tick 主循环
        static method onInit() {
            GuarderData.tickTimer = CreateTimer();
            TimerStart(GuarderData.tickTimer, GUARD_TICK, true, function () {
                integer pid;

                for (1 <= pid <= MAX_PLAYER_COUNT) {
                    if (GuarderData.owner[pid] != null && (GetPlayerSlotState(ConvertedPlayer(pid)) == PLAYER_SLOT_STATE_PLAYING) && (GetPlayerController(ConvertedPlayer(pid)) == MAP_CONTROL_USER)) {
                        GuarderData.updatePlayerAI(pid);
                    }
                }
            });
        }
    }

    // 对外 API
    public function GuarderInitOwner(player p, unit ownerUnit) {
        GuarderData.initOwner(p, ownerUnit);
    }

    public function GuarderAddPet(player p, unit petUnit) -> boolean {
        return GuarderData.addPet(p, petUnit);
    }

    public function GuarderRemovePet(player p, unit petUnit) -> boolean {
        return GuarderData.removePet(p, petUnit);
    }

    public function GuarderClear(player p) {
        GuarderData.clear(p);
    }

    public function GuarderSetPaused(player p, boolean paused) {
        GuarderData.setPaused(p, paused);
    }
}


#undef GUARDER_STATE_NONE
#undef GUARDER_STATE_IDLE_RING
#undef GUARDER_STATE_MOVE
#undef GUARDER_STATE_ATTACK
#undef GUARDER_STATE_PAUSED

//! endzinc
#endif
