#ifndef UIExtendEventIncluded
#define UIExtendEventIncluded

#include "Crainax/core/table/Hash_UIDefine.j"

//! zinc
/*
扩展按下和右键事件
*/
library UIExtendEvent requires Hardware,UIHashTable {

    //UI的扩充事件回调事件(参数是Frame不是UI结构实例)
    public type uiEvent extends function(integer);

    public module extendEvent {

        //注册按下事件
        method exLeftDown (uiEvent func)  -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_LEFT_DOWN,func);
            return this;
        }
        //注册抬起事件
        method exLeftUp (uiEvent func)  -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_LEFT_UP,func);
            return this;
        }
        //注册右键按下事件
        method exRightDown (uiEvent func)  -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_RIGHT_DOWN,func);
            return this;
        }
        //注册右键抬起事件
        method exRightUp (uiEvent func)  -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_RIGHT_UP,func);
            return this;
        }
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
            integer currentUI;
            uiEvent func;
            if (!DzIsMouseOverUI()) {return;} //如果鼠标不在游戏内，就不响应该事件
            currentUI = DzGetMouseFocus();
            if (HaveSavedInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_DOWN)) {
                func = LoadInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_DOWN);
                func.evaluate(currentUI);
            }
        });
        hardware.regRightUpEvent(function () { //注册右键抬起事件
            integer currentUI;
            uiEvent func;
            if (!DzIsMouseOverUI()) {return;} //如果鼠标不在游戏内，就不响应该事件
            currentUI = DzGetMouseFocus();
            if (HaveSavedInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_UP)) {
                func = LoadInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_UP);
                func.evaluate(currentUI);
            }
        });
    }
}

//! endzinc
#endif
