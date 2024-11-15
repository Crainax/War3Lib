#ifndef UTDamageUtilsIncluded
#define UTDamageUtilsIncluded

//! zinc
/*
DamageUtils测试库
测试命令:
s1 - 测试物理伤害
s2 - 测试真实伤害
s3 - 测试模拟普攻
s4 - 测试范围物理伤害
s5 - 测试范围真实伤害
s6 - 切换伤害数值显示
s7 - 切换伤害反弹测试
参数命令:
-d [数值] - 设置伤害值
-r [数值] - 设置范围值
-e [特效路径] - 设置特效
*/
library UTDamageUtils requires DamageUtils {
	private unit testDummy = null;     // 测试用假人
	private unit testSource = null;     // 测试用伤害源
	private real testDamage = 100.0;   // 测试用伤害值
	private real testRadius = 300.0;   // 测试用范围值
	private string testEffect = "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl"; // 测试用特效
	private trigger damageEventTrigger = null;
	private boolean isShowDamage = false;
	private boolean isReflectDamage = false;  // 反伤开关
	private integer reflectCount = 0;  // 反伤计数器


	// 创建测试环境
	function CreateTestEnv(player p) {
		real x = GetPlayerStartLocationX(p);
		real y = GetPlayerStartLocationY(p);
		real angle;
		integer i;
		group g = CreateGroup();
		unit dummy;

		// 清理所有已存在的测试单位
		GroupEnumUnitsInRange(g, x, y, 1000, null);
		ForGroup(g, function() {
			unit u = GetEnumUnit();
			if(GetUnitTypeId(u) == 'opeo' || GetUnitTypeId(u) == 'hpea') {
				RemoveUnit(u);
			}
			u = null;
		});
		DestroyGroup(g);
		g = null;

		testDummy = null;
		testSource = null;

		// 创建中心苦工单位
		testDummy = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'opeo', x + 200, y, 270);
		SetUnitInvulnerable(testDummy, false);
		SetUnitState(testDummy, UNIT_STATE_LIFE, GetUnitState(testDummy, UNIT_STATE_MAX_LIFE));
		// 注册伤害事件
		TriggerRegisterUnitEvent(damageEventTrigger, testDummy, EVENT_UNIT_DAMAGED);

		// 创建环形分布的额外苦工
		for(0 <= i < 8) {
			angle = i * 45.0 * bj_DEGTORAD;
			dummy = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'opeo',
			x + 200 + testRadius * Cos(angle),
			y + testRadius * Sin(angle),
			270);
			// 为每个苦工注册伤害事件
			TriggerRegisterUnitEvent(damageEventTrigger, dummy, EVENT_UNIT_DAMAGED);
		}

		// 创建伤害源(农民)
		testSource = CreateUnit(p, 'hpea', x, y, 90);
		SetUnitAttack(testSource, 50);
		// 为农民也注册伤害事件
		TriggerRegisterUnitEvent(damageEventTrigger, testSource, EVENT_UNIT_DAMAGED);
	}

	// 测试物理伤害
	function TTestUTDamageUtils1(player p) {
		CreateTestEnv(p);
		Trace("测试物理伤害: " + R2S(testDamage));
		ApplyPhysicalDamage(testSource, testDummy, testDamage, true);
	}

	// 测试真实伤害
	function TTestUTDamageUtils2(player p) {
		CreateTestEnv(p);
		Trace("测试真实伤害: " + R2S(testDamage));
		ApplyPureDamage(testSource, testDummy, testDamage, true);
	}

	// 测试模拟普攻
	function TTestUTDamageUtils3(player p) {
		CreateTestEnv(p);
		Trace("测试模拟普攻，基础攻击: 50");
		SimulateBasicAttack(testSource, testDummy, 0);
	}

	// 测试范围物理伤害
	function TTestUTDamageUtils4(player p) {
		CreateTestEnv(p);
		Trace("测试范围物理伤害: " + R2S(testDamage) + " 范围: " + R2S(testRadius));
		Trace("中心点有1个假人，半径 " + R2S(testRadius) + " 处有8个假人");
		Trace("范围内的假人都会受到伤害和特效");
		DamageArea(testSource, GetUnitX(testSource), GetUnitY(testSource),
		testRadius, testDamage, true, testEffect);
	}

	// 测试范围真实伤害
	function TTestUTDamageUtils5(player p) {
		CreateTestEnv(p);
		Trace("测试范围真实伤害: " + R2S(testDamage) + " 范围: " + R2S(testRadius));
		Trace("中心点有1个假人，半径 " + R2S(testRadius) + " 处有8个假人");
		Trace("范围内的假人都会受到伤害和特效");
		DamageAreaPure(testSource, GetUnitX(testSource), GetUnitY(testSource),
		testRadius, testDamage, true, testEffect);
	}

	// 测试伤害显示开关
	function TTestUTDamageUtils6(player p) {
		isShowDamage = !isShowDamage;
		if(isShowDamage) {
			Trace("|cff00ff00开启|r伤害数值显示");
		} else {
			Trace("|cffff0000关闭|r伤害数值显示");
		}
	}

	// 测试反伤开关
	function TTestUTDamageUtils7(player p) {
		isReflectDamage = !isReflectDamage;
		if(isReflectDamage) {
			reflectCount = 0;  // 重置反伤计数
			Trace("|cff00ff00开启|r伤害反弹测试 - 受伤单位将反弹50%伤害(最多5次)");
		} else {
			Trace("|cffff0000关闭|r伤害反弹测试");
		}
	}

	// 处理参数设置命令
	function TTestActUTDamageUtils1(string str) {
		player  p     = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,    num = 0, len = StringLength(str);
		string  paramS[]; // 所有参数S
		integer paramI[]; // 所有参数I
		real    paramR[]; // 所有参数R

		// 解析参数
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

		// 处理命令
		if (paramS[0] == "d") {
			testDamage = paramR[1];
			Trace("设置伤害值为: " + R2S(testDamage));
		} else if (paramS[0] == "r") {
			testRadius = paramR[1];
			Trace("设置范围值为: " + R2S(testRadius));
		} else if (paramS[0] == "e") {
			testEffect = paramS[1];
			Trace("设置特效为: " + testEffect);
		}

		p = null;
	}

	function onInit() {
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr, 0.5);
		TriggerAddCondition(tr, Condition(function() {
			Trace("|cff00ff00[DamageUtils测试]|r 输入以下命令进行测试:");
			Trace("s1 - 测试物理伤害");
			Trace("s2 - 测试真实伤害");
			Trace("s3 - 测试模拟普攻");
			Trace("s4 - 测试范围物理伤害");
			Trace("s5 - 测试范围真实伤害");
			Trace("s6 - 切换伤害数值显示");
			Trace("s7 - 切换伤害反弹测试");
			Trace("参数设置:");
			Trace("-d [数值] - 设置伤害值");
			Trace("-r [数值] - 设置范围值");
			Trace("-e [路径] - 设置特效");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		// 创建伤害事件触发器
		damageEventTrigger = CreateTrigger();
		TriggerAddCondition(damageEventTrigger, Condition(function (){
			unit source = GetEventDamageSource();
			unit target = GetTriggerUnit();
			real damage = GetEventDamage();

			// 显示伤害信息
			if(isShowDamage) {
				Trace("|cffff0000伤害事件|r - 来源: " + GetUnitName(source) +
				" 目标: " + GetUnitName(target) +
				"("+I2S(GetHandleId(target))+ ") 伤害: " + R2S(damage) + " 当前栈层: " + I2S(DmgS.getTop()));
			}

			// 反伤测试
			if(isReflectDamage && reflectCount < 5) {  // 限制反伤次数
				reflectCount += 1;  // 增加反伤计数
				Trace("第 " + I2S(reflectCount) + " 次反伤");

				// 造成反伤
				DamageArea(target, GetUnitX(target),GetUnitY(target), 100, damage * 0.5, true, I2S(DmgS.getTop()));

				if(reflectCount >= 5) {
					Trace("|cffff0000达到最大反伤次数(5次),现在栈层: " + I2S(DmgS.getTop()));
				}
			}
		}));

		// 注册聊天事件
		UnitTestRegisterChatEvent(function() {
			string str = GetEventPlayerChatString();

			if(SubString(str, 0, 1) == "-") {
				TTestActUTDamageUtils1(SubString(str, 1, StringLength(str)));
				return;
			}

			if(str == "s1") TTestUTDamageUtils1(GetTriggerPlayer());
			else if(str == "s2") TTestUTDamageUtils2(GetTriggerPlayer());
			else if(str == "s3") TTestUTDamageUtils3(GetTriggerPlayer());
			else if(str == "s4") TTestUTDamageUtils4(GetTriggerPlayer());
			else if(str == "s5") TTestUTDamageUtils5(GetTriggerPlayer());
			else if(str == "s6") TTestUTDamageUtils6(GetTriggerPlayer());
			else if(str == "s7") TTestUTDamageUtils7(GetTriggerPlayer());  // 新增命令
		});

		cameraControl.openWheel();
	}

	function onDestroy() {
		DestroyTrigger(damageEventTrigger);
		damageEventTrigger = null;
	}
}
//! endzinc

#endif
