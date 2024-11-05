#ifndef GroupUtilsIncluded
#define GroupUtilsIncluded

//! zinc
/*
单位组有关
伤害有关
// u = FirstOfGroup(g);  //少用这个,单位删了后直接是0了
用GroupPickRandomUnit(g);好一些
*/
library GroupUtils requires UnitFilter {

    group tempG = null;
    unit tempU = null;

    //库补充,防内存泄漏
    public function GroupEnumUnitsInRangeEx (group whichGroup,real x,real y,real radius,boolexpr filter) {
        GroupEnumUnitsInRange(whichGroup, x, y, radius, filter);
        DestroyBoolExpr(filter);
    }
    //库补充,防内存泄漏
    public function GroupEnumUnitsInRectEx (group whichGroup,rect r,boolexpr filter) {
        GroupEnumUnitsInRect(whichGroup, r, filter);
        DestroyBoolExpr(filter);
    }

    //获取单位组:[敌方]
    public function GetEnemyGroup (unit u,real x,real y,real radius) -> group {
        tempG = CreateGroup();
        tempU = u;
        GroupEnumUnitsInRangeEx(tempG, x, y, radius, Filter(function () -> boolean {
            if (IsEnemy(GetOwningPlayer(tempU),GetFilterUnit())) {
                return true;
            }
            return false;
        }));
        tempU = null;
        return tempG;
    }

    //获取圆形随机单位
    public function GetRandomEnemy (unit u,real x,real y,real radius)  -> unit {
        return GroupPickRandomUnit(GetEnemyGroup(u,x,y,radius));
    }

}

//! endzinc
#endif
