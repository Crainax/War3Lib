#ifndef UIEventTextIncluded
#define UIEventTextIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
文字UI组件
*/
library UIEventText requires STRUCT_SHARED_REQUIRE_UI,UIEventModule,UITextModule {

    public struct uiEventText {
        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(uiEventText)
        module uiEventModule;  // UI事件的共用方法
        module uiTextModule;   // UI文本的共用方法

        // 创建文本
        // parent: 父级框架
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("TEXT",STRING_TEXT + I2S(id),parent,TEMPLATE_TEXT_EVENT,0);
            STRUCT_SHARED_UI_ONCREATE(uiEventText)
            return this;
        }

        method onDestroy () {
            if (!this.isExist()) {return;}
            STRUCT_SHARED_UI_ONDESTROY(uiEventText)
            DzDestroyFrame(ui);
            uiId.recycle(id);
        }
    }
}



//! endzinc
#endif
