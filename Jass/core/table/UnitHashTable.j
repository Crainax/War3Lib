#ifndef UnitHashTableIncluded
#define UnitHashTableIncluded


#include "Crainax/core/table/Hash_UnitDefine.j"

//! zinc
/*
单位哈希表
*/
library UnitHashTable {

    public hashtable HASH_UNIT = InitHashtable();  // 单位哈希表

    // 调用方负责提供跨客户端一致且全局唯一的正整数；HandleID 仅作为同一单位的本机查表键。
    public function SetUnitStableSyncId(unit u, integer stableId) -> boolean {
        if (u == null || GetUnitTypeId(u) == 0 || stableId <= 0) { return false; }
        SaveInteger(HASH_UNIT, GetHandleId(u), KEY_UNIT_STABLE_SYNC_ID, stableId);
        return true;
    }

    public function GetUnitStableSyncId(unit u) -> integer {
        if (u == null || GetUnitTypeId(u) == 0) { return 0; }
        return LoadInteger(HASH_UNIT, GetHandleId(u), KEY_UNIT_STABLE_SYNC_ID);
    }

}

//! endzinc
#endif
