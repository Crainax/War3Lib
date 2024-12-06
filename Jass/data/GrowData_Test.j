#ifndef UTGrowDataIncluded
#define UTGrowDataIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTGrowData requires GrowData {

	function TTestUTGrowData1 (player p) {
		//growdata
	}
	function TTestUTGrowData2 (player p) {
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
	function TTestUTGrowData3 (player p) {}
	function TTestUTGrowData4 (player p) {}
	function TTestUTGrowData5 (player p) {}
	function TTestUTGrowData6 (player p) {}
	function TTestUTGrowData7 (player p) {}
	function TTestUTGrowData8 (player p) {}
	function TTestUTGrowData9 (player p) {}
	function TTestUTGrowData10 (player p) {}
	function TTestActUTGrowData1 (string str) {
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
			BJDebugMsg("[GrowData] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTGrowData1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTGrowData1(GetTriggerPlayer());
			else if(str == "s2") TTestUTGrowData2(GetTriggerPlayer());
			else if(str == "s3") TTestUTGrowData3(GetTriggerPlayer());
			else if(str == "s4") TTestUTGrowData4(GetTriggerPlayer());
			else if(str == "s5") TTestUTGrowData5(GetTriggerPlayer());
			else if(str == "s6") TTestUTGrowData6(GetTriggerPlayer());
			else if(str == "s7") TTestUTGrowData7(GetTriggerPlayer());
			else if(str == "s8") TTestUTGrowData8(GetTriggerPlayer());
			else if(str == "s9") TTestUTGrowData9(GetTriggerPlayer());
			else if(str == "s10") TTestUTGrowData10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
