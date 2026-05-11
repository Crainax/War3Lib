#ifndef MusicConstantIncluded
#define MusicConstantIncluded

/*
声音的初始化
及一些常用的声音API
*/

#define MUSIC_INDEX_BTN_DOWN_1      1001   //用于UI的音效:按钮按下
#define MUSIC_INDEX_BTN_OVER_1      1002   //用于UI的音效:按钮悬停
#define MUSIC_INDEX_BTN_OVER_2      1003   //用于UI的音效:按钮悬停
#define MUSIC_INDEX_BTN_UP_1        1004   //用于UI的音效:按钮弹起
#define MUSIC_INDEX_FLASH_1         1005   //用于UI的音效:刷新类型1
#define MUSIC_INDEX_CLICK_PAUSE     1006   //用于UI的音效:暂停

#define MUSIC_INDEX_BLACKHOLE       2001   //黑洞音效
#define MUSIC_INDEX_CURE_1          2002   //治疗1音效
#define MUSIC_INDEX_CURE_2          2003   //治疗2音效
#define MUSIC_INDEX_XIAOYE_WORLD    2004   //小夜世界音效

#define MUSIC_INDEX_BASE_DMGED      5   //基地受击音效
#define MUSIC_INDEX_BASE_DEATH      6   //基地死亡音效
#define MUSIC_INDEX_NO_GOLD         7   //金币不足音效
#define MUSIC_INDEX_ERROR           8   //错误提示音效
#define MUSIC_INDEX_GOLD            9   //获得金币音效
#define MUSIC_INDEX_TOMES           10  //典籍音效
#define MUSIC_INDEX_ITEM            11  //获得物品音效
#define MUSIC_INDEX_BTN_CLICK       12  //按钮点击音效
#define MUSIC_INDEX_UP_SPELL        13  //升级法术音效
#define MUSIC_INDEX_LUMBER          14  //获得木材的声音
#define MUSIC_INDEX_JOB_FINISH      15  //任务完成音效
#define MUSIC_INDEX_JOB_PAUSE       16  //任务暂停音效
#define MUSIC_INDEX_JOB_START       17  //任务开始音效
#define MUSIC_INDEX_BTN_SWITCH_CLOSE 18 //开关关闭音效
#define MUSIC_INDEX_BTN_SWITCH_OPEN 19  //开关开启音效

#define MUSIC_INDEX_ARENA_CLEAR     3001 //竞技场胜利音效
#define MUSIC_INDEX_ARENA_FAIL      3002 //竞技场失败音效
#define MUSIC_INDEX_ARENA_START     3003 //竞技场开始音效
#define MUSIC_INDEX_BOSS_COMING     3004 //Boss来临音效
#define MUSIC_INDEX_BUY_FAIL        3005 //购买失败音效
#define MUSIC_INDEX_CHUGUAI         3006 //出怪音效
#define MUSIC_INDEX_EQUIT_COMBINE   3007 //装备合成音效
#define MUSIC_INDEX_EQUIT_UPDATE    3008 //装备升级音效
#define MUSIC_INDEX_SHOP_BUY        3009 //商店购买音效
#define MUSIC_INDEX_SPELL_UNLOCK    3010 //技能解锁音效
#define MUSIC_INDEX_UPDATE_SPELL    3011 //技能升级音效
#define MUSIC_INDEX_START_MISSION   3012 //任务开始音效

#define SOUND_POOL_SIZE 20  // 每个音效的对象池大小（可同时播放20个）

#endif
