// 用原始地图测试
#undef OriginMapUnitTestMode
// 用空地图测试
#define EmptyMapUnitTestMode

#include "D:/War3/Library/War3Lib/Jass/utils/debug/Logger_Test.j"



#if defined(OriginMapUnitTestMode)

// lua_print: 正式地图

#else

// lua_print: 空白地图

#endif //

