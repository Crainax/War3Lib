#ifndef UTBulletIncluded
#define UTBulletIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTBullet requires Bullet {

	// 测试用单位：友方施法者（P1）与敌方单位（P11）
	private unit utCaster = null;
	private unit utEnemy  = null;  // 保留一个敌方单位参考点（便于朝向计算）
	private unit utEnemies[];      // 100个环形分布的敌方单位数组

	// 施放模式：由英雄施放 A000 时决定本次调用 BulletCast / BulletCastToPoint 的方式
	private integer utCastMode = 1;   // 1~6
	private trigger utCastTr = null;

	// 统一完成回调：打印命中结果 + 读取自定义 tag（HASH_TIMER 里自存）
	private function onBulletComplete() -> boolean {
		timer t;
		integer id;
		unit c;
		unit u;
		boolean hit;
		real x;
		real y;
		integer tag;

		t = BulletCompleteGetTimer();
		id = 0;
		tag = 0;
		if (t != null) {
			id = GetHandleId(t);
			tag = LoadInteger(HASH_TIMER, id, 99);
		}

		c = BulletCompleteGetCaster();
		u = BulletCompleteGetTarget();
		hit = BulletCompleteGetHit();
		x = BulletCompleteGetX();
		y = BulletCompleteGetY();

		BJDebugMsg("[BulletTest] onComplete"
		+ " tag=" + I2S(tag)
		+ " hit=" + I2S(I3(hit, 1, 0))
		+ " caster=" + S3(c != null, GetUnitName(c), "(null)")
		+ " target=" + S3(u != null, GetUnitName(u), "(null)")
		+ " x=" + R2S(x) + " y=" + R2S(y));

		t = null;
		c = null;
		u = null;
		return true;
	}

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

		centerX = 0.0;
		centerY = 0.0;
		utCaster = CreateUnit(p1, 'Hpal', centerX, centerY, 0.0);
		UnitAddAbility(utCaster, 'A000');

		// 创建100个敌方单位（hpea）呈环形分布
		radius = 700.0;
		angleStep = 360.0 / 100.0;

		for (0 <= i <= 99) {
			angle = angleStep * I2R(i);
			unitX = centerX + radius * CosBJ(angle);
			unitY = centerY + radius * SinBJ(angle);
			utEnemies[i] = CreateUnit(p11, 'hpea', unitX, unitY, angle);
			if (i == 0) {
				utEnemy = utEnemies[i];
			}
		}

		BJDebugMsg("[BulletTest] 已创建施法者 + 100个环形敌方单位；请用英雄施放 A000 或输入 s1~s10 / -help");

		p1 = null;
		p11 = null;
	}

	// 注册一次施法触发器：英雄施放 A000 时，根据 utCastMode 执行不同 Bullet 测试
	private function ensureCastTrigger() {
		trigger tr;

		if (utCastTr != null) {
			return;
		}

		tr = CreateTrigger();
		utCastTr = tr;
		TriggerRegisterUnitEvent(tr, utCaster, EVENT_UNIT_SPELL_EFFECT);
		TriggerAddCondition(tr, Condition(function () -> boolean {
			unit u;
			real sx;
			real sy;
			real tx;
			real ty;
			real facing;
			timer t;
			integer id;
			real ang;

			u = GetTriggerUnit();
			if (GetSpellAbilityId() != 'A000') {
				u = null;
				return false;
			}

			sx = GetUnitX(u);
			sy = GetUnitY(u);
			tx = GetSpellTargetX();
			ty = GetSpellTargetY();
			facing = GetFacing(sx, sy, tx, ty);

			// 默认配置（每次 cast 只影响一次，BulletCast 内部会复原）
			BulletCfg.speed         = 900.0;
			BulletCfg.modelPath     = BULLET_MODEL_PATH;
			BulletCfg.scale         = 1.0;
			BulletCfg.hitEffectPath = "";
			BulletCfg.damageType    = BULLET_DMG_MAGIC;
			BulletCfg.heightOffset  = 0.0;

			BJDebugMsg("[BulletTest] 英雄施放 A000, 模式=" + I2S(utCastMode));

			// 模式说明：
			// 1: BulletCast（默认魔法伤害，无击中特效）
			// 2: BulletCast（有击中特效）
			// 3: BulletCast（物理伤害）
			// 4: BulletCast（纯粹伤害）
			// 5: BulletCastToPoint（命中优先结束；终点=技能目标点）
			// 6: BulletCastToPoint（选一个“空隙角度”尽量不命中，hit=false）
			if (utCastMode == 1) {
				t = BulletCast(u, sx, sy, facing, 200.0, 150.0, 1200.0, function onBulletComplete);
				if (t != null) {
					id = GetHandleId(t);
					SaveInteger(HASH_TIMER, id, 99, 101);
				}
			}
			else if (utCastMode == 2) {
				BulletCfg.hitEffectPath = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl";
				t = BulletCast(u, sx, sy, facing, 200.0, 150.0, 1200.0, function onBulletComplete);
				if (t != null) {
					id = GetHandleId(t);
					SaveInteger(HASH_TIMER, id, 99, 102);
				}
			}
			else if (utCastMode == 3) {
				BulletCfg.damageType = BULLET_DMG_PHYSICAL;
				t = BulletCast(u, sx, sy, facing, 200.0, 150.0, 1200.0, function onBulletComplete);
				if (t != null) {
					id = GetHandleId(t);
					SaveInteger(HASH_TIMER, id, 99, 103);
				}
			}
			else if (utCastMode == 4) {
				BulletCfg.damageType = BULLET_DMG_PURE;
				t = BulletCast(u, sx, sy, facing, 200.0, 150.0, 1200.0, function onBulletComplete);
				if (t != null) {
					id = GetHandleId(t);
					SaveInteger(HASH_TIMER, id, 99, 104);
				}
			}
			else if (utCastMode == 5) {
				// 终点=技能目标点，沿途命中则提前结束；否则到点结束 hit=false
				t = BulletCastToPoint(u, sx, sy, tx, ty, 200.0, 150.0, function onBulletComplete);
				if (t != null) {
					id = GetHandleId(t);
					SaveInteger(HASH_TIMER, id, 99, 105);
				}
			}
			else if (utCastMode == 6) {
				// “空隙角度”测试：避开环形单位（角度 1.8°，两单位间隙），半径调小
				ang = 1.8;
				tx = sx + 1200.0 * CosBJ(ang);
				ty = sy + 1200.0 * SinBJ(ang);
				BulletCfg.speed = 1200.0;
				t = BulletCastToPoint(u, sx, sy, tx, ty, 200.0, 10.0, function onBulletComplete);
				if (t != null) {
					id = GetHandleId(t);
					SaveInteger(HASH_TIMER, id, 99, 106);
				}
			}

			u = null;
			t = null;
			return true;
		}));

		tr = null;
	}

	function Init () {
		initUnits();
		ensureCastTrigger();
	}

	// 1) BulletCast：默认魔法伤害，无击中特效，带 onComplete
	function TTestUTBullet1 (player p) {
		real sx;
		real sy;
		real ex;
		real ey;
		real facing;
		timer t;
		integer id;

		initUnits();
		if (utCaster == null || utEnemy == null) {
			BJDebugMsg("[BulletTest] 单位未初始化");
			return;
		}

		sx = GetUnitX(utCaster);
		sy = GetUnitY(utCaster);
		ex = GetUnitX(utEnemy);
		ey = GetUnitY(utEnemy);
		facing = GetFacing(sx, sy, ex, ey);

		BulletCfg.speed         = 900.0;
		BulletCfg.modelPath     = BULLET_MODEL_PATH;
		BulletCfg.scale         = 1.0;
		BulletCfg.hitEffectPath = "";
		BulletCfg.damageType    = BULLET_DMG_MAGIC;
		BulletCfg.heightOffset  = 0.0;

		BJDebugMsg("[BulletTest] TTestUTBullet1：BulletCast(魔法, 无击中特效, onComplete)");
		t = BulletCast(utCaster, sx, sy, facing, 200.0, 150.0, 1200.0, function onBulletComplete);
		if (t != null) {
			id = GetHandleId(t);
			SaveInteger(HASH_TIMER, id, 99, 201);
		}

		t = null;
		p = null;
	}

	// 2) BulletCast：魔法伤害，有击中特效
	function TTestUTBullet2 (player p) {
		real sx;
		real sy;
		real ex;
		real ey;
		real facing;
		timer t;
		integer id;

		initUnits();
		if (utCaster == null || utEnemy == null) {
			BJDebugMsg("[BulletTest] 单位未初始化");
			return;
		}

		sx = GetUnitX(utCaster);
		sy = GetUnitY(utCaster);
		ex = GetUnitX(utEnemy);
		ey = GetUnitY(utEnemy);
		facing = GetFacing(sx, sy, ex, ey);

		BulletCfg.speed         = 900.0;
		BulletCfg.modelPath     = BULLET_MODEL_PATH;
		BulletCfg.scale         = 1.0;
		BulletCfg.hitEffectPath = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl";
		BulletCfg.damageType    = BULLET_DMG_MAGIC;
		BulletCfg.heightOffset  = 0.0;

		BJDebugMsg("[BulletTest] TTestUTBullet2：BulletCast(魔法, 有击中特效, onComplete)");
		t = BulletCast(utCaster, sx, sy, facing, 200.0, 150.0, 1200.0, function onBulletComplete);
		if (t != null) {
			id = GetHandleId(t);
			SaveInteger(HASH_TIMER, id, 99, 202);
		}

		t = null;
		p = null;
	}

	// 3) BulletCast：物理伤害（验证 damageType 分支）
	function TTestUTBullet3 (player p) {
		real sx;
		real sy;
		real ex;
		real ey;
		real facing;
		timer t;
		integer id;

		initUnits();
		if (utCaster == null || utEnemy == null) {
			BJDebugMsg("[BulletTest] 单位未初始化");
			return;
		}

		sx = GetUnitX(utCaster);
		sy = GetUnitY(utCaster);
		ex = GetUnitX(utEnemy);
		ey = GetUnitY(utEnemy);
		facing = GetFacing(sx, sy, ex, ey);

		BulletCfg.speed         = 900.0;
		BulletCfg.modelPath     = BULLET_MODEL_PATH;
		BulletCfg.scale         = 1.0;
		BulletCfg.hitEffectPath = "";
		BulletCfg.damageType    = BULLET_DMG_PHYSICAL;
		BulletCfg.heightOffset  = 0.0;

		BJDebugMsg("[BulletTest] TTestUTBullet3：BulletCast(物理, 无击中特效, onComplete)");
		t = BulletCast(utCaster, sx, sy, facing, 200.0, 150.0, 1200.0, function onBulletComplete);
		if (t != null) {
			id = GetHandleId(t);
			SaveInteger(HASH_TIMER, id, 99, 203);
		}

		t = null;
		p = null;
	}

	// 4) BulletCast：纯粹伤害（验证 damageType 分支）
	function TTestUTBullet4 (player p) {
		real sx;
		real sy;
		real ex;
		real ey;
		real facing;
		timer t;
		integer id;

		initUnits();
		if (utCaster == null || utEnemy == null) {
			BJDebugMsg("[BulletTest] 单位未初始化");
			return;
		}

		sx = GetUnitX(utCaster);
		sy = GetUnitY(utCaster);
		ex = GetUnitX(utEnemy);
		ey = GetUnitY(utEnemy);
		facing = GetFacing(sx, sy, ex, ey);

		BulletCfg.speed         = 900.0;
		BulletCfg.modelPath     = BULLET_MODEL_PATH;
		BulletCfg.scale         = 1.0;
		BulletCfg.hitEffectPath = "";
		BulletCfg.damageType    = BULLET_DMG_PURE;
		BulletCfg.heightOffset  = 0.0;

		BJDebugMsg("[BulletTest] TTestUTBullet4：BulletCast(纯粹, 无击中特效, onComplete)");
		t = BulletCast(utCaster, sx, sy, facing, 200.0, 150.0, 1200.0, function onBulletComplete);
		if (t != null) {
			id = GetHandleId(t);
			SaveInteger(HASH_TIMER, id, 99, 204);
		}

		t = null;
		p = null;
	}

	// 5) BulletCast：射程不足（在到达敌人前强制结束 hit=false）
	function TTestUTBullet5 (player p) {
		real sx;
		real sy;
		real ex;
		real ey;
		real facing;
		timer t;
		integer id;

		initUnits();
		if (utCaster == null || utEnemy == null) {
			BJDebugMsg("[BulletTest] 单位未初始化");
			return;
		}

		sx = GetUnitX(utCaster);
		sy = GetUnitY(utCaster);
		ex = GetUnitX(utEnemy);
		ey = GetUnitY(utEnemy);
		facing = GetFacing(sx, sy, ex, ey);

		BulletCfg.speed         = 900.0;
		BulletCfg.modelPath     = BULLET_MODEL_PATH;
		BulletCfg.scale         = 1.0;
		BulletCfg.hitEffectPath = "";
		BulletCfg.damageType    = BULLET_DMG_MAGIC;
		BulletCfg.heightOffset  = 0.0;

		BJDebugMsg("[BulletTest] TTestUTBullet5：BulletCast(射程=400，预期 hit=false)");
		t = BulletCast(utCaster, sx, sy, facing, 200.0, 150.0, 400.0, function onBulletComplete);
		if (t != null) {
			id = GetHandleId(t);
			SaveInteger(HASH_TIMER, id, 99, 205);
		}

		t = null;
		p = null;
	}

	// 6) BulletCast：缩放 + 高度偏移（验证模型变换/高度）
	function TTestUTBullet6 (player p) {
		real sx;
		real sy;
		real ex;
		real ey;
		real facing;
		timer t;
		integer id;

		initUnits();
		if (utCaster == null || utEnemy == null) {
			BJDebugMsg("[BulletTest] 单位未初始化");
			return;
		}

		sx = GetUnitX(utCaster);
		sy = GetUnitY(utCaster);
		ex = GetUnitX(utEnemy);
		ey = GetUnitY(utEnemy);
		facing = GetFacing(sx, sy, ex, ey);

		BulletCfg.speed         = 900.0;
		BulletCfg.modelPath     = BULLET_MODEL_PATH;
		BulletCfg.scale         = 1.6;
		BulletCfg.hitEffectPath = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl";
		BulletCfg.damageType    = BULLET_DMG_MAGIC;
		BulletCfg.heightOffset  = 120.0;

		BJDebugMsg("[BulletTest] TTestUTBullet6：BulletCast(scale=1.6,heightOffset=120，有击中特效)");
		t = BulletCast(utCaster, sx, sy, facing, 200.0, 150.0, 1200.0, function onBulletComplete);
		if (t != null) {
			id = GetHandleId(t);
			SaveInteger(HASH_TIMER, id, 99, 206);
		}

		t = null;
		p = null;
	}

	// 7) BulletCast：高速（验证 speed 生效）
	function TTestUTBullet7 (player p) {
		real sx;
		real sy;
		real ex;
		real ey;
		real facing;
		timer t;
		integer id;

		initUnits();
		if (utCaster == null || utEnemy == null) {
			BJDebugMsg("[BulletTest] 单位未初始化");
			return;
		}

		sx = GetUnitX(utCaster);
		sy = GetUnitY(utCaster);
		ex = GetUnitX(utEnemy);
		ey = GetUnitY(utEnemy);
		facing = GetFacing(sx, sy, ex, ey);

		BulletCfg.speed         = 1800.0;
		BulletCfg.modelPath     = BULLET_MODEL_PATH;
		BulletCfg.scale         = 1.0;
		BulletCfg.hitEffectPath = "";
		BulletCfg.damageType    = BULLET_DMG_MAGIC;
		BulletCfg.heightOffset  = 0.0;

		BJDebugMsg("[BulletTest] TTestUTBullet7：BulletCast(speed=1800)");
		t = BulletCast(utCaster, sx, sy, facing, 200.0, 150.0, 1200.0, function onBulletComplete);
		if (t != null) {
			id = GetHandleId(t);
			SaveInteger(HASH_TIMER, id, 99, 207);
		}

		t = null;
		p = null;
	}

	// 8) BulletCastToPoint：终点=某敌人位置（通常会命中，hit=true）
	function TTestUTBullet8 (player p) {
		real sx;
		real sy;
		real tx;
		real ty;
		timer t;
		integer id;

		initUnits();
		if (utCaster == null || utEnemy == null) {
			BJDebugMsg("[BulletTest] 单位未初始化");
			return;
		}

		sx = GetUnitX(utCaster);
		sy = GetUnitY(utCaster);
		tx = GetUnitX(utEnemy);
		ty = GetUnitY(utEnemy);

		BulletCfg.speed         = 900.0;
		BulletCfg.modelPath     = BULLET_MODEL_PATH;
		BulletCfg.scale         = 1.0;
		BulletCfg.hitEffectPath = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl";
		BulletCfg.damageType    = BULLET_DMG_MAGIC;
		BulletCfg.heightOffset  = 0.0;

		BJDebugMsg("[BulletTest] TTestUTBullet8：BulletCastToPoint(终点=敌人位置，预期 hit=true)");
		t = BulletCastToPoint(utCaster, sx, sy, tx, ty, 200.0, 150.0, function onBulletComplete);
		if (t != null) {
			id = GetHandleId(t);
			SaveInteger(HASH_TIMER, id, 99, 208);
		}

		t = null;
		p = null;
	}

	// 9) BulletCastToPoint：空隙角度 + 小半径（尽量不命中，hit=false）
	function TTestUTBullet9 (player p) {
		real sx;
		real sy;
		real tx;
		real ty;
		real ang;
		timer t;
		integer id;

		initUnits();
		if (utCaster == null) {
			BJDebugMsg("[BulletTest] 单位未初始化");
			return;
		}

		sx = GetUnitX(utCaster);
		sy = GetUnitY(utCaster);
		ang = 1.8;
		tx = sx + 1200.0 * CosBJ(ang);
		ty = sy + 1200.0 * SinBJ(ang);

		BulletCfg.speed         = 1200.0;
		BulletCfg.modelPath     = BULLET_MODEL_PATH;
		BulletCfg.scale         = 1.0;
		BulletCfg.hitEffectPath = "";
		BulletCfg.damageType    = BULLET_DMG_MAGIC;
		BulletCfg.heightOffset  = 0.0;

		BJDebugMsg("[BulletTest] TTestUTBullet9：BulletCastToPoint(空隙角度, radius=10, 预期 hit=false)");
		t = BulletCastToPoint(utCaster, sx, sy, tx, ty, 200.0, 10.0, function onBulletComplete);
		if (t != null) {
			id = GetHandleId(t);
			SaveInteger(HASH_TIMER, id, 99, 209);
		}

		t = null;
		p = null;
	}

	// 10) 模式驱动：切换 utCastMode，让玩家用 A000 实际施放触发（仿照 Pierce_Test 的 s1~s4 模式）
	function TTestUTBullet10 (player p) {
		initUnits();
		ensureCastTrigger();
		BJDebugMsg("[BulletTest] TTestUTBullet10：已启用 A000 模式驱动。输入 s1~s6 切换模式，然后用英雄施放 A000。");
		p = null;
	}

	function TTestActUTBullet1 (string str) {
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

		// 简易命令（以 "-" 开头触发）：
		// -help
		// -mode N        (1~6)
		// -run N         (1~10)
		if (paramS[0] == "help") {
			BJDebugMsg("[BulletTest] -help | -mode N(1~6) | -run N(1~10)");
			BJDebugMsg("[BulletTest] 也可直接输入：s1~s10（等价于 run 1~10），或 s1~s6 切换 A000 模式后施放 A000。");
		}
		else if (paramS[0] == "mode") {
			if (num >= 2) {
				utCastMode = paramI[1];
				BJDebugMsg("[BulletTest] utCastMode=" + I2S(utCastMode) + "（请用英雄施放 A000）");
			} else {
				BJDebugMsg("[BulletTest] 用法：-mode 1");
			}
		}
		else if (paramS[0] == "run") {
			if (num >= 2) {
				if (paramI[1] == 1) TTestUTBullet1(p);
				else if (paramI[1] == 2) TTestUTBullet2(p);
				else if (paramI[1] == 3) TTestUTBullet3(p);
				else if (paramI[1] == 4) TTestUTBullet4(p);
				else if (paramI[1] == 5) TTestUTBullet5(p);
				else if (paramI[1] == 6) TTestUTBullet6(p);
				else if (paramI[1] == 7) TTestUTBullet7(p);
				else if (paramI[1] == 8) TTestUTBullet8(p);
				else if (paramI[1] == 9) TTestUTBullet9(p);
				else if (paramI[1] == 10) TTestUTBullet10(p);
				else BJDebugMsg("[BulletTest] run 范围：1~10");
			} else {
				BJDebugMsg("[BulletTest] 用法：-run 1");
			}
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[Bullet] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTBullet1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			// s1~s6：切换 A000 施放模式（仿照 Pierce_Test）
			if (str == "s1") { utCastMode = 1; BJDebugMsg("[BulletTest] 模式切换到 1：BulletCast(魔法, 无击中特效)"); }
			else if (str == "s2") { utCastMode = 2; BJDebugMsg("[BulletTest] 模式切换到 2：BulletCast(魔法, 有击中特效)"); }
			else if (str == "s3") { utCastMode = 3; BJDebugMsg("[BulletTest] 模式切换到 3：BulletCast(物理)"); }
			else if (str == "s4") { utCastMode = 4; BJDebugMsg("[BulletTest] 模式切换到 4：BulletCast(纯粹)"); }
			else if (str == "s5") { utCastMode = 5; BJDebugMsg("[BulletTest] 模式切换到 5：BulletCastToPoint(终点=技能目标点)"); }
			else if (str == "s6") { utCastMode = 6; BJDebugMsg("[BulletTest] 模式切换到 6：BulletCastToPoint(空隙角度, radius=10)"); }
			// s7~s10：直接执行指定用例
			else if (str == "s7") TTestUTBullet7(GetTriggerPlayer());
			else if (str == "s8") TTestUTBullet8(GetTriggerPlayer());
			else if (str == "s9") TTestUTBullet9(GetTriggerPlayer());
			else if (str == "s10") TTestUTBullet10(GetTriggerPlayer());
		});


		// EXEffectMatRotateZ
		// YDWECoordinateY.
	}

}
//! endzinc

#endif
