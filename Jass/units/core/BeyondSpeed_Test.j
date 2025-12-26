#ifndef UTBeyondSpeedIncluded
#define UTBeyondSpeedIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTBeyondSpeed requires BeyondSpeed, UnitTestFramwork {

    // 测试用单位记录
    private unit testUnits[];

    private function GetTestUnit(integer idx) -> unit {
        if (idx < 1 || idx > 3) { return null; }
        return testUnits[idx];
    }

    private function SetTestUnit(integer idx, unit u) {
        if (idx < 1 || idx > 3) { return; }
        if (testUnits[idx] != null) {
            RemoveUnit(testUnits[idx]);
            testUnits[idx] = null;
        }
        testUnits[idx] = u;
    }

	function Init () {
		player p; unit u1; unit u2; unit u3; real startX; real startY;

		p = Player(0);
		startX = 0.0;
		startY = 0.0;

		// 创建3个测试单位
		u1 = CreateUnit(p, 'hpea', startX, startY, 0.0);
		u2 = CreateUnit(p, 'hpea', startX + 200.0, startY, 0.0);
		u3 = CreateUnit(p, 'hpea', startX + 400.0, startY, 0.0);

		SetTestUnit(1, u1);
		SetTestUnit(2, u2);
		SetTestUnit(3, u3);

		SelectUnit(u1, true);
		SelectUnit(u2, true);
		SelectUnit(u3, true);

		BJDebugMsg("|cFF00FF00[BeyondSpeed] 测试单位已创建（3个）|r");
		BJDebugMsg("|cFF00FF00[BeyondSpeed] 输入 s1-s10 进行测试|r");

		// 给单位1下达长距离移动指令
		IssuePointOrder(u1, "move", 5000.0, 0.0);
		IssuePointOrder(u2, "move", 5000.0, 0.0);
		IssuePointOrder(u3, "move", 5000.0, 0.0);

		p = null;
		u1 = null;
		u2 = null;
		u3 = null;
	}

	// 测试1：AddUnitSuperSpeed 基本功能
	function TTestUTBeyondSpeed1 (player p) {
		unit u; integer bonus;
		u = GetTestUnit(1);
		if (u == null) {
			BJDebugMsg("|cFFFF0000[BeyondSpeed] s1 失败：测试单位1不存在|r");
			return;
		}
		BJDebugMsg("[BeyondSpeed] s1: 给单位1添加 +200 加速");
		AddUnitSuperSpeed(u, 200);
		bonus = GetUnitSuperSpeed(u);
		assert.Integer(bonus, 200, "s1: 累计加速值应为 200");
		BJDebugMsg("[BeyondSpeed] 单位1应明显提速");
		u = null;
	}

	// 测试2：GetUnitSuperSpeed 查询功能
	function TTestUTBeyondSpeed2 (player p) {
		unit u; integer bonus;
		u = GetTestUnit(1);
		if (u == null) {
			BJDebugMsg("|cFFFF0000[BeyondSpeed] s2 失败：测试单位1不存在|r");
			return;
		}
		bonus = GetUnitSuperSpeed(u);
		BJDebugMsg("[BeyondSpeed] s2: 查询单位1的加速值 = " + I2S(bonus));
		assert.Integer(bonus, 200, "s2: 累计加速值应为 200");
		u = null;
	}

	// 测试3：SetUnitSuperSpeedEffect 设置特效路径
	function TTestUTBeyondSpeed3 (player p) {
		unit u;
		u = GetTestUnit(1);
		if (u == null) {
			BJDebugMsg("|cFFFF0000[BeyondSpeed] s3 失败：测试单位1不存在|r");
			return;
		}
		BJDebugMsg("[BeyondSpeed] s3: 给单位1设置残影特效");
		SetUnitSuperSpeedEffect(u, "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
		BJDebugMsg("[BeyondSpeed] 单位1移动时应显示残影特效");
		u = null;
	}

	// 测试4：SetUnitSuperSpeedEnable(false) 暂停补位移
	function TTestUTBeyondSpeed4 (player p) {
		unit u; integer bonus;
		u = GetTestUnit(1);
		if (u == null) {
			BJDebugMsg("|cFFFF0000[BeyondSpeed] s4 失败：测试单位1不存在|r");
			return;
		}
		BJDebugMsg("[BeyondSpeed] s4: 暂停单位1的超速补位移");
		SetUnitSuperSpeedEnable(u, false);
		bonus = GetUnitSuperSpeed(u);
		assert.Integer(bonus, 200, "s4: bonus 应保持不变");
		BJDebugMsg("[BeyondSpeed] 单位1速度应回落（不再补位移）");
		u = null;
	}

	// 测试5：SetUnitSuperSpeedEnable(true) 恢复补位移
	function TTestUTBeyondSpeed5 (player p) {
		unit u; integer bonus;
		u = GetTestUnit(1);
		if (u == null) {
			BJDebugMsg("|cFFFF0000[BeyondSpeed] s5 失败：测试单位1不存在|r");
			return;
		}
		BJDebugMsg("[BeyondSpeed] s5: 恢复单位1的超速补位移");
		SetUnitSuperSpeedEnable(u, true);
		bonus = GetUnitSuperSpeed(u);
		assert.Integer(bonus, 200, "s5: bonus 应保持不变");
		BJDebugMsg("[BeyondSpeed] 单位1应恢复提速");
		u = null;
	}

	// 测试6：AddUnitSuperSpeed 负值，清理
	function TTestUTBeyondSpeed6 (player p) {
		unit u; integer bonus;
		u = GetTestUnit(1);
		if (u == null) {
			BJDebugMsg("|cFFFF0000[BeyondSpeed] s6 失败：测试单位1不存在|r");
			return;
		}
		BJDebugMsg("[BeyondSpeed] s6: 给单位1添加 -200 加速（清零）");
		AddUnitSuperSpeed(u, -200);
		bonus = GetUnitSuperSpeed(u);
		assert.Integer(bonus, 0, "s6: 累计加速值应为 0");
		BJDebugMsg("[BeyondSpeed] 单位1应从队列移除，速度恢复正常");
		u = null;
	}

	// 测试7：多单位同时测试
	function TTestUTBeyondSpeed7 (player p) {
		unit u1; unit u2; unit u3;
		u1 = GetTestUnit(1);
		u2 = GetTestUnit(2);
		u3 = GetTestUnit(3);
		if (u1 == null || u2 == null || u3 == null) {
			BJDebugMsg("|cFFFF0000[BeyondSpeed] s7 失败：测试单位不存在|r");
			return;
		}
		BJDebugMsg("[BeyondSpeed] s7: 给3个单位分别添加不同加速值");
		AddUnitSuperSpeed(u1, 100);
		AddUnitSuperSpeed(u2, 200);
		AddUnitSuperSpeed(u3, 300);
		assert.Integer(GetUnitSuperSpeed(u1), 100, "s7: 单位1加速值应为 100");
		assert.Integer(GetUnitSuperSpeed(u2), 200, "s7: 单位2加速值应为 200");
		assert.Integer(GetUnitSuperSpeed(u3), 300, "s7: 单位3加速值应为 300");
		BJDebugMsg("[BeyondSpeed] 3个单位应同时提速");
		u1 = null;
		u2 = null;
		u3 = null;
	}

	// 测试8：累计加速测试
	function TTestUTBeyondSpeed8 (player p) {
		unit u; integer bonus;
		u = GetTestUnit(2);
		if (u == null) {
			BJDebugMsg("|cFFFF0000[BeyondSpeed] s8 失败：测试单位2不存在|r");
			return;
		}
		BJDebugMsg("[BeyondSpeed] s8: 给单位2再添加 +50 加速（累计）");
		AddUnitSuperSpeed(u, 50);
		bonus = GetUnitSuperSpeed(u);
		assert.Integer(bonus, 250, "s8: 累计加速值应为 250 (200+50)");
		BJDebugMsg("[BeyondSpeed] 单位2应进一步提速");
		u = null;
	}

	// 测试9：单位死亡/无效自动清理
	function TTestUTBeyondSpeed9 (player p) {
		unit u; integer bonus;
		u = GetTestUnit(3);
		if (u == null) {
			BJDebugMsg("|cFFFF0000[BeyondSpeed] s9 失败：测试单位3不存在|r");
			return;
		}
		BJDebugMsg("[BeyondSpeed] s9: 移除单位3，测试自动清理");
		bonus = GetUnitSuperSpeed(u);
		BJDebugMsg("[BeyondSpeed] 移除前加速值 = " + I2S(bonus));
		RemoveUnit(u);
		SetTestUnit(3, null);
		BJDebugMsg("[BeyondSpeed] 单位3已移除，应在下次 tick 时自动清理");
		u = null;
	}

	// 测试10：重新创建单位并测试
	function TTestUTBeyondSpeed10 (player p) {
		player owner; unit u; integer bonus;
		owner = GetTriggerPlayer();
		u = CreateUnit(owner, 'hpea', 0.0, 200.0, 0.0);
		SetTestUnit(1, u);
		SelectUnit(u, true);
		IssuePointOrder(u, "move", 5000.0, 200.0);
		BJDebugMsg("[BeyondSpeed] s10: 重新创建单位1并添加加速");
		AddUnitSuperSpeed(u, 150);
		SetUnitSuperSpeedEffect(u, "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
		bonus = GetUnitSuperSpeed(u);
		assert.Integer(bonus, 150, "s10: 累计加速值应为 150");
		BJDebugMsg("[BeyondSpeed] 新单位1应提速并显示特效");
		owner = null;
		u = null;
	}

	function TTestActUTBeyondSpeed1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R
		unit u; integer idx; integer delta;

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

		if (paramS[0] == "add") {
			// -add <unitIdx> <delta>
			if (num >= 3) {
				idx = paramI[1];
				delta = paramI[2];
				u = GetTestUnit(idx);
				if (u != null) {
					AddUnitSuperSpeed(u, delta);
					BJDebugMsg("[BeyondSpeed] 单位" + I2S(idx) + " 添加加速 " + I2S(delta) + "，当前值 = " + I2S(GetUnitSuperSpeed(u)));
				} else {
					BJDebugMsg("|cFFFF0000[BeyondSpeed] 单位" + I2S(idx) + "不存在|r");
				}
			}
		} else if (paramS[0] == "enable") {
			// -enable <unitIdx> <0|1>
			if (num >= 3) {
				idx = paramI[1];
				u = GetTestUnit(idx);
				if (u != null) {
					SetUnitSuperSpeedEnable(u, paramI[2] != 0);
					BJDebugMsg("[BeyondSpeed] 单位" + I2S(idx) + " 超速状态 = " + I2S(paramI[2]));
				} else {
					BJDebugMsg("|cFFFF0000[BeyondSpeed] 单位" + I2S(idx) + "不存在|r");
				}
			}
		} else if (paramS[0] == "get") {
			// -get <unitIdx>
			if (num >= 2) {
				idx = paramI[1];
				u = GetTestUnit(idx);
				if (u != null) {
					BJDebugMsg("[BeyondSpeed] 单位" + I2S(idx) + " 加速值 = " + I2S(GetUnitSuperSpeed(u)));
				} else {
					BJDebugMsg("|cFFFF0000[BeyondSpeed] 单位" + I2S(idx) + "不存在|r");
				}
			}
		}

		p = null;
		u = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[BeyondSpeed] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTBeyondSpeed1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTBeyondSpeed1(GetTriggerPlayer());
			else if(str == "s2") TTestUTBeyondSpeed2(GetTriggerPlayer());
			else if(str == "s3") TTestUTBeyondSpeed3(GetTriggerPlayer());
			else if(str == "s4") TTestUTBeyondSpeed4(GetTriggerPlayer());
			else if(str == "s5") TTestUTBeyondSpeed5(GetTriggerPlayer());
			else if(str == "s6") TTestUTBeyondSpeed6(GetTriggerPlayer());
			else if(str == "s7") TTestUTBeyondSpeed7(GetTriggerPlayer());
			else if(str == "s8") TTestUTBeyondSpeed8(GetTriggerPlayer());
			else if(str == "s9") TTestUTBeyondSpeed9(GetTriggerPlayer());
			else if(str == "s10") TTestUTBeyondSpeed10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
