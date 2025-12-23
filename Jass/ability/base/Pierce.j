#ifndef PierceIncluded
#define PierceIncluded

//! zinc
/*
穿刺型技能模拟
使用计时器 + HASH_TIMER + 枚举 Group，实现直线穿透弹道。
首版：通过结构体数组配置速度/模型/缩放/击中特效/伤害类型，每单位最多命中一次。
*/


// 基本参数（默认值，可通过 PierceCfg 结构体覆盖）
#define PIERCE_TICK              0.03
#define PIERCE_SPEED             900.0
#define PIERCE_CLIFF_Z           128.0
#define PIERCE_MODEL_PATH        "Abilities\\Spells\\Undead\\CarrionSwarm\\CarrionSwarmMissile.mdl"

// 伤害类型常量
#define PIERCE_DMG_PHYSICAL      1
#define PIERCE_DMG_MAGIC         2
#define PIERCE_DMG_PURE          3

library Pierce requires DamageUtils {

    // 公共配置结构体数组：先修改这些静态成员，再调用 PierceCast（一次配置只影响一次 Cast）
    public struct PierceCfg []{
        public static real    speed         = PIERCE_SPEED;          // 弹道速度
        public static string  modelPath     = PIERCE_MODEL_PATH;     // 投射物模型
        public static real    scale         = 1.0;                   // 模型缩放
        public static string  hitEffectPath = "";                    // 击中特效模型
        public static integer damageType    = PIERCE_DMG_MAGIC;      // 伤害类型
        public static real    heightOffset  = 0.0;                   // 投射物高度偏移（相对地形），默认 0
        public static trigger trMatch       = null;                  // 全局匹配到单位的回调（模板）

        static method registerMatchEnemy(code func) {
            if (trMatch == null) {
                trMatch = CreateTrigger();
            }
            TriggerAddCondition(trMatch, Condition(func));
        }
    }

    // 匹配回调时使用的参数结构体（全局静态变量作为回调上下文，回调结束后会自动清空）
    public struct PierceMatchArgs []{
        public static unit caster = null;
        public static unit target = null;
        public static real damage = 0.0; // 回调中可修改伤害值，只有 damage >= 1.0 时才会造成伤害
    }

    // 兼容函数：获取当前匹配到的单位
    public function PierceMatchEnemy () -> unit { return PierceMatchArgs.target;}

    // 完成回调用上下文（类似 Mover 的 EffectMoveArgs）
    public struct PierceCompleteArgs []{
        public static timer t = null;
        public static real x = 0.0;
        public static real y = 0.0;
    }

    public function PierceCompleteGetTimer() -> timer {
        return PierceCompleteArgs.t;
    }

    public function PierceCompleteGetX() -> real {
        return PierceCompleteArgs.x;
    }

    public function PierceCompleteGetY() -> real {
        return PierceCompleteArgs.y;
    }

    // 回调参数（枚举 Filter 使用静态成员传参，避免哈希表冲突）
    private unit    pierceCbCaster        = null;
    private group   pierceCbHitGrp        = null;
    private real    pierceCbDamage        = 0.0;
    private integer pierceCbDamageType    = 0;
    private string  pierceCbHitEffectPath = "";
    private trigger pierceCbMatchTr       = null;

    // 计时器回调：推进弹道、枚举单位、结束时清理
    private function PierceTimer() {
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
        group hitGrp;
        group enumGrp;
        real speed;
        real heightOffset;
        trigger matchTr;
        trigger trComplete;
        real endX;
        real endY;

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
        hitGrp       = LoadGroupHandle(HASH_TIMER, id, 10);
        speed        = LoadReal(HASH_TIMER, id, 11);
        heightOffset = LoadReal(HASH_TIMER, id, 16);
        matchTr      = LoadTriggerHandle(HASH_TIMER, id, 15);
        trComplete   = LoadTriggerHandle(HASH_TIMER, id, 18);
        endX         = LoadReal(HASH_TIMER, id, 20);
        endY         = LoadReal(HASH_TIMER, id, 21);

        // 失效或超出射程：清理
        if (caster == null || e == null || travelled >= range) {
            // 完成回调（如果有）：优先回调，再清理 HASH_TIMER
            if (trComplete != null) {
                PierceCompleteArgs.t = t;
                PierceCompleteArgs.x = endX;
                PierceCompleteArgs.y = endY;
                TriggerEvaluate(trComplete);
                PierceCompleteArgs.t = null;
                PierceCompleteArgs.x = 0.0;
                PierceCompleteArgs.y = 0.0;
            }

            if (e != null) {
                DestroyEffect(e);
            }
            if (hitGrp != null) {
                DestroyGroup(hitGrp);
            }
            if (matchTr != null) {
                DestroyTrigger(matchTr);
            }
            if (trComplete != null) {
                DestroyTrigger(trComplete);
            }

            FlushChildHashtable(HASH_TIMER, id);
            PauseTimer(t);
            DestroyTimer(t);

            e       = null;
            caster  = null;
            hitGrp   = null;
            matchTr  = null;
            trComplete = null;
            t       = null;
            return;
        }

        // 前进一小步（每个弹道独立速度）
        step = speed * PIERCE_TICK;
        x = x + step * CosBJ(facing);
        y = y + step * SinBJ(facing);
        x = YDWECoordinateX(x);
        y = YDWECoordinateY(y);
        travelled = travelled + step;

        SaveReal(HASH_TIMER, id, 3, x);
        SaveReal(HASH_TIMER, id, 4, y);
        SaveReal(HASH_TIMER, id, 9, travelled);

        // 根据当前地形高度设置 Z（类似 AJZ2_CLIFF_Z）
        z = I2R(GetTerrainCliffLevel(x, y)) * PIERCE_CLIFF_Z + heightOffset;
        DzSetEffectPos(e, x, y, z);

        // 临时 Group 枚举周围单位，每个单位只命中一次
        enumGrp = CreateGroup();

        pierceCbCaster        = caster;
        pierceCbHitGrp        = hitGrp;
        pierceCbDamage        = damage;
        pierceCbDamageType    = LoadInteger(HASH_TIMER, id, 13);
        pierceCbHitEffectPath = LoadStr(HASH_TIMER, id, 14);
        pierceCbMatchTr       = matchTr;

        GroupEnumUnitsInRangeEx(enumGrp, x, y, radius, Filter(function () -> boolean{
            // 穿刺枚举 Filter：只对还没被该弹道命中的敌单位造成一次伤害
            unit u;
            effect he;

            u = GetFilterUnit();
            if (u != null && IsEnemy(u, GetOwningPlayer(pierceCbCaster))) {
                if (!IsUnitInGroup(u, pierceCbHitGrp)) {
                    GroupAddUnit(pierceCbHitGrp, u);

                    // 设置回调上下文（可在回调中修改 damage）
                    PierceMatchArgs.caster = pierceCbCaster;
                    PierceMatchArgs.target = u;
                    PierceMatchArgs.damage = pierceCbDamage;

                    // 如果注册了匹配回调，先执行回调逻辑
                    if (pierceCbMatchTr != null) {
                        TriggerEvaluate(pierceCbMatchTr);
                    }

                    // 只有 damage >= 1.0 时才造成伤害与特效
                    if (PierceMatchArgs.damage >= 1.0) {
                        // 根据配置的伤害类型结算伤害（允许回调修改伤害值）
                        if (pierceCbDamageType == PIERCE_DMG_PHYSICAL) {
                            ApplyPhysicalDamage(pierceCbCaster, u, PierceMatchArgs.damage);
                        } else if (pierceCbDamageType == PIERCE_DMG_PURE) {
                            ApplyPureDamage(pierceCbCaster, u, PierceMatchArgs.damage);
                        } else {
                            ApplyMagicDamage(pierceCbCaster, u, PierceMatchArgs.damage);
                        }

                        // 击中特效（可选，允许回调修改路径）
                        if (pierceCbHitEffectPath != "") {
                            he = AddSpecialEffect(pierceCbHitEffectPath, GetUnitX(u), GetUnitY(u));
                            DestroyEffect(he);
                            he = null;
                        }
                    }

                    // 清理回调上下文
                    PierceMatchArgs.caster = null;
                    PierceMatchArgs.target = null;
                    PierceMatchArgs.damage = 0.0;

                    u = null;
                    return true;
                }
            }

            u = null;
            return false;

        }));

        DestroyGroup(enumGrp);
        enumGrp = null;

        pierceCbCaster  = null;
        pierceCbHitGrp  = null;
        pierceCbDamage  = 0.0;

        caster = null;
        e      = null;
        hitGrp = null;
        enumGrp = null;
        t      = null;
        matchTr = null;
        trComplete = null;
    }

    // 对外入口：
    // caster   - 施法者
    // x, y     - 弹道起点坐标
    // facing   - 初始朝向（角度）
    // damage   - 对每个单位造成的魔法伤害
    // radius   - 穿刺检测半径
    // range    - 最远射程（超过后弹道结束）
    public function PierceCast(unit caster, real x, real y, real facing, real damage, real radius, real range) {
        timer t;
        integer id;
        effect e;
        group hitGrp;
        real z;
        real cfgSpeed;
        string cfgModel;
        real cfgScale;
        string cfgHitPath;
        integer cfgDmgType;
        real cfgHeight;
        trigger cfgMatchTr;

        if (caster == null || range <= 0.0 || radius <= 0.0 || damage <= 0.0) {
            return;
        }

        x = YDWECoordinateX(x);
        y = YDWECoordinateY(y);

        // 读取本次 Cast 的配置（一次配置只影响一次 Cast）
        cfgSpeed   = PierceCfg.speed;
        cfgModel   = PierceCfg.modelPath;
        cfgScale   = PierceCfg.scale;
        cfgHitPath = PierceCfg.hitEffectPath;
        cfgDmgType = PierceCfg.damageType;
        cfgHeight  = PierceCfg.heightOffset;
        cfgMatchTr = PierceCfg.trMatch;

        // 初始高度
        z = I2R(GetTerrainCliffLevel(x, y)) * PIERCE_CLIFF_Z + cfgHeight;

        // 使用结构体数组配置的模型与缩放
        e = AddSpecialEffect(cfgModel, x, y);
        EXEffectMatRotateZ(e, facing);
        if (cfgScale != 1.0) {
            EXEffectMatScale(e, cfgScale, cfgScale, cfgScale);
        }
        DzSetEffectPos(e, x, y, z);

        hitGrp = CreateGroup();

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
        SaveGroupHandle(HASH_TIMER, id, 10, hitGrp);
        SaveReal(HASH_TIMER, id, 11, cfgSpeed);
        SaveReal(HASH_TIMER, id, 12, cfgScale);
        SaveInteger(HASH_TIMER, id, 13, cfgDmgType);
        SaveStr(HASH_TIMER, id, 14, cfgHitPath);
        SaveReal(HASH_TIMER, id, 16, cfgHeight);
        if (cfgMatchTr != null) {
            SaveTriggerHandle(HASH_TIMER, id, 15, cfgMatchTr);
        }

        // Cast 结束后恢复配置为默认值（避免影响后续 Cast）
        PierceCfg.speed         = PIERCE_SPEED;
        PierceCfg.modelPath     = PIERCE_MODEL_PATH;
        PierceCfg.scale         = 1.0;
        PierceCfg.hitEffectPath = "";
        PierceCfg.damageType    = PIERCE_DMG_MAGIC;
        PierceCfg.heightOffset  = 0.0;
        PierceCfg.trMatch       = null;

        TimerStart(t, PIERCE_TICK, true, function PierceTimer);

        e          = null;
        hitGrp     = null;
        cfgModel   = null;
        cfgHitPath = null;
        t          = null;
        cfgMatchTr = null;
    }

    // 点到点穿刺入口（类似 Mover.StartEffectMove 的 onComplete）：
    // 从 (startX,startY) 直线飞到 (targetX,targetY)，沿途每单位最多命中一次，结束时触发 onComplete。
    // 说明：onComplete 回调中可用 PierceCompleteGetTimer() 取回 timer，并通过 HASH_TIMER 读取你自存的参数。
    public function PierceCastToPoint(unit caster, real startX, real startY, real targetX, real targetY, real damage, real radius, code onComplete) -> timer {
        timer t;
        timer result;
        integer id;
        effect e;
        group hitGrp;
        real z;
        real cfgSpeed;
        string cfgModel;
        real cfgScale;
        string cfgHitPath;
        integer cfgDmgType;
        real cfgHeight;
        trigger cfgMatchTr;
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
        cfgSpeed   = PierceCfg.speed;
        cfgModel   = PierceCfg.modelPath;
        cfgScale   = PierceCfg.scale;
        cfgHitPath = PierceCfg.hitEffectPath;
        cfgDmgType = PierceCfg.damageType;
        cfgHeight  = PierceCfg.heightOffset;
        cfgMatchTr = PierceCfg.trMatch;

        // 初始高度
        z = I2R(GetTerrainCliffLevel(startX, startY)) * PIERCE_CLIFF_Z + cfgHeight;

        // 使用结构体数组配置的模型与缩放
        e = AddSpecialEffect(cfgModel, startX, startY);
        EXEffectMatRotateZ(e, facing);
        if (cfgScale != 1.0) {
            EXEffectMatScale(e, cfgScale, cfgScale, cfgScale);
        }
        DzSetEffectPos(e, startX, startY, z);

        hitGrp = CreateGroup();

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
        SaveGroupHandle(HASH_TIMER, id, 10, hitGrp);
        SaveReal(HASH_TIMER, id, 11, cfgSpeed);
        SaveReal(HASH_TIMER, id, 12, cfgScale);
        SaveInteger(HASH_TIMER, id, 13, cfgDmgType);
        SaveStr(HASH_TIMER, id, 14, cfgHitPath);
        SaveReal(HASH_TIMER, id, 16, cfgHeight);
        if (cfgMatchTr != null) {
            SaveTriggerHandle(HASH_TIMER, id, 15, cfgMatchTr);
        }

        // 保存“期望结束点”（给完成回调使用）
        SaveReal(HASH_TIMER, id, 20, targetX);
        SaveReal(HASH_TIMER, id, 21, targetY);

        // 包装完成回调为 trigger（与 Mover 风格一致）
        trComplete = null;
        if (onComplete != null) {
            trComplete = CreateTrigger();
            TriggerAddCondition(trComplete, Condition(onComplete));
            SaveTriggerHandle(HASH_TIMER, id, 18, trComplete);
        }

        // Cast 结束后恢复配置为默认值（避免影响后续 Cast）
        PierceCfg.speed         = PIERCE_SPEED;
        PierceCfg.modelPath     = PIERCE_MODEL_PATH;
        PierceCfg.scale         = 1.0;
        PierceCfg.hitEffectPath = "";
        PierceCfg.damageType    = PIERCE_DMG_MAGIC;
        PierceCfg.heightOffset  = 0.0;
        PierceCfg.trMatch       = null;

        TimerStart(t, PIERCE_TICK, true, function PierceTimer);
        result = t;

        e          = null;
        hitGrp     = null;
        cfgModel   = null;
        cfgHitPath = null;
        cfgMatchTr = null;
        trComplete = null;
        t          = null;
        return result;
    }
}

//! endzinc
#endif
