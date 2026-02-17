#ifndef UTHeroSelectorIncluded
#define UTHeroSelectorIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTHeroSelector requires HeroSelector,Keyboard,SyncBus {

	function Init () {
		integer j; integer i; integer max;

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
		heroData[5].icon = "ReplaceableTextures\\CommandButtons\\BTNFurion.blp";
		heroData[6].icon = "ReplaceableTextures\\CommandButtons\\BTNKeeperGhostBlue.blp";
		heroData[7].icon = "ReplaceableTextures\\CommandButtons\\BTNPriestessOfTheMoon.blp";
		heroData[8].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroWarden.blp";
		heroData[9].icon = "ReplaceableTextures\\CommandButtons\\BTNWarden2.blp";
		heroData[10].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroArchMage.blp";
		heroData[11].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp";
		heroData[12].icon = "ReplaceableTextures\\CommandButtons\\BTNArthas.blp";
		heroData[13].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroBloodElfPrince.blp";
		heroData[14].icon = "ReplaceableTextures\\CommandButtons\\BTNGhostMage.blp";
		heroData[15].icon = "ReplaceableTextures\\CommandButtons\\BTNJaina.blp";
		heroData[16].icon = "ReplaceableTextures\\CommandButtons\\BTNBloodMage2.blp";
		heroData[17].icon = "ReplaceableTextures\\CommandButtons\\BTNGarithos.blp";
		heroData[18].icon = "ReplaceableTextures\\CommandButtons\\BTNHeroMountainKing.blp";
		heroData[19].icon = "ReplaceableTextures\\CommandButtons\\BTNNagaSeaWitch.blp";
		heroData[20].icon = "ReplaceableTextures\\CommandButtons\\BTNReturnGoods.blp";
		heroData[21].icon = "ReplaceableTextures\\PassiveButtons\\PASBTNGnollCommandAura.blp";
		heroData[22].icon = "ReplaceableTextures\\CommandButtons\\BTNAnimateDead.blp";
		heroData[23].icon = "ReplaceableTextures\\PassiveButtons\\PASBTNThorns.blp";
		heroData[24].icon = "ReplaceableTextures\\CommandButtons\\BTNAntiMagicShell.blp";
		heroData[25].icon = "ReplaceableTextures\\PassiveButtons\\PASBTNTrueShot.blp";
		heroData[26].icon = "ReplaceableTextures\\PassiveButtons\\PASBTNDevotion.blp";
		heroData[27].icon = "ReplaceableTextures\\PassiveButtons\\PASBTNBrilliance.blp";
		heroData[28].icon = "ReplaceableTextures\\CommandButtons\\BTNBloodLustOn.blp";
		heroData[29].icon = "ReplaceableTextures\\CommandButtons\\BTNFireForTheCannon.blp";
		heroData[30].icon = "ReplaceableTextures\\CommandButtons\\BTNBreathOfFrost.blp";
		heroData[31].icon = "ReplaceableTextures\\PassiveButtons\\PASBTNBash.blp";
		heroData[32].icon = "ReplaceableTextures\\CommandButtons\\BTNTheBlackArrowOnOff.blp";
		heroData[33].icon = "ReplaceableTextures\\CommandButtons\\BTNBanish.blp";
		heroData[34].icon = "ReplaceableTextures\\CommandButtons\\BTNBlizzard.blp";
		heroData[35].icon = "ReplaceableTextures\\CommandButtons\\BTNCrushingWave.blp";
		heroData[36].icon = "ReplaceableTextures\\CommandButtons\\BTNCarrionSwarm.blp";
		heroData[37].icon = "ReplaceableTextures\\CommandButtons\\BTNFrostBolt.blp";
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
		for (1 <= i <= 37) {
			heroData[i].talentCount = ModuloInteger(i, 6);
			heroData[i].text2 = "力量英雄/近战";
			heroData[i].giftCount = ModuloInteger(i+1, 6);
			heroData[i].skillCount = ModuloInteger(i+2, 6);
			heroData[i].equitCount = ModuloInteger(i+3, 11);
			max = heroData[i].talentCount;
			if (heroData[i].giftCount > max) max = heroData[i].giftCount;
			if (heroData[i].skillCount > max) max = heroData[i].skillCount;
			if (heroData[i].equitCount > max) max = heroData[i].equitCount;
			for (1 <= j <= max) {
				if (j <= heroData[i].talentCount) {
					heroData.talentIcon[i][j]  = heroData[ModuloInteger(i+j-1, 37)+1].icon;
					heroData.talentValue[i][j] = j * 10;
				}
				if (j <= heroData[i].giftCount) {
					heroData.giftIcon[i][j]    = heroData[ModuloInteger(i+j, 37)+1].icon;
					heroData.giftValue[i][j]   = j * 20;
				}
				if (j <= heroData[i].skillCount) {
					heroData.skillIcon[i][j]   = heroData[ModuloInteger(i+j+1, 37)+1].icon;
					heroData.skillValue[i][j]  = j * 30;
				}
				if (j <= heroData[i].equitCount) {
					heroData.equitIcon[i][j]   = heroData[ModuloInteger(i+j+2, 37)+1].icon;
					heroData.equitValue[i][j]  = j * 40;
				}
			}
		}

		heroData.size = 37;

		// 进度条测试数据：随机填充（按玩家 pid=1..MAX_PLAYER_COUNT，英雄 pos=1..heroData.size）
		for (1 <= i <= MAX_PLAYER_COUNT) {
			// 全英雄亲密度（共通，只取玩家索引）
			heroData.progressAllMax[i] = 1000;
			heroData.progressAll[i] = GetRandomInt(0, heroData.progressAllMax[i]);
		}
		for (1 <= i <= heroData.size) {
			for (1 <= j <= MAX_PLAYER_COUNT) {
				// 英雄亲密度（按玩家+英雄）
				if (GetRandomInt(0, 1) == 0) {
					heroData.progressHeroMax[j][i] = 0;
					heroData.progressHero[j][i] = 0;
				} else {
					heroData.progressHeroMax[j][i] = 200;
					heroData.progressHero[j][i] = GetRandomInt(0, heroData.progressHeroMax[j][i]);
				}
			}
		}

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

		heroData.trBottomTextControl = CreateTrigger();
		TriggerAddCondition(heroData.trBottomTextControl, Condition(function () -> boolean {
			integer pos = GetHeroConditionPosAsync();
			// 取余数3 = 1 才隐藏（即返回false），否则显示
			boolean show = ModuloInteger(pos, 3) != 1;
			// 显示的内容和pos有关
			if (show) {
				CallbackHeroBtn1String("位置" + I2S(pos) + "的底部文本");
			}
			return show;
		}));

		heroData.trRightEnter = CreateTrigger();
		TriggerAddCondition(heroData.trRightEnter, Condition(function () -> boolean {
			integer hero; integer eventType; integer eventIndex; integer value;
			player p;
			p = GetLocalPlayer();
			hero = heroData.argsHeroIndex;
			eventType = heroData.argsEventType;
			eventIndex = heroData.argsEventIndex;
			if (hero > 0 && hero <= heroData.size && eventIndex > 0) {
				if (eventType == 1) {
					// 天赋技能
					if (eventIndex <= heroData[hero].talentCount) {
						value = heroData.talentValue[hero][eventIndex];
						toastHint.createAtMouse(p, "[HSelect] Enter: 天赋技能 - 英雄" + I2S(hero) + " 索引" + I2S(eventIndex) + " Value=" + I2S(value));
					}
				} else if (eventType == 2) {
					// 赠礼
					if (eventIndex <= heroData[hero].giftCount) {
						value = heroData.giftValue[hero][eventIndex];
						toastHint.createAtMouse(p, "[HSelect] Enter: 赠礼 - 英雄" + I2S(hero) + " 索引" + I2S(eventIndex) + " Value=" + I2S(value));
					}
				} else if (eventType == 3) {
					// 建议的技能
					if (eventIndex <= heroData[hero].skillCount) {
						value = heroData.skillValue[hero][eventIndex];
						toastHint.createAtMouse(p, "[HSelect] Enter: 建议的技能 - 英雄" + I2S(hero) + " 索引" + I2S(eventIndex) + " Value=" + I2S(value));
					}
				} else if (eventType == 4) {
					// 装备
					if (eventIndex <= heroData[hero].equitCount) {
						value = heroData.equitValue[hero][eventIndex];
						toastHint.createAtMouse(p, "[HSelect] Enter: 装备 - 英雄" + I2S(hero) + " 索引" + I2S(eventIndex) + " Value=" + I2S(value));
					}
				}
			}
			p = null;
			return true;
		}));

		heroData.trRightLeave = CreateTrigger();
		TriggerAddCondition(heroData.trRightLeave, Condition(function () -> boolean {
			integer hero; integer eventType; integer eventIndex; integer value;
			player p;
			p = GetLocalPlayer();
			hero = heroData.argsHeroIndex;
			eventType = heroData.argsEventType;
			eventIndex = heroData.argsEventIndex;
			if (hero > 0 && hero <= heroData.size && eventIndex > 0) {
				if (eventType == 1) {
					// 天赋技能
					if (eventIndex <= heroData[hero].talentCount) {
						value = heroData.talentValue[hero][eventIndex];
						toastHint.createAtMouse(p, "[HSelect] Leave: 天赋技能 - 英雄" + I2S(hero) + " 索引" + I2S(eventIndex) + " Value=" + I2S(value));
					}
				} else if (eventType == 2) {
					// 赠礼
					if (eventIndex <= heroData[hero].giftCount) {
						value = heroData.giftValue[hero][eventIndex];
						toastHint.createAtMouse(p, "[HSelect] Leave: 赠礼 - 英雄" + I2S(hero) + " 索引" + I2S(eventIndex) + " Value=" + I2S(value));
					}
				} else if (eventType == 3) {
					// 建议的技能
					if (eventIndex <= heroData[hero].skillCount) {
						value = heroData.skillValue[hero][eventIndex];
						toastHint.createAtMouse(p, "[HSelect] Leave: 建议的技能 - 英雄" + I2S(hero) + " 索引" + I2S(eventIndex) + " Value=" + I2S(value));
					}
				} else if (eventType == 4) {
					// 装备
					if (eventIndex <= heroData[hero].equitCount) {
						value = heroData.equitValue[hero][eventIndex];
						toastHint.createAtMouse(p, "[HSelect] Leave: 装备 - 英雄" + I2S(hero) + " 索引" + I2S(eventIndex) + " Value=" + I2S(value));
					}
				}
			}
			p = null;
			return true;
		}));

	}

	function TTestUTHeroSelector1 (player p) {
		// 测试setBtn1Text方法
		heroSelectorUI.setBtn1Text(p, "选择技能");
		toastHint.createAtMouse(p, "[HSelect] 已设置按钮1文本为: 选择技能");
	}
	function TTestUTHeroSelector2 (player p) {
		// 测试setBtn1Text方法
		heroSelectorUI.setBtn1Text(p, "已选择:\n古道飘雪亦如胧");
		toastHint.createAtMouse(p, "[HSelect] 已设置按钮1文本为");
	}
	function TTestUTHeroSelector3 (player p) {
		toastHint.createAtMouse(p, "[HSelect] 新规则: 打开UI后默认btn1流光");
	}
	function TTestUTHeroSelector4 (player p) {
		toastHint.createAtMouse(p, "[HSelect] 新规则: 首次按btn1会先关闭btn1流光,再发同步");
	}
	function TTestUTHeroSelector5 (player p) {
		toastHint.createAtMouse(p, "[HSelect] 新规则: 选中任意hero icon后,btn2流光(覆盖btn1)");
	}
	function TTestUTHeroSelector6 (player p) {
		toastHint.createAtMouse(p, "[HSelect] 新规则: 流光状态仅内部控制,不再对外开放");
	}
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
		trigger tr = CreateTrigger();

		// 直接在此实现 HSelect 数据接收，不再通过 HeroSelector 内部回调
		syncBus.onDataSync("HSelect", function () -> boolean {
			string str; player p; integer pos;
			str = syncBus.getPayload();
			p = syncBus.getPlayer();
			if (SubStringBJ(str, 1, 1) == "L") {
				toastHint.createAtMouse(p, "[HSelect] 玩家 " + GetPlayerName(p) + " 点击了按钮1（随机选择）");
			} else if (SubStringBJ(str, 1, 1) == "R") {
				pos = S2I(SubStringBJ(str, 2, StringLength(str)));
				toastHint.createAtMouse(p, "[HSelect] 玩家 " + GetPlayerName(p) + " 点击了按钮2，选择位置: " + I2S(pos));
			}
			str = null; p = null;
			return true;
		});

		//在游戏开始0.0秒后再调用
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
