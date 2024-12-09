#ifndef ItemBtnsIncluded
#define ItemBtnsIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc

// 原生的物品栏按钮和事件
// 控制物品栏按钮的进入,离开事件(点击和右键点击事件感觉并不需要)
library ItemBtns {

    // 物品栏按钮结构体形式
    public struct itemBtns []{
        static integer slot[]; // 使用slot表示物品栏位的UI,第1个是左上角,第6个是右下角

        static integer argsPos = 0; // 回调参数:触发位置

        // 私有变量
        private {
            static trigger trEnter = null;
            static trigger trLeave = null;
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

        static method outside (integer pos) {
            DzFrameClearAllPoints(slot[pos]);
            DzFrameSetAbsolutePoint(slot[pos],ANCHOR_BOTTOMLEFT,-1.0,0);
        }

        static method inside (integer pos) {
            integer row,column;
            row = ModuloInteger(pos - 1,2) + 1;
            column = (pos - 1) / 2 + 1;
            DzFrameClearAllPoints(slot[pos]);
            DzFrameSetPoint(slot[pos], ANCHOR_CENTER, DzGetGameUI(), ANCHOR_RIGHT, - 0.3078 + (0.0398 * row), - 0.165 - (0.0385 * column));
        }

        static method onInit() {
            integer i;
            for(1 <= i <= 6) {
                slot[i] = DzFrameGetItemBarButton(i - 1);
            }

            #define REGISTER_ITEMBTNS_EVENT(pos) \
            DzFrameSetScriptByCode(slot[pos],FRAME_MOUSE_ENTER CRNL \
                ,function () {if (trEnter != null) {argsPos = pos;TriggerEvaluate(trEnter);}},false); CRNL \
            DzFrameSetScriptByCode(slot[pos],FRAME_MOUSE_LEAVE CRNL \
                ,function () {if (trLeave != null) {argsPos = pos;TriggerEvaluate(trLeave);}},false);

            REGISTER_ITEMBTNS_EVENT(1)
            REGISTER_ITEMBTNS_EVENT(2)
            REGISTER_ITEMBTNS_EVENT(3)
            REGISTER_ITEMBTNS_EVENT(4)
            REGISTER_ITEMBTNS_EVENT(5)
            REGISTER_ITEMBTNS_EVENT(6)

            #undef REGISTER_ITEMBTNS_EVENT
        }

    }
}
//! endzinc

#endif