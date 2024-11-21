#ifndef UIEventTextIncluded
#define UIEventTextIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
文字UI组件
*/
library UIEventText requires UIId,UITocInit,UIBaseModule,UIEventModule,UITextModule {

    public struct uiEventText {
        integer ui; //frameID
        integer id; //可以回收的ID名(为了销毁时ID不重复)

        STRUCT_SHARED_METHODS(uiEventText)

        module uiBaseModule;   // UI控件的共用方法
        module uiEventModule;  // UI事件的共用方法
        module uiTextModule;   // UI文本的共用方法

        // 创建文本
        // parent: 父级框架
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("TEXT",STRING_TEXT + I2S(id),parent,TEMPLATE_TEXT_EVENT,0);
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
