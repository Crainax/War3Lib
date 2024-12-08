#ifndef UTUnitTestUIRulerIncluded
#define UTUnitTestUIRulerIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUnitTestUIRuler requires UnitTestUIRuler {

	function TTestUTUnitTestUIRuler1 (player p) {}
	function TTestUTUnitTestUIRuler2 (player p) {}
	function TTestUTUnitTestUIRuler3 (player p) {}
	function TTestUTUnitTestUIRuler4 (player p) {}
	function TTestUTUnitTestUIRuler5 (player p) {}
	function TTestUTUnitTestUIRuler6 (player p) {}
	function TTestUTUnitTestUIRuler7 (player p) {}
	function TTestUTUnitTestUIRuler8 (player p) {}
	function TTestUTUnitTestUIRuler9 (player p) {}
	function TTestUTUnitTestUIRuler10 (player p) {}
	function TTestActUTUnitTestUIRuler1 (string str) {
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
			BJDebugMsg("[UnitTestUIRuler] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitTestUIRuler1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitTestUIRuler1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitTestUIRuler2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitTestUIRuler3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitTestUIRuler4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitTestUIRuler5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitTestUIRuler6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitTestUIRuler7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitTestUIRuler8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitTestUIRuler9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitTestUIRuler10(GetTriggerPlayer());
		});
		InitTestUIRuler();
	}

}
//! endzinc

#endif
