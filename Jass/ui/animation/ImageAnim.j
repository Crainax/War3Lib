#ifndef ImageAnimIncluded
#define ImageAnimIncluded

#include "Crainax/ui/constants/UIConstants.j" // UI常量


//! zinc
/*
图片相关的
*/
library ImageAnim requires BaseAnim, UIHashTable, UIImage,GrowData {


    public struct imageAnim [] {

        static method gif (player p,growdata gd,integer parent)  -> nothing {
            uiImage img;
            baseanim ba;
            if (GetLocalPlayer() != p) {return;}
            img = uiImage.create(DzGetGameUI());
            img.setSize(0.035 * gd.scale,0.035 * gd.scale);
            img.setPoint(ANCHOR_CENTER,parent,ANCHOR_CENTER,0,0);
            ba = baseanim.create(img.ui);
            ba.addSequ(gd.path,gd.max,gd.gap,false);
            ba.addLife(gd.gap*gd.max + 1,function (baseanim ba) {
                // BaseAnim 生命周期结束时销毁对应的 uiImage
                integer ui = ba.ui;
                uiImage img = uiHashTable(ui).ui.get();
                if (uiHashTable(ui).ui.getType() != uiImage.typeid) return;
                img.destroy();
                #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
                BJDebugMsg("GIF销毁了: " + I2S(img)+"["+I2S(img.ui)+"]");
                #endif
            });
        }


    }

}

//! endzinc
#endif
