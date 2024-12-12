#ifndef UIImageBarIncluded
#define UIImageBarIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
进度条(使用两个Image组件)
组合式UI
*/

// 颜色
#define DEFAULT_COLOR_FILL "ReplaceableTextures\\TeamColor\\TeamColor02.blp"
#define DEFAULT_COLOR_BACKGROUND "ReplaceableTextures\\TeamColor\\TeamColor15.blp"

library UIImageBar requires UIImage {

    public struct uiImageBar {

        uiImage uiBackground;
        uiImage uiFill;
        private uiBorder border;

        STRUCT_SHARED_METHODS(uiImageBar)

        // 原理是用uiFill来挡住uiBackground，通过设置uiFill的偏移来实现进度条的效果
        //uiFill进度前进时,uiBackground的前端被挡住部分就更少了
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            uiBackground = uiImage.create(parent)
                .setTexture(DEFAULT_COLOR_BACKGROUND);
            uiFill = uiImage.create(parent)
                .setPoint(ANCHOR_TOPLEFT, uiBackground.ui , ANCHOR_TOPLEFT, 0.0, 0.0)
                .setPoint(ANCHOR_BOTTOMLEFT, uiBackground.ui , ANCHOR_BOTTOMLEFT, 0.0, 0.0)
                .setTexture(DEFAULT_COLOR_FILL);
            border = 0; // 默认没有边框
            return this;
        }

        // 设置填充颜色
        method setFillColor (integer playerColor) -> thistype {
            integer color;
            if (!this.isExist()) {return this;}
            color = ModuloInteger(playerColor, 16);
            if (color < 10) {
                uiFill.setTexture("ReplaceableTextures\\TeamColor\\TeamColor0" + I2S(color) + ".blp");
            } else {
                uiFill.setTexture("ReplaceableTextures\\TeamColor\\TeamColor" + I2S(color) + ".blp");
            }
            return this;
        }

        // 设置背景颜色
        method setBackgroundColor (integer playerColor) -> thistype {
            integer color;
            if (!this.isExist()) {return this;}
            color = ModuloInteger(playerColor, 16);
            if (color < 10) {
                uiBackground.setTexture("ReplaceableTextures\\TeamColor\\TeamColor0" + I2S(color) + ".blp");
            } else {
                uiBackground.setTexture("ReplaceableTextures\\TeamColor\\TeamColor" + I2S(color) + ".blp");
            }
            return this;
        }

        // 设置外边框
        method setBorder (integer borderType) -> thistype {
            if (!this.isExist()) {return this;}
            if (border == 0) {
                border = uiBorder.create(uiFill.ui)
                    .alignParent(uiBackground.ui);
            }
            return this;
        }

        // 获取进度
        method getProgress () -> real {
            if (!this.isExist()) {return 0.0;}
            return DzFrameGetWidth(uiFill.ui) / DzFrameGetWidth(uiBackground.ui);
        }

        // 设置进度(0-1.0)
        method setProgress (real progress) -> thistype {
            if (!this.isExist()) {return this;}
            // 设置填充图片的宽度为背景宽度 * 进度值
            uiFill.setSize(DzFrameGetWidth(uiBackground.ui) * progress,0.0);
            return this;
        }

        // 设置位置
        method setPoint (integer anchor, integer relative, integer relativeAnchor, real offsetX, real offsetY) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetPoint(uiBackground.ui,anchor,relative,relativeAnchor,offsetX,offsetY);
            return this;
        }

        // 设置进度条的大小
        method setSize (real width, real height) -> thistype {
            uiBackground.setSize(width,height);
            return this;
        }

        method onDestroy () {
            if (!this.isExist()) {return;}
            if (border != 0) {border.destroy();}
            uiFill.destroy(); //注意顺序
            uiBackground.destroy();
        }

    }

}

//! endzinc
#endif
