#ifndef UTHeroUtilsIncluded
#define UTHeroUtilsIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "japi/YDWEJapiScript.j"

//! zinc

//自动生成的文件
library UTHeroUtils requires HeroUtils {

	// 测试1：主属性类型设置和获取
	private function Test_MainAttrType() {
		player p; unit hero; integer mainType;

		p = ConvertedPlayer(1);
		hero = CreateUnit(p, 'Hpal', 0.0, 0.0, 270.0);

		// 测试设置主属性类型为力量
		SetUnitMainAttrType(hero, 0);
		mainType = GetUnitMainAttrType(hero);
		assert.Boolean(mainType == 0, "设置主属性类型为力量后应返回 0");

		// 测试设置主属性类型为敏捷
		SetUnitMainAttrType(hero, 1);
		mainType = GetUnitMainAttrType(hero);
		assert.Boolean(mainType == 1, "设置主属性类型为敏捷后应返回 1");

		// 测试设置主属性类型为智力
		SetUnitMainAttrType(hero, 2);
		mainType = GetUnitMainAttrType(hero);
		assert.Boolean(mainType == 2, "设置主属性类型为智力后应返回 2");

		hero = null;
		p = null;
	}

	// 测试2：主属性 Value/Bonus/Up/Down 操作
	private function Test_MainAttrOperations() {
		player p; unit hero; real value; real bonus; real finalPercent; real expected;

		p = ConvertedPlayer(1);
		hero = CreateUnit(p, 'Hpal', 0.0, 0.0, 270.0);
		SetUnitMainAttrType(hero, 0); // 力量为主属性

		// 清理 BigInteger
		bigInteger.reset(p, HASH_KEY_BIGINT_MAIN);
		bigInteger.reset(p, HASH_KEY_BIGINT_MAIN_BONUS);

		// 测试1：添加主属性数值
		AddUnitMainAttrValue(hero, 100.0);
		value = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN);
		assert.Real(value, 100.0, "添加主属性数值 100 后应正确存储");

		// 测试2：添加主属性 Bonus
		AddUnitMainAttrBonus(hero, 50.0);
		bonus = bigInteger.toReal(p, HASH_KEY_BIGINT_MAIN_BONUS);
		assert.Real(bonus, 50.0, "添加主属性 Bonus 50 后应正确存储");

		// 测试3：添加主属性 Up
		AddUnitMainAttrUpPercent(hero, 0.2);
		// 验证主属性 Up 已存储（通过力量最终倍率间接验证）
		SetUnitStr(hero, 100.0);
		SetUnitMainAttrType(hero, 0);
		finalPercent = GetUnitStrFinalPercent(hero);
		expected = 1.2; // (1 + 0.2)
		assert.Real(finalPercent, expected, "添加主属性 Up 20% 后力量倍率应为 1.2");

		// 测试4：添加主属性 Down
		AddUnitMainAttrDownPercent(hero, 0.1);
		finalPercent = GetUnitStrFinalPercent(hero);
		expected = 1.2 * 0.9; // (1 + 0.2) * (1 - 0.1)
		assert.Real(finalPercent, expected, "添加主属性 Down 10% 后力量倍率应为 1.08");

		// 测试5：再次添加 Up，验证累积
		AddUnitMainAttrUpPercent(hero, 0.3);
		finalPercent = GetUnitStrFinalPercent(hero);
		expected = 1.5 * 0.9; // (1 + 0.2 + 0.3) * (1 - 0.1)
		assert.Real(finalPercent, expected, "再次添加主属性 Up 30% 后力量倍率应为 1.35");

		hero = null;
		p = null;
	}

	// 测试3：次属性 Value/Bonus/Up/Down 操作
	private function Test_SubAttrOperations() {
		player p; unit hero; real value; real bonus; real finalPercent; real expected;

		p = ConvertedPlayer(1);
		hero = CreateUnit(p, 'Hpal', 0.0, 0.0, 270.0);
		SetUnitMainAttrType(hero, 0); // 力量为主属性，敏捷和智力为次属性

		// 清理 BigInteger
		bigInteger.reset(p, HASH_KEY_BIGINT_SUB);
		bigInteger.reset(p, HASH_KEY_BIGINT_SUB_BONUS);

		// 测试1：添加次属性数值
		AddUnitSubAttrValue(hero, 200.0);
		value = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB);
		assert.Real(value, 200.0, "添加次属性数值 200 后应正确存储");

		// 测试2：添加次属性 Bonus
		AddUnitSubAttrBonus(hero, 100.0);
		bonus = bigInteger.toReal(p, HASH_KEY_BIGINT_SUB_BONUS);
		assert.Real(bonus, 100.0, "添加次属性 Bonus 100 后应正确存储");

		// 测试3：添加次属性 Up
		AddUnitSubAttrUpPercent(hero, 0.15);
		// 验证次属性 Up 已存储（通过敏捷最终倍率间接验证，因为敏捷是次属性）
		SetUnitAgi(hero, 100.0);
		finalPercent = GetUnitAgiFinalPercent(hero);
		expected = 1.15; // (1 + 0.15)
		assert.Real(finalPercent, expected, "添加次属性 Up 15% 后敏捷倍率应为 1.15");

		// 测试4：添加次属性 Down
		AddUnitSubAttrDownPercent(hero, 0.05);
		finalPercent = GetUnitAgiFinalPercent(hero);
		expected = 1.15 * 0.95; // (1 + 0.15) * (1 - 0.05)
		assert.Real(finalPercent, expected, "添加次属性 Down 5% 后敏捷倍率应为 1.0925");

		hero = null;
		p = null;
	}

	// 测试4：三维基础值（基础+主/次属性数值）
	private function Test_BaseAttrValue() {
		player p; unit hero; real baseStr; real baseAgi; real baseInt; real expected;

		p = ConvertedPlayer(1);
		hero = CreateUnit(p, 'Hpal', 0.0, 0.0, 270.0);

		// 清理 BigInteger
		bigInteger.reset(p, HASH_KEY_BIGINT_STR);
		bigInteger.reset(p, HASH_KEY_BIGINT_AGI);
		bigInteger.reset(p, HASH_KEY_BIGINT_INT);
		bigInteger.reset(p, HASH_KEY_BIGINT_MAIN);
		bigInteger.reset(p, HASH_KEY_BIGINT_SUB);

		// 设置基础力量为 100
		SetUnitStr(hero, 100.0);
		// 设置基础敏捷为 80
		SetUnitAgi(hero, 80.0);
		// 设置基础智力为 60
		SetUnitInt(hero, 60.0);

		// 设置主属性类型为力量
		SetUnitMainAttrType(hero, 0);
		// 添加主属性数值 50
		AddUnitMainAttrValue(hero, 50.0);
		// 添加次属性数值 30
		AddUnitSubAttrValue(hero, 30.0);

		// 测试：力量基础值 = 基础力量(100) + 主属性数值(50) = 150
		baseStr = GetUnitBaseStr(hero);
		expected = 100.0 + 50.0;
		assert.Real(baseStr, expected, "力量基础值应为 150 (100+50)");

		// 测试：敏捷基础值 = 基础敏捷(80) + 次属性数值(30) = 110
		baseAgi = GetUnitBaseAgi(hero);
		expected = 80.0 + 30.0;
		assert.Real(baseAgi, expected, "敏捷基础值应为 110 (80+30)");

		// 测试：智力基础值 = 基础智力(60) + 次属性数值(30) = 90
		baseInt = GetUnitBaseInt(hero);
		expected = 60.0 + 30.0;
		assert.Real(baseInt, expected, "智力基础值应为 90 (60+30)");

		// 切换主属性类型为敏捷
		SetUnitMainAttrType(hero, 1);
		// 测试：力量基础值 = 基础力量(100) + 次属性数值(30) = 130
		baseStr = GetUnitBaseStr(hero);
		expected = 100.0 + 30.0;
		assert.Real(baseStr, expected, "主属性切换后力量基础值应为 130 (100+30)");

		// 测试：敏捷基础值 = 基础敏捷(80) + 主属性数值(50) = 130
		baseAgi = GetUnitBaseAgi(hero);
		expected = 80.0 + 50.0;
		assert.Real(baseAgi, expected, "主属性切换后敏捷基础值应为 130 (80+50)");

		hero = null;
		p = null;
	}

	// 测试5：三维最终倍率计算
	private function Test_FinalPercent() {
		player p; unit hero; real finalPercent; real expected;
		integer uid;

		p = ConvertedPlayer(1);
		hero = CreateUnit(p, 'Hpal', 0.0, 0.0, 270.0);
		SetUnitMainAttrType(hero, 0); // 力量为主属性

		// 清理所有倍率（直接操作哈希表）
		uid = GetHandleId(hero);
		if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MAIN_ATTR_UP_RATE)) {
			RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_MAIN_ATTR_UP_RATE);
		}
		if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MAIN_ATTR_DOWN_RATE)) {
			RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_MAIN_ATTR_DOWN_RATE);
		}
		if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_SUB_ATTR_UP_RATE)) {
			RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_SUB_ATTR_UP_RATE);
		}
		if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_SUB_ATTR_DOWN_RATE)) {
			RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_SUB_ATTR_DOWN_RATE);
		}
		if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_UP_RATE)) {
			RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_UP_RATE);
		}
		if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_DOWN_RATE)) {
			RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_DOWN_RATE);
		}

		// 测试1：初始倍率应为 1.0
		finalPercent = GetUnitStrFinalPercent(hero);
		assert.Real(finalPercent, 1.0, "初始力量倍率应为 1.0");

		// 测试2：添加力量 Up 20%，主属性 Up 10%
		AddUnitStrUpPercent(hero, 0.2);
		AddUnitMainAttrUpPercent(hero, 0.1);
		finalPercent = GetUnitStrFinalPercent(hero);
		expected = (1.0 + 0.2 + 0.1); // (1 + attrUp + mainUp)
		assert.Real(finalPercent, expected, "力量 Up 20% + 主属性 Up 10% 后倍率应为 1.3");

		// 测试3：添加力量 Down 5%，主属性 Down 5%
		AddUnitStrDownPercent(hero, 0.05);
		AddUnitMainAttrDownPercent(hero, 0.05);
		finalPercent = GetUnitStrFinalPercent(hero);
		expected = (1.0 + 0.2 + 0.1) * (1.0 - 0.05) * (1.0 - 0.05); // (1+attrUp+mainUp)*(1-attrDown)*(1-mainDown)
		assert.Real(finalPercent, expected, "添加 Down 后倍率应为 " + R2S(expected));

		// 测试4：敏捷作为次属性，添加敏捷 Up 15%，次属性 Up 10%
		AddUnitAgiUpPercent(hero, 0.15);
		AddUnitSubAttrUpPercent(hero, 0.1);
		finalPercent = GetUnitAgiFinalPercent(hero);
		expected = (1.0 + 0.15 + 0.1); // (1 + attrUp + subUp)
		assert.Real(finalPercent, expected, "敏捷 Up 15% + 次属性 Up 10% 后倍率应为 1.25");

		hero = null;
		p = null;
	}

	// 测试6：三维属性完整计算（基础+主/次属性）* 倍率 + Bonus
	private function Test_FullAttrCalculation() {
		player p; unit hero; real str; real agi; real intVal; real expected;

		p = ConvertedPlayer(1);
		hero = CreateUnit(p, 'Hpal', 0.0, 0.0, 270.0);
		SetUnitMainAttrType(hero, 0); // 力量为主属性

		// 清理所有数据
		bigInteger.reset(p, HASH_KEY_BIGINT_STR);
		bigInteger.reset(p, HASH_KEY_BIGINT_AGI);
		bigInteger.reset(p, HASH_KEY_BIGINT_INT);
		bigInteger.reset(p, HASH_KEY_BIGINT_MAIN);
		bigInteger.reset(p, HASH_KEY_BIGINT_SUB);
		bigInteger.reset(p, HASH_KEY_BIGINT_MAIN_BONUS);
		bigInteger.reset(p, HASH_KEY_BIGINT_SUB_BONUS);

		// 设置基础值
		SetUnitStr(hero, 100.0);
		SetUnitAgi(hero, 80.0);
		SetUnitInt(hero, 60.0);

		// 设置主属性数值和 Bonus
		AddUnitMainAttrValue(hero, 50.0);
		AddUnitMainAttrBonus(hero, 20.0);

		// 设置次属性数值和 Bonus
		AddUnitSubAttrValue(hero, 30.0);
		AddUnitSubAttrBonus(hero, 15.0);

		// 设置倍率：力量 Up 20%，主属性 Up 10%，力量 Down 5%，主属性 Down 5%
		AddUnitStrUpPercent(hero, 0.2);
		AddUnitMainAttrUpPercent(hero, 0.1);
		AddUnitStrDownPercent(hero, 0.05);
		AddUnitMainAttrDownPercent(hero, 0.05);

		// 设置力量 Bonus
		AddUnitStrBonus(hero, 10.0);

		// 计算期望值：力量 = (基础100 + 主属性50) * (1+0.2+0.1) * (1-0.05) * (1-0.05) + (力量Bonus10 + 主属性Bonus20)
		expected = (100.0 + 50.0) * (1.0 + 0.2 + 0.1) * (1.0 - 0.05) * (1.0 - 0.05) + (10.0 + 20.0);
		str = GetUnitStr(hero);
		assert.Real(str, expected, "力量完整计算应正确");

		// 设置敏捷倍率：敏捷 Up 15%，次属性 Up 10%，敏捷 Down 3%
		AddUnitAgiUpPercent(hero, 0.15);
		AddUnitSubAttrUpPercent(hero, 0.1);
		AddUnitAgiDownPercent(hero, 0.03);

		// 设置敏捷 Bonus
		AddUnitAgiBonus(hero, 5.0);

		// 计算期望值：敏捷 = (基础80 + 次属性30) * (1+0.15+0.1) * (1-0.03) * (1-0) + (敏捷Bonus5 + 次属性Bonus15)
		expected = (80.0 + 30.0) * (1.0 + 0.15 + 0.1) * (1.0 - 0.03) + (5.0 + 15.0);
		agi = GetUnitAgi(hero);
		assert.Real(agi, expected, "敏捷完整计算应正确");

		// 设置智力倍率和 Bonus
		AddUnitIntUpPercent(hero, 0.12);
		AddUnitIntDownPercent(hero, 0.02);
		AddUnitIntBonus(hero, 8.0);

		// 计算期望值：智力 = (基础60 + 次属性30) * (1+0.12+0.1) * (1-0.02) * (1-0) + (智力Bonus8 + 次属性Bonus15)
		expected = (60.0 + 30.0) * (1.0 + 0.12 + 0.1) * (1.0 - 0.02) + (8.0 + 15.0);
		intVal = GetUnitInt(hero);
		assert.Real(intVal, expected, "智力完整计算应正确");

		hero = null;
		p = null;
	}

	// 测试7：三维属性 Set/Add 操作（含欠款缓存逻辑）
	private function Test_AttrSetAdd() {
		player p; unit hero; real str; real agi; real intVal; real cache;

		p = ConvertedPlayer(1);
		hero = CreateUnit(p, 'Hpal', 0.0, 0.0, 270.0);

		// 清理 BigInteger
		bigInteger.reset(p, HASH_KEY_BIGINT_STR);
		bigInteger.reset(p, HASH_KEY_BIGINT_AGI);
		bigInteger.reset(p, HASH_KEY_BIGINT_INT);

		// 测试1：Set 操作
		SetUnitStr(hero, 100.0);
		str = bigInteger.toReal(p, HASH_KEY_BIGINT_STR);
		assert.Real(str, 100.0, "SetUnitStr 100 后应正确存储");

		SetUnitAgi(hero, 80.0);
		agi = bigInteger.toReal(p, HASH_KEY_BIGINT_AGI);
		assert.Real(agi, 80.0, "SetUnitAgi 80 后应正确存储");

		SetUnitInt(hero, 60.0);
		intVal = bigInteger.toReal(p, HASH_KEY_BIGINT_INT);
		assert.Real(intVal, 60.0, "SetUnitInt 60 后应正确存储");

		// 测试2：Add 操作
		AddUnitStr(hero, 50.0);
		str = bigInteger.toReal(p, HASH_KEY_BIGINT_STR);
		assert.Real(str, 150.0, "AddUnitStr 50 后应为 150");

		AddUnitAgi(hero, -20.0);
		agi = bigInteger.toReal(p, HASH_KEY_BIGINT_AGI);
		assert.Real(agi, 60.0, "AddUnitAgi -20 后应为 60");

		AddUnitInt(hero, 40.0);
		intVal = bigInteger.toReal(p, HASH_KEY_BIGINT_INT);
		assert.Real(intVal, 100.0, "AddUnitInt 40 后应为 100");

		// 测试3：力量欠款缓存逻辑：+100 -200 +1000 = 900
		bigInteger.reset(p, HASH_KEY_BIGINT_STR);
		bigInteger.reset(p, HASH_KEY_BIGINT_STR_CACHE);

		AddUnitStr(hero, 100.0);
		str = bigInteger.toReal(p, HASH_KEY_BIGINT_STR);
		cache = bigInteger.toReal(p, HASH_KEY_BIGINT_STR_CACHE);
		assert.Real(str, 100.0, "欠款测试：首次 +100 后力量应为 100");
		assert.Real(cache, 0.0, "欠款测试：首次 +100 后欠款应为 0");

		AddUnitStr(hero, -200.0);
		str = bigInteger.toReal(p, HASH_KEY_BIGINT_STR);
		cache = bigInteger.toReal(p, HASH_KEY_BIGINT_STR_CACHE);
		assert.Real(str, 0.0, "欠款测试：+100 -200 后力量应为 0");
		assert.Real(cache, 100.0, "欠款测试：+100 -200 后欠款应为 100");

		AddUnitStr(hero, 1000.0);
		str = bigInteger.toReal(p, HASH_KEY_BIGINT_STR);
		cache = bigInteger.toReal(p, HASH_KEY_BIGINT_STR_CACHE);
		assert.Real(str, 900.0, "欠款测试：+100 -200 +1000 后力量应为 900");
		assert.Real(cache, 0.0, "欠款测试：+100 -200 +1000 后欠款应被清空");

		// 测试4：大数欠款测试：-1亿 +2亿 = 1亿
		bigInteger.reset(p, HASH_KEY_BIGINT_STR);
		bigInteger.reset(p, HASH_KEY_BIGINT_STR_CACHE);

		AddUnitStr(hero, -100000000.0);
		str = bigInteger.toReal(p, HASH_KEY_BIGINT_STR);
		cache = bigInteger.toReal(p, HASH_KEY_BIGINT_STR_CACHE);
		assert.Real(str, 0.0, "大数欠款测试：-1亿 后力量应为 0");
		assert.Real(cache, 100000000.0, "大数欠款测试：-1亿 后欠款应为 1亿");

		AddUnitStr(hero, 200000000.0);
		str = bigInteger.toReal(p, HASH_KEY_BIGINT_STR);
		cache = bigInteger.toReal(p, HASH_KEY_BIGINT_STR_CACHE);
		assert.Real(str, 100000000.0, "大数欠款测试：-1亿 +2亿 后力量应为 1亿");
		assert.Real(cache, 0.0, "大数欠款测试：-1亿 +2亿 后欠款应被清空");

		hero = null;
		p = null;
	}

	// 测试8：三维属性 Up/Down/Bonus 操作
	private function Test_AttrUpDownBonus() {
		player p; unit hero; real finalPercent; real expected; integer uid; real bonus;

		p = ConvertedPlayer(1);
		hero = CreateUnit(p, 'Hpal', 0.0, 0.0, 270.0);
		uid = GetHandleId(hero);

		// 清理倍率和 Bonus（力量相关）
		if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_STR_UP_RATE)) {
			RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_STR_UP_RATE);
		}
		if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_STR_DOWN_RATE)) {
			RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_STR_DOWN_RATE);
		}
		if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_STR_BONUS_REAL)) {
			RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_STR_BONUS_REAL);
		}

		// 测试1：力量 Up/Down/Bonus
		AddUnitStrUpPercent(hero, 0.25);
		finalPercent = GetUnitStrFinalPercent(hero);
		assert.Real(finalPercent, 1.25, "力量 Up 25% 后倍率应为 1.25");

		AddUnitStrDownPercent(hero, 0.1);
		finalPercent = GetUnitStrFinalPercent(hero);
		expected = 1.25 * 0.9;
		assert.Real(finalPercent, expected, "力量 Down 10% 后倍率应为 1.125");

		AddUnitStrBonus(hero, 50.0);
		bonus = LoadReal(HASH_UNIT, uid, KEY_UNIT_STR_BONUS_REAL);
		assert.Real(bonus, 50.0, "力量 Bonus 50 后应正确存储");

		// 测试2：敏捷 Up/Down/Bonus
		if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_AGI_UP_RATE)) {
			RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_AGI_UP_RATE);
		}
		if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_AGI_DOWN_RATE)) {
			RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_AGI_DOWN_RATE);
		}
		if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_AGI_BONUS_REAL)) {
			RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_AGI_BONUS_REAL);
		}

		AddUnitAgiUpPercent(hero, 0.18);
		AddUnitAgiDownPercent(hero, 0.06);
		finalPercent = GetUnitAgiFinalPercent(hero);
		expected = 1.18 * 0.94;
		assert.Real(finalPercent, expected, "敏捷 Up 18% Down 6% 后倍率应为 " + R2S(expected));

		AddUnitAgiBonus(hero, 30.0);
		bonus = LoadReal(HASH_UNIT, uid, KEY_UNIT_AGI_BONUS_REAL);
		assert.Real(bonus, 30.0, "敏捷 Bonus 30 后应正确存储");

		// 测试3：智力 Up/Down/Bonus
		if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_INT_UP_RATE)) {
			RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_INT_UP_RATE);
		}
		if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_INT_DOWN_RATE)) {
			RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_INT_DOWN_RATE);
		}
		if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_INT_BONUS_REAL)) {
			RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_INT_BONUS_REAL);
		}

		AddUnitIntUpPercent(hero, 0.22);
		AddUnitIntDownPercent(hero, 0.08);
		finalPercent = GetUnitIntFinalPercent(hero);
		expected = 1.22 * 0.92;
		assert.Real(finalPercent, expected, "智力 Up 22% Down 8% 后倍率应为 " + R2S(expected));

		AddUnitIntBonus(hero, 40.0);
		bonus = LoadReal(HASH_UNIT, uid, KEY_UNIT_INT_BONUS_REAL);
		assert.Real(bonus, 40.0, "智力 Bonus 40 后应正确存储");

		hero = null;
		p = null;
	}

	// 测试9：非 BigInteger 单位的边界情况
	private function Test_NonBigIntegerUnit() {
		player p; unit footman; real str; real agi; real intVal; real baseStr; real baseAgi; real baseInt; real finalPercent;

		p = ConvertedPlayer(1);
		footman = CreateUnit(p, 'hfoo', 0.0, 0.0, 270.0);

		// 非 BigInteger 单位的所有操作应该不生效或返回 0/1.0
		SetUnitStr(footman, 100.0);
		str = GetUnitStr(footman);
		assert.Real(str, 0.0, "非 BigInteger 单位 GetUnitStr 应返回 0");

		AddUnitStr(footman, 50.0);
		str = GetUnitStr(footman);
		assert.Real(str, 0.0, "非 BigInteger 单位 AddUnitStr 后 GetUnitStr 仍应返回 0");

		baseStr = GetUnitBaseStr(footman);
		assert.Real(baseStr, 0.0, "非 BigInteger 单位 GetUnitBaseStr 应返回 0");

		finalPercent = GetUnitStrFinalPercent(footman);
		assert.Real(finalPercent, 1.0, "非 BigInteger 单位 GetUnitStrFinalPercent 应返回 1.0");

		// 主属性/次属性操作也应不生效
		AddUnitMainAttrValue(footman, 100.0);
		AddUnitSubAttrValue(footman, 50.0);
		baseStr = GetUnitBaseStr(footman);
		assert.Real(baseStr, 0.0, "非 BigInteger 单位主/次属性操作后 GetUnitBaseStr 仍应返回 0");

		footman = null;
		p = null;
	}

	function Init () {
		// 自动执行所有测试
		UnitTestAutoTimer(0.3, 0.1, function() {
			Trace("HeroUtils 主属性类型测试");
			Test_MainAttrType();
		}, null);

		UnitTestAutoTimer(0.4, 0.1, function() {
			Trace("HeroUtils 主属性操作测试");
			Test_MainAttrOperations();
		}, null);

		UnitTestAutoTimer(0.5, 0.1, function() {
			Trace("HeroUtils 次属性操作测试");
			Test_SubAttrOperations();
		}, null);

		UnitTestAutoTimer(0.6, 0.1, function() {
			Trace("HeroUtils 三维基础值测试");
			Test_BaseAttrValue();
		}, null);

		UnitTestAutoTimer(0.7, 0.1, function() {
			Trace("HeroUtils 最终倍率测试");
			Test_FinalPercent();
		}, null);

		UnitTestAutoTimer(0.8, 0.1, function() {
			Trace("HeroUtils 完整属性计算测试");
			Test_FullAttrCalculation();
		}, null);

		UnitTestAutoTimer(0.9, 0.1, function() {
			Trace("HeroUtils 属性 Set/Add 测试");
			Test_AttrSetAdd();
		}, null);

		UnitTestAutoTimer(1.0, 0.1, function() {
			Trace("HeroUtils 属性 Up/Down/Bonus 测试");
			Test_AttrUpDownBonus();
		}, null);

		UnitTestAutoTimer(1.1, 0.1, function() {
			Trace("HeroUtils 非 BigInteger 单位边界测试");
			Test_NonBigIntegerUnit();
		}, null);
	}

	function TTestUTHeroUtils1 (player p) {
		Test_MainAttrType();
		BJDebugMsg("[HeroUtils] 主属性类型测试完成");
	}
	function TTestUTHeroUtils2 (player p) {
		Test_MainAttrOperations();
		BJDebugMsg("[HeroUtils] 主属性操作测试完成");
	}
	function TTestUTHeroUtils3 (player p) {
		Test_SubAttrOperations();
		BJDebugMsg("[HeroUtils] 次属性操作测试完成");
	}
	function TTestUTHeroUtils4 (player p) {
		Test_BaseAttrValue();
		BJDebugMsg("[HeroUtils] 三维基础值测试完成");
	}
	function TTestUTHeroUtils5 (player p) {
		Test_FinalPercent();
		BJDebugMsg("[HeroUtils] 最终倍率测试完成");
	}
	function TTestUTHeroUtils6 (player p) {
		Test_FullAttrCalculation();
		BJDebugMsg("[HeroUtils] 完整属性计算测试完成");
	}
	function TTestUTHeroUtils7 (player p) {
		Test_AttrSetAdd();
		BJDebugMsg("[HeroUtils] 属性 Set/Add 测试完成");
	}
	function TTestUTHeroUtils8 (player p) {
		Test_AttrUpDownBonus();
		BJDebugMsg("[HeroUtils] 属性 Up/Down/Bonus 测试完成");
	}
	function TTestUTHeroUtils9 (player p) {
		Test_NonBigIntegerUnit();
		BJDebugMsg("[HeroUtils] 非 BigInteger 单位边界测试完成");
	}
	function TTestUTHeroUtils10 (player p) {
		// 执行所有测试
		Test_MainAttrType();
		Test_MainAttrOperations();
		Test_SubAttrOperations();
		Test_BaseAttrValue();
		Test_FinalPercent();
		Test_FullAttrCalculation();
		Test_AttrSetAdd();
		Test_AttrUpDownBonus();
		Test_NonBigIntegerUnit();
		BJDebugMsg("[HeroUtils] 所有测试完成");
	}
	function TTestActUTHeroUtils1 (string str) {
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
			BJDebugMsg("[HeroUtils] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTHeroUtils1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTHeroUtils1(GetTriggerPlayer());
			else if(str == "s2") TTestUTHeroUtils2(GetTriggerPlayer());
			else if(str == "s3") TTestUTHeroUtils3(GetTriggerPlayer());
			else if(str == "s4") TTestUTHeroUtils4(GetTriggerPlayer());
			else if(str == "s5") TTestUTHeroUtils5(GetTriggerPlayer());
			else if(str == "s6") TTestUTHeroUtils6(GetTriggerPlayer());
			else if(str == "s7") TTestUTHeroUtils7(GetTriggerPlayer());
			else if(str == "s8") TTestUTHeroUtils8(GetTriggerPlayer());
			else if(str == "s9") TTestUTHeroUtils9(GetTriggerPlayer());
			else if(str == "s10") TTestUTHeroUtils10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
