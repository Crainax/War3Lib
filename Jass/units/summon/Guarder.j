#ifndef GuarderIncluded
#define GuarderIncluded

//! zinc
/*
召唤物守护系统
按玩家管理，每个玩家一个主人单位，召唤物围绕主人进行智能AI
使用状态机驱动，移动/追击使用 Dashing 实现快速冲刺
*/

// 可调参数
#define GUARD_TICK                   0.20
#define GUARD_SEARCH_RADIUS          1200.0
#define GUARD_ACTIVITY_RADIUS        1000.0
#define GUARD_ATTACK_RANGE           200.0
#define GUARD_RETURN_RADIUS          800.0
#define GUARD_OUT_RADIUS             1500.0
#define GUARD_RING_RADIUS            400.0
#define GUARD_DASH_SPEED             30.0
#define GUARD_DASH_MAX               2000.0
#define GUARD_MAX_PETS_PER_PLAYER    1300

library Guarder requires Dashing, Geometry, GroupUtils, UnitFilter {

    // 状态枚举
    private integer STATE_NONE = 0;
    private integer STATE_IDLE_RING = 1;
    private integer STATE_CHASE_DASH = 2;
    private integer STATE_ATTACK = 3;
    private integer STATE_RETURN_DASH = 4;
    private integer STATE_PAUSED = 5;


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

        // 当前用于 Dashing 的 timer（用于"正在 dash 中"的判定与防重入）
        private static timer dashTimer[MAX_PLAYER_COUNT][GUARD_MAX_PETS_PER_PLAYER];

        // 外部暂停标志（用于特殊剧情/复活等）
        private static boolean paused[];

        // 周期 tick timer
        private static timer tickTimer;

        // 检查单位是否空闲
        private static method isUnitIdle(unit u) -> boolean {
            return OrderId2String(GetUnitCurrentOrder(u)) == null;
        }

        // 检查玩家ID有效性
        private static method isValidPid(integer pid) -> boolean {
            return pid >= 1 && pid <= MAX_PLAYER_COUNT;
        }

        // 检查索引有效性
        private static method isValidIdx(integer pid, integer idx) -> boolean {
            return GuarderData.isValidPid(pid) && idx >= 1 && idx <= GuarderData.size[pid];
        }

        // Dashing 回调：通过 Dashing 的 timer id 在 HASH_TIMER 里读取 pid/idx（Dashing 清理 hashtable 在回调之后执行）
        private static method onDashComplete() -> boolean {
            timer t;
            integer id;
            integer pid;
            integer idx;

            t = DashingGetTimer();
            if (t != null) {
                id = GetHandleId(t);
                pid = LoadInteger(HASH_TIMER, id, 90);
                idx = LoadInteger(HASH_TIMER, id, 91);

                if (GuarderData.isValidIdx(pid, idx)) {
                    GuarderData.dashTimer[pid][idx] = null;
                    GuarderData.state[pid][idx] = STATE_NONE;
                }
            }

            t = null;
            return true;
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
            GuarderData.state[pid][idx] = STATE_NONE;
            GuarderData.target[pid][idx] = null;
            GuarderData.dashTimer[pid][idx] = null;

            return true;
        }

        // 移除召唤物（线性查找并紧凑删除）
        public static method removePet(player p, unit petUnit) -> boolean {
            integer pid; integer idx; integer last; timer dashT;

            if (p == null || petUnit == null) { return false; }

            pid = GetConvertedPlayerId(p);
            if (!GuarderData.isValidPid(pid)) { return false; }

            // 线性查找
            for (1 <= idx <= GuarderData.size[pid]) {
                if (GuarderData.pet[pid][idx] == petUnit) {
                    // 找到，先清理 dashTimer（如果存在）
                    dashT = GuarderData.dashTimer[pid][idx];
                    if (dashT != null) {
                        PauseTimer(dashT);
                        DestroyTimer(dashT);
                        dashT = null;
                    }

                    // 紧凑删除
                    last = GuarderData.size[pid];
                    if (idx != last) {
                        // 将最后元素移到当前位置
                        GuarderData.pet[pid][idx] = GuarderData.pet[pid][last];
                        GuarderData.state[pid][idx] = GuarderData.state[pid][last];
                        GuarderData.target[pid][idx] = GuarderData.target[pid][last];
                        GuarderData.dashTimer[pid][idx] = GuarderData.dashTimer[pid][last];
                    }
                    // 清空最后位置
                    GuarderData.pet[pid][last] = null;
                    GuarderData.state[pid][last] = STATE_NONE;
                    GuarderData.target[pid][last] = null;
                    GuarderData.dashTimer[pid][last] = null;
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

            // 清理所有 dashTimer
            for (1 <= idx <= GuarderData.size[pid]) {
                if (GuarderData.dashTimer[pid][idx] != null) {
                    PauseTimer(GuarderData.dashTimer[pid][idx]);
                    DestroyTimer(GuarderData.dashTimer[pid][idx]);
                    GuarderData.dashTimer[pid][idx] = null;
                }
                GuarderData.pet[pid][idx] = null;
                GuarderData.state[pid][idx] = STATE_NONE;
                GuarderData.target[pid][idx] = null;
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

        // 清理死亡的 pet（紧凑删除）
        private static method cleanDeadPets(integer pid) {
            integer idx; integer last; unit u; timer dashT;

            if (!GuarderData.isValidPid(pid)) { return; }

            idx = 1;
            while (idx <= GuarderData.size[pid]) {
                u = GuarderData.pet[pid][idx];
                if (u == null || !IsUnitAliveBJ(u)) {
                    // 死亡，先清理 dashTimer（如果存在）
                    dashT = GuarderData.dashTimer[pid][idx];
                    if (dashT != null) {
                        PauseTimer(dashT);
                        DestroyTimer(dashT);
                        dashT = null;
                    }

                    // 紧凑删除
                    last = GuarderData.size[pid];
                    if (idx != last) {
                        GuarderData.pet[pid][idx] = GuarderData.pet[pid][last];
                        GuarderData.state[pid][idx] = GuarderData.state[pid][last];
                        GuarderData.target[pid][idx] = GuarderData.target[pid][last];
                        GuarderData.dashTimer[pid][idx] = GuarderData.dashTimer[pid][last];
                    }
                    GuarderData.pet[pid][last] = null;
                    GuarderData.state[pid][last] = STATE_NONE;
                    GuarderData.target[pid][last] = null;
                    GuarderData.dashTimer[pid][last] = null;
                    GuarderData.size[pid] = GuarderData.size[pid] - 1;
                    // 不增加 idx，继续检查当前位置
                } else {
                    idx = idx + 1;
                }
                u = null;
            }
        }

        // 寻敌并选择最近目标（以 owner 为中心）
        private static method findNearestEnemy(integer pid, unit petUnit) -> unit {
            unit ownerUnit; group enumGrp; unit result; unit u; real dist; real minDist; real px; real py; real ux; real uy; real dx; real dy;

            ownerUnit = GuarderData.owner[pid];
            if (ownerUnit == null || !IsUnitAliveBJ(ownerUnit)) {
                return null;
            }

            px = GetUnitX(petUnit);
            py = GetUnitY(petUnit);
            result = null;
            minDist = 0.0;

            enumGrp = CreateGroup();
            GroupEnumUnitsInRangeEx(enumGrp, GetUnitX(ownerUnit), GetUnitY(ownerUnit), GUARD_SEARCH_RADIUS, null);

            u = FirstOfGroup(enumGrp);
            while (u != null) {
                GroupRemoveUnit(enumGrp, u);

                if (u != ownerUnit && IsUnitAliveBJ(u) && IsEnemy(u, GetOwningPlayer(ownerUnit)) && GetUnitAbilityLevel(u, 'Avul') == 0) {
                    ux = GetUnitX(u);
                    uy = GetUnitY(u);
                    dx = ux - px;
                    dy = uy - py;
                    dist = dx * dx + dy * dy; // 距离平方

                    if (result == null || dist < minDist) {
                        result = u;
                        minDist = dist;
                    }
                }

                u = FirstOfGroup(enumGrp);
            }

            DestroyGroup(enumGrp);
            enumGrp = null;
            u = null;
            ownerUnit = null;
            return result;
        }

        // 处理单个 pet 的 AI
        private static method updatePetAI(integer pid, integer idx) {
            unit petUnit; unit ownerUnit; unit targetUnit; integer state; timer dashT; boolean isIdle; real px; real py; real ox; real oy; real tx; real ty; real dist; real distToOwner; real angle; real nx; real ny; real vx; real vy; real vr;
            integer tid;

            if (!GuarderData.isValidIdx(pid, idx)) { return; }

            petUnit = GuarderData.pet[pid][idx];
            if (petUnit == null || !IsUnitAliveBJ(petUnit)) { return; }

            ownerUnit = GuarderData.owner[pid];
            if (ownerUnit == null || !IsUnitAliveBJ(ownerUnit)) {
                // owner 无效，清理该 pet
                GuarderData.removePet(ConvertedPlayer(pid), petUnit);
                return;
            }

            state = GuarderData.state[pid][idx];
            targetUnit = GuarderData.target[pid][idx];
            dashT = GuarderData.dashTimer[pid][idx];
            isIdle = GuarderData.isUnitIdle(petUnit);

            px = GetUnitX(petUnit);
            py = GetUnitY(petUnit);
            ox = GetUnitX(ownerUnit);
            oy = GetUnitY(ownerUnit);
            distToOwner = GetDistance(px, py, ox, oy);

            // 检查是否需要暂停
            if (GuarderData.paused[pid] || IsUnitPaused(ownerUnit)) {
                if (state != STATE_PAUSED) {
                    PauseUnit(petUnit, true);
                    GuarderData.state[pid][idx] = STATE_PAUSED;
                    // 清理 dashTimer
                    if (dashT != null) {
                        PauseTimer(dashT);
                        DestroyTimer(dashT);
                        GuarderData.dashTimer[pid][idx] = null;
                    }
                }
                petUnit = null;
                ownerUnit = null;
                targetUnit = null;
                dashT = null;
                return;
            } else {
                // 解除暂停
                if (IsUnitPaused(petUnit)) {
                    PauseUnit(petUnit, false);
                }
            }

            // 检查是否离主人过远（需要回归）
            if (distToOwner > GUARD_OUT_RADIUS) {
                // 强制回归
                if (state != STATE_RETURN_DASH && isIdle && dashT == null) {
                    GuarderData.state[pid][idx] = STATE_RETURN_DASH;
                    GuarderData.target[pid][idx] = null;
                    // 使用 Dashing 冲回主人附近
                    dashT = StartDashing(petUnit, ox, oy, GUARD_DASH_SPEED, GUARD_DASH_MAX, function GuarderData.onDashComplete, null, 0.0, 0.0);
                    GuarderData.dashTimer[pid][idx] = dashT;
                    if (dashT != null) {
                        tid = GetHandleId(dashT);
                        SaveInteger(HASH_TIMER, tid, 90, pid);
                        SaveInteger(HASH_TIMER, tid, 91, idx);
                    }
                }
                petUnit = null;
                ownerUnit = null;
                targetUnit = null;
                dashT = null;
                return;
            }

            // 如果正在 dash 中，跳过本次更新
            if (dashT != null) {
                petUnit = null;
                ownerUnit = null;
                targetUnit = null;
                dashT = null;
                return;
            }

            // 寻敌
            targetUnit = GuarderData.findNearestEnemy(pid, petUnit);

            // 验证旧目标是否仍然有效
            if (targetUnit != null && (targetUnit == GuarderData.target[pid][idx])) {
                if (!IsUnitAliveBJ(targetUnit) || GetUnitAbilityLevel(targetUnit, 'Avul') > 0) {
                    targetUnit = null;
                    GuarderData.target[pid][idx] = null;
                } else {
                    // 检查目标是否还在活动范围内
                    tx = GetUnitX(targetUnit);
                    ty = GetUnitY(targetUnit);
                    dist = GetDistance(tx, ty, ox, oy);
                    if (dist > GUARD_ACTIVITY_RADIUS) {
                        targetUnit = null;
                        GuarderData.target[pid][idx] = null;
                    }
                }
            }

            // 更新目标缓存
            GuarderData.target[pid][idx] = targetUnit;

            if (targetUnit == null) {
                // 无目标：进入 IDLE_RING
                if (state != STATE_IDLE_RING && isIdle) {
                    GuarderData.state[pid][idx] = STATE_IDLE_RING;
                    // 计算环形站位点
                    angle = 45.0 * idx; // 每个 pet 按索引分配角度
                    nx = ox + Cos(angle * bj_DEGTORAD) * GUARD_RING_RADIUS;
                    ny = oy + Sin(angle * bj_DEGTORAD) * GUARD_RING_RADIUS;
                    IssuePointOrder(petUnit, "move", nx, ny);
                }
            } else {
                // 有目标：检查距离决定是攻击还是追击
                tx = GetUnitX(targetUnit);
                ty = GetUnitY(targetUnit);
                dist = GetDistance(px, py, tx, ty);

                if (dist <= GUARD_ATTACK_RANGE) {
                    // 在攻击范围内：进入 ATTACK
                    if (state != STATE_ATTACK && isIdle) {
                        GuarderData.state[pid][idx] = STATE_ATTACK;
                        IssueTargetOrder(petUnit, "attack", targetUnit);
                    }
                } else {
                    // 不在攻击范围内：使用 Dashing 追击
                    if (state != STATE_CHASE_DASH && isIdle) {
                        GuarderData.state[pid][idx] = STATE_CHASE_DASH;

                        // 计算追击点（限制在活动半径内）
                        vx = tx - ox;
                        vy = ty - oy;
                        vr = SquareRoot(vx * vx + vy * vy);
                        if (vr > GUARD_ACTIVITY_RADIUS) {
                            vx = vx / vr * GUARD_ACTIVITY_RADIUS;
                            vy = vy / vr * GUARD_ACTIVITY_RADIUS;
                            nx = ox + vx;
                            ny = oy + vy;
                        } else {
                            nx = tx;
                            ny = ty;
                        }

                        // 使用 Dashing 冲向目标附近
                        dashT = StartDashing(petUnit, nx, ny, GUARD_DASH_SPEED, GUARD_DASH_MAX, function GuarderData.onDashComplete, null, 0.0, 0.0);

                        GuarderData.dashTimer[pid][idx] = dashT;
                        if (dashT != null) {
                            tid = GetHandleId(dashT);
                            SaveInteger(HASH_TIMER, tid, 90, pid);
                            SaveInteger(HASH_TIMER, tid, 91, idx);
                        }
                    }
                }
            }

            petUnit = null;
            ownerUnit = null;
            targetUnit = null;
            dashT = null;
        }

        // 周期 tick 主循环
        static method onInit() {
            GuarderData.tickTimer = CreateTimer();
            TimerStart(GuarderData.tickTimer, GUARD_TICK, true, function () {
                integer pid; integer idx;

                for (1 <= pid <= MAX_PLAYER_COUNT) {
                    if (GuarderData.owner[pid] != null && (GetPlayerSlotState(ConvertedPlayer(pid)) == PLAYER_SLOT_STATE_PLAYING) && (GetPlayerController(ConvertedPlayer(pid)) == MAP_CONTROL_USER)) {
                        // 清理死亡的 pet
                        GuarderData.cleanDeadPets(pid);

                        // 遍历该玩家的所有 pet
                        for (1 <= idx <= GuarderData.size[pid]) {
                            GuarderData.updatePetAI(pid, idx);
                        }
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

//! endzinc
#endif
