#ifndef FrameNineSliceIncluded
#define FrameNineSliceIncluded
#include "Crainax/ui/constants/UIConstants.j"
//! zinc
library FrameNineSlice requires UIImage, UIExtendResize {
    public struct frameNineSlice {
        uiImage root;
        real width;
        real height;
        private real corner;
        private uiImage tile[9];

        method setSize(real w, real h) -> thistype {
            integer row;
            integer col;
            // 中段至少留一个正宽度，防止引擎把零尺寸解释为自动尺寸。
            width = RMaxBJ(w, 2 * corner + 0.001);
            height = RMaxBJ(h, 2 * corner + 0.001);
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
        method setTexturePrefix(string prefix) {
            integer i;
            for (0 <= i <= 8) { if (tile[i] != 0) { tile[i].setTexture(prefix + I2S(i) + ".blp"); } }
        }
        static method create(integer parent, string prefix, real c, boolean center, real w, real h) -> thistype {
            thistype this = allocate();
            integer i;
            corner = RMaxBJ(0.001,c);
            root = uiImage.create(parent).setTexture(UI_STRING_PATH_BLANK);
            for (0 <= i <= 8) {
                // Dz 的 0..8 锚点和九宫格的行优先顺序一致。
                tile[i] = 0;
                if (center || i != 4) {
                    tile[i] = uiImage.create(root.ui).setTexture(prefix + I2S(i) + ".blp").setPoint(i, root.ui, i, 0, 0);
                }
            }
            return this.setSize(w, h);
        }
        method getRoot() -> uiImage { return root; }
        method getWidth() -> real { return width; }
        method getHeight() -> real { return height; }
        method setPoint(integer anchor, integer relative, integer relativeAnchor, real x, real y) -> thistype {
            root.exRePoint(anchor,relative,relativeAnchor,x,y);
            return this;
        }
        method show(boolean visible) -> thistype { root.show(visible); return this; }
        method onDestroy() {
            integer i;
            for (0 <= i <= 8) { if (tile[i] != 0) { tile[i].destroy(); tile[i] = 0; } }
            root.destroy();
            root = 0;
        }
    }
}
//! endzinc
#endif
