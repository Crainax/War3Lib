#ifndef UTBaseAnimIncluded
#define UTBaseAnimIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTBaseAnim requires BaseAnim {

	function TTestUTBaseAnim1 (player p) {
		//baseanim.create
	}
	function TTestUTBaseAnim2 (player p) {}
	function TTestUTBaseAnim3 (player p) {}
	function TTestUTBaseAnim4 (player p) {}
	function TTestUTBaseAnim5 (player p) {}
	function TTestUTBaseAnim6 (player p) {}
	function TTestUTBaseAnim7 (player p) {}
	function TTestUTBaseAnim8 (player p) {}
	function TTestUTBaseAnim9 (player p) {}
	function TTestUTBaseAnim10 (player p) {}
	function TTestActUTBaseAnim1 (string str) {
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
			BJDebugMsg("[BaseAnim] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTBaseAnim1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTBaseAnim1(GetTriggerPlayer());
			else if(str == "s2") TTestUTBaseAnim2(GetTriggerPlayer());
			else if(str == "s3") TTestUTBaseAnim3(GetTriggerPlayer());
			else if(str == "s4") TTestUTBaseAnim4(GetTriggerPlayer());
			else if(str == "s5") TTestUTBaseAnim5(GetTriggerPlayer());
			else if(str == "s6") TTestUTBaseAnim6(GetTriggerPlayer());
			else if(str == "s7") TTestUTBaseAnim7(GetTriggerPlayer());
			else if(str == "s8") TTestUTBaseAnim8(GetTriggerPlayer());
			else if(str == "s9") TTestUTBaseAnim9(GetTriggerPlayer());
			else if(str == "s10") TTestUTBaseAnim10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
