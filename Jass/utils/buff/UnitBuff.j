#ifndef UnitBuffIncluded
#define UnitBuffIncluded


#include "Crainax/core/constant/JapiConstant.j"
#include "Crainax/core/table/Hash_UnitDefine.j"
#include "YDWEBase.j"
#include "japi/YDWEJapiUnit.j"

//! zinc
/*
单位buff工具库
*/

// 无敌特效路径
#define IMMUTE_EFFECT_PATH "Abilities\\Spells\\Human\\DivineShield\\DivineShieldTarget.mdl"
#define IMMUTE_EFFECT_POINT "origin"

// 破防特效路径
#define DEFENSE_REDUCE_EFFECT_PATH "Abilities\\Spells\\NightElf\\FaerieFire\\FaerieFireTarget.mdl"
#define DEFENSE_REDUCE_EFFECT_POINT "head"

// 沉默/缴械统一使用原生沉默魔法目标特效（db/buff.ini: [BNsi] TargetArt）
#define SILENCE_DISABLE_EFFECT_PATH "Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl"
#define SILENCE_DISABLE_EFFECT_POINT "overhead"

library UnitBuff requires UnitUtils, HashTable, BindEffect, DamageUtils, UnitFilter, GroupUtils {

    private function AttachSilenceDisableEffect(unit u) {
        if (u == null || GetUnitTypeId(u) == 0) { return; }
        bindEffect.attachUnique(u, SILENCE_DISABLE_EFFECT_PATH, SILENCE_DISABLE_EFFECT_POINT);
    }

    private function DetachSilenceDisableEffectIfUnused(unit u) {
        integer hid;

        if (u == null || GetUnitTypeId(u) == 0) { return; }

        hid = GetHandleId(u);
        if (!HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_SILENCE_TIME_LEFT) && !HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_DISARM_EFFECT_TIME_LEFT)) {
            bindEffect.detachUnique(u, SILENCE_DISABLE_EFFECT_PATH);
        }
    }

    private function ApplySilenceNative(unit u) {
        integer hid;

        if (u == null || GetUnitTypeId(u) == 0) { return; }

        hid = GetHandleId(u);
        if (!HaveSavedInteger(HASH_UNIT, hid, KEY_UNIT_SILENCE_NATIVE_ON)) {
            DzUnitSilence(u, true);
            SaveInteger(HASH_UNIT, hid, KEY_UNIT_SILENCE_NATIVE_ON, 1);
        }
    }

    private function ReleaseSilenceNative(unit u) {
        integer hid;

        if (u == null) { return; }

        hid = GetHandleId(u);
        if (HaveSavedInteger(HASH_UNIT, hid, KEY_UNIT_SILENCE_NATIVE_ON)) {
            if (GetUnitTypeId(u) != 0) {
                DzUnitSilence(u, false);
            }
            RemoveSavedInteger(HASH_UNIT, hid, KEY_UNIT_SILENCE_NATIVE_ON);
        }
    }

    // 获取一份底层缴械锁；第一份锁负责实际禁用攻击。
    public function AcquireUnitDisarm(unit u) -> boolean {
        integer hid;
        integer lockCount;

        if (u == null || GetUnitTypeId(u) == 0) { return false; }

        hid = GetHandleId(u);
        lockCount = LoadInteger(HASH_UNIT, hid, KEY_UNIT_DISARM_NATIVE_ON);
        if (lockCount <= 0) {
            DzUnitDisableAttack(u, true);
        }
        SaveInteger(HASH_UNIT, hid, KEY_UNIT_DISARM_NATIVE_ON, lockCount + 1);
        return true;
    }

    // 释放一份底层缴械锁；最后一份锁释放后才恢复攻击。
    public function ReleaseUnitDisarm(unit u) {
        integer hid;
        integer lockCount;

        if (u == null) { return; }

        hid = GetHandleId(u);
        lockCount = LoadInteger(HASH_UNIT, hid, KEY_UNIT_DISARM_NATIVE_ON);
        if (lockCount <= 0) {
            return;
        }
        if (lockCount == 1) {
            if (GetUnitTypeId(u) != 0) {
                DzUnitDisableAttack(u, false);
            }
            RemoveSavedInteger(HASH_UNIT, hid, KEY_UNIT_DISARM_NATIVE_ON);
        } else {
            SaveInteger(HASH_UNIT, hid, KEY_UNIT_DISARM_NATIVE_ON, lockCount - 1);
        }
    }

    private function GetEXPauseLockCount(unit u, integer key) -> integer {
        integer hid;

        if (u == null) { return 0; }

        hid = GetHandleId(u);
        if (!HaveSavedInteger(HASH_UNIT, hid, key)) { return 0; }
        return LoadInteger(HASH_UNIT, hid, key);
    }

    private function HasAnyEXPauseLock(unit u) -> boolean {
        if (u == null) { return false; }

        if (GetEXPauseLockCount(u, KEY_UNIT_EX_PAUSE_LOCK_STUN) > 0) { return true; }
        if (GetEXPauseLockCount(u, KEY_UNIT_EX_PAUSE_LOCK_PRECAST) > 0) { return true; }
        if (GetEXPauseLockCount(u, KEY_UNIT_EX_PAUSE_LOCK_TIMED_PRECAST) > 0) { return true; }
        return false;
    }

    private function ApplyEXPauseLock(unit u, integer key) {
        integer hid; integer count; boolean wasLocked;

        if (u == null || GetUnitTypeId(u) == 0) { return; }

        hid = GetHandleId(u);
        wasLocked = HasAnyEXPauseLock(u);
        count = GetEXPauseLockCount(u, key);
        SaveInteger(HASH_UNIT, hid, key, count + 1);

        if (!wasLocked) {
            EXPauseUnit(u, true);
        }
    }

    private function ReleaseEXPauseLock(unit u, integer key) {
        integer hid; integer count;

        if (u == null) { return; }

        hid = GetHandleId(u);
        count = GetEXPauseLockCount(u, key);
        if (count <= 0) { return; }

        if (count <= 1) {
            RemoveSavedInteger(HASH_UNIT, hid, key);
        } else {
            SaveInteger(HASH_UNIT, hid, key, count - 1);
        }

        if (GetUnitTypeId(u) != 0 && !HasAnyEXPauseLock(u)) {
            EXPauseUnit(u, false);
        }
    }

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
                DisplayImportantTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, "|cFFFF0000[ImmuteQueue] 队列已满，无法继续添加无敌单位！|r");
                return;
            }

            // 加入队列
            thistype.uList[thistype.size] = u;
            thistype.size += 1;

            // 确保定时器运行
            if (thistype.tickTimer == null) {
                thistype.tickTimer = CreateTimer();
                TimerStart(thistype.tickTimer, 0.05, true, function () {
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
                        } else if (!HaveSavedReal(HASH_UNIT, hid, HASH_UNIT_IMMUTE_TIME_LEFT)) {
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
                            RemoveSavedReal(HASH_UNIT, hid, HASH_UNIT_IMMUTE_TIME_LEFT);
                            // 解绑无敌特效
                            bindEffect.detachUnique(u, IMMUTE_EFFECT_PATH);
                            i = thistype.removeAt(i);
                            u = null;
                        } else {
                            // 读取剩余时间
                            timeLeft = LoadReal(HASH_UNIT, hid, HASH_UNIT_IMMUTE_TIME_LEFT);

                            if (timeLeft > 0.0) {
                                // 时间未到，递减
                                timeLeft = timeLeft - 0.05;
                                SaveReal(HASH_UNIT, hid, HASH_UNIT_IMMUTE_TIME_LEFT, timeLeft);
                            } else {
                                // 时间到了（包括 0 秒无敌窗），移除无敌
                                UnitRemoveAbility(u, 'Avul');
                                RemoveSavedReal(HASH_UNIT, hid, HASH_UNIT_IMMUTE_TIME_LEFT);
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

    // 眩晕队列：集中管理处于眩晕中的单位
    private struct PauseQueue [] {
        private static unit uList[];
        private static integer size = 0;
        private static timer tickTimer = null;

        // 尾部交换移除指定索引（注意：解除暂停与清理也统一在这里做，避免循环里频繁设置）
        private static method removeAt(integer index) -> integer {
            integer last; unit ru; integer hid; string effx;
            if (index < 0 || index >= thistype.size) { return index; }

            // 先取出要移除的单位（必须在交换前拿到）
            ru = thistype.uList[index];

            // 统一做清理/解除暂停：只在移除时做一次
            if (ru != null) {
                hid = GetHandleId(ru);

                if (HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_PAUSE_TIME_LEFT)) {
                    RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_PAUSE_TIME_LEFT);
                }

                if (HaveSavedString(HASH_UNIT, hid, KEY_UNIT_PAUSE_EFFX)) {
                    effx = LoadStr(HASH_UNIT, hid, KEY_UNIT_PAUSE_EFFX);
                    if (effx != "") {
                        bindEffect.detachUnique(ru, effx);
                    }
                    RemoveSavedString(HASH_UNIT, hid, KEY_UNIT_PAUSE_EFFX);
                    effx = "";
                }

                if (HaveSavedString(HASH_UNIT, hid, KEY_UNIT_PAUSE_LOC)) {
                    RemoveSavedString(HASH_UNIT, hid, KEY_UNIT_PAUSE_LOC);
                }

                ReleaseEXPauseLock(ru, KEY_UNIT_EX_PAUSE_LOCK_STUN);
                // BJDebugMsg(I2S(GetHandleId(ru))+"pause:false");
            }

            last = thistype.size - 1;
            if (index != last) {
                thistype.uList[index] = thistype.uList[last];
            }
            thistype.uList[last] = null;
            thistype.size -= 1;
            ru = null;
            return index - 1;
        }

        // 将单位加入队列（若不在队列）
        public static method addUnit(unit u) {
            integer i;
            if (u == null) { return; }

            for (i = 0; i < thistype.size; i += 1) {
                if (thistype.uList[i] == u) { return; }
            }

            if (thistype.size >= 8190) {
                DisplayImportantTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, "|cFFFF0000[PauseQueue] 队列已满，无法继续添加眩晕单位！|r");
                return;
            }

            thistype.uList[thistype.size] = u;
            thistype.size += 1;

            if (thistype.tickTimer == null) {
                thistype.tickTimer = CreateTimer();
                TimerStart(thistype.tickTimer, 0.02, true, function () {
                    integer i; integer hid; unit u; real timeLeft;

                    for (i = 0; i < thistype.size; i += 1) {
                        u = thistype.uList[i];
                        if (u == null || GetUnitTypeId(u) == 0 || !IsUnitAliveBJ(u)) {
                            // 单位无效：移出（解除暂停与清理都在 removeAt 内做）
                            i = thistype.removeAt(i);
                            u = null;
                        } else {
                            hid = GetHandleId(u);
                            if (!HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_PAUSE_TIME_LEFT)) {
                                // 外部已清理：直接移出（解除暂停与清理都在 removeAt 内做）
                                i = thistype.removeAt(i);
                                u = null;
                            } else {
                                timeLeft = LoadReal(HASH_UNIT, hid, KEY_UNIT_PAUSE_TIME_LEFT);
                                if (timeLeft > 0.0) {
                                    timeLeft = timeLeft - 0.02;
                                    SaveReal(HASH_UNIT, hid, KEY_UNIT_PAUSE_TIME_LEFT, timeLeft);
                                    u = null;
                                } else {
                                    // 到期：移出（解除暂停与清理都在 removeAt 内做）
                                    i = thistype.removeAt(i);
                                    u = null;
                                }
                            }
                        }
                    }

                    if (thistype.size <= 0 && thistype.tickTimer != null) {
                        PauseTimer(thistype.tickTimer);
                        DestroyTimer(thistype.tickTimer);
                        thistype.tickTimer = null;
                        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
                        if (thistype.size <= 0) {BJDebugMsg("PauseQueue: 眩晕队列已销毁");}
                        #endif
                    }
                });
            }
        }
    }


    // 前摇暂停队列：只管理限时前摇锁，不进入眩晕抗性/CD/异常状态
    private struct PrecastPauseQueue [] {
        private static unit uList[];
        private static integer size = 0;
        private static timer tickTimer = null;

        private static method removeAt(integer index) -> integer {
            integer last; unit ru; integer hid;
            if (index < 0 || index >= thistype.size) { return index; }

            ru = thistype.uList[index];
            if (ru != null) {
                hid = GetHandleId(ru);
                if (HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_EX_PAUSE_PRECAST_TIME_LEFT)) {
                    RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_EX_PAUSE_PRECAST_TIME_LEFT);
                }
                ReleaseEXPauseLock(ru, KEY_UNIT_EX_PAUSE_LOCK_TIMED_PRECAST);
            }

            last = thistype.size - 1;
            if (index != last) {
                thistype.uList[index] = thistype.uList[last];
            }
            thistype.uList[last] = null;
            thistype.size -= 1;
            ru = null;
            return index - 1;
        }

        public static method addUnit(unit u) {
            integer i;
            if (u == null) { return; }

            for (i = 0; i < thistype.size; i += 1) {
                if (thistype.uList[i] == u) { return; }
            }

            if (thistype.size >= 8190) {
                DisplayImportantTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, "|cFFFF0000[PrecastPauseQueue] 队列已满，无法继续添加前摇暂停单位！|r");
                return;
            }

            thistype.uList[thistype.size] = u;
            thistype.size += 1;

            if (thistype.tickTimer == null) {
                thistype.tickTimer = CreateTimer();
                TimerStart(thistype.tickTimer, 0.02, true, function () {
                    integer i; integer hid; unit u; real timeLeft;

                    for (i = 0; i < thistype.size; i += 1) {
                        u = thistype.uList[i];
                        if (u == null || GetUnitTypeId(u) == 0 || !IsUnitAliveBJ(u)) {
                            i = thistype.removeAt(i);
                            u = null;
                        } else {
                            hid = GetHandleId(u);
                            if (!HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_EX_PAUSE_PRECAST_TIME_LEFT)) {
                                i = thistype.removeAt(i);
                                u = null;
                            } else {
                                timeLeft = LoadReal(HASH_UNIT, hid, KEY_UNIT_EX_PAUSE_PRECAST_TIME_LEFT);
                                if (timeLeft > 0.0) {
                                    timeLeft = timeLeft - 0.02;
                                    SaveReal(HASH_UNIT, hid, KEY_UNIT_EX_PAUSE_PRECAST_TIME_LEFT, timeLeft);
                                    u = null;
                                } else {
                                    i = thistype.removeAt(i);
                                    u = null;
                                }
                            }
                        }
                    }

                    if (thistype.size <= 0 && thistype.tickTimer != null) {
                        PauseTimer(thistype.tickTimer);
                        DestroyTimer(thistype.tickTimer);
                        thistype.tickTimer = null;
                        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
                        if (thistype.size <= 0) {BJDebugMsg("PrecastPauseQueue: 前摇暂停队列已销毁");}
                        #endif
                    }
                });
            }
        }
    }


    // 眩晕CD队列：集中管理处于“眩晕CD”中的单位（独立计时器，仅递减 KEY_UNIT_STUN_CD_LEFT）
    private struct StunCdQueue [] {
        private static unit uList[];
        private static integer size = 0;
        private static timer tickTimer = null;

        // 尾部交换移除指定索引
        private static method removeAt(integer index) -> integer {
            integer last;
            if (index < 0 || index >= thistype.size) { return index; }
            last = thistype.size - 1;
            if (index != last) {
                thistype.uList[index] = thistype.uList[last];
            }
            thistype.uList[last] = null;
            thistype.size -= 1;
            return index - 1;
        }

        // 将单位加入队列（若不在队列）
        public static method addUnit(unit u) {
            integer i;
            if (u == null) { return; }

            for (i = 0; i < thistype.size; i += 1) {
                if (thistype.uList[i] == u) { return; }
            }

            if (thistype.size >= 8190) {
                DisplayImportantTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, "|cFFFF0000[StunCdQueue] 队列已满，无法继续添加眩晕CD单位！|r");
                return;
            }

            thistype.uList[thistype.size] = u;
            thistype.size += 1;

            if (thistype.tickTimer == null) {
                thistype.tickTimer = CreateTimer();
                TimerStart(thistype.tickTimer, 0.05, true, function () {
                    integer i; integer hid; unit u; real cdLeft;

                    for (i = 0; i < thistype.size; i += 1) {
                        u = thistype.uList[i];
                        if (u == null || GetUnitTypeId(u) == 0) {
                            // 单位无效：清理CD并移出
                            if (u != null) {
                                hid = GetHandleId(u);
                                if (HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_STUN_CD_LEFT)) {
                                    RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_STUN_CD_LEFT);
                                }
                            }
                            i = thistype.removeAt(i);
                            u = null;
                        } else {
                            hid = GetHandleId(u);
                            if (!HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_STUN_CD_LEFT)) {
                                // 外部已清理CD：移出
                                i = thistype.removeAt(i);
                                u = null;
                            } else {
                                cdLeft = LoadReal(HASH_UNIT, hid, KEY_UNIT_STUN_CD_LEFT);
                                if (cdLeft > 0.0) {
                                    cdLeft = cdLeft - 0.05;
                                    SaveReal(HASH_UNIT, hid, KEY_UNIT_STUN_CD_LEFT, cdLeft);
                                    u = null;
                                } else {
                                    // CD到期：清理并移出
                                    RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_STUN_CD_LEFT);
                                    i = thistype.removeAt(i);
                                    u = null;
                                }
                            }
                        }
                    }

                    if (thistype.size <= 0 && thistype.tickTimer != null) {
                        PauseTimer(thistype.tickTimer);
                        DestroyTimer(thistype.tickTimer);
                        thistype.tickTimer = null;
                        // #if (CURRENT_BUILD_VERSION != VERSION_RELEASE)
                        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
                        if (thistype.size <= 0) {BJDebugMsg("StunCdQueue: 眩晕CD队列已销毁");}
                        #endif
                    }
                });
            }
        }
    }

    // 沉默队列：集中管理禁用技能状态，到期后自动恢复
    private struct SilenceQueue [] {
        private static unit uList[];
        private static integer size = 0;
        private static timer tickTimer = null;

        private static method removeAt(integer index) -> integer {
            integer last; unit ru; integer hid;
            if (index < 0 || index >= thistype.size) { return index; }

            ru = thistype.uList[index];
            if (ru != null) {
                hid = GetHandleId(ru);
                if (HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_SILENCE_TIME_LEFT)) {
                    RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_SILENCE_TIME_LEFT);
                }
                ReleaseSilenceNative(ru);
                DetachSilenceDisableEffectIfUnused(ru);
            }

            last = thistype.size - 1;
            if (index != last) {
                thistype.uList[index] = thistype.uList[last];
            }
            thistype.uList[last] = null;
            thistype.size -= 1;
            ru = null;
            return index - 1;
        }

        public static method addUnit(unit u) {
            integer i;
            if (u == null) { return; }

            for (i = 0; i < thistype.size; i += 1) {
                if (thistype.uList[i] == u) { return; }
            }

            if (thistype.size >= 8190) {
                DisplayImportantTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, "|cFFFF0000[SilenceQueue] 队列已满，无法继续添加沉默单位！|r");
                return;
            }

            thistype.uList[thistype.size] = u;
            thistype.size += 1;

            if (thistype.tickTimer == null) {
                thistype.tickTimer = CreateTimer();
                TimerStart(thistype.tickTimer, 0.05, true, function () {
                    integer i; integer hid; unit u; real timeLeft;

                    for (i = 0; i < thistype.size; i += 1) {
                        u = thistype.uList[i];
                        if (u == null || GetUnitTypeId(u) == 0 || !IsUnitAliveBJ(u)) {
                            i = thistype.removeAt(i);
                            u = null;
                        } else {
                            hid = GetHandleId(u);
                            if (!HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_SILENCE_TIME_LEFT)) {
                                i = thistype.removeAt(i);
                                u = null;
                            } else {
                                timeLeft = LoadReal(HASH_UNIT, hid, KEY_UNIT_SILENCE_TIME_LEFT);
                                if (timeLeft > 0.0) {
                                    timeLeft = timeLeft - 0.05;
                                    SaveReal(HASH_UNIT, hid, KEY_UNIT_SILENCE_TIME_LEFT, timeLeft);
                                    u = null;
                                } else {
                                    i = thistype.removeAt(i);
                                    u = null;
                                }
                            }
                        }
                    }

                    if (thistype.size <= 0 && thistype.tickTimer != null) {
                        PauseTimer(thistype.tickTimer);
                        DestroyTimer(thistype.tickTimer);
                        thistype.tickTimer = null;
                        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
                        if (thistype.size <= 0) {BJDebugMsg("SilenceQueue: 沉默队列已销毁");}
                        #endif
                    }
                });
            }
        }
    }

    // 缴械队列：集中管理禁用攻击状态，到期后自动恢复
    private struct DisarmQueue [] {
        private static unit uList[];
        private static integer size = 0;
        private static timer tickTimer = null;

        private static method removeAt(integer index) -> integer {
            integer last; unit ru; integer hid;
            boolean hadTimedDisarm;
            if (index < 0 || index >= thistype.size) { return index; }

            ru = thistype.uList[index];
            if (ru != null) {
                hid = GetHandleId(ru);
                hadTimedDisarm = HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_DISARM_TIME_LEFT);
                if (HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_DISARM_TIME_LEFT)) {
                    RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_DISARM_TIME_LEFT);
                }
                if (HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_DISARM_EFFECT_TIME_LEFT)) {
                    RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_DISARM_EFFECT_TIME_LEFT);
                }
                if (hadTimedDisarm) {
                    ReleaseUnitDisarm(ru);
                }
                DetachSilenceDisableEffectIfUnused(ru);
            }

            last = thistype.size - 1;
            if (index != last) {
                thistype.uList[index] = thistype.uList[last];
            }
            thistype.uList[last] = null;
            thistype.size -= 1;
            ru = null;
            return index - 1;
        }

        public static method addUnit(unit u) {
            integer i;
            if (u == null) { return; }

            for (i = 0; i < thistype.size; i += 1) {
                if (thistype.uList[i] == u) { return; }
            }

            if (thistype.size >= 8190) {
                DisplayImportantTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, "|cFFFF0000[DisarmQueue] 队列已满，无法继续添加缴械单位！|r");
                return;
            }

            thistype.uList[thistype.size] = u;
            thistype.size += 1;

            if (thistype.tickTimer == null) {
                thistype.tickTimer = CreateTimer();
                TimerStart(thistype.tickTimer, 0.05, true, function () {
                    integer i; integer hid; unit u; real timeLeft; real effectTimeLeft;

                    for (i = 0; i < thistype.size; i += 1) {
                        u = thistype.uList[i];
                        if (u == null || GetUnitTypeId(u) == 0 || !IsUnitAliveBJ(u)) {
                            i = thistype.removeAt(i);
                            u = null;
                        } else {
                            hid = GetHandleId(u);
                            if (!HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_DISARM_TIME_LEFT)) {
                                i = thistype.removeAt(i);
                                u = null;
                            } else {
                                timeLeft = LoadReal(HASH_UNIT, hid, KEY_UNIT_DISARM_TIME_LEFT);
                                if (timeLeft > 0.0) {
                                    timeLeft = timeLeft - 0.05;
                                    SaveReal(HASH_UNIT, hid, KEY_UNIT_DISARM_TIME_LEFT, timeLeft);
                                    if (HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_DISARM_EFFECT_TIME_LEFT)) {
                                        effectTimeLeft = LoadReal(HASH_UNIT, hid, KEY_UNIT_DISARM_EFFECT_TIME_LEFT) - 0.05;
                                        if (effectTimeLeft > 0.0) {
                                            SaveReal(HASH_UNIT, hid, KEY_UNIT_DISARM_EFFECT_TIME_LEFT, effectTimeLeft);
                                        } else {
                                            RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_DISARM_EFFECT_TIME_LEFT);
                                            DetachSilenceDisableEffectIfUnused(u);
                                        }
                                    }
                                    u = null;
                                } else {
                                    i = thistype.removeAt(i);
                                    u = null;
                                }
                            }
                        }
                    }

                    if (thistype.size <= 0 && thistype.tickTimer != null) {
                        PauseTimer(thistype.tickTimer);
                        DestroyTimer(thistype.tickTimer);
                        thistype.tickTimer = null;
                        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
                        if (thistype.size <= 0) {BJDebugMsg("DisarmQueue: 缴械队列已销毁");}
                        #endif
                    }
                });
            }
        }
    }

    // TimerBuff 队列：集中管理所有定时器 BUFF
    public struct TimerBuffQueue [] {
        private static timer timers[];      // timer 列表（每个 BUFF 的独立 timer）
        private static unit units[];        // 单位列表
        private static real lefts[];        // 剩余时间列表
        private static integer size = 0;    // 当前元素数量
        private static timer tickTimer = null; // 驱动队列的定时器
        static timer expireTimer = null;

        //回调
        public static method getExpireTimer ()  -> timer {
            return expireTimer;
        }

        // 尾部交换移除指定索引的元素（完全清理，包括销毁资源）
        private static method removeAt(integer index) -> integer {
            integer last; timer buffT; trigger cbTr; integer tid;
            if (index < 0 || index >= thistype.size) { return index; }

            // 获取要移除的元素
            buffT = thistype.timers[index];
            tid = GetHandleId(buffT);

            // 清理回调 trigger（改为使用 HASH_TIMER）
            if (HaveSavedHandle(HASH_TIMER, tid, 1)) {
                cbTr = LoadTriggerHandle(HASH_TIMER, tid, 1);
                if (cbTr != null) {
                    DestroyTrigger(cbTr);
                    cbTr = null;
                }
                // FlushChildHashtable 会清理所有数据，不需要单独 RemoveSavedHandle
            }

            // 清理外部 HASH_TIMER 数据（包括 trigger）
            FlushChildHashtable(HASH_TIMER, tid);

            // 销毁 timer
            if (buffT != null) {
                PauseTimer(buffT);
                DestroyTimer(buffT);
                buffT = null;
            }

            // 尾部交换
            last = thistype.size - 1;
            if (index != last) {
                thistype.timers[index] = thistype.timers[last];
                thistype.units[index] = thistype.units[last];
                thistype.lefts[index] = thistype.lefts[last];
            }
            thistype.timers[last] = null;
            thistype.units[last] = null;
            thistype.lefts[last] = 0.0;
            thistype.size -= 1;

            return index - 1;
        }

        // 添加定时器 BUFF
        public static method add(unit u, real time, code fun) -> timer {
            timer buffT; trigger cbTr; integer tid;

            if (u == null || time <= 0.0 || fun == null) { return null; }

            // 检查队列容量
            if (thistype.size >= 8190) {
                DisplayImportantTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, "|cFFFF0000[TimerBuffQueue] 队列已满，无法继续添加定时器 BUFF！|r");
                return null;
            }

            // 创建独立的 timer（供外部存参和回调时 GetExpiredTimer 使用）
            buffT = CreateTimer();
            tid = GetHandleId(buffT);

            // 创建回调 trigger 并绑定 fun（改为使用 HASH_TIMER）
            cbTr = CreateTrigger();
            TriggerAddCondition(cbTr, Condition(fun));
            SaveTriggerHandle(HASH_TIMER, tid, 1, cbTr);
            cbTr = null;

            // 加入队列
            thistype.timers[thistype.size] = buffT;
            thistype.units[thistype.size] = u;
            thistype.lefts[thistype.size] = time;
            thistype.size += 1;

            // 确保定时器运行
            if (thistype.tickTimer == null) {
                thistype.tickTimer = CreateTimer();
                TimerStart(thistype.tickTimer, 0.05, true, function () {
                    integer i; timer buffT; unit u; real timeLeft; trigger cbTr; integer tid;

                    // 单次遍历 + 尾部交换，O(n)
                    for (i = 0; i < thistype.size; i += 1) {
                        buffT = thistype.timers[i];
                        u = thistype.units[i];
                        timeLeft = thistype.lefts[i];

                        // 检查单位是否有效
                        if (u == null || GetUnitTypeId(u) == 0) {
                            // 单位不存在，直接清理该 BUFF（不调用回调）
                            i = thistype.removeAt(i);
                            u = null;
                            buffT = null;
                        } else if (!IsUnitAliveBJ(u)) {
                            // 单位死亡，调用回调后清理
                            tid = GetHandleId(buffT);

                            // 执行回调（改为使用 HASH_TIMER）
                            if (HaveSavedHandle(HASH_TIMER, tid, 1)) {
                                cbTr = LoadTriggerHandle(HASH_TIMER, tid, 1);
                                if (cbTr != null) {
                                    expireTimer = buffT;
                                    TriggerEvaluate(cbTr);
                                    DestroyTrigger(cbTr);
                                    cbTr = null;
                                    expireTimer = null;
                                }
                                // FlushChildHashtable 会清理所有数据，不需要单独 RemoveSavedHandle
                            }

                            i = thistype.removeAt(i);
                            u = null;
                            buffT = null;
                        } else {
                            // 递减剩余时间
                            timeLeft = timeLeft - 0.05;

                            if (timeLeft <= 0.0) {
                                // 时间到了，先从队列移除（不销毁资源）
                                tid = GetHandleId(buffT);

                                // 执行回调（改为使用 HASH_TIMER）
                                if (HaveSavedHandle(HASH_TIMER, tid, 1)) {
                                    cbTr = LoadTriggerHandle(HASH_TIMER, tid, 1);
                                    if (cbTr != null) {
                                        expireTimer = buffT;
                                        TriggerEvaluate(cbTr);
                                        DestroyTrigger(cbTr);
                                        cbTr = null;
                                        expireTimer = null;
                                    }
                                    // FlushChildHashtable 会清理所有数据，不需要单独 RemoveSavedHandle
                                }

                                i = thistype.removeAt(i);

                                u = null;
                                buffT = null;
                            } else {
                                // 更新剩余时间
                                thistype.lefts[i] = timeLeft;
                                u = null;
                                buffT = null;
                            }
                        }
                    }

                    // 队列为空时，停止并释放计时器
                    if (thistype.size <= 0 && thistype.tickTimer != null) {
                        PauseTimer(thistype.tickTimer);
                        DestroyTimer(thistype.tickTimer);
                        thistype.tickTimer = null;
                        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
                        if (thistype.size <= 0) {BJDebugMsg("TimerBuffQueue: 定时器 BUFF 队列已销毁");}
                        #endif
                    }
                });
            }

            return buffT;
        }
    }

    // 能叠加的无敌(计算)
    public function ImmuteDamageTime(unit u, real time, boolean eff) {
        integer hid; real oldTime;

        if (u == null || time < 0.0) { return; }

        hid = GetHandleId(u);

        if (HaveSavedReal(HASH_UNIT, hid, HASH_UNIT_IMMUTE_TIME_LEFT)) {
            // 已存在无敌，取最大值（叠加）
            oldTime = LoadReal(HASH_UNIT, hid, HASH_UNIT_IMMUTE_TIME_LEFT);
            SaveReal(HASH_UNIT, hid, HASH_UNIT_IMMUTE_TIME_LEFT, RMaxBJ(oldTime, time));
        } else {
            // 第一次添加无敌
            UnitAddAbility(u, 'Avul');
            SaveReal(HASH_UNIT, hid, HASH_UNIT_IMMUTE_TIME_LEFT, time);
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

        if (HaveSavedReal(HASH_UNIT, hid, HASH_UNIT_IMMUTE_TIME_LEFT)) {
            // 已存在无敌，不做缩短（保持原值），确保不产生提前移除
            oldTime = LoadReal(HASH_UNIT, hid, HASH_UNIT_IMMUTE_TIME_LEFT);
            if (oldTime < 0.0) {
                // 如果当前时间小于0（不应该发生，但保险起见），设为0
                SaveReal(HASH_UNIT, hid, HASH_UNIT_IMMUTE_TIME_LEFT, 0.0);
            }
            // 否则保持原值，不缩短
        } else {
            // 第一次添加0秒无敌
            UnitAddAbility(u, 'Avul');
            // 双重保险：保存哈希记录（0.0），队列tick也会检查
            SaveReal(HASH_UNIT, hid, HASH_UNIT_IMMUTE_TIME_LEFT, 0.0);
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
                    if (HaveSavedReal(HASH_UNIT, hid, HASH_UNIT_IMMUTE_TIME_LEFT)) {
                        RemoveSavedReal(HASH_UNIT, hid, HASH_UNIT_IMMUTE_TIME_LEFT);
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

    private function GetDefenseDownPercentSourceParent(integer hid, integer sourceType) -> integer {
        return StringHash("UnitBuffDefenseDownPercent:" + I2S(hid) + ":" + I2S(sourceType));
    }

    private function GetDefenseDownPercentTimerParent(integer hid, integer sourceType, integer instanceId) -> integer {
        return StringHash("UnitBuffDefenseDownPercentTimer:" + I2S(hid) + ":" + I2S(sourceType) + ":" + I2S(instanceId));
    }

    private function AttachDefenseDownPercentEffect(unit u) {
        integer hid; integer count;

        if (u == null || GetUnitTypeId(u) == 0) { return; }

        hid = GetHandleId(u);
        count = LoadInteger(HASH_UNIT, hid, KEY_UNIT_DEFENSE_DOWN_PERCENT_ACTIVE_COUNT);
        if (count <= 0) {
            bindEffect.attachUnique(u, DEFENSE_REDUCE_EFFECT_PATH, DEFENSE_REDUCE_EFFECT_POINT);
            count = 0;
        }
        SaveInteger(HASH_UNIT, hid, KEY_UNIT_DEFENSE_DOWN_PERCENT_ACTIVE_COUNT, count + 1);
    }

    private function DetachDefenseDownPercentEffect(unit u) {
        integer hid; integer count;

        if (u == null) { return; }

        hid = GetHandleId(u);
        count = LoadInteger(HASH_UNIT, hid, KEY_UNIT_DEFENSE_DOWN_PERCENT_ACTIVE_COUNT);
        if (count <= 1) {
            RemoveSavedInteger(HASH_UNIT, hid, KEY_UNIT_DEFENSE_DOWN_PERCENT_ACTIVE_COUNT);
            if (GetUnitTypeId(u) != 0) {
                bindEffect.detachUnique(u, DEFENSE_REDUCE_EFFECT_PATH);
            }
        } else {
            SaveInteger(HASH_UNIT, hid, KEY_UNIT_DEFENSE_DOWN_PERCENT_ACTIVE_COUNT, count - 1);
        }
    }

    private function FindDefenseDownPercentInstance(integer sourceParent, integer instanceId) -> integer {
        integer count; integer i; integer found;

        count = LoadInteger(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_COUNT);
        i = 1;
        found = 0;
        while (i <= count && found == 0) {
            if (LoadInteger(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_ID_BASE + i) == instanceId) {
                found = i;
            }
            i += 1;
        }
        return found;
    }

    private function RecalcDefenseDownPercentSource(unit u, integer sourceType) {
        integer hid; integer sourceParent; integer count; integer i;
        real oldRate; real newRate; real rate;

        if (u == null || sourceType <= 0) { return; }

        hid = GetHandleId(u);
        sourceParent = GetDefenseDownPercentSourceParent(hid, sourceType);
        count = LoadInteger(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_COUNT);
        oldRate = 0.0;
        newRate = 0.0;

        if (HaveSavedReal(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_APPLIED_RATE)) {
            oldRate = LoadReal(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_APPLIED_RATE);
        }

        for (1 <= i <= count) {
            if (HaveSavedReal(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_RATE_BASE + i)) {
                rate = LoadReal(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_RATE_BASE + i);
                if (rate > newRate) {
                    newRate = rate;
                }
            }
        }

        if (RAbsBJ(oldRate - newRate) > 0.0001) {
            if (oldRate > 0.0) {
                if (GetUnitTypeId(u) != 0) {
                    AddUnitDefenseDownPercent(u, -oldRate);
                }
                if (newRate <= 0.0) {
                    DetachDefenseDownPercentEffect(u);
                }
            } else if (newRate > 0.0) {
                AttachDefenseDownPercentEffect(u);
            }

            if (newRate > 0.0) {
                if (GetUnitTypeId(u) != 0) {
                    AddUnitDefenseDownPercent(u, newRate);
                }
                SaveReal(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_APPLIED_RATE, newRate);
            } else {
                RemoveSavedReal(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_APPLIED_RATE);
            }
        }

        if (count <= 0 && newRate <= 0.0) {
            FlushChildHashtable(HASH_UNIT, sourceParent);
        }
    }

    private function RemoveDefenseDownPercentSourceInstance(unit u, integer sourceType, integer instanceId) {
        integer hid; integer sourceParent; integer count; integer index; integer lastId; real lastRate;

        if (u == null || sourceType <= 0) { return; }

        hid = GetHandleId(u);
        sourceParent = GetDefenseDownPercentSourceParent(hid, sourceType);
        count = LoadInteger(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_COUNT);
        index = FindDefenseDownPercentInstance(sourceParent, instanceId);

        if (index > 0) {
            if (index != count) {
                lastId = LoadInteger(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_ID_BASE + count);
                lastRate = LoadReal(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_RATE_BASE + count);
                SaveInteger(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_ID_BASE + index, lastId);
                SaveReal(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_RATE_BASE + index, lastRate);
            }
            RemoveSavedInteger(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_ID_BASE + count);
            RemoveSavedReal(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_RATE_BASE + count);
            count -= 1;
            if (count > 0) {
                SaveInteger(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_COUNT, count);
            } else {
                RemoveSavedInteger(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_COUNT);
            }
            RecalcDefenseDownPercentSource(u, sourceType);
        }
    }

    // 设置来源型百分比破防。
    // 同 sourceType 只取最高实例值，不同 sourceType 通过 AddUnitDefenseDownPercent/RealAdd 叠加；rate <= 0 会清除该实例。
    public function ApplyDefenseDownPercentSource(unit u, integer sourceType, integer instanceId, real rate) {
        integer hid; integer sourceParent; integer count; integer index;

        if (u == null || sourceType <= 0) { return; }
        if (rate <= 0.0) {
            RemoveDefenseDownPercentSourceInstance(u, sourceType, instanceId);
            return;
        }
        if (rate >= 1.0) {
            rate = 0.999;
        }
        if (!IsUnitAliveBJ(u)) { return; }

        hid = GetHandleId(u);
        sourceParent = GetDefenseDownPercentSourceParent(hid, sourceType);
        index = FindDefenseDownPercentInstance(sourceParent, instanceId);
        if (index == 0) {
            count = LoadInteger(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_COUNT) + 1;
            SaveInteger(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_COUNT, count);
            index = count;
            SaveInteger(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_ID_BASE + index, instanceId);
        }
        SaveReal(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_RATE_BASE + index, rate);
        RecalcDefenseDownPercentSource(u, sourceType);
    }

    // 清除一个来源型百分比破防实例；清除后同 sourceType 会回落到剩余实例中的最高 rate。
    public function ClearDefenseDownPercentSource(unit u, integer sourceType, integer instanceId) {
        RemoveDefenseDownPercentSourceInstance(u, sourceType, instanceId);
    }

    // 限时来源型百分比破防。
    // 重复调用同 sourceType + instanceId 时刷新最大剩余时间，并保留当前较高 rate，过期后自动清除该实例。
    public function ReduceDefenseDownPercentTime(unit u, integer sourceType, integer instanceId, real rate, real remainTime) {
        integer hid; integer sourceParent; integer index; integer timeParent; real oldRate; real oldTime; timer t; integer tid;

        if (u == null || !IsUnitAliveBJ(u)) { return; }
        if (sourceType <= 0 || remainTime <= 0.0) { return; }
        if (rate <= 0.0) { return; }

        hid = GetHandleId(u);
        sourceParent = GetDefenseDownPercentSourceParent(hid, sourceType);
        index = FindDefenseDownPercentInstance(sourceParent, instanceId);
        if (index > 0 && HaveSavedReal(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_RATE_BASE + index)) {
            oldRate = LoadReal(HASH_UNIT, sourceParent, KEY_UNIT_DEFENSE_DOWN_PERCENT_INSTANCE_RATE_BASE + index);
            if (oldRate > rate) {
                rate = oldRate;
            }
        }
        ApplyDefenseDownPercentSource(u, sourceType, instanceId, rate);

        timeParent = GetDefenseDownPercentTimerParent(hid, sourceType, instanceId);
        if (HaveSavedReal(HASH_UNIT, timeParent, 2)) {
            oldTime = LoadReal(HASH_UNIT, timeParent, 2);
            SaveReal(HASH_UNIT, timeParent, 2, RMaxBJ(oldTime, remainTime));
        } else {
            SaveReal(HASH_UNIT, timeParent, 2, remainTime);
        }

        if (!HaveSavedHandle(HASH_UNIT, timeParent, 1)) {
            t = CreateTimer();
            tid = GetHandleId(t);
            SaveTimerHandle(HASH_UNIT, timeParent, 1, t);
            SaveUnitHandle(HASH_TIMER, tid, 1, u);
            SaveInteger(HASH_TIMER, tid, 2, sourceType);
            SaveInteger(HASH_TIMER, tid, 3, instanceId);
            SaveInteger(HASH_TIMER, tid, 4, timeParent);
            TimerStart(t, 0.10, true, function () {
                timer t; integer tid; integer sourceType; integer instanceId; integer timeParent; unit u; real timeLeft;

                t = GetExpiredTimer();
                tid = GetHandleId(t);
                u = LoadUnitHandle(HASH_TIMER, tid, 1);
                sourceType = LoadInteger(HASH_TIMER, tid, 2);
                instanceId = LoadInteger(HASH_TIMER, tid, 3);
                timeParent = LoadInteger(HASH_TIMER, tid, 4);

                if (u == null || GetUnitTypeId(u) == 0 || !IsUnitAliveBJ(u)) {
                    if (u != null) {
                        ClearDefenseDownPercentSource(u, sourceType, instanceId);
                    }
                    FlushChildHashtable(HASH_UNIT, timeParent);
                    FlushChildHashtable(HASH_TIMER, tid);
                    PauseTimer(t);
                    DestroyTimer(t);
                    u = null;
                    t = null;
                    return;
                }

                if (HaveSavedReal(HASH_UNIT, timeParent, 2)) {
                    timeLeft = LoadReal(HASH_UNIT, timeParent, 2) - 0.10;
                    if (timeLeft <= 0.0) {
                        ClearDefenseDownPercentSource(u, sourceType, instanceId);
                        FlushChildHashtable(HASH_UNIT, timeParent);
                        FlushChildHashtable(HASH_TIMER, tid);
                        PauseTimer(t);
                        DestroyTimer(t);
                        u = null;
                        t = null;
                    } else {
                        SaveReal(HASH_UNIT, timeParent, 2, timeLeft);
                        u = null;
                    }
                } else {
                    FlushChildHashtable(HASH_UNIT, timeParent);
                    FlushChildHashtable(HASH_TIMER, tid);
                    PauseTimer(t);
                    DestroyTimer(t);
                    u = null;
                    t = null;
                }
            });
            t = null;
        }
    }

    //中毒效果
    public function PoisonTime(unit source, unit u, real damage, integer duration) {
        timer t;
        integer uid;
        integer remain;

        if (u == null || !IsUnitAliveBJ(u)) {
            return;
        }
        if (duration <= 0) {
            return;
        }

        uid = GetHandleId(u);
        if (!HaveSavedReal(HASH_UNIT, uid, HASH_UNIT_POISON_DAMAGE)) {
            t = CreateTimer();
            ApplyPureDamage(source, u, damage);
            SaveReal(HASH_UNIT, uid, HASH_UNIT_POISON_DAMAGE, damage);
            remain = duration - 1; // 已经立即结算一次伤害，剩余次数 = duration - 1
            SaveInteger(HASH_TIMER, GetHandleId(t), 1, remain);
            SaveUnitHandle(HASH_TIMER, GetHandleId(t), 3, u);
            SaveUnitHandle(HASH_TIMER, GetHandleId(t), 4, source);
            bindEffect.attachUnique(u, "Abilities\\Spells\\NightElf\\shadowstrike\\shadowstrike.mdl", "head");
            TimerStart(t, 1, true, function () {

                timer t;
                integer id;
                integer remain;
                unit u;
                integer uid;
                real damage;
                unit source;
                boolean invalid;

                t = GetExpiredTimer();
                id = GetHandleId(t);
                remain = LoadInteger(HASH_TIMER, id, 1);
                u = LoadUnitHandle(HASH_TIMER, id, 3);
                source = LoadUnitHandle(HASH_TIMER, id, 4);

                // 单位已死亡/被移除/句柄失效：提前清理计时器
                invalid = (u == null);
                if (!invalid) {
                    invalid = (GetUnitTypeId(u) == 0 || !IsUnitAliveBJ(u));
                }

                if (invalid) {
                    if (u != null) {
                        uid = GetHandleId(u);
                        RemoveSavedReal(HASH_UNIT, uid, HASH_UNIT_POISON_DAMAGE);
                        bindEffect.detachUnique(u, "Abilities\\Spells\\NightElf\\shadowstrike\\shadowstrike.mdl");
                    }
                    PauseTimer(t);
                    FlushChildHashtable(HASH_TIMER, id);
                    DestroyTimer(t);
                } else {
                    uid = GetHandleId(u);
                    damage = LoadReal(HASH_UNIT, uid, HASH_UNIT_POISON_DAMAGE);

                    if (remain > 0) {
                        remain = remain - 1;
                        ApplyPureDamage(source, u, damage);
                        SaveInteger(HASH_TIMER, id, 1, remain);
                    } else {
                        RemoveSavedReal(HASH_UNIT, uid, HASH_UNIT_POISON_DAMAGE);
                        PauseTimer(t);
                        FlushChildHashtable(HASH_TIMER, id);
                        DestroyTimer(t);
                        bindEffect.detachUnique(u, "Abilities\\Spells\\NightElf\\shadowstrike\\shadowstrike.mdl");
                    }
                }

                t = null;
                u = null;
                source = null;

            });
            t = null;
        }
    }

    // 前摇暂停：仅锁住单位行动，不进入眩晕抗性/CD/IsUnitStunning
    public function PrecastPauseUnit(unit u, boolean flag) {
        if (u == null || GetUnitTypeId(u) == 0) { return; }

        if (flag) {
            ApplyEXPauseLock(u, KEY_UNIT_EX_PAUSE_LOCK_PRECAST);
        } else {
            ReleaseEXPauseLock(u, KEY_UNIT_EX_PAUSE_LOCK_PRECAST);
        }
    }

    // 限时前摇暂停：重复调用取最大剩余时间
    public function PrecastPauseUnitTimed(unit u, real time) {
        integer hid; real oldTime; boolean hasTime;

        if (u == null || !IsUnitAliveBJ(u) || time <= 0.0) { return; }

        hid = GetHandleId(u);
        hasTime = HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_EX_PAUSE_PRECAST_TIME_LEFT);
        if (hasTime) {
            oldTime = LoadReal(HASH_UNIT, hid, KEY_UNIT_EX_PAUSE_PRECAST_TIME_LEFT);
            SaveReal(HASH_UNIT, hid, KEY_UNIT_EX_PAUSE_PRECAST_TIME_LEFT, RMaxBJ(oldTime, time));
        } else {
            SaveReal(HASH_UNIT, hid, KEY_UNIT_EX_PAUSE_PRECAST_TIME_LEFT, time);
            ApplyEXPauseLock(u, KEY_UNIT_EX_PAUSE_LOCK_TIMED_PRECAST);
        }

        PrecastPauseQueue.addUnit(u);
    }

    // 清除前摇暂停，不影响真实眩晕
    public function ClearPrecastPause(unit u) {
        integer hid;
        if (u == null) { return; }

        hid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_EX_PAUSE_PRECAST_TIME_LEFT)) {
            RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_EX_PAUSE_PRECAST_TIME_LEFT);
        }
        while (GetEXPauseLockCount(u, KEY_UNIT_EX_PAUSE_LOCK_PRECAST) > 0) {
            ReleaseEXPauseLock(u, KEY_UNIT_EX_PAUSE_LOCK_PRECAST);
        }
        while (GetEXPauseLockCount(u, KEY_UNIT_EX_PAUSE_LOCK_TIMED_PRECAST) > 0) {
            ReleaseEXPauseLock(u, KEY_UNIT_EX_PAUSE_LOCK_TIMED_PRECAST);
        }
    }

    // 判断单位是否有前摇暂停锁
    public function IsUnitPrecastPaused(unit u) -> boolean {
        if (u == null || GetUnitTypeId(u) == 0) { return false; }
        if (GetEXPauseLockCount(u, KEY_UNIT_EX_PAUSE_LOCK_PRECAST) > 0) { return true; }
        if (GetEXPauseLockCount(u, KEY_UNIT_EX_PAUSE_LOCK_TIMED_PRECAST) > 0) { return true; }
        return false;
    }

    // 沉默单位：禁用技能，时间取最大值刷新
    public function SilenceUnit(unit u, real time) {
        integer hid; real oldTime;

        if (u == null || !IsUnitAliveBJ(u) || time <= 0.0) { return; }
        if (GetUnitAbilityLevel(u, 'Amim') > 0 || GetUnitAbilityLevel(u, MAGIC_IMMUNITY_SPELL_ID) > 0) { return; }

        hid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_SILENCE_TIME_LEFT)) {
            oldTime = LoadReal(HASH_UNIT, hid, KEY_UNIT_SILENCE_TIME_LEFT);
            SaveReal(HASH_UNIT, hid, KEY_UNIT_SILENCE_TIME_LEFT, RMaxBJ(oldTime, time));
        } else {
            SaveReal(HASH_UNIT, hid, KEY_UNIT_SILENCE_TIME_LEFT, time);
        }

        ApplySilenceNative(u);
        AttachSilenceDisableEffect(u);
        SilenceQueue.addUnit(u);
    }

    // 立即清除沉默状态
    public function ClearSilence(unit u) {
        integer hid;
        if (u == null || GetUnitTypeId(u) == 0) { return; }

        hid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_SILENCE_TIME_LEFT)) {
            RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_SILENCE_TIME_LEFT);
        }
        ReleaseSilenceNative(u);
        DetachSilenceDisableEffectIfUnused(u);
    }

    // 判断单位是否处于沉默中
    public function IsUnitSilenced(unit u) -> boolean {
        integer hid; real left;
        if (u == null || GetUnitTypeId(u) == 0) { return false; }
        hid = GetHandleId(u);
        if (!HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_SILENCE_TIME_LEFT)) { return false; }
        left = LoadReal(HASH_UNIT, hid, KEY_UNIT_SILENCE_TIME_LEFT);
        return left > 0.0;
    }

    // 缴械单位公共实现：功能时间与可见特效时间分别取最大值刷新。
    private function ApplyDisarmUnit(unit u, real time, boolean showEffect) {
        integer hid; real oldTime; real oldEffectTime;
        boolean hasTimedDisarm;

        if (u == null || !IsUnitAliveBJ(u) || time <= 0.0) { return; }
        if (GetUnitAbilityLevel(u, 'Amim') > 0 || GetUnitAbilityLevel(u, MAGIC_IMMUNITY_SPELL_ID) > 0) { return; }

        hid = GetHandleId(u);
        hasTimedDisarm = HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_DISARM_TIME_LEFT);
        if (hasTimedDisarm) {
            oldTime = LoadReal(HASH_UNIT, hid, KEY_UNIT_DISARM_TIME_LEFT);
            SaveReal(HASH_UNIT, hid, KEY_UNIT_DISARM_TIME_LEFT, RMaxBJ(oldTime, time));
        } else {
            SaveReal(HASH_UNIT, hid, KEY_UNIT_DISARM_TIME_LEFT, time);
            AcquireUnitDisarm(u);
        }

        if (showEffect) {
            oldEffectTime = 0.0;
            if (HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_DISARM_EFFECT_TIME_LEFT)) {
                oldEffectTime = LoadReal(HASH_UNIT, hid, KEY_UNIT_DISARM_EFFECT_TIME_LEFT);
            }
            SaveReal(HASH_UNIT, hid, KEY_UNIT_DISARM_EFFECT_TIME_LEFT, RMaxBJ(oldEffectTime, time));
            AttachSilenceDisableEffect(u);
        }
        DisarmQueue.addUnit(u);
    }

    // 普通缴械：禁用攻击并显示原生沉默特效。
    public function DisarmUnit(unit u, real time) {
        ApplyDisarmUnit(u, time, true);
    }

    // 静默缴械：禁用攻击但不新增原生沉默特效；已有可见缴械/沉默特效不受影响。
    public function DisarmUnitSilent(unit u, real time) {
        ApplyDisarmUnit(u, time, false);
    }

    // 立即清除普通限时缴械；其他系统持有的底层缴械锁不受影响。
    public function ClearDisarm(unit u) {
        integer hid;
        boolean hadTimedDisarm;
        if (u == null || GetUnitTypeId(u) == 0) { return; }

        hid = GetHandleId(u);
        hadTimedDisarm = HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_DISARM_TIME_LEFT);
        if (hadTimedDisarm) {
            RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_DISARM_TIME_LEFT);
        }
        if (HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_DISARM_EFFECT_TIME_LEFT)) {
            RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_DISARM_EFFECT_TIME_LEFT);
        }
        if (hadTimedDisarm) {
            ReleaseUnitDisarm(u);
        }
        DetachSilenceDisableEffectIfUnused(u);
    }

    // 判断单位是否仍持有任意来源的缴械锁。
    public function IsUnitDisarmed(unit u) -> boolean {
        integer hid;
        if (u == null || GetUnitTypeId(u) == 0) { return false; }
        hid = GetHandleId(u);
        return LoadInteger(HASH_UNIT, hid, KEY_UNIT_DISARM_NATIVE_ON) > 0;
    }

    // 眩晕单位（队列 + 尾部交换）
    public function StunUnit(unit u, real time, string loc, string effx) {
        integer hid; real resist; real effective; real oldTime; boolean hasTime; string oldEffx; string oldLoc; boolean effValid; real cdLeft; boolean cdDisabled;

        if (u == null || !IsUnitAliveBJ(u)) { return; }

        // 眩晕免疫直接跳过
        if (IsUnitStunImmune(u)) { return; }

        // 魔免直接跳过
        if (GetUnitAbilityLevel(u, 'Amim') > 0 || GetUnitAbilityLevel(u, MAGIC_IMMUNITY_SPELL_ID) > 0) { return; }

        resist = GetUnitStunResist(u);
        effective = time * (1.0 - resist);
        if (effective <= 0.0) { return; }

        hid = GetHandleId(u);
        // 检查CD是否禁用
        cdDisabled = IsUnitStunCdDisabled(u);
        // 如果未禁用CD且CD>0，直接返回（不能续晕/刷新）
        if (!cdDisabled) {
            if (HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_STUN_CD_LEFT)) {
                cdLeft = LoadReal(HASH_UNIT, hid, KEY_UNIT_STUN_CD_LEFT);
                if (cdLeft > 0.0) { return; }
            }
        }

        hasTime = HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_PAUSE_TIME_LEFT);
        if (hasTime) {
            oldTime = LoadReal(HASH_UNIT, hid, KEY_UNIT_PAUSE_TIME_LEFT);
            SaveReal(HASH_UNIT, hid, KEY_UNIT_PAUSE_TIME_LEFT, RMaxBJ(oldTime, effective));
        } else {
            SaveReal(HASH_UNIT, hid, KEY_UNIT_PAUSE_TIME_LEFT, effective);
        }

        // 如果未禁用CD，设置CD = effective * 5
        if (!cdDisabled) {
            SaveReal(HASH_UNIT, hid, KEY_UNIT_STUN_CD_LEFT, effective * 5.0);
            StunCdQueue.addUnit(u);
        }

        // 处理眩晕特效（仅当参数有效时覆盖）
        effValid = (effx != "" && loc != "");
        if (effValid) {
            if (HaveSavedString(HASH_UNIT, hid, KEY_UNIT_PAUSE_EFFX)) {
                oldEffx = LoadStr(HASH_UNIT, hid, KEY_UNIT_PAUSE_EFFX);
            } else {
                oldEffx = "";
            }
            if (HaveSavedString(HASH_UNIT, hid, KEY_UNIT_PAUSE_LOC)) {
                oldLoc = LoadStr(HASH_UNIT, hid, KEY_UNIT_PAUSE_LOC);
            } else {
                oldLoc = "";
            }

            if (oldEffx == "" || oldEffx != effx || oldLoc != loc) {
                if (oldEffx != "") {
                    bindEffect.detachUnique(u, oldEffx);
                }
                bindEffect.attachUnique(u, effx, loc);
                SaveStr(HASH_UNIT, hid, KEY_UNIT_PAUSE_EFFX, effx);
                SaveStr(HASH_UNIT, hid, KEY_UNIT_PAUSE_LOC, loc);
            }
        }

        // 眩晕生效：强制停止当前命令并暂停，确保立刻停住
        // 说明：
        // - 部分情况下 pause 不会立刻打断“已在执行的移动指令”，先 stop 可避免“有特效但还能走几秒”
        // - 同时持续强制 pause（见 PauseQueue tick）以对抗外部解除暂停
        if (!hasTime) {
            ApplyEXPauseLock(u, KEY_UNIT_EX_PAUSE_LOCK_STUN);
        }
        PauseQueue.addUnit(u);
    }

    // 判断单位是否处于眩晕中（根据剩余时间键位）
    public function IsUnitStunning(unit u) -> boolean {
        integer hid; real left;
        if (u == null || GetUnitTypeId(u) == 0) { return false; }
        hid = GetHandleId(u);
        if (!HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_PAUSE_TIME_LEFT)) { return false; }
        left = LoadReal(HASH_UNIT, hid, KEY_UNIT_PAUSE_TIME_LEFT);
        return left > 0.0;
    }

    // 立即清除单位的眩晕状态
    public function ClearStun(unit u) {
        integer hid; string effx;
        if (u == null || GetUnitTypeId(u) == 0) { return; }

        hid = GetHandleId(u);
        // 立即解除暂停
        ReleaseEXPauseLock(u, KEY_UNIT_EX_PAUSE_LOCK_STUN);
        // 清理眩晕时间
        if (HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_PAUSE_TIME_LEFT)) {
            RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_PAUSE_TIME_LEFT);
        }
        // 清理特效
        if (HaveSavedString(HASH_UNIT, hid, KEY_UNIT_PAUSE_EFFX)) {
            effx = LoadStr(HASH_UNIT, hid, KEY_UNIT_PAUSE_EFFX);
            if (effx != "") {
                bindEffect.detachUnique(u, effx);
            }
            RemoveSavedString(HASH_UNIT, hid, KEY_UNIT_PAUSE_EFFX);
            effx = "";
        }
        if (HaveSavedString(HASH_UNIT, hid, KEY_UNIT_PAUSE_LOC)) {
            RemoveSavedString(HASH_UNIT, hid, KEY_UNIT_PAUSE_LOC);
        }
    }

    // 范围眩晕参数（静态成员变量传递）
    private unit stunAreaSource = null;
    private real stunAreaTime = 0.0;
    private string stunAreaEffLoc = "";
    private string stunAreaEfx = "";

    // 范围眩晕
    public function StunArea(unit u, real x, real y, real radius, real time, string effLoc, string efx) {
        group g; unit filterUnit;

        stunAreaSource = u;
        stunAreaTime = time;
        stunAreaEffLoc = effLoc;
        stunAreaEfx = efx;

        g = CreateGroup();
        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            unit filterUnit;

            filterUnit = GetFilterUnit();
            if (IsEnemyUnit(filterUnit, stunAreaSource)) {
                StunUnit(filterUnit, stunAreaTime, stunAreaEffLoc, stunAreaEfx);
                filterUnit = null;
                return true;
            }

            filterUnit = null;
            return false;
        }));

        DestroyGroup(g);
        g = null;
        stunAreaSource = null;
        stunAreaTime = 0.0;
        stunAreaEffLoc = "";
        stunAreaEfx = "";
    }


    public function StartTimerBuff(unit u, real time, code fun) -> timer {
        return TimerBuffQueue.add(u, time, fun);
    }

}

//! endzinc
#endif
