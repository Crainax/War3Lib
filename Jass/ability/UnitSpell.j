#ifndef UnitSpellIncluded
#define UnitSpellIncluded

#include "Crainax/data/unit/UnitData.j"
#include "Crainax/core/table/Hash_UnitDefine.j"

// 定义单位最大技能数量(简单技能也是这个数)
#define MAX_UNIT_CURRENT_SPELLS 200

//! zinc
/*
每个单位拥有的技能
键值从 HASH_KEY_UNIT_UNITSPELL_IDS 开始的200个全是存储spell结构体的(含固定技能,镜像技能,虚拟技能)
键值从 HASH_KEY_UNIT_SIMPLESPELL_IDS 开始的200个全是存储spelldata:简单技能
可以拥有 200*2 个技能
*/
library UnitSpell requires Spell {

    public struct unitSpell {
        STRUCT_SHARED_METHODS(unitSpell)

        unit    u;                // 所属单位
        integer spellCount = 0;   // 当前技能数量
        integer simpleCount = 0;  // 简单技能的数量

        // 检查技能是否已存在(不含简单技能)
        method hasSpell(spell sp) -> boolean {
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

        // 检查单位是否拥有指定技能类型(含简单技能)
        method hasSpellData (spellData sd)  -> boolean {
            integer i;
            integer handleId = GetHandleId(this.u);
            spell sp;
            spellData existingSpell;

            if (sd.spellType == SPELL_TYPE_SIMPLE) { //简单技能的判断
                for (0 <= i < this.simpleCount) {
                    if (HaveSavedInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_SIMPLESPELL_IDS + i)) {
                        existingSpell = LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_SIMPLESPELL_IDS + i);
                        if (existingSpell == sd) {  // 检查是否是同一个spellData
                            return true;
                        }
                    }
                }
                return false;
            } else { //其他技能的判断
                for (0 <= i < this.spellCount) {
                    sp = LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITSPELL_IDS + i);
                    if (sp.sd == sd) {
                        return true;
                    }
                }
                return false;
            }

        }

        // 通过spellData添加技能
        method addSpellData(spellData sd, integer lv) -> boolean {
            spell sp = 0;
            integer level = IMinBJ(lv, IMaxBJ(sd.maxLevel, 1));

            if (sd.spellType == SPELL_TYPE_SIMPLE) { //优先处理简单技能
                if (this.simpleCount >= MAX_UNIT_CURRENT_SPELLS || this.hasSpellData(sd)) {
                    return false;
                }

                if (sd.trInit != null) {
                    sd.argsU = this.u;
                    sd.argsLevel = level;
                    TriggerEvaluate(sd.trInit);
                }

                SaveInteger(HASH_UNIT, GetHandleId(this.u),
                HASH_KEY_UNIT_SIMPLESPELL_IDS + this.simpleCount, sd);
                // 保存技能等级
                SaveInteger(HASH_UNIT, GetHandleId(this.u),
                HASH_KEY_UNIT_SIMPLESPELL_LEVELS + this.simpleCount, level);
                this.simpleCount += 1;
                return true;
            }

            //以下是其他技能
            if (this.spellCount >= MAX_UNIT_CURRENT_SPELLS) {
                return false;
            }

            // 创建技能实例
            if (sd.spellType == SPELL_TYPE_ENTITY) {
                sp = spell.entity(this.u, sd.id, level);
                // } else if (sd.spellType == SPELL_TYPE_MIRROR) {
                //     sp = spell.mirror(this.u, sd.id, level);
            } else if (sd.spellType == SPELL_TYPE_VIRTUAL) {
                sp = spell.virtual(this.u, sd.id,level) ;
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
        method addSpell(spell sp) -> boolean {
            if (this.spellCount >= MAX_UNIT_CURRENT_SPELLS) {
                return false;
            }

            if (!sp.isExist()) {
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

        // 获取技能数量
        method getSpellCount() -> integer {
            return this.spellCount;
        }

        // 获取简单技能数量
        method getSimpleSpellCount() -> integer {
            return this.simpleCount;
        }

        // 获取指定索引的技能(从0开始到count-1)
        method getSpell(integer index) -> spell {
            integer handleId = GetHandleId(this.u);
            spell sp;

            if (index >= 0 && index < this.spellCount) {
                sp = LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITSPELL_IDS + index);
                return sp;
            }
            return 0;
        }

        // 获取指定索引的简单技能类型(从0开始到count-1)
        method getSimpleSpell(integer index) -> spellData {
            integer handleId = GetHandleId(this.u);
            spellData sd;

            if (index >= 0 && index < this.simpleCount) {
                sd = LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_SIMPLESPELL_IDS + index);
                return sd;
            }
            return 0;
        }

        // 获取指定Simple技能的等级
        method getSimpleSpellLevel(spellData sd) -> integer {
            integer i = 0;
            integer handleId = GetHandleId(this.u);
            spellData targetSpell;

            // 遍历查找Simple技能
            for (0 <= i < this.simpleCount) {
                targetSpell = LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_SIMPLESPELL_IDS + i);
                if (targetSpell == sd) {
                    return LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_SIMPLESPELL_LEVELS + i);
                }
            }
            return 0; // 未找到该技能返回0
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

        // 移除指定的简单技能
        method removeSimpleSpell(spellData sd) -> boolean {
            integer i = 0;
            integer handleId = GetHandleId(this.u);
            spellData lastSpell = 0;
            spellData targetSpell = 0;
            integer targetLevel = 0;
            integer lastLevel = 0;

            // 遍历查找简单技能
            for (0 <= i < this.simpleCount) {
                targetSpell = LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_SIMPLESPELL_IDS + i);
                if (targetSpell == sd) {
                    // 获取技能等级并调用销毁触发器
                    targetLevel = LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_SIMPLESPELL_LEVELS + i);
                    if (sd.trDestroy != null) {
                        sd.argsU = this.u;
                        sd.argsLevel = targetLevel;
                        TriggerEvaluate(sd.trDestroy);
                    }

                    // 如果不是最后一个技能,则把最后一个技能移到当前位置
                    if (i < this.simpleCount - 1) {
                        lastSpell = LoadInteger(HASH_UNIT, handleId,
                        HASH_KEY_UNIT_SIMPLESPELL_IDS + this.simpleCount - 1);
                        lastLevel = LoadInteger(HASH_UNIT, handleId,
                        HASH_KEY_UNIT_SIMPLESPELL_LEVELS + this.simpleCount - 1);

                        SaveInteger(HASH_UNIT, handleId,
                        HASH_KEY_UNIT_SIMPLESPELL_IDS + i, lastSpell);
                        SaveInteger(HASH_UNIT, handleId,
                        HASH_KEY_UNIT_SIMPLESPELL_LEVELS + i, lastLevel);
                    }

                    // 清理最后一个位置
                    RemoveSavedInteger(HASH_UNIT, handleId,
                    HASH_KEY_UNIT_SIMPLESPELL_IDS + this.simpleCount - 1);
                    RemoveSavedInteger(HASH_UNIT, handleId,
                    HASH_KEY_UNIT_SIMPLESPELL_LEVELS + this.simpleCount - 1);
                    this.simpleCount -= 1;
                    return true;
                }
            }
            return false;
        }

        // 通过spellData移除技能
        method removeSpellData(spellData sd) -> boolean {
            spell sp;
            if (sd.spellType == SPELL_TYPE_SIMPLE) {
                return this.removeSimpleSpell(sd);
            } else {
                sp = spell.get(this.u, sd.id);
                if (sp != 0) {
                    return this.removeSpell(sp);
                }
            }
            return false;
        }

        // 初始化默认技能(从unitData继承)
        private method initDefaultSpell() {
            integer i = 0;
            unitData ud = unitData.byType(GetUnitTypeId(this.u));

            this.spellCount = 0; // 初始化技能数量
            this.simpleCount = 0; // 初始化简单技能数量

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
            integer handleId = GetHandleId(this.u);
            spell sp;
            spellData sd;
            integer level;

            // 销毁所有技能实例
            for (0 <= i < this.spellCount) {
                sp = LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITSPELL_IDS + i);
                if (sp != 0) {
                    sp.destroy();
                }
                RemoveSavedInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITSPELL_IDS + i);
            }

            // 清理简单技能的引用和调用销毁触发器
            for (0 <= i < this.simpleCount) {
                sd = LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_SIMPLESPELL_IDS + i);
                if (sd != 0 && sd.trDestroy != null) {
                    level = LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_SIMPLESPELL_LEVELS + i);
                    sd.argsU = this.u;
                    sd.argsLevel = level;
                    TriggerEvaluate(sd.trDestroy);
                }
                RemoveSavedInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_SIMPLESPELL_IDS + i);
                RemoveSavedInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_SIMPLESPELL_LEVELS + i);
            }

            // 清理自身的引用
            if (HaveSavedInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITSPELL)) {
                RemoveSavedInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITSPELL);
            }
            this.u = null;
        }

        static method onInit () {
            unitLifeCycle.registerDestroy(function () { //单位移除后也移除这里
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
