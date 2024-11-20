#ifndef UTUITextIncluded
#define UTUITextIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUIText requires UIText {

	function TTestUTUIText1 (player p) {
		uiText t = uiText.create(uiId.get(),10);
	}
	function TTestUTUIText2 (player p) {}
	function TTestUTUIText3 (player p) {}
	function TTestUTUIText4 (player p) {}
	function TTestUTUIText5 (player p) {}
	function TTestUTUIText6 (player p) {}
	function TTestUTUIText7 (player p) {}
	function TTestUTUIText8 (player p) {}
	function TTestUTUIText9 (player p) {}
	function TTestUTUIText10 (player p) {}
	function TTestActUTUIText1 (string str) {
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
			BJDebugMsg("[UIText] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUIText1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUIText1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUIText2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUIText3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUIText4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUIText5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUIText6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUIText7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUIText8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUIText9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUIText10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
