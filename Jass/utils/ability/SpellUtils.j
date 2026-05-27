#ifndef SpellUtilsIncluded
#define SpellUtilsIncluded

#include "Crainax/core/constant/HashTable.j"
#include "Crainax/core/table/Hash_AbilityDefine.j"

//! zinc
/*
技能相关的工具类
*/
library SpellUtils requires HashTable, MathUtils, PlayerHeroAttr {

	// ====== Lua 交互：Ubertip 扩展 ======
	// 通过全局变量 + 触发器与 Lua 通信：
	// 对应脚本：script/depends/slk/spellutils.lua
	public trigger spellutilsUberTip_tr = null;
	public integer spellutilsUberTip_id = 0;
	public integer spellutilsUberTip_level = 0;
	public string spellutilsUberTip_result = "";

	// ====== 技能属性：被动强化变更回调 ======
	private trigger spellPassiveRateChangedTr = null;
	private player spellPassiveRateChangedPlayer = null;
	private unit spellPassiveRateChangedUnit = null;
	private integer spellPassiveRateChangedAbilityID = 0;
	private boolean spellPassiveRateChangedAll = false;

	private real playerSpellPassiveRate[];

	private function LoadAbilityReal(unit u, integer abilityID, integer childKey, real defaultValue) -> real {
		integer parentKey;

		if (u == null || abilityID == 0) { return defaultValue; }

		parentKey = GetAbilityHashKey(u, abilityID);
		if (parentKey == 0 || !HaveSavedReal(HASH_ABILITY, parentKey, childKey)) {
			return defaultValue;
		}
		return LoadReal(HASH_ABILITY, parentKey, childKey);
	}

	private function SaveAbilityReal(unit u, integer abilityID, integer childKey, real value, real emptyValue) {
		integer parentKey;

		if (u == null || abilityID == 0) { return; }

		parentKey = GetAbilityHashKey(u, abilityID);
		if (parentKey == 0) { return; }

		if (value == emptyValue) {
			if (HaveSavedReal(HASH_ABILITY, parentKey, childKey)) {
				RemoveSavedReal(HASH_ABILITY, parentKey, childKey);
			}
		} else {
			SaveReal(HASH_ABILITY, parentKey, childKey, value);
		}
	}

	private function FireSpellPassiveRateChanged(player p, unit u, integer abilityID, boolean isAll) {
		if (spellPassiveRateChangedTr == null) { return; }

		spellPassiveRateChangedPlayer = p;
		spellPassiveRateChangedUnit = u;
		spellPassiveRateChangedAbilityID = abilityID;
		spellPassiveRateChangedAll = isAll;
		TriggerEvaluate(spellPassiveRateChangedTr);
		spellPassiveRateChangedPlayer = null;
		spellPassiveRateChangedUnit = null;
		spellPassiveRateChangedAbilityID = 0;
		spellPassiveRateChangedAll = false;
	}

	//异步获取当前单位的指定xy位置的技能id
	// param x    x坐标
	// param y    y坐标
	// return 技能id
	public function GetCurrentXYAbility (integer x,integer y)    -> integer {
		return S2I(EXExecuteScript("(require 'jass.message').button("+I2S(x)+", "+I2S(y)+")"));
	}

	//异步获取当前单位的指定xy位置的指令id（Lua 第二返回值）
	// param x    x坐标
	// param y    y坐标
	// return 指令id
	public function GetCurrentXYAbilityOrder (integer x,integer y)    -> integer {
		return S2I(EXExecuteScript("select(2, (require 'jass.message').button("+I2S(x)+", "+I2S(y)+"))"));
	}


	//获取技能提示工具 - 扩展
	//获取技能图标
	public function GetAbilityArt (integer id)    -> string {
		return YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ABILITY, id, "Art");
	}

	//获取提示工具 - 学习
	public function GetAbilityResearchTip (integer id)    -> string {
		return YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ABILITY, id, "ResearchTip");
	}

	//获取冷却数值
	public function GetAbilityCool (integer id,integer level)    -> real {
		return YDWEGetObjectPropertyReal(YDWE_OBJECT_TYPE_ABILITY, id, "Cool1");
	}

	//获取技能介绍（支持按等级获取）
	// param id     技能id
	// param level  技能等级（从1开始），当 SLK 中为 table 时，取第 level 个元素
	// return       对应等级的 Ubertip 文本；不存在则返回空字符串
	public function GetAbilityUberTip (integer id, integer level)    -> string {
		// 设置参数，触发 Lua 侧逻辑
		spellutilsUberTip_id = id;
		spellutilsUberTip_level = level;
		spellutilsUberTip_result = "";

		if (spellutilsUberTip_tr != null) {
			TriggerEvaluate(spellutilsUberTip_tr);
		}

		// Lua 侧未初始化或未返回结果时，回退到原有 YDWE 行为
		// if (spellutilsUberTip_result == "" && id != 0) {
		// 	spellutilsUberTip_result = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ABILITY, id, "Ubertip");
		// }

		return spellutilsUberTip_result;
	}

	// 刷新技能CD
	public function RefreshAbility (unit u,integer id)    -> nothing {
		integer level = GetUnitAbilityLevel(u,id);
		if (level < 1) {return ;}
		UnitRemoveAbility(u,id);
		UnitAddAbility(u,id);
		SetUnitAbilityLevel(u,id,level);
	}

	// 给英雄加技能永久性
	public function UnitAddAbilityP(unit u, integer i) {
		UnitAddAbility(u, i);
		UnitMakeAbilityPermanent(u, true, i);
	}

	// ====== 技能最终伤害 ======
	private function GetAbilitySpellFinalDamageRateUp(unit u, integer abilityID) -> real {
		return LoadAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_FINAL_DAMAGE_UP, 1.0);
	}

	private function GetAbilitySpellFinalDamageRateDown(unit u, integer abilityID) -> real {
		return LoadAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_FINAL_DAMAGE_DOWN, 1.0);
	}

	public function AddAbilitySpellFinalDamageRateUp(unit u, integer abilityID, real value) {
		real multiplier; real v;

		if (u == null || abilityID == 0 || value == 0.0) { return; }

		multiplier = GetAbilitySpellFinalDamageRateUp(u, abilityID);
		if (value > 0.0) {
			multiplier = multiplier * (1.0 + value);
		} else {
			v = -value;
			multiplier = multiplier / (1.0 + v);
		}
		SaveAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_FINAL_DAMAGE_UP, multiplier, 1.0);
	}

	public function AddAbilitySpellFinalDamageRateDown(unit u, integer abilityID, real value) {
		real multiplier; real v; real denom;

		if (u == null || abilityID == 0 || value == 0.0) { return; }
		if (value >= 1.0 || value <= -1.0) { return; }

		multiplier = GetAbilitySpellFinalDamageRateDown(u, abilityID);
		if (value > 0.0) {
			multiplier = multiplier * (1.0 - value);
		} else {
			v = -value;
			denom = 1.0 - v;
			if (denom <= 0.0) { return; }
			multiplier = multiplier / denom;
		}
		SaveAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_FINAL_DAMAGE_DOWN, multiplier, 1.0);
	}

	public function GetAbilitySpellFinalDamageRate(unit u, integer abilityID) -> real {
		if (u == null || abilityID == 0) { return 1.0; }
		return RMaxBJ(0.0, GetAbilitySpellFinalDamageRateUp(u, abilityID) * GetAbilitySpellFinalDamageRateDown(u, abilityID));
	}

	public function GetTotalSpellFinalDamageRate(unit u, integer abilityID) -> real {
		if (u == null) { return 1.0; }
		return plyaerHeroAttr.getTotalSpellFinalDamageRate(GetOwningPlayer(u)) * GetAbilitySpellFinalDamageRate(u, abilityID);
	}

	// ====== 技能范围 ======
	public function AddAbilitySpellRangeRateUp(unit u, integer abilityID, real value) {
		real rate;

		if (u == null || abilityID == 0 || value == 0.0) { return; }

		rate = LoadAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_RANGE_UP, 0.0) + value;
		SaveAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_RANGE_UP, rate, 0.0);
	}

	public function AddAbilitySpellRangeRateDown(unit u, integer abilityID, real value) {
		real rate;

		if (u == null || abilityID == 0 || value == 0.0) { return; }

		rate = RealAdd(LoadAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_RANGE_DOWN, 0.0), value);
		SaveAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_RANGE_DOWN, rate, 0.0);
	}

	public function GetAbilitySpellRangeRate(unit u, integer abilityID) -> real {
		real up; real down;

		if (u == null || abilityID == 0) { return 1.0; }

		up = LoadAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_RANGE_UP, 0.0);
		down = LoadAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_RANGE_DOWN, 0.0);
		return RMaxBJ(0.0, (1.0 + up) * (1.0 - down));
	}

	// ====== 被动强化 ======
	public function AddPlayerSpellPassiveRate(player p, real value) {
		integer pid;

		if (p == null || value == 0.0) { return; }

		pid = GetConvertedPlayerId(p);
		playerSpellPassiveRate[pid] += value;
		FireSpellPassiveRateChanged(p, null, 0, true);
	}

	public function GetPlayerSpellPassiveRate(player p) -> real {
		if (p == null) { return 0.0; }
		return playerSpellPassiveRate[GetConvertedPlayerId(p)];
	}

	public function AddAbilitySpellPassiveRate(unit u, integer abilityID, real value) {
		real rate;

		if (u == null || abilityID == 0 || value == 0.0) { return; }

		rate = LoadAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_PASSIVE_RATE, 0.0) + value;
		SaveAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_PASSIVE_RATE, rate, 0.0);
		FireSpellPassiveRateChanged(GetOwningPlayer(u), u, abilityID, false);
	}

	public function GetAbilitySpellPassiveRate(unit u, integer abilityID) -> real {
		return LoadAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_PASSIVE_RATE, 0.0);
	}

	public function GetTotalSpellPassiveRate(unit u, integer abilityID) -> real {
		if (u == null) { return 1.0; }
		return RMaxBJ(0.01, 1.0 + GetPlayerSpellPassiveRate(GetOwningPlayer(u)) + GetAbilitySpellPassiveRate(u, abilityID));
	}

	public function HasAbilitySpellPassiveAppliedRate(unit u, integer abilityID) -> boolean {
		integer parentKey;

		if (u == null || abilityID == 0) { return false; }

		parentKey = GetAbilityHashKey(u, abilityID);
		if (parentKey == 0) { return false; }
		return HaveSavedReal(HASH_ABILITY, parentKey, HASH_CHILD_SALT_SPELL_PASSIVE_APPLIED_RATE);
	}

	public function SetAbilitySpellPassiveAppliedRate(unit u, integer abilityID, real value) {
		SaveAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_PASSIVE_APPLIED_RATE, value, 0.0);
	}

	public function GetAbilitySpellPassiveAppliedRate(unit u, integer abilityID) -> real {
		return LoadAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_PASSIVE_APPLIED_RATE, 0.0);
	}

	public function ClearAbilitySpellPassiveAppliedRate(unit u, integer abilityID) {
		SaveAbilityReal(u, abilityID, HASH_CHILD_SALT_SPELL_PASSIVE_APPLIED_RATE, 0.0, 0.0);
	}

	public function RegisterSpellPassiveRateChanged(code func) {
		if (spellPassiveRateChangedTr == null) {
			spellPassiveRateChangedTr = CreateTrigger();
		}
		TriggerAddCondition(spellPassiveRateChangedTr, Condition(func));
	}

	public function GetSpellPassiveRateChangedPlayer() -> player { return spellPassiveRateChangedPlayer; }
	public function GetSpellPassiveRateChangedUnit() -> unit { return spellPassiveRateChangedUnit; }
	public function GetSpellPassiveRateChangedAbilityID() -> integer { return spellPassiveRateChangedAbilityID; }
	public function IsSpellPassiveRateChangedAll() -> boolean { return spellPassiveRateChangedAll; }

	function onInit () {
		// 初始化 Lua 侧的 spellutils.lua（通过 Cheat 调用）
		// 对应脚本路径：script/depends/slk/spellutils.lua
		Cheat("exec-lua:depends.slk.spellutils");
	}

}

//! endzinc
#endif
