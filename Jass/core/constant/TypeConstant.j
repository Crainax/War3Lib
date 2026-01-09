#ifndef TypeConstantIncluded
#define TypeConstantIncluded


/*
	存放SXTable的索引(以单位的ID作为父索引),去定义非重复值
	从1000开始吧
*/
//基础属性
#define KIA3W 1
#define KIASTR 2
#define KIAAGI 3
#define KIAINT 4
#define KIAATTACK 6
#define KIADEFENSE 5
#define KIAHP 7
#define KIAMP 8

//吸血
#define KEY_XIXUE_PHYSICAL 17
#define KEY_XIXUE_SPELL 18

//攻速
#define KEY_ATTACK_SPEED 19
//暴击
#define KEY_ATTACK_CRITICAL 20
//伤害加成
#define KEY_DAMAGE_ALL 21
//生命回复
#define KEY_LIFE_REGEN 22
//魔法回复
#define KEY_MANA_REGEN 23
//技能伤害
#define KEY_SPELL_DAMAGE 24
//经验获得率
#define KEY_EXP_RATE 25
//金钱获得率
#define KEY_GOLD_RATE 26
//暴击敏捷系数
#define KEY_CRITICAL_AGI_RATE 27
//力量百分比
#define KEY_STR_RATE 28
//敏捷百分比
#define KEY_AGI_RATE 29
//智力百分比
#define KEY_INT_RATE 30
//生命百分比
#define KEY_LIFE_RATE 31
//防御百分比
#define KEY_DEFENSE_RATE 32
//生命回复百分比
#define KEY_LIFE_REGEN_RATE 34
//攻击百分比
#define KEY_ATTACK_RATE 35
//魔法回复百分比
#define KEY_MANA_REGEN_RATE 36
//减少受到的伤害量
#define KEY_DAMAGE_REDUCE 37
//减少受到的伤害比
#define KEY_DAMAGE_REDUCE_RAT 38
//移速
#define KEY_MOVE_SPEED 39
//主属性
#define KEY_MAIN_ATTR 40
//主动技能伤害
#define KEY_ACTIVE_SPELL_DAMAGE 41
//暴击伤害
#define KEY_CRITICAL_EXTRA 42
//技能暴击系数
#define KEY_SPELL_CRITICAL 43
//攻击总伤害
#define KEY_PHYSICAL_DAMAGE 44

//对应原装备的ID
#define KEY_ITEM_ORIGIN 16

//存技能1
#define KEY_ITEM_ABILITY_1 101
//存技能2
#define KEY_ITEM_ABILITY_2 102
//存技能3
#define KEY_ITEM_ABILITY_3 103




//单位ID:
#define UNIT_GOLD 17237227
#define UNIT_EXP 17237718
#define HASH_KEY_UNIT_EXCLUDE_ABILITY_DECORATE 17237719
#define KEY_UNIT_ARENA_ATTACK_RATE_KEY  17237229
#define KEY_UNIT_ARENA_HP_RATE_KEY  17237230


//技能ID:
#define SPELL_MULTI_TIME_KEY    100001000    //多重施法间隔
#define SPELL_MULTIABLE_KEY     100002000    //是否能多重施法
#define SPELL_USE_TYPE_KEY      100003000    //使用类型
#define SPELL_POINTER_KEY       100004000    //指针


//异度用:   10000-100000之间不重复


// 英雄类型/属性在 HASH_TYPEID 中的子键（后续可在常量表中统一调整）
#define HERO_TYPE_ID_KEY              10000   // 英雄枚举 ID
#define HERO_TYPE_IS_MAN_KEY          10010   // 是否男英雄
#define HERO_TYPE_IS_STR_KEY          10020   // 是否力量主属性
#define HERO_TYPE_IS_AGI_KEY          10030   // 是否敏捷主属性
#define HERO_TYPE_IS_INT_KEY          10040   // 是否智力主属性
#define HERO_TYPE_IS_NORMAL_KEY       10050   // 是否近战英雄
#define HERO_TYPE_IS_MISSILE_KEY      10060   // 是否远程英雄
#define HERO_TYPE_BELONG_SPELL_KEY    10070   // 专属技能 ID
#define HERO_TYPE_NAME_KEY            10080   // 英雄名字
#define HERO_TYPE_DESC_KEY            10090   // 英雄描述
#define HERO_TYPE_TALENT_SPELL_KEY    10100   // 天赋技能 ID
#define HASH_KEY_TYPE_ABILITY_ACHIEVEMENT 10110  //技能的绑定成就ID
#define MOSHOU_KEY_DAMAGE_TYPE 10111  // 魔兽:伤害类型(物理或魔法)
#define MOSHOU_KEY_DAMAGE_RATE 10112  // 魔兽:伤害百分比(小数)


#endif
