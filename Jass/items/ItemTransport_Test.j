#ifndef UTItemTransportIncluded
#define UTItemTransportIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTItemTransport requires ItemTransport {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);
	}

	function TTestUTItemTransport1 (player p) {
		//itemTransport
	}
	function TTestUTItemTransport2 (player p) {}
	function TTestUTItemTransport3 (player p) {}
	function TTestUTItemTransport4 (player p) {}
	function TTestUTItemTransport5 (player p) {}
	function TTestUTItemTransport6 (player p) {}
	function TTestUTItemTransport7 (player p) {}
	function TTestUTItemTransport8 (player p) {}
	function TTestUTItemTransport9 (player p) {}
	function TTestUTItemTransport10 (player p) {}
	function TTestActUTItemTransport1 (string str) {
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
			BJDebugMsg("[ItemTransport] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTItemTransport1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTItemTransport1(GetTriggerPlayer());
			else if(str == "s2") TTestUTItemTransport2(GetTriggerPlayer());
			else if(str == "s3") TTestUTItemTransport3(GetTriggerPlayer());
			else if(str == "s4") TTestUTItemTransport4(GetTriggerPlayer());
			else if(str == "s5") TTestUTItemTransport5(GetTriggerPlayer());
			else if(str == "s6") TTestUTItemTransport6(GetTriggerPlayer());
			else if(str == "s7") TTestUTItemTransport7(GetTriggerPlayer());
			else if(str == "s8") TTestUTItemTransport8(GetTriggerPlayer());
			else if(str == "s9") TTestUTItemTransport9(GetTriggerPlayer());
			else if(str == "s10") TTestUTItemTransport10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
