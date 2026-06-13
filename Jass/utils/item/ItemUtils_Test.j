#ifndef UTItemUtilsIncluded
#define UTItemUtilsIncluded

// 用空地图测试
#undef OriginMapUnitTestMode

//! zinc

library UTItemUtils requires ItemUtils, UnitTestFramwork {
    private item testItem = null;

    private function CleanupTestItem() {
        if (testItem != null) {
            ClearItemCooldownEx(testItem);
            if (GetItemTypeId(testItem) != 0) {
                RemoveItem(testItem);
            }
            testItem = null;
        }
    }

    private function CreateTestItem() -> item {
        CleanupTestItem();
        testItem = CreateItem('phea', 0.0, 0.0);
        SetItemUserData(testItem, 0);
        SetItemPawnable(testItem, true);
        SetItemDroppable(testItem, true);
        return testItem;
    }

    private function Test_Set_Start() {
        item it;

        it = CreateTestItem();
        SetItemCooldownEx(it, 0.3);
        assert.Boolean(!IsItemCooldownExOK(it), "SetItemCooldownEx 后物品应进入冷却");
        assert.Real(GetItemCooldownEx(it), 0.3, "0.3 秒冷却应以 0.1 秒刻度保存");
        assert.Integer(GetItemCharges(it), 1, "不足 1 秒的冷却 charges 应向上显示为 1");
        assert.Boolean(!IsItemPawnable(it), "普通物品冷却中应不可出售");

        it = null;
    }

    private function Test_Set_End() {
        assert.Boolean(IsItemCooldownExOK(testItem), "0.3 秒冷却结束后应就绪");
        assert.Real(GetItemCooldownEx(testItem), 0.0, "冷却结束后剩余时间应为 0");
        assert.Integer(GetItemCharges(testItem), 0, "冷却结束后 charges 应清零");
        assert.Boolean(IsItemPawnable(testItem), "冷却结束后应恢复可出售");
        CleanupTestItem();
    }

    private function Test_Update_Start() {
        item it;

        it = CreateTestItem();
        SetItemCooldownEx(it, 1.0);
        SetItemCooldownEx(it, 0.2);
        assert.Real(GetItemCooldownEx(it), 0.2, "重复设置同一物品应更新为新冷却");
        assert.Integer(GetItemCharges(it), 1, "0.2 秒冷却 charges 应向上显示为 1");

        it = null;
    }

    private function Test_Update_End() {
        assert.Boolean(IsItemCooldownExOK(testItem), "重复设置后的 0.2 秒冷却应按新值结束");
        assert.Integer(GetItemCharges(testItem), 0, "重复设置后的冷却结束应清零 charges");
        CleanupTestItem();
    }

    private function Test_Clear() {
        item it;

        it = CreateTestItem();
        SetItemCooldownEx(it, 1.0);
        ClearItemCooldownEx(it);
        assert.Boolean(IsItemCooldownExOK(it), "ClearItemCooldownEx 后物品应立即就绪");
        assert.Real(GetItemCooldownEx(it), 0.0, "ClearItemCooldownEx 后剩余时间应为 0");
        assert.Integer(GetItemCharges(it), 0, "ClearItemCooldownEx 后 charges 应清零");
        assert.Boolean(IsItemPawnable(it), "ClearItemCooldownEx 后应恢复可出售");
        CleanupTestItem();

        it = null;
    }

    private function Test_Removed_Start() {
        item it;

        it = CreateTestItem();
        SetItemCooldownEx(it, 1.0);
        RemoveItem(it);
        assert.Boolean(IsItemCooldownExOK(it), "已移除物品应视为冷却就绪");

        it = null;
    }

    private function Test_Removed_End() {
        assert.Boolean(testItem == null || IsItemCooldownExOK(testItem), "已移除物品不应卡住冷却状态");
        testItem = null;
    }

    function onInit() {
        trigger tr;

        tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr, 0.5);
        TriggerAddCondition(tr, Condition(function () -> boolean {
            BJDebugMsg("[ItemUtils] 单元测试已加载");

            UnitTestAutoTimer(0.20, 0.10, function() {
                Test_Set_Start();
            }, null);
            UnitTestAutoTimer(0.65, 0.10, function() {
                Test_Set_End();
            }, null);
            UnitTestAutoTimer(0.80, 0.10, function() {
                Test_Update_Start();
            }, null);
            UnitTestAutoTimer(1.15, 0.10, function() {
                Test_Update_End();
            }, null);
            UnitTestAutoTimer(1.30, 0.10, function() {
                Test_Clear();
            }, null);
            UnitTestAutoTimer(1.45, 0.10, function() {
                Test_Removed_Start();
            }, null);
            UnitTestAutoTimer(1.70, 0.10, function() {
                Test_Removed_End();
            }, null);

            DestroyTrigger(GetTriggeringTrigger());
            return false;
        }));
        tr = null;
    }
}

//! endzinc

#endif
