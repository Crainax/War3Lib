#ifndef UICheckboxIncluded
#define UICheckboxIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
文字UI组件
*/

library UICheckbox requires UIId,UITocInit,UIBaseModule {

    public struct uiCheckbox {
        integer ui; //frameID
        integer id; //可以回收的ID名(为了销毁时ID不重复)

        STRUCT_SHARED_METHODS(uiCheckbox)

        module uiBaseModule;   // UI控件的共用方法

        // 创建打钩型复选框
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("GLUECHECKBOX",STRING_CHECKBOX + I2S(id),parent,TEMPLATE_CHECKBOX,0);
            return this;
        }

        // 创建单选型复选框
        static method createR (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("GLUECHECKBOX",STRING_CHECKBOX + I2S(id),parent,TEMPLATE_CHECKBOX_RADIO,0);
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
            DzDestroyFrame(ui);
            uiId.recycle(id);
        }
    }
}



//! endzinc
#endif
