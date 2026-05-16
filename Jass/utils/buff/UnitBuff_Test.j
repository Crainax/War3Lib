#ifndef UTUnitBuffIncluded
#define UTUnitBuffIncluded

/*
UnitBuff_Test 指令说明：

基础旧用例：
- 输入 s1~s5：无敌/一次无敌窗口测试。
- 输入 s6~s10：时间破防、永久破防、冲突位与刷新测试。
- 输入 s11~s16、s18：眩晕、抗性、免疫、清除、CD 与禁用 CD 测试。
- 输入 s19：StartTimerBuff 外部存参和回调清理测试。

本次新增用例：
- 输入 s20：创建测试单位，沉默 3 秒；立即检查 IsUnitSilenced 为 true，3.4 秒后检查自动清除。
- 输入 s21：创建测试单位，沉默 3 秒后立刻 ClearSilence；检查 IsUnitSilenced 为 false。
- 输入 s22：创建测试单位，缴械/禁用攻击 3 秒；立即检查 IsUnitDisarmed 为 true，3.4 秒后检查自动清除。
- 输入 s23：创建测试单位，缴械/禁用攻击 3 秒后立刻 ClearDisarm；检查 IsUnitDisarmed 为 false。

手动选中单位测试：
- 输入 -silence 3：对当前选中单位沉默 3 秒。
- 输入 -clearsilence：清除当前选中单位沉默。
- 输入 -disarm 3：对当前选中单位缴械/禁用攻击 3 秒。
- 输入 -cleardisarm：清除当前选中单位缴械。
- 输入 -buffstate：查询当前选中单位是否沉默、是否缴械。

开局测试场景：
- 自动创建 1 个玩家1大魔法师，额外添加多种技能，并默认选中。
- 自动创建 10 个玩家2敌方农民，方便测试沉默后技能栏变化、缴械后攻击行为。
*/

// 用原始地图测试
#undef OriginMapUnitTestMode


//# dependency:resource/ui/console/unitpanel/yidu_str.blp
//# dependency:resource/ui/console/unitpanel/yidu_agi.blp
//# dependency:resource/ui/console/unitpanel/yidu_int.blp
//# dependency:resource/ui/console/unitpanel/yidu_Atk.blp
//# dependency:resource/ui/console/unitpanel/yidu_Def.blp


//! zinc


