#ifndef GuarderIncluded
#define GuarderIncluded

// Guarder 需要使用 HASH_UNIT 存储单位属性（独立攻击范围）
#include "Crainax/core/table/Hash_UnitDefine.j"

//! zinc
/*
召唤物守护系统
按玩家管理，每个玩家一个主人单位，召唤物围绕主人进行智能AI
使用 BeyondSpeed 的超级移速配合状态机实现移动/追击
*/

// 可调参数
#define GUARD_TICK                      0.20   // AI 更新周期（秒）：每 0.20 秒执行一次守卫 AI 逻辑
#define GUARD_SEARCH_RADIUS             1200.0 // 敌人搜索半径（码）：以主人为中心，在此范围内搜索敌人
#define GUARD_ATTACK_RANGE              500.0  // 攻击判定范围（码）：守卫与敌人距离 ≤ 此值时，下达 attack 命令
#define GUARD_RING_RADIUS               400.0  // 环形站位半径（码）：无敌人时，守卫围绕主人形成环形阵型的半径
#define GUARD_SUPER_SPEED_BONUS         800    // 超级移速加成（整数）：守卫加入时获得的额外移速（突破 522 上限）
#define GUARD_MOVE_POINT_EPS            100.0  // 移动指令更新阈值（码）：move 目标点变化超过此值才重新下达 move 命令（避免频繁刷屏）
#define GUARD_MAX_PETS_PER_PLAYER       1300   // 每玩家最大守卫数量：单个玩家最多可拥有的守卫数量上限
#define GUARD_FREE_RADIUS               600.0  // 主人附近自由活动半径：主人在这个距离内小范围移动时，pet 不需要重新排队跟着转
#define GUARD_TELEPORT_RADIUS           1000.0 // 额外瞬移阈值（码）：瞬移触发距离 = 搜索半径 + 本值
#define GUARD_TELEPORT_OFFSET           150.0  // 瞬移回主人附近的随机偏移半径，避免所有宠物叠在一个点
#define GUARD_IDLE_OWNER_MOVE_EPS       400.0  // 主人小幅移动时，idle 环绕不更新的阈值
#define GUARD_ATTACK_TELEPORT_DISTANCE  1800.0 // 攻击瞬移距离（码）：守卫与目标距离超过此值时，瞬移到目标附近

//复用工具类函数
#define GUARDER_ISVALID_IDX(pid, idx) (ISVALID_PLAYER_ID(pid) && idx >= 1 && idx <= guarder.size[pid])   //检查索引有效性

// 状态枚举
#define GUARDER_STATE_NONE  0
#define GUARDER_STATE_IDLE_RING  1
#define GUARDER_STATE_MOVE  2
#define GUARDER_STATE_ATTACK  3
#define GUARDER_STATE_PAUSED  4

/*
 * ========================================
 * Guarder 系统公共 API 方法说明
 * ========================================
 */

// guarder.initOwner(player p, unit ownerUnit)
// 功能：初始化指定玩家的主人单位
// 参数：
//   - p: 玩家句柄，不能为 null
//   - ownerUnit: 主人单位句柄，不能为 null
// 说明：
//   - 每个玩家只能有一个主人单位，后续添加的守卫会围绕此单位行动
//   - 如果该玩家的搜索半径未初始化（<=0），会自动设置为默认值 GUARD_SEARCH_RADIUS
//   - 使用示例：guarder.initOwner(p0, testHero);

// guarder.addPet(player p, unit petUnit) -> boolean
// 功能：将单位添加为指定玩家的守卫
// 参数：
//   - p: 玩家句柄，不能为 null
//   - petUnit: 要添加的守卫单位句柄，不能为 null
// 返回值：
//   - true: 添加成功
//   - false: 添加失败（单位已存在、容量已满、参数无效等）
// 说明：
//   - 添加成功后会为守卫单位添加超级移速加成（突破 522 上限）
//   - 会为守卫设置默认攻击范围（可通过 HASH_UNIT 系统修改）
//   - 守卫会自动围绕主人形成环形阵型，并在搜索范围内自动攻击敌人
//   - 使用示例：guarder.addPet(p, u);

// guarder.removePet(player p, unit petUnit) -> boolean
// 功能：从指定玩家的守卫系统中移除单个守卫单位
// 参数：
//   - p: 玩家句柄，不能为 null
//   - petUnit: 要移除的守卫单位句柄，不能为 null
// 返回值：
//   - true: 移除成功
//   - false: 移除失败（单位不存在、参数无效等）
// 说明：
//   - 移除时会恢复守卫的移速（减去超级移速加成）
//   - 会清理守卫的独立攻击范围数据
//   - 使用紧凑数组删除，保证 O(1) 时间复杂度

// guarder.clear(player p)
// 功能：清空指定玩家的所有守卫（不删除单位，仅解绑系统）
// 参数：
//   - p: 玩家句柄，不能为 null
// 说明：
//   - 会恢复所有守卫的移速（减去超级移速加成）
//   - 会清理所有守卫的独立攻击范围数据
//   - 清空后该玩家的守卫数量为 0，但主人单位仍然保留
//   - 使用示例：guarder.clear(p); // 清空所有召唤物

// guarder.setPaused(player p, boolean paused)
// 功能：外部控制暂停/恢复指定玩家的所有守卫 AI
// 参数：
//   - p: 玩家句柄，不能为 null
//   - paused: true=暂停，false=恢复
// 说明：
//   - 暂停时守卫会被暂停（PauseUnit），停止所有 AI 行为
//   - 恢复时守卫会解除暂停，继续执行 AI 逻辑
//   - 适用于特殊剧情、复活等场景需要临时停止守卫行为
//   - 使用示例：guarder.setPaused(p, true); // 暂停所有守卫

// guarder.addPlayerSearchRadius(player p, real delta)
// 功能：动态增加/减少指定玩家的守卫搜索半径（召回半径同样复用此值）
// 参数：
//   - p: 玩家句柄，不能为 null
//   - delta: 半径变化量（可为正数或负数）
// 说明：
//   - 搜索半径影响：敌人搜索范围、召回触发距离
//   - 瞬移触发距离 = 搜索半径 + GUARD_TELEPORT_RADIUS
//   - 最终半径不会小于 0（会自动限制）
//   - 如果当前半径未初始化（<=0），会先设置为默认值 GUARD_SEARCH_RADIUS 再加 delta
//   - 使用示例：guarder.addPlayerSearchRadius(p, 200.0); // 增加 200 码搜索半径

// guarder.getSize(player p) -> integer
// 功能：获取指定玩家的守卫数量
// 参数：
//   - p: 玩家句柄，不能为 null
// 返回值：
//   - 该玩家的守卫数量（0 表示没有守卫）
// 说明：
//   - 返回值为紧凑数组的有效元素数量
//   - 使用示例：integer count = guarder.getSize(p);

// guarder.getPetByIndex(player p, integer index) -> unit
// 功能：获取指定玩家第 index 个位置的守卫单位（用于遍历）
// 参数：
//   - p: 玩家句柄，不能为 null
//   - index: 索引位置（从 1 开始，1-based）
// 返回值：
//   - unit: 守卫单位句柄，如果索引无效或位置为空则返回 null
// 说明：
//   - 索引范围：1 到 getSize(p)
//   - 使用紧凑数组，所有有效守卫都在 1..size 范围内
//   - 使用示例：见下方遍历示例

/*
 * ========================================
 * 遍历守卫示例
 * ========================================
 *
 * // 遍历指定玩家的所有守卫
 * integer i; integer count; unit pet;
 * count = guarder.getSize(p);
 * for (1 <= i <= count) {
 *     pet = guarder.getPetByIndex(p, i);
 *     if (pet != null && GetUnitTypeId(pet) != 0) {
 *         // 处理守卫逻辑
 *         BJDebugMsg("守卫 " + I2S(i) + ": " + GetUnitName(pet));
 *     }
 *     pet = null;
 * }
 */

library Guarder requires BeyondSpeed, Geometry, GroupUtils, UnitFilter {

    // 数据结构：按玩家紧凑数组
    public struct guarder []{
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
        // 每玩家可动态调整的搜索半径（召回半径复用此值）
        private static real searchRadius[];
        // idle 环绕时记录“上一次环绕中心的主人坐标”（按玩家）
        private static real ringOwnerX[];
        private static real ringOwnerY[];
        // 外部暂停标志（用于特殊剧情/复活等）
        private static boolean paused[];
        // 周期 tick timer
        private static timer tickTimer = null;

        // 初始化主人单位
        public static method initOwner(player p, unit ownerUnit) {
            integer pid;

            if (p == null || ownerUnit == null) { return; }

            pid = GetConvertedPlayerId(p);
            if (!ISVALID_PLAYER_ID(pid)) { return; }

            guarder.owner[pid] = ownerUnit;
            if (guarder.searchRadius[pid] <= 0.0) {
                guarder.searchRadius[pid] = GUARD_SEARCH_RADIUS;
            }
        }

        // 添加召唤物
        public static method addPet(player p, unit petUnit) -> boolean {
            integer pid; integer idx; integer hid;

            if (p == null || petUnit == null) { return false; }

            pid = GetConvertedPlayerId(p);
            if (!ISVALID_PLAYER_ID(pid)) { return false; }

            // 检查是否已存在
            for (1 <= idx <= guarder.size[pid]) {
                if (guarder.pet[pid][idx] == petUnit) {
                    return false; // 已存在
                }
            }

            // 检查容量
            if (guarder.size[pid] >= GUARD_MAX_PETS_PER_PLAYER) {
                return false; // 容量已满
            }

            // 紧凑追加
            guarder.size[pid] = guarder.size[pid] + 1;
            idx = guarder.size[pid];
            guarder.pet[pid][idx] = petUnit;
            guarder.state[pid][idx] = GUARDER_STATE_NONE;
            guarder.target[pid][idx] = null;
            guarder.moveX[pid][idx] = 0.0;
            guarder.moveY[pid][idx] = 0.0;

            AddUnitSuperSpeed(petUnit, GUARD_SUPER_SPEED_BONUS);
            // 默认给每个守卫写入独立攻击范围（可被外部系统修改为其他值）
            hid = GetHandleId(petUnit);
            if (!HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_GUARD_ATTACK_RANGE)) {
                SaveReal(HASH_UNIT, hid, KEY_UNIT_GUARD_ATTACK_RANGE, GUARD_ATTACK_RANGE);
            }

            return true;
        }

        // 移除召唤物（线性查找并紧凑删除）
        public static method removePet(player p, unit petUnit) -> boolean {
            integer pid; integer idx; integer last;
            integer hid;

            if (p == null || petUnit == null) { return false; }

            pid = GetConvertedPlayerId(p);
            if (!ISVALID_PLAYER_ID(pid)) { return false; }

            // 线性查找
            for (1 <= idx <= guarder.size[pid]) {
                if (guarder.pet[pid][idx] == petUnit) {
                    AddUnitSuperSpeed(petUnit, -GUARD_SUPER_SPEED_BONUS);
                    hid = GetHandleId(petUnit);
                    RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_GUARD_ATTACK_RANGE);

                    // 紧凑删除
                    last = guarder.size[pid];
                    if (idx != last) {
                        // 将最后元素移到当前位置
                        guarder.pet[pid][idx] = guarder.pet[pid][last];
                        guarder.state[pid][idx] = guarder.state[pid][last];
                        guarder.target[pid][idx] = guarder.target[pid][last];
                        guarder.moveX[pid][idx] = guarder.moveX[pid][last];
                        guarder.moveY[pid][idx] = guarder.moveY[pid][last];
                    }
                    // 清空最后位置
                    guarder.pet[pid][last] = null;
                    guarder.state[pid][last] = GUARDER_STATE_NONE;
                    guarder.target[pid][last] = null;
                    guarder.moveX[pid][last] = 0.0;
                    guarder.moveY[pid][last] = 0.0;
                    guarder.size[pid] = guarder.size[pid] - 1;
                    return true;
                }
            }

            return false; // 未找到
        }

        // 清空该玩家全部 pet（不负责删除单位，仅解绑/清空引用）
        public static method clear(player p) {
            integer pid; integer idx;
            integer hid;

            if (p == null) { return; }

            pid = GetConvertedPlayerId(p);
            if (!ISVALID_PLAYER_ID(pid)) { return; }

            for (1 <= idx <= guarder.size[pid]) {
                if (guarder.pet[pid][idx] != null) {
                    hid = GetHandleId(guarder.pet[pid][idx]);
                    RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_GUARD_ATTACK_RANGE);
                    AddUnitSuperSpeed(guarder.pet[pid][idx], -GUARD_SUPER_SPEED_BONUS);
                    guarder.pet[pid][idx] = null;
                }
                guarder.state[pid][idx] = GUARDER_STATE_NONE;
                guarder.target[pid][idx] = null;
                guarder.moveX[pid][idx] = 0.0;
                guarder.moveY[pid][idx] = 0.0;
            }

            guarder.size[pid] = 0;
        }

        // 外部强制暂停/恢复
        public static method setPaused(player p, boolean paused) {
            integer pid; integer idx; unit u; integer hid;

            if (p == null) { return; }

            pid = GetConvertedPlayerId(p);
            if (!ISVALID_PLAYER_ID(pid)) { return; }

            guarder.paused[pid] = paused;

            // 立即对现有守卫同步 Pause + Avul（只移除由本系统添加的 Avul）
            for (1 <= idx <= guarder.size[pid]) {
                u = guarder.pet[pid][idx];
                if (u != null && GetUnitTypeId(u) != 0) {
                    hid = GetHandleId(u);
                    if (paused) {
                        if (GetUnitAbilityLevel(u, 'Avul') == 0) {
                            UnitAddAbility(u, 'Avul');
                            SaveInteger(HASH_UNIT, hid, KEY_UNIT_GUARD_PAUSE_AVUL_ADDED, 1);
                        }
                        PauseUnit(u, true);
                        guarder.state[pid][idx] = GUARDER_STATE_PAUSED;
                        guarder.target[pid][idx] = null;
                    } else {
                        if (HaveSavedInteger(HASH_UNIT, hid, KEY_UNIT_GUARD_PAUSE_AVUL_ADDED) && LoadInteger(HASH_UNIT, hid, KEY_UNIT_GUARD_PAUSE_AVUL_ADDED) == 1) {
                            UnitRemoveAbility(u, 'Avul');
                            RemoveSavedInteger(HASH_UNIT, hid, KEY_UNIT_GUARD_PAUSE_AVUL_ADDED);
                        }
                        PauseUnit(u, false);
                    }
                }
                u = null;
            }
        }

        // 记录 move 指令，避免重复下达
        private static method orderMove(integer pid, integer idx, unit petUnit, real x, real y, integer newState, unit newTarget) {
            real lastX; real lastY; boolean needOrder; real diff;

            lastX = guarder.moveX[pid][idx];
            lastY = guarder.moveY[pid][idx];
            diff = GetDistance(lastX, lastY, x, y);
            needOrder = (guarder.state[pid][idx] != newState) || (guarder.target[pid][idx] != newTarget) || (diff > GUARD_MOVE_POINT_EPS);

            if (needOrder) {
                IssuePointOrder(petUnit, "move", x, y);
                guarder.moveX[pid][idx] = x;
                guarder.moveY[pid][idx] = y;
                guarder.state[pid][idx] = newState;
                guarder.target[pid][idx] = newTarget;
            }
        }

        // 下达 stop，避免重复打断
        private static method orderStop(integer pid, integer idx, unit petUnit, integer newState) {
            boolean needOrder;
            needOrder = (guarder.state[pid][idx] != newState) || (guarder.target[pid][idx] != null) || (guarder.moveX[pid][idx] != 0.0) || (guarder.moveY[pid][idx] != 0.0);
            if (needOrder) {
                IssueImmediateOrder(petUnit, "stop");
                guarder.state[pid][idx] = newState;
                guarder.target[pid][idx] = null;
                guarder.moveX[pid][idx] = 0.0;
                guarder.moveY[pid][idx] = 0.0;
            }
        }

        // 计算环绕角度（角度随当前玩家 pet 数量自适应：2=>180°,3=>120°,8=>45°）
        private static method getRingAngle(integer pid, integer idx) -> real {
            integer count;
            count = guarder.size[pid];
            if (count <= 0) { count = 1; }
            return (360.0 / I2R(count)) * I2R(idx - 1);
        }

        private static method getAttackRange(unit u) -> real {
            integer hid;
            if (u == null) { return GUARD_ATTACK_RANGE; }
            hid = GetHandleId(u);
            if (HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_GUARD_ATTACK_RANGE)) {
                return LoadReal(HASH_UNIT, hid, KEY_UNIT_GUARD_ATTACK_RANGE);
            }
            return GUARD_ATTACK_RANGE;
        }

        // 处理单个 pet 的 AI
        private static method updatePetWithEnemies(integer pid, integer idx) {
            unit petUnit; unit ownerUnit; unit targetUnit; unit bestTarget; unit enemyUnit; player ownerPlayer;
            integer state; integer i; integer enemyCount;
            real px; real py; real ox; real oy; real distToOwner;
            real nx; real ny; real angle; real tx; real ty;
            real bestDist; real dist; real dx; real dy; boolean ownerPaused;
            real ownerMoveDist;
            real searchRadius; real teleportDist; real attackRange;
            real vx; real vy; real vr; real targetX; real targetY;
            integer hid,hid2;


            if (!GUARDER_ISVALID_IDX(pid, idx)) { return; }

            petUnit = guarder.pet[pid][idx];
            if (petUnit == null || GetUnitTypeId(petUnit) == 0) { return; }

            ownerUnit = guarder.owner[pid];
            // 主人死亡不影响守卫 AI：只在句柄失效时才退出/解绑
            if (ownerUnit == null || GetUnitTypeId(ownerUnit) == 0) {
                guarder.removePet(ConvertedPlayer(pid), petUnit);
                petUnit = null;
                ownerUnit = null;
                return;
            }

            state = guarder.state[pid][idx];
            targetUnit = guarder.target[pid][idx];

            px = GetUnitX(petUnit);
            py = GetUnitY(petUnit);
            ox = GetUnitX(ownerUnit);
            oy = GetUnitY(ownerUnit);
            distToOwner = GetDistance(px, py, ox, oy);

            ownerPaused = guarder.paused[pid] || IsUnitPaused(ownerUnit);
            if (ownerPaused) {
                if (state != GUARDER_STATE_PAUSED) {
                    PauseUnit(petUnit, true);
                    guarder.state[pid][idx] = GUARDER_STATE_PAUSED;
                    guarder.target[pid][idx] = null;
                    // 外部 pause 时给守卫 Avul（只在 guarder.paused=true 时处理，避免影响其他系统的 PauseUnit）
                    if (guarder.paused[pid]) {
                        hid = GetHandleId(petUnit);
                        if (GetUnitAbilityLevel(petUnit, 'Avul') == 0) {
                            UnitAddAbility(petUnit, 'Avul');
                            SaveInteger(HASH_UNIT, hid, KEY_UNIT_GUARD_PAUSE_AVUL_ADDED, 1);
                        }
                    }
                }
                petUnit = null;
                ownerUnit = null;
                targetUnit = null;
                return;
            } else if (IsUnitPaused(petUnit)) {
                PauseUnit(petUnit, false);
                // 从外部 pause 恢复时，如果 Avul 是 Guarder 添加的，则移除
                hid2 = GetHandleId(petUnit);
                if (HaveSavedInteger(HASH_UNIT, hid2, KEY_UNIT_GUARD_PAUSE_AVUL_ADDED) && LoadInteger(HASH_UNIT, hid2, KEY_UNIT_GUARD_PAUSE_AVUL_ADDED) == 1) {
                    UnitRemoveAbility(petUnit, 'Avul');
                    RemoveSavedInteger(HASH_UNIT, hid2, KEY_UNIT_GUARD_PAUSE_AVUL_ADDED);
                }
            }

            enemyCount = guarder.enemyCount;
            searchRadius = guarder.searchRadius[pid];
            if (searchRadius <= 0.0) { searchRadius = GUARD_SEARCH_RADIUS; }
            teleportDist = searchRadius + GUARD_TELEPORT_RADIUS;
            attackRange = guarder.getAttackRange(petUnit);

            // 1) 瞬移区：太远直接瞬移回主人附近随机点，并重置为 idle
            if (distToOwner > teleportDist) {
                angle = GetRandomReal(0.0, 360.0);
                nx = ox + Cos(angle * bj_DEGTORAD) * GUARD_TELEPORT_OFFSET;
                ny = oy + Sin(angle * bj_DEGTORAD) * GUARD_TELEPORT_OFFSET;

                SetUnitX(petUnit, nx);
                SetUnitY(petUnit, ny);

                guarder.state[pid][idx] = GUARDER_STATE_IDLE_RING;
                guarder.target[pid][idx] = null;
                guarder.moveX[pid][idx] = 0.0;
                guarder.moveY[pid][idx] = 0.0;
                IssueImmediateOrder(petUnit, "stop");

                petUnit = null;
                ownerUnit = null;
                targetUnit = null;
                return;
            }

            // 2) 召回区：停止继续追远目标，跑回主人附近（用环绕点分散）
            if (distToOwner > searchRadius) {
                guarder.target[pid][idx] = null;
                angle = guarder.getRingAngle(pid, idx);
                nx = ox + Cos(angle * bj_DEGTORAD) * GUARD_RING_RADIUS;
                ny = oy + Sin(angle * bj_DEGTORAD) * GUARD_RING_RADIUS;
                guarder.orderMove(pid, idx, petUnit, nx, ny, GUARDER_STATE_MOVE, null);
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
                        guarder.orderStop(pid, idx, petUnit, GUARDER_STATE_IDLE_RING);
                    }
                    petUnit = null;
                    ownerUnit = null;
                    targetUnit = null;
                    return;
                }

                // 可选加强：主人相对上次环绕中心移动不大，则不更新环绕
                ownerMoveDist = GetDistance(ox, oy, guarder.ringOwnerX[pid], guarder.ringOwnerY[pid]);
                if (state == GUARDER_STATE_IDLE_RING && ownerMoveDist <= GUARD_IDLE_OWNER_MOVE_EPS) {
                    petUnit = null;
                    ownerUnit = null;
                    targetUnit = null;
                    return;
                }

                angle = guarder.getRingAngle(pid, idx);
                nx = ox + Cos(angle * bj_DEGTORAD) * GUARD_RING_RADIUS;
                ny = oy + Sin(angle * bj_DEGTORAD) * GUARD_RING_RADIUS;
                guarder.orderMove(pid, idx, petUnit, nx, ny, GUARDER_STATE_IDLE_RING, null);
                guarder.ringOwnerX[pid] = ox;
                guarder.ringOwnerY[pid] = oy;
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
                    enemyUnit = guarder.enemies[i];
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
                angle = guarder.getRingAngle(pid, idx);
                nx = ox + Cos(angle * bj_DEGTORAD) * GUARD_RING_RADIUS;
                ny = oy + Sin(angle * bj_DEGTORAD) * GUARD_RING_RADIUS;
                guarder.orderMove(pid, idx, petUnit, nx, ny, GUARDER_STATE_IDLE_RING, null);
                guarder.ringOwnerX[pid] = ox;
                guarder.ringOwnerY[pid] = oy;
            } else {
                targetX = GetUnitX(bestTarget);
                targetY = GetUnitY(bestTarget);
                dist = GetDistance(px, py, targetX, targetY);
                if (dist <= attackRange) {
                    if (state != GUARDER_STATE_ATTACK || targetUnit != bestTarget) {
                        guarder.state[pid][idx] = GUARDER_STATE_ATTACK;
                        guarder.target[pid][idx] = bestTarget;
                        guarder.moveX[pid][idx] = 0.0;
                        guarder.moveY[pid][idx] = 0.0;
                        IssueTargetOrder(petUnit, "attack", bestTarget);
                    }
                } else if (dist > GUARD_ATTACK_TELEPORT_DISTANCE) {
                    // 过远：瞬移到目标附近，同时保证仍在搜索半径内
                    angle = GetRandomReal(0.0, 360.0);
                    dx = Cos(angle * bj_DEGTORAD) * 200.0;
                    dy = Sin(angle * bj_DEGTORAD) * 200.0;
                    nx = targetX + dx;
                    ny = targetY + dy;

                    // 将瞬移落点限制在搜索半径内（以主人为中心）
                    vx = nx - ox;
                    vy = ny - oy;
                    vr = SquareRoot(vx * vx + vy * vy);
                    if (vr > searchRadius) {
                        vx = vx / vr * searchRadius;
                        vy = vy / vr * searchRadius;
                        nx = ox + vx;
                        ny = oy + vy;
                    }


                    DestroyEffect(AddSpecialEffect("Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", GetUnitX(petUnit),GetUnitY(petUnit) ));
                    SetUnitX(petUnit, nx);
                    SetUnitY(petUnit, ny);
                    DestroyEffect(AddSpecialEffect("Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl", nx,ny ));

                    // 瞬移后直接攻击
                    guarder.state[pid][idx] = GUARDER_STATE_ATTACK;
                    guarder.target[pid][idx] = bestTarget;
                    guarder.moveX[pid][idx] = 0.0;
                    guarder.moveY[pid][idx] = 0.0;
                    IssueTargetOrder(petUnit, "attack", bestTarget);
                } else {
                    // D3 风格：不再用活动半径限制目标（只在超出"搜索半径"时由召回区强制拉回）
                    nx = targetX;
                    ny = targetY;
                    guarder.orderMove(pid, idx, petUnit, nx, ny, GUARDER_STATE_MOVE, bestTarget);
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
            real radius;

            ownerUnit = guarder.owner[pid];
            // 主人死亡不影响守卫 AI：只在句柄失效时才退出
            if (ownerUnit == null || GetUnitTypeId(ownerUnit) == 0) { return; }

            ownerPlayer = GetOwningPlayer(ownerUnit);
            ox = GetUnitX(ownerUnit);
            oy = GetUnitY(ownerUnit);
            radius = guarder.searchRadius[pid];
            if (radius <= 0.0) { radius = GUARD_SEARCH_RADIUS; }

            enemyCount = 0;
            enumGrp = CreateGroup();
            GroupEnumUnitsInRangeEx(enumGrp, ox, oy, radius, null);

            enumUnit = FirstOfGroup(enumGrp);
            while (enumUnit != null) {
                GroupRemoveUnit(enumGrp, enumUnit);
                if (enumUnit != ownerUnit && IsUnitAliveBJ(enumUnit) && IsUnitEnemy(enumUnit, ownerPlayer) && GetUnitAbilityLevel(enumUnit, 'Avul') == 0) {
                    enemyCount = enemyCount + 1;
                    guarder.enemies[enemyCount] = enumUnit;
                }
                enumUnit = FirstOfGroup(enumGrp);
            }

            DestroyGroup(enumGrp);
            enumGrp = null;
            ownerPlayer = null;

            guarder.enemyCount = enemyCount;
            for (1 <= idx <= guarder.size[pid]) {
                guarder.updatePetWithEnemies(pid, idx);
            }

            if (enemyCount > 0) {
                for (1 <= idx <= enemyCount) {
                    guarder.enemies[idx] = null;
                }
            }
            guarder.enemyCount = 0;

            ownerUnit = null;
            enumUnit = null;
        }


        // 增加/减少某玩家的守卫搜索半径（召回半径同样复用此值）
        // delta 可为负数；最终半径不会小于 0
        public static method addPlayerSearchRadius(player p, real delta) {
            integer pid;
            real r;
            if (p == null) { return; }
            pid = GetConvertedPlayerId(p);
            if (!ISVALID_PLAYER_ID(pid)) { return; }

            r = guarder.searchRadius[pid];
            if (r <= 0.0) { r = GUARD_SEARCH_RADIUS; }
            r = r + delta;
            if (r < 0.0) { r = 0.0; }
            guarder.searchRadius[pid] = r;
        }

        // 获取指定玩家的守卫数量
        public static method getSize(player p) -> integer {
            integer pid;
            if (p == null) { return 0; }
            pid = GetConvertedPlayerId(p);
            if (!ISVALID_PLAYER_ID(pid)) { return 0; }
            return guarder.size[pid];
        }

        // 获取指定玩家第 index 个位置的守卫单位（用于遍历）
        public static method getPetByIndex(player p, integer index) -> unit {
            integer pid;
            if (p == null) { return null; }
            pid = GetConvertedPlayerId(p);
            if (!ISVALID_PLAYER_ID(pid)) { return null; }
            if (index < 1 || index > guarder.size[pid]) { return null; }
            return guarder.pet[pid][index];
        }

        // 周期 tick 主循环
        static method onInit() {
            guarder.tickTimer = CreateTimer();
            TimerStart(guarder.tickTimer, GUARD_TICK, true, function () {
                integer pid;

                for (1 <= pid <= MAX_PLAYER_COUNT) {
                    if (guarder.owner[pid] != null && (GetPlayerSlotState(ConvertedPlayer(pid)) == PLAYER_SLOT_STATE_PLAYING) && (GetPlayerController(ConvertedPlayer(pid)) == MAP_CONTROL_USER)) {
                        guarder.updatePlayerAI(pid);
                    }
                }
            });
        }
    }

}


#undef GUARDER_STATE_NONE
#undef GUARDER_STATE_IDLE_RING
#undef GUARDER_STATE_MOVE
#undef GUARDER_STATE_ATTACK
#undef GUARDER_STATE_PAUSED

//! endzinc
#endif
