#ifndef UTAttacrtionIncluded
#define UTAttacrtionIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

// 自动生成的文件
// 指令列表：
//  - "-spawn"：在 (-2000,-2000) 起点 10x10 网格生成 100 个玩家11农民
//  - "-go"：生成敌人（如未生成）并以默认参数启动吸怪（半径1200，速度30，持续8秒）
//  - "-go_resist"：生成敌人并额外生成一批带吸怪抗性/免疫的敌人，再启动吸怪
//  - "-push"：生成敌人并以负速度（-30）启动吸怪，用于观察负值时无吸附/斥力行为
library UTAttacrtion requires Attraction {

	private boolean spawned = false;
	private unit testCaster = null;

	private function spawnEnemies() {
		integer i; integer row; integer col;
		real baseX; real baseY; real step;
		unit u;

		if (spawned) { return; }

		baseX = -2000.0;
		baseY = -2000.0;
		step = 200.0;
		for (i = 0; i < 100; i += 1) {
			row = i / 10;
			col = i - row * 10;
			u = CreateUnit(Player(10), 'hpea', baseX + step * col, baseY + step * row, 0.0);
		}
		u = null;
		spawned = true;
	}

	private function ensureCaster() -> unit {
		unit u;
		if (testCaster != null) {
			return testCaster;
		}
		u = CreateUnit(Player(0), 'Hamg', 0.0, 0.0, 270.0);
		testCaster = u;
		return u;
	}

	private function startAttract() {
		unit caster;

		caster = ensureCaster();
		CreateAttractionAt(caster, GetUnitX(caster),GetUnitY(caster), 1200.0, 30.0, 8.0, true);
		caster = null;
	}

	private function startAttractWithSpeed(real speed) {
		unit caster;

		caster = ensureCaster();
		if (speed >= 0.0) {
			CreateAttractionAt(caster, GetUnitX(caster), GetUnitY(caster), 1200.0, speed, 8.0, true);
		} else {
			CreateRepulsionAt(caster, GetUnitX(caster), GetUnitY(caster), 1200.0, -speed, 8.0, true);
		}
		caster = null;
	}

	private function spawnResistUnits() {
		integer i;
		unit u;
		real angle;
		real dist;
		player p;

		p = Player(10);
		dist = 600.0;
		for (i = 0; i < 6; i += 1) {
			angle = 60.0 * i;
			u = CreateUnit(p, 'hpea', dist * Cos(angle * bj_DEGTORAD), dist * Sin(angle * bj_DEGTORAD), 0.0);
			if (i == 0) {
				AddUnitAttractResistUp(u, 0.5); // 50% 抗性
			} else if (i == 1) {
				AddUnitAttractResistUp(u, 0.9); // 90% 抗性
			} else if (i == 2) {
				AddUnitAttractResistUp(u, 0.99); // 接近完全抗性
			} else if (i == 3) {
				SetUnitAttractImmune(u, true); // 免疫
			} else if (i == 4) {
				AddUnitAttractResistUp(u, 0.3); // 30% 抗性
			} else {
				AddUnitAttractResistUp(u, 0.7); // 70% 抗性
			}
		}
		u = null;
		p = null;
	}

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			unit u; real r1; real r2; real expect;

			u = CreateUnit(Player(0), 'hpea', 0, 0, 0);

			// 吸怪抗性叠加应遵循 RealAdd 归一规则
			AddUnitAttractResistUp(u, 0.3);
			AddUnitAttractResistUp(u, 0.8);
			expect = RealAdd(0.3, 0.8);
			r1 = GetUnitAttractResist(u);
			assert.Real(r1, expect, "吸怪抗性叠加应匹配 RealAdd 结果");

			// 重置后应为 0
			ResetUnitAttractResistUp(u);
			r2 = GetUnitAttractResist(u);
			assert.Real(r2, 0.0, "重置吸怪抗性应为 0");

			RemoveUnit(u);
			u = null;
		}, null);

		UnitTestAutoTimer(0.1, 2.0, function() {
			unit u;

			u = CreateUnit(Player(0), 'hpea', 0, 0, 0);

			// 免疫开关应正确反映
			SetUnitAttractImmune(u, true);
			assert.Boolean(IsUnitAttractImmune(u), "开启吸怪免疫后应为真");
			SetUnitAttractImmune(u, false);
			assert.Boolean(!IsUnitAttractImmune(u), "关闭吸怪免疫后应为假");

			RemoveUnit(u);
			u = null;
		}, null);
	}

	function TTestUTAttacrtion1 (player p) {}
	function TTestUTAttacrtion2 (player p) {}
	function TTestUTAttacrtion3 (player p) {}
	function TTestUTAttacrtion4 (player p) {}
	function TTestUTAttacrtion5 (player p) {}
	function TTestUTAttacrtion6 (player p) {}
	function TTestUTAttacrtion7 (player p) {}
	function TTestUTAttacrtion8 (player p) {}
	function TTestUTAttacrtion9 (player p) {}
	function TTestUTAttacrtion10 (player p) {}
	function TTestActUTAttacrtion1 (string str) {
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

		if (paramS[0] == "spawn") {
			spawnEnemies();
			BJDebugMsg("[AttractTest] 已生成 100 个玩家11农民在 -2000/-2000 网格。");
		} else if (paramS[0] == "go") {
			spawnEnemies();
			startAttract();
			BJDebugMsg("[AttractTest] 吸怪已启动（半径1200，速度30，持续8秒）。");
		} else if (paramS[0] == "go_resist") {
			spawnEnemies();
			spawnResistUnits();
			startAttract();
			BJDebugMsg("[AttractTest] 吸怪+抗性测试启动（含多档抗性与免疫单位）。");
		} else if (paramS[0] == "push") {
			spawnEnemies();
			startAttractWithSpeed(-30.0);
			BJDebugMsg("[AttractTest] 斥力已启动（半径1200，速度30，持续8秒，推开敌人）。");
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[Attacrtion] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTAttacrtion1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTAttacrtion1(GetTriggerPlayer());
			else if(str == "s2") TTestUTAttacrtion2(GetTriggerPlayer());
			else if(str == "s3") TTestUTAttacrtion3(GetTriggerPlayer());
			else if(str == "s4") TTestUTAttacrtion4(GetTriggerPlayer());
			else if(str == "s5") TTestUTAttacrtion5(GetTriggerPlayer());
			else if(str == "s6") TTestUTAttacrtion6(GetTriggerPlayer());
			else if(str == "s7") TTestUTAttacrtion7(GetTriggerPlayer());
			else if(str == "s8") TTestUTAttacrtion8(GetTriggerPlayer());
			else if(str == "s9") TTestUTAttacrtion9(GetTriggerPlayer());
			else if(str == "s10") TTestUTAttacrtion10(GetTriggerPlayer());
		});

		// Attraction.create
		//YDWECoordinateX

	}

}
//! endzinc

#endif
