#ifndef UTUnitRegenIncluded
#define UTUnitRegenIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
* 单位属性-生命值恢复测试
*
* 测试功能:
* 1. 定量回复(生命值/魔法值)
* 2. 百分比回复(生命值/魔法值)
* 3. 回复效益(增幅/减幅)
* 4. 多单位同时回复
*
* 测试指令:
* s1 - 测试定量回血回魔
* s2 - 测试百分比回血回魔
* s3 - 测试回复效益增幅
* s4 - 测试回复效益减幅
* s5 - 测试多单位回复
* -a [value] - 设置定量回血值
* -b [value] - 设置定量回魔值
* -c [value] - 设置百分比回血值
* -d [value] - 设置百分比回魔值
*/
library UTUnitRegen requires UnitRegen {

	private unit testUnit = null;
	private unit testUnit2 = null;

	function Init() {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			testUnit2 = CreateUnit(Player(0), 'hfoo', 100, 100, 0);
			// 设置初始生命值和魔法值为最大值的30%
			SetUnitState(testUnit, UNIT_STATE_MAX_MANA, 3000);
			SetUnitState(testUnit2, UNIT_STATE_MAX_MANA, 3000);
			SetUnitState(testUnit, UNIT_STATE_LIFE, GetUnitState(testUnit, UNIT_STATE_MAX_LIFE) * 0.3);
			SetUnitState(testUnit, UNIT_STATE_MANA, GetUnitState(testUnit, UNIT_STATE_MAX_MANA) * 0.3);
			SetUnitState(testUnit2, UNIT_STATE_LIFE, GetUnitState(testUnit2, UNIT_STATE_MAX_LIFE) * 0.3);
			SetUnitState(testUnit2, UNIT_STATE_MANA, GetUnitState(testUnit2, UNIT_STATE_MAX_MANA) * 0.3);
			}, function() {
			//end
			// RemoveUnit(testUnit);
			// RemoveUnit(testUnit2);
			// testUnit = null;
			// testUnit2 = null;
		});
	}

	// 测试定量回复
	function TTestUTUnitRegen1(player p) {
		unitRegen oldRegen;
		unitRegen regen;

		// 先销毁旧的回复属性
		oldRegen = unitRegen.get(testUnit);
		if (oldRegen.isExist()) {
			oldRegen.destroy();
		}
		regen = unitRegen.parse(testUnit);
		// 先重置生命值和魔法值
		SetUnitState(testUnit, UNIT_STATE_LIFE, 1);
		SetUnitState(testUnit, UNIT_STATE_MANA, 1);
		regen.addHPFixedRegen(10.0);  // 每秒回10点血
		regen.addMPFixedRegen(5.0);   // 每秒回5点魔
		TimerStart(CreateTimer(),10,false,function (){
			timer t = GetExpiredTimer();
			BJDebugMsg("10秒到了,现在单位的生命和魔法是:");
			BJDebugMsg("生命值: " + R2S(GetUnitState(testUnit, UNIT_STATE_LIFE)));
			BJDebugMsg("魔法值: " + R2S(GetUnitState(testUnit, UNIT_STATE_MANA)));
			PauseTimer(t);
			DestroyTimer(t);
			t = null;
		});
		BJDebugMsg("测试1开始: 定量回复 - 每秒回血10点,回魔5点");
	}

	// 测试百分比回复
	function TTestUTUnitRegen2(player p) {
		unitRegen oldRegen;
		unitRegen regen;

		// 先销毁旧的回复属性
		oldRegen = unitRegen.get(testUnit);
		if (oldRegen.isExist()) {
			oldRegen.destroy();
		}
		regen = unitRegen.parse(testUnit);
		// 先重置生命值和魔法值
		SetUnitState(testUnit, UNIT_STATE_LIFE, 1);
		SetUnitState(testUnit, UNIT_STATE_MANA, 1);
		TimerStart(CreateTimer(),10,false,function (){
			timer t = GetExpiredTimer();
			BJDebugMsg("10秒到了,现在单位的生命和魔法是:");
			BJDebugMsg("生命值: " + R2S(GetUnitState(testUnit, UNIT_STATE_LIFE)));
			BJDebugMsg("魔法值: " + R2S(GetUnitState(testUnit, UNIT_STATE_MANA)));
			PauseTimer(t);
			DestroyTimer(t);
			t = null;
		});
		regen.addHPPercentRegen(0.05); // 每秒回5%最大生命值
		regen.addMPPercentRegen(0.03); // 每秒回3%最大魔法值
		BJDebugMsg("测试2开始: 百分比回复 - 每秒回血5%,回魔3%");
	}

	// 测试回复效益增幅
	function TTestUTUnitRegen3(player p) {
		unitRegen oldRegen;
		unitRegen regen;

		// 先销毁旧的回复属性
		oldRegen = unitRegen.get(testUnit);
		if (oldRegen.isExist()) {
			oldRegen.destroy();
		}
		regen = unitRegen.parse(testUnit);
		// 先重置生命值和魔法值
		SetUnitState(testUnit, UNIT_STATE_LIFE, 1);
		SetUnitState(testUnit, UNIT_STATE_MANA, 1);
		TimerStart(CreateTimer(),10,false,function (){
			timer t = GetExpiredTimer();
			BJDebugMsg("10秒到了,现在单位的生命和魔法是:");
			BJDebugMsg("生命值: " + R2S(GetUnitState(testUnit, UNIT_STATE_LIFE)));
			BJDebugMsg("魔法值: " + R2S(GetUnitState(testUnit, UNIT_STATE_MANA)));
			PauseTimer(t);
			DestroyTimer(t);
			t = null;
		});
		regen.addHPFixedRegen(10.0);
		regen.addRegenEffectUp(0.5);   // 增加50%回复效益
		BJDebugMsg("测试3开始: 回复效益增幅50% - 每秒实际回血15点");
	}

	// 测试回复效益减幅
	function TTestUTUnitRegen4(player p) {
		unitRegen oldRegen;
		unitRegen regen;

		// 先销毁旧的回复属性
		oldRegen = unitRegen.get(testUnit);
		if (oldRegen.isExist()) {
			oldRegen.destroy();
		}
		regen = unitRegen.parse(testUnit);
		// 先重置生命值和魔法值
		SetUnitState(testUnit, UNIT_STATE_LIFE, 1);
		SetUnitState(testUnit, UNIT_STATE_MANA, 1);
		TimerStart(CreateTimer(),10,false,function (){
			timer t = GetExpiredTimer();
			BJDebugMsg("10秒到了,现在单位的生命和魔法是:");
			BJDebugMsg("单位1生命值: " + R2S(GetUnitState(testUnit, UNIT_STATE_LIFE)));
			BJDebugMsg("单位1魔法值: " + R2S(GetUnitState(testUnit, UNIT_STATE_MANA)));
			BJDebugMsg("单位2生命值: " + R2S(GetUnitState(testUnit2, UNIT_STATE_LIFE)));
			BJDebugMsg("单位2魔法值: " + R2S(GetUnitState(testUnit2, UNIT_STATE_MANA)));
			PauseTimer(t);
			DestroyTimer(t);
			t = null;
		});
		regen.addHPFixedRegen(10.0);
		regen.addRegenEffectDown(0.3); // 减少30%回复效益
		BJDebugMsg("测试4开始: 回复效益减少30% - 每秒实际回血7点");
	}

	// 测试多单位回复
	function TTestUTUnitRegen5(player p) {
		unitRegen oldRegen1;
		unitRegen oldRegen2;
		unitRegen regen1;
		unitRegen regen2;

		// 先销毁两个单位的旧回复属性
		oldRegen1 = unitRegen.get(testUnit);
		oldRegen2 = unitRegen.get(testUnit2);
		if (oldRegen1.isExist()) {
			oldRegen1.destroy();
		}
		if (oldRegen2.isExist()) {
			oldRegen2.destroy();
		}
		regen1 = unitRegen.parse(testUnit);
		regen2 = unitRegen.parse(testUnit2);
		// 先重置两个单位的生命值和魔法值
		SetUnitState(testUnit, UNIT_STATE_LIFE, 1);
		SetUnitState(testUnit2, UNIT_STATE_LIFE, 1);
		TimerStart(CreateTimer(),10,false,function (){
			timer t = GetExpiredTimer();
			BJDebugMsg("10秒到了,现在单位的生命和魔法是:");
			BJDebugMsg("生命值: " + R2S(GetUnitState(testUnit, UNIT_STATE_LIFE)));
			BJDebugMsg("魔法值: " + R2S(GetUnitState(testUnit, UNIT_STATE_MANA)));
			PauseTimer(t);
			DestroyTimer(t);
			t = null;
		});
		regen1.addHPFixedRegen(10.0);
		regen2.addHPFixedRegen(20.0);
		BJDebugMsg("测试5开始: 多单位回复 - 单位1每秒回血10点,单位2每秒回血20点");
	}

	function TTestUTUnitRegen6 (player p) {}
	function TTestUTUnitRegen7 (player p) {}
	function TTestUTUnitRegen8 (player p) {}
	function TTestUTUnitRegen9 (player p) {}
	function TTestUTUnitRegen10 (player p) {}
	function TTestActUTUnitRegen1 (string str) {
		player p	 = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R
		unitRegen regen;
		unitRegen oldRegen;

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
			// 先销毁旧的回复属性
			oldRegen = unitRegen.get(testUnit);
			if (oldRegen.isExist()) {
				oldRegen.destroy();
			}
			regen = unitRegen.parse(testUnit);
			regen.addHPFixedRegen(paramR[1]);
			BJDebugMsg("设置定量回血值: " + R2S(paramR[1]));
		} else if (paramS[0] == "b") {
			// 先销毁旧的回复属性
			oldRegen = unitRegen.get(testUnit);
			if (oldRegen.isExist()) {
				oldRegen.destroy();
			}
			regen = unitRegen.parse(testUnit);
			regen.addMPFixedRegen(paramR[1]);
			BJDebugMsg("设置定量回魔值: " + R2S(paramR[1]));
		} else if (paramS[0] == "c") {
			// 先销毁旧的回复属性
			oldRegen = unitRegen.get(testUnit);
			if (oldRegen.isExist()) {
				oldRegen.destroy();
			}
			regen = unitRegen.parse(testUnit);
			regen.addHPPercentRegen(paramR[1]);
			BJDebugMsg("设置百分比回血值: " + R2S(paramR[1] * 100) + "%");
		} else if (paramS[0] == "d") {
			// 先销毁旧的回复属性
			oldRegen = unitRegen.get(testUnit);
			if (oldRegen.isExist()) {
				oldRegen.destroy();
			}
			regen = unitRegen.parse(testUnit);
			regen.addMPPercentRegen(paramR[1]);
			BJDebugMsg("设置百分比回魔值: " + R2S(paramR[1] * 100) + "%");
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[UnitRegen] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitRegen1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitRegen1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitRegen2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitRegen3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitRegen4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitRegen5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitRegen6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitRegen7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitRegen8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitRegen9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitRegen10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
