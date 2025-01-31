#ifndef MonsterDropIncluded
#define MonsterDropIncluded

#include "Crainax/config/SharedMethod.h"
//! zinc
/*
怪物掉落内容
*/
library MonsterDrop {

    public module monsterDrop {

        boolean isInitDrop = false;  // 是否使用默认掉落数据

        // 使用默认掉落模式(从monsterData继承)
        method useDefaultDrop() {
            isInitDrop = true;  // 使用monsterData的掉落
            SaveInteger(HASH_UNIT, GetHandleId(this.u), HASH_KEY_UNIT_DROP_COUNT, 0);
        }

        // 设置为自定义掉落模式
        method setCustomDrop() {
            isInitDrop = false;
            SaveInteger(HASH_UNIT, GetHandleId(this.u), HASH_KEY_UNIT_DROP_COUNT, 0);
        }

        // 添加自定义掉落物品
        method addCustomDrop(integer itemType, real chance) {
            integer count = 0;
            if (isInitDrop) { return; }  // 如果使用默认掉落则不允许添加

            count = LoadInteger(HASH_UNIT, GetHandleId(this.u), HASH_KEY_UNIT_DROP_COUNT);
            if (count >= MAX_MONSTER_DROP_ITEMS) { return; }

            SaveInteger(HASH_UNIT, GetHandleId(this.u),
                HASH_KEY_UNIT_DROP_TYPES + count, itemType);
            SaveReal(HASH_UNIT, GetHandleId(this.u),
                HASH_KEY_UNIT_DROP_CHANCES + count, chance);
            SaveInteger(HASH_UNIT, GetHandleId(this.u),
                HASH_KEY_UNIT_DROP_COUNT, count + 1);
        }

        //获取掉落物数量
        method getDropCount() -> integer {
            if (isInitDrop) {
                return this.md.getDropItemCount();
            }
            return LoadInteger(HASH_UNIT, GetHandleId(this.u), HASH_KEY_UNIT_DROP_COUNT);
        }

        //获取第x个掉落物的类型
        method getDropItem(integer index) -> integer {
            if (isInitDrop) {
                return this.md.getDropItemType(index);
            }
            if (index >= 0 && index < this.getDropCount()) {
                return LoadInteger(HASH_UNIT, GetHandleId(this.u),
                    HASH_KEY_UNIT_DROP_TYPES + index);
            }
            return 0;
        }

        //获取第x个掉落物的掉落率
        method getDropChance(integer index) -> real {
            if (isInitDrop) {
                return this.md.getDropItemChance(index);
            }
            if (index >= 0 && index < this.getDropCount()) {
                return LoadReal(HASH_UNIT, GetHandleId(this.u),
                    HASH_KEY_UNIT_DROP_CHANCES + index);
            }
            return 0.0;
        }
    }
}

//! endzinc
#endif
