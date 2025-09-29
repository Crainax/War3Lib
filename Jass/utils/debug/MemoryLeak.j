#ifndef MemoryLeakIncluded
#define MemoryLeakIncluded

//! zinc
/*
内存泄漏检测
*/
library MemoryLeak  {

	public trigger trMemoryLeak = null;

	//显示一下当前的泄露情况
	public function MemoryLeakShow () {
		TriggerEvaluate(trMemoryLeak);
	}

	function onInit ()  {
		Cheat("exec-lua:depends.debug.memory_leak"); //内存泄露检测
	}
}

//! endzinc
#endif
