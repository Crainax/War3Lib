#ifndef UIEditboxIncluded
#define UIEditboxIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
文字UI组件
*/
library UIEditbox requires UIId,UITocInit,UIBaseModule,UITextModule,UIEventModule {

    public struct uiEditbox {
        integer ui; //frameID
        integer id; //可以回收的ID名(为了销毁时ID不重复)

        STRUCT_SHARED_METHODS(uiEditbox)

        module uiBaseModule; // UI控件的共用方法
        module uiTextModule;   // UI文本的共用方法
        module uiEventModule;  // UI事件的共用方法

        // 创建文本
        // parent: 父级框架
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("EDITBOX",STRING_EDITBOX + I2S(id),parent,TEMPLATE_EDITBOX,0);
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
            DzDestroyFrame(ui);
            uiId.recycle(id);
        }
    }
}

//! endzinc
#endif
