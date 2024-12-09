#ifndef UnitTestUIRulerIncluded
#define UnitTestUIRulerIncluded

/*
用来测量UI组件的尺寸
*/

#include "Crainax/input/constant/KeyConstants.j"
#include "Crainax/ui/constants/UIConstants.j" // UI常量


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

    //触发UI尺子调用这条就行了
    public function InitTestUIRuler () {
        DoNothing();
    }

    function onInit ()  {
        integer i;
        trigger tr = CreateTrigger();

        // 初始化锚点在地图中心
        anchorPosX = 0.4;
        anchorPosY = 0.3;

        imageAnchor = uiImage.create(DzGetGameUI()) //锚点钉
            .setSize(0.01,0.01)
            .hide()
            .setAbsPoint(ANCHOR_CENTER, anchorPosX, anchorPosY) // 设置初始位置
            .texture("UI\\MiniMap\\minimap-gold.blp");

        for (1 <= i <= 5) {
            imageRuler[i] = uiImage.create(DzGetGameUI());
            textRuler[i] = uiText.create(DzGetGameUI()) //上
                .setAlign(4)
                .hide()
                .setText("0.000");
        }

        // 创建尺子图像
        for (1 <= i <= 2) { //上下
            imageRuler[i].setPoint(ANCHOR_TOP, textRuler[i].ui, ANCHOR_TOP, 0, 0)
                .setPoint(ANCHOR_BOTTOM, textRuler[i].ui, ANCHOR_BOTTOM, 0, 0)
                .setSize(0.01, 0.01)
                .hide()
                .texture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp");
        }

        // 创建尺子图像
        for (3 <= i <= 4) { //左右
            imageRuler[i].setAllPoint(textRuler[i].ui)
                .hide()
                .texture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp");
        }

        // 创建锚点到鼠标的尺子
        imageRuler[5].hide()
            .setAlpha(100)
            .texture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp");
        textRuler[5].setPoint(ANCHOR_CENTER, imageRuler[5].ui, ANCHOR_CENTER, 0, 0)
            .setSize(0.1, 0);


        // ESC键切换显示/隐藏
        keyboard.regKeyUpEvent(KEY_ESC, function (){
            integer i;
            isShowRuler = !isShowRuler;
            if (isShowRuler) {
                imageAnchor.show();
                for (1 <= i <= 5) {
                    imageRuler[i].show();
                    textRuler[i].show();
                }
            } else {
                imageAnchor.hide();
                for (1 <= i <= 5) {
                    imageRuler[i].hide();
                    textRuler[i].hide();
                }
            }
        });

        // 添加鼠标点击事件
        hardware.regLeftUpEvent(function() {
            real mouseX;
            real mouseY;

            if (!isShowRuler) return;

            if (DzIsKeyDown(KEY_CONTROL)) {
                mouseX = GetMouseXEx();
                mouseY = GetMouseYEx();
                imageAnchor.setAbsPoint(ANCHOR_CENTER, mouseX, mouseY);
                anchorPosX = mouseX; // 记录锚点位置
                anchorPosY = mouseY;
                BJDebugMsg("参考物位置: " + R2SW(mouseX, 7, 3) + " " + R2SW(mouseY, 7, 3));
            } else {
                // 添加打印边距信息
                mouseX = GetMouseXEx();
                mouseY = GetMouseYEx();
                BJDebugMsg("距离边界: " +
                "左=" + R2SW(mouseX, 7, 3) +
                " 右=" + R2SW(0.8 - mouseX, 7, 3) +
                " 上=" + R2SW(0.6 - mouseY, 7, 3) +
                " 下=" + R2SW(mouseY, 7, 3));
            }
        });

        // 鼠标移动事件
        hardware.regMoveEvent(function (){
            real mouseX, mouseY, dx, dy, width, height;

            mouseX = GetMouseXEx();
            mouseY = GetMouseYEx();

            if (!isShowRuler) return;

            // 更新上尺子
            textRuler[1].setAbsPoint(ANCHOR_TOP, mouseX, 0.6);
            textRuler[1].setAbsPoint(ANCHOR_BOTTOM, mouseX, mouseY + 0.005);
            textRuler[1].setText(R2SW(0.6 - mouseY, 7, 3));

            // 更新下尺子
            textRuler[2].setAbsPoint(ANCHOR_TOP, mouseX, mouseY - 0.005);
            textRuler[2].setAbsPoint(ANCHOR_BOTTOM, mouseX, 0);
            textRuler[2].setText(R2SW(mouseY, 7, 3));

            // 更新左尺子
            textRuler[3].setAbsPoint(ANCHOR_LEFT, 0, mouseY);
            textRuler[3].setAbsPoint(ANCHOR_RIGHT, mouseX - 0.005, mouseY);
            textRuler[3].setText(R2SW(mouseX, 7, 3));

            // 更新右尺子
            textRuler[4].setAbsPoint(ANCHOR_LEFT, mouseX + 0.005, mouseY);
            textRuler[4].setAbsPoint(ANCHOR_RIGHT, 0.8, mouseY);
            textRuler[4].setText(R2SW(0.8 - mouseX, 7, 3));

            // 计算x,y偏移并更新文本
            dx = mouseX - anchorPosX;
            dy = mouseY - anchorPosY;

            // 计算尺子的宽高(尺子绝对值)
            width = I2R(IAbsBJ(R2I(dx * 1000))) / 1000;
            height = I2R(IAbsBJ(R2I(dy * 1000))) / 1000;

            // 根据鼠标位置设置锚点和尺寸
            if (mouseX >= anchorPosX) {
                if (mouseY >= anchorPosY) {
                    // 鼠标在右上
                    imageRuler[5].clearPoint()
                        .setAbsPoint(ANCHOR_TOP_RIGHT, mouseX, mouseY)
                        .setSize(width, height);
                } else {
                    // 鼠标在右下
                    imageRuler[5].clearPoint()
                        .setAbsPoint(ANCHOR_BOTTOM_RIGHT, mouseX, mouseY)
                        .setSize(width, height);
                }
            } else {
                if (mouseY >= anchorPosY) {
                    // 鼠标在左上
                    imageRuler[5].clearPoint()
                        .setAbsPoint(ANCHOR_TOP_LEFT, mouseX, mouseY)
                        .setSize(width, height);
                } else {
                    // 鼠标在左下
                    imageRuler[5].clearPoint()
                        .setAbsPoint(ANCHOR_BOTTOM_LEFT, mouseX, mouseY)
                        .setSize(width, height);
                }
            }

            textRuler[5].setText("x:" + R2SW(dx, 7, 3) + " y:" + R2SW(dy, 7, 3));
        });

        //在游戏开始0.1秒后再调用
        TriggerRegisterTimerEventSingle(tr,0.1);
        TriggerAddCondition(tr,Condition(function (){
            BJDebugMsg("[已注入UI尺子,按下Ctrl+点击设置锚点,按下Esc开启/关闭尺子]");
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;
    }
}

//! endzinc
#endif


