#ifndef UTMonsterIncluded
#define UTMonsterIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include

//! zinc

//自动生成的文件
library UTMonster requires Monster {

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

	function TTestUTMonster1 (player p) {}
	function TTestUTMonster2 (player p) {}
	function TTestUTMonster3 (player p) {}
	function TTestUTMonster4 (player p) {}
	function TTestUTMonster5 (player p) {}
	function TTestUTMonster6 (player p) {}
	function TTestUTMonster7 (player p) {}
	function TTestUTMonster8 (player p) {}
	function TTestUTMonster9 (player p) {}
	function TTestUTMonster10 (player p) {}
	function TTestActUTMonster1 (string str) {
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
			BJDebugMsg("[Monster] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTMonster1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTMonster1(GetTriggerPlayer());
			else if(str == "s2") TTestUTMonster2(GetTriggerPlayer());
			else if(str == "s3") TTestUTMonster3(GetTriggerPlayer());
			else if(str == "s4") TTestUTMonster4(GetTriggerPlayer());
			else if(str == "s5") TTestUTMonster5(GetTriggerPlayer());
			else if(str == "s6") TTestUTMonster6(GetTriggerPlayer());
			else if(str == "s7") TTestUTMonster7(GetTriggerPlayer());
			else if(str == "s8") TTestUTMonster8(GetTriggerPlayer());
			else if(str == "s9") TTestUTMonster9(GetTriggerPlayer());
			else if(str == "s10") TTestUTMonster10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
