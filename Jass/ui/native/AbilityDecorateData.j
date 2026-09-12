#ifndef AbilityDecorateDataIncluded
#define AbilityDecorateDataIncluded

#include "Crainax/core/constant/HashTable.j"
#include "Crainax/core/table/Hash_AbilityDefine.j"

#define ABILITY_DECORATE_CUSTOM_STRING_MAX 100

//! zinc
library AbilityDecorateData requires HashTable {

	private function GetCustomStringSlotById(integer parentKey, integer id) -> integer {
		integer i; integer count;

		if (parentKey == 0 || id == 0) { return 0; }

		count = LoadInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_COUNT);
		for (1 <= i <= count) {
			if (LoadInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_ID_BASE + i) == id) {
				return i;
			}
		}
		return 0;
	}

	// 获取单位指定技能当前挂载的自定义字符串数量。
	public function GetAbilityDecorateCustomStringCount(unit u, integer abilityID) -> integer {
		integer parentKey;

		if (u == null || abilityID == 0) { return 0; }

		parentKey = GetAbilityHashKey(u, abilityID);
		if (parentKey == 0) { return 0; }

		return LoadInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_COUNT);
	}

	// 按当前紧凑索引读取自定义字符串；索引越界时返回空字符串。
	public function GetAbilityDecorateCustomStringByIndex(unit u, integer abilityID, integer index) -> string {
		integer parentKey; integer count;

		if (u == null || abilityID == 0) { return ""; }

		parentKey = GetAbilityHashKey(u, abilityID);
		if (parentKey == 0) { return ""; }

		count = LoadInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_COUNT);
		if (index < 1 || index > count) { return ""; }

		return LoadStr(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_TEXT_BASE + index);
	}

	// 新增一条自定义字符串并返回稳定 ID；当前每个单位技能最多保存 100 条。
	public function AddAbilityDecorateCustomString(unit u, integer abilityID, string text) -> integer {
		integer parentKey; integer count; integer id;

		if (u == null || abilityID == 0 || text == null || StringLength(text) == 0) { return 0; }

		parentKey = GetAbilityHashKey(u, abilityID);
		if (parentKey == 0) { return 0; }

		count = LoadInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_COUNT);
		if (count >= ABILITY_DECORATE_CUSTOM_STRING_MAX) { return 0; }

		id = LoadInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_NEXT_ID);
		if (id <= 0) {
			id = 1;
		}
		SaveInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_NEXT_ID, id + 1);

		count = count + 1;
		SaveStr(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_TEXT_BASE + count, text);
		SaveInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_ID_BASE + count, id);
		SaveInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_COUNT, count);

		return id;
	}

	// 按稳定 ID 更新已有字符串；字符串索引可能因删除操作变化。
	public function SetAbilityDecorateCustomStringById(unit u, integer abilityID, integer id, string text) -> boolean {
		integer parentKey; integer slot;

		if (u == null || abilityID == 0 || id == 0 || text == null || StringLength(text) == 0) { return false; }

		parentKey = GetAbilityHashKey(u, abilityID);
		if (parentKey == 0) { return false; }

		slot = GetCustomStringSlotById(parentKey, id);
		if (slot == 0) { return false; }

		SaveStr(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_TEXT_BASE + slot, text);
		return true;
	}

	// 按稳定 ID 删除字符串；内部使用尾部交换保持索引紧凑。
	public function RemoveAbilityDecorateCustomString(unit u, integer abilityID, integer id) -> boolean {
		integer parentKey; integer count; integer slot; string lastText; integer lastId;

		if (u == null || abilityID == 0 || id == 0) { return false; }

		parentKey = GetAbilityHashKey(u, abilityID);
		if (parentKey == 0) { return false; }

		count = LoadInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_COUNT);
		slot = GetCustomStringSlotById(parentKey, id);
		if (slot == 0) { return false; }

		if (slot != count) {
			lastText = LoadStr(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_TEXT_BASE + count);
			lastId = LoadInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_ID_BASE + count);
			SaveStr(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_TEXT_BASE + slot, lastText);
			SaveInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_ID_BASE + slot, lastId);
		}

		RemoveSavedString(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_TEXT_BASE + count);
		RemoveSavedInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_ID_BASE + count);

		count = count - 1;
		if (count <= 0) {
			RemoveSavedInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_COUNT);
		} else {
			SaveInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_COUNT, count);
		}

		return true;
	}

}
//! endzinc

#undef ABILITY_DECORATE_CUSTOM_STRING_MAX

#endif
