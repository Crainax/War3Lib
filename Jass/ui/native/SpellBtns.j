#ifndef SpellBtnsIncluded
#define SpellBtnsIncluded

//! zinc

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量
#include "Crainax/config/config.h" // 配置

// 原生的技能栏按钮和事件
// 控制技能栏按钮的进入,离开,点击还有右键点击事件
library SpellBtns requires Hardware,UIHashTable,Icon,UILayer {

    public struct spellBtns {
        static integer grid [3][4];  // 使用grid表示技能格子Frame
        static icon icons [3][4];

        static integer argsRow = 0; // 回调参数:行
        static integer argsCol = 0; // 回调参数:列

        private {
            static uiImage shadeImg = 0;  //技能栏大暗遮罩,用于右键表示
            static uiBtn shadeBtn   = 0;  //技能栏大暗遮罩,用于右键表示

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
            static if (LIBRARY_DIYBtnsSize) { // 自定义技能栏按钮大小
                DzFrameSetPoint(grid[row][col], ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, DIY_BTN_SPELL_PIVOT_X1 + (DIY_BTN_SPELL_PIVOT_X2 * col), DIY_BTN_SPELL_PIVOT_Y1 - (DIY_BTN_SPELL_PIVOT_Y2 * row));
            } else {
                DzFrameSetPoint(grid[row][col], ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.1935 + (0.0435 * col), -0.142 - (0.044 * row));
            }
        }

        // 显示或隐藏遮罩
        static method showShade (boolean show) {
            if (!shadeImg.isExist()) {
                shadeImg = uiImage.create(uilayer.lv[1])
                    .setSize(0.02,0.02)
                    .setTexture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp");
            }
            if (!shadeBtn.isExist()) {
                shadeBtn = uiBtn.createSimple(DzFrameGetParent(spellBtns.grid[3][4])) //这样也没用,全都挡不住,但是全能hover
                    .setPoint(ANCHOR_TOPLEFT, shadeImg.ui, ANCHOR_TOPLEFT, 0.0, 0.0)
                    .setPoint(ANCHOR_BOTTOMRIGHT, shadeImg.ui, ANCHOR_BOTTOMRIGHT, 0.0, 0.0)
                    .onMouseEnter(function() {BJDebugMsg("enter"); })
                    .onMouseLeave(function() {BJDebugMsg("leave"); })
                    .onMouseClick(function() {BJDebugMsg("click"); });
            }

            if (show) {
                shadeImg.clearPoint()
                    .setPoint(ANCHOR_TOPLEFT, grid[1][1], ANCHOR_TOPLEFT, 0.0, 0.0)
                    .setPoint(ANCHOR_BOTTOMRIGHT, grid[3][4], ANCHOR_BOTTOMRIGHT, 0.0, 0.0);
            } else {
                shadeImg.clearPoint()
                    .setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, -0.8, 0.6);
            }
            SetPlayerAbilityAvailable(GetLocalPlayer(),'AHbz',false); //随便用一个技能也可以,刷新一下
            SetPlayerAbilityAvailable(GetLocalPlayer(),'AHbz',true);
        }

        // 初始化
        static method onInit() {
            integer row;
            integer col;
            uiBtn btn;
            for(1 <= row <= 3) {
                for(1 <= col <= 4) {
                    grid[row][col] = DzFrameGetCommandBarButton(row-1, col-1);
                    btn = uiBtn.bindCreated(grid[row][col]);
                    btn.spEnter(function(integer frame) {
                        integer data = uiHashTable(frame).eventdata.get();
                        argsRow = (data - 1) / 4 + 1;
                        argsCol = ModuloInteger(data - 1,4) + 1;
                        TriggerEvaluate(trEnter);
                    });
                    btn.spLeave(function(integer frame) {
                        integer data = uiHashTable(frame).eventdata.get();
                        argsRow = (data - 1) / 4 + 1;
                        argsCol = ModuloInteger(data - 1,4) + 1;
                        TriggerEvaluate(trLeave);
                    });
                    btn.spClick(function(integer frame) {
                        integer data = uiHashTable(frame).eventdata.get();
                        argsRow = (data - 1) / 4 + 1;
                        argsCol = ModuloInteger(data - 1,4) + 1;
                        TriggerEvaluate(trClick);
                    });
                    btn.spRightClick(function(integer frame) {
                        integer data = uiHashTable(frame).eventdata.get();
                        argsRow = (data - 1) / 4 + 1;
                        argsCol = ModuloInteger(data - 1,4) + 1;
                        TriggerEvaluate(trRightClick);
                    });

                    icons[row][col] = icon.create(uilayer.lv[1]);
                    static if (LIBRARY_DIYBtnsSize) { // 自定义技能栏按钮大小
                        icons[row][col].setSize(DIY_BTN_SPELL_SIZE, DIY_BTN_SPELL_SIZE);
                    } else {
                        icons[row][col].setSize(SIZE_ORIGIN_UI_SPELL, SIZE_ORIGIN_UI_SPELL);
                    }
                    icons[row][col].setPoint(ANCHOR_CENTER, grid[row][col], ANCHOR_CENTER, 0.0, 0.0)
                        .setTexture(UI_STRING_PATH_BLANK);
                    icons[row][col].clickBtn = btn;
                    uiHashTable(grid[row][col]).eventdata.bind(((row-1)*4)+col);
                }
            }
        }

    }
}
//! endzinc

#endif