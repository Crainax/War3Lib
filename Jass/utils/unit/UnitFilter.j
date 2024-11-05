#ifndef UnitFilterIncluded
#define UnitFilterIncluded

//! zinc
/*
单位有关
*/
library UnitFilter {

    //判断是否是敌方(不带无敌)
    public function IsEnemy (player p,unit u)  -> boolean {
        return GetUnitState(u, UNIT_STATE_LIFE) > .405 && !(IsUnitType(u, UNIT_TYPE_STRUCTURE)) && !(IsUnitHidden(u)) && IsUnitEnemy(u, p) && GetUnitAbilityLevel(u,'Avul') == 0;
    }
    //旧名：IsEnemy2
    //判断是否是敌方(能匹配到无敌单位)
    public function IsEnemyIncludeInvul (player p,unit u)  -> boolean {
        return GetUnitState(u, UNIT_STATE_LIFE) > .405 && !(IsUnitType(u, UNIT_TYPE_STRUCTURE)) && !(IsUnitHidden(u)) && IsUnitEnemy(u, p);
    }
    //判断是否是友方
    public function IsAlly (player p,unit u)  -> boolean {
        return GetUnitState(u, UNIT_STATE_LIFE) > .405 && !(IsUnitType(u, UNIT_TYPE_STRUCTURE)) && !(IsUnitHidden(u)) && IsUnitAlly(u, p);
    }

}

//! endzinc
#endif

