#ifndef UTSpellEventIncluded
#define UTSpellEventIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTSpellEvent requires SpellEvent {

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

	function TTestUTSpellEvent1 (player p) {
		//TriggerSpellEvent
	}
	function TTestUTSpellEvent2 (player p) {}
	function TTestUTSpellEvent3 (player p) {}
	function TTestUTSpellEvent4 (player p) {}
	function TTestUTSpellEvent5 (player p) {}
	function TTestUTSpellEvent6 (player p) {}
	function TTestUTSpellEvent7 (player p) {}
	function TTestUTSpellEvent8 (player p) {}
	function TTestUTSpellEvent9 (player p) {}
	function TTestUTSpellEvent10 (player p) {}
	function TTestActUTSpellEvent1 (string str) {
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
			BJDebugMsg("[SpellEvent] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTSpellEvent1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTSpellEvent1(GetTriggerPlayer());
			else if(str == "s2") TTestUTSpellEvent2(GetTriggerPlayer());
			else if(str == "s3") TTestUTSpellEvent3(GetTriggerPlayer());
			else if(str == "s4") TTestUTSpellEvent4(GetTriggerPlayer());
			else if(str == "s5") TTestUTSpellEvent5(GetTriggerPlayer());
			else if(str == "s6") TTestUTSpellEvent6(GetTriggerPlayer());
			else if(str == "s7") TTestUTSpellEvent7(GetTriggerPlayer());
			else if(str == "s8") TTestUTSpellEvent8(GetTriggerPlayer());
			else if(str == "s9") TTestUTSpellEvent9(GetTriggerPlayer());
			else if(str == "s10") TTestUTSpellEvent10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
