#ifndef UTItemDecorateIncluded
#define UTItemDecorateIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTItemDecorate requires ItemDecorate {

	// 测试用的物品数组
	item testItems[];

	function Init () {
		integer i;
		// 在地图上创建一些测试物品并设置装饰
		testItems[1] = CreateItem('rag1', -300, 200); // 敏捷便鞋
		SetItemDecorateIcon(testItems[1], "ReplaceableTextures\\CommandButtons\\BTNBootsOfSpeed.blp");
		SetItemDecorateGrow(testItems[1], growdata[ICONGROW_13]);

		testItems[2] = CreateItem('ram1', -200, 200); // 大魔法师指环
		SetItemDecorateIcon(testItems[2], "ReplaceableTextures\\CommandButtons\\BTNRingGreen.blp");
		SetItemDecorateGrow(testItems[2], growdata[ICONGROW_14]);

		testItems[3] = CreateItem('ram2', -100, 200); // 大魔法师指环 +2
		SetItemDecorateIcon(testItems[3], "ReplaceableTextures\\CommandButtons\\BTNRingViolet.blp");
		SetItemDecorateGrow(testItems[3], growdata[ICONGROW_15]);

		testItems[4] = CreateItem('sor2', 0, 200); // 影子之球 +2
		SetItemDecorateIcon(testItems[4], "ReplaceableTextures\\CommandButtons\\BTNOrbOfDarkness.blp");
		SetItemDecorateGrow(testItems[4], growdata[ICONGROW_16]);

		testItems[5] = CreateItem('sor3', 100, 200); // 影子之球 +3
		SetItemDecorateIcon(testItems[5], "ReplaceableTextures\\CommandButtons\\BTNOrbOfFire.blp");
		SetItemDecorateGrow(testItems[5], growdata[ICONGROW_17]);

		testItems[6] = CreateItem('sreg', 200, 200); // 恢复卷轴
		SetItemDecorateIcon(testItems[6], "ReplaceableTextures\\CommandButtons\\BTNScrollOfHealing.blp");
		SetItemDecorateGrow(testItems[6], growdata[ICONGROW_18]);

		// 创建一些只有图标没有流光的物品
		testItems[7] = CreateItem('spsh', -300, 100); // 魔法护盾护身符
		SetItemDecorateIcon(testItems[7], "ReplaceableTextures\\CommandButtons\\BTNPeriapt.blp");

		testItems[8] = CreateItem('srbd', -200, 100); // 灼热之刃
		SetItemDecorateIcon(testItems[8], "ReplaceableTextures\\CommandButtons\\BTNSteelMelee.blp");

		// 创建一些只有流光没有自定义图标的物品
		testItems[9] = CreateItem('thdm', -100, 100); // 雷霆蜥蜴钻石
		SetItemDecorateGrow(testItems[9], growdata[ICONGROW_13]);

		testItems[10] = CreateItem('tin2', 0, 100); // 智力之书 +2
		SetItemDecorateGrow(testItems[10], growdata[ICONGROW_14]);

		BJDebugMsg("|cFFFFCC00[ItemDecorate]|r 已创建10个带装饰的测试物品");
		BJDebugMsg("|cFFFFCC00[ItemDecorate]|r 拾取物品到英雄物品栏可查看装饰效果");
	}

	// 测试1: 为地上的物品动态添加装饰
	function TTestUTItemDecorate1 (player p) {
		item it;
		it = CreateItem('dkfw', 0, 0);
		SetItemDecorateIcon(it, "ReplaceableTextures\\CommandButtons\\BTNChestOfGold.blp");
		SetItemDecorateGrow(it, growdata[ICONGROW_13]);
		BJDebugMsg("|cFF00FF00[测试1]|r 在(0,0)创建带装饰的物品");
		it = null;
	}

	// 测试2: 移除物品装饰（设为空）
	function TTestUTItemDecorate2 (player p) {
		if (testItems[1] != null) {
			SetItemDecorateIcon(testItems[1], "");
			SetItemDecorateGrow(testItems[1], 0);
			BJDebugMsg("|cFF00FF00[测试2]|r 已移除物品1的装饰，重新拾取可查看效果");
		}
	}

	// 测试3: 修改物品装饰
	function TTestUTItemDecorate3 (player p) {
		if (testItems[2] != null) {
			SetItemDecorateIcon(testItems[2], "ReplaceableTextures\\CommandButtons\\BTNCrystalBall.blp");
			SetItemDecorateGrow(testItems[2], growdata[ICONGROW_18]);
			BJDebugMsg("|cFF00FF00[测试3]|r 已修改物品2的装饰，重新拾取可查看效果");
		}
	}

	// 测试4: 批量创建带装饰的物品
	function TTestUTItemDecorate4 (player p) {
		integer i;
		item it;
		real x; real y;
		x = -200.0;
		for (1 <= i <= 6) {
			y = -100.0 + i * 30.0;
			it = CreateItem('rag1', x, y);
			SetItemDecorateIcon(it, "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp");
			SetItemDecorateGrow(it, growdata[ICONGROW_13 + ModuloInteger(i - 1, 6)]);
			it = null;
		}
		BJDebugMsg("|cFF00FF00[测试4]|r 创建6个带相同图标但不同流光的物品");
	}

	// 测试5: 只设置图标不设置流光
	function TTestUTItemDecorate5 (player p) {
		item it;
		it = CreateItem('dphe', 100, 0);
		SetItemDecorateIcon(it, "ReplaceableTexture\\CommandButtons\\BTNPhoenixEgg.blp");
		BJDebugMsg("|cFF00FF00[测试5]|r 创建只有自定义图标的物品");
		it = null;
	}

	// 测试6: 只设置流光不设置图标
	function TTestUTItemDecorate6 (player p) {
		item it;
		it = CreateItem('thle', 200, 0);
		SetItemDecorateGrow(it, growdata[ICONGROW_17]);
		BJDebugMsg("|cFF00FF00[测试6]|r 创建只有流光效果的物品");
		it = null;
	}

	function TTestUTItemDecorate7 (player p) {}
	function TTestUTItemDecorate8 (player p) {}
	function TTestUTItemDecorate9 (player p) {}
	function TTestUTItemDecorate10 (player p) {}
	function TTestActUTItemDecorate1 (string str) {
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
			unit hero1, hero2;
			real x = 0, y = 0;

			BJDebugMsg("[ItemDecorate] 单元测试已加载");

			// 为玩家1创建两个测试英雄
			hero1 = CreateUnit(Player(0), 'Hamg', x, y, 270); // 创建大法师在坐标(0,0)
			hero2 = CreateUnit(Player(0), 'Hblm', x + 200, y, 270); // 创建血法师在坐标(200,0)

			// 为英雄添加一些技能用于测试
			UnitAddAbility(hero1, 'ACbc'); // 火焰呼吸
			UnitAddAbility(hero1, 'ACbf'); // 霜冻闪电
			UnitAddAbility(hero1, 'ACpy'); // 变形术
			UnitAddAbility(hero1, 'AOhx'); // 妖术
			UnitAddAbility(hero1, 'ACdv'); // 吞噬
			UnitAddAbility(hero1, 'ACen'); // 诱捕

			UnitAddAbility(hero2, 'AHbz'); // 暴风雪
			UnitAddAbility(hero2, 'AHwe'); // 水元素
			UnitAddAbility(hero2, 'AHab'); // 闪现
			UnitAddAbility(hero2, 'AHmt'); // 群体传送
			UnitAddAbility(hero2, 'AHfs'); // 烈焰风暴
			UnitAddAbility(hero2, 'AHbn'); // 驱逐魔法

			BJDebugMsg("|cFFFFCC00[ItemDecorate]|r 已创建两个测试英雄：大法师和血法师");
			BJDebugMsg("|cFFFFCC00[ItemDecorate]|r 选中英雄拾取物品可测试装饰效果");

			Init();

			// 清理句柄
			hero1 = null;
			hero2 = null;

			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTItemDecorate1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTItemDecorate1(GetTriggerPlayer());
			else if(str == "s2") TTestUTItemDecorate2(GetTriggerPlayer());
			else if(str == "s3") TTestUTItemDecorate3(GetTriggerPlayer());
			else if(str == "s4") TTestUTItemDecorate4(GetTriggerPlayer());
			else if(str == "s5") TTestUTItemDecorate5(GetTriggerPlayer());
			else if(str == "s6") TTestUTItemDecorate6(GetTriggerPlayer());
			else if(str == "s7") TTestUTItemDecorate7(GetTriggerPlayer());
			else if(str == "s8") TTestUTItemDecorate8(GetTriggerPlayer());
			else if(str == "s9") TTestUTItemDecorate9(GetTriggerPlayer());
			else if(str == "s10") TTestUTItemDecorate10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
