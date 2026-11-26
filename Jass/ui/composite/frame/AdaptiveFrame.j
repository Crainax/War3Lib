#ifndef AdaptiveFrameIncluded
#define AdaptiveFrameIncluded
#include "Crainax/ui/constants/UIConstants.j"
//! zinc
//# dependency:resource/ui/frame/shell0.blp
//# dependency:resource/ui/frame/shell1.blp
//# dependency:resource/ui/frame/shell2.blp
//# dependency:resource/ui/frame/shell3.blp
//# dependency:resource/ui/frame/shell4.blp
//# dependency:resource/ui/frame/shell5.blp
//# dependency:resource/ui/frame/shell6.blp
//# dependency:resource/ui/frame/shell7.blp
//# dependency:resource/ui/frame/shell8.blp
//# dependency:resource/ui/frame/inset0.blp
//# dependency:resource/ui/frame/inset1.blp
//# dependency:resource/ui/frame/inset2.blp
//# dependency:resource/ui/frame/inset3.blp
//# dependency:resource/ui/frame/inset5.blp
//# dependency:resource/ui/frame/inset6.blp
//# dependency:resource/ui/frame/inset7.blp
//# dependency:resource/ui/frame/inset8.blp
//# dependency:resource/ui/frame/title-left.blp
//# dependency:resource/ui/frame/title-right.blp
//# dependency:map/fonts/YaHeiBold.ttf
//# dependency:resource/ui/frame/close.blp
//# dependency:resource/ui/frame/close-hover.blp
//# dependency:resource/ui/frame/stripes.blp
//# dependency:resource/ui/frame/check-off.blp
//# dependency:resource/ui/frame/check-on.blp
//# dependency:resource/ui/frame/check-locked.blp
//# dependency:resource/ui/frame/check-locked-on.blp
//# dependency:resource/ui/frame/mint.blp
//# dependency:resource/ui/frame/track.blp
//# dependency:resource/ui/frame/rule.blp
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
library AdaptiveFrame requires UIImage, UIText, UIButton, UIExtendResize, UIExtendEvent {
    private function texture(string name) -> string {
        return "ui\\frame\\" + name + ".blp";
    }

    public function AdaptiveFrameFont(uiText label, real size) {
        DzFrameSetFont(label.ui,"fonts\\YaHeiBold.ttf",size,0);
    }

    // 普通 Frame。调用者先销毁挂在 root 下的业务组件，再销毁容器。
    public struct frameSkin {
        uiImage root;
        real width;
        real height;
        private real corner;
        private uiImage tile[9];
        private boolean isButton;
        private static constant real BUTTON_HEIGHT = 0.029;

        method setSize(real w, real h) -> thistype {
            integer row;
            integer col;
            // 中段至少留一个正宽度，防止引擎把零尺寸解释为自动尺寸。
            width = RMaxBJ(w, 2 * corner + 0.001);
            height = RMaxBJ(h, 2 * corner + 0.001);
            if (isButton) {
                height = BUTTON_HEIGHT;
                root.exReSize(width,height);
                tile[0].exReSize(corner,height);
                tile[1].exReSize(width - 2 * corner,height);
                tile[2].exReSize(corner,height);
                return this;
            }
            root.exReSize(width,height);
            for (0 <= row <= 2) {
                for (0 <= col <= 2) {
                    w = corner;
                    h = corner;
                    if (col == 1) { w = width - 2 * corner; }
                    if (row == 1) { h = height - 2 * corner; }
                    if (tile[row * 3 + col] != 0) { tile[row * 3 + col].exReSize(w, h); }
                }
            }
            return this;
        }
        method setStyle(string style) {
            integer i;
            if (isButton) {
                for (0 <= i <= 2) { tile[i].setTexture(texture("btn-" + style + I2S(i))); }
                return;
            }
            for (0 <= i <= 8) { if (tile[i] != 0) { tile[i].setTexture(texture(style + I2S(i))); } }
        }
        private static method make(integer parent, string style, real c, real w, real h) -> thistype {
            thistype this = allocate();
            integer i;
            corner = c;
            isButton = style == "button";
            root = uiImage.create(parent).setTexture(UI_STRING_PATH_BLANK);
            if (isButton) {
                for (0 <= i <= 2) {
                    tile[i] = uiImage.create(root.ui).setPoint(ANCHOR_LEFT+i,root.ui,ANCHOR_LEFT+i,0,0);
                }
                this.setStyle("idle");
                return this.setSize(w,h);
            }
            for (0 <= i <= 8) {
                // Dz 的 0..8 锚点和九宫格的行优先顺序一致。
                tile[i] = 0;
                if (style != "inset" || i != 4) {
                    tile[i] = uiImage.create(root.ui).setTexture(texture(style + I2S(i))).setPoint(i, root.ui, i, 0, 0);
                }
            }
            return this.setSize(w, h);
        }
        static method panel(integer parent, real w, real h) -> thistype {
            return thistype.make(parent, "shell", 0.012, w, h);
        }
        static method inset(integer parent, real w, real h) -> thistype {
            return thistype.make(parent, "inset", 0.011, w, h);
        }
        static method button(integer parent, real w) -> thistype {
            return thistype.make(parent, "button", BUTTON_HEIGHT * 0.25, w, BUTTON_HEIGHT);
        }
        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
        method testButtonTiles() -> integer {
            integer i;
            integer count = 0;
            for (0 <= i <= 8) { if (tile[i] != 0) { count += 1; } }
            return count;
        }
        #endif
        method onDestroy() {
            integer i;
            for (0 <= i <= 8) { if (tile[i] != 0) { tile[i].destroy(); tile[i] = 0; } }
            root.destroy();
        }
    }

    public struct adaptiveFrame {
        frameSkin skin;
        uiText title;
        private uiImage left;
        private uiImage right;
        private uiImage rule;
        private uiImage titleViewport;
        private uiImage closeImage;
        private uiBtn closeHit;
        method show(boolean visible) -> thistype {
            skin.root.show(visible);
            return this;
        }
        method getRoot() -> uiImage {
            return skin.root;
        }
        private uiImage titleArt;
        private boolean hasTitleArt;
        private boolean largeTitle;
        private boolean hasCaption;
        method getTitleFrame() -> integer {
            if (hasTitleArt && largeTitle) { return titleArt.ui; }
            return title.ui;
        }
        method setLargeTitle(boolean large) -> thistype {
            integer anchor;
            largeTitle = large;
            titleArt.show(hasTitleArt && large);
            title.show(!hasTitleArt || !large);
            anchor = this.getTitleFrame();
            left.exRePoint(ANCHOR_RIGHT,anchor,ANCHOR_LEFT,-0.006,0);
            right.exRePoint(ANCHOR_LEFT,anchor,ANCHOR_RIGHT,0.006,0);
            left.show(hasCaption || (hasTitleArt && large));
            right.show(hasCaption || (hasTitleArt && large));
            return this;
        }
        // 固定标题可使用带透明通道的字形贴图；尺寸采用原图的字面宽高比。
        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
        method testTitleViewport() -> integer { return titleViewport.ui; }
        #endif
        method setTitleArt(string path, real aspect, real height) -> thistype {
            hasTitleArt = path != null && path != "" && aspect > 0 && height > 0;
            if (hasTitleArt) { titleArt.setTexture(path).exReSize(height * aspect,height); }
            return this.setLargeTitle(largeTitle);
        }
        method setTitle(string value, integer fontSize) -> thistype {
            hasTitleArt = false;
            hasCaption = value != "";
            title.setFontLevel("fonts\\YaHeiBold.ttf",fontSize).setText(value);
            return this.setLargeTitle(largeTitle);
        }
        method setSize(real w, real h) -> thistype {
            skin.setSize(RMaxBJ(0.10,w), RMaxBJ(0.055,h));
            // 两侧对称预留关闭键宽度、边距和间隙；先裁掉侧饰外端，标题中心不动。
            titleViewport.exReSize(skin.width - 2 * (0.022 + 0.008 + 0.004),0.034);
            rule.exReSize(skin.width - 0.028, 0.0024);
            return this;
        }
        static method create(integer parent, string caption, real w, real h) -> thistype {
            thistype this = allocate();
            skin = frameSkin.panel(parent,w,h);

            // 位移由未缩放的锚框承担，改字号时标题中心不会一起向下移动。
            titleViewport = uiImage.create(skin.root.ui).setTexture(UI_STRING_PATH_BLANK).setClip(true)
                .setPoint(ANCHOR_CENTER,skin.root.ui,ANCHOR_TOP,0,-0.017);
            title = uiText.create(titleViewport.ui).setPoint(ANCHOR_CENTER,titleViewport.ui,ANCHOR_CENTER,0,0);
            titleArt = uiImage.create(titleViewport.ui).setPoint(ANCHOR_CENTER,titleViewport.ui,ANCHOR_CENTER,0,0);
            largeTitle = true;
            DzFrameSetScale(title.ui,1.0);
            left = uiImage.create(titleViewport.ui).setTexture(texture("title-left")).exReSize(0.048,0.012);
            right = uiImage.create(titleViewport.ui).setTexture(texture("title-right")).exReSize(0.048,0.012);
            rule = uiImage.create(skin.root.ui).setTexture(texture("rule")).setPoint(ANCHOR_TOP,skin.root.ui,ANCHOR_TOP,0,-0.038);
            closeImage = uiImage.create(skin.root.ui).setTexture(texture("close")).exReSize(0.022,0.022)
                .exRePoint(ANCHOR_RIGHT,skin.root.ui,ANCHOR_TOPRIGHT,-0.008,-0.019);
            closeHit = uiBtn.createBlank(skin.root.ui).setAllPoint(closeImage.ui);
            uiHashTable(closeHit.ui).eventdata.bind(this);
            closeHit.onEnter(function() {
                thistype panel = uiHashTable(DzGetTriggerUIEventFrame()).eventdata.get();
                panel.closeImage.setTexture(texture("close-hover"));
            }).onLeave(function() {
                thistype panel = uiHashTable(DzGetTriggerUIEventFrame()).eventdata.get();
                panel.closeImage.setTexture(texture("close"));
            }).onClick(function() {
                thistype panel = uiHashTable(DzGetTriggerUIEventFrame()).eventdata.get();
                panel.closeImage.setTexture(texture("close"));
                panel.show(false);
            });
            this.setTitle(caption,8);
            return this.setSize(w,h);
        }
        method onDestroy() {
            left.destroy();
            right.destroy();
            title.destroy();
            titleArt.destroy();
            titleViewport.destroy();
            rule.destroy();
            closeHit.destroy();
            closeImage.destroy();
            skin.destroy();
        }
    }

    public struct frameProgress {
        uiImage root;
        private uiImage fill;
        private uiText label;
        private real width;
        private real height;
        integer value;
        integer maximum;

        method setValue(integer current, integer total) -> thistype {
            maximum = IMaxBJ(0,total);
            value = IMaxBJ(0,IMinBJ(current,maximum));
            fill.show(value > 0);
            if (value > 0) { fill.exReSize((width - 0.002) * value / maximum,height - 0.002); }
            label.setText(I2S(value) + "/" + I2S(maximum));
            return this;
        }
        method setSize(real w, real h) -> thistype {
            width = RMaxBJ(0.004,w);
            height = RMaxBJ(0.004,h);
            root.exReSize(width,height);
            return this.setValue(value,maximum);
        }
        static method create(integer parent, real w, real h) -> thistype {
            thistype this = allocate();
            root = uiImage.create(parent).setTexture(texture("track"));
            fill = uiImage.create(root.ui).setTexture(texture("mint")).exRePoint(ANCHOR_LEFT,root.ui,ANCHOR_LEFT,0.001,0);
            label = uiText.create(root.ui).setFontSize(4).setAlign(4).setAllPoint(root.ui);
            AdaptiveFrameFont(label,0.010);
            DzFrameAddTextShadow(label.ui,0.00065,0.0,0xFF000000);
            DzFrameDuplicateTextShadow(label.ui,8);
            value = 0;
            maximum = 0;
            return this.setSize(w,h);
        }
        method onDestroy() {
            label.destroy();
            fill.destroy();
            root.destroy();
        }
    }

    public struct frameCheckbox {
        uiBtn root;
        boolean checked;
        boolean enabled;
        private uiImage mark;
        private uiText label;
        uiEvent changed; // 本地事件，参数是复选框实例。
        method setState(boolean selected, boolean active) -> thistype {
            string name = "check-off";
            checked = selected;
            enabled = active;
            if (selected) { name = "check-on"; }
            if (!active) {
                name = "check-locked";
                if (selected) { name = "check-locked-on"; }
            }
            mark.setTexture(texture(name));
            label.setAlpha(255);
            if (!active) { label.setAlpha(110); }
            DzFrameSetEnable(root.ui,active);
            return this;
        }
        static method create(integer parent, string caption, real w) -> thistype {
            thistype this = allocate();
            root = uiBtn.createBlank(parent).exReSize(RMaxBJ(w,0.025),0.022);
            mark = uiImage.create(root.ui).exReSize(0.021,0.021).setPoint(ANCHOR_LEFT,root.ui,ANCHOR_LEFT,0,0);
            label = uiText.create(root.ui).setText(caption).exRePoint(ANCHOR_LEFT,mark.ui,ANCHOR_RIGHT,0.003,0);
            AdaptiveFrameFont(label,0.011);
            changed = 0;
            uiHashTable(root.ui).eventdata.bind(this);
            root.onClick(function() {
                thistype box = uiHashTable(DzGetTriggerUIEventFrame()).eventdata.get();
                if (box.enabled) {
                    box.setState(!box.checked,true);
                    if (box.changed != 0) { box.changed.evaluate(box); }
                }
            });
            return this.setState(false,true);
        }
        method onDestroy() {
            label.destroy();
            mark.destroy();
            root.destroy();
        }
    }

    public struct frameButton {
        frameSkin skin;
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
        method getRoot() -> uiImage {
            return skin.root;
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
            skin = frameSkin.button(parent,w);
            caption = text;
            clicked = 0;
            hasIcon = false;
            hovered = false;
            appearance = "idle";
            enabled = true;
            stripes = uiImage.create(skin.root.ui).setTexture(texture("stripes")).exReSize(0.013,0.006)
                .exRePoint(ANCHOR_BOTTOMRIGHT,skin.root.ui,ANCHOR_BOTTOMRIGHT,-0.006,0.004);
            icon = uiImage.create(skin.root.ui).show(false);
            label = uiText.create(skin.root.ui).setText(text).setFontSize(6);
            AdaptiveFrameFont(label,0.011);
            hit = uiBtn.createBlank(skin.root.ui).setAllPoint(skin.root.ui);
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
            label.destroy();
            icon.destroy();
            stripes.destroy();
            skin.destroy();
        }
    }
}
//! endzinc
#endif
