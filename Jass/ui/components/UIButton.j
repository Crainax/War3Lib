#ifndef UIButtonIncluded
#define UIButtonIncluded

#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j"
#include "Crainax/ui/modules/UIBaseModule.j" // 引入共用模块

//! zinc
library UIButton requires UIId,UITocInit,UIBaseModule {

    public struct uiButton {
        integer ui; //frameID
        integer id; //可以回收的ID名

        STRUCT_SHARED_METHODS(uiButton)

        module uiBaseModule; // UI控件的共用方法

        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("TEXT",STRING_BUTTON + I2S(id),parent,TEMPLATE_BLANK_BUTTON,0);
            return this;
        }


        method onDestroy () {
            if (!this.isExist()) {return;}
            DzDestroyFrame(ui);
            uiId.recycle(id);
        }
    }
}
//! endzinc
#endif
