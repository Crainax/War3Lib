
#if (LOG_PRINT_LEVEL >= 1) // 打印致命错误信息
#define LogFatalCon(condition, message)   \
    if (condition)                        \
    {                                     \
        BJDebugMsg("[Fatal]:" + message); \
    }
#define LogFatal(message) BJDebugMsg("[Fatal]:" + message);
#else
#define LogFatalCon(condition, message)
#define LogFatal(message)
#endif

#if (LOG_PRINT_LEVEL >= 2) // 打印错误信息
#define LogErrorCon(condition, message)   \
    if (condition)                        \
    {                                     \
        BJDebugMsg("[Error]:" + message); \
    }
#define LogError(message) BJDebugMsg("[Error]:" + message);
#else
#define LogErrorCon(condition, message)
#define LogError(message)
#endif

#if (LOG_PRINT_LEVEL >= 3) // 打印警告信息
#define LogWarningCon(condition, message)   \
    if (condition)                          \
    {                                       \
        BJDebugMsg("[Warning]:" + message); \
    }
#define LogWarning(message) BJDebugMsg("[Warning]:" + message);
#else
#define LogWarningCon(condition, message)
#define LogWarning(message)
#endif

#if (LOG_PRINT_LEVEL >= 4) // 打印信息
#define LogInfoCon(condition, message)   \
    if (condition)                       \
    {                                    \
        BJDebugMsg("[Info]:" + message); \
    }
#define LogInfo(message) BJDebugMsg("[Info]:" + message);
#else
#define LogInfoCon(condition, message)
#define LogInfo(message)
#endif

#if (LOG_PRINT_LEVEL >= 5) // 打印调试信息
#define LogDebugCon(condition, message)   \
    if (condition)                        \
    {                                     \
        BJDebugMsg("[Debug]:" + message); \
    }
#define LogDebug(message) BJDebugMsg("[Debug]:" + message);
#else
#define LogDebugCon(condition, message)
#define LogDebug(message)
#endif

#if (LOG_PRINT_LEVEL >= 6) // 打印跟踪信息
#define LogTraceCon(condition, message)   \
    if (condition)                        \
    {                                     \
        BJDebugMsg("[Trace]:" + message); \
    }
#define LogTrace(message) BJDebugMsg("[Trace]:" + message);
#else
#define LogTraceCon(condition, message)
#define LogTrace(message)
#endif
