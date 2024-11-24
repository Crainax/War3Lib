#ifndef UIExtendEventIncluded
#define UIExtendEventIncluded

//! zinc
/*
扩展按下和右键事件
*/
library UIExtendEvent {

    public module extendEvent {

        method onMouseDown (code func)  -> thistype {
            if (!this.isExist()) {return this;}
            return this;
        }

        method onMouseRightDown (code func)  -> thistype {
            if (!this.isExist()) {return this;}
            return this;
        }
        method onMouseRightClick (code func)  -> thistype {
            if (!this.isExist()) {return this;}
            return this;
        }
        //注册按下事件
        static method onInit () {
            hardware.regLeftDownEvent(function () {
                integer currentUI;
                if (!DzIsMouseOverUI()) {return;} //如果鼠标不在游戏内，就不响应鼠标滚轮
                currentUI = DzGetMouseFocus();
                if (currentUI == null) {return;}
                if (currentUI.isExist()) {
                    currentUI.onLeftDown();
                }
            });
        }
    }
}

//! endzinc
#endif
