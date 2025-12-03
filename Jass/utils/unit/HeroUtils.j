#ifndef HeroUtilsIncluded
#define HeroUtilsIncluded


#include "Crainax/core/constant/JapiConstant.j" //constant可以直接加进去没问题
#include "Crainax/core/table/Hash_UnitDefine.j"
#include "Crainax/core/table/Hash_BIDefine.j"

//! zinc
/*
英雄属性相关（支持 BigInteger 主/次属性与三维虚拟属性）
*/
library HeroUtils requires UnitUtils {

    //=====================
    // 英雄主属性类型
    //=====================

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

    // 手动设置英雄主属性类型（0 力量 / 1 敏捷 / 2 智力）
    public function SetUnitMainAttrType(unit u, integer attrType) {
        integer uid;

        if (u == null) { return; }
        if (attrType < 0 || attrType > 2) { return; }

        uid = GetHandleId(u);
        SaveInteger(HASH_UNIT, uid, KEY_UNIT_MAIN_ATTR_TYPE, attrType);

        // 修改主属性类型仅影响虚拟属性计算，本身不改写英雄原始属性
        // 具体刷新由属性观察者回调完成
        if (heroAttrObserver.onAttrChangedCB != null) {
            heroAttrObserver.argsU = u;
            heroAttrObserver.argsAttrType = -1; // -1 表示整体刷新
            TriggerEvaluate(heroAttrObserver.onAttrChangedCB);
        }
    }

    //=====================
    // 属性变化观察者
    //=====================

    public struct heroAttrObserver [] {

        public static unit argsU = null;
        public static integer argsAttrType = 0; // 0=STR,1=AGI,2=INT,-1=全部
        public static trigger onAttrChangedCB = null;

        // 属性变化观察者事件注册
        public static method registerAttrChanged(code func) {
            if (heroAttrObserver.onAttrChangedCB == null) {
                heroAttrObserver.onAttrChangedCB = CreateTrigger();
            }
            TriggerAddCondition(heroAttrObserver.onAttrChangedCB, Condition(func));
        }

        static method fire(integer attrType) {
            if (heroAttrObserver.onAttrChangedCB != null) {
                heroAttrObserver.argsAttrType = attrType;
                TriggerEvaluate(heroAttrObserver.onAttrChangedCB);
            }
        }
    }

    //=====================
    // 三维基础属性（虚拟基础值）
    //=====================

    // 仅负责读取基础值，不做写入
    private function GetUnitBaseStr(unit u) -> real {
        player p; real base;

        if (u == null) { return 0.0; }

        if (!IsUnitBigInteger(u)) {
            return GetHeroStr(u, true);
        }

        p = GetOwningPlayer(u);
        base = bigInteger.toReal(p, HASH_KEY_BIGINT_STR);
        p = null;

        return base;
    }

    private function GetUnitBaseAgi(unit u) -> real {
        player p; real base;

        if (u == null) { return 0.0; }

        if (!IsUnitBigInteger(u)) {
            return GetHeroAgi(u, true);
        }

        p = GetOwningPlayer(u);
        base = bigInteger.toReal(p, HASH_KEY_BIGINT_AGI);
        p = null;

        return base;
    }

    private function GetUnitBaseInt(unit u) -> real {
        player p; real base;

        if (u == null) { return 0.0; }

        if (!IsUnitBigInteger(u)) {
            return GetHeroInt(u, true);
        }

        p = GetOwningPlayer(u);
        base = bigInteger.toReal(p, HASH_KEY_BIGINT_INT);
        p = null;

        return base;
    }

    //=====================
    // 主/次属性（虚拟数值与倍率）
    //=====================

    // 主属性当前数值（只对大数英雄生效）
    public function GetUnitMainAttrValue(unit u) -> real {
        player p; real value;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        p = GetOwningPlayer(u);
        value = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN);
        p = null;

        return value;
    }

    public function SetUnitMainAttrValue(unit u, real value) {
        player p;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        p = GetOwningPlayer(u);
        bigInteger.reset(p, HASH_KEY_BIGINT_MAIN);
        if (value > 0.0) {
            bigInteger.addReal(p, HASH_KEY_BIGINT_MAIN, value);
        }
        p = null;

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(-1);
    }

    public function AddUnitMainAttrValue(unit u, real value) {
        player p;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }
        if (value == 0.0) { return; }

        p = GetOwningPlayer(u);
        if (value > 0.0) {
            bigInteger.addReal(p, HASH_KEY_BIGINT_MAIN, value);
        } else {
            bigInteger.subReal(p, HASH_KEY_BIGINT_MAIN, -value);
        }
        p = null;

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(-1);
    }

    public function GetUnitMainAttrBonus(unit u) -> real {
        player p; real bonus;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        p = GetOwningPlayer(u);
        bonus = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN_BONUS);
        p = null;

        return bonus;
    }

    public function AddUnitMainAttrBonus(unit u, real value) {
        player p;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }
        if (value == 0.0) { return; }

        p = GetOwningPlayer(u);
        if (value > 0.0) {
            bigInteger.addReal(p, HASH_KEY_BIGINT_MAIN_BONUS, value);
        } else {
            bigInteger.subReal(p, HASH_KEY_BIGINT_MAIN_BONUS, -value);
        }
        p = null;

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(-1);
    }

    // 主属性增减幅（real，累积）
    private function GetUnitMainAttrUpRate(unit u) -> real {
        integer uid; real up;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_HP_UP_RATE)) {
            // 复用生命 up 键不合适，这里可扩展新键；先返回 0.0 占位
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_HP_UP_RATE);
        } else {
            up = 0.0;
        }
        return up;
    }

    private function GetUnitMainAttrDownRate(unit u) -> real {
        integer uid; real down;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_HP_DOWN_RATE)) {
            // 同上，仅为占位，后续可独立键位
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_HP_DOWN_RATE);
        } else {
            down = 0.0;
        }
        return down;
    }

    public function AddUnitMainAttrUpPercent(unit u, real value) {
        integer uid; real up;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        up = GetUnitMainAttrUpRate(u);
        up = up + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_HP_UP_RATE, up);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(-1);
    }

    public function AddUnitMainAttrDownPercent(unit u, real value) {
        integer uid; real down;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        down = GetUnitMainAttrDownRate(u);
        down = down + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_HP_DOWN_RATE, down);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(-1);
    }

    // 主属性自己的最终倍率
    public function GetUnitMainAttrFinalPercent(unit u) -> real {
        real up; real down; real rate;

        if (u == null) { return 1.0; }
        if (!IsUnitBigInteger(u)) { return 1.0; }

        up = GetUnitMainAttrUpRate(u);
        down = GetUnitMainAttrDownRate(u);
        rate = (1.0 + up) * (1.0 - down);

        return rate;
    }

    // 次属性（两种次属性共用一套）
    public function GetUnitSubAttrValue(unit u) -> real {
        player p; real value;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        p = GetOwningPlayer(u);
        value = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB);
        p = null;

        return value;
    }

    public function SetUnitSubAttrValue(unit u, real value) {
        player p;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        p = GetOwningPlayer(u);
        bigInteger.reset(p, HASH_KEY_BIGINT_SUB);
        if (value > 0.0) {
            bigInteger.addReal(p, HASH_KEY_BIGINT_SUB, value);
        }
        p = null;

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(-1);
    }

    public function AddUnitSubAttrValue(unit u, real value) {
        player p;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }
        if (value == 0.0) { return; }

        p = GetOwningPlayer(u);
        if (value > 0.0) {
            bigInteger.addReal(p, HASH_KEY_BIGINT_SUB, value);
        } else {
            bigInteger.subReal(p, HASH_KEY_BIGINT_SUB, -value);
        }
        p = null;

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(-1);
    }

    public function GetUnitSubAttrBonus(unit u) -> real {
        player p; real bonus;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        p = GetOwningPlayer(u);
        bonus = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB_BONUS);
        p = null;

        return bonus;
    }

    public function AddUnitSubAttrBonus(unit u, real value) {
        player p;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }
        if (value == 0.0) { return; }

        p = GetOwningPlayer(u);
        if (value > 0.0) {
            bigInteger.addReal(p, HASH_KEY_BIGINT_SUB_BONUS, value);
        } else {
            bigInteger.subReal(p, HASH_KEY_BIGINT_SUB_BONUS, -value);
        }
        p = null;

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(-1);
    }

    private function GetUnitSubAttrUpRate(unit u) -> real {
        integer uid; real up;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MP_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_MP_UP_RATE);
        } else {
            up = 0.0;
        }

        return up;
    }

    private function GetUnitSubAttrDownRate(unit u) -> real {
        integer uid; real down;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MP_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_MP_DOWN_RATE);
        } else {
            down = 0.0;
        }

        return down;
    }

    public function AddUnitSubAttrUpPercent(unit u, real value) {
        integer uid; real up;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        up = GetUnitSubAttrUpRate(u);
        up = up + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MP_UP_RATE, up);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(-1);
    }

    public function AddUnitSubAttrDownPercent(unit u, real value) {
        integer uid; real down;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        down = GetUnitSubAttrDownRate(u);
        down = down + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MP_DOWN_RATE, down);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(-1);
    }

    public function GetUnitSubAttrFinalPercent(unit u) -> real {
        real up; real down; real rate;

        if (u == null) { return 1.0; }
        if (!IsUnitBigInteger(u)) { return 1.0; }

        up = GetUnitSubAttrUpRate(u);
        down = GetUnitSubAttrDownRate(u);
        rate = (1.0 + up) * (1.0 - down);

        return rate;
    }

    //=====================
    // 力量/敏捷/智力 自身的 up/down/bonus
    //=====================

    private function GetUnitStrUpRate(unit u) -> real {
        integer uid; real up;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_UP_RATE);
        } else {
            up = 0.0;
        }

        return up;
    }

    private function GetUnitStrDownRate(unit u) -> real {
        integer uid; real down;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_DOWN_RATE);
        } else {
            down = 0.0;
        }

        return down;
    }

    private function GetUnitStrBonusReal(unit u) -> real {
        integer uid; real bonus;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BONUS_REAL)) {
            bonus = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BONUS_REAL);
        } else {
            bonus = 0.0;
        }

        return bonus;
    }

    public function AddUnitStrUpPercent(unit u, real value) {
        integer uid; real up;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        up = GetUnitStrUpRate(u);
        up = up + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_UP_RATE, up);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(0);
    }

    public function AddUnitStrDownPercent(unit u, real value) {
        integer uid; real down;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        down = GetUnitStrDownRate(u);
        down = down + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_DOWN_RATE, down);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(0);
    }

    public function AddUnitStrBonus(unit u, real value) {
        integer uid; real bonus;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        bonus = GetUnitStrBonusReal(u);
        bonus = bonus + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BONUS_REAL, bonus);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(0);
    }

    // 敏捷
    private function GetUnitAgiUpRate(unit u) -> real {
        integer uid; real up;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_DEFENSE_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_DEFENSE_UP_RATE);
        } else {
            up = 0.0;
        }

        return up;
    }

    private function GetUnitAgiDownRate(unit u) -> real {
        integer uid; real down;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_DEFENSE_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_DEFENSE_DOWN_RATE);
        } else {
            down = 0.0;
        }

        return down;
    }

    private function GetUnitAgiBonusReal(unit u) -> real {
        integer uid; integer bonusI; real bonus;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_DEFENSE_BONUS_INTEGER)) {
            bonusI = LoadInteger(HASH_UNIT, uid, KEY_UNIT_DEFENSE_BONUS_INTEGER);
            bonus = I2R(bonusI);
        } else {
            bonus = 0.0;
        }

        return bonus;
    }

    public function AddUnitAgiUpPercent(unit u, real value) {
        integer uid; real up;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        up = GetUnitAgiUpRate(u);
        up = up + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_DEFENSE_UP_RATE, up);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(1);
    }

    public function AddUnitAgiDownPercent(unit u, real value) {
        integer uid; real down;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        down = GetUnitAgiDownRate(u);
        down = down + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_DEFENSE_DOWN_RATE, down);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(1);
    }

    public function AddUnitAgiBonus(unit u, real value) {
        integer uid; integer bonusI;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        if (HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_DEFENSE_BONUS_INTEGER)) {
            bonusI = LoadInteger(HASH_UNIT, uid, KEY_UNIT_DEFENSE_BONUS_INTEGER);
        } else {
            bonusI = 0;
        }
        bonusI = bonusI + R2I(value);
        SaveInteger(HASH_UNIT, uid, KEY_UNIT_DEFENSE_BONUS_INTEGER, bonusI);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(1);
    }

    // 智力
    private function GetUnitIntUpRate(unit u) -> real {
        integer uid; real up;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MP_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_MP_UP_RATE);
        } else {
            up = 0.0;
        }

        return up;
    }

    private function GetUnitIntDownRate(unit u) -> real {
        integer uid; real down;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MP_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_MP_DOWN_RATE);
        } else {
            down = 0.0;
        }

        return down;
    }

    private function GetUnitIntBonusReal(unit u) -> real {
        integer uid; real bonus;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MP_BONUS_REAL)) {
            bonus = LoadReal(HASH_UNIT, uid, KEY_UNIT_MP_BONUS_REAL);
        } else {
            bonus = 0.0;
        }

        return bonus;
    }

    public function AddUnitIntUpPercent(unit u, real value) -> nothing {
        integer uid; real up;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        up = GetUnitIntUpRate(u);
        up = up + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MP_UP_RATE, up);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(2);
    }

    public function AddUnitIntDownPercent(unit u, real value) -> nothing {
        integer uid; real down;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        down = GetUnitIntDownRate(u);
        down = down + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MP_DOWN_RATE, down);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(2);
    }

    public function AddUnitIntBonus(unit u, real value) -> nothing {
        integer uid; real bonus;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        bonus = GetUnitIntBonusReal(u);
        bonus = bonus + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MP_BONUS_REAL, bonus);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(2);
    }

    //=====================
    // 三维属性 set/add/get（大数英雄专用）
    //=====================

    public function GetUnitStr(unit u) -> real {
        integer mainType; real base; real valueMain; real valueSub; real bonusMain; real bonusAttr; real upAttr; real downAttr; real upMain; real downMain; real upSub; real downSub; real finalPercent;

        if (u == null) { return 0.0; }

        if (!IsUnitBigInteger(u)) {
            return GetHeroStr(u, true);
        }

        mainType = GetUnitMainAttrType(u);

        base = GetUnitBaseStr(u);
        bonusAttr = GetUnitStrBonusReal(u);
        upAttr = GetUnitStrUpRate(u);
        downAttr = GetUnitStrDownRate(u);

        valueMain = GetUnitMainAttrValue(u);
        bonusMain = GetUnitMainAttrBonus(u);
        upMain = GetUnitMainAttrUpRate(u);
        downMain = GetUnitMainAttrDownRate(u);

        valueSub = GetUnitSubAttrValue(u);
        upSub = GetUnitSubAttrUpRate(u);
        downSub = GetUnitSubAttrDownRate(u);

        if (mainType == 0) {
            finalPercent = (1.0 + upAttr + upMain) * (1.0 - downAttr) * (1.0 - downMain);
            return (base + valueMain) * finalPercent + (bonusAttr + bonusMain);
        }

        // 力量作为次属性
        finalPercent = (1.0 + upAttr + upSub) * (1.0 - downAttr) * (1.0 - downSub);
        return (base + valueSub) * finalPercent + (bonusAttr + GetUnitSubAttrBonus(u));
    }

    public function SetUnitStr(unit u, real value) {
        player p;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        p = GetOwningPlayer(u);
        bigInteger.reset(p, HASH_KEY_BIGINT_STR);
        if (value > 0.0) {
            bigInteger.addReal(p, HASH_KEY_BIGINT_STR, value);
        }
        p = null;

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(0);
    }

    public function AddUnitStr(unit u, real value) {
        player p;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }
        if (value == 0.0) { return; }

        p = GetOwningPlayer(u);
        if (value > 0.0) {
            bigInteger.addReal(p, HASH_KEY_BIGINT_STR, value);
        } else {
            bigInteger.subReal(p, HASH_KEY_BIGINT_STR, -value);
        }
        p = null;

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(0);
    }

    public function GetUnitAgi(unit u) -> real {
        integer mainType; real base; real valueMain; real valueSub; real bonusMain; real bonusAttr; real upAttr; real downAttr; real upMain; real downMain; real upSub; real downSub; real finalPercent;

        if (u == null) { return 0.0; }

        if (!IsUnitBigInteger(u)) {
            return GetHeroAgi(u, true);
        }

        mainType = GetUnitMainAttrType(u);

        base = GetUnitBaseAgi(u);
        bonusAttr = GetUnitAgiBonusReal(u);
        upAttr = GetUnitAgiUpRate(u);
        downAttr = GetUnitAgiDownRate(u);

        valueMain = GetUnitMainAttrValue(u);
        bonusMain = GetUnitMainAttrBonus(u);
        upMain = GetUnitMainAttrUpRate(u);
        downMain = GetUnitMainAttrDownRate(u);

        valueSub = GetUnitSubAttrValue(u);
        upSub = GetUnitSubAttrUpRate(u);
        downSub = GetUnitSubAttrDownRate(u);

        if (mainType == 1) {
            finalPercent = (1.0 + upAttr + upMain) * (1.0 - downAttr) * (1.0 - downMain);
            return (base + valueMain) * finalPercent + (bonusAttr + bonusMain);
        }

        finalPercent = (1.0 + upAttr + upSub) * (1.0 - downAttr) * (1.0 - downSub);
        return (base + valueSub) * finalPercent + (bonusAttr + GetUnitSubAttrBonus(u));
    }

    public function SetUnitAgi(unit u, real value) {
        player p;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        p = GetOwningPlayer(u);
        bigInteger.reset(p, HASH_KEY_BIGINT_AGI);
        if (value > 0.0) {
            bigInteger.addReal(p, HASH_KEY_BIGINT_AGI, value);
        }
        p = null;

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(1);
    }

    public function AddUnitAgi(unit u, real value) {
        player p;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }
        if (value == 0.0) { return; }

        p = GetOwningPlayer(u);
        if (value > 0.0) {
            bigInteger.addReal(p, HASH_KEY_BIGINT_AGI, value);
        } else {
            bigInteger.subReal(p, HASH_KEY_BIGINT_AGI, -value);
        }
        p = null;

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(1);
    }

    public function GetUnitInt(unit u) -> real {
        integer mainType; real base; real valueMain; real valueSub; real bonusMain; real bonusAttr; real upAttr; real downAttr; real upMain; real downMain; real upSub; real downSub; real finalPercent;

        if (u == null) { return 0.0; }

        if (!IsUnitBigInteger(u)) {
            return GetHeroInt(u, true);
        }

        mainType = GetUnitMainAttrType(u);

        base = GetUnitBaseInt(u);
        bonusAttr = GetUnitIntBonusReal(u);
        upAttr = GetUnitIntUpRate(u);
        downAttr = GetUnitIntDownRate(u);

        valueMain = GetUnitMainAttrValue(u);
        bonusMain = GetUnitMainAttrBonus(u);
        upMain = GetUnitMainAttrUpRate(u);
        downMain = GetUnitMainAttrDownRate(u);

        valueSub = GetUnitSubAttrValue(u);
        upSub = GetUnitSubAttrUpRate(u);
        downSub = GetUnitSubAttrDownRate(u);

        if (mainType == 2) {
            finalPercent = (1.0 + upAttr + upMain) * (1.0 - downAttr) * (1.0 - downMain);
            return (base + valueMain) * finalPercent + (bonusAttr + bonusMain);
        }

        finalPercent = (1.0 + upAttr + upSub) * (1.0 - downAttr) * (1.0 - downSub);
        return (base + valueSub) * finalPercent + (bonusAttr + GetUnitSubAttrBonus(u));
    }

    public function SetUnitInt(unit u, real value) {
        player p;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        p = GetOwningPlayer(u);
        bigInteger.reset(p, HASH_KEY_BIGINT_INT);
        if (value > 0.0) {
            bigInteger.addReal(p, HASH_KEY_BIGINT_INT, value);
        }
        p = null;

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(2);
    }

    public function AddUnitInt(unit u, real value) {
        player p;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }
        if (value == 0.0) { return; }

        p = GetOwningPlayer(u);
        if (value > 0.0) {
            bigInteger.addReal(p, HASH_KEY_BIGINT_INT, value);
        } else {
            bigInteger.subReal(p, HASH_KEY_BIGINT_INT, -value);
        }
        p = null;

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(2);
    }

    /*
    使用说明简要：
      1. 调用 SetUnitMainAttrType(u, 0/1/2) 手动指定英雄主属性类型。
      2. 使用 Set/AddUnitMainAttrValue / SubAttrValue / *Bonus / *UpPercent / *DownPercent
         配置主属性与次属性整体加成。
      3. 使用 Set/AddUnitStr/Agi/Int 以及对应的 Up/Down/Bonus 操作三维属性本体。
      4. 外部系统通过 heroAttrObserver.registerAttrChanged 注册回调，
         在回调中使用 heroAttrObserver.argsU 与 argsAttrType 以及
         GetUnitStr/Agi/Int 获取最新虚拟属性值。
    */
}

//! endzinc
#endif
