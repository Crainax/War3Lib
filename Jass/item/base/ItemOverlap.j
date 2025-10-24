#ifndef ItemOverlapIncluded
#define ItemOverlapIncluded

//! zinc
/*
物品叠加系统
*/
library ItemOverlap  {

    public struct itemOverlap [] {

        // 注册表：记录可叠加的物品类型
        private static integer regTypeIds[];
        private static integer regCount = 0;

        // 在注册表中查找 typeId，返回索引（未找到返回 0）
        private static method findIndexByType(integer typeId) -> integer {
            integer i;
            for (1 <= i <= itemOverlap.regCount) {
                if (itemOverlap.regTypeIds[i] == typeId) {
                    return i;
                }
            }
            return 0;
        }

        // 对外接口：注册可叠加物品类型（无限叠加）
        public static method register(integer typeId) -> boolean {
            if (typeId == 0) { return false; }
            if (itemOverlap.findIndexByType(typeId) != 0) { return true; }
            itemOverlap.regCount += 1;
            itemOverlap.regTypeIds[itemOverlap.regCount] = typeId;
            return true;
        }

        static method onInit () {
            trigger tr; integer i;
            tr = CreateTrigger();
            for (i = 0; i < MAX_PLAYER_COUNT; i += 1) {
                TriggerRegisterPlayerUnitEvent(tr, Player(i), EVENT_PLAYER_UNIT_PICKUP_ITEM, null);
            }
            TriggerAddCondition(tr, Condition(function () {
                unit u; item it; integer typeId; integer idx;
                integer i; item slotItem; integer cur; integer add; integer slotType;
                player p;

                u = GetManipulatingUnit();
                it = GetManipulatedItem();
                if (u == null || it == null || GetItemType(it) != ITEM_TYPE_CHARGED) {
                    u = null; it = null;
                }

                p = GetOwningPlayer(u);
                // 只有属于中立被动玩家或当前玩家的物品才能叠加
                if (GetItemPlayer(it) != Player(PLAYER_NEUTRAL_PASSIVE) && GetItemPlayer(it) != p) {
                    u = null; it = null; p = null;
                }

                typeId = GetItemTypeId(it);
                idx = itemOverlap.findIndexByType(typeId);
                if (idx == 0) {
                    u = null; it = null; p = null;
                }

                // 新物品的层数（至少按 1 处理）
                add = GetItemCharges(it);
                if (add <= 0) { add = 1; }

                // 遍历背包，找到第一件同类物品并直接无限叠加
                for (i = 0; i < 6; i += 1) {
                    slotItem = UnitItemInSlot(u, i);
                    if (slotItem != null && slotItem != it) {
                        slotType = GetItemTypeId(slotItem);
                        if (slotType == typeId) {
                            cur = GetItemCharges(slotItem);
                            SetItemCharges(slotItem, cur + add);
                            RemoveItem(it);
                            it = null; u = null; p = null;
                        }
                    }
                }

                // 背包没有同类物品，保持新物品不变
                it = null; u = null;

            }));
            tr = null;
        }

    }

}

//! endzinc
#endif
