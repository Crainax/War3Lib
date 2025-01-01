#ifndef UTMouseMenuIncluded
#define UTMouseMenuIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTMouseMenu requires MouseMenu {

	function Init () {
		unit hero,building;
		real x = 0, y = 0;
		integer i = 0;

		BJDebugMsg("|cff00ff00[菜单测试]|r 单元测试已加载");

		// 为玩家1创建测试英雄
		hero = CreateUnit(Player(0), 'Hamg', 0, 0, 270); // 创建大法师在坐标(0,0)
		SetHeroLevel(hero, 10,true);

		// 创建一个建筑单位用于测试12个技能
		building = CreateUnit(Player(0), 'hcas', 400, 0, 270); // 创建人族城堡

		// 为建筑添加12个技能
		UnitAddAbility(building, 'AHbz'); // 暴风雪
		UnitAddAbility(building, 'AHwe'); // 水元素
		UnitAddAbility(building, 'AHab'); // 闪现
		UnitAddAbility(building, 'AHmt'); // 群体传送
		UnitAddAbility(building, 'AHfs'); // 烈焰风暴
		UnitAddAbility(building, 'AHbn'); // 驱逐魔法
		UnitAddAbility(building, 'AHdr'); // 吸取魔法
		UnitAddAbility(building, 'AHpx'); // 凤凰
		UnitAddAbility(building, 'AHad'); // 奥术光环
		UnitAddAbility(building, 'AHav'); // 化身
		UnitAddAbility(building, 'AHcs'); // 寒冰护甲
		UnitAddAbility(building, 'AHfa'); // 烈焰护甲

		// 添加8个预选的技能
		UnitAddAbility(hero, 'ACbc'); // 火焰呼吸
		UnitAddAbility(hero, 'ACbf'); // 霜冻闪电
		UnitAddAbility(hero, 'ACpy'); // 变形术
		UnitAddAbility(hero, 'AOhx'); // 妖术
		UnitAddAbility(hero, 'ACdv'); // 吞噬
		UnitAddAbility(hero, 'ACen'); // 诱捕
		UnitAddAbility(hero, 'ANr3'); // 混乱之雨
		UnitAddAbility(hero, 'AOhw'); // 医疗波

		// 在英雄周围随机放置物品
		CreateItem('rag1', -200, 100); // 敏捷便鞋 +3
		CreateItem('ram1', -100, 100); // 大魔法师指环
		CreateItem('ram2', 0, 100);    // 大魔法师指环 +2
		CreateItem('sor2', 100, 100);  // 影子之球 +2
		CreateItem('sor3', 200, 100);  // 影子之球 +3

		CreateItem('sreg', -200, -100); // 恢复卷轴
		CreateItem('spsh', -100, -100); // 魔法护盾护身符
		CreateItem('srbd', 0, -100);    // 灼热之刀
		CreateItem('thdm', 100, -100);  // 雷霆蜥蜴钻石
		CreateItem('tin2', 200, -100);  // 智力之书 +2

		// 放置一些特殊物品
		CreateItem('dkfw', -150, 0);    // 雷霆水桶(自动使用型)
		CreateItem('dphe', 150, 0);     // 雷霆凤凰蛋(自动使用型)
		CreateItem('thle', 0, 150);     // 雷霆蜥蜴之蛋(自动使用型)
	}

	mouseMenu menu = 0;
	mouseMenu spellMenu = 0;
	mouseMenu itemMenu = 0;
	boolean isUpward = true;
	boolean isAutoDestroy = true;
	integer currentMenuType = 0;  // 0: 普通菜单, 1: 技能菜单, 2: 物品菜单
	integer menuItemCount = 3;    // 默认菜单项数量

	function TTestUTMouseMenu1 (player p) {  // 测试菜单方向切换
		isUpward = !isUpward;  // 切换方向
		if (isUpward) {
			BJDebugMsg("当前方向: 向上");
		} else {
			BJDebugMsg("当前方向: 向下");
		}
	}
	function TTestUTMouseMenu2 (player p) {  // 测试自动销毁切换
		isAutoDestroy = !isAutoDestroy;
		if (isAutoDestroy) {
			BJDebugMsg("当前自动销毁: 开启");
		} else {
			BJDebugMsg("当前自动销毁: 关闭");
		}
	}
	function TTestUTMouseMenu3 (player p) {
	}
	function TTestUTMouseMenu4 (player p) {
	}
	function TTestUTMouseMenu5 (player p) {
	}
	function TTestUTMouseMenu6 (player p) {
	}
	function TTestUTMouseMenu7 (player p) {
	}
	function TTestUTMouseMenu8 (player p) {
	}
	function TTestUTMouseMenu9 (player p) {
	}
	function TTestUTMouseMenu10 (player p) {
	}

	function TTestActUTMouseMenu1 (string str) {
		player  p     = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,    num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];                              //所有参数S
		integer paramI [];                              //所有参数I
		real    paramR [];                             //所有参数R
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

		if (paramS[0] == "destroy") {
			if (menu.isExist()) {
				menu.destroy();
				menu = 0;
				BJDebugMsg("菜单已销毁");
			} else {
				BJDebugMsg("菜单不存在");
			}
		} else if (paramS[0] == "autodestroy") {
			if (menu.isExist()) {
				menu.setAutoDestroy(!menu.autoDestroy);
				BJDebugMsg("菜单自动销毁已" + S3(menu.autoDestroy , "开启" , "关闭"));
			} else {
				BJDebugMsg("菜单不存在");
			}
		} else if (paramS[0] == "count") {
			if (num > 1) {
				paramI[1] = ILimit(paramI[1], 1, MOUSE_MENU_MAX_ITEMS);
				if (paramI[1] != menuItemCount) {
					menuItemCount = paramI[1];
					BJDebugMsg("菜单项数量已设置为: " + I2S(menuItemCount));
				}
			} else {
				BJDebugMsg("当前菜单项数量: " + I2S(menuItemCount));
			}
		} else if (paramS[0] == "a") {

		} else if (paramS[0] == "b") {

		}

		p = null;
	}

	function createNormalMenu(real x, real y) -> mouseMenu {
		integer i = 1;
		if (menu.isExist()) {
			menu.destroy();
		}
		menu = mouseMenu.create(DzGetGameUI(), isUpward, 0.13)
			.setAutoDestroy(isAutoDestroy);

		menu.onEnter(function(integer index) {
			BJDebugMsg("[普通菜单-进入] "+I2S(index));
		});
		menu.onClick(function(integer index) {
			BJDebugMsg("[普通菜单-点击] "+I2S(index));
		});
		menu.onLeave(function(integer index) {
			BJDebugMsg("[普通菜单-离开] "+I2S(index));
		});
		menu.listenDestroy(function(integer index) {
			BJDebugMsg("监控到删除事件");
			menu = 0;
		});

		// 根据menuItemCount创建菜单项
		while (i <= menuItemCount) {
			menu.AddMenuItem("普通菜单项" + I2S(i));
			i += 1;
		}

		return menu;
	}

	function createSpellMenu(real x, real y) -> mouseMenu {
		integer i = 1;
		if (!spellMenu.isExist()) {
				spellMenu = mouseMenu.createSimple(DzFrameGetParent(spellBtns.grid[3][4]), isUpward, 0.13)
					.setAutoDestroy(isAutoDestroy);

				spellMenu.onEnter(function(integer index) {
					BJDebugMsg("[技能菜单-进入] "+I2S(index));
				});
				spellMenu.onClick(function(integer index) {
					BJDebugMsg("[技能菜单-点击] "+I2S(index));
				});
				spellMenu.onLeave(function(integer index) {
					BJDebugMsg("[技能菜单-离开] "+I2S(index));
				});
		} else {
			spellMenu.show(false);
		}

		BJDebugMsg("技能菜单已创建");
		// 根据menuItemCount创建菜单项
		while (i <= menuItemCount) {
			spellMenu.AddMenuSimpleItem("技能菜单项" + I2S(i));
			i += 1;
		}

		return spellMenu;
	}

	function createItemMenu(real x, real y) -> mouseMenu {
		integer i = 1;
		if (!itemMenu.isExist()) {
			itemMenu = mouseMenu.createSimple(itemBtns.slot[1], isUpward, 0.13)
				.setAutoDestroy(isAutoDestroy);

			itemMenu.onEnter(function(integer index) {
				BJDebugMsg("[物品菜单-进入] "+I2S(index));
			});
			itemMenu.onClick(function(integer index) {
				BJDebugMsg("[物品菜单-点击] "+I2S(index));
			});
			itemMenu.onLeave(function(integer index) {
				BJDebugMsg("[物品菜单-离开] "+I2S(index));
			});

		} else {
			itemMenu.show(false);
		}

		BJDebugMsg("物品菜单已创建");
		// 根据menuItemCount创建菜单项
		while (i <= menuItemCount) {
			itemMenu.AddMenuSimpleItem("物品菜单项" + I2S(i));
			i += 1;
		}

		return itemMenu;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("|cff00ff00[MouseMenu]|r 单元测试已加载");
			BJDebugMsg("|cff00ff00[MouseMenu]|r 可用命令:");
			BJDebugMsg("|cffffcc00s1|r - 切换菜单方向（当前: " + S3(isUpward, "向上", "向下") + "）");
			BJDebugMsg("|cffffcc00s2|r - 切换自动销毁（当前: " + S3(isAutoDestroy, "开启", "关闭") + "）");
			BJDebugMsg("|cffffcc00-destroy|r - 销毁当前菜单");
			BJDebugMsg("|cffffcc00-autodestroy|r - 切换自动销毁状态");
			BJDebugMsg("|cffffcc00-count x|r - 设置菜单项数量(1-20)，当前: " + I2S(menuItemCount));
			BJDebugMsg("|cffffcc00Tab键|r - 切换菜单类型（普通/技能/物品）");
			BJDebugMsg("右键点击 - 在鼠标位置创建菜单");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTMouseMenu1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTMouseMenu1(GetTriggerPlayer());
			else if(str == "s2") TTestUTMouseMenu2(GetTriggerPlayer());
			else if(str == "s3") TTestUTMouseMenu3(GetTriggerPlayer());
			else if(str == "s4") TTestUTMouseMenu4(GetTriggerPlayer());
			else if(str == "s5") TTestUTMouseMenu5(GetTriggerPlayer());
			else if(str == "s6") TTestUTMouseMenu6(GetTriggerPlayer());
			else if(str == "s7") TTestUTMouseMenu7(GetTriggerPlayer());
			else if(str == "s8") TTestUTMouseMenu8(GetTriggerPlayer());
			else if(str == "s9") TTestUTMouseMenu9(GetTriggerPlayer());
			else if(str == "s10") TTestUTMouseMenu10(GetTriggerPlayer());
		});

		hardware.regRightUpEvent(function() {
			real x = hardware.getMouseX();
			real y = hardware.getMouseY();
			real menuHeight = 3 * MOUSE_MENU_HEIGHT + 2 * MOUSE_MENU_ITEM_GAP;
			mouseMenu currentMenu = 0;

			// 根据当前菜单类型创建对应菜单
			if (currentMenuType == 0) {
				// 普通菜单
				if (!isUpward) {
					y -= menuHeight;
				}
				currentMenu = createNormalMenu(x, y);
				// 普通菜单使用 0.165 作为下限
				currentMenu.menuFrame.setAbsPoint(ANCHOR_BOTTOMLEFT, x, RLimit(y,0.165,y));
			} else {
				// Simple菜单（技能/物品）
				if (currentMenuType == 1) {
					currentMenu = createSpellMenu(x, y);
				} else {
					currentMenu = createItemMenu(x, y);
				}
				// Simple菜单使用原始坐标
				currentMenu.menuFrame.setAbsPoint(ANCHOR_BOTTOMLEFT, x, y);
			}

			currentMenu.show(true);

			BJDebugMsg("在位置("+R2S(x)+","+R2S(y)+")创建" +
			S3(currentMenuType == 0, "普通", S3(currentMenuType == 1, "技能", "物品")) +
			"菜单 (" + S3(isUpward, "向上", "向下") +
			", 自动销毁: " + S3(isAutoDestroy, "开启", "关闭") + ")");
		});

		keyboard.regKeyUpEvent(9, function() { // tab键切换菜单类型
			currentMenuType = ModuloInteger(currentMenuType + 1, 3);
			BJDebugMsg("当前菜单类型: " +
			S3(currentMenuType == 0, "普通菜单",
			S3(currentMenuType == 1, "技能菜单", "物品菜单")));
		});
		keyboard.regKeyDownEvent(9, null);
	}

}
//! endzinc

#endif
