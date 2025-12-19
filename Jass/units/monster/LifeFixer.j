#ifndef LifeFixerIncluded
#define LifeFixerIncluded

#include "YDBase.j"
#include "unit/Attr.j"

//! zinc
library LifeFixer requires YDBase, Attr {

    /*
    BOSS人数修正
    */
    public function GetBossRenshuHPRate(integer rs) -> real {
        if (rs >= 6) {
            return 0.72;
        } else if (rs == 5) {
            return 0.74;
        } else if (rs == 4) {
            return 0.775;
        } else if (rs == 3) {
            return 0.83;
        } else if (rs == 2) {
            return 0.9;
        }
        return 1.0;
    }

    public function FixBossHP(unit u, integer rs, integer old) {
        real addValue;

        addValue = GetUnitState(u, UNIT_STATE_MAX_LIFE) * (GetBossRenshuHPRate(rs) - GetBossRenshuHPRate(old));
        AddUnitHP(u, addValue);
        BJDebugMsg("|cFFFF66CC【 " + GetUnitName(u) + " 】|r的生命修正成:" + FormatNumber(GetUnitState(u, UNIT_STATE_MAX_LIFE)) + "x |cffff0000" + I2S(rs) + "|r条命.");
    }

    // 多条命
    // 手动destroy
    public struct lifeFixer {
        private unit caster;
        private integer times;
        private integer current;
        private timer t;
        private texttag ttHint;

        static method flashLoc() {
            thistype this;

            this = LoadInteger(YDTable, GetHandleId(GetExpiredTimer()), 1);

            if (this.times < 2) {
                UnitRemoveAbility(this.caster, 'A02l');
            }
            if (this.current >= this.times) {
                return;
            }
            SetTextTagPosUnitBJ(this.ttHint, this.caster, 20);
            if (!IsUnitAliveBJ(this.caster)) {
                this.current = this.current + 1;
                SetUnitLifePercentBJ(this.caster, 100);
                SetTextTagTextBJ(this.ttHint, I2S(this.current) + "/" + I2S(this.times) + "次生命", 20);
                if (this.current >= this.times) {
                    UnitRemoveAbility(this.caster, 'A02l');
                }
            }
        }

        method addTimes(integer i) {
            FixBossHP(this.caster, this.times + i, this.times);
            this.times = this.times + i;
            UnitAddAbility(this.caster, 'A02l');
            SetTextTagTextBJ(this.ttHint, I2S(this.current) + "/" + I2S(this.times) + "次生命", 20);
        }

        method getTimes() -> integer {
            return this.current;
        }


        static method create(unit caster, integer times) -> thistype {
            thistype this;

            this = thistype.allocate();
            this.caster = caster;
            this.times = times;
            this.ttHint = CreateTextTagUnitBJ("1/" + I2S(times) + "次生命", caster, 0, 20, 0, 100, 100, 0);
            SetTextTagPosUnitBJ(this.ttHint, this.caster, 20);
            this.current = 1;
            if (times > 1) {
                FixBossHP(caster, times, 1);
            }
            // 加上复活技能
            UnitAddAbility(caster, 'A02l');
            this.t = CreateTimer();
            SaveInteger(YDTable, GetHandleId(this.t), 1, this);
            TimerStart(this.t, 0.05, true, function thistype.flashLoc);
            return this;
        }

        method onDestroy() {
            FlushChildHashtable(YDTable, GetHandleId(this.t));
            UnitRemoveAbility(this.caster, 'A02l');
            DestroyTextTag(this.ttHint);
            this.ttHint = null;
            this.caster = null;
            PauseTimer(this.t);
            DestroyTimer(this.t);
            this.t = null;
        }
    }
}
//! endzinc

#endif
