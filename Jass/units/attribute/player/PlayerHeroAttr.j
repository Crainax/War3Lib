#ifndef PlayerHeroAttrIncluded
#define PlayerHeroAttrIncluded

//! zinc
/*
技能范围相关的属性
*/
library PlayerHeroAttr requires MathUtils{

    public struct plyaerHeroAttr [] {

        static real spellRangeRateUp []; //技能范围增幅
        static real spellRangeRateDown []; //技能范围减幅
        static real spellFinalDmgUpMul [];   // 技能最终伤害增幅乘子（默认1.0）
        static real spellFinalDmgDownMul []; // 技能最终伤害减幅乘子（默认1.0）

        // 获取玩家的总范围倍率（默认1.0）：(1 + up) * (1 - down)
        static method getTotalSpellRangeRate(player p) -> real {
            integer pid; real up; real down; real rate;

            if (p == null) { return 1.0; }

            pid = GetConvertedPlayerId(p);
            up = spellRangeRateUp[pid];
            down = spellRangeRateDown[pid];
            rate = (1.0 + up) * (1.0 - down);
            return rate;
        }

        // 增加玩家的范围增幅
        static method addSpellRangeRateUp(player p, real value) {
            integer pid;
            if (p == null || value == 0.0) { return; }
            pid = GetConvertedPlayerId(p);
            spellRangeRateUp[pid] += value;
        }

        // 增加玩家的范围减幅
        static method addSpellRangeRateDown(player p, real value) {
            integer pid;
            if (p == null || value == 0.0) { return; }
            pid = GetConvertedPlayerId(p);
            spellRangeRateDown[pid] = RealAdd(spellRangeRateDown[pid], value);
        }

        // 获取玩家的技能最终伤害总倍率（默认1.0）：upMul * downMul
        static method getTotalSpellFinalDamageRate(player p) -> real {
            integer pid; real upMul; real downMul;
            if (p == null) { return 1.0; }

            pid = GetConvertedPlayerId(p);
            upMul = spellFinalDmgUpMul[pid];
            downMul = spellFinalDmgDownMul[pid];
            if (upMul == 0.0) { upMul = 1.0; }
            if (downMul == 0.0) { downMul = 1.0; }
            return upMul * downMul;
        }

        // 增加技能最终伤害的增幅（乘法叠加）。
        // 传入正数v：乘以(1+v)。传入负数-v：乘以1/(1+v)，用于撤销同等次数的正向增幅。
        static method addSpellFinalDamageRateUp(player p, real value) {
            integer pid; real m; real v;
            if (p == null || value == 0.0) { return; }
            pid = GetConvertedPlayerId(p);
            m = spellFinalDmgUpMul[pid];
            if (m == 0.0) { m = 1.0; }

            if (value > 0.0) {
                m = m * (1.0 + value);
            } else {
                v = -value; // v > 0
                m = m / (1.0 + v);
            }

            spellFinalDmgUpMul[pid] = m;
        }

        // 增加技能最终伤害的减幅（乘法叠加）。
        // 传入正数v（0 <= v < 1）：乘以(1 - v)。传入负数-v（0 < v < 1）：乘以1/(1 - v)撤销。
        static method addSpellFinalDamageRateDown(player p, real value) {
            integer pid; real m; real v; real denom;
            if (p == null || value == 0.0) { return; }
            if (value >= 1.0 || value <= -1.0) { return; }

            pid = GetConvertedPlayerId(p);
            m = spellFinalDmgDownMul[pid];
            if (m == 0.0) { m = 1.0; }

            if (value > 0.0) {
                m = m * (1.0 - value);
            } else {
                v = -value; // v > 0
                denom = 1.0 - v; // 0 < denom < 1
                if (denom <= 0.0) { return; }
                m = m / denom;
            }

            spellFinalDmgDownMul[pid] = m;
        }
    }


}

//! endzinc
#endif
