#ifndef UITextFontDzMemoryIncluded
#define UITextFontDzMemoryIncluded

// 只给 UITextFontDzMemory 单测注入。排序上位于 YDLua.j 之后，用来取消 Lua 启动。
// 正式界面不要调用 DzFontResearchIsolate，也不要依赖这个文件。
#undef SetCameraBounds
#undef DzWriteLog
#define LoggerIncluded

library UITextFontDzMemory
    function DzFontResearchIsolate takes nothing returns nothing
    endfunction
endlibrary
#endif
