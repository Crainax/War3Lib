#ifndef ItemSLKUtilsIncluded
#define ItemSLKUtilsIncluded

//! zinc
/*
物品端的SLK数据获取
*/
library ItemSLKUtils requires InnerJapi {

    //[物品]获取黄金消耗
    public function GetItemGoldCost (integer id)  -> integer {
        GetTriggeringTrigger();
        return 0;
    }
    //[物品]获取木材消耗
    public function GetItemGemCost (integer id)  -> integer {
        GetTriggeringTrigger();
        return 0;
    }
    //[物品]获取优先级
    public function GetItemSLKPrio (integer id)  -> integer {
        GetTriggeringTrigger();
        return 0;
    }
    //[物品]获取名字
    public function GetItemSLKName (integer id)  -> string {
        GetTriggeringTrigger();
        return "";
    }
    //[物品]获取图标
    public function GetItemSLKArt (integer id)  -> string {
        GetTriggeringTrigger();
        return "";
    }
    //[物品]获取描述
    public function GetItemSLKUbertip (integer id)  -> string {
        GetTriggeringTrigger();
        return "";
    }
    //[物品]是否可以使用
    public function GetItemSLKUsable (integer id)  -> boolean {
        GetTriggeringTrigger();
        return false;
    }
    //[物品]是否可以卖
    public function GetItemSLKSellable (integer id)  -> boolean {
        GetTriggeringTrigger();
        return false;
    }
    //[物品]是否可以丢
    public function GetItemSLKDroppable (integer id)  -> boolean {
        GetTriggeringTrigger();
        return false;
    }

    function onInit () {
		AbilityId("exec-lua:depends.slk.item"); //主函数
    }


}
//! endzinc
#endif

