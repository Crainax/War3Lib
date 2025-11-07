#ifndef AbilityDecorateIncluded
#define AbilityDecorateIncluded

//! zinc
/*
技能栏装饰（Icon / Grow / CornerText）
*/
#include "Crainax/core/table/Hash_AbilityDefine.j"
#include "Crainax/core/table/Hash_UnitDefine.j"
#include "Crainax/core/constant/TypeConstant.j"
#include "Crainax/ui/constants/UIConstants.j" // UI常量


library AbilityDecorate requires SpellBtns,HashTable {


    // 生成子键：位运算 + 质数，避免冲突且不溢出
    private function AD_Key (unit u, integer abilId, integer salt) -> integer {
        integer uid; integer result;
        if (u == null || abilId == 0) { return 0; }
        uid = GetHandleId(u);
        // 使用位运算 + 质数组合，避免冲突
        // uid 左移16位 + abilId 左移8位 + salt，再乘以质数
        result = ((uid * 65536) + (abilId * 256) + salt) * 1009;
        return result;
    }

    // 排除单位参与技能装饰处理
    public function ExcludeUnitFromAbilityDecorate(unit u) {
        integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        SaveBoolean(HASH_UNIT, uid, HASH_KEY_UNIT_EXCLUDE_ABILITY_DECORATE, true);
    }

    // 排除单位类型参与技能装饰处理
    public function ExcludeUnitTypeFromAbilityDecorate(integer typeID) {
        if (typeID == 0) { return; }
        SaveBoolean(HASH_TYPEID, typeID, HASH_KEY_UNIT_EXCLUDE_ABILITY_DECORATE, true);
    }

    // 检查单位是否被排除（检查单位和单位类型）
    private function IsUnitExcludedFromAbilityDecorate(unit u) -> boolean {
        integer uid; integer typeID;
        if (u == null) { return false; }

        // 检查单位实例是否被排除
        uid = GetHandleId(u);
        if (HaveSavedBoolean(HASH_UNIT, uid, HASH_KEY_UNIT_EXCLUDE_ABILITY_DECORATE)) {
            return LoadBoolean(HASH_UNIT, uid, HASH_KEY_UNIT_EXCLUDE_ABILITY_DECORATE);
        }

        // 检查单位类型是否被排除
        typeID = GetUnitTypeId(u);
        if (HaveSavedBoolean(HASH_TYPEID, typeID, HASH_KEY_UNIT_EXCLUDE_ABILITY_DECORATE)) {
            return LoadBoolean(HASH_TYPEID, typeID, HASH_KEY_UNIT_EXCLUDE_ABILITY_DECORATE);
        }

        return false;
    }

    // 将哈希中的装饰应用到指定槽位
    private function ApplyAbilityDecorToSlot(unit u, integer abilId, integer row, integer col) {
        integer ck; string iconPath; integer gdId; growdata gd; string ctext;

        // 图标
        ck = AD_Key(u, abilId, HASH_CHILD_SALT_ICON);
        iconPath = LoadStr(HASH_ABILITY, HASH_PARENT_ABILITY_DECORATE, ck);
        if (iconPath != null && StringLength(iconPath) > 0) {
            spellBtns.icons[row][col].setTexture(iconPath).show(true);
        } else {
            spellBtns.icons[row][col].setTexture(UI_STRING_PATH_BLANK).show(false);
        }

        // 流光
        ck = AD_Key(u, abilId, HASH_CHILD_SALT_GLOW);
        gdId = LoadInteger(HASH_ABILITY, HASH_PARENT_ABILITY_DECORATE, ck);
        if (gdId != 0) {
            gd = gdId;
            spellBtns.icons[row][col].grow(gd);
        } else {
            spellBtns.icons[row][col].unGrow();
        }

        // 角落文字
        ck = AD_Key(u, abilId, HASH_CHILD_SALT_CORNER);
        ctext = LoadStr(HASH_ABILITY, HASH_PARENT_ABILITY_DECORATE, ck);
        if (ctext != null && StringLength(ctext) > 0) {
            spellBtns.icons[row][col].setCornerText(ctext);
        } else {
            spellBtns.icons[row][col].setCornerText(null);
        }
    }


    // 立刻刷新当前选中单位的指定技能ID对应的槽位
    private function DoImmediateRefresh(unit u, integer abilityID) {
        unit sel; integer row; integer col; integer value;
        sel = DzGetSelectedLeaderUnit();
        if (sel == u && abilityID != 0) {
            for (1 <= row <= 3) {
                for (1 <= col <= 4) {
                    value = GetCurrentXYAbility(col - 1, row - 1);
                    if (value == abilityID) {
                        ApplyAbilityDecorToSlot(sel, abilityID, row, col);
                    }
                }
            }
        }
        sel = null;
    }

    // 将装饰图标路径存入 HASH_ABILITY（固定父键 + 复合子键）
    public function SetAbilityDecorateIcon (unit u, integer abilityID, string path) {
        integer ck;
        ck = AD_Key(u, abilityID, HASH_CHILD_SALT_ICON);
        if (ck == 0) { return; }
        if (path == null) {
            RemoveSavedString(HASH_ABILITY, HASH_PARENT_ABILITY_DECORATE, ck);
        } else {
            SaveStr(HASH_ABILITY, HASH_PARENT_ABILITY_DECORATE, ck, path);
        }

        // 即时刷新：若当前选中单位为目标单位，则更新对应技能槽(注意:异步操作)
        DoImmediateRefresh(u, abilityID);
    }

    // 将装饰流光数据存入 HASH_ABILITY（0 表示无流光）
    public function SetAbilityDecorateGrow (unit u, integer abilityID, growdata gd) {
        integer ck;
        ck = AD_Key(u, abilityID, HASH_CHILD_SALT_GLOW);
        if (ck == 0) { return; }
        if (gd == 0) {
            RemoveSavedInteger(HASH_ABILITY, HASH_PARENT_ABILITY_DECORATE, ck);
        } else {
            SaveInteger(HASH_ABILITY, HASH_PARENT_ABILITY_DECORATE, ck, gd);
        }

        // 即时刷新(注意:异步操作)
        DoImmediateRefresh(u, abilityID);
    }

    // 将角落文字装饰存入 HASH_ABILITY（null 或空串表示移除）
    public function SetAbilityDecorateCornerText (unit u, integer abilityID, string text) {
        integer ck;
        ck = AD_Key(u, abilityID, HASH_CHILD_SALT_CORNER);
        if (ck == 0) { return; }
        if (text == null || StringLength(text) == 0) {
            RemoveSavedString(HASH_ABILITY, HASH_PARENT_ABILITY_DECORATE, ck);
        } else {
            SaveStr(HASH_ABILITY, HASH_PARENT_ABILITY_DECORATE, ck, text);
        }

        // 即时刷新(注意:异步操作)
        DoImmediateRefresh(u, abilityID);
    }

    function onInit ()  {
        // 监听技能栏变化，更新对应槽位的装饰
        spellBtns.onAbilityUIChange(function () {
            integer row; integer col; integer abilCode; unit u;
            row = spellBtns.getCallbackRow();
            col = spellBtns.getCallbackColumn();
            abilCode = spellBtns.getCallbackAbility();

            // 获取当前选择单位
            u = DzGetSelectedLeaderUnit();

            // 检查单位是否被排除
            if (IsUnitExcludedFromAbilityDecorate(u)) {
                // 被排除的单位，直接跳过处理
                u = null;
                return;
            }

            if (u != null && abilCode != 0) {
                ApplyAbilityDecorToSlot(u, abilCode, row, col);
            } else {
                // 槽位清空或无法获取能力：还原覆盖层
                spellBtns.icons[row][col].setTexture(UI_STRING_PATH_BLANK).show(false);
                spellBtns.icons[row][col].unGrow();
                spellBtns.icons[row][col].setCornerText(null);
            }
            u = null;
        });
    }
}

//! endzinc
#endif


