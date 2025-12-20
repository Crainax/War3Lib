#ifndef LifeFixerIncluded
#define LifeFixerIncluded


//! zinc
library LifeFixer requires UnitUtils {

    // 多条命
    public struct lifeFixer {
        private unit caster;
        private integer times;
        private real baseHp;

        method addTimes(integer i) {
            real addHp;

            if (this.caster == null || i <= 0) { return; }
            addHp = this.baseHp * i;
            if (addHp != 0.0) {
                AddUnitHP(this.caster, addHp);
                BJDebugMsg("|cFFFF66CC【 " + GetUnitName(this.caster) + " 】|r的生命修正成:" + FormatNumber(GetUnitState(this.caster, UNIT_STATE_MAX_LIFE)) + ".");
            }
            this.times = this.times + i;
        }

        static method create(unit caster, integer times) -> thistype {
            thistype this;
            integer add;

            this = thistype.allocate();
            this.caster = caster;
            this.baseHp = GetUnitState(caster, UNIT_STATE_MAX_LIFE);
            this.times = 1;

            add = times - 1;
            if (add > 0) {
                this.addTimes(add);
            }
            return this;
        }

        method onDestroy() {
            this.caster = null;
            this.baseHp = 0.0;
        }
    }
}
//! endzinc

#endif
