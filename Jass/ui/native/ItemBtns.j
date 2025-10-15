#ifndef ItemBtnsIncluded
#define ItemBtnsIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc

// 原生的物品栏按钮和事件
// 控制物品栏按钮的进入,离开事件(点击和右键点击事件感觉并不需要)
library ItemBtns requires Hardware,UIHashTable,Icon,UILayer,UnitSelect {

    // 物品栏按钮结构体形式
    public struct itemBtns []{
        static integer slot[]; // 使用slot表示物品栏位的UI,第1个是左上角,第6个是右下角
        static icon icons [];   // icon成员(非simple类型)-> 目前禁止getClickBtn搞其他东西,因为绑定的ClickBtn是Simple,其他全是非Simple
        static item callbackItem = null; // 回调参数:当前变化槽位对应的物品

        // 私有变量
        private {
            static integer argsPos = 0; // 回调参数:触发位置
            static uiImage shadeImg = 0;  //物品栏大暗遮罩,用于右键表示
            static uiBtn shadeBtn   = 0;  //物品栏大暗遮罩,用于右键表示

            static trigger trEnter = null;
            static trigger trLeave = null;

            static trigger trRefresh = null; //刷新界面显示的物品回调

            // 记录当前选择单位6个物品槽的上次状态
            static item lastItems[];

            // 英雄切换相关
            static unit lastSelectedUnit = null; // 上次选中的单位
            static boolean isMouseOverItemBar = false; // 鼠标是否在物品栏上
            static integer currentHoverPos = 0; // 当前悬停的位置
        }

        // 注册进入事件,就算没有物品,有物品栏的英雄也会触发这个事件
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

        // 获取回调参数:触发位置
        static method getCallbackPos() -> integer {
            return argsPos;
        }

        // 手动触发指定位置的leave和enter事件
        static method triggerLeaveEnter() {
            if (currentHoverPos < 1 || currentHoverPos > 6) { return; }

            // 先触发leave事件
            if (trLeave != null) {
                argsPos = currentHoverPos;
                TriggerEvaluate(trLeave);
            }

            // 再触发enter事件
            if (trEnter != null) {
                argsPos = currentHoverPos;
                TriggerEvaluate(trEnter);
            }
        }

        //注册当前单位物品的UI刷新
        static method onItemUIChange (code func) {
            if (trRefresh == null) {
                trRefresh = CreateTrigger();
                hardware.regUpdateEvent(function() { //用这个来监控物品的变化
                    integer i; unit u; item it; item prev;

                    // 若无监听者则无需执行
                    if (trRefresh == null) { return; }

                    // 当前选择的主单位（英雄/领袖）
                    u = DzGetSelectedLeaderUnit();

                    // 遍历6个物品槽，检测变化
                    for (1 <= i <= 6) {
                        prev = lastItems[i];
                        if (u != null) {
                            it = UnitItemInSlot(u, i - 1);
                        } else {
                            it = null;
                        }

                        if (it != prev) {
                            // 设置回调参数并触发
                            argsPos = i;
                            callbackItem = it;
                            TriggerEvaluate(trRefresh);

                            // 覆盖记录
                            lastItems[i] = it;
                        }
                    }

                    // 句柄置空
                    prev = null; it = null; u = null;
                });
            }
            TriggerAddCondition(trRefresh, Condition(func));
        }

        // 获取回调参数:变化的物品
        static method getCallbackItem() -> item {
            return callbackItem;
        }

        static method outside (integer pos) {
            DzFrameClearAllPoints(slot[pos]);
            DzFrameSetAbsolutePoint(slot[pos],ANCHOR_BOTTOMLEFT,-1.0,0);
        }

        static method inside (integer pos) {
            integer row,column;
            row = (pos - 1) / 2 + 1;
            column = ModuloInteger(pos - 1,2) + 1;
            DzFrameClearAllPoints(slot[pos]);
            DzFrameSetSize(slot[pos], SIZE_ORIGIN_UI_ITEM, SIZE_ORIGIN_UI_ITEM);
            DzFrameSetPoint(slot[pos], ANCHOR_CENTER, DzGetGameUI(), ANCHOR_RIGHT, - 0.3108 + (0.04134 * column), - 0.165 - (0.0385 * row));
        }

        // 显示或隐藏遮罩
        static method showShade (boolean show) {
            if (!shadeImg.isExist()) {
                shadeImg = uiImage.create(uilayer.lv[1])
                    .setSize(0.02,0.02)
                    .setTexture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp");
            }
            if (!shadeBtn.isExist()) {
                shadeBtn = uiBtn.createSimple(slot[1]) //这样也没用,全都挡不住,但是全能hover
                    .setPoint(ANCHOR_TOPLEFT, shadeImg.ui, ANCHOR_TOPLEFT, 0.0, 0.0)
                    .setPoint(ANCHOR_BOTTOMRIGHT, shadeImg.ui, ANCHOR_BOTTOMRIGHT, 0.0, 0.0);
            }

            if (show) {
                shadeImg.clearPoint()
                    .setPoint(ANCHOR_TOPLEFT, slot[1], ANCHOR_TOPLEFT, 0.0, 0.0)
                    .setPoint(ANCHOR_BOTTOMRIGHT, slot[6], ANCHOR_BOTTOMRIGHT, 0.0, 0.0);
            } else {
                shadeImg.clearPoint()
                    .setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, -0.8, 0.6);
            }
        }

        static method onInit() {
            integer i;
            uiBtn btn;
            for(1 <= i <= 6) {
                slot[i] = DzFrameGetItemBarButton(i - 1);
                btn = uiBtn.bindCreated(slot[i]);
                btn.onMouseEnter(function() {
                    integer frame = DzGetTriggerUIEventFrame();
                    argsPos = uiHashTable(frame).eventdata.get();
                    isMouseOverItemBar = true;
                    currentHoverPos = argsPos;
                    TriggerEvaluate(trEnter);
                });
                btn.onMouseLeave(function() {
                    integer frame = DzGetTriggerUIEventFrame();
                    argsPos = uiHashTable(frame).eventdata.get();
                    isMouseOverItemBar = false;
                    currentHoverPos = 0;
                    TriggerEvaluate(trLeave);
                });
                uiHashTable(slot[i]).eventdata.bind(i);
                icons[i] = icon.create(uilayer.lv[1])
                    .setSize(SIZE_ORIGIN_UI_ITEM, SIZE_ORIGIN_UI_ITEM)
                    .setPoint(ANCHOR_CENTER, slot[i], ANCHOR_CENTER, 0.0, 0.0)
                    .setTexture(UI_STRING_PATH_BLANK);
                icons[i].clickBtn = btn;
            }

            // 注册异步选择单位事件，处理英雄切换时的物品栏事件
            unitSelect.onAsync(function() {
                unit newUnit = unitSelect.args;

                // 如果鼠标在物品栏上且切换了单位，需要触发先leave再enter
                if (isMouseOverItemBar && newUnit != lastSelectedUnit && currentHoverPos > 0) {
                    itemBtns.triggerLeaveEnter();
                }

                lastSelectedUnit = newUnit;
                newUnit = null;
            });

        }

    }
}
//! endzinc

#endif