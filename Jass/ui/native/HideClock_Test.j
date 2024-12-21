#ifndef UTHideClockIncluded
#define UTHideClockIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTHideClock requires UnitTestFramwork {

	function TTestUTHideClock1 (player p) {
		//HideClock() //隐藏模型  注释在代码里就行了
	}
	function TTestUTHideClock2 (player p) {}
	function TTestUTHideClock3 (player p) {}
	function TTestUTHideClock4 (player p) {}
	function TTestUTHideClock5 (player p) {}
	function TTestUTHideClock6 (player p) {}
	function TTestUTHideClock7 (player p) {}
	function TTestUTHideClock8 (player p) {}
	function TTestUTHideClock9 (player p) {}
	function TTestUTHideClock10 (player p) {}
	function TTestActUTHideClock1 (string str) {
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
			BJDebugMsg("[HideClock] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTHideClock1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTHideClock1(GetTriggerPlayer());
			else if(str == "s2") TTestUTHideClock2(GetTriggerPlayer());
			else if(str == "s3") TTestUTHideClock3(GetTriggerPlayer());
			else if(str == "s4") TTestUTHideClock4(GetTriggerPlayer());
			else if(str == "s5") TTestUTHideClock5(GetTriggerPlayer());
			else if(str == "s6") TTestUTHideClock6(GetTriggerPlayer());
			else if(str == "s7") TTestUTHideClock7(GetTriggerPlayer());
			else if(str == "s8") TTestUTHideClock8(GetTriggerPlayer());
			else if(str == "s9") TTestUTHideClock9(GetTriggerPlayer());
			else if(str == "s10") TTestUTHideClock10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
