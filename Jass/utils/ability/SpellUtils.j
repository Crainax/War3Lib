#ifndef SpellUtilsIncluded
#define SpellUtilsIncluded

//! zinc
/*
技能相关的工具类
*/
library SpellUtils {

    //异步获取当前单位的指定xy位置的技能id
    // param x  x坐标
    // param y  y坐标
    // return 技能id
    public function GetCurrentXYAbility (integer x,integer y)  -> integer {
        return S2I(EXExecuteScript("(require 'jass.message').button("+I2S(x)+", "+I2S(y)+")"));
    }


    //获取技能提示工具 - 扩展
    public function GetAbilityUberTip (integer id)  -> string {
		return YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ABILITY, id, "Ubertip");
    }

    //获取提示工具 - 学习
    public function GetAbilityResearchTip (integer id)  -> string {
		return YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ABILITY, id, "ResearchTip");
    }

    //获取冷却数值
    public function GetAbilityCool (integer id,integer level)  -> real {
		return YDWEGetObjectPropertyReal(YDWE_OBJECT_TYPE_ABILITY, id, "Cool"+I2S(level));
    }

    // 刷新技能CD
    public function RefreshAbility (unit u,integer id)  -> nothing {
        integer level = GetUnitAbilityLevel(u,id);
        if (level < 1) {return ;}
        UnitRemoveAbility(u,id);
        UnitAddAbility(u,id);
        SetUnitAbilityLevel(u,id,level);
    }

    // 给英雄加技能永久性
    public function UnitAddAbilityP(unit u, integer i) {
        UnitAddAbility(u, i);
        UnitMakeAbilityPermanent(u, true, i);
    }

}

//! endzinc
#endif
