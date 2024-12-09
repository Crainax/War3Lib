#ifndef SpellBtnsIncluded
#define SpellBtnsIncluded

//! zinc

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

// 原生的技能栏按钮和事件
// 控制技能栏按钮的进入,离开,点击还有右键点击事件
library SpellBtns requires Hardware {

    public struct spellBtns {
        static integer grid [3][4]; // 使用grid表示技能格子Frame

        static integer argsRow = 0; // 回调参数:行
        static integer argsCol = 0; // 回调参数:列

        private {
            static trigger trEnter      = null;   // 进入事件
            static trigger trLeave      = null;   // 离开事件
            static trigger trClick      = null;   // 点击事件
            static trigger trRightClick = null;   // 右键点击事件

            static integer mousePos     = 0;      //当前鼠标所在的位置
            static boolean rcStartOnUI  = false;  // 是否开始右键点击
            static integer rcStartPos   = 0;      // 右键点击开始时的鼠标位置
        }

        // 注册进入事件
        static method onEnter (code func) {
            if (trEnter == null) {
                trEnter = CreateTrigger();
            }
            TriggerAddCondition(trEnter, Condition(func));
        }
        // 注册离开事件
        static method onLeave (code func) {
            if (trLeave == null) {
                trLeave = CreateTrigger();
            }
            TriggerAddCondition(trLeave, Condition(func));
        }
        // 注册点击事件
        static method onClick (code func) {
            if (trClick == null) {
                trClick = CreateTrigger();
            }
            TriggerAddCondition(trClick, Condition(func));
        }
        // 注册右键点击事件
        static method onRightClick (code func) {
            if (trRightClick == null) {
                trRightClick = CreateTrigger();
            }
            TriggerAddCondition(trRightClick, Condition(func));
        }

        // 把技能按钮移出屏幕外
        static method outside (integer row,integer col) {
            DzFrameClearAllPoints(grid[row][col]);
            DzFrameSetAbsolutePoint(grid[row][col],ANCHOR_BOTTOMLEFT,-1.0,0);
        }

        // 把技能按钮移回应有的位置
        static method inside (integer row,integer col) {
            DzFrameClearAllPoints(grid[row][col]);
            DzFrameSetPoint(grid[row][col], ANCHOR_CENTER, DzGetGameUI(), ANCHOR_RIGHT, - 0.3078 + (0.0398 * row), - 0.165 - (0.0385 * col));
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
            DzFrameSetScriptByCode(grid[row][col],FRAME_MOUSE_ENTER,function () {mousePos = ((row-1)*4)+col;if(trEnter != null) {argsRow = row;argsCol = col;TriggerEvaluate(trEnter);}},false); CRNL \
            DzFrameSetScriptByCode(grid[row][col],FRAME_MOUSE_LEAVE,function () {mousePos = 0;if(trLeave != null) {argsRow = row;argsCol = col;TriggerEvaluate(trLeave);}},false); CRNL \
            DzFrameSetScriptByCode(grid[row][col],FRAME_MOUSE_DOWN,function () {if(trClick != null) {argsRow = row;argsCol = col;TriggerEvaluate(trClick);}},false);

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
                    if (trRightClick != null) {
                        argsRow = (mousePos - 1) / 4 + 1;
                        argsCol = ModuloInteger(mousePos - 1,4) + 1;
                        TriggerEvaluate(trRightClick);
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