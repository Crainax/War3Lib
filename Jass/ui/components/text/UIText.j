#ifndef UITextIncluded
#define UITextIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
文字UI组件
*/
library UIText requires STRUCT_SHARED_REQUIRE_UI,UITextModule {


    public struct uiText {
        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(uiText)

        // UI控件的共用方法
        module uiTextModule;   // UI文本的共用方法

        // 创建文本
        // parent: 父级框架
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("TEXT",STRING_TEXT + I2S(id),parent,TEMPLATE_TEXT,0);
            STRUCT_SHARED_UI_ONCREATE(uiText)
            return this;
        }

        method onDestroy () {
            if (!this.isExist()) {return;}
            STRUCT_SHARED_UI_ONDESTROY(uiText)
            DzDestroyFrame(ui);
            uiId.recycle(id);
        }
    }
}

//! endzinc
#endif
