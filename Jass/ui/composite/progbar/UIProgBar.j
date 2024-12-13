#ifndef UIProgBarIncluded
#define UIProgBarIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
动态进度条(使用Sprite组件)
组合式UI
*/

//# dependency: ui/bar/grow_yellow.mdx
//# dependency: ui/bar/grow_mp.mdx
//# dependency: ui/bar/grow_hp.mdx
//# dependency: ui/bar/shade_yellow.mdx
//# dependency: ui/bar/shade_hmp.mdx
//# dependency: ui/bar/hpbar_glow.blp

library UIProgBar requires UISprite {

    public struct uiProgBar {

        uiSprite uiGlow;
        uiSprite uiShade;

        STRUCT_SHARED_METHODS(uiProgBar)

        // 原理是用uiShade来挡住uiGlow，通过设置uiShade的偏移来实现进度条的效果
        //uiShade进度前进时,uiGlow的前端被挡住部分就更少了
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            uiGlow = uiSprite.create(parent)
                .setModel("ui\\bar\\grow_hp.mdx",0,0)
                .setSize(0.001,0.001)
                .setAnimate(0,true);
            uiShade = uiSprite.create(parent)
                .setModel("ui\\bar\\shade_hmp.mdx",0,0)
                .setSize(0.001,0.001)
                .setAnimate(0,false)
                .setAllPoint(uiGlow.ui);
            return this;
        }

        // 设置进度(0-1.0)
        method setProgress (real progress) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetAnimateOffset(uiShade.ui,progress);
            return this;
        }

        // 设置位置
        method setPoint (integer anchor, integer relative, integer relativeAnchor, real offsetX, real offsetY) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetPoint(uiGlow.ui,anchor,relative,relativeAnchor,offsetX,offsetY);
            return this;
        }

        // 设置进度条的大小
        method setScale (real scale) -> thistype {
            uiGlow.setScale(scale);
            uiShade.setScale(scale);
            return this;
        }

        method onDestroy () {
            if (!this.isExist()) {return;}
            uiShade.destroy(); //注意顺序
            uiGlow.destroy();
        }

    }

}

//! endzinc
#endif
