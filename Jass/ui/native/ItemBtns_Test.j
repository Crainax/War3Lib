#ifndef UTItemBtnsIncluded
#define UTItemBtnsIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

library UTItemBtns requires ItemBtns,UnitTestUIRuler {

	// 初始化就调用
	function Init () {
		itemBtns.onEnter(function () {
			integer pos = itemBtns.argsPos;
			BJDebugMsg("第" + I2S(pos) + "个物品进入2");
		});
		itemBtns.onLeave(function () {
			integer pos = itemBtns.argsPos;
			BJDebugMsg("第" + I2S(pos) + "个物品离开2");
		});
	}
	// 测试1: 测试全部隐藏和全部显示的
	function TTestUTItemBtns1 (player p) {
		integer i;
		for (1 <= i <= 6) {
			itemBtns.outside(i);
		}
		BJDebugMsg("全部物品隐藏");
	}
	function TTestUTItemBtns2 (player p) {
		integer i;
		for (1 <= i <= 6) {
			itemBtns.inside(i);
		}
		BJDebugMsg("全部物品显示");
	}
	function TTestUTItemBtns3 (player p) { //测试流光
		itemBtns.icons[1].grow(growdata[ICONGROW_13]);
		itemBtns.icons[2].grow(growdata[ICONGROW_14]);
		itemBtns.icons[3].grow(growdata[ICONGROW_15]);
		itemBtns.icons[4].grow(growdata[ICONGROW_16]);
		itemBtns.icons[5].grow(growdata[ICONGROW_17]);
		itemBtns.icons[6].grow(growdata[ICONGROW_18]);
	}
	boolean isShadeShown = false;
	function TTestUTItemBtns4 (player p) {
		integer i;
		isShadeShown = !isShadeShown;
		itemBtns.showShade(isShadeShown);
		BJDebugMsg("全部物品暗遮罩");
	}
	function TTestUTItemBtns5 (player p) {}
	function TTestUTItemBtns6 (player p) {}
	function TTestUTItemBtns7 (player p) {}
	function TTestUTItemBtns8 (player p) {}
	function TTestUTItemBtns9 (player p) {}
	function TTestUTItemBtns10 (player p) {}
	function TTestActUTItemBtns1 (string str) {
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

		if (paramS[0] == "outside") {
			itemBtns.outside(paramI[1]);
			BJDebugMsg("outside:"+I2S(paramI[1]));
		} else if (paramS[0] == "inside") {
			itemBtns.inside(paramI[1]);
			BJDebugMsg("inside:"+I2S(paramI[1]));
		} else if (paramS[0] == "ungrow") {
			itemBtns.icons[paramI[1]].unGrow();
			BJDebugMsg("停止流光:"+I2S(paramI[1]));
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

			BJDebugMsg("[ItemBtns] 单元测试已加载");

			// 为玩家1创建测试英雄
			hero = CreateUnit(Player(0), 'Hamg', 0, 0, 270); // 创建大法师在坐标(0,0)

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

			Init();

			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTItemBtns1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTItemBtns1(GetTriggerPlayer());
			else if(str == "s2") TTestUTItemBtns2(GetTriggerPlayer());
			else if(str == "s3") TTestUTItemBtns3(GetTriggerPlayer());
			else if(str == "s4") TTestUTItemBtns4(GetTriggerPlayer());
			else if(str == "s5") TTestUTItemBtns5(GetTriggerPlayer());
			else if(str == "s6") TTestUTItemBtns6(GetTriggerPlayer());
			else if(str == "s7") TTestUTItemBtns7(GetTriggerPlayer());
			else if(str == "s8") TTestUTItemBtns8(GetTriggerPlayer());
			else if(str == "s9") TTestUTItemBtns9(GetTriggerPlayer());
			else if(str == "s10") TTestUTItemBtns10(GetTriggerPlayer());
		});
		InitTestUIRuler();
	}

}
//! endzinc

#endif
