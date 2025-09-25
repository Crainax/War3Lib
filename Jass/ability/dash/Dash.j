#ifndef DashIncluded
#define DashIncluded

//! zinc
/*
冲刺系统 - 数据与接口层
说明：
- 仅负责数据存储与查询，UI与具体冲刺实现不在本模块中。
- 参考 @DashSystem.j 与 @DashSystemData.j 的数据形态进行抽离与统一。
*/

#include "Crainax/config/SharedMethod.h"

library Dash {

    // 实例结构体：每个 dash 实例持有自身配置
    public struct dash {

        STRUCT_SHARED_METHODS(dash)

        // ====== 全局索引，用于遍历所有 dash ======
        public static thistype Lists[];
        public static integer size = 0;

        // ====== 每玩家列表（二维数组） ======
        public static thistype playerLists [MAX_PLAYER_COUNT][MAX_COUNT_DASH];
        public static integer  playerSize  [MAX_PLAYER_COUNT];

        // ====== 实例成员（配置与状态） ======
        string  name;
        real    max;
        real    cool;
        real    speed;
        string  path;
        real    cooldownRemain;

        // 索引（方便 O(1) 从 Lists 中删除）
        private integer listIndex;
        // 归属玩家与其在玩家列表中的索引
        private integer ownerPid1;
        private integer playerListIndex;
        private static trigger coolCallback = null; //回调触发器(参数dArgs)
        private static trigger changeCallback = null; //回调触发器(无参数)
        static thistype dArgs = 0;
        static player pArgs = null;

        // ===== 工具：边界 =====
        private static method isValidPlayer(integer pid1) -> boolean {
            return pid1 >= 1 && pid1 <= MAX_PLAYER_COUNT;
        }

        private static method isValidPos(integer pos) -> boolean {
            return pos >= 1 && pos <= MAX_COUNT_DASH;
        }

        // ===== 生命周期 =====
        public static method create (player p) -> thistype {
            integer pid1; integer pos;
            thistype this;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer(pid1)) { return 0; }
            this = allocate();
            this.name = null;
            this.max = 0.0;
            this.cool = 0.0;
            this.speed = 0.0;
            this.path = null;
            this.cooldownRemain = 0.0;

            // 加入全局列表
            dash.size = dash.size + 1;
            dash.Lists[dash.size] = this;
            this.listIndex = dash.size;
            // 加入玩家列表
            this.ownerPid1 = pid1;
            pos = dash.playerSize[pid1] + 1;
            if (pos <= MAX_COUNT_DASH) {
                dash.playerLists[pid1][pos] = this;
                dash.playerSize[pid1] = pos;
                this.playerListIndex = pos;
            } else {
                // 若超出容量，撤销全局登记并返回空
                dash.Lists[this.listIndex] = 0;
                dash.size = dash.size - 1;
                this.listIndex = 0;
                this.destroy();
                return 0;
            }
            if (changeCallback != null) {
                pArgs = p;
                TriggerEvaluate(changeCallback);
            }
            return this;
        }

        method onDestroy () { // 析构：从 Lists 中移除
            integer last; integer pid1; integer plast;
            if (!this.isExist()) {return;}

            pArgs = this.getOwner();
            if (this.listIndex != 0) {
                last = dash.size;
                if (this.listIndex != last) {
                    dash.Lists[this.listIndex] = dash.Lists[last];
                    dash.Lists[this.listIndex].listIndex = this.listIndex;
                }
                dash.Lists[last] = 0;
                dash.size = dash.size - 1;
                this.listIndex = 0;
            }
            // 从玩家列表移除
            pid1 = this.ownerPid1;
            if (dash.isValidPlayer(pid1) && this.playerListIndex != 0) {
                plast = dash.playerSize[pid1];
                if (this.playerListIndex != plast) {
                    dash.playerLists[pid1][this.playerListIndex] = dash.playerLists[pid1][plast];
                    dash.playerLists[pid1][this.playerListIndex].playerListIndex = this.playerListIndex;
                }
                dash.playerLists[pid1][plast] = 0;
                dash.playerSize[pid1] = plast - 1;
                this.playerListIndex = 0;
                this.ownerPid1 = 0;
            }
            this.path = null;
            this.name = null;

            if (changeCallback != null) {
                TriggerEvaluate(changeCallback);
            }
            pArgs = null;

        }

        // ===== 实例配置接口 =====
        method setConfig(string name, real speed, real max, real cool, string path) {
            if (!this.isExist()) {return;}
            this.name  = name;
            this.max   = max;
            this.speed = speed;
            this.cool  = cool;
            this.path  = path;
        }

        // ===== 实例冷却接口 =====
        method isOnCooldown() -> boolean { return this.cooldownRemain > 0.0; }
        method getCooldownRemaining() -> real { return this.cooldownRemain; }
        method setCooldownRemaining(real value) {
            real v = value; if (v < 0.0) { v = 0.0; }
            this.cooldownRemain = v;
        }

        // ===== 玩家级查询（实例方法）=====
        method getOwnerPid1() -> integer { return this.ownerPid1; }
        method getOwner() -> player { if (this.ownerPid1 <= 0) { return null; } return ConvertedPlayer(this.ownerPid1); }
        method getPlayerDashCount() -> integer { if (this.ownerPid1 <= 0) { return 0; } return dash.playerSize[this.ownerPid1]; }
        static method getPlayerDashByIndex(player p, integer pos) -> thistype {
            integer pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer(pid1)) { return 0; }
            if (!dash.isValidPos(pos)) { return 0; }
            return dash.playerLists[pid1][pos];
        }

        // 获取玩家当前不在冷却中的 dash 数量
        static method getPlayerAvailableDashCount(player p) -> integer {
            integer pid1; integer i; integer count; thistype inst;
            pid1 = GetConvertedPlayerId(p);
            if (!dash.isValidPlayer(pid1)) { return 0; }
            count = 0;
            for (1 <= i <= dash.playerSize[pid1]) {
                inst = dash.playerLists[pid1][i];
                if (inst != 0 && inst.isExist() && !inst.isOnCooldown()) {
                    count = count + 1;
                }
            }
            return count;
        }

        // ===== 冷却好了回调(dArgs参数) =====
        static method registerCoolCallBack(code func) {
            if (coolCallback == null) {
                coolCallback = CreateTrigger();
            }
            TriggerAddCondition(coolCallback, Condition(func));
        }

        static method getCallbackDash () -> thistype { return dArgs; }

        // ===== 创建了新的 dash 或者销毁了 dash 回调(玩家参数) =====
        static method registerChangeCallBack(code func) {
            if (changeCallback == null) {
                changeCallback = CreateTrigger();
            }
            TriggerAddCondition(changeCallback, Condition(func));
        }

        static method getCallbackPlayer () -> player { return pArgs; }

        // ===== 初始化 =====
        static method onInit() {
            timer ti = CreateTimer();
            TimerStart(ti, 0.2, true, function (){ //CD减少事件
                integer i; thistype this; boolean isCall = false;
                if (size > 0) {
                    for (1 <= i <= size) {
                        this = Lists[i]; //从结论来说i就是.uID
                        if (this.isExist() && this.isOnCooldown()) {
                            this.cooldownRemain = RMaxBJ(0, this.cooldownRemain - 0.2);
                            if (this.cooldownRemain <= 0) {
                                isCall = true;
                            }
                        }
                    }

                    if (isCall) {
                        //触发回调
                        if (coolCallback != null) {
                            dArgs = this;
                            TriggerEvaluate(coolCallback);
                        }
                    }

                }
            });
            ti = null;
        }
    }
}

//! endzinc
#endif
