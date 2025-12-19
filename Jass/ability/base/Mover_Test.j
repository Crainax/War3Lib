#ifndef UTMoverIncluded
#define UTMoverIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTMover requires Mover {

	// 测试用单位：圣骑士（用于伤害测试）
	private unit utCaster = null;
	private trigger utCastTr = null;
	private integer utTestMode = 1;  // 1=基础移动, 2=带完成回调, 3=带步骤回调, 4=不同配置, 5=到达伤害
	private unit utEnemies[];  // 100个农民数组（用于伤害测试）

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

		// 创建圣骑士在地图中央（用于伤害测试）
		utCaster = CreateUnit(p1, 'Hpal', 0.0, 0.0, 0.0);
		UnitAddAbility(utCaster, 'A000');

		// 创建100个农民（平铺，10x10网格，围绕原点）
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

		BJDebugMsg("[MoverTest] 已创建100个农民（10x10网格，玩家11）");

		// 注册施法触发器：英雄施放 A000 时，根据 utTestMode 调用 StartEffectMove
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

				BJDebugMsg("[MoverTest] 英雄施放 A000, 模式=" + I2S(utTestMode));

				if (utTestMode == 1) {
					// 测试1: 基础移动（无伤害，无回调）
					EffectMoveCfg.radius = 0.0;
					EffectMoveCfg.damage = 0.0;
					EffectMoveCfg.onStep = null;
					StartEffectMove(null, sx, sy, tx, ty, null);
					BJDebugMsg("[MoverTest] 已创建基础特效移动");
				} else if (utTestMode == 2) {
					// 测试2: 带完成回调
					EffectMoveCfg.radius = 0.0;
					EffectMoveCfg.damage = 0.0;
					EffectMoveCfg.onStep = null;
					StartEffectMove(null, sx, sy, tx, ty, function () -> boolean {
						effect e;
						real x;
						real y;
						e = EffectMoveGetEffect();
						x = EffectMoveGetX();
						y = EffectMoveGetY();
						BJDebugMsg("[MoverTest] 特效移动完成: x=" + R2S(x) + ", y=" + R2S(y));
						e = null;
						return true;
					});
					BJDebugMsg("[MoverTest] 已创建带完成回调的特效移动");
				} else if (utTestMode == 3) {
					// 测试3: 带步骤回调（每若干 tick 打印一次）
					EffectMoveCfg.radius = 0.0;
					EffectMoveCfg.damage = 0.0;
					EffectMoveCfg.onStep = function () -> boolean {
						integer stepCount;
						real x;
						real y;
						real travelled;
						effect e;
						stepCount = 0;
						x = EffectMoveGetX();
						y = EffectMoveGetY();
						travelled = EffectMoveGetTravelled();
						e = EffectMoveGetEffect();
						// 每10个tick打印一次（约0.3秒）
						stepCount = R2I(travelled / (EffectMoveCfg.speed * EffectMoveCfg.tick * 10.0));
						if (ModuloInteger(R2I(travelled / (EffectMoveCfg.speed * EffectMoveCfg.tick)), 10) == 0) {
							BJDebugMsg("[MoverTest] 步骤回调: x=" + R2S(x) + ", y=" + R2S(y) + ", 已移动=" + R2S(travelled));
						}
						e = null;
						return true;
					};
					StartEffectMove(null, sx, sy, tx, ty, function () -> boolean {
						effect e;
						real x;
						real y;
						real travelled;
						e = EffectMoveGetEffect();
						x = EffectMoveGetX();
						y = EffectMoveGetY();
						travelled = EffectMoveGetTravelled();
						BJDebugMsg("[MoverTest] 特效移动完成: 总距离=" + R2S(travelled));
						e = null;
						return true;
					});
					BJDebugMsg("[MoverTest] 已创建带步骤回调的特效移动");
				} else if (utTestMode == 4) {
					// 测试4: 不同配置参数测试（连续发起多次，每次不同配置）
					// 第一次：默认配置
					EffectMoveCfg.radius = 0.0;
					EffectMoveCfg.damage = 0.0;
					EffectMoveCfg.onStep = null;
					StartEffectMove(null, sx - 200.0, sy, tx - 200.0, ty, function () -> boolean {
						BJDebugMsg("[MoverTest] 配置测试1完成（默认配置）");
						return true;
					});
					// 第二次：修改模型和缩放
					EffectMoveCfg.modelPath = "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl";
					EffectMoveCfg.scale = 2.0;
					EffectMoveCfg.radius = 0.0;
					EffectMoveCfg.damage = 0.0;
					EffectMoveCfg.onStep = null;
					StartEffectMove(null, sx, sy, tx, ty, function () -> boolean {
						BJDebugMsg("[MoverTest] 配置测试2完成（修改模型和缩放）");
						return true;
					});
					// 第三次：修改速度和高度
					EffectMoveCfg.speed = 1200.0;
					EffectMoveCfg.heightOffset = 100.0;
					EffectMoveCfg.radius = 0.0;
					EffectMoveCfg.damage = 0.0;
					EffectMoveCfg.onStep = null;
					StartEffectMove(null, sx + 200.0, sy, tx + 200.0, ty, function () -> boolean {
						BJDebugMsg("[MoverTest] 配置测试3完成（修改速度和高度）");
						return true;
					});
					BJDebugMsg("[MoverTest] 已创建3个不同配置的特效移动");
				} else if (utTestMode == 5) {
					// 测试5: 到达伤害测试（物理伤害）
					EffectMoveCfg.damageType = EFFECTMOVE_DMG_PHYSICAL;
					EffectMoveCfg.radius = 200.0;
					EffectMoveCfg.damage = 500.0;
					EffectMoveCfg.onStep = null;
					StartEffectMove(utCaster, sx, sy, tx, ty, function () -> boolean {
						effect e;
						real x;
						real y;
						e = EffectMoveGetEffect();
						x = EffectMoveGetX();
						y = EffectMoveGetY();
						BJDebugMsg("[MoverTest] 物理伤害特效移动完成: x=" + R2S(x) + ", y=" + R2S(y));
						BJDebugMsg("[MoverTest] 终点半径200内的敌人应受到500物理伤害");
						e = null;
						return true;
					});
					BJDebugMsg("[MoverTest] 已创建物理伤害特效移动（伤害500，半径200）");
				} else if (utTestMode == 6) {
					// 测试6: 到达伤害测试（魔法伤害）
					EffectMoveCfg.damageType = EFFECTMOVE_DMG_MAGIC;
					EffectMoveCfg.radius = 200.0;
					EffectMoveCfg.damage = 500.0;
					EffectMoveCfg.onStep = null;
					StartEffectMove(utCaster, sx, sy, tx, ty, function () -> boolean {
						effect e;
						real x;
						real y;
						e = EffectMoveGetEffect();
						x = EffectMoveGetX();
						y = EffectMoveGetY();
						BJDebugMsg("[MoverTest] 魔法伤害特效移动完成: x=" + R2S(x) + ", y=" + R2S(y));
						BJDebugMsg("[MoverTest] 终点半径200内的敌人应受到500魔法伤害");
						e = null;
						return true;
					});
					BJDebugMsg("[MoverTest] 已创建魔法伤害特效移动（伤害500，半径200）");
				} else if (utTestMode == 7) {
					// 测试7: 到达伤害测试（纯粹伤害）
					EffectMoveCfg.damageType = EFFECTMOVE_DMG_PURE;
					EffectMoveCfg.radius = 200.0;
					EffectMoveCfg.damage = 500.0;
					EffectMoveCfg.onStep = null;
					StartEffectMove(utCaster, sx, sy, tx, ty, function () -> boolean {
						effect e;
						real x;
						real y;
						e = EffectMoveGetEffect();
						x = EffectMoveGetX();
						y = EffectMoveGetY();
						BJDebugMsg("[MoverTest] 纯粹伤害特效移动完成: x=" + R2S(x) + ", y=" + R2S(y));
						BJDebugMsg("[MoverTest] 终点半径200内的敌人应受到500纯粹伤害");
						e = null;
						return true;
					});
					BJDebugMsg("[MoverTest] 已创建纯粹伤害特效移动（伤害500，半径200）");
				}

				u = null;
				return true;
			}));
		}

		BJDebugMsg("[MoverTest] 已创建圣骑士并添加 A000 技能");
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

	// 测试1: 基础移动（无伤害，无回调）
	function TTestUTMover1 (player p) {
		initUnits();
		if (utCaster == null) {
			BJDebugMsg("[MoverTest] 单位未初始化");
			return;
		}
		utTestMode = 1;
		BJDebugMsg("[MoverTest] 测试1: 基础移动（无伤害，无回调）");
		BJDebugMsg("[MoverTest] 请对目标点施放 A000 技能");
	}

	// 测试2: 带完成回调
	function TTestUTMover2 (player p) {
		initUnits();
		if (utCaster == null) {
			BJDebugMsg("[MoverTest] 单位未初始化");
			return;
		}
		utTestMode = 2;
		BJDebugMsg("[MoverTest] 测试2: 带完成回调");
		BJDebugMsg("[MoverTest] 请对目标点施放 A000 技能");
	}

	// 测试3: 带步骤回调
	function TTestUTMover3 (player p) {
		initUnits();
		if (utCaster == null) {
			BJDebugMsg("[MoverTest] 单位未初始化");
			return;
		}
		utTestMode = 3;
		BJDebugMsg("[MoverTest] 测试3: 带步骤回调（每10个tick打印一次位置）");
		BJDebugMsg("[MoverTest] 请对目标点施放 A000 技能");
	}

	// 测试4: 不同配置参数测试
	function TTestUTMover4 (player p) {
		initUnits();
		if (utCaster == null) {
			BJDebugMsg("[MoverTest] 单位未初始化");
			return;
		}
		utTestMode = 4;
		BJDebugMsg("[MoverTest] 测试4: 不同配置参数测试（连续3个特效，不同配置）");
		BJDebugMsg("[MoverTest] 请对目标点施放 A000 技能");
	}

	// 测试5: 到达伤害测试（物理伤害）
	function TTestUTMover5 (player p) {
		initUnits();
		if (utCaster == null) {
			BJDebugMsg("[MoverTest] 单位未初始化");
			return;
		}
		utTestMode = 5;
		BJDebugMsg("[MoverTest] 测试5: 到达伤害测试（物理伤害，伤害500，半径200）");
		BJDebugMsg("[MoverTest] 请对目标点施放 A000 技能，终点半径内的敌人会受到伤害");
	}

	// 测试6: 到达伤害测试（魔法伤害）
	function TTestUTMover6 (player p) {
		initUnits();
		if (utCaster == null) {
			BJDebugMsg("[MoverTest] 单位未初始化");
			return;
		}
		utTestMode = 6;
		BJDebugMsg("[MoverTest] 测试6: 到达伤害测试（魔法伤害，伤害500，半径200）");
		BJDebugMsg("[MoverTest] 请对目标点施放 A000 技能，终点半径内的敌人会受到伤害");
	}

	// 测试7: 到达伤害测试（纯粹伤害）
	function TTestUTMover7 (player p) {
		initUnits();
		if (utCaster == null) {
			BJDebugMsg("[MoverTest] 单位未初始化");
			return;
		}
		utTestMode = 7;
		BJDebugMsg("[MoverTest] 测试7: 到达伤害测试（纯粹伤害，伤害500，半径200）");
		BJDebugMsg("[MoverTest] 请对目标点施放 A000 技能，终点半径内的敌人会受到伤害");
	}

	function TTestUTMover8 (player p) {}
	function TTestUTMover9 (player p) {}
	function TTestUTMover10 (player p) {}

	function TTestActUTMover1 (string str) {
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
			BJDebugMsg("[Mover] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTMover1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTMover1(GetTriggerPlayer());
			else if(str == "s2") TTestUTMover2(GetTriggerPlayer());
			else if(str == "s3") TTestUTMover3(GetTriggerPlayer());
			else if(str == "s4") TTestUTMover4(GetTriggerPlayer());
			else if(str == "s5") TTestUTMover5(GetTriggerPlayer());
			else if(str == "s6") TTestUTMover6(GetTriggerPlayer());
			else if(str == "s7") TTestUTMover7(GetTriggerPlayer());
			else if(str == "s8") TTestUTMover8(GetTriggerPlayer());
			else if(str == "s9") TTestUTMover9(GetTriggerPlayer());
			else if(str == "s10") TTestUTMover10(GetTriggerPlayer());
		});

		//YDWECoordinateX
		//EXSetEffectZ
	}

}
//! endzinc

#endif
