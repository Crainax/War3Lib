#ifndef LoggerIncluded
#define LoggerIncluded

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
    public trigger logger_tr    = null;

    // 追踪级别日志(灰色),用于程序执行追踪
    public function Trace(string msg) {
        logger_msg   = msg;
        logger_level = 0;
        logger_p     = GetLocalPlayer();
		TriggerEvaluate(logger_tr);
    }

    // 调试级别日志(绿色),用于输出变量值等调试信息
    public function Debug(string msg) {
        logger_msg   = msg;
        logger_level = 1;
        logger_p     = GetLocalPlayer();
		TriggerEvaluate(logger_tr);
    }

    // 信息级别日志(白色),用于输出普通提示信息
    public function Info(string msg) {
        logger_msg   = msg;
        logger_level = 2;
        logger_p     = GetLocalPlayer();
		TriggerEvaluate(logger_tr);
    }

    // 警告级别日志(黄色),用于输出警告信息
    public function Warn(string msg) {
        logger_msg   = msg;
        logger_level = 3;
        logger_p     = GetLocalPlayer();
		TriggerEvaluate(logger_tr);
    }

    // 错误级别日志(红色),用于输出错误信息
    public function Error(string msg) {
        logger_msg   = msg;
        logger_level = 4;
        logger_p     = GetLocalPlayer();
		TriggerEvaluate(logger_tr);
    }

    // 向指定玩家输出追踪日志(灰色)
    public function TraceToPlayer(player p, string msg) {
        logger_msg   = msg;
        logger_level = 0;
        logger_p     = p;
		TriggerEvaluate(logger_tr);
    }

    // 向指定玩家输出调试日志(绿色)
    public function DebugToPlayer(player p, string msg) {
        logger_msg   = msg;
        logger_level = 1;
        logger_p     = p;
		TriggerEvaluate(logger_tr);
    }

    // 向指定玩家输出信息日志(白色)
    public function InfoToPlayer(player p, string msg) {
        logger_msg   = msg;
        logger_level = 2;
        logger_p     = p;
		TriggerEvaluate(logger_tr);
    }

    // 向指定玩家输出警告日志(黄色)
    public function WarnToPlayer(player p, string msg) {
        logger_msg   = msg;
        logger_level = 3;
        logger_p     = p;
		TriggerEvaluate(logger_tr);
    }

    // 向指定玩家输出错误日志(红色)
    public function ErrorToPlayer(player p, string msg) {
        logger_msg   = msg;
        logger_level = 4;
        logger_p     = p;
		TriggerEvaluate(logger_tr);
    }

    function onInit() {
        Cheat("exec-lua:depends.debug.logger"); //日志打印系统初始化
    }
}

//! endzinc
#endif