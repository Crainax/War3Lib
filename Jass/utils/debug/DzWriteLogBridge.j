#ifndef DzWriteLogBridgeIncluded
#define DzWriteLogBridgeIncluded

//! zinc
/*
DzWriteLog Lua bridge.
*/
library DzWriteLogBridge requires YDLua {

	public trigger dzWriteLog_tr = null;
	public string dzWriteLog_msg = "";

	private boolean dzWriteLog_luaInitRequested = false;

	private function EnsureDzWriteLogLua() {
		if (!dzWriteLog_luaInitRequested) {
			dzWriteLog_luaInitRequested = true;
			#if defined(WAR3_INNER_JAPI)
			AbilityId("exec-lua:depends.debug.dz_write_log");
			#else
			Cheat("exec-lua:depends.debug.dz_write_log");
			#endif
		}
	}

	public function CrainaxDzWriteLog(string msg) {
		if (dzWriteLog_tr == null) {
			EnsureDzWriteLogLua();
		}
		dzWriteLog_msg = msg;
		if (dzWriteLog_tr != null) {
			TriggerEvaluate(dzWriteLog_tr);
		}
		dzWriteLog_msg = "";
	}

	function onInit() {
		EnsureDzWriteLogLua();
	}
}

//! endzinc
#endif
