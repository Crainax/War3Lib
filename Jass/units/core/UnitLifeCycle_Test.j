#ifndef UTUnitLifeCycleIncluded
#define UTUnitLifeCycleIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUnitLifeCycle requires UnitLifeCycle {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start
			}, function() {
			//end
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
			//unitLifeCycle
		},null);
	}

	unit u = null;
	function TTestUTUnitLifeCycle1 (player p) {
		u = CreateUnit(GetOwningPlayer(GetSpellAbilityUnit()),'uyan',GetUnitX(GetSpellAbilityUnit()),GetUnitY(GetSpellAbilityUnit()),0);
	}
	function TTestUTUnitLifeCycle2 (player p) {
		RemoveUnit(u);
	}
	function TTestUTUnitLifeCycle3 (player p) {}
	function TTestUTUnitLifeCycle4 (player p) {}
	function TTestUTUnitLifeCycle5 (player p) {}
	function TTestUTUnitLifeCycle6 (player p) {}
	function TTestUTUnitLifeCycle7 (player p) {}
	function TTestUTUnitLifeCycle8 (player p) {}
	function TTestUTUnitLifeCycle9 (player p) {}
	function TTestUTUnitLifeCycle10 (player p) {}
	function TTestActUTUnitLifeCycle1 (string str) {
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
			BJDebugMsg("[UnitLifeCycle] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitLifeCycle1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitLifeCycle1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitLifeCycle2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitLifeCycle3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitLifeCycle4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitLifeCycle5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitLifeCycle6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitLifeCycle7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitLifeCycle8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitLifeCycle9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitLifeCycle10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
