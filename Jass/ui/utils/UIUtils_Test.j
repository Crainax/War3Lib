#ifndef UTUIUtilsIncluded
#define UTUIUtilsIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc
/*
* UI工具库测试文件
*
* 测试命令:
* s1 - 测试GetResizeRate函数
* s2 - 测试GetMouseXEx和GetMouseYEx函数
* s3 - 测试GetFixedMouseX和GetFixedMouseY函数
* -a [min] [max] - 测试固定范围内的鼠标X坐标
* -b [min] [max] - 测试固定范围内的鼠标Y坐标
*/
library UTUIUtils requires UIUtils {

	// 测试GetResizeRate函数
	function TTestUTUIUtils1(player p) {
		real rate = GetResizeRate();
		BJDebugMsg("当前窗口缩放比例: " + R2S(rate));
	}

	// 测试GetMouseXEx和GetMouseYEx函数
	function TTestUTUIUtils2(player p) {
		real mouseX = GetMouseXEx();
		real mouseY = GetMouseYEx();
		BJDebugMsg("鼠标X坐标: " + R2S(mouseX));
		BJDebugMsg("鼠标Y坐标: " + R2S(mouseY));
	}

	// 测试GetFixedMouseX和GetFixedMouseY函数
	function TTestUTUIUtils3(player p) {
		real fixedX = GetFixedMouseX(0.1, 0.7);
		real fixedY = GetFixedMouseY(0.1, 0.5);
		BJDebugMsg("限制范围后的鼠标X坐标: " + R2S(fixedX));
		BJDebugMsg("限制范围后的鼠标Y坐标: " + R2S(fixedY));
	}

	// 保留其他测试函数占位
	function TTestUTUIUtils4(player p) {}
	function TTestUTUIUtils5(player p) {}
	function TTestUTUIUtils6(player p) {}
	function TTestUTUIUtils7(player p) {}
	function TTestUTUIUtils8(player p) {}
	function TTestUTUIUtils9(player p) {}
	function TTestUTUIUtils10(player p) {}

	// 处理带参数的测试命令
	function TTestActUTUIUtils1(string str) {
		player p = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i, num = 0, len = StringLength(str);
		string paramS[];
		integer paramI[];
		real paramR[];
		real fixedX;
		real fixedY;
		// 解析参数
		for (0 <= i <= len - 1) {
			if (SubString(str,i,i+1) == " ") {
				paramS[num] = SubString(str,0,i);
				paramI[num] = S2I(paramS[num]);
				paramR[num] = S2R(paramS[num]);
				num = num + 1;
				str = SubString(str,i + 1,len);
				len = StringLength(str);
				i = -1;
			}
		}
		paramS[num] = str;
		paramI[num] = S2I(paramS[num]);
		paramR[num] = S2R(paramS[num]);
		num = num + 1;

		// 测试固定范围的鼠标X坐标
		if (paramS[0] == "a") {
			fixedX = GetFixedMouseX(paramR[1], paramR[2]);
			BJDebugMsg("在范围 " + R2S(paramR[1]) + " 到 " + R2S(paramR[2]) + " 内的鼠标X坐标: " + R2S(fixedX));
		}
		// 测试固定范围的鼠标Y坐标
		else if (paramS[0] == "b") {
			fixedY = GetFixedMouseY(paramR[1], paramR[2]);
			BJDebugMsg("在范围 " + R2S(paramR[1]) + " 到 " + R2S(paramR[2]) + " 内的鼠标Y坐标: " + R2S(fixedY));
		}

		p = null;
	}

	function onInit() {
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr, 0.5);
		TriggerAddCondition(tr, Condition(function() {
			BJDebugMsg("[UIUtils] 单元测试已加载");
			BJDebugMsg("使用 s1-s3 测试基本功能");
			BJDebugMsg("使用 -a [min] [max] 测试固定范围的鼠标X坐标");
			BJDebugMsg("使用 -b [min] [max] 测试固定范围的鼠标Y坐标");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function() {
			string str = GetEventPlayerChatString();

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUIUtils1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUIUtils1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUIUtils2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUIUtils3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUIUtils4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUIUtils5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUIUtils6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUIUtils7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUIUtils8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUIUtils9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUIUtils10(GetTriggerPlayer());
		});
	}
}
//! endzinc

#endif
