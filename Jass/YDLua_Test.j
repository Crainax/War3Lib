#ifndef UTYDLuaIncluded
#define UTYDLuaIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "D:/War3/Library/War3Lib/Jass/YDLua.j"

//! zinc

//自动生成的文件
library UTYDLua requires YDLua {

	public integer testhaha = 100;
	public code cccc;

	function TTestUTYDLua1 (player p) {
		BJDebugMsg("测试YDLua的输出");
	}
	function TTestUTYDLua2 (player p) {
		CreateUnit(Player(0),'uyan',0,0,0);
	}

	function bbb() {
		DoNothing();
	}

	function TTestUTYDLua3 (player p) {
		TriggerEvaluate(trr);
	}
	function TTestUTYDLua4 (player p) {}
	function TTestUTYDLua5 (player p) {}
	function TTestUTYDLua6 (player p) {}
	function TTestUTYDLua7 (player p) {}
	function TTestUTYDLua8 (player p) {}
	function TTestUTYDLua9 (player p) {}
	function TTestUTYDLua10 (player p) {}
	function TTestActUTYDLua1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R
		for (0 <= i <= len - 1) {
			if (SubString(str,i,i+1) == " ") {
				paramS[num]= SubString(str,0,i);
				paramI[num]= S2I(paramS[num]);
				paramR[num]= S2R(paramS[num]);
				num = num + 1;
				str = SubString(str,i + 1,len);
				len = StringLength(str);
				i = -1;
			}
		}
		paramS[num]= str;
		paramI[num]= S2I(paramS[num]);
		paramR[num]= S2R(paramS[num]);
		num = num + 1;

		if (paramS[0] == "a") {

		} else if (paramS[0] == "b") {

		}

		p = null;
	}

	public trigger trr = null;
	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEvent(tr,0.5,false);
		TriggerAddCondition(tr,Condition(function (){
			Cheat("exec-lua:depends.test");
			BJDebugMsg("[YDLua] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTYDLua1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTYDLua1(GetTriggerPlayer());
			else if(str == "s2") TTestUTYDLua2(GetTriggerPlayer());
			else if(str == "s3") TTestUTYDLua3(GetTriggerPlayer());
			else if(str == "s4") TTestUTYDLua4(GetTriggerPlayer());
			else if(str == "s5") TTestUTYDLua5(GetTriggerPlayer());
			else if(str == "s6") TTestUTYDLua6(GetTriggerPlayer());
			else if(str == "s7") TTestUTYDLua7(GetTriggerPlayer());
			else if(str == "s8") TTestUTYDLua8(GetTriggerPlayer());
			else if(str == "s9") TTestUTYDLua9(GetTriggerPlayer());
			else if(str == "s10") TTestUTYDLua10(GetTriggerPlayer());
		});


	}

}
//! endzinc

#endif
