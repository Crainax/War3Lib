#ifndef UTUnitAttrIncluded
#define UTUnitAttrIncluded

/*
 * 单位属性系统测试文件
 *
 * 测试命令说明：
 *
 * HP相关命令：
 * -addhp [value] : 增加基础HP
 * -hpup [value] : 设置HP增幅比例
 * -hpdown [value] : 设置HP减幅比例
 *
 * MP相关命令：
 * -addmp [value] : 增加基础MP
 * -mpup [value] : 设置MP增幅比例
 * -mpdown [value] : 设置MP减幅比例
 *
 * 攻击力相关命令：
 * -atk [value] : 设置基础攻击力
 * -addatk [value] : 增加基础攻击力
 * -atkup [value] : 设置攻击力增幅比例
 * -atkdown [value] : 设置攻击力减幅比例
 * -atkbonus [value] : 设置攻击力固定加成
 *
 * 防御力相关命令：
 * -def [value] : 设置基础防御力
 * -adddef [value] : 增加基础防御力
 * -defup [value] : 设置防御力增幅比例
 * -defdown [value] : 设置防御力减幅比例
 * -defbonus [value] : 设置防御力固定加成
 *
 * 攻击速度相关命令：
 * -atkspd [value] : 增加基础攻击速度
 * -atkspddown [value] : 设置攻击速度减速比例
 *
 * 攻击范围相关命令：
 * -atkrange [value] : 增加基础攻击范围
 * -atkrangeup [value] : 设置攻击范围增幅比例
 * -atkrangedown [value] : 设置攻击范围减幅比例
 *
 * 攻击间隔相关命令：
 * -atkinterval [value] : 增加基础攻击间隔
 *
 * 其他测试命令：
 * -archer : 切换为弓箭手单位进行测试
 * -enemy [count] : 在远处创建指定数量的敌对单位
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
		// 默认使用步兵作为测试单位
		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		testAttr = unitAttr.parse(testUnit);
		testAttr.addHP(100);
		SelectUnit(testUnit,true);
	}

	// 创建弓箭手测试单位
	private function CreateArcherUnit(player p) {
		if (testUnit != null) {
			RemoveUnit(testUnit);
		}
		testUnit = CreateUnit(p, 'earc', 0, 0, 0); // 使用精灵弓箭手
		testAttr = unitAttr.parse(testUnit);
		testAttr.addHP(100);
		SelectUnit(testUnit,true);
	}

	// 测试基础HP的增减
	function TTestUTUnitAttr1(player p) {
	}

	// 测试HP增幅比例
	function TTestUTUnitAttr2(player p) {
	}

	// 测试HP减幅比例
	function TTestUTUnitAttr3(player p) {
	}

	// 测试HP增减幅组合效果
	function TTestUTUnitAttr4(player p) {
	}

	// 参数化测试处理函数
	function TTestActUTUnitAttr1(string str) {
		player  p     = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,    num = 0, len = StringLength(str);
		string  paramS[];
		integer paramI[];
		real    paramR[];
		unit    enemy;

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

		// HP相关命令
		if (paramS[0] == "addhp") {
			// 增加基础HP
			testAttr.addHP(paramR[1]);
			BJDebugMsg("增加基础HP: " + R2S(paramR[1]));
		} else if (paramS[0] == "hpup") {
			// 设置HP增幅
			testAttr.addHPRateUp(paramR[1]);
			BJDebugMsg("设置HP增幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "hpdown") {
			// 设置HP减幅
			testAttr.addHPRateDown(paramR[1]);
			BJDebugMsg("设置HP减幅为: " + R2S(paramR[1]));
		}
		// MP相关命令
		else if (paramS[0] == "addmp") {
			// 增加基础MP
			testAttr.addMP(paramR[1]);
			BJDebugMsg("增加基础MP: " + R2S(paramR[1]));
		} else if (paramS[0] == "mpup") {
			// 设置MP增幅
			testAttr.addMPRateUp(paramR[1]);
			BJDebugMsg("设置MP增幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "mpdown") {
			// 设置MP减幅
			testAttr.addMPRateDown(paramR[1]);
			BJDebugMsg("设置MP减幅为: " + R2S(paramR[1]));
		}
		// 攻击力相关命令
		else if (paramS[0] == "atk") {
			// 设置基础攻击力
			testAttr.setBaseAtk(paramR[1]);
			BJDebugMsg("设置基础攻击力为: " + R2S(paramR[1]));
		} else if (paramS[0] == "addatk") {
			// 增加基础攻击力
			testAttr.addBaseAtk(paramR[1]);
			BJDebugMsg("增加基础攻击力: " + R2S(paramR[1]));
		} else if (paramS[0] == "atkup") {
			// 设置攻击力增幅
			testAttr.addAtkRateUp(paramR[1]);
			BJDebugMsg("设置攻击力增幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "atkdown") {
			// 设置攻击力减幅
			testAttr.addAtkRateDown(paramR[1]);
			BJDebugMsg("设置攻击力减幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "atkbonus") {
			// 设置固定加成
			testAttr.addAtkFixedBonus(paramR[1]);
			BJDebugMsg("设置固定加成为: " + R2S(paramR[1]));
		}
		// 防御力相关命令
		else if (paramS[0] == "def") {
			// 设置基础防御力
			testAttr.setBaseDef(paramR[1]);
			BJDebugMsg("设置基础防御力为: " + R2S(paramR[1]));
		} else if (paramS[0] == "adddef") {
			// 增加基础防御力
			testAttr.addBaseDef(paramR[1]);
			BJDebugMsg("增加基础防御力: " + R2S(paramR[1]));
		} else if (paramS[0] == "defup") {
			// 设置防御力增幅
			testAttr.addDefRateUp(paramR[1]);
			BJDebugMsg("设置防御力增幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "defdown") {
			// 设置防御力减幅
			testAttr.addDefRateDown(paramR[1]);
			BJDebugMsg("设置防御力减幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "defbonus") {
			// 设置固定加成
			testAttr.addDefFixedBonus(paramR[1]);
			BJDebugMsg("设置防御力固定加成为: " + R2S(paramR[1]));
		}
		// 攻击速度相关命令
		else if (paramS[0] == "atkspd") {
			// 增加基础攻击速度
			testAttr.addAtkSpeed(paramR[1]);
			BJDebugMsg("增加基础攻击速度: " + R2S(paramR[1]));
			BJDebugMsg("当前攻击速度: " + R2S(testAttr.getCurrentAtkSpeed()));
		} else if (paramS[0] == "atkspddown") {
			// 设置攻击速度减速比例
			testAttr.addAtkSpdDown(paramR[1]);
			BJDebugMsg("攻击速度百分比减少: " + R2S(paramR[1]));
			BJDebugMsg("当前攻击速度: " + R2S(testAttr.getCurrentAtkSpeed()));
		}
		// 攻击范围相关命令
		else if (paramS[0] == "atkrange") {
			// 增加基础攻击范围
			testAttr.addAtkRange(paramR[1]);
			BJDebugMsg("增加基础攻击范围: " + R2S(paramR[1]));
			BJDebugMsg("当前攻击范围: " + R2S(testAttr.getCurrentAtkRange()));
		} else if (paramS[0] == "atkrangeup") {
			// 设置攻击范围增幅
			testAttr.addAtkRangeRateUp(paramR[1]);
			BJDebugMsg("设置攻击范围增幅: " + R2S(paramR[1]));
			BJDebugMsg("当前攻击范围: " + R2S(testAttr.getCurrentAtkRange()));
		} else if (paramS[0] == "atkrangedown") {
			// 设置攻击范围减幅
			testAttr.addAtkRangeRateDown(paramR[1]);
			BJDebugMsg("设置攻击范围减幅: " + R2S(paramR[1]));
			BJDebugMsg("当前攻击范围: " + R2S(testAttr.getCurrentAtkRange()));
		}
		// 攻击间隔相关命令
		else if (paramS[0] == "atkinterval") {
			// 增加基础攻击间隔
			testAttr.addAtkItvDown(paramR[1]);
			BJDebugMsg("攻击间隔百分比减少: " + R2S(paramR[1]));
			BJDebugMsg("当前攻击间隔: " + R2S(testAttr.getCurrentAtkInterval()));
		}
		// 其他测试命令
		else if (paramS[0] == "archer") {
			// 切换为弓箭手单位
			CreateArcherUnit(p);
			BJDebugMsg("已切换为弓箭手单位进行测试");
		} else if (paramS[0] == "enemy") {
			// 创建敌对单位
			for (0 <= i < paramI[1]) {
				enemy = CreateUnit(Player(11), 'hfoo', 500, 200 + i * 100, 270);
				SetUnitOwner(enemy, Player(11), true);
				// 设置敌对关系
				SetPlayerAllianceStateAllyBJ(Player(11), p, false);
				SetPlayerAllianceStateVisionBJ(Player(11), p, false);
			}
			BJDebugMsg("已创建 " + I2S(paramI[1]) + " 个敌对单位");
		}

		// 显示当前状态
		if (paramS[0] == "addhp" || paramS[0] == "hpup" || paramS[0] == "hpdown") {
			BJDebugMsg("当前HP: " + R2S(testAttr.getCurrentHP()));
			BJDebugMsg("当前HP倍率: " + R2S(testAttr.getCurrentHPRate()));
		} else if (paramS[0] == "addmp" || paramS[0] == "mpup" || paramS[0] == "mpdown") {
			BJDebugMsg("当前MP: " + R2S(testAttr.getCurrentMP()));
			BJDebugMsg("当前MP倍率: " + R2S(testAttr.getCurrentMPRate()));
		} else if (paramS[0] == "def" || paramS[0] == "adddef" || paramS[0] == "defup" || paramS[0] == "defdown" || paramS[0] == "defbonus") {
			BJDebugMsg("防御力: " + R2S(testAttr.baseDef) + " + " + R2S(testAttr.DefRateBonus + testAttr.DefFixedBonus));
		} else {
			BJDebugMsg("攻击力: " + R2S(testAttr.baseAtk) + " + " + R2S(testAttr.AtkRateBonus + testAttr.AtkFixedBonus));
		}

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
			assert.Real(testAttr.getCurrentHPRate(), 0.5, "当前HP倍率应为0.5");
		}, null);

		// 测试3：HP减幅比例测试
		UnitTestAutoTimer(2.1, 0, function() {
			CreateTestUnit(Player(0));
			testAttr.addHPRateDown(0.3);
			assert.Real(testAttr.getCurrentHP(), 70.0, "增加30%减幅后应为70");
			assert.Real(testAttr.getCurrentHPRate(), -0.3, "当前HP倍率应为-0.3");
		}, null);

		// 测试4：HP增减幅组合效果测试
		UnitTestAutoTimer(2.6, 0, function() {
			CreateTestUnit(Player(0));
			testAttr.addHPRateUp(0.5);
			testAttr.addHPRateDown(0.2);
			assert.Real(testAttr.getCurrentHP(), 120.0, "增加50%增幅,20%减幅后应为120");
			assert.Real(testAttr.getCurrentHPRate(), 0.2, "当前HP倍率应为0.2");
		}, null);

		// 测试5：HP减幅的递减收益测试
		UnitTestAutoTimer(3.1, 0, function() {
			CreateTestUnit(Player(0));

			// 测试两个30%减幅的叠加
			testAttr.addHPRateDown(0.3);
			testAttr.addHPRateDown(0.3);
			// 期望值：1 - (1-0.3)*(1-0.3) = 0.51，所以最终HP应该是100*(1-0.51)=49
			assert.Real(testAttr.getCurrentHP(), 49.0, "两个30%减幅叠加后应为49");
			assert.Real(testAttr.HPRateDown, 0.51, "两个30%减幅叠加后减幅值应为0.51");

			// 测试第三个30%减幅的叠加
			testAttr.addHPRateDown(0.3);
			// 期望值：1 - (1-0.51)*(1-0.3) ≈ 0.657，所以最终HP应该是100*(1-0.657)=34.3
			assert.Real(testAttr.getCurrentHP(), 34.3, "三个30%减幅叠加后应为34.3");
			assert.Real(testAttr.HPRateDown, 0.657, "三个30%减幅叠加后减幅值应为0.657");
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
			assert.Real(testAttr.HPRateDown, 0.0, "加入反向值后减幅应为0");
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
			assert.Real(testAttr.HPRateDown, 0.496, "20%,30%,10%减幅叠加后减幅值应为0.496");
		}, null);

		// 测试8：基础攻击力测试
		UnitTestAutoTimer(4.6, 0, function() {
			CreateTestUnit(Player(0));

			// 测试设置基础攻击力
			testAttr.setBaseAtk(100.0);
			assert.Real(testAttr.baseAtk, 100.0, "设置基础攻击力应为100");
			assert.Real(testAttr.getCurrentAtk(), 100.0, "当前攻击力应为100");

			// 测试增加基础攻击力
			testAttr.addBaseAtk(50.0);
			assert.Real(testAttr.baseAtk, 150.0, "增加50点后基础攻击力应为150");
			assert.Real(testAttr.getCurrentAtk(), 150.0, "当前攻击力应为150");
		}, null);

		// 测试9：攻击力增幅测试
		UnitTestAutoTimer(5.1, 0, function() {
			CreateTestUnit(Player(0));
			testAttr.setBaseAtk(100.0);

			// 测试增幅效果
			testAttr.addAtkRateUp(0.5); // 增加50%
			assert.Real(testAttr.getCurrentAtk(), 150.0, "50%增幅后攻击力应为150");
			assert.Real(testAttr.getCurrentAtkRate(), 0.5, "当前攻击力倍率应为0.5");

			// 测试固定加成
			testAttr.addAtkFixedBonus(30.0);
			assert.Real(testAttr.getCurrentAtk(), 180.0, "加30点固定加成后应为180");
			assert.Real(testAttr.AtkFixedBonus, 30.0, "固定加成应为30");
		}, null);

		// 测试10：攻击力减幅的递减收益测试
		UnitTestAutoTimer(5.6, 0, function() {
			CreateTestUnit(Player(0));
			testAttr.setBaseAtk(100.0);

			// 测试两个30%减幅的叠加
			testAttr.addAtkRateDown(0.3);
			testAttr.addAtkRateDown(0.3);
			// 期望值：1 - (1-0.3)*(1-0.3) = 0.51
			assert.Real(testAttr.getCurrentAtk(), 49.0, "两个30%减幅叠加后攻击力应为49");
			assert.Real(testAttr.AtkRateDown, 0.51, "两个30%减幅叠加后减幅值应为0.51");

			// 测试第三个30%减幅的叠加
			testAttr.addAtkRateDown(0.3);
			// 期望值：1 - (1-0.51)*(1-0.3) ≈ 0.657
			assert.Real(testAttr.getCurrentAtk(), 34.3, "三个30%减幅叠加后攻击力应为34.3");
			assert.Real(testAttr.AtkRateDown, 0.657, "三个30%减幅叠加后减幅值应为0.657");

			// 测试恢复减幅效果
			testAttr.addAtkRateDown(-0.3);
			testAttr.addAtkRateDown(-0.3);
			testAttr.addAtkRateDown(-0.3);
			assert.Real(testAttr.getCurrentAtk(), 100.0, "三个-30%减幅叠加后攻击力应恢复为100");
			assert.Real(testAttr.AtkRateDown, 0.0, "三个-30%减幅叠加后减幅值应恢复为0");
		}, null);

		// 测试11：攻击力增减幅组合效果测试
		UnitTestAutoTimer(6.1, 0, function() {
			CreateTestUnit(Player(0));
			testAttr.setBaseAtk(100.0);

			// 测试增幅和减幅的组合效果
			testAttr.addAtkRateUp(0.5);    // 增加50%
			testAttr.addAtkRateDown(0.2);   // 减少20%
			// 计算：100 * (1 + 0.5) * (1 - 0.2) = 120
			assert.Real(testAttr.getCurrentAtk(), 120.0, "50%增幅20%减幅后攻击力应为120");
			assert.Real(testAttr.getCurrentAtkRate(), 0.2, "当前攻击力倍率应为0.2");

			// 添加固定加成测试
			testAttr.addAtkFixedBonus(30.0);
			assert.Real(testAttr.getCurrentAtk(), 150.0, "加30点固定加成后应为150");
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
