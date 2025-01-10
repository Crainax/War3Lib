#ifndef UTUnitAttrIncluded
#define UTUnitAttrIncluded

/*
 * 单位属性系统测试文件
 *
 * 测试命令说明：
 * hp1: 测试基础HP的增减
 * hp2: 测试HP增幅比例
 * hp3: 测试HP减幅比例
 * hp4: 测试HP增减幅组合效果
 *
 * 参数化测试命令：
 * -a [baseHP] : 设置基础HP
 * -b [value] : 增加基础HP
 * -c [value] : 设置HP增幅比例
 * -d [value] : 设置HP减幅比例
 */

//! zinc

library UTUnitAttr requires UnitAttr {
	private unit testUnit = null;
	private unitAttr testAttr = 0;

	// 创建测试单位
	private function CreateTestUnit(player p) {
		if (testUnit != null) {
			RemoveUnit(testUnit);
		}
		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0); // 使用步兵作为测试单位
		testAttr = unitAttr.parse(testUnit);
		testAttr.addHP(100);
		SelectUnit(testUnit,true);
	}

	// 测试基础HP的增减
	function TTestUTUnitAttr1(player p) {
		CreateTestUnit(p);
		BJDebugMsg("测试1开始: 基础HP增减测试");

		BJDebugMsg("初始基础HP: " + R2S(testAttr.getCurrentHP()));
		testAttr.addHP(50);
		BJDebugMsg("增加50点HP后: " + R2S(testAttr.getCurrentHP()));
		testAttr.addHP(-30);
		BJDebugMsg("减少30点HP后: " + R2S(testAttr.getCurrentHP()));
	}

	// 测试HP增幅比例
	function TTestUTUnitAttr2(player p) {
		CreateTestUnit(p);
		BJDebugMsg("测试2开始: HP增幅比例测试");

		BJDebugMsg("初始HP: " + R2S(testAttr.getCurrentHP()));
		testAttr.addHPRateUp(0.5); // 增加50%
		BJDebugMsg("增加50%增幅后: " + R2S(testAttr.getCurrentHP()));
		BJDebugMsg("当前HP倍率: " + R2S(testAttr.getCurrentHPRate()));
	}

	// 测试HP减幅比例
	function TTestUTUnitAttr3(player p) {
		CreateTestUnit(p);
		BJDebugMsg("测试3开始: HP减幅比例测试");

		BJDebugMsg("初始HP: " + R2S(testAttr.getCurrentHP()));
		testAttr.addHPRateDown(0.3); // 减少30%
		BJDebugMsg("增加30%减幅后: " + R2S(testAttr.getCurrentHP()));
		BJDebugMsg("当前HP倍率: " + R2S(testAttr.getCurrentHPRate()));
	}

	// 测试HP增减幅组合效果
	function TTestUTUnitAttr4(player p) {
		CreateTestUnit(p);
		BJDebugMsg("测试4开始: HP增减幅组合测试");

		BJDebugMsg("初始HP: " + R2S(testAttr.getCurrentHP()));
		testAttr.addHPRateUp(0.5);   // 增加50%
		testAttr.addHPRateDown(0.2); // 减少20%
		BJDebugMsg("增加50%增幅,20%减幅后: " + R2S(testAttr.getCurrentHP()));
		BJDebugMsg("当前HP倍率: " + R2S(testAttr.getCurrentHPRate()));
	}

	// 参数化测试处理函数
	function TTestActUTUnitAttr1(string str) {
		player  p     = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,    num = 0, len = StringLength(str);
		string  paramS[];
		integer paramI[];
		real    paramR[];

		// 解析参数
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

		if (testUnit == null) {
			CreateTestUnit(p);
		}

		// 处理不同的参数命令
		if (paramS[0] == "a") {
			// 设置基础HP
			testAttr.baseHP = paramR[1];
			BJDebugMsg("设置基础HP为: " + R2S(paramR[1]));
		} else if (paramS[0] == "b") {
			// 增加基础HP
			testAttr.addHP(paramR[1]);
			BJDebugMsg("增加基础HP: " + R2S(paramR[1]));
		} else if (paramS[0] == "c") {
			// 设置HP增幅
			testAttr.addHPRateUp(paramR[1]);
			BJDebugMsg("设置HP增幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "d") {
			// 设置HP减幅
			testAttr.addHPRateDown(paramR[1]);
			BJDebugMsg("设置HP减幅为: " + R2S(paramR[1]));
		}

		BJDebugMsg("当前HP: " + R2S(testAttr.getCurrentHP()));
		BJDebugMsg("当前HP倍率: " + R2S(testAttr.getCurrentHPRate()));

		p = null;
	}

	function Init() {
		player p = Player(0);
		BJDebugMsg("=== UnitAttr测试系统已加载 ===");

		// 创建测试单位
		CreateTestUnit(p);

		// 测试1.1：测试初始HP
		UnitTestAutoTimer(0.1, 0, function() {
			assert.Real(testAttr.getCurrentHP(), 100.0, "初始HP应为100");
		}, null);

		// 测试1.2：测试增加HP
		UnitTestAutoTimer(0.6, 0, function() {
			testAttr.addHP(50);
			assert.Real(testAttr.getCurrentHP(), 150.0, "增加50点HP后应为150");
		}, null);

		// 测试1.3：测试减少HP
		UnitTestAutoTimer(1.1, 0, function() {
			testAttr.addHP(-30);
			assert.Real(testAttr.getCurrentHP(), 120.0, "减少30点HP后应为120");
		}, null);

		// 测试2：HP增幅比例测试
		UnitTestAutoTimer(1.6, 0, function() {
			CreateTestUnit(Player(0));
			testAttr.addHPRateUp(0.5);
			assert.Real(testAttr.getCurrentHP(), 150.0, "增加50%增幅后应为150");
			assert.Real(testAttr.getCurrentHPRate(), 1.5, "当前HP倍率应为1.5");
		}, null);

		// 测试3：HP减幅比例测试
		UnitTestAutoTimer(2.1, 0, function() {
			CreateTestUnit(Player(0));
			testAttr.addHPRateDown(0.3);
			assert.Real(testAttr.getCurrentHP(), 70.0, "增加30%减幅后应为70");
			assert.Real(testAttr.getCurrentHPRate(), 0.7, "当前HP倍率应为0.7");
		}, null);

		// 测试4：HP增减幅组合效果测试
		UnitTestAutoTimer(2.6, 0, function() {
			CreateTestUnit(Player(0));
			testAttr.addHPRateUp(0.5);
			testAttr.addHPRateDown(0.2);
			assert.Real(testAttr.getCurrentHP(), 120.0, "增加50%增幅,20%减幅后应为120");
			assert.Real(testAttr.getCurrentHPRate(), 1.2, "当前HP倍率应为1.2");
		}, null);

		// 测试5：HP减幅的递减收益测试
		UnitTestAutoTimer(3.1, 0, function() {
			CreateTestUnit(Player(0));

			// 测试两个30%减幅的叠加
			testAttr.addHPRateDown(0.3);
			testAttr.addHPRateDown(0.3);
			// 期望值：1 - (1-0.3)*(1-0.3) = 0.51，所以最终HP应该是100*(1-0.51)=49
			assert.Real(testAttr.getCurrentHP(), 49.0, "两个30%减幅叠加后应为49");
			assert.Real(testAttr.getHPRateDown(), 0.51, "两个30%减幅叠加后减幅值应为0.51");

			// 测试第三个30%减幅的叠加
			testAttr.addHPRateDown(0.3);
			// 期望值：1 - (1-0.51)*(1-0.3) ≈ 0.657，所以最终HP应该是100*(1-0.657)=34.3
			assert.Real(testAttr.getCurrentHP(), 34.3, "三个30%减幅叠加后应为34.3");
			assert.Real(testAttr.getHPRateDown(), 0.657, "三个30%减幅叠加后减幅值应为0.657");
		}, null);

		// 测试6：HP减幅的反向恢复测试
		UnitTestAutoTimer(3.6, 0, function() {
			CreateTestUnit(Player(0));

			// 先加一个减幅
			testAttr.addHPRateDown(0.3);
			assert.Real(testAttr.getCurrentHP(), 70.0, "30%减幅后应为70");

			// 加入反向值测试恢复
			testAttr.addHPRateDown(-0.3);
			assert.Real(testAttr.getCurrentHP(), 100.0, "加入反向值后应恢复到100");
			assert.Real(testAttr.getHPRateDown(), 0.0, "加入反向值后减幅应为0");
		}, null);

		// 测试7：HP减幅的复杂叠加测试
		UnitTestAutoTimer(4.1, 0, function() {
			CreateTestUnit(Player(0));

			// 测试多个不同数值的减幅叠加
			testAttr.addHPRateDown(0.2);  // 20%减幅
			testAttr.addHPRateDown(0.3);  // 30%减幅
			testAttr.addHPRateDown(0.1);  // 10%减幅

			// 计算期望值：
			// 第一次：0.2
			// 第二次：1-(1-0.2)*(1-0.3) = 0.44
			// 第三次：1-(1-0.44)*(1-0.1) ≈ 0.496
			assert.Real(testAttr.getCurrentHP(), 50.4, "20%,30%,10%减幅叠加后应为50.4");
			assert.Real(testAttr.getHPRateDown(), 0.496, "20%,30%,10%减幅叠加后减幅值应为0.496");
		}, null);

		p = null;
	}

	function onInit() {
		//在游戏开始0.5秒后初始化
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function() {
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		// 注册聊天事件
		UnitTestRegisterChatEvent(function() {
			string str = GetEventPlayerChatString();

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitAttr1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "hp1") TTestUTUnitAttr1(GetTriggerPlayer());
			else if(str == "hp2") TTestUTUnitAttr2(GetTriggerPlayer());
			else if(str == "hp3") TTestUTUnitAttr3(GetTriggerPlayer());
			else if(str == "hp4") TTestUTUnitAttr4(GetTriggerPlayer());
		});
	}
}

//! endzinc
#endif
