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

        // 检查技能是否已存在
        private method hasSpell(spell sp) -> boolean {
            integer i = 0;
            integer handleId = GetHandleId(this.u);
            spell existingSpell;

            for (0 <= i < this.spellCount) {
                existingSpell = LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITSPELL_IDS + i);
                if (existingSpell == sp) {
                    return true;
                }
            }
            return false;
        }

        // 通过spellData添加技能
        method addSpellData(spellData sd, integer level) -> boolean {
            spell sp = 0;

            if (this.spellCount >= MAX_UNIT_CURRENT_SPELLS) {
                return false;
            }

            // 创建技能实例
            if (sd.spellType == SPELL_TYPE_ENTITY) {
                sp = spell.entity(this.u, sd.id, IMinBJ(level, IMaxBJ(sd.maxLevel, 1)));
            // } else if (sd.spellType == SPELL_TYPE_MIRROR) {
            //     sp = spell.mirror(this.u, sd.id, IMinBJ(level, IMaxBJ(sd.maxLevel, 1)));
            } else if (sd.spellType == SPELL_TYPE_VIRTUAL) {
                sp = spell.virtual(this.u, sd.id, IMinBJ(level, IMaxBJ(sd.maxLevel, 1)));
            } else if (sd.spellType == SPELL_TYPE_SIMPLE) {
                // sp = spell.virtual(this.u, sd.id, IMinBJ(level, IMaxBJ(sd.maxLevel, 1)));
            }
            if (sp == 0) {
                return false;
            }

            // 检查是否已存在相同的技能实例
            if (this.hasSpell(sp)) {
                return false;
            }

            SaveInteger(HASH_UNIT, GetHandleId(this.u),
                HASH_KEY_UNIT_UNITSPELL_IDS + this.spellCount, sp);
            this.spellCount += 1;
            return true;
        }

        // 直接添加技能实例
        method addSpell(spell sp) -> spell {
            if (this.spellCount >= MAX_UNIT_CURRENT_SPELLS) {
                return 0;
            }

            if (!sp.isExist()) {
                return 0;
            }

            // 检查是否已存在相同的技能实例
            if (this.hasSpell(sp)) {
                return 0;
            }

            SaveInteger(HASH_UNIT, GetHandleId(this.u),
                HASH_KEY_UNIT_UNITSPELL_IDS + this.spellCount, sp);
            this.spellCount += 1;
            return sp;
        }

        // 获取技能数量
        method getSpellCount() -> integer {
            return this.spellCount;
        }

        // 获取指定索引的技能
        method getSpell(integer index) -> spell {
            integer handleId = GetHandleId(this.u);
            spell sp;

            if (index >= 0 && index < this.spellCount) {
                sp = LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITSPELL_IDS + index);
                return sp;
            }
            return 0;
        }

        // 移除指定技能
        method removeSpell(spell sp) -> boolean {
            integer i = 0;
            integer handleId = GetHandleId(this.u);
            spell lastSpell = 0;
            spell targetSpell = 0;

            if (!sp.isExist()) {
                return false;
            }

            // 遍历查找技能
            for (0 <= i < this.spellCount) {
                targetSpell = LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITSPELL_IDS + i);
                if (targetSpell == sp) {
                    // 如果不是最后一个技能,则把最后一个技能移到当前位置
                    if (i < this.spellCount - 1) {
                        lastSpell = LoadInteger(HASH_UNIT, handleId,
                            HASH_KEY_UNIT_UNITSPELL_IDS + this.spellCount - 1);
                        SaveInteger(HASH_UNIT, handleId,
                            HASH_KEY_UNIT_UNITSPELL_IDS + i, lastSpell);
                    }

                    // 清理最后一个位置
                    RemoveSavedInteger(HASH_UNIT, handleId,
                        HASH_KEY_UNIT_UNITSPELL_IDS + this.spellCount - 1);
                    this.spellCount -= 1;

                    // 销毁技能对象
                    targetSpell.destroy();
                    return true;
                }
            }
            return false;
        }

        // 通过spellData移除技能
        method removeSpellData(spellData sd) -> boolean {
            spell sp = spell.get(this.u, sd.id);
            if (sp != 0) {
                return this.removeSpell(sp);
            }
            return false;
        }

        // 初始化默认技能(从unitData继承)
        private method initDefaultSpell() {
            integer i = 0;
            unitData ud = unitData.byType(GetUnitTypeId(this.u));

            this.spellCount = 0; // 初始化技能数量

            // 从unitData创建所有技能
            for (0 <= i < ud.getSpellCount()) {
                this.addSpellData(ud.getSpellId(i), ud.getSpellLevel(i));
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
            BJDebugMsg("unitSpell销毁了:"+I2S(this));
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
