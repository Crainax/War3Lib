#ifndef UTUISliderIncluded
#define UTUISliderIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUISlider requires UISlider {

	uiSlider uiSliderTest = 0;

	function TTestUTUISlider1 (player p) {
		if (uiSliderTest != null) {uiSliderTest.destroy();}
		uiSliderTest = uiSlider.create(DzGetGameUI())
			.setSize(0.0074*2,0.22006*2)
			.setStep(1)
			.setValue(50)
			.setMinMaxValue(1,100)
			.setThumbScale(2.5)
			.setPoint(ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0.0,0.0)
			.onChange(function (uiSlider ui) {
				BJDebugMsg("滑块值:"+R2S(ui.getValue()));
			});
	}
	function TTestUTUISlider2 (player p) {
	}
	function TTestUTUISlider3 (player p) {}
	function TTestUTUISlider4 (player p) {}
	function TTestUTUISlider5 (player p) {}
	function TTestUTUISlider6 (player p) {}
	function TTestUTUISlider7 (player p) {}
	function TTestUTUISlider8 (player p) {}
	function TTestUTUISlider9 (player p) {}
	function TTestUTUISlider10 (player p) {}
	function TTestActUTUISlider1 (string str) {
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
			BJDebugMsg("[UISlider] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUISlider1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUISlider1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUISlider2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUISlider3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUISlider4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUISlider5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUISlider6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUISlider7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUISlider8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUISlider9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUISlider10(GetTriggerPlayer());
		});


		hardware.regWheelEvent(function () {
			integer delta = DzGetWheelDelta();
			if (uiSliderTest == 0) {return;}
			if (delta > 0) {
				BJDebugMsg("滚轮向上");
				uiSliderTest.setValue(uiSliderTest.getValue() + 1);
			} else {
				BJDebugMsg("滚轮向下");
				uiSliderTest.setValue(uiSliderTest.getValue() - 1);
			}
		});
	}

}
//! endzinc

#endif
