#ifndef UTUnitSpellIncluded
#define UTUnitSpellIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
 * UnitSpell测试文件
 * 测试UnitSpell库的所有功能
 *
 * 测试命令:
 * s1 - 测试unitSpell.parse创建和基本属性
 * s2 - 测试unitSpell.get获取实例
 * s3 - 测试addSpell和getSpell
 * s4 - 测试getSpellCount
 * s5 - 测试默认技能初始化
 * s6 - 测试单位销毁时的清理
 *
 * -a [unitId] - 创建指定ID的测试单位
 * -b [spellId] - 为当前选中单位添加指定技能
 */
library UTUnitSpell requires UnitSpell {

	private unit testUnit = null;

	function Init() {
		UnitTestAutoTimer(0.1, 2.0, function() {
			// 初始化测试环境
			testUnit = null;
		}, function() {
			// 清理测试环境
			if (testUnit != null) {
				RemoveUnit(testUnit);
				testUnit = null;
			}
		});
	}

	// 测试unitSpell.parse创建和基本属性
	function TTestUTUnitSpell1(player p) {
		unitSpell us = unitSpell.parse(testUnit);
		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);

		BJDebugMsg("测试1: unitSpell.parse创建");
		BJDebugMsg("单位是否有效: " + B2S(us != 0));
		BJDebugMsg("绑定单位是否正确: " + B2S(us.u == testUnit));
	}

	// 测试unitSpell.get获取实例
	function TTestUTUnitSpell2(player p) {
		unitSpell us1 = unitSpell.parse(testUnit);
		unitSpell us2 = unitSpell.get(testUnit);
		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);

		BJDebugMsg("测试2: unitSpell.get获取");
		BJDebugMsg("获取实例是否相同: " + B2S(us1 == us2));
	}

	// 测试addSpell和getSpell
	function TTestUTUnitSpell3(player p) {
		unitSpell us = unitSpell.parse(testUnit);
		spell sp = spell.create(testUnit, 'AHbz', 1); // 创建一个测试技能
		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);

		us.addSpell(sp);
		BJDebugMsg("测试3: addSpell和getSpell");
		BJDebugMsg("获取技能是否正确: " + B2S(us.getSpell(0) == sp));
	}

	// 测试getSpellCount
	function TTestUTUnitSpell4(player p) {
		unitSpell us;
		spell sp;
		integer countBefore;

		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		us = unitSpell.parse(testUnit);
		sp = spell.create(testUnit, 'AHbz', 1);

		countBefore = us.getSpellCount();
		us.addSpell(sp);

		BJDebugMsg("测试4: getSpellCount");
		BJDebugMsg("技能数量是否正确: " + B2S(us.getSpellCount() == countBefore + 1));
	}

	// 测试默认技能初始化
	function TTestUTUnitSpell5(player p) {
		unitSpell us = unitSpell.parse(testUnit);
		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);

		BJDebugMsg("测试5: 默认技能初始化");
		BJDebugMsg("默认技能数量: " + I2S(us.getSpellCount()));
	}

	// 测试单位销毁时的清理
	function TTestUTUnitSpell6(player p) {
		unitSpell us = unitSpell.parse(testUnit);
		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);

		BJDebugMsg("测试6: 单位销毁清理");
		BJDebugMsg("销毁前unitSpell存在: " + B2S(us.isExist()));
		RemoveUnit(testUnit);
		BJDebugMsg("销毁后unitSpell存在: " + B2S(us.isExist()));
	}

	// 以下测试用例预留
	function TTestUTUnitSpell7(player p) {}
	function TTestUTUnitSpell8(player p) {}
	function TTestUTUnitSpell9(player p) {}
	function TTestUTUnitSpell10(player p) {}

	// 处理带参数的测试命令
	function TTestActUTUnitSpell1(string str) {
		player p;
		integer index;
		integer i;
		integer num;
		integer len;
		string paramS[];
		integer paramI[];
		real paramR[];
		unit selectedUnit;
		unitSpell us;
		spell sp;

		p = GetTriggerPlayer();
		index = GetConvertedPlayerId(p);
		num = 0;
		len = StringLength(str);

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

		if (paramS[0] == "a") {
			// 创建测试单位
			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(p, paramI[1], 0, 0, 0);
			BJDebugMsg("创建测试单位: " + I2S(paramI[1]));
		} else if (paramS[0] == "b") {
			// 为当前选中单位添加技能
			selectedUnit = GetSelectedUnit(p);
			if (selectedUnit != null) {
				us = unitSpell.get(selectedUnit);
				if (us != 0) {
					sp = spell.create(selectedUnit, paramI[1], 1);
					us.addSpell(sp);
					BJDebugMsg("添加技能: " + I2S(paramI[1]));
				}
			}
		}

		p = null;
	}

	function onInit() {
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr, 0.5);
		TriggerAddCondition(tr, Condition(function() {
			BJDebugMsg("[UnitSpell] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function() {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitSpell1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitSpell1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitSpell2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitSpell3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitSpell4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitSpell5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitSpell6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitSpell7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitSpell8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitSpell9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitSpell10(GetTriggerPlayer());
		});
	}
}
//! endzinc

#endif
