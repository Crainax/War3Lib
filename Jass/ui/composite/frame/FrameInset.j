#ifndef FrameInsetIncluded
#define FrameInsetIncluded
#include "Crainax/ui/constants/UIConstants.j"
//! zinc
//# dependency:resource/ui/frame/inset0.blp
//# dependency:resource/ui/frame/inset1.blp
//# dependency:resource/ui/frame/inset2.blp
//# dependency:resource/ui/frame/inset3.blp
//# dependency:resource/ui/frame/inset5.blp
//# dependency:resource/ui/frame/inset6.blp
//# dependency:resource/ui/frame/inset7.blp
//# dependency:resource/ui/frame/inset8.blp
library FrameInset requires FrameNineSlice, UIImage, UIExtendResize {
    // 透明中心内框；调用者先销毁业务子组件，再销毁容器。
    public struct frameInset {
        private frameNineSlice skin;
        private uiImage content;
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
        method getContentWidth() -> real { return skin.width - 0.022; }
        method getContentHeight() -> real { return skin.height - 0.022; }
        method setSize(real w, real h) -> thistype {
            skin.setSize(w,h);
            content.exReSize(this.getContentWidth(),this.getContentHeight());
            return this;
        }
        static method create(integer parent, real w, real h) -> thistype {
            thistype this = allocate();
            skin = frameNineSlice.create(parent,"ui\\frame\\inset",0.011,false,w,h);
            content = uiImage.create(skin.root.ui).setTexture(UI_STRING_PATH_BLANK)
                .exRePoint(ANCHOR_TOPLEFT,skin.root.ui,ANCHOR_TOPLEFT,0.011,-0.011);
            return this.setSize(w,h);
        }
        method onDestroy() {
            content.destroy();
            content = 0;
            skin.destroy();
            skin = 0;
        }
    }
}
//! endzinc
#endif
