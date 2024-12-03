#ifndef YDLuaIncluded
#define YDLuaIncluded

//! zinc
/*
原生Lua引擎非内置
*/
library YDLua {


    #define SetCameraBounds(a,b,c,d,e,f,g,h) initializeLua() CRNL call SetCameraBounds(a,b,c,d,e,f,g,h)

    // main 函数就初始化的
    public function initializeLua () -> integer {
        Cheat("exec-lua:plugin_main");
        return 0;
    }


    function onInit ()  {
        //在游戏开始0.0秒后再调用
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr,0.0);
        TriggerAddCondition(tr,Condition(function (){
            BJDebugMsg("调用了YDLua引擎");
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;
    }
}

//! endzinc
#endif
