#ifndef UTConversionUtilsIncluded
#define UTConversionUtilsIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTConversionUtils requires ConversionUtils {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start
			}, function() {
			//end
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
			//S3
			BJDebugMsg(I2S(<?=StringHash( "GJ")?>));
			BJDebugMsg(I2S(StringHash("GJ")));
		},null);
	}

	function TTestUTConversionUtils1 (player p) {}
	function TTestUTConversionUtils2 (player p) {}
	function TTestUTConversionUtils3 (player p) {}
	function TTestUTConversionUtils4 (player p) {}
	function TTestUTConversionUtils5 (player p) {}
	function TTestUTConversionUtils6 (player p) {}
	function TTestUTConversionUtils7 (player p) {}
	function TTestUTConversionUtils8 (player p) {}
	function TTestUTConversionUtils9 (player p) {}
	function TTestUTConversionUtils10 (player p) {}
	function TTestActUTConversionUtils1 (string str) {
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
			BJDebugMsg("[ConversionUtils] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTConversionUtils1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTConversionUtils1(GetTriggerPlayer());
			else if(str == "s2") TTestUTConversionUtils2(GetTriggerPlayer());
			else if(str == "s3") TTestUTConversionUtils3(GetTriggerPlayer());
			else if(str == "s4") TTestUTConversionUtils4(GetTriggerPlayer());
			else if(str == "s5") TTestUTConversionUtils5(GetTriggerPlayer());
			else if(str == "s6") TTestUTConversionUtils6(GetTriggerPlayer());
			else if(str == "s7") TTestUTConversionUtils7(GetTriggerPlayer());
			else if(str == "s8") TTestUTConversionUtils8(GetTriggerPlayer());
			else if(str == "s9") TTestUTConversionUtils9(GetTriggerPlayer());
			else if(str == "s10") TTestUTConversionUtils10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
