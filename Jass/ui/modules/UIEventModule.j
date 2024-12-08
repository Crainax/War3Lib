#ifndef UIEventModuleIncluded
#define UIEventModuleIncluded

#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
UI事件的共用方法
*/
library UIEventModule {
    // 定义共用的方法结构
    public module uiEventModule {
        // 鼠标进入事件
        method onMouseEnter (code fun) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_ENTER,fun,false);
            return this;
        }
        // 鼠标离开事件
        method onMouseLeave (code fun) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_LEAVE,fun,false);
            return this;
        }
        // 鼠标松开事件,和点击一样,基本可以当相同事件
        // method onMouseUp (code fun) -> thistype {
        //     if (!this.isExist()) {return this;}
        //     DzFrameSetScriptByCode(ui,FRAME_MOUSE_UP,fun,false);
        //     return this;
        // }
        // 鼠标点击事件(效果和FRAME_MOUSE_UP一样,注释掉上面这个了)
        method onMouseClick (code fun) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_DOWN,fun,false);
            return this;
        }
        // 鼠标滚轮事件
        method onMouseWheel (code fun) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_WHEEL,fun,false);
            return this;
        }
        // 鼠标双击事件
        method onMouseDoubleClick (code fun) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_DOUBLECLICK,fun,false);
            return this;
        }

        optional module extendEvent; //扩展事件
        optional module simpleEvent; //原生UI的事件
    }

}

//! endzinc
#endif
