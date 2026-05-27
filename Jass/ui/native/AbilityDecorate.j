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
#include "Crainax/ui/native/AbilityDecorateData.j"


library AbilityDecorate requires SpellBtns,HashTable,AbilityDecorateData {
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
        integer parentKey; integer ck; string iconPath; integer gdId; growdata gd; string ctext; integer fontSize; boolean shadow;

        parentKey = GetAbilityHashKey(u, abilId);
        if (parentKey == 0) { return; }

        // 暗图层（默认不显示）
        ck = HASH_CHILD_SALT_SHADOW;
        shadow = false;
        if (HaveSavedBoolean(HASH_ABILITY, parentKey, ck)) {
            shadow = LoadBoolean(HASH_ABILITY, parentKey, ck);
        }

        // 图标
        ck = HASH_CHILD_SALT_ICON;
        iconPath = LoadStr(HASH_ABILITY, parentKey, ck);
        if (iconPath != null && StringLength(iconPath) > 0) {
            spellBtns.icons[row][col].setTexture(iconPath).show(true);
        } else {
            // 无自定义图标时：若需要显示暗图层，保持图标层可见（空图即可）
            spellBtns.icons[row][col].setTexture(UI_STRING_PATH_BLANK).show(shadow);
        }

        // 流光
        ck = HASH_CHILD_SALT_GLOW;
        gdId = LoadInteger(HASH_ABILITY, parentKey, ck);
        if (gdId != 0) {
            gd = gdId;
            spellBtns.icons[row][col].grow(gd);
        } else {
            spellBtns.icons[row][col].unGrow();
        }

        // 角落文字
        ck = HASH_CHILD_SALT_CORNER;
        ctext = LoadStr(HASH_ABILITY, parentKey, ck);
        if (ctext != null && StringLength(ctext) > 0) {
            spellBtns.icons[row][col].setCornerText(ctext);
        } else {
            spellBtns.icons[row][col].setCornerText(null);
        }

        // 右上角文字
        ck = HASH_CHILD_SALT_TOP_RIGHT;
        ctext = LoadStr(HASH_ABILITY, parentKey, ck);
        if (ctext != null && StringLength(ctext) > 0) {
            fontSize = LoadInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_TOP_RIGHT_SIZE);
            if (fontSize <= 0) { fontSize = 2; }
            spellBtns.icons[row][col].setTopRightText(ctext, fontSize);
        } else {
            spellBtns.icons[row][col].setTopRightText(null, 0);
        }

        spellBtns.icons[row][col].setShadow(shadow);
    }

    // 清理单个技能槽位的所有装饰覆盖
    private function ClearAbilityDecorSlot(integer row, integer col) {
        spellBtns.icons[row][col].setTexture(UI_STRING_PATH_BLANK).show(false);
        spellBtns.icons[row][col].unGrow();
        spellBtns.icons[row][col].setCornerText(null);
        spellBtns.icons[row][col].setTopRightText(null, 0);
        spellBtns.icons[row][col].setShadow(false);
    }

    // 清理整页技能栏（12格）上的装饰覆盖
    public function ClearAbilityDecorUI() {
        integer row; integer col;
        for (1 <= row <= 3) {
            for (1 <= col <= 4) {
                ClearAbilityDecorSlot(row, col);
            }
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

    // 将装饰图标路径存入 HASH_ABILITY（父键 = 单位+技能ID，子键 = ICON）
    public function SetAbilityDecorateIcon (unit u, integer abilityID, string path) {
        integer parentKey;
        parentKey = GetAbilityHashKey(u, abilityID);
        if (parentKey == 0) { return; }
        if (path == null) {
            RemoveSavedString(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ICON);
        } else {
            SaveStr(HASH_ABILITY, parentKey, HASH_CHILD_SALT_ICON, path);
        }

        // 即时刷新：若当前选中单位为目标单位，则更新对应技能槽(注意:异步操作)
        DoImmediateRefresh(u, abilityID);
    }

    // 将装饰流光数据存入 HASH_ABILITY（0 表示无流光，父键 = 单位+技能ID，子键 = GLOW）
    public function SetAbilityDecorateGrow (unit u, integer abilityID, growdata gd) {
        integer parentKey;
        parentKey = GetAbilityHashKey(u, abilityID);
        if (parentKey == 0) { return; }
        if (gd == 0) {
            RemoveSavedInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_GLOW);
        } else {
            SaveInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_GLOW, gd);
        }

        // 即时刷新(注意:异步操作)
        DoImmediateRefresh(u, abilityID);
    }

    // 将角落文字装饰存入 HASH_ABILITY（null 或空串表示移除，父键 = 单位+技能ID，子键 = CORNER）
    public function SetAbilityDecorateCornerText (unit u, integer abilityID, string text) {
        integer parentKey;
        parentKey = GetAbilityHashKey(u, abilityID);
        if (parentKey == 0) { return; }
        if (text == null || StringLength(text) == 0) {
            RemoveSavedString(HASH_ABILITY, parentKey, HASH_CHILD_SALT_CORNER);
        } else {
            SaveStr(HASH_ABILITY, parentKey, HASH_CHILD_SALT_CORNER, text);
        }

        // 即时刷新(注意:异步操作)
        DoImmediateRefresh(u, abilityID);
    }

    // 将右上角文字装饰存入 HASH_ABILITY（null 或空串表示移除，父键 = 单位+技能ID）
    public function SetAbilityDecorateTopRightText(unit u, integer abilityID, string text, integer fontSize) {
        integer parentKey;
        parentKey = GetAbilityHashKey(u, abilityID);
        if (parentKey == 0) { return; }
        if (text == null || StringLength(text) == 0) {
            RemoveSavedString(HASH_ABILITY, parentKey, HASH_CHILD_SALT_TOP_RIGHT);
            RemoveSavedInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_TOP_RIGHT_SIZE);
        } else {
            SaveStr(HASH_ABILITY, parentKey, HASH_CHILD_SALT_TOP_RIGHT, text);
            SaveInteger(HASH_ABILITY, parentKey, HASH_CHILD_SALT_TOP_RIGHT_SIZE, IMaxBJ(1, fontSize));
        }

        // 即时刷新(注意:异步操作)
        DoImmediateRefresh(u, abilityID);
    }

    // 将暗图层开关存入 HASH_ABILITY（默认 false，不显示）
    public function SetAbilityDecorateShadow (unit u, integer abilityID, boolean flag) {
        integer parentKey;
        parentKey = GetAbilityHashKey(u, abilityID);
        if (parentKey == 0) { return; }
        if (flag) {
            SaveBoolean(HASH_ABILITY, parentKey, HASH_CHILD_SALT_SHADOW, true);
        } else {
            RemoveSavedBoolean(HASH_ABILITY, parentKey, HASH_CHILD_SALT_SHADOW);
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
                // 被排除的单位由业务侧自行处理技能栏装饰
                u = null;
                return;
            }

            if (u != null && abilCode != 0) {
                ApplyAbilityDecorToSlot(u, abilCode, row, col);
            } else {
                // 槽位清空或无法获取能力：还原覆盖层
                ClearAbilityDecorSlot(row, col);
            }
            u = null;
        });
    }
}

//! endzinc
#endif

