#ifndef UTToastHintIncluded
#define UTToastHintIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/**
* ToastHint组件的单元测试库
*
* 聊天命令测试:
* s1 - 在鼠标位置创建一个基础提示框
* s2 - 在屏幕中心创建一个提示框
* s3 - 创建多个提示框测试
* s4 - 测试长文本的显示效果
* s5 - 测试中文文本的显示效果
* s6 - 在技能栏第二排第3格创建提示(createAtSpell示例)
* s7 - 在物品栏第3格创建提示(createAtItem示例)
*
* 鼠标点击测试:
* 左键点击 - 显示鼠标实际坐标(0-0.8, 0-0.6)
* 右键点击 - 显示鼠标相对坐标(像素值)
*
* 参数化测试命令:
* -a x y - 在指定坐标(x,y)创建提示框
* -b text - 使用指定文本创建提示框
* -c x y text - 在技能栏(x,y)创建提示框
* -d pos text - 在物品栏pos创建提示框
*/
library UTToastHint requires ToastHint {

	// 在鼠标位置创建基础提示框
	function TTestUTToastHint1(player p) {
		toastHint.createAtMouse(p, "这是一个测试提示");
	}

	// 在屏幕中心创建提示框
	function TTestUTToastHint2(player p) {
		toastHint.create(p, "屏幕中心提示", 0.4, 0.3);
	}

	// 测试多个提示框
	function TTestUTToastHint3(player p) {
		toastHint.createAtMouse(p, "提示1");
		toastHint.createAtMouse(p, "提示2");
		toastHint.createAtMouse(p, "提示3");
	}

	// 测试长文本
	function TTestUTToastHint4(player p) {
		toastHint.createAtMouse(p, "这是一个非常长的提示文本，用来测试提示框的自动换行和显示效果\n效果123\nppppp123");
	}

	// 测试中文
	function TTestUTToastHint5(player p) {
		toastHint.createAtMouse(p, "测试中文显示：你好，世界！");
	}

	// 测试技能栏定位提示(createAtSpell)
	function TTestUTToastHint6(player p) {
		toastHint.createAtSpell(p, 3, 2, "createAtSpell: 第二排第3格");
	}

	// 测试物品栏定位提示(createAtItem)
	function TTestUTToastHint7(player p) {
		toastHint.createAtItem(p, 3, "createAtItem: 第3个物品格");
	}

	// 其他测试用例保留占位
	function TTestUTToastHint8(player p) {}
	function TTestUTToastHint9(player p) {}
	function TTestUTToastHint10(player p) {}

	// 处理带参数的测试命令
	function TTestActUTToastHint1(string str) {
		player p = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i, num = 0, len = StringLength(str);
		string paramS[];
		integer paramI[];
		real paramR[];

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

		// 处理参数化命令
		if (paramS[0] == "a") {
			// -a x y：在指定坐标创建提示框
			if (num >= 3) {
				toastHint.create(p, "指定坐标提示", paramR[1], paramR[2]);
			}
		} else if (paramS[0] == "b") {
			// -b text：使用指定文本创建提示框
			if (num >= 2) {
				toastHint.createAtMouse(p, paramS[1]);
			}
		} else if (paramS[0] == "c") {
			// -c x y text：在技能栏(x,y)创建提示框
			if (num >= 4) {
				toastHint.createAtSpell(p, paramI[1], paramI[2], paramS[3]);
			}
		} else if (paramS[0] == "d") {
			// -d pos text：在物品栏pos创建提示框
			if (num >= 3) {
				toastHint.createAtItem(p, paramI[1], paramS[2]);
			}
		}

		p = null;
	}

	function onInit() {
		// 在游戏开始0.5秒后加载测试
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr, 0.5);
		TriggerAddCondition(tr, Condition(function() {
			BJDebugMsg("[ToastHint] 单元测试已加载");
			BJDebugMsg("输入s1-s7测试不同功能");
			BJDebugMsg("输入-a x y在指定坐标创建提示");
			BJDebugMsg("输入-b text使用指定文本创建提示");
			BJDebugMsg("输入-c x y text在技能栏(x,y)创建提示(如: -c 3 2 hi)");
			BJDebugMsg("输入-d pos text在物品栏pos创建提示(如: -d 3 hi)");
			BJDebugMsg("左键点击显示坐标");
			BJDebugMsg("右键点击显示相对坐标");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		// 注册聊天命令
		UnitTestRegisterChatEvent(function() {
			string str = GetEventPlayerChatString();

			// 处理参数化命令
			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTToastHint1(SubStringBJ(str,2,StringLength(str)));
				return;
			}

			// 处理简单测试命令
			if (str == "s1") TTestUTToastHint1(GetTriggerPlayer());
			else if(str == "s2") TTestUTToastHint2(GetTriggerPlayer());
			else if(str == "s3") TTestUTToastHint3(GetTriggerPlayer());
			else if(str == "s4") TTestUTToastHint4(GetTriggerPlayer());
			else if(str == "s5") TTestUTToastHint5(GetTriggerPlayer());
			else if(str == "s6") TTestUTToastHint6(GetTriggerPlayer());
			else if(str == "s7") TTestUTToastHint7(GetTriggerPlayer());
			else if(str == "s8") TTestUTToastHint8(GetTriggerPlayer());
			else if(str == "s9") TTestUTToastHint9(GetTriggerPlayer());
			else if(str == "s10") TTestUTToastHint10(GetTriggerPlayer());
		});

		// 注册鼠标事件
		hardware.regLeftDownEvent(function() {
			real x = hardware.getMouseX();
			real y = hardware.getMouseY();
			string msg = "鼠标坐标: (" + R2S(x) + ", " + R2S(y) + ")";
			toastHint.createAtMouse(GetLocalPlayer(), msg);
		});

		hardware.regRightDownEvent(function() {
			real x = DzGetMouseXRelative();
			real y = DzGetMouseYRelative();
			string msg = "相对坐标: (" + R2S(x) + ", " + R2S(y) + ")";
			toastHint.createAtMouse(GetLocalPlayer(), msg);
		});
	}
}
//! endzinc

#endif
