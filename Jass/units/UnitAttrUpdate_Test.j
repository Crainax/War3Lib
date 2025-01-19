#ifndef UTUnitAttrUpdateIncluded
#define UTUnitAttrUpdateIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUnitAttrUpdate requires UnitAttrUpdate {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start
			}, function() {
			//end
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
			//InitUnitAttrUpdate();
		},null);
	}

	function TTestUTUnitAttrUpdate1 (player p) {}
	function TTestUTUnitAttrUpdate2 (player p) {}
	function TTestUTUnitAttrUpdate3 (player p) {}
	function TTestUTUnitAttrUpdate4 (player p) {}
	function TTestUTUnitAttrUpdate5 (player p) {}
	function TTestUTUnitAttrUpdate6 (player p) {}
	function TTestUTUnitAttrUpdate7 (player p) {}
	function TTestUTUnitAttrUpdate8 (player p) {}
	function TTestUTUnitAttrUpdate9 (player p) {}
	function TTestUTUnitAttrUpdate10 (player p) {}
	function TTestActUTUnitAttrUpdate1 (string str) {
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
			BJDebugMsg("[UnitAttrUpdate] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitAttrUpdate1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitAttrUpdate1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitAttrUpdate2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitAttrUpdate3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitAttrUpdate4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitAttrUpdate5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitAttrUpdate6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitAttrUpdate7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitAttrUpdate8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitAttrUpdate9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitAttrUpdate10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
