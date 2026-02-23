#ifndef UIBorderIncluded
#define UIBorderIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
边框图片UI组件
*/

//# dependency:resource/UI/Widgets/ToolTips/Human/human-tooltip-border2.blp

library UIBorder requires UIId,UITocInit,UIBaseModule,UIImageModule {

    public struct uiBorder {
        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(uiBorder)

        module uiImageModule;  // UI图片的共用方法

        // 创建边框种类1
        // parent: 父级框架
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE + I2S(id),parent,TEMPLATE_BORDER1,0);
            STRUCT_SHARED_UI_ONCREATE(uiBorder)
            return this;
        }

        // 创建边框种类2:适用于按钮系
        // parent: 父级框架
        static method createType2 (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE + I2S(id),parent,TEMPLATE_BORDER2,0);
            STRUCT_SHARED_UI_ONCREATE(uiBorder)
            return this;
        }

        // 创建边框种类2:适用于大面板通知消息系
        // parent: 父级框架
        static method createType3 (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE + I2S(id),parent,TEMPLATE_BORDER3,0);
            STRUCT_SHARED_UI_ONCREATE(uiBorder)
            return this;
        }

        // 创建边框种类2:适用于大面板通知消息系
        // parent: 父级框架
        static method createType4 (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE + I2S(id),parent,TEMPLATE_BORDER4,0);
            STRUCT_SHARED_UI_ONCREATE(uiBorder)
            return this;
        }

        // 创建边框种类5:魔兽原生对话框风格
        // parent: 父级框架
        static method createType5 (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE + I2S(id),parent,TEMPLATE_BORDER5,0);
            STRUCT_SHARED_UI_ONCREATE(uiBorder)
            return this;
        }

        // 创建工具提示背景图片(种类1)
        // parent: 父级框架
        static method createToolTips (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE + I2S(id),parent,TEMPLATE_IMAGE_TOOLTIPS,0);
            STRUCT_SHARED_UI_ONCREATE(uiImage)
            return this;
        }

        // 创建工具提示背景图片(种类2)
        // parent: 父级框架
        static method createToolTips2 (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE + I2S(id),parent,TEMPLATE_IMAGE_TOOLTIPS2,0);
            STRUCT_SHARED_UI_ONCREATE(uiImage)
            return this;
        }

        // 创建边角(图标系的)
        // parent: 父级框架
        static method createCornerBorder (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE + I2S(id),parent,TEMPLATE_IMAGE_CORNER_BORDER,0);
            STRUCT_SHARED_UI_ONCREATE(uiImage)
            return this;
        }

        method alignParent(integer ui,real padding) -> thistype {
            if (!this.isExist()) {return this;}
            this.setPoint(ANCHOR_TOPLEFT, ui, ANCHOR_TOPLEFT, -1 * padding, padding);
            this.setPoint(ANCHOR_BOTTOMRIGHT, ui, ANCHOR_BOTTOMRIGHT, padding, -1 * padding);
            return this;
        }

        method onDestroy () {
            if (!this.isExist()) {return;}
            STRUCT_SHARED_UI_ONDESTROY(uiBorder)
            DzDestroyFrame(ui);
            uiId.recycle(id);
        }
    }
}



//! endzinc
#endif
