#ifndef UnitSpellIncluded
#define UnitSpellIncluded

#include "Crainax/data/unit/UnitData.j"

// 定义单位最大技能数量
#define MAX_UNIT_CURRENT_SPELLS 200

//! zinc
/*
每个单位拥有的技能
*/
library UnitSpell {

    public struct unitSpell {
        STRUCT_SHARED_METHODS(unitSpell)

        boolean isInitSpell = false;  // 是否使用默认技能配置
        unit u;                       // 所属单位
        unitData ud;                  // 单位类型的技能数据

        // 使用默认技能配置(从unitData继承)
        method useDefaultSpells() {
            isInitSpell = true;  // 使用unitData的技能配置
            SaveInteger(HASH_UNIT, GetHandleId(this.u), HASH_KEY_UNIT_SPELL_COUNT, 0);
        }

        // 设置为自定义技能配置
        method setCustomSpells() {
            isInitSpell = false;
            SaveInteger(HASH_UNIT, GetHandleId(this.u), HASH_KEY_UNIT_SPELL_COUNT, 0);
        }

        // 添加自定义技能
        method addCustomSpell(integer spellId, integer level) {
            integer count = 0;
            if (isInitSpell) { return; }  // 如果使用默认配置则不允许添加

            count = LoadInteger(HASH_UNIT, GetHandleId(this.u), HASH_KEY_UNIT_SPELL_COUNT);
            if (count >= MAX_UNIT_CURRENT_SPELLS) { return; }

            SaveInteger(HASH_UNIT, GetHandleId(this.u),
                HASH_KEY_UNIT_SPELL_IDS + count, spellId);
            SaveInteger(HASH_UNIT, GetHandleId(this.u),
                HASH_KEY_UNIT_SPELL_LEVELS + count, level);
            SaveInteger(HASH_UNIT, GetHandleId(this.u),
                HASH_KEY_UNIT_SPELL_COUNT, count + 1);
        }

        // 获取技能数量
        method getSpellCount() -> integer {
            if (isInitSpell) {
                return this.ud.getSpellCount();
            }
            return LoadInteger(HASH_UNIT, GetHandleId(this.u), HASH_KEY_UNIT_SPELL_COUNT);
        }

        // 获取指定索引的技能ID
        method getSpellId(integer index) -> integer {
            if (isInitSpell) {
                return this.ud.getSpellId(index);
            }
            if (index >= 0 && index < this.getSpellCount()) {
                return LoadInteger(HASH_UNIT, GetHandleId(this.u),
                    HASH_KEY_UNIT_SPELL_IDS + index);
            }
            return 0;
        }

        // 获取指定索引的技能等级
        method getSpellLevel(integer index) -> integer {
            if (isInitSpell) {
                return this.ud.getSpellLevel(index);
            }
            if (index >= 0 && index < this.getSpellCount()) {
                return LoadInteger(HASH_UNIT, GetHandleId(this.u),
                    HASH_KEY_UNIT_SPELL_LEVELS + index);
            }
            return 0;
        }

        // 构造函数
        static method parse(unit u) -> thistype {
            thistype this;
            integer handleId = GetHandleId(u);

            // 先检查是否已存在
            if (HaveSavedInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_SPELL)) {
                return LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_SPELL);
            }

            // 不存在才创建新的
            this = thistype.allocate();
            this.u = u;
            this.ud = unitData.byType(GetUnitTypeId(u));
            this.useDefaultSpells();  // 默认使用unitData的技能配置

            SaveInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_SPELL, this);
            return this;
        }

        // 获取已存在的实例
        static method get(unit u) -> thistype {
            if (HaveSavedInteger(HASH_UNIT, GetHandleId(u), HASH_KEY_UNIT_SPELL)) {
                return LoadInteger(HASH_UNIT, GetHandleId(u), HASH_KEY_UNIT_SPELL);
            }
            return 0;
        }

        method onDestroy() {
            if (HaveSavedInteger(HASH_UNIT, GetHandleId(this.u), HASH_KEY_UNIT_SPELL)) {
                RemoveSavedInteger(HASH_UNIT, GetHandleId(this.u), HASH_KEY_UNIT_SPELL);
            }
            this.u = null;
        }
    }
}

//! endzinc

#undef MAX_UNIT_CURRENT_SPELLS
#endif
