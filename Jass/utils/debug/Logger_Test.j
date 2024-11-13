#ifndef UTLoggerIncluded
#define UTLoggerIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc
//==================================
// Logger测试模块
// version: 1.0
// author: 系统自动生成
// date: 2024/11/13
//
// 功能：测试Logger库的所有日志输出功能
// 测试指令：
// s1 - 测试全局日志输出(Trace/Debug/Info/Warn/Error)
// s2 - 测试指定玩家日志输出
// -a [msg] - 测试自定义消息的全局日志输出
// -b [msg] - 测试自定义消息的玩家日志输出
// 输出路径: "D:/Program Files (x86)/Warcraft III Frozen Throne/War3Lib/日志/"
//==================================
library UTLogger requires Logger {

	// 测试全局日志输出
	function TTestUTLogger1(player p) {
		Trace("这是一条追踪日志");
		Debug("这是一条调试日志");
		Info("这是一条信息日志");
		Warn("这是一条警告日志");
		Error("这是一条错误日志");
	}

	// 测试指定玩家日志输出
	function TTestUTLogger2(player p) {
		TraceToPlayer(p, "这是发送给玩家的追踪日志");
		DebugToPlayer(p, "这是发送给玩家的调试日志");
		InfoToPlayer(p, "这是发送给玩家的信息日志");
		WarnToPlayer(p, "这是发送给玩家的警告日志");
		ErrorToPlayer(p, "这是发送给玩家的错误日志");
	}

	// 其他测试函数预留
	function TTestUTLogger3(player p) {}
	function TTestUTLogger4(player p) {}
	function TTestUTLogger5(player p) {}
	function TTestUTLogger6(player p) {}
	function TTestUTLogger7(player p) {}
	function TTestUTLogger8(player p) {}
	function TTestUTLogger9(player p) {}
	function TTestUTLogger10(player p) {}

	// 处理带参数的测试命令
	function TTestActUTLogger1(string str) {
		player p = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i, num = 0, len = StringLength(str);
		string paramS[]; // 所有参数S
		integer paramI[]; // 所有参数I
		real paramR[]; // 所有参数R

		// 解析参数
		for (0 <= i <= len - 1) {
			if (SubString(str,i,i+1) == " ") {
				paramS[num] = SubString(str,0,i);
				paramI[num] = S2I(paramS[num]);
				paramR[num] = S2R(paramS[num]);
				num = num + 1;
				str = SubString(str,i + 1,len);
				len = StringLength(str);
				i = -1;
			}
		}
		paramS[num] = str;
		paramI[num] = S2I(paramS[num]);
		paramR[num] = S2R(paramS[num]);
		num = num + 1;

		// 测试自定义消息的全局日志输出
		if (paramS[0] == "a") {
			Trace(paramS[1]);
			Debug(paramS[1]);
			Info(paramS[1]);
			Warn(paramS[1]);
			Error(paramS[1]);
		}
		// 测试自定义消息的玩家日志输出
		else if (paramS[0] == "b") {
			TraceToPlayer(p, paramS[1]);
			DebugToPlayer(p, paramS[1]);
			InfoToPlayer(p, paramS[1]);
			WarnToPlayer(p, paramS[1]);
			ErrorToPlayer(p, paramS[1]);
		}

		p = null;
	}

	function onInit() {
		// 注册聊天事件处理器
		UnitTestRegisterChatEvent(function() {
			string str = GetEventPlayerChatString();
			integer i = 1;

			// 处理带参数的命令
			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTLogger1(SubStringBJ(str,2,StringLength(str)));
				return;
			}

			// 处理简单测试命令
			if (str == "s1") TTestUTLogger1(GetTriggerPlayer());
			else if(str == "s2") TTestUTLogger2(GetTriggerPlayer());
			else if(str == "s3") TTestUTLogger3(GetTriggerPlayer());
			else if(str == "s4") TTestUTLogger4(GetTriggerPlayer());
			else if(str == "s5") TTestUTLogger5(GetTriggerPlayer());
			else if(str == "s6") TTestUTLogger6(GetTriggerPlayer());
			else if(str == "s7") TTestUTLogger7(GetTriggerPlayer());
			else if(str == "s8") TTestUTLogger8(GetTriggerPlayer());
			else if(str == "s9") TTestUTLogger9(GetTriggerPlayer());
			else if(str == "s10") TTestUTLogger10(GetTriggerPlayer());
		});
	}
}
//! endzinc

#endif
