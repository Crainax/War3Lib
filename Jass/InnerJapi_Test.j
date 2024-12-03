#ifndef UTInnerJapiIncluded
#define UTInnerJapiIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTInnerJapi requires InnerJapi {

	function TTestUTInnerJapi1 (player p) {
		BJDebugMsg("测试内容");
	}
	function TTestUTInnerJapi2 (player p) {}
	function TTestUTInnerJapi3 (player p) {}
	function TTestUTInnerJapi4 (player p) {}
	function TTestUTInnerJapi5 (player p) {}
	function TTestUTInnerJapi6 (player p) {}
	function TTestUTInnerJapi7 (player p) {}
	function TTestUTInnerJapi8 (player p) {}
	function TTestUTInnerJapi9 (player p) {}
	function TTestUTInnerJapi10 (player p) {}
	function TTestActUTInnerJapi1 (string str) {
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
			BJDebugMsg("[InnerJapi] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTInnerJapi1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTInnerJapi1(GetTriggerPlayer());
			else if(str == "s2") TTestUTInnerJapi2(GetTriggerPlayer());
			else if(str == "s3") TTestUTInnerJapi3(GetTriggerPlayer());
			else if(str == "s4") TTestUTInnerJapi4(GetTriggerPlayer());
			else if(str == "s5") TTestUTInnerJapi5(GetTriggerPlayer());
			else if(str == "s6") TTestUTInnerJapi6(GetTriggerPlayer());
			else if(str == "s7") TTestUTInnerJapi7(GetTriggerPlayer());
			else if(str == "s8") TTestUTInnerJapi8(GetTriggerPlayer());
			else if(str == "s9") TTestUTInnerJapi9(GetTriggerPlayer());
			else if(str == "s10") TTestUTInnerJapi10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
