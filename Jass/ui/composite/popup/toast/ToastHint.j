#ifndef ToastHintIncluded
#define ToastHintIncluded

#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j" // UI常量


//! zinc

/*
* 提示框动画库
*
* 创建一个带边框的小提示,向上移动渐隐
* - 移动效果: 缓入缓出
* - 透明度: 缓出
* - 支持异步/同步调用
*
* @requires UIBorder 边框组件
* @requires UIText 文本组件
* @requires UIAnimTimer 动画计时器
* @requires InchUtils 工具库
*/
library ToastHint requires UIBorder,UIText,UIAnimTimer,Hardware,EasingUtils {

    #define HINT_DURATION 150 // 持续时长(帧)
    #define HINT_MOVE_DISTANCE 0.05 // 向上移动距离
    #define UI_ABS_CENTER_X 0.4
    #define UI_ABS_CENTER_Y 0.3
    #define UI_ABS_RIGHT_X 0.8

    public struct toastHint {
        static thistype List[];     // 提示框列表
        static integer size = 0;    // 当前数量
        static uianim UIA = 0;      // 动画实例

        // 成员变量
        uiBorder bg;                // 背景框
        uiText text;               // 文本
        integer cd;                // 剩余时间
        real x;                    // 初始X坐标
        real y;                    // 初始Y坐标
        integer id;                // 实例ID

        STRUCT_SHARED_METHODS(toastHint)

        method onDestroy() {
            if(!this.isExist()) { return; }

            // 清理UI
            if(text != 0) { text.destroy(); }
            if(bg != 0) { bg.destroy(); }

            // 清理数据
            bg = 0;
            text = 0;
            cd = 0;

            // 从列表移除
            if(id != 0) {
                List[id] = List[size];
                List[id].id = id;
                size -= 1;
                id = 0;
            }

            // 停止动画
            if(size <= 0) {
                UIA.unreg();
                #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
                BJDebugMsg("停止了toastHint");
                #endif
            }
        }

        // 创建提示框(指定坐标)
        static method create(player p, string content, real x, real y) -> thistype {
            thistype this = 0;

            if(GetLocalPlayer() != p) { return 0; }

            this = thistype.allocate();

            // 保存初始坐标
            this.x = x;
            this.y = y;
            this.cd = HINT_DURATION;

            this.bg = uiBorder.createToolTips2(DzGetGameUI());

            // 创建文本
            this.text = uiText.create(this.bg.ui)
                .setAlign(4)
                .setText(content)
                .setAbsPoint(ANCHOR_BOTTOM, x, y);

            // 创建背景
            // this.bg.setPoint(ANCHOR_TOPLEFT, text.ui, ANCHOR_TOPLEFT, -0.005, 0.005)
            //     .setPoint(ANCHOR_BOTTOMRIGHT, text.ui, ANCHOR_BOTTOMRIGHT, 0.005, -0.005);
            this.bg.alignParent(text.ui,0.006);

            // 加入列表
            size += 1;
            List[size] = this;
            this.id = size;

            UIA.reg();
            return this;
        }

        // 创建提示框(鼠标位置)
        static method createAtMouse(player p, string content) -> thistype {
            return create(p, content, hardware.getMouseX(),hardware.getMouseY());
        }

        /**
        * 在技能栏图标位置创建提示
        * x: 列(1~4, 从左到右)
        * y: 行(1~3, 从上到下)
        *
        * 格子示例:
        * xxxx
        * xxxx
        * xxxx
        *
        * 例: 第二排第3个位置
        * toastHint.createAtSpell(p, 3, 2, "第二排第3格提示");
        */
        static method createAtSpell(player p, integer x, integer y, string content) -> thistype {
            real absX;
            real absY;

            if (x < 1 || x > 4 || y < 1 || y > 3) { return 0; }

            static if (LIBRARY_DIYBtnsSize) {
                // 与 SpellBtns.inside(row,col) 使用同一套技能按钮布局参数
                absX = UI_ABS_CENTER_X + (DIY_BTN_SPELL_PIVOT_X1 + (DIY_BTN_SPELL_PIVOT_X2 * x));
                absY = UI_ABS_CENTER_Y + (DIY_BTN_SPELL_PIVOT_Y1 - (DIY_BTN_SPELL_PIVOT_Y2 * y));
            } else {
                absX = UI_ABS_CENTER_X + (0.1935 + (0.0435 * x));
                absY = UI_ABS_CENTER_Y + (-0.142 - (0.044 * y));
            }

            return create(p, content, absX, absY);
        }

        static method createAtSpellPos(player p, integer pos, string content) -> thistype {
            integer row;
            integer col;
            if (pos < 1 || pos > 12) { pos = 1; }
            row = (pos - 1) / 4 + 1;
            col = ModuloInteger(pos - 1, 4) + 1;
            return createAtSpell(p, col, row, content);
        }

        /**
        * 在物品栏图标位置创建提示
        * pos: 槽位(1~6, 从左上到右下)
        * 1 2
        * 3 4
        * 5 6
        */
        static method createAtItem(player p, integer pos, string content) -> thistype {
            integer row;
            integer column;
            real absX;
            real absY;

            if (pos < 1 || pos > 6) { return 0; }

            // 与 ItemBtns.inside(pos) 使用同一套物品按钮布局参数
            row = (pos - 1) / 2 + 1;
            column = ModuloInteger(pos - 1,2) + 1;
            absX = UI_ABS_RIGHT_X + (-0.3108 + (0.04134 * column));
            absY = UI_ABS_CENTER_Y + (-0.165 - (0.0385 * row));
            return create(p, content, absX, absY);
        }

        static method onInit() {
            UIA = uianim.create(function() {
                integer i;
                thistype this;

                for(1 <= i <= size) {
                    this = List[i];
                    this.cd -= 1;

                    // 更新位置和透明度
                    this.text.setAbsPoint(ANCHOR_BOTTOM, this.x,
                    this.y + HINT_MOVE_DISTANCE * EaseOutExpo(1.0 - I2R(this.cd) / HINT_DURATION));

                    // 同步更新透明度
                    this.bg.setAlpha(255 - R2I(255 * EaseInOutCubic(1.0 - I2R(this.cd) / HINT_DURATION)));
                    this.text.setAlpha(255 - R2I(255 * EaseInOutCubic(1.0 - I2R(this.cd) / HINT_DURATION)));

                    // 检查是否结束
                    if(this.cd <= 0) {
                        this.destroy();
                        i -= 1;
                    }
                }
            });
        }
    }
}

//! endzinc

#endif
