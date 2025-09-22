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
    public function ApplyPhysicalDamage (unit u,unit target,real dmg) {
        static if (LIBRARY_Damage) {dmgF.isBJ = bj;}
        UnitDamageTarget( u, target, dmg, false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS );
    }

    //单体伤害:魔法
    public function ApplyMagicDamage (unit u,unit target,real dmg) {
        static if (LIBRARY_Damage) {dmgF.isBJ = bj;}
        UnitDamageTarget( u, target, dmg, false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS );
    }
    //单体伤害:真实
    public function ApplyPureDamage (unit u,unit target,real dmg) {
        static if (LIBRARY_Damage) {dmgF.isBJ = bj;}
        UnitDamageTarget( u, target, dmg, false, true, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_SLOW_POISON, WEAPON_TYPE_WHOKNOWS );
    }

    //模拟普攻(最后一个参数代表额外的终伤,0)
    public function SimulateBasicAttack (unit u,unit target,real fd) {
        UnitDamageTarget( u, target, GetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE))*(1.0+fd), true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS );
    }

    // 伤害参数结构体
    private struct DmgP {
        unit   source;
        string eft;
        real   damage;

        // 正确使用 onDestroy，而不是 destroy
        method onDestroy() {
            this.source = null;
            // this.eft = null; // 可选
        }
    }

    // 伤害参数栈
    public struct DmgS [] {
        private static DmgP stack [];
        private static integer top = -1;

        public static method push(DmgP params) {
            if (thistype.top >= 8190) {
                // 调试期提示或直接 return，避免越界
                #if (CURRENT_BUILD_VERSION != VERSION_RELEASE)
                    BJDebugMsg("DmgS overflow");
                #endif
                return;
            }
            thistype.top += 1;
            thistype.stack[thistype.top] = params;
        }

        public static method pop() -> DmgP {
            DmgP params = thistype.stack[thistype.top];
            if (thistype.top < 0) {
                BJDebugMsg("DmgS underflow");
                return 0;
            }
            thistype.stack[thistype.top] = 0;
            thistype.top -= 1;
            return params;
        }

        public static method current() -> DmgP {
            return thistype.stack[thistype.top];
        }
    }

    // 范围普通伤害
    public function DamageAreaPhysical (unit u, real x, real y, real radius, real damage, string efx) {
        group g = CreateGroup();
        DmgP params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.damage = damage;

        DmgS.push(params);

        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            DmgP current = DmgS.current();
            if (IsEnemy(GetFilterUnit(), GetOwningPlayer(current.source))) {
                ApplyPhysicalDamage(current.source, GetFilterUnit(), current.damage);
                if (current.eft != null) {
                    DestroyEffect(AddSpecialEffect(current.eft, GetUnitX(GetFilterUnit()), GetUnitY(GetFilterUnit())));
                }
                return true;
            }
            return false;
        }));

        params = DmgS.pop();
        params.destroy(); // 现在会真正释放实例，并调用 onDestroy
        DestroyGroup(g);
        g = null;
    }

    //范围魔法伤害
    public function DamageAreaMagic (unit u,real x,real y,real radius,real damage,string efx) {
        group g = CreateGroup();
        DmgP params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.damage = damage;

        DmgS.push(params);

        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            DmgP current = DmgS.current();
            if (IsEnemy(GetFilterUnit(),GetOwningPlayer(current.source))) {
                ApplyMagicDamage(current.source,GetFilterUnit(),current.damage);
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
    public function DamageAreaPure (unit u,real x,real y,real radius,real damage,string efx) {
        group g = CreateGroup();
        DmgP params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.damage = damage;

        DmgS.push(params);

        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            DmgP current = DmgS.current();
            if (IsEnemy(GetFilterUnit(),GetOwningPlayer(current.source))) {
                ApplyPureDamage(current.source,GetFilterUnit(),current.damage);
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
