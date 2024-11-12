#ifndef UnitSLKUtilsIncluded
#define UnitSLKUtilsIncluded

//! zinc
/*
物品端的SLK数据获取
*/
library UnitSLKUtils requires InnerJapi {

    //[单位]Primary
    public function GetUnitSLKPrimary (integer id)  -> string {
        GetTriggeringTrigger();
        return "";
    }
    //[单位]Name
    public function GetUnitSLKName (integer id)  -> string {
        GetTriggeringTrigger();
        return "";
    }
    //[单位]Art
    public function GetUnitSLKArt (integer id)  -> string {
        GetTriggeringTrigger();
        return "";
    }
    //[单位]File(模型文件)
    public function GetUnitSLKFile (integer id)  -> string {
        GetTriggeringTrigger();
        return "";
    }

    function onInit () {
		AbilityId("exec-lua:depends.slk.unit"); //主函数
    }


}

//! endzinc
#endif

