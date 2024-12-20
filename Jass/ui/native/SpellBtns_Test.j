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
*   - 测试技能按钮的遮罩效果
*   - 测试技能按钮的显示/隐藏
*   - 测试技能按钮的高亮效果
*   - 测试技能按钮的框架信息
* ---------------------------------------------------------------------------
* 测试命令:
*   s1: 切换遮罩显示/隐藏
*   s2: 切换技能按钮显示/隐藏
*   s3: 测试技能按钮高亮效果
*   s4: 显示技能按钮框架信息
* ===========================================================================
*/

//自动生成的文件
library UTSpellBtns requires SpellBtns {
	boolean shadeVisible = false;
	function TTestUTSpellBtns1 (player p) { //试试simpleButton能不能用,能用是能用
		integer i;
		shadeVisible = !shadeVisible;
		spellBtns.showShade(shadeVisible);
		BJDebugMsg("测试了一下遮挡SpellBtns的按钮");
	}
	boolean isInside = false;
	function TTestUTSpellBtns2 (player p) {
		integer i,j;
		isInside = !isInside;
		if (isInside) {
			for (1 <= i <= 3) {
				for (1 <= j <= 4) {
					spellBtns.inside(i,j);
				}
			}
			BJDebugMsg("全部物品显示");
		} else {
			for (1 <= i <= 3) {
				for (1 <= j <= 4) {
					spellBtns.outside(i,j);
				}
			}
			BJDebugMsg("全部物品隐藏");
		}
	}
	boolean isGrow = false;
	function TTestUTSpellBtns3 (player p) { //测试流光
		integer i,j;
		isGrow = !isGrow;
		if (isGrow) {
			spellBtns.icons[1][1].grow(growdata[ICONGROW_1]);
			spellBtns.icons[2][1].grow(growdata[ICONGROW_2]);
			spellBtns.icons[3][1].grow(growdata[ICONGROW_3]);
			spellBtns.icons[1][2].grow(growdata[ICONGROW_4]);
			spellBtns.icons[2][2].grow(growdata[ICONGROW_5]);
			spellBtns.icons[3][2].grow(growdata[ICONGROW_6]);
			spellBtns.icons[1][3].grow(growdata[ICONGROW_7]);
			spellBtns.icons[2][3].grow(growdata[ICONGROW_8]);
			spellBtns.icons[3][3].grow(growdata[ICONGROW_9]);
			spellBtns.icons[1][4].grow(growdata[ICONGROW_10]);
			spellBtns.icons[2][4].grow(growdata[ICONGROW_11]);
			spellBtns.icons[3][4].grow(growdata[ICONGROW_12]);
		} else {
			for (1 <= i <= 3) {
				for (1 <= j <= 4) {
					spellBtns.icons[i][j].unGrow();
				}
			}
		}
		BJDebugMsg("测试了一下技能图标的高亮");
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
	function TTestUTSpellBtns5 (player p) { //给原生遮罩里再创个按钮
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

			spellBtns.onEnter(function () {
				integer row = spellBtns.argsRow;
				integer column = spellBtns.argsCol;
				BJDebugMsg("第" + I2S(row) + "行,第" + I2S(column) + "列的技能进入:" + I2S(spellBtns.grid[row][column]));
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

		InitTestUIRuler();

	}

}
//! endzinc

#endif
