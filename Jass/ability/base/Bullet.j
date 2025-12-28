#ifndef BulletIncluded
#define BulletIncluded

//! zinc
/*
子弹型特效(击中消失+回调)
非穿透弹道：命中第一个敌人即结束，或到达最大距离强制结束
*/

// 基本参数（默认值，可通过 BulletCfg 结构体覆盖）
#define BULLET_TICK              0.03
#define BULLET_SPEED             900.0
#define BULLET_CLIFF_Z           128.0
#define BULLET_MODEL_PATH        "Abilities\\Spells\\Undead\\CarrionSwarm\\CarrionSwarmMissile.mdl"

// 伤害类型常量
#define BULLET_DMG_PHYSICAL      1
#define BULLET_DMG_MAGIC         2
#define BULLET_DMG_PURE          3

library Bullet requires HashTable, DamageUtils, Geometry, GroupUtils {

    // 公共配置结构体数组：先修改这些静态成员，再调用 BulletCast（一次配置只影响一次 Cast）
    public struct BulletCfg []{
        public static real    speed         = BULLET_SPEED;          // 弹道速度
        public static string  modelPath     = BULLET_MODEL_PATH;     // 投射物模型
        public static real    scale         = 1.0;                   // 模型缩放
        public static string  hitEffectPath = "";                    // 击中特效模型
        public static integer damageType    = BULLET_DMG_MAGIC;      // 伤害类型
        public static real    heightOffset  = 0.0;                   // 投射物高度偏移（相对地形），默认 0
    }

    // 完成回调用上下文（类似 Mover 的 EffectMoveArgs）
    public struct BulletCompleteArgs []{
        public static timer t = null;
        public static unit caster = null;
        public static unit target = null;
        public static boolean hit = false;
        public static real x = 0.0;
        public static real y = 0.0;
    }

    public function BulletCompleteGetTimer() -> timer {
        return BulletCompleteArgs.t;
    }

    public function BulletCompleteGetCaster() -> unit {
        return BulletCompleteArgs.caster;
    }

    public function BulletCompleteGetTarget() -> unit {
        return BulletCompleteArgs.target;
    }

    public function BulletCompleteGetHit() -> boolean {
        return BulletCompleteArgs.hit;
    }

    public function BulletCompleteGetX() -> real {
        return BulletCompleteArgs.x;
    }

    public function BulletCompleteGetY() -> real {
        return BulletCompleteArgs.y;
    }

    // 回调参数（枚举 Filter 使用静态成员传参，避免哈希表冲突）
    private unit    bulletCbCaster        = null;
    private real    bulletCbDamage        = 0.0;
    private integer bulletCbDamageType    = 0;
    private string  bulletCbHitEffectPath = "";
    private unit    bulletCbFound         = null;

    // 计时器回调：推进弹道、枚举单位、结束时清理
    private function BulletTimer() {
        timer t;
        integer id;
        unit caster;
        effect e;
        real x;
        real y;
        real facing;
        real damage;
        real radius;
        real range;
        real travelled;
        real step;
        real z;
        real speed;
        real heightOffset;
        trigger trComplete;
        real endX;
        real endY;
        group enumGrp;
        unit hitTarget;
        effect he;
        boolean shouldEnd;
        integer cfgDmgType;
        string cfgHitPath;

        t = GetExpiredTimer();
        id = GetHandleId(t);

        caster       = LoadUnitHandle(HASH_TIMER, id, 1);
        e            = LoadEffectHandle(HASH_TIMER, id, 2);
        x            = LoadReal(HASH_TIMER, id, 3);
        y            = LoadReal(HASH_TIMER, id, 4);
        facing       = LoadReal(HASH_TIMER, id, 5);
        damage       = LoadReal(HASH_TIMER, id, 6);
        radius       = LoadReal(HASH_TIMER, id, 7);
        range        = LoadReal(HASH_TIMER, id, 8);
        travelled    = LoadReal(HASH_TIMER, id, 9);
        speed        = LoadReal(HASH_TIMER, id, 11);
        heightOffset = LoadReal(HASH_TIMER, id, 16);
        trComplete   = LoadTriggerHandle(HASH_TIMER, id, 18);
        endX         = LoadReal(HASH_TIMER, id, 20);
        endY         = LoadReal(HASH_TIMER, id, 21);
        cfgDmgType   = LoadInteger(HASH_TIMER, id, 13);
        cfgHitPath   = LoadStr(HASH_TIMER, id, 14);

        shouldEnd = false;
        hitTarget = null;
        enumGrp = null;
        he = null;

        // 失效或超出射程：强制结束
        if (caster == null || e == null || travelled >= range) {
            shouldEnd = true;
            // 使用保存的终点坐标（如果是 BulletCastToPoint）或当前位置
            if (endX != 0.0 || endY != 0.0) {
                x = endX;
                y = endY;
            }
        } else {
            // 前进一小步（每个弹道独立速度）
            step = speed * BULLET_TICK;
            x = x + step * CosBJ(facing);
            y = y + step * SinBJ(facing);
            x = YDWECoordinateX(x);
            y = YDWECoordinateY(y);
            travelled = travelled + step;

            SaveReal(HASH_TIMER, id, 3, x);
            SaveReal(HASH_TIMER, id, 4, y);
            SaveReal(HASH_TIMER, id, 9, travelled);

            // 根据当前地形高度设置 Z
            z = I2R(GetTerrainCliffLevel(x, y)) * BULLET_CLIFF_Z + heightOffset;
            DzSetEffectPos(e, x, y, z);

            // 临时 Group 枚举周围单位，命中第一个敌人即结束
            enumGrp = CreateGroup();

            bulletCbCaster        = caster;
            bulletCbDamage        = damage;
            bulletCbDamageType    = cfgDmgType;
            bulletCbHitEffectPath = cfgHitPath;
            bulletCbFound         = null;

            GroupEnumUnitsInRangeEx(enumGrp, x, y, radius, Filter(function () -> boolean {
                unit u;

                u = GetFilterUnit();
                // 只命中第一个枚举到的敌人
                if (u != null && IsEnemy(u, GetOwningPlayer(bulletCbCaster))) {
                    if (bulletCbFound == null) {
                        bulletCbFound = u;
                        u = null;
                        return true;
                    }
                }

                u = null;
                return false;
            }));

            // 如果找到目标，立即结束并结算伤害
            if (bulletCbFound != null) {
                hitTarget = bulletCbFound;
                shouldEnd = true;

                // 只有 damage >= 1.0 时才造成伤害与特效
                if (bulletCbDamage >= 1.0) {
                    // 根据配置的伤害类型结算伤害
                    if (bulletCbDamageType == BULLET_DMG_PHYSICAL) {
                        ApplyPhysicalDamage(bulletCbCaster, hitTarget, bulletCbDamage);
                    } else if (bulletCbDamageType == BULLET_DMG_PURE) {
                        ApplyPureDamage(bulletCbCaster, hitTarget, bulletCbDamage);
                    } else {
                        ApplyMagicDamage(bulletCbCaster, hitTarget, bulletCbDamage);
                    }

                    // 击中特效（可选）
                    if (bulletCbHitEffectPath != "") {
                        he = AddSpecialEffect(bulletCbHitEffectPath, GetUnitX(hitTarget), GetUnitY(hitTarget));
                        DestroyEffect(he);
                        he = null;
                    }
                }
            }

            DestroyGroup(enumGrp);
            enumGrp = null;

            bulletCbCaster  = null;
            bulletCbDamage  = 0.0;
            bulletCbFound   = null;
        }

        // 如果结束，执行清理
        if (shouldEnd) {
            // 完成回调（如果有）：优先回调，再清理 HASH_TIMER
            if (trComplete != null) {
                BulletCompleteArgs.t = t;
                BulletCompleteArgs.caster = caster;
                BulletCompleteArgs.target = hitTarget;
                BulletCompleteArgs.hit = (hitTarget != null);
                BulletCompleteArgs.x = x;
                BulletCompleteArgs.y = y;
                TriggerEvaluate(trComplete);
                BulletCompleteArgs.t = null;
                BulletCompleteArgs.caster = null;
                BulletCompleteArgs.target = null;
                BulletCompleteArgs.hit = false;
                BulletCompleteArgs.x = 0.0;
                BulletCompleteArgs.y = 0.0;
            }

            // 清理资源
            if (e != null) {
                DestroyEffect(e);
            }
            if (trComplete != null) {
                DestroyTrigger(trComplete);
            }

            FlushChildHashtable(HASH_TIMER, id);
            PauseTimer(t);
            DestroyTimer(t);

            e          = null;
            caster     = null;
            hitTarget  = null;
            trComplete = null;
            t          = null;
            return;
        }

        // 继续运行，只清理局部变量
        caster = null;
        e      = null;
        trComplete = null;
        t      = null;
    }

    // 对外入口：
    // caster   - 施法者
    // x, y     - 弹道起点坐标
    // facing   - 初始朝向（角度）
    // damage   - 对目标造成的伤害
    // radius   - 命中检测半径
    // range    - 最远射程（超过后弹道结束）
    // onComplete - 完成回调（可选）
    public function BulletCast(unit caster, real x, real y, real facing, real damage, real radius, real range, code onComplete) -> timer {
        timer t;
        integer id;
        effect e;
        real z;
        real cfgSpeed;
        string cfgModel;
        real cfgScale;
        string cfgHitPath;
        integer cfgDmgType;
        real cfgHeight;
        trigger trComplete;

        if (caster == null || range <= 0.0 || radius <= 0.0 || damage <= 0.0) {
            return null;
        }

        x = YDWECoordinateX(x);
        y = YDWECoordinateY(y);

        // 读取本次 Cast 的配置（一次配置只影响一次 Cast）
        cfgSpeed   = BulletCfg.speed;
        cfgModel   = BulletCfg.modelPath;
        cfgScale   = BulletCfg.scale;
        cfgHitPath = BulletCfg.hitEffectPath;
        cfgDmgType = BulletCfg.damageType;
        cfgHeight  = BulletCfg.heightOffset;

        // 初始高度
        z = I2R(GetTerrainCliffLevel(x, y)) * BULLET_CLIFF_Z + cfgHeight;

        // 使用结构体数组配置的模型与缩放
        e = AddSpecialEffect(cfgModel, x, y);
        EXEffectMatRotateZ(e, facing);
        if (cfgScale != 1.0) {
            EXEffectMatScale(e, cfgScale, cfgScale, cfgScale);
        }
        DzSetEffectPos(e, x, y, z);

        t = CreateTimer();
        id = GetHandleId(t);

        SaveUnitHandle(HASH_TIMER, id, 1, caster);
        SaveEffectHandle(HASH_TIMER, id, 2, e);
        SaveReal(HASH_TIMER, id, 3, x);
        SaveReal(HASH_TIMER, id, 4, y);
        SaveReal(HASH_TIMER, id, 5, facing);
        SaveReal(HASH_TIMER, id, 6, damage);
        SaveReal(HASH_TIMER, id, 7, radius);
        SaveReal(HASH_TIMER, id, 8, range);
        SaveReal(HASH_TIMER, id, 9, 0.0); // travelled
        SaveReal(HASH_TIMER, id, 11, cfgSpeed);
        SaveInteger(HASH_TIMER, id, 13, cfgDmgType);
        SaveStr(HASH_TIMER, id, 14, cfgHitPath);
        SaveReal(HASH_TIMER, id, 16, cfgHeight);
        SaveReal(HASH_TIMER, id, 20, 0.0); // endX（BulletCast 不使用）
        SaveReal(HASH_TIMER, id, 21, 0.0); // endY（BulletCast 不使用）

        // Cast 结束后恢复配置为默认值（避免影响后续 Cast）
        BulletCfg.speed         = BULLET_SPEED;
        BulletCfg.modelPath     = BULLET_MODEL_PATH;
        BulletCfg.scale         = 1.0;
        BulletCfg.hitEffectPath = "";
        BulletCfg.damageType    = BULLET_DMG_MAGIC;
        BulletCfg.heightOffset  = 0.0;

        // 包装完成回调为 trigger（与 Mover 风格一致）
        trComplete = null;
        if (onComplete != null) {
            trComplete = CreateTrigger();
            TriggerAddCondition(trComplete, Condition(onComplete));
            SaveTriggerHandle(HASH_TIMER, id, 18, trComplete);
        }

        TimerStart(t, BULLET_TICK, true, function BulletTimer);

        e          = null;
        cfgModel   = null;
        cfgHitPath = null;
        trComplete = null;
        return t;
    }

    //# check: BulletCastToPoint
    // 点到点子弹入口（类似 Mover.StartEffectMove 的 onComplete）：
    // 从 (startX,startY) 直线飞到 (targetX,targetY)，命中第一个敌人即结束，或到达目标点强制结束，结束时触发 onComplete。
    // 说明：onComplete 回调中可用 BulletCompleteGetTimer() 取回 timer，并通过 HASH_TIMER 读取你自存的参数。
    public function BulletCastToPoint(unit caster, real startX, real startY, real targetX, real targetY, real damage, real radius, code onComplete) -> timer {
        timer t;
        timer result;
        integer id;
        effect e;
        real z;
        real cfgSpeed;
        string cfgModel;
        real cfgScale;
        string cfgHitPath;
        integer cfgDmgType;
        real cfgHeight;
        trigger trComplete;
        real dx;
        real dy;
        real facing;
        real range;

        if (caster == null || radius <= 0.0 || damage <= 0.0) {
            return null;
        }

        startX = YDWECoordinateX(startX);
        startY = YDWECoordinateY(startY);
        targetX = YDWECoordinateX(targetX);
        targetY = YDWECoordinateY(targetY);

        dx = targetX - startX;
        dy = targetY - startY;
        range = SquareRoot(dx * dx + dy * dy);
        if (range <= 0.0) {
            return null;
        }
        facing = Atan2(dy, dx) * bj_RADTODEG;

        // 读取本次 Cast 的配置（一次配置只影响一次 Cast）
        cfgSpeed   = BulletCfg.speed;
        cfgModel   = BulletCfg.modelPath;
        cfgScale   = BulletCfg.scale;
        cfgHitPath = BulletCfg.hitEffectPath;
        cfgDmgType = BulletCfg.damageType;
        cfgHeight  = BulletCfg.heightOffset;

        // 初始高度
        z = I2R(GetTerrainCliffLevel(startX, startY)) * BULLET_CLIFF_Z + cfgHeight;

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
        SaveReal(HASH_TIMER, id, 5, facing);
        SaveReal(HASH_TIMER, id, 6, damage);
        SaveReal(HASH_TIMER, id, 7, radius);
        SaveReal(HASH_TIMER, id, 8, range);
        SaveReal(HASH_TIMER, id, 9, 0.0); // travelled
        SaveReal(HASH_TIMER, id, 11, cfgSpeed);
        SaveInteger(HASH_TIMER, id, 13, cfgDmgType);
        SaveStr(HASH_TIMER, id, 14, cfgHitPath);
        SaveReal(HASH_TIMER, id, 16, cfgHeight);

        // 保存"期望结束点"（给完成回调使用）
        SaveReal(HASH_TIMER, id, 20, targetX);
        SaveReal(HASH_TIMER, id, 21, targetY);

        // Cast 结束后恢复配置为默认值（避免影响后续 Cast）
        BulletCfg.speed         = BULLET_SPEED;
        BulletCfg.modelPath     = BULLET_MODEL_PATH;
        BulletCfg.scale         = 1.0;
        BulletCfg.hitEffectPath = "";
        BulletCfg.damageType    = BULLET_DMG_MAGIC;
        BulletCfg.heightOffset  = 0.0;

        // 包装完成回调为 trigger（与 Mover 风格一致）
        trComplete = null;
        if (onComplete != null) {
            trComplete = CreateTrigger();
            TriggerAddCondition(trComplete, Condition(onComplete));
            SaveTriggerHandle(HASH_TIMER, id, 18, trComplete);
        }

        TimerStart(t, BULLET_TICK, true, function BulletTimer);
        result = t;

        e          = null;
        cfgModel   = null;
        cfgHitPath = null;
        trComplete = null;
        t          = null;
        return result;
    }
    //# endcheck
}

//! endzinc
#endif
