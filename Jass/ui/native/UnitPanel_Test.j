//===========================================================================
// UnitPanel_Test.j
//===========================================================================
// 文件描述：单位面板测试模块
// 创建日期：未知
// 修改记录：
//   - 实现了单位属性面板的测试功能
//   - 包含攻击、护甲等属性的显示和交互
//
// 主要功能：
//   - 创建并测试单位属性面板UI
//   - 提供属性图标和数值显示
//   - 实现鼠标悬停和点击事件
//   - 包含单元测试用例
//===========================================================================

#ifndef UTUnitPanelIncluded
#define UTUnitPanelIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "Crainax/ui/constants/UIConstants.j" // UI常量

//# dependency:resource/ui/console/unitpanel/yidu_str.blp
//# dependency:resource/ui/console/unitpanel/yidu_agi.blp
//# dependency:resource/ui/console/unitpanel/yidu_int.blp
//# dependency:resource/ui/console/unitpanel/yidu_Atk.blp
//# dependency:resource/ui/console/unitpanel/yidu_Def.blp
//! zinc

//自动生成的文件
library UTUnitPanel requires UnitPanel, UnitTestUIRuler, UIButton, UIImage, UIText, Hardware {
	uiImage testBtnRelCheck = 0;
	uiText testBtnRelText = 0;
	uiBtn testBtnRelBtn = 0;
	uiImage testBtnAbsCheck = 0;
	uiText testBtnAbsText = 0;
	uiBtn testBtnAbsBtn = 0;
	boolean testBtnInited = false;
	real testBtnAbsX = 0.335;
	real testBtnAbsY = 0.125;
	real testBtnAbsW = 0.125;
	real testBtnAbsH = 0.022;

	function UnitPanelTestMoveRelHidden(boolean hard) {
		if (testBtnRelCheck != 0 && testBtnRelCheck.ui != 0) {
			testBtnRelCheck.clearPoint().setAbsPoint(ANCHOR_BOTTOMLEFT, -1.0, 0.0);
		}
		if (testBtnRelText != 0 && testBtnRelText.ui != 0) {
			testBtnRelText.clearPoint().setAbsPoint(ANCHOR_BOTTOMLEFT, -1.0, 0.0);
		}
		if (testBtnRelBtn != 0 && testBtnRelBtn.ui != 0) {
			if (hard) { testBtnRelBtn.setSize(0.001, 0.001); }
			testBtnRelBtn.clearPoint().setAbsPoint(ANCHOR_BOTTOMLEFT, -1.0, 0.0);
		}
	}

	function UnitPanelTestMoveAbsHidden(boolean hard) {
		if (testBtnAbsCheck != 0 && testBtnAbsCheck.ui != 0) {
			testBtnAbsCheck.clearPoint().setAbsPoint(ANCHOR_BOTTOMLEFT, -1.0, 0.0);
		}
		if (testBtnAbsText != 0 && testBtnAbsText.ui != 0) {
			testBtnAbsText.clearPoint().setAbsPoint(ANCHOR_BOTTOMLEFT, -1.0, 0.0);
		}
		if (testBtnAbsBtn != 0 && testBtnAbsBtn.ui != 0) {
			if (hard) { testBtnAbsBtn.setSize(0.001, 0.001); }
			testBtnAbsBtn.clearPoint().setAbsPoint(ANCHOR_BOTTOMLEFT, -1.0, 0.0);
		}
	}

	function UnitPanelTestEnsureMoveButtons() {
		integer parent;
		if (testBtnInited) { return; }
		parent = DzSimpleFrameFindByName("SimpleInfoPanelIconArmor", 2);
		if (parent == 0) {
			BJDebugMsg("[UPBtn] parent SimpleInfoPanelIconArmor#2 not found");
			return;
		}

		testBtnRelCheck = uiImage.createSimple(parent)
			.setSize(0.018, 0.018)
			.setTexture("UI\\Widgets\\Glues\\GlueScreen-Checkbox-Background.blp");
		if (testBtnRelCheck == 0 || testBtnRelCheck.ui == 0) { return; }
		testBtnRelText = uiText.createSimple(parent)
			.setAlign(3)
			.setFontSize(4)
			.setText("REL");
		if (testBtnRelText == 0 || testBtnRelText.ui == 0) { return; }
		testBtnRelBtn = uiBtn.createSimple(parent)
			.onEnter(function () { BJDebugMsg("[UPBtn] REL enter"); })
			.onLeave(function () { BJDebugMsg("[UPBtn] REL leave"); })
			.onClick(function () { BJDebugMsg("[UPBtn] REL click"); });
		if (testBtnRelBtn == 0 || testBtnRelBtn.ui == 0) { return; }

		testBtnAbsCheck = uiImage.createSimple(parent)
			.setSize(0.018, 0.018)
			.setTexture("UI\\Widgets\\Glues\\GlueScreen-Checkbox-Background.blp");
		if (testBtnAbsCheck == 0 || testBtnAbsCheck.ui == 0) { return; }
		testBtnAbsText = uiText.createSimple(parent)
			.setAlign(3)
			.setFontSize(4)
			.setText("ABS");
		if (testBtnAbsText == 0 || testBtnAbsText.ui == 0) { return; }
		testBtnAbsBtn = uiBtn.createSimple(parent)
			.onEnter(function () { BJDebugMsg("[UPBtn] ABS enter"); })
			.onLeave(function () { BJDebugMsg("[UPBtn] ABS leave"); })
			.onClick(function () { BJDebugMsg("[UPBtn] ABS click"); });
		if (testBtnAbsBtn == 0 || testBtnAbsBtn.ui == 0) { return; }

		testBtnInited = true;
		UnitPanelTestMoveRelHidden(true);
		UnitPanelTestMoveAbsHidden(true);
	}

	function UnitPanelTestShowRel() {
		UnitPanelTestEnsureMoveButtons();
		if (!testBtnInited) { return; }
		UnitPanelTestMoveAbsHidden(true);
		testBtnRelCheck
			.clearPoint()
			.setPoint(ANCHOR_CENTER, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.116, -0.012);
		testBtnRelText
			.clearPoint()
			.setPoint(ANCHOR_LEFT, testBtnRelCheck.ui, ANCHOR_RIGHT, 0.0035, 0.0);
		testBtnRelBtn
			.clearPoint()
			.setPoint(ANCHOR_TOPLEFT, testBtnRelCheck.ui, ANCHOR_TOPLEFT, 0.0, 0.001)
			.setPoint(ANCHOR_BOTTOMRIGHT, testBtnRelText.ui, ANCHOR_BOTTOMRIGHT, 0.002, -0.001);
		BJDebugMsg("[UPBtn] REL shown: two relative anchors to simple image/text");
	}

	function UnitPanelTestShowAbs(real x, real y) {
		UnitPanelTestEnsureMoveButtons();
		if (!testBtnInited) { return; }
		testBtnAbsX = x;
		testBtnAbsY = y;
		UnitPanelTestMoveRelHidden(true);
		testBtnAbsCheck
			.clearPoint()
			.setAbsPoint(ANCHOR_CENTER, x - testBtnAbsW * 0.5 + 0.010, y);
		testBtnAbsText
			.clearPoint()
			.setAbsPoint(ANCHOR_LEFT, x - testBtnAbsW * 0.5 + 0.024, y);
		testBtnAbsBtn
			.setSize(testBtnAbsW, testBtnAbsH)
			.clearPoint()
			.setAbsPoint(ANCHOR_CENTER, x, y);
		BJDebugMsg("[UPBtn] ABS shown: size + absolute point x=" + R2SW(x, 1, 3) + " y=" + R2SW(y, 1, 3));
	}

	public function Init2 () {
		#ifdef UnitPanelShowBuilding
		unitPanel.registerBuilding(); //注册建筑单位的单位面板刷新机制
		#endif

		#ifdef UnitPanelShowMonster
		unitSelect.onAsync(function () {
			if (GetUnitTypeId(unitSelect.args) == 'hsor' || GetUnitTypeId(unitSelect.args) == 'hmpr') {
				unitPanel.iconMonster.show(true);
			}
		});
		unitSelect.onAsyncUn(function () {
			if (GetUnitTypeId(unitSelect.args) == 'hsor' || GetUnitTypeId(unitSelect.args) == 'hmpr') {
				unitPanel.iconMonster.show(false);
			}
		});
		#endif
	}

	integer testCount = 0;
	// 初始化测试内容
	function Init () {
		#define testInit2(name,evt) unitPanel.on/**/name/**/evt(function () {BJDebugMsg(#name + " " + #evt);});

		#define testInit2In(name) \
		testInit2(name,Enter) CRNL \
		testInit2(name,Leave) CRNL \
		testInit2(name,Click) CRNL \
		testInit2(name,RightClick) CRNL

		testInit2In(Attack)
		testInit2In(Armor)
		testInit2In(Hero)
		#ifdef UnitPanelShowBuilding
		testInit2In(Building)
		#endif
		#ifdef UnitPanelShowMonster
		testInit2In(Monster)
		#endif

		Init2();

		unitPanel.onAttackEnter(function () {
			testCount = testCount + 1;
			unitPanel.textAttackExtra.setText("|cff00ff00+" + FormatNumber(testCount*1230432.) + "|r");
			unitPanel.showAttackExtra(true);
		});
		unitPanel.onAttackLeave(function () {
			unitPanel.showAttackExtra(false);
		});
		unitPanel.onArmorEnter(function () {
			testCount = testCount + 1;
			unitPanel.textArmorExtra.setText("|cffff0000-" + FormatNumber(testCount*123043242.) + "|r");
			unitPanel.showArmorExtra(true);
		});
		unitPanel.onArmorLeave(function () {
			unitPanel.showArmorExtra(false);
		});
		unitPanel.onHeroEnter(function () {
			testCount = testCount + 1;
			unitPanel.textStrExtra.setText("|cff00ff00+" + FormatNumber(testCount * 300000000.) + "|r");
			unitPanel.textAgiExtra.setText("|cff00ff00+" + FormatNumber(testCount * 500000000.) + "|r");
			unitPanel.textIntExtra.setText("|cff00ff00+" + FormatNumber(testCount * 6700000000.) + "|r");
			unitPanel.showStrExtra(true);
			unitPanel.showAgiExtra(true);
			unitPanel.showIntExtra(true);
		});
		unitPanel.onHeroLeave(function () {
			unitPanel.showStrExtra(false);
			unitPanel.showAgiExtra(false);
			unitPanel.showIntExtra(false);
		});
	}
	function TTestUTUnitPanel1 (player p) { //给两个图标加一下grow看看效果
		unitPanel.iconAttack.grow(growdata[ICONGROW_14]);
		unitPanel.iconArmor.grow(growdata[ICONGROW_18]);
	}
	function TTestUTUnitPanel2 (player p) { //移除所有原生UI到屏幕外
		unitPanel.iconAttack.setCornerText("Lv.1");
		unitPanel.iconArmor.setCornerText("1级");
	}
	function TTestUTUnitPanel3 (player p) {
		unitPanel.iconAttack.startCooldown(3.0,0);
		unitPanel.iconArmor.startCooldown(5.0,0);
	}
	function TTestUTUnitPanel4 (player p) {
		unitPanel.iconArmor.startCooldown(0,0);
	}
	function TTestUTUnitPanel5 (player p) {
		#ifdef UnitPanelShowBuilding
		unitPanel.moveOutBuilding();
		#endif
		#ifdef UnitPanelShowMonster
		unitPanel.moveOutMonster();
		#endif
		BJDebugMsg("移走");
	}
	function TTestUTUnitPanel6 (player p) {
		integer portrait; integer hpUI; integer mpUI;

		// 获取大头像句柄
		portrait = DzFrameGetPortrait();
		if (portrait == 0) {
			BJDebugMsg("[UnitPanel] 无法获取大头像句柄");
			return;
		}

		// 通过内存偏移获取生命值UI和魔法值UI
		hpUI = DzFrameGetAlpha(DzFrameGetPortrait() + 0x194);
		mpUI = DzFrameGetAlpha(DzFrameGetPortrait() + 0x198);

		// 将生命值UI移出屏幕外
		DzFrameSetSize(hpUI, 0.02, 0.02);
		DzFrameClearAllPoints(hpUI);
		DzFrameSetPoint(hpUI, 4, DzGetGameUI(), 4, 0.80, -0.60);

		// 将魔法值UI移出屏幕外
		DzFrameSetSize(mpUI, 0.02, 0.02);
		DzFrameClearAllPoints(mpUI);
		DzFrameSetPoint(mpUI, 4, DzGetGameUI(), 4, 0.80, -0.60);

		BJDebugMsg("[UnitPanel] 已将原生生命值和魔法值UI移出屏幕外");
	}
	function TTestUTUnitPanel7 (player p) {
		unitPanel.initHPMPUI();
	}
	function TTestUTUnitPanel8 (player p) {}
	function TTestUTUnitPanel9 (player p) {}
	function TTestUTUnitPanel10 (player p) {}
	function TTestActUTUnitPanel1 (string str) {
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

		} else if (paramS[0] == "ub") {
			if (num <= 1 || paramS[1] == "help") {
				BJDebugMsg("[UPBtn] -ub rel | -ub abs [x y] | -ub mouse | -ub hide | -ub hard | -ub info");
			} else if (paramS[1] == "rel") {
				UnitPanelTestShowRel();
			} else if (paramS[1] == "abs") {
				if (num >= 4) {
					UnitPanelTestShowAbs(paramR[2], paramR[3]);
				} else {
					UnitPanelTestShowAbs(testBtnAbsX, testBtnAbsY);
				}
			} else if (paramS[1] == "mouse") {
				UnitPanelTestShowAbs(hardware.getMouseX(), hardware.getMouseY());
			} else if (paramS[1] == "hide") {
				UnitPanelTestEnsureMoveButtons();
				UnitPanelTestMoveRelHidden(false);
				UnitPanelTestMoveAbsHidden(false);
				BJDebugMsg("[UPBtn] soft hide: move to absolute offscreen only");
			} else if (paramS[1] == "hard") {
				UnitPanelTestEnsureMoveButtons();
				UnitPanelTestMoveRelHidden(true);
				UnitPanelTestMoveAbsHidden(true);
				BJDebugMsg("[UPBtn] hard hide: set size 0.001 and move offscreen");
			} else if (paramS[1] == "info") {
				BJDebugMsg("[UPBtn] abs x=" + R2SW(testBtnAbsX, 1, 3) + " y=" + R2SW(testBtnAbsY, 1, 3) + " w=" + R2SW(testBtnAbsW, 1, 3) + " h=" + R2SW(testBtnAbsH, 1, 3));
			}
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			unit hero,building,witch1,priest1,witch2,priest2;
			real x = 0, y = 0;
			integer i = 0;

			// 为玩家1创建测试英雄
			hero = CreateUnit(Player(0), 'Hamg', 0, 0, 270); // 创建大法师在坐标(0,0)
			SetHeroLevel(hero, 10,true);

			// 为玩家1创建女巫和牧师
			witch1 = CreateUnit(Player(0), 'hsor', 200, 200, 270);  // 创建女巫
			priest1 = CreateUnit(Player(0), 'hmpr', 200, -200, 270); // 创建牧师

			// 在地图远角创建玩家2的女巫和牧师
			witch2 = CreateUnit(Player(11), 'hsor', 5000, 5000, 270);  // 创建玩家12的女巫
			priest2 = CreateUnit(Player(11), 'hmpr', 5000, -5000, 270); // 创建玩家12的牧师

			// 创建一个建筑单位用于测试12个技能
			building = CreateUnit(Player(0), 'hcas', 400, 0, 270); // 创建人族城堡


			CreateItem('rag1', -300, 200); // 敏捷便鞋

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
			BJDebugMsg("[UnitPanel] 单元测试已加载");

			Init();

			DestroyTrigger(GetTriggeringTrigger());
		}));

		//在游戏开始0.1秒后再调用
		tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.1);
		TriggerAddCondition(tr,Condition(function (){
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitPanel1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitPanel1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitPanel2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitPanel3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitPanel4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitPanel5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitPanel6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitPanel7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitPanel8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitPanel9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitPanel10(GetTriggerPlayer());
		});
		InitTestUIRuler();
	}

}
//! endzinc

#endif
