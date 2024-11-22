#ifndef UTUIEventTextIncluded
#define UTUIEventTextIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUIEventText requires UIEventText {

	uiEventText currentText = 0;

	function TTestUTUIEventText1 (player p) {
		if (GetLocalPlayer() == p) {
			currentText = uiEventText.create(DzGetGameUI())
				.setPoint(ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,currentText.id*0.01,currentText.id*0.01)
				.setText("这是一个测试文本"+I2S(currentText.id)+"\n测试一下事件功能")
				.onMouseEnter(function (){BJDebugMsg("鼠标进入:"+I2S(DzGetTriggerUIEventFrame()));})
				.onMouseLeave(function (){BJDebugMsg("鼠标离开:"+I2S(DzGetTriggerUIEventFrame()));})
				.onMouseUp(function (){BJDebugMsg("鼠标松开:"+I2S(DzGetTriggerUIEventFrame()));})
				.onMouseClick(function (){BJDebugMsg("鼠标点击:"+I2S(DzGetTriggerUIEventFrame()));})
				.onMouseWheel(function (){BJDebugMsg("鼠标滚轮:"+I2S(DzGetTriggerUIEventFrame()));})
				.onMouseDoubleClick(function (){BJDebugMsg("鼠标双击:"+I2S(DzGetTriggerUIEventFrame()));});
			BJDebugMsg("创建了一个文本UI，测试事件系统");
		}
	}
	function TTestUTUIEventText2 (player p) {}
	function TTestUTUIEventText3 (player p) {}
	function TTestUTUIEventText4 (player p) {}
	function TTestUTUIEventText5 (player p) {}
	function TTestUTUIEventText6 (player p) {}
	function TTestUTUIEventText7 (player p) {}
	function TTestUTUIEventText8 (player p) {}
	function TTestUTUIEventText9 (player p) {}
	function TTestUTUIEventText10 (player p) {}
	function TTestActUTUIEventText1 (string str) {
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
			BJDebugMsg("[UIEventText] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;


		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUIEventText1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUIEventText1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUIEventText2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUIEventText3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUIEventText4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUIEventText5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUIEventText6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUIEventText7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUIEventText8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUIEventText9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUIEventText10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
