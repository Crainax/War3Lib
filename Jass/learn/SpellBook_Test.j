#ifndef UTSpellBookIncluded
#define UTSpellBookIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "KKPRE.j"

// 使用方式
// 输入 s1：创建/复用圣骑士并配置 A000/A001，并示例设定两个技能等级
// 输入 s2：打印该玩家测试圣骑士 两本魔法书里所有技能的等级
// 输入 -lv AHhb 3：把技能 AHhb 设置为 3 级（任意技能ID都行）
// 输入 -show：打印 A000/A001 内技能等级

//! zinc

//自动生成的文件
library UTSpellBook requires SpellBook, LBKKPRE,UnitUtils,SpellUtils {

	// 每个玩家一个测试用圣骑士（1-based pid）
	private unit testPaladin[];

	private function getOrCreateTestPaladin(player p) -> unit {
		integer pid;
		unit u = null;
		real x;
		real y;

		pid = GetConvertedPlayerId(p);
		u = testPaladin[pid];

		if (u == null) {
			x = GetStartLocationX(GetPlayerStartLocation(p));
			y = GetStartLocationY(GetPlayerStartLocation(p));
			u = CreateUnit(p, 'Hpal', x, y, 270.0);
			SetHeroLevel(u, 10, false);
			AddUnitMP(u,100000);
			testPaladin[pid] = u;
		}
		return u;
	}

	// 配置两层魔法书：
	// A000 里包含：A001 + 4个英雄技能
	// A001 里包含：任意5个技能（这里选5个经典英雄技能）
	private function setupSpellBooks(unit u) {
		// 先确保两本魔法书在单位身上
		UnitAddAbility(u, 'A000');
		// UnitAddAbility(u, 'A001');

		// A000：包含 A001 + 4 个英雄技能（山丘之王 4 技能）
		DzSetUnitAbilitySpellBookList(u, 'A000', "AHtc,AHfs,AHbn,AHdr,AHhb,A001", true);
		DzSetUnitAbilityUpdate(u, 'A000');

		// A001：圣骑士经典 5 技能
		DzSetUnitAbilitySpellBookList(u, 'A001', "AUim,AUts,AUcb,AUls,A002", true);
		DzSetUnitAbilityUpdate(u, 'A001');
		//这里添加外面有的技能无效

		// A001：圣骑士经典 5 技能
		DzSetUnitAbilitySpellBookList(u, 'A002', "AEfk,AEbl,AEsh,AEsv", true);
		DzSetUnitAbilityUpdate(u, 'A002');
		//这里添加外面有的技能无效

	}

	private function setAbilityLevelByStr(unit u, string abilIdStr, integer level) {
		integer abilId;
		integer oldLv;

		abilId = YDWES2Id(abilIdStr);
		oldLv = GetUnitAbilityLevel(u, abilId);
		if (oldLv == 0) {
			// 如果单位没有该技能，先加上（魔法书里一般会自动附带，但这里做兜底）
			UnitAddAbility(u, abilId);
		}

		SetUnitAbilityLevel(u, abilId, level);
		BJDebugMsg("[SpellBook] 设置技能等级: " + YDWEId2S(abilId) + " -> " + I2S(level));
	}

	private function printSpellBookListLevels(player p, unit u, integer bookId) {
		string listStr;
		integer i;
		integer len;
		integer start;
		string token;
		integer abilId;
		integer lv;
		string abilName;

		listStr = DzGetUnitAbilitySpellBookList(u, bookId);
		DisplayTextToPlayer(p, 0, 0, "|cffffcc00[SpellBook]|r " + YDWEId2S(bookId) + " 列表: " + (listStr));

		if (listStr == null || listStr == "") {
			DisplayTextToPlayer(p, 0, 0, "  (空)");
			return;
		}

		len = StringLength(listStr);
		start = 0;

		// 逗号分隔解析：在 i==len 时刷出最后一个 token
		for (0 <= i <= len) {
			if (i == len || SubString(listStr, i, i + 1) == ",") {
				token = SubString(listStr, start, i);
				if (token != null && token != "") {
					abilId = YDWES2Id(token);
					lv = GetUnitAbilityLevel(u, abilId);
					abilName = GetObjectName(abilId);
					DisplayTextToPlayer(p, 0, 0, "  - " + token + " (" + YDWEId2S(abilId) + ")  等级=" + I2S(lv) + "  名称=" + abilName);
				}
				start = i + 1;
			}
		}
		//851975
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
	}

	function TTestUTSpellBook1 (player p) {
		unit u;

		u = getOrCreateTestPaladin(p);
		setupSpellBooks(u);

		// 示例：用“字符串技能ID”指定某个技能等级（并用 YDWEId2S 打印确认）
		// 这里把圣光术(AHhb)设为 3 级，雷霆一击(AHtc)设为 2 级
		setAbilityLevelByStr(u, "AHhb", 3);
		setAbilityLevelByStr(u, "AHtc", 2);

		DisplayTextToPlayer(p, 0, 0, "|cff00ccff[SpellBook]|r 已创建/复用圣骑士，并完成 A000/A001 魔法书配置。");
		DisplayTextToPlayer(p, 0, 0, "|cff00ccff用法：输入 |r|cffffff00s2|r|cff00ccff 打印魔法书内技能等级；输入 |r|cffffff00-lv 技能ID 等级|r|cff00ccff 设定等级。|r");
		u = null;
	}
	function TTestUTSpellBook2 (player p) {
		unit u;

		u = getOrCreateTestPaladin(p);
		// s2：打印玩家（测试圣骑士）两本魔法书里所有技能的等级
		printSpellBookListLevels(p, u, 'A000');
		printSpellBookListLevels(p, u, 'A001');
		printSpellBookListLevels(p, u, 'A002');
		u = null;
	}

	function TTestUTSpellBook3 (player p) {
		// 测试 GetCurrentXYAbility - 遍历技能ID和名字（不创建单位）
		integer x, y, abilityId, orderId;
		string abilityName;

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
	}
	function TTestUTSpellBook4 (player p) {
		unit u;
		u = getOrCreateTestPaladin(p);
		// A000：包含 A001 + 4 个英雄技能（山丘之王 4 技能）
		DzSetUnitAbilitySpellBookList(u, 'A000', "AHtc,AHfs,AHbn,AHdr,A001", true);
		DzSetUnitAbilityUpdate(u, 'A000');
	}
	function TTestUTSpellBook5 (player p) {
		unit u;

		u = getOrCreateTestPaladin(p);
		// A001：圣骑士经典 5 技能
		DzSetUnitAbilitySpellBookList(u, 'A002', "AEsh,AEsv", true);
		DzSetUnitAbilityUpdate(u, 'A002');
		//这里添加外面有的技能无效
	}
	function TTestUTSpellBook6 (player p) {}
	function TTestUTSpellBook7 (player p) {}
	function TTestUTSpellBook8 (player p) {}
	function TTestUTSpellBook9 (player p) {}
	function TTestUTSpellBook10 (player p) {}
	function TTestActUTSpellBook1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		unit    u = null;
		integer lv = 0;
		for (0 <= i <= len - 1) {
			if (SubString(str,i,i+1) == " ") {
				paramS[num]= SubString(str,0,i);
				paramI[num]= S2I(paramS[num]);
				num = num + 1;
				str = SubString(str,i + 1,len);
				len = StringLength(str);
				i = -1;
			}
		}
		paramS[num]= str;
		paramI[num]= S2I(paramS[num]);
		num = num + 1;

		// 命令格式（聊天输入以 '-' 开头）：
		// -lv AHhb 3    => 给测试圣骑士设置技能等级
		// -show         => 打印 A000/A001 内技能等级
		if (paramS[0] == "lv") {
			if (num >= 3) {
				u = getOrCreateTestPaladin(p);
				setupSpellBooks(u);
				lv = paramI[2];
				setAbilityLevelByStr(u, paramS[1], lv);
			} else {
				DisplayTextToPlayer(p, 0, 0, "|cffff0000用法错误：|-lv 技能ID 等级|r 例如：-lv AHhb 3");
			}
		} else if (paramS[0] == "show") {
			u = getOrCreateTestPaladin(p);
			printSpellBookListLevels(p, u, 'A000');
			printSpellBookListLevels(p, u, 'A001');
		}

		u = null;
		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[SpellBook] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTSpellBook1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTSpellBook1(GetTriggerPlayer());
			else if(str == "s2") TTestUTSpellBook2(GetTriggerPlayer());
			else if(str == "s3") TTestUTSpellBook3(GetTriggerPlayer());
			else if(str == "s4") TTestUTSpellBook4(GetTriggerPlayer());
			else if(str == "s5") TTestUTSpellBook5(GetTriggerPlayer());
			else if(str == "s6") TTestUTSpellBook6(GetTriggerPlayer());
			else if(str == "s7") TTestUTSpellBook7(GetTriggerPlayer());
			else if(str == "s8") TTestUTSpellBook8(GetTriggerPlayer());
			else if(str == "s9") TTestUTSpellBook9(GetTriggerPlayer());
			else if(str == "s10") TTestUTSpellBook10(GetTriggerPlayer());

			// SpellBookTest
		});

	}

}
//! endzinc

#endif
