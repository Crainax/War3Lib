#ifndef HASHSLKDefineIncluded
#define HASHSLKDefineIncluded

/*
物编哈希表键值定义
*/

#define HASH_KEY_SLK_UNITDATA    1725 //储存的单位数据结构体
#define HASH_KEY_SLK_MONSTERDATA 1726 //储存的怪物数据结构体
#define HASH_KEY_SLK_SPELLDATA   1727 //储存的技能数据结构体


// 物品掉落相关键值 (预留20个空间 1800-1819/1820-1839)  MonsterData
#define HASH_KEY_SLK_UNIT_DROP_COUNT   1799 //怪物掉落物品总数
#define HASH_KEY_SLK_UNIT_DROP_TYPES   1800 //怪物掉落物品类型数组起始键值
#define HASH_KEY_SLK_UNIT_DROP_CHANCES 1820 //怪物掉落物品概率数组起始键值

// 技能相关键值 (预留200个空间 2000-2199) UnitData
#define HASH_KEY_SLK_UNIT_SPELL_COUNT  1900 //技能数量
#define HASH_KEY_SLK_UNIT_SPELL_IDS    2000 //技能ID数组起始键值
#define HASH_KEY_SLK_UNIT_SPELL_LEVELS 2200 //技能等级数组起始键值

// 2400开始可继续添加新的键值定义...

#endif
