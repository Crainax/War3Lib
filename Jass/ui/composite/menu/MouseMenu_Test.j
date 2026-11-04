#ifndef UTMouseMenuIncluded
#define UTMouseMenuIncluded
#undef OriginMapUnitTestMode
#define EmptyMapUnitTestMode
//! zinc
// Ordinary-frame menu regression harness. No SimpleMouseMenu dependency.
// Compile validation is not a substitute for the interactive checks described below.
library UTMouseMenu requires MouseMenu {
    private mouseMenu sample = 0;
    private mouseMenu successor = 0;
    private integer initialEsc = 0;
    private boolean upward = true;
    private integer amount = 3;
    private boolean verifySuccessor = false;

    private function CloseSamples() {
        if (sample.isExist()) { sample.destroy(); }
        if (successor.isExist()) { successor.destroy(); }
        sample = 0; successor = 0; verifySuccessor = false;
    }
    private function Log(string text) { Trace("[MouseMenu] " + text); }
    private function Assertions() {
        mouseMenu m;
        integer i = 0;
        integer baseline = 0;
        CloseSamples();
        baseline = escStack.getSize();
        m = mouseMenu.create(DzGetGameUI(), true, 0.13);
        assert.Integer(m.getItemCount(), 0, "[MouseMenu] new empty");
        m.show(true);
        assert.Integer(escStack.getSize(), baseline, "[MouseMenu] empty does not push Esc");
        for (1 <= i <= 25) { m.AddMenuItem("菜单 " + I2S(i)); }
        assert.Integer(m.getItemCount(), 20, "[MouseMenu] capacity and overflow");
        for (1 <= i <= 30) {
            m.showAt(0.79, 0.59).show(true);
            assert.Integer(escStack.getSize(), baseline + 1, "[MouseMenu] one Esc per shown menu");
            m.show(false);
            assert.Integer(escStack.getSize(), baseline, "[MouseMenu] hide removes Esc");
        }
        m.showAt(0.4, 0.3);
        escStack.pop();
        assert.Boolean(!m.isShown(), "[MouseMenu] Esc hides menu");
        assert.Integer(escStack.getSize(), baseline, "[MouseMenu] Esc pops once");
        m.showAt(0.4, 0.3);
        m.destroy();
        assert.Integer(escStack.getSize(), baseline, "[MouseMenu] direct destroy removes Esc");
        m = mouseMenu.create(DzGetGameUI(), false, 0.13).AddMenuItem("保留后清空");
        m.showAt(0.01, 0.01).clear();
        assert.Integer(m.getItemCount(), 0, "[MouseMenu] clear count");
        assert.Integer(escStack.getSize(), baseline, "[MouseMenu] clear removes Esc");
        m.AddMenuItem("重新加入");
        assert.Integer(m.getItemCount(), 1, "[MouseMenu] clear then reuse");
        m.setAutoDestroy(true).showAt(0.4, 0.3).show(false);
        assert.Boolean(!m.isExist(), "[MouseMenu] auto destroy");
        assert.Integer(escStack.getSize(), baseline, "[MouseMenu] auto destroy Esc");
        Log("自动状态断言完成；视觉和点击项目请继续 s2..s8。");
    }
    private function ShowSample() {
        integer i = 0;
        CloseSamples();
        sample = mouseMenu.create(DzGetGameUI(), upward, 0.14).setAutoDestroy(true);
        sample.listenDestroy(function(integer index) { sample = 0; });
        for (1 <= i <= amount) { sample.AddMenuItem("普通菜单 " + I2S(i)); }
        sample.onClick(function(integer index) { Log("点击菜单项 " + I2S(index)); });
        // Deliberately omit onEnter/onLeave: built-in highlight must still work.
        sample.showAt(hardware.getMouseX(), hardware.getMouseY());
        Log("普通菜单：" + I2S(amount) + " 项，向上=" + B2S(upward) + "；悬停高亮、外部点击和 Esc 应正常。");
    }
    private function ShowTransition() {
        CloseSamples();
        initialEsc = escStack.getSize();
        sample = mouseMenu.create(DzGetGameUI(), true, 0.15).setAutoDestroy(true);
        sample.listenDestroy(function(integer index) { sample = 0; });
        sample.AddMenuItem("打开分解确认");
        sample.onClick(function(integer index) {
            successor = mouseMenu.create(DzGetGameUI(), true, 0.15).setAutoDestroy(true);
            successor.listenDestroy(function(integer unused) { successor = 0; });
            successor.AddMenuItem("取消").AddMenuItem("确认分解");
            successor.onClick(function(integer choice) { Log("确认菜单结果 " + I2S(choice)); });
            successor.showAt(0.45, 0.32);
            verifySuccessor = true;
        });
        sample.showAt(0.4, 0.3);
        Log("点击‘打开分解确认’，新菜单应持续显示；随后输入 s6 检查。");
    }
    private function onInit() {
        timer checkTimer = CreateTimer();
        TimerStart(checkTimer, 0.1, true, function() {
            if (verifySuccessor) {
                verifySuccessor = false;
                assert.Boolean(successor.isShown(), "[MouseMenu] callback successor survives old click");
                assert.Integer(escStack.getSize(), initialEsc + 1, "[MouseMenu] callback successor owns one Esc");
            }
        });
        checkTimer = null;
        UnitTestRegisterChatEvent(function() {
            string str = GetEventPlayerChatString();
            if (GetTriggerPlayer() != GetLocalPlayer()) { return; }
            if (str == "s1") { Assertions(); }
            else if (str == "s2") { upward = true; amount = 3; ShowSample(); }
            else if (str == "s3") { upward = false; amount = 3; ShowSample(); }
            else if (str == "s4") { amount = 1; ShowSample(); }
            else if (str == "s5") { ShowTransition(); }
            else if (str == "s6") { assert.Boolean(successor.isShown(), "[MouseMenu] successor still shown"); }
            else if (str == "s7") { amount = 20; ShowSample(); }
            else if (str == "s8") { CloseSamples(); Log("直接销毁完成：检查无残留高亮/点击区/Esc"); }
            else if (str == "s9") { amount = 25; ShowSample(); }
        });
        hardware.regRightUpEvent(function() { ShowSample(); });
        UnitTestAutoTimer(0.5, 0.0, function() {
            Log("s1 状态回归；s2 向上3项；s3 向下3项；s4 单项；s5 回调开新菜单；s6 检查新菜单；s7 满20项；s8 直接销毁；s9 超限25项。");
            Log("右键在鼠标处打开；请测试屏幕四角、重复开关、高亮、外部点击、Esc。测试结果以游戏内断言与观察为准。");
        }, null);
    }
}
//! endzinc
#endif
