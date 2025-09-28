#ifndef DamageUtilsIncluded
#define DamageUtilsIncluded

#include "Crainax/core/constant/JapiConstant.j"

//! zinc
/*
伤害工具
*/
library DamageUtils requires UnitFilter,GroupUtils {


    // --------------------
    // Lifesteal aggregation for single-hit (no new structs; lightweight stack)
    // --------------------
    private integer lsTop = -1;
    private unit    lsSource[];
    private real    lsTotal[];

    private function LS_begin(unit src) {
        lsTop += 1;
        lsSource[lsTop] = src;
        lsTotal[lsTop] = 0.0;
    }

    private function LS_end() -> real {
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

    public function SingleDamageLSIsActive(unit src) -> boolean {
        if (lsTop < 0) return false;
        return lsSource[lsTop] == src;
    }

    public function SingleDamageLSAdd(real amount) {
        if (lsTop < 0) return;
        if (amount > 0.0) {
            lsTotal[lsTop] = lsTotal[lsTop] + amount;
        }
    }


    //旧名替换:DamageSingle
    //单体伤害:物理
    public function ApplyPhysicalDamage (unit u,unit target,real dmg) {
        real dealt;
        // 检查是否需要吸血聚合
        if (TrLifeSteal != null) {
            LS_begin(u);
            UnitDamageTarget( u, target, dmg, false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS );
            dealt = LS_end();

            //触发回调
            uArgs = u; //回调参数
            rArgs = dealt; //回调参数
            TriggerEvaluate(TrLifeSteal);
            uArgs = null;
            rArgs = 0.;
        } else {
            UnitDamageTarget( u, target, dmg, false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS );
        }
    }

    //单体伤害:魔法
    public function ApplyMagicDamage (unit u,unit target,real dmg) {
        real dealt;
        // 检查是否需要吸血聚合
        if (TrLifeSteal != null) {
            LS_begin(u);
            UnitDamageTarget( u, target, dmg, false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS );
            dealt = LS_end();

            //触发回调
            uArgs = u; //回调参数
            rArgs = dealt; //回调参数
            TriggerEvaluate(TrLifeSteal);
            uArgs = null;
            rArgs = 0.;
        } else {
            UnitDamageTarget( u, target, dmg, false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS );
        }
    }
    //单体伤害:真实
    public function ApplyPureDamage (unit u,unit target,real dmg) {
        real dealt;
        // 检查是否需要吸血聚合
        if (TrLifeSteal != null) {
            LS_begin(u);
            UnitDamageTarget( u, target, dmg, false, true, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_SLOW_POISON, WEAPON_TYPE_WHOKNOWS );
            dealt = LS_end();

            //触发回调
            uArgs = u; //回调参数
            rArgs = dealt; //回调参数
            TriggerEvaluate(TrLifeSteal);
            uArgs = null;
            rArgs = 0.;
        } else {
            UnitDamageTarget( u, target, dmg, false, true, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_SLOW_POISON, WEAPON_TYPE_WHOKNOWS );
        }
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
            DmgP p;
            if (thistype.top < 0) return false;
            p = thistype.stack[thistype.top];
            return p.enableLifestealAggregation && p.source == src;
        }

        // 聚合一次最终造成的伤害（由 DamageSystem 在事件最终阶段调用）
        static method aggregate(real amount) {
            DmgP p;
            if (thistype.top < 0) return;
            p = thistype.stack[thistype.top];
            if (p.enableLifestealAggregation && amount > 0) {
                p.lifestealDealtTotal += amount;
                thistype.stack[thistype.top] = p; // 写回（结构体为值语义）
            }
        }
    }

    // 范围普通伤害
    public function DamageAreaPhysical (unit u, real x, real y, real radius, real damage, string efx) {
        group g; real dealt; DmgP params;

        g = CreateGroup();
        params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.damage = damage;
        params.enableLifestealAggregation = (TrLifeSteal != null);
        params.lifestealDealtTotal = 0.0;

        DmgS.push(params);

        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            DmgP current = DmgS.current();
            if (IsEnemy(GetFilterUnit(), GetOwningPlayer(current.source))) {
                UnitDamageTarget( current.source, GetFilterUnit(), current.damage, false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS );
                if (current.eft != null) {
                    DestroyEffect(AddSpecialEffect(current.eft, GetUnitX(GetFilterUnit()), GetUnitY(GetFilterUnit())));
                }
                return true;
            }
            return false;
        }));

        params = DmgS.pop();
        dealt = params.lifestealDealtTotal;
        params.destroy();
        DestroyGroup(g);
        g = null;

        // 如果有吸血回调且造成了伤害，触发回调
        if (TrLifeSteal != null && dealt > 0.0) {
            uArgs = u;
            rArgs = dealt;
            TriggerEvaluate(TrLifeSteal);
            uArgs = null;
            rArgs = 0.;
        }
    }

    //范围魔法伤害
    public function DamageAreaMagic (unit u,real x,real y,real radius,real damage,string efx) {
        group g; real dealt; DmgP params;

        g = CreateGroup();
        params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.damage = damage;
        params.enableLifestealAggregation = (TrLifeSteal != null);
        params.lifestealDealtTotal = 0.0;

        DmgS.push(params);

        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            DmgP current = DmgS.current();
            if (IsEnemy(GetFilterUnit(),GetOwningPlayer(current.source))) {
                UnitDamageTarget( current.source, GetFilterUnit(), current.damage, false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS );
                if (current.eft != null) {
                    DestroyEffect(AddSpecialEffect(current.eft, GetUnitX(GetFilterUnit()),GetUnitY(GetFilterUnit())));
                }
                return true;
            }
            return false;
        }));

        params = DmgS.pop();
        dealt = params.lifestealDealtTotal;
        params.destroy();
        DestroyGroup(g);
        g = null;

        // 如果有吸血回调且造成了伤害，触发回调
        if (TrLifeSteal != null && dealt > 0.0) {
            uArgs = u;
            rArgs = dealt;
            TriggerEvaluate(TrLifeSteal);
            uArgs = null;
            rArgs = 0.;
        }
    }

    //范围真实伤害
    public function DamageAreaPure (unit u,real x,real y,real radius,real damage,string efx) {
        group g; real dealt; DmgP params;

        g = CreateGroup();
        params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.damage = damage;
        params.enableLifestealAggregation = (TrLifeSteal != null);
        params.lifestealDealtTotal = 0.0;

        DmgS.push(params);

        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            DmgP current = DmgS.current();
            if (IsEnemy(GetFilterUnit(),GetOwningPlayer(current.source))) {
                UnitDamageTarget( current.source, GetFilterUnit(), current.damage, false, true, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_SLOW_POISON, WEAPON_TYPE_WHOKNOWS );
                if (current.eft != null) {
                    DestroyEffect(AddSpecialEffect(current.eft, GetUnitX(GetFilterUnit()),GetUnitY(GetFilterUnit())));
                }
                return true;
            }
            return false;
        }));

        params = DmgS.pop();
        dealt = params.lifestealDealtTotal;
        params.destroy();
        DestroyGroup(g);
        g = null;

        // 如果有吸血回调且造成了伤害，触发回调
        if (TrLifeSteal != null && dealt > 0.0) {
            uArgs = u;
            rArgs = dealt;
            TriggerEvaluate(TrLifeSteal);
            uArgs = null;
            rArgs = 0.;
        }
    }

    //范围秒杀
    public function DamageAreaKill (unit u,real x,real y,real radius,string efx) {
        group g; real dealt; DmgP params;

        g = CreateGroup();
        params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.enableLifestealAggregation = (TrLifeSteal != null);
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
        dealt = params.lifestealDealtTotal;
        params.destroy();
        DestroyGroup(g);
        g = null;

        // 如果有吸血回调且造成了伤害，触发回调
        if (TrLifeSteal != null && dealt > 0.0) {
            uArgs = u;
            rArgs = dealt;
            TriggerEvaluate(TrLifeSteal);
            uArgs = null;
            rArgs = 0.;
        }
    }


    private trigger TrLifeSteal = null; //回调触发器
    private unit uArgs = null; //回调参数
    private real rArgs = 0.; //回调参数

    //注册
    public function RegisterDamageLifeSteal(code func) {
        if (TrLifeSteal == null) {
            TrLifeSteal = CreateTrigger();
        }
        TriggerAddCondition(TrLifeSteal, Condition(func));

    }
    //吸血的单位
    public function GetDamageLifeStealUnit () -> unit { return uArgs;}
    //吸血的数值
    public function GetDamageLifeStealReal () -> real { return rArgs;}

}

//! endzinc
#endif
