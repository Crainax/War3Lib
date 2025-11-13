#ifndef SpellBtnsIncluded
#define SpellBtnsIncluded

//! zinc

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

// 原生的技能栏按钮和事件
// 控制技能栏按钮的进入,离开,点击还有右键点击事件
library SpellBtns requires Hardware,UIHashTable,Icon,UILayer,SpellUtils {

    public struct spellBtns {
        static integer grid [3][4];  // 使用grid表示技能格子Frame
        static icon icons [3][4];


        private {
            static integer argsCol = 0; // 回调参数:列
            static integer argsRow = 0; // 回调参数:行

            static uiImage shadeImg = 0;  //技能栏大暗遮罩,用于右键表示
            static uiBtn shadeBtn   = 0;  //技能栏大暗遮罩,用于右键表示

            static trigger trEnter      = null;   // 进入事件
            static trigger trLeave      = null;   // 离开事件
            static trigger trClick      = null;   // 点击事件
            static trigger trRightClick = null;   // 右键点击事件

            // 基于稳定能力值的事件（在 Enter 记录能力，Leave 置 0）
            static trigger trEnterAbility      = null;
            static trigger trLeaveAbility      = null;
            static trigger trClickAbility      = null;
            static trigger trRightClickAbility = null;

            // 当前悬停按钮的能力值（Enter 时记录，Leave 后置 0）
            static integer stableAbility = 0;
            static integer stableRow = 0;
            static integer stableCol = 0;

            static integer mousePos     = 0;      //当前鼠标所在的位置
            static boolean rcStartOnUI  = false;  // 是否开始右键点击
            static integer rcStartPos   = 0;      // 右键点击开始时的鼠标位置

            // 技能栏UI刷新（12槽）
            static trigger trAbilityRefresh = null; // 刷新界面显示的技能回调
            static integer lastAbilities[3][4];      // 记录上一次显示的能力值
        }

        //回调参数(事件当前的技能id)
        public static method getCallbackRow ()  -> integer {
            return argsRow;
        }
        public static method getCallbackColumn ()  -> integer {
            return argsCol;
        }
        public static method getCallbackAbility ()  -> integer {
            // 若当前扫描位置与悬停位置一致，则返回稳定能力；否则返回当前位置即时能力
            if (stableAbility != 0 && argsRow == stableRow && argsCol == stableCol) {
                return stableAbility;
            }
            return GetCurrentXYAbility(argsCol - 1, argsRow - 1);
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

        // ===== 能力稳定版回调注册（在 Enter 记录 ability，Leave 清 0） =====
        static method onEnterAbility (code func) {
            if (trEnterAbility == null) { trEnterAbility = CreateTrigger(); }
            TriggerAddCondition(trEnterAbility, Condition(func));
        }
        static method onLeaveAbility (code func) {
            if (trLeaveAbility == null) { trLeaveAbility = CreateTrigger(); }
            TriggerAddCondition(trLeaveAbility, Condition(func));
        }
        static method onClickAbility (code func) {
            if (trClickAbility == null) { trClickAbility = CreateTrigger(); }
            TriggerAddCondition(trClickAbility, Condition(func));
        }
        static method onRightClickAbility (code func) {
            if (trRightClickAbility == null) { trRightClickAbility = CreateTrigger(); }
            TriggerAddCondition(trRightClickAbility, Condition(func));
        }

        // 注册当前单位技能栏的UI刷新（12 槽检测变化）
        static method onAbilityUIChange (code func) {
            if (trAbilityRefresh == null) {
                trAbilityRefresh = CreateTrigger();
                hardware.regUpdateEvent(function() {
                    integer row; integer col; integer nowAbil; integer prevAbil;

                    // 若无监听者则无需执行
                    if (trAbilityRefresh == null) { return; }

                    // 遍历 3x4 技能槽
                    for (1 <= row <= 3) {
                        for (1 <= col <= 4) {
                            prevAbil = lastAbilities[row][col];
                            nowAbil  = GetCurrentXYAbility(col - 1, row - 1);

                            if (nowAbil != prevAbil) {
                                // 设置回调参数并触发
                                argsRow = row;
                                argsCol = col;
                                TriggerEvaluate(trAbilityRefresh);

                                // 覆盖记录
                                lastAbilities[row][col] = nowAbil;
                            }
                        }
                    }
                });
            }
            TriggerAddCondition(trAbilityRefresh, Condition(func));
        }

        // 清空指定玩家的技能栏记录，下一帧会触发 onAbilityUIChange 回调
        public static method clearLastAbilities (player p) {
            integer row; integer col;
            if (GetLocalPlayer() == p) {
                for (1 <= row <= 3) {
                    for (1 <= col <= 4) {
                        lastAbilities[row][col] = 0;
                    }
                }
            }
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
                        // 进入时记录稳定能力值，供 Click/RightClick/Leave 使用
                        stableAbility = GetCurrentXYAbility(argsCol-1, argsRow-1);
                        stableRow = argsRow;
                        stableCol = argsCol;
                        if (trEnter != null) { TriggerEvaluate(trEnter); }
                        if (trEnterAbility != null) { TriggerEvaluate(trEnterAbility); }
                    });
                    btn.spLeave(function(integer frame) {
                        integer data = uiHashTable(frame).eventdata.get();
                        argsRow = (data - 1) / 4 + 1;
                        argsCol = ModuloInteger(data - 1,4) + 1;
                        if (trLeave != null) { TriggerEvaluate(trLeave); }
                        if (trLeaveAbility != null) { TriggerEvaluate(trLeaveAbility); }
                        // 离开后清空稳定能力值
                        stableAbility = 0;
                        stableRow = 0;
                        stableCol = 0;
                    });
                    btn.spClick(function(integer frame) {
                        integer data = uiHashTable(frame).eventdata.get();
                        argsRow = (data - 1) / 4 + 1;
                        argsCol = ModuloInteger(data - 1,4) + 1;
                        if (trClick != null) { TriggerEvaluate(trClick); }
                        if (trClickAbility != null) { TriggerEvaluate(trClickAbility); }
                    });
                    btn.spRightClick(function(integer frame) {
                        integer data = uiHashTable(frame).eventdata.get();
                        argsRow = (data - 1) / 4 + 1;
                        argsCol = ModuloInteger(data - 1,4) + 1;
                        if (trRightClick != null) { TriggerEvaluate(trRightClick); }
                        if (trRightClickAbility != null) { TriggerEvaluate(trRightClickAbility); }
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