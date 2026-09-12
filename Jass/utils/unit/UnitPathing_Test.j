#ifndef UTUnitPathingIncluded
#define UTUnitPathingIncluded
#undef OriginMapUnitTestMode
#include "../../core/table/Hash_UnitDefine.j"
//! zinc
library UTUnitPathing requires UnitPathing {
    function onInit() {
        UnitTestAutoTimer(0.1, 0.0, function() {
            unit u = CreateUnit(Player(0), 'hfoo', 0.0, 0.0, 0.0);
            integer id = GetHandleId(u);
            SetUnitPathingDisabledSource(u, 0, true);
            SetUnitPathingDisabledSource(u, 0, true);
            assert.Integer(LoadInteger(HASH_UNIT, id, KEY_UNIT_PATHING_SOURCES), 1, "重复开启不累加");
            SetUnitPathingDisabledSource(u, 1, true);
            SetUnitPathingDisabledSource(u, 1, false);
            SetUnitPathingDisabledSource(u, 1, false);
            assert.Integer(LoadInteger(HASH_UNIT, id, KEY_UNIT_PATHING_SOURCES), 1, "临时来源结束保留永久来源");
            SetUnitPathingDisabledSource(u, 29, true);
            SetUnitPathingDisabledSource(u, 0, false);
            assert.Integer(LoadInteger(HASH_UNIT, id, KEY_UNIT_PATHING_SOURCES), 536870912, "移除永久来源保留其他来源");
            SetUnitPathingDisabledSource(u, 30, true);
            SetUnitPathingDisabledSource(u, -1, true);
            assert.Integer(LoadInteger(HASH_UNIT, id, KEY_UNIT_PATHING_SOURCES), 536870912, "非法槽位不改状态");
            SetUnitPathingDisabledSource(u, 29, false);
            assert.Boolean(!HaveSavedInteger(HASH_UNIT, id, KEY_UNIT_PATHING_SOURCES), "最后来源结束清理状态");
            RemoveUnit(u);
            u = null;
        }, null);
    }
}
//! endzinc
#endif
