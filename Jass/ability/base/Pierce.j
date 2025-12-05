#ifndef PierceIncluded
#define PierceIncluded

//! zinc
/*
穿刺型技能模拟
使用计时器 + HASH_TIMER + 共享枚举 Group，实现直线穿透弹道。
首版：固定模型，魔法伤害，每单位最多命中一次。
*/
library Pierce requires DamageUtils {

    // 基本参数
    #define PIERCE_TICK          0.03
    #define PIERCE_SPEED         900.0
    #define PIERCE_CLIFF_Z       128.0
    #define PIERCE_MODEL_PATH    "effects\\pierce.mdl"

    // 共享枚举 Group（全局复用，避免每帧创建/销毁）
    private group pierceEnumGroup = null;

    // 回调参数（枚举 Filter 使用静态成员传参，避免哈希表冲突）
    private unit  pierceCbCaster  = null;
    private group pierceCbHitGrp  = null;
    private real  pierceCbDamage  = 0.0;

    // 穿刺枚举 Filter：只对还没被该弹道命中的敌单位造成一次伤害
    private function PierceFilter() -> boolean {
        unit u;

        u = GetFilterUnit();
        if (u != null && IsEnemy(u, GetOwningPlayer(pierceCbCaster))) {
            if (!IsUnitInGroup(u, pierceCbHitGrp)) {
                GroupAddUnit(pierceCbHitGrp, u);
                ApplyMagicDamage(pierceCbCaster, u, pierceCbDamage);
                u = null;
                return true;
            }
        }

        u = null;
        return false;
    }

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

        t = GetExpiredTimer();
        id = GetHandleId(t);

        caster    = LoadUnitHandle(HASH_TIMER, id, 1);
        e         = LoadEffectHandle(HASH_TIMER, id, 2);
        x         = LoadReal(HASH_TIMER, id, 3);
        y         = LoadReal(HASH_TIMER, id, 4);
        facing    = LoadReal(HASH_TIMER, id, 5);
        damage    = LoadReal(HASH_TIMER, id, 6);
        radius    = LoadReal(HASH_TIMER, id, 7);
        range     = LoadReal(HASH_TIMER, id, 8);
        travelled = LoadReal(HASH_TIMER, id, 9);
        hitGrp    = LoadGroupHandle(HASH_TIMER, id, 10);

        // 失效或超出射程：清理
        if (caster == null || e == null || travelled >= range) {
            if (e != null) {
                DestroyEffect(e);
            }
            if (hitGrp != null) {
                DestroyGroup(hitGrp);
            }

            FlushChildHashtable(HASH_TIMER, id);
            PauseTimer(t);
            DestroyTimer(t);

            e      = null;
            caster = null;
            hitGrp = null;
            t      = null;
            return;
        }

        // 前进一小步
        step = PIERCE_SPEED * PIERCE_TICK;
        x = x + step * CosBJ(facing);
        y = y + step * SinBJ(facing);
        x = YDWECoordinateX(x);
        y = YDWECoordinateY(y);
        travelled = travelled + step;

        SaveReal(HASH_TIMER, id, 3, x);
        SaveReal(HASH_TIMER, id, 4, y);
        SaveReal(HASH_TIMER, id, 9, travelled);

        // 根据当前地形高度设置 Z（类似 AJZ2_CLIFF_Z）
        z = I2R(GetTerrainCliffLevel(x, y)) * PIERCE_CLIFF_Z + GetUnitFlyHeight(caster) + 50.0;
        EXSetEffectXY(e, x, y);
        EXSetEffectZ(e, z);

        // 用共享 Group 枚举周围单位，每个单位只命中一次
        if (pierceEnumGroup == null) {
            pierceEnumGroup = CreateGroup();
        } else {
            GroupClear(pierceEnumGroup);
        }

        pierceCbCaster = caster;
        pierceCbHitGrp = hitGrp;
        pierceCbDamage = damage;

        GroupEnumUnitsInRangeEx(pierceEnumGroup, x, y, radius, Filter(function PierceFilter));

        pierceCbCaster = null;
        pierceCbHitGrp = null;
        pierceCbDamage = 0.0;

        caster = null;
        e      = null;
        hitGrp = null;
        t      = null;
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

        if (caster == null || range <= 0.0 || radius <= 0.0 || damage <= 0.0) {
            return;
        }

        x = YDWECoordinateX(x);
        y = YDWECoordinateY(y);

        z = I2R(GetTerrainCliffLevel(x, y)) * PIERCE_CLIFF_Z + GetUnitFlyHeight(caster) + 50.0;

        // 首版用固定模型，后续可以通过“结构体数组配置”扩展不同模型、特效等
        e = AddSpecialEffect(PIERCE_MODEL_PATH, x, y);
        EXEffectMatRotateZ(e, facing);
        EXSetEffectZ(e, z);

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

        TimerStart(t, PIERCE_TICK, true, function PierceTimer);

        e      = null;
        hitGrp = null;
        t      = null;
    }

    function onInit ()  {
        // 共享 Group 懒初始化即可，这里不强制创建
    }
}

//! endzinc
#endif
