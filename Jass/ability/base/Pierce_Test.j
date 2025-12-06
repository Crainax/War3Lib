#ifndef UTPierceIncluded
#define UTPierceIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

// 自动生成的文件（单元测试）
library UTPierce requires Pierce {

	// 测试用单位：友方施法者（P1）与敌方单位（P11）
	private unit utCaster = null;
	private unit utEnemy  = null;  // 保留第一个敌方单位作为参考点（用于测试函数中的朝向计算）
	private unit utEnemies[];      // 100个环形分布的敌方单位数组

	// 回调测试模式：0=无，1=打印不截断，2=打印并截断默认伤害/特效
	private integer utMatchMode = 0;
	private boolean utMatchCbInited = false;

	private function initUnits() {
		player p1;
		player p11;
		integer i;
		real centerX;
		real centerY;
		real radius;
		real angle;
		real angleStep;
		real unitX;
		real unitY;

		if (utCaster != null) {
			return;
		}

		p1  = Player(0);   // 玩家1
		p11 = Player(10);  // 玩家11（敌方）

		// 创建友方施法者在地图中央
		centerX = 0.0;
		centerY = 0.0;
		utCaster = CreateUnit(p1, 'Hpal', centerX, centerY, 0.0);
		UnitAddAbility(utCaster, 'A000');

		// 创建100个敌方单位（hpea）呈环形分布
		radius = 700.0;  // 环形半径
		angleStep = 360.0 / 100.0;  // 每个单位的角度间隔（3.6度）

		for (0 <= i <= 99) {
			angle = angleStep * I2R(i);
			unitX = centerX + radius * CosBJ(angle);
			unitY = centerY + radius * SinBJ(angle);

			utEnemies[i] = CreateUnit(p11, 'hpea', unitX, unitY, angle);

			// 第一个单位作为 utEnemy（用于测试函数中的朝向计算）
			if (i == 0) {
				utEnemy = utEnemies[i];
			}
		}

		BJDebugMsg("[PierceTest] 已创建100个环形分布的敌方单位（hpea）");

		p1  = null;
		p11 = null;
	}

	// 注册一次全局匹配回调：根据 utMatchMode 控制是否截断默认伤害/特效
	private function ensureMatchCallback() {
		if (utMatchCbInited) {
			return;
		}

		PierceCfg.registerMatchEnemy(function () -> boolean {
			unit c;
			unit u;
			real d;

			c = PierceMatchArgs.caster;
			u = PierceMatchArgs.target;
			d = PierceMatchArgs.damage;

			BJDebugMsg("[PierceTest] match mode=" + I2S(utMatchMode)
			+ " caster=" + GetUnitName(c)
			+ " target=" + GetUnitName(u)
			+ " dmg=" + R2S(d));

			// mode=2 时截断默认处理（不再走内置伤害与特效）
			if (utMatchMode == 2) {
				PierceMatchArgs.allowDefault = false;
			}

			c = null;
			u = null;
			return true;
		});

		utMatchCbInited = true;
	}

	// 1) 不带 hitEffectPath、不带回调
	function TTestUTPierce1 (player p) {
		real sx;
		real sy;
		real ex;
		real ey;
		real facing;

		initUnits();
		if (utCaster == null || utEnemy == null) {
			BJDebugMsg("[PierceTest] 单位未初始化");
			return;
		}

		sx = GetUnitX(utCaster);
		sy = GetUnitY(utCaster);
		ex = GetUnitX(utEnemy);
		ey = GetUnitY(utEnemy);
		facing = GetFacing(sx, sy, ex, ey);

		// 配置：无击中特效，无回调
		PierceCfg.speed         = 900.0;
		PierceCfg.modelPath     = PIERCE_MODEL_PATH;
		PierceCfg.scale         = 1.0;
		PierceCfg.hitEffectPath = "";
		PierceCfg.damageType    = PIERCE_DMG_MAGIC;

		utMatchMode = 0;

		BJDebugMsg("[PierceTest] TTestUTPierce1 开始（无击中特效，无回调）");
		PierceCast(utCaster, sx, sy, facing, 200.0, 150.0, 1200.0);
	}

	// 2) 带 hitEffectPath（Stampede 弹片爆炸），不带回调
	function TTestUTPierce2 (player p) {
		real sx;
		real sy;
		real ex;
		real ey;
		real facing;

		initUnits();
		if (utCaster == null || utEnemy == null) {
			BJDebugMsg("[PierceTest] 单位未初始化");
			return;
		}

		sx = GetUnitX(utCaster);
		sy = GetUnitY(utCaster);
		ex = GetUnitX(utEnemy);
		ey = GetUnitY(utEnemy);
		facing = GetFacing(sx, sy, ex, ey);

		PierceCfg.speed         = 900.0;
		PierceCfg.modelPath     = PIERCE_MODEL_PATH;
		PierceCfg.scale         = 1.0;
		PierceCfg.hitEffectPath = "Abilities\\Spells\\Other\\Stampede\\MissileDeath.mdl";
		PierceCfg.damageType    = PIERCE_DMG_MAGIC;

		utMatchMode = 0;

		BJDebugMsg("[PierceTest] TTestUTPierce2 开始（有击中特效，无回调）");
		PierceCast(utCaster, sx, sy, facing, 200.0, 150.0, 1200.0);
	}

	// 3) 带回调（打印），不截断默认处理
	function TTestUTPierce3 (player p) {
		real sx;
		real sy;
		real ex;
		real ey;
		real facing;

		initUnits();
		ensureMatchCallback();

		if (utCaster == null || utEnemy == null) {
			BJDebugMsg("[PierceTest] 单位未初始化");
			return;
		}

		sx = GetUnitX(utCaster);
		sy = GetUnitY(utCaster);
		ex = GetUnitX(utEnemy);
		ey = GetUnitY(utEnemy);
		facing = GetFacing(sx, sy, ex, ey);

		PierceCfg.speed         = 900.0;
		PierceCfg.modelPath     = PIERCE_MODEL_PATH;
		PierceCfg.scale         = 1.0;
		PierceCfg.hitEffectPath = "Abilities\\Spells\\Other\\Stampede\\MissileDeath.mdl";
		PierceCfg.damageType    = PIERCE_DMG_MAGIC;

		utMatchMode = 1; // 打印但不截断

		BJDebugMsg("[PierceTest] TTestUTPierce3 开始（有回调，打印，不截断）");
		PierceCast(utCaster, sx, sy, facing, 200.0, 150.0, 1200.0);
	}

	// 4) 带回调（打印），截断默认处理
	function TTestUTPierce4 (player p) {
		real sx;
		real sy;
		real ex;
		real ey;
		real facing;

		initUnits();
		ensureMatchCallback();

		if (utCaster == null || utEnemy == null) {
			BJDebugMsg("[PierceTest] 单位未初始化");
			return;
		}

		sx = GetUnitX(utCaster);
		sy = GetUnitY(utCaster);
		ex = GetUnitX(utEnemy);
		ey = GetUnitY(utEnemy);
		facing = GetFacing(sx, sy, ex, ey);

		PierceCfg.speed         = 900.0;
		PierceCfg.modelPath     = PIERCE_MODEL_PATH;
		PierceCfg.scale         = 1.0;
		PierceCfg.hitEffectPath = "Abilities\\Spells\\Other\\Stampede\\MissileDeath.mdl";
		PierceCfg.damageType    = PIERCE_DMG_MAGIC;

		utMatchMode = 2; // 打印并截断默认处理

		BJDebugMsg("[PierceTest] TTestUTPierce4 开始（有回调，打印，截断默认伤害/特效）");
		PierceCast(utCaster, sx, sy, facing, 200.0, 150.0, 1200.0);
	}

	function TTestUTPierce5 (player p) {}
	function TTestUTPierce6 (player p) {}
	function TTestUTPierce7 (player p) {}
	function TTestUTPierce8 (player p) {}
	function TTestUTPierce9 (player p) {}
	function TTestUTPierce10 (player p) {}
	function TTestActUTPierce1 (string str) {
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
			BJDebugMsg("[Pierce] 单元测试已加载");
			initUnits();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTPierce1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTPierce1(GetTriggerPlayer());
			else if(str == "s2") TTestUTPierce2(GetTriggerPlayer());
			else if(str == "s3") TTestUTPierce3(GetTriggerPlayer());
			else if(str == "s4") TTestUTPierce4(GetTriggerPlayer());
			else if(str == "s5") TTestUTPierce5(GetTriggerPlayer());
			else if(str == "s6") TTestUTPierce6(GetTriggerPlayer());
			else if(str == "s7") TTestUTPierce7(GetTriggerPlayer());
			else if(str == "s8") TTestUTPierce8(GetTriggerPlayer());
			else if(str == "s9") TTestUTPierce9(GetTriggerPlayer());
			else if(str == "s10") TTestUTPierce10(GetTriggerPlayer());
		});


		//YDWECoordinateX
		//YDWECoordinateY
		//HASH_TIMER
		//EXSetEffectXY
	}

}
//! endzinc

#endif
