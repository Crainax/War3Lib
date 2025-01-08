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

#include "Crainax/units/attribute/UnitAttr.j"

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
		testAttr.baseHP = 100; // 设置初始基础HP为100
		testAttr.hpRateUp = 0;
		testAttr.hpRateDown = 0;
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
		BJDebugMsg("=== UnitAttr测试系统已加载 ===");
		BJDebugMsg("使用hp1-hp4测试预设功能");
		BJDebugMsg("使用-a [value]设置基础HP");
		BJDebugMsg("使用-b [value]增加基础HP");
		BJDebugMsg("使用-c [value]设置HP增幅");
		BJDebugMsg("使用-d [value]设置HP减幅");
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
