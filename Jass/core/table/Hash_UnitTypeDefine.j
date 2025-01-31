#ifndef HASHUnitTypeDefineIncluded
#define HASHUnitTypeDefineIncluded

/*
单位类型哈希表键值定义
*/

#define HASH_KEY_UNITTYPE_MONSTERDATA  1726 //储存的怪物数据结构体
#define HASH_KEY_UNITTYPE_ITEM_COUNT   1727 //怪物掉落物品总数

// 物品掉落相关键值 (预留20个空间 1800-1819)
#define HASH_KEY_UNITTYPE_ITEM_TYPES   1800 //怪物掉落物品类型数组起始键值
// 物品掉落概率相关键值 (预留20个空间 1820-1839)
#define HASH_KEY_UNITTYPE_ITEM_CHANCES 1820 //怪物掉落物品概率数组起始键值

// 1840开始可继续添加新的键值定义...

#endif
