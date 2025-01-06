#ifndef UTUnitAttrIncluded
#define UTUnitAttrIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include

//! zinc

//自动生成的文件
library UTUnitAttr requires UnitAttr {

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

	function TTestUTUnitAttr1 (player p) {}
	function TTestUTUnitAttr2 (player p) {}
	function TTestUTUnitAttr3 (player p) {}
	function TTestUTUnitAttr4 (player p) {}
	function TTestUTUnitAttr5 (player p) {}
	function TTestUTUnitAttr6 (player p) {}
	function TTestUTUnitAttr7 (player p) {}
	function TTestUTUnitAttr8 (player p) {}
	function TTestUTUnitAttr9 (player p) {}
	function TTestUTUnitAttr10 (player p) {}
	function TTestActUTUnitAttr1 (string str) {
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
			BJDebugMsg("[UnitAttr] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitAttr1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitAttr1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitAttr2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitAttr3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitAttr4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitAttr5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitAttr6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitAttr7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitAttr8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitAttr9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitAttr10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
