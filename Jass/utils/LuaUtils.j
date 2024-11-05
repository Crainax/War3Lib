#ifndef LuaUtilsIncluded
#define LuaUtilsIncluded

//! zinc
/*
Lua调用库
*/
library LuaUtils requires InnerJapi {

	//控制台打印东西
	public function Print (string s) {
		EXExecuteScript("print('"+s+"')");
	}
	//记录日志

	//显示一下当前的泄露情况
	public function MemoryLeakShow () {
		GetTriggerUnit();
	}

	//显示一下当前的结构体统计情况
	public function StructShow () {
		GetTriggerUnit();
	}

	//打开定时检测数据功能.写Log里
	public function OpenDetector () {
		AbilityId("exec-lua:Detector");
	}

	//LUA端已经HOOK,立马显示所有英雄的所有数据.
	public function DetectS () {
		GetTriggerUnit();
	}

	//文件读写
	function onInit () {
		AbilityId("exec-lua:Crainax"); //主函数
		AbilityId("exec-lua:MemoryLeak"); //内存泄露检测
		// EXExecuteScript("require \"IOUtils\""); //文件读写
	}

}

//! endzinc
#endif
