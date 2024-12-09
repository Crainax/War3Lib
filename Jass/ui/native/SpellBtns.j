#ifndef SpellBtnsIncluded
#define SpellBtnsIncluded

//! zinc

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

// 原生的技能栏按钮和事件
// 控制技能栏按钮的进入,离开,点击还有右键点击事件
library SpellBtns requires Hardware,UIHashTable {

    public struct spellBtns {
        static integer grid [3][4];  // 使用grid表示技能格子Frame
        static uiBtn uis [3][4];     // uibtn成员

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
                    uis[row][col] = uiBtn.bindSimple(grid[row][col]);
                    uis[row][col].spEnter(function(integer frame) {
                        integer data = uiHashTable(frame).eventdata.get();
                        argsRow = (data - 1) / 4 + 1;
                        argsCol = ModuloInteger(data - 1,4) + 1;
                        TriggerEvaluate(trEnter);
                    });
                    uis[row][col].spLeave(function(integer frame) {
                        integer data = uiHashTable(frame).eventdata.get();
                        argsRow = (data - 1) / 4 + 1;
                        argsCol = ModuloInteger(data - 1,4) + 1;
                        TriggerEvaluate(trLeave);
                    });
                    uis[row][col].spClick(function(integer frame) {
                        integer data = uiHashTable(frame).eventdata.get();
                        argsRow = (data - 1) / 4 + 1;
                        argsCol = ModuloInteger(data - 1,4) + 1;
                        TriggerEvaluate(trClick);
                    });
                    uis[row][col].spRightClick(function(integer frame) {
                        integer data = uiHashTable(frame).eventdata.get();
                        argsRow = (data - 1) / 4 + 1;
                        argsCol = ModuloInteger(data - 1,4) + 1;
                        TriggerEvaluate(trRightClick);
                    });
                    uiHashTable(grid[row][col]).eventdata.bind(((row-1)*4)+col);
                }
            }
        }

    }
}
//! endzinc

#endif