#ifndef UTKeyboardIncluded
#define UTKeyboardIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTKeyboard requires Keyboard {

	function TTestUTKeyboard1 (player p) {
		keyboard.regKeyDownEvent(KEY_A, function (){
			BJDebugMsg("[Keyboard] 按下A键");
		});
		keyboard.regKeyUpEvent(KEY_A, function (){
			BJDebugMsg("[Keyboard] 抬起A键");
		});
	}
	function TTestUTKeyboard2 (player p) {
		keyboard.regKeyDownEvent(KEY_CTRL, function (){
			BJDebugMsg("[Keyboard] 按下Ctrl键");
		});
		keyboard.regKeyUpEvent(KEY_CTRL, function (){
			BJDebugMsg("[Keyboard] 抬起Ctrl键");
		});
		keyboard.regKeyDownEvent(KEY_CTRL, function (){
			BJDebugMsg("[Keyboard] 按下Ctrl键2");
		});
		keyboard.regKeyUpEvent(KEY_CTRL, function (){
			BJDebugMsg("[Keyboard] 抬起Ctrl键2");
		});
	}
	function TTestUTKeyboard3 (player p) {
		keyboard.regKeyDownEvent(KEY_ESC, function (){
			BJDebugMsg("[Keyboard] 按下ESC键");
		});
		keyboard.regKeyUpEvent(KEY_ESC, function (){
			BJDebugMsg("[Keyboard] 抬起ESC键");
		});
	}
	function TTestUTKeyboard4 (player p) {}
	function TTestUTKeyboard5 (player p) {}
	function TTestUTKeyboard6 (player p) {}
	function TTestUTKeyboard7 (player p) {}
	function TTestUTKeyboard8 (player p) {}
	function TTestUTKeyboard9 (player p) {}
	function TTestUTKeyboard10 (player p) {}
	function TTestActUTKeyboard1 (string str) {
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
			BJDebugMsg("[Keyboard] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTKeyboard1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTKeyboard1(GetTriggerPlayer());
			else if(str == "s2") TTestUTKeyboard2(GetTriggerPlayer());
			else if(str == "s3") TTestUTKeyboard3(GetTriggerPlayer());
			else if(str == "s4") TTestUTKeyboard4(GetTriggerPlayer());
			else if(str == "s5") TTestUTKeyboard5(GetTriggerPlayer());
			else if(str == "s6") TTestUTKeyboard6(GetTriggerPlayer());
			else if(str == "s7") TTestUTKeyboard7(GetTriggerPlayer());
			else if(str == "s8") TTestUTKeyboard8(GetTriggerPlayer());
			else if(str == "s9") TTestUTKeyboard9(GetTriggerPlayer());
			else if(str == "s10") TTestUTKeyboard10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
