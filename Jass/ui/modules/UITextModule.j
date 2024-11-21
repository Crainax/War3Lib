#ifndef UITextModuleIncluded
#define UITextModuleIncluded

#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
UI文本的共用方法
*/

#define FONT_SIZE_HUGE   0.015 // 特大号
#define FONT_SIZE_LARGE  0.012 // 大号
#define FONT_SIZE_MEDIUM 0.011 // 中号
#define FONT_SIZE_NORMAL 0.01  // 标准
#define FONT_SIZE_SMALL  0.009 // 小号
#define FONT_SIZE_TINY   0.008 // 特小号
#define FONT_SIZE_MINI   0.006 // 迷你号


library UITextModule {
    // 定义共用的方法结构
    public module uiTextModule {

        // 设置标准字体大小
        // size: 1=迷你号, 2=特小号, 3=小号, 4=标准, 5=中号, 6=大号, 7=特大号
        method setFontSize (integer size) -> thistype {
            real fontSize = FONT_SIZE_NORMAL;
            if (!this.isExist()) {return this;}

            if (size == 1) {
                fontSize = FONT_SIZE_MINI;
            } else if (size == 2) {
                fontSize = FONT_SIZE_TINY;
            } else if (size == 3) {
                fontSize = FONT_SIZE_SMALL;
            } else if (size == 4) {
                fontSize = FONT_SIZE_NORMAL;
            } else if (size == 5) {
                fontSize = FONT_SIZE_MEDIUM;
            } else if (size == 6) {
                fontSize = FONT_SIZE_LARGE;
            } else if (size == 7) {
                fontSize = FONT_SIZE_HUGE;
            }

            DzFrameSetFont(ui, "fonts\\zt.ttf", fontSize, 0);
            return this;
        }

        // 设置对齐方式(前提要先定好大小,不然无处对齐)
        // align: 可以使用0-8的简单数字,或TEXT_ALIGN_*常量
        // 0=左上, 1=顶部居中, 2=右上
        // 3=左中, 4=居中, 5=右中
        // 6=左下, 7=底部居中, 8=右下
        method setAlign (integer align) -> thistype {
            integer finalAlign = align;

            if (!this.isExist()) {return this;}

            // 如果输入0-8,转换为对应的组合值
            if (align >= 0 && align <= 8) {
                if (align == 0) {
                    finalAlign = 9;       // 左上
                } else if (align == 1) {
                    finalAlign = 17;      // 顶部居中
                } else if (align == 2) {
                    finalAlign = 33;      // 右上
                } else if (align == 3) {
                    finalAlign = 10;      // 左中
                } else if (align == 4) {
                    finalAlign = 18;      // 居中
                } else if (align == 5) {
                    finalAlign = 34;      // 右中
                } else if (align == 6) {
                    finalAlign = 12;      // 左下
                } else if (align == 7) {
                    finalAlign = 20;      // 底部居中
                } else if (align == 8) {
                    finalAlign = 36;      // 右下
                }
            }

            DzFrameSetTextAlignment(ui, finalAlign);
            return this;
        }

        // 设置文本内容
        method setText (string text) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetText(ui,text);
            return this;
        }

    }

}

#undef FONT_SIZE_HUGE
#undef FONT_SIZE_LARGE
#undef FONT_SIZE_MEDIUM
#undef FONT_SIZE_NORMAL
#undef FONT_SIZE_SMALL
#undef FONT_SIZE_TINY
#undef FONT_SIZE_MINI


//! endzinc
#endif
