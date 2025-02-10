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
* s5 - 测试随机创建和删除
* s6 - 测试单位销毁时的清理
*
* -a [unitId] - 创建指定ID的测试单位
* -b [spellId] - 为当前选中单位添加指定技能
*/
library UTUnitSpell requires UnitSpell {

	private unit testUnit = null;
	private unitSpell us = 0;
	private boolean toggle5 = false;

	// 用于Simple技能回调测试的全局变量
	private integer simpleSpellInitCount = 0;
	private integer simpleSpellDestroyCount = 0;

	function Init() {
		// 测试1: parse创建 - 0.1秒
		spellData sd = spellData.byType('AHbz');
		sd = spellData.byType('AHtb');
		sd = spellData.byType('AHtc');
		sd = spellData.byType('AHmt');
		sd = spellData.byType('AHfs');
		UnitTestAutoTimer(0.1, 0, function() {
			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			us = unitSpell.parse(testUnit);

			Trace("测试1: unitSpell.parse创建");
			assert.Boolean(us != 0, "单位是否有效");
			assert.Boolean(us.u == testUnit, "绑定单位是否正确");
		}, null);

		// 测试2: get获取 - 0.2秒
		UnitTestAutoTimer(0.2, 0, function() {
			unitSpell us2;

			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			us = unitSpell.parse(testUnit);
			us2 = unitSpell.get(testUnit);

			Trace("测试2: unitSpell.get获取");
			assert.Boolean(us == us2, "获取实例是否相同");
		}, null);

		// 测试3: addSpell和getSpell - 0.3秒
		UnitTestAutoTimer(0.3, 0, function() {
			spell sp;

			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			us = unitSpell.parse(testUnit);
			sp = spell.entity(testUnit, 'AHbz', 1);

			us.addSpell(sp);
			Trace("测试3: addSpell和getSpell");
			assert.Boolean(us.getSpell(0) == sp, "获取技能是否正确");
		}, null);

		// 测试4: getSpellCount - 0.4秒
		UnitTestAutoTimer(0.4, 0, function() {
			spell sp;
			integer countBefore;

			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			us = unitSpell.parse(testUnit);
			sp = spell.entity(testUnit, 'AHbz', 1);

			countBefore = us.getSpellCount();
			us.addSpell(sp);

			Trace("测试4: getSpellCount");
			assert.Boolean(us.getSpellCount() == countBefore + 1, "技能数量是否正确");
		}, null);

		// 测试6: 单位销毁清理 - 0.5秒
		UnitTestAutoTimer(0.5, 0, function() {
			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			us = unitSpell.parse(testUnit);

			Trace("测试6: 单位销毁清理");
			assert.Boolean(us.isExist(), "销毁前unitSpell存在");
			RemoveUnit(testUnit);
			assert.Boolean(!us.isExist(), "销毁后unitSpell不存在");
			testUnit = null;
		}, null);

		// 测试7: 技能添加删除测试 - 0.6秒
		UnitTestAutoTimer(0.6, 0, function() {
			integer spellIds[]; // 不同的技能ID
			integer i = 0;
			boolean removeResult = false;
			spell invalidSpell = 0;
			spellData sd = 0;

			Trace("开始测试7: 技能添加删除测试");

			spellIds[0] = 'AHbz';
			spellIds[1] = 'AHtb';
			spellIds[2] = 'AHtc';
			spellIds[3] = 'AHmt';
			spellIds[4] = 'AHfs';

			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			us = unitSpell.parse(testUnit);

			// 添加5个不同的技能
			for (0 <= i < 5) {
				sd = spellData.byType(spellIds[i]);
				us.addSpellData(sd, 1);
			}

			// 测试技能数量
			assert.Integer(us.getSpellCount(), 5, "添加5个技能后数量是否为5");

			// 测试删除不存在的技能
			removeResult = us.removeSpell(invalidSpell);
			assert.Boolean(!removeResult, "删除不存在的技能应该返回false");

			// 逐个删除技能并检查数量
			for (0 <= i < 5) {
				sd = spellData.byType(spellIds[i]);
				removeResult = us.removeSpellData(sd);
				assert.Boolean(removeResult, "删除第" + I2S(i + 1) + "个技能应该成功");
				assert.Integer(us.getSpellCount(), 4 - i, "删除后技能数量应该为" + I2S(4 - i));
			}

			// 最终检查
			assert.Integer(us.getSpellCount(), 0, "删除所有技能后数量应该为0");
		}, null);

		// 测试8: 重复添加技能测试 - 0.7秒
		UnitTestAutoTimer(0.7, 0, function() {
			spell sp1, sp2;
			spellData sd;

			Trace("开始测试8: 重复添加技能测试");

			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			us = unitSpell.parse(testUnit);

			// 测试重复添加相同的spell实例
			sp1 = spell.entity(testUnit, 'AHbz', 1);
			assert.Boolean(us.addSpell(sp1), "首次添加技能实例应该成功");
			assert.Boolean(!us.addSpell(sp1), "重复添加相同技能实例应该失败");
			assert.Integer(us.getSpellCount(), 1, "重复添加后技能数量应该为1");

			// 测试重复添加相同的spellData
			sd = spellData.byType('AHtb');
			assert.Boolean(us.addSpellData(sd, 1), "首次通过spellData添加技能应该成功");
			assert.Boolean(!us.addSpellData(sd, 1), "重复添加相同spellData应该失败");
			assert.Integer(us.getSpellCount(), 2, "重复添加后技能数量应该为2");
		}, null);

		// 测试9: Simple技能测试 - 0.8秒
		UnitTestAutoTimer(0.8, 0, function() {
			spellData sd;
			spellData sds[];
			integer i;


			boolean addResult = false;
			boolean removeResult = false;

			Trace("开始测试9: Simple技能测试");

			if (testUnit != null) {
				RemoveUnit(testUnit);
			}

			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			us = unitSpell.parse(testUnit);

			// 创建Simple类型的技能数据
			sd = spellData.new();
			sd.spellType = SPELL_TYPE_SIMPLE;
			sd.maxLevel = 3;

			for (1 <= i <= 3) {
				sds[i] = spellData.new();
				sds[i].spellType = SPELL_TYPE_SIMPLE;
				sds[i].maxLevel = 2+i;
			}


			// 注册初始化和销毁回调
			sd.registerInit(function() {
				simpleSpellInitCount += 1;
				Trace("Simple技能初始化回调被调用, 当前计数: " + I2S(simpleSpellInitCount));
			});
			sd.registerDestroy(function() {
				simpleSpellDestroyCount += 1;
				Trace("Simple技能销毁回调被调用, 当前计数: " + I2S(simpleSpellDestroyCount));
			});

			// 测试添加Simple技能
			addResult = us.addSpellData(sd, 2);
			assert.Boolean(addResult, "添加Simple技能应该成功");
			assert.Integer(us.getSimpleSpellCount(), 1, "Simple技能数量应该为1");
			assert.Integer(simpleSpellInitCount, 1, "Simple技能初始化回调应该被调用一次");

			// 测试获取Simple技能
			assert.Boolean(us.getSimpleSpell(0) == sd, "获取Simple技能应该返回正确的spellData");
			assert.Boolean(us.hasSpellData(sd), "hasSpellData应该能检测到Simple技能");

			// 测试重复添加
			addResult = us.addSpellData(sd, 2);
			assert.Boolean(!addResult, "重复添加Simple技能应该失败");
			assert.Integer(us.getSimpleSpellCount(), 1, "重复添加后Simple技能数量应该仍为1");

			// 测试删除Simple技能
			removeResult = us.removeSpellData(sd);
			assert.Boolean(removeResult, "删除Simple技能应该成功");
			assert.Integer(us.getSimpleSpellCount(), 0, "删除后Simple技能数量应该为0");
			assert.Integer(simpleSpellDestroyCount, 1, "Simple技能销毁回调应该被调用一次");

			// 测试删除不存在的Simple技能
			removeResult = us.removeSpellData(sd);
			assert.Boolean(!removeResult, "删除不存在的Simple技能应该失败");

			// 测试添加多个Simple技能
			for (1 <= i <= 3) {
				addResult = us.addSpellData(sds[i], i);
				assert.Boolean(addResult, "添加第" + I2S(i) + "个Simple技能应该成功");
				assert.Integer(us.getSimpleSpellCount(), i, "添加" + I2S(i) + "个Simple技能后数量应该为" + I2S(i));
			}

			// 测试获取多个Simple技能
			for (1 <= i <= 3) {
				assert.Boolean(us.getSimpleSpell(i-1) == sds[i], "获取第" + I2S(i) + "个Simple技能应该返回正确的spellData");
				assert.Boolean(us.hasSpellData(sds[i]), "hasSpellData应该能检测到第" + I2S(i) + "个Simple技能");
			}

			// 测试逐个删除Simple技能
			for (1 <= i <= 3) {
				removeResult = us.removeSpellData(sds[i]);
				assert.Boolean(removeResult, "删除第" + I2S(i) + "个Simple技能应该成功");
				assert.Integer(us.getSimpleSpellCount(), 3-i, "删除后Simple技能数量应该为" + I2S(3-i));
			}

			// 测试全部删除后再次删除
			for (1 <= i <= 3) {
				removeResult = us.removeSpellData(sds[i]);
				assert.Boolean(!removeResult, "删除已删除的Simple技能应该失败");
			}
		}, null);
	}

	// 测试用例函数保持空实现
	function TTestUTUnitSpell1(player p) {}
	function TTestUTUnitSpell2(player p) {}
	function TTestUTUnitSpell3(player p) {}
	function TTestUTUnitSpell4(player p) {}

	// 只保留测试5的实现，因为它是交互式的随机创建删除测试
	function TTestUTUnitSpell5(player p) {
		integer i;
		integer count;
		unit u;
		group g;
		unitSpell tempUs;

		if (toggle5) {
			// 删除模式：遍历所有单位并删除技能实例
			g = CreateGroup();
			GroupEnumUnitsInRect(g, GetPlayableMapRect(), null);
			ForGroup(g, function() {
				unit u = GetEnumUnit();
				unitSpell tempUs = unitSpell.get(u);
				if (tempUs != 0) {
					tempUs.destroy();
					Trace("删除了单位 " + GetUnitName(u) + " 的技能实例");
				}
				u = null;
			});
			DestroyGroup(g);
			g = null;
			Trace("已清理所有技能实例");
		} else {
			// 创建模式：随机创建10-20个带技能的单位
			count = GetRandomInt(10, 20);
			Trace("准备创建 " + I2S(count) + " 个测试单位");

			for (0 <= i < count) {
				u = CreateUnit(p, 'hfoo',
				GetRandomReal(-1000, 1000),
				GetRandomReal(-1000, 1000),
				GetRandomReal(0, 360));

				tempUs = unitSpell.parse(u);
				if (tempUs != 0) {
					Trace("创建第 " + I2S(i + 1) + " 个单位的技能实例成功");
				}
				u = null;
			}
			Trace("完成创建测试单位");
		}

		toggle5 = !toggle5;
	}

	function TTestUTUnitSpell6(player p) {}

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
			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(p, paramI[1], 0, 0, 0);
			us = unitSpell.parse(testUnit);
			Trace("创建测试单位: " + I2S(paramI[1]));
		} else if (paramS[0] == "b") {
			selectedUnit = unitSelect.currentU[index];
			if (selectedUnit != null) {
				us = unitSpell.get(selectedUnit);
				if (us != 0) {
					us.addSpell(spell.entity(selectedUnit, paramI[1], 1));
					Trace("添加技能: " + I2S(paramI[1]));
				}
			}
		}

		p = null;
	}

	function onInit() {
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr, 0.5);
		TriggerAddCondition(tr, Condition(function() {
			Trace("[UnitSpell] 单元测试已加载");
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
