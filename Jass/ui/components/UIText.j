#ifndef UITextIncluded
#define UITextIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
文字UI组件
*/
library UIText requires UIId,UITocInit {
    public struct uiText {

        integer ui; //frameID
        integer id; //可以回收的ID名(为了销毁时ID不重复)

        STRUCT_SHARED_METHODS(uiText)

        static method create (integer parent,integer size) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("TEXT",STRING_TEXT + I2S(id),parent,TEMPLATE_TEXT,0);
            DzFrameSetFont(ui,"fonts\\zt.ttf",size,0);
            return this;
        }

        // TEXT_ALIGN_TOP_LEFT = 0        // 左上对齐
        // TEXT_ALIGN_TOP_CENTER = 1      // 顶部居中对齐
        // TEXT_ALIGN_TOP_RIGHT = 2       // 右上对齐
        // TEXT_ALIGN_MIDDLE_LEFT = 3     // 左中对齐
        // TEXT_ALIGN_MIDDLE_CENTER = 4   // 中心对齐
        // TEXT_ALIGN_MIDDLE_RIGHT = 5    // 右中对齐
        // TEXT_ALIGN_BOTTOM_LEFT = 6     // 左下对齐
        // TEXT_ALIGN_BOTTOM_CENTER = 7   // 底部居中对齐
        // TEXT_ALIGN_BOTTOM_RIGHT = 8    // 右下对齐
        method setAlign (integer align) -> nothing {
            if (!this.isExist()) {return;}
            DzFrameSetTextAlignment(ui,align);
        }

        method setText (string text) -> nothing {
            if (!this.isExist()) {return;}
            DzFrameSetText(ui,text);
        }

        //销毁时调用
        method onDestroy () {
            if (!this.isExist()) {return;}
            DzDestroyFrame(ui);
            uiId.recycle(id);
            ui = 0;
            id = 0;
        }

    }
}

//! endzinc
#endif
