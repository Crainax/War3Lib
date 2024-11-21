#ifndef UITextIncluded
#define UITextIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
文字UI组件
*/
library UIText requires UIId,UITocInit,UIBaseModule {


    public struct uiText {
        integer ui; //frameID
        integer id; //可以回收的ID名(为了销毁时ID不重复)

        STRUCT_SHARED_METHODS(uiText)

        module uiBaseModule; // UI控件的共用方法
        module uiTextModule;   // UI文本的共用方法

        // 创建文本
        // parent: 父级框架
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("TEXT",STRING_TEXT + I2S(id),parent,TEMPLATE_TEXT,0);
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
