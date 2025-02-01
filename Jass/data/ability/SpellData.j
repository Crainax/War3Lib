#ifndef SpellDataIncluded
#define SpellDataIncluded

#include "Crainax/core/table/Hash_SLKDefine.j"

//! zinc
/*
技能数据
*/
library SpellData {

    public struct spellData [] {

        static integer counter = 0;

        integer id;           // 技能ID(从那边直接获取数据)

        integer maxLevel;     // 技能等级(最大等级)
        string  description;  // 技能描述
        string  icon;         // 技能图标

        //根据技能类型
        public static method byType(integer at) -> thistype {
            thistype this;
            if (HaveSavedInteger(HASH_SLK, at, HASH_KEY_SLK_SPELLDATA)) {
                this = LoadInteger(HASH_SLK, at, HASH_KEY_SLK_SPELLDATA);
            } else {
                counter += 1;
                this = thistype[counter];
                SaveInteger(HASH_SLK, at, HASH_KEY_SLK_SPELLDATA, this);
                id = at;
            }
            return this;
        }
    }

}

//! endzinc
#endif
