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

    // --------------------
    // Lifesteal aggregation for single-hit (no new structs; lightweight stack)
    // --------------------
    private static integer lsTop = -1;
    private static unit    lsSource[];
    private static real    lsTotal[];

    public function LS_begin(unit src) {
        lsTop += 1;
        lsSource[lsTop] = src;
        lsTotal[lsTop] = 0.0;
    }

    public function LS_end() -> real {
        real dealt;
        if (lsTop < 0) {
            return 0.0;
        }
        dealt = lsTotal[lsTop];
        lsSource[lsTop] = null;
        lsTotal[lsTop] = 0.0;
        lsTop -= 1;
        return dealt;
    }

    public function LS_isActive(unit src) -> boolean {
        if (lsTop < 0) return false;
        return lsSource[lsTop] == src;
    }

    public function LS_add(real amount) {
        if (lsTop < 0) return;
        if (amount > 0.0) {
            lsTotal[lsTop] = lsTotal[lsTop] + amount;
        }
    }

    // LS variants for single-target damage (return final dealt; caller decides to lifesteal)
    public function ApplyPhysicalDamageLS (unit u, unit target, real dmg) -> real {
        real dealt;
        LS_begin(u);
        ApplyPhysicalDamage(u, target, dmg);
        dealt = LS_end();
        return dealt;
    }

    public function ApplyMagicDamageLS (unit u, unit target, real dmg) -> real {
        real dealt;
        LS_begin(u);
        ApplyMagicDamage(u, target, dmg);
        dealt = LS_end();
        return dealt;
    }

    public function ApplyPureDamageLS (unit u, unit target, real dmg) -> real {
        real dealt;
        LS_begin(u);
        ApplyPureDamage(u, target, dmg);
        dealt = LS_end();
        return dealt;
    }

    //模拟普攻(最后一个参数代表额外的终伤,0)
    public function SimulateBasicAttack (unit u,unit target,real fd) {
        UnitDamageTarget( u, target, GetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE))*(1.0+fd), true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS );
    }

    // 伤害参数结构体
    public struct DmgP {
        unit   source;
        string eft;
        real   damage;
        // Lifesteal aggregation control (skill lifesteal only when enabled on AoE)
        boolean enableLifestealAggregation;
        real    lifestealDealtTotal;

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

        static method push(DmgP params) {
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

        static method pop() -> DmgP {
            DmgP params = thistype.stack[thistype.top];
            if (thistype.top < 0) {
                BJDebugMsg("DmgS underflow");
                return 0;
            }
            thistype.stack[thistype.top] = 0;
            thistype.top -= 1;
            return params;
        }

        static method current() -> DmgP {
            return thistype.stack[thistype.top];
        }

        // 是否存在可用的上下文，且开启了技能吸血聚合，并且来源匹配
        static method hasAggregation(unit src) -> boolean {
            if (thistype.top < 0) return false;
            DmgP p = thistype.stack[thistype.top];
            return p.enableLifestealAggregation && p.source == src;
        }

        // 聚合一次最终造成的伤害（由 DamageSystem 在事件最终阶段调用）
        static method aggregate(real amount) {
            if (thistype.top < 0) return;
            DmgP p = thistype.stack[thistype.top];
            if (p.enableLifestealAggregation && amount > 0) {
                p.lifestealDealtTotal += amount;
                thistype.stack[thistype.top] = p; // 写回（结构体为值语义）
            }
        }
    }

    // 范围普通伤害
    public function DamageAreaPhysical (unit u, real x, real y, real radius, real damage, string efx) {
        group g = CreateGroup();
        DmgP params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.damage = damage;
        params.enableLifestealAggregation = false;
        params.lifestealDealtTotal = 0.0;

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
        params.enableLifestealAggregation = false;
        params.lifestealDealtTotal = 0.0;

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
        params.enableLifestealAggregation = false;
        params.lifestealDealtTotal = 0.0;

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

    //范围秒杀
    public function DamageAreaKill (unit u,real x,real y,real radius,string efx) {
        group g = CreateGroup();
        DmgP params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.enableLifestealAggregation = false;
        params.lifestealDealtTotal = 0.0;


        DmgS.push(params);

        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            DmgP current = DmgS.current();
            if (IsEnemy(GetFilterUnit(),GetOwningPlayer(current.source))) {
                UnitDamageTarget( current.source, GetFilterUnit(), GetUnitState(GetFilterUnit(),UNIT_STATE_MAX_LIFE)*1.2, false, true, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_SLOW_POISON, WEAPON_TYPE_WHOKNOWS );
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

    // 带技能吸血聚合的一次性吸血版本（合并一次吸血，按最终造成伤害）
    public function DamageAreaPhysicalLS (unit u, real x, real y, real radius, real damage, string efx) -> real {
        group g = CreateGroup();
        DmgP params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.damage = damage;
        params.enableLifestealAggregation = true;
        params.lifestealDealtTotal = 0.0;

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
        real dealt = params.lifestealDealtTotal;
        params.destroy();
        DestroyGroup(g);
        g = null;
        // 一次性吸血（仅当配置非零）
        integer idx = GetConvertedPlayerId(GetOwningPlayer(u));
        if (dealt > 0 && RXixueSpell[idx] != 0.0) {
            Xixue(u, dealt * RXixueSpell[idx]);
        }
        return dealt;
    }

    public function DamageAreaMagicLS (unit u, real x, real y, real radius, real damage, string efx) -> real {
        group g = CreateGroup();
        DmgP params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.damage = damage;
        params.enableLifestealAggregation = true;
        params.lifestealDealtTotal = 0.0;

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
        real dealt = params.lifestealDealtTotal;
        params.destroy();
        DestroyGroup(g);
        g = null;
        // 一次性吸血（仅当配置非零）
        integer idx = GetConvertedPlayerId(GetOwningPlayer(u));
        if (dealt > 0 && RXixueSpell[idx] != 0.0) {
            Xixue(u, dealt * RXixueSpell[idx]);
        }
        return dealt;
    }

}

//! endzinc
#endif
