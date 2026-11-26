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
//# dependency:resource/ui/frame/title-left.blp
//# dependency:resource/ui/frame/title-right.blp
//# dependency:resource/ui/frame/rule.blp
//# dependency:resource/ui/frame/close.blp
//# dependency:resource/ui/frame/close-hover.blp
library AdaptiveFrame requires FrameTheme, FrameNineSlice, UIButton, UIExtendEvent, UIImage, UIText, UIExtendResize, UIHashTable {
    public struct adaptiveFrame {
        private frameNineSlice skin;
        private uiImage content;
        uiEvent closed; // 本地关闭通知，参数为实例；程序 show(false) 不触发。
        uiText title;
        private uiImage left;
        private uiImage right;
        private uiImage rule;
        private uiImage titleViewport;
        private uiImage closeImage;
        private uiBtn closeHit;
        // 返回借用句柄，不得单独 destroy；业务子组件必须先于容器销毁。
        method getRoot() -> uiImage { return skin.root; }
        method getWidth() -> real { return skin.width; }
        method getHeight() -> real { return skin.height; }
        method setPoint(integer anchor, integer relative, integer relativeAnchor, real x, real y) -> thistype {
            skin.root.exRePoint(anchor,relative,relativeAnchor,x,y);
            return this;
        }
        method show(boolean visible) -> thistype { skin.root.show(visible); return this; }
        method getContentRoot() -> uiImage { return content; }
        method getContentWidth() -> real { return skin.width - 0.028; }
        method getContentHeight() -> real { return skin.height - 0.054; }
        method setCloseVisible(boolean visible) -> thistype {
            closeImage.setTexture(FrameTexture("close")).show(visible);
            closeHit.show(visible);
            return this;
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
        method testLeftDecoration() -> integer { return left.ui; }
        method testRightDecoration() -> integer { return right.ui; }
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
            content.exReSize(this.getContentWidth(),this.getContentHeight());
            return this;
        }
        static method create(integer parent, string caption, real w, real h) -> thistype {
            thistype this = allocate();
            skin = frameNineSlice.create(parent,"ui\\frame\\shell",0.012,true,w,h);

            // 位移由未缩放的锚框承担，改字号时标题中心不会一起向下移动。
            titleViewport = uiImage.create(skin.root.ui).setTexture(UI_STRING_PATH_BLANK).setClip(true)
                .setPoint(ANCHOR_CENTER,skin.root.ui,ANCHOR_TOP,0,-0.017);
            title = uiText.create(titleViewport.ui).setPoint(ANCHOR_CENTER,titleViewport.ui,ANCHOR_CENTER,0,0);
            titleArt = uiImage.create(titleViewport.ui).setPoint(ANCHOR_CENTER,titleViewport.ui,ANCHOR_CENTER,0,0);
            largeTitle = true;
            DzFrameSetScale(title.ui,1.0);
            left = uiImage.create(titleViewport.ui).setTexture(FrameTexture("title-left")).exReSize(0.048,0.012);
            right = uiImage.create(titleViewport.ui).setTexture(FrameTexture("title-right")).exReSize(0.048,0.012);
            rule = uiImage.create(skin.root.ui).setTexture(FrameTexture("rule")).setPoint(ANCHOR_TOP,skin.root.ui,ANCHOR_TOP,0,-0.038);
            closeImage = uiImage.create(skin.root.ui).setTexture(FrameTexture("close")).exReSize(0.022,0.022)
                .exRePoint(ANCHOR_RIGHT,skin.root.ui,ANCHOR_TOPRIGHT,-0.008,-0.019);
            closeHit = uiBtn.createBlank(skin.root.ui).setAllPoint(closeImage.ui);
            // 保留旧版原生事件语义；sp* 会额外修改共享鼠标状态及销毁时补发 leave。
            uiHashTable(closeHit.ui).eventdata.bind(this);
            closeHit.onEnter(function() {
                thistype panel = uiHashTable(DzGetTriggerUIEventFrame()).eventdata.get();
                panel.closeImage.setTexture(FrameTexture("close-hover"));
            }).onLeave(function() {
                thistype panel = uiHashTable(DzGetTriggerUIEventFrame()).eventdata.get();
                panel.closeImage.setTexture(FrameTexture("close"));
            }).onClick(function() {
                thistype panel = uiHashTable(DzGetTriggerUIEventFrame()).eventdata.get();
                panel.closeImage.setTexture(FrameTexture("close"));
                panel.show(false);
                if (panel.closed != 0) { panel.closed.evaluate(panel); }
            });
            // 调用者先销毁业务子组件，再销毁外框；内容区不裁剪。
            content = uiImage.create(skin.root.ui).setTexture(UI_STRING_PATH_BLANK)
                .exRePoint(ANCHOR_TOPLEFT,skin.root.ui,ANCHOR_TOPLEFT,0.014,-0.040);
            closed = 0;
            this.setTitle(caption,8);
            return this.setSize(w,h);
        }
        method onDestroy() {
            closed = 0;
            content.destroy();
            content = 0;
            left.destroy();
            left = 0;
            right.destroy();
            right = 0;
            title.destroy();
            title = 0;
            titleArt.destroy();
            titleArt = 0;
            titleViewport.destroy();
            titleViewport = 0;
            rule.destroy();
            rule = 0;
            closeHit.destroy();
            closeHit = 0;
            closeImage.destroy();
            closeImage = 0;
            skin.destroy();
            skin = 0;
        }
    }
}
//! endzinc
#endif
