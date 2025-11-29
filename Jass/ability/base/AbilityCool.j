#ifndef AbilityCoolIncluded
#define AbilityCoolIncluded

// 冷却哈希键定义等
#include "Crainax/core/table/Hash_AbilityDefine.j"
#include "Crainax/core/constant/HashTable.j"

//! zinc
/*
技能的冷却管理
*/
library AbilityCool requires HashTable {

    // 冷却队列：集中管理所有处于冷却中的 (unit, abilityId)
    private struct AbilityCDQueue [] {
        private static unit    uList[];      // 单位列表
        private static integer abilList[];   // 技能ID列表
        private static integer size = 0;     // 当前元素数量
        private static timer   tickTimer = null; // 驱动冷却衰减的定时器

        // 确保定时器已创建并运行
        private static method ensureTimer() {
            if (thistype.tickTimer == null) {
                thistype.tickTimer = CreateTimer();
                TimerStart(thistype.tickTimer, 0.02, true, function () {
                    integer i; integer last; unit u; integer abilId; integer parentKey; real cd;

                    // 单次遍历 + 尾部交换，O(n)
                    for (i = 0; i < thistype.size; i += 1) {
                        u      = thistype.uList[i];
                        abilId = thistype.abilList[i];

                        parentKey = GetAbilityHashKey(u, abilId);

                        // 如果哈希中已经没有记录，视为冷却结束，直接移除队列项
                        if (parentKey == 0 || !HaveSavedReal(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_COOLDOWN)) {
                            last = thistype.size - 1;
                            if (i != last) {
                                thistype.uList[i]    = thistype.uList[last];
                                thistype.abilList[i] = thistype.abilList[last];
                            }
                            thistype.uList[last]    = null;
                            thistype.abilList[last] = 0;
                            thistype.size -= 1;
                            i -= 1;
                            u = null;
                        } else {
                            cd = LoadReal(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_COOLDOWN) - 0.02;

                            if (cd <= 0.02) {
                                // 冷却结束：删除哈希记录并从队列移除
                                RemoveSavedReal(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_COOLDOWN);

                                // 尾部交换移除当前元素
                                last = thistype.size - 1;
                                if (i != last) {
                                    thistype.uList[i]    = thistype.uList[last];
                                    thistype.abilList[i] = thistype.abilList[last];
                                }
                                thistype.uList[last]    = null;
                                thistype.abilList[last] = 0;
                                thistype.size -= 1;

                                // 因为换入了新元素，i 回退一位以继续检查该位置
                                i -= 1;
                            } else {
                                // 冷却尚未结束：写回剩余时间
                                SaveReal(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_COOLDOWN, cd);
                            }

                            // 清理本次循环用到的句柄
                            u = null;
                        }
                    }

                    // 队列为空时，停止并释放计时器，方便下次懒加载
                    if (thistype.size <= 0 && thistype.tickTimer != null) {
                        PauseTimer(thistype.tickTimer);
                        DestroyTimer(thistype.tickTimer);
                        thistype.tickTimer = null;
                    }
                });
            }
        }

        // 查找队列中是否已有 (u, abilityID) 项，找到则返回索引，否则返回 -1
        private static method indexOf(unit u, integer abilityID) -> integer {
            integer i;
            for (i = 0; i < thistype.size; i += 1) {
                if (thistype.uList[i] == u && thistype.abilList[i] == abilityID) {
                    return i;
                }
            }
            return -1;
        }

        // 在队列中设置或更新某个 (u, abilityID) 的冷却
        public static method setValue(unit u, integer abilityID, real value) {
            integer idx; integer last; integer parentKey;

            if (u == null || abilityID == 0) { return; }

            if (value <= 0.0) {
                // 冷却结束：若在队列中则删除
                idx = thistype.indexOf(u, abilityID);
                if (idx >= 0) {
                    last = thistype.size - 1;
                    if (idx != last) {
                        thistype.uList[idx]    = thistype.uList[last];
                        thistype.abilList[idx] = thistype.abilList[last];
                    }
                    thistype.uList[last]    = null;
                    thistype.abilList[last] = 0;
                    thistype.size -= 1;
                }

                // 当队列已空时，停止并释放计时器，优化性能
                if (thistype.size <= 0 && thistype.tickTimer != null) {
                    PauseTimer(thistype.tickTimer);
                    DestroyTimer(thistype.tickTimer);
                    thistype.tickTimer = null;
                }

                // 同步清理哈希记录
                parentKey = GetAbilityHashKey(u, abilityID);
                if (parentKey != 0 && HaveSavedReal(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_COOLDOWN)) {
                    RemoveSavedReal(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_COOLDOWN);
                }
                return;
            }

            // 设置冷却：若已有则更新，没有则追加
            thistype.ensureTimer();

            // 写入哈希中的冷却时间
            parentKey = GetAbilityHashKey(u, abilityID);
            if (parentKey == 0) { return; }
            SaveReal(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_COOLDOWN, value);

            idx = thistype.indexOf(u, abilityID);
            if (idx >= 0) {
                // 已存在队列条目，只需要更新哈希，不改动队列结构
            } else {
                if (thistype.size >= 8190) {
                    BJDebugMsg("|cFFFF0000[AbilityCool] 队列已满，无法继续添加冷却条目！|r");
                    return;
                }
                thistype.uList[thistype.size]    = u;
                thistype.abilList[thistype.size] = abilityID;
                thistype.size += 1;
            }
        }
    }

    // 判断技能冷却是否已就绪（无冷却或冷却结束）
    public function IsAbilityCDOK(unit u, integer abilityID) -> boolean {
        integer parentKey; real cd;

        if (u == null || abilityID == 0) { return true; }

        parentKey = GetAbilityHashKey(u, abilityID);
        if (parentKey == 0) { return true; }

        if (!HaveSavedReal(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_COOLDOWN)) {
            return true;
        }

        cd = LoadReal(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_COOLDOWN);
        if (cd <= 0.0) {
            // 冷却记录已到期，顺手清理
            RemoveSavedReal(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_COOLDOWN);
            return true;
        }

        return false;
    }

    // 设置技能逻辑冷却时间（秒）
    public function SetAbilityCD(unit u, integer abilityID, real value) {
        if (u == null || abilityID == 0) { return; }

        AbilityCDQueue.setValue(u, abilityID, value);
    }
}

//! endzinc
#endif

