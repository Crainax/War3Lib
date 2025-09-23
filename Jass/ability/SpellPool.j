#ifndef SpellPoolIncluded
#define SpellPoolIncluded

//! zinc
/*
技能池
先研究每个技能位置能不能独立
*/
library SpellPool {

    public unit spellpool_u     = null;
    public trigger spellpool_tr = null;
    public function TriggerName(unit u) {
        spellpool_u = u;
        TriggerEvaluate(spellpool_tr);
    }

    function onInit () {
        Cheat("exec-lua:depends.spellpool");
    }

}

//! endzinc
#endif
