#ifndef UnitDefenseReduceIncluded
#define UnitDefenseReduceIncluded

#include "Crainax/core/table/Hash_UnitDefine.j"

//! zinc
/*
旧固定值破防接口。
保留 ReduceDefenseTime/ReduceDefenseForever 与 HASH_UNIT_DEFENSE_REDUCE_VALUE 语义，
供旧地图版本按函数名单独触发注入；新来源百分比破防留在 UnitBuff.j。
*/
library UnitDefenseReduce requires UnitUtils, HashTable, BindEffect {

    // 时间破防（带冲突位和剩余时间）
    public function ReduceDefenseTime(unit u, integer slot, integer defense, real remainTime) {
        integer hid; integer defKey; integer timeKey; integer old; integer newDef; real oldTime; timer t; integer tid;

        if (u == null || !IsUnitAliveBJ(u)) { return; }
        if (slot < 1 || slot > 10) { return; }
        if (remainTime <= 0.0) { return; }

        hid = GetHandleId(u);
        defKey = HASH_UNIT_DEFENSE_REDUCE_VALUE + (slot - 1);
        timeKey = defKey + 10;

        // 读取旧值，取最大值
        if (HaveSavedInteger(HASH_UNIT, hid, defKey)) {
            old = LoadInteger(HASH_UNIT, hid, defKey);
        } else {
            old = 0;
        }
        newDef = IMaxBJ(old, defense);

        // 如果破防值增加，更新防御
        if (newDef > old) {
            SaveInteger(HASH_UNIT, hid, defKey, newDef);
            AddUnitDefenseBonus(u, (newDef - old) * -1);
            // 第一次产生破防时附加特效
            if (old == 0) {
                bindEffect.attachUnique(u, "Abilities\\Spells\\NightElf\\FaerieFire\\FaerieFireTarget.mdl", "head");
            }
        }

        // 更新剩余时间（取最大值）
        if (HaveSavedReal(HASH_UNIT, hid, timeKey)) {
            oldTime = LoadReal(HASH_UNIT, hid, timeKey);
            SaveReal(HASH_UNIT, hid, timeKey, RMaxBJ(oldTime, remainTime));
        } else {
            SaveReal(HASH_UNIT, hid, timeKey, remainTime);
        }

        // 检查是否需要创建新的计时器（通过检查是否有该 slot 的 timer）
        // 使用一个辅助键来存储 (unit, slot) -> timer 的映射
        tid = GetHandleId(u) * 100 + slot;
        if (!HaveSavedHandle(HASH_UNIT, tid, 1)) {
            // 创建新的计时器
            t = CreateTimer();
            tid = GetHandleId(t);
            SaveUnitHandle(HASH_TIMER, tid, 1, u);
            SaveInteger(HASH_TIMER, tid, 2, slot);
            // 保存 (unit, slot) -> timer 的映射，方便检查
            SaveTimerHandle(HASH_UNIT, GetHandleId(u) * 100 + slot, 1, t);
            TimerStart(t, 0.10, true, function () {
                timer t; integer id; integer hid; unit u; integer slot; integer defKey; integer timeKey; integer defense; real timeLeft;

                t = GetExpiredTimer();
                id = GetHandleId(t);
                u = LoadUnitHandle(HASH_TIMER, id, 1);
                slot = LoadInteger(HASH_TIMER, id, 2);

                // 检查单位是否有效
                if (u == null || GetUnitTypeId(u) == 0 || !IsUnitAliveBJ(u)) {
                    // 单位已失效，提前结束
                    if (u != null) {
                        hid = GetHandleId(u);
                        defKey = HASH_UNIT_DEFENSE_REDUCE_VALUE + (slot - 1);
                        timeKey = defKey + 10;
                        if (HaveSavedInteger(HASH_UNIT, hid, defKey)) {
                            defense = LoadInteger(HASH_UNIT, hid, defKey);
                            // 尝试恢复防御（如果单位还存在）
                            if (GetUnitTypeId(u) != 0) {
                                AddUnitDefenseBonus(u, defense);
                            }
                            RemoveSavedInteger(HASH_UNIT, hid, defKey);
                        }
                        if (HaveSavedReal(HASH_UNIT, hid, timeKey)) {
                            RemoveSavedReal(HASH_UNIT, hid, timeKey);
                        }
                        bindEffect.detachUnique(u, "Abilities\\Spells\\NightElf\\FaerieFire\\FaerieFireTarget.mdl");
                        // 清理 (unit, slot) -> timer 映射
                        RemoveSavedHandle(HASH_UNIT, hid * 100 + slot, 1);
                    }
                    // 清理计时器
                    FlushChildHashtable(HASH_TIMER, id);
                    PauseTimer(t);
                    DestroyTimer(t);
                    t = null;
                    u = null;
                    return;
                }

                hid = GetHandleId(u);
                defKey = HASH_UNIT_DEFENSE_REDUCE_VALUE + (slot - 1);
                timeKey = defKey + 10;

                // 读取剩余时间
                if (HaveSavedReal(HASH_UNIT, hid, timeKey)) {
                    timeLeft = LoadReal(HASH_UNIT, hid, timeKey);
                    timeLeft = timeLeft - 0.10;

                    if (timeLeft <= 0.0) {
                        // 时间到了，恢复防御并清理
                        if (HaveSavedInteger(HASH_UNIT, hid, defKey)) {
                            defense = LoadInteger(HASH_UNIT, hid, defKey);
                            AddUnitDefenseBonus(u, defense);
                            RemoveSavedInteger(HASH_UNIT, hid, defKey);
                        }
                        RemoveSavedReal(HASH_UNIT, hid, timeKey);
                        bindEffect.detachUnique(u, "Abilities\\Spells\\NightElf\\FaerieFire\\FaerieFireTarget.mdl");
                        // 清理 (unit, slot) -> timer 映射
                        RemoveSavedHandle(HASH_UNIT, hid * 100 + slot, 1);
                        // 清理计时器
                        FlushChildHashtable(HASH_TIMER, id);
                        PauseTimer(t);
                        DestroyTimer(t);
                        t = null;
                        u = null;
                    } else {
                        // 更新剩余时间
                        SaveReal(HASH_UNIT, hid, timeKey, timeLeft);
                        u = null;
                    }
                } else {
                    // 哈希记录丢失，清理计时器
                    if (u != null) {
                        RemoveSavedHandle(HASH_UNIT, hid * 100 + slot, 1);
                    }
                    FlushChildHashtable(HASH_TIMER, id);
                    PauseTimer(t);
                    DestroyTimer(t);
                    t = null;
                    u = null;
                }
            });
            t = null;
        }
    }

    // 永久破防（带冲突位）
    public function ReduceDefenseForever(unit u, integer slot, integer defense) {
        integer hid; integer defKey; integer old; integer newDef;

        if (u == null || !IsUnitAliveBJ(u)) { return; }
        if (slot < 1 || slot > 10) { return; }

        hid = GetHandleId(u);
        defKey = HASH_UNIT_DEFENSE_REDUCE_VALUE + (slot - 1);

        // 读取旧值，取最大值
        if (HaveSavedInteger(HASH_UNIT, hid, defKey)) {
            old = LoadInteger(HASH_UNIT, hid, defKey);
        } else {
            old = 0;
        }
        newDef = IMaxBJ(old, defense);

        // 如果破防值增加，更新防御和特效
        if (newDef > old) {
            SaveInteger(HASH_UNIT, hid, defKey, newDef);
            AddUnitDefenseBonus(u, (newDef - old) * -1);
            // 第一次产生破防时附加特效
            if (old == 0) {
                bindEffect.attachUnique(u, "Abilities\\Spells\\NightElf\\FaerieFire\\FaerieFireTarget.mdl", "head");
            }
        }
    }

}
//! endzinc

#endif
