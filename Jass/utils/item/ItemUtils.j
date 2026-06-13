#ifndef ItemUtilsIncluded
#define ItemUtilsIncluded

#include "Crainax/core/table/Hash_ItemDefine.j"

#define ITEM_COOLDOWN_TICK 0.10
#define ITEM_COOLDOWN_TICKS_PER_SECOND 10
#define ITEM_COOLDOWN_MAX_SIZE 8190

//! zinc
/*
物品工具库
*/
library ItemUtils requires HashTable, NumberUtils {

    private struct ItemCooldownQueue [] {
        private static item itemList[];
        private static integer leftTicks[];
        private static integer size = 0;
        private static timer tickTimer = null;

        private static method ticksToCharges(integer ticks) -> integer {
            if (ticks <= 0) { return 0; }
            return (ticks + ITEM_COOLDOWN_TICKS_PER_SECOND - 1) / ITEM_COOLDOWN_TICKS_PER_SECOND;
        }

        private static method secondsToTicks(real seconds) -> integer {
            if (seconds <= 0.0) { return 0; }
            return IMaxBJ(1, R2I(seconds * I2R(ITEM_COOLDOWN_TICKS_PER_SECOND) + 0.999));
        }

        private static method shouldToggleItem(item it) -> boolean {
            return it != null && GetItemTypeId(it) != 0 && GetDigitAt(GetItemUserData(it), 4) < 1;
        }

        private static method clearSaved(item it) {
            integer id;

            if (it == null) { return; }
            id = GetHandleId(it);
            RemoveSavedBoolean(HASH_ITEM, id, HASH_KEY_ITEM_CD);
            RemoveSavedInteger(HASH_ITEM, id, HASH_KEY_ITEM_CD_QUEUE_INDEX);
            RemoveSavedInteger(HASH_ITEM, id, HASH_KEY_ITEM_CD_LEFT_TICKS);
        }

        private static method stopTimerIfEmpty() {
            if (thistype.size <= 0 && thistype.tickTimer != null) {
                PauseTimer(thistype.tickTimer);
                DestroyTimer(thistype.tickTimer);
                thistype.tickTimer = null;
            }
        }

        private static method removeAt(integer index, boolean restoreItemFlags) -> integer {
            integer last;
            item removed;
            item moved;

            if (index < 0 || index >= thistype.size) { return index; }

            removed = thistype.itemList[index];
            if (removed != null) {
                thistype.clearSaved(removed);
                if (restoreItemFlags && thistype.shouldToggleItem(removed)) {
                    SetItemPawnable(removed, true);
                    SetItemDroppable(removed, true);
                }
            }

            last = thistype.size - 1;
            if (index != last) {
                moved = thistype.itemList[last];
                thistype.itemList[index] = moved;
                thistype.leftTicks[index] = thistype.leftTicks[last];
                if (moved != null) {
                    SaveInteger(HASH_ITEM, GetHandleId(moved), HASH_KEY_ITEM_CD_QUEUE_INDEX, index);
                }
            }

            thistype.itemList[last] = null;
            thistype.leftTicks[last] = 0;
            thistype.size -= 1;
            thistype.stopTimerIfEmpty();

            removed = null;
            moved = null;
            return index - 1;
        }

        private static method indexOf(item it) -> integer {
            integer i;

            if (it == null) { return -1; }
            if (HaveSavedInteger(HASH_ITEM, GetHandleId(it), HASH_KEY_ITEM_CD_QUEUE_INDEX)) {
                i = LoadInteger(HASH_ITEM, GetHandleId(it), HASH_KEY_ITEM_CD_QUEUE_INDEX);
                if (i >= 0 && i < thistype.size && thistype.itemList[i] == it) {
                    return i;
                }
            }
            for (i = 0; i < thistype.size; i += 1) {
                if (thistype.itemList[i] == it) { return i; }
            }
            return -1;
        }

        private static method ensureTimer() {
            if (thistype.tickTimer == null) {
                thistype.tickTimer = CreateTimer();
                TimerStart(thistype.tickTimer, ITEM_COOLDOWN_TICK, true, function () {
                    integer i;
                    item it;

                    for (i = 0; i < thistype.size; i += 1) {
                        it = thistype.itemList[i];
                        if (it == null || GetItemTypeId(it) == 0) {
                            i = thistype.removeAt(i, false);
                        } else if (!HaveSavedBoolean(HASH_ITEM, GetHandleId(it), HASH_KEY_ITEM_CD)) {
                            i = thistype.removeAt(i, true);
                        } else {
                            thistype.leftTicks[i] -= 1;
                            if (thistype.leftTicks[i] <= 0) {
                                SetItemCharges(it, 0);
                                i = thistype.removeAt(i, true);
                            } else {
                                SaveInteger(HASH_ITEM, GetHandleId(it), HASH_KEY_ITEM_CD_LEFT_TICKS, thistype.leftTicks[i]);
                                SetItemCharges(it, thistype.ticksToCharges(thistype.leftTicks[i]));
                            }
                        }
                        it = null;
                    }

                    thistype.stopTimerIfEmpty();
                });
            }
        }

        public static method set(item it, real seconds) {
            integer index;
            integer ticks;

            if (it == null || GetItemTypeId(it) == 0) { return; }
            if (seconds <= 0.0) {
                thistype.clear(it);
                return;
            }

            ticks = thistype.secondsToTicks(seconds);
            index = thistype.indexOf(it);
            if (index < 0) {
                if (thistype.size >= ITEM_COOLDOWN_MAX_SIZE) {
                    BJDebugMsg("|cFFFF0000[ItemCooldownQueue] 队列已满，无法继续添加物品冷却！|r");
                    return;
                }
                index = thistype.size;
                thistype.itemList[index] = it;
                thistype.size += 1;
            }

            thistype.leftTicks[index] = ticks;
            if (thistype.shouldToggleItem(it)) {
                SetItemPawnable(it, false);
                SetItemDroppable(it, false);
            }
            SetItemCharges(it, thistype.ticksToCharges(ticks));
            SaveBoolean(HASH_ITEM, GetHandleId(it), HASH_KEY_ITEM_CD, true);
            SaveInteger(HASH_ITEM, GetHandleId(it), HASH_KEY_ITEM_CD_QUEUE_INDEX, index);
            SaveInteger(HASH_ITEM, GetHandleId(it), HASH_KEY_ITEM_CD_LEFT_TICKS, ticks);
            thistype.ensureTimer();
        }

        public static method clear(item it) {
            integer index;

            if (it == null) { return; }
            index = thistype.indexOf(it);
            if (index >= 0) {
                if (GetItemTypeId(it) != 0) {
                    SetItemCharges(it, 0);
                }
                thistype.removeAt(index, GetItemTypeId(it) != 0);
            } else {
                thistype.clearSaved(it);
                if (GetItemTypeId(it) != 0) {
                    SetItemCharges(it, 0);
                    if (thistype.shouldToggleItem(it)) {
                        SetItemPawnable(it, true);
                        SetItemDroppable(it, true);
                    }
                }
            }
            thistype.stopTimerIfEmpty();
        }

        public static method getLeft(item it) -> real {
            integer index;

            if (it == null || GetItemTypeId(it) == 0) { return 0.0; }
            if (!HaveSavedBoolean(HASH_ITEM, GetHandleId(it), HASH_KEY_ITEM_CD)) { return 0.0; }
            index = thistype.indexOf(it);
            if (index < 0) { return 0.0; }
            return I2R(thistype.leftTicks[index]) * ITEM_COOLDOWN_TICK;
        }
    }

    public function UnitAddItemByIdPlayer (integer itemId, unit whichHero) -> item {
        bj_lastCreatedItem = CreateItem(itemId, GetUnitX(whichHero), GetUnitY(whichHero));
        UnitAddItem(whichHero, bj_lastCreatedItem);
        SetItemPlayer(bj_lastCreatedItem, GetOwningPlayer(whichHero),false);
        return bj_lastCreatedItem;
    }

    /*
    设置物品冷却。冷却期间用 charges 显示向上取整秒数，并临时禁用普通物品的出售/丢弃。
    cd <= 0 时等同于清除冷却；it 为 null 或已移除时安全忽略。
    */
    public function SetItemCooldownEx(item it, real cd) {
        ItemCooldownQueue.set(it, cd);
    }

    /*
    手动清除物品冷却，恢复普通物品的出售/丢弃状态并清理队列索引。
    it 为 null 或已移除时安全忽略。
    */
    public function ClearItemCooldownEx(item it) {
        ItemCooldownQueue.clear(it);
    }

    /*
    查询物品剩余冷却秒数，返回值以 0.1 秒刻度递减。
    null、已移除物品或未进入冷却的物品返回 0。
    */
    public function GetItemCooldownEx(item it) -> real {
        return ItemCooldownQueue.getLeft(it);
    }

    /*
    判断物品冷却是否就绪。该函数不修改队列状态。
    null、已移除物品或未进入冷却的物品视为就绪。
    */
    public function IsItemCooldownExOK(item it) -> boolean {
        return GetItemCooldownEx(it) <= 0.0;
    }

}

//! endzinc
#undef ITEM_COOLDOWN_TICK
#undef ITEM_COOLDOWN_TICKS_PER_SECOND
#undef ITEM_COOLDOWN_MAX_SIZE
#endif
