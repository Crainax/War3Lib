#ifndef MemoryLeakIncluded
#define MemoryLeakIncluded

//! zinc
/*
内存泄漏检测
*/
library MemoryLeak requires InnerJapi {

	//显示一下当前的泄露情况
	public function MemoryLeakShow () {
		GetTriggerUnit();
	}

    function onInit ()  {
		AbilityId("exec-lua:depends.debug.memory_leak"); //内存泄露检测
    }
}

//! endzinc
#endif
