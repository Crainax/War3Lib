#ifndef UnitUtilsIncluded
#define UnitUtilsIncluded

#include "Crainax/core/constant/JapiConstant.j" //constant可以直接加进去没问题
#include "Crainax/core/table/Hash_UnitDefine.j"
#include "Crainax/core/table/Hash_BIDefine.j"

//! zinc
/*
单位有关的增强功能
*/
library UnitUtils requires BigInteger,MathUtils {

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

    //=====================
    // 攻击扩展工具函数
    //=====================

    // 获取单位攻击增幅（real）
    private function GetUnitAttackUpRate(unit u) -> real {
        integer uid; real up;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_UP_RATE);
        } else {
            up = 0.0;
        }
        return up;
    }

    // 获取单位攻击减幅（real）
    private function GetUnitAttackDownRate(unit u) -> real {
        integer uid; real down;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_DOWN_RATE);
        } else {
            down = 0.0;
        }
        return down;
    }

    // 获取单位攻击固定加成（非 BigInteger 路径，real）
    private function GetUnitAttackBonusReal(unit u) -> real {
        integer uid; real bonus;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BONUS_REAL)) {
            bonus = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BONUS_REAL);
        } else {
            bonus = 0.0;
        }
        return bonus;
    }

    // 获取当前单位攻击总倍率：(1 + up) * (1 - down)，默认 1.0
    public function GetUnitAttackFinalPercent(unit u) -> real {
        real up; real down; real rate;
        if (u == null) { return 1.0; }
        up = GetUnitAttackUpRate(u);
        down = GetUnitAttackDownRate(u);
        rate = (1.0 + up) * (1.0 - down);
        return rate;
    }

    // 获取单位“基础攻击”（不含增减幅与定值）
    // 注意：此函数不做任何写入操作，基础攻击的初始化放在 Set/Add 等写入函数中完成，避免 OOS 风险
    public function GetUnitBaseAttack(unit u) -> real {
        player p; real base; real cur; real factor;
        integer uid;

        if (u == null) { return 0.0; }

        if (IsUnitBigInteger(u)) {
            p = GetOwningPlayer(u);
            base = bigInteger.toReal(p, HASH_KEY_BIGINT_ATTACK);
            p = null;
            return base;
        }

        uid = GetHandleId(u);

        // 若已缓存基础攻击，则直接返回
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BASE_REAL)) {
            return LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BASE_REAL);
        }

        // 未初始化时，仅根据当前总攻击（引擎状态 + 缩放倍数）计算并返回，但不写入哈希表
        cur = GetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE));
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR)) {
            factor = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR);
        } else {
            factor = 1.0;
        }
        base = cur * factor;

        return base;
    }

    // 计算单位当前“最终攻击”（基础 * 总倍率 + 定值）
    private function CalcUnitFinalAttackReal(unit u) -> real {
        real base; real rate; real bonus; player p;

        if (u == null) { return 0.0; }

        base = GetUnitBaseAttack(u);
        rate = GetUnitAttackFinalPercent(u);

        if (IsUnitBigInteger(u)) {
            p = GetOwningPlayer(u);
            bonus = bigInteger.toReal(p, HASH_KEY_BIGINT_ATTACK_BONUS);
            p = null;
        } else {
            bonus = GetUnitAttackBonusReal(u);
        }

        return base * rate + bonus;
    }

    // 非 BigInteger 单位：按 10^n 规则写入引擎攻击与扩展倍数
    private function ApplyAttackScaling(unit u, real attack) -> nothing {
        real value; integer uid; integer n; integer i; real factor;

        if (u == null) { return; }

        uid = GetHandleId(u);
        value = attack;

        // 保护下限，避免引擎攻击小于 0
        if (value < 0.0) {
            value = 0.0;
        }
        n = 0;

        // 大于 10 亿才开始缩放，避免不必要的精度损失
        if (value > 1000000000.0) {
            while (value > 1000000000.0 && n < 30) {
                value = value / 10.0;
                n = n + 1;
            }
        }

        if (n > 0) {
            factor = 1.0;
            i = 0;
            while (i < n) {
                factor = factor * 10.0;
                i = i + 1;
            }
            SaveInteger(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_EXP, n);
            SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR, factor);
        } else {
            if (HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_EXP)) {
                RemoveSavedInteger(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_EXP);
            }
            if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR)) {
                RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR);
            }
        }

        SetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE), value);
    }

    // 将 BigInteger 中的最终攻击值同步到引擎攻击值与 10^n 扩展键
    private function SyncBigIntAttackToEngine(unit u) -> nothing {
        real total;
        if (u == null) { return; }

        total = CalcUnitFinalAttackReal(u);

        if (total <= 0.0) {
            ApplyAttackScaling(u, 0.0);
            return;
        }

        ApplyAttackScaling(u, total);
    }

    //重新计算单位当前攻击（应用增减幅与定值）
    private function RecalcUnitAttack(unit u) -> nothing {
        real total; integer uid; real cur; real factor; real base;
        if (u == null) { return; }

        // 懒初始化普通单位的基础攻击缓存（避免在 Get 函数中写入，防 OOS）
        if (!IsUnitBigInteger(u)) {
            uid = GetHandleId(u);
            if (!HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BASE_REAL)) {
                cur = GetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE));
                if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR)) {
                    factor = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR);
                } else {
                    factor = 1.0;
                }
                base = cur * factor;
                SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BASE_REAL, base);
            }
        }

        total = CalcUnitFinalAttackReal(u);

        if (IsUnitBigInteger(u)) {
            // BigInteger 单位统一通过 SyncBigIntAttackToEngine 写回
            SyncBigIntAttackToEngine(u);
        } else {
            ApplyAttackScaling(u, total);
        }
    }

    //获取单位的攻击力/防御/生命/魔法值
    // 普通单位：从引擎状态 + 10^n 扩展倍数还原（已经包含增减幅与定值）
    // BigInteger 单位：返回 CalcUnitFinalAttackReal 计算出的最终攻击
    public function GetUnitAttack(unit u) -> real {
        real base; integer uid; real factor;

        if (IsUnitBigInteger(u)) {
            return CalcUnitFinalAttackReal(u);
        }

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

    // 获取英雄的主属性类型：
    //  - 返回值：0=力量(STR)，1=敏捷(AGI)，2=智力(INT)，0 也作为默认/未知值
    //  - 优先从 HASH_UNIT/KEY_UNIT_MAIN_ATTR_TYPE 中读取，可被其他系统覆盖
    //  - 若未缓存，则通过对象编辑器字段 Primary 读取并缓存
    public function GetUnitMainAttrType(unit u) -> integer {
        integer uid; integer attrType; integer unitTypeId; string primary;

        if (u == null) { return 0; }

        uid = GetHandleId(u);

        // 优先：哈希表中的自定义主属性类型
        if (HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_MAIN_ATTR_TYPE)) {
            return LoadInteger(HASH_UNIT, uid, KEY_UNIT_MAIN_ATTR_TYPE);
        }

        unitTypeId = GetUnitTypeId(u);
        if (!IsHeroUnitId(unitTypeId)) {
            return 0;
        }

        // 通过对象编辑器获取 Primary 字段（STR/AGI/INT）
        primary = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_UNIT, unitTypeId, "Primary");

        if (primary == "STR") {
            attrType = 0;
        } else if (primary == "AGI") {
            attrType = 1;
        } else if (primary == "INT") {
            attrType = 2;
        } else {
            attrType = 0;
        }

        // 缓存结果，避免频繁读取对象编辑器
        SaveInteger(HASH_UNIT, uid, KEY_UNIT_MAIN_ATTR_TYPE, attrType);

        primary = null;
        return attrType;
    }

    // 获取英雄当前主属性数值（整数）：
    //  - 根据 GetUnitMainAttrType 返回的类型，读取对应的力量/敏捷/智力
    //  - 非英雄或未知类型返回 0
    public function GetUnitMainAttrValue(unit u) -> integer {
        integer unitTypeId; integer attrType; integer value;

        if (u == null) { return 0; }

        unitTypeId = GetUnitTypeId(u);
        if (!IsHeroUnitId(unitTypeId)) {
            return 0;
        }

        attrType = GetUnitMainAttrType(u);

        if (attrType == 0) {
            value = R2I(GetHeroStr(u, true));
        } else if (attrType == 1) {
            value = R2I(GetHeroAgi(u, true));
        } else if (attrType == 2) {
            value = R2I(GetHeroInt(u, true));
        } else {
            value = 0;
        }

        return value;
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

    //设置攻击力（支持超过 21 亿；BigInteger 单位走大整数链路）
    public function SetUnitAttack(unit u, real attack) -> nothing {
        real value; integer uid; player p;

        if (IsUnitBigInteger(u)) {
            if (u == null) { return; }
            p = GetOwningPlayer(u);
            bigInteger.reset(p, HASH_KEY_BIGINT_ATTACK);
            bigInteger.reset(p, HASH_KEY_BIGINT_ATTACK_CACHE);
            if (attack > 0.0) {
                bigInteger.addReal(p, HASH_KEY_BIGINT_ATTACK, attack);
            }
            p = null;
            SyncBigIntAttackToEngine(u);
            return;
        }

        if (u == null) { return; }

        uid = GetHandleId(u);
        value = attack;

        // 普通单位：直接设置基础攻击，并按照当前增减幅/定值重算最终攻击
        SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BASE_REAL, value);
        RecalcUnitAttack(u);
    }

    //增加攻击力（支持超过 21 亿；BigInteger 单位使用大整数 add/sub 逻辑）
    public function AddUnitAttack(unit u, real attack) -> nothing {
        player p; real delta; real debt; real cur; real dec; real over; real remain; real base; integer uid;

        if (IsUnitBigInteger(u)) {
            if (u == null) { return; }
            if (attack == 0.0) { return; }

            p = GetOwningPlayer(u);
            delta = attack;

            if (delta > 0.0) {
                // 加攻击：优先偿还欠款
                debt = bigInteger.toReal(p, HASH_KEY_BIGINT_ATTACK_CACHE);
                if (debt > 0.0) {
                    if (delta <= debt) {
                        bigInteger.subReal(p, HASH_KEY_BIGINT_ATTACK_CACHE, delta);
                    } else {
                        remain = delta - debt;
                        bigInteger.reset(p, HASH_KEY_BIGINT_ATTACK_CACHE);
                        bigInteger.addReal(p, HASH_KEY_BIGINT_ATTACK, remain);
                    }
                } else {
                    bigInteger.addReal(p, HASH_KEY_BIGINT_ATTACK, delta);
                }
            } else {
                // 减攻击：可能产生欠款
                dec = -delta;
                cur = bigInteger.toReal(p, HASH_KEY_BIGINT_ATTACK);
                if (cur >= dec) {
                    bigInteger.subReal(p, HASH_KEY_BIGINT_ATTACK, dec);
                } else {
                    over = dec - cur;
                    bigInteger.reset(p, HASH_KEY_BIGINT_ATTACK);
                    bigInteger.addReal(p, HASH_KEY_BIGINT_ATTACK_CACHE, over);
                }
            }

            p = null;
            SyncBigIntAttackToEngine(u);
            return;
        }

        if (u == null || attack == 0.0) { return; }

        // 普通单位：修改基础攻击，然后用增减幅/定值重算
        uid = GetHandleId(u);
        base = GetUnitBaseAttack(u);
        base = base + attack;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BASE_REAL, base);
        RecalcUnitAttack(u);
    }

    // 增加攻击增幅（百分比形式，value 为小数，如 0.2 表示 +20%）
    public function AddUnitAttackUpPercent(unit u, real value) -> nothing {
        integer uid; real up;

        if (u == null || value == 0.0) { return; }

        uid = GetHandleId(u);
        up = GetUnitAttackUpRate(u);
        up = up + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_UP_RATE, up);

        RecalcUnitAttack(u);
    }

    // 增加攻击减幅（value 为小数，如 0.3 表示 -30%）
    public function AddUnitAttackDownPercent(unit u, real value) -> nothing {
        integer uid; real down;

        if (u == null || value == 0.0) { return; }

        uid = GetHandleId(u);
        down = GetUnitAttackDownRate(u);
        down = RealAdd(down, value);
        SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_DOWN_RATE, down);

        RecalcUnitAttack(u);
    }

    // 增加固定攻击值（不受增减幅影响）
    public function AddUnitAttackBonus(unit u, real value) -> nothing {
        integer uid; real bonus; player p;

        if (u == null || value == 0.0) { return; }

        if (IsUnitBigInteger(u)) {
            p = GetOwningPlayer(u);
            if (value > 0.0) {
                bigInteger.addReal(p, HASH_KEY_BIGINT_ATTACK_BONUS, value);
            } else {
                bigInteger.subReal(p, HASH_KEY_BIGINT_ATTACK_BONUS, -value);
            }
            p = null;
        } else {
            uid = GetHandleId(u);
            bonus = GetUnitAttackBonusReal(u);
            bonus = bonus + value;
            SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BONUS_REAL, bonus);
        }

        RecalcUnitAttack(u);
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
