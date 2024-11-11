#ifndef StructDetectorIncluded
#define StructDetectorIncluded

//! zinc
/*
内存泄漏检测
*/
library StructDetector requires InnerJapi {

	//显示一下当前的结构体统计情况
	public function StructShow () {
		GetTriggerUnit();
	}

	//添加要监控的结构体
	public function AddStructMonitor(string structName) {
		GetTriggerUnit();
	}

	//删除要监控的结构体
	public function RemoveStructMonitor(string structName) {
		GetTriggerUnit();
	}

	//定时记录结构体状态
	public function TimerStructRecord(real interval) {
		GetTriggerUnit();
	}

	function onInit ()  {
		AbilityId("exec-lua:depends.debug.struct_detector"); //内存泄露检测
	}
}

//! endzinc
#endif
