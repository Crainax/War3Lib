#ifndef UIButtonIncluded
#define UIButtonIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
文字UI组件
*/

//# dependency:ui\image\textbutton_highlight.blp

library UIButton requires UIId,UITocInit,UIBaseModule,UIEventModule {

    public struct uiBtn {
        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(uiBtn)

        module uiBaseModule;   // UI控件的共用方法
        module uiEventModule;  // UI事件的共用方法

        // 创建一个不带声音的
        // parent: 父级框架
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BUTTON",STRING_BUTTON + I2S(id),parent,TEMPLATE_NORMAL_BUTTON,0); //有高亮无声音的图标
            STRUCT_SHARED_UI_ONCREATE(uiBtn)
            return this;
        }

        //普通带声效系
        static method createSound (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("GLUEBUTTON",STRING_BUTTON + I2S(id),parent,TEMPLATE_NORMAL_BUTTON,0); //有高亮有声音的图标
            STRUCT_SHARED_UI_ONCREATE(uiBtn)
            return this;
        }

        //右键菜单系
        static method createRC (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("GLUEBUTTON",STRING_BUTTON + I2S(id),parent,TEMPLATE_TEXT_BUTTON,0); //配合异度下的菜单使用,要导入:ui\image\textbutton_highlight.blp
            STRUCT_SHARED_UI_ONCREATE(uiBtn)
            return this;
        }

        // 创建空白按钮
        // parent: 父级框架
        static method createBlank (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BUTTON",STRING_BUTTON + I2S(id),parent,TEMPLATE_BLANK_BUTTON,0);
            STRUCT_SHARED_UI_ONCREATE(uiBtn)
            return this;
        }

        method onDestroy () {
            if (!this.isExist()) {return;}
            STRUCT_SHARED_UI_ONDESTROY(uiBtn)
            DzDestroyFrame(ui);
            uiId.recycle(id);
        }
    }
}



//! endzinc
#endif
