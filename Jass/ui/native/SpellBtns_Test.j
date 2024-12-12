#ifndef UTSpellBtnsIncluded
#define UTSpellBtnsIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
* SpellBtns_Test.j
* ===========================================================================
* 技能按钮单元测试模块
* ---------------------------------------------------------------------------
* 功能:
*   - 测试技能按钮的创建和显示
*   - 测试技能按钮的事件响应
*   - 测试技能按钮的遮罩效果
* ---------------------------------------------------------------------------
* 测试命令:
*   s1: 测试技能按钮遮罩
*   s2: 切换遮罩显示/隐藏
*   s3: 测试创建原生按钮
*   s4: 显示技能按钮框架信息
* ===========================================================================
*/

//自动生成的文件
library UTSpellBtns requires SpellBtns {


	uiBtn shade = 0;
	uiImage shadeImg = 0;
	boolean shadeVisible = false;
	function TTestUTSpellBtns1 (player p) { //试试simpleButton能不能用,能用是能用
		shadeImg = uiImage.create(DzGetGameUI())
			.setSize(0.2,0.2)
			.setPoint(ANCHOR_TOPLEFT, spellBtns.grid[1][1], ANCHOR_TOPLEFT, 0.0, 0.0)
			.setPoint(ANCHOR_BOTTOMRIGHT, spellBtns.grid[3][4], ANCHOR_BOTTOMRIGHT, 0.0, 0.0)
			.setTexture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp")
			.show(true);
		shade = uiBtn.createSimple(DzFrameGetParent(spellBtns.grid[3][4])) //这样也没用,全都挡不住,但是全能hover
			// .clearPoint() 这条好像不能写  写了子的位置就不准了
			.setSize(0.2,0.2)
			.setPoint(ANCHOR_CENTER, spellBtns.grid[3][4], ANCHOR_CENTER, 0.0, 0.0)
			.onMouseEnter(function() {integer frame = DzGetTriggerUIEventFrame();integer data = uiHashTable(frame).eventdata.get();BJDebugMsg("enter"); })
			.onMouseLeave(function() {integer frame = DzGetTriggerUIEventFrame();integer data = uiHashTable(frame).eventdata.get();BJDebugMsg("leave"); })
			.onMouseClick(function() {integer frame = DzGetTriggerUIEventFrame();integer data = uiHashTable(frame).eventdata.get();BJDebugMsg("click"); })
			.show(false); //不弄这条的话隐藏再显示好像会有问题
		uiHashTable(shade.ui).eventdata.bind(8174);
		shadeVisible = true;
		// DzFrameSetParent(btn.ui, spellBtns.grid[3][4]);
		SetPlayerAbilityAvailable(p,'AHbz',false); //随便用一个技能也可以
		SetPlayerAbilityAvailable(p,'AHbz',true);
		BJDebugMsg("测试了一下遮挡SpellBtns的按钮");
	}
	function TTestUTSpellBtns2 (player p) {
		if (shade != 0) {
			if (shadeVisible) {
				shade.show(true);
				shadeImg.show(false);
				shadeVisible = false;
				BJDebugMsg("隐藏遮罩");
			} else {
				shade.show(false);
				shadeImg.show(true);
				shadeVisible = true;
				BJDebugMsg("显示遮罩");
			}
		}
		SetPlayerAbilityAvailable(p,'AHbz',false);
		SetPlayerAbilityAvailable(p,'AHbz',true);
	}
	function TTestUTSpellBtns3 (player p) { //尝试创建一下带反馈的按钮,实际行不通(从)
		// uiBtn btnAttack;
		// integer parent = DzSimpleFrameFindByName("SimpleInfoPanelIconDamage", 0); //攻击的父框架
		// integer child = DzCreateFrameByTagName("SIMPLEFRAME", "upAttack", parent, "TestButtonBarFrame", 0);
		// DzFrameClearAllPoints( child ); //这条必不可少,不然会杂糅在一起
		// btnAttack = uiBtn.bindSimple("TestButtonBarQuestsButton", 0)
		// 	.setSize(0.027, 0.027)
		// 	.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0, 0);
		// BJDebugMsg("创建了一个原生按钮");
	}
	function TTestUTSpellBtns4 (player p) {
		integer i,j;
		for (1 <= i <= 3) {
			for (1 <= j <= 4) {
				BJDebugMsg("原生第" + I2S(i) + "行,第" + I2S(j) + "列:" + I2S(DzFrameGetCommandBarButton(i-1,j-1)));
				BJDebugMsg("CD第" + I2S(i) + "行,第" + I2S(j) + "列:" + I2S(DzFrameGetCommandBarButtonAutoCastIndicator (DzFrameGetCommandBarButton(i-1,j-1))));
				BJDebugMsg("扩展第" + I2S(i) + "行,第" + I2S(j) + "列:" + I2S(spellBtns.grid[i][j]));
			}
		}
	}
	uiBtn shade2 = 0;
	uiImage shadeImg2 = 0;
	function TTestUTSpellBtns5 (player p) { //给原生遮罩里再创个按钮
		if (shade.isExist()) {
			shade2 = uiBtn.createSimple(shade.ui) //这样也没用,全都挡不住,但是全能hover
				.clearPoint()
				.setSize(0.035,0.035)
				.setPoint(ANCHOR_CENTER, shade.ui, ANCHOR_CENTER, 0.0, 0.0)
				.onMouseEnter(function() {integer frame = DzGetTriggerUIEventFrame();integer data = uiHashTable(frame).eventdata.get();BJDebugMsg("小enter"); })
				.onMouseLeave(function() {integer frame = DzGetTriggerUIEventFrame();integer data = uiHashTable(frame).eventdata.get();BJDebugMsg("小leave"); })
				.onMouseClick(function() {integer frame = DzGetTriggerUIEventFrame();integer data = uiHashTable(frame).eventdata.get();BJDebugMsg("小click"); });
			shadeImg2 = uiImage.create(DzGetGameUI())
				.setSize(0.03,0.035)
				.setAllPoint(shade2.ui)
				.setTexture("ReplaceableTextures\\CommandButtons\\BTNRepairOn.blp");
			BJDebugMsg("创建了一个子按钮");
		}
	}
	function TTestUTSpellBtns6 (player p) {}
	function TTestUTSpellBtns7 (player p) {}
	function TTestUTSpellBtns8 (player p) {}
	function TTestUTSpellBtns9 (player p) {}
	function TTestUTSpellBtns10 (player p) {}
	function TTestActUTSpellBtns1 (string str) {
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
			unit hero,building;
			real x = 0, y = 0;
			integer i = 0;

			BJDebugMsg("|cff00ff00[SpellBtns测试]|r 单元测试已加载");
			BJDebugMsg("|cff00ff00[SpellBtns测试]|r 可用命令:");
			BJDebugMsg("|cffffcc00s1|r - 测试技能按钮遮罩");
			BJDebugMsg("|cffffcc00s2|r - 切换遮罩显示/隐藏");
			BJDebugMsg("|cffffcc00s3|r - 测试创建原生按钮");
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

			spellBtns.onEnter(function () {
				integer row = spellBtns.argsRow;
				integer column = spellBtns.argsCol;
				BJDebugMsg("第" + I2S(row) + "行,第" + I2S(column) + "列的技能进入:" + I2S(spellBtns.grid[row][column]));
				// BJDebugMsg("触发的UI:" + I2S(DzGetTriggerUIEventFrame()) + " 数据:" + I2S(uiHashTable(DzGetTriggerUIEventFrame()).eventdata.get()));
			});
			spellBtns.onLeave(function () {
				integer row = spellBtns.argsRow;
				integer column = spellBtns.argsCol;
				BJDebugMsg("第" + I2S(row) + "行,第" + I2S(column) + "列的技能离开");
			});
			spellBtns.onClick(function () {
				integer row = spellBtns.argsRow;
				integer column = spellBtns.argsCol;
				BJDebugMsg("第" + I2S(row) + "行,第" + I2S(column) + "列的技能点击");
			});
			spellBtns.onRightClick(function () {
				integer row = spellBtns.argsRow;
				integer column = spellBtns.argsCol;
				BJDebugMsg("第" + I2S(row) + "行,第" + I2S(column) + "列的技能右键点击");
			});

			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTSpellBtns1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTSpellBtns1(GetTriggerPlayer());
			else if(str == "s2") TTestUTSpellBtns2(GetTriggerPlayer());
			else if(str == "s3") TTestUTSpellBtns3(GetTriggerPlayer());
			else if(str == "s4") TTestUTSpellBtns4(GetTriggerPlayer());
			else if(str == "s5") TTestUTSpellBtns5(GetTriggerPlayer());
			else if(str == "s6") TTestUTSpellBtns6(GetTriggerPlayer());
			else if(str == "s7") TTestUTSpellBtns7(GetTriggerPlayer());
			else if(str == "s8") TTestUTSpellBtns8(GetTriggerPlayer());
			else if(str == "s9") TTestUTSpellBtns9(GetTriggerPlayer());
			else if(str == "s10") TTestUTSpellBtns10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
