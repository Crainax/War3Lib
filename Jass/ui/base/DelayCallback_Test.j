#ifndef UTDelayCallbackIncluded
#define UTDelayCallbackIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTDelayCallback requires DelayCallback {

	function TTestUTDelayCallback1 (player p) {
		BJDebugMsg("开始延迟回调测试：将在3帧后执行");
		delayCallback.register(3, function (player p) {
			BJDebugMsg("延迟回调测试：3帧后执行成功！");
		});
	}

	function TTestUTDelayCallback2 (player p) {}
	function TTestUTDelayCallback3 (player p) {}
	function TTestUTDelayCallback4 (player p) {}
	function TTestUTDelayCallback5 (player p) {}
	function TTestUTDelayCallback6 (player p) {}
	function TTestUTDelayCallback7 (player p) {}
	function TTestUTDelayCallback8 (player p) {}
	function TTestUTDelayCallback9 (player p) {}
	function TTestUTDelayCallback10 (player p) {}
	function TTestActUTDelayCallback1 (string str) {
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
			BJDebugMsg("[DelayCallback] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTDelayCallback1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTDelayCallback1(GetTriggerPlayer());
			else if(str == "s2") TTestUTDelayCallback2(GetTriggerPlayer());
			else if(str == "s3") TTestUTDelayCallback3(GetTriggerPlayer());
			else if(str == "s4") TTestUTDelayCallback4(GetTriggerPlayer());
			else if(str == "s5") TTestUTDelayCallback5(GetTriggerPlayer());
			else if(str == "s6") TTestUTDelayCallback6(GetTriggerPlayer());
			else if(str == "s7") TTestUTDelayCallback7(GetTriggerPlayer());
			else if(str == "s8") TTestUTDelayCallback8(GetTriggerPlayer());
			else if(str == "s9") TTestUTDelayCallback9(GetTriggerPlayer());
			else if(str == "s10") TTestUTDelayCallback10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
