#ifndef UTItemAbilityIncluded
#define UTItemAbilityIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "D:/War3/Library/War3Lib/Jass/item/ItemAbility.j"

//! zinc

//自动生成的文件
library UTItemAbility requires ItemAbility {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);
	}

	// 测试物品技能基础配置
	function TTestUTItemAbility1 (player p) {
		integer testItemId; integer testAbilityId; integer testLevel;

		BJDebugMsg("|cFFFF66CC【测试1】|r 物品技能基础配置测试");

		// 测试物品ID和技能ID
		testItemId = 'I000';  // 假设的测试物品ID
		testAbilityId = 'A000';  // 假设的测试技能ID
		testLevel = 3;

		// 配置物品技能1
		SetItemtypeAbility1(testItemId, testAbilityId, testLevel);

		// 检查配置是否成功
		if (ItemtypeHasAbility(testItemId)) {
			BJDebugMsg("|cFF00FF00✓|r 物品技能配置成功");
		} else {
			BJDebugMsg("|cFFFF0000✗|r 物品技能配置失败");
		}

		// 清除配置
		SetItemtypeAbility1(testItemId, 0, 0);
		if (!ItemtypeHasAbility(testItemId)) {
			BJDebugMsg("|cFF00FF00✓|r 物品技能清除成功");
		} else {
			BJDebugMsg("|cFFFF0000✗|r 物品技能清除失败");
		}
	}

	// 测试双技能配置
	function TTestUTItemAbility2 (player p) {
		integer testItemId; integer ability1; integer ability2; integer level1; integer level2;

		BJDebugMsg("|cFFFF66CC【测试2】|r 双技能配置测试");

		testItemId = 'I001';
		ability1 = 'A001';
		ability2 = 'A002';
		level1 = 2;
		level2 = 4;

		// 配置两个技能
		SetItemtypeAbility1(testItemId, ability1, level1);
		SetItemtypeAbility2(testItemId, ability2, level2);

		if (ItemtypeHasAbility(testItemId)) {
			BJDebugMsg("|cFF00FF00✓|r 双技能配置成功");
		} else {
			BJDebugMsg("|cFFFF0000✗|r 双技能配置失败");
		}

		// 清除配置
		SetItemtypeAbility1(testItemId, 0, 0);
		SetItemtypeAbility2(testItemId, 0, 0);
	}

	// 测试单位获得物品技能
	function TTestUTItemAbility3 (player p) {
		unit testUnit; integer testItemId; integer testAbilityId; integer testLevel;

		BJDebugMsg("|cFFFF66CC【测试3】|r 单位获得物品技能测试");

		// 创建测试单位
		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		testItemId = 'I002';
		testAbilityId = 'A003';
		testLevel = 2;

		// 配置物品技能
		SetItemtypeAbility1(testItemId, testAbilityId, testLevel);

		// 单位获得物品技能
		UnitGetItemtypeAbility(testUnit, testItemId);

		// 检查技能是否获得
		if (GetUnitAbilityLevel(testUnit, testAbilityId) >= testLevel) {
			BJDebugMsg("|cFF00FF00✓|r 单位成功获得物品技能，等级: " + I2S(GetUnitAbilityLevel(testUnit, testAbilityId)));
		} else {
			BJDebugMsg("|cFFFF0000✗|r 单位未获得物品技能");
		}

		// 清理
		UnitLostItemtypeAbility(testUnit, testItemId);
		SetItemtypeAbility1(testItemId, 0, 0);
		RemoveUnit(testUnit);
		testUnit = null;
	}

	// 测试单位失去物品技能
	function TTestUTItemAbility4 (player p) {
		unit testUnit; integer testItemId; integer testAbilityId; integer testLevel;

		BJDebugMsg("|cFFFF66CC【测试4】|r 单位失去物品技能测试");

		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		testItemId = 'I003';
		testAbilityId = 'A004';
		testLevel = 3;

		// 配置并授予技能
		SetItemtypeAbility1(testItemId, testAbilityId, testLevel);
		UnitGetItemtypeAbility(testUnit, testItemId);

		// 失去技能
		UnitLostItemtypeAbility(testUnit, testItemId);

		// 检查技能是否移除
		if (GetUnitAbilityLevel(testUnit, testAbilityId) == 0) {
			BJDebugMsg("|cFF00FF00✓|r 单位成功失去物品技能");
		} else {
			BJDebugMsg("|cFFFF0000✗|r 单位仍保留物品技能，等级: " + I2S(GetUnitAbilityLevel(testUnit, testAbilityId)));
		}

		// 清理
		SetItemtypeAbility1(testItemId, 0, 0);
		RemoveUnit(testUnit);
		testUnit = null;
	}

	// 测试技能等级叠加
	function TTestUTItemAbility5 (player p) {
		unit testUnit; integer testItemId1; integer testItemId2; integer testAbilityId; integer level1; integer level2;

		BJDebugMsg("|cFFFF66CC【测试5】|r 技能等级叠加测试");

		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		testItemId1 = 'I004';
		testItemId2 = 'I005';
		testAbilityId = 'A005';
		level1 = 2;
		level2 = 4;

		// 配置两个物品都有相同技能但不同等级
		SetItemtypeAbility1(testItemId1, testAbilityId, level1);
		SetItemtypeAbility1(testItemId2, testAbilityId, level2);

		// 单位获得第一个物品技能
		UnitGetItemtypeAbility(testUnit, testItemId1);
		BJDebugMsg("获得第一个物品后技能等级: " + I2S(GetUnitAbilityLevel(testUnit, testAbilityId)));

		// 单位获得第二个物品技能（应该取最大等级）
		UnitGetItemtypeAbility(testUnit, testItemId2);
		BJDebugMsg("获得第二个物品后技能等级: " + I2S(GetUnitAbilityLevel(testUnit, testAbilityId)));

		if (GetUnitAbilityLevel(testUnit, testAbilityId) == level2) {
			BJDebugMsg("|cFF00FF00✓|r 技能等级叠加正确，取最大等级");
		} else {
			BJDebugMsg("|cFFFF0000✗|r 技能等级叠加错误");
		}

		// 清理
		UnitLostItemtypeAbility(testUnit, testItemId1);
		UnitLostItemtypeAbility(testUnit, testItemId2);
		SetItemtypeAbility1(testItemId1, 0, 0);
		SetItemtypeAbility1(testItemId2, 0, 0);
		RemoveUnit(testUnit);
		testUnit = null;
	}

	// 测试技能等级回退
	function TTestUTItemAbility6 (player p) {
		unit testUnit; integer testItemId1; integer testItemId2; integer testAbilityId; integer level1; integer level2;

		BJDebugMsg("|cFFFF66CC【测试6】|r 技能等级回退测试");

		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		testItemId1 = 'I006';
		testItemId2 = 'I007';
		testAbilityId = 'A006';
		level1 = 2;
		level2 = 4;

		// 配置并授予两个不同等级的同技能
		SetItemtypeAbility1(testItemId1, testAbilityId, level1);
		SetItemtypeAbility1(testItemId2, testAbilityId, level2);
		UnitGetItemtypeAbility(testUnit, testItemId1);
		UnitGetItemtypeAbility(testUnit, testItemId2);

		BJDebugMsg("获得两个物品后技能等级: " + I2S(GetUnitAbilityLevel(testUnit, testAbilityId)));

		// 失去高等级物品，应该回退到低等级
		UnitLostItemtypeAbility(testUnit, testItemId2);
		BJDebugMsg("失去高等级物品后技能等级: " + I2S(GetUnitAbilityLevel(testUnit, testAbilityId)));

		if (GetUnitAbilityLevel(testUnit, testAbilityId) == level1) {
			BJDebugMsg("|cFF00FF00✓|r 技能等级回退正确");
		} else {
			BJDebugMsg("|cFFFF0000✗|r 技能等级回退错误");
		}

		// 失去最后一个物品，技能应该完全移除
		UnitLostItemtypeAbility(testUnit, testItemId1);
		if (GetUnitAbilityLevel(testUnit, testAbilityId) == 0) {
			BJDebugMsg("|cFF00FF00✓|r 技能完全移除正确");
		} else {
			BJDebugMsg("|cFFFF0000✗|r 技能完全移除错误");
		}

		// 清理
		SetItemtypeAbility1(testItemId1, 0, 0);
		SetItemtypeAbility1(testItemId2, 0, 0);
		RemoveUnit(testUnit);
		testUnit = null;
	}

	// 测试边界情况
	function TTestUTItemAbility7 (player p) {
		BJDebugMsg("|cFFFF66CC【测试7】|r 边界情况测试");

		// 测试无效参数
		SetItemtypeAbility1(0, 0, 0);
		SetItemtypeAbility1(0, 'A007', 0);
		SetItemtypeAbility1('I008', 0, 3);
		SetItemtypeAbility1('I008', 'A007', -1);

		// 检查无效配置是否被正确处理
		if (!ItemtypeHasAbility(0)) {
			BJDebugMsg("|cFF00FF00✓|r 无效参数处理正确");
		} else {
			BJDebugMsg("|cFFFF0000✗|r 无效参数处理错误");
		}

		// 测试正常配置
		SetItemtypeAbility1('I008', 'A007', 1);
		if (ItemtypeHasAbility('I008')) {
			BJDebugMsg("|cFF00FF00✓|r 正常配置成功");
		} else {
			BJDebugMsg("|cFFFF0000✗|r 正常配置失败");
		}

		// 清理
		SetItemtypeAbility1('I008', 0, 0);
	}

	// 测试双技能同时获得和失去
	function TTestUTItemAbility8 (player p) {
		unit testUnit; integer testItemId; integer ability1; integer ability2; integer level1; integer level2;

		BJDebugMsg("|cFFFF66CC【测试8】|r 双技能同时操作测试");

		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		testItemId = 'I009';
		ability1 = 'A008';
		ability2 = 'A009';
		level1 = 2;
		level2 = 3;

		// 配置双技能
		SetItemtypeAbility1(testItemId, ability1, level1);
		SetItemtypeAbility2(testItemId, ability2, level2);

		// 同时获得两个技能
		UnitGetItemtypeAbility(testUnit, testItemId);

		BJDebugMsg("技能1等级: " + I2S(GetUnitAbilityLevel(testUnit, ability1)));
		BJDebugMsg("技能2等级: " + I2S(GetUnitAbilityLevel(testUnit, ability2)));

		if (GetUnitAbilityLevel(testUnit, ability1) == level1 && GetUnitAbilityLevel(testUnit, ability2) == level2) {
			BJDebugMsg("|cFF00FF00✓|r 双技能同时获得成功");
		} else {
			BJDebugMsg("|cFFFF0000✗|r 双技能同时获得失败");
		}

		// 同时失去两个技能
		UnitLostItemtypeAbility(testUnit, testItemId);

		if (GetUnitAbilityLevel(testUnit, ability1) == 0 && GetUnitAbilityLevel(testUnit, ability2) == 0) {
			BJDebugMsg("|cFF00FF00✓|r 双技能同时失去成功");
		} else {
			BJDebugMsg("|cFFFF0000✗|r 双技能同时失去失败");
		}

		// 清理
		SetItemtypeAbility1(testItemId, 0, 0);
		SetItemtypeAbility2(testItemId, 0, 0);
		RemoveUnit(testUnit);
		testUnit = null;
	}

	// 测试多次获得同一物品
	function TTestUTItemAbility9 (player p) {
		unit testUnit; integer testItemId; integer testAbilityId; integer testLevel;

		BJDebugMsg("|cFFFF66CC【测试9】|r 多次获得同一物品测试");

		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		testItemId = 'I010';
		testAbilityId = 'A010';
		testLevel = 2;

		// 配置物品技能
		SetItemtypeAbility1(testItemId, testAbilityId, testLevel);

		// 多次获得同一物品技能
		UnitGetItemtypeAbility(testUnit, testItemId);
		UnitGetItemtypeAbility(testUnit, testItemId);
		UnitGetItemtypeAbility(testUnit, testItemId);

		BJDebugMsg("多次获得后技能等级: " + I2S(GetUnitAbilityLevel(testUnit, testAbilityId)));

		// 失去一次
		UnitLostItemtypeAbility(testUnit, testItemId);
		BJDebugMsg("失去一次后技能等级: " + I2S(GetUnitAbilityLevel(testUnit, testAbilityId)));

		// 失去剩余次数
		UnitLostItemtypeAbility(testUnit, testItemId);
		UnitLostItemtypeAbility(testUnit, testItemId);

		if (GetUnitAbilityLevel(testUnit, testAbilityId) == 0) {
			BJDebugMsg("|cFF00FF00✓|r 多次获得/失去处理正确");
		} else {
			BJDebugMsg("|cFFFF0000✗|r 多次获得/失去处理错误");
		}

		// 清理
		SetItemtypeAbility1(testItemId, 0, 0);
		RemoveUnit(testUnit);
		testUnit = null;
	}

	// 综合测试
	function TTestUTItemAbility10 (player p) {
		unit testUnit; integer item1; integer item2; integer ability1; integer ability2; integer level1; integer level2;

		BJDebugMsg("|cFFFF66CC【测试10】|r 综合测试");

		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		item1 = 'I011';
		item2 = 'I012';
		ability1 = 'A011';
		ability2 = 'A012';
		level1 = 3;
		level2 = 5;

		// 配置两个物品，每个都有双技能
		SetItemtypeAbility1(item1, ability1, level1);
		SetItemtypeAbility2(item1, ability2, level2);
		SetItemtypeAbility1(item2, ability1, level1 + 1);  // 更高等级
		SetItemtypeAbility2(item2, ability2, level2 - 1);  // 更低等级

		// 获得第一个物品
		UnitGetItemtypeAbility(testUnit, item1);
		BJDebugMsg("获得物品1后 - 技能1等级: " + I2S(GetUnitAbilityLevel(testUnit, ability1)) + ", 技能2等级: " + I2S(GetUnitAbilityLevel(testUnit, ability2)));

		// 获得第二个物品
		UnitGetItemtypeAbility(testUnit, item2);
		BJDebugMsg("获得物品2后 - 技能1等级: " + I2S(GetUnitAbilityLevel(testUnit, ability1)) + ", 技能2等级: " + I2S(GetUnitAbilityLevel(testUnit, ability2)));

		// 失去第一个物品
		UnitLostItemtypeAbility(testUnit, item1);
		BJDebugMsg("失去物品1后 - 技能1等级: " + I2S(GetUnitAbilityLevel(testUnit, ability1)) + ", 技能2等级: " + I2S(GetUnitAbilityLevel(testUnit, ability2)));

		// 失去第二个物品
		UnitLostItemtypeAbility(testUnit, item2);
		BJDebugMsg("失去物品2后 - 技能1等级: " + I2S(GetUnitAbilityLevel(testUnit, ability1)) + ", 技能2等级: " + I2S(GetUnitAbilityLevel(testUnit, ability2)));

		if (GetUnitAbilityLevel(testUnit, ability1) == 0 && GetUnitAbilityLevel(testUnit, ability2) == 0) {
			BJDebugMsg("|cFF00FF00✓|r 综合测试通过");
		} else {
			BJDebugMsg("|cFFFF0000✗|r 综合测试失败");
		}

		// 清理
		SetItemtypeAbility1(item1, 0, 0);
		SetItemtypeAbility2(item1, 0, 0);
		SetItemtypeAbility1(item2, 0, 0);
		SetItemtypeAbility2(item2, 0, 0);
		RemoveUnit(testUnit);
		testUnit = null;
	}
	function TTestActUTItemAbility1 (string str) {
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

		if (paramS[0] == "config") {
			// 配置测试物品技能: -config itemId abilityId level
			if (num >= 3) {
				integer itemId = paramI[1];
				integer abilityId = paramI[2];
				integer level = paramI[3];
				SetItemtypeAbility1(itemId, abilityId, level);
				BJDebugMsg("|cFF00FF00配置成功|r 物品ID: " + I2S(itemId) + ", 技能ID: " + I2S(abilityId) + ", 等级: " + I2S(level));
			} else {
				BJDebugMsg("|cFFFF0000参数不足|r 用法: -config itemId abilityId level");
			}
		} else if (paramS[0] == "check") {
			// 检查物品是否有技能: -check itemId
			if (num >= 1) {
				integer itemId = paramI[1];
				if (ItemtypeHasAbility(itemId)) {
					BJDebugMsg("|cFF00FF00物品有技能|r ID: " + I2S(itemId));
				} else {
					BJDebugMsg("|cFFFF0000物品无技能|r ID: " + I2S(itemId));
				}
			} else {
				BJDebugMsg("|cFFFF0000参数不足|r 用法: -check itemId");
			}
		} else if (paramS[0] == "grant") {
			// 授予单位物品技能: -grant itemId
			if (num >= 1) {
				integer itemId = paramI[1];
				unit u = GetTriggerUnit();
				if (u != null) {
					UnitGetItemtypeAbility(u, itemId);
					BJDebugMsg("|cFF00FF00授予成功|r 单位获得物品技能 ID: " + I2S(itemId));
				} else {
					BJDebugMsg("|cFFFF0000无目标单位|r");
				}
				u = null;
			} else {
				BJDebugMsg("|cFFFF0000参数不足|r 用法: -grant itemId");
			}
		} else if (paramS[0] == "revoke") {
			// 撤销单位物品技能: -revoke itemId
			if (num >= 1) {
				integer itemId = paramI[1];
				unit u = GetTriggerUnit();
				if (u != null) {
					UnitLostItemtypeAbility(u, itemId);
					BJDebugMsg("|cFF00FF00撤销成功|r 单位失去物品技能 ID: " + I2S(itemId));
				} else {
					BJDebugMsg("|cFFFF0000无目标单位|r");
				}
				u = null;
			} else {
				BJDebugMsg("|cFFFF0000参数不足|r 用法: -revoke itemId");
			}
		} else if (paramS[0] == "clear") {
			// 清除物品技能配置: -clear itemId
			if (num >= 1) {
				integer itemId = paramI[1];
				SetItemtypeAbility1(itemId, 0, 0);
				SetItemtypeAbility2(itemId, 0, 0);
				BJDebugMsg("|cFF00FF00清除成功|r 物品技能配置已清除 ID: " + I2S(itemId));
			} else {
				BJDebugMsg("|cFFFF0000参数不足|r 用法: -clear itemId");
			}
		} else if (paramS[0] == "help") {
			// 显示帮助信息
			BJDebugMsg("|cFFFF66CC【ItemAbility 测试命令】|r");
			BJDebugMsg("|cFF00FF00基础测试:|r s1-s10");
			BJDebugMsg("|cFF00FF00参数化测试:|r");
			BJDebugMsg("  -config itemId abilityId level  // 配置物品技能");
			BJDebugMsg("  -check itemId                   // 检查物品技能");
			BJDebugMsg("  -grant itemId                   // 授予单位技能");
			BJDebugMsg("  -revoke itemId                  // 撤销单位技能");
			BJDebugMsg("  -clear itemId                   // 清除技能配置");
			BJDebugMsg("  -help                           // 显示此帮助");
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[ItemAbility] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTItemAbility1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTItemAbility1(GetTriggerPlayer());
			else if(str == "s2") TTestUTItemAbility2(GetTriggerPlayer());
			else if(str == "s3") TTestUTItemAbility3(GetTriggerPlayer());
			else if(str == "s4") TTestUTItemAbility4(GetTriggerPlayer());
			else if(str == "s5") TTestUTItemAbility5(GetTriggerPlayer());
			else if(str == "s6") TTestUTItemAbility6(GetTriggerPlayer());
			else if(str == "s7") TTestUTItemAbility7(GetTriggerPlayer());
			else if(str == "s8") TTestUTItemAbility8(GetTriggerPlayer());
			else if(str == "s9") TTestUTItemAbility9(GetTriggerPlayer());
			else if(str == "s10") TTestUTItemAbility10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
