#define CRNL <?='\n'?>  //因为这是二次wave的,所以这个宏定义得重定义一次

#ifndef YDLuaIncluded
#define YDLuaIncluded

//! zinc
/*
原生Lua引擎非内置
*/

// https://create.reckfeng.com/kkapidoc/#/menu_kkapi_japi kkapi的japi文档

library YDLua {

    #define SetCameraBounds(a,b,c,d,e,f,g,h) initializeLua() CRNL call SetCameraBounds(a,b,c,d,e,f,g,h)

    // main 函数就初始化的
    public function initializeLua () -> integer {
        #if defined(WAR3_INNER_JAPI)
        ExecuteFunc("DoNothing");
        StartCampaignAI(Player(PLAYER_NEUTRAL_AGGRESSIVE), "callback");
        ExecuteFunc("DoNothing");
        AbilityId("exec-lua:plugin_main");
        #else
        Cheat("exec-lua:plugin_main");
        #endif
        return 0;
    }
}

//! endzinc
#endif
