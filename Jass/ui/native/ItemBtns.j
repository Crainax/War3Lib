#ifndef ItemBtnsIncluded
#define ItemBtnsIncluded


#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc

// 原生的物品栏按钮和事件
// 控制物品栏按钮的进入,离开事件(点击和右键点击事件感觉并不需要)
library ItemBtns {

    // 物品栏按钮事件,整数代表物品栏位
    public type onItemBtns extends function(integer);

    // 物品栏按钮结构体形式
    public struct itemBtns []{
        static integer slot[]; // 使用slot表示物品栏位的UI,第1个是左上角,第6个是右下角

        private {
            static onItemBtns funcEnter      = 0 ; //接口保存
            static onItemBtns funcLeave      = 0 ; //接口保存
        }

        // 注册进入事件,就算没有物品,有物品栏的英雄也会触发这个事件
        static method onEnter (onItemBtns func) {
            funcEnter = func;
        }

        // 注册离开事件
        static method onLeave (onItemBtns func) {
            funcLeave = func;
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

            DzFrameSetScriptByCode(slot[1],FRAME_MOUSE_ENTER
                ,function () {if (funcEnter != 0) funcEnter.evaluate(1);},false);
            DzFrameSetScriptByCode(slot[1],FRAME_MOUSE_LEAVE
                ,function (){if (funcLeave != 0) funcLeave.evaluate(1);}, false);
            DzFrameSetScriptByCode(slot[2],FRAME_MOUSE_ENTER
                ,function () {if (funcEnter != 0) funcEnter.evaluate(2);},false);
            DzFrameSetScriptByCode(slot[2],FRAME_MOUSE_LEAVE
                ,function (){if (funcLeave != 0) funcLeave.evaluate(2);}, false);
            DzFrameSetScriptByCode(slot[3],FRAME_MOUSE_ENTER
                ,function () {if (funcEnter != 0) funcEnter.evaluate(3);},false);
            DzFrameSetScriptByCode(slot[3],FRAME_MOUSE_LEAVE
                ,function (){if (funcLeave != 0) funcLeave.evaluate(3);}, false);
            DzFrameSetScriptByCode(slot[4],FRAME_MOUSE_ENTER
                ,function () {if (funcEnter != 0) funcEnter.evaluate(4);},false);
            DzFrameSetScriptByCode(slot[4],FRAME_MOUSE_LEAVE
                ,function (){if (funcLeave != 0) funcLeave.evaluate(4);}, false);
            DzFrameSetScriptByCode(slot[5],FRAME_MOUSE_ENTER
                ,function () {if (funcEnter != 0) funcEnter.evaluate(5);},false);
            DzFrameSetScriptByCode(slot[5],FRAME_MOUSE_LEAVE
                ,function (){if (funcLeave != 0) funcLeave.evaluate(5);}, false);
            DzFrameSetScriptByCode(slot[6],FRAME_MOUSE_ENTER
                ,function () {if (funcEnter != 0) funcEnter.evaluate(6);},false);
            DzFrameSetScriptByCode(slot[6],FRAME_MOUSE_LEAVE
                ,function (){if (funcLeave != 0) funcLeave.evaluate(6);}, false);

        }

    }
}
//! endzinc

#endif