#ifndef DashIncluded
#define DashIncluded

//! zinc
/*
冲刺系统 - 数据与接口层
说明：
- 仅负责数据存储与查询，UI与具体冲刺实现不在本模块中。
- 参考 @DashSystem.j 与 @DashSystemData.j 的数据形态进行抽离与统一。
*/

// 若外部未定义，则提供一个默认值；可按需在上层覆盖
#ifndef MAX_COUNT_DASH
#define MAX_COUNT_DASH 10
#endif

library Dash {

    // 纯静态结构体：管理每位玩家的冲刺槽位与配置
    public struct dash [] {

        // 扁平化存储（pid1: 1..MAX_PLAYER_COUNT, pos: 1..MAX_COUNT_DASH）
        // 计算偏移： (pid1 - 1) * MAX_COUNT_DASH + (pos - 1)

        // 槽位注册 id（0 表示空）
        private static integer dashId[];
        // 每玩家拥有的已注册冲刺数量（包含冷却中的）
        private static integer dashCountByPlayer[];

        // 配置：名称/最大距离/冷却时长/速度/特效路径
        private static string  dashName[];
        private static real    dashMax[];
        private static real    dashCool[];
        private static real    dashSpeed[];
        private static string  dashPath[];

        // 冷却剩余时间
        private static real    dashCooldownRemain[];

        // ===== 工具：索引与边界 =====
        private static method offset(integer pid1, integer pos) -> integer {
            return (pid1 - 1) * MAX_COUNT_DASH + (pos - 1);
        }

        private static method isValidPlayer1(integer pid1) -> boolean {
            return pid1 >= 1 && pid1 <= MAX_PLAYER_COUNT;
        }

        private static method isValidPos(integer pos) -> boolean {
            return pos >= 1 && pos <= MAX_COUNT_DASH;
        }

        // ===== 槽位查询 =====
        public static method GetDashPos(player p, integer id) -> integer {
            integer pid1; integer pos; integer off;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return 0; }
            for (1 <= pos <= MAX_COUNT_DASH) {
                off = dash.offset(pid1, pos);
                if (dash.dashId[off] == id) { return pos; }
            }
            return 0;
        }

        public static method GetEmptyDashPos(player p) -> integer {
            integer pid1; integer pos; integer off;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return -1; }
            for (1 <= pos <= MAX_COUNT_DASH) {
                off = dash.offset(pid1, pos);
                if (dash.dashId[off] == 0) { return pos; }
            }
            return -1;
        }

        // ===== 注册与移除 =====
        public static method AddDash(player p, integer id) {
            integer pid1; integer pos; integer off;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return; }

            // 已存在则跳过
            pos = dash.GetDashPos(p, id);
            if (pos != 0) { return; }

            pos = dash.GetEmptyDashPos(p);
            if (pos <= 0) { return; }

            off = dash.offset(pid1, pos);
            dash.dashId[off] = id;
            dash.dashCountByPlayer[pid1] = dash.dashCountByPlayer[pid1] + 1;
        }

        // 重要：外部配置写入接口
        public static method SetDashConfig(player p, integer id, string name, real speed, real max, real cool, string path) {
            integer pid1; integer pos; integer off;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return; }

            pos = dash.GetDashPos(p, id);
            if (pos == 0) { return; }

            off = dash.offset(pid1, pos);
            dash.dashName[off]  = name;
            dash.dashMax[off]   = max;
            dash.dashSpeed[off] = speed;
            dash.dashCool[off]  = cool;
            dash.dashPath[off]  = path;
        }

        // 重要：外部移除接口
        public static method RemoveDash(player p, integer id) {
            integer pid1; integer pos; integer off;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return; }

            pos = dash.GetDashPos(p, id);
            if (pos == 0) { return; }

            off = dash.offset(pid1, pos);
            dash.dashId[off] = 0;
            dash.dashName[off] = null;
            dash.dashMax[off] = 0.0;
            dash.dashSpeed[off] = 0.0;
            dash.dashCool[off] = 0.0;
            dash.dashPath[off] = null;
            dash.dashCooldownRemain[off] = 0.0;
            if (dash.dashCountByPlayer[pid1] > 0) {
                dash.dashCountByPlayer[pid1] = dash.dashCountByPlayer[pid1] - 1;
            }
        }

        // ===== 统计与查询 =====
        // 已注册（含冷却中）数量
        public static method GetAvailableDashCount(player p) -> integer {
            integer pid1;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return 0; }
            return dash.dashCountByPlayer[pid1];
        }

        // 可用数量（剔除冷却中）
        public static method GetNormalDashCount(player p) -> integer {
            integer pid1; integer pos; integer off; integer cnt;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return 0; }
            cnt = 0;
            for (1 <= pos <= MAX_COUNT_DASH) {
                off = dash.offset(pid1, pos);
                if (dash.dashId[off] != 0 && dash.dashCooldownRemain[off] <= 0.0) {
                    cnt = cnt + 1;
                }
            }
            return cnt;
        }

        public static method IsDashOnCooldown(player p, integer id) -> boolean {
            integer pid1; integer pos; integer off;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return false; }
            pos = dash.GetDashPos(p, id);
            if (pos == 0) { return false; }
            off = dash.offset(pid1, pos);
            return dash.dashCooldownRemain[off] > 0.0;
        }

        public static method GetDashCooldownRemaining(player p, integer id) -> real {
            integer pid1; integer pos; integer off;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return 0.0; }
            pos = dash.GetDashPos(p, id);
            if (pos == 0) { return 0.0; }
            off = dash.offset(pid1, pos);
            return dash.dashCooldownRemain[off];
        }

        public static method SetDashCooldownRemaining(player p, integer id, real value) {
            integer pid1; integer pos; integer off; real v;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return; }
            pos = dash.GetDashPos(p, id);
            if (pos == 0) { return; }
            v = value;
            if (v < 0.0) { v = 0.0; }
            off = dash.offset(pid1, pos);
            dash.dashCooldownRemain[off] = v;
        }

        // ===== 常量查询 =====
        public static method GetDashMaxPlayers() -> integer { return MAX_PLAYER_COUNT; }
        public static method GetDashMaxPerPlayer() -> integer { return MAX_COUNT_DASH; }

        // ===== 初始化 =====
        static method onInit() {
            // 留空：依赖于 Zinc 数组默认初始化（0/null）
        }
    }
}

//! endzinc
#endif
