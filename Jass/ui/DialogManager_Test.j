#ifndef UTDialogManagerIncluded
#define UTDialogManagerIncluded

//! zinc
//===========================================================================
// DialogManager_Test.j
//===========================================================================
// 对话框管理器的单元测试库
//
// 测试指令:
// 基础测试:
// s1-s10     : 预留的基础测试函数槽位
// 功能测试:
// -p [数量]  : 创建分页对话框,测试翻页功能
// -e [数量]  : 创建带ESC的对话框,测试退出功能
// -r         : 随机创建对话框,测试稳定性
// -c         : 清除当前玩家的对话框
//
// 作者: Crainax
// 最后修改: 2024-11-18
//===========================================================================
library UTDialogManager requires DialogManager {

    //预留的基础测试函数
    function TTestUTDialogManager1 (player p) {}
    function TTestUTDialogManager2 (player p) {}
    function TTestUTDialogManager3 (player p) {}
    function TTestUTDialogManager4 (player p) {}
    function TTestUTDialogManager5 (player p) {}
    function TTestUTDialogManager6 (player p) {}
    function TTestUTDialogManager7 (player p) {}
    function TTestUTDialogManager8 (player p) {}
    function TTestUTDialogManager9 (player p) {}
    function TTestUTDialogManager10 (player p) {}

    //功能测试函数
    private function testPageDialog(player p, integer num) {
        dlgMgr dlg = dlgMgr.create(p, "分页对话框测试", num);
        dlg.onClick(function(){
            dlgMgr dlg = dlgCtx.dlThis;
            DisplayTextToPlayer(dlg.p, 0., 0.,
                "|cffff9900[分页对话框]|r 点击了第 " + I2S(dlgCtx.pos) + " 个选项");
            dlg.destroy();
        });
        dlg.refTitle(function(dlgMgr dlg, integer pos) -> string {
            return "[" + I2S(dlg) + "]选项 " + I2S(pos) + " - " + I2S(GetRandomInt(1,999));
        });
        dlg.show();
    }

    private function testEscDialog(player p, integer num) {
        dlgMgr dlg = dlgMgr.create(p, "ESC对话框测试", num);
        dlg.onClick(function(){
            dlgMgr dlg = dlgCtx.dlThis;
            DisplayTextToPlayer(dlg.p, 0., 0.,
                "|cffff9900[ESC对话框]|r 点击了第 " + I2S(dlgCtx.pos) + " 个选项");
            dlg.destroy();
        });
        dlg.refTitle(function(dlgMgr dlg, integer pos) -> string {
            return "[" + I2S(dlg) + "]选项 " + I2S(pos) + " - " + I2S(GetRandomInt(1,999));
        });
        dlg.esc = true;
        dlg.show();
    }

    private function testRandomDialog(player p) {
        integer num = GetRandomInt(1, 20);
        boolean hasEsc = (GetRandomInt(0,1) == 1);
        dlgMgr dlg = dlgMgr.create(p, "随机测试", num);
        dlg.onClick(function(){
            dlgMgr dlg = dlgCtx.dlThis;
            DisplayTextToPlayer(dlg.p, 0., 0.,
                "|cff00ffff[随机对话框]|r 点击了第 " + I2S(dlgCtx.pos) + " 个选项");
            dlg.destroy();
        });
        dlg.refTitle(function(dlgMgr dlg, integer pos) -> string {
            return "[" + I2S(dlg) + "]选项 " + I2S(pos) + " - " + I2S(GetRandomInt(1,999));
        });
        dlg.esc = hasEsc;
        dlg.show();

        DisplayTextToPlayer(p, 0., 0.,
            "|cff00ffff[随机对话框]|r 生成了 " + I2S(num) + " 个选项" +
            S3(hasEsc, " (带ESC)", ""));
    }

    private function clearDialog(player p) {
        integer index = GetConvertedPlayerId(p);
        if (DL[index].isExist()) {
            DL[index].destroy();
            DisplayTextToPlayer(p, 0., 0., "|cffff0000[清除]|r 对话框已清除");
        } else {
            DisplayTextToPlayer(p, 0., 0., "|cffff0000[清除]|r 没有找到活动的对话框");
        }
    }

    //处理测试命令
    private function handleTestCommand(string cmd) {
        player p = GetTriggerPlayer();
        string cmdType = SubString(cmd, 0, 2);
        integer num = 1;

        if (StringLength(cmd) > 2) {
            num = S2I(SubString(cmd, 2, StringLength(cmd)));
        }

        if (cmdType == "-p") {
            testPageDialog(p, num);
        }
        else if (cmdType == "-e") {
            testEscDialog(p, num);
        }
        else if (cmdType == "-r") {
            testRandomDialog(p);
        }

        p = null;
    }

    //初始化
    private function onInit() {
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr, 0.5);
        TriggerAddCondition(tr, Condition(function() {
            BJDebugMsg("|cff00ff00[DialogManager测试]|r 已加载");
            BJDebugMsg("基础测试指令: s1-s10");
            BJDebugMsg("功能测试指令:");
            BJDebugMsg("-p [数量] : 测试分页对话框");
            BJDebugMsg("-e [数量] : 测试带ESC的对话框");
            BJDebugMsg("-r : 测试随机对话框");
            BJDebugMsg("|cffff9900右键点击|r : 清除当前对话框");
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;

        //注册聊天命令
        UnitTestRegisterChatEvent(function() {
            string cmd = GetEventPlayerChatString();
            if (SubString(cmd,0,1) == "-") {
                handleTestCommand(cmd);
            }
            else if (cmd == "s1") TTestUTDialogManager1(GetTriggerPlayer());
            else if (cmd == "s2") TTestUTDialogManager2(GetTriggerPlayer());
            else if (cmd == "s3") TTestUTDialogManager3(GetTriggerPlayer());
            else if (cmd == "s4") TTestUTDialogManager4(GetTriggerPlayer());
            else if (cmd == "s5") TTestUTDialogManager5(GetTriggerPlayer());
            else if (cmd == "s6") TTestUTDialogManager6(GetTriggerPlayer());
            else if (cmd == "s7") TTestUTDialogManager7(GetTriggerPlayer());
            else if (cmd == "s8") TTestUTDialogManager8(GetTriggerPlayer());
            else if (cmd == "s9") TTestUTDialogManager9(GetTriggerPlayer());
            else if (cmd == "s10") TTestUTDialogManager10(GetTriggerPlayer());
        });

        //注册鼠标右键点击事件
        DzTriggerRegisterMouseEventByCode(null, 2, 1, false, function() {
            clearDialog(GetTriggerPlayer());
        });
    }
}

//! endzinc
#endif
