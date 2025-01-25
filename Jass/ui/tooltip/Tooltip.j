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
        integer relative; //整个框架的锚点控制

        STRUCT_SHARED_METHODS(tooltip)

        //懒加载函数
        static method create () -> thistype {
            thistype this   = allocate();
            border = uiBorder.createToolTips(DzGetGameUI());
            relative = 0;
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
        method exWidth (real width) {
            integer i;
            if (!this.isExist()) {return;}
            for (1 <= i <= textCount) {
                if (alignWidth[i]) {
                    text[i].exReSize(width,0);
                }
            }
        }

        //一次性长度
        method setWidth (real width) {
            integer i;
            if (!this.isExist()) {return;}
            for (1 <= i <= textCount) {
                if (alignWidth[i]) {
                    text[i].setSize(width,0);
                }
            }
        }

        //标准布局 - 只有标题
        //长x宽均由文本决定
        method layoutTitle(string titleText) -> thistype {
            if (!this.isExist()) {return this;}

            this.clear(); //清除老UI,除(如果有)
            text[1]   = uiText.create(border.ui)
                .setAlign(4)
                .setText(titleText);
            textCount = 1;
            alignWidth[1] = true;
            relative  = text[1].ui;                //锚点控制

            border.alignParent(relative,0.01);
            return this;
        }

        //标准布局 - 标题和描述
        //长x宽均由文本决定
        method layoutTitleDesc(string titleText, string descText) -> thistype {
            if (!this.isExist()) {return this;}

            this.clear(); //清除老UI,除(如果有)
            text[2]   = uiText.create(border.ui)
                .setText(descText)
                .setFontSize(4);
            text[1]   = uiText.create(border.ui)
                .setText(titleText)
                .setPoint(ANCHOR_BOTTOM,text[2].ui,ANCHOR_TOP,0,0.005);
            textCount     = 2;
            relative      = text[2].ui;  //锚点控制
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

        //灵活布局 - 初始只有一条文本
        method layoutFlexible(string initialText) -> thistype {
            if (!this.isExist()) {return this;}

            this.clear(); //清除老UI
            text[1] = uiText.create(border.ui)
                .setAlign(4)
                .setText(initialText);
            textCount = 1;
            alignWidth[1] = true;
            relative = text[1].ui;

            //初始化border位置
            border.setPoint(ANCHOR_TOP, text[1].ui, ANCHOR_TOP, 0, 0.01);
            border.setPoint(ANCHOR_BOTTOM, text[1].ui, ANCHOR_BOTTOM, 0, -0.01);
            border.setPointFix(ANCHOR_LEFT, text[1].ui, ANCHOR_LEFT, -0.01, 0);
            border.setPointFix(ANCHOR_RIGHT, text[1].ui, ANCHOR_RIGHT, 0.01, 0);

            return this;
        }

        //在指定位置添加文本
        //position: 插入位置(1-based)，如果大于当前文本数量则追加到末尾
        method addText(string content, integer position) -> thistype {
            integer i;
            integer actualPos;

            if (!this.isExist()) {return this;}
            if (textCount >= TOOL_CHILD_MAX) {return this;}

            //确定实际插入位置
            actualPos = position;
            if (actualPos > textCount + 1) {
                actualPos = textCount + 1;
            }
            if (actualPos < 1) {
                actualPos = 1;
            }

            //移动现有文本
            for (i = textCount; i >= actualPos; i -= 1) {
                text[i + 1] = text[i];
                alignWidth[i + 1] = alignWidth[i];
            }

            //创建新文本
            text[actualPos] = uiText.create(border.ui)
                .setAlign(4)
                .setText(content);
            alignWidth[actualPos] = true;
            textCount += 1;

            //重新设置文本间的相对位置
            for (i = 1; i <= textCount; i += 1) {
                if (i == 1) {
                    text[i].setPoint(ANCHOR_TOP, border.ui, ANCHOR_TOP, 0, 0.01);
                } else {
                    text[i].setPoint(ANCHOR_TOP, text[i-1].ui, ANCHOR_BOTTOM, 0, 0.005);
                }
            }

            //更新border边界
            border.setPoint(ANCHOR_TOP, text[1].ui, ANCHOR_TOP, 0, 0.01);
            border.setPoint(ANCHOR_BOTTOM, text[textCount].ui, ANCHOR_BOTTOM, 0, -0.01);
            border.setPointFix(ANCHOR_LEFT, text[1].ui, ANCHOR_LEFT, -0.01, 0);
            border.setPointFix(ANCHOR_RIGHT, text[1].ui, ANCHOR_RIGHT, 0.01, 0);

            relative = text[textCount].ui; //更新相对位置控制点

            return this;
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
