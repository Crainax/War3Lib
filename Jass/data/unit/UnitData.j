#ifndef UnitDataIncluded
#define UnitDataIncluded

#include "Crainax/config/SharedMethod.h"
#include "Crainax/core/table/Hash_SLKDefine.j"


// 定义技能最大数量
#define MAX_UNIT_SPELLS 200

//! zinc
/*
单位类型的数据
包含单位类型的技能等通用属性
todo: 加一下技能的删改查(现在只有增)
*/
library UnitData requires SpellData {

    public struct unitData [] {

        static integer counter = 0;

        // 添加技能
        public method addSpell(spellData sd, integer level) {
            integer count = 0;

            if (HaveSavedInteger(HASH_SLK, this, HASH_KEY_SLK_UNIT_SPELL_COUNT)) {
                count = LoadInteger(HASH_SLK, this, HASH_KEY_SLK_UNIT_SPELL_COUNT);
            }

            if (count >= MAX_UNIT_SPELLS) {
                return;  // 超出最大数量限制
            }

            // 保存技能ID
            SaveInteger(HASH_SLK, this, HASH_KEY_SLK_UNIT_SPELL_IDS + count, sd);
            // 保存技能等级
            SaveInteger(HASH_SLK, this, HASH_KEY_SLK_UNIT_SPELL_LEVELS + count, level);
            // 更新技能总数
            SaveInteger(HASH_SLK, this, HASH_KEY_SLK_UNIT_SPELL_COUNT, count + 1);
        }

        // 获取技能数量
        public method getSpellCount() -> integer {
            if (HaveSavedInteger(HASH_SLK, this, HASH_KEY_SLK_UNIT_SPELL_COUNT)) {
                return LoadInteger(HASH_SLK, this, HASH_KEY_SLK_UNIT_SPELL_COUNT);
            }
            return 0;
        }

        // 获取指定索引的技能ID
        public method getSpellId(integer index) -> spellData {
            if (index >= 0 && index < this.getSpellCount()) {
                return LoadInteger(HASH_SLK, this, HASH_KEY_SLK_UNIT_SPELL_IDS + index);
            }
            return 0;
        }

        // 获取指定索引的技能等级
        public method getSpellLevel(integer index) -> integer {
            if (index >= 0 && index < this.getSpellCount()) {
                return LoadInteger(HASH_SLK, this, HASH_KEY_SLK_UNIT_SPELL_LEVELS + index);
            }
            return 0;
        }

        //根据单位类型(只有这一个构造函数)
        public static method byType(integer ut) -> thistype {
            thistype this;
            if (HaveSavedInteger(HASH_SLK, ut, HASH_KEY_SLK_UNITDATA)) {
                this = LoadInteger(HASH_SLK, ut, HASH_KEY_SLK_UNITDATA);
            } else {
                counter += 1;
                this = thistype[counter];
                SaveInteger(HASH_SLK, ut, HASH_KEY_SLK_UNITDATA, this);
                //初始化
                SaveInteger(HASH_SLK, this, HASH_KEY_SLK_UNIT_SPELL_COUNT, 0);
            }
            return this;
        }
    }
}

//! endzinc

#undef MAX_UNIT_SPELLS
#endif
