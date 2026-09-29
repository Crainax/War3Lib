#ifndef UnitPathingIncluded
#define UnitPathingIncluded

#include "Crainax/core/table/Hash_UnitDefine.j"

//! zinc
library UnitPathing requires UnitHashTable {
    // 查询是否仍有生效的穿墙来源，不改变碰撞状态。
    public function IsUnitPathingDisabled(unit u) -> boolean {
        if (u == null) { return false; }
        return LoadInteger(HASH_UNIT, GetHandleId(u), KEY_UNIT_PATHING_SOURCES) != 0;
    }

    // source 为调用方统一分配的 0..29 槽位；同一来源重复开启/关闭不会累加。
    // 所有共存的穿墙效果须通过本接口控制；单位删除时随 HASH_UNIT 清理。
    public function SetUnitPathingDisabledSource(unit u, integer source, boolean enabled) {
        integer id;
        integer mask;
        integer bit;
        boolean active;
        if (u == null || GetUnitTypeId(u) == 0 || source < 0 || source > 29) { return; }
        id = GetHandleId(u);
        mask = LoadInteger(HASH_UNIT, id, KEY_UNIT_PATHING_SOURCES);
        bit = R2I(Pow(2.0, I2R(source)));
        active = ModuloInteger(mask / bit, 2) != 0;
        if (enabled && !active) {
            mask += bit;
        } else if (!enabled && active) {
            mask -= bit;
        } else if (!enabled) {
            return;
        }
        if (mask == 0) {
            RemoveSavedInteger(HASH_UNIT, id, KEY_UNIT_PATHING_SOURCES);
        } else {
            SaveInteger(HASH_UNIT, id, KEY_UNIT_PATHING_SOURCES, mask);
        }
        // 重复开启仍重施穿墙，便于复活后恢复。
        SetUnitPathing(u, mask == 0);
    }
}
//! endzinc
#endif
