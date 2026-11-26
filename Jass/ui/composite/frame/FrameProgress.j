#ifndef FrameProgressIncluded
#define FrameProgressIncluded
#include "Crainax/ui/constants/UIConstants.j"
//! zinc
//# dependency:resource/ui/frame/track.blp
//# dependency:resource/ui/frame/mint.blp
library FrameProgress requires FrameTheme, UIImage, UIExtendResize, UIText {
    public struct frameProgress {
        uiImage root;
        private uiImage fill;
        private uiText label;
        private real width;
        private real height;
        integer value;
        integer maximum;

        method getRoot() -> uiImage { return root; }
        method getWidth() -> real { return width; }
        method getHeight() -> real { return height; }
        method setPoint(integer anchor, integer relative, integer relativeAnchor, real x, real y) -> thistype {
            root.exRePoint(anchor,relative,relativeAnchor,x,y);
            return this;
        }
        method show(boolean visible) -> thistype { root.show(visible); return this; }
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
            root = uiImage.create(parent).setTexture(FrameTexture("track"));
            fill = uiImage.create(root.ui).setTexture(FrameTexture("mint")).exRePoint(ANCHOR_LEFT,root.ui,ANCHOR_LEFT,0.001,0);
            label = uiText.create(root.ui).setFontSize(4).setAlign(4).setAllPoint(root.ui);
            FrameFont(label,0.010);
            DzFrameAddTextShadow(label.ui,0.00065,0.0,0xFF000000);
            DzFrameDuplicateTextShadow(label.ui,8);
            value = 0;
            maximum = 0;
            return this.setSize(w,h);
        }
        method onDestroy() {
            label.destroy();
            label = 0;
            fill.destroy();
            fill = 0;
            root.destroy();
            root = 0;
        }
    }
}
//! endzinc
#endif
