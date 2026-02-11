#ifndef UTAbilityDecorateIncluded
#define UTAbilityDecorateIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTAbilityDecorate requires AbilityDecorate {

	// 测试用的英雄和技能
	unit testHero1; // 大法师
	unit testHero2; // 血法师
	integer ABIL_BOOK_MAIN = 'A0DA';     // AbilityDecorate.w3a: 魔法书
	integer ABIL_BOOK_SKILL1 = 'A0DB';   // AbilityDecorate.w3a: 书内技能1
	integer ABIL_BOOK_SKILL2 = 'A0DC';   // AbilityDecorate.w3a: 书内技能2
	integer ABIL_BOOK_SKILL3 = 'A0DD';   // AbilityDecorate.w3a: 书内技能3

	private function SetupTestSpellBook(unit u) {
		UnitAddAbility(u, ABIL_BOOK_MAIN);
		DzSetUnitAbilitySpellBookList(u, ABIL_BOOK_MAIN, "A0DB,A0DC,A0DD", true);
		DzSetUnitAbilityUpdate(u, ABIL_BOOK_MAIN);
	}

	function Init () {
        integer key;

        // 魔法书本体装饰（验证：角标 + 流光 + 暗图层）
        SetAbilityDecorateIcon(testHero1, ABIL_BOOK_MAIN, "ReplaceableTextures\\CommandButtons\\BTNSpellBookBLS.blp");
        SetAbilityDecorateGrow(testHero1, ABIL_BOOK_MAIN, growdata[ICONGROW_16]);
        SetAbilityDecorateCornerText(testHero1, ABIL_BOOK_MAIN, "书");
        SetAbilityDecorateShadow(testHero1, ABIL_BOOK_MAIN, true);

        // 书内技能装饰（验证：角标 + 流光）
        SetAbilityDecorateIcon(testHero1, ABIL_BOOK_SKILL1, "ReplaceableTextures\\CommandButtons\\BTNHealOn.blp");
        SetAbilityDecorateGrow(testHero1, ABIL_BOOK_SKILL1, growdata[ICONGROW_13]);
        SetAbilityDecorateCornerText(testHero1, ABIL_BOOK_SKILL1, "Q");

        SetAbilityDecorateIcon(testHero1, ABIL_BOOK_SKILL2, "ReplaceableTextures\\CommandButtons\\BTNWaterElemental.blp");
        SetAbilityDecorateGrow(testHero1, ABIL_BOOK_SKILL2, growdata[ICONGROW_14]);
        SetAbilityDecorateCornerText(testHero1, ABIL_BOOK_SKILL2, "W");

        SetAbilityDecorateIcon(testHero1, ABIL_BOOK_SKILL3, "ReplaceableTextures\\CommandButtons\\BTNFlameStrike.blp");
        SetAbilityDecorateGrow(testHero1, ABIL_BOOK_SKILL3, growdata[ICONGROW_15]);
        SetAbilityDecorateCornerText(testHero1, ABIL_BOOK_SKILL3, "E");

			// 血法师的技能装饰
        SetAbilityDecorateIcon(testHero2, 'AHbz', "ReplaceableTextures\\CommandButtons\\BTNBlizzard.blp");
        SetAbilityDecorateGrow(testHero2, 'AHbz', growdata[ICONGROW_13]);
        SetAbilityDecorateCornerText(testHero2, 'AHbz', "Q");
        SetAbilityDecorateShadow(testHero2, 'AHbz', true);

        SetAbilityDecorateIcon(testHero2, 'AHwe', "ReplaceableTextures\\CommandButtons\\BTNWaterElemental.blp");
        SetAbilityDecorateGrow(testHero2, 'AHwe', growdata[ICONGROW_14]);
        SetAbilityDecorateCornerText(testHero2, 'AHwe', "W");

        SetAbilityDecorateIcon(testHero2, 'AHab', "ReplaceableTextures\\CommandButtons\\BTNBlink.blp");
        SetAbilityDecorateGrow(testHero2, 'AHab', growdata[ICONGROW_15]);
        SetAbilityDecorateCornerText(testHero2, 'AHab', "E");

        SetAbilityDecorateIcon(testHero2, 'AHmt', "ReplaceableTextures\\CommandButtons\\BTNMassTeleport.blp");
        SetAbilityDecorateGrow(testHero2, 'AHmt', growdata[ICONGROW_16]);
        SetAbilityDecorateCornerText(testHero2, 'AHmt', "R");

        SetAbilityDecorateIcon(testHero2, 'AHfs', "ReplaceableTextures\\CommandButtons\\BTNFlameStrike.blp");
        SetAbilityDecorateGrow(testHero2, 'AHfs', growdata[ICONGROW_17]);
        SetAbilityDecorateCornerText(testHero2, 'AHfs', "T");

        SetAbilityDecorateIcon(testHero2, 'AHbn', "ReplaceableTextures\\CommandButtons\\BTNBanish.blp");
        SetAbilityDecorateGrow(testHero2, 'AHbn', growdata[ICONGROW_18]);
        SetAbilityDecorateCornerText(testHero2, 'AHbn', "Y");

        // 输出部分典型散列键，方便观察哈希分布（父键 = GetAbilityHashKey(unit, abilityId)）
        key = GetAbilityHashKey(testHero1, ABIL_BOOK_MAIN);
        Trace("|cFF99FFCC[HashTest]|r H1 魔法书A0DA key = " + I2S(key));

        key = GetAbilityHashKey(testHero1, ABIL_BOOK_SKILL1);
        Trace("|cFF99FFCC[HashTest]|r H1 书内A0DB key = " + I2S(key));

        key = GetAbilityHashKey(testHero1, ABIL_BOOK_SKILL2);
        Trace("|cFF99FFCC[HashTest]|r H1 书内A0DC key = " + I2S(key));

        key = GetAbilityHashKey(testHero1, ABIL_BOOK_SKILL3);
        Trace("|cFF99FFCC[HashTest]|r H1 书内A0DD key = " + I2S(key));

			Trace("|cFFFFCC00[AbilityDecorate]|r 已设置魔法书本体 + 书内3技能装饰");
			Trace("|cFFFFCC00[AbilityDecorate]|r 选中大法师后先看魔法书按钮，再点开魔法书查看书内技能装饰");
		}

	// 测试1: 魔法书本体动态装饰 + 暗图层切换
	function TTestUTAbilityDecorate1 (player p) {
		unit u; ability abil; integer key; boolean nowOn;
        u = DzGetSelectedLeaderUnit();
        if (u != null) {
            SetAbilityDecorateIcon(u, ABIL_BOOK_MAIN, "ReplaceableTextures\\CommandButtons\\BTNChestOfGold.blp");
            SetAbilityDecorateGrow(u, ABIL_BOOK_MAIN, growdata[ICONGROW_18]);
            SetAbilityDecorateCornerText(u, ABIL_BOOK_MAIN, "书★");
            key = GetAbilityHashKey(u, ABIL_BOOK_MAIN);
            nowOn = HaveSavedBoolean(HASH_ABILITY, key, HASH_CHILD_SALT_SHADOW);
            if (nowOn) {
                SetAbilityDecorateShadow(u, ABIL_BOOK_MAIN, false);
                Trace("|cFF00FF00[测试1]|r 魔法书暗图层：当前开启 -> 已关闭");
            } else {
                SetAbilityDecorateShadow(u, ABIL_BOOK_MAIN, true);
                Trace("|cFF00FF00[测试1]|r 魔法书暗图层：当前关闭 -> 已开启");
            }
        }
		abil = null; u = null;
	}

	// 测试2: 移除书内技能1装饰（设为空）
	function TTestUTAbilityDecorate2 (player p) {
		unit u; ability abil;
        u = DzGetSelectedLeaderUnit();
        if (u != null) {
            SetAbilityDecorateIcon(u, ABIL_BOOK_SKILL1, "");
            SetAbilityDecorateGrow(u, ABIL_BOOK_SKILL1, 0);
            SetAbilityDecorateCornerText(u, ABIL_BOOK_SKILL1, "");
            Trace("|cFF00FF00[测试2]|r 已移除书内技能A0DB的装饰");
        }
		abil = null; u = null;
	}

	// 测试3: 修改书内技能2装饰
	function TTestUTAbilityDecorate3 (player p) {
		unit u; ability abil;
        u = DzGetSelectedLeaderUnit();
        if (u != null) {
            SetAbilityDecorateIcon(u, ABIL_BOOK_SKILL2, "ReplaceableTextures\\CommandButtons\\BTNCrystalBall.blp");
            SetAbilityDecorateGrow(u, ABIL_BOOK_SKILL2, growdata[ICONGROW_17]);
            SetAbilityDecorateCornerText(u, ABIL_BOOK_SKILL2, "W★");
            Trace("|cFF00FF00[测试3]|r 已修改书内技能A0DC的装饰");
        }
		abil = null; u = null;
	}

	// 测试4: 批量设置魔法书本体+书内技能装饰
	function TTestUTAbilityDecorate4 (player p) {
		unit u; ability abil; integer i; integer abilCodes[]; string icons[]; string texts[];

		u = DzGetSelectedLeaderUnit();
		if (u == null) { return; }

		// 设置技能ID数组（1本魔法书 + 3个书内技能）
		abilCodes[1] = ABIL_BOOK_MAIN; icons[1] = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"; texts[1] = "书";
		abilCodes[2] = ABIL_BOOK_SKILL1; icons[2] = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"; texts[2] = "Q";
		abilCodes[3] = ABIL_BOOK_SKILL2; icons[3] = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"; texts[3] = "W";
		abilCodes[4] = ABIL_BOOK_SKILL3; icons[4] = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"; texts[4] = "E";

        for (1 <= i <= 4) {
            SetAbilityDecorateIcon(u, abilCodes[i], icons[i]);
            SetAbilityDecorateGrow(u, abilCodes[i], growdata[ICONGROW_13 + ModuloInteger(i - 1, 6)]);
            SetAbilityDecorateCornerText(u, abilCodes[i], texts[i]);
        }
		Trace("|cFF00FF00[测试4]|r 已批量设置魔法书本体和书内技能装饰");
		abil = null; u = null;
	}

	// 测试5: 只设置图标不设置流光和文字
	function TTestUTAbilityDecorate5 (player p) {
		unit u; ability abil;
        u = DzGetSelectedLeaderUnit();
        if (u != null) {
            SetAbilityDecorateIcon(u, ABIL_BOOK_MAIN, "ReplaceableTextures\\CommandButtons\\BTNPhoenixEgg.blp");
            Trace("|cFF00FF00[测试5]|r 已为魔法书本体设置自定义图标");
        }
		abil = null; u = null;
	}

	// 测试6: 只设置流光不设置图标和文字
	function TTestUTAbilityDecorate6 (player p) {
		unit u; ability abil;
        u = DzGetSelectedLeaderUnit();
        if (u != null) {
            SetAbilityDecorateGrow(u, ABIL_BOOK_SKILL1, growdata[ICONGROW_17]);
            Trace("|cFF00FF00[测试6]|r 已为书内技能A0DB设置流光效果");
        }
		abil = null; u = null;
	}

	// 测试7: 只设置角落文字
	function TTestUTAbilityDecorate7 (player p) {
		unit u; ability abil;
        u = DzGetSelectedLeaderUnit();
        if (u != null) {
            SetAbilityDecorateCornerText(u, ABIL_BOOK_SKILL2, "角标★");
            Trace("|cFF00FF00[测试7]|r 已为书内技能A0DC设置角标");
        }
		abil = null; u = null;
	}

	// 测试8: 切换英雄测试装饰
	function TTestUTAbilityDecorate8 (player p) {
		if (testHero1 != null && testHero2 != null) {
			SelectUnitForPlayerSingle(testHero1, p);
			Trace("|cFF00FF00[测试8]|r 已切换到第一个英雄，查看技能装饰");
		}
	}

	// 测试9: 清除所有装饰
	function TTestUTAbilityDecorate9 (player p) {
		unit u; ability abil; integer i; integer abilCodes[];

		u = DzGetSelectedLeaderUnit();
		if (u == null) { return; }

		abilCodes[1] = ABIL_BOOK_MAIN; abilCodes[2] = ABIL_BOOK_SKILL1;
		abilCodes[3] = ABIL_BOOK_SKILL2; abilCodes[4] = ABIL_BOOK_SKILL3;

        for (1 <= i <= 4) {
            SetAbilityDecorateIcon(u, abilCodes[i], "");
            SetAbilityDecorateGrow(u, abilCodes[i], 0);
            SetAbilityDecorateCornerText(u, abilCodes[i], "");
            SetAbilityDecorateShadow(u, abilCodes[i], false);
        }
		Trace("|cFF00FF00[测试9]|r 已清除当前英雄魔法书本体与书内技能装饰");
		abil = null; u = null;
	}

	// 测试10: 重新初始化装饰
	function TTestUTAbilityDecorate10 (player p) {
		Init();
		Trace("|cFF00FF00[测试10]|r 已重新初始化所有技能装饰");
		//YDWEId2S
	}

	// 测试11: 技能暗图层开关与哈希键验证
	function TTestUTAbilityDecorate11 (player p) {
		unit u; integer key; boolean hasShadow;
		u = DzGetSelectedLeaderUnit();
		if (u == null) { return; }

		key = GetAbilityHashKey(u, ABIL_BOOK_MAIN);
		SetAbilityDecorateShadow(u, ABIL_BOOK_MAIN, true);
		hasShadow = HaveSavedBoolean(HASH_ABILITY, key, HASH_CHILD_SALT_SHADOW);
        if (hasShadow) {
		    Trace("|cFF00FF00[测试11]|r 打开暗图层, hasShadow=true");
        } else {
		    Trace("|cFFFF5555[测试11]|r 打开暗图层, hasShadow=false");
        }

		SetAbilityDecorateShadow(u, ABIL_BOOK_MAIN, false);
		hasShadow = HaveSavedBoolean(HASH_ABILITY, key, HASH_CHILD_SALT_SHADOW);
        if (!hasShadow) {
		    Trace("|cFF00FF00[测试11]|r 关闭暗图层, hasShadow=false");
        } else {
		    Trace("|cFFFF5555[测试11]|r 关闭暗图层, hasShadow=true");
        }

		u = null;
	}

	function TTestActUTAbilityDecorate1 (string str) {
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
			real x = 0, y = 0;

			Trace("[AbilityDecorate] 单元测试已加载");

			// 为玩家1创建两个测试英雄
			testHero1 = CreateUnit(Player(0), 'Hamg', x, y, 270); // 创建大法师在坐标(0,0)
			testHero2 = CreateUnit(Player(0), 'Hblm', x + 200, y, 270); // 创建血法师在坐标(200,0)

			// 为英雄添加一些技能用于测试
			SetupTestSpellBook(testHero1); // 魔法书 + 书内技能
			UnitAddAbility(testHero1, 'ACbc'); // 火焰呼吸
			UnitAddAbility(testHero1, 'ACbf'); // 霜冻闪电
			UnitAddAbility(testHero1, 'ACpy'); // 变形术
			UnitAddAbility(testHero1, 'AOhx'); // 妖术
			UnitAddAbility(testHero1, 'ACdv'); // 吞噬
			UnitAddAbility(testHero1, 'ACen'); // 诱捕

			UnitAddAbility(testHero2, 'AHbz'); // 暴风雪
			UnitAddAbility(testHero2, 'AHwe'); // 水元素
			UnitAddAbility(testHero2, 'AHab'); // 闪现
			UnitAddAbility(testHero2, 'AHmt'); // 群体传送
			UnitAddAbility(testHero2, 'AHfs'); // 烈焰风暴
			UnitAddAbility(testHero2, 'AHbn'); // 驱逐魔法

			Trace("|cFFFFCC00[AbilityDecorate]|r 已创建两个测试英雄并注入魔法书物编技能");
			Trace("|cFFFFCC00[AbilityDecorate]|r 选中大法师：先看魔法书按钮角标/流光，再点开魔法书看书内技能角标/流光");

			Init();

			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTAbilityDecorate1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTAbilityDecorate1(GetTriggerPlayer());
			else if(str == "s2") TTestUTAbilityDecorate2(GetTriggerPlayer());
			else if(str == "s3") TTestUTAbilityDecorate3(GetTriggerPlayer());
			else if(str == "s4") TTestUTAbilityDecorate4(GetTriggerPlayer());
			else if(str == "s5") TTestUTAbilityDecorate5(GetTriggerPlayer());
			else if(str == "s6") TTestUTAbilityDecorate6(GetTriggerPlayer());
			else if(str == "s7") TTestUTAbilityDecorate7(GetTriggerPlayer());
			else if(str == "s8") TTestUTAbilityDecorate8(GetTriggerPlayer());
			else if(str == "s9") TTestUTAbilityDecorate9(GetTriggerPlayer());
			else if(str == "s10") TTestUTAbilityDecorate10(GetTriggerPlayer());
			else if(str == "s11") TTestUTAbilityDecorate11(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
