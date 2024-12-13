#ifndef UIImageModuleIncluded
#define UIImageModuleIncluded

#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
UI图片的共用方法
*/

library UIImageModule {
    // 定义共用的方法结构
    public module uiImageModule {
        // 设置图片路径
        method setTexture (string path) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetTexture(this.ui,path,0);
            return this;
        }

        // 设置图片控件视口,防止模型超出范围
        method setClip (boolean clip) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetClip(this.ui,clip);
            return this;
        }


    }

}


//! endzinc
#endif
