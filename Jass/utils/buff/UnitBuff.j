#ifndef UnitBuffIncluded
#define UnitBuffIncluded

//! zinc
/*
单位buff工具库
*/
library UnitBuff requires UnitUtils {

    // 上:能叠加的无敌(计算)
    public function ImmuteDamageTime(unit u, real time, boolean eff) {
        timer t;

        t = null;
        if (HaveSavedReal(HASH_UNIT, GetHandleId(u), KEY_IMMUTE_UNIT_REAL)) {
            SaveReal(HASH_UNIT, GetHandleId(u), KEY_IMMUTE_UNIT_REAL, RMaxBJ(LoadReal(HASH_UNIT, GetHandleId(u), KEY_IMMUTE_UNIT_REAL), time));
        } else {
            UnitAddAbility(u, 'Avul');
            SaveReal(HASH_UNIT, GetHandleId(u), KEY_IMMUTE_UNIT_REAL, time);
            t = CreateTimer();
            SaveUnitHandle(HASH_TIMER, GetHandleId(t), 1, u);
            TimerStart(t, 0.1, true, function () {
                timer t;
                integer id;
                unit u;
                real time;

                t = GetExpiredTimer();
                id = GetHandleId(t);
                u = LoadUnitHandle(HASH_TIMER, GetHandleId(t), 1);
                time = LoadReal(HASH_UNIT, GetHandleId(u), KEY_IMMUTE_UNIT_REAL);
                if (time > 0) {
                    time = time - 0.1;
                    SaveReal(HASH_UNIT, GetHandleId(u), KEY_IMMUTE_UNIT_REAL, time);
                } else {
                    UnitRemoveAbility(u, 'Avul');
                    RemoveSavedReal(HASH_UNIT, GetHandleId(u), KEY_IMMUTE_UNIT_REAL);
                    PauseTimer(t);
                    FlushChildHashtable(HASH_TIMER, id);
                    DestroyTimer(t);
                }
                t = null;
                u = null;

            });
            if (eff) {
                DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl", GetUnitX(u), GetUnitY(u)));
            }
            t = null;
        }
    }

    //只免疫一次无敌
    public function ImmuteDamageOnce(unit u) {
        timer t;
        if (GetUnitAbilityLevel(u, 'Avul') < 1) {
            t = CreateTimer();
            UnitAddAbility(u, 'Avul');
            SaveUnitHandle(HASH_TIMER, GetHandleId(t), 1, u);
            TimerStart(t, time, false, function () {
                timer t;
                integer id;
                unit u;

                t = GetExpiredTimer();
                id = GetHandleId(t);
                u = LoadUnitHandle(HASH_TIMER, id, 1);
                PauseTimer(t);
                DestroyTimer(t);
                FlushChildHashtable(HASH_TIMER, id);
                UnitRemoveAbility(u, 'Avul');
                u = null;
                t = null;
            });
            t = null;
        }
    }


}

//! endzinc
#endif
