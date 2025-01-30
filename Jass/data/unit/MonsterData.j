#ifndef MonsterDataIncluded
#define MonsterDataIncluded

#include "Crainax/config/SharedMethod.h"
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

        //根据单位类型
        public static method byUnitType (integer ut)  -> thistype {
            thistype this;
            if (HaveSavedInteger(HASH_UNITTYPE,ut,HASH_KEY_UNITTYPE_MONSTERDATA)) {
                this = LoadInteger(HASH_UNITTYPE,ut,HASH_KEY_UNITTYPE_MONSTERDATA);
            } else {
                counter += 1;
                SaveInteger(HASH_UNITTYPE,ut,HASH_KEY_UNITTYPE_MONSTERDATA,thistype[counter]);
                //初始化
            }
            return this;
        }

    }

}

//! endzinc
#endif
