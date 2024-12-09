#ifndef UISimpleEventIncluded
#define UISimpleEventIncluded

#include "Crainax/ui/constants/UIConstants.j" // UI常量
#include "Crainax/core/table/Hash_UIDefine.j" // UI哈希表键值定义


//! zinc
/*
另一种形式的事件系统
只要用了这里的任一方法,enter和leave都要用这里的不能用普通的了
*/
library UISimpleEvent requires UIEventModule,UILifeCycle {

    public type uiEvent extends function(integer);

    boolean rcStartOnUI = false;  // 是否开始右键点击
    integer clickStartUI   = 0;      // 右键点击开始时的UI

    //原生UI的事件
    public module simpleEvent {
        // 鼠标进入事件(右键前提强化版)
        method spEnter (uiEvent fun) -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_SIMPLE_EVENT_ENTER,fun);
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_ENTER,function () {
                integer frame = DzGetTriggerUIEventFrame();
                uiEvent func;
                clickStartUI = frame; //用于记录右键信息
                if (HaveSavedInteger(HASH_UI,frame,HASH_KEY_UI_SIMPLE_EVENT_ENTER)) {
                    func = LoadInteger(HASH_UI,frame,HASH_KEY_UI_SIMPLE_EVENT_ENTER);
                    func.evaluate(frame);
                }
            },false);
            return this;
        }
        // 鼠标离开事件(右键前提强化版)
        method spLeave (uiEvent fun) -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_SIMPLE_EVENT_LEAVE,fun);
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_LEAVE,function () {
                integer frame = DzGetTriggerUIEventFrame();
                uiEvent func;
                clickStartUI = 0; //用于记录右键信息
                if (HaveSavedInteger(HASH_UI,frame,HASH_KEY_UI_SIMPLE_EVENT_LEAVE)) {
                    func = LoadInteger(HASH_UI,frame,HASH_KEY_UI_SIMPLE_EVENT_LEAVE);
                    func.evaluate(frame);
                }
            },false);
            return this;
        }

        // 鼠标点击事件,其实这个不是必须项,只是为了统一写法硬加的
        method spClick (uiEvent fun) -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_SIMPLE_EVENT_CLICK,fun);
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_DOWN,function () {
                integer frame = DzGetTriggerUIEventFrame();
                uiEvent func;
                if (HaveSavedInteger(HASH_UI,frame,HASH_KEY_UI_SIMPLE_EVENT_CLICK)) {
                    func = LoadInteger(HASH_UI,frame,HASH_KEY_UI_SIMPLE_EVENT_CLICK);
                    func.evaluate(frame);
                }
            },false);
            return this;
        }

        // 鼠标右键点击事件
        method spRightClick (uiEvent fun) -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_SIMPLE_EVENT_RIGHT_CLICK,fun);
            return this;
        }
    }

    function onInit () {
        hardware.regRightDownEvent(function () { //注册右键按下事件
            if (clickStartUI != 0) {
                rcStartOnUI = true;
            }
            // 新增的click判断逻辑
        });
        hardware.regRightUpEvent(function () { //注册右键抬起事件
            uiEvent func;
            // 新增的click判断逻辑
            if (rcStartOnUI && clickStartUI != 0) {
                if (HaveSavedInteger(HASH_UI,clickStartUI,HASH_KEY_UI_SIMPLE_EVENT_RIGHT_CLICK)) {
                    func = LoadInteger(HASH_UI,clickStartUI,HASH_KEY_UI_SIMPLE_EVENT_RIGHT_CLICK);
                    func.evaluate(clickStartUI);
                }
            }

            rcStartOnUI = false;
        });
        // UI销毁时如果鼠标正在上面,则触发一次离开事件,不然会引进只进不出的错误
        uiLifeCycle.registerDestroy(function (){
            integer ui = uiLifeCycle.agrsFrame;
            uiEvent func;
            if (clickStartUI == ui && HaveSavedInteger(HASH_UI,ui,HASH_KEY_UI_SIMPLE_EVENT_LEAVE)) {
                func = LoadInteger(HASH_UI,clickStartUI,HASH_KEY_UI_SIMPLE_EVENT_LEAVE);
                func.evaluate(clickStartUI);
            }
            clickStartUI = 0;
        });
    }

}

//! endzinc
#endif
