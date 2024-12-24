#ifndef UTToastPopIncluded
#define UTToastPopIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTToastPop requires ToastPop {

	function TTestUTToastPop1 (player p) {
		//toastPop
		toastPop th = toastPop.createWithTitle(p, "这是一个测试提示","这是一个测试内容");
	}
	function TTestUTToastPop2 (player p) {
		toastPop th = toastPop.createWithIcon(p, "ReplaceableTextures\\CommandButtons\\BTNRingPurple.blp","这是一个测试内容这是一个测试内容这是一个测试内容这是一个测试内容\n\t\t\theheheheheninini");
	}
	function TTestUTToastPop3 (player p) {}
	function TTestUTToastPop4 (player p) {}
	function TTestUTToastPop5 (player p) {}
	function TTestUTToastPop6 (player p) {}
	function TTestUTToastPop7 (player p) {}
	function TTestUTToastPop8 (player p) {}
	function TTestUTToastPop9 (player p) {}
	function TTestUTToastPop10 (player p) {}
	function TTestActUTToastPop1 (string str) {
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
			BJDebugMsg("[ToastPop] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTToastPop1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTToastPop1(GetTriggerPlayer());
			else if(str == "s2") TTestUTToastPop2(GetTriggerPlayer());
			else if(str == "s3") TTestUTToastPop3(GetTriggerPlayer());
			else if(str == "s4") TTestUTToastPop4(GetTriggerPlayer());
			else if(str == "s5") TTestUTToastPop5(GetTriggerPlayer());
			else if(str == "s6") TTestUTToastPop6(GetTriggerPlayer());
			else if(str == "s7") TTestUTToastPop7(GetTriggerPlayer());
			else if(str == "s8") TTestUTToastPop8(GetTriggerPlayer());
			else if(str == "s9") TTestUTToastPop9(GetTriggerPlayer());
			else if(str == "s10") TTestUTToastPop10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
