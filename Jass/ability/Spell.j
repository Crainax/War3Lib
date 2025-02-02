#ifndef SpellIncluded
#define SpellIncluded

#include "Crainax/config/SharedMethod.h"
#include "Crainax/core/table/Hash_SpellDefine.j"

//! zinc
/*
法术(技能)结构体
三种:
1)id 与 sd里面的id是一样的,且不是0. -> 固定技能(entity)
2)id 与 sd里面的id不一样,使用镜像技能 -> 镜像技能(mirror) -> 带模板的英雄技能
3)id 是 0,CD什么都是自己模拟的技能 -> 虚拟技能(virtual) -> 物品技能
4)不创建结构体 -> 简单技能(simple) -> 无结构体,固定发挥
*/
library Spell {

    // 技能哈希值计算
    public function GetHashValue ( integer handleID, integer customId ) -> integer {
        // 使用两个大质数
        integer prime1 = 131071;  // 2^17-1
        integer prime2 = 179424673; // 较大的质数

        return (handleID * prime1) + (customId * prime2);
    }

    public struct spell {
        unit      u;          // 技能拥有者
        integer   spellType;  // 技能类型(0:结构技能,1:无结构技能,2:虚拟技能,3:简单技能)
        integer   id;         // 技能ID(一致则1类,不一致则2类,为0则是3类)
        spellData sd;         // 技能实例的对应技能数据
        integer   level;      // 技能等级

        STRUCT_SHARED_METHODS(spell)

        // 实体技能(有ID)
        public static method entity (unit u, integer id, integer level) -> thistype {
            thistype this;
			integer key = GetHashValue(GetHandleId(u), id);

            if (key == 0 ) { //单位没有这个技能
                return 0;
            }
            //todo:人物拥有技能判定
			// 先检查是否已存在
			if (HaveSavedInteger(HASH_SPELL, key, HASH_KEY_SPELL_SPELL)) {
				return LoadInteger(HASH_SPELL, key, HASH_KEY_SPELL_SPELL);
			}

			// 不存在才创建新的
			this = allocate();
            this.u = u;
            this.id = id;
            this.sd = spellData.byType(id);
            this.level = level;
            this.spellType = SPELL_TYPE_ENTITY;

			SaveInteger(HASH_SPELL, key, HASH_KEY_SPELL_SPELL, this);
			return this;
        }

        // 镜像技能(无ID)
        public static method mirror (unit u ,integer id, spellData sd, integer level)  -> thistype {
            thistype this;
			integer key = GetHashValue(GetHandleId(u), id);

			// 先检查是否已存在
			if (HaveSavedInteger(HASH_SPELL, key, HASH_KEY_SPELL_SPELL)) {
				return LoadInteger(HASH_SPELL, key, HASH_KEY_SPELL_SPELL);
			}

            // 不存在才创建新的
            this = allocate();
            this.u = u;
            this.id = id;
            this.spellType = SPELL_TYPE_MIRROR;
            this.sd = sd;
            this.level = level;
			SaveInteger(HASH_SPELL, key, HASH_KEY_SPELL_SPELL, this);
            return this;
        }

        // 虚拟技能(无ID)
        public static method virtual (unit u ,spellData sd, integer level)  -> thistype {
            thistype this;
			integer key = GetHashValue(GetHandleId(u), sd); //使用sd作为哈希值

			// 先检查是否已存在
			if (HaveSavedInteger(HASH_SPELL, key, HASH_KEY_SPELL_SPELL)) {
				return LoadInteger(HASH_SPELL, key, HASH_KEY_SPELL_SPELL);
			}

            // 不存在才创建新的
            this = allocate();
            this.u = u;
            this.id = 0;
            this.spellType = SPELL_TYPE_VIRTUAL;
            this.sd = sd;
            this.level = level;
			SaveInteger(HASH_SPELL, key, HASH_KEY_SPELL_SPELL, this);
            return this;
        }

        //销毁
        method onDestroy () {
            if (HaveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(u), sd), HASH_KEY_SPELL_SPELL)) {
                RemoveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(u), sd), HASH_KEY_SPELL_SPELL);
			}
            this.u = null;
            this.id = 0;
            this.sd = 0;
        }

    }
}

//! endzinc
#endif
