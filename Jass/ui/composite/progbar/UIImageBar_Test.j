#ifndef UTUIImageBarIncluded
#define UTUIImageBarIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUIImageBar requires UIImageBar {

	uiImageBar bar = 0;
	real progress = 0.0;

	function TTestUTUIImageBar1 (player p) {
		// 创建进度条
		bar = uiImageBar.create(DzGetGameUI())
			.setProgress(0.5)
			.setSize(0.2, 0.01)
			.setBorder(1)
			.setFillColor(1)
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0,0);
		TimerStart(CreateTimer(),0.03,true,function (){
			if (bar.isExist()) {
				progress += 0.01;
				if (progress >= 1.0) {
					progress = 0.0;
				}
				bar.setProgress(progress);
				BJDebugMsg("getProgress: " + R2S(bar.getProgress()));
			}
		});
	}
	function TTestUTUIImageBar2 (player p) {
		if (bar.isExist()) {
			bar.destroy();
		}
	}
	function TTestUTUIImageBar3 (player p) {}
	function TTestUTUIImageBar4 (player p) {}
	function TTestUTUIImageBar5 (player p) {}
	function TTestUTUIImageBar6 (player p) {}
	function TTestUTUIImageBar7 (player p) {}
	function TTestUTUIImageBar8 (player p) {}
	function TTestUTUIImageBar9 (player p) {}
	function TTestUTUIImageBar10 (player p) {}
	function TTestActUTUIImageBar1 (string str) {
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

		if (paramS[0] == "size") {
			bar.setSize(paramR[1], paramR[2]);
		} else if (paramS[0] == "color") {
			bar.setFillColor(paramI[1]);
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[UIImageBar] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUIImageBar1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUIImageBar1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUIImageBar2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUIImageBar3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUIImageBar4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUIImageBar5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUIImageBar6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUIImageBar7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUIImageBar8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUIImageBar9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUIImageBar10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
