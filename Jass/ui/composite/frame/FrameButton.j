#ifndef FrameButtonIncluded
#define FrameButtonIncluded
#include "Crainax/ui/constants/UIConstants.j"
//! zinc
//# dependency:resource/ui/frame/stripes.blp
//# dependency:resource/ui/frame/btn-idle0.blp
//# dependency:resource/ui/frame/btn-idle1.blp
//# dependency:resource/ui/frame/btn-idle2.blp
//# dependency:resource/ui/frame/btn-hover0.blp
//# dependency:resource/ui/frame/btn-hover1.blp
//# dependency:resource/ui/frame/btn-hover2.blp
//# dependency:resource/ui/frame/btn-pressed0.blp
//# dependency:resource/ui/frame/btn-pressed1.blp
//# dependency:resource/ui/frame/btn-pressed2.blp
//# dependency:resource/ui/frame/btn-disabled0.blp
//# dependency:resource/ui/frame/btn-disabled1.blp
//# dependency:resource/ui/frame/btn-disabled2.blp
library FrameButton requires FrameTheme, UIImage, UIButton, UIExtendResize, UIExtendEvent, UIText, UIHashTable {
    private struct frameButtonSkin {
        uiImage root;
        real width;
        real height;
        private uiImage tile[3];
        method setSize(real w, real h) -> thistype {
            width = RMaxBJ(w,0.0155);
            height = 0.029;
            root.exReSize(width,height);
            tile[0].exReSize(0.00725,height);
            tile[1].exReSize(width - 0.0145,height);
            tile[2].exReSize(0.00725,height);
            return this;
        }
        method setStyle(string style) {
            integer i;
            for (0 <= i <= 2) { tile[i].setTexture(FrameTexture("btn-" + style + I2S(i))); }
        }
        static method create(integer parent, real w) -> thistype {
            thistype this = allocate();
            integer i;
            root = uiImage.create(parent).setTexture(UI_STRING_PATH_BLANK);
            for (0 <= i <= 2) { tile[i] = uiImage.create(root.ui).setPoint(ANCHOR_LEFT+i,root.ui,ANCHOR_LEFT+i,0,0); }
            this.setStyle("idle");
            return this.setSize(w,0.029);
        }
        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
        method testButtonTiles() -> integer {
            integer i;
            integer count = 0;
            for (0 <= i <= 2) { if (tile[i] != 0) { count += 1; } }
            return count;
        }
        #endif
        method onDestroy() {
            integer i;
            for (0 <= i <= 2) { tile[i].destroy(); tile[i] = 0; }
            root.destroy();
            root = 0;
        }
    }

    public struct frameButton {
        private frameButtonSkin skin;
        private uiBtn hit;
        private uiText label;
        private uiImage stripes;
        private string appearance;
        private boolean hovered;
        private uiImage icon;
        private boolean hasIcon;
        private string caption;
        boolean enabled;
        uiEvent clicked; // 本地事件，参数是按钮实例。
        method getRoot() -> uiImage { return skin.root; }
        method getWidth() -> real { return skin.width; }
        method getHeight() -> real { return skin.height; }
        method setPoint(integer anchor, integer relative, integer relativeAnchor, real x, real y) -> thistype {
            skin.root.exRePoint(anchor,relative,relativeAnchor,x,y);
            return this;
        }
        method show(boolean visible) -> thistype { skin.root.show(visible); return this; }
        method setText(string text) -> thistype {
            caption = text;
            label.setText(text);
            return this.setWidth(skin.width);
        }
        method setWidth(real w) -> thistype {
            real iconSize;
            skin.setSize(w,skin.height);
            stripes.show(skin.width >= 0.105);
            iconSize = RMinBJ(skin.width,skin.height) - 0.010;
            icon.exReSize(iconSize,iconSize);
            if (hasIcon && caption != "") {
                icon.exRePoint(ANCHOR_LEFT,skin.root.ui,ANCHOR_LEFT,0.005,0);
                label.exRePoint(ANCHOR_CENTER,skin.root.ui,ANCHOR_CENTER,iconSize * 0.45,0);
            } else {
                icon.exRePoint(ANCHOR_CENTER,skin.root.ui,ANCHOR_CENTER,0,0);
                label.exRePoint(ANCHOR_CENTER,skin.root.ui,ANCHOR_CENTER,0,0);
            }
            return this;
        }
        method setIcon(string path) -> thistype {
            hasIcon = path != "" && path != null;
            if (hasIcon) { icon.setTexture(path); }
            icon.show(hasIcon);
            return this.setWidth(skin.width);
        }
        private method paint(string style) {
            if (appearance != style) {
                skin.setStyle(style);
                appearance = style;
            }
        }
        private method pointerEvent(integer eventId) {
            if (!enabled) { return; }
            if (eventId == FRAME_MOUSE_ENTER) {
                hovered = true;
                this.paint("hover");
            } else if (eventId == FRAME_MOUSE_LEAVE) {
                hovered = false;
                this.paint("idle");
            } else if (eventId == FRAME_MOUSE_DOWN) {
                this.paint("pressed");
                if (clicked != 0) { clicked.evaluate(this); }
            } else if (eventId == FRAME_MOUSE_UP) {
                if (hovered) { this.paint("hover"); }
                else { this.paint("idle"); }
            }
        }
        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
        method testButtonTiles() -> integer { return skin.testButtonTiles(); }
        method testPointerEvent(integer eventId) { this.pointerEvent(eventId); }
        method testAppearance() -> string { return appearance; }
        #endif
        method setEnabled(boolean active) -> thistype {
            if (!active) { hovered = false; this.paint("disabled"); }
            else if (!enabled) { this.paint("idle"); }
            enabled = active;
            skin.root.setAlpha(255);
            if (!active) { skin.root.setAlpha(115); }
            DzFrameSetEnable(hit.ui,active);
            return this;
        }
        static method create(integer parent, string text, real w) -> thistype {
            thistype this = allocate();
            skin = frameButtonSkin.create(parent,w);
            caption = text;
            clicked = 0;
            hasIcon = false;
            hovered = false;
            appearance = "idle";
            enabled = true;
            stripes = uiImage.create(skin.root.ui).setTexture(FrameTexture("stripes")).exReSize(0.013,0.006)
                .exRePoint(ANCHOR_BOTTOMRIGHT,skin.root.ui,ANCHOR_BOTTOMRIGHT,-0.006,0.004);
            icon = uiImage.create(skin.root.ui).show(false);
            label = uiText.create(skin.root.ui).setText(text).setFontSize(6);
            FrameFont(label,0.011);
            hit = uiBtn.createBlank(skin.root.ui).setAllPoint(skin.root.ui);
            // 保留旧版原生事件语义；sp* 会额外修改共享鼠标状态及销毁时补发 leave。
            uiHashTable(hit.ui).eventdata.bind(this);
            hit.onEnter(function() {
                thistype b = uiHashTable(DzGetTriggerUIEventFrame()).eventdata.get();
                b.pointerEvent(FRAME_MOUSE_ENTER);
            }).onLeave(function() {
                thistype b = uiHashTable(DzGetTriggerUIEventFrame()).eventdata.get();
                b.pointerEvent(FRAME_MOUSE_LEAVE);
            }).onClick(function() {
                thistype b = uiHashTable(DzGetTriggerUIEventFrame()).eventdata.get();
                b.pointerEvent(FRAME_MOUSE_DOWN);
            });
            DzFrameSetScriptByCode(hit.ui,FRAME_MOUSE_UP,function() {
                thistype b = uiHashTable(DzGetTriggerUIEventFrame()).eventdata.get();
                b.pointerEvent(FRAME_MOUSE_UP);
            },false);
            this.setEnabled(true);
            return this.setWidth(w);
        }
        method onDestroy() {
            enabled = false;
            hovered = false;
            clicked = 0;
            hit.destroy();
            hit = 0;
            label.destroy();
            label = 0;
            icon.destroy();
            icon = 0;
            stripes.destroy();
            stripes = 0;
            skin.destroy();
            skin = 0;
        }
    }
}
//! endzinc
#endif
