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

#include "Crainax/config/SharedMethod.h"

library Dash {

    // 实例结构体：每个 dash 实例持有自身配置
    public struct dash {

        STRUCT_SHARED_METHODS(dash)

        // ====== 全局索引，用于遍历所有 dash ======
        public static thistype DashLists[];
        public static integer size = 0;

        // ====== 槽位映射（二维数组） ======
        private static integer IDashID [MAX_PLAYER_COUNT][MAX_COUNT_DASH];
        private static thistype slots  [MAX_PLAYER_COUNT][MAX_COUNT_DASH];

        // ====== 实例成员（配置与状态） ======
        integer id;         // 冲刺 id（在 create 中设置）
        string  dashName;
        real    dashMax;
        real    dashCool;
        real    dashSpeed;
        string  dashPath;
        real    dashCooldownRemain;

        // 索引（方便 O(1) 从 DashLists 中删除）
        private integer listIndex;

        // ===== 工具：边界 =====
        private static method isValidPlayer1(integer pid1) -> boolean {
            return pid1 >= 1 && pid1 <= MAX_PLAYER_COUNT;
        }

        private static method isValidPos(integer pos) -> boolean {
            return pos >= 1 && pos <= MAX_COUNT_DASH;
        }

        // ===== 生命周期 =====
        static method create (integer id) -> thistype {
            thistype this = allocate();
            this.id = id;
            this.dashName = null;
            this.dashMax = 0.0;
            this.dashCool = 0.0;
            this.dashSpeed = 0.0;
            this.dashPath = null;
            this.dashCooldownRemain = 0.0;

            // 加入全局列表
            dash.size = dash.size + 1;
            dash.DashLists[dash.size] = this;
            this.listIndex = dash.size;
            return this;
        }

        method onDestroy () { // 析构：从 DashLists 中移除
            integer last;
            if (this.listIndex != 0) {
                last = dash.size;
                if (this.listIndex != last) {
                    dash.DashLists[this.listIndex] = dash.DashLists[last];
                    dash.DashLists[this.listIndex].listIndex = this.listIndex;
                }
                dash.DashLists[last] = 0;
                dash.size = dash.size - 1;
                this.listIndex = 0;
            }
            this.dashPath = null;
            this.dashName = null;
        }

        // ===== 槽位查询 =====
        public static method GetDashPos(player p, integer id) -> integer {
            integer pid1; integer pos;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return 0; }
            for (1 <= pos <= MAX_COUNT_DASH) {
                if (dash.IDashID[pid1][pos] == id) { return pos; }
            }
            return 0;
        }

        public static method GetEmptyDashPos(player p) -> integer {
            integer pid1; integer pos;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return -1; }
            for (1 <= pos <= MAX_COUNT_DASH) {
                if (dash.IDashID[pid1][pos] == 0) { return pos; }
            }
            return -1;
        }

        // ===== 注册与移除 =====
        public static method AddDash(player p, integer id) {
            integer pid1; integer pos;
            thistype inst;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return; }

            // 已存在则跳过
            pos = dash.GetDashPos(p, id);
            if (pos != 0) { return; }

            pos = dash.GetEmptyDashPos(p);
            if (pos <= 0) { return; }

            inst = dash.create(id);
            dash.IDashID[pid1][pos] = id;
            dash.slots[pid1][pos] = inst;
        }

        // 重要：外部配置写入接口
        public static method SetDashConfig(player p, integer id, string name, real speed, real max, real cool, string path) {
            integer pid1; integer pos;
            thistype inst;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return; }

            pos = dash.GetDashPos(p, id);
            if (pos == 0) { return; }

            inst = dash.slots[pid1][pos];
            if (inst == 0) { return; }
            inst.dashName  = name;
            inst.dashMax   = max;
            inst.dashSpeed = speed;
            inst.dashCool  = cool;
            inst.dashPath  = path;
        }

        // 重要：外部移除接口
        public static method RemoveDash(player p, integer id) {
            integer pid1; integer pos;
            thistype inst;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return; }

            pos = dash.GetDashPos(p, id);
            if (pos == 0) { return; }

            inst = dash.slots[pid1][pos];
            dash.IDashID[pid1][pos] = 0;
            dash.slots[pid1][pos] = 0;
            if (inst != 0) {
                inst.destroy();
            }
        }

        // ===== 统计与查询 =====
        // 已注册（含冷却中）数量
        public static method GetAvailableDashCount(player p) -> integer {
            integer pid1; integer pos; integer cnt;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return 0; }
            cnt = 0;
            for (1 <= pos <= MAX_COUNT_DASH) {
                if (dash.IDashID[pid1][pos] != 0) { cnt = cnt + 1; }
            }
            return cnt;
        }

        // 可用数量（剔除冷却中）
        public static method GetNormalDashCount(player p) -> integer {
            integer pid1; integer pos; integer cnt;
            thistype inst;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return 0; }
            cnt = 0;
            for (1 <= pos <= MAX_COUNT_DASH) {
                inst = dash.slots[pid1][pos];
                if (inst != 0 && inst.dashCooldownRemain <= 0.0) { cnt = cnt + 1; }
            }
            return cnt;
        }

        public static method IsDashOnCooldown(player p, integer id) -> boolean {
            integer pid1; integer pos; thistype inst;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return false; }
            pos = dash.GetDashPos(p, id);
            if (pos == 0) { return false; }
            inst = dash.slots[pid1][pos];
            if (inst == 0) { return false; }
            return inst.dashCooldownRemain > 0.0;
        }

        public static method GetDashCooldownRemaining(player p, integer id) -> real {
            integer pid1; integer pos; thistype inst;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return 0.0; }
            pos = dash.GetDashPos(p, id);
            if (pos == 0) { return 0.0; }
            inst = dash.slots[pid1][pos];
            if (inst == 0) { return 0.0; }
            return inst.dashCooldownRemain;
        }

        public static method SetDashCooldownRemaining(player p, integer id, real value) {
            integer pid1; integer pos; thistype inst; real v;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer1(pid1)) { return; }
            pos = dash.GetDashPos(p, id);
            if (pos == 0) { return; }
            inst = dash.slots[pid1][pos];
            if (inst == 0) { return; }
            v = value; if (v < 0.0) { v = 0.0; }
            inst.dashCooldownRemain = v;
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
