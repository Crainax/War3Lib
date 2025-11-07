#ifndef ItemUtilsIncluded
#define ItemUtilsIncluded

//! zinc
/*
物品工具库
*/
library ItemUtils {

    public function UnitAddItemByIdPlayer (integer itemId, unit whichHero) -> item {
        bj_lastCreatedItem = CreateItem(itemId, GetUnitX(whichHero), GetUnitY(whichHero));
        UnitAddItem(whichHero, bj_lastCreatedItem);
        SetItemPlayer(bj_lastCreatedItem, GetOwningPlayer(whichHero),false);
        return bj_lastCreatedItem;
    }


}

//! endzinc
#endif
