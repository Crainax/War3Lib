#ifndef UIImageIncluded
#define UIImageIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
图片UI组件
*/

//# dependency:UI\Widgets\ToolTips\Human\human-tooltip-background2.blp
//# dependency:UI\Widgets\ToolTips\Human\human-tooltip-border2.blp

library UIImage requires UIId,UITocInit,UIBaseModule,UIImageModule {

    public struct uiImage {
        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(uiImage)

        module uiImageModule;  // UI图片的共用方法

        // 创建图片
        // parent: 父级框架
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE + I2S(id),parent,TEMPLATE_IMAGE,0);
            STRUCT_SHARED_UI_ONCREATE(uiImage)
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

        // 创建一个用在原生Frame里的图片,这种图片是不能destroy的!
        // parent: 父级框架
        static method createSimple (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            DzCreateFrameByTagName("SIMPLEFRAME", STRING_IMAGE + I2S(id), parent, TEMPLATE_SIMPLE_IMAGE, id);
            ui = DzSimpleTextureFindByName(TEMPLATE_SIMPLE_IMAGE_CHILD, id);
            STRUCT_SHARED_UI_ONCREATE(uiImage)
            return this;
        }

        // 绑定原生图片
        // name: 图片名称(fdf写的image的名字)
        // index: 图片索引(在外部创建时的填写的ID最后一个参数)
        static method bindSimple (string name, integer index) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzSimpleTextureFindByName(name, index);
            STRUCT_SHARED_UI_ONCREATE(uiImage)
            return this;
        }


        method onDestroy () {
            if (!this.isExist()) {return;}
            STRUCT_SHARED_UI_ONDESTROY(uiImage)
            DzDestroyFrame(ui);
            uiId.recycle(id);
        }
    }
}



//! endzinc
#endif
