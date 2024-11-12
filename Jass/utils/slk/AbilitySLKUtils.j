#ifndef AbilitySLKUtilsIncluded
#define AbilitySLKUtilsIncluded

//! zinc
/*
物品端的SLK数据获取
*/
library AbilitySLKUtils requires InnerJapi {


    //[技能]Tip
    public function GetAbilityTip (integer id)  -> string {
        GetTriggeringTrigger();
        return "";
    }
    //[技能]Ubertip
    public function GetAbilityUbertip (integer id)  -> string {
        GetTriggeringTrigger();
        return "";
    }
    //[技能]Untip
    public function GetAbilityUntip (integer id)  -> string {
        GetTriggeringTrigger();
        return "";
    }
    //[技能]Unubertip
    public function GetAbilityUnubertip (integer id)  -> string {
        GetTriggeringTrigger();
        return "";
    }
    //[技能]Art
    public function GetAbilityArt (integer id)  -> string {
        GetTriggeringTrigger();
        return "";
    }
    //[技能]Rng1
    public function GetAbilityRng1 (integer id)  -> integer {
        GetTriggeringTrigger();
        return 0;
    }
    //[技能]Area1
    public function GetAbilityArea1 (integer id)  -> integer {
        GetTriggeringTrigger();
        return 0;
    }
    //[技能]Cool1
    public function GetAbilityCool1 (integer id)  -> string {
        GetTriggeringTrigger();
        return "";
    }
    //[技能]Cost1
    public function GetAbilityCost1 (integer id)  -> integer {
        GetTriggeringTrigger();
        return 0;
    }

    function onInit () {
		AbilityId("exec-lua:depends.slk.ability"); //主函数
    }


}

//! endzinc
#endif

