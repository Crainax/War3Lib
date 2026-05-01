#ifndef ImageAnimIncluded
#define ImageAnimIncluded

#include "Crainax/ui/constants/UIConstants.j" // UI常量


//! zinc
/*
图片相关的
*/
library ImageAnim requires BaseAnim, UIHashTable, UIImage, GrowData, EasingUtils, UIAnimTimer, UIUtils {

    #define IMAGE_ANIM_MST_UI_LENGTH       0.4 // 左右两张图片拼合后的总长度(横向宽度)基准值
    #define IMAGE_ANIM_MST_UI_WIDTH        0.2 // 拼合图片的高度基准值
    #define IMAGE_ANIM_MST_UI_SCALE_RADIO  0.5 // 动画缩放幅度(例如0.5表示进场从1.5倍缩小到1倍，退场从1倍放大到1.5倍)
    #define IMAGE_ANIM_MST_COUNTDOWN_START 20  // 进场动画持续帧数
    #define IMAGE_ANIM_MST_COUNTDOWN_HOLD  20 // 动画中间停留展示的持续帧数
    #define IMAGE_ANIM_MST_COUNTDOWN_END   20  // 退场动画持续帧数
    #define IMAGE_ANIM_MST_COUNTDOWN_TOTAL (IMAGE_ANIM_MST_COUNTDOWN_START + IMAGE_ANIM_MST_COUNTDOWN_HOLD + IMAGE_ANIM_MST_COUNTDOWN_END) // 动画总持续帧数
    #define IMAGE_ANIM_MST_CENTER_OFFSET_Y 0.1 // 整体动画在屏幕Y轴中心点的偏移量(正数向上偏移)
    #define IMAGE_ANIM_MST_HASH_KEY        1950// 绑在UI哈希表上的Key值，用于防重和清理生命周期

    //私人副本特效
    private struct mstPairAnim {
        static thistype List[];
        static integer size = 0;
        static uianim UIA = 0;

        uiImage uiMain;
        uiImage uiLeft;
        uiImage uiRight;
        baseanim lifeAnim;
        real imageScale;
        integer id;
        integer now;

        private method applyFrame(real scale, integer alpha) {
            real resizeX = GetResizeRate();
            if (resizeX <= 0.0) {resizeX = 1.0;}
            if (alpha < 0) {alpha = 0;}
            if (alpha > 255) {alpha = 255;}
            if (!uiMain.isExist() || !uiLeft.isExist() || !uiRight.isExist()) {return;}
            uiMain.setAlpha(alpha);
            uiLeft.setAlpha(alpha)
                .setSize(scale * imageScale * IMAGE_ANIM_MST_UI_LENGTH * 0.5, scale * imageScale * IMAGE_ANIM_MST_UI_WIDTH / resizeX);
            uiRight.setAlpha(alpha)
                .setSize(scale * imageScale * IMAGE_ANIM_MST_UI_LENGTH * 0.5, scale * imageScale * IMAGE_ANIM_MST_UI_WIDTH / resizeX);
        }

        static method create(string leftPath, string rightPath, real imageScale) -> thistype {
            thistype this = allocate();
            uiMain = uiImage.create(DzGetGameUI());
            uiLeft = uiImage.create(uiMain.ui);
            uiRight = uiImage.create(uiMain.ui);
            now = 0;
            this.imageScale = imageScale;
            if (this.imageScale <= 0.0) {this.imageScale = 1.0;}

            uiMain.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, IMAGE_ANIM_MST_CENTER_OFFSET_Y)
                .setSize(0.001, 0.001)
                .setAlpha(0);
            uiLeft.setTexture(leftPath)
                .setPoint(ANCHOR_RIGHT, uiMain.ui, ANCHOR_CENTER, 0.0, 0.0);
            uiRight.setTexture(rightPath)
                .setPoint(ANCHOR_LEFT, uiMain.ui, ANCHOR_CENTER, 0.0, 0.0);
            applyFrame(1.0 + IMAGE_ANIM_MST_UI_SCALE_RADIO, 0);

            SaveInteger(HASH_UI, uiMain.ui, IMAGE_ANIM_MST_HASH_KEY, this);
            size += 1;
            List[size] = this;
            id = size;
            UIA.reg();

            lifeAnim = baseanim.create(uiMain.ui);
            lifeAnim.addLife(IMAGE_ANIM_MST_COUNTDOWN_TOTAL + 1, function(baseanim ba) {
                integer ui = ba.ui;
                thistype this = 0;
                if (HaveSavedInteger(HASH_UI, ui, IMAGE_ANIM_MST_HASH_KEY)) {
                    this = LoadInteger(HASH_UI, ui, IMAGE_ANIM_MST_HASH_KEY);
                    if (this != 0 && this.id != 0) {
                        this.lifeAnim = 0;
                        this.destroy();
                    }
                }
            });
            return this;
        }

        method onDestroy() {
            baseanim ba;
            if (uiMain.isExist()) {
                RemoveSavedInteger(HASH_UI, uiMain.ui, IMAGE_ANIM_MST_HASH_KEY);
            }
            if (lifeAnim.isExist()) {
                ba = lifeAnim;
                lifeAnim = 0;
                ba.destroy();
            }
            if (id != 0) {
                List[id] = List[size];
                List[id].id = id;
                size -= 1;
                id = 0;
            }
            if (uiLeft.isExist()) {uiLeft.destroy();}
            if (uiRight.isExist()) {uiRight.destroy();}
            if (uiMain.isExist()) {uiMain.destroy();}
            uiLeft = 0;
            uiRight = 0;
            uiMain = 0;
            if (size <= 0) {UIA.unreg();}
        }

        static method onInit() {
            UIA = uianim.create(function() {
                integer i;
                thistype this;
                real r;
                real scale;
                integer alpha;
                for (1 <= i <= size) {
                    this = List[i];
                    now += 1;
                    if (now <= IMAGE_ANIM_MST_COUNTDOWN_START) {
                        r = I2R(now) / IMAGE_ANIM_MST_COUNTDOWN_START;
                        scale = (1.0 - EaseInOutBack(r)) * IMAGE_ANIM_MST_UI_SCALE_RADIO + 1.0;
                        alpha = R2I(EaseOutExpo(r) * 255.0);
                    } else if (now <= IMAGE_ANIM_MST_COUNTDOWN_START + IMAGE_ANIM_MST_COUNTDOWN_HOLD) {
                        scale = 1.0;
                        alpha = 255;
                    } else {
                        r = I2R(now - IMAGE_ANIM_MST_COUNTDOWN_START - IMAGE_ANIM_MST_COUNTDOWN_HOLD) / IMAGE_ANIM_MST_COUNTDOWN_END;
                        scale = 1.0 - EaseInOutBack(r);
                        if (scale < 0.0) {scale = 0.0;}
                        alpha = 255 - R2I(EaseOutCubic(r) * 255.0);
                    }
                    applyFrame(scale, alpha);
                }
            });
        }
    }

    public struct imageAnim [] {

        static method mstPair(string leftPath, string rightPath) {
            mstPairAnim.create(leftPath, rightPath, 1.0);
        }

        static method mstPairScale(string leftPath, string rightPath, real imageScale) {
            mstPairAnim.create(leftPath, rightPath, imageScale);
        }

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
