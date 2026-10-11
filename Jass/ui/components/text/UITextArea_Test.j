#ifndef UTUITextAreaIncluded
#define UTUITextAreaIncluded
#undef OriginMapUnitTestMode
//! zinc
library UTUITextArea requires UITextArea, UIImage {
    private uiTextArea left = 0;
    private uiTextArea right = 0;
    private uiImage background = 0;
    private integer baseline = 0;
    private integer resizeBaseline = 0;
    private integer pointBaseline = 0;
    // 原生分步探针不调用 uiTextArea.create/setText，避免封装把多个嫌疑点一起执行。
    // 每输入一个指令后等待画面稳定；记录闪退时输入的指令，日志可能来不及渲染。
    private integer probe = 0;
    private integer probeId = 0;
    private integer probeBar = 0;
    private integer probeStage = 0;

    function Paragraph(integer index) -> string {
        return "|cff66ccff第 " + I2S(index) + " 段|r：中文、English 123。测试自动换行与滚轮阅读；每段独立追加，不拼接完整长文。";
    }
    function FillLongText(uiTextArea area, integer count) {
        integer i;
        area.setText("|cffffd84a【开头】滚轮阅读测试|r");
        for (1 <= i <= count) {area.appendText(Paragraph(i));}
        area.appendText("|cff66ff66【正文结束】已读到最后一行。|r");
        assert.Integer(area.getPartCount(), count + 2, "长文按段保存");
        assert.String(area.getTextPart(count + 1), Paragraph(count), "最后一个正文段落完整");
    }
    function Cleanup() {
        if (left.isExist()) {left.destroy(); left = 0;}
        if (right.isExist()) {right.destroy(); right = 0;}
        if (background.isExist()) {background.destroy(); background = 0;}
    }
    function CreateAreas() {
        Cleanup();
        BJDebugMsg("[UITextArea] BEGIN 完整封装测试，先创建左侧3号组件。");
        baseline = uiId.getActiveCount();
        resizeBaseline = resizer.size; pointBaseline = rePointer.size;
        background = uiImage.create(DzGetGameUI()).setTexture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp")
            .exReSize(0.56, 0.34).exRePoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0, 0.05);
        left = uiTextArea.create(DzGetGameUI());
        BJDebugMsg("[UITextArea] RETURN 左侧create；BEGIN 右侧create(3)。");
        right = uiTextArea.create(DzGetGameUI());
        BJDebugMsg("[UITextArea] RETURN 右侧create。");
        assert.Boolean(left.isExist() && right.isExist(), "原生 TEXTAREA 与滚动条子控件创建成功");
        if (!left.isExist() || !right.isExist()) {
            BJDebugMsg("[UITextArea] 创建未完成；请检查上方主框架或子控件错误。修复 FDF 后重新打包并重新进图。");
            return;
        }
        left.exReSize(0.24, 0.28).exRePoint(ANCHOR_CENTER, background.ui, ANCHOR_CENTER, -0.135, 0);
        right.exReSize(0.24, 0.28).exRePoint(ANCHOR_CENTER, background.ui, ANCHOR_CENTER, 0.135, 0);
        FillLongText(left, 30);
        right.setText("|cffffd84a短正文，3号字|r|n|n不应需要滚动。|n两侧组件独立。|n|n切换窗口比例检查排版。");
        assert.Integer(left.getFontSize(), 3, "默认3号字");
        assert.Boolean(left.getScrollBar() != right.getScrollBar(), "多实例滚动条独立");
        assert.Boolean(left.getText() == null, "超长正文不合并成危险的大字符串");
        BJDebugMsg("[UITextArea] PASS 完整封装测试已返回；请等待画面稳定再判断。");
    }
    function ProbeHelp() {
        BJDebugMsg("[UITextArea] 修复回归：f1创建完整组件；t6追加120段长文；t2/t3手动滚轮检查；t5替换；t7销毁。滚动条透明，使用鼠标滚轮。");
        BJDebugMsg("[UITextArea] 分步排查：依次输入 s1~s11，每步等待2秒。闪退请报告最后输入的指令。");
        BJDebugMsg("s1原生创建；s2尺寸；s3位置；s4查子控件；s5短文；s6分段长文；s7手动向上滚动；s8手动向下滚动并检查停留。");
        BJDebugMsg("s9清除滚动条锚点；s10重设上下锚点；s11滚动条高度设0；s12完整封装。s0显示说明。");
        BJDebugMsg("本轮s1只运行一次；重新排查请重新进图。旧功能命令改为t2~t8，需先成功运行f1或s12。");
        BJDebugMsg("s6闪退专项：先完成s1~s5，然后d1=40行短ASCII；d2=1段彩色中文；d3=6000字符分段追加；d4=重置短文；d5=追加一行(可重复)。");
    }
    // 不推进s序列；对比小字节量溢出、大字符串、格式文本和逐行追加。
    function ProbeText(integer kind) {
        integer i;
        string value = "";
        if (probeStage < 5) {BJDebugMsg("[UITextArea] 请先完成s1~s5。"); return;}
        BJDebugMsg("[UITextArea] BEGIN d" + I2S(kind) + " build");
        if (kind == 1) {
            for (1 <= i <= 40) {value += "L" + I2S(i) + "|n";}
        } else if (kind == 2) {
            value = Paragraph(1);
        } else if (kind == 3) {
            // 总计6000字符，每次只传100字符，不构造6000字符的JASS字符串。
            for (1 <= i <= 10) {value += "0123456789";}
            DzFrameSetText(probe, "");
            for (1 <= i <= 60) {DzFrameAddText(probe, value);}
            BJDebugMsg("[UITextArea] PASS d3：6000字符分60段追加完成。");
            return;
        } else if (kind == 4) {
            value = "START";
        } else if (kind == 5) {
            BJDebugMsg("[UITextArea] BEGIN DzFrameAddText single line");
            DzFrameAddText(probe, "ASCII appended line");
            BJDebugMsg("[UITextArea] RETURN DzFrameAddText；等待2秒，观察是否出现滚动条。");
            return;
        }
        BJDebugMsg("[UITextArea] BUILT d" + I2S(kind) + " StringLength=" + I2S(StringLength(value)) + "；BEGIN DzFrameSetText");
        DzFrameSetText(probe, value);
        BJDebugMsg("[UITextArea] RETURN d" + I2S(kind) + " DzFrameSetText；等待2秒观察。");
    }
    function ProbeStep(integer step) {
        integer i;
        integer probeUp;
        integer probeDown;
        integer probeThumb;
        if (step != probeStage + 1) {
            BJDebugMsg("[UITextArea] 顺序不符，下一步请输入 s" + I2S(probeStage + 1) + "；s0查看说明。");
            return;
        }
        BJDebugMsg("[UITextArea] BEGIN s" + I2S(step));
        if (step == 1) {
            probeId = uiId.get();
            probe = DzCreateFrame("War3LibTextArea", DzGetGameUI(), probeId);
            BJDebugMsg("[UITextArea] RETURN DzCreateFrame=" + I2S(probe));
            if (probe == 0) {
                uiId.recycle(probeId); probeId = 0;
                BJDebugMsg("[UITextArea] FAIL 创建返回0，停止；检查模板是否已打包加载。");
                return;
            }
        } else if (step == 2) {
            DzFrameSetSize(probe, 0.24 * GetResizeRate(), 0.28);
        } else if (step == 3) {
            DzFrameSetPoint(probe, ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0, 0.05);
        } else if (step == 4) {
            probeBar = DzFrameFindByName("War3LibTextAreaBar", probeId);
            probeUp = DzFrameFindByName("War3LibTextAreaUp", probeId);
            probeDown = DzFrameFindByName("War3LibTextAreaDown", probeId);
            probeThumb = DzFrameFindByName("War3LibTextAreaThumb", probeId);
            BJDebugMsg("[UITextArea] bar=" + I2S(probeBar) + " up=" + I2S(probeUp) + " down=" + I2S(probeDown) + " thumb=" + I2S(probeThumb));
            if (probeBar == 0 || probeUp == 0 || probeDown == 0 || probeThumb == 0) {
                BJDebugMsg("[UITextArea] FAIL 子控件存在0，停止，不继续调用原生接口。");
                return;
            }
        } else if (step == 5) {
            DzFrameSetText(probe, "短文字 ABC 123|n第二行。此步不自动滚动。");
        } else if (step == 6) {
            DzFrameSetText(probe, "【开头】分段写入");
            for (1 <= i <= 30) {DzFrameAddText(probe, Paragraph(i));}
            DzFrameAddText(probe, "【正文结束】");
        } else if (step == 7) {
            BJDebugMsg("[UITextArea] 请用鼠标滚轮向上阅读，观察文字能否停留；不调用滚动值接口。");
        } else if (step == 8) {
            BJDebugMsg("[UITextArea] 请用鼠标滚轮向下阅读，再向上滚动后等待，确认没有持续下滚。");
        } else if (step == 9) {
            DzFrameClearAllPoints(probeBar);
        } else if (step == 10) {
            DzFrameSetPoint(probeBar, ANCHOR_TOPRIGHT, probe, ANCHOR_TOPRIGHT, 0, -0.001);
            BJDebugMsg("[UITextArea] RETURN TOPRIGHT；BEGIN BOTTOMRIGHT。");
            DzFrameSetPoint(probeBar, ANCHOR_BOTTOMRIGHT, probe, ANCHOR_BOTTOMRIGHT, 0, 0.001);
        } else if (step == 11) {
            DzFrameSetSize(probeBar, UI_TEXTAREA_BAR_WIDTH * GetResizeRate(), 0.0);
        }
        probeStage = step;
        BJDebugMsg("[UITextArea] PASS s" + I2S(step) + " 已返回；等待2秒，稳定后输入 s" + I2S(step + 1));
        if (step == 6) {BJDebugMsg("[UITextArea] 接下来s7、s8为手动滚轮检查，不再调用不兼容接口。");}
    }
    function onInit() {
        UnitTestRegisterChatEvent(function() {
            string cmd = GetEventPlayerChatString();
            if (GetLocalPlayer() != GetTriggerPlayer()) {return;}
            if (cmd == "s0") {ProbeHelp();}
            else if (cmd == "f1") {CreateAreas();}
            else if (cmd == "d1") {ProbeText(1);}
            else if (cmd == "d2") {ProbeText(2);}
            else if (cmd == "d3") {ProbeText(3);}
            else if (cmd == "d4") {ProbeText(4);}
            else if (cmd == "d5") {ProbeText(5);}
            else if (cmd == "s1") {ProbeStep(1);}
            else if (cmd == "s2") {ProbeStep(2);}
            else if (cmd == "s3") {ProbeStep(3);}
            else if (cmd == "s4") {ProbeStep(4);}
            else if (cmd == "s5") {ProbeStep(5);}
            else if (cmd == "s6") {ProbeStep(6);}
            else if (cmd == "s7") {ProbeStep(7);}
            else if (cmd == "s8") {ProbeStep(8);}
            else if (cmd == "s9") {ProbeStep(9);}
            else if (cmd == "s10") {ProbeStep(10);}
            else if (cmd == "s11") {ProbeStep(11);}
            else if (cmd == "s12") {
                if (probeStage != 11) {BJDebugMsg("[UITextArea] 请先依次完成s1~s11。"); return;}
                CreateAreas();
            }
            else if (cmd == "t2" && left.isExist()) {BJDebugMsg("[UITextArea] 请手动向上滚动检查；程序定位接口已移除。");}
            else if (cmd == "t3" && left.isExist()) {BJDebugMsg("[UITextArea] 请手动向下滚动检查，再向上滚动确认能停留。");}
            else if (cmd == "t4" && left.isExist()) {left.appendText("|cffff66cc【追加文字】|r 新的一段。");}
            else if (cmd == "t5" && left.isExist()) {
                left.setText("短正文替换长文，应回到顶部。|n第二行。");
                assert.String(left.getText(), "短正文替换长文，应回到顶部。|n第二行。", "文本替换");
            }
            else if (cmd == "t6" && left.isExist()) {FillLongText(left, 120);}
            else if (cmd == "t7" && left.isExist()) {
                Cleanup();
                assert.Integer(uiId.getActiveCount(), baseline, "销毁后回收组件 UI ID");
                assert.Integer(resizer.size, resizeBaseline, "销毁后注销全部大小适配器");
                assert.Integer(rePointer.size, pointBaseline, "销毁后注销全部位置适配器");
            }
            else if (cmd == "t8" && left.isExist()) {left.exReSize(0.18, 0.12);}
        });
        ProbeHelp();
    }
}
//! endzinc
#endif
