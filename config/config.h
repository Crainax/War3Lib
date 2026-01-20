#define VERSION "0.0.1"
#define MAX_PLAYER_COUNT 4

// 原生UI的大小
#define SIZE_ORIGIN_UI_SPELL 0.038
#define SIZE_ORIGIN_UI_ITEM 0.032

// #define UNITPANEL_ICON_TEXTURE_STR    "ui\\console\\unitpanel\\origin_str.blp"
// #define UNITPANEL_ICON_TEXTURE_AGI    "ui\\console\\unitpanel\\origin_agi.blp"
// #define UNITPANEL_ICON_TEXTURE_INT    "ui\\console\\unitpanel\\origin_int.blp"
// #define UNITPANEL_ICON_TEXTURE_ATTACK "ui\\console\\unitpanel\\origin_attack.blp"
// #define UNITPANEL_ICON_TEXTURE_ARMOR  "ui\\console\\unitpanel\\origin_armor.blp"

#define UNITPANEL_ICON_TEXTURE_STR    "ui\\console\\unitpanel\\yidu_str.blp"
#define UNITPANEL_ICON_TEXTURE_AGI    "ui\\console\\unitpanel\\yidu_agi.blp"
#define UNITPANEL_ICON_TEXTURE_INT    "ui\\console\\unitpanel\\yidu_int.blp"
#define UNITPANEL_ICON_TEXTURE_ATTACK "ui\\console\\unitpanel\\yidu_Atk.blp"
#define UNITPANEL_ICON_TEXTURE_ARMOR  "ui\\console\\unitpanel\\yidu_Def.blp"

#undef UnitPanelShowBuilding
#undef UnitPanelShowMonster

#define IsUnitBigInteger(u)   IsHeroUnitId(GetUnitTypeId(u))   //应用高精度大数的单位

//魔免技能(隐藏图标的)
#define MAGIC_IMMUNITY_SPELL_ID 'A04e'

//吸怪相关的配置
#define ATTRACTION_COMEBACK_EFX      "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl"
#define ATTRACTION_DUMMY_UNIT_ID     'h005'

#define TOOLTIP_DEFAULT_X 0.786
#define TOOLTIP_DEFAULT_Y 0.1375

#define DEFENSE_ARMOR 0.01

//地图的最低攻击间隔(非特殊情况)
#define MIN_ATTACK_INTERVAL 0.2

//冲刺最大槽位数
#define MAX_COUNT_DASH 10

//新版魔法书的翻页ID
#define TALENT_BOOK1_SPELLID   'A000'
#define TALENT_BOOK2_SPELLID   'A001'
#define TALENT_BOOK3_SPELLID   'A002'


#define MAX_SUPER_SPEED 1000 //最大超级移速

#define ISVALID_PLAYER_ID(pid) (pid >= 1 && pid <= MAX_PLAYER_COUNT)
