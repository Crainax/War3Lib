#ifndef UTSpellUtilsIncluded
#define UTSpellUtilsIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

// 使用说明：
// 1. 游戏加载时会自动创建3个测试单位（步兵、步枪兵、骑士）
// 2. 输入命令 "s1" - 遍历并显示技能坐标 x:0-3, y:0-2 的技能ID和名称
// 3. 输入命令 "s2" - 给测试单位随机添加3个技能，再次输入会清空之前添加的技能
// 3. 输入命令 "s3" - 测试魔法书
// 4. 可用的测试技能ID：AAns, ACac, ACad, ACah, ACam, ACat, ACav, ACba, ACbb, ACbc,
//    ACbf, ACbh, ACbk, ACbl, ACbn, ACbz, ACc2, ACc3, ACca, ACcb, ACce, ACch

//! zinc

//自动生成的文件
library UTSpellUtils requires SpellUtils, LBKKAPI,UnitUtils {

	// 全局测试单位引用和技能跟踪
	private unit testUnits[3];
	private boolean skillsAdded = false;
	private integer unitAbilities[3][3];  // 存储每个单位的3个技能ID [单位索引][技能索引]
	private integer passiveCallbackCount = 0;
	private integer passiveCallbackAbilityID = 0;
	private boolean passiveCallbackAll = false;

	private function TestAbilityAttrs() {
		unit u;
		player p;
		integer abilityID;

		u = testUnits[0];
		p = Player(0);
		abilityID = 'A000';

		assert.Real(GetAbilitySpellFinalDamageRate(u, abilityID), 1.0, "技能终伤默认值应为 1.0");
		AddAbilitySpellFinalDamageRateUp(u, abilityID, 0.5);
		AddAbilitySpellFinalDamageRateDown(u, abilityID, 0.2);
		assert.Real(GetAbilitySpellFinalDamageRate(u, abilityID), 1.2, "技能终伤 Up/Down 应叠乘");
		AddAbilitySpellFinalDamageRateUp(u, abilityID, -0.5);
		AddAbilitySpellFinalDamageRateDown(u, abilityID, -0.2);
		assert.Real(GetAbilitySpellFinalDamageRate(u, abilityID), 1.0, "技能终伤 Up/Down 应可撤销");

		plyaerHeroAttr.addSpellFinalDamageRateUp(p, 0.25);
		AddAbilitySpellFinalDamageRateUp(u, abilityID, 0.2);
		assert.Real(GetTotalSpellFinalDamageRate(u, abilityID), 1.5, "总技能终伤应等于玩家终伤乘技能终伤");
		AddAbilitySpellFinalDamageRateUp(u, abilityID, -0.2);
		plyaerHeroAttr.addSpellFinalDamageRateUp(p, -0.25);

		assert.Real(GetAbilitySpellRangeRate(u, abilityID), 1.0, "技能范围默认值应为 1.0");
		AddAbilitySpellRangeRateUp(u, abilityID, 0.5);
		AddAbilitySpellRangeRateDown(u, abilityID, 0.2);
		assert.Real(GetAbilitySpellRangeRate(u, abilityID), 1.2, "技能范围 Up/Down 应按规则合成");
		AddAbilitySpellRangeRateUp(u, abilityID, -0.5);
		AddAbilitySpellRangeRateDown(u, abilityID, -0.2);
		assert.Real(GetAbilitySpellRangeRate(u, abilityID), 1.0, "技能范围 Up/Down 应可撤销");

		passiveCallbackCount = 0;
		passiveCallbackAbilityID = 0;
		passiveCallbackAll = false;
		RegisterSpellPassiveRateChanged(function () {
			passiveCallbackCount += 1;
			passiveCallbackAbilityID = GetSpellPassiveRateChangedAbilityID();
			passiveCallbackAll = IsSpellPassiveRateChangedAll();
		});

		AddPlayerSpellPassiveRate(p, 0.2);
		assert.Boolean(passiveCallbackCount == 1 && passiveCallbackAll, "玩家被动强化变化应触发全量回调");
		AddAbilitySpellPassiveRate(u, abilityID, 0.3);
		assert.Boolean(passiveCallbackCount == 2 && passiveCallbackAbilityID == abilityID && !passiveCallbackAll, "技能被动强化变化应触发单技能回调");
		assert.Real(GetTotalSpellPassiveRate(u, abilityID), 1.5, "总被动强化应为 1 + 玩家强化 + 技能强化");
		AddAbilitySpellPassiveRate(u, abilityID, -0.3);
		AddPlayerSpellPassiveRate(p, -0.2);

		SetAbilitySpellPassiveAppliedRate(u, abilityID, 1.75);
		assert.Boolean(HasAbilitySpellPassiveAppliedRate(u, abilityID), "被动强化快照应可检测");
		assert.Real(GetAbilitySpellPassiveAppliedRate(u, abilityID), 1.75, "被动强化快照应可读取");
		ClearAbilitySpellPassiveAppliedRate(u, abilityID);
		assert.Boolean(!HasAbilitySpellPassiveAppliedRate(u, abilityID), "被动强化快照应可清理");

		u = null;
		p = null;
	}

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			// 创建测试单位
			testUnits[0] = CreateUnit(Player(0), 'hfoo', 0, 0, 0); // 步兵
			testUnits[1] = CreateUnit(Player(0), 'hrif', 100, 100, 0); // 步枪兵
			testUnits[2] = CreateUnit(Player(0), 'hkni', 200, 200, 0); // 骑士

			UnitAddAbility(testUnits[0], 'AJB0');

			BJDebugMsg("[SpellUtils] 测试单位已创建");
			TestAbilityAttrs();
			}, function() {
			// 可选：清理测试单位（目前保留供测试使用）
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);
	}

	function TTestUTSpellUtils1 (player p) {
		// 测试 GetCurrentXYAbility - 遍历技能ID和名字（不创建单位）
		integer x, y, abilityId, orderId;
		string abilityName;

		DisplayTextToPlayer(p, 0, 0, "|cffffcc00=== SpellUtils 技能遍历测试开始 ==|r");

		// 遍历 x:0-3, y:0-2 的技能坐标
		for (0 <= x <= 3) {
			for (0 <= y <= 2) {
				abilityId = GetCurrentXYAbility(x, y);
				orderId = GetCurrentXYAbilityOrder(x, y);
				abilityName = GetObjectName(abilityId);
				if (abilityName != null && abilityName != "") {
					Trace("|cff00ff00技能坐标 (" + I2S(x) + "," + I2S(y) + "):|r  ID: " + YDWEId2S(abilityId) + "  名字: " + abilityName + "  指令ID: " + I2S(orderId));
				} else {
					Trace("|cff00ff00技能坐标 (" + I2S(x) + "," + I2S(y) + "):|r  ID: " + YDWEId2S(abilityId) + "  名字: [未找到或无效]  指令ID: " + I2S(orderId));
				}
			}
		}

		DisplayTextToPlayer(p, 0, 0, "|cff00ccff提示：测试单位已在游戏初始化时创建|r");
		DisplayTextToPlayer(p, 0, 0, "|cff00ccff输入 's2' 可以给单位随机添加技能|r");
		DisplayTextToPlayer(p, 0, 0, "|cffffcc00=== SpellUtils 技能遍历测试完成 ==|r");
	}
	function TTestUTSpellUtils2 (player p) {
		// 测试单位技能添加/清空功能
		integer i, j, randomIndex;
		string abilityIds[];
		integer abilId;
		string abilName;

		// 初始化技能ID数组
		abilityIds[0] = "AAns";
		abilityIds[1] = "ACac";
		abilityIds[2] = "ACad";
		abilityIds[3] = "ACah";
		abilityIds[4] = "ACam";
		abilityIds[5] = "ACat";
		abilityIds[6] = "ACav";
		abilityIds[7] = "ACba";
		abilityIds[8] = "ACbb";
		abilityIds[9] = "ACbc";
		abilityIds[10] = "ACbf";
		abilityIds[11] = "ACbh";
		abilityIds[12] = "ACbk";
		abilityIds[13] = "ACbl";
		abilityIds[14] = "ACbn";
		abilityIds[15] = "ACbz";
		abilityIds[16] = "ACc2";
		abilityIds[17] = "ACc3";
		abilityIds[18] = "ACca";
		abilityIds[19] = "ACcb";
		abilityIds[20] = "ACce";
		abilityIds[21] = "ACch";

		// 检查测试单位是否存在
		if (testUnits[0] == null || testUnits[1] == null || testUnits[2] == null) {
			DisplayTextToPlayer(p, 0, 0, "|cffff0000错误：测试单位不存在，请重新加载地图|r");
			return;
		}

		DisplayTextToPlayer(p, 0, 0, "|cffffcc00=== 单位技能操作测试开始 ==|r");

		if (skillsAdded) {
			// 清空技能
			for (i = 0; i < 3; i += 1) {
				if (testUnits[i] != null) {
					DisplayTextToPlayer(p, 0, 0, "|cffff9900清空 " + GetUnitName(testUnits[i]) + " 的技能:|r");
					// 清空之前添加的3个技能
					for (j = 0; j < 3; j += 1) {
						if (unitAbilities[i][j] != 0) {
							UnitRemoveAbility(testUnits[i], unitAbilities[i][j]);
							DisplayTextToPlayer(p, 0, 0, "  - 移除技能: " + GetObjectName(unitAbilities[i][j]));
							unitAbilities[i][j] = 0;
						}
					}
				}
			}
			skillsAdded = false;
			DisplayTextToPlayer(p, 0, 0, "|cff00ff00技能已全部清空，再次输入 's2' 可以重新添加|r");
		} else {
			// 为每个单位随机添加3个不同的技能
			DisplayTextToPlayer(p, 0, 0, "|cff00ff00为每个单位随机添加3个技能:|r");

			for (i = 0; i < 3; i += 1) {
				if (testUnits[i] != null) {
					DisplayTextToPlayer(p, 0, 0, "|cff00ccff" + GetUnitName(testUnits[i]) + " 获得技能:|r");

					// 为当前单位随机选择3个技能
					for (j = 0; j < 3; j += 1) {
						randomIndex = GetRandomInt(0, 21); // 0-21，对应22个技能ID
						abilId = S2I(abilityIds[randomIndex]);
						abilName = GetObjectName(abilId);

						// 存储技能ID用于后续清空
						unitAbilities[i][j] = abilId;

						// 添加技能到单位
						UnitAddAbility(testUnits[i], abilId);

						// 显示添加的技能
						DisplayTextToPlayer(p, 0, 0, "  + " + abilityIds[randomIndex] + " - " + abilName);
					}
				}
			}

			skillsAdded = true;
			DisplayTextToPlayer(p, 0, 0, "|cff00ff00技能添加完成，再次输入 's2' 可以清空技能|r");
		}

		DisplayTextToPlayer(p, 0, 0, "|cffffcc00=== 单位技能操作测试完成 ==|r");
	}
	function TTestUTSpellUtils3 (player p) {
		integer i;
		for (0 <= i <= 2) {
			AddUnitMP(testUnits[i], 500);
			UnitAddAbility(testUnits[i], 'Aspb');
		}
		DisplayTextToPlayer(p, 0, 0, "|cffffcc00=== 单位魔法书测试完成 ==|r");
	}

	function TTestUTSpellUtils4 (player p) {
		// Trace(GetAbilityUberTip('AJB0')); //测试一下异度的字符串
		BJDebugMsg(GetObjectName('AJB0'));
	}
	function TTestUTSpellUtils5 (player p) {
		BJDebugMsg(GetAbilityArt('AJB0'));
	}
	function TTestUTSpellUtils6 (player p) {
		// 打印 ability['AJB0'] 子表的所有字段
		integer abilityId;
		string abilityIdStr;
		string luaScript;
		string result;
		integer i;
		string lines[];
		integer lineCount;
		integer pos;
		integer len;
		integer start;
		string key;
		string value;

		abilityId = 'AJB0';
		abilityIdStr = YDWEId2S(abilityId);
		luaScript = "";

		DisplayTextToPlayer(p, 0, 0, "=== 打印 ability['" + abilityIdStr + "'] 子表 ===");

		// 构造 Lua 脚本：遍历 ability['AJB0'] 表的所有键值对
		// 返回格式: "KEY1|VALUE1||KEY2|VALUE2||..." (使用 || 分隔每个键值对，| 分隔键和值)
		// 注意：将值中的 | 转义为 ||，避免与分隔符冲突
		luaScript = "(function() local slk = require'jass.slk'; local ability = slk.ability; local id = " + I2S(abilityId) + "; local data = ability[id]; if not data then return 'ERROR:ability not found'; end; local result = {}; for k, v in pairs(data) do local val = tostring(v); if type(v) == 'string' then val = val:gsub('|', '||'); end; table.insert(result, tostring(k) .. '|' .. val); end; return table.concat(result, '||') end)()";

		result = EXExecuteScript(luaScript);

		// 解析结果：格式为 "KEY1|VALUE1||KEY2|VALUE2||..."
		if (result != null && result != "") {
			if (DzStringFind(result, "ERROR:", 0, true) >= 0) {
				BJDebugMsg("错误: " + result);
			} else {
				// 解析 || 分隔的键值对
				lineCount = 0;
				len = StringLength(result);
				start = 0;

				for (0 <= i <= len - 1) {
					// 检查是否是 || 分隔符（需要检查两个连续的 |）
					if (i < len - 1 && SubString(result, i, i + 1) == "|" && SubString(result, i + 1, i + 2) == "|") {
						// 找到键值对分隔符 ||
						if (i > start) {
							lines[lineCount] = SubString(result, start, i);
							lineCount = lineCount + 1;
						}
						start = i + 2;
						i = i + 1; // 跳过第二个 |
					} else if (i == len - 1) {
						// 最后一个键值对
						if (i >= start) {
							lines[lineCount] = SubString(result, start, len);
							lineCount = lineCount + 1;
						}
					}
				}

				// 输出所有字段（无颜色代码，清晰易读）
				BJDebugMsg("ability['" + abilityIdStr + "'] 共有 " + I2S(lineCount) + " 个字段:");
				for (0 <= i <= lineCount - 1) {
					// 解析每个键值对：KEY|VALUE
					pos = DzStringFind(lines[i], "|", 0, true);
					if (pos >= 0) {
						len = StringLength(lines[i]);
						key = SubString(lines[i], 0, pos);
						value = SubString(lines[i], pos + 1, len);
						// 恢复被转义的 | 符号
						value = DzStringReplace(value, "||", "|", true);
						// 输出无颜色代码的键值对
						BJDebugMsg("  " + key + " = " + value);
					} else {
						BJDebugMsg("  " + lines[i]);
					}
				}
			}
		} else {
			BJDebugMsg("错误：EXExecuteScript 返回空结果");
		}

		DisplayTextToPlayer(p, 0, 0, "=== 打印完成 ===");
	}
	function TTestUTSpellUtils7 (player p) {
		// 测试 GetAbilityUberTip 按等级获取功能（只打印长度，避免长字符串导致闪退）
		integer abilityId;
		integer level;
		string result;
		integer i;

		abilityId = 'AJB0';

		Trace("=== 测试 GetAbilityUberTip('AJB0', level) 1-20级（只显示长度） ===");

		for (1 <= i <= 20) {
			level = i;
			result = GetAbilityUberTip(abilityId, level);

			if (result != null && result != "") {
				BJDebugMsg(result);
			} else {
				BJDebugMsg("空");
			}
		}

		Trace("=== 测试完成 ===");
	}
	function TTestUTSpellUtils8 (player p) {
		BJDebugMsg(GetAbilityUberTip('AJB0',12));
	}
	function TTestUTSpellUtils9 (player p) {}
	function TTestUTSpellUtils10 (player p) {}
	function TTestActUTSpellUtils1 (string str) {
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
			BJDebugMsg("[SpellUtils] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTSpellUtils1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTSpellUtils1(GetTriggerPlayer());
			else if(str == "s2") TTestUTSpellUtils2(GetTriggerPlayer());
			else if(str == "s3") TTestUTSpellUtils3(GetTriggerPlayer());
			else if(str == "s4") TTestUTSpellUtils4(GetTriggerPlayer());
			else if(str == "s5") TTestUTSpellUtils5(GetTriggerPlayer());
			else if(str == "s6") TTestUTSpellUtils6(GetTriggerPlayer());
			else if(str == "s7") TTestUTSpellUtils7(GetTriggerPlayer());
			else if(str == "s8") TTestUTSpellUtils8(GetTriggerPlayer());
			else if(str == "s9") TTestUTSpellUtils9(GetTriggerPlayer());
			else if(str == "s10") TTestUTSpellUtils10(GetTriggerPlayer());
		});
		DzUnlockOpCodeLimit(true);

	}

}
//! endzinc

#endif
