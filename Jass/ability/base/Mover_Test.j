#ifndef UTMoverIncluded
#define UTMoverIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "D:/War3/Library/War3Lib/Jass/ability/base/Mover.j"

//! zinc

//自动生成的文件
library UTMover requires Mover {

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

	function TTestUTMover1 (player p) {}
	function TTestUTMover2 (player p) {}
	function TTestUTMover3 (player p) {}
	function TTestUTMover4 (player p) {}
	function TTestUTMover5 (player p) {}
	function TTestUTMover6 (player p) {}
	function TTestUTMover7 (player p) {}
	function TTestUTMover8 (player p) {}
	function TTestUTMover9 (player p) {}
	function TTestUTMover10 (player p) {}
	function TTestActUTMover1 (string str) {
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
			BJDebugMsg("[Mover] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTMover1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTMover1(GetTriggerPlayer());
			else if(str == "s2") TTestUTMover2(GetTriggerPlayer());
			else if(str == "s3") TTestUTMover3(GetTriggerPlayer());
			else if(str == "s4") TTestUTMover4(GetTriggerPlayer());
			else if(str == "s5") TTestUTMover5(GetTriggerPlayer());
			else if(str == "s6") TTestUTMover6(GetTriggerPlayer());
			else if(str == "s7") TTestUTMover7(GetTriggerPlayer());
			else if(str == "s8") TTestUTMover8(GetTriggerPlayer());
			else if(str == "s9") TTestUTMover9(GetTriggerPlayer());
			else if(str == "s10") TTestUTMover10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
