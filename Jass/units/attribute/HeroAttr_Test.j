#ifndef UTHeroAttrIncluded
#define UTHeroAttrIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTHeroAttr requires HeroAttr {
	private unit testHeroStr = null;  // 力量型英雄
	private unit testHeroAgi = null;  // 敏捷型英雄
	private heroAttr attrStr = 0;     // 力量英雄属性
	private heroAttr attrAgi = 0;     // 敏捷英雄属性

	// 创建测试英雄
	private function CreateTestHeroes(player p) {
		if (testHeroStr != null) {
			RemoveUnit(testHeroStr);
		}
		if (testHeroAgi != null) {
			RemoveUnit(testHeroAgi);
		}

		// 创建一个力量型英雄和一个敏捷型英雄
		testHeroStr = CreateUnit(p, 'Hmkg', 0, 0, 0);  // 山丘之王
		testHeroAgi = CreateUnit(p, 'Edem', 200, 0, 0);  // 恶魔猎手

		// 初始化属性系统
		attrStr = heroAttr.parse(testHeroStr, MAIN_ATTR_STR);
		attrAgi = heroAttr.parse(testHeroAgi, MAIN_ATTR_AGI);

		// 设置基础属性值方便测试
		attrStr.setBaseStr(100);
		attrAgi.setBaseStr(80);

		SelectUnit(testHeroStr, true);
	}

	function Init() {
		player p = Player(0);
		BJDebugMsg("=== HeroAttr测试系统已加载 ===");

		heroAttr.onStrChange(function() { // 监听Str变化
			heroAttr ha = heroAttr.ethis;
			// BJDebugMsg("[单位]: " + GetUnitName(ha.u) + " [Str]: " + R2S(ha.getCurrentStr()));
		});

		// 创建测试英雄
		//Trace
		CreateTestHeroes(p);

		// 测试1：基础力量属性测试
		UnitTestAutoTimer(0.1, 0, function() {
			assert.Real(attrStr.getCurrentStr(), 100.0, "力量英雄初始Str应为100");
			assert.Real(attrAgi.getCurrentStr(), 80.0, "敏捷英雄初始Str应为80");
		}, null);

		// 测试2：主属性增幅测试
		UnitTestAutoTimer(0.6, 0, function() {
			// 给力量英雄加50%主属性增幅
			attrStr.addMainAttrRateUp(0.5);
			assert.Real(attrStr.getCurrentStr(), 150.0, "力量英雄50%主属性增幅后Str应为150");

			// 给敏捷英雄加50%主属性增幅(不应影响力量)
			attrAgi.addMainAttrRateUp(0.5);
			assert.Real(attrAgi.getCurrentStr(), 80.0, "敏捷英雄主属性增幅不应影响Str");
		}, null);

		// 测试3：次属性增幅测试
		UnitTestAutoTimer(1.1, 0, function() {
			// 重置测试英雄
			CreateTestHeroes(Player(0));

			// 给力量英雄加30%次属性增幅
			attrStr.addSubAttrRateUp(0.3);
			assert.Real(attrStr.getCurrentStr(), 100.0, "力量英雄次属性增幅不应影响Str");

			// 给敏捷英雄加30%次属性增幅(应影响力量)
			attrAgi.addSubAttrRateUp(0.3);
			assert.Real(attrAgi.getCurrentStr(), 104.0, "敏捷英雄30%次属性增幅后Str应为104");
		}, null);

		// 测试4：属性固定加成测试
		UnitTestAutoTimer(1.6, 0, function() {
			CreateTestHeroes(Player(0));

			// 测试主属性固定加成
			attrStr.addMainAttrFixedBonus(50.0);
			assert.Real(attrStr.getCurrentStr(), 150.0, "力量英雄加50点主属性固定加成后Str应为150");

			// 测试次属性固定加成
			attrAgi.addSubAttrFixedBonus(30.0);
			assert.Real(attrAgi.getCurrentStr(), 110.0, "敏捷英雄加30点次属性固定加成后Str应为110");
		}, null);

		// 测试5：力量属性各种增减幅组合测试
		UnitTestAutoTimer(2.1, 0, function() {
			CreateTestHeroes(Player(0));

			// 设置基础力量为100
			attrStr.setBaseStr(100);

			// 添加力量增减幅
			attrStr.addStrRateUp(0.3);    // +30%
			attrStr.addStrRateDown(0.1);   // -10%

			// 添加主属性增减幅
			attrStr.addMainAttrRateUp(0.2);    // +20%
			attrStr.addMainAttrRateDown(0.05);  // -5%

			// 计算期望值：
			// 基础值: 100
			// 所有增幅相加: (1 + 0.3 + 0.2) = 1.5
			// 所有减幅相乘: (1 - 0.1) * (1 - 0.05) = 0.9 * 0.95 = 0.855
			// 最终计算: 100 * 1.5 * 0.855 = 128.25
			assert.Real(attrStr.getCurrentStr(), 128.25, "力量英雄复杂增减幅组合测试1");

			// 添加固定加成
			attrStr.addStrFixedBonus(50);
			attrStr.addMainAttrFixedBonus(30);

			// 最终结果应为: 128.25 + 50 + 30 = 208.25
			assert.Real(attrStr.getCurrentStr(), 208.25, "力量英雄复杂增减幅组合测试2");
		}, null);

		// 测试6：次属性对力量的影响组合测试
		UnitTestAutoTimer(2.6, 0, function() {
			CreateTestHeroes(Player(0));

			// 设置基础属性
			attrAgi.setBaseStr(100);

			// 添加力量相关增减幅
			attrAgi.addStrRateUp(0.2);     // +20%
			attrAgi.addStrRateDown(0.1);    // -10%

			// 添加次属性增减幅
			attrAgi.addSubAttrRateUp(0.3);     // +30%
			attrAgi.addSubAttrRateDown(0.15);   // -15%

			// 计算期望值：
			// 基础值: 100
			// 所有增幅相加: (1 + 0.2 + 0.3) = 1.5
			// 所有减幅相乘: (1 - 0.1) * (1 - 0.15) = 0.9 * 0.85 = 0.765
			// 最终计算: 100 * 1.5 * 0.765 = 114.75
			assert.Real(attrAgi.getCurrentStr(), 114.75, "敏捷英雄力量复杂增减幅组合测试1");

			// 添加固定加成
			attrAgi.addStrFixedBonus(40);
			attrAgi.addSubAttrFixedBonus(20);

			// 最终结果应为: 114.75 + 40 + 20 = 174.75
			assert.Real(attrAgi.getCurrentStr(), 174.75, "敏捷英雄力量复杂增减幅组合测试2");
		}, null);

		// 测试7：极限值测试
		UnitTestAutoTimer(3.1, 0, function() {
			CreateTestHeroes(Player(0));

			// 设置一个较大的基础值
			attrStr.setBaseStr(1000);

			// 添加多个大幅度的增减幅
			attrStr.addStrRateUp(2.0);      // +200%
			attrStr.addMainAttrRateUp(1.5);  // +150%
			attrStr.addStrRateDown(0.4);     // -40%
			attrStr.addMainAttrRateDown(0.3); // -30%

			// 添加大量固定加成
			attrStr.addStrFixedBonus(500);
			attrStr.addMainAttrFixedBonus(300);

			// 计算期望值：
			// 基础值: 1000
			// 所有增幅相加: (1 + 2.0 + 1.5) = 4.5
			// 所有减幅相乘: (1 - 0.4) * (1 - 0.3) = 0.6 * 0.7 = 0.42
			// 属性计算: 1000 * 4.5 * 0.42 = 1890
			// 加上固定加成: 1890 + 500 + 300 = 2690
			assert.Real(attrStr.getCurrentStr(), 2690.0, "力量英雄极限值测试");
		}, null);

		// 测试8：主属性基础值测试
		UnitTestAutoTimer(3.6, 0, function() {
			CreateTestHeroes(Player(0));

			// 测试力量英雄的主属性基础值
			attrStr.addMainAttrBase(50);
			assert.Real(attrStr.getBaseStr(), 150.0, "力量英雄加50主属性基础值后白字应为150");
			assert.Real(attrStr.getCurrentStr(), 150.0, "力量英雄加50主属性基础值后总值应为150");

			// 测试敏捷英雄的主属性基础值(不应影响力量)
			attrAgi.addMainAttrBase(50);
			assert.Real(attrAgi.getBaseStr(), 80.0, "敏捷英雄加50主属性基础值后力量白字应为80");
			assert.Real(attrAgi.getCurrentStr(), 80.0, "敏捷英雄加50主属性基础值后力量总值应为80");
		}, null);

		// 测试9：次属性基础值测试
		UnitTestAutoTimer(4.1, 0, function() {
			CreateTestHeroes(Player(0));

			// 测试力量英雄的次属性基础值(不应影响力量)
			attrStr.addSubAttrBase(30);
			assert.Real(attrStr.getBaseStr(), 100.0, "力量英雄加30次属性基础值后力量白字应为100");
			assert.Real(attrStr.getCurrentStr(), 100.0, "力量英雄加30次属性基础值后力量总值应为100");

			// 测试敏捷英雄的次属性基础值(应影响力量)
			attrAgi.addSubAttrBase(30);
			assert.Real(attrAgi.getBaseStr(), 110.0, "敏捷英雄加30次属性基础值后力量白字应为110");
			assert.Real(attrAgi.getCurrentStr(), 110.0, "敏捷英雄加30次属性基础值后力量总值应为110");
		}, null);

		// 测试10：主属性和次属性基础值组合测试
		UnitTestAutoTimer(4.6, 0, function() {
			CreateTestHeroes(Player(0));

			// 设置基础属性和增减幅
			attrAgi.setBaseStr(100);
			attrAgi.addStrRateUp(0.5);     // +50%
			attrAgi.addSubAttrRateUp(0.3);  // +30%

			// 添加主属性和次属性基础值
			attrAgi.addMainAttrBase(20);  // 不影响力量
			attrAgi.addSubAttrBase(50);   // 影响力量

			attrAgi.addSubAttrFixedBonus(25); //固定影响

			// 计算期望值：
			// 增幅: (100+50) * (1 + 0.5 + 0.3) + 25 = 295
			assert.Real(attrAgi.getBaseStr(), 150.0, "敏捷英雄复杂组合后力量白字应为150");
			assert.Real(attrAgi.getCurrentStr(), 295.0, "敏捷英雄复杂组合后力量总值应为295");
		}, null);

		// 测试11：多重增幅叠加测试
		UnitTestAutoTimer(5.1, 0, function() {
			CreateTestHeroes(Player(0));

			// 设置基础属性
			attrStr.setBaseStr(100);

			// 添加多次力量增幅
			attrStr.addStrRateUp(0.2);     // +20%
			attrStr.addStrRateUp(0.3);     // +30%
			attrStr.addStrRateUp(0.15);    // +15%

			// 添加多次主属性增幅
			attrStr.addMainAttrRateUp(0.25);    // +25%
			attrStr.addMainAttrRateUp(0.35);    // +35%

			// 添加多次次属性增幅
			attrStr.addSubAttrRateUp(0.1);     // +10%
			attrStr.addSubAttrRateUp(0.2);     // +20%

			// 计算期望值：
			// 基础值: 100
			// 力量增幅总和: 0.2 + 0.3 + 0.15 = 0.65
			// 主属性增幅总和: 0.25 + 0.35 = 0.6
			// 次属性增幅总和: 0.1 + 0.2 = 0.3
			// 所有增幅相加: (1 + 0.65 + 0.6) = 2.25
			// 最终计算: 100 * 2.25 = 225
			assert.Real(attrStr.getCurrentStr(), 225.0, "力量英雄多重增幅叠加测试1");

			// 再添加一些减幅测试
			attrStr.addStrRateDown(0.2);      // -20%
			attrStr.addMainAttrRateDown(0.1);  // -10%

			// 计算最终期望值：
			// 之前结果: 225
			// 减幅相乘: (1 - 0.2) * (1 - 0.1) = 0.8 * 0.9 = 0.72
			// 最终计算: 225 * 0.72 = 162
			assert.Real(attrStr.getCurrentStr(), 162, "力量英雄多重增幅叠加测试2");

			// 测试敏捷英雄的多重增幅叠加
			attrAgi.setBaseStr(100);

			// 添加多次各类增幅
			attrAgi.addStrRateUp(0.25);      // +25%
			attrAgi.addStrRateUp(0.35);      // +35%
			attrAgi.addSubAttrRateUp(0.2);   // +20%
			attrAgi.addSubAttrRateUp(0.3);   // +30%
			attrAgi.addMainAttrRateUp(0.4);  // +40% (不影响力量)

			// 计算期望值：
			// 基础值: 100
			// 力量增幅总和: 0.25 + 0.35 = 0.6
			// 次属性增幅总和: 0.2 + 0.3 = 0.5
			// 所有增幅相加: (1 + 0.6 + 0.5) = 2.1
			// 最终计算: 100 * 2.1 = 210
			assert.Real(attrAgi.getCurrentStr(), 210.0, "敏捷英雄多重增幅叠加测试1");

			// 添加减幅
			attrAgi.addStrRateDown(0.15);     // -15%
			attrAgi.addSubAttrRateDown(0.25);  // -25%

			// 计算最终期望值：
			// 之前结果: 210
			// 减幅相乘: (1 - 0.15) * (1 - 0.25) = 0.85 * 0.75 = 0.6375
			// 最终计算: 210 * 0.6375 = 133.875
			assert.Real(attrAgi.getCurrentStr(), 133.875, "敏捷英雄多重增幅叠加测试2");
		}, null);

		// 测试12：主属性切换测试
		UnitTestAutoTimer(5.6, 0, function() {
			CreateTestHeroes(Player(0));

			// 设置初始状态
			attrStr.setBaseStr(100);
			attrStr.addMainAttrBase(50);    // 主属性基础值+50
			attrStr.addSubAttrBase(30);     // 次属性基础值+30
			attrStr.addMainAttrRateUp(0.5); // 主属性增幅+50%
			attrStr.addSubAttrRateUp(0.3);  // 次属性增幅+30%

			// 验证初始状态
			assert.Real(attrStr.getBaseStr(), 150.0, "力量英雄切换前力量白字应为150");
			assert.Real(attrStr.getCurrentStr(), 225.0, "力量英雄切换前力量总值应为225"); // 150 * (1 + 0.5) = 225

			// 切换到敏捷主属性
			attrStr.switchMainAttr(MAIN_ATTR_AGI);

			// 验证切换后状态
			// 原主属性值变为次属性值,原次属性值变为主属性值
			assert.Real(attrStr.getBaseStr(), 130.0, "力量英雄切换后力量白字应为130"); // 100 + 30(原次属性基础值)
			assert.Real(attrStr.getCurrentStr(), 169.0, "力量英雄切换后力量总值应为169"); // 130 * (1 + 0.3) = 169

			// 切换回力量主属性
			attrStr.switchMainAttr(MAIN_ATTR_STR);

			// 验证恢复状态
			assert.Real(attrStr.getBaseStr(), 150.0, "力量英雄恢复后力量白字应为150");
			assert.Real(attrStr.getCurrentStr(), 225.0, "力量英雄恢复后力量总值应为225");
		}, null);

		// 测试13：主属性或次属性能否吃到%加成
		UnitTestAutoTimer(5.6, 0, function() {
			CreateTestHeroes(Player(0));

			// 设置初始状态
			attrStr.setBaseStr(100);
			attrStr.addMainAttrBase(200);    // 主属性基础值+50
			attrStr.addMainAttrRateUp(0.5); // 主属性增幅+50%
			attrStr.addStrRateUp(0.5);

			// 验证初始状态
			assert.Real(attrStr.getBaseStr(), 300.0, "力量英雄双重白字应为300");
			assert.Real(attrStr.getCurrentStr(), 600.0, "力量英雄双重总值应为600"); // 300 * (1 + 0.5 + 0.5) = 600
		}, null);

		p = null;
	}

	// 处理测试命令
	function TTestActUTHeroAttr1(string str) {
		player p = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i, num = 0, len = StringLength(str);
		string paramS[];
		integer paramI[];
		real paramR[];

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

		if (testHeroStr == null) {
			CreateTestHeroes(p);
		}

		// 新建测试单位命令
		if (paramS[0] == "new") {
			CreateTestHeroes(p);
			BJDebugMsg("已重新创建测试英雄");
		}
		// 力量相关命令
		else if (paramS[0] == "str") {
			attrStr.setBaseStr(paramR[1]);
			attrAgi.setBaseStr(paramR[1]);
			BJDebugMsg("设置力量英雄基础力量为: " + R2S(paramR[1]));
		} else if (paramS[0] == "addstr") {
			attrStr.addBaseStr(paramR[1]);
			attrAgi.addBaseStr(paramR[1]);
			BJDebugMsg("增加力量英雄基础力量: " + R2S(paramR[1]));
		} else if (paramS[0] == "strup") {
			attrStr.addStrRateUp(paramR[1]);
			attrAgi.addStrRateUp(paramR[1]);
			BJDebugMsg("设置力量英雄力量增幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "strdown") {
			attrStr.addStrRateDown(paramR[1]);
			attrAgi.addStrRateDown(paramR[1]);
			BJDebugMsg("设置力量英雄力量减幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "strbonus") {
			attrStr.addStrFixedBonus(paramR[1]);
			attrAgi.addStrFixedBonus(paramR[1]);
			BJDebugMsg("设置力量英雄力量固定加成为: " + R2S(paramR[1]));
		} else if (paramS[0] == "addstrbonus") {
			attrStr.addStrFixedBonus(paramR[1]);
			attrAgi.addStrFixedBonus(paramR[1]);
			BJDebugMsg("增加力量英雄力量固定加成: " + R2S(paramR[1]));
		}
		// 主属性相关命令
		else if (paramS[0] == "mainup") {
			attrStr.addMainAttrRateUp(paramR[1]);
			attrAgi.addMainAttrRateUp(paramR[1]);
			BJDebugMsg("设置力量英雄主属性增幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "maindown") {
			attrStr.addMainAttrRateDown(paramR[1]);
			attrAgi.addMainAttrRateDown(paramR[1]);
			BJDebugMsg("设置力量英雄主属性减幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "mainbonus") {
			attrStr.addMainAttrFixedBonus(paramR[1]);
			attrAgi.addMainAttrFixedBonus(paramR[1]);
			BJDebugMsg("设置力量英雄主属性固定加成为: " + R2S(paramR[1]));
		}
		// 次属性相关命令
		else if (paramS[0] == "subup") {
			attrStr.addSubAttrRateUp(paramR[1]);
			attrAgi.addSubAttrRateUp(paramR[1]);
			BJDebugMsg("设置力量英雄次属性增幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "subdown") {
			attrStr.addSubAttrRateDown(paramR[1]);
			attrAgi.addSubAttrRateDown(paramR[1]);
			BJDebugMsg("设置力量英雄次属性减幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "subbonus") {
			attrStr.addSubAttrFixedBonus(paramR[1]);
			attrAgi.addSubAttrFixedBonus(paramR[1]);
			BJDebugMsg("设置力量英雄次属性固定加成为: " + R2S(paramR[1]));
		}
		// 主属性基础值相关命令
		else if (paramS[0] == "mainadd") {
			attrStr.addMainAttrBase(paramR[1]);
			attrAgi.addMainAttrBase(paramR[1]);
			BJDebugMsg("增加力量英雄主属性基础值: " + R2S(paramR[1]));
		}
		// 次属性基础值相关命令
		else if (paramS[0] == "subadd") {
			attrStr.addSubAttrBase(paramR[1]);
			attrAgi.addSubAttrBase(paramR[1]);
			BJDebugMsg("增加力量英雄次属性基础值: " + R2S(paramR[1]));
		}
		// 切换主属性命令
		else if (paramS[0] == "switch") {
			if (paramI[1] >= 0 && paramI[1] <= 2) {
				attrStr.switchMainAttr(paramI[1]);
				attrAgi.switchMainAttr(paramI[1]);
				BJDebugMsg("切换主属性类型为: " + I2S(paramI[1]));
			} else {
				BJDebugMsg("无效的主属性类型,请使用0(力量),1(敏捷),2(智力)");
			}
		}

		// 显示当前状态
		BJDebugMsg("力量英雄当前力量: " + R2S(attrStr.getCurrentStr()));
		BJDebugMsg("力量英雄当前力量白字: " + R2S(attrStr.getBaseStr()));
		BJDebugMsg("力量英雄当前力量绿字: " + R2S(attrStr.getExtraStr()));
		BJDebugMsg("敏捷英雄当前力量: " + R2S(attrAgi.getCurrentStr()));
		BJDebugMsg("敏捷英雄当前力量白字: " + R2S(attrAgi.getBaseStr()));
		BJDebugMsg("敏捷英雄当前力量绿字: " + R2S(attrAgi.getExtraStr()));

		p = null;
	}

	function onInit() {
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
				TTestActUTHeroAttr1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
		});
	}
}

//! endzinc

#endif
