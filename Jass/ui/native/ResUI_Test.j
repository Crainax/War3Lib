#ifndef UTResUIIncluded
#define UTResUIIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTResUI requires ResUI,UnitTestUIRuler{

	function TTestUTResUI1 (player p) {
		integer ui = DzFrameGetTopMessage();
		DzFrameClearAllPoints(ui);
		DzFrameSetSize(ui, 0.076, 0.018);
		DzFrameSetPoint(ui, ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0);
		BJDebugMsg("测试一下最上的UI");
		//答案:一坨  完全不知道是什么
	}
	function TTestUTResUI2 (player p) {}
	function TTestUTResUI3 (player p) {}
	function TTestUTResUI4 (player p) {}
	function TTestUTResUI5 (player p) {}
	function TTestUTResUI6 (player p) {}
	function TTestUTResUI7 (player p) {}
	function TTestUTResUI8 (player p) {}
	function TTestUTResUI9 (player p) {}
	function TTestUTResUI10 (player p) {}
	function TTestActUTResUI1 (string str) {
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
			BJDebugMsg("[ResUI] 单元测试已加载");

			resUI.onEnter(1, function() {
				BJDebugMsg("1.onEnter");
			});
			resUI.onLeave(1, function() {
				BJDebugMsg("1.onLeave");
			});
			resUI.onEnter(2, function() {
				BJDebugMsg("2.onEnter");
			});
			resUI.onLeave(2, function() {
				BJDebugMsg("2.onLeave");
			});
			resUI.onEnter(3, function() {
				BJDebugMsg("3.onEnter");
			});
			resUI.onLeave(3, function() {
				BJDebugMsg("3.onLeave");
			});

			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTResUI1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTResUI1(GetTriggerPlayer());
			else if(str == "s2") TTestUTResUI2(GetTriggerPlayer());
			else if(str == "s3") TTestUTResUI3(GetTriggerPlayer());
			else if(str == "s4") TTestUTResUI4(GetTriggerPlayer());
			else if(str == "s5") TTestUTResUI5(GetTriggerPlayer());
			else if(str == "s6") TTestUTResUI6(GetTriggerPlayer());
			else if(str == "s7") TTestUTResUI7(GetTriggerPlayer());
			else if(str == "s8") TTestUTResUI8(GetTriggerPlayer());
			else if(str == "s9") TTestUTResUI9(GetTriggerPlayer());
			else if(str == "s10") TTestUTResUI10(GetTriggerPlayer());
		});

		InitTestUIRuler();

	}

}
//! endzinc

#endif
