#ifndef SpellIncluded
#define SpellIncluded

#include "Crainax/config/SharedMethod.h"

//! zinc
/*
法术(技能)结构体
三种:
1)id 与 sd里面的id是一样的,且不是0. -> 固定技能
2)id 与 sd里面的id不一样,使用模板技能 -> 模板技能
3)id 或 sd里的id是0 ,则是虚拟的技能 -> 虚拟技能
*/
library Spell {

    public struct spell {
        unit      owner;  // 技能拥有者
        integer   id;     // 技能ID(一致则1类,不一致则2类,为0则是3类)
        spellData sd;     // 技能实例的对应技能数据

        STRUCT_SHARED_METHODS(spell)

        public static method parse (unit u, integer id) -> thistype {
            thistype this;
			integer handleId = GetHandleId(DzUnitFindAbility(u, id));

            if (handleId == 0 ) { //单位没有这个技能
                return 0;
            }

			// 先检查是否已存在
			if (HaveSavedInteger(HASH_SPELL, handleId, HASH_KEY_SPELL_SPELL)) {
				return LoadInteger(HASH_SPELL, handleId, HASH_KEY_SPELL_SPELL);
			}

			// 不存在才创建新的
			this = allocate();
            this.u = u;
            this.id = id;
            this.sd = spellData.byType(id);

			SaveInteger(HASH_SPELL, handleId, HASH_KEY_SPELL_SPELL, this);
			return this;
        }


    }
}

//! endzinc
#endif
