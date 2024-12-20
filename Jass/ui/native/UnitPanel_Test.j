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
library UTUnitPanel requires UnitPanel,UnitTestUIRuler {

	public function Init2 () {
		unitPanel.registerBuilding(); //注册建筑单位的单位面板刷新机制

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
	}

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
		testInit2In(Building)
		testInit2In(Monster)

		Init2();
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
		unitPanel.moveOutBuilding();
		unitPanel.moveOutMonster();
		BJDebugMsg("移走");
	}
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
