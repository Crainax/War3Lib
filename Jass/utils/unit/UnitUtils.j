#ifndef UnitUtilsIncluded
#define UnitUtilsIncluded

#include "Crainax/core/constant/JapiConstant.j" //constant可以直接加进去没问题
#include "Crainax/core/table/Hash_UnitDefine.j"

//! zinc
/*
单位有关的增强功能
*/
library UnitUtils {

    public struct unitAttrObserver [] {

        public static unit argsU = null;
        public static trigger attackIntervalCB = null;

        //攻击间隔的观察者事件注册
        public static method registerAttackInterval (code func) {
            if (attackIntervalCB == null) {
                attackIntervalCB = CreateTrigger();
            }
            TriggerAddCondition(attackIntervalCB, Condition(func));
        }

    }

    //获取单位的攻击力/防御/生命/魔法值
    // 支持超过 21 亿的扩展攻击力：
    //  - 当攻击力大于 10 亿时，内部会自动按 10 的 n 次方进行缩放存储，
    //    实际存入引擎的攻击值为 attack / pow(10, n)，并在 HASH_UNIT 中记录 n 与 10^n
    //  - 此处读取时会将引擎中的攻击值乘以 10^n 还原为真实攻击力
    public function GetUnitAttack(unit u) -> real {
        real base; integer uid; real factor;

        uid = GetHandleId(u);
        base = GetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE));

        // 如果存在攻击扩展倍数，则还原为真实攻击力
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR)) {
            factor = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR);
            return base * factor;
        }

        return base;
    }

    public function GetUnitDefense(unit u) -> integer {
        return R2I(GetUnitState(u,ConvertUnitState(UNIT_STATE_ARMOR)));
    }

    public function GetUnitHP(unit u) -> real {
        return GetUnitState(u,UNIT_STATE_MAX_LIFE);
    }

    public function GetUnitMP(unit u) -> real {
        return GetUnitState(u,UNIT_STATE_MAX_MANA);
    }

    // 获取当前单位攻击力的扩展倍数（10 的 n 次方，使用 real 存储）
    //  - 当未使用扩展（即攻击力未超过 10 亿时），直接返回 0.0
    //  - 当返回值 > 0 时，表示真实攻击力 = 引擎攻击值 * 返回值
    public function GetUnitAttackMult(unit u) -> real {
        integer uid;

        uid = GetHandleId(u);
        if (!HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR)) {
            return 0.0;
        }

        return LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR);
    }

    //设置攻击力（支持超过 21 亿）
    public function SetUnitAttack(unit u, real attack) -> nothing {
        real value; integer uid; integer n; integer i; real factor;

        uid = GetHandleId(u);
        value = attack;
        n = 0;

        // 大于 10 亿才开始缩放，避免不必要的精度损失
        if (value > 1000000000.0) {
            // 每次 /10，直到不大于 10 亿，或达到安全指数上限
            while (value > 1000000000.0 && n < 30) {
                value = value / 10.0;
                n = n + 1;
            }
        }

        // 根据 n 计算 10^n 的倍数（real），并保存
        if (n > 0) {
            factor = 1.0;
            i = 0;
            while (i < n) {
                factor = factor * 10.0;
                i = i + 1;
            }

            // 保存扩展信息：指数 n 和倍数 10^n（real）
            SaveInteger(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_EXP, n);
            SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR, factor);
        } else {
            // 没有扩展时，清理掉之前的扩展记录
            if (HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_EXP)) {
                RemoveSavedInteger(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_EXP);
            }
            if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR)) {
                RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR);
            }
        }

        // 实际写入引擎的攻击值（已缩放）
        SetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE), value);
    }

    //增加攻击力（支持超过 21 亿）
    public function AddUnitAttack(unit u, real attack) -> nothing {
        SetUnitAttack(u, GetUnitAttack(u) + attack);
    }

    //设置防御
    public function SetUnitDefense(unit u, real defense) -> nothing {
        SetUnitState(u,ConvertUnitState(UNIT_STATE_ARMOR),defense);
    }
    //增加防御
    public function AddUnitDefense(unit u, real defense) -> nothing {
        SetUnitDefense(u,GetUnitDefense(u)+defense);
    }

    //修改生命最大值
    public function SetUnitHP(unit u, real hp) -> nothing {
        SetUnitState(u,UNIT_STATE_MAX_LIFE,RMaxBJ(hp,2.0));
    }
    //增加生命最大值
    public function AddUnitHP(unit u,real hp ) {
        SetUnitHP(u,RMaxBJ(GetUnitHP(u)+hp,10.0));
        if (hp > 0) {SetUnitLifeBJ(u,GetUnitState(u,UNIT_STATE_LIFE)+hp);}
    }
    //回血(定值)
    public function RegenUnitHP(unit u, real volume) -> nothing {
        SetUnitLifeBJ(u,GetUnitState(u,UNIT_STATE_LIFE)+volume);
    }
    //回蓝(百分比)
    public function RegenUnitHPPercent(unit u, real rate) -> nothing {
        SetUnitLifeBJ(u,GetUnitState(u,UNIT_STATE_LIFE)+GetUnitHP(u)*rate);
    }

    //设置魔法最大值
    public function SetUnitMP(unit u, real mp) -> nothing {
        SetUnitState(u,UNIT_STATE_MAX_MANA,mp);
    }
    //增加魔法最大值
    public function AddUnitMP(unit u,real mp ) {
        SetUnitMP(u,GetUnitMP(u)+mp);
        if (mp > 0) {SetUnitManaBJ(u,GetUnitState(u,UNIT_STATE_MANA)+mp);}
    }
    //回蓝(定值)
    public function RegenUnitMP(unit u, real volume) -> nothing {
        SetUnitManaBJ(u,GetUnitState(u,UNIT_STATE_MANA)+volume);
    }
    //回蓝(百分比)
    public function RegenUnitMPPercent(unit u, real rate) -> nothing {
        SetUnitManaBJ(u,GetUnitState(u,UNIT_STATE_MANA)+GetUnitMP(u)*rate);
    }

    // 获取移速
    public function GetUnitSpeed (unit u)  -> integer {
        if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED)) { //突破522与0的移速的Hook
            return LoadInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED);
        }
        else {return R2I(GetUnitMoveSpeed(u));}
    }
    //todo: 这个UNTable其他地图需要兼容
    // 增加移速
    public function AddUnitSpeed (unit u,integer speed) {
        integer value;
        if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED)) { //突破522与0的移速的Hook
            value  = LoadInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED);
            value += speed;
            SaveInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED,value);
        } else {value = R2I(GetUnitMoveSpeed(u)) + speed;}
		SetUnitMoveSpeed(u,value);
    }

    //射程(还会+警戒范围)
    public function GetUnitAttackRange(unit u) -> real {
        return GetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_RANGE));
    }
    //设置射程(还会设置警戒范围)
    public function SetUnitAttackRange (unit u,real range) {
		SetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_RANGE),range);
		SetUnitAcquireRange(u,RMaxBJ(range,900.0));
    }
    //增加射程(还会+警戒范围)
	public function AddUnitAttackRange (unit u,real range) {
		SetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_RANGE),GetUnitAttackRange(u) + range);
		SetUnitAcquireRange(u,RMaxBJ(GetUnitAcquireRange(u)+range,900.0));
    }

    // 获取攻速
    public function GetUnitAttackSpeed(unit u) -> real {
        return GetUnitState(u,ConvertUnitState(UNIT_STATE_RATE_OF_FIRE));
    }
    // 增加攻速
	public function AddUnitAttackSpeed (unit u,real speed) {
		SetUnitState(u,ConvertUnitState(UNIT_STATE_RATE_OF_FIRE),GetUnitState(u,ConvertUnitState(UNIT_STATE_RATE_OF_FIRE)) + speed);
	}

    // (获取缓存的攻击间隔(可能为负))
    public function GetUnitAttackIntervalCache(unit u) -> real {
        return LoadReal(HASH_UNIT,GetHandleId(u),KEY_UNIT_ATTACK_INTERVAL_CACHE);
    }

    // (获取单位的攻击间隔,不会小于0.1)
    public function GetUnitAttackInterval(unit u) -> real {
        return GetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_INTERVAL));
    }

    // 攻击间隔(虽然写着加,但是实际是减) - 带最小值与观察者
	public function AddAttackInterval (unit u,real value) {
        real cacheValue; real newValue; integer uid;

        uid = GetHandleId(u);

        // 检查是否已初始化缓存
        if (!HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_INTERVAL_CACHE)) {
            // 如果没有初始化，先保存当前攻击间隔到缓存
            SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_INTERVAL_CACHE, GetUnitAttackInterval(u));
        }

        // 获取当前缓存值并添加新值
        cacheValue = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_INTERVAL_CACHE);
        cacheValue += value;

        // 更新缓存
        SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_INTERVAL_CACHE, cacheValue);

        // 设置实际攻击间隔（确保不小于MIN_ATTACK_INTERVAL）
        newValue = RMaxBJ(cacheValue, MIN_ATTACK_INTERVAL);
        SetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_INTERVAL), newValue);

        // 观察者模式回调
        if (unitAttrObserver.attackIntervalCB != null) {
            unitAttrObserver.argsU = u;
            TriggerEvaluate(unitAttrObserver.attackIntervalCB);
        }
	}

    //传送单位(带特效与镜头转换)
    public function TransportUnit (unit u,real x,real y,boolean camera) {
        if (camera) PanCameraToTimedForPlayer(GetOwningPlayer(u),x,y,0.2);
        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", GetUnitX(u), GetUnitY(u)));
        SetUnitPosition(u,x,y);
        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", GetUnitX(u), GetUnitY(u)));
    }

}

//! endzinc
#endif
