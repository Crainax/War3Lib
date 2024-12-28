#ifndef UTObsRealIncluded
#define UTObsRealIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTObsReal requires ObsReal {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start
			}, function() {
			//end
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
			//obsReal or = obsReal.create();
		},null);
	}

	function TTestUTObsReal1 (player p) {}
	function TTestUTObsReal2 (player p) {}
	function TTestUTObsReal3 (player p) {}
	function TTestUTObsReal4 (player p) {}
	function TTestUTObsReal5 (player p) {}
	function TTestUTObsReal6 (player p) {}
	function TTestUTObsReal7 (player p) {}
	function TTestUTObsReal8 (player p) {}
	function TTestUTObsReal9 (player p) {}
	function TTestUTObsReal10 (player p) {}
	function TTestActUTObsReal1 (string str) {
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
			BJDebugMsg("[ObsReal] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTObsReal1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTObsReal1(GetTriggerPlayer());
			else if(str == "s2") TTestUTObsReal2(GetTriggerPlayer());
			else if(str == "s3") TTestUTObsReal3(GetTriggerPlayer());
			else if(str == "s4") TTestUTObsReal4(GetTriggerPlayer());
			else if(str == "s5") TTestUTObsReal5(GetTriggerPlayer());
			else if(str == "s6") TTestUTObsReal6(GetTriggerPlayer());
			else if(str == "s7") TTestUTObsReal7(GetTriggerPlayer());
			else if(str == "s8") TTestUTObsReal8(GetTriggerPlayer());
			else if(str == "s9") TTestUTObsReal9(GetTriggerPlayer());
			else if(str == "s10") TTestUTObsReal10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
