#ifndef UIEditboxIncluded
#define UIEditboxIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
文字UI组件
*/
library UIEditbox requires STRUCT_SHARED_REQUIRE_UI,UITextModule,UIEventModule {

    public struct uiEditbox {
        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(uiEditbox)
        module uiTextModule;   // UI文本的共用方法
        module uiEventModule;  // UI事件的共用方法

        // 创建文本
        // parent: 父级框架
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("EDITBOX",STRING_EDITBOX + I2S(id),parent,TEMPLATE_EDITBOX,0);
            STRUCT_SHARED_UI_ONCREATE(uiEditbox)
            return this;
        }

        // 设置焦点
        method setFocus (boolean focus) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetFocus(ui,focus);
            return this;
        }

        // 文本改变事件, DzFrameGetText获取内容
        method onChange (code c) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetScriptByCode(ui,FRAME_EDITBOX_TEXT_CHANGED,c,false);
            return this;
        }

        method onDestroy () {
            if (!this.isExist()) {return;}
            STRUCT_SHARED_UI_ONDESTROY(uiEditbox)
            DzDestroyFrame(ui);
            uiId.recycle(id);
        }
    }
}

//! endzinc
#endif
