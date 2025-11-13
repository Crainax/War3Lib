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
library UTSpellUtils requires SpellUtils {

	// 全局测试单位引用和技能跟踪
	private unit testUnits[3];
	private boolean skillsAdded = false;
	private integer unitAbilities[3][3];  // 存储每个单位的3个技能ID [单位索引][技能索引]

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			// 创建测试单位
			testUnits[0] = CreateUnit(Player(0), 'hfoo', 0, 0, 0); // 步兵
			testUnits[1] = CreateUnit(Player(0), 'hrif', 100, 100, 0); // 步枪兵
			testUnits[2] = CreateUnit(Player(0), 'hkni', 200, 200, 0); // 骑士

			BJDebugMsg("[SpellUtils] 测试单位已创建");
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

	function TTestUTSpellUtils4 (player p) {}
	function TTestUTSpellUtils5 (player p) {}
	function TTestUTSpellUtils6 (player p) {}
	function TTestUTSpellUtils7 (player p) {}
	function TTestUTSpellUtils8 (player p) {}
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

	}

}
//! endzinc

#endif
