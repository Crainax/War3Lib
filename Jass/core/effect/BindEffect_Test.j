#ifndef UTBindEffectIncluded
#define UTBindEffectIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTBindEffect requires BindEffect {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			BJDebugMsg("[BindEffect] 开始测试特效绑定系统");
			}, function() {
			//end,这里是2秒后调用的内容
			BJDebugMsg("[BindEffect] 测试完成");
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);
	}

	// 测试1：基本特效附加
	function TTestUTBindEffect1 (player p) {
		unit u;
		effect e;

		u = CreateUnit(p, 'hfoo', 0, 0, 0);
		if (u != null) {
			e = bindEffect.attachUnique(u, "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", "origin");
			if (e != null) {
				BJDebugMsg("[测试1] 成功附加特效到单位");
			} else {
				BJDebugMsg("[测试1] 特效附加失败");
			}
			u = null;
		}
	}

	// 测试2：同mdl特效替换
	function TTestUTBindEffect2 (player p) {
		unit u;
		effect e1, e2;

		u = CreateUnit(p, 'hfoo', 0, 0, 0);
		if (u != null) {
			e1 = bindEffect.attachUnique(u, "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", "origin");
			e2 = bindEffect.attachUnique(u, "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", "origin");

			if (e1 != e2) {
				BJDebugMsg("[测试2] 同mdl特效替换成功");
			} else {
				BJDebugMsg("[测试2] 同mdl特效替换失败");
			}
			u = null;
		}
	}

	// 测试3：特效分离
	function TTestUTBindEffect3 (player p) {
		unit u;
		effect e;

		u = CreateUnit(p, 'hfoo', 0, 0, 0);
		if (u != null) {
			e = bindEffect.attachUnique(u, "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", "origin");
			if (e != null) {
				bindEffect.detachUnique(u, "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl");
				BJDebugMsg("[测试3] 特效分离完成");
			}
			u = null;
		}
	}

	// 测试4：多个不同特效
	function TTestUTBindEffect4 (player p) {
		unit u;
		effect e1, e2, e3;

		u = CreateUnit(p, 'hfoo', 0, 0, 0);
		if (u != null) {
			e1 = bindEffect.attachUnique(u, "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", "origin");
			e2 = bindEffect.attachUnique(u, "Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl", "origin");
			e3 = bindEffect.attachUnique(u, "Abilities\\Spells\\Human\\Blizzard\\BlizzardTarget.mdl", "origin");

			if (e1 != null && e2 != null && e3 != null) {
				BJDebugMsg("[测试4] 成功附加3个不同特效");
			} else {
				BJDebugMsg("[测试4] 部分特效附加失败");
			}
			u = null;
		}
	}

	// 测试5：单位死亡自动清理
	function TTestUTBindEffect5 (player p) {
		unit u;
		effect e;

		u = CreateUnit(p, 'hfoo', 0, 0, 0);
		if (u != null) {
			e = bindEffect.attachUnique(u, "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", "origin");
			if (e != null) {
				BJDebugMsg("[测试5] 附加特效后杀死单位，测试自动清理");
				KillUnit(u);
				u = null;
			}
		}
	}

	function TTestUTBindEffect6 (player p) {
	}

	// 测试7：空单位处理
	function TTestUTBindEffect7 (player p) {
		effect e;

		e = bindEffect.attachUnique(null, "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", "origin");
		if (e == null) {
			BJDebugMsg("[测试7] 正确处理空单位");
		} else {
			BJDebugMsg("[测试7] 空单位处理失败");
		}
	}

	// 测试8：无效mdl路径
	function TTestUTBindEffect8 (player p) {
		unit u;
		effect e;

		u = CreateUnit(p, 'hfoo', 0, 0, 0);
		if (u != null) {
			e = bindEffect.attachUnique(u, "Invalid\\Path\\To\\Model.mdl", "origin");
			if (e == null) {
				BJDebugMsg("[测试8] 正确处理无效mdl路径");
			} else {
				BJDebugMsg("[测试8] 无效mdl路径处理异常");
			}
			u = null;
		}
	}

	// 测试9：分离不存在的特效
	function TTestUTBindEffect9 (player p) {
		unit u;

		u = CreateUnit(p, 'hfoo', 0, 0, 0);
		if (u != null) {
			bindEffect.detachUnique(u, "NonExistent\\Model.mdl");
			BJDebugMsg("[测试9] 分离不存在的特效完成（应该无错误）");
			u = null;
		}
	}

	// 测试10：容量测试（尝试添加超过20个特效）
	function TTestUTBindEffect10 (player p) {
		unit u;
		effect e;
		integer i;
		string mdlPaths[];

		u = CreateUnit(p, 'hfoo', 0, 0, 0);
		if (u != null) {
			// 准备25个不同的特效路径（超过20个限制）
			mdlPaths[0] = "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl";
			mdlPaths[1] = "Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl";
			mdlPaths[2] = "Abilities\\Spells\\Human\\Blizzard\\BlizzardTarget.mdl";
			mdlPaths[3] = "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl";
			mdlPaths[4] = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl";
			mdlPaths[5] = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl";
			mdlPaths[6] = "Abilities\\Spells\\Human\\Slow\\SlowTarget.mdl";
			mdlPaths[7] = "Abilities\\Spells\\Human\\InnerFire\\InnerFireTarget.mdl";
			mdlPaths[8] = "Abilities\\Spells\\Human\\Invisibility\\InvisibilityTarget.mdl";
			mdlPaths[9] = "Abilities\\Spells\\Human\\ManaShield\\ManaShieldCaster.mdl";
			mdlPaths[10] = "Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl";
			mdlPaths[11] = "Abilities\\Spells\\Human\\BerserkerRage\\BerserkerRage.mdl";
			mdlPaths[12] = "Abilities\\Spells\\Human\\WindWalk\\WindWalkTarget.mdl";
			mdlPaths[13] = "Abilities\\Spells\\Human\\ManaBurn\\ManaBurnTarget.mdl";
			mdlPaths[14] = "Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl";
			mdlPaths[15] = "Abilities\\Spells\\Human\\Banish\\BanishTarget.mdl";
			mdlPaths[16] = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl";
			mdlPaths[17] = "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl";
			mdlPaths[18] = "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl";
			mdlPaths[19] = "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl";
			mdlPaths[20] = "Abilities\\Spells\\Human\\Avatar\\AvatarCaster.mdl";
			mdlPaths[21] = "Abilities\\Spells\\Human\\Devotion\\DevotionAura.mdl";
			mdlPaths[22] = "Abilities\\Spells\\Human\\Brilliance\\Brilliance.mdl";
			mdlPaths[23] = "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl";
			mdlPaths[24] = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl";

			// 尝试添加25个不同的特效（超过20个限制）
			for (i = 0; i < 25; i += 1) {
				e = bindEffect.attachUnique(u, mdlPaths[i], "origin");
				if (e == null && i >= 20) {
					BJDebugMsg("[测试10] 容量限制测试通过，第" + I2S(i + 1) + "个特效被正确拒绝");
					break;
				} else if (e != null && i < 20) {
					BJDebugMsg("[测试10] 第" + I2S(i + 1) + "个特效添加成功");
				}
			}
			u = null;
		}
	}
	function TTestActUTBindEffect1 (string str) {
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
			BJDebugMsg("[BindEffect] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTBindEffect1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTBindEffect1(GetTriggerPlayer());
			else if(str == "s2") TTestUTBindEffect2(GetTriggerPlayer());
			else if(str == "s3") TTestUTBindEffect3(GetTriggerPlayer());
			else if(str == "s4") TTestUTBindEffect4(GetTriggerPlayer());
			else if(str == "s5") TTestUTBindEffect5(GetTriggerPlayer());
			else if(str == "s6") TTestUTBindEffect6(GetTriggerPlayer());
			else if(str == "s7") TTestUTBindEffect7(GetTriggerPlayer());
			else if(str == "s8") TTestUTBindEffect8(GetTriggerPlayer());
			else if(str == "s9") TTestUTBindEffect9(GetTriggerPlayer());
			else if(str == "s10") TTestUTBindEffect10(GetTriggerPlayer());
			else if(str == "help") {
				BJDebugMsg("=== BindEffect 测试命令 ===");
				BJDebugMsg("s1 - 基本特效附加测试");
				BJDebugMsg("s2 - 同mdl特效替换测试");
				BJDebugMsg("s3 - 特效分离测试");
				BJDebugMsg("s4 - 多个不同特效测试");
				BJDebugMsg("s5 - 单位死亡自动清理测试");
				BJDebugMsg("s6 - 安全移除单位测试");
				BJDebugMsg("s7 - 空单位处理测试");
				BJDebugMsg("s8 - 无效mdl路径测试");
				BJDebugMsg("s9 - 分离不存在特效测试");
				BJDebugMsg("s10 - 容量限制测试");
				BJDebugMsg("help - 显示此帮助信息");
			}
		});

	}

}
//! endzinc

#endif
