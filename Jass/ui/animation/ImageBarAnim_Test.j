#ifndef UTImageBarAnimIncluded
#define UTImageBarAnimIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTImageBarAnim requires ImageBarAnim {

	uiImageBar bar = 0;

	function TTestUTImageBarAnim1 (player p) {
		bar = uiImageBar.create(DzGetGameUI())
			.setProgress(0.5)
			.setSize(0.2, 0.01)
			.setBorder(1)
			.setFillColor(1)
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0,0)
			.animateIB(0.0, 1.0, 1.0, function(uiImageBar cb) {
				BJDebugMsg("[ImageBarAnim] 动画结束");
				cb.destroy();
			});
	}
	function TTestUTImageBarAnim2 (player p) {}
	function TTestUTImageBarAnim3 (player p) {}
	function TTestUTImageBarAnim4 (player p) {}
	function TTestUTImageBarAnim5 (player p) {}
	function TTestUTImageBarAnim6 (player p) {}
	function TTestUTImageBarAnim7 (player p) {}
	function TTestUTImageBarAnim8 (player p) {}
	function TTestUTImageBarAnim9 (player p) {}
	function TTestUTImageBarAnim10 (player p) {}
	function TTestActUTImageBarAnim1 (string str) {
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
			BJDebugMsg("[ImageBarAnim] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTImageBarAnim1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTImageBarAnim1(GetTriggerPlayer());
			else if(str == "s2") TTestUTImageBarAnim2(GetTriggerPlayer());
			else if(str == "s3") TTestUTImageBarAnim3(GetTriggerPlayer());
			else if(str == "s4") TTestUTImageBarAnim4(GetTriggerPlayer());
			else if(str == "s5") TTestUTImageBarAnim5(GetTriggerPlayer());
			else if(str == "s6") TTestUTImageBarAnim6(GetTriggerPlayer());
			else if(str == "s7") TTestUTImageBarAnim7(GetTriggerPlayer());
			else if(str == "s8") TTestUTImageBarAnim8(GetTriggerPlayer());
			else if(str == "s9") TTestUTImageBarAnim9(GetTriggerPlayer());
			else if(str == "s10") TTestUTImageBarAnim10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
