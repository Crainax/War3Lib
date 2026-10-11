#ifndef UITextAreaIncluded
#define UITextAreaIncluded
#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j"

#define UI_TEXTAREA_MAX_LINES 1024 // FDF 同步设置的最大保留行数；超出时原生控件丢弃最早行
#define UI_TEXTAREA_BAR_WIDTH 0.0001 // 透明滚动条保留极小正宽度，减少正文右侧占位；跟随 exResize 横向适配
#define UI_TEXTAREA_TEXT_LIMIT 2048 // 每段字符串的保守字节上限；长正文必须逐段追加，禁止先拼完整大字符串

// 模板由 ui/Crainax.toc -> ui/BaseUI.fdf 统一加载，源模板为同目录 UITextArea.fdf。

//! zinc
// 原生只读 TEXTAREA；滚轮及拖动由原生滚动条处理，不产生同步事件。
library UITextArea requires STRUCT_SHARED_REQUIRE_UI, UIEventModule, UIExtendResize, UIHashTable {
    private struct textAreaPart {
        string value;
        thistype next;
    }
    public struct uiTextArea {
        STRUCT_SHARED_INNER_UI(uiTextArea)
        module uiEventModule;
        private string content;
        private textAreaPart firstPart;
        private textAreaPart lastPart;
        private integer partCount;
        private integer textLength;
        private integer fontSize;
        private integer scrollBar;
        private integer upButton;
        private integer downButton;
        private integer thumb;
        private resizer barResize;
        private resizer thumbResize;
        private resizer upResize;
        private resizer downResize;

        // 当前KK客户端不支持对原生SCROLLBAR使用Get/SetValue。
        // 阅读滚动完全交给原生鼠标滚轮，不模拟箭头点击、不定时改位置。
        // 超过单字符串安全上限时返回null；用getTextPart逐段读取，避免取全文再次拼接崩溃。
        method getText() -> string {return content;}
        method getTextLength() -> integer {return textLength;}
        method getPartCount() -> integer {return partCount;}
        method getTextPart(integer index) -> string {
            textAreaPart part = firstPart;
            if (index < 1) {return null;}
            while (part != 0 && index > 1) {part = part.next; index -= 1;}
            if (part == 0) {return null;}
            return part.value;
        }
        private method clearParts() {
            textAreaPart part = firstPart;
            textAreaPart nextPart = 0;
            while (part != 0) {
                nextPart = part.next; part.value = null; part.destroy(); part = nextPart;
            }
            firstPart = 0; lastPart = 0; partCount = 0; textLength = 0; content = "";
        }
        private method savePart(string value) -> boolean {
            textAreaPart part = textAreaPart.create();
            integer separator = 0;
            if (part == 0) {return false;}
            part.value = value; part.next = 0;
            if (lastPart == 0) {firstPart = part;} else {lastPart.next = part; separator = 2;}
            lastPart = part; partCount += 1;
            textLength += separator + StringLength(value);
            if (textLength <= UI_TEXTAREA_TEXT_LIMIT) {
                if (separator == 0) {content = value;} else {content = content + "|n" + value;}
            } else {content = null;}
            return true;
        }
        method getFontSize() -> integer {return fontSize;}
        method getScrollBar() -> integer {return scrollBar;}
        method setText(string value) -> thistype {
            if (!this.isExist()) {return this;}
            if (value == null) {value = "";}
            if (StringLength(value) > UI_TEXTAREA_TEXT_LIMIT) {
                BJDebugMsg("[UITextArea] setText单段过长，请在生成正文时按段appendText。"); return this;
            }
            if (value == content) {return this;}
            clearParts();
            if (value != "" && !savePart(value)) {DzFrameSetText(ui, ""); return this;}
            DzFrameSetText(ui, value);
            return this;
        }
        method appendText(string value) -> thistype {
            if (!this.isExist() || value == null || value == "") {return this;}
            if (StringLength(value) > UI_TEXTAREA_TEXT_LIMIT) {
                BJDebugMsg("[UITextArea] appendText单段过长，请拆为多个完整段落。"); return this;
            }
            if (!savePart(value)) {return this;}
            DzFrameAddText(ui, value);
            return this;
        }
        method clear() -> thistype {return setText("");}
        method setEnabled(boolean enabled) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetEnable(ui, enabled);
            if (scrollBar != 0) {DzFrameSetEnable(scrollBar, enabled);}
            if (upButton != 0) {DzFrameSetEnable(upButton, enabled);}
            if (downButton != 0) {DzFrameSetEnable(downButton, enabled);}
            if (thumb != 0) {DzFrameSetEnable(thumb, enabled);}
            return this;
        }
        // 包括原生滚动条子控件；卡牌悬停不因进入正文或拖动滑块而中断。
        method containsFrame(integer frame) -> boolean {
            integer depth = 0;
            if (!this.isExist() || frame == 0) {return false;}
            while (frame != 0 && depth < 16) {
                if (frame == ui) {return true;}
                frame = DzFrameGetParent(frame);
                depth += 1;
            }
            return false;
        }
        // 单一模板，固定3号字；每次创建使用独立context。
        // FDF 默认尺寸 0.16×0.16，避免原生 TEXTAREA 在零高度下创建滚动条。
        static method create(integer parent) -> thistype {
            thistype this;
            if (parent == 0) {return 0;}
            this = allocate();
            if (this == 0) {return 0;}
            id = uiId.get(); content = ""; fontSize = 3;
            firstPart = 0; lastPart = 0; partCount = 0; textLength = 0;
            scrollBar = 0; upButton = 0; downButton = 0; thumb = 0;
            barResize = 0; thumbResize = 0; upResize = 0; downResize = 0;
            ui = DzCreateFrame("War3LibTextArea", parent, id);
            if (ui == 0) {
                DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 30, "[UITextArea] 主框架创建失败：War3LibTextArea；检查测试包 ui/BaseUI.fdf 模板。");
                this.destroy(); return 0;
            }
            STRUCT_SHARED_UI_ONCREATE(uiTextArea)
            scrollBar = DzFrameFindByName("War3LibTextAreaBar", id);
            upButton = DzFrameFindByName("War3LibTextAreaUp", id);
            downButton = DzFrameFindByName("War3LibTextAreaDown", id);
            thumb = DzFrameFindByName("War3LibTextAreaThumb", id);
            if (scrollBar == 0 || upButton == 0 || downButton == 0 || thumb == 0) {
                DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 30, "[UITextArea] 子控件查找失败：context=" + I2S(id)
                    + " bar=" + I2S(scrollBar) + " up=" + I2S(upButton) + " down=" + I2S(downButton) + " thumb=" + I2S(thumb));
                this.destroy(); return 0;
            }
            DzFrameClearAllPoints(scrollBar);
            DzFrameSetPoint(scrollBar, ANCHOR_TOPRIGHT, ui, ANCHOR_TOPRIGHT, 0, -0.001);
            DzFrameSetPoint(scrollBar, ANCHOR_BOTTOMRIGHT, ui, ANCHOR_BOTTOMRIGHT, 0, 0.001);
            // 原生子控件归 TEXTAREA 所有，仅登记宽度自适应，销毁时先注销。
            barResize = resizer.create(scrollBar, UI_TEXTAREA_BAR_WIDTH, 0.0);
            thumbResize = resizer.create(thumb, UI_TEXTAREA_BAR_WIDTH, 0.012);
            upResize = resizer.create(upButton, UI_TEXTAREA_BAR_WIDTH, 0.008);
            downResize = resizer.create(downButton, UI_TEXTAREA_BAR_WIDTH, 0.008);
            DzFrameSetSize(scrollBar, UI_TEXTAREA_BAR_WIDTH * GetResizeRate(), 0.0);
            DzFrameSetSize(thumb, UI_TEXTAREA_BAR_WIDTH * GetResizeRate(), 0.012);
            DzFrameSetSize(upButton, UI_TEXTAREA_BAR_WIDTH * GetResizeRate(), 0.008);
            DzFrameSetSize(downButton, UI_TEXTAREA_BAR_WIDTH * GetResizeRate(), 0.008);
            return this;
        }
        method onDestroy() {
            clearParts();
            if (barResize != 0) {barResize.destroy();}
            if (thumbResize != 0) {thumbResize.destroy();}
            if (upResize != 0) {upResize.destroy();}
            if (downResize != 0) {downResize.destroy();}
            if (ui != 0) {
                STRUCT_SHARED_UI_ONDESTROY(uiTextArea)
                DzDestroyFrame(ui);
            }
            uiId.recycle(id);
            ui = 0; content = null; scrollBar = 0; upButton = 0; downButton = 0; thumb = 0;
        }
    }
}
//! endzinc
#endif
