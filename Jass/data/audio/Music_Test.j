#ifndef UTMusicIncluded
#define UTMusicIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTMusic requires Music {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start
			}, function() {
			//end
		});
		UnitTestAutoTimer(bj_PI, 2.0, function() {
			//assert.Boolean(true, "测试1");
			//music[1001]
			//music[13]
		},null);
		// YDUserDataSet(itemcode, 'esaz', "LL", integer, 23000);
	}

	function TTestUTMusic1 (player p) {}
	function TTestUTMusic2 (player p) {}
	function TTestUTMusic3 (player p) {}
	function TTestUTMusic4 (player p) {}
	function TTestUTMusic5 (player p) {}
	function TTestUTMusic6 (player p) {}
	function TTestUTMusic7 (player p) {}
	function TTestUTMusic8 (player p) {}
	function TTestUTMusic9 (player p) {}
	function TTestUTMusic10 (player p) {}
	function TTestActUTMusic1 (string str) {
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
			BJDebugMsg("[Music] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTMusic1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTMusic1(GetTriggerPlayer());
			else if(str == "s2") TTestUTMusic2(GetTriggerPlayer());
			else if(str == "s3") TTestUTMusic3(GetTriggerPlayer());
			else if(str == "s4") TTestUTMusic4(GetTriggerPlayer());
			else if(str == "s5") TTestUTMusic5(GetTriggerPlayer());
			else if(str == "s6") TTestUTMusic6(GetTriggerPlayer());
			else if(str == "s7") TTestUTMusic7(GetTriggerPlayer());
			else if(str == "s8") TTestUTMusic8(GetTriggerPlayer());
			else if(str == "s9") TTestUTMusic9(GetTriggerPlayer());
			else if(str == "s10") TTestUTMusic10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
