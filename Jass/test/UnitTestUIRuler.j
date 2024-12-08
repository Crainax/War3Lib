#ifndef UnitTestUIRulerIncluded
#define UnitTestUIRulerIncluded

/*
用来测量UI组件的尺寸
*/

#include "Crainax/input/constant/KeyConstants.j"

//! zinc
library UnitTestUIRuler requires UIImage,UIText,UIUtils,Hardware,Keyboard {

	//单元测试总
	trigger TUnitTest = null;
    boolean isShowRuler = false; //是否显示尺子
    uiImage imageAnchor = 0; //锚点,按下Ctrl再点击鼠标左键定锚
    real anchorPosX = 0; //锚点X坐标
    real anchorPosY = 0; //锚点Y坐标
    uiImage imageRuler[]; //尺子(4把常规的)+一把锚点尺
    uiText textRuler[]; //尺子上的文字

    function InitTestUIRuler () {
        DoNothing();
    }

    function onInit ()  {
        integer i;

        imageAnchor = uiImage.create(DzGetGameUI()) //锚点钉
            .setSize(0.005,0.005)
            .hide()
            .texture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp");

        // 创建文本显示
        textRuler[1] = uiText.create(DzGetGameUI()) //上
            .setPoint(ANCHOR_TOP, DzGetGameUI(), ANCHOR_TOP, 0, 0)
            .setPoint(ANCHOR_BOTTOM, DzGetGameUI(), ANCHOR_CENTER, 0, 0)
            .setAlign(4)
            .setText("0.000");
        textRuler[2] = uiText.create(DzGetGameUI()) //下
            .setPoint(ANCHOR_TOP, DzGetGameUI(), ANCHOR_CENTER, 0, 0)
            .setPoint(ANCHOR_BOTTOM, DzGetGameUI(), ANCHOR_BOTTOM, 0, 0)
            .setAlign(4)
            .setText("0.000");
        textRuler[3] = uiText.create(DzGetGameUI()) //左
            .setPoint(ANCHOR_LEFT, DzGetGameUI(), ANCHOR_LEFT, 0, 0)
            .setAlign(4)
            .setText("0.000");
        textRuler[4] = uiText.create(DzGetGameUI()) //右
            .setPoint(ANCHOR_RIGHT, DzGetGameUI(), ANCHOR_RIGHT, 0, 0)
            .setAlign(4)
            .setText("0.000");
        textRuler[5] = uiText.create(DzGetGameUI()) //锚点到鼠标
            .setAlign(4)
            .setText("0.000");

        // 创建尺子图像
        for (1 <= i <= 4) {
            imageRuler[i] = uiImage.create(DzGetGameUI())
                .setAllPoint(textRuler[i].ui)
                .hide()
                .texture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp");
        }

        // 创建锚点到鼠标的尺子
        imageRuler[5] = uiImage.create(DzGetGameUI())
            .setAllPoint(textRuler[5].ui)
            .hide()
            .texture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp");

        // ESC键切换显示/隐藏
        keyboard.regKeyUpEvent(KEY_ESC, function (){
            isShowRuler = !isShowRuler;
            if (isShowRuler) {
                imageAnchor.show();
                integer i;
                for (1 <= i <= 5) {
                    imageRuler[i].show();
                    textRuler[i].show();
                }
            } else {
                imageAnchor.hide();
                integer i;
                for (1 <= i <= 5) {
                    imageRuler[i].hide();
                    textRuler[i].hide();
                }
            }
        });

        // 添加鼠标点击事件
        hardware.regClickEvent(function() {
            real mouseX;
            real mouseY;

            if (!isShowRuler) return;

            if (hardware.isKeyDown(KEY_CONTROL)) {
                mouseX = GetMouseXEx();
                mouseY = GetMouseYEx();
                imageAnchor.setAbsPoint(ANCHOR_CENTER, mouseX, mouseY);
                anchorPosX = mouseX; // 记录锚点位置
                anchorPosY = mouseY;
            }
        });

        // 鼠标移动事件
        hardware.regMoveEvent(function (){
            real mouseX;
            real mouseY;
            real dx;
            real dy;

            mouseX = GetMouseXEx();
            mouseY = GetMouseYEx();

            if (!isShowRuler) return;

            // 更新上尺子
            textRuler[1].setAbsPoint(ANCHOR_BOTTOM, mouseX, mouseY);
            textRuler[1].setText(R2SW(mouseY, 7, 3));

            // 更新下尺子
            textRuler[2].setAbsPoint(ANCHOR_TOP, mouseX, mouseY);
            textRuler[2].setText(R2SW(-mouseY, 7, 3));

            // 更新左尺子
            textRuler[3].setAbsPoint(ANCHOR_RIGHT, mouseX, mouseY);
            textRuler[3].setText(R2SW(mouseX, 7, 3));

            // 更新右尺子
            textRuler[4].setAbsPoint(ANCHOR_LEFT, mouseX, mouseY);
            textRuler[4].setText(R2SW(-mouseX, 7, 3));

            // 计算x,y偏移并更新文本
            dx = mouseX - anchorPosX;
            dy = mouseY - anchorPosY;

            // 根据鼠标相对于锚点的位置来设置textRuler[5]的锚点
            if (mouseX >= anchorPosX) {
                if (mouseY >= anchorPosY) {
                    // 鼠标在右下
                    textRuler[5].setPoint(ANCHOR_TOP_LEFT, imageAnchor.ui, ANCHOR_CENTER, 0, 0);
                    textRuler[5].setAbsPoint(ANCHOR_BOTTOM_RIGHT, mouseX, mouseY);
                } else {
                    // 鼠标在右上
                    textRuler[5].setPoint(ANCHOR_BOTTOM_LEFT, imageAnchor.ui, ANCHOR_CENTER, 0, 0);
                    textRuler[5].setAbsPoint(ANCHOR_TOP_RIGHT, mouseX, mouseY);
                }
            } else {
                if (mouseY >= anchorPosY) {
                    // 鼠标在左下
                    textRuler[5].setPoint(ANCHOR_TOP_RIGHT, imageAnchor.ui, ANCHOR_CENTER, 0, 0);
                    textRuler[5].setAbsPoint(ANCHOR_BOTTOM_LEFT, mouseX, mouseY);
                } else {
                    // 鼠标在左上
                    textRuler[5].setPoint(ANCHOR_BOTTOM_RIGHT, imageAnchor.ui, ANCHOR_CENTER, 0, 0);
                    textRuler[5].setAbsPoint(ANCHOR_TOP_LEFT, mouseX, mouseY);
                }
            }

            textRuler[5].setText("x:" + R2SW(dx, 7, 3) + " y:" + R2SW(dy, 7, 3));
        });
    }
}

//! endzinc
#endif


