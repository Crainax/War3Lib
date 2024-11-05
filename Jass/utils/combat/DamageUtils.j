#ifndef DamageUtilsIncluded
#define DamageUtilsIncluded

#include "Crainax/core/constant/JapiConstant.j"
#include "Crainax/utils/unit/UnitFilter.j"

//! zinc
/*
伤害工具
*/
library DamageUtils requires UnitFilter {

    //中转的东西
    public struct gF [] {
        static group  g         = null;  //生成的单位组
        public static unit    u1 = null;  //绑定的单位1
        public static player  p1 = null;  //绑定的玩家1
        public static integer i1 = 0;     //绑定的整数1
        public static real    r1 = 0;     //绑定的实数1
        public static string  s1 = null;  //绑定的字符串1
        public static boolean b1 = false; //绑定的布尔1
    }
    //todo: 改成进出栈方式来造成伤害

    //todo: 用一个结构体来传参,不要在这里传bj

    //旧名替换:DamageSingle
    //单体伤害:物理
    public function ApplyPhysicalDamage (unit u,unit target,real dmg,boolean bj) {
        static if (LIBRARY_Damage) {dmgF.isBJ = bj;}
        UnitDamageTarget( u, target, dmg, false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS );
    }
    //单体伤害:真实
    public function ApplyPureDamage (unit u,unit target,real dmg,boolean bj) {
        static if (LIBRARY_Damage) {dmgF.isBJ = bj;}
        UnitDamageTarget( u, target, dmg, false, false, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_SLOW_POISON, WEAPON_TYPE_WHOKNOWS );
    }

    //模拟普攻(最后一个参数代表额外的终伤,0)
    public function SimulateBasicAttack (unit u,unit target,real fd) {
        UnitDamageTarget( u, target, GetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE))*(1.0+fd), true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS );
    }

    //范围普通伤害
    public function DamageArea (unit u,real x,real y,real radius,real damage,boolean bj,string efx) {
        group g = CreateGroup();
        gF.u1 = u;
        gF.s1 = efx;
        gF.r1 = damage;
        gF.b1 = bj;
        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            if (IsEnemy(GetOwningPlayer(gF.u1),GetFilterUnit())) {
                ApplyPhysicalDamage(gF.u1,GetFilterUnit(),gF.r1,gF.b1);
                if (gF.s1 != null) {DestroyEffect(AddSpecialEffect(gF.s1, GetUnitX(GetFilterUnit()),GetUnitY(GetFilterUnit()) ));}
                return true;
            }
            return false;
        }));
        DestroyGroup(g);
        gF.u1 = null;
        g = null;
    }
    //范围真实伤害
    public function DamageAreaPure (unit u,real x,real y,real radius,real damage,boolean bj,string efx) {
        group g = CreateGroup();
        gF.u1 = u;
        gF.s1 = efx;
        gF.r1 = damage;
        gF.b1 = bj;
        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            if (IsEnemy(GetOwningPlayer(gF.u1),GetFilterUnit())) {
                ApplyPureDamage(gF.u1,GetFilterUnit(),gF.r1,gF.b1);
                if (gF.s1 != null) {DestroyEffect(AddSpecialEffect(gF.s1, GetUnitX(GetFilterUnit()),GetUnitY(GetFilterUnit()) ));}
                return true;
            }
            return false;
        }));
        DestroyGroup(g);
        gF.u1 = null;
        g = null;
    }

}

//! endzinc
#endif
