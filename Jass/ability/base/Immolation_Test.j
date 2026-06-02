#ifndef UTImmolationIncluded
#define UTImmolationIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

library UTImmolation requires Immolation {
	private unit singleSource = null;
	private unit singleAnchor = null;
	private unit singleTarget = null;
	private real singleStartLife = 0.0;

	private unit stackSource = null;
	private unit stackAnchor1 = null;
	private unit stackAnchor2 = null;
	private unit stackTarget = null;
	private real stackStartLife = 0.0;

	private unit intervalSource = null;
	private unit intervalAnchor = null;
	private unit intervalTarget = null;
	private real intervalStartLife = 0.0;

	private function CreateSource(player p, real x, real y) -> unit {
		unit u;
		u = CreateUnit(p, 'Hpal', x, y, 270.0);
		SetUnitInvulnerable(u, true);
		return u;
	}

	private function CreateAnchor(player p, real x, real y, real duration) -> unit {
		unit u;
		u = CreateUnit(p, 'hpea', x, y, 270.0);
		UnitApplyTimedLifeBJ(duration, 'BTLF', u);
		return u;
	}

	private function CreateTarget(real x, real y) -> unit {
		unit u;
		u = CreateUnit(Player(10), 'hfoo', x, y, 270.0);
		SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE));
		return u;
	}

	private function Test_Single_Start() {
		singleSource = CreateSource(Player(0), 0.0, 0.0);
		singleAnchor = CreateAnchor(Player(0), 0.0, 0.0, 1.50);
		singleTarget = CreateTarget(120.0, 0.0);
		singleStartLife = GetUnitState(singleTarget, UNIT_STATE_LIFE);

		ImmolationCfg.interval = 1.0;
		ImmolationCfg.hitEffectPath = "Abilities\\Weapons\\Bolt\\BoltImpact.mdl";
		StartImmolation(singleSource, singleAnchor, 220.0, 80.0, 1.0);

		assert.Integer(GetImmolationActiveCount(), 1, "单个献祭启动后实例数应为 1");
		assert.Boolean(IsImmolationTimerAlive(), "单个献祭启动后主管计时器应存在");
	}

	private function Test_Single_End() {
		real life;
		life = GetUnitState(singleTarget, UNIT_STATE_LIFE);
		assert.Boolean(life < singleStartLife, "单个献祭首次间隔后应造成伤害");
		assert.Integer(GetImmolationActiveCount(), 0, "单个献祭持续时间结束后实例数应为 0");
		assert.Boolean(!IsImmolationTimerAlive(), "列表为空后主管计时器应销毁");
	}

	private function Test_Stack_Start() {
		stackSource = CreateSource(Player(0), 400.0, 0.0);
		stackAnchor1 = CreateAnchor(Player(0), 400.0, 0.0, 1.50);
		stackAnchor2 = CreateAnchor(Player(0), 400.0, 0.0, 1.50);
		stackTarget = CreateTarget(520.0, 0.0);
		stackStartLife = GetUnitState(stackTarget, UNIT_STATE_LIFE);

		ImmolationCfg.interval = 1.0;
		StartImmolation(stackSource, stackAnchor1, 220.0, 80.0, 1.0);
		ImmolationCfg.interval = 1.0;
		StartImmolation(stackSource, stackAnchor2, 220.0, 80.0, 1.0);

		assert.Integer(GetImmolationActiveCount(), 2, "两个重叠献祭启动后实例数应为 2");
	}

	private function Test_Stack_End() {
		real life;
		life = GetUnitState(stackTarget, UNIT_STATE_LIFE);
		assert.Boolean(stackStartLife - life > 120.0, "两个重叠献祭应叠加造成伤害");
		assert.Integer(GetImmolationActiveCount(), 0, "重叠献祭结束后实例数应为 0");
		assert.Boolean(!IsImmolationTimerAlive(), "重叠献祭结束后主管计时器应销毁");
	}

	private function Test_CustomInterval_Start() {
		intervalSource = CreateSource(Player(0), 800.0, 0.0);
		intervalAnchor = CreateAnchor(Player(0), 800.0, 0.0, 1.20);
		intervalTarget = CreateTarget(920.0, 0.0);
		intervalStartLife = GetUnitState(intervalTarget, UNIT_STATE_LIFE);

		ImmolationCfg.interval = 0.30;
		StartImmolation(intervalSource, intervalAnchor, 220.0, 45.0, 0.90);

		assert.Integer(GetImmolationActiveCount(), 1, "自定义 interval 献祭启动后实例数应为 1");
		assert.Boolean(IsImmolationTimerAlive(), "自定义 interval 献祭启动后主管计时器应存在");
	}

	private function Test_CustomInterval_End() {
		real life;
		life = GetUnitState(intervalTarget, UNIT_STATE_LIFE);
		assert.Boolean(intervalStartLife - life > 80.0, "0.30 秒 interval 在 0.90 秒内应多次造成伤害");
		assert.Integer(GetImmolationActiveCount(), 0, "自定义 interval 献祭结束后实例数应为 0");
		assert.Boolean(!IsImmolationTimerAlive(), "自定义 interval 献祭结束后主管计时器应销毁");
	}

	function Init() {
		UnitTestAutoTimer(0.20, 0.10, function() {
			Trace("Immolation 单实例启动测试");
			Test_Single_Start();
		}, null);

		UnitTestAutoTimer(1.55, 0.10, function() {
			Trace("Immolation 单实例结束测试");
			Test_Single_End();
		}, null);

		UnitTestAutoTimer(1.80, 0.10, function() {
			Trace("Immolation 叠加启动测试");
			Test_Stack_Start();
		}, null);

		UnitTestAutoTimer(3.15, 0.10, function() {
			Trace("Immolation 叠加结束测试");
			Test_Stack_End();
		}, null);

		UnitTestAutoTimer(3.40, 0.10, function() {
			Trace("Immolation 自定义间隔启动测试");
			Test_CustomInterval_Start();
		}, null);

		UnitTestAutoTimer(4.55, 0.10, function() {
			Trace("Immolation 自定义间隔结束测试");
			Test_CustomInterval_End();
		}, null);
	}

	function TTestUTImmolation1(player p) {
		Test_Single_Start();
		p = null;
	}

	function TTestUTImmolation2(player p) {
		Test_Stack_Start();
		p = null;
	}

	function TTestUTImmolation3(player p) {
		Test_CustomInterval_Start();
		p = null;
	}

	function onInit() {
		trigger tr;

		tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr, 0.50);
		TriggerAddCondition(tr, Condition(function() -> boolean {
			BJDebugMsg("[Immolation] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
			return true;
		}));
		tr = null;

		UnitTestRegisterChatEvent(function() {
			string str;

			str = GetEventPlayerChatString();
			if (str == "s1") {
				TTestUTImmolation1(GetTriggerPlayer());
			} else if (str == "s2") {
				TTestUTImmolation2(GetTriggerPlayer());
			} else if (str == "s3") {
				TTestUTImmolation3(GetTriggerPlayer());
			}
		});
	}
}

//! endzinc

#endif
