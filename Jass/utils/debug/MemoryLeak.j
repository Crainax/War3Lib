#ifndef MemoryLeakIncluded
#define MemoryLeakIncluded

//! zinc
/*
内存泄漏检测
*/
library MemoryLeak  {

	public trigger trMemoryLeak = null;
	public boolean memoryLeakSilent = false;

	// 触发一次 Lua 侧内存统计；silent 为 true 时只写日志不刷屏。
	private function EvaluateMemoryLeak(boolean silent) {
		if (trMemoryLeak != null) {
			memoryLeakSilent = silent;
			TriggerEvaluate(trMemoryLeak);
			memoryLeakSilent = false;
		}
	}

	//显示一下当前的泄露情况
	public function MemoryLeakShow () {
		EvaluateMemoryLeak(false);
	}

	// 定时静默采样，用于持续记录运行期句柄数量。
	private function MemoryLeakPeriodicLog() {
		EvaluateMemoryLeak(true);
	}

	function onInit ()  {
		DzFixUnitEventMemoryLeak();
		Cheat("exec-lua:depends.debug.memory_leak"); //内存泄露检测
		TimerStart(CreateTimer(), 180.0, true, function MemoryLeakPeriodicLog);
	}
}

//! endzinc
#endif
