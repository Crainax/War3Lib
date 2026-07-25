#ifndef LoggerIncluded
#define LoggerIncluded

#define LOGGER_TARGET_ALL -1
#define LOGGER_TARGET_NONE -2

//! zinc
//==================================
// 日志打印系统
// version: 1.0
// author: 系统自动生成
// date: 2024/3/21
//
// 功能：提供五个日志级别输出
// - TRACE(灰)：追踪调试用
// - DEBUG(绿)：调试信息用
// - INFO(白)：普通信息用
// - WARN(黄)：警告信息用
// - ERROR(红)：错误信息用
//
// 示例：
// call Info("普通信息")
// call Error(Player(0), "玩家1的错误")
//==================================
library Logger requires YDLua {

    public integer logger_level = 0;
    public string  logger_msg   = null;
    public player  logger_p     = null;
    public integer logger_target_pid = -1;
    public integer logger_important_depth = 0;
    public trigger logger_tr    = null;

    private boolean logger_luaInitRequested = false;

    private function EnsureLoggerLua() {
        if (!logger_luaInitRequested) {
            logger_luaInitRequested = true;
            Cheat("exec-lua:depends.debug.logger");
        }
    }

    private function Write(integer level, string msg, player p, integer targetPid) {
        EnsureLoggerLua();
        logger_msg = msg;
        logger_level = level;
        logger_p = p;
        logger_target_pid = targetPid;
        if (logger_tr != null) {
            TriggerEvaluate(logger_tr);
        }
        logger_msg = null;
        logger_p = null;
        logger_target_pid = LOGGER_TARGET_ALL;
    }

    private function TargetPid(player p) -> integer {
        if (p == null) {
            return LOGGER_TARGET_NONE;
        }
        return GetPlayerId(p);
    }

    public function CrainaxLogTrace(string msg) { Write(0, msg, null, LOGGER_TARGET_ALL); }
    public function CrainaxLogDebug(string msg) { Write(1, msg, null, LOGGER_TARGET_ALL); }
    public function CrainaxLogInfo(string msg) { Write(2, msg, null, LOGGER_TARGET_ALL); }
    public function CrainaxLogWarn(string msg) { Write(3, msg, null, LOGGER_TARGET_ALL); }
    public function CrainaxLogError(string msg) { Write(4, msg, null, LOGGER_TARGET_ALL); }

    // 追踪级别日志(灰色),用于程序执行追踪
    public function Trace(string msg) {
        Write(0, msg, null, LOGGER_TARGET_ALL);
    }

    // 调试级别日志(绿色),用于输出变量值等调试信息
    public function Debug(string msg) {
        Write(1, msg, null, LOGGER_TARGET_ALL);
    }

    // 信息级别日志(白色),用于输出普通提示信息
    public function Info(string msg) {
        Write(2, msg, null, LOGGER_TARGET_ALL);
    }

    // 警告级别日志(黄色),用于输出警告信息
    public function Warn(string msg) {
        Write(3, msg, null, LOGGER_TARGET_ALL);
    }

    // 错误级别日志(红色),用于输出错误信息
    public function Error(string msg) {
        Write(4, msg, null, LOGGER_TARGET_ALL);
    }

    // 向指定玩家输出追踪日志(灰色)
    public function TraceToPlayer(player p, string msg) {
        Write(0, msg, p, TargetPid(p));
    }

    // 向指定玩家输出调试日志(绿色)
    public function DebugToPlayer(player p, string msg) {
        Write(1, msg, p, TargetPid(p));
    }

    // 向指定玩家输出信息日志(白色)
    public function InfoToPlayer(player p, string msg) {
        Write(2, msg, p, TargetPid(p));
    }

    // 向指定玩家输出警告日志(黄色)
    public function WarnToPlayer(player p, string msg) {
        Write(3, msg, p, TargetPid(p));
    }

    // 向指定玩家输出错误日志(红色)
    public function ErrorToPlayer(player p, string msg) {
        Write(4, msg, p, TargetPid(p));
    }

    public function BeginImportantDisplayLog() {
        logger_important_depth = logger_important_depth + 1;
    }

    public function EndImportantDisplayLog() {
        if (logger_important_depth > 0) {
            logger_important_depth = logger_important_depth - 1;
        }
    }

    public function DisplayImportantTextToPlayer(player toPlayer, real x, real y, string message) {
        BeginImportantDisplayLog();
        DisplayTextToPlayer(toPlayer, x, y, message);
        EndImportantDisplayLog();
    }

    public function DisplayImportantTimedTextToPlayer(player toPlayer, real x, real y, real duration, string message) {
        BeginImportantDisplayLog();
        DisplayTimedTextToPlayer(toPlayer, x, y, duration, message);
        EndImportantDisplayLog();
    }

    function onInit() {
        EnsureLoggerLua();
    }
}

//! endzinc
#undef LOGGER_TARGET_ALL
#undef LOGGER_TARGET_NONE
#endif
