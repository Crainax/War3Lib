#ifndef TooltipIncluded
#define TooltipIncluded

//! zinc
/*
Tooltip的简单实现
能用至多2个文字+1个图标
*/
#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j" // UI常量

#define TOOL_CHILD_MAX 50

library Tooltip requires Icon {

    public struct tooltip {

        static integer borderType = 0;

        uiBorder border;
        icon ic[TOOL_CHILD_MAX];
        uiText text[TOOL_CHILD_MAX];
        boolean alignWidth[TOOL_CHILD_MAX]; //是否对齐宽度
        integer iconCount;
        integer textCount;
        integer relative; //整个框架的锚点控制(下面的UI)
        integer relativeTop; //整个框架的锚点控制(上面的UI)
        integer fontSize; //当前字号设置

        STRUCT_SHARED_METHODS(tooltip)

        //懒加载函数
        static method create () -> thistype {
            thistype this   = allocate();
            border = uiBorder.createToolTips(DzGetGameUI());
            relative = 0;
            relativeTop = 0;
            fontSize = 4; // 默认标准字号
            return this;
        }

        //[私有方法]清除内部UI
        private method clear () {
            integer i;
            for (1 <= i <= iconCount) {
                if (ic[i] != 0) {
                    ic[i].destroy();
                    ic[i] = 0;
                }
            }
            iconCount = 0;
            for (1 <= i <= textCount) {
                if (text[i] != 0) {
                    text[i].destroy();
                    text[i] = 0;
                }
            }
            textCount = 0;
        }


        //固定长度(个人感觉只需要锚住最下面一条内容就行了)
        method exWidth (real width) -> thistype {
            integer i;
            if (!this.isExist()) {return this;}
            for (1 <= i <= textCount) {
                if (alignWidth[i]) {
                    text[i].exReSize(width,0);
                }
            }
            return this;
        }

        //一次性长度
        method setWidth (real width) -> thistype {
            integer i;
            if (!this.isExist()) {return this;}
            for (1 <= i <= textCount) {
                if (alignWidth[i]) {
                    text[i].setSize(width,0);
                }
            }
            return this;
        }

        //标准布局 - 只有标题
        //长x宽均由文本决定
        method layoutTitle(string titleText) -> thistype {
            if (!this.isExist()) {return this;}

            this.clear(); //清除老UI,除(如果有)
            text[1]   = uiText.create(border.ui)
                .setFontSize(fontSize)
                .setAlign(4)
                .setText(titleText);
            textCount = 1;
            alignWidth[1] = true;
            relative  = text[1].ui;                //锚点控制
            relativeTop = text[1].ui;                //锚点控制

            border.alignParent(relative,0.01);
            return this;
        }

        //标准布局 - 标题和描述
        //长x宽均由文本决定
        method layoutTitleDesc(string titleText, string descText) -> thistype {
            if (!this.isExist()) {return this;}

            this.clear(); //清除老UI,除(如果有)
            text[2]   = uiText.create(border.ui)
                .setFontSize(fontSize+1)
                .setText(descText);
            text[1]   = uiText.create(border.ui)
                .setFontSize(fontSize)
                .setText(titleText)
                .setPoint(ANCHOR_BOTTOM,text[2].ui,ANCHOR_TOP,0,0.005);
            textCount     = 2;
            relative      = text[2].ui;  //锚点控制
            relativeTop   = text[1].ui;  //锚点控制
            alignWidth[2] = true;        //对齐宽度
            border.setPoint(ANCHOR_TOP, text[1].ui, ANCHOR_TOP, 0, 0.01);
            border.setPoint(ANCHOR_BOTTOM, text[2].ui, ANCHOR_BOTTOM, 0, -0.01);
            border.setPointFix(ANCHOR_LEFT, text[2].ui, ANCHOR_LEFT, -0.01, 0);
            border.setPointFix(ANCHOR_RIGHT, text[2].ui, ANCHOR_RIGHT, 0.01, 0);
            this.setWidth(0.2);

            //以底描述为基准
            // desc.setAbsolutePoint(ANCHOR_BOTTOMRIGHT, .786, .1375);
            return this;
        }

        // 设置位置
        method setPoint (integer anchor, integer targetUI, integer targetAnchor, real offsetX, real offsetY) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetPoint(relative,anchor,targetUI,targetAnchor,offsetX,offsetY);
            return this;
        }

        //绝对位置
        method setAbsPoint (integer anchor, real x, real y) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetAbsolutePoint(relative,anchor,x,y);
            return this;
        }

        //设置字号（链式调用）
        method setFontSize(integer size) -> thistype {
            if (!this.isExist()) {return this;}
            fontSize = size;
            return this;
        }

        //灵活布局 - 初始只有一条文本
        method layoutFlexible(string initialText) -> thistype {
            if (!this.isExist()) {return this;}

            this.clear(); //清除老UI
            text[1] = uiText.create(border.ui)
                .setFontSize(fontSize)
                .setAlign(4)
                .setText(initialText);
            textCount = 1;
            alignWidth[1] = true;
            relative = text[1].ui;
            relativeTop = text[1].ui;

            //初始化border位置
            border.setPoint(ANCHOR_TOP, text[1].ui, ANCHOR_TOP, 0, 0.01);
            border.setPoint(ANCHOR_BOTTOM, text[1].ui, ANCHOR_BOTTOM, 0, -0.01);
            border.setPointFix(ANCHOR_LEFT, text[1].ui, ANCHOR_LEFT, -0.01, 0);
            border.setPointFix(ANCHOR_RIGHT, text[1].ui, ANCHOR_RIGHT, 0.01, 0);

            return this;
        }

        //添加文本到tooltip顶部(layoutFlexible专用)
        method addText(string content) -> uiText {
            integer newPosition;

            if (!this.isExist()) {return 0;}
            if (textCount >= TOOL_CHILD_MAX) {return 0;}

            //创建新文本
            textCount += 1;
            newPosition = textCount;
            text[newPosition] = uiText.create(border.ui)
                .setFontSize(fontSize)
                .setAlign(4)
                .setText(content);
            alignWidth[newPosition] = true;
            relativeTop = text[newPosition].ui;

            //设置新文本的位置
            text[newPosition].setPoint(ANCHOR_BOTTOM, text[newPosition-1].ui, ANCHOR_TOP, 0, 0.005);

            //更新border边界(头部)
            border.setPoint(ANCHOR_TOP, text[textCount].ui, ANCHOR_TOP, 0, 0.01);

            return text[newPosition];
        }

        // 添加一行：左侧图标 + 文本（文本居中，对齐同 addText）(layoutFlexible专用)
        method addIconLeft(string content, string iconPath, real sizeX, real sizeY) -> uiText {
            integer newPosition;

            if (!this.isExist()) {return 0;}
            if (textCount >= TOOL_CHILD_MAX) {return 0;}

            // 先创建文本（作为锚点，保持与 addText 一致的居中与堆叠规则）
            textCount += 1;
            newPosition = textCount;
            text[newPosition] = uiText.create(border.ui)
                .setFontSize(fontSize)
                .setAlign(4)
                .setText(content);
            alignWidth[newPosition] = true;
            relativeTop = text[newPosition].ui;

            // 垂直堆叠到上一行之上
            text[newPosition].setPoint(ANCHOR_BOTTOM, text[newPosition-1].ui, ANCHOR_TOP, 0, 0.005);

            // 创建并放置图标在文本左侧
            iconCount += 1;
            ic[iconCount] = icon.create(border.ui)
                .setTexture(iconPath)
                .setSize(sizeX, sizeY)
                .setPoint(ANCHOR_RIGHT, text[newPosition].ui, ANCHOR_LEFT, -0.004, 0)
                .show(true);

            // 更新边界顶部（宽度仍与底部第一行一致）
            border.setPoint(ANCHOR_TOP, text[textCount].ui, ANCHOR_TOP, 0, 0.01);

            return text[newPosition];
        }

        method getFirstText ()  -> uiText {
            if (!this.isExist()) {return 0;}
            return text[1];
        }

        method onDestroy() {
            if (!this.isExist()) {return;}
            this.clear();
            if (border != 0) {
                border.destroy();
                border = 0;
            }
        }
    }
}

//! endzinc
#endif
