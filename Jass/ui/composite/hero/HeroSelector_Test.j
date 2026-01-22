#ifndef UTHeroSelectorIncluded
#define UTHeroSelectorIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTHeroSelector requires HeroSelector,Keyboard {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);

		heroData[1].icon = "ReplaceableTextures\\CommandButtons\\BTNKeeperOfTheGrove.blp";
		heroData[2].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroDemonHunter.blp";
		heroData[3].icon = "ReplaceableTextures\\CommandButtons\\BTNMetamorphosis.blp";
		heroData[4].icon = "ReplaceableTextures\\CommandButtons\\BTNEvilIllidan.blp";
		heroData[5].icon = "ReplaceableTextures\\CommandButtons\\BTNMetamorphosis.blp";
		heroData[6].icon = "ReplaceableTextures\\CommandButtons\\BTNFurion.blp";
		heroData[7].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroDemonHunter.blp";
		heroData[8].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroDemonHunter.blp";
		heroData[9].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroDemonHunter.blp";
		heroData[10].icon = "ReplaceableTextures\\CommandButtons\\BTNKeeperOfTheGrove.blp";
		heroData[11].icon = "ReplaceableTextures\\CommandButtons\\BTNKeeperGhostBlue.blp";
		heroData[12].icon = "ReplaceableTextures\\CommandButtons\\BTNFurion.blp";
		heroData[13].icon = "ReplaceableTextures\\CommandButtons\\BTNFurion.blp";
		heroData[14].icon = "ReplaceableTextures\\CommandButtons\\BTNPriestessOfTheMoon.blp";
		heroData[15].icon = "ReplaceableTextures\\CommandButtons\\BTNPriestessOfTheMoon.blp";
		heroData[16].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroWarden.blp";
		heroData[17].icon = "ReplaceableTextures\\CommandButtons\\BTNWarden2.blp";
		heroData[18].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroArchMage.blp";
		heroData[19].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroArchMage.blp";
		heroData[20].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp";
		heroData[21].icon = "ReplaceableTextures\\CommandButtons\\BTNArthas.blp";
		heroData[22].icon = "ReplaceableTextures\\CommandButtons\\BTNArthas.blp";
		heroData[23].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroBloodElfPrince.blp";
		heroData[24].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp";
		heroData[25].icon = "ReplaceableTextures\\CommandButtons\\BTNGhostMage.blp";
		heroData[26].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp";
		heroData[27].icon = "ReplaceableTextures\\CommandButtons\\BTNJaina.blp";
		heroData[28].icon = "ReplaceableTextures\\CommandButtons\\BTNBloodMage2.blp";
		heroData[29].icon = "ReplaceableTextures\\CommandButtons\\BTNGarithos.blp";
		heroData[30].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroMountainKing.blp";
		heroData[31].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp";
		heroData[32].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroMountainKing.blp";
		heroData[33].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp";
		heroData[34].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp";
		heroData[35].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp";
		heroData[36].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp";
		heroData[37].icon = "ReplaceableTextures\\CommandButtons\\BTNNagaSeaWitch.blp";
		heroData[1].name = "阿利亚之笛";
		heroData[2].name = "古之忍耐姜歌";
		heroData[3].name = "召唤护身符";
		heroData[4].name = "远古雕像";
		heroData[5].name = "重生十字章";
		heroData[6].name = "神秘卷轴";
		heroData[7].name = "芒硝护盾";
		heroData[8].name = "刺客佩刀";
		heroData[9].name = "先祖权杖";
		heroData[10].name = "埃苏尼之心";
		heroData[11].name = "奎尔萨拉斯之靴";
		heroData[12].name = "血羽之心";
		heroData[13].name = "巨人力量腰带";
		heroData[14].name = "剑刃护甲";
		heroData[15].name = "神秘腰带";
		heroData[16].name = "敏捷腰带";
		heroData[17].name = "速度之靴";
		heroData[18].name = "战斗标准";
		heroData[19].name = "空瓶";
		heroData[20].name = "盛满泉水的瓶子";
		heroData[21].name = "统治权杖";
		heroData[22].name = "奶酪";
		heroData[23].name = "法师长袍";
		heroData[24].name = "国王之冠";
		heroData[25].name = "火焰风衣";
		heroData[26].name = "影子风衣";
		heroData[27].name = "赛纳留斯的号角";
		heroData[28].name = "贵族圆环";
		heroData[29].name = "灵魂之球";
		heroData[30].name = "死亡领主皇冠";
		heroData[31].name = "水晶球";
		heroData[32].name = "科勒恩的逃脱匕首";
		heroData[33].name = "雷霆水桶";
		heroData[34].name = "雷霆凤凰蛋";
		heroData[35].name = "德鲁伊布袋";
		heroData[36].name = "召唤钻石";
		heroData[37].name = "雷电花芯";
		heroData[1].text2 = "力量英雄/近战";
		heroData[2].text2 = "力量英雄/近战";
		heroData[3].text2 = "力量英雄/近战";
		heroData[4].text2 = "力量英雄/近战";
		heroData[5].text2 = "力量英雄/近战";
		heroData[6].text2 = "力量英雄/近战";
		heroData[7].text2 = "力量英雄/近战";
		heroData[8].text2 = "力量英雄/近战";
		heroData[9].text2 = "力量英雄/近战";
		heroData[10].text2 = "力量英雄/近战";
		heroData[11].text2 = "力量英雄/近战";
		heroData[12].text2 = "力量英雄/近战";
		heroData[13].text2 = "力量英雄/近战";
		heroData[14].text2 = "力量英雄/近战";
		heroData[15].text2 = "力量英雄/近战";
		heroData[16].text2 = "力量英雄/近战";
		heroData[17].text2 = "力量英雄/近战";
		heroData[18].text2 = "力量英雄/近战";
		heroData[19].text2 = "力量英雄/近战";
		heroData[20].text2 = "力量英雄/近战";
		heroData[21].text2 = "力量英雄/近战";
		heroData[22].text2 = "力量英雄/近战";
		heroData[23].text2 = "力量英雄/近战";
		heroData[24].text2 = "力量英雄/近战";
		heroData[25].text2 = "力量英雄/近战";
		heroData[26].text2 = "力量英雄/近战";
		heroData[27].text2 = "力量英雄/近战";
		heroData[28].text2 = "力量英雄/近战";
		heroData[29].text2 = "力量英雄/近战";
		heroData[30].text2 = "力量英雄/近战";
		heroData[31].text2 = "力量英雄/近战";
		heroData[32].text2 = "力量英雄/近战";
		heroData[33].text2 = "力量英雄/近战";
		heroData[34].text2 = "力量英雄/近战";
		heroData[35].text2 = "力量英雄/近战";
		heroData[36].text2 = "力量英雄/近战";
		heroData[37].text2 = "力量英雄/近战";
		heroData.size = 37;

		heroData.trBtn1Click = CreateTrigger();
		TriggerAddCondition(heroData.trBtn1Click, Condition(function (){
			player p = GetHeroSelectorPlayer();
			toastHint.createAtMouse(p, "[HSelect] 玩家 " + GetPlayerName(p) + " 点击了按钮1（随机选择）");
		}));

		heroData.trBtn2Click = CreateTrigger();
		TriggerAddCondition(heroData.trBtn2Click, Condition(function (){
			integer pos = GetHeroSelectorPos();
			player p = GetHeroSelectorPlayer();
			toastHint.createAtMouse(p, "[HSelect] 玩家 " + GetPlayerName(p) + " 点击了按钮2，选择位置: " + I2S(pos));
		}));

		heroData.trHeroCondition = CreateTrigger();
		TriggerAddCondition(heroData.trHeroCondition, Condition(function () -> boolean {
			integer pos = GetHeroConditionPosAsync();
			// pos 取余数为 1 的返回 false
			return ModuloInteger(pos, 2) != 1;
		}));

		heroData.trHeroBtn1String = CreateTrigger();
		TriggerAddCondition(heroData.trHeroBtn1String, Condition(function () -> boolean {
			integer pos = GetHeroConditionPosAsync();
			// 根据位置返回不同的字符串
			CallbackHeroBtn1String("位置" + I2S(pos) + "的描述");
			return true;
		}));

		heroData.trBpEnter = CreateTrigger();
		TriggerAddCondition(heroData.trBpEnter, Condition(function () -> boolean {
			player p = GetLocalPlayer();
			toastHint.createAtMouse(p, "[HSelect] 鼠标进入左下角BP区域");
			return true;
		}));

		heroData.trBpLeave = CreateTrigger();
		TriggerAddCondition(heroData.trBpLeave, Condition(function () -> boolean {
			player p = GetLocalPlayer();
			toastHint.createAtMouse(p, "[HSelect] 鼠标离开左下角BP区域");
			return true;
		}));

	}

	function TTestUTHeroSelector1 (player p) {
		// 测试setBtn1Text方法
		heroSelectorUI.setBtn1Text(p, "测试按钮1文本");
		toastHint.createAtMouse(p, "[HSelect] 已设置按钮1文本为: 测试按钮1文本");
	}
	function TTestUTHeroSelector2 (player p) {}
	function TTestUTHeroSelector3 (player p) {}
	function TTestUTHeroSelector4 (player p) {}
	function TTestUTHeroSelector5 (player p) {}
	function TTestUTHeroSelector6 (player p) {}
	function TTestUTHeroSelector7 (player p) {}
	function TTestUTHeroSelector8 (player p) {}
	function TTestUTHeroSelector9 (player p) {}
	function TTestUTHeroSelector10 (player p) {}
	function TTestActUTHeroSelector1 (string str) {
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
			BJDebugMsg("[HeroSelector] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTHeroSelector1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTHeroSelector1(GetTriggerPlayer());
			else if(str == "s2") TTestUTHeroSelector2(GetTriggerPlayer());
			else if(str == "s3") TTestUTHeroSelector3(GetTriggerPlayer());
			else if(str == "s4") TTestUTHeroSelector4(GetTriggerPlayer());
			else if(str == "s5") TTestUTHeroSelector5(GetTriggerPlayer());
			else if(str == "s6") TTestUTHeroSelector6(GetTriggerPlayer());
			else if(str == "s7") TTestUTHeroSelector7(GetTriggerPlayer());
			else if(str == "s8") TTestUTHeroSelector8(GetTriggerPlayer());
			else if(str == "s9") TTestUTHeroSelector9(GetTriggerPlayer());
			else if(str == "s10") TTestUTHeroSelector10(GetTriggerPlayer());
		});

		// 注册 F3 按键，用于切换英雄选择 UI 的开启/关闭
		keyboard.regKeyDownEvent(KEY_F3, function (){
			player lp;
			lp = GetLocalPlayer();

			if (!heroSelectorUI.isShow()) {
				heroSelectorUI.show(lp);
			} else {
				heroSelectorUI.hide(lp);
			}

			lp = null;
		});
		keyboard.regKeyUpEvent(KEY_F3, null);

	}

}
//! endzinc

#endif
