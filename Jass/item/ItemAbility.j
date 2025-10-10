#ifndef ItemAbilityIncluded
#define ItemAbilityIncluded

#include "Crainax/core/constant/TypeConstant.j" // UI常量

/*
    物品里的技能（简化维护 + 安全键位 + 最大等级聚合）
    - 独立 hashtable: HASH_UNIT_ABILITY
    - 父键 = GetHandleId(u)
    - 子键设计（不越界）：
        - KEY_MAX(abilityId)    = -1000000000 - abilityId
        - KEY_TOTAL(abilityId)  = -1100000000 - abilityId
        - KEY_LV(abilityId, lv) = -1200000000 - abilityId*100 - lv
    - SetItemAbility1/2 支持等级；叠加同技能时取最大等级；移除时回退
*/

//! zinc

#define KEY_ITEM_ABILITY_1_LV 'A1LV'
#define KEY_ITEM_ABILITY_2_LV 'A2LV'

library ItemAbility {

    hashtable HASH_UNIT_ABILITY = InitHashtable();

    // 子键生成（注意：abilityId 和 lv 都应为正数）
    private function KEY_MAX(integer abilityId) -> integer { return -1000000000 - abilityId; }
    private function KEY_TOTAL(integer abilityId) -> integer { return -1100000000 - abilityId; }
    private function KEY_LV(integer abilityId, integer lv) -> integer { return -1200000000 - abilityId*100 - lv; }

    private function LoadTypeAbilityId(integer origin, integer keyId) -> integer {
        if (HaveSavedInteger(HASH_TYPEID, origin, keyId)) { return LoadInteger(HASH_TYPEID, origin, keyId); }
        return 0;
    }
    private function LoadTypeAbilityLv(integer origin, integer keyLv) -> integer {
        integer lv = 0;
        if (HaveSavedInteger(HASH_TYPEID, origin, keyLv)) { lv = LoadInteger(HASH_TYPEID, origin, keyLv); }
        if (lv < 1) { lv = 1; }
        return lv;
    }

    // 配置物品类型的技能1（ID + 等级）
    public function SetItemAbility1Level(integer itemID, integer abilityId, integer level) {
        if (abilityId != 0 && level > 0) {
            SaveInteger(HASH_TYPEID, itemID, KEY_ITEM_ABILITY_1, abilityId);
            SaveInteger(HASH_TYPEID, itemID, KEY_ITEM_ABILITY_1_LV, level);
        } else {
            RemoveSavedInteger(HASH_TYPEID, itemID, KEY_ITEM_ABILITY_1);
            RemoveSavedInteger(HASH_TYPEID, itemID, KEY_ITEM_ABILITY_1_LV);
        }
    }
    // 配置物品类型的技能2（ID + 等级）
    public function SetItemAbility2Level(integer itemID, integer abilityId, integer level) {
        if (abilityId != 0 && level > 0) {
            SaveInteger(HASH_TYPEID, itemID, KEY_ITEM_ABILITY_2, abilityId);
            SaveInteger(HASH_TYPEID, itemID, KEY_ITEM_ABILITY_2_LV, level);
        } else {
            RemoveSavedInteger(HASH_TYPEID, itemID, KEY_ITEM_ABILITY_2);
            RemoveSavedInteger(HASH_TYPEID, itemID, KEY_ITEM_ABILITY_2_LV);
        }
    }

    public function ItemHasAbility(item it, integer origin) -> boolean {
        return HaveSavedInteger(HASH_TYPEID, origin, KEY_ITEM_ABILITY_1)
            || HaveSavedInteger(HASH_TYPEID, origin, KEY_ITEM_ABILITY_2);
    }

    // 增加来源并维持最大等级
    private function GrantAbility(unit u, integer abilityId, integer lv) {
        integer uid; integer total; integer cntLv; integer curMax;
        if (abilityId == 0 || lv <= 0) return;
        uid = GetHandleId(u);
        total = LoadInteger(HASH_UNIT_ABILITY, uid, KEY_TOTAL(abilityId)) + 1;
        SaveInteger(HASH_UNIT_ABILITY, uid, KEY_TOTAL(abilityId), total);
        cntLv = LoadInteger(HASH_UNIT_ABILITY, uid, KEY_LV(abilityId, lv)) + 1;
        SaveInteger(HASH_UNIT_ABILITY, uid, KEY_LV(abilityId, lv), cntLv);
        curMax = LoadInteger(HASH_UNIT_ABILITY, uid, KEY_MAX(abilityId));
        if (lv > curMax) { SaveInteger(HASH_UNIT_ABILITY, uid, KEY_MAX(abilityId), lv); curMax = lv; }
        if (GetUnitAbilityLevel(u, abilityId) == 0) { UnitAddAbility(u, abilityId); }
        if (GetUnitAbilityLevel(u, abilityId) < curMax) { SetUnitAbilityLevel(u, abilityId, curMax); }
    }

    // 减少来源并在必要时回退最大等级或移除技能
    private function RevokeAbility(unit u, integer abilityId, integer lv) {
        integer uid; integer total; integer cntLv; integer curMax; integer newMax;
        if (abilityId == 0 || lv <= 0) return;
        uid = GetHandleId(u);
        total = LoadInteger(HASH_UNIT_ABILITY, uid, KEY_TOTAL(abilityId));
        if (total <= 0) return;
        cntLv = LoadInteger(HASH_UNIT_ABILITY, uid, KEY_LV(abilityId, lv));
        if (cntLv > 1) { SaveInteger(HASH_UNIT_ABILITY, uid, KEY_LV(abilityId, lv), cntLv - 1); }
        else { RemoveSavedInteger(HASH_UNIT_ABILITY, uid, KEY_LV(abilityId, lv)); }
        total = total - 1;
        if (total <= 0) {
            UnitRemoveAbility(u, abilityId);
            RemoveSavedInteger(HASH_UNIT_ABILITY, uid, KEY_TOTAL(abilityId));
            RemoveSavedInteger(HASH_UNIT_ABILITY, uid, KEY_MAX(abilityId));
            return;
        }
        SaveInteger(HASH_UNIT_ABILITY, uid, KEY_TOTAL(abilityId), total);
        curMax = LoadInteger(HASH_UNIT_ABILITY, uid, KEY_MAX(abilityId));
        if (lv == curMax && LoadInteger(HASH_UNIT_ABILITY, uid, KEY_LV(abilityId, lv)) == 0) {
            newMax = curMax - 1;
            while (newMax >= 1 && LoadInteger(HASH_UNIT_ABILITY, uid, KEY_LV(abilityId, newMax)) == 0) { newMax = newMax - 1; }
            if (newMax >= 1) {
                SaveInteger(HASH_UNIT_ABILITY, uid, KEY_MAX(abilityId), newMax);
                if (GetUnitAbilityLevel(u, abilityId) > newMax) { SetUnitAbilityLevel(u, abilityId, newMax); }
            } else {
                // 自愈；理论上不会发生（total>0 却无等级桶）
                UnitRemoveAbility(u, abilityId);
                RemoveSavedInteger(HASH_UNIT_ABILITY, uid, KEY_TOTAL(abilityId));
                RemoveSavedInteger(HASH_UNIT_ABILITY, uid, KEY_MAX(abilityId));
            }
        }
    }

    // 单位获得物品：根据“物品类型配置”的技能授予（it 不参与判重）
    public function UnitAddItemAbility(unit u, integer origin) {
        integer abilityId; integer lv;
        if (HaveSavedInteger(HASH_TYPEID, origin, KEY_ITEM_ABILITY_1)) {
            abilityId = LoadInteger(HASH_TYPEID, origin, KEY_ITEM_ABILITY_1);
            lv = LoadTypeAbilityLv(origin, KEY_ITEM_ABILITY_1_LV);
            GrantAbility(u, abilityId, lv);
        }
        if (HaveSavedInteger(HASH_TYPEID, origin, KEY_ITEM_ABILITY_2)) {
            abilityId = LoadInteger(HASH_TYPEID, origin, KEY_ITEM_ABILITY_2);
            lv = LoadTypeAbilityLv(origin, KEY_ITEM_ABILITY_2_LV);
            GrantAbility(u, abilityId, lv);
        }
    }

    // 单位失去物品：撤销对应的技能贡献（it 不参与判重）
    public function UnitReduceItemAbility(unit u, integer origin) {
        integer abilityId; integer lv;
        if (HaveSavedInteger(HASH_TYPEID, origin, KEY_ITEM_ABILITY_1)) {
            abilityId = LoadInteger(HASH_TYPEID, origin, KEY_ITEM_ABILITY_1);
            lv = LoadTypeAbilityLv(origin, KEY_ITEM_ABILITY_1_LV);
            RevokeAbility(u, abilityId, lv);
        }
        if (HaveSavedInteger(HASH_TYPEID, origin, KEY_ITEM_ABILITY_2)) {
            abilityId = LoadInteger(HASH_TYPEID, origin, KEY_ITEM_ABILITY_2);
            lv = LoadTypeAbilityLv(origin, KEY_ITEM_ABILITY_2_LV);
            RevokeAbility(u, abilityId, lv);
        }
    }

}
//! endzinc

#endif