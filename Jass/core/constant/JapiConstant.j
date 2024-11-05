/*

japi引用的常量库 由于wave宏定义 只对以下的代码有效

请将常量库里所有内容复制到  自定义脚本代码区
*/

//魔兽版本 用GetGameVersion 来获取当前版本 来对比以下具体版本做出相应操作
#define version_124b   6374
#define version_124e   6387
#define version_126    6401
#define version_127a   7000
#define version_127b   7085
#define version_128a   7205

//-----------模拟聊天------------------
#ifndef JapiOtherConstantIncluded
#define JapiOtherConstantIncluded
#define CHAT_RECIPIENT_ALL    0    // [所有人]
#define CHAT_RECIPIENT_ALLIES      1    // [盟友]
#define CHAT_RECIPIENT_OBSERVERS   2    // [观看者]
#define CHAT_RECIPIENT_REFEREES    2    // [裁判]
#define CHAT_RECIPIENT_PRIVATE     3    // [私人的]
#endif
//---------技能数据类型---------------

#ifndef JapiAbilityConstantIncluded
#define JapiAbilityConstantIncluded
//冷却时间
#define ABILITY_STATE_COOLDOWN 1

//目标允许
#define ABILITY_DATA_TARGS 100

//施放时间
#define ABILITY_DATA_CAST 101

//持续时间
#define ABILITY_DATA_DUR 102

//持续时间
#define ABILITY_DATA_HERODUR 103

//魔法消耗
#define ABILITY_DATA_COST 104

//施放间隔
#define ABILITY_DATA_COOL 105

//影响区域
#define ABILITY_DATA_AREA 106

//施法距离
#define ABILITY_DATA_RNG 107

//数据A
#define ABILITY_DATA_DATA_A 108

//数据B
#define ABILITY_DATA_DATA_B 109

//数据C
#define ABILITY_DATA_DATA_C 110

//数据D
#define ABILITY_DATA_DATA_D 111

//数据E
#define ABILITY_DATA_DATA_E 112

//数据F
#define ABILITY_DATA_DATA_F 113

//数据G
#define ABILITY_DATA_DATA_G 114

//数据H
#define ABILITY_DATA_DATA_H 115

//数据I
#define ABILITY_DATA_DATA_I 116

//单位类型
#define ABILITY_DATA_UNITID 117

//热键
#define ABILITY_DATA_HOTKET 200

//关闭热键
#define ABILITY_DATA_UNHOTKET 201

//学习热键
#define ABILITY_DATA_RESEARCH_HOTKEY 202

//名字
#define ABILITY_DATA_NAME 203

//图标
#define ABILITY_DATA_ART 204

//目标效果
#define ABILITY_DATA_TARGET_ART 205

//施法者效果
#define ABILITY_DATA_CASTER_ART 206

//目标点效果
#define ABILITY_DATA_EFFECT_ART 207

//区域效果
#define ABILITY_DATA_AREAEFFECT_ART 208

//投射物
#define ABILITY_DATA_MISSILE_ART 209

//特殊效果
#define ABILITY_DATA_SPECIAL_ART 210

//闪电效果
#define ABILITY_DATA_LIGHTNING_EFFECT 211

//buff提示
#define ABILITY_DATA_BUFF_TIP 212

//buff提示
#define ABILITY_DATA_BUFF_UBERTIP 213

//学习提示
#define ABILITY_DATA_RESEARCH_TIP 214

//提示
#define ABILITY_DATA_TIP 215

//关闭提示
#define ABILITY_DATA_UNTIP 216

//学习提示
#define ABILITY_DATA_RESEARCH_UBERTIP 217

//提示
#define ABILITY_DATA_UBERTIP 218

//关闭提示
#define ABILITY_DATA_UNUBERTIP 219

#define ABILITY_DATA_UNART 220

#define ABILITY_DATA_RESEARCH_ART 221

#endif


//----------物品数据类型----------------------

//物品图标
#define ITEM_DATA_ART 1

//物品提示
#define ITEM_DATA_TIP 2

//物品扩展提示
#define ITEM_DATA_UBERTIP 3

//物品名字
#define ITEM_DATA_NAME 4

//物品说明
#define ITEM_DATA_DESCRIPTION 5


//------------单位数据类型--------------
//攻击1 伤害骰子数量
#define UNIT_STATE_ATTACK1_DAMAGE_DICE 0x10

//攻击1 伤害骰子面数
#define UNIT_STATE_ATTACK1_DAMAGE_SIDE 0x11

//攻击1 基础伤害
#define UNIT_STATE_ATTACK1_DAMAGE_BASE 0x12

//攻击1 升级奖励
#define UNIT_STATE_ATTACK1_DAMAGE_BONUS 0x13

