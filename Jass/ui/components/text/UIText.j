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

        // 创建一个用在原生Frame里的文本,这种文本是不能destroy的!
        // parent: 父级框架
        static method createSimple (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            DzCreateFrameByTagName("SIMPLEFRAME", STRING_TEXT + I2S(id), parent, TEMPLATE_SIMPLE_TEXT, id);
            ui = DzSimpleFontStringFindByName(TEMPLATE_SIMPLE_TEXT_CHILD, id);
            STRUCT_SHARED_UI_ONCREATE(uiText)
            return this;
        }

        // 绑定原生文本
        // name: 文本名称(fdf写的text的名字)
        // index: 文本索引(在外部创建时的填写的ID最后一个参数)
        static method bindSimple (string name, integer index) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzSimpleFontStringFindByName(name, index);
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
