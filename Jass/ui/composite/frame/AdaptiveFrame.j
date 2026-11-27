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
library AdaptiveFrame requires FrameTheme, FrameNineSlice, UIButton, UIExtendDrag, UIExtendEvent, UIImage, UIText, UIExtendResize, UIHashTable {
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
        private uiBtn dragHit;
        private boolean customBounds;
        private real minX;
        private real maxX;
        private real minY;
        private real maxY;
        private integer dragIndex;
        private static thistype draggablePanels[];
        private static integer dragCount = 0;

        private static integer screenLayout = 0;
        // exRePoint 保存真实相对框架。原生读取返回布局对象，不能用作 frame 句柄。
        private method centerCoordinate(boolean horizontal) -> real {
            integer frame = skin.root.ui;
            integer wanted = ANCHOR_CENTER;
            integer anchor;
            integer nextAnchor;
            integer relative;
            integer layout;
            rePointer ptr;
            real value = 0;
            real span;
            real offset;
            integer depth = 0;
            while (frame != 0 && depth < 128) {
                depth += 1;
                if (frame == DzGetGameUI()) {
                    if (horizontal) { return value + ModuloInteger(wanted,3)*0.4; }
                    return value + (2 - wanted/3)*0.3;
                }
                ptr = LoadInteger(HASH_UI,frame,HASH_KEY_UI_EXTEND_REPOINTER);
                if (ptr != 0) {
                    anchor = ptr.anchor;
                    relative = ptr.relative;
                    nextAnchor = ptr.relativeAnchor;
                    offset = ptr.offsetY;
                    if (horizontal) { offset = ptr.offsetX * GetResizeRate(); }
                } else {
                    anchor = 0;
                    while (anchor <= 8 && !DzFrameGetPointValid(frame,anchor)) { anchor += 1; }
                    if (anchor > 8) { break; }
                    layout = DzFrameGetPointRelative(frame,anchor);
                    nextAnchor = DzFrameGetPointRelativePoint(frame,anchor);
                    relative = 0;
                    if (layout == screenLayout) { relative = DzGetGameUI(); }
                    else if (layout != 0) { relative = DzFrameGetParent(frame); }
                    offset = DzFrameGetPointY(frame,anchor);
                    if (horizontal) { offset = DzFrameGetPointX(frame,anchor); }
                }
                if (horizontal) {
                    span = DzFrameGetWidth(frame);
                    value += offset + (ModuloInteger(wanted,3)-ModuloInteger(anchor,3))*span*0.5;
                } else {
                    span = DzFrameGetHeight(frame);
                    value += offset + (anchor/3-wanted/3)*span*0.5;
                }
                frame = relative;
                wanted = nextAnchor;
            }
            return value;
        }
        method getDragX() -> real {
            if (dragIndex != 0) { return dragHit.getDragX(); }
            return this.centerCoordinate(true);
        }
        method getDragY() -> real {
            if (dragIndex != 0) { return dragHit.getDragY(); }
            return this.centerCoordinate(false);
        }
        private method updateBounds() {
            real halfW = skin.width * GetResizeRate() * 0.5;
            real halfH = skin.height * 0.5;
            if (customBounds) { return; }
            minX = RMinBJ(0.04,halfW) - halfW;
            maxX = 0.8 - minX;
            minY = RMinBJ(0.04,halfH) - halfH;
            maxY = 0.6 - minY;
            if (dragIndex != 0) { dragHit.setDragBounds(minX,maxX,minY,maxY); }
        }
        method setDragBounds(real left, real right, real bottom, real top) -> thistype {
            customBounds = true;
            minX = left;
            maxX = right;
            minY = bottom;
            maxY = top;
            if (dragIndex != 0) { dragHit.setDragBounds(left,right,bottom,top); }
            return this;
        }
        method setDragPosition(real x, real y) -> thistype {
            if (dragIndex != 0) { dragHit.setDragPosition(x,y); }
            else {
                this.updateBounds();
                uiDragger.detachAnchor(skin.root.ui);
                skin.root.clearPoint().setAbsPoint(ANCHOR_CENTER,RLimit(x,minX,maxX),RLimit(y,minY,maxY));
            }
            return this;
        }
        method setDraggable(boolean enabled) -> thistype {
            if (enabled && dragIndex == 0) {
                this.updateBounds();
                dragHit.enableDragAt(skin.root.ui,this.getDragX(),this.getDragY(),minX,maxX,minY,maxY).show(true);
                dragCount += 1;
                dragIndex = dragCount;
                draggablePanels[dragIndex] = this;
            } else if (!enabled && dragIndex != 0) {
                draggablePanels[dragIndex] = draggablePanels[dragCount];
                draggablePanels[dragIndex].dragIndex = dragIndex;
                draggablePanels[dragCount] = 0;
                dragCount -= 1;
                dragIndex = 0;
                dragHit.disableDrag().show(false);
            }
            return this;
        }
        private static method windowResized() {
            integer i;
            for (1 <= i <= dragCount) {
                draggablePanels[i].updateBounds();
                draggablePanels[i].updateTitleDecorations();
            }
        }
        static method onInit() {
            hardware.regResizeEvent(function thistype.windowResized);
        }
        // 返回借用句柄，不得单独 destroy；业务子组件必须先于容器销毁。
        method getRoot() -> uiImage { return skin.root; }
        method getWidth() -> real { return skin.width; }
        method getHeight() -> real { return skin.height; }
        method setPoint(integer anchor, integer relative, integer relativeAnchor, real x, real y) -> thistype {
            skin.root.exRePoint(anchor,relative,relativeAnchor,x,y);
            if (dragIndex != 0) { dragHit.stopDrag().setDragPosition(this.centerCoordinate(true),this.centerCoordinate(false)); }
            return this;
        }
        method show(boolean visible) -> thistype {
            if (!visible) { dragHit.stopDrag(); }
            skin.root.show(visible);
            return this;
        }
        method getContentRoot() -> uiImage { return content; }
        method getContentWidth() -> real { return skin.width - 0.028; }
        method getContentHeight() -> real { return skin.height - 0.054; }
        method setCloseVisible(boolean visible) -> thistype {
            closeImage.setTexture(FrameTexture("close")).show(visible);
            closeHit.show(visible);
            return this;
        }
        private method close() {
            closeImage.setTexture(FrameTexture("close"));
            this.show(false);
            if (closed != 0) { closed.evaluate(this); }
        }
        private uiImage titleArt;
        private boolean hasTitleArt;
        private boolean largeTitle;
        private boolean hasCaption;
        method getTitleFrame() -> integer {
            if (hasTitleArt && largeTitle) { return titleArt.ui; }
            return title.ui;
        }
        // 标题栏不开启原生视口裁剪（规避 1.27 负 X 吞字），空间不足时隐藏左右装饰。
        private method updateTitleDecorations() {
            real rate = GetResizeRate();
            real width = DzFrameGetRealWidth(this.getTitleFrame());
            boolean visible = (hasCaption || (hasTitleArt && largeTitle)) && width + 0.108 * rate <= (skin.width - 0.068) * rate;
            left.show(visible);
            right.show(visible);
        }
        method setLargeTitle(boolean large) -> thistype {
            integer anchor;
            largeTitle = large;
            titleArt.show(hasTitleArt && large);
            title.show(!hasTitleArt || !large);
            anchor = this.getTitleFrame();
            left.exRePoint(ANCHOR_RIGHT,anchor,ANCHOR_LEFT,-0.006,0);
            right.exRePoint(ANCHOR_LEFT,anchor,ANCHOR_RIGHT,0.006,0);
            this.updateTitleDecorations();
            return this;
        }
        // 固定标题可使用带透明通道的字形贴图；尺寸采用原图的字面宽高比。
        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
        static method testWindowResize() { thistype.windowResized(); }
        method testCloseClick() { this.close(); }
        method testDragHit() -> integer { return dragHit.ui; }
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
            if (dragIndex != 0) { this.updateBounds(); }
            // 两侧对称预留关闭键宽度、边距和间隙；空间不足时隐藏左右装饰，标题中心不动。
            titleViewport.exReSize(skin.width - 2 * (0.022 + 0.008 + 0.004),0.034);
            this.updateTitleDecorations();
            rule.exReSize(skin.width - 0.028, 0.0024);
            content.exReSize(this.getContentWidth(),this.getContentHeight());
            return this;
        }
        static method create(integer parent, string caption, real w, real h) -> thistype {
            thistype this = allocate();
            skin = frameNineSlice.create(parent,"ui\\frame\\shell",0.012,true,w,h);

            dragIndex = 0;
            customBounds = false;
            dragHit = uiBtn.createBlank(skin.root.ui);
            if (screenLayout == 0) {
                dragHit.setPoint(ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0);
                screenLayout = DzFrameGetPointRelative(dragHit.ui,ANCHOR_CENTER);
                dragHit.clearPoint();
            }
            dragHit.setAllPoint(skin.root.ui).show(false);

            // 位移由未缩放的锚框承担，改字号时标题中心不会一起向下移动。
            titleViewport = uiImage.create(skin.root.ui).setTexture(UI_STRING_PATH_BLANK)
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
                panel.close();
            });
            // 调用者先销毁业务子组件，再销毁外框；内容区不裁剪。
            content = uiImage.create(skin.root.ui).setTexture(UI_STRING_PATH_BLANK)
                .exRePoint(ANCHOR_TOPLEFT,skin.root.ui,ANCHOR_TOPLEFT,0.014,-0.040);
            closed = 0;
            this.setTitle(caption,8);
            return this.setSize(w,h);
        }
        method onDestroy() {
            this.setDraggable(false);
            dragHit.destroy();
            dragHit = 0;
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
