#ifndef UTMemoryLeakIncluded
#define UTMemoryLeakIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTMemoryLeak requires MemoryLeak {

	function Init () {
	}

	function TTestUTMemoryLeak1 (player p) {
		MemoryLeakShow();
	}
	function TTestUTMemoryLeak2 (player p) {}
	function TTestUTMemoryLeak3 (player p) {}
	function TTestUTMemoryLeak4 (player p) {}
	function TTestUTMemoryLeak5 (player p) {}
	function TTestUTMemoryLeak6 (player p) {}
	function TTestUTMemoryLeak7 (player p) {}
	function TTestUTMemoryLeak8 (player p) {}
	function TTestUTMemoryLeak9 (player p) {}
	function TTestUTMemoryLeak10 (player p) {}
	function TTestActUTMemoryLeak1 (string str) {
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
			BJDebugMsg("[MemoryLeak] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTMemoryLeak1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTMemoryLeak1(GetTriggerPlayer());
			else if(str == "s2") TTestUTMemoryLeak2(GetTriggerPlayer());
			else if(str == "s3") TTestUTMemoryLeak3(GetTriggerPlayer());
			else if(str == "s4") TTestUTMemoryLeak4(GetTriggerPlayer());
			else if(str == "s5") TTestUTMemoryLeak5(GetTriggerPlayer());
			else if(str == "s6") TTestUTMemoryLeak6(GetTriggerPlayer());
			else if(str == "s7") TTestUTMemoryLeak7(GetTriggerPlayer());
			else if(str == "s8") TTestUTMemoryLeak8(GetTriggerPlayer());
			else if(str == "s9") TTestUTMemoryLeak9(GetTriggerPlayer());
			else if(str == "s10") TTestUTMemoryLeak10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
