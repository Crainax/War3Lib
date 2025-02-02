#ifndef HASHUnitDefineIncluded
#define HASHUnitDefineIncluded

/*
单位哈希表定义
*/

#define HASH_KEY_UNIT_UNITATTR  1726 //储存的单位属性结构体
#define HASH_KEY_UNIT_HEROATTR  1727 //储存的英雄属性结构体
#define HASH_KEY_UNIT_UNITREGEN 1728 //储存的单位回复属性结构体
#define HASH_KEY_UNIT_MONSTER   1729 //储存的怪物结构体
#define HASH_KEY_UNIT_UNITSPELL  1730 //储存的单位技能结构体

// 怪物掉落相关键值 (预留20个空间 1800-1819)
#define HASH_KEY_UNIT_DROP_TYPES    1800 //怪物掉落物品类型数组起始键值
// 怪物掉落概率相关键值 (预留20个空间 1820-1839)
#define HASH_KEY_UNIT_DROP_CHANCES  1820 //怪物掉落物品概率数组起始键值
// 怪物掉落数量键值
#define HASH_KEY_UNIT_DROP_COUNT    1840 //怪物掉落物品数量

// 单位技能相关键值 (预留200个空间 1800-1999)
#define HASH_KEY_UNIT_UNITSPELL_IDS    1800 //单位技能ID数组起始键值

// 2000开始可继续添加新的键值定义...

#endif
