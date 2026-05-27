#ifndef UTUnitUtilsIncluded
#define UTUnitUtilsIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUnitUtils requires UnitUtils {

	// BigInteger 攻击链路测试
	private function Test_BigIntAttack() {
		player p;
		unit hero;
		real big;

		p = ConvertedPlayer(1);
		hero = CreateUnit(p, 'Hpal', 0.0, 0.0, 270.0);

		// 保证起始攻击与欠款为 0
		bigInteger.reset(p, HASH_KEY_BIGINT_ATTACK);
		bigInteger.reset(p, HASH_KEY_BIGINT_ATTACK_CACHE);
		SetUnitAttack(hero, 0.0);

		// 先加 1000 攻击
		AddUnitAttack(hero, 1000.0);

		// 再加超大攻击，再减回去，检查是否仍为 1000
		big = 1000000000.0 * 1000000000.0;
		AddUnitAttack(hero, big);
		AddUnitAttack(hero, -big);
		assert.Boolean(GetUnitAttack(hero) == 1000.0, "BigInt 攻击大数加减后应仍为 1000");
		assert.Boolean(bigInteger.compareInt(p, HASH_KEY_BIGINT_ATTACK_CACHE, 0) == 0, "BigInt 大数加减后欠款应为 0");

		// 欠款缓存测试：1000 - 10000 => 欠 9000，再 +11000 => 攻击应为 2000，且欠款清零
		bigInteger.reset(p, HASH_KEY_BIGINT_ATTACK);
		bigInteger.reset(p, HASH_KEY_BIGINT_ATTACK_CACHE);
		SetUnitAttack(hero, 1000.0);
		AddUnitAttack(hero, -10000.0);
		assert.Boolean(GetUnitAttack(hero) == 0.0, "BigInt 1000-10000 攻击应为 0");
		assert.Boolean(bigInteger.compareInt(p, HASH_KEY_BIGINT_ATTACK_CACHE, 9000) == 0, "BigInt 1000-10000 欠款应为 9000");

		AddUnitAttack(hero, 11000.0);
		assert.Boolean(GetUnitAttack(hero) == 2000.0, "BigInt 1000-10000+11000 攻击应为 2000");
		assert.Boolean(bigInteger.compareInt(p, HASH_KEY_BIGINT_ATTACK_CACHE, 0) == 0, "BigInt 欠款应归零");

		hero = null;
		p = null;
	}

	// [异度] BigInteger 暴击真伤链路测试
	private function Test_BigIntCritTrue() {
		player p;
		unit hero;
		real big;
		real expected;

		p = ConvertedPlayer(1);
		hero = CreateUnit(p, 'Hpal', 0.0, 0.0, 270.0);
		big = 1000000000.0 * 1000000000.0;

		bigInteger.reset(p, HASH_KEY_BIGINT_CRIT_TRUE);
		RemoveSavedReal(HASH_UNIT, GetHandleId(hero), KEY_UNIT_CRIT_TRUE_UP_RATE);
		RemoveSavedReal(HASH_UNIT, GetHandleId(hero), KEY_UNIT_CRIT_TRUE_DOWN_RATE);

		AddUnitCritTrue(hero, big);
		AddUnitCritTrue(hero, -big);
		AddUnitCritTrue(hero, 1000.0);
		assert.Real(GetUnitCritTrue(hero), 1000.0, "暴击真伤大数加减后应为 1000");
		assert.Real(GetUnitCritTruePercent(hero), 1.0, "暴击真伤初始倍率应为 1.0");

		AddUnitCritTrueUpPercent(hero, 0.5);
		AddUnitCritTrueDownPercent(hero, 0.2);
		expected = 1000.0 * 1.5 * 0.8;
		assert.Real(GetUnitCritTruePercent(hero), 1.2, "暴击真伤 50% 增幅 + 20% 减幅后倍率应为 1.2");
		assert.Real(GetUnitCritTrue(hero), expected, "暴击真伤倍率后应为 1200");

		hero = null;
		p = null;
	}

	// [异度] BigInteger 格挡链路测试
	private function Test_BigIntBlock() {
		player p;
		unit hero;
		real big;

		p = ConvertedPlayer(1);
		hero = CreateUnit(p, 'Hpal', 0.0, 0.0, 270.0);
		big = 1000000000.0 * 1000000000.0;

		bigInteger.reset(p, HASH_KEY_BIGINT_BLOCK);
		AddUnitBlock(hero, big);
		AddUnitBlock(hero, -big);
		AddUnitBlock(hero, 2000.0);
		assert.Real(GetUnitBlock(hero), 2000.0, "格挡大数加减后应为 2000");

		hero = null;
		p = null;
	}

	// [异度] 单位最终受伤倍率测试
	private function Test_DamagedFinal() {
		player p;
		unit hero;

		p = ConvertedPlayer(1);
		hero = CreateUnit(p, 'Hpal', 0.0, 0.0, 270.0);

		ResetUnitDamagedUp(hero);
		ResetUnitDamagedDown(hero);
		assert.Real(GetUnitDamagedFinal(hero), 1.0, "受伤倍率初始值应为 1.0");

		AddUnitDamagedUp(hero, 0.1);
		AddUnitDamagedUp(hero, 0.1);
		assert.Real(GetUnitDamagedUpRate(hero), 0.21, "两次 10% 受伤增加应叠乘为 21%");
		assert.Real(GetUnitDamagedFinal(hero), 1.21, "两次受伤增加后最终倍率应为 1.21");

		AddUnitDamagedUp(hero, -0.1);
		assert.Real(GetUnitDamagedUpRate(hero), 0.1, "移除一次 10% 受伤增加后应回到 10%");

		AddUnitDamagedDown(hero, 0.3);
		AddUnitDamagedDown(hero, 0.3);
		assert.Real(GetUnitDamagedDownRate(hero), 0.51, "两次 30% 受伤减少应 RealAdd 为 51%");
		assert.Real(GetUnitDamagedFinal(hero), 0.539, "受伤增加 10% 且受伤减少 51% 后最终倍率应为 0.539");

		AddUnitDamagedDown(hero, -0.3);
		assert.Real(GetUnitDamagedDownRate(hero), 0.3, "移除一次 30% 受伤减少后应回到 30%");

		ResetUnitDamagedUp(hero);
		ResetUnitDamagedDown(hero);
		assert.Real(GetUnitDamagedFinal(hero), 1.0, "重置后受伤倍率应回到 1.0");

		hero = null;
		p = null;
	}

	private function Test_ResistFull() {
		player p;
		unit hero;

		p = ConvertedPlayer(1);
		hero = CreateUnit(p, 'Hpal', 0.0, 0.0, 270.0);

		ResetUnitResistUp(hero);
		ResetUnitResistDown(hero);
		assert.Real(GetUnitResistFinal(hero), 1.0, "魔抗初始最终倍率应为 1.0");

		AddUnitResistUp(hero, 0.5);
		assert.Real(GetUnitResistFinal(hero), 0.5, "50% 魔抗后最终倍率应为 0.5");

		AddUnitResistUp(hero, 1.0);
		assert.Real(GetUnitResistFinal(hero), 0.0, "新增 100% 魔抗层后最终倍率应为 0.0");
		AddUnitResistDown(hero, 1.0);
		assert.Real(GetUnitResistFinal(hero), 0.0, "100% 魔抗层存在时魔易应被遮蔽");
		AddUnitResistUp(hero, -1.0);
		assert.Real(GetUnitResistFinal(hero), 1.0, "移除 100% 魔抗层后应恢复 50% 魔抗和 100% 魔易");
		AddUnitResistDown(hero, -1.0);
		assert.Real(GetUnitResistFinal(hero), 0.5, "移除魔易后应回到 50% 魔抗");

		AddUnitResistUp(hero, 1.0);
		AddUnitResistUp(hero, 1.0);
		assert.Real(GetUnitResistFinal(hero), 0.0, "两层 100% 魔抗后最终倍率应为 0.0");
		AddUnitResistUp(hero, -1.0);
		assert.Real(GetUnitResistFinal(hero), 0.0, "移除一层后仍应保持 100% 魔抗");
		AddUnitResistUp(hero, -1.0);
		assert.Real(GetUnitResistFinal(hero), 0.5, "移除所有 100% 魔抗层后应恢复原有 50% 魔抗");

		AddUnitResistUp(hero, 1.0);
		ResetUnitResistUp(hero);
		assert.Real(GetUnitResistFinal(hero), 1.0, "重置魔抗减伤应同时清理 100% 魔抗层");

		hero = null;
		p = null;
	}

	// 普通单位（步兵）攻击增幅/减幅/定值测试
	private function Test_NormalUnitAttackPercent() {
		player p;
		unit footman;
		real base; real expected; real actual; real rate;

		p = ConvertedPlayer(1);
		footman = CreateUnit(p, 'hfoo', 0.0, 0.0, 270.0);

		// 测试1：设置基础攻击 1000
		SetUnitAttack(footman, 1000.0);
		base = GetUnitBaseAttack(footman);
		assert.Real(base, 1000.0, "普通单位基础攻击应为 1000");
		assert.Real(GetUnitAttackFinalPercent(footman), 1.0, "普通单位初始倍率应为 1.0");
		assert.Real(GetUnitAttack(footman), 1000.0, "普通单位初始攻击应为 1000");

		// 测试2：添加 50% 增幅
		AddUnitAttackUpPercent(footman, 0.5);
		rate = GetUnitAttackFinalPercent(footman);
		expected = 1000.0 * 1.5;
		actual = GetUnitAttack(footman);
		assert.Real(rate, 1.5, "普通单位 50% 增幅后倍率应为 1.5");
		assert.Real(actual, expected, "普通单位 50% 增幅后攻击应为 1500");
		Trace("actual:" + R2S(actual) + " expected:" + R2S(expected));

		// 测试3：再添加 20% 减幅
		AddUnitAttackDownPercent(footman, 0.2);
		rate = GetUnitAttackFinalPercent(footman);
		expected = 1000.0 * 1.5 * 0.8;
		actual = GetUnitAttack(footman);
		assert.Real(rate, 1.2, "普通单位 50% 增幅 + 20% 减幅后倍率应为 1.2");
		assert.Real(actual, expected, "普通单位 50% 增幅 + 20% 减幅后攻击应为 1200");

		// 测试4：添加 500 定值
		AddUnitAttackBonus(footman, 500.0);
		expected = 1000.0 * 1.2 + 500.0;
		actual = GetUnitAttack(footman);
		assert.Real(actual, expected, "普通单位添加 500 定值后攻击应为 1700");

		// 测试5：验证基础攻击未变
		base = GetUnitBaseAttack(footman);
		assert.Real(base, 1000.0, "普通单位基础攻击应仍为 1000（不受增幅/定值影响）");

		// 测试6：再添加 30% 增幅，验证倍率叠加
		AddUnitAttackUpPercent(footman, 0.3);
		rate = GetUnitAttackFinalPercent(footman);
		expected = 1000.0 * 1.8 * 0.8 + 500.0;
		actual = GetUnitAttack(footman);
		assert.Real(rate, 1.44, "普通单位总增幅 80% + 减幅 20% 后倍率应为 1.44");
		assert.Real(actual, expected, "普通单位最终攻击应为 1940");

		footman = null;
		p = null;
	}

	// BigInteger 单位（英雄）攻击增幅/减幅/定值测试
	private function Test_BigIntUnitAttackPercent() {
		player p;
		unit hero;
		real base; real expected; real actual; real rate; real big;
		real bonusReal;

		p = ConvertedPlayer(1);
		hero = CreateUnit(p, 'Hpal', 0.0, 0.0, 270.0);

		// 保证起始攻击与欠款为 0
		bigInteger.reset(p, HASH_KEY_BIGINT_ATTACK);
		bigInteger.reset(p, HASH_KEY_BIGINT_ATTACK_CACHE);
		bigInteger.reset(p, HASH_KEY_BIGINT_ATTACK_BONUS);
		SetUnitAttack(hero, 0.0);

		// 测试1：设置基础攻击 1000
		SetUnitAttack(hero, 1000.0);
		base = GetUnitBaseAttack(hero);
		assert.Real(base, 1000.0, "BigInt 单位基础攻击应为 1000");
		assert.Real(GetUnitAttackFinalPercent(hero), 1.0, "BigInt 单位初始倍率应为 1.0");
		assert.Real(GetUnitAttack(hero), 1000.0, "BigInt 单位初始攻击应为 1000");

		// 测试2：添加 50% 增幅
		AddUnitAttackUpPercent(hero, 0.5);
		rate = GetUnitAttackFinalPercent(hero);
		expected = 1000.0 * 1.5;
		actual = GetUnitAttack(hero);
		assert.Real(rate, 1.5, "BigInt 单位 50% 增幅后倍率应为 1.5");
		assert.Real(actual, expected, "BigInt 单位 50% 增幅后攻击应为 1500");

		// 测试3：再添加 20% 减幅
		AddUnitAttackDownPercent(hero, 0.2);
		rate = GetUnitAttackFinalPercent(hero);
		expected = 1000.0 * 1.5 * 0.8;
		actual = GetUnitAttack(hero);
		assert.Real(rate, 1.2, "BigInt 单位 50% 增幅 + 20% 减幅后倍率应为 1.2");
		assert.Real(actual, expected, "BigInt 单位 50% 增幅 + 20% 减幅后攻击应为 1200");

		// 测试4：添加 500 定值（使用 BigInteger 存储）
		AddUnitAttackBonus(hero, 500.0);
		expected = 1000.0 * 1.2 + 500.0;
		actual = GetUnitAttack(hero);
		assert.Real(actual, expected, "BigInt 单位添加 500 定值后攻击应为 1700");

		// 测试5：验证基础攻击未变
		base = GetUnitBaseAttack(hero);
		assert.Real(base, 1000.0, "BigInt 单位基础攻击应仍为 1000（不受增幅/定值影响）");

		// 测试6：大数测试：基础攻击 + 超大数，再加减，验证倍率和定值仍正确
		big = 1000000000.0 * 1000000000.0;
		AddUnitAttack(hero, big);
		AddUnitAttack(hero, -big);
		base = GetUnitBaseAttack(hero);
		expected = 1000.0 * 1.2 + 500.0;
		actual = GetUnitAttack(hero);
		assert.Real(base, 1000.0, "BigInt 单位大数加减后基础攻击应仍为 1000");
		assert.Real(actual, expected, "BigInt 单位大数加减后最终攻击应仍为 1700");

		// 测试7：再添加 30% 增幅，验证倍率叠加
		AddUnitAttackUpPercent(hero, 0.3);
		rate = GetUnitAttackFinalPercent(hero);
		expected = 1000.0 * 1.8 * 0.8 + 500.0;
		actual = GetUnitAttack(hero);
		assert.Real(rate, 1.44, "BigInt 单位总增幅 80% + 减幅 20% 后倍率应为 1.44");
		assert.Real(actual, expected, "BigInt 单位最终攻击应为 1940");

		// 测试8：验证 BigInteger 定值存储正确
		bonusReal = bigInteger.toReal(p, HASH_KEY_BIGINT_ATTACK_BONUS);
		assert.Real(bonusReal, 500.0, "BigInt 单位定值应正确存储在 BigInteger 中");

		hero = null;
		p = null;
	}

	function Init () {
		// 注册全局单位选中事件，打印当前攻击力与攻击倍数
		trigger selTr;
		integer i;
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
			//GetUnitAttackInterval
		},null);

		// 自动执行 BigInteger 攻击链路测试
		UnitTestAutoTimer(0.3, 0.1, function() {
			Trace("UnitUtils BigIntAttack 测试");
			Test_BigIntAttack();
		}, null);

		// 自动执行 [异度] 暴击真伤 / 格挡测试
		UnitTestAutoTimer(0.35, 0.1, function() {
			Trace("UnitUtils 暴击真伤 BigInteger 测试");
			Test_BigIntCritTrue();
		}, null);
		UnitTestAutoTimer(0.36, 0.1, function() {
			Trace("UnitUtils 格挡 BigInteger 测试");
			Test_BigIntBlock();
		}, null);
		UnitTestAutoTimer(0.37, 0.1, function() {
			Trace("UnitUtils 最终受伤倍率测试");
			Test_DamagedFinal();
		}, null);
		UnitTestAutoTimer(0.38, 0.1, function() {
			Trace("UnitUtils 100% 魔抗可逆测试");
			Test_ResistFull();
		}, null);

		// 自动执行普通单位攻击增幅/减幅/定值测试
		UnitTestAutoTimer(0.4, 0.1, function() {
			Trace("UnitUtils 普通单位攻击百分比测试");
			Test_NormalUnitAttackPercent();
		}, null);

		// 自动执行 BigInteger 单位攻击增幅/减幅/定值测试
		UnitTestAutoTimer(0.5, 0.1, function() {
			Trace("UnitUtils BigInteger 单位攻击百分比测试");
			Test_BigIntUnitAttackPercent();
		}, null);

		selTr = CreateTrigger();
		for (0 <= i <= 11) {
			TriggerRegisterPlayerUnitEvent(selTr, Player(i), EVENT_PLAYER_UNIT_SELECTED, null);
		}
		TriggerAddCondition(selTr, Condition(function () -> boolean {
			unit u; real atk; real mult;
			u    = GetTriggerUnit();
			atk  = GetUnitAttack(u);
			mult = GetUnitAttackMult(u);
			BJDebugMsg("[UnitUtils] 选中单位攻击=" + R2S(atk) + "  倍数=" + R2S(mult));
			u = null;
			return false;
		}));
		selTr = null;
	}

	function TTestUTUnitUtils1 (player p) {
		integer i;
		unit u;
		real x; real y;
		integer startLoc;

		startLoc = GetPlayerStartLocation(p);
		x = GetStartLocationX(startLoc);
		y = GetStartLocationY(startLoc);

		// 创建 3 个步兵，分别设置不同量级的攻击力（含超过 21 亿的情况）
		for (0 <= i <= 2) {
			u = CreateUnit(p, 'hfoo', x + 150.0 * I2R(i), y, 270.0);
			if (i == 0) {
				SetUnitAttack(u, 500000000.0);      // 5e8，不触发扩展
			} else if (i == 1) {
				SetUnitAttack(u, 250000000.0*10.0);     // 2.5e9，触发扩展
			} else {
				SetUnitAttack(u, 9999999.0  * 19999.0);    // 9.999e10，更大数
			}
			u = null;
		}
	}
	function TTestUTUnitUtils2 (player p) {
		// 普通单位攻击增幅/减幅/定值测试
		Test_NormalUnitAttackPercent();
		BJDebugMsg("[UnitUtils] 普通单位攻击百分比测试完成");
	}
	function TTestUTUnitUtils3 (player p) {
		// BigInteger 单位攻击增幅/减幅/定值测试
		Test_BigIntUnitAttackPercent();
		BJDebugMsg("[UnitUtils] BigInteger 单位攻击百分比测试完成");
	}
	function TTestUTUnitUtils4 (player p) {
		unit u = CreateUnit(p,'hpea',0,0,0);
		AddUnitDefense(u,-1000);
		BJDebugMsg("测试负甲");
		u = null;
	}
	function TTestUTUnitUtils5 (player p) {}
	function TTestUTUnitUtils6 (player p) {}
	function TTestUTUnitUtils7 (player p) {}
	function TTestUTUnitUtils8 (player p) {}
	function TTestUTUnitUtils9 (player p) {}
	function TTestUTUnitUtils10 (player p) {}
	function TTestActUTUnitUtils1 (string str) {
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

		if (paramS[0] == "a") {

		} else if (paramS[0] == "b") {

		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[UnitUtils] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitUtils1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitUtils1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitUtils2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitUtils3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitUtils4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitUtils5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitUtils6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitUtils7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitUtils8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitUtils9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitUtils10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
