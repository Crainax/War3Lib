#ifndef HASHBIDefineIncluded
#define HASHBIDefineIncluded

/*
大数哈希表定义
*/


#define HASH_KEY_BIGINT_GOLD  1       //金币大数库
#define HASH_KEY_BIGINT_JIEJING  11   //结晶大数库
#define HASH_KEY_BIGINT_DAMAGE  21    //伤害统计大数库
#define HASH_KEY_BIGINT_GOLD_MAX  31  //累积金币大数库


#define HASH_KEY_BIGINT_ATTACK        41   // BigInteger: 每个玩家当前真实攻击力（非负大整数）
#define HASH_KEY_BIGINT_ATTACK_CACHE  51   // BigInteger: 攻击力欠款缓存（正数，记录还欠多少攻击）
#define HASH_KEY_BIGINT_ATTACK_BONUS  61   // BigInteger: 攻击力定值

#define HASH_KEY_BIGINT_STR        71   // BigInteger: 每个玩家当前真实力量（非负大整数）
#define HASH_KEY_BIGINT_STR_CACHE  81   // BigInteger: 力量欠款缓存（正数，记录还欠多少攻击）
#define HASH_KEY_BIGINT_STR_BONUS  91   // BigInteger: 力量定值

#define HASH_KEY_BIGINT_AGI        101   // BigInteger: 每个玩家当前真实敏捷（非负大整数）
#define HASH_KEY_BIGINT_AGI_CACHE  111   // BigInteger: 敏捷欠款缓存（正数，记录还欠多少攻击）
#define HASH_KEY_BIGINT_AGI_BONUS  121   // BigInteger: 敏捷定值

#define HASH_KEY_BIGINT_INT        131   // BigInteger: 每个玩家当前真实智力（非负大整数）
#define HASH_KEY_BIGINT_INT_CACHE  141   // BigInteger: 智力欠款缓存（正数，记录还欠多少攻击）
#define HASH_KEY_BIGINT_INT_BONUS  151   // BigInteger: 智力定值

// 主 / 次属性（按玩家维度）
#define HASH_KEY_BIGINT_MAIN        161  // BigInteger: 每个玩家当前真实主属性
#define HASH_KEY_BIGINT_MAIN_BONUS  171  // BigInteger: 主属性定值
#define HASH_KEY_BIGINT_MAIN_CACHE  201  // BigInteger: 主属性欠款缓存（正数，记录还欠多少主属性）
#define HASH_KEY_BIGINT_SUB         181  // BigInteger: 每个玩家当前真实次属性
#define HASH_KEY_BIGINT_SUB_BONUS   191  // BigInteger: 次属性定值
#define HASH_KEY_BIGINT_SUB_CACHE   211  // BigInteger: 次属性欠款缓存（正数，记录还欠多少次属性）


#endif
