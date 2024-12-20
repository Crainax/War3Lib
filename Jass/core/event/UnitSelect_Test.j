#ifndef UTUnitSelectIncluded
#define UTUnitSelectIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUnitSelect requires UnitSelect {

	function TTestUTUnitSelect1 (player p) {
		unitSelect.onSync(function (){ //同步时选中单位调用
			unit u = unitSelect.argsSync;
			BJDebugMsg("[同步单位选择事件]:" + GetUnitName(u));
			u = null;
		});
		unitSelect.onSyncUn(function (){ //同步时取消选择单位调用
			unit u = unitSelect.argsSync;
			BJDebugMsg("[同步单位取消选择事件]:" + GetUnitName(u));
			u = null;
		});
		unitSelect.onAsync(function (){ //异步时选中单位调用
			unit u = unitSelect.args;
			BJDebugMsg("[异步单位选择事件]:" + GetUnitName(u));
			u = null;
		});
		unitSelect.onAsyncUn(function (){ //异步时取消选择单位调用
			unit u = unitSelect.args;
			BJDebugMsg("[异步单位取消选择事件]:" + GetUnitName(u));
			u = null;
		});
	}
	function TTestUTUnitSelect2 (player p) {}
	function TTestUTUnitSelect3 (player p) {}
	function TTestUTUnitSelect4 (player p) {}
	function TTestUTUnitSelect5 (player p) {}
	function TTestUTUnitSelect6 (player p) {}
	function TTestUTUnitSelect7 (player p) {}
	function TTestUTUnitSelect8 (player p) {}
	function TTestUTUnitSelect9 (player p) {}
	function TTestUTUnitSelect10 (player p) {}
	function TTestActUTUnitSelect1 (string str) {
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
			unit hero, building, footman1, footman2, archer, priest;

			BJDebugMsg("[UnitSelect] 单元测试已加载");

			// 创建主要测试英雄
			hero = CreateUnit(Player(0), 'Hamg', 0, 0, 270); // 大法师

			// 创建一些测试单位
			footman1 = CreateUnit(Player(0), 'hfoo', -200, 200, 270); // 步兵1
			footman2 = CreateUnit(Player(0), 'hfoo', -200, -200, 270); // 步兵2
			archer = CreateUnit(Player(0), 'earc', 200, 200, 270); // 弓箭手
			priest = CreateUnit(Player(0), 'hmpr', 200, -200, 270); // 牧师

			// 创建一个建筑
			building = CreateUnit(Player(0), 'hbar', 400, 0, 270); // 兵营

			// 给单位添加一些状态以便区分
			SetUnitState(footman1, UNIT_STATE_LIFE, GetUnitState(footman1, UNIT_STATE_MAX_LIFE) * 0.5); // 半血
			SetUnitState(archer, UNIT_STATE_MANA, 0); // 没蓝
			UnitAddAbility(priest, 'Ainf'); // 给牧师添加隐身能力

			// 设置英雄等级
			SetHeroLevel(hero, 5, true);

			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitSelect1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitSelect1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitSelect2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitSelect3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitSelect4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitSelect5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitSelect6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitSelect7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitSelect8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitSelect9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitSelect10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
