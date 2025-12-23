#ifndef DashingIncluded
#define DashingIncluded

//! zinc
/*
简易单位冲刺(带多处回调)
使用 HASH_TIMER 存储上下文，支持 code 回调（通过 trigger 包装）
*/

// 伤害类型常量
#define DASHING_DMG_PHYSICAL      1
#define DASHING_DMG_MAGIC         2
#define DASHING_DMG_PURE          3

library Dashing requires HashTable,DamageUtils {

    // 公共配置结构体数组：先修改这些静态成员，再调用 StartDashing（一次配置只影响一次 Dash）
    public struct DashingCfg []{
        public static integer damageType = DASHING_DMG_MAGIC;  // 伤害类型
    }

    // 回调参数上下文（全局静态变量作为回调上下文，回调结束后会自动清空）
    public struct DashingArgs []{
        public static timer t = null;
        public static unit u = null;
        public static integer times = 0;
    }

    // 兼容函数：获取当前回调的 timer
    public function DashingGetTimer() -> timer {
        return DashingArgs.t;
    }

    // 兼容函数：获取当前回调的 unit
    public function DashingGetUnit() -> unit {
        return DashingArgs.u;
    }

    // 兼容函数：获取当前回调的 times
    public function DashingGetTimes() -> integer {
        return DashingArgs.times;
    }

    // StartDashing: 统一的冲刺函数（合并 DashI 和 DashII）
    // radius > 0 且 damage >= 1.0 时才会造成伤害
    public function StartDashing(unit caster, real x, real y, real speed, real max, code onComplete, code onStep, real radius, real damage) -> timer {
        timer t;
        timer result;
        integer id;
        real facing;
        group hitGrp;
        group enumGrp;
        trigger trComplete;
        trigger trStep;
        boolean hasDamage;
        integer cfgDamageType;

        if (caster == null || speed <= 0.0 || max <= 0.0) {
            return null;
        }

        // 判断是否有伤害逻辑（radius > 0 且 damage >= 1.0）
        hasDamage = (radius > 0.0 && damage >= 1.0);

        facing = GetFacing(GetUnitX(caster), GetUnitY(caster), x, y);
        t = CreateTimer();
        id = GetHandleId(t);

        // 设置单位朝向和动画
        SetUnitFacing(caster, facing);
        IssuePointOrder(caster, "move", x, y);
        SetUnitAnimation(caster, "spell");

        // 如果有伤害逻辑，创建命中缓存组和枚举组（复用，避免每 tick 创建）
        hitGrp = null;
        enumGrp = null;
        if (hasDamage) {
            hitGrp = CreateGroup();
            enumGrp = CreateGroup();
        }

        // 读取本次 Dash 的配置（一次配置只影响一次 Dash）
        cfgDamageType = DashingCfg.damageType;

        // 保存上下文到 HASH_TIMER
        SaveInteger(HASH_TIMER, id, 1, 1);  // tick 计数
        SaveReal(HASH_TIMER, id, 2, facing);
        SaveReal(HASH_TIMER, id, 3, YDWECoordinateX(x));
        SaveReal(HASH_TIMER, id, 4, YDWECoordinateY(y));
        SaveReal(HASH_TIMER, id, 5, speed);
        SaveUnitHandle(HASH_TIMER, id, 6, caster);
        SaveReal(HASH_TIMER, id, 7, max);
        SaveReal(HASH_TIMER, id, 11, damage);
        SaveReal(HASH_TIMER, id, 12, radius);
        SaveInteger(HASH_TIMER, id, 16, cfgDamageType);
        if (hitGrp != null) {
            SaveGroupHandle(HASH_TIMER, id, 10, hitGrp);
        }
        if (enumGrp != null) {
            SaveGroupHandle(HASH_TIMER, id, 15, enumGrp);
        }

        // Dash 结束后恢复配置为默认值（避免影响后续 Dash）
        DashingCfg.damageType = DASHING_DMG_MAGIC;

        // 包装回调为 trigger
        trComplete = null;
        trStep = null;
        if (onComplete != null) {
            trComplete = CreateTrigger();
            TriggerAddCondition(trComplete, Condition(onComplete));
        }
        if (onStep != null) {
            trStep = CreateTrigger();
            TriggerAddCondition(trStep, Condition(onStep));
        }
        SaveTriggerHandle(HASH_TIMER, id, 13, trComplete);
        SaveTriggerHandle(HASH_TIMER, id, 14, trStep);

        // 启动计时器
        TimerStart(t, 0.02, true, function () {
            timer t;
            integer id;
            integer i;
            real facing;
            real x;
            real y;
            real speed;
            unit u;
            real xp;
            real yp;
            real max;
            group hitGrp;
            group enumGrp;
            real damage;
            real radius;
            integer damageType;
            trigger trComplete;
            trigger trStep;
            boolean b;
            unit l_unit;
            integer maxTicks;

            t = GetExpiredTimer();
            id = GetHandleId(t);

            // 读取上下文
            i = LoadInteger(HASH_TIMER, id, 1);
            facing = LoadReal(HASH_TIMER, id, 2);
            x = LoadReal(HASH_TIMER, id, 3);
            y = LoadReal(HASH_TIMER, id, 4);
            speed = LoadReal(HASH_TIMER, id, 5);
            u = LoadUnitHandle(HASH_TIMER, id, 6);
            max = LoadReal(HASH_TIMER, id, 7);
            hitGrp = LoadGroupHandle(HASH_TIMER, id, 10);
            damage = LoadReal(HASH_TIMER, id, 11);
            radius = LoadReal(HASH_TIMER, id, 12);
            damageType = LoadInteger(HASH_TIMER, id, 16);
            trComplete = LoadTriggerHandle(HASH_TIMER, id, 13);
            trStep = LoadTriggerHandle(HASH_TIMER, id, 14);
            enumGrp = LoadGroupHandle(HASH_TIMER, id, 15);

            b = false;
            l_unit = null;

            // 失效检查
            if (u == null) {
                b = true;
            } else {
                // 计算下一位置
                xp = YDWECoordinateX(GetUnitX(u) + speed * CosBJ(facing));
                yp = YDWECoordinateY(GetUnitY(u) + speed * SinBJ(facing));

                // 根据是否有伤害逻辑决定最大 tick 数（有伤害: 300, 无伤害: 600）
                if (damage >= 1.0 && radius > 0.0) {
                    maxTicks = 300;
                } else {
                    maxTicks = 600;
                }

                // 检查是否继续冲刺
                if (i <= maxTicks && !IsTerrainPathable(xp, yp, PATHING_TYPE_WALKABILITY)) {
                    i = i + 1;
                    SaveInteger(HASH_TIMER, id, 1, i);

                    // 检查是否到达目标或超出最大距离
                    if (GetDistance(xp, yp, x, y) < speed) {
                        SetUnitX(u, x);
                        SetUnitY(u, y);
                        b = true;
                    } else {
                        SetUnitX(u, xp);
                        SetUnitY(u, yp);
                        if (i * speed >= max) {
                            b = true;
                        }
                    }

                    // 如果有伤害逻辑，执行伤害枚举（radius > 0 且 damage >= 1.0）
                    if (!b && damage >= 1.0 && radius > 0.0 && hitGrp != null && enumGrp != null) {
                        GroupClear(enumGrp);
                        GroupEnumUnitsInRangeEx(enumGrp, GetUnitX(u), GetUnitY(u), radius, null);
                        while (true) {
                            l_unit = FirstOfGroup(enumGrp);
                            if (l_unit == null) {
                                break;
                            }
                            GroupRemoveUnit(enumGrp, l_unit);
                            if (!IsUnitInGroup(l_unit, hitGrp) && IsEnemyMagicUnit(l_unit, u)) {
                                // 根据配置的伤害类型结算伤害
                                if (damageType == DASHING_DMG_PHYSICAL) {
                                    ApplyPhysicalDamage(u, l_unit, damage);
                                } else if (damageType == DASHING_DMG_PURE) {
                                    ApplyPureDamage(u, l_unit, damage);
                                } else {
                                    ApplyMagicDamage(u, l_unit, damage);
                                }
                                GroupAddUnit(hitGrp, l_unit);
                            }
                        }
                        l_unit = null;
                    }

                    // 触发 step 回调
                    if (trStep != null) {
                        DashingArgs.t = t;
                        DashingArgs.u = u;
                        DashingArgs.times = i;
                        TriggerEvaluate(trStep);
                        DashingArgs.t = null;
                        DashingArgs.u = null;
                        DashingArgs.times = 0;
                    }
                } else {
                    // 遇到地形障碍，停止
                    b = true;
                }
            }

            // 如果结束，执行清理
            if (b) {
                // 触发 complete 回调
                if (trComplete != null) {
                    DashingArgs.t = t;
                    DashingArgs.u = u;
                    DashingArgs.times = i;
                    TriggerEvaluate(trComplete);
                    DashingArgs.t = null;
                    DashingArgs.u = null;
                    DashingArgs.times = 0;
                }

                // 恢复单位移动命令
                if (u != null) {
                    IssuePointOrder(u, "move", GetUnitX(u), GetUnitY(u));
                }

                // 清理资源
                if (trComplete != null) {
                    DestroyTrigger(trComplete);
                }
                if (trStep != null) {
                    DestroyTrigger(trStep);
                }
                if (hitGrp != null) {
                    DestroyGroup(hitGrp);
                }
                if (enumGrp != null) {
                    DestroyGroup(enumGrp);
                }

                FlushChildHashtable(HASH_TIMER, id);
                PauseTimer(t);
                DestroyTimer(t);

                t = null;
                u = null;
                hitGrp = null;
                enumGrp = null;
                trComplete = null;
                trStep = null;
            } else {
                // 继续运行，只清理局部变量（句柄对象仍在 HASH_TIMER 中保存）
                t = null;
                u = null;
                enumGrp = null;
                hitGrp = null;
                trComplete = null;
                trStep = null;
            }
        });

        // 保存返回值
        result = t;

        // 清理局部变量（timer 已在计时器中管理，这里只清理其他句柄）
        hitGrp = null;
        enumGrp = null;
        trComplete = null;
        trStep = null;
        t = null;
        return result;
    }
}

//! endzinc
#endif
