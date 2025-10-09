#ifndef UTImageAnimIncluded
#define UTImageAnimIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTImageAnim requires ImageAnim {

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

	function TTestUTImageAnim1 (player p) {
		integer i = growdata[ICONGROW_1];
		i = growdata[ICONGROW_2];
		i = growdata[ICONGROW_3];
		i = growdata[ICONGROW_4];
		i = growdata[ICONGROW_5];
		i = growdata[ICONGROW_6];
		i = growdata[ICONGROW_7];
		i = growdata[ICONGROW_8];
		i = growdata[ICONGROW_9];
		i = growdata[ICONGROW_10];
		i = growdata[ICONGROW_11];
		i = growdata[ICONGROW_12];
		i = growdata[ICONGROW_13];
		i = growdata[ICONGROW_14];
		i = growdata[ICONGROW_15];
		i = growdata[ICONGROW_16];
		i = growdata[ICONGROW_17];
		i = growdata[ICONGROW_18];
		i = growdata[ICONGROW_BTN];
		i = growdata[ICONGROW_20];
		i = growdata[ICONGROW_21];
		i = growdata[GIF_UPGRADE];
		i = growdata[GIF_SHAKEWAVE1];
		i = growdata[GIF_STAR];
		i = growdata[SEQ_LOADING];
		i = growdata[GIF_BUFF];
		i = growdata[GIF_ICON_FLASH];
		i = growdata[GIF_ICON_FLASH_2];
		i = growdata[GIF_ICON_CLICK];
		i = growdata[GIF_ICON_LEVELUP];
	}
	function TTestUTImageAnim2 (player p) {}
	function TTestUTImageAnim3 (player p) {}
	function TTestUTImageAnim4 (player p) {}
	function TTestUTImageAnim5 (player p) {}
	function TTestUTImageAnim6 (player p) {}
	function TTestUTImageAnim7 (player p) {}
	function TTestUTImageAnim8 (player p) {}
	function TTestUTImageAnim9 (player p) {}
	function TTestUTImageAnim10 (player p) {}
	function TTestActUTImageAnim1 (string str) {
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
			imageAnim.gif(p, growdata[paramI[1]], DzGetGameUI());
			BJDebugMsg("测试 GIF 动画: growdata[" + I2S(paramI[1]) + "]");
		} else if (paramS[0] == "b") {

		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[ImageAnim] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTImageAnim1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTImageAnim1(GetTriggerPlayer());
			else if(str == "s2") TTestUTImageAnim2(GetTriggerPlayer());
			else if(str == "s3") TTestUTImageAnim3(GetTriggerPlayer());
			else if(str == "s4") TTestUTImageAnim4(GetTriggerPlayer());
			else if(str == "s5") TTestUTImageAnim5(GetTriggerPlayer());
			else if(str == "s6") TTestUTImageAnim6(GetTriggerPlayer());
			else if(str == "s7") TTestUTImageAnim7(GetTriggerPlayer());
			else if(str == "s8") TTestUTImageAnim8(GetTriggerPlayer());
			else if(str == "s9") TTestUTImageAnim9(GetTriggerPlayer());
			else if(str == "s10") TTestUTImageAnim10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
