#ifndef ItemTransportIncluded
#define ItemTransportIncluded

//! zinc
/*
右键双击装备传送 - 结构体版本
说明：
- 每个实例代表一个 A->B 的传送关系
- 支持单向注册和双向注册
- 使用双重索引数据结构，支持高效查询和遍历

使用示例：
1. 单向传送注册
   // 注册英雄到仓库的传送
   itemTransport.registerOneWay(hero, depot, "|cFFFF66CC【消息】|r物品已传送到仓库");
   itemTransport.enableForUnit(hero);

2. 双向传送注册
   // 注册英雄和仓库的双向传送
   itemTransport.registerBidirectional(hero, depot,
       "|cFFFF66CC【消息】|r物品已传送到仓库",
       "|cFFFF66CC【消息】|r物品已传送到英雄");
   itemTransport.enableForUnit(hero);
   itemTransport.enableForUnit(depot);

3. 批量注册多个单位
   // 为多个玩家注册英雄和仓库的传送关系
   for (integer i = 1; i <= 12; i++) {
       player p = ConvertedPlayer(i);
       unit playerHero = GetPlayerHero(p);
       unit playerDepot = GetPlayerDepot(p);

       if (playerHero != null && playerDepot != null) {
           itemTransport.registerBidirectional(playerHero, playerDepot, null, null);
           itemTransport.enableForUnit(playerHero);
           itemTransport.enableForUnit(playerDepot);
       }
   }

4. 查询统计信息
   // 获取总传送关系数量
   integer totalCount = itemTransport.getTotalCount();
   // 获取某个单位的传送关系数量
   integer unitCount = itemTransport.getUnitTransportCount(myUnit);
*/

#include "Crainax/config/SharedMethod.h"

#define MAX_TRANSPORT_COUNT     500     // 最大传送关系数量
#define MAX_UNIT_TRANSPORTS     20      // 每个单位最多的传送关系数
#define MAX_UNIT_COUNT          1000    // 最大单位数量（用于分组数组）

