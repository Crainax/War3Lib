#ifndef CardFlipAnimIncluded
#define CardFlipAnimIncluded

#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j"
#include "Crainax/data/audio/MusicConstant.j"

//! zinc
/*
 * 播放矩形卡牌序列帧。growdata.max 是最后一帧的编号，首帧为 0。
 * 只创建本地 UI；底层 BaseAnim/UIAnimTimer 的经典句柄在全端初始化。
 */
library CardFlipAnim requires BaseAnim, GrowData, UIImage, UIButton, UIHashTable, UIExtendEvent, Music {

    public struct cardFlipAnim [] {
        // parent 是定位参照；实际图片使用同一个 parent 创建。
        // holdTicks 以 0.02 秒为单位，播放完毕后保留末帧。
        static method play(player p, integer parent, growdata gd, real width, real height, real offsetX, real offsetY, integer holdTicks) {
            uiImage img;
            baseanim anim;
            integer lifeTicks;

            if (GetLocalPlayer() != p || parent == 0 || gd == 0 || gd.max <= 0 || gd.gap <= 0 || gd.path == "" || width <= 0.0 || height <= 0.0) {
                return;
            }
            if (holdTicks < 1) {holdTicks = 1;}

            img = uiImage.create(parent);
            img.setSize(width, height);
            img.setPoint(ANCHOR_CENTER, parent, ANCHOR_CENTER, offsetX, offsetY);

            anim = baseanim.create(img.ui);
            anim.addSequ(gd.path, gd.max, gd.gap, false);
            lifeTicks = gd.max * gd.gap + holdTicks + 1;
            anim.addLife(lifeTicks, function(baseanim finished) {
                integer ui = finished.ui;
                uiImage cardImage;
                if (uiHashTable(ui).ui.getType() != uiImage.typeid) {return;}
                cardImage = uiHashTable(ui).ui.get();
                cardImage.destroy();
            });
        }
    }

    // 可点击的卡牌：静止卡背 -> 点击反馈 -> 翻转与高光 -> 短暂停留后清理。
    // 仅包含本地 UI 与预初始化音效；游戏奖励必须由调用方另外同步处理。
    public struct cardFlipCard {
        STRUCT_SHARED_METHODS(cardFlipCard)

        private uiImage card;
        private uiImage glow;
        private uiBtn clickArea;
        private baseanim cardAnim;
        private baseanim glowAnim;
        private growdata cardData;
        private growdata glowData;
        private real width;
        private real height;
        private integer holdTicks;
        private integer state; // 0=待点击，1=翻转中

        static method create(player p, integer parent, growdata cardData, growdata glowData, real width, real height, real offsetX, real offsetY, integer holdTicks) -> thistype {
            thistype this;
            if (GetLocalPlayer() != p || parent == 0 || cardData == 0 || glowData == 0 || cardData.max <= 0 || cardData.gap <= 0 || glowData.max != cardData.max || cardData.gap != glowData.gap || cardData.path == "" || glowData.path == "" || width <= 0.0 || height <= 0.0) {
                return 0;
            }
            this = allocate();
            this.cardData = cardData;
            this.glowData = glowData;
            this.width = width;
            this.height = height;
            this.holdTicks = holdTicks;
            if (this.holdTicks < 1) {this.holdTicks = 1;}
            this.state = 0;
            this.cardAnim = 0;
            this.glowAnim = 0;

            this.card = uiImage.create(parent);
            this.card.setSize(width, height);
            this.card.setPoint(ANCHOR_CENTER, parent, ANCHOR_CENTER, offsetX, offsetY);
            this.card.setTexture(cardData.path + "0.blp");
            uiHashTable(this.card.ui).eventdata.bind(this);

            this.glow = uiImage.create(parent);
            this.glow.setSize(width, height);
            this.glow.setPoint(ANCHOR_CENTER, this.card.ui, ANCHOR_CENTER, 0.0, 0.0);
            this.glow.setTexture(glowData.path + "2.blp");
            this.glow.setAlpha(0);

            this.clickArea = uiBtn.createBlank(parent);
            this.clickArea.setAllPoint(this.card.ui);
            uiHashTable(this.clickArea.ui).eventdata.bind(this);
            this.clickArea.spEnter(function(integer frame) {
                cardFlipCard target = uiHashTable(frame).eventdata.get();
                if (target.isExist() && target.state == 0) {
                    target.glow.setAlpha(150);
                }
            });
            this.clickArea.spLeave(function(integer frame) {
                cardFlipCard target = uiHashTable(frame).eventdata.get();
                if (target.isExist() && target.state == 0) {
                    target.glow.setAlpha(0);
                }
            });
            this.clickArea.spClick(function(integer frame) {
                cardFlipCard target = uiHashTable(frame).eventdata.get();
                if (target.isExist()) {target.start();}
            });
            return this;
        }

        private method start() {
            integer lifeTicks;
            if (!this.isExist() || this.state != 0) {return;}
            this.state = 1;
            this.clickArea.show(false);
            music[MUSIC_INDEX_BTN_DOWN_1].play();

            // 按下时稍微收紧，再随翻转的前三帧弹回原尺寸。
            this.card.setSize(this.width * 0.97, this.height * 0.97);
            this.cardAnim = baseanim.create(this.card.ui);
            this.cardAnim.addSequ(this.cardData.path, this.cardData.max, this.cardData.gap, false);
            this.cardAnim.addZoom(this.width * 0.97, this.width, this.height * 0.97, this.height, 3);
            lifeTicks = this.cardData.max * this.cardData.gap + this.holdTicks + 1;
            this.cardAnim.addLife(lifeTicks, function(baseanim finished) {
                cardFlipCard target = uiHashTable(finished.ui).eventdata.get();
                if (!target.isExist()) {return;}
                // BaseAnim 正在自己的寿命回调中析构，避免重复销毁它。
                target.cardAnim = 0;
                target.destroy();
            });

            this.glow.setAlpha(255);
            this.glowAnim = baseanim.create(this.glow.ui);
            this.glowAnim.addSequ(this.glowData.path, this.glowData.max, this.glowData.gap, false);
        }

        method onDestroy() {
            if (!this.isExist()) {return;}
            if (this.clickArea.isExist()) {this.clickArea.destroy(); this.clickArea = 0;}
            if (this.glowAnim.isExist()) {this.glowAnim.destroy(); this.glowAnim = 0;}
            if (this.cardAnim.isExist()) {this.cardAnim.destroy(); this.cardAnim = 0;}
            if (this.glow.isExist()) {this.glow.destroy(); this.glow = 0;}
            if (this.card.isExist()) {this.card.destroy(); this.card = 0;}
        }
    }
}
//! endzinc

#endif
