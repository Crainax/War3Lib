#ifndef HASHUnitDefineIncluded
#define HASHUnitDefineIncluded

/*
单位哈希表定义
*/



// BindEffect 特效存储键位（共21个）
#define HASH_UNIT_EFFECT_COUNT 100    // 特效数量(100-120)
#define HASH_UNIT_EFFECT_1     101    // 特效存储位 1
#define HASH_UNIT_EFFECT_2     102    // 特效存储位 2
#define HASH_UNIT_EFFECT_3     103    // 特效存储位 3
#define HASH_UNIT_EFFECT_4     104    // 特效存储位 4
#define HASH_UNIT_EFFECT_5     105    // 特效存储位 5
#define HASH_UNIT_EFFECT_6     106    // 特效存储位 6
#define HASH_UNIT_EFFECT_7     107    // 特效存储位 7
#define HASH_UNIT_EFFECT_8     108    // 特效存储位 8
#define HASH_UNIT_EFFECT_9     109    // 特效存储位 9
#define HASH_UNIT_EFFECT_10    110    // 特效存储位 10
#define HASH_UNIT_EFFECT_11    111    // 特效存储位 11
#define HASH_UNIT_EFFECT_12    112    // 特效存储位 12
#define HASH_UNIT_EFFECT_13    113    // 特效存储位 13
#define HASH_UNIT_EFFECT_14    114    // 特效存储位 14
#define HASH_UNIT_EFFECT_15    115    // 特效存储位 15
#define HASH_UNIT_EFFECT_16    116    // 特效存储位 16
#define HASH_UNIT_EFFECT_17    117    // 特效存储位 17
#define HASH_UNIT_EFFECT_18    118    // 特效存储位 18
#define HASH_UNIT_EFFECT_19    119    // 特效存储位 19
#define HASH_UNIT_EFFECT_20    120    // 特效存储位 20


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

#define HASH_KEY_UNIT_SIMPLESPELL_IDS    2000 //单位技能(简单)ID数组起始键值
#define HASH_KEY_UNIT_SIMPLESPELL_LEVELS  2200 //单位简单技能等级数组起始键值

// 2400开始可继续添加新的键值定义...

#define KEY_UNIT_MOVE_SPEED 237960560 //单位的移速记录
#define KEY_UNIT_ATTACK_INTERVAL_CACHE        255610124 //



//异度用键位
#define KEY_UNIT_ARENA_PLAYER 10001 // 子键:属于玩家几的竞技场怪物
#define KEY_UNIT_GUAI_PLAYER 10002 // 子键:属于玩家几的竞技场怪物
#define KEY_UNIT_BOSS_PLAYER 10003 // 子键:是否属于BOSS



#endif