library ItemTransport {

    // 传送关系结构体
    public struct itemTransport {

        STRUCT_SHARED_METHODS(itemTransport)

        // ====== 双重索引系统 ======
        // 全局列表（用于遍历所有传送关系）
        public static thistype Lists[];
        public static integer size = 0;

        // 单位分组列表（按源单位分组）
        public static thistype unitLists[MAX_UNIT_COUNT][MAX_UNIT_TRANSPORTS];
        public static integer unitSize[MAX_UNIT_COUNT];

        // ====== 实例成员（传送关系配置） ======
        private unit sourceUnit;        // 源单位
        private unit targetUnit;        // 目标单位
        private string message;         // 传送成功提示消息

        // ====== 实例索引记录 ======
        private integer listIndex;        // 在全局列表中的位置
        private integer sourceUnitId;     // 源单位的自定义ID
        private integer unitListIndex;    // 在单位列表中的位置

        // ====== 回调参数传递（避免哈希表冲突） ======
        public static unit callbackSourceUnit = null;
        public static unit callbackTargetUnit = null;
        public static item callbackItem = null;
        public static integer callbackSlot = 0;

        // ====== 全局触发器 ======
        private static trigger transportTrigger = null;
        private static boolean initialized = false;

        // ====== 边界检查 ======
        private static method isValidUnitId(integer unitId) -> boolean {
            return unitId >= 1 && unitId <= MAX_UNIT_COUNT;
        }

        private static method isValidPos(integer pos) -> boolean {
            return pos >= 1 && pos <= MAX_UNIT_TRANSPORTS;
        }

        // ====== 单位ID获取（需要根据实际项目调整） ======
        private static method getUnitCustomId(unit u) -> integer {
            // 这里需要根据实际项目的单位ID系统调整
            // 暂时使用句柄ID的简化版本
            return ModuloInteger(GetHandleId(u), MAX_UNIT_COUNT) + 1;
        }

        // ====== 生命周期 =====
        public static method create(unit source, unit target, string msg) -> thistype {
            integer sourceId; integer pos; thistype this;

            if (source == null || target == null) { return 0; }

            sourceId = itemTransport.getUnitCustomId(source);
            if (!itemTransport.isValidUnitId(sourceId)) { return 0; }

            this = allocate();
            this.sourceUnit = source;
            this.targetUnit = target;
            this.message = msg;

            // 加入全局列表
            itemTransport.size = itemTransport.size + 1;
            itemTransport.Lists[itemTransport.size] = this;
            this.listIndex = itemTransport.size;

            // 加入单位分组列表
            this.sourceUnitId = sourceId;
            pos = itemTransport.unitSize[sourceId] + 1;
            if (pos <= MAX_UNIT_TRANSPORTS) {
                itemTransport.unitLists[sourceId][pos] = this;
                itemTransport.unitSize[sourceId] = pos;
                this.unitListIndex = pos;
            } else {
                // 容量超限回滚
                itemTransport.Lists[this.listIndex] = 0;
                itemTransport.size = itemTransport.size - 1;
                this.listIndex = 0;
                this.destroy();
                BJDebugMsg("ItemTransport: 单位传送关系已达上限");
                return 0;
            }

            return this;
        }

        method onDestroy() {
            integer last; integer unitLast;

            if (!this.isExist()) { return; }

            // 从全局列表移除（紧凑数组）
            if (this.listIndex != 0) {
                last = itemTransport.size;
                if (this.listIndex != last) {
                    // 将最后元素移到当前位置
                    itemTransport.Lists[this.listIndex] = itemTransport.Lists[last];
                    itemTransport.Lists[this.listIndex].listIndex = this.listIndex;
                }
                itemTransport.Lists[last] = 0;
                itemTransport.size = itemTransport.size - 1;
                this.listIndex = 0;
            }

            // 从单位列表移除（紧凑数组）
            if (itemTransport.isValidUnitId(this.sourceUnitId) && this.unitListIndex != 0) {
                unitLast = itemTransport.unitSize[this.sourceUnitId];
                if (this.unitListIndex != unitLast) {
                    // 将最后元素移到当前位置
                    itemTransport.unitLists[this.sourceUnitId][this.unitListIndex] = itemTransport.unitLists[this.sourceUnitId][unitLast];
                    itemTransport.unitLists[this.sourceUnitId][this.unitListIndex].unitListIndex = this.unitListIndex;
                }
                itemTransport.unitLists[this.sourceUnitId][unitLast] = 0;
                itemTransport.unitSize[this.sourceUnitId] = unitLast - 1;
                this.unitListIndex = 0;
                this.sourceUnitId = 0;
            }

            // 清理句柄类成员变量
            this.sourceUnit = null;
            this.targetUnit = null;
        }

        // ====== 单向传送注册 ======
        public static method registerOneWay(unit source, unit target, string successMsg) -> thistype {
            string msg = successMsg;
            if (msg == null) { msg = "|cFFFF66CC【消息】|r物品传送成功"; }
            return itemTransport.create(source, target, msg);
        }

        // ====== 双向传送注册 ======
        public static method registerBidirectional(unit unitA, unit unitB, string msgAtoB, string msgBtoA) -> boolean {
            thistype transportAB; thistype transportBA;
            string msgAB = msgAtoB; string msgBA = msgBtoA;

            if (msgAB == null) { msgAB = "|cFFFF66CC【消息】|r物品传送成功"; }
            if (msgBA == null) { msgBA = "|cFFFF66CC【消息】|r物品传送成功"; }

            // 创建 A->B 传送关系
            transportAB = itemTransport.create(unitA, unitB, msgAB);
            if (transportAB == 0) { return false; }

            // 创建 B->A 传送关系
            transportBA = itemTransport.create(unitB, unitA, msgBA);
            if (transportBA == 0) {
                // 如果 B->A 创建失败，回滚 A->B
                transportAB.destroy();
                return false;
            }

            return true;
        }

        // ====== 查询方法 ======
        // 根据源单位查找目标单位
        public static method findTarget(unit source, item targetItem) -> unit {
            integer sourceId; integer i; thistype inst;

            if (source == null) { return null; }

            sourceId = itemTransport.getUnitCustomId(source);
            if (!itemTransport.isValidUnitId(sourceId)) { return null; }

            for (1 <= i <= itemTransport.unitSize[sourceId]) {
                inst = itemTransport.unitLists[sourceId][i];
                if (inst != 0 && inst.isExist()) {
                    // 检查目标单位是否有空间容纳物品
                    if (inst.targetUnit != null) {
                        return inst.targetUnit;
                    }
                }
            }

            return null;
        }

        // 根据源单位获取传送消息
        public static method getMessage(unit source) -> string {
            integer sourceId; integer i; thistype inst;

            if (source == null) { return null; }

            sourceId = itemTransport.getUnitCustomId(source);
            if (!itemTransport.isValidUnitId(sourceId)) { return null; }

            for (1 <= i <= itemTransport.unitSize[sourceId]) {
                inst = itemTransport.unitLists[sourceId][i];
                if (inst != 0 && inst.isExist()) {
                    return inst.message;
                }
            }

            return "|cFFFF66CC【消息】|r物品传送成功";
        }

        // ====== 回调参数获取方法 ======
        public static method getCallbackSourceUnit() -> unit {
            return itemTransport.callbackSourceUnit;
        }

        public static method getCallbackTargetUnit() -> unit {
            return itemTransport.callbackTargetUnit;
        }

        public static method getCallbackItem() -> item {
            return itemTransport.callbackItem;
        }

        public static method getCallbackSlot() -> integer {
            return itemTransport.callbackSlot;
        }

        // ====== 初始化 ======
        static method onInit() {
            if (itemTransport.initialized) { return; }

            itemTransport.transportTrigger = CreateTrigger();
            TriggerAddCondition(itemTransport.transportTrigger, Condition(function () -> boolean {
                integer orderId; integer i; integer pos; unit source; item targetItem;
                unit target; string msg; timer t;

                orderId = GetIssuedOrderId();

                // 检查是否为双击装备命令（852002-852007）
                if (orderId < 852002 || orderId > 852007) { return false; }

                source = GetTriggerUnit();
                targetItem = GetOrderTargetItem();

                if (source == null || targetItem == null) { return false; }

                // 查找物品在背包中的位置
                pos = 0;
                for (1 <= i <= 6) {
                    if (UnitItemInSlotBJ(source, i) == targetItem) {
                        pos = i;
                        break;
                    }
                }

                if (pos <= 0) { return false; }

                // 查找传送目标
                target = itemTransport.findTarget(source, targetItem);
                if (target == null) { return false; }

                // 获取传送消息
                msg = itemTransport.getMessage(source);

                // 设置回调参数
                itemTransport.callbackSourceUnit = source;
                itemTransport.callbackTargetUnit = target;
                itemTransport.callbackItem = targetItem;
                itemTransport.callbackSlot = pos;

                // 使用定时器延迟执行传送（避免与游戏原生行为冲突）
                t = CreateTimer();
                TimerStart(t, 0.0, false, function () {
                    timer expiredTimer; unit srcUnit; unit tgtUnit; item itm; integer slot;
                    string message; boolean success;

                    expiredTimer = GetExpiredTimer();
                    srcUnit = itemTransport.getCallbackSourceUnit();
                    tgtUnit = itemTransport.getCallbackTargetUnit();
                    itm = itemTransport.getCallbackItem();
                    slot = itemTransport.getCallbackSlot();

                    // 二次验证物品仍在原位置
                    if (srcUnit != null && tgtUnit != null && itm != null) {
                        if (UnitItemInSlotBJ(srcUnit, slot) == itm) {
                            // 尝试传送物品
                            success = UnitAddItem(tgtUnit, itm);
                            message = itemTransport.getMessage(srcUnit);

                            if (success) {
                                if (message != null) {
                                    DisplayTextToPlayer(GetOwningPlayer(srcUnit), 0, 0, message);
                                }
                            } else {
                                DisplayTextToPlayer(GetOwningPlayer(srcUnit), 0, 0, "|cffff0000传送失败，目标背包已满。|r");
                            }
                        }
                    }

                    // 清理回调参数
                    itemTransport.callbackSourceUnit = null;
                    itemTransport.callbackTargetUnit = null;
                    itemTransport.callbackItem = null;
                    itemTransport.callbackSlot = 0;

                    // 清理定时器
                    PauseTimer(expiredTimer);
                    DestroyTimer(expiredTimer);
                    expiredTimer = null;
                });

                t = null;
                return false;
            }));

            itemTransport.initialized = true;
        }

        // ====== 公共接口：为单位注册传送监听 ======
        public static method enableForUnit(unit u) {
            if (u == null) { return; }
            if (itemTransport.transportTrigger == null) {
                itemTransport.onInit();
            }
            TriggerRegisterUnitEvent(itemTransport.transportTrigger, u, EVENT_UNIT_ISSUED_TARGET_ORDER);
        }

        // ====== 统计方法 ======
        public static method getTotalCount() -> integer {
            return itemTransport.size;
        }

        public static method getUnitTransportCount(unit u) -> integer {
            integer unitId;
            if (u == null) { return 0; }
            unitId = itemTransport.getUnitCustomId(u);
            if (!itemTransport.isValidUnitId(unitId)) { return 0; }
            return itemTransport.unitSize[unitId];
        }
    }

}

//! endzinc
#endif
