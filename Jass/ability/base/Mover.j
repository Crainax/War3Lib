#ifndef MoverIncluded
#define MoverIncluded

//! zinc
/*
特效移动库
投射物特效直线移动到目标点，支持到达伤害和回调
*/

// 基本参数（默认值，可通过 EffectMoveCfg 结构体覆盖）
#define EFFECTMOVE_TICK              0.03
#define EFFECTMOVE_SPEED             800.0
#define EFFECTMOVE_CLIFF_Z           128.0
#define EFFECTMOVE_MODEL_PATH        "Abilities\\Spells\\Undead\\CarrionSwarm\\CarrionSwarmMissile.mdl"

// 伤害类型常量
#define EFFECTMOVE_DMG_PHYSICAL      1
#define EFFECTMOVE_DMG_MAGIC         2
#define EFFECTMOVE_DMG_PURE          3

library Mover requires HashTable, DamageUtils, Geometry {

    // 公共配置结构体数组：先修改这些静态成员，再调用 StartEffectMove（一次配置只影响一次移动）
    public struct EffectMoveCfg []{
        public static real    speed         = EFFECTMOVE_SPEED;          // 弹道速度
        public static string  modelPath     = EFFECTMOVE_MODEL_PATH;     // 投射物模型
        public static real    scale         = 1.0;                       // 模型缩放
        public static real    heightOffset  = 0.0;                       // 投射物高度偏移（相对地形），默认 0
        public static real    tick          = EFFECTMOVE_TICK;           // 计时器间隔
        public static integer damageType    = EFFECTMOVE_DMG_MAGIC;      // 伤害类型
        public static real    radius        = 0.0;                       // 到达伤害检测半径（damage >= 1.0 时生效）
        public static real    damage        = 0.0;                       // 到达时对每个单位造成的伤害（damage >= 1.0 且 radius > 0.0 时生效）
        public static code    onStep        = null;                      // 每 tick 回调（可选）
    }

    // 回调参数上下文（全局静态变量作为回调上下文，回调结束后会自动清空）
    public struct EffectMoveArgs []{
        public static timer t = null;
        public static effect e = null;
        public static real x = 0.0;
        public static real y = 0.0;
        public static real travelled = 0.0;
    }

    // 兼容函数：获取当前回调的 timer
    public function EffectMoveGetTimer() -> timer {
        return EffectMoveArgs.t;
    }

    // 兼容函数：获取当前回调的 effect
    public function EffectMoveGetEffect() -> effect {
        return EffectMoveArgs.e;
    }

    // 兼容函数：获取当前回调的 x 坐标
    public function EffectMoveGetX() -> real {
        return EffectMoveArgs.x;
    }

    // 兼容函数：获取当前回调的 y 坐标
    public function EffectMoveGetY() -> real {
        return EffectMoveArgs.y;
    }

    // 兼容函数：获取当前回调的已移动距离
    public function EffectMoveGetTravelled() -> real {
        return EffectMoveArgs.travelled;
    }

    // 回调参数（枚举 Filter 使用静态成员传参，避免哈希表冲突）
    private unit    effectMoveCbCaster        = null;
    private real    effectMoveCbDamage        = 0.0;
    private integer effectMoveCbDamageType    = 0;

    // 计时器回调：推进弹道、结束时清理
    private function EffectMoveTimer() {
        timer t;
        integer id;
        unit caster;
        effect e;
        real x;
        real y;
        real targetX;
        real targetY;
        real facing;
        real damage;
        real radius;
        real range;
        real travelled;
        real step;
        real z;
        real speed;
        real tick;
        real heightOffset;
        trigger trComplete;
        trigger trStep;
        group enumGrp;
        unit l_unit;
        boolean b;

        t = GetExpiredTimer();
        id = GetHandleId(t);

        caster       = LoadUnitHandle(HASH_TIMER, id, 1);
        e            = LoadEffectHandle(HASH_TIMER, id, 2);
        x            = LoadReal(HASH_TIMER, id, 3);
        y            = LoadReal(HASH_TIMER, id, 4);
        targetX      = LoadReal(HASH_TIMER, id, 5);
        targetY      = LoadReal(HASH_TIMER, id, 6);
        facing       = LoadReal(HASH_TIMER, id, 7);
        damage       = LoadReal(HASH_TIMER, id, 8);
        radius       = LoadReal(HASH_TIMER, id, 9);
        range        = LoadReal(HASH_TIMER, id, 10);
        travelled    = LoadReal(HASH_TIMER, id, 11);
        speed        = LoadReal(HASH_TIMER, id, 12);
        heightOffset = LoadReal(HASH_TIMER, id, 13);
        trComplete   = LoadTriggerHandle(HASH_TIMER, id, 14);
        trStep       = LoadTriggerHandle(HASH_TIMER, id, 15);
        tick         = LoadReal(HASH_TIMER, id, 17);

        b = false;
        l_unit = null;
        enumGrp = null;

        // 失效或超出射程：清理
        if (e == null || travelled >= range) {
            b = true;
        } else {
            // 前进一小步
            // 注意：speed 是“每秒速度”，step 才是“每 tick 位移”
            // tick 必须用本次实例保存的值，不能用 EffectMoveCfg（它会在 StartEffectMove 后被重置）
            if (tick <= 0.0) {
                tick = EFFECTMOVE_TICK;
            }
            step = speed * tick;
            x = x + step * CosBJ(facing);
            y = y + step * SinBJ(facing);
            x = YDWECoordinateX(x);
            y = YDWECoordinateY(y);
            travelled = travelled + step;

            SaveReal(HASH_TIMER, id, 3, x);
            SaveReal(HASH_TIMER, id, 4, y);
            SaveReal(HASH_TIMER, id, 11, travelled);

            // 根据当前地形高度设置 Z
            z = I2R(GetTerrainCliffLevel(x, y)) * EFFECTMOVE_CLIFF_Z + heightOffset;
            DzSetEffectPos(e, x, y, z);

            // 检查是否到达目标
            if (GetDistance(x, y, targetX, targetY) <= step) {
                x = targetX;
                y = targetY;
                SaveReal(HASH_TIMER, id, 3, x);
                SaveReal(HASH_TIMER, id, 4, y);
                DzSetEffectPos(e, x, y, I2R(GetTerrainCliffLevel(x, y)) * EFFECTMOVE_CLIFF_Z + heightOffset);
                b = true;
            }

            // 触发 step 回调
            if (!b && trStep != null) {
                EffectMoveArgs.t = t;
                EffectMoveArgs.e = e;
                EffectMoveArgs.x = x;
                EffectMoveArgs.y = y;
                EffectMoveArgs.travelled = travelled;
                TriggerEvaluate(trStep);
                EffectMoveArgs.t = null;
                EffectMoveArgs.e = null;
                EffectMoveArgs.x = 0.0;
                EffectMoveArgs.y = 0.0;
                EffectMoveArgs.travelled = 0.0;
            }
        }

        // 如果结束，执行清理
        if (b) {
            // 触发 complete 回调
            if (trComplete != null) {
                EffectMoveArgs.t = t;
                EffectMoveArgs.e = e;
                EffectMoveArgs.x = x;
                EffectMoveArgs.y = y;
                EffectMoveArgs.travelled = travelled;
                TriggerEvaluate(trComplete);
                EffectMoveArgs.t = null;
                EffectMoveArgs.e = null;
                EffectMoveArgs.x = 0.0;
                EffectMoveArgs.y = 0.0;
                EffectMoveArgs.travelled = 0.0;
            }

            // 到达伤害：在终点枚举并结算一次伤害
            if (caster != null && damage >= 1.0 && radius > 0.0) {
                enumGrp = CreateGroup();
                effectMoveCbCaster = caster;
                effectMoveCbDamage = damage;
                effectMoveCbDamageType = LoadInteger(HASH_TIMER, id, 16);

                GroupEnumUnitsInRangeEx(enumGrp, x, y, radius, Filter(function () -> boolean {
                    unit u;
                    u = GetFilterUnit();
                    if (u != null && IsEnemy(u, GetOwningPlayer(effectMoveCbCaster))) {
                        // 根据配置的伤害类型结算伤害
                        if (effectMoveCbDamageType == EFFECTMOVE_DMG_PHYSICAL) {
                            ApplyPhysicalDamage(effectMoveCbCaster, u, effectMoveCbDamage);
                        } else if (effectMoveCbDamageType == EFFECTMOVE_DMG_PURE) {
                            ApplyPureDamage(effectMoveCbCaster, u, effectMoveCbDamage);
                        } else {
                            ApplyMagicDamage(effectMoveCbCaster, u, effectMoveCbDamage);
                        }
                        u = null;
                        return true;
                    }
                    u = null;
                    return false;
                }));

                DestroyGroup(enumGrp);
                enumGrp = null;
                effectMoveCbCaster = null;
                effectMoveCbDamage = 0.0;
                effectMoveCbDamageType = 0;
            }

            // 清理资源
            if (e != null) {
                DestroyEffect(e);
            }
            if (trComplete != null) {
                DestroyTrigger(trComplete);
            }
            if (trStep != null) {
                DestroyTrigger(trStep);
            }

            FlushChildHashtable(HASH_TIMER, id);
            PauseTimer(t);
            DestroyTimer(t);

            e = null;
            caster = null;
            trComplete = null;
            trStep = null;
            t = null;
        } else {
            // 继续运行，只清理局部变量
            caster = null;
            e = null;
            trComplete = null;
            trStep = null;
            t = null;
        }
    }

    // 对外入口：
    // caster   - 施法者（可为 null，仅视觉移动）
    // startX, startY - 弹道起点坐标
    // targetX, targetY - 弹道终点坐标
    // onComplete - 完成回调（可选）
    public function StartEffectMove(unit caster, real startX, real startY, real targetX, real targetY, code onComplete) -> timer {
        timer t;
        timer result;
        integer id;
        effect e;
        real facing;
        real range;
        real z;
        real cfgSpeed;
        string cfgModel;
        real cfgScale;
        real cfgHeight;
        real cfgTick;
        integer cfgDmgType;
        real cfgRadius;
        real cfgDamage;
        code cfgOnStep;
        trigger trComplete;
        trigger trStep;

        if (EffectMoveCfg.radius < 0.0 || EffectMoveCfg.damage < 0.0) {
            return null;
        }

        startX = YDWECoordinateX(startX);
        startY = YDWECoordinateY(startY);
        targetX = YDWECoordinateX(targetX);
        targetY = YDWECoordinateY(targetY);

        // 读取本次移动的配置（一次配置只影响一次移动）
        cfgSpeed   = EffectMoveCfg.speed;
        cfgModel   = EffectMoveCfg.modelPath;
        cfgScale   = EffectMoveCfg.scale;
        cfgHeight  = EffectMoveCfg.heightOffset;
        cfgTick    = EffectMoveCfg.tick;
        cfgDmgType = EffectMoveCfg.damageType;
        cfgRadius  = EffectMoveCfg.radius;
        cfgDamage  = EffectMoveCfg.damage;
        cfgOnStep  = EffectMoveCfg.onStep;

        // 防御性修正：避免 tick=0 导致 TimerStart(0) 以及 speed<=0 导致无限循环
        if (cfgTick <= 0.0) {
            cfgTick = EFFECTMOVE_TICK;
        }
        if (cfgSpeed <= 0.0) {
            cfgSpeed = EFFECTMOVE_SPEED;
        }
        if (cfgScale <= 0.0) {
            cfgScale = 1.0;
        }
        if (cfgModel == null || cfgModel == "") {
            cfgModel = EFFECTMOVE_MODEL_PATH;
        }

        // 计算朝向和射程
        facing = GetFacing(startX, startY, targetX, targetY);
        range = GetDistance(startX, startY, targetX, targetY);

        // 初始高度
        z = I2R(GetTerrainCliffLevel(startX, startY)) * EFFECTMOVE_CLIFF_Z + cfgHeight;

        // 使用结构体数组配置的模型与缩放
        e = AddSpecialEffect(cfgModel, startX, startY);
        EXEffectMatRotateZ(e, facing);
        if (cfgScale != 1.0) {
            EXEffectMatScale(e, cfgScale, cfgScale, cfgScale);
        }
        DzSetEffectPos(e, startX, startY, z);

        t = CreateTimer();
        id = GetHandleId(t);

        SaveUnitHandle(HASH_TIMER, id, 1, caster);
        SaveEffectHandle(HASH_TIMER, id, 2, e);
        SaveReal(HASH_TIMER, id, 3, startX);
        SaveReal(HASH_TIMER, id, 4, startY);
        SaveReal(HASH_TIMER, id, 5, targetX);
        SaveReal(HASH_TIMER, id, 6, targetY);
        SaveReal(HASH_TIMER, id, 7, facing);
        SaveReal(HASH_TIMER, id, 8, cfgDamage);
        SaveReal(HASH_TIMER, id, 9, cfgRadius);
        SaveReal(HASH_TIMER, id, 10, range);
        SaveReal(HASH_TIMER, id, 11, 0.0); // travelled
        SaveReal(HASH_TIMER, id, 12, cfgSpeed);
        SaveReal(HASH_TIMER, id, 13, cfgHeight);
        SaveInteger(HASH_TIMER, id, 16, cfgDmgType);
        SaveReal(HASH_TIMER, id, 17, cfgTick);

        // 移动结束后恢复配置为默认值（避免影响后续移动）
        EffectMoveCfg.speed         = EFFECTMOVE_SPEED;
        EffectMoveCfg.modelPath     = EFFECTMOVE_MODEL_PATH;
        EffectMoveCfg.scale         = 1.0;
        EffectMoveCfg.heightOffset  = 0.0;
        EffectMoveCfg.tick          = EFFECTMOVE_TICK;
        EffectMoveCfg.damageType    = EFFECTMOVE_DMG_MAGIC;
        EffectMoveCfg.radius        = 0.0;
        EffectMoveCfg.damage        = 0.0;
        EffectMoveCfg.onStep        = null;

        // 包装回调为 trigger
        trComplete = null;
        trStep = null;
        if (onComplete != null) {
            trComplete = CreateTrigger();
            TriggerAddCondition(trComplete, Condition(onComplete));
        }
        if (cfgOnStep != null) {
            trStep = CreateTrigger();
            TriggerAddCondition(trStep, Condition(cfgOnStep));
        }
        SaveTriggerHandle(HASH_TIMER, id, 14, trComplete);
        SaveTriggerHandle(HASH_TIMER, id, 15, trStep);

        // 启动计时器
        TimerStart(t, cfgTick, true, function EffectMoveTimer);

        // 保存返回值
        result = t;

        // 清理局部变量
        e = null;
        trComplete = null;
        trStep = null;
        cfgModel = null;
        t = null;
        return result;
    }
}

//! endzinc
#endif