//攻击1 最小伤害
#define UNIT_STATE_ATTACK1_DAMAGE_MIN 0x14

//攻击1 最大伤害
#define UNIT_STATE_ATTACK1_DAMAGE_MAX 0x15

//攻击1 全伤害范围
#define UNIT_STATE_ATTACK1_RANGE 0x16

//装甲
#define UNIT_STATE_ARMOR 0x20

// attack 1 attribute adds
//攻击1 伤害衰减参数
#define UNIT_STATE_ATTACK1_DAMAGE_LOSS_FACTOR 0x21

//攻击1 武器声音
#define UNIT_STATE_ATTACK1_WEAPON_SOUND 0x22

//攻击1 攻击类型
#define UNIT_STATE_ATTACK1_ATTACK_TYPE 0x23

//攻击1 最大目标数
#define UNIT_STATE_ATTACK1_MAX_TARGETS 0x24

//攻击1 攻击间隔
#define UNIT_STATE_ATTACK1_INTERVAL 0x25

//攻击1 攻击延迟/summary>
#define UNIT_STATE_ATTACK1_INITIAL_DELAY 0x26

//攻击1 弹射弧度
#define UNIT_STATE_ATTACK1_BACK_SWING 0x28

//攻击1 攻击范围缓冲
#define UNIT_STATE_ATTACK1_RANGE_BUFFER 0x27

//攻击1 目标允许
#define UNIT_STATE_ATTACK1_TARGET_TYPES 0x29

//攻击1 溅出区域
#define UNIT_STATE_ATTACK1_SPILL_DIST 0x56

//攻击1 溅出半径
#define UNIT_STATE_ATTACK1_SPILL_RADIUS 0x57

//攻击1 武器类型
#define UNIT_STATE_ATTACK1_WEAPON_TYPE 0x58

// attack 2 attributes (sorted in a sequencial order based on memory address)
//攻击2 伤害骰子数量
#define UNIT_STATE_ATTACK2_DAMAGE_DICE 0x30

//攻击2 伤害骰子面数
#define UNIT_STATE_ATTACK2_DAMAGE_SIDE 0x31

//攻击2 基础伤害
#define UNIT_STATE_ATTACK2_DAMAGE_BASE 0x32

//攻击2 升级奖励
#define UNIT_STATE_ATTACK2_DAMAGE_BONUS 0x33

//攻击2 伤害衰减参数
#define UNIT_STATE_ATTACK2_DAMAGE_LOSS_FACTOR 0x34

//攻击2 武器声音
#define UNIT_STATE_ATTACK2_WEAPON_SOUND 0x35

//攻击2 攻击类型
#define UNIT_STATE_ATTACK2_ATTACK_TYPE 0x36

//攻击2 最大目标数
#define UNIT_STATE_ATTACK2_MAX_TARGETS 0x37

//攻击2 攻击间隔
#define UNIT_STATE_ATTACK2_INTERVAL 0x38

//攻击2 攻击延迟
#define UNIT_STATE_ATTACK2_INITIAL_DELAY 0x39

//攻击2 攻击范围
#define UNIT_STATE_ATTACK2_RANGE 0x40

//攻击2 攻击缓冲
#define UNIT_STATE_ATTACK2_RANGE_BUFFER 0x41

//攻击2 最小伤害
#define UNIT_STATE_ATTACK2_DAMAGE_MIN 0x42

//攻击2 最大伤害
#define UNIT_STATE_ATTACK2_DAMAGE_MAX 0x43

//攻击2 弹射弧度
#define UNIT_STATE_ATTACK2_BACK_SWING 0x44

//攻击2 目标允许类型
#define UNIT_STATE_ATTACK2_TARGET_TYPES 0x45

//攻击2 溅出区域
#define UNIT_STATE_ATTACK2_SPILL_DIST 0x46

//攻击2 溅出半径
#define UNIT_STATE_ATTACK2_SPILL_RADIUS 0x47

//攻击2 武器类型
#define UNIT_STATE_ATTACK2_WEAPON_TYPE 0x59

//装甲类型
#define UNIT_STATE_ARMOR_TYPE 0x50

#define UNIT_STATE_RATE_OF_FIRE 0x51 // global attack rate of unit, work on both attacks
#define UNIT_STATE_ACQUISITION_RANGE 0x52 // how far the unit will automatically look for targets
#define UNIT_STATE_LIFE_REGEN 0x53
#define UNIT_STATE_MANA_REGEN 0x54

#define UNIT_STATE_MIN_RANGE 0x55
#define UNIT_STATE_AS_TARGET_TYPE 0x60
#define UNIT_STATE_TYPE 0x61

