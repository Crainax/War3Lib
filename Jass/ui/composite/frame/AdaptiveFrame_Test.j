#ifndef UTAdaptiveFrameIncluded
#define UTAdaptiveFrameIncluded
#include "Crainax/ui/composite/frame/AdaptiveFrameConfig.h"
#undef OriginMapUnitTestMode
#define EmptyMapUnitTestMode
//! zinc
//# dependency:resource/ui/frame/task-stripes.blp
library UTAdaptiveFrame requires AdaptiveFrame {
    private adaptiveFrame panel;
    private frameSkin taskRow;
    private frameProgress progress;
    private frameCheckbox longTitle;
    private frameCheckbox locked;
    private frameButton buttons[4];
    private uiImage rewardIcon;
    private uiImage taskStripes;
    private uiText taskName;
    private uiText dimensions;

    private function resizePanel(real w, real h) {
        integer i;
        real buttonWidth;
        panel.setSize(RMaxBJ(0.34,RMinBJ(w,0.54)),RMaxBJ(0.19,RMinBJ(h,0.32)));
        w = panel.skin.width;
        h = panel.skin.height;
        dimensions.setText("宽 " + R2SW(w,1,3) + "   高 " + R2SW(h,1,3));
        taskRow.setSize(w - 0.032,h - 0.146);
        progress.setSize(w - 0.109,0.014);
        buttonWidth = (w - 0.050) / 4;
        for (0 <= i <= 3) {
            buttons[i].setWidth(buttonWidth);
            buttons[i].getRoot().exRePoint(ANCHOR_BOTTOMLEFT,panel.getRoot().ui,ANCHOR_BOTTOMLEFT,
                0.016 + i * (buttonWidth + 0.006),0.013);
        }
        buttons[0].setEnabled(w < 0.5399);
        buttons[1].setEnabled(w > 0.3401);
        buttons[2].setEnabled(h < 0.3199);
        buttons[3].setEnabled(h > 0.1901);
    }
    private function adjust(integer control) {
        real w = panel.skin.width;
        real h = panel.skin.height;
        if (control == buttons[0]) { w += 0.020; }
        else if (control == buttons[1]) { w -= 0.020; }
        else if (control == buttons[2]) { h += 0.015; }
        else if (control == buttons[3]) { h -= 0.015; }
        resizePanel(w,h);
    }
    private function addControl(integer index, string caption) {
        buttons[index] = frameButton.create(panel.getRoot().ui,caption,0.08);
        buttons[index].clicked = uiEvent.adjust;
    }
    private function changeTitle(integer id) {
        if (longTitle.checked) {
            panel.setTitle("每日任务与活跃度奖励",8);
        } else {
            panel.setTitle("每日任务",8);
        }
    }
    private real normalWidth;
    private real normalHeight;

    private real shortWidth;
    private function checkTitleHeight(string state) {
        real actual = DzFrameGetRealHeight(panel.title.ui);
        real reserved = DzFrameGetHeight(panel.testTitleViewport());
        Trace("[AdaptiveFrame] title height " + state + " actual=" + R2SW(actual,1,5) + " reserved=" + R2SW(reserved,1,5));
        assert.Boolean(actual > 0 && actual <= reserved,"[AdaptiveFrame] " + state + " title fits reserved height");
    }
    private function checkDecorations() {
        integer l = panel.testLeftDecoration();
        integer r = panel.testRightDecoration();
        rePointer lp = LoadInteger(HASH_UI,l,HASH_KEY_UI_EXTEND_REPOINTER);
        rePointer rp = LoadInteger(HASH_UI,r,HASH_KEY_UI_EXTEND_REPOINTER);
        assert.Integer(lp.relative,panel.title.ui,"[AdaptiveFrame] left follows text");
        assert.Integer(rp.relative,panel.title.ui,"[AdaptiveFrame] right follows text");
        assert.Integer(DzFrameGetPointRelativePoint(l,ANCHOR_RIGHT),ANCHOR_LEFT,"[AdaptiveFrame] left targets leading edge");
        assert.Integer(DzFrameGetPointRelativePoint(r,ANCHOR_LEFT),ANCHOR_RIGHT,"[AdaptiveFrame] right targets trailing edge");
    }
    private function checkRestored() {
        checkTitleHeight("restored short");
        assert.Real(DzFrameGetRealWidth(panel.title.ui),shortWidth,"[AdaptiveFrame] short title width restored");
        checkDecorations();
        Trace("[AdaptiveFrame] 自动断言结束，可点击四个按钮和长标题复选框。");
    }
    private function restoreShort() {
        longTitle.setState(false,true);
        changeTitle(longTitle);
        UnitTestAutoTimer(0.4,0.0,function checkRestored,null);
    }
    private function checkLong() {
        checkTitleHeight("long");
        assert.Boolean(DzFrameGetRealWidth(panel.title.ui) > shortWidth,"[AdaptiveFrame] long title grows");
        checkDecorations();
        Trace("[AdaptiveFrame] long title ready");
        UnitTestAutoTimer(4.0,0.0,function restoreShort,null);
    }
    private function checkTitle() {
        checkTitleHeight("short");
        shortWidth = DzFrameGetRealWidth(panel.title.ui);
        Trace("[AdaptiveFrame] native normal width=" + R2SW(normalWidth,1,5) + " large=" + R2SW(shortWidth,1,5));
        assert.Boolean(shortWidth > normalWidth && DzFrameGetRealHeight(panel.title.ui) > normalHeight,"[AdaptiveFrame] native large title grows");
        checkDecorations();
        longTitle.setState(true,true);
        changeTitle(longTitle);
        UnitTestAutoTimer(0.4,0.0,function checkLong,null);
    }
    private function measureNormal() {
        normalWidth = DzFrameGetRealWidth(panel.getTitleFrame());
        normalHeight = DzFrameGetRealHeight(panel.getTitleFrame());
        checkTitleHeight("normal");
        panel.setLargeTitle(true);
        UnitTestAutoTimer(0.4,0.0,function checkTitle,null);
    }
    private function buildDemo() {
        integer parent;
        panel = adaptiveFrame.create(DzGetGameUI(),"每日任务",0.40,0.22);
        parent = panel.getRoot().ui;
        panel.getRoot().setAbsPoint(ANCHOR_CENTER,0.4,0.34);
        taskRow = frameSkin.inset(parent,0.36,0.08);
        taskRow.root.setPoint(ANCHOR_TOP,parent,ANCHOR_TOP,0,-0.048);
        rewardIcon = uiImage.create(taskRow.root.ui).setTexture("ReplaceableTextures\\CommandButtons\\BTNHealthStone.blp")
            .exReSize(0.036,0.036).exRePoint(ANCHOR_LEFT,taskRow.root.ui,ANCHOR_LEFT,0.009,0);
        taskStripes = uiImage.create(taskRow.root.ui).setTexture("ui\\frame\\task-stripes.blp").exReSize(0.014,0.007)
            .exRePoint(ANCHOR_LEFT,rewardIcon.ui,ANCHOR_RIGHT,0.012,0.009);
        taskName = uiText.create(taskRow.root.ui).setFontSize(6).setText("每日在线1小时")
            .exRePoint(ANCHOR_LEFT,taskStripes.ui,ANCHOR_RIGHT,0.004,0);
        AdaptiveFrameFont(taskName,0.012);
        progress = frameProgress.create(taskRow.root.ui,0.2,0.014);
        progress.root.exRePoint(ANCHOR_LEFT,rewardIcon.ui,ANCHOR_RIGHT,0.012,-0.010);
        longTitle = frameCheckbox.create(parent,"使用长标题",0.11);
        longTitle.root.exRePoint(ANCHOR_TOPLEFT,taskRow.root.ui,ANCHOR_BOTTOMLEFT,0,-0.005);
        longTitle.changed = uiEvent.changeTitle;
        changeTitle(longTitle);
        locked = frameCheckbox.create(parent,"自动领取",0.090);
        locked.root.exRePoint(ANCHOR_LEFT,longTitle.root.ui,ANCHOR_RIGHT,0.006,0);
        locked.setState(true,false);
        dimensions = uiText.create(parent).setFontSize(4)
            .exRePoint(ANCHOR_BOTTOM,parent,ANCHOR_BOTTOM,0,0.047);
        AdaptiveFrameFont(dimensions,0.009);
        addControl(0,"提高宽度");
        addControl(1,"减少宽度");
        addControl(2,"提高高度");
        addControl(3,"减少高度");
        resizePanel(0.40,0.22);
    }
    private function destroyDemo() {
        integer i;
        for (0 <= i <= 3) { buttons[i].destroy(); buttons[i] = 0; }
        dimensions.destroy();
        locked.destroy();
        longTitle.destroy();
        progress.destroy();
        taskName.destroy();
        taskStripes.destroy();
        rewardIcon.destroy();
        taskRow.destroy();
        panel.destroy();
        panel = 0;
    }
    private function createDemo() {
        integer i;
        buildDemo();
        assert.Integer(buttons[0].skin.testButtonTiles(),3,"[AdaptiveFrame] horizontal button uses three slices");
        resizePanel(0.54,0.32);
        for (0 <= i <= 3) {
            assert.Real(buttons[i].skin.height,0.029,"[AdaptiveFrame] fixed button height");
            assert.Real(buttons[i].skin.width,0.1225,"[AdaptiveFrame] expanded button width");
            assert.Integer(buttons[i].skin.testButtonTiles(),3,"[AdaptiveFrame] resized button uses three slices");
        }
        resizePanel(0.40,0.22);
        adjust(buttons[0]);
        assert.Real(panel.skin.width,0.42,"[AdaptiveFrame] wider");
        assert.Real(panel.skin.height,0.22,"[AdaptiveFrame] width preserves height");
        adjust(buttons[1]);
        assert.Real(panel.skin.width,0.40,"[AdaptiveFrame] narrower");
        adjust(buttons[2]);
        assert.Real(panel.skin.height,0.235,"[AdaptiveFrame] taller");
        adjust(buttons[3]);
        assert.Real(panel.skin.height,0.22,"[AdaptiveFrame] shorter");
        resizePanel(1,0);
        assert.Boolean(!buttons[0].enabled && !buttons[3].enabled,"[AdaptiveFrame] bounds");
        progress.setValue(1,0);
        assert.Integer(progress.value,0,"[AdaptiveFrame] empty progress");
        progress.setValue(1300,1200);
        assert.Integer(progress.value,1200,"[AdaptiveFrame] capped progress");
        progress.setValue(720,1200);
        resizePanel(0.40,0.22);
        panel.setLargeTitle(false);
        UnitTestAutoTimer(0.4,0.0,function measureNormal,null);
    }
    private integer baselineSizes;
    private integer baselinePoints;
    private integer activeSizes;
    private integer activePoints;
    private integer cycle = 0;
    private integer tick = 0;

    // 分帧走用户实际的布局路径，避免一次触发执行数十次全量重排。
    private function lifecycleTick() {
        timer driver = GetExpiredTimer();
        if (tick == 0) {
            buildDemo();
            activeSizes = resizer.size;
            activePoints = rePointer.size;
            longTitle.setState(true,true);
            changeTitle(longTitle);
            Trace("[AdaptiveFrame] lifecycle build " + I2S(cycle + 1));
        } else if (tick <= 24) {
            if (ModuloInteger(tick,2) == 1) { resizePanel(0.54,0.32); }
            else { resizePanel(0.34,0.19); }
        } else {
            assert.Real(DzFrameGetWidth(panel.testTitleViewport()),(0.34 - 0.068) * GetResizeRate(),"[AdaptiveFrame] header reserves close hit area");
            assert.Integer(resizer.size,activeSizes,"[AdaptiveFrame] resize registrations stable");
            assert.Integer(rePointer.size,activePoints,"[AdaptiveFrame] anchor registrations stable");
            buttons[0].testPointerEvent(FRAME_MOUSE_ENTER);
            buttons[0].testPointerEvent(FRAME_MOUSE_DOWN);
            assert.String(buttons[0].testAppearance(),"pressed","[AdaptiveFrame] pressed inside");
            buttons[0].testPointerEvent(FRAME_MOUSE_LEAVE);
            buttons[0].testPointerEvent(FRAME_MOUSE_UP);
            assert.String(buttons[0].testAppearance(),"idle","[AdaptiveFrame] release after leave stays idle");
            buttons[0].testPointerEvent(FRAME_MOUSE_ENTER);
            assert.String(buttons[0].testAppearance(),"hover","[AdaptiveFrame] destroy while hovered");
            destroyDemo();
            assert.Integer(resizer.size,baselineSizes,"[AdaptiveFrame] destroyed sizes return to baseline");
            assert.Integer(rePointer.size,baselinePoints,"[AdaptiveFrame] destroyed anchors return to baseline");
            cycle += 1;
            tick = -1;
            if (cycle == 3) {
                PauseTimer(driver);
                DestroyTimer(driver);
                UnitTestAutoTimer(0.1,0.0,function createDemo,null);
            }
        }
        tick += 1;
        driver = null;
    }
    private function lifecycleTest() {
        timer driver = CreateTimer();
        baselineSizes = resizer.size;
        baselinePoints = rePointer.size;
        TimerStart(driver,0.05,true,function lifecycleTick);
        driver = null;
    }
    private function onInit() {
        UnitTestRegisterChatEvent(function() {
            string command = GetEventPlayerChatString();
            if (GetTriggerPlayer() != GetLocalPlayer() || panel == 0) { return; }
            if (command == "s1") { panel.show(true); }
            else if (command == "s2") { panel.setLargeTitle(false); }
            else if (command == "s3") { panel.setLargeTitle(true); }
        });
        UnitTestAutoTimer(0.5,0.0,function lifecycleTest,null);
    }
}
//! endzinc
#endif