//自动生成的文件
library UTUnitBuff requires UnitBuff {

    // 眩晕测试用单位记录，避免重复创建导致多选
    private unit stunTestUnits[];
    private unit manualTestHero = null;
    private unit manualTestEnemies[];

    private function SetStunTestUnit(integer idx, unit u) {
        if (stunTestUnits[idx] != null) {
            RemoveUnit(stunTestUnits[idx]);
            stunTestUnits[idx] = null;
        }
        stunTestUnits[idx] = u;
    }

    private function CreateManualTestScene() {
        player owner; player enemyOwner; unit u; integer i; real x; real y;

        owner = Player(0);
        enemyOwner = Player(1);

        if (manualTestHero != null) {
            RemoveUnit(manualTestHero);
            manualTestHero = null;
        }
        for (1 <= i <= 10) {
            if (manualTestEnemies[i] != null) {
                RemoveUnit(manualTestEnemies[i]);
                manualTestEnemies[i] = null;
            }
        }

        manualTestHero = CreateUnit(owner, 'Hamg', 0.0, 0.0, 270.0);
        SetHeroLevel(manualTestHero, 10, false);
        UnitAddAbility(manualTestHero, 'AHbz'); // 暴风雪
        UnitAddAbility(manualTestHero, 'AHwe'); // 水元素
        UnitAddAbility(manualTestHero, 'AHab'); // 辉煌光环
        UnitAddAbility(manualTestHero, 'AHmt'); // 群体传送
        UnitAddAbility(manualTestHero, 'ACbc'); // 火焰呼吸
        UnitAddAbility(manualTestHero, 'ACbf'); // 霜冻闪电
        UnitAddAbility(manualTestHero, 'ACpy'); // 变形术
        UnitAddAbility(manualTestHero, 'AOhx'); // 妖术
        UnitAddAbility(manualTestHero, 'ACdv'); // 吞噬
        UnitAddAbility(manualTestHero, 'ACen'); // 诱捕
        UnitAddAbility(manualTestHero, 'ANr3'); // 混乱之雨
        UnitAddAbility(manualTestHero, 'AOhw'); // 医疗波
        SelectUnit(manualTestHero, true);

        for (1 <= i <= 10) {
            x = 450.0 + I2R(ModuloInteger(i - 1, 5)) * 120.0;
            y = -240.0 + I2R((i - 1) / 5) * 160.0;
            u = CreateUnit(enemyOwner, 'hpea', x, y, 270.0);
            manualTestEnemies[i] = u;
            u = null;
        }

        BJDebugMsg("[UnitBuffTest] 已创建测试场景：玩家1大魔法师(多技能) + 玩家2敌方农民x10");
        BJDebugMsg("[UnitBuffTest] 默认已选中大魔法师，可直接输入 -silence 5 / -disarm 5 / -buffstate");

        owner = null;
        enemyOwner = null;
    }

    // 沉默/缴械测试检查回调（使用 hashtable 传参，避免闭包捕获）
    private function DisableDebuffTestCheck() {
        timer t; integer id; integer mode; unit u;

        t = GetExpiredTimer();
        id = GetHandleId(t);
        mode = LoadInteger(HASH_TIMER, id, 2);
        u = LoadUnitHandle(HASH_TIMER, id, 1);

        if (mode == 20) {
            if (IsUnitSilenced(u)) {
                BJDebugMsg("|cFFFF0000[UnitBuffTest] s20 失败：沉默未自动清理|r");
            } else {
                BJDebugMsg("[UnitBuffTest] s20 完成：沉默已自动清理");
            }
        } else if (mode == 22) {
            if (IsUnitDisarmed(u)) {
                BJDebugMsg("|cFFFF0000[UnitBuffTest] s22 失败：缴械未自动清理|r");
            } else {
                BJDebugMsg("[UnitBuffTest] s22 完成：缴械已自动清理");
            }
        }

        FlushChildHashtable(HASH_TIMER, id);
        PauseTimer(t);
        DestroyTimer(t);
        u = null;
        t = null;
    }

    // 眩晕测试检查回调（使用 hashtable 传参，避免闭包捕获）
    private function StunTestCheck() {
        timer t; integer id; integer mode; unit u; real left;

        t = GetExpiredTimer();
        id = GetHandleId(t);
        mode = LoadInteger(HASH_TIMER, id, 2);
        u = LoadUnitHandle(HASH_TIMER, id, 1);

        if (mode == 11) {
            if (HaveSavedReal(HASH_UNIT, GetHandleId(u), KEY_UNIT_PAUSE_TIME_LEFT)) {
                BJDebugMsg("|cFFFF0000[UnitBuffTest] s11 失败：眩晕未清理|r");
            } else {
                BJDebugMsg("[UnitBuffTest] s11 完成：眩晕已清理");
            }
        } else if (mode == 12) {
            if (HaveSavedReal(HASH_UNIT, GetHandleId(u), KEY_UNIT_PAUSE_TIME_LEFT)) {
                left = LoadReal(HASH_UNIT, GetHandleId(u), KEY_UNIT_PAUSE_TIME_LEFT);
                BJDebugMsg("|cFFFF0000[UnitBuffTest] s12 失败：抗性未生效，剩余 " + R2S(left) + "|r");
            } else {
                BJDebugMsg("[UnitBuffTest] s12 完成：约 1 秒后已清理眩晕");
            }
        }

        FlushChildHashtable(HASH_TIMER, id);
        PauseTimer(t);
        DestroyTimer(t);
        u = null;
        t = null;
    }

	function Init () {
        CreateManualTestScene();
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);
	}

	// 测试1：ImmuteDamageTime 基本功能
	function TTestUTUnitBuff1 (player p) {
		unit u; player owner;

		owner = GetTriggerPlayer();
		u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
		SelectUnit(u, true);
		BJDebugMsg("[UnitBuffTest] s1: 给单位添加2秒无敌（带特效）");
		ImmuteDamageTime(u, 2.0, true);
		BJDebugMsg("[UnitBuffTest] 单位应有 'Avul' 技能，2秒后自动移除");
		u = null;
		owner = null;
	}

	// 测试2：ImmuteDamageOnce 基本功能（0秒无敌窗）
	function TTestUTUnitBuff2 (player p) {
		unit u; player owner;

		owner = GetTriggerPlayer();
		u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
		SelectUnit(u, true);
		BJDebugMsg("[UnitBuffTest] s2: 给单位添加0秒无敌窗");
		ImmuteDamageOnce(u);
		BJDebugMsg("[UnitBuffTest] 单位应有 'Avul' 技能，0秒计时器立即移除");
		u = null;
		owner = null;
	}

	// 测试3：ImmuteDamageTime 叠加功能
	function TTestUTUnitBuff3 (player p) {
		unit u; player owner;

		owner = GetTriggerPlayer();
		u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
		SelectUnit(u, true);
		BJDebugMsg("[UnitBuffTest] s3: 先添加1秒无敌，再添加3秒无敌（应取最大值3秒）");
		ImmuteDamageTime(u, 1.0, false);
		ImmuteDamageTime(u, 3.0, false);
		BJDebugMsg("[UnitBuffTest] 单位应有 'Avul' 技能，3秒后自动移除（不会提前结束）");
		u = null;
		owner = null;
	}

	// 测试4：ImmuteDamageTime + ImmuteDamageOnce 同单位冲突测试
	function TTestUTUnitBuff4 (player p) {
		unit u; player owner;

		owner = GetTriggerPlayer();
		u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
		SelectUnit(u, true);
		BJDebugMsg("[UnitBuffTest] s4: 先添加2秒无敌，再调用Once（不应缩短时间）");
		ImmuteDamageTime(u, 2.0, false);
		ImmuteDamageOnce(u);
		BJDebugMsg("[UnitBuffTest] 单位应有 'Avul' 技能，仍应在2秒后移除（不会提前）");
		u = null;
		owner = null;
	}

	// 测试5：连续多次调用 ImmuteDamageOnce，队列清空后timer应停止
	function TTestUTUnitBuff5 (player p) {
		unit u1; unit u2; unit u3; player owner;

		owner = GetTriggerPlayer();
		u1 = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
		u2 = CreateUnit(owner, 'hpea', 100.0, 0.0, 0.0);
		u3 = CreateUnit(owner, 'hpea', 200.0, 0.0, 0.0);
		SelectUnit(u1, true);
		BJDebugMsg("[UnitBuffTest] s5: 给3个单位添加0秒无敌窗，然后等待队列清空");
		ImmuteDamageOnce(u1);
		ImmuteDamageOnce(u2);
		ImmuteDamageOnce(u3);
		BJDebugMsg("[UnitBuffTest] 3个单位应在0秒计时器后移除，队列清空后timer应自动停止");
		u1 = null;
		u2 = null;
		u3 = null;
		owner = null;
	}
	// 测试6：时间破防基本功能
	function TTestUTUnitBuff6 (player p) {
		unit u; player owner; real def;

		owner = GetTriggerPlayer();
		u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
		SelectUnit(u, true);
		def = GetUnitDefense(u);
		BJDebugMsg("[UnitBuffTest] s6: 给单位添加时间破防（slot=1, defense=10, time=3秒）");
		BJDebugMsg("[UnitBuffTest] 单位当前防御: " + R2S(def));
		ReduceDefenseTime(u, 1, 10, 3.0);
		BJDebugMsg("[UnitBuffTest] 单位应有破防特效，防御应减少10，3秒后自动恢复");
		u = null;
		owner = null;
	}

	// 测试7：冲突位机制 - 同一 slot 取最大值
	function TTestUTUnitBuff7 (player p) {
		unit u; player owner; real def;

		owner = GetTriggerPlayer();
		u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
		SelectUnit(u, true);
		def = GetUnitDefense(u);
		BJDebugMsg("[UnitBuffTest] s7: 同一 slot 取最大值测试（slot=1, 先10后20，应取20）");
		BJDebugMsg("[UnitBuffTest] 单位当前防御: " + R2S(def));
		ReduceDefenseTime(u, 1, 10, 3.0);
		BJDebugMsg("[UnitBuffTest] 第一次：破防10，防御应减少10");
		ReduceDefenseTime(u, 1, 20, 3.0);
		BJDebugMsg("[UnitBuffTest] 第二次：破防20（最大值），防御应再减少10（总共减少20）");
		BJDebugMsg("[UnitBuffTest] 3秒后防御应恢复20");
		u = null;
		owner = null;
	}

	// 测试8：不同 slot 独立存在
	function TTestUTUnitBuff8 (player p) {
		unit u; player owner; real def;

		owner = GetTriggerPlayer();
		u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
		SelectUnit(u, true);
		def = GetUnitDefense(u);
		BJDebugMsg("[UnitBuffTest] s8: 不同 slot 独立测试（slot=1和slot=2同时存在）");
		BJDebugMsg("[UnitBuffTest] 单位当前防御: " + R2S(def));
		ReduceDefenseTime(u, 1, 10, 3.0);
		BJDebugMsg("[UnitBuffTest] slot=1: 破防10，防御应减少10");
		ReduceDefenseTime(u, 2, 15, 2.0);
		BJDebugMsg("[UnitBuffTest] slot=2: 破防15，防御应再减少15（总共减少25）");
		BJDebugMsg("[UnitBuffTest] slot=2的2秒后恢复15，slot=1的3秒后恢复10");
		u = null;
		owner = null;
	}

	// 测试9：剩余时间刷新机制（取最大值）
	function TTestUTUnitBuff9 (player p) {
		unit u; player owner; real def;

		owner = GetTriggerPlayer();
		u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
		SelectUnit(u, true);
		def = GetUnitDefense(u);
		BJDebugMsg("[UnitBuffTest] s9: 剩余时间刷新测试（先3秒，再刷新到5秒，应取最大值5秒）");
		BJDebugMsg("[UnitBuffTest] 单位当前防御: " + R2S(def));
		ReduceDefenseTime(u, 1, 10, 3.0);
		BJDebugMsg("[UnitBuffTest] 第一次：破防10，剩余时间3秒");
		ReduceDefenseTime(u, 1, 10, 5.0);
		BJDebugMsg("[UnitBuffTest] 第二次：刷新剩余时间为5秒（取最大值），防御不变");
		BJDebugMsg("[UnitBuffTest] 5秒后防御应恢复10");
		u = null;
		owner = null;
	}

	// 测试10：永久破防功能
	function TTestUTUnitBuff10 (player p) {
		unit u; player owner; real def;

		owner = GetTriggerPlayer();
		u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
		SelectUnit(u, true);
		def = GetUnitDefense(u);
		BJDebugMsg("[UnitBuffTest] s10: 永久破防测试（slot=1, defense=15）");
		BJDebugMsg("[UnitBuffTest] 单位当前防御: " + R2S(def));
		ReduceDefenseForever(u, 1, 15);
		BJDebugMsg("[UnitBuffTest] 单位应有破防特效，防御应减少15，永久生效");
		ReduceDefenseForever(u, 1, 20);
		BJDebugMsg("[UnitBuffTest] 再次调用（最大值20），防御应再减少5（总共减少20）");
		u = null;
		owner = null;
	}

    // 测试11：基础眩晕 2 秒（带特效）
    function TTestUTUnitBuff11 (player p) {
        unit u; player owner;
        timer t; integer tid;

        owner = GetTriggerPlayer();
        u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
        SetStunTestUnit(1, u);
        SelectUnit(u, true);
        BJDebugMsg("[UnitBuffTest] s11: 眩晕 2 秒，带特效");
        StunUnit(u, 2.0, "overhead", "Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl");

        t = CreateTimer();
        tid = GetHandleId(t);
        SaveUnitHandle(HASH_TIMER, tid, 1, u);
        SaveInteger(HASH_TIMER, tid, 2, 11);
        TimerStart(t, 2.5, false, function () {
            StunTestCheck();
        });
        t = null;
        u = null;
        owner = null;
    }

    // 测试12：眩晕抗性缩短时长
    function TTestUTUnitBuff12 (player p) {
        unit u; player owner; real left;
        timer t; integer tid;

        owner = GetTriggerPlayer();
        u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
        SetStunTestUnit(2, u);
        SelectUnit(u, true);
        AddUnitStunResistUp(u, 0.5);
        BJDebugMsg("[UnitBuffTest] s12: 眩晕 2 秒，抗性 0.5，应约 1 秒结束");
        StunUnit(u, 2.0, "overhead", "Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl");

        t = CreateTimer();
        tid = GetHandleId(t);
        SaveUnitHandle(HASH_TIMER, tid, 1, u);
        SaveInteger(HASH_TIMER, tid, 2, 12);
        TimerStart(t, 1.5, false, function () {
            StunTestCheck();
        });
        t = null;
        u = null;
        owner = null;
    }

    // 测试13：眩晕免疫直接跳过
    function TTestUTUnitBuff13 (player p) {
        unit u; player owner;

        owner = GetTriggerPlayer();
        u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
        SelectUnit(u, true);
        SetUnitStunImmune(u, true);
        BJDebugMsg("[UnitBuffTest] s13: 设置眩晕免疫后调用 PauseUnitEx，应跳过");
        StunUnit(u, 2.0, "overhead", "Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl");
        if (HaveSavedReal(HASH_UNIT, GetHandleId(u), KEY_UNIT_PAUSE_TIME_LEFT)) {
            BJDebugMsg("|cFFFF0000[UnitBuffTest] s13 失败：仍然保存了眩晕时间|r");
        } else {
            BJDebugMsg("[UnitBuffTest] s13 完成：未保存眩晕时间，免疫生效");
        }
        u = null;
        owner = null;
    }

    // 测试14：魔免跳过测试
    function TTestUTUnitBuff14 (player p) {
        unit u; player owner;

        owner = GetTriggerPlayer();
        u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
        SetStunTestUnit(3, u);
        SelectUnit(u, true);
        // 添加魔免技能
        if (GetUnitAbilityLevel(u, 'Amim') == 0 && GetUnitAbilityLevel(u, MAGIC_IMMUNITY_SPELL_ID) == 0) {
            UnitAddAbility(u, 'Amim');
        }
        BJDebugMsg("[UnitBuffTest] s14: 设置魔免后调用 StunUnit，应跳过");
        StunUnit(u, 2.0, "overhead", "Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl");
        if (HaveSavedReal(HASH_UNIT, GetHandleId(u), KEY_UNIT_PAUSE_TIME_LEFT)) {
            BJDebugMsg("|cFFFF0000[UnitBuffTest] s14 失败：仍然保存了眩晕时间|r");
        } else {
            BJDebugMsg("[UnitBuffTest] s14 完成：未保存眩晕时间，魔免生效");
        }
        u = null;
        owner = null;
    }

    // 测试15：ClearStun 立即解除测试
    function TTestUTUnitBuff15 (player p) {
        unit u; player owner;

        owner = GetTriggerPlayer();
        u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
        SetStunTestUnit(4, u);
        SelectUnit(u, true);
        BJDebugMsg("[UnitBuffTest] s15: 眩晕 2 秒后立即 ClearStun");
        StunUnit(u, 2.0, "overhead", "Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl");
        if (IsUnitStunning(u)) {
            BJDebugMsg("[UnitBuffTest] 眩晕已应用");
        } else {
            BJDebugMsg("|cFFFF0000[UnitBuffTest] s15 失败：眩晕未应用|r");
            u = null;
            owner = null;
            return;
        }
        ClearStun(u);
        if (IsUnitStunning(u)) {
            BJDebugMsg("|cFFFF0000[UnitBuffTest] s15 失败：ClearStun 后仍然眩晕|r");
        } else {
            BJDebugMsg("[UnitBuffTest] s15 完成：ClearStun 立即解除眩晕");
        }
        if (HaveSavedReal(HASH_UNIT, GetHandleId(u), KEY_UNIT_PAUSE_TIME_LEFT)) {
            BJDebugMsg("|cFFFF0000[UnitBuffTest] s15 失败：时间键位未清理|r");
        } else {
            BJDebugMsg("[UnitBuffTest] s15 完成：时间键位已清理");
        }
        u = null;
        owner = null;
    }

    // 测试16：CD 阻挡测试
    function TTestUTUnitBuff16 (player p) {
        unit u; player owner; timer t; integer tid; real cdLeft; real timeLeft;

        owner = GetTriggerPlayer();
        u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
        SetStunTestUnit(5, u);
        SelectUnit(u, true);
        Trace("[UnitBuffTest] s16: 眩晕 0.5 秒后立即再眩晕 2.0 秒，应被CD阻挡");
        StunUnit(u, 0.5, "overhead", "Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl");
        Trace("[UnitBuffTest] 第一次眩晕已应用（0.5秒）");
        // 立即再次眩晕，应被CD阻挡
        StunUnit(u, 2.0, "overhead", "Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl");
        timeLeft = LoadReal(HASH_UNIT, GetHandleId(u), KEY_UNIT_PAUSE_TIME_LEFT);
        if (timeLeft > 0.4 && timeLeft < 0.6) {
            Trace("[UnitBuffTest] 第二次眩晕被阻挡，剩余时间仍为 " + R2S(timeLeft) + "（接近0.5）");
        } else {
            Trace("|cFFFF0000[UnitBuffTest] s16 失败：第二次眩晕未被阻挡，剩余时间 " + R2S(timeLeft) + "|r");
        }
        // 检查CD是否已设置
        if (HaveSavedReal(HASH_UNIT, GetHandleId(u), KEY_UNIT_STUN_CD_LEFT)) {
            cdLeft = LoadReal(HASH_UNIT, GetHandleId(u), KEY_UNIT_STUN_CD_LEFT);
            Trace("[UnitBuffTest] CD已设置，剩余 " + R2S(cdLeft) + " 秒（应为约5秒）");
        } else {
            Trace("|cFFFF0000[UnitBuffTest] s16 失败：CD未设置|r");
        }

        // 等待CD结束后再次眩晕应生效
        t = CreateTimer();
        tid = GetHandleId(t);
        SaveUnitHandle(HASH_TIMER, tid, 1, u);
        SaveInteger(HASH_TIMER, tid, 2, 16);
        TimerStart(t, 6.0, false, function () {
            timer t; integer id; unit u; real timeLeft;

            t = GetExpiredTimer();
            id = GetHandleId(t);
            u = LoadUnitHandle(HASH_TIMER, id, 1);

            if (u != null) {
                // CD应已结束，再次眩晕应生效
                StunUnit(u, 5, "overhead", "Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl");
                timeLeft = LoadReal(HASH_UNIT, GetHandleId(u), KEY_UNIT_PAUSE_TIME_LEFT);
                if (timeLeft > 4.9 && timeLeft < 5.1) {
                    Trace("[UnitBuffTest] s16 完成：CD结束后再次眩晕生效，剩余时间 " + R2S(timeLeft));
                } else {
                    Trace("|cFFFF0000[UnitBuffTest] s16 失败：CD结束后眩晕未生效，剩余时间 " + R2S(timeLeft) + "|r");
                }
            }

            FlushChildHashtable(HASH_TIMER, id);
            PauseTimer(t);
            DestroyTimer(t);
            u = null;
            t = null;
        });
        t = null;
        u = null;
        owner = null;
    }

    // 测试19：StartTimerBuff 基本功能 - 外部存参，回调中读取
    function TTestUTUnitBuff19 (player p) {
        unit u; player owner; timer bt; timer checkT; integer checkId;

        owner = GetTriggerPlayer();
        u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
        SelectUnit(u, true);
        BJDebugMsg("[UnitBuffTest] s19: StartTimerBuff 测试 - 外部存参，回调中读取");

        // 创建定时器 BUFF，回调中读取外部存储的参数
        bt = StartTimerBuff(u, 2.30, function () -> boolean {
            timer t; integer id; integer v;

            t = TimerBuffQueue.getExpireTimer();
            id = GetHandleId(t);
            v = LoadInteger(HASH_TIMER, id, 100);

            BJDebugMsg("内部测试了");
            if (v == 100000) {
                BJDebugMsg("[UnitBuffTest] s19 完成：回调中成功读取到外部存储的参数 " + I2S(v));
            } else {
                BJDebugMsg("|cFFFF0000[UnitBuffTest] s19 失败：回调中读取的参数不正确，期望 100000，实际 " + I2S(v) + "|r");
            }

            t = null;
            return true;
        });

        if (bt == null) {
            BJDebugMsg("|cFFFF0000[UnitBuffTest] s19 失败：StartTimerBuff 返回 null|r");
            u = null;
            owner = null;
            return;
        }

        // 外部存储参数到返回的 timer
        SaveInteger(HASH_TIMER, GetHandleId(bt), 100, 100000);
        BJDebugMsg("[UnitBuffTest] 已存储参数到 timer，键=100，值=100000");

        // 0.6 秒后检查清理是否生效
        checkT = CreateTimer();
        checkId = GetHandleId(checkT);
        SaveTimerHandle(HASH_TIMER, checkId, 1, bt);
        TimerStart(checkT, 2.4, false, function () {
            timer t; integer id; timer bt; boolean hasData;

            t = GetExpiredTimer();
            id = GetHandleId(t);
            bt = LoadTimerHandle(HASH_TIMER, id, 1);

            if (bt != null) {
                hasData = HaveSavedInteger(HASH_TIMER, GetHandleId(bt), 100);
                if (!hasData) {
                    BJDebugMsg("[UnitBuffTest] s19 完成：回调执行后，HASH_TIMER 数据已清理");
                } else {
                    BJDebugMsg("|cFFFF0000[UnitBuffTest] s19 警告：回调执行后，HASH_TIMER 数据未清理|r");
                }
            } else {
                BJDebugMsg("[UnitBuffTest] s19 完成：timer 已是null");
            }

            FlushChildHashtable(HASH_TIMER, id);
            PauseTimer(t);
            DestroyTimer(t);
            bt = null;
            t = null;
        });
        checkT = null;

        u = null;
        owner = null;
    }

    // 测试18：CD禁用测试 - SetUnitStunCdDisabled 置 true 后应允许连续眩晕
    function TTestUTUnitBuff18 (player p) {
        unit u; player owner; real timeLeft; real cdLeft;

        owner = GetTriggerPlayer();
        u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
        SetStunTestUnit(6, u);
        SelectUnit(u, true);
        BJDebugMsg("[UnitBuffTest] s18: 设置CD禁用后，连续眩晕应不被阻挡");

        // 先设置CD禁用（在第一次眩晕之前）
        SetUnitStunCdDisabled(u, true);
        BJDebugMsg("[UnitBuffTest] CD已禁用");

        // 第一次眩晕 0.5 秒（CD被禁用，所以不会设置CD）
        StunUnit(u, 0.5, "overhead", "Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl");
        BJDebugMsg("[UnitBuffTest] 第一次眩晕已应用（0.5秒）");

        // 检查CD是否未设置（因为CD被禁用，所以不应该设置CD）
        if (HaveSavedReal(HASH_UNIT, GetHandleId(u), KEY_UNIT_STUN_CD_LEFT)) {
            cdLeft = LoadReal(HASH_UNIT, GetHandleId(u), KEY_UNIT_STUN_CD_LEFT);
            BJDebugMsg("|cFFFF0000[UnitBuffTest] s18 失败：CD被禁用时不应设置CD，但检测到CD剩余 " + R2S(cdLeft) + " 秒|r");
        } else {
            BJDebugMsg("[UnitBuffTest] CD未设置（符合预期，因为CD被禁用）");
        }

        // 立即再次眩晕 2.0 秒，应不被CD阻挡（因为CD已禁用）
        StunUnit(u, 2.0, "overhead", "Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl");
        timeLeft = LoadReal(HASH_UNIT, GetHandleId(u), KEY_UNIT_PAUSE_TIME_LEFT);

        // 验证第二次眩晕生效（剩余时间应为2.0秒，取最大值）
        if (timeLeft > 1.9 && timeLeft < 2.1) {
            BJDebugMsg("[UnitBuffTest] 第二次眩晕生效，剩余时间 " + R2S(timeLeft) + "（应为2.0秒，取最大值）");
        } else {
            BJDebugMsg("|cFFFF0000[UnitBuffTest] s18 失败：第二次眩晕未生效或被阻挡，剩余时间 " + R2S(timeLeft) + "|r");
        }

        // 验证CD仍然未设置（因为CD被禁用，所以不应该设置CD）
        if (HaveSavedReal(HASH_UNIT, GetHandleId(u), KEY_UNIT_STUN_CD_LEFT)) {
            cdLeft = LoadReal(HASH_UNIT, GetHandleId(u), KEY_UNIT_STUN_CD_LEFT);
            BJDebugMsg("|cFFFF0000[UnitBuffTest] s18 失败：CD被禁用时不应设置CD，但检测到CD剩余 " + R2S(cdLeft) + " 秒|r");
        } else {
            BJDebugMsg("[UnitBuffTest] CD仍然未设置（符合预期）");
        }

        BJDebugMsg("[UnitBuffTest] s18 完成：CD禁用后连续眩晕正常工作");
        u = null;
        owner = null;
    }

    // 测试20：沉默 3 秒并自动清理
    function TTestUTUnitBuff20 (player p) {
        unit u; player owner; timer t; integer tid;

        owner = GetTriggerPlayer();
        u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
        SetStunTestUnit(7, u);
        SelectUnit(u, true);
        BJDebugMsg("[UnitBuffTest] s20: 沉默 3 秒，使用原生沉默特效 overhead");
        SilenceUnit(u, 3.0);
        if (IsUnitSilenced(u)) {
            BJDebugMsg("[UnitBuffTest] 沉默已应用，IsUnitSilenced=true");
        } else {
            BJDebugMsg("|cFFFF0000[UnitBuffTest] s20 失败：沉默未应用|r");
        }

        t = CreateTimer();
        tid = GetHandleId(t);
        SaveUnitHandle(HASH_TIMER, tid, 1, u);
        SaveInteger(HASH_TIMER, tid, 2, 20);
        TimerStart(t, 3.4, false, function () {
            DisableDebuffTestCheck();
        });
        t = null;
        u = null;
        owner = null;
    }

    // 测试21：ClearSilence 立即清除沉默
    function TTestUTUnitBuff21 (player p) {
        unit u; player owner;

        owner = GetTriggerPlayer();
        u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
        SetStunTestUnit(8, u);
        SelectUnit(u, true);
        BJDebugMsg("[UnitBuffTest] s21: 沉默 3 秒后立即 ClearSilence");
        SilenceUnit(u, 3.0);
        if (IsUnitSilenced(u)) {
            BJDebugMsg("[UnitBuffTest] 沉默已应用");
        } else {
            BJDebugMsg("|cFFFF0000[UnitBuffTest] s21 失败：沉默未应用|r");
        }
        ClearSilence(u);
        if (IsUnitSilenced(u)) {
            BJDebugMsg("|cFFFF0000[UnitBuffTest] s21 失败：ClearSilence 后仍然沉默|r");
        } else {
            BJDebugMsg("[UnitBuffTest] s21 完成：ClearSilence 立即解除沉默");
        }
        u = null;
        owner = null;
    }

    // 测试22：缴械 3 秒并自动清理
    function TTestUTUnitBuff22 (player p) {
        unit u; player owner; timer t; integer tid;

        owner = GetTriggerPlayer();
        u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
        SetStunTestUnit(9, u);
        SelectUnit(u, true);
        BJDebugMsg("[UnitBuffTest] s22: 缴械/禁用攻击 3 秒，使用原生沉默特效 overhead");
        DisarmUnit(u, 3.0);
        if (IsUnitDisarmed(u)) {
            BJDebugMsg("[UnitBuffTest] 缴械已应用，IsUnitDisarmed=true");
        } else {
            BJDebugMsg("|cFFFF0000[UnitBuffTest] s22 失败：缴械未应用|r");
        }

        t = CreateTimer();
        tid = GetHandleId(t);
        SaveUnitHandle(HASH_TIMER, tid, 1, u);
        SaveInteger(HASH_TIMER, tid, 2, 22);
        TimerStart(t, 3.4, false, function () {
            DisableDebuffTestCheck();
        });
        t = null;
        u = null;
        owner = null;
    }

    // 测试23：ClearDisarm 立即清除缴械
    function TTestUTUnitBuff23 (player p) {
        unit u; player owner;

        owner = GetTriggerPlayer();
        u = CreateUnit(owner, 'hpea', 0.0, 0.0, 0.0);
        SetStunTestUnit(10, u);
        SelectUnit(u, true);
        BJDebugMsg("[UnitBuffTest] s23: 缴械 3 秒后立即 ClearDisarm");
        DisarmUnit(u, 3.0);
        if (IsUnitDisarmed(u)) {
            BJDebugMsg("[UnitBuffTest] 缴械已应用");
        } else {
            BJDebugMsg("|cFFFF0000[UnitBuffTest] s23 失败：缴械未应用|r");
        }
        ClearDisarm(u);
        if (IsUnitDisarmed(u)) {
            BJDebugMsg("|cFFFF0000[UnitBuffTest] s23 失败：ClearDisarm 后仍然缴械|r");
        } else {
            BJDebugMsg("[UnitBuffTest] s23 完成：ClearDisarm 立即解除缴械");
        }
        u = null;
        owner = null;
    }

	function TTestActUTUnitBuff1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R
		unit u; real def; real duration;
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

		if (paramS[0] == "reduce") {
			// 测试时间破防: -reduce slot defense time
			// 示例: -reduce 1 10 3.0
			if (num >= 3) {
				u = unitSelect.currentU[index];
				if (u != null) {
					def = GetUnitDefense(u);
					BJDebugMsg("[UnitBuffTest] 时间破防测试: slot=" + I2S(paramI[1]) + ", defense=" + I2S(paramI[2]) + ", time=" + R2S(paramR[3]));
					BJDebugMsg("[UnitBuffTest] 单位当前防御: " + R2S(def));
					ReduceDefenseTime(u, paramI[1], paramI[2], paramR[3]);
					BJDebugMsg("[UnitBuffTest] 破防已应用");
				} else {
					BJDebugMsg("[UnitBuffTest] 错误: 请先选择一个单位");
				}
				u = null;
			} else {
				BJDebugMsg("[UnitBuffTest] 用法: -reduce slot defense time");
				BJDebugMsg("[UnitBuffTest] 示例: -reduce 1 10 3.0");
			}
		} else if (paramS[0] == "reduceP") {
			// 测试永久破防: -reduceP slot defense
			// 示例: -reduceP 1 15
			if (num >= 2) {
				u = unitSelect.currentU[index];
				if (u != null) {
					def = GetUnitDefense(u);
					BJDebugMsg("[UnitBuffTest] 永久破防测试: slot=" + I2S(paramI[1]) + ", defense=" + I2S(paramI[2]));
					BJDebugMsg("[UnitBuffTest] 单位当前防御: " + R2S(def));
					ReduceDefenseForever(u, paramI[1], paramI[2]);
					BJDebugMsg("[UnitBuffTest] 永久破防已应用");
				} else {
					BJDebugMsg("[UnitBuffTest] 错误: 请先选择一个单位");
				}
				u = null;
			} else {
				BJDebugMsg("[UnitBuffTest] 用法: -reduceP slot defense");
				BJDebugMsg("[UnitBuffTest] 示例: -reduceP 1 15");
			}
		} else if (paramS[0] == "pause") {
			// 测试暂停单位: -pause
			u = unitSelect.currentU[index];
			if (u != null) {
				EXPauseUnit(u, true);
				BJDebugMsg("[UnitBuffTest] 单位已暂停");
			} else {
				BJDebugMsg("[UnitBuffTest] 错误: 请先选择一个单位");
			}
			u = null;
		} else if (paramS[0] == "restore") {
			// 测试恢复单位: -restore
			u = unitSelect.currentU[index];
			if (u != null) {
				EXPauseUnit(u, false);
				BJDebugMsg("[UnitBuffTest] 单位已恢复");
			} else {
				BJDebugMsg("[UnitBuffTest] 错误: 请先选择一个单位");
			}
			u = null;
		} else if (paramS[0] == "silence") {
			// 测试沉默单位: -silence 3
			u = unitSelect.currentU[index];
			duration = 3.0;
			if (num >= 2) { duration = paramR[1]; }
			if (u != null && duration > 0.0) {
				SilenceUnit(u, duration);
				BJDebugMsg("[UnitBuffTest] 已沉默当前选中单位，持续 " + R2S(duration) + " 秒");
			} else if (u == null) {
				BJDebugMsg("[UnitBuffTest] 错误: 请先选择一个单位");
			} else {
				BJDebugMsg("[UnitBuffTest] 用法: -silence 3");
			}
			u = null;
		} else if (paramS[0] == "clearsilence") {
			// 清除沉默: -clearsilence
			u = unitSelect.currentU[index];
			if (u != null) {
				ClearSilence(u);
				BJDebugMsg("[UnitBuffTest] 已清除当前选中单位沉默");
			} else {
				BJDebugMsg("[UnitBuffTest] 错误: 请先选择一个单位");
			}
			u = null;
		} else if (paramS[0] == "disarm") {
			// 测试缴械单位: -disarm 3
			u = unitSelect.currentU[index];
			duration = 3.0;
			if (num >= 2) { duration = paramR[1]; }
			if (u != null && duration > 0.0) {
				DisarmUnit(u, duration);
				BJDebugMsg("[UnitBuffTest] 已缴械/禁用攻击当前选中单位，持续 " + R2S(duration) + " 秒");
			} else if (u == null) {
				BJDebugMsg("[UnitBuffTest] 错误: 请先选择一个单位");
			} else {
				BJDebugMsg("[UnitBuffTest] 用法: -disarm 3");
			}
			u = null;
		} else if (paramS[0] == "cleardisarm") {
			// 清除缴械: -cleardisarm
			u = unitSelect.currentU[index];
			if (u != null) {
				ClearDisarm(u);
				BJDebugMsg("[UnitBuffTest] 已清除当前选中单位缴械");
			} else {
				BJDebugMsg("[UnitBuffTest] 错误: 请先选择一个单位");
			}
			u = null;
		} else if (paramS[0] == "buffstate") {
			// 查询当前选中单位状态: -buffstate
			u = unitSelect.currentU[index];
			if (u != null) {
				BJDebugMsg("[UnitBuffTest] IsUnitSilenced=" + B2S(IsUnitSilenced(u)) + ", IsUnitDisarmed=" + B2S(IsUnitDisarmed(u)));
			} else {
				BJDebugMsg("[UnitBuffTest] 错误: 请先选择一个单位");
			}
			u = null;
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[UnitBuff] 单元测试已加载");
			BJDebugMsg("[UnitBuffTest] 输入 s20/s21 测沉默自动清理/手动清除");
			BJDebugMsg("[UnitBuffTest] 输入 s22/s23 测缴械自动清理/手动清除");
			BJDebugMsg("[UnitBuffTest] 选中单位后输入 -silence 3 / -disarm 3 / -clearsilence / -cleardisarm / -buffstate");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitBuff1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitBuff1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitBuff2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitBuff3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitBuff4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitBuff5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitBuff6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitBuff7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitBuff8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitBuff9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitBuff10(GetTriggerPlayer());
            else if(str == "s11") TTestUTUnitBuff11(GetTriggerPlayer());
            else if(str == "s12") TTestUTUnitBuff12(GetTriggerPlayer());
            else if(str == "s13") TTestUTUnitBuff13(GetTriggerPlayer());
            else if(str == "s14") TTestUTUnitBuff14(GetTriggerPlayer());
            else if(str == "s15") TTestUTUnitBuff15(GetTriggerPlayer());
            else if(str == "s16") TTestUTUnitBuff16(GetTriggerPlayer());
            else if(str == "s18") TTestUTUnitBuff18(GetTriggerPlayer());
            else if(str == "s19") TTestUTUnitBuff19(GetTriggerPlayer());
            else if(str == "s20") TTestUTUnitBuff20(GetTriggerPlayer());
            else if(str == "s21") TTestUTUnitBuff21(GetTriggerPlayer());
            else if(str == "s22") TTestUTUnitBuff22(GetTriggerPlayer());
            else if(str == "s23") TTestUTUnitBuff23(GetTriggerPlayer());
		});

		//unitAttrShow
		//EXExecuteScript
		//YDWECoordinateY
		// EXPauseUnit
	}

}
//! endzinc

#endif
