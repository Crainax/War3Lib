#ifndef DzWriteLogBridgeIncluded
#define DzWriteLogBridgeIncluded

//! zinc
/*
DzWriteLog Lua bridge.
*/
library DzWriteLogBridge requires YDLua {

	public trigger dzWriteLog_tr = null;
	public string dzWriteLog_msg = "";

	public function CrainaxDzWriteLog(string msg) {
		dzWriteLog_msg = msg;
		if (dzWriteLog_tr != null) {
			TriggerEvaluate(dzWriteLog_tr);
		}
		dzWriteLog_msg = "";
	}
}

//! endzinc
#endif
