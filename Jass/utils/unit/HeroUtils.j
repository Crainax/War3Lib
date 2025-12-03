#ifndef HeroUtilsIncluded
#define HeroUtilsIncluded


#include "Crainax/core/constant/JapiConstant.j" //constant可以直接加进去没问题
#include "Crainax/core/table/Hash_UnitDefine.j"
#include "Crainax/core/table/Hash_BIDefine.j"

//! zinc
/*
英雄属性相关
*/
library HeroUtils requires UnitUtils {

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


}

//! endzinc
#endif
