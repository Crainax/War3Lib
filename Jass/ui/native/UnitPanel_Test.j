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


//! zinc

//自动生成的文件
library UTUnitPanel requires UnitPanel {


	integer testFrame,testText;
	integer testFrame2,testText2;
	uiBtn btnAttack = 0,btnArmor = 0;
	integer valueAttack, valueArmor;
	integer textAttack, textArmor;
	integer iconAttack, iconArmor;
	function Init () {
		//单位攻击面板（也就是跟随单位攻击1显示） 没有攻击则不显示UI
		integer parent = DzSimpleFrameFindByName("SimpleInfoPanelIconDamage", 0);
		//三围面板（跟随英雄三围面板，有就显示。普通单位则不显示）可以绑定英雄
		// integer parent = DzSimpleFrameFindByName("SimpleInfoPanelIconHero", 6);  //英雄三围框架
		integer child = DzCreateFrameByTagName("SIMPLEFRAME", "kuangjia", parent, "框架", 0);
		// 无响应事件置父
		DzFrameClearAllPoints( child );
		DzFrameSetPoint( child, 4, DzGetGameUI(), 4, 0, 0 );
		// 响应事件置父

		iconAttack = DzSimpleTextureFindByName("攻击图标", 0);
		DzFrameSetSize( iconAttack, 0.02, 0.02 );
		DzFrameSetTexture( iconAttack, "ReplaceableTextures\\CommandButtons\\BTNFrostArmor.blp",0 );
		DzFrameSetPoint( iconAttack, ANCHOR_LEFT, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.015, -0.01 );
		iconArmor = DzSimpleTextureFindByName("护甲图标", 0);
		DzFrameSetSize( iconArmor, 0.02, 0.02 );
		DzFrameSetTexture( iconArmor, "ReplaceableTextures\\CommandButtons\\BTNDarkSummoning.blp",0 );
		DzFrameSetPoint( iconArmor, ANCHOR_TOP, iconAttack, ANCHOR_BOTTOM, 0, -0.005 );

		btnAttack = uiBtn.createSimple(parent)
			.setAllPoint(iconAttack)
			.onMouseEnter(function() {BJDebugMsg("enterAttack"); })
			.onMouseLeave(function() {BJDebugMsg("leaveAttack"); })
			.onMouseClick(function() {BJDebugMsg("clickAttack"); });
		btnArmor = uiBtn.createSimple(parent)
			.setAllPoint(iconArmor)
			.onMouseEnter(function() {BJDebugMsg("enterArmor"); })
			.onMouseLeave(function() {BJDebugMsg("leaveArmor"); })
			.onMouseClick(function() {BJDebugMsg("clickArmor"); });

		//可以通过最后一个参数区分是哪个
		testFrame = DzCreateFrameByTagName("SIMPLEFRAME", "ceshi", child, "testFrame", 0);
		BJDebugMsg("testFrame:" + I2S(testFrame));
		// testText = DzFrameGetChild(testFrame, 0); //获取不到
		testText = DzSimpleFontStringFindByName("ceshinerong", 0);
		BJDebugMsg("testText:" + I2S(testText));
		DzFrameSetText(testText, "上内容");
		DzFrameSetPoint( testText, 0, btnAttack.ui, 2, 0.05, 0.00 );

		testFrame2 = DzCreateFrameByTagName("SIMPLEFRAME", "ceshi", child, "testFrame", 1);
		BJDebugMsg("testFrame2:" + I2S(testFrame2));
		testText2 = DzSimpleFontStringFindByName("ceshinerong", 1);
		BJDebugMsg("testText2:" + I2S(testText2));
		DzFrameSetText(testText2, "下内容");
		DzFrameSetPoint( testText2, 1, testText, 5, 0, -0.005 );


		textAttack = DzSimpleFontStringFindByName("攻击", 0);
		DzFrameClearAllPoints( textAttack );
		DzFrameSetPoint( textAttack, 0, btnAttack.ui, 2, 0, 0.00 );
		DzFrameSetText( textAttack, "攻击:" );
		textArmor = DzSimpleFontStringFindByName("护甲", 0);
		DzFrameClearAllPoints( textArmor );
		DzFrameSetPoint( textArmor, 0, btnArmor.ui, 2, 0, 0.00 );
		DzFrameSetText( textArmor, "防御:" );

		valueAttack = DzSimpleFontStringFindByName("攻击数值", 0);
		DzFrameClearAllPoints( valueAttack );
		DzFrameSetPoint( valueAttack, 3, btnAttack.ui, 5, 0, -0.005 );
		DzFrameSetText( valueAttack, "0" );
		valueArmor = DzSimpleFontStringFindByName("护甲数值", 0);
		DzFrameClearAllPoints( valueArmor );
		DzFrameSetPoint( valueArmor, 3, btnArmor.ui, 5, 0, -0.005 );
		DzFrameSetText( valueArmor, "2000" );

	}
	function TTestUTUnitPanel1 (player p) {
	}
	function TTestUTUnitPanel2 (player p) { //移除所有原生UI到屏幕外

	}
	function TTestUTUnitPanel3 (player p) {
		//unitPanel.onAttrBtnEnter();
	}
	function TTestUTUnitPanel4 (player p) {}
	function TTestUTUnitPanel5 (player p) {}
	function TTestUTUnitPanel6 (player p) {}
	function TTestUTUnitPanel7 (player p) {}
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
			BJDebugMsg("[UnitPanel] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));

		//在游戏开始0.1秒后再调用
		tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.1);
		TriggerAddCondition(tr,Condition(function (){
			unitPanel.moveOutAll();
			Init();
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

	}

}
//! endzinc

#endif
