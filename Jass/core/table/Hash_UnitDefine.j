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

#define KEY_UNIT_MOVE_SPEED                  237960560 //单位的移速记录
#define KEY_UNIT_ATTACK_INTERVAL_CACHE       255610124 // 攻击间隔小于地图设置的缓存值

// 单位攻击力扩展键值（支持超过 21 亿的攻击力）
#define KEY_UNIT_ATTACK_SCALE_EXP            255610125 // 攻击力扩展缩放指数 n
#define KEY_UNIT_ATTACK_SCALE_FACTOR         255610126 // 攻击力扩展缩放倍数 10^n

// 单位攻击基础值与百分比/定值加成（实数缓存）
#define KEY_UNIT_ATTACK_BASE_REAL            255610127 // 单位基础攻击缓存（real）
#define KEY_UNIT_ATTACK_UP_RATE              255610128 // 单位攻击增幅累计值（real）
#define KEY_UNIT_ATTACK_DOWN_RATE            255610129 // 单位攻击减幅累计值（real）
#define KEY_UNIT_ATTACK_BONUS_REAL           255610130 // 单位攻击固定加成（real，仅用于非 BigInteger 链路）

// 英雄主属性类型（0 力量 / 1 敏捷 / 2 智力），优先从此键读取，可被其他系统覆盖
#define KEY_UNIT_MAIN_ATTR_TYPE              255610131

// 单位防御基础值与百分比/定值加成
#define KEY_UNIT_DEFENSE_BASE_INTEGER        255610132 // 单位基础防御缓存（integer）
#define KEY_UNIT_DEFENSE_UP_RATE             255610133 // 单位防御增幅累计值（real）
#define KEY_UNIT_DEFENSE_DOWN_RATE           255610134 // 单位防御减幅累计值（real）
#define KEY_UNIT_DEFENSE_BONUS_INTEGER       255610135 // 单位防御固定加成（integer）

// 单位生命值基础值与百分比/定值加成
#define KEY_UNIT_HP_BASE_REAL                255610136 // 单位基础生命值缓存（real）
#define KEY_UNIT_HP_UP_RATE                  255610137 // 单位生命值增幅累计值（real）
#define KEY_UNIT_HP_DOWN_RATE                255610138 // 单位生命值减幅累计值（real）
#define KEY_UNIT_HP_BONUS_REAL               255610139 // 单位生命值固定加成（real）

// 单位魔法值基础值与百分比/定值加成
#define KEY_UNIT_MP_BASE_REAL                255610140 // 单位基础魔法值缓存（real）
#define KEY_UNIT_MP_UP_RATE                  255610141 // 单位魔法值增幅累计值（real）
#define KEY_UNIT_MP_DOWN_RATE                255610142 // 单位魔法值减幅累计值（real）
#define KEY_UNIT_MP_BONUS_REAL               255610143 // 单位魔法值固定加成（real）

// 主 / 次属性增减幅（英雄虚拟属性扩展用）
#define KEY_UNIT_MAIN_ATTR_UP_RATE           255610144 // 主属性增幅累计值（real）
#define KEY_UNIT_MAIN_ATTR_DOWN_RATE         255610145 // 主属性减幅累计值（real）
#define KEY_UNIT_SUB_ATTR_UP_RATE            255610146 // 次属性增幅累计值（real）
#define KEY_UNIT_SUB_ATTR_DOWN_RATE          255610147 // 次属性减幅累计值（real）

// 英雄三维属性（力量/敏捷/智力）增减幅与定值加成（独立于攻击/防御/魔法值）
#define KEY_UNIT_STR_UP_RATE                 255610148 // 力量增幅累计值（real）
#define KEY_UNIT_STR_DOWN_RATE               255610149 // 力量减幅累计值（real）
#define KEY_UNIT_STR_BONUS_REAL              255610150 // 力量固定加成（real）
#define KEY_UNIT_AGI_UP_RATE                 255610151 // 敏捷增幅累计值（real）
#define KEY_UNIT_AGI_DOWN_RATE               255610152 // 敏捷减幅累计值（real）
#define KEY_UNIT_AGI_BONUS_REAL              255610153 // 敏捷固定加成（real）
#define KEY_UNIT_INT_UP_RATE                 255610154 // 智力增幅累计值（real）
#define KEY_UNIT_INT_DOWN_RATE               255610155 // 智力减幅累计值（real）
#define KEY_UNIT_INT_BONUS_REAL              255610156 // 智力固定加成（real）

// 英雄三维属性禁用与跨属性共享开关（布尔标记）
#define KEY_UNIT_STR_DISABLED                255610157 // 力量属性是否被禁用（boolean）
#define KEY_UNIT_AGI_DISABLED                255610158 // 敏捷属性是否被禁用（boolean）
#define KEY_UNIT_INT_DISABLED                255610159 // 智力属性是否被禁用（boolean）

// 跨属性共享：X 属性是否计入 Y 属性
#define KEY_UNIT_STR_TO_AGI_SHARE            255610160 // 力量是否计入敏捷（boolean）
#define KEY_UNIT_STR_TO_INT_SHARE            255610161 // 力量是否计入智力（boolean）
#define KEY_UNIT_AGI_TO_STR_SHARE            255610162 // 敏捷是否计入力量（boolean）
#define KEY_UNIT_AGI_TO_INT_SHARE            255610163 // 敏捷是否计入智力（boolean）
#define KEY_UNIT_INT_TO_STR_SHARE            255610164 // 智力是否计入力量（boolean）
#define KEY_UNIT_INT_TO_AGI_SHARE            255610165 // 智力是否计入敏捷（boolean）

//异度用键位
#define KEY_UNIT_ARENA_PLAYER 10001 // 子键:属于玩家几的竞技场怪物
#define KEY_UNIT_GUAI_PLAYER 10002 // 子键:属于玩家几的竞技场怪物
#define KEY_UNIT_BOSS_PLAYER 10003 // 子键:是否属于BOSS



#endif
