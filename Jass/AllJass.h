#define CRNL <?='\n'?>

#define VERSION_UNITTEST  4 //单元测试
#define VERSION_MODELTEST 5 //模型测试

#define PLATFORM_DZ 1 //网易平台渠道
#define PLATFORM_11 2 //11平台渠道

// 当前构建版本
#define CURRENT_BUILD_VERSION VERSION_UNITTEST
// 当前的平台分包
#define CURRENT_BUILD_PLATFORM PLATFORM_DZ

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

#include "config/Log.h" // 输出日志配置
// #define StructMode // todo:结构体数量查看模式:用条件编译直接全部搞定

//函数入口
#if (CURRENT_BUILD_VERSION == VERSION_UNITTEST) // 单元测试
    #include "config/UnitTest.h"
#elif (CURRENT_BUILD_VERSION == VERSION_MODELTEST) // 模型测试
    #include "config/ModelTest.h"
#endif
