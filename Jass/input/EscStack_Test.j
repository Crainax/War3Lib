#ifndef UTEscStackIncluded
#define UTEscStackIncluded

//! zinc
library UTEscStack requires EscStack {
	private integer testId1 = 0;
	private integer testId2 = 0;
	private integer testId3 = 0;
	private integer testCount = 0;

	// 测试用的回调函数
	function TestFunc1(player p) {
		testCount += 1;
		BJDebugMsg("TestFunc1执行 - 计数: " + I2S(testCount));
	}

	function TestFunc2(player p) {
		testCount += 2;
		BJDebugMsg("TestFunc2执行 - 计数: " + I2S(testCount));
	}

	function TestFunc3(player p) {
		testCount += 3;
		BJDebugMsg("TestFunc3执行 - 计数: " + I2S(testCount));
	}

	// 测试基本压栈和出栈
	function TTestUTEscStack1(player p) {
		BJDebugMsg("测试1: 基本压栈和出栈");
		testCount = 0;

		// 压入三个函数
		testId1 = escStack.push(TestFunc1);
		testId2 = escStack.push(TestFunc2);
		testId3 = escStack.push(TestFunc3);

		BJDebugMsg("当前栈大小: " + I2S(escStack.getSize()));

		// 按ESC键会依次执行: TestFunc3 -> TestFunc2 -> TestFunc1
		BJDebugMsg("请按三次ESC键测试出栈顺序");
	}

	// 测试中途移除
	function TTestUTEscStack2(player p) {
		BJDebugMsg("测试2: 中途移除功能");
		testCount = 0;

		// 压入三个函数
		testId1 = escStack.push(TestFunc1);
		testId2 = escStack.push(TestFunc2);
		testId3 = escStack.push(TestFunc3);

		// 移除中间的函数
		if (escStack.remove(testId2)) {
			BJDebugMsg("成功移除TestFunc2");
		}

		BJDebugMsg("当前栈大小: " + I2S(escStack.getSize()));
		BJDebugMsg("请按ESC键，应该只执行TestFunc3和TestFunc1");
	}

	// 测试清空栈
	function TTestUTEscStack3(player p) {
		BJDebugMsg("测试3: 清空栈功能");
		testCount = 0;

		// 压入函数
		escStack.push(TestFunc1);
		escStack.push(TestFunc2);
		escStack.push(TestFunc3);

		BJDebugMsg("压入3个函数后栈大小: " + I2S(escStack.getSize()));
		escStack.clear();
		BJDebugMsg("清空后栈大小: " + I2S(escStack.getSize()));
	}

	// 测试边界情况
	function TTestUTEscStack4(player p) {
		BJDebugMsg("测试4: 边界情况测试");

		// 测试空栈出栈
		if (!escStack.pop()) {
			BJDebugMsg("空栈出栈测试通过");
		}

		// 测试移除不存在的ID
		if (!escStack.remove(-1)) {
			BJDebugMsg("移除不存在ID测试通过");
		}
	}

	function TTestActUTEscStack1(string str) {
		player p = GetTriggerPlayer();

		if (str == "clear") {
			escStack.clear();
			BJDebugMsg("栈已清空");
		} else if (str == "size") {
			BJDebugMsg("当前栈大小: " + I2S(escStack.getSize()));
		}

		p = null;
	}

	function onInit() {
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr, 0.5);
		TriggerAddCondition(tr, Condition(function() {
			BJDebugMsg("[EscStack] 单元测试已加载");
			BJDebugMsg("输入以下命令进行测试：");
			BJDebugMsg("s1 - 测试基本压栈和出栈");
			BJDebugMsg("s2 - 测试中途移除功能");
			BJDebugMsg("s3 - 测试清空栈功能");
			BJDebugMsg("s4 - 测试边界情况");
			BJDebugMsg("-clear - 清空栈");
			BJDebugMsg("-size - 查看当前栈大小");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function() {
			string str = GetEventPlayerChatString();

			if (SubStringBJ(str, 1, 1) == "-") {
				TTestActUTEscStack1(SubStringBJ(str, 2, StringLength(str)));
				return;
			}

			if (str == "s1") TTestUTEscStack1(GetTriggerPlayer());
			else if (str == "s2") TTestUTEscStack2(GetTriggerPlayer());
			else if (str == "s3") TTestUTEscStack3(GetTriggerPlayer());
			else if (str == "s4") TTestUTEscStack4(GetTriggerPlayer());
		});
	}
}
//! endzinc

#endif
