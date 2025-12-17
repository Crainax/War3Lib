#ifndef UTUnitBuffIncluded
#define UTUnitBuffIncluded

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

	function Init () {
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
	function TTestActUTUnitBuff1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R
		unit u; real def;
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
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[UnitBuff] 单元测试已加载");
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
		});

		//unitAttrShow
		//EXExecuteScript
		//YDWECoordinateY
	}

}
//! endzinc

#endif
