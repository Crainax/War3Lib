#ifndef UIExtendEventIncluded
#define UIExtendEventIncluded

#include "Crainax/ui/constants/UIConstants.j" // UI常量
#include "Crainax/core/table/Hash_UIDefine.j"

//! zinc
/*
扩展按下和右键事件
*/
library UIExtendEvent requires Hardware,UIHashTable,UILifeCycle {

    //UI的扩充事件回调事件(参数是Frame不是UI结构实例)
    public type uiEvent extends function(integer);

    boolean rcStartOnUI = false;  // 是否开始右键点击
    integer clickStartUI   = 0;      // 右键点击开始时的UI

    public module extendEvent {

        //注册按下事件,只适用于非Simple类型的
        method exLeftDown (uiEvent func)  -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_LEFT_DOWN,func);
            return this;
        }
        //注册抬起事件,只适用于非Simple类型的
        method exLeftUp (uiEvent func)  -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_LEFT_UP,func);
            return this;
        }

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

        // 下面这批不适用Simple的所以全部删除了
        // //注册右键按下事件
        // method exRightDown (uiEvent func)  -> thistype {
        //     if (!this.isExist()) {return this;}
        //     SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_RIGHT_DOWN,func);
        //     return this;
        // }
        // //注册右键抬起事件
        // method exRightUp (uiEvent func)  -> thistype {
        //     if (!this.isExist()) {return this;}
        //     SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_RIGHT_UP,func);
        //     return this;
        // }
        // //注册右键点击事件（精确判断）
        // method exRightClick (uiEvent func) -> thistype {
        //     if (!this.isExist()) {return this;}
        //     SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_RIGHT_CLICK,func);
        //     return this;
        // }
    }

    function onInit () {
        hardware.regLeftDownEvent(function () { //注册左键按下事件
            integer currentUI;
            uiEvent func;
            if (!DzIsMouseOverUI()) {return;}
            currentUI = DzGetMouseFocus();
            if (HaveSavedInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_LEFT_DOWN)) {
                func = LoadInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_LEFT_DOWN);
                func.evaluate(currentUI);
            }
        });
        hardware.regLeftUpEvent(function () { //注册左键抬起事件,在click事件之前触发
            integer currentUI;
            uiEvent func;
            if (!DzIsMouseOverUI()) {return;} //如果鼠标不在游戏内，就不响应该事件
            currentUI = DzGetMouseFocus();
            if (HaveSavedInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_LEFT_UP)) {
                func = LoadInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_LEFT_UP);
                func.evaluate(currentUI);
            }
        });
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
        // hardware.regRightDownEvent(function () { //注册右键按下事件
        //     integer currentUI;
        //     uiEvent func;
        //     if (!DzIsMouseOverUI()) {
        //         return;
        //     }
        //     currentUI = DzGetMouseFocus();

        //     if (HaveSavedInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_DOWN)) {
        //         func = LoadInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_DOWN);
        //         func.evaluate(currentUI);
        //     }

        //     // 新增的click判断逻辑
        //     rcStartOnUI = true;
        //     rcStartUI = currentUI;
        // });
        // hardware.regRightUpEvent(function () { //注册右键抬起事件
        //     integer currentUI;
        //     uiEvent func;
        //     if (!DzIsMouseOverUI()) {
        //         return;
        //     }
        //     currentUI = DzGetMouseFocus();

        //     if (HaveSavedInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_UP)) {
        //         func = LoadInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_UP);
        //         func.evaluate(currentUI);
        //     }

        //     // 新增的click判断逻辑
        //     if (rcStartOnUI && currentUI == rcStartUI) {
        //         if (HaveSavedInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_CLICK)) {
        //             func = LoadInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_CLICK);
        //             func.evaluate(currentUI);
        //         }
        //     }

        //     rcStartOnUI = false;
        //     rcStartUI = 0;
        // });
    }
}

//! endzinc
#endif
