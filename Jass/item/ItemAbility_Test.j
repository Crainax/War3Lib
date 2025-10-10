#ifndef UTItemAbilityIncluded
#define UTItemAbilityIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "D:/War3/Library/War3Lib/Jass/item/ItemAbility.j"

//! zinc

//自动生成的文件
library UTItemAbility requires ItemAbility {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);
	}

	function TTestUTItemAbility1 (player p) {}
	function TTestUTItemAbility2 (player p) {}
	function TTestUTItemAbility3 (player p) {}
	function TTestUTItemAbility4 (player p) {}
	function TTestUTItemAbility5 (player p) {}
	function TTestUTItemAbility6 (player p) {}
	function TTestUTItemAbility7 (player p) {}
	function TTestUTItemAbility8 (player p) {}
	function TTestUTItemAbility9 (player p) {}
	function TTestUTItemAbility10 (player p) {}
	function TTestActUTItemAbility1 (string str) {
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
			BJDebugMsg("[ItemAbility] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTItemAbility1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTItemAbility1(GetTriggerPlayer());
			else if(str == "s2") TTestUTItemAbility2(GetTriggerPlayer());
			else if(str == "s3") TTestUTItemAbility3(GetTriggerPlayer());
			else if(str == "s4") TTestUTItemAbility4(GetTriggerPlayer());
			else if(str == "s5") TTestUTItemAbility5(GetTriggerPlayer());
			else if(str == "s6") TTestUTItemAbility6(GetTriggerPlayer());
			else if(str == "s7") TTestUTItemAbility7(GetTriggerPlayer());
			else if(str == "s8") TTestUTItemAbility8(GetTriggerPlayer());
			else if(str == "s9") TTestUTItemAbility9(GetTriggerPlayer());
			else if(str == "s10") TTestUTItemAbility10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
