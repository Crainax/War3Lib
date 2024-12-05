#ifndef SpellBtnsIncluded
#define SpellBtnsIncluded

//! zinc

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

// 原生的技能栏按钮和事件
// 控制技能栏按钮的进入,离开,点击还有右键点击事件
library SpellBtns requires hardware{

    // 技能栏按钮事件,整数代表技能格子
    public type onSpellBtns extends function(integer,integer);

    public struct spellBtns {
        static integer grid [3][4]; // 使用grid表示技能格子

        private {
            static onSpellBtns funcEnter      = 0 ;     //接口保存
            static onSpellBtns funcLeave      = 0 ;     //接口保存
            static onSpellBtns funcClick      = 0 ;     //接口保存
            static onSpellBtns funcRightClick = 0 ;     //接口保存
            static integer mousePos           = 0;      //当前鼠标所在的位置
            static boolean rcStartOnUI        = false;  // 是否开始右键点击
            static integer rcStartPos         = 0;      // 右键点击开始时的鼠标位置
        }

        // 注册进入事件
        static method onEnter (onSpellBtns func) {
            funcEnter = func;
        }
        // 注册离开事件
        static method onLeave (onSpellBtns func) {
            funcLeave = func;
        }
        // 注册点击事件
        static method onClick (onSpellBtns func) {
            funcClick = func;
        }
        // 注册右键点击事件
        static method onRightClick (onSpellBtns func) {
            funcRightClick = func;
        }

        //判断鼠标是否在按钮里
        // static method isMouseIn (integer row,integer col) -> boolean {
        //     return IsMouseInRect(DzGetFrame(FRAME_GAME_UI,0),0,0,1,1);
        // }

        // 把技能按钮移出屏幕外
        static method outside (integer row,integer col) {
            DzFrameClearAllPoints(grid[row][col]);
            DzFrameSetAbsolutePoint(grid[row][col],ANCHOR_BOTTOMLEFT,-1.0,0);
        }

        // 把技能按钮移回应有的位置
        static method inside (integer row,integer col) {
            DzFrameClearAllPoints(grid[row][col]);
            DzFrameSetPoint(grid[row][col], ANCHOR_CENTER, DzGetGameUI(), ANCHOR_RIGHT, - 0.3078 + (0.0398 * row), - 0.165 - (0.0385 * column));
        }

        static method onInit() {
            integer row;
            integer col;
            for(1 <= row <= 3) {
                for(1 <= col <= 4) {
                    grid[row][col] = DzFrameGetCommandBarButton(row-1, col-1);
                }
            }

            #define SPELL_BTN_EVENT_MACRO(row,col) \
            DzFrameSetScriptByCode(grid[row][col],FRAME_MOUSE_ENTER,function () {mousePos = ((row-1)*4)+col;if(funcEnter != 0) funcEnter.evaluate(row,col);},false); CRNL \
            DzFrameSetScriptByCode(grid[row][col],FRAME_MOUSE_LEAVE,function () {mousePos = 0;if(funcLeave != 0) funcLeave.evaluate(row,col);},false); CRNL \
            DzFrameSetScriptByCode(grid[row][col],FRAME_MOUSE_DOWN,function () {if(funcClick != 0) funcClick.evaluate(row,col);},false); CRNL \

            SPELL_BTN_EVENT_MACRO(1,1)
            SPELL_BTN_EVENT_MACRO(1,2)
            SPELL_BTN_EVENT_MACRO(1,3)
            SPELL_BTN_EVENT_MACRO(1,4)
            SPELL_BTN_EVENT_MACRO(2,1)
            SPELL_BTN_EVENT_MACRO(2,2)
            SPELL_BTN_EVENT_MACRO(2,3)
            SPELL_BTN_EVENT_MACRO(2,4)
            SPELL_BTN_EVENT_MACRO(3,1)
            SPELL_BTN_EVENT_MACRO(3,2)
            SPELL_BTN_EVENT_MACRO(3,3)
            SPELL_BTN_EVENT_MACRO(3,4)

            #undef SPELL_BTN_EVENT_MACRO

            hardware.regRightDownEvent(function () { //注册右键按下事件
                if (mousePos >= 1 && mousePos <= 12) {
                    rcStartOnUI = true;
                    rcStartPos = mousePos;
                }
                // 新增的click判断逻辑
            });
            hardware.regRightUpEvent(function () { //注册右键抬起事件
                // 新增的click判断逻辑
                if (rcStartOnUI && mousePos == rcStartPos) {
                    if (funcRightClick != 0) {
                        funcRightClick.evaluate(mousePos);
                    }
                }

                rcStartOnUI = false;
                rcStartPos = 0;
            });
        }

    }
}
//! endzinc

#endif