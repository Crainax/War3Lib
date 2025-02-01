#ifndef UTSpellDataIncluded
#define UTSpellDataIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "D:/War3/Library/War3Lib/Jass/data/ability/SpellData.j"

//! zinc

//自动生成的文件
library UTSpellData requires SpellData {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start
			}, function() {
			//end
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);
	}

	function TTestUTSpellData1 (player p) {}
	function TTestUTSpellData2 (player p) {}
	function TTestUTSpellData3 (player p) {}
	function TTestUTSpellData4 (player p) {}
	function TTestUTSpellData5 (player p) {}
	function TTestUTSpellData6 (player p) {}
	function TTestUTSpellData7 (player p) {}
	function TTestUTSpellData8 (player p) {}
	function TTestUTSpellData9 (player p) {}
	function TTestUTSpellData10 (player p) {}
	function TTestActUTSpellData1 (string str) {
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
			BJDebugMsg("[SpellData] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTSpellData1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTSpellData1(GetTriggerPlayer());
			else if(str == "s2") TTestUTSpellData2(GetTriggerPlayer());
			else if(str == "s3") TTestUTSpellData3(GetTriggerPlayer());
			else if(str == "s4") TTestUTSpellData4(GetTriggerPlayer());
			else if(str == "s5") TTestUTSpellData5(GetTriggerPlayer());
			else if(str == "s6") TTestUTSpellData6(GetTriggerPlayer());
			else if(str == "s7") TTestUTSpellData7(GetTriggerPlayer());
			else if(str == "s8") TTestUTSpellData8(GetTriggerPlayer());
			else if(str == "s9") TTestUTSpellData9(GetTriggerPlayer());
			else if(str == "s10") TTestUTSpellData10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
