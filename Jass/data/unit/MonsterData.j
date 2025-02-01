#ifndef MonsterDataIncluded
#define MonsterDataIncluded

#include "Crainax/config/SharedMethod.h"

// 定义怪物掉落物品最大数量
#define MAX_MONSTER_DROP_ITEMS 20

//! zinc
/*
怪物类型的数据
*/
library MonsterData {

    public struct monsterData [] {

        static integer counter = 0;

        integer gold;  // 怪物掉落金币[基础值]
        integer exp;   // 怪物提供经验值[基础值]
        integer kill;  // 怪物击杀数量[基础值]

        // 添加物品掉落
        public method addDropItem(integer itemType, real chance) {
            integer count = 0;
            integer array items[];
            real array chances[];

            if (HaveSavedInteger(HASH_UNITTYPE, this, HASH_KEY_SLK_UNIT_DROP_COUNT)) {
                count = LoadInteger(HASH_UNITTYPE, this, HASH_KEY_SLK_UNIT_DROP_COUNT);
            }

            if (count >= MAX_MONSTER_DROP_ITEMS) {
                return;  // 超出最大数量限制
            }

            // 保存物品类型
            SaveInteger(HASH_UNITTYPE, this, HASH_KEY_SLK_UNIT_DROP_TYPES + count, itemType);
            // 保存掉落概率
            SaveReal(HASH_UNITTYPE, this, HASH_KEY_SLK_UNIT_DROP_CHANCES + count, chance);
            // 更新物品总数
            SaveInteger(HASH_UNITTYPE, this, HASH_KEY_SLK_UNIT_DROP_COUNT, count + 1);
        }

        // 获取物品掉落数量
        public method getDropItemCount() -> integer {
            if (HaveSavedInteger(HASH_UNITTYPE, this, HASH_KEY_SLK_UNIT_DROP_COUNT)) {
                return LoadInteger(HASH_UNITTYPE, this, HASH_KEY_SLK_UNIT_DROP_COUNT);
            }
            return 0;
        }

        // 获取指定索引的物品类型
        public method getDropItemType(integer index) -> integer {
            if (index >= 0 && index < this.getDropItemCount()) {
                return LoadInteger(HASH_UNITTYPE, this, HASH_KEY_SLK_UNIT_DROP_TYPES + index);
            }
            return 0;
        }

        // 获取指定索引的物品掉落概率
        public method getDropItemChance(integer index) -> real {
            if (index >= 0 && index < this.getDropItemCount()) {
                return LoadReal(HASH_UNITTYPE, this, HASH_KEY_SLK_UNIT_DROP_CHANCES + index);
            }
            return 0.0;
        }

        //根据单位类型
        public static method byType(integer ut) -> thistype {
            thistype this;
            if (HaveSavedInteger(HASH_UNITTYPE,ut,HASH_KEY_SLK_MONSTERDATA)) {
                this = LoadInteger(HASH_UNITTYPE,ut,HASH_KEY_SLK_MONSTERDATA);
            } else {
                counter += 1;
                this = thistype[counter];
                SaveInteger(HASH_UNITTYPE,ut,HASH_KEY_SLK_MONSTERDATA,this);
                //初始化
                SaveInteger(HASH_UNITTYPE, this, HASH_KEY_SLK_UNIT_DROP_COUNT, 0);
            }
            return this;
        }
    }
}

//! endzinc
#undef MAX_MONSTER_DROP_ITEMS
#endif
