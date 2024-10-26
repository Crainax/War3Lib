
// API文档: https://japi.war3rpg.top/
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
    #define CHAT_RECIPIENT_ALL    0    // [所有人]
    #define CHAT_RECIPIENT_ALLIES      1    // [盟友]
    #define CHAT_RECIPIENT_OBSERVERS   2    // [观看者]
    #define CHAT_RECIPIENT_REFEREES    2    // [裁判]
    #define CHAT_RECIPIENT_PRIVATE     3    // [私人的]

    //---------技能数据类型---------------

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


library_once japi

    function FrameHideInterface takes nothing returns nothing
        call GetTriggeringTrigger()
    endfunction

    function EXGetEventDamageData takes integer p1 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function EXSetEventDamage takes real p1 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function EXSetUnitReal takes integer p1, integer p2, real p3 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function DestroyFrame takes integer p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function EXGetUnitReal takes integer p1, integer p2 returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function VirtualMpqRegisterPath takes string p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameGetModelSpeed takes integer p1 returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function EXGetUnitString takes integer p1, integer p2 returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function EXSetUnitString takes integer p1, integer p2, string p3 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function EXGetUnitInteger takes integer p1, integer p2 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function EXBlpRect takes string p1, string p2, integer p3, integer p4, integer p5, integer p6 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function EXSetUnitInteger takes integer p1, integer p2, integer p3 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function EXGetUnitArrayString takes integer p1, integer p2, integer p3 returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function FrameSetModelColor takes integer p1, integer p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function EXBlendButtonIcon takes string p1, string p2, string p3 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function FrameShowInterface takes nothing returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function EXSetItemDataString takes integer p1, integer p2, string p3 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function EXSetUnitArrayString takes integer p1, integer p2, integer p3, string p4 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function EXPauseUnit takes unit p1, boolean p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function EXGetAbilityDataString takes ability p1, integer p2, integer p3 returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function FrameSetTextColor takes integer p1, integer p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function EXExecuteScript takes string p1 returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function EXGetUnitAbility takes unit p1, integer p2 returns ability
    	call GetTriggeringTrigger()
    	return null
    endfunction

    function EXGetUnitAbilityByIndex takes unit p1, integer p2 returns ability
    	call GetTriggeringTrigger()
    	return null
    endfunction

    function EXGetAbilityId takes ability p1 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function EXGetAbilityState takes ability p1, integer p2 returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function EXSetAbilityState takes ability p1, integer p2, real p3 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function EXGetAbilityDataReal takes ability p1, integer p2, integer p3 returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function GetMouseX takes nothing returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function GetFps takes nothing returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function EXSetAbilityDataReal takes ability p1, integer p2, integer p3, real p4 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function ShowFpsText takes boolean p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function EXGetAbilityDataInteger takes ability p1, integer p2, integer p3 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function EXSetAbilityDataInteger takes ability p1, integer p2, integer p3, integer p4 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function EXSetAbilityString takes integer p1, integer p2, integer p3, string p4 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function EXSetAbilityDataString takes ability p1, integer p2, integer p3, string p4 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function EXSetAbilityAEmeDataA takes ability p1, integer p2 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function EXGetBuffDataString takes integer p1, integer p2 returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function EXSetBuffDataString takes integer p1, integer p2, string p3 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function EXGetAbilityString takes integer p1, integer p2, integer p3 returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function LocalPointOrder takes integer p1, real p2, real p3, integer p4 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function EXGetItemDataString takes integer p1, integer p2 returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function ExExecuteFunc takes string p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function GetByte takes string p1 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function EXDisplayChat takes player p1, integer p2, string p3 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function EXSetEffectAnimation takes effect p1, integer p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function EXSetEffectColor takes effect p1, integer p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function GetChatState takes nothing returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function Hex takes integer p1 returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function EXDclareButtonIcon takes string p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function EXBlpSector takes string p1, string p2, integer p3, integer p4, integer p5, integer p6, integer p7 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function EXPolygon takes string p1, integer p2, integer p3, hashtable p4, integer p5, integer p6 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function EXClear takes string p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function png2tga_file takes string p1 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function SaveFunc takes integer p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetTexture takes integer p1, string p2, integer p3 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function GetMouseY takes nothing returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function timer_start takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function timer_end takes integer p1 returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function timer_destroy takes integer p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function EnableWideScreen takes boolean p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function GetPlayerSelectedUnit takes integer p1 returns unit
    	call GetTriggeringTrigger()
    	return null
    endfunction

    function LocalOrder takes integer p1, integer p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function LocalTargetOrder takes integer p1, widget p2, integer p3 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function GetMapName takes nothing returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function GetMapPath takes nothing returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function GetWar3Path takes nothing returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function GetGameVersion takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function GetPluginVersion takes nothing returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function SetUnitAbilityButtonShow takes integer p1, integer p2, boolean p3 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function SetHeroLevels takes code p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function get_code_addr takes string p1 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function get_code_id takes string p1 returns code
    	call GetTriggeringTrigger()
    	return null
    endfunction

    function get_code_name takes integer p1 returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function FrameGetHeroManaBar takes integer p1 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function Box takes string p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function SetOwner takes string p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function get_copy_str takes nothing returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function GetTargetObject takes nothing returns unit
    	call GetTriggeringTrigger()
    	return null
    endfunction

    // 异步获取 当前玩家大头像模型的单位 当框选一群单位时 切换选择也会改变返回值 一般用来做UI操作时需要用到的接口
    function GetRealSelectUnit takes nothing returns unit
    	call GetTriggeringTrigger()
    	return null
    endfunction

    function FrameGetUnitMessage takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function GetUnitAddress takes unit p1 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function SetUnitPosition2 takes unit p1, real p2, real p3 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function SetUnitTexture takes unit p1, string p2, integer p3 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function SetUnitModel takes unit p1, string p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function SetUnitPortrait takes unit p1, string p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function SetUnitName takes unit p1, string p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    //字符串相关
    function ReleaseString takes string str returns nothing
        call GetTriggeringTrigger()
    endfunction
    function ReleaseAllString takes nothing returns nothing
        call GetTriggeringTrigger()
    endfunction
    function GetCacheStringCount takes nothing returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction

    function DumpAllString takes string filename returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction

    function GetWindowHeight takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function SetUnitProperName takes unit p1, string p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function DestroySimpleFrame takes integer p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function SetUnitMissileModel takes unit p1, string p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetTextFontSpacing takes integer p1, real p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function SetUnitMissileArc takes unit p1, real p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function SimpleFontStringFindByName takes string p1, integer p2 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function SetUnitMissileSpeed takes unit p1, real p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetAnimationByIndex takes integer p1, integer p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function SetUnitMissileHoming takes unit p1, boolean p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function GetGlueUI takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameSetModelScale takes integer p1, real p2, real p3, real p4 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function GetGameUI takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameSetScale takes integer p1, real p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameEditBlackBorders takes real p1, real p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameGetMinimapButton takes integer p1 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetMinimap takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetPortrait takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetCommandBarButton takes integer p1, integer p2 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetHeroBarButton takes integer p1 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetHeroHPBar takes integer p1 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetTooltip takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetChatMessage takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetItemBarButton takes integer p1 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetTopMessage takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetButtonCooldownModel takes integer p1 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function GetWindowX takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameSetButtonCooldownModelSize takes integer p1, real p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameGetMouseBorders takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetItemBar takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function GetWindowWidth takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetItemBackground takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetItemBackgroundTexture takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetSimpleConsole takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetSimpleConsole2 takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function LoadToc takes string p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetAllPoints takes integer p1, integer p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameGetTextHeight takes integer p1 returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function CreateFrame takes string p1, integer p2, integer p3 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function CreateSimpleFrame takes string p1, integer p2, integer p3 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function CreateFrameByTagName takes string p1, string p2, integer p3, string p4, integer p5 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameSetSize takes integer p1, real p2, real p3 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function SetKeyboard takes integer p1, boolean p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetWidth takes integer p1, real p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function RegisterMessageEvent takes trigger p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameClearAllPoints takes integer p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetHeight takes integer p1, real p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetPoint takes integer p1, integer p2, integer p3, integer p4, real p5, real p6 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetAbsolutePoint takes integer p1, integer p2, real p3, real p4 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameShow takes integer p1, boolean p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetEnable takes integer p1, boolean p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetFocus takes integer p1, boolean p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameGetModelSize takes integer p1 returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function FrameSetEditFocus takes integer p1, boolean p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetAlpha takes integer p1, integer p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameGetAlpha takes integer p1 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetWidth takes integer p1 returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function FrameGetHeight takes integer p1 returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function FrameSetModelRotateY takes integer p1, real p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameGetTextWidth takes integer p1 returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function FrameSetText takes integer p1, string p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameGetText takes integer p1 returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function FrameGetTextColor takes integer p1 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameSetTextFont takes integer p1, string p2, real p3 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetAnimate takes integer p1, integer p2, boolean p3 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetAnimateOffset takes integer p1, real p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetModel takes integer p1, string p2, integer p3, integer p4 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetModelSize takes integer p1, real p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function GetMouseVectorY takes nothing returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function FrameSetModelXY takes integer p1, real p2, real p3 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameGetModelX takes integer p1 returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function FrameGetModelY takes integer p1 returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function FrameSetModelSpeed takes integer p1, real p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetModelRotateX takes integer p1, real p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetModelRotateZ takes integer p1, real p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function GetWindowY takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameSetModelTexture takes integer p1, string p2, integer p3 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameCageMouse takes integer p1, boolean p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetLevel takes integer p1, integer p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetParent takes integer p1, integer p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameSetSimpleFrameParent takes integer p1, integer p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function FrameFindByName takes string p1, integer p2 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function SimpleFrameFindByName takes string p1, integer p2 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function SimpleTextureFindByName takes string p1, integer p2 returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function GetMouseFocus takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function FrameGetType takes integer p1 returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function SetWar3MapMap takes string p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function GetTriggerKey takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function GetWheelDelta takes nothing returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function IsWindowActive takes nothing returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function GetKeyState takes integer p1 returns boolean
    	call GetTriggeringTrigger()
    	return false
    endfunction

    function RegisterFrameEvent takes integer p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function GetMessagePlayer takes nothing returns player
    	call GetTriggeringTrigger()
    	return null
    endfunction

    function GetTriggerMessage takes nothing returns string
    	call GetTriggeringTrigger()
    	return ""
    endfunction

    function SendCustomMessage takes string p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function SendMessage takes integer p1, integer p2, integer p3 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function GetMouseVectorX takes nothing returns real
    	call GetTriggeringTrigger()
    	return 0.0
    endfunction

    function SetMousePos takes real p1, real p2 returns nothing
    	call GetTriggeringTrigger()
    endfunction

    function GetWindowMouseX takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function GetWindowMouseY takes nothing returns integer
    	call GetTriggeringTrigger()
    	return 0
    endfunction

    function set_copy_str takes string p1 returns nothing
    	call GetTriggeringTrigger()
    endfunction


    function initializePlugin takes nothing returns integer
        call ExecuteFunc("DoNothing")
        call StartCampaignAI( Player(PLAYER_NEUTRAL_AGGRESSIVE), "callback" )
        call ExecuteFunc("DoNothing")
        call AbilityId("exec-lua:plugin_main")

        return 0
    endfunction
endlibrary


//
#define SetCameraBounds(a,b,c,d,e,f,g,h) initializePlugin() CRNL call SetCameraBounds(a,b,c,d,e,f,g,h)




//! zinc
/*
初始化内置JAPI
*/
library InnerJapi requires optional japi{

    function onInit ()  {
        integer i = 0;
        // BJDebugMsg(GetPluginVersion());
        GetPluginVersion();
    }
}

//! endzinc


#ifdef OPEN
    #undef public
#endif


