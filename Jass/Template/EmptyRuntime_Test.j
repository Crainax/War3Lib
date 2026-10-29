#ifndef UTEmptyRuntimeIncluded
#define UTEmptyRuntimeIncluded
// 可复用的空白测试入口：保留地图及 Lua 启动，不创建测试单位、UI 或聊天触发器。
#undef OriginMapUnitTestMode
#define EmptyMapUnitTestMode
//! zinc
library UTEmptyRuntime {
    function onInit() {
        BJDebugMsg("[EmptyRuntime] 空白测试已启动");
    }
}
//! endzinc
#endif
