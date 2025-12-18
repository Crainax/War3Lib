#ifndef UTDashingIncluded
#define UTDashingIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTDashing requires Dashing {

	// 测试用单位：圣骑士
	private unit utCaster = null;
	private trigger utCastTr = null;
	private integer utTestMode = 1;  // 1=直接冲, 2=带回调, 3=冲刺过程中的回调, 4=伤害类型测试
	private unit utEnemies[];  // 100个农民数组

	// 初始化测试单位
	private function initUnits() {
		player p1;
		player p11;
		trigger tr;
		integer i;
		integer j;
		integer count;
		real startX;
		real startY;
		real spacing;
		real unitX;
		real unitY;
		integer perRow;

		if (utCaster != null) {
			return;
		}

		p1 = Player(0);  // 玩家1
		p11 = Player(10);  // 玩家11（敌方）

		// 创建圣骑士在地图中央
		utCaster = CreateUnit(p1, 'Hpal', 0.0, 0.0, 0.0);
		UnitAddAbility(utCaster, 'A000');

		// 创建100个农民（平铺，10x10网格）
		startX = -500.0;
		startY = -500.0;
		spacing = 100.0;
		perRow = 10;
		count = 0;

		for (0 <= i <= 9) {
			for (0 <= j <= 9) {
				unitX = startX + spacing * I2R(j);
				unitY = startY + spacing * I2R(i);
				utEnemies[count] = CreateUnit(p11, 'hpea', unitX, unitY, 0.0);
				count = count + 1;
			}
		}

		BJDebugMsg("[DashingTest] 已创建100个农民（10x10网格，玩家11）");

		// 注册施法触发器：英雄施放 A000 时，根据 utTestMode 调用 StartDashing
		if (utCastTr == null) {
			tr = CreateTrigger();
			utCastTr = tr;
			TriggerRegisterUnitEvent(tr, utCaster, EVENT_UNIT_SPELL_EFFECT);
			TriggerAddCondition(tr, Condition(function () -> boolean {
				unit u;
				real sx;
				real sy;
				real tx;
				real ty;

				u = GetTriggerUnit();
				if (GetSpellAbilityId() != 'A000') {
					u = null;
					return false;
				}

				sx = GetUnitX(u);
				sy = GetUnitY(u);
				tx = GetSpellTargetX();
				ty = GetSpellTargetY();

				BJDebugMsg("[DashingTest] 英雄施放 A000, 模式=" + I2S(utTestMode));

				if (utTestMode == 1) {
					// 测试1: 直接冲（无伤害，无回调）
					StartDashing(u, tx, ty, 80.0, 1200, null, null, 0.0, 0.0);
				} else if (utTestMode == 2) {
					// 测试2: 带回调（无伤害，有完成回调）
					StartDashing(u, tx, ty, 80.0, 1200, function () -> boolean {
						unit cu;
						cu = DashingGetUnit();
						BJDebugMsg("[DashingTest] 冲刺完成: " + GetUnitName(cu));
						cu = null;
						return true;
					}, null, 0.0, 0.0);
				} else if (utTestMode == 3) {
					// 测试3: 冲刺过程中的回调（无伤害，有步骤回调）
					StartDashing(u, tx, ty, 80.0, 1200, null, function () -> boolean {
						unit cu;
						integer times;
						effect e;
						cu = DashingGetUnit();
						times = DashingGetTimes();
						// 每步添加特效
						e = AddSpecialEffect("Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl", GetUnitX(cu), GetUnitY(cu));
						DestroyEffect(e);
						e = null;
						cu = null;
						return true;
					}, 0.0, 0.0);
				} else if (utTestMode == 4) {
					// 测试4: 伤害类型测试（物理伤害）
					DashingCfg.damageType = DASHING_DMG_PHYSICAL;
					StartDashing(u, tx, ty, 80.0, 1200, function () -> boolean {
						unit cu;
						cu = DashingGetUnit();
						BJDebugMsg("[DashingTest] 物理伤害冲刺完成: " + GetUnitName(cu));
						cu = null;
						return true;
					}, null, 200.0, 500.0);
				} else if (utTestMode == 5) {
					// 测试5: 伤害类型测试（魔法伤害）
					DashingCfg.damageType = DASHING_DMG_MAGIC;
					StartDashing(u, tx, ty, 80.0, 1200, function () -> boolean {
						unit cu;
						cu = DashingGetUnit();
						BJDebugMsg("[DashingTest] 魔法伤害冲刺完成: " + GetUnitName(cu));
						cu = null;
						return true;
					}, null, 200.0, 500.0);
				} else if (utTestMode == 6) {
					// 测试6: 伤害类型测试（纯粹伤害）
					DashingCfg.damageType = DASHING_DMG_PURE;
					StartDashing(u, tx, ty, 80.0, 1200, function () -> boolean {
						unit cu;
						cu = DashingGetUnit();
						BJDebugMsg("[DashingTest] 纯粹伤害冲刺完成: " + GetUnitName(cu));
						cu = null;
						return true;
					}, null, 200.0, 500.0);
				}

				u = null;
				return true;
			}));
		}

		BJDebugMsg("[DashingTest] 已创建圣骑士并添加 A000 技能");
		p1 = null;
		p11 = null;
		tr = null;
	}

	function Init () {
		initUnits();
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);
	}

	// 测试1: 直接冲（无伤害，无回调）
	function TTestUTDashing1 (player p) {
		initUnits();
		if (utCaster == null) {
			BJDebugMsg("[DashingTest] 单位未初始化");
			return;
		}
		utTestMode = 1;
		BJDebugMsg("[DashingTest] 测试1: 直接冲（无伤害，无回调）");
		BJDebugMsg("[DashingTest] 请对目标点施放 A000 技能");
	}

	// 测试2: 带回调（无伤害，有完成回调）
	function TTestUTDashing2 (player p) {
		initUnits();
		if (utCaster == null) {
			BJDebugMsg("[DashingTest] 单位未初始化");
			return;
		}
		utTestMode = 2;
		BJDebugMsg("[DashingTest] 测试2: 带回调（无伤害，有完成回调）");
		BJDebugMsg("[DashingTest] 请对目标点施放 A000 技能");
	}

	// 测试3: 冲刺过程中的回调（无伤害，有步骤回调）
	function TTestUTDashing3 (player p) {
		initUnits();
		if (utCaster == null) {
			BJDebugMsg("[DashingTest] 单位未初始化");
			return;
		}
		utTestMode = 3;
		BJDebugMsg("[DashingTest] 测试3: 冲刺过程中的回调（无伤害，有步骤回调）");
		BJDebugMsg("[DashingTest] 请对目标点施放 A000 技能");
	}

	// 测试4: 伤害类型测试（物理伤害）
	function TTestUTDashing4 (player p) {
		initUnits();
		if (utCaster == null) {
			BJDebugMsg("[DashingTest] 单位未初始化");
			return;
		}
		utTestMode = 4;
		BJDebugMsg("[DashingTest] 测试4: 物理伤害冲刺（伤害500，半径200）");
		BJDebugMsg("[DashingTest] 请对目标点施放 A000 技能，会伤害路径上的敌人");
	}

	// 测试5: 伤害类型测试（魔法伤害）
	function TTestUTDashing5 (player p) {
		initUnits();
		if (utCaster == null) {
			BJDebugMsg("[DashingTest] 单位未初始化");
			return;
		}
		utTestMode = 5;
		BJDebugMsg("[DashingTest] 测试5: 魔法伤害冲刺（伤害500，半径200）");
		BJDebugMsg("[DashingTest] 请对目标点施放 A000 技能，会伤害路径上的敌人");
	}

	// 测试6: 伤害类型测试（纯粹伤害）
	function TTestUTDashing6 (player p) {
		initUnits();
		if (utCaster == null) {
			BJDebugMsg("[DashingTest] 单位未初始化");
			return;
		}
		utTestMode = 6;
		BJDebugMsg("[DashingTest] 测试6: 纯粹伤害冲刺（伤害500，半径200）");
		BJDebugMsg("[DashingTest] 请对目标点施放 A000 技能，会伤害路径上的敌人");
	}
	function TTestUTDashing7 (player p) {}
	function TTestUTDashing8 (player p) {}
	function TTestUTDashing9 (player p) {}
	function TTestUTDashing10 (player p) {}
	function TTestActUTDashing1 (string str) {
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
			BJDebugMsg("[Dashing] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTDashing1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTDashing1(GetTriggerPlayer());
			else if(str == "s2") TTestUTDashing2(GetTriggerPlayer());
			else if(str == "s3") TTestUTDashing3(GetTriggerPlayer());
			else if(str == "s4") TTestUTDashing4(GetTriggerPlayer());
			else if(str == "s5") TTestUTDashing5(GetTriggerPlayer());
			else if(str == "s6") TTestUTDashing6(GetTriggerPlayer());
			else if(str == "s7") TTestUTDashing7(GetTriggerPlayer());
			else if(str == "s8") TTestUTDashing8(GetTriggerPlayer());
			else if(str == "s9") TTestUTDashing9(GetTriggerPlayer());
			else if(str == "s10") TTestUTDashing10(GetTriggerPlayer());
		});

		//YDWECoordinateX
	}

}
//! endzinc

#endif
