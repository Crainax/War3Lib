#ifndef UTTalentIncluded
#define UTTalentIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "KKPRE.j"
#include "Crainax/core/constant/JapiConstant.j"


//! zinc

//自动生成的文件
library UTTalent requires Talent {

	private unit talentTestUnit[];
	private integer testSkillIndex[];  // 每个玩家的当前技能指针
	private integer testSkillList[37]; // 37个测试技能ID

	private function getOrCreateTalentUnit(player p) -> unit {
		integer pid;
		unit u = null;
		real x;
		real y;

		if (p == null) {
			return null;
		}

		pid = GetConvertedPlayerId(p);
		if (pid < 1 || pid > MAX_PLAYER_COUNT) {
			return null;
		}

		u = talentTestUnit[pid];
		if (u == null) {
			x = GetStartLocationX(GetPlayerStartLocation(p));
			y = GetStartLocationY(GetPlayerStartLocation(p));
			u = CreateUnit(p, 'Hpal', x, y, 270.0);
			SetHeroLevel(u, 10, false);
			AddUnitHP(u, 10000);
			AddUnitMP(u, 10000);
			talentTestUnit[pid] = u;
		}
		return u;
	}

	private function initTestSkillList() {
		// 直接赋值37个技能ID（0-36索引）
		// 第1组: AEbl,AEfk,AEsh,AEsv
		testSkillList[0] = 'AEbl';
		testSkillList[1] = 'AEfk';
		testSkillList[2] = 'AEsh';
		testSkillList[3] = 'AEsv';
		// 第2组: AHhb,AHds,AHre,AHad
		testSkillList[4] = 'AHhb';
		testSkillList[5] = 'AHds';
		testSkillList[6] = 'AHre';
		// 第3组: AHfs,AHbn,AHdr,AHpx
		testSkillList[7] = 'AHfs';
		testSkillList[8] = 'AHbn';
		testSkillList[9] = 'AHdr';
		testSkillList[10] = 'AHpx';
		// 第4组: AHbz,AHab,AHwe,AHmt
		testSkillList[11] = 'AHbz';
		testSkillList[12] = 'AHwe';
		testSkillList[13] = 'AHmt';
		// 第5组: AHtc,AHtb,AHbh,AHav
		testSkillList[14] = 'AHtc';
		testSkillList[15] = 'AHtb';
		testSkillList[16] = 'AHav';
		// 第6组: ANfl,ANfa,ANms,ANto
		testSkillList[17] = 'ANfl';
		testSkillList[18] = 'ANfa';
		testSkillList[19] = 'ANms';
		testSkillList[20] = 'ANto';
		// 第7组: AHca,AEst,AEar,AEsf
		testSkillList[21] = 'AHca';
		testSkillList[22] = 'AEst';
		testSkillList[23] = 'AEsf';
		// 第8组: ACs7,AOcl,AEsh,ANr2
		testSkillList[24] = 'ACs7';
		testSkillList[25] = 'AOcl';
		testSkillList[26] = 'ANr2';
		// 第9组: ANhs,ANab,ANcr,ANtm
		testSkillList[27] = 'ANhs';
		testSkillList[28] = 'ANab';
		testSkillList[29] = 'ANcr';
		testSkillList[30] = 'ANtm';
		// 第10组: AOwk,AOcr,AOmi,AOww
		testSkillList[31] = 'AOwk';
		testSkillList[32] = 'AOcr';
		testSkillList[33] = 'AOmi';
		testSkillList[34] = 'AOww';
	}

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);
		initTestSkillList();
	}

	function TTestUTTalent1 (player p) {
		integer pid;
		integer abilId;
		boolean ok;
		unit u;

		pid = GetConvertedPlayerId(p);
		if (pid < 1 || pid > MAX_PLAYER_COUNT) {
			return;
		}

		// 确保已绑定单位
		u = getOrCreateTalentUnit(p);
		if (u != null) {
			talent.bindUnit(p, u);
		}

		// 检查是否还有技能可添加
		if (testSkillIndex[pid] >= 37) {
			DisplayTextToPlayer(p, 0, 0, "[TalentTest] 所有技能已添加完毕，使用 -clear 重置。");
			u = null;
			return;
		}

		// 添加1个技能
		abilId = testSkillList[testSkillIndex[pid]];
		ok = talent.addSpellId(p, abilId);
		if (ok) {
			testSkillIndex[pid] += 1;
			DisplayTextToPlayer(p, 0, 0, "[TalentTest] s1: 已添加 " + YDWEId2S(abilId) + " (索引 " + I2S(testSkillIndex[pid]) + "/37)");
		} else {
			DisplayTextToPlayer(p, 0, 0, "[TalentTest] s1: 添加失败 " + YDWEId2S(abilId));
		}

		u = null;
	}

	function TTestUTTalent2 (player p) {
		integer pid;
		integer i;
		integer abilId;
		integer added;
		boolean ok;
		unit u;

		pid = GetConvertedPlayerId(p);
		if (pid < 1 || pid > MAX_PLAYER_COUNT) {
			return;
		}

		// 确保已绑定单位
		u = getOrCreateTalentUnit(p);
		if (u != null) {
			talent.bindUnit(p, u);
		}

		// 检查是否还有技能可添加
		if (testSkillIndex[pid] >= 37) {
			DisplayTextToPlayer(p, 0, 0, "[TalentTest] 所有技能已添加完毕，使用 -clear 重置。");
			u = null;
			return;
		}

		// 添加3个技能
		added = 0;
		for (1 <= i <= 3) {
			if (testSkillIndex[pid] >= 37) {
				break;
			}
			abilId = testSkillList[testSkillIndex[pid]];
			ok = talent.addSpellId(p, abilId);
			if (ok) {
				testSkillIndex[pid] += 1;
				added += 1;
			}
		}

		DisplayTextToPlayer(p, 0, 0, "[TalentTest] s2: 已添加 " + I2S(added) + " 个技能 (索引 " + I2S(testSkillIndex[pid]) + "/37)");

		u = null;
	}
	function TTestUTTalent3 (player p) {}
	function TTestUTTalent4 (player p) {}
	function TTestUTTalent5 (player p) {}
	function TTestUTTalent6 (player p) {}
	function TTestUTTalent7 (player p) {}
	function TTestUTTalent8 (player p) {}
	function TTestUTTalent9 (player p) {}
	function TTestUTTalent10 (player p) {}
	function TTestActUTTalent1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R
		unit	u = null;
		integer abilId = 0;
		real	value = 0.0;
		boolean ok = false;
		integer pid;
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

		if (paramS[0] == "bind") {
			u = getOrCreateTalentUnit(p);
			if (u != null) {
				talent.bindUnit(p, u);
				DisplayTextToPlayer(p, 0, 0, "[TalentTest] 已绑定测试英雄。");
			}
		} else if (paramS[0] == "add") {
			if (num >= 2) {
				abilId = YDWES2Id(paramS[1]);
				if (abilId != 0) {
					ok = talent.addSpellId(p, abilId);
					DisplayTextToPlayer(p, 0, 0, "[TalentTest] add " + paramS[1] + " => " + S3(ok, "成功", "失败"));
				} else {
					DisplayTextToPlayer(p, 0, 0, "[TalentTest] 无效技能ID。");
				}
			} else {
				DisplayTextToPlayer(p, 0, 0, "[TalentTest] 用法：-add 技能ID");
			}
		} else if (paramS[0] == "rm") {
			if (num >= 2) {
				abilId = YDWES2Id(paramS[1]);
				if (abilId != 0) {
					ok = talent.removeSpellId(p, abilId);
					DisplayTextToPlayer(p, 0, 0, "[TalentTest] rm " + paramS[1] + " => " + S3(ok, "成功", "失败"));
				} else {
					DisplayTextToPlayer(p, 0, 0, "[TalentTest] 无效技能ID。");
				}
			} else {
				DisplayTextToPlayer(p, 0, 0, "[TalentTest] 用法：-rm 技能ID");
			}
		} else if (paramS[0] == "show") {
			talent.debugPrintList(p);
		} else if (paramS[0] == "clear") {
			pid = GetConvertedPlayerId(p);
			if (pid >= 1 && pid <= MAX_PLAYER_COUNT) {
				testSkillIndex[pid] = 0;
			}
			talent.clearAll(p);
			DisplayTextToPlayer(p, 0, 0, "[TalentTest] 已清空技能列表并重置指针。");
		} else if (paramS[0] == "check") {
			DisplayTextToPlayer(p, 0, 0, "[TalentTest] isInSpellBookLocal=" + S3(talent.isInSpellBookLocal(p), "true", "false"));
		} else if (paramS[0] == "cdset") {
			if (num >= 3) {
				abilId = YDWES2Id(paramS[1]);
				value = S2R(paramS[2]);
				u = getOrCreateTalentUnit(p);
				if (u != null && abilId != 0) {
					YDWESetUnitAbilityState(u, abilId, ABILITY_STATE_COOLDOWN, value);
					DisplayTextToPlayer(p, 0, 0, "[TalentTest] 已设置 " + paramS[1] + " 冷却=" + R2S(value));
				}
			} else {
				DisplayTextToPlayer(p, 0, 0, "[TalentTest] 用法：-cdset 技能ID 秒数");
			}
		} else if (paramS[0] == "cdget") {
			if (num >= 2) {
				abilId = YDWES2Id(paramS[1]);
				u = getOrCreateTalentUnit(p);
				if (u != null && abilId != 0) {
					value = YDWEGetUnitAbilityState(u, abilId, ABILITY_STATE_COOLDOWN);
					DisplayTextToPlayer(p, 0, 0, "[TalentTest] 当前冷却=" + R2S(value));
				}
			} else {
				DisplayTextToPlayer(p, 0, 0, "[TalentTest] 用法：-cdget 技能ID");
			}
		} else {
			DisplayTextToPlayer(p, 0, 0, "[TalentTest] 未知命令。");
		}

		u = null;
		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[Talent] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTTalent1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTTalent1(GetTriggerPlayer());
			else if(str == "s2") TTestUTTalent2(GetTriggerPlayer());
			else if(str == "s3") TTestUTTalent3(GetTriggerPlayer());
			else if(str == "s4") TTestUTTalent4(GetTriggerPlayer());
			else if(str == "s5") TTestUTTalent5(GetTriggerPlayer());
			else if(str == "s6") TTestUTTalent6(GetTriggerPlayer());
			else if(str == "s7") TTestUTTalent7(GetTriggerPlayer());
			else if(str == "s8") TTestUTTalent8(GetTriggerPlayer());
			else if(str == "s9") TTestUTTalent9(GetTriggerPlayer());
			else if(str == "s10") TTestUTTalent10(GetTriggerPlayer());
		});

		//YDWEGetUnitAbilityState
	}

}
//! endzinc

#endif
