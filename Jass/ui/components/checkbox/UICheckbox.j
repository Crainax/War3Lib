#ifndef UICheckboxIncluded
#define UICheckboxIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
文字UI组件
*/

library UICheckbox requires STRUCT_SHARED_REQUIRE_UI {

    public struct uiCheckbox {
        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(uiCheckbox)

        // 创建打钩型复选框
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("GLUECHECKBOX",STRING_CHECKBOX + I2S(id),parent,TEMPLATE_CHECKBOX,0);
            STRUCT_SHARED_UI_ONCREATE(uiCheckbox)
            return this;
        }

        // 创建单选型复选框
        static method createR (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("GLUECHECKBOX",STRING_CHECKBOX + I2S(id),parent,TEMPLATE_CHECKBOX_RADIO,0);
            STRUCT_SHARED_UI_ONCREATE(uiCheckbox)
            return this;
        }

        // 当被选中时
        method onChecked (code fun) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetScriptByCode(ui,FRAME_CHECKBOX_CHECKED,fun,false);
            return this;
        }
        // 当未被选中时
        method onUnchecked (code fun) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetScriptByCode(ui,FRAME_CHECKBOX_UNCHECKED,fun,false);
            return this;
        }

        method onDestroy () {
            if (!this.isExist()) {return;}
            STRUCT_SHARED_UI_ONDESTROY(uiCheckbox)
            DzDestroyFrame(ui);
            uiId.recycle(id);
        }
    }
}



//! endzinc
#endif
