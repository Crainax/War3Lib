#ifndef SpellTableIncluded
#define SpellTableIncluded


#include "Crainax/core/table/Hash_SpellDefine.j"

//! zinc
/*
技能哈希表
*/
library SpellTable {

    public hashtable HASH_SPELL   = InitHashtable();  // 技能哈希表(键是通过GetHashValue计算的)

}

//! endzinc
#endif

