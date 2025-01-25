#ifndef UTUnitRegenIncluded
#define UTUnitRegenIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUnitRegen requires UnitRegen {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start
			}, function() {
			//end
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
			//unitRegen
		},null);
	}

	function TTestUTUnitRegen1 (player p) {}
	function TTestUTUnitRegen2 (player p) {}
	function TTestUTUnitRegen3 (player p) {}
	function TTestUTUnitRegen4 (player p) {}
	function TTestUTUnitRegen5 (player p) {}
	function TTestUTUnitRegen6 (player p) {}
	function TTestUTUnitRegen7 (player p) {}
	function TTestUTUnitRegen8 (player p) {}
	function TTestUTUnitRegen9 (player p) {}
	function TTestUTUnitRegen10 (player p) {}
	function TTestActUTUnitRegen1 (string str) {
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
			BJDebugMsg("[UnitRegen] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitRegen1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitRegen1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitRegen2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitRegen3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitRegen4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitRegen5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitRegen6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitRegen7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitRegen8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitRegen9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitRegen10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
