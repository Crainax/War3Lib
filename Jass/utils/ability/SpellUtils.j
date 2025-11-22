#ifndef SpellUtilsIncluded
#define SpellUtilsIncluded

//! zinc
/*
技能相关的工具类
*/
library SpellUtils {

	// ====== Lua 交互：Ubertip 扩展 ======
	// 通过全局变量 + 触发器与 Lua 通信：
	// 对应脚本：script/depends/slk/spellutils.lua
	public trigger spellutilsUberTip_tr = null;
	public integer spellutilsUberTip_id = 0;
	public integer spellutilsUberTip_level = 0;
	public string spellutilsUberTip_result = "";

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

	function onInit () {
		// 初始化 Lua 侧的 spellutils.lua（通过 Cheat 调用）
		// 对应脚本路径：script/depends/slk/spellutils.lua
		Cheat("exec-lua:depends.slk.spellutils");
	}

}

//! endzinc
#endif
