// 用原始地图测试
#undef OriginMapUnitTestMode
// 用空地图测试
#define EmptyMapUnitTestMode

#include "Jass/core/SyncBus_Test2.j"



#if defined(OriginMapUnitTestMode)

// lua_print: 正式地图

#else

// lua_print: 空白地图

#endif //
