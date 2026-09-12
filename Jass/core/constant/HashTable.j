#ifndef HashTableIncluded
#define HashTableIncluded

// 常用哈希表

//! zinc
library HashTable {
    // 全局哈希表定义
    public{
        hashtable HASH_TYPEID  = InitHashtable();  // 单位类型哈希表
        hashtable HASH_TIMER   = InitHashtable();  // 计时器哈希表
        hashtable HASH_GROUP   = InitHashtable();  // 单位组哈希表
        hashtable HASH_EFFECT  = InitHashtable();  // 特效哈希表
        hashtable HASH_TRIGGER = InitHashtable();  // 触发器哈希表
        hashtable HASH_ITEM    = InitHashtable();  // 触发器哈希表
        hashtable HASH_ABILITY = InitHashtable();  // 触发器哈希表
        hashtable HASH_DIALOG  = InitHashtable();  // 对话框哈希表
    }

    // (unit, abilityId) 需要落到 HASH_ABILITY 的单一 parent key，
    // 因此使用独立二级表分配无冲突记录号，不再压缩散列两个整数。
    // GetHandleId 只是本机查表的 parent；返回记录号不参与任何跨客户端排序或业务裁决。
    private hashtable abilityKeyIndex = InitHashtable();
    private integer abilityKeyIndexNext = 0;

    // 根据单位 + 技能 ID 取得唯一 HASH_ABILITY parent key。
    public function GetAbilityHashKey (unit u, integer abilId) -> integer {
        integer uid; integer key;
        if (u == null || abilId == 0) { return 0; }
        uid = GetHandleId(u);

        key = LoadInteger(abilityKeyIndex, uid, abilId);
        if (key == 0) {
            abilityKeyIndexNext += 1;
            key = abilityKeyIndexNext;
            SaveInteger(abilityKeyIndex, uid, abilId, key);
        }
        return key;
    }


}
//! endzinc

#endif
