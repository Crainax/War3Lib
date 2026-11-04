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
    private mouseMenu reentrantTarget = 0;
    private mouseMenu reentrantThird = 0;
    private integer thirdDestroyed = 0;
    private integer leaveNotifications = 0;

    // Destruction callbacks may show the pending target or a newer third menu.
    // Verify ownership and Esc cleanup without relying on physical mouse input.
    private function ReentryAssertions() {
        mouseMenu old = 0;
        integer baseline = escStack.getSize();
        reentrantTarget = mouseMenu.create(DzGetGameUI(), true, 0.13).AddMenuItem("目标");
        old = mouseMenu.create(DzGetGameUI(), true, 0.13).AddMenuItem("旧菜单").setAutoDestroy(true);
        old.listenDestroy(function(integer unused) { reentrantTarget.show(true); });
        old.show(true);
        reentrantTarget.show(true);
        assert.Boolean(reentrantTarget.isShown(), "[MouseMenu] reentrant target stays shown");
        assert.Integer(escStack.getSize(), baseline + 1, "[MouseMenu] reentrant target owns one Esc");
        reentrantTarget.show(false);
        assert.Integer(escStack.getSize(), baseline, "[MouseMenu] reentrant target leaves no Esc");
        reentrantTarget.destroy();

        thirdDestroyed = 0;
        reentrantTarget = mouseMenu.create(DzGetGameUI(), true, 0.13).AddMenuItem("外层目标");
        reentrantThird = mouseMenu.create(DzGetGameUI(), true, 0.13).AddMenuItem("回调菜单").setAutoDestroy(true);
        reentrantThird.listenDestroy(function(integer unused) { thirdDestroyed += 1; reentrantThird = 0; });
        old = mouseMenu.create(DzGetGameUI(), true, 0.13).AddMenuItem("旧菜单").setAutoDestroy(true);
        old.listenDestroy(function(integer unused) { reentrantThird.show(true); });
        old.show(true);
        reentrantTarget.show(true);
        assert.Boolean(reentrantThird.isShown(), "[MouseMenu] newer callback menu wins");
        assert.Boolean(!reentrantTarget.isShown(), "[MouseMenu] outer target does not steal ownership");
        assert.Integer(escStack.getSize(), baseline + 1, "[MouseMenu] third menu owns one Esc");
        escStack.pop();
        assert.Integer(thirdDestroyed, 1, "[MouseMenu] third menu destroys and notifies once");
        assert.Integer(reentrantThird, 0, "[MouseMenu] third menu owner notified");
        assert.Integer(escStack.getSize(), baseline, "[MouseMenu] third menu leaves no Esc");
        // A target superseded by a callback remains reusable by its caller.
        reentrantTarget.show(true);
        assert.Boolean(reentrantTarget.isShown(), "[MouseMenu] superseded target can be reused");
        reentrantTarget.destroy();
        reentrantTarget = 0;
        assert.Integer(escStack.getSize(), baseline, "[MouseMenu] reentry cleanup complete");
    }

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
        ReentryAssertions();
        Log("自动状态断言完成；视觉和点击项目请继续 s2..s8。");
    }
    // Exercise every supported count in both directions, including clear/rebuild.
    private function CountAssertions() {
        mouseMenu m;
        integer direction;
        integer count;
        integer i;
        integer baseline;
        integer activeFrames;
        integer resizeCount;
        integer pointCount;
        integer firstFrame;
        integer lastFrame;
        integer rootFrame;
        string label;
        CloseSamples();
        baseline = escStack.getSize();
        activeFrames = uiId.getActiveCount();
        resizeCount = resizer.size;
        pointCount = rePointer.size;
        for (0 <= direction <= 1) {
            m = mouseMenu.create(DzGetGameUI(), direction == 1, 0.14);
            for (1 <= count <= 20) {
                m.clear();
                assert.Integer(uiId.getActiveCount(), activeFrames + 11, "[MouseMenu] clear retains only root/skin/hover");
                assert.Integer(resizer.size, resizeCount + 10, "[MouseMenu] clear releases row resizers");
                assert.Integer(rePointer.size, pointCount + 9, "[MouseMenu] clear retains nine skin pointers");
                for (1 <= i <= count) { m.AddMenuItem("拼接 " + I2S(i)); }
                assert.Integer(m.getItemCount(), count, "[MouseMenu] rebuilt count");
                assert.Real(m.getHeight(), count * MOUSE_MENU_HEIGHT + 2 * MOUSE_MENU_PADDING, "[MouseMenu] joined height");
                m.showAt(0.79, 0.01);
                label = "[MouseMenu] count=" + I2S(count) + " direction=" + I2S(direction);
                assert.Boolean(m.isShown(), label + " shown");
                assert.Real(DzFrameGetHeight(m.menuFrame.ui), count * 0.026 + 0.008, label + " native panel height");
                for (1 <= i <= count) {
                    assert.Real(DzFrameGetHeight(m.testItem(i).background.ui), 0.026, label + " row " + I2S(i) + " height");
                    assert.Boolean(DzFrameIsVisible(m.testItem(i).separator.ui) == ((direction == 1 && i < count) || (direction == 0 && i > 1)), label + " row " + I2S(i) + " separator");
                }
                firstFrame = m.testItem(1).btn.ui;
                lastFrame = m.testItem(count).btn.ui;
                mouseMenu.enter(firstFrame);
                assert.Boolean(DzFrameIsVisible(m.testHighlight()), label + " first hover visible");
                mouseMenu.enter(lastFrame);
                if (count > 1) { mouseMenu.leave(firstFrame); }
                assert.Integer(m.testHoveredIndex(), count, label + " stale leave preserves latest hover");
                assert.Boolean(DzFrameIsVisible(m.testHighlight()), label + " last hover visible");
                mouseMenu.leave(lastFrame);
                assert.Boolean(!DzFrameIsVisible(m.testHighlight()), label + " leave hides hover");
                mouseMenu.enter(lastFrame);
                uiEventState.uiId = lastFrame;
                uiEventState.rcStart = true;
                m.show(false);
                assert.Integer(uiEventState.uiId, 0, label + " hide clears input owner");
                assert.Boolean(!uiEventState.rcStart, label + " hide clears right click state");
                m.show(true);
                assert.Boolean(!DzFrameIsVisible(m.testHighlight()), label + " reopen has no stale hover");
                assert.Integer(escStack.getSize(), baseline + 1, "[MouseMenu] matrix one Esc");
            }
            // clear while hovered, then exercise the same menu's rebuilt anchors.
            mouseMenu.enter(lastFrame);
            m.clear();
            assert.Integer(uiHashTable(lastFrame).eventdata.get2(), 0, "[MouseMenu] clear removes button binding");
            assert.Integer(uiHashTable(lastFrame).ui.get(), 0, "[MouseMenu] clear removes frame registry");
            m.AddMenuItem("重建").showAt(0.4, 0.3);
            lastFrame = m.testItem(1).btn.ui;
            mouseMenu.enter(lastFrame);
            rootFrame = m.menuFrame.ui;
            m.destroy();
            assert.Integer(uiHashTable(rootFrame).ui.get(), 0, "[MouseMenu] destroy removes root registry");
            assert.Integer(uiHashTable(lastFrame).ui.get(), 0, "[MouseMenu] destroy removes hovered row registry");
            assert.Integer(uiId.getActiveCount(), activeFrames, "[MouseMenu] no frame leak");
            assert.Integer(resizer.size, resizeCount, "[MouseMenu] no resizer leak");
            assert.Integer(rePointer.size, pointCount, "[MouseMenu] no pointer leak");
            assert.Integer(escStack.getSize(), baseline, "[MouseMenu] matrix cleanup");
        }
        Log("1..20项、上下方向、清空重建的状态断言完成。");
    }
    private function HoverCleanupAssertions() {
        mouseMenu m;
        integer baseline;
        integer frame;
        CloseSamples();
        baseline = uiId.getActiveCount();
        leaveNotifications = 0;
        m = mouseMenu.create(DzGetGameUI(), false, 0.14).AddMenuItem("悬停清理");
        m.onLeave(function(integer index) { leaveNotifications += 1; });
        m.showAt(0.4, 0.3);
        frame = m.testItem(1).btn.ui;
        mouseMenu.enter(frame);
        m.show(false);
        mouseMenu.leave(frame);
        assert.Integer(leaveNotifications, 1, "[MouseMenu] hide balances leave exactly once");
        m.show(true);
        mouseMenu.enter(frame);
        m.clear();
        assert.Integer(leaveNotifications, 2, "[MouseMenu] clear balances leave exactly once");
        m.AddMenuItem("清空后重建").showAt(0.4, 0.3);
        mouseMenu.enter(m.testItem(1).btn.ui);
        m.setAutoDestroy(true).show(false);
        assert.Integer(leaveNotifications, 3, "[MouseMenu] auto destroy balances leave exactly once");
        assert.Integer(uiId.getActiveCount(), baseline, "[MouseMenu] hover cleanup no frame leak");
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
            if (str == "s1") { Assertions(); CountAssertions(); HoverCleanupAssertions(); }
            else if (str == "s2") { upward = true; amount = 3; ShowSample(); }
            else if (str == "s3") { upward = false; amount = 3; ShowSample(); }
            else if (str == "s4") { amount = 1; ShowSample(); }
            else if (str == "s5") { ShowTransition(); }
            else if (str == "s6") { assert.Boolean(successor.isShown(), "[MouseMenu] successor still shown"); }
            else if (str == "s7") { amount = 20; ShowSample(); }
            else if (str == "s8") { CloseSamples(); Log("直接销毁完成：检查无残留高亮/点击区/Esc"); }
            else if (str == "s9") { amount = 25; ShowSample(); }
            else if (str == "s10") { amount = 2; ShowSample(); }
            else if (str == "s11") { amount = 5; ShowSample(); }
            else if (str == "s12") { amount = 10; ShowSample(); }
            else if (SubString(str, 0, 2) == "n ") {
                amount = S2I(SubString(str, 2, StringLength(str)));
                if (amount < 0) { amount = 0; }
                if (amount > 25) { amount = 25; }
                ShowSample();
            }
            else if (str == "dir") { upward = !upward; ShowSample(); }
        });
        hardware.regRightUpEvent(function() { ShowSample(); });
        UnitTestAutoTimer(0.5, 0.0, function() {
            Log("s1 状态回归；s2 向上3项；s3 向下3项；s4 单项；s5 回调开新菜单；s6 检查新菜单；s7 满20项；s8 直接销毁；s9 超限25项。");
            Log("s10 两项；s11 五项；s12 十项；n 数量（0..25）；dir 切换上下方向。检查外框接缝、首尾、分隔线与悬停文字遮挡。");
            Log("右键在鼠标处打开；请测试屏幕四角、重复开关、高亮、外部点击、Esc。测试结果以游戏内断言与观察为准。");
        }, null);
    }
}
//! endzinc
#endif
