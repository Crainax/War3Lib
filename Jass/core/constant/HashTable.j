#ifndef HashTableIncluded
#define HashTableIncluded

// 常用哈希表

//! zinc
library HashTable {
    // 全局哈希表定义
    public{
        hashtable HASH_UNIT_TYPE = InitHashtable();  // 单位类型哈希表
        hashtable HASH_UNIT      = InitHashtable();  // 单位实例哈希表
        hashtable HASH_TIMER     = InitHashtable();  // 计时器哈希表
        hashtable HASH_GROUP     = InitHashtable();  // 单位组哈希表
        hashtable HASH_SPELL     = InitHashtable();  // 技能结构哈希表
        hashtable HASH_UI        = InitHashtable();  // UI结构哈希表
    }

}
//! endzinc

#endif