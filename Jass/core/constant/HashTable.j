#ifndef HashTableIncluded
#define HashTableIncluded

// 常用哈希表

//! zinc
library HashTable {
    // 全局哈希表定义
    public{
        hashtable HASH_UNIT_TYPE = InitHashtable();  // 单位类型哈希表
        hashtable HASH_TIMER     = InitHashtable();  // 计时器哈希表
        hashtable HASH_GROUP     = InitHashtable();  // 单位组哈希表
        hashtable HASH_EFFECT    = InitHashtable();  // 特效哈希表
    }

}
//! endzinc

#endif