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
    //  - 若未缓存，则通过对象编辑器字段 Primary 读取并返回（不写入，避免 OOS 风险）
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

        // 注意：不在 Get 函数中写入，避免 OOS 风险
        // 如需缓存，请在初始化时调用 CacheUnitMainAttrType 或使用 SetUnitMainAttrType

        primary = null;
        return attrType;
    }

    // 缓存英雄的主属性类型（从对象编辑器读取并写入哈希表）
    // 用于初始化时预先缓存，避免在 Get 函数中写入导致 OOS 风险
    public function CacheUnitMainAttrType(unit u) {
        integer uid; integer attrType; integer unitTypeId; string primary;

        if (u == null) { return; }

        uid = GetHandleId(u);

        // 如果已缓存，直接返回
        if (HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_MAIN_ATTR_TYPE)) {
            return;
        }

        unitTypeId = GetUnitTypeId(u);
        if (!IsHeroUnitId(unitTypeId)) {
            return;
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
    // 基础三维原始值（仅 BigInteger，兜底 0）
    //=====================

    private function GetUnitBaseStrRaw(unit u) -> real {
        player p; real value;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        p = GetOwningPlayer(u);
        value = bigInteger.toReal(p, HASH_KEY_BIGINT_STR);
        p = null;

        return value;
    }

    private function GetUnitBaseAgiRaw(unit u) -> real {
        player p; real value;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        p = GetOwningPlayer(u);
        value = bigInteger.toReal(p, HASH_KEY_BIGINT_AGI);
        p = null;

        return value;
    }

    private function GetUnitBaseIntRaw(unit u) -> real {
        player p; real value;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        p = GetOwningPlayer(u);
        value = bigInteger.toReal(p, HASH_KEY_BIGINT_INT);
        p = null;

        return value;
    }

    //=====================
    // 主/次属性（虚拟数值与倍率，外部只暴露 Add 系列）
    //=====================

    // 主属性当前数值（内部使用）
    private function GetMainAttrValueReal(unit u) -> real {
        player p; real value;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        p = GetOwningPlayer(u);
        value = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN);
        p = null;

        return value;
    }

    private function GetMainAttrBonusReal(unit u) -> real {
        player p; real bonus;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        p = GetOwningPlayer(u);
        bonus = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN_BONUS);
        p = null;

        return bonus;
    }

    // 主属性增减幅（real，累积，内部）
    private function GetMainAttrUpRate(unit u) -> real {
        integer uid; real up;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MAIN_ATTR_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_MAIN_ATTR_UP_RATE);
        } else {
            up = 0.0;
        }
        return up;
    }

    private function GetMainAttrDownRate(unit u) -> real {
        integer uid; real down;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MAIN_ATTR_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_MAIN_ATTR_DOWN_RATE);
        } else {
            down = 0.0;
        }
        return down;
    }

    // 仅保留 Add 系列给外部调用
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

    public function AddUnitMainAttrUpPercent(unit u, real value) {
        integer uid; real up;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        up = GetMainAttrUpRate(u);
        up = up + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MAIN_ATTR_UP_RATE, up);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(-1);
    }

    public function AddUnitMainAttrDownPercent(unit u, real value) {
        integer uid; real down;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        down = GetMainAttrDownRate(u);
        down = down + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MAIN_ATTR_DOWN_RATE, down);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(-1);
    }

    // 次属性（两种次属性共用一套，内部使用）
    private function GetSubAttrValueReal(unit u) -> real {
        player p; real value;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        p = GetOwningPlayer(u);
        value = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB);
        p = null;

        return value;
    }

    private function GetSubAttrBonusReal(unit u) -> real {
        player p; real bonus;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        p = GetOwningPlayer(u);
        bonus = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB_BONUS);
        p = null;

        return bonus;
    }

    // 次属性增减幅（内部）
    private function GetSubAttrUpRate(unit u) -> real {
        integer uid; real up;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_SUB_ATTR_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_SUB_ATTR_UP_RATE);
        } else {
            up = 0.0;
        }

        return up;
    }

    private function GetSubAttrDownRate(unit u) -> real {
        integer uid; real down;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_SUB_ATTR_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_SUB_ATTR_DOWN_RATE);
        } else {
            down = 0.0;
        }

        return down;
    }

    // 次属性对外仅暴露 Add 系列
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

    public function AddUnitSubAttrUpPercent(unit u, real value) {
        integer uid; real up;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        up = GetSubAttrUpRate(u);
        up = up + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_SUB_ATTR_UP_RATE, up);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(-1);
    }

    public function AddUnitSubAttrDownPercent(unit u, real value) {
        integer uid; real down;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        down = GetSubAttrDownRate(u);
        down = down + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_SUB_ATTR_DOWN_RATE, down);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(-1);
    }

    //=====================
    // 力量/敏捷/智力 自身的 up/down/bonus
    //=====================

    private function GetUnitStrUpRate(unit u) -> real {
        integer uid; real up;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_STR_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_STR_UP_RATE);
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
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_STR_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_STR_DOWN_RATE);
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
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_STR_BONUS_REAL)) {
            bonus = LoadReal(HASH_UNIT, uid, KEY_UNIT_STR_BONUS_REAL);
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
        SaveReal(HASH_UNIT, uid, KEY_UNIT_STR_UP_RATE, up);

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
        SaveReal(HASH_UNIT, uid, KEY_UNIT_STR_DOWN_RATE, down);

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
        SaveReal(HASH_UNIT, uid, KEY_UNIT_STR_BONUS_REAL, bonus);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(0);
    }

    // 敏捷
    private function GetUnitAgiUpRate(unit u) -> real {
        integer uid; real up;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_AGI_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_AGI_UP_RATE);
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
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_AGI_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_AGI_DOWN_RATE);
        } else {
            down = 0.0;
        }

        return down;
    }

    private function GetUnitAgiBonusReal(unit u) -> real {
        integer uid; real bonus;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_AGI_BONUS_REAL)) {
            bonus = LoadReal(HASH_UNIT, uid, KEY_UNIT_AGI_BONUS_REAL);
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
        SaveReal(HASH_UNIT, uid, KEY_UNIT_AGI_UP_RATE, up);

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
        SaveReal(HASH_UNIT, uid, KEY_UNIT_AGI_DOWN_RATE, down);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(1);
    }

    public function AddUnitAgiBonus(unit u, real value) {
        integer uid; real bonus;

        if (u == null || value == 0.0) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        bonus = GetUnitAgiBonusReal(u);
        bonus = bonus + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_AGI_BONUS_REAL, bonus);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(1);
    }

    // 智力
    private function GetUnitIntUpRate(unit u) -> real {
        integer uid; real up;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_INT_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_INT_UP_RATE);
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
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_INT_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_INT_DOWN_RATE);
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
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_INT_BONUS_REAL)) {
            bonus = LoadReal(HASH_UNIT, uid, KEY_UNIT_INT_BONUS_REAL);
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
        SaveReal(HASH_UNIT, uid, KEY_UNIT_INT_UP_RATE, up);

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
        SaveReal(HASH_UNIT, uid, KEY_UNIT_INT_DOWN_RATE, down);

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
        SaveReal(HASH_UNIT, uid, KEY_UNIT_INT_BONUS_REAL, bonus);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(2);
    }

    //=====================
    // 三维属性基础值（基础 + 主/次属性数值）
    //=====================

    public function GetUnitBaseStr(unit u) -> real {
        integer mainType; real base; real mainVal; real subVal;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        mainType = GetUnitMainAttrType(u);
        base = GetUnitBaseStrRaw(u);
        mainVal = GetMainAttrValueReal(u);
        subVal = GetSubAttrValueReal(u);

        if (mainType == 0) {
            return base + mainVal;
        }

        return base + subVal;
    }

    public function GetUnitBaseAgi(unit u) -> real {
        integer mainType; real base; real mainVal; real subVal;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        mainType = GetUnitMainAttrType(u);
        base = GetUnitBaseAgiRaw(u);
        mainVal = GetMainAttrValueReal(u);
        subVal = GetSubAttrValueReal(u);

        if (mainType == 1) {
            return base + mainVal;
        }

        return base + subVal;
    }

    public function GetUnitBaseInt(unit u) -> real {
        integer mainType; real base; real mainVal; real subVal;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        mainType = GetUnitMainAttrType(u);
        base = GetUnitBaseIntRaw(u);
        mainVal = GetMainAttrValueReal(u);
        subVal = GetSubAttrValueReal(u);

        if (mainType == 2) {
            return base + mainVal;
        }

        return base + subVal;
    }

    //=====================
    // 三维属性最终倍率 (1+attrUp+subUp)*(1-attrDown)*(1-subDown)
    //=====================

    private function GetUnitStrFinalPercentInternal(unit u) -> real {
        integer mainType; real attrUp; real attrDown; real layerUp; real layerDown;

        if (u == null) { return 1.0; }
        if (!IsUnitBigInteger(u)) { return 1.0; }

        mainType = GetUnitMainAttrType(u);
        attrUp = GetUnitStrUpRate(u);
        attrDown = GetUnitStrDownRate(u);

        if (mainType == 0) {
            layerUp = GetMainAttrUpRate(u);
            layerDown = GetMainAttrDownRate(u);
        } else {
            layerUp = GetSubAttrUpRate(u);
            layerDown = GetSubAttrDownRate(u);
        }

        return (1.0 + attrUp + layerUp) * (1.0 - attrDown) * (1.0 - layerDown);
    }

    public function GetUnitStrFinalPercent(unit u) -> real {
        return GetUnitStrFinalPercentInternal(u);
    }

    private function GetUnitAgiFinalPercentInternal(unit u) -> real {
        integer mainType; real attrUp; real attrDown; real layerUp; real layerDown;

        if (u == null) { return 1.0; }
        if (!IsUnitBigInteger(u)) { return 1.0; }

        mainType = GetUnitMainAttrType(u);
        attrUp = GetUnitAgiUpRate(u);
        attrDown = GetUnitAgiDownRate(u);

        if (mainType == 1) {
            layerUp = GetMainAttrUpRate(u);
            layerDown = GetMainAttrDownRate(u);
        } else {
            layerUp = GetSubAttrUpRate(u);
            layerDown = GetSubAttrDownRate(u);
        }

        return (1.0 + attrUp + layerUp) * (1.0 - attrDown) * (1.0 - layerDown);
    }

    public function GetUnitAgiFinalPercent(unit u) -> real {
        return GetUnitAgiFinalPercentInternal(u);
    }

    private function GetUnitIntFinalPercentInternal(unit u) -> real {
        integer mainType; real attrUp; real attrDown; real layerUp; real layerDown;

        if (u == null) { return 1.0; }
        if (!IsUnitBigInteger(u)) { return 1.0; }

        mainType = GetUnitMainAttrType(u);
        attrUp = GetUnitIntUpRate(u);
        attrDown = GetUnitIntDownRate(u);

        if (mainType == 2) {
            layerUp = GetMainAttrUpRate(u);
            layerDown = GetMainAttrDownRate(u);
        } else {
            layerUp = GetSubAttrUpRate(u);
            layerDown = GetSubAttrDownRate(u);
        }

        return (1.0 + attrUp + layerUp) * (1.0 - attrDown) * (1.0 - layerDown);
    }

    public function GetUnitIntFinalPercent(unit u) -> real {
        return GetUnitIntFinalPercentInternal(u);
    }

    //=====================
    // 三维属性 set/add/get（大数英雄专用）
    //=====================

    public function GetUnitStr(unit u) -> real {
        integer mainType; real baseRaw; real mainVal; real subVal; real bonusAttr; real bonusOther; real finalPercent;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        mainType = GetUnitMainAttrType(u);

        baseRaw = GetUnitBaseStrRaw(u);
        mainVal = GetMainAttrValueReal(u);
        subVal = GetSubAttrValueReal(u);

        bonusAttr = GetUnitStrBonusReal(u);

        if (mainType == 0) {
            bonusOther = GetMainAttrBonusReal(u);
            finalPercent = GetUnitStrFinalPercentInternal(u);
            return (baseRaw + mainVal) * finalPercent + (bonusAttr + bonusOther);
        }

        bonusOther = GetSubAttrBonusReal(u);
        finalPercent = GetUnitStrFinalPercentInternal(u);
        return (baseRaw + subVal) * finalPercent + (bonusAttr + bonusOther);
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
        player p; real delta; real debt; real cur; real dec; real over; real remain;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }
        if (value == 0.0) { return; }

        p = GetOwningPlayer(u);
        delta = value;

        if (delta > 0.0) {
            // 加力量：优先偿还欠款
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_STR_CACHE);
            if (debt > 0.0) {
                if (delta <= debt) {
                    bigInteger.subReal(p, HASH_KEY_BIGINT_STR_CACHE, delta);
                } else {
                    remain = delta - debt;
                    bigInteger.reset(p, HASH_KEY_BIGINT_STR_CACHE);
                    bigInteger.addReal(p, HASH_KEY_BIGINT_STR, remain);
                }
            } else {
                bigInteger.addReal(p, HASH_KEY_BIGINT_STR, delta);
            }
        } else {
            // 减力量：可能产生欠款
            dec = -delta;
            cur = bigInteger.toReal(p, HASH_KEY_BIGINT_STR);
            if (cur >= dec) {
                bigInteger.subReal(p, HASH_KEY_BIGINT_STR, dec);
            } else {
                over = dec - cur;
                bigInteger.reset(p, HASH_KEY_BIGINT_STR);
                bigInteger.addReal(p, HASH_KEY_BIGINT_STR_CACHE, over);
            }
        }

        p = null;

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(0);
    }

    public function GetUnitAgi(unit u) -> real {
        integer mainType; real baseRaw; real mainVal; real subVal; real bonusAttr; real bonusOther; real finalPercent;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        mainType = GetUnitMainAttrType(u);

        baseRaw = GetUnitBaseAgiRaw(u);
        mainVal = GetMainAttrValueReal(u);
        subVal = GetSubAttrValueReal(u);

        bonusAttr = GetUnitAgiBonusReal(u);

        if (mainType == 1) {
            bonusOther = GetMainAttrBonusReal(u);
            finalPercent = GetUnitAgiFinalPercentInternal(u);
            return (baseRaw + mainVal) * finalPercent + (bonusAttr + bonusOther);
        }

        bonusOther = GetSubAttrBonusReal(u);
        finalPercent = GetUnitAgiFinalPercentInternal(u);
        return (baseRaw + subVal) * finalPercent + (bonusAttr + bonusOther);
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
        player p; real delta; real debt; real cur; real dec; real over; real remain;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }
        if (value == 0.0) { return; }

        p = GetOwningPlayer(u);
        delta = value;

        if (delta > 0.0) {
            // 加敏捷：优先偿还欠款
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_AGI_CACHE);
            if (debt > 0.0) {
                if (delta <= debt) {
                    bigInteger.subReal(p, HASH_KEY_BIGINT_AGI_CACHE, delta);
                } else {
                    remain = delta - debt;
                    bigInteger.reset(p, HASH_KEY_BIGINT_AGI_CACHE);
                    bigInteger.addReal(p, HASH_KEY_BIGINT_AGI, remain);
                }
            } else {
                bigInteger.addReal(p, HASH_KEY_BIGINT_AGI, delta);
            }
        } else {
            // 减敏捷：可能产生欠款
            dec = -delta;
            cur = bigInteger.toReal(p, HASH_KEY_BIGINT_AGI);
            if (cur >= dec) {
                bigInteger.subReal(p, HASH_KEY_BIGINT_AGI, dec);
            } else {
                over = dec - cur;
                bigInteger.reset(p, HASH_KEY_BIGINT_AGI);
                bigInteger.addReal(p, HASH_KEY_BIGINT_AGI_CACHE, over);
            }
        }

        p = null;

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(1);
    }

    public function GetUnitInt(unit u) -> real {
        integer mainType; real baseRaw; real mainVal; real subVal; real bonusAttr; real bonusOther; real finalPercent;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }

        mainType = GetUnitMainAttrType(u);

        baseRaw = GetUnitBaseIntRaw(u);
        mainVal = GetMainAttrValueReal(u);
        subVal = GetSubAttrValueReal(u);

        bonusAttr = GetUnitIntBonusReal(u);

        if (mainType == 2) {
            bonusOther = GetMainAttrBonusReal(u);
            finalPercent = GetUnitIntFinalPercentInternal(u);
            return (baseRaw + mainVal) * finalPercent + (bonusAttr + bonusOther);
        }

        bonusOther = GetSubAttrBonusReal(u);
        finalPercent = GetUnitIntFinalPercentInternal(u);
        return (baseRaw + subVal) * finalPercent + (bonusAttr + bonusOther);
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
        player p; real delta; real debt; real cur; real dec; real over; real remain;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }
        if (value == 0.0) { return; }

        p = GetOwningPlayer(u);
        delta = value;

        if (delta > 0.0) {
            // 加智力：优先偿还欠款
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_INT_CACHE);
            if (debt > 0.0) {
                if (delta <= debt) {
                    bigInteger.subReal(p, HASH_KEY_BIGINT_INT_CACHE, delta);
                } else {
                    remain = delta - debt;
                    bigInteger.reset(p, HASH_KEY_BIGINT_INT_CACHE);
                    bigInteger.addReal(p, HASH_KEY_BIGINT_INT, remain);
                }
            } else {
                bigInteger.addReal(p, HASH_KEY_BIGINT_INT, delta);
            }
        } else {
            // 减智力：可能产生欠款
            dec = -delta;
            cur = bigInteger.toReal(p, HASH_KEY_BIGINT_INT);
            if (cur >= dec) {
                bigInteger.subReal(p, HASH_KEY_BIGINT_INT, dec);
            } else {
                over = dec - cur;
                bigInteger.reset(p, HASH_KEY_BIGINT_INT);
                bigInteger.addReal(p, HASH_KEY_BIGINT_INT_CACHE, over);
            }
        }

        p = null;

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(2);
    }


    //初始化上述属性
    public function InitAllUnitAttr (unit u ) {
        if (IsUnitBigInteger(u)) {
            // 预先缓存主属性类型，避免后续 Get 函数频繁读取对象编辑器
            CacheUnitMainAttrType(u);
            AddUnitAttack(u,GetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE)));
            SetUnitStr(u,GetHeroStr(u,false));
            SetUnitAgi(u,GetHeroAgi(u,false));
            SetUnitInt(u,GetHeroInt(u,false));
        } else {
            AddUnitAttack(u,0);
        }
        AddUnitDefense(u,0);
        AddUnitHP(u,0);
        AddUnitMP(u,0);
    }

    /*
    使用说明简要：
      1. 调用 SetUnitMainAttrType(u, 0/1/2) 手动指定英雄主属性类型。
      2. 使用 AddUnitMainAttrValue / AddUnitSubAttrValue / *Bonus / *UpPercent / *DownPercent
         配置主属性与次属性整体加成（仅对 BigInteger 英雄生效）。
      3. 使用 Set/AddUnitStr/Agi/Int 以及对应的 Up/Down/Bonus 操作三维属性本体。
      4. 外部系统通过 heroAttrObserver.registerAttrChanged 注册回调，
         在回调中使用 heroAttrObserver.argsU 与 argsAttrType 以及
         GetUnitStr/Agi/Int 获取最新虚拟属性值。
    */
}

//! endzinc
#endif
