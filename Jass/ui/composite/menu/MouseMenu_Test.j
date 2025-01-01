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

		BJDebugMsg("|cff00ff00[技能按钮测试]|r 单元测试已加载");
		BJDebugMsg("|cff00ff00[技能按钮测试]|r 可用命令:");
		BJDebugMsg("|cffffcc00s1|r - 切换遮罩显示/隐藏");
		BJDebugMsg("|cffffcc00s2|r - 切换技能按钮显示/隐藏");
		BJDebugMsg("|cffffcc00s3|r - 测试技能按钮高亮效果");
		BJDebugMsg("|cffffcc00s4|r - 显示技能按钮框架信息");

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
	boolean isUpward = true;  // 添加方向控制变量
	boolean isAutoDestroy = true;  // 添加方向控制变量

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

	mouseMenu simpleMenu = 0;
	function TTestUTMouseMenu3 (player p) {  // 测试 SimpleMenuItem
		real x = hardware.getMouseX();
		real y = hardware.getMouseY();
		real menuHeight = 3 * MOUSE_MENU_HEIGHT + 2 * MOUSE_MENU_ITEM_GAP;

		if (!simpleMenu.isExist()) {
			simpleMenu = mouseMenu.createSimple(DzFrameGetParent(spellBtns.grid[3][4]), isUpward, 0.13)
				.setAutoDestroy(isAutoDestroy);
		} else {
			simpleMenu.show(false);
		}

		simpleMenu.onEnter(function(integer index) {
			BJDebugMsg("[Simple菜单-进入] "+I2S(index));
		});
		simpleMenu.onClick(function(integer index) {
			BJDebugMsg("[Simple菜单-点击] "+I2S(index));
		});
		simpleMenu.onLeave(function(integer index) {
			BJDebugMsg("[Simple菜单-离开] "+I2S(index));
		});

		// 添加Simple菜单项
		simpleMenu.AddMenuSimpleItem("Simple菜单项1");
		simpleMenu.AddMenuSimpleItem("Simple菜单项2");
		simpleMenu.AddMenuSimpleItem("Simple菜单项3");

		// 根据方向调整Y坐标
		if (!isUpward) {
			y -= menuHeight;
		}
		simpleMenu.menuFrame.setAbsPoint(ANCHOR_BOTTOMLEFT, x, y);
		simpleMenu.show(true);

		BJDebugMsg("在鼠标位置("+R2S(x)+","+R2S(y)+")创建" + S3(isUpward , "向上" , "向下") + " Simple菜单" + "(自动销毁: " + S3(isAutoDestroy, "开启", "关闭") + ")");
	}
	function TTestUTMouseMenu4 (player p) {
	}
	function TTestUTMouseMenu5 (player p) {}
	function TTestUTMouseMenu6 (player p) {}
	function TTestUTMouseMenu7 (player p) {}
	function TTestUTMouseMenu8 (player p) {}
	function TTestUTMouseMenu9 (player p) {}
	function TTestUTMouseMenu10 (player p) {}
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
		} else if (paramS[0] == "a") {

		} else if (paramS[0] == "b") {

		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[MouseMenu] 单元测试已加载");
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
			real finalY = y;  // 最终的Y坐标
			real menuHeight = 3 * MOUSE_MENU_HEIGHT + 2 * MOUSE_MENU_ITEM_GAP;  // 3个项目的总高度

			// 在右键位置创建菜单
			if (menu.isExist()) {
				menu.destroy();
			}
			menu = mouseMenu.create(DzGetGameUI(), isUpward, 0.13)
				.setAutoDestroy(isAutoDestroy);

			menu.onEnter(function(integer index) {
				BJDebugMsg("[右键菜单-进入] "+I2S(index));
			});
			menu.onClick(function(integer index) {
				BJDebugMsg("[右键菜单-点击] "+I2S(index));
			});
			menu.onLeave(function(integer index) {
				BJDebugMsg("[右键菜单-离开] "+I2S(index));
			});

			menu.AddMenuItem("右键菜单项1");
			menu.AddMenuItem("右键菜单项2");
			menu.AddMenuItem("右键菜单项3");

			// 计算菜单总高度

			// 根据方向调整Y坐标
			if (!isUpward) {
				// 向下生长时，确保顶部坐标加上菜单高度不超过0.8
				y -=  menuHeight;
			}
			menu.menuFrame.setAbsPoint(ANCHOR_BOTTOMLEFT, x, RLimit(y,0.165,y));
			menu.show(true);

			// 显示实际位置信息
			if (finalY != y) {
				BJDebugMsg("菜单Y坐标已调整: " + R2S(y) + " -> " + R2S(finalY));
			}
			BJDebugMsg("在位置("+R2S(x)+","+R2S(finalY)+")创建" +
			S3(isUpward , "向上" , "向下") + "菜单");
		});

	}

}
//! endzinc

#endif
