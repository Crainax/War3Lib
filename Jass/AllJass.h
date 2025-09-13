#include "config/rewave.h"

#if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
    // 单元测试
    #define TestMode
    #undef GongceMode
    #define LOG_PRINT_LEVEL 6
    // lua_print: 单元测试
#elif (CURRENT_BUILD_VERSION == VERSION_MODELTEST)
    // 模型测试
    #define TestMode
    #undef GongceMode
    #define LOG_PRINT_LEVEL 6
    // lua_print: 模型测试
#endif

//这两条是用到YDWE函数就要导入的,没用到就不用导入
#include "Crainax/config/Log.h" // 输出日志配置

//函数入口
#if (CURRENT_BUILD_VERSION == VERSION_UNITTEST) // 单元测试
    #include "config/UnitTest.h"
#elif (CURRENT_BUILD_VERSION == VERSION_MODELTEST) // 模型测试
    #include "config/ModelTest.h"
#endif
