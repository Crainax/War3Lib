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

	function Init () {
        integer key;

        // 为英雄添加技能并设置装饰
        // 大法师的技能装饰
        SetAbilityDecorateIcon(testHero1, 'ACbc', "ReplaceableTextures\\CommandButtons\\BTNBreathOfFire.blp");
        SetAbilityDecorateGrow(testHero1, 'ACbc', growdata[ICONGROW_13]);
        SetAbilityDecorateCornerText(testHero1, 'ACbc', "1");

        SetAbilityDecorateIcon(testHero1, 'ACbf', "ReplaceableTextures\\CommandButtons\\BTNFreezingBreath.blp");
        SetAbilityDecorateGrow(testHero1, 'ACbf', growdata[ICONGROW_14]);
        SetAbilityDecorateCornerText(testHero1, 'ACbf', "2");

        SetAbilityDecorateIcon(testHero1, 'ACpy', "ReplaceableTextures\\CommandButtons\\BTNPolymorph.blp");
        SetAbilityDecorateGrow(testHero1, 'ACpy', growdata[ICONGROW_15]);
        SetAbilityDecorateCornerText(testHero1, 'ACpy', "3");

        SetAbilityDecorateIcon(testHero1, 'AOhx', "ReplaceableTextures\\CommandButtons\\BTNHex.blp");
        SetAbilityDecorateGrow(testHero1, 'AOhx', growdata[ICONGROW_16]);
        SetAbilityDecorateCornerText(testHero1, 'AOhx', "4");

        SetAbilityDecorateIcon(testHero1, 'ACdv', "ReplaceableTextures\\CommandButtons\\BTNDevour.blp");
        SetAbilityDecorateGrow(testHero1, 'ACdv', growdata[ICONGROW_17]);
        SetAbilityDecorateCornerText(testHero1, 'ACdv', "5");

        SetAbilityDecorateIcon(testHero1, 'ACen', "ReplaceableTextures\\CommandButtons\\BTNEnsnare.blp");
        SetAbilityDecorateGrow(testHero1, 'ACen', growdata[ICONGROW_18]);
        SetAbilityDecorateCornerText(testHero1, 'ACen', "6");

		// 血法师的技能装饰
        SetAbilityDecorateIcon(testHero2, 'AHbz', "ReplaceableTextures\\CommandButtons\\BTNBlizzard.blp");
        SetAbilityDecorateGrow(testHero2, 'AHbz', growdata[ICONGROW_13]);
        SetAbilityDecorateCornerText(testHero2, 'AHbz', "Q");

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
        key = GetAbilityHashKey(testHero1, 'ACbc');
        Trace("|cFF99FFCC[HashTest]|r H1 'ACbc' key = " + I2S(key));

        key = GetAbilityHashKey(testHero1, 'ACbf');
        Trace("|cFF99FFCC[HashTest]|r H1 'ACbf' key = " + I2S(key));

        key = GetAbilityHashKey(testHero1, 'ACpy');
        Trace("|cFF99FFCC[HashTest]|r H1 'ACpy' key = " + I2S(key));

        key = GetAbilityHashKey(testHero2, 'AHbz');
        Trace("|cFF99FFCC[HashTest]|r H2 'AHbz' key = " + I2S(key));

        key = GetAbilityHashKey(testHero2, 'AHwe');
        Trace("|cFF99FFCC[HashTest]|r H2 'AHwe' key = " + I2S(key));

        key = GetAbilityHashKey(testHero2, 'AHab');
        Trace("|cFF99FFCC[HashTest]|r H2 'AHab' key = " + I2S(key));

		Trace("|cFFFFCC00[AbilityDecorate]|r 已为两个英雄的技能设置装饰");
		Trace("|cFFFFCC00[AbilityDecorate]|r 选中英雄可查看技能装饰效果");
	}

	// 测试1: 为技能动态添加装饰
	function TTestUTAbilityDecorate1 (player p) {
		unit u; ability abil;
        u = DzGetSelectedLeaderUnit();
        if (u != null) {
            SetAbilityDecorateIcon(u, 'ACbc', "ReplaceableTextures\\CommandButtons\\BTNChestOfGold.blp");
            SetAbilityDecorateGrow(u, 'ACbc', growdata[ICONGROW_13]);
            SetAbilityDecorateCornerText(u, 'ACbc', "★");
            Trace("|cFF00FF00[测试1]|r 已为火焰呼吸技能添加装饰");
        }
		abil = null; u = null;
	}

	// 测试2: 移除技能装饰（设为空）
	function TTestUTAbilityDecorate2 (player p) {
		unit u; ability abil;
        u = DzGetSelectedLeaderUnit();
        if (u != null) {
            SetAbilityDecorateIcon(u, 'ACbf', "");
            SetAbilityDecorateGrow(u, 'ACbf', 0);
            SetAbilityDecorateCornerText(u, 'ACbf', "");
            Trace("|cFF00FF00[测试2]|r 已移除霜冻闪电技能的装饰");
        }
		abil = null; u = null;
	}

	// 测试3: 修改技能装饰
	function TTestUTAbilityDecorate3 (player p) {
		unit u; ability abil;
        u = DzGetSelectedLeaderUnit();
        if (u != null) {
            SetAbilityDecorateIcon(u, 'ACpy', "ReplaceableTextures\\CommandButtons\\BTNCrystalBall.blp");
            SetAbilityDecorateGrow(u, 'ACpy', growdata[ICONGROW_18]);
            SetAbilityDecorateCornerText(u, 'ACpy', "★");
            Trace("|cFF00FF00[测试3]|r 已修改变形术技能的装饰");
        }
		abil = null; u = null;
	}

	// 测试4: 批量设置技能装饰
	function TTestUTAbilityDecorate4 (player p) {
		unit u; ability abil; integer i; integer abilCodes[]; string icons[]; string texts[];

		u = DzGetSelectedLeaderUnit();
		if (u == null) { return; }

		// 设置技能ID数组
		abilCodes[1] = 'ACbc'; icons[1] = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"; texts[1] = "A";
		abilCodes[2] = 'ACbf'; icons[2] = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"; texts[2] = "B";
		abilCodes[3] = 'ACpy'; icons[3] = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"; texts[3] = "C";
		abilCodes[4] = 'AOhx'; icons[4] = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"; texts[4] = "D";
		abilCodes[5] = 'ACdv'; icons[5] = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"; texts[5] = "E";
		abilCodes[6] = 'ACen'; icons[6] = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"; texts[6] = "F";

        for (1 <= i <= 6) {
            SetAbilityDecorateIcon(u, abilCodes[i], icons[i]);
            SetAbilityDecorateGrow(u, abilCodes[i], growdata[ICONGROW_13 + ModuloInteger(i - 1, 6)]);
            SetAbilityDecorateCornerText(u, abilCodes[i], texts[i]);
        }
		Trace("|cFF00FF00[测试4]|r 已批量设置6个技能的装饰");
		abil = null; u = null;
	}

	// 测试5: 只设置图标不设置流光和文字
	function TTestUTAbilityDecorate5 (player p) {
		unit u; ability abil;
        u = DzGetSelectedLeaderUnit();
        if (u != null) {
            SetAbilityDecorateIcon(u, 'AHbz', "ReplaceableTextures\\CommandButtons\\BTNPhoenixEgg.blp");
            Trace("|cFF00FF00[测试5]|r 已为暴风雪技能设置自定义图标");
        }
		abil = null; u = null;
	}

	// 测试6: 只设置流光不设置图标和文字
	function TTestUTAbilityDecorate6 (player p) {
		unit u; ability abil;
        u = DzGetSelectedLeaderUnit();
        if (u != null) {
            SetAbilityDecorateGrow(u, 'AHwe', growdata[ICONGROW_17]);
            Trace("|cFF00FF00[测试6]|r 已为水元素技能设置流光效果");
        }
		abil = null; u = null;
	}

	// 测试7: 只设置角落文字
	function TTestUTAbilityDecorate7 (player p) {
		unit u; ability abil;
        u = DzGetSelectedLeaderUnit();
        if (u != null) {
            SetAbilityDecorateCornerText(u, 'AHab', "★");
            Trace("|cFF00FF00[测试7]|r 已为闪现技能设置角落文字");
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

		abilCodes[1] = 'ACbc'; abilCodes[2] = 'ACbf'; abilCodes[3] = 'ACpy';
		abilCodes[4] = 'AOhx'; abilCodes[5] = 'ACdv'; abilCodes[6] = 'ACen';

        for (1 <= i <= 6) {
            SetAbilityDecorateIcon(u, abilCodes[i], "");
            SetAbilityDecorateGrow(u, abilCodes[i], 0);
            SetAbilityDecorateCornerText(u, abilCodes[i], "");
        }
		Trace("|cFF00FF00[测试9]|r 已清除当前英雄所有技能的装饰");
		abil = null; u = null;
	}

	// 测试10: 重新初始化装饰
	function TTestUTAbilityDecorate10 (player p) {
		Init();
		Trace("|cFF00FF00[测试10]|r 已重新初始化所有技能装饰");
		//YDWEId2S
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

			Trace("|cFFFFCC00[AbilityDecorate]|r 已创建两个测试英雄：大法师和血法师");
			Trace("|cFFFFCC00[AbilityDecorate]|r 选中英雄可测试技能装饰效果");

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
		});

	}

}
//! endzinc

#endif
