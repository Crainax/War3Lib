#ifndef UnitSpellIncluded
#define UnitSpellIncluded

#include "Crainax/data/unit/UnitData.j"
#include "Crainax/core/table/Hash_UnitDefine.j"

// 定义单位最大技能数量
#define MAX_UNIT_CURRENT_SPELLS 200

//! zinc
/*
每个单位拥有的技能
*/
library UnitSpell requires Spell {

    public struct unitSpell {
        STRUCT_SHARED_METHODS(unitSpell)

        unit u;                       // 所属单位
        integer spellCount = 0;       // 当前技能数量

        // 添加技能
        method addSpell(spell sp) {
            if (sp == 0) { return; }      // 无效的技能
            if (this.spellCount >= MAX_UNIT_CURRENT_SPELLS) { return; }

            SaveInteger(HASH_UNIT, GetHandleId(this.u),
            HASH_KEY_UNIT_UNITSPELL_IDS + this.spellCount, sp);
            this.spellCount += 1;
        }

        // 获取技能数量
        method getSpellCount() -> integer {
            return this.spellCount;
        }

        // 获取指定索引的技能
        method getSpell(integer index) -> spell {
            if (index >= 0 && index < this.spellCount) {
                return LoadInteger(HASH_UNIT, GetHandleId(this.u),
                HASH_KEY_UNIT_UNITSPELL_IDS + index);
            }
            return 0;
        }


        // 初始化默认技能(从unitData继承)
        private method initDefaultSpell() {
            integer i = 0;
            spellData sd = 0;
            integer level = 0;
            integer maxLevel = 0;
            spell sp = 0;
            unitData ud = unitData.byType(GetUnitTypeId(this.u));

            this.spellCount = 0; // 初始化技能数量

            // 从unitData创建所有技能
            for (0 <= i < ud.getSpellCount()) {
                sd = ud.getSpellId(i);
                level = ud.getSpellLevel(i);
                maxLevel = sd.maxLevel;
                sp = spell.entity(this.u, sd, IMinBJ(level, IMaxBJ(maxLevel, 1)));
                if (sp != 0) {
                    SaveInteger(HASH_UNIT, GetHandleId(this.u),
                    HASH_KEY_UNIT_UNITSPELL_IDS + this.spellCount, sp);
                    this.spellCount += 1;
                }
            }
        }

        // 构造函数
        static method parse(unit u) -> thistype {
            thistype this;
            integer handleId = GetHandleId(u);

            // 先检查是否已存在
            if (HaveSavedInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITSPELL)) {
                return LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITSPELL);
            }

            // 不存在才创建新的
            this = thistype.allocate();
            this.u = u;
            this.initDefaultSpell();  // 默认初始化技能

            SaveInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITSPELL, this);
            return this;
        }

        // 获取已存在的实例
        static method get(unit u) -> thistype {
            if (HaveSavedInteger(HASH_UNIT, GetHandleId(u), HASH_KEY_UNIT_UNITSPELL)) {
                return LoadInteger(HASH_UNIT, GetHandleId(u), HASH_KEY_UNIT_UNITSPELL);
            }
            return 0;
        }

        method onDestroy() {
            integer i = 0;

            // 清理所有技能引用
            for (0 <= i < this.spellCount) {
                RemoveSavedInteger(HASH_UNIT, GetHandleId(this.u),
                HASH_KEY_UNIT_UNITSPELL_IDS + i);
            }

            if (HaveSavedInteger(HASH_UNIT, GetHandleId(this.u), HASH_KEY_UNIT_UNITSPELL)) {
                RemoveSavedInteger(HASH_UNIT, GetHandleId(this.u), HASH_KEY_UNIT_UNITSPELL);
            }
            this.u = null;
        }

        static method onInit () {
            unitLifeCycle.registerDestroy(function () {
				unit u = unitLifeCycle.argsUnit;
				thistype this = thistype.get(u);
				if (this.isExist()) {
					this.destroy();
				}
				u = null;
			});
        }
    }
}

//! endzinc

#undef MAX_UNIT_CURRENT_SPELLS
#endif
