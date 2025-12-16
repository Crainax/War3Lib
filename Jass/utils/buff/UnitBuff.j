#ifndef UnitBuffIncluded
#define UnitBuffIncluded


#include "Crainax/core/constant/JapiConstant.j"
#include "Crainax/core/table/Hash_UnitDefine.j"

//! zinc
/*
单位buff工具库
*/

// 无敌特效路径
#define IMMUTE_EFFECT_PATH "Abilities\\Spells\\Human\\DivineShield\\DivineShieldTarget.mdl"
#define IMMUTE_EFFECT_POINT "origin"
library UnitBuff requires UnitUtils, HashTable, BindEffect {

    // 无敌队列：集中管理所有处于无敌中的单位
    private struct ImmuteQueue [] {
        private static unit  uList[];      // 单位列表
        private static integer size = 0;     // 当前元素数量
        private static timer tickTimer = null; // 驱动无敌衰减的定时器

        // 尾部交换移除指定索引的元素（共通方法）
        private static method removeAt(integer index) -> integer {
            integer last;
            if (index < 0 || index >= thistype.size) { return index; }

            last = thistype.size - 1;
            if (index != last) {
                thistype.uList[index] = thistype.uList[last];
            }
            thistype.uList[last] = null;
            thistype.size -= 1;
            // 返回新的索引（因为换入了新元素，需要回退一位继续检查）
            return index - 1;
        }

        // 将单位加入队列（如果不在队列中）
        public static method addUnit(unit u) {
            integer i;
            if (u == null) { return; }

            // 内联查找是否已在队列中
            for (i = 0; i < thistype.size; i += 1) {
                if (thistype.uList[i] == u) {
                    // 已在队列中，不需要重复添加
                    return;
                }
            }

            // 检查队列容量
            if (thistype.size >= 8190) {
                BJDebugMsg("|cFFFF0000[ImmuteQueue] 队列已满，无法继续添加无敌单位！|r");
                return;
            }

            // 加入队列
            thistype.uList[thistype.size] = u;
            thistype.size += 1;

            // 确保定时器运行
            if (thistype.tickTimer == null) {
                thistype.tickTimer = CreateTimer();
                TimerStart(thistype.tickTimer, 0.02, true, function () {
                    integer i; integer last; integer hid; unit u; real timeLeft;

                    // 单次遍历 + 尾部交换，O(n)
                    for (i = 0; i < thistype.size; i += 1) {
                        u = thistype.uList[i];
                        hid = GetHandleId(u);

                        // 检查单位是否有效
                        if (u == null || GetUnitTypeId(u) == 0) {
                            // 单位已失效，尾部交换移除
                            i = thistype.removeAt(i);
                            u = null;
                        } else if (!HaveSavedReal(HASH_UNIT, hid, KEY_IMMUTE_UNIT_TIME_LEFT)) {
                            // 检查哈希中是否还有记录（外部可能已清理）
                            // 外部已清理，移除 Avul 技能（如果还存在）并移出队列
                            if (GetUnitAbilityLevel(u, 'Avul') >= 1) {
                                UnitRemoveAbility(u, 'Avul');
                                // 解绑无敌特效
                                bindEffect.detachUnique(u, IMMUTE_EFFECT_PATH);
                            }
                            i = thistype.removeAt(i);
                            u = null;
                        } else if (GetUnitAbilityLevel(u, 'Avul') < 1) {
                            // 检查单位是否还有无敌技能（如果没有则移出队列）
                            // 无敌技能被外部移除，清理哈希并移出队列
                            RemoveSavedReal(HASH_UNIT, hid, KEY_IMMUTE_UNIT_TIME_LEFT);
                            // 解绑无敌特效
                            bindEffect.detachUnique(u, IMMUTE_EFFECT_PATH);
                            i = thistype.removeAt(i);
                            u = null;
                        } else {
                            // 读取剩余时间
                            timeLeft = LoadReal(HASH_UNIT, hid, KEY_IMMUTE_UNIT_TIME_LEFT);

                            if (timeLeft > 0.0) {
                                // 时间未到，递减
                                timeLeft = timeLeft - 0.02;
                                SaveReal(HASH_UNIT, hid, KEY_IMMUTE_UNIT_TIME_LEFT, timeLeft);
                            } else {
                                // 时间到了（包括 0 秒无敌窗），移除无敌
                                UnitRemoveAbility(u, 'Avul');
                                RemoveSavedReal(HASH_UNIT, hid, KEY_IMMUTE_UNIT_TIME_LEFT);
                                // 解绑无敌特效
                                bindEffect.detachUnique(u, IMMUTE_EFFECT_PATH);
                                // 尾部交换移除当前元素
                                i = thistype.removeAt(i);
                            }

                            u = null;
                        }
                    }

                    // 队列为空时，停止并释放计时器，方便下次懒加载
                    if (thistype.size <= 0 && thistype.tickTimer != null) {
                        PauseTimer(thistype.tickTimer);
                        DestroyTimer(thistype.tickTimer);
                        thistype.tickTimer = null;
                        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
                        if (thistype.size <= 0) {BJDebugMsg("ImmuteQueue: 无敌队列已销毁");}
                        #endif
                    }
                });
            }
        }
    }

    // 能叠加的无敌(计算)
    public function ImmuteDamageTime(unit u, real time, boolean eff) {
        integer hid; real oldTime;

        if (u == null || time < 0.0) { return; }

        hid = GetHandleId(u);

        if (HaveSavedReal(HASH_UNIT, hid, KEY_IMMUTE_UNIT_TIME_LEFT)) {
            // 已存在无敌，取最大值（叠加）
            oldTime = LoadReal(HASH_UNIT, hid, KEY_IMMUTE_UNIT_TIME_LEFT);
            SaveReal(HASH_UNIT, hid, KEY_IMMUTE_UNIT_TIME_LEFT, RMaxBJ(oldTime, time));
        } else {
            // 第一次添加无敌
            UnitAddAbility(u, 'Avul');
            SaveReal(HASH_UNIT, hid, KEY_IMMUTE_UNIT_TIME_LEFT, time);
            ImmuteQueue.addUnit(u);

            // 绑定无敌特效
            bindEffect.attachUnique(u, IMMUTE_EFFECT_PATH, IMMUTE_EFFECT_POINT);

            // 播放特效（如果需要）
            if (eff) {
                DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl", GetUnitX(u), GetUnitY(u)));
            }
        }
    }

    // 只免疫一次无敌（真正的0秒无敌，使用0秒计时器立即移除）
    public function ImmuteDamageOnce(unit u) {
        integer hid; real oldTime; timer t; integer tid;

        if (u == null) { return; }

        hid = GetHandleId(u);

        if (HaveSavedReal(HASH_UNIT, hid, KEY_IMMUTE_UNIT_TIME_LEFT)) {
            // 已存在无敌，不做缩短（保持原值），确保不产生提前移除
            oldTime = LoadReal(HASH_UNIT, hid, KEY_IMMUTE_UNIT_TIME_LEFT);
            if (oldTime < 0.0) {
                // 如果当前时间小于0（不应该发生，但保险起见），设为0
                SaveReal(HASH_UNIT, hid, KEY_IMMUTE_UNIT_TIME_LEFT, 0.0);
            }
            // 否则保持原值，不缩短
        } else {
            // 第一次添加0秒无敌
            UnitAddAbility(u, 'Avul');
            // 双重保险：保存哈希记录（0.0），队列tick也会检查
            SaveReal(HASH_UNIT, hid, KEY_IMMUTE_UNIT_TIME_LEFT, 0.0);
            ImmuteQueue.addUnit(u);

            // 使用0秒计时器立即移除（真正的0秒无敌）
            t = CreateTimer();
            tid = GetHandleId(t);
            SaveUnitHandle(HASH_TIMER, tid, 1, u);
            TimerStart(t, 0.0, false, function () {
                timer t; integer id; integer hid; unit u;

                t = GetExpiredTimer();
                id = GetHandleId(t);
                u = LoadUnitHandle(HASH_TIMER, id, 1);

                if (u != null) {
                    hid = GetHandleId(u);
                    // 移除无敌技能
                    if (GetUnitAbilityLevel(u, 'Avul') >= 1) {
                        UnitRemoveAbility(u, 'Avul');
                    }
                    // 清理哈希记录
                    if (HaveSavedReal(HASH_UNIT, hid, KEY_IMMUTE_UNIT_TIME_LEFT)) {
                        RemoveSavedReal(HASH_UNIT, hid, KEY_IMMUTE_UNIT_TIME_LEFT);
                    }
                }

                // 清理定时器
                FlushChildHashtable(HASH_TIMER, id);
                PauseTimer(t);
                DestroyTimer(t);
                u = null;
                t = null;
            });
            t = null;
        }
    }


}

//! endzinc
#endif
