#ifndef DamageUtilsIncluded
#define DamageUtilsIncluded

#include "Crainax/core/constant/JapiConstant.j"

//! zinc
/*
伤害工具
*/
library DamageUtils requires UnitFilter,GroupUtils {

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

    //伤害参数结构体
    private struct DmgP {
        unit    source;  //伤害来源
        string  eft;     //特效
        real    damage;  //伤害值
        boolean isBj;    //是否暴击

        method destroy() {
            this.source = null;
            this.eft = null;
        }
    }

    //伤害参数栈
    public struct DmgS [] {
        private static DmgP stack[100];
        private static integer top = -1;

        public static method push(DmgP params) {
            thistype.top += 1;
            thistype.stack[thistype.top] = params;
        }

        public static method pop() -> DmgP {
            DmgP params = thistype.stack[thistype.top];
            thistype.stack[thistype.top] = 0;
            thistype.top -= 1;
            return params;
        }

        public static method getTop() -> integer {
            return thistype.top;
        }

        public static method current() -> DmgP {
            return thistype.stack[thistype.top];
        }
    }

    //范围普通伤害
    public function DamageArea (unit u,real x,real y,real radius,real damage,boolean bj,string efx) {
        group g = CreateGroup();
        DmgP params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.damage = damage;
        params.isBj = bj;

        DmgS.push(params);

        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            DmgP current = DmgS.current();
            if (IsEnemy(GetOwningPlayer(current.source),GetFilterUnit())) {
                ApplyPhysicalDamage(current.source,GetFilterUnit(),current.damage,current.isBj);
                if (current.eft != null) {
                    DestroyEffect(AddSpecialEffect(current.eft, GetUnitX(GetFilterUnit()),GetUnitY(GetFilterUnit())));
                }
                return true;
            }
            return false;
        }));

        params = DmgS.pop();
        params.destroy();
        DestroyGroup(g);
        g = null;
    }

    //范围真实伤害
    public function DamageAreaPure (unit u,real x,real y,real radius,real damage,boolean bj,string efx) {
        group g = CreateGroup();
        DmgP params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.damage = damage;
        params.isBj = bj;

        DmgS.push(params);

        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            DmgP current = DmgS.current();
            if (IsEnemy(GetOwningPlayer(current.source),GetFilterUnit())) {
                ApplyPureDamage(current.source,GetFilterUnit(),current.damage,current.isBj);
                if (current.eft != null) {
                    DestroyEffect(AddSpecialEffect(current.eft, GetUnitX(GetFilterUnit()),GetUnitY(GetFilterUnit())));
                }
                return true;
            }
            return false;
        }));

        params = DmgS.pop();
        params.destroy();
        DestroyGroup(g);
        g = null;
    }

}

//! endzinc
#endif
