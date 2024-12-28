#ifndef UTObsIntegerIncluded
#define UTObsIntegerIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTObsInteger requires ObsInteger {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start
			}, function() {
			//end
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
			obsInteger oi = obsInteger.create();
			oi.setValue(123);
		},null);
	}

	function TTestUTObsInteger1 (player p) {}
	function TTestUTObsInteger2 (player p) {}
	function TTestUTObsInteger3 (player p) {}
	function TTestUTObsInteger4 (player p) {}
	function TTestUTObsInteger5 (player p) {}
	function TTestUTObsInteger6 (player p) {}
	function TTestUTObsInteger7 (player p) {}
	function TTestUTObsInteger8 (player p) {}
	function TTestUTObsInteger9 (player p) {}
	function TTestUTObsInteger10 (player p) {}
	function TTestActUTObsInteger1 (string str) {
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
			BJDebugMsg("[ObsInteger] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTObsInteger1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTObsInteger1(GetTriggerPlayer());
			else if(str == "s2") TTestUTObsInteger2(GetTriggerPlayer());
			else if(str == "s3") TTestUTObsInteger3(GetTriggerPlayer());
			else if(str == "s4") TTestUTObsInteger4(GetTriggerPlayer());
			else if(str == "s5") TTestUTObsInteger5(GetTriggerPlayer());
			else if(str == "s6") TTestUTObsInteger6(GetTriggerPlayer());
			else if(str == "s7") TTestUTObsInteger7(GetTriggerPlayer());
			else if(str == "s8") TTestUTObsInteger8(GetTriggerPlayer());
			else if(str == "s9") TTestUTObsInteger9(GetTriggerPlayer());
			else if(str == "s10") TTestUTObsInteger10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
