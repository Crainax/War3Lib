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
    }

    // 能力装饰相关：根据单位 + 技能ID 生成父键（纯整数散列）
    public function GetAbilityHashKey (unit u, integer abilId) -> integer {
        integer uid; integer h;
        if (u == null || abilId == 0) { return 0; }
        uid = GetHandleId(u);

        // 说明：
        //  - abilId 通常是四字符代码（如 'ALoc'），在 32 位整数全域内分布
        //  - uid 一般是百万级整数（句柄ID），远小于 abilId 的数量级
        // 这里用两个互不相关的大奇数常量做线性组合，再对一个大素数取模，
        // 避免简单移位/乘法导致的小周期模式，尽可能降低碰撞概率。

        // 线性混合（允许 32 位溢出，当作模 2^32 运算的一部分）
        h = abilId * 1103515245 + uid * 1597334677 + 104395301;

        // 映射到 (1 .. 2147483646) 范围，避免出现 0 和 -2^31 这种特殊值
        h = ModuloInteger(h, 2147483647); // 2147483647 = 2^31 - 1，素数
        if (h <= 0) {
            h = h + 2147483647;
        }
        return h;
    }


}
//! endzinc

#endif
