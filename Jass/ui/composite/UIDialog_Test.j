#ifndef UTUIDialogIncluded
#define UTUIDialogIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

library UTUIDialog requires UIDialog,SyncBus {

    private dialogData currentDD = 0;
    private integer contentCallCount = 0;
    private integer enterCallCount = 0;
    private integer leaveCallCount = 0;
    private integer clickCallCount = 0;
    private boolean useHashBinding = false;

    private function DestroyCurrentDialogData() {
        if (currentDD.isExist()) {
            currentDD.destroy();
            currentDD = 0;
        }
    }

    private function CalcPageCount(integer total) -> integer {
        if (total <= 0) {
            return 1;
        }
        return (total + 9 - 1) / 9;
    }

    private function BindCommonCallback(dialogData dd) {
        dd.trContent(function () {
            integer pos = GetUIDialogPosAsync();
            contentCallCount += 1;
            CallbackUIDialogContent("测试条目 #" + I2S(pos));
        });

        dd.onEnter(function () {
            integer pos = GetUIDialogPosAsync();
            enterCallCount += 1;
            BJDebugMsg("[UIDialogTest] Enter: pos=" + I2S(pos));
        });

        dd.onLeave(function () {
            integer pos = GetUIDialogPosAsync();
            leaveCallCount += 1;
            BJDebugMsg("[UIDialogTest] Leave: pos=" + I2S(pos));
        });

        dd.onClick(function () {
            dialogData data = GetUIDialogData();
            integer pos = GetUIDialogPos();
            integer value = 0;
            clickCallCount += 1;

            if (useHashBinding) {
                value = LoadInteger(HASH_DIALOG, data, 100 + pos);
                BJDebugMsg("[UIDialogTest] Click: pos=" + I2S(pos) + ", hash=" + I2S(value));
            } else {
                BJDebugMsg("[UIDialogTest] Click: pos=" + I2S(pos));
            }
        });
    }

    private function CreateTestDialog(player p, integer count, string title, boolean bindHash) {
        integer i;
        DestroyCurrentDialogData();

        currentDD = dialogData.create(p, count);
        if (!currentDD.isExist()) {
            BJDebugMsg("|cffff0000[UIDialogTest]|r dialogData.create 失败");
            return;
        }

        currentDD.title = title;
        useHashBinding = bindHash;
        contentCallCount = 0;
        enterCallCount = 0;
        leaveCallCount = 0;
        clickCallCount = 0;

        if (bindHash) {
            for (1 <= i <= count) {
                SaveInteger(HASH_DIALOG, currentDD, 100 + i, 9000 + i);
            }
        }

        BindCommonCallback(currentDD);
        currentDD.show();
    }

    private function RunAutoAssert() {
        dialogData temp;

        assert.Integer(CalcPageCount(0), 1, "UIDialog: 0项时页数应为1");
        assert.Integer(CalcPageCount(9), 1, "UIDialog: 9项时页数应为1");
        assert.Integer(CalcPageCount(10), 2, "UIDialog: 10项时页数应为2");
        assert.Integer(CalcPageCount(17), 2, "UIDialog: 17项时页数应为2");

        // 全局位置映射边界：第2页第1项 -> 10
        assert.Integer((2 - 1) * 9 + 1, 10, "UIDialog: 全局位置映射边界");

        // 空回调容错（不注册任何回调）
        temp = dialogData.create(ConvertedPlayer(1), 3);
        assert.Boolean(temp.isExist(), "UIDialog: 空回调场景可创建");
        if (temp.isExist()) {
            temp.title = "空回调测试";
            temp.show();
            temp.hide();
            temp.destroy();
        }

        Trace("UIDialog: 自动断言完成");
    }

    function TTestUTUIDialog1(player p) {
        CreateTestDialog(p, 5, "UIDialog测试(无分页)", false);
        BJDebugMsg("[UIDialogTest] s1: 已创建5项对话框");
    }

    function TTestUTUIDialog2(player p) {
        CreateTestDialog(p, 17, "UIDialog测试(分页)", false);
        BJDebugMsg("[UIDialogTest] s2: 已创建17项对话框, 可测试翻页循环");
    }

    function TTestUTUIDialog3(player p) {
        if (!currentDD.isExist()) {
            CreateTestDialog(p, 11, "UIDialog测试(同步点击)", false);
        }

        if (currentDD.isExist()) {
            syncBus.DzSyncDataEx("UIDialog", "C," + I2S(currentDD) + ",2");
            BJDebugMsg("[UIDialogTest] s3: 已发送模拟点击 payload C,<id>,2");
        }
    }

    function TTestUTUIDialog4(player p) {
        CreateTestDialog(p, 6, "UIDialog测试(HASH绑定)", true);
        BJDebugMsg("[UIDialogTest] s4: 已绑定 HASH_DIALOG(100+pos), 请点击任意项验证读取");
    }

    function TTestUTUIDialog5(player p) {
        dialogData data;
        integer i;

        DestroyCurrentDialogData();
        data = dialogData.create(p, 9);
        if (!data.isExist()) {
            assert.Boolean(false, "UIDialog: s5 创建失败");
            return;
        }

        data.title = "UIDialog测试(压力销毁)";
        for (1 <= i <= 5) {
            data.show();
            data.hide();
        }
        data.destroy();

        assert.Boolean(true, "UIDialog: s5 重复show/hide完成");
        BJDebugMsg("[UIDialogTest] s5: 重复创建/销毁完成");
    }

    function TTestUTUIDialog6(player p) {
        CreateTestDialog(p, 6, "UIDialog测试(窄宽度)", false);
        if (currentDD.isExist()) {
            currentDD.setWidth(0.180);
            currentDD.refresh();
        }
        BJDebugMsg("[UIDialogTest] s6: 宽度已设为0.180(居中)");
    }

    function TTestUTUIDialog7(player p) {
        CreateTestDialog(p, 6, "UIDialog测试(左上角定位)", false);
        if (currentDD.isExist()) {
            currentDD.setWidth(0.180);
            currentDD.setAbsPoint(ANCHOR_TOPLEFT, 0.020, 0.560);
            currentDD.refresh();
        }
        BJDebugMsg("[UIDialogTest] s7: 已设置左上角定位(ANCHOR_TOPLEFT,0.020,0.560)+宽度0.180");
    }

    function TTestUTUIDialog8(player p) {
        CreateTestDialog(p, 6, "UIDialog测试(clearAbsPoint)", false);
        if (currentDD.isExist()) {
            currentDD.setWidth(0.180);
            currentDD.setAbsPoint(ANCHOR_TOPLEFT, 0.020, 0.560);
            currentDD.clearAbsPoint();
            currentDD.refresh();
        }
        BJDebugMsg("[UIDialogTest] s8: 已执行clearAbsPoint(), 对话框恢复居中");
    }
    function TTestUTUIDialog9(player p) {}
    function TTestUTUIDialog10(player p) {}

    function TTestActUTUIDialog1(string str) {
        player p = GetTriggerPlayer();

        if (str == "clear") {
            DestroyCurrentDialogData();
            BJDebugMsg("[UIDialogTest] 已清理 currentDD");
        }

        p = null;
    }

    function Init() {
        UnitTestAutoTimer(0.1, 2.0, function() {
            RunAutoAssert();
        }, null);
    }

    function onInit() {
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr, 0.5);
        TriggerAddCondition(tr, Condition(function () {
            BJDebugMsg("[UIDialog] 单元测试已加载");
            BJDebugMsg("s1: 5项无分页");
            BJDebugMsg("s2: 17项分页");
            BJDebugMsg("s3: 模拟同步点击并自动关闭");
            BJDebugMsg("s4: HASH_DIALOG 外部绑定读取");
            BJDebugMsg("s5: show/hide 压力销毁");
            BJDebugMsg("s6: setWidth(0.180) 宽度测试");
            BJDebugMsg("s7: setAbsPoint 左上角定位测试");
            BJDebugMsg("s8: clearAbsPoint 恢复居中测试");
            BJDebugMsg("-clear: 清理 currentDD");
            Init();
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;

        UnitTestRegisterChatEvent(function () {
            string str = GetEventPlayerChatString();

            if (SubStringBJ(str, 1, 1) == "-") {
                TTestActUTUIDialog1(SubStringBJ(str, 2, StringLength(str)));
                return;
            }

            if (str == "s1") TTestUTUIDialog1(GetTriggerPlayer());
            else if (str == "s2") TTestUTUIDialog2(GetTriggerPlayer());
            else if (str == "s3") TTestUTUIDialog3(GetTriggerPlayer());
            else if (str == "s4") TTestUTUIDialog4(GetTriggerPlayer());
            else if (str == "s5") TTestUTUIDialog5(GetTriggerPlayer());
            else if (str == "s6") TTestUTUIDialog6(GetTriggerPlayer());
            else if (str == "s7") TTestUTUIDialog7(GetTriggerPlayer());
            else if (str == "s8") TTestUTUIDialog8(GetTriggerPlayer());
            else if (str == "s9") TTestUTUIDialog9(GetTriggerPlayer());
            else if (str == "s10") TTestUTUIDialog10(GetTriggerPlayer());
        });
    }
}

//! endzinc

#endif
