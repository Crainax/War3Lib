#ifndef UIBorderIncluded
#define UIBorderIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
边框图片UI组件
*/

library UIBorder requires UIId,UITocInit,UIBaseModule,UIImageModule {

    public struct uiBorder {
        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(uiBorder)

        module uiImageModule;  // UI图片的共用方法

        // 创建文本
        // parent: 父级框架
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE + I2S(id),parent,TEMPLATE_BORDER1,0);
            STRUCT_SHARED_UI_ONCREATE(uiBorder)
            return this;
        }

        method alignParent(integer ui) -> thistype {
            if (!this.isExist()) {return this;}
            this.setPoint(ANCHOR_TOPLEFT, ui, ANCHOR_TOPLEFT, -0.005, 0.005);
            this.setPoint(ANCHOR_BOTTOMRIGHT, ui, ANCHOR_BOTTOMRIGHT, 0.005, -0.005);
            return this;
        }

        method onDestroy () {
            if (!this.isExist()) {return;}
            STRUCT_SHARED_UI_ONDESTROY(uiBorder)
            DzDestroyFrame(ui);
            uiId.recycle(id);
        }
    }
}



//! endzinc
#endif
