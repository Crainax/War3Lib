#ifndef {UnitTest}Included
#define {UnitTest}Included

// 用原始地图测试
#undef OriginMapUnitTestMode

#include

//! zinc

//自动生成的文件
library {UnitTest} requires LibraryName {

	function TTest{UnitTest}1 (player p) {}
	function TTest{UnitTest}2 (player p) {}
	function TTest{UnitTest}3 (player p) {}
	function TTest{UnitTest}4 (player p) {}
	function TTest{UnitTest}5 (player p) {}
	function TTest{UnitTest}6 (player p) {}
	function TTest{UnitTest}7 (player p) {}
	function TTest{UnitTest}8 (player p) {}
	function TTest{UnitTest}9 (player p) {}
	function TTest{UnitTest}10 (player p) {}
	function TTestAct{UnitTest}1 (string str) {
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

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[LibraryName] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestAct{UnitTest}1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTest{UnitTest}1(GetTriggerPlayer());
			else if(str == "s2") TTest{UnitTest}2(GetTriggerPlayer());
			else if(str == "s3") TTest{UnitTest}3(GetTriggerPlayer());
			else if(str == "s4") TTest{UnitTest}4(GetTriggerPlayer());
			else if(str == "s5") TTest{UnitTest}5(GetTriggerPlayer());
			else if(str == "s6") TTest{UnitTest}6(GetTriggerPlayer());
			else if(str == "s7") TTest{UnitTest}7(GetTriggerPlayer());
			else if(str == "s8") TTest{UnitTest}8(GetTriggerPlayer());
			else if(str == "s9") TTest{UnitTest}9(GetTriggerPlayer());
			else if(str == "s10") TTest{UnitTest}10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
