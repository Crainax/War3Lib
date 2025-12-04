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
    // 属性禁用与跨属性共享开关（内部布尔读取）
    //=====================

    private function isUnitStrDisabled(unit u) -> boolean {
        integer uid;

        if (u == null) { return false; }
        if (!IsUnitBigInteger(u)) { return false; }

        uid = GetHandleId(u);
        if (HaveSavedBoolean(HASH_UNIT, uid, KEY_UNIT_STR_DISABLED)) {
            return LoadBoolean(HASH_UNIT, uid, KEY_UNIT_STR_DISABLED);
        }

        return false;
    }

    private function isUnitAgiDisabled(unit u) -> boolean {
        integer uid;

        if (u == null) { return false; }
        if (!IsUnitBigInteger(u)) { return false; }

        uid = GetHandleId(u);
        if (HaveSavedBoolean(HASH_UNIT, uid, KEY_UNIT_AGI_DISABLED)) {
            return LoadBoolean(HASH_UNIT, uid, KEY_UNIT_AGI_DISABLED);
        }

        return false;
    }

    private function isUnitIntDisabled(unit u) -> boolean {
        integer uid;

        if (u == null) { return false; }
        if (!IsUnitBigInteger(u)) { return false; }

        uid = GetHandleId(u);
        if (HaveSavedBoolean(HASH_UNIT, uid, KEY_UNIT_INT_DISABLED)) {
            return LoadBoolean(HASH_UNIT, uid, KEY_UNIT_INT_DISABLED);
        }

        return false;
    }

    private function isStrToAgiShare(unit u) -> boolean {
        integer uid;

        if (u == null) { return false; }
        if (!IsUnitBigInteger(u)) { return false; }

        uid = GetHandleId(u);
        if (HaveSavedBoolean(HASH_UNIT, uid, KEY_UNIT_STR_TO_AGI_SHARE)) {
            return LoadBoolean(HASH_UNIT, uid, KEY_UNIT_STR_TO_AGI_SHARE);
        }

        return false;
    }

    private function isStrToIntShare(unit u) -> boolean {
        integer uid;

        if (u == null) { return false; }
        if (!IsUnitBigInteger(u)) { return false; }

        uid = GetHandleId(u);
        if (HaveSavedBoolean(HASH_UNIT, uid, KEY_UNIT_STR_TO_INT_SHARE)) {
            return LoadBoolean(HASH_UNIT, uid, KEY_UNIT_STR_TO_INT_SHARE);
        }

        return false;
    }

    private function isAgiToStrShare(unit u) -> boolean {
        integer uid;

        if (u == null) { return false; }
        if (!IsUnitBigInteger(u)) { return false; }

        uid = GetHandleId(u);
        if (HaveSavedBoolean(HASH_UNIT, uid, KEY_UNIT_AGI_TO_STR_SHARE)) {
            return LoadBoolean(HASH_UNIT, uid, KEY_UNIT_AGI_TO_STR_SHARE);
        }

        return false;
    }

    private function isAgiToIntShare(unit u) -> boolean {
        integer uid;

        if (u == null) { return false; }
        if (!IsUnitBigInteger(u)) { return false; }

        uid = GetHandleId(u);
        if (HaveSavedBoolean(HASH_UNIT, uid, KEY_UNIT_AGI_TO_INT_SHARE)) {
            return LoadBoolean(HASH_UNIT, uid, KEY_UNIT_AGI_TO_INT_SHARE);
        }

        return false;
    }

    private function isIntToStrShare(unit u) -> boolean {
        integer uid;

        if (u == null) { return false; }
        if (!IsUnitBigInteger(u)) { return false; }

        uid = GetHandleId(u);
        if (HaveSavedBoolean(HASH_UNIT, uid, KEY_UNIT_INT_TO_STR_SHARE)) {
            return LoadBoolean(HASH_UNIT, uid, KEY_UNIT_INT_TO_STR_SHARE);
        }

        return false;
    }

    private function isIntToAgiShare(unit u) -> boolean {
        integer uid;

        if (u == null) { return false; }
        if (!IsUnitBigInteger(u)) { return false; }

        uid = GetHandleId(u);
        if (HaveSavedBoolean(HASH_UNIT, uid, KEY_UNIT_INT_TO_AGI_SHARE)) {
            return LoadBoolean(HASH_UNIT, uid, KEY_UNIT_INT_TO_AGI_SHARE);
        }

        return false;
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
        player p; real delta; real debt; real cur; real dec; real over; real remain;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }
        if (value == 0.0) { return; }

        p = GetOwningPlayer(u);
        delta = value;

        if (delta > 0.0) {
            // 加主属性：优先偿还欠款
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN_CACHE);
            if (debt > 0.0) {
                if (delta <= debt) {
                    bigInteger.subReal(p, HASH_KEY_BIGINT_MAIN_CACHE, delta);
                } else {
                    remain = delta - debt;
                    bigInteger.reset(p, HASH_KEY_BIGINT_MAIN_CACHE);
                    bigInteger.addReal(p, HASH_KEY_BIGINT_MAIN, remain);
                }
            } else {
                bigInteger.addReal(p, HASH_KEY_BIGINT_MAIN, delta);
            }
        } else {
            // 减主属性：可能产生欠款
            dec = -delta;
            cur = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN);
            if (cur >= dec) {
                bigInteger.subReal(p, HASH_KEY_BIGINT_MAIN, dec);
            } else {
                over = dec - cur;
                bigInteger.reset(p, HASH_KEY_BIGINT_MAIN);
                bigInteger.addReal(p, HASH_KEY_BIGINT_MAIN_CACHE, over);
            }
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
        player p; real delta; real debt; real cur; real dec; real over; real remain;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }
        if (value == 0.0) { return; }

        p = GetOwningPlayer(u);
        delta = value;

        if (delta > 0.0) {
            // 加次属性：优先偿还欠款
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB_CACHE);
            if (debt > 0.0) {
                if (delta <= debt) {
                    bigInteger.subReal(p, HASH_KEY_BIGINT_SUB_CACHE, delta);
                } else {
                    remain = delta - debt;
                    bigInteger.reset(p, HASH_KEY_BIGINT_SUB_CACHE);
                    bigInteger.addReal(p, HASH_KEY_BIGINT_SUB, remain);
                }
            } else {
                bigInteger.addReal(p, HASH_KEY_BIGINT_SUB, delta);
            }
        } else {
            // 减次属性：可能产生欠款
            dec = -delta;
            cur = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB);
            if (cur >= dec) {
                bigInteger.subReal(p, HASH_KEY_BIGINT_SUB, dec);
            } else {
                over = dec - cur;
                bigInteger.reset(p, HASH_KEY_BIGINT_SUB);
                bigInteger.addReal(p, HASH_KEY_BIGINT_SUB_CACHE, over);
            }
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
    // 属性禁用与跨属性共享开关（对外接口）
    //=====================

    // 关闭/开启虚拟力量属性：true=禁用，本体相关接口返回 0，但仍可作为共享来源
    public function SetUnitStrDisabled(unit u, boolean flag) {
        integer uid;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        SaveBoolean(HASH_UNIT, uid, KEY_UNIT_STR_DISABLED, flag);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(0);
    }

    // 关闭/开启虚拟敏捷属性：true=禁用，本体相关接口返回 0，但仍可作为共享来源
    public function SetUnitAgiDisabled(unit u, boolean flag) {
        integer uid;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        SaveBoolean(HASH_UNIT, uid, KEY_UNIT_AGI_DISABLED, flag);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(1);
    }

    // 关闭/开启虚拟智力属性：true=禁用，本体相关接口返回 0，但仍可作为共享来源
    public function SetUnitIntDisabled(unit u, boolean flag) {
        integer uid;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        SaveBoolean(HASH_UNIT, uid, KEY_UNIT_INT_DISABLED, flag);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(2);
    }

    // 力量计入敏捷
    public function SetUnitStrShareToAgi(unit u, boolean flag) {
        integer uid;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        SaveBoolean(HASH_UNIT, uid, KEY_UNIT_STR_TO_AGI_SHARE, flag);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(1);
    }

    // 力量计入智力
    public function SetUnitStrShareToInt(unit u, boolean flag) {
        integer uid;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        SaveBoolean(HASH_UNIT, uid, KEY_UNIT_STR_TO_INT_SHARE, flag);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(2);
    }

    // 敏捷计入力量
    public function SetUnitAgiShareToStr(unit u, boolean flag) {
        integer uid;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        SaveBoolean(HASH_UNIT, uid, KEY_UNIT_AGI_TO_STR_SHARE, flag);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(0);
    }

    // 敏捷计入智力
    public function SetUnitAgiShareToInt(unit u, boolean flag) {
        integer uid;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        SaveBoolean(HASH_UNIT, uid, KEY_UNIT_AGI_TO_INT_SHARE, flag);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(2);
    }

    // 智力计入力量
    public function SetUnitIntShareToStr(unit u, boolean flag) {
        integer uid;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        SaveBoolean(HASH_UNIT, uid, KEY_UNIT_INT_TO_STR_SHARE, flag);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(0);
    }

    // 智力计入敏捷
    public function SetUnitIntShareToAgi(unit u, boolean flag) {
        integer uid;

        if (u == null) { return; }
        if (!IsUnitBigInteger(u)) { return; }

        uid = GetHandleId(u);
        SaveBoolean(HASH_UNIT, uid, KEY_UNIT_INT_TO_AGI_SHARE, flag);

        heroAttrObserver.argsU = u;
        heroAttrObserver.fire(1);
    }

    //=====================
    // 三维属性基础值（基础 + 主/次属性数值）  会扣欠款,返回值可能为负,自行判断
    //=====================

    public function GetUnitBaseStr(unit u) -> real {
        integer mainType;
        player p;
        real base; real mainVal; real subVal;
        real result; real shareBase;
        real debt;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }
        if (isUnitStrDisabled(u)) { return 0.0; }

        p = GetOwningPlayer(u);
        mainType = GetUnitMainAttrType(u);
        base = GetUnitBaseStrRaw(u);
        mainVal = GetMainAttrValueReal(u);
        subVal = GetSubAttrValueReal(u);

        // 自身基础值
        if (mainType == 0) {
            result = base + mainVal;
            // 减去主属性欠款
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN_CACHE);
            result = result - debt;
        } else {
            result = base + subVal;
            // 减去次属性欠款
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB_CACHE);
            result = result - debt;
        }

        // 减去自身欠款
        debt = bigInteger.toReal(p, HASH_KEY_BIGINT_STR_CACHE);
        result = result - debt;

        // AGI -> STR 共享
        if (isAgiToStrShare(u)) {
            shareBase = GetUnitBaseAgiRaw(u);
            if (mainType == 1) {
                shareBase = shareBase + mainVal;
                // 减去主属性欠款
                debt = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN_CACHE);
                shareBase = shareBase - debt;
            } else {
                shareBase = shareBase + subVal;
                // 减去次属性欠款
                debt = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB_CACHE);
                shareBase = shareBase - debt;
            }
            // 减去 AGI 的欠款（因为共享来源的欠款也要扣除）
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_AGI_CACHE);
            shareBase = shareBase - debt;
            result = result + shareBase;
        }

        // INT -> STR 共享
        if (isIntToStrShare(u)) {
            shareBase = GetUnitBaseIntRaw(u);
            if (mainType == 2) {
                shareBase = shareBase + mainVal;
                // 减去主属性欠款
                debt = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN_CACHE);
                shareBase = shareBase - debt;
            } else {
                shareBase = shareBase + subVal;
                // 减去次属性欠款
                debt = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB_CACHE);
                shareBase = shareBase - debt;
            }
            // 减去 INT 的欠款（因为共享来源的欠款也要扣除）
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_INT_CACHE);
            shareBase = shareBase - debt;
            result = result + shareBase;
        }

        p = null;

        return result;
    }

    public function GetUnitBaseAgi(unit u) -> real {
        integer mainType;
        player p;
        real base; real mainVal; real subVal;
        real result; real shareBase;
        real debt;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }
        if (isUnitAgiDisabled(u)) { return 0.0; }

        p = GetOwningPlayer(u);
        mainType = GetUnitMainAttrType(u);
        base = GetUnitBaseAgiRaw(u);
        mainVal = GetMainAttrValueReal(u);
        subVal = GetSubAttrValueReal(u);

        // 自身基础值
        if (mainType == 1) {
            result = base + mainVal;
            // 减去主属性欠款
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN_CACHE);
            result = result - debt;
        } else {
            result = base + subVal;
            // 减去次属性欠款
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB_CACHE);
            result = result - debt;
        }

        // 减去自身欠款
        debt = bigInteger.toReal(p, HASH_KEY_BIGINT_AGI_CACHE);
        result = result - debt;

        // STR -> AGI 共享
        if (isStrToAgiShare(u)) {
            shareBase = GetUnitBaseStrRaw(u);
            if (mainType == 0) {
                shareBase = shareBase + mainVal;
                // 减去主属性欠款
                debt = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN_CACHE);
                shareBase = shareBase - debt;
            } else {
                shareBase = shareBase + subVal;
                // 减去次属性欠款
                debt = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB_CACHE);
                shareBase = shareBase - debt;
            }
            // 减去 STR 的欠款（因为共享来源的欠款也要扣除）
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_STR_CACHE);
            shareBase = shareBase - debt;
            result = result + shareBase;
        }

        // INT -> AGI 共享
        if (isIntToAgiShare(u)) {
            shareBase = GetUnitBaseIntRaw(u);
            if (mainType == 2) {
                shareBase = shareBase + mainVal;
                // 减去主属性欠款
                debt = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN_CACHE);
                shareBase = shareBase - debt;
            } else {
                shareBase = shareBase + subVal;
                // 减去次属性欠款
                debt = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB_CACHE);
                shareBase = shareBase - debt;
            }
            // 减去 INT 的欠款（因为共享来源的欠款也要扣除）
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_INT_CACHE);
            shareBase = shareBase - debt;
            result = result + shareBase;
        }

        p = null;

        return result;
    }

    public function GetUnitBaseInt(unit u) -> real {
        integer mainType;
        player p;
        real base; real mainVal; real subVal;
        real result; real shareBase;
        real debt;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }
        if (isUnitIntDisabled(u)) { return 0.0; }

        p = GetOwningPlayer(u);
        mainType = GetUnitMainAttrType(u);
        base = GetUnitBaseIntRaw(u);
        mainVal = GetMainAttrValueReal(u);
        subVal = GetSubAttrValueReal(u);

        // 自身基础值
        if (mainType == 2) {
            result = base + mainVal;
            // 减去主属性欠款
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN_CACHE);
            result = result - debt;
        } else {
            result = base + subVal;
            // 减去次属性欠款
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB_CACHE);
            result = result - debt;
        }

        // 减去自身欠款
        debt = bigInteger.toReal(p, HASH_KEY_BIGINT_INT_CACHE);
        result = result - debt;

        // STR -> INT 共享
        if (isStrToIntShare(u)) {
            shareBase = GetUnitBaseStrRaw(u);
            if (mainType == 0) {
                shareBase = shareBase + mainVal;
                // 减去主属性欠款
                debt = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN_CACHE);
                shareBase = shareBase - debt;
            } else {
                shareBase = shareBase + subVal;
                // 减去次属性欠款
                debt = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB_CACHE);
                shareBase = shareBase - debt;
            }
            // 减去 STR 的欠款（因为共享来源的欠款也要扣除）
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_STR_CACHE);
            shareBase = shareBase - debt;
            result = result + shareBase;
        }

        // AGI -> INT 共享
        if (isAgiToIntShare(u)) {
            shareBase = GetUnitBaseAgiRaw(u);
            if (mainType == 1) {
                shareBase = shareBase + mainVal;
                // 减去主属性欠款
                debt = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN_CACHE);
                shareBase = shareBase - debt;
            } else {
                shareBase = shareBase + subVal;
                // 减去次属性欠款
                debt = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB_CACHE);
                shareBase = shareBase - debt;
            }
            // 减去 AGI 的欠款（因为共享来源的欠款也要扣除）
            debt = bigInteger.toReal(p, HASH_KEY_BIGINT_AGI_CACHE);
            shareBase = shareBase - debt;
            result = result + shareBase;
        }

        p = null;

        return result;
    }

    //=====================
    // 三维属性最终倍率
    //  - 基本公式：(1 + Σ(up)) * Π(1 - down)
    //  - up = 本属性 up + 对应层 up（主/次属性）
    //  - 若存在跨属性共享，则叠加共享来源的 up/down/layerUp/layerDown
    //=====================

    private function GetUnitStrFinalPercentInternal(unit u) -> real {
        integer mainType;
        real attrUp; real attrDown; real layerUp; real layerDown;
        real upSum; real downMul;
        real otherAttrUp; real otherAttrDown; real otherLayerUp; real otherLayerDown;

        if (u == null) { return 1.0; }
        if (!IsUnitBigInteger(u)) { return 1.0; }
        if (isUnitStrDisabled(u)) { return 0.0; }

        mainType = GetUnitMainAttrType(u);

        // 自身 up/down
        attrUp = GetUnitStrUpRate(u);
        attrDown = GetUnitStrDownRate(u);
        if (mainType == 0) {
            layerUp = GetMainAttrUpRate(u);
            layerDown = GetMainAttrDownRate(u);
        } else {
            layerUp = GetSubAttrUpRate(u);
            layerDown = GetSubAttrDownRate(u);
        }

        upSum = attrUp + layerUp;
        downMul = (1.0 - attrDown) * (1.0 - layerDown);

        // AGI -> STR 共享
        if (isAgiToStrShare(u)) {
            otherAttrUp = GetUnitAgiUpRate(u);
            otherAttrDown = GetUnitAgiDownRate(u);
            if (mainType == 1) {
                otherLayerUp = GetMainAttrUpRate(u);
                otherLayerDown = GetMainAttrDownRate(u);
            } else {
                otherLayerUp = GetSubAttrUpRate(u);
                otherLayerDown = GetSubAttrDownRate(u);
            }
            upSum = upSum + otherAttrUp + otherLayerUp;
            downMul = downMul * (1.0 - otherAttrDown) * (1.0 - otherLayerDown);
        }

        // INT -> STR 共享
        if (isIntToStrShare(u)) {
            otherAttrUp = GetUnitIntUpRate(u);
            otherAttrDown = GetUnitIntDownRate(u);
            if (mainType == 2) {
                otherLayerUp = GetMainAttrUpRate(u);
                otherLayerDown = GetMainAttrDownRate(u);
            } else {
                otherLayerUp = GetSubAttrUpRate(u);
                otherLayerDown = GetSubAttrDownRate(u);
            }
            upSum = upSum + otherAttrUp + otherLayerUp;
            downMul = downMul * (1.0 - otherAttrDown) * (1.0 - otherLayerDown);
        }

        return (1.0 + upSum) * downMul;
    }

    public function GetUnitStrFinalPercent(unit u) -> real {
        return GetUnitStrFinalPercentInternal(u);
    }

    private function GetUnitAgiFinalPercentInternal(unit u) -> real {
        integer mainType;
        real attrUp; real attrDown; real layerUp; real layerDown;
        real upSum; real downMul;
        real otherAttrUp; real otherAttrDown; real otherLayerUp; real otherLayerDown;

        if (u == null) { return 1.0; }
        if (!IsUnitBigInteger(u)) { return 1.0; }
        if (isUnitAgiDisabled(u)) { return 0.0; }

        mainType = GetUnitMainAttrType(u);

        // 自身 up/down
        attrUp = GetUnitAgiUpRate(u);
        attrDown = GetUnitAgiDownRate(u);
        if (mainType == 1) {
            layerUp = GetMainAttrUpRate(u);
            layerDown = GetMainAttrDownRate(u);
        } else {
            layerUp = GetSubAttrUpRate(u);
            layerDown = GetSubAttrDownRate(u);
        }

        upSum = attrUp + layerUp;
        downMul = (1.0 - attrDown) * (1.0 - layerDown);

        // STR -> AGI 共享
        if (isStrToAgiShare(u)) {
            otherAttrUp = GetUnitStrUpRate(u);
            otherAttrDown = GetUnitStrDownRate(u);
            if (mainType == 0) {
                otherLayerUp = GetMainAttrUpRate(u);
                otherLayerDown = GetMainAttrDownRate(u);
            } else {
                otherLayerUp = GetSubAttrUpRate(u);
                otherLayerDown = GetSubAttrDownRate(u);
            }
            upSum = upSum + otherAttrUp + otherLayerUp;
            downMul = downMul * (1.0 - otherAttrDown) * (1.0 - otherLayerDown);
        }

        // INT -> AGI 共享
        if (isIntToAgiShare(u)) {
            otherAttrUp = GetUnitIntUpRate(u);
            otherAttrDown = GetUnitIntDownRate(u);
            if (mainType == 2) {
                otherLayerUp = GetMainAttrUpRate(u);
                otherLayerDown = GetMainAttrDownRate(u);
            } else {
                otherLayerUp = GetSubAttrUpRate(u);
                otherLayerDown = GetSubAttrDownRate(u);
            }
            upSum = upSum + otherAttrUp + otherLayerUp;
            downMul = downMul * (1.0 - otherAttrDown) * (1.0 - otherLayerDown);
        }

        return (1.0 + upSum) * downMul;
    }

    public function GetUnitAgiFinalPercent(unit u) -> real {
        return GetUnitAgiFinalPercentInternal(u);
    }

    private function GetUnitIntFinalPercentInternal(unit u) -> real {
        integer mainType;
        real attrUp; real attrDown; real layerUp; real layerDown;
        real upSum; real downMul;
        real otherAttrUp; real otherAttrDown; real otherLayerUp; real otherLayerDown;

        if (u == null) { return 1.0; }
        if (!IsUnitBigInteger(u)) { return 1.0; }
        if (isUnitIntDisabled(u)) { return 0.0; }

        mainType = GetUnitMainAttrType(u);

        // 自身 up/down
        attrUp = GetUnitIntUpRate(u);
        attrDown = GetUnitIntDownRate(u);
        if (mainType == 2) {
            layerUp = GetMainAttrUpRate(u);
            layerDown = GetMainAttrDownRate(u);
        } else {
            layerUp = GetSubAttrUpRate(u);
            layerDown = GetSubAttrDownRate(u);
        }

        upSum = attrUp + layerUp;
        downMul = (1.0 - attrDown) * (1.0 - layerDown);

        // STR -> INT 共享
        if (isStrToIntShare(u)) {
            otherAttrUp = GetUnitStrUpRate(u);
            otherAttrDown = GetUnitStrDownRate(u);
            if (mainType == 0) {
                otherLayerUp = GetMainAttrUpRate(u);
                otherLayerDown = GetMainAttrDownRate(u);
            } else {
                otherLayerUp = GetSubAttrUpRate(u);
                otherLayerDown = GetSubAttrDownRate(u);
            }
            upSum = upSum + otherAttrUp + otherLayerUp;
            downMul = downMul * (1.0 - otherAttrDown) * (1.0 - otherLayerDown);
        }

        // AGI -> INT 共享
        if (isAgiToIntShare(u)) {
            otherAttrUp = GetUnitAgiUpRate(u);
            otherAttrDown = GetUnitAgiDownRate(u);
            if (mainType == 1) {
                otherLayerUp = GetMainAttrUpRate(u);
                otherLayerDown = GetMainAttrDownRate(u);
            } else {
                otherLayerUp = GetSubAttrUpRate(u);
                otherLayerDown = GetSubAttrDownRate(u);
            }
            upSum = upSum + otherAttrUp + otherLayerUp;
            downMul = downMul * (1.0 - otherAttrDown) * (1.0 - otherLayerDown);
        }

        return (1.0 + upSum) * downMul;
    }

    public function GetUnitIntFinalPercent(unit u) -> real {
        return GetUnitIntFinalPercentInternal(u);
    }

    //=====================
    // 三维属性 set/add/get（大数英雄专用）
    //=====================

    public function GetUnitStr(unit u) -> real {
        integer mainType;
        real baseTotal; real finalPercent;
        real totalBonus;
        real bonusAttr; real bonusOther;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }
        if (isUnitStrDisabled(u)) { return 0.0; }

        mainType = GetUnitMainAttrType(u);

        // 基础值：已包含跨属性共享
        baseTotal = GetUnitBaseStr(u);

        // 自身 Bonus
        bonusAttr = GetUnitStrBonusReal(u);
        if (mainType == 0) {
            bonusOther = GetMainAttrBonusReal(u);
        } else {
            bonusOther = GetSubAttrBonusReal(u);
        }
        totalBonus = bonusAttr + bonusOther;

        // 来自敏捷的共享 Bonus
        if (isAgiToStrShare(u)) {
            bonusAttr = GetUnitAgiBonusReal(u);
            if (mainType == 1) {
                bonusOther = GetMainAttrBonusReal(u);
            } else {
                bonusOther = GetSubAttrBonusReal(u);
            }
            totalBonus = totalBonus + bonusAttr + bonusOther;
        }

        // 来自智力的共享 Bonus
        if (isIntToStrShare(u)) {
            bonusAttr = GetUnitIntBonusReal(u);
            if (mainType == 2) {
                bonusOther = GetMainAttrBonusReal(u);
            } else {
                bonusOther = GetSubAttrBonusReal(u);
            }
            totalBonus = totalBonus + bonusAttr + bonusOther;
        }

        finalPercent = GetUnitStrFinalPercentInternal(u);
        return RMaxBJ(0.0,baseTotal * finalPercent + totalBonus);
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
        // 如果力量计入敏捷，触发敏捷回调
        if (isStrToAgiShare(u)) {
            heroAttrObserver.fire(1);
        }
        // 如果力量计入智力，触发智力回调
        if (isStrToIntShare(u)) {
            heroAttrObserver.fire(2);
        }
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
        // 如果力量计入敏捷，触发敏捷回调
        if (isStrToAgiShare(u)) {
            heroAttrObserver.fire(1);
        }
        // 如果力量计入智力，触发智力回调
        if (isStrToIntShare(u)) {
            heroAttrObserver.fire(2);
        }
    }

    public function GetUnitAgi(unit u) -> real {
        integer mainType;
        real baseTotal; real finalPercent;
        real totalBonus;
        real bonusAttr; real bonusOther;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }
        if (isUnitAgiDisabled(u)) { return 0.0; }

        mainType = GetUnitMainAttrType(u);

        // 基础值：已包含跨属性共享
        baseTotal = GetUnitBaseAgi(u);

        // 自身 Bonus
        bonusAttr = GetUnitAgiBonusReal(u);
        if (mainType == 1) {
            bonusOther = GetMainAttrBonusReal(u);
        } else {
            bonusOther = GetSubAttrBonusReal(u);
        }
        totalBonus = bonusAttr + bonusOther;

        // 来自力量的共享 Bonus
        if (isStrToAgiShare(u)) {
            bonusAttr = GetUnitStrBonusReal(u);
            if (mainType == 0) {
                bonusOther = GetMainAttrBonusReal(u);
            } else {
                bonusOther = GetSubAttrBonusReal(u);
            }
            totalBonus = totalBonus + bonusAttr + bonusOther;
        }

        // 来自智力的共享 Bonus
        if (isIntToAgiShare(u)) {
            bonusAttr = GetUnitIntBonusReal(u);
            if (mainType == 2) {
                bonusOther = GetMainAttrBonusReal(u);
            } else {
                bonusOther = GetSubAttrBonusReal(u);
            }
            totalBonus = totalBonus + bonusAttr + bonusOther;
        }

        finalPercent = GetUnitAgiFinalPercentInternal(u);
        return RMaxBJ(0.0,baseTotal * finalPercent + totalBonus);
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
        // 如果敏捷计入力量，触发力量回调
        if (isAgiToStrShare(u)) {
            heroAttrObserver.fire(0);
        }
        // 如果敏捷计入智力，触发智力回调
        if (isAgiToIntShare(u)) {
            heroAttrObserver.fire(2);
        }
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
        // 如果敏捷计入力量，触发力量回调
        if (isAgiToStrShare(u)) {
            heroAttrObserver.fire(0);
        }
        // 如果敏捷计入智力，触发智力回调
        if (isAgiToIntShare(u)) {
            heroAttrObserver.fire(2);
        }
    }

    public function GetUnitInt(unit u) -> real {
        integer mainType;
        real baseTotal; real finalPercent;
        real totalBonus;
        real bonusAttr; real bonusOther;

        if (u == null) { return 0.0; }
        if (!IsUnitBigInteger(u)) { return 0.0; }
        if (isUnitIntDisabled(u)) { return 0.0; }

        mainType = GetUnitMainAttrType(u);

        // 基础值：已包含跨属性共享
        baseTotal = GetUnitBaseInt(u);

        // 自身 Bonus
        bonusAttr = GetUnitIntBonusReal(u);
        if (mainType == 2) {
            bonusOther = GetMainAttrBonusReal(u);
        } else {
            bonusOther = GetSubAttrBonusReal(u);
        }
        totalBonus = bonusAttr + bonusOther;

        // 来自力量的共享 Bonus
        if (isStrToIntShare(u)) {
            bonusAttr = GetUnitStrBonusReal(u);
            if (mainType == 0) {
                bonusOther = GetMainAttrBonusReal(u);
            } else {
                bonusOther = GetSubAttrBonusReal(u);
            }
            totalBonus = totalBonus + bonusAttr + bonusOther;
        }

        // 来自敏捷的共享 Bonus
        if (isAgiToIntShare(u)) {
            bonusAttr = GetUnitAgiBonusReal(u);
            if (mainType == 1) {
                bonusOther = GetMainAttrBonusReal(u);
            } else {
                bonusOther = GetSubAttrBonusReal(u);
            }
            totalBonus = totalBonus + bonusAttr + bonusOther;
        }

        finalPercent = GetUnitIntFinalPercentInternal(u);
        return RMaxBJ(0.0,baseTotal * finalPercent + totalBonus);
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
        // 如果智力计入力量，触发力量回调
        if (isIntToStrShare(u)) {
            heroAttrObserver.fire(0);
        }
        // 如果智力计入敏捷，触发敏捷回调
        if (isIntToAgiShare(u)) {
            heroAttrObserver.fire(1);
        }
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
        // 如果智力计入力量，触发力量回调
        if (isIntToStrShare(u)) {
            heroAttrObserver.fire(0);
        }
        // 如果智力计入敏捷，触发敏捷回调
        if (isIntToAgiShare(u)) {
            heroAttrObserver.fire(1);
        }
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

