#ifndef UTUIHashTableIncluded
#define UTUIHashTableIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUIHashTable requires UIHashTable {

	function TTestUTUIHashTable1 (player p) {
		uiHashTable.eventdata.bind(1,1);
	}
	function TTestUTUIHashTable2 (player p) {}
	function TTestUTUIHashTable3 (player p) {}
	function TTestUTUIHashTable4 (player p) {}
	function TTestUTUIHashTable5 (player p) {}
	function TTestUTUIHashTable6 (player p) {}
	function TTestUTUIHashTable7 (player p) {}
	function TTestUTUIHashTable8 (player p) {}
	function TTestUTUIHashTable9 (player p) {}
	function TTestUTUIHashTable10 (player p) {}
	function TTestActUTUIHashTable1 (string str) {
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
			BJDebugMsg("[UIHashTable] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUIHashTable1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUIHashTable1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUIHashTable2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUIHashTable3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUIHashTable4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUIHashTable5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUIHashTable6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUIHashTable7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUIHashTable8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUIHashTable9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUIHashTable10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
