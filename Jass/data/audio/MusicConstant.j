#ifndef MusicConstantIncluded
#define MusicConstantIncluded

/*
声音的初始化
及一些常用的声音API
*/

#define MUSIC_INDEX_BTN_DOWN_1 1001   //用于UI的音效:按钮按下
#define MUSIC_INDEX_BTN_OVER_1 1002   //用于UI的音效:按钮悬停
#define MUSIC_INDEX_BTN_OVER_2 1003   //用于UI的音效:按钮悬停
#define MUSIC_INDEX_BTN_UP_1   1004   //用于UI的音效:按钮弹起
#define MUSIC_INDEX_FLASH_1    1005   //用于UI的音效:刷新类型1

#define MUSIC_INDEX_BASE_DMGED 5   //基地受击音效
#define MUSIC_INDEX_BASE_DEATH 6   //基地死亡音效
#define MUSIC_INDEX_NO_GOLD    7   //金币不足音效
#define MUSIC_INDEX_ERROR      8   //错误提示音效
#define MUSIC_INDEX_GOLD       9   //获得金币音效
#define MUSIC_INDEX_TOMES      10  //典籍音效
#define MUSIC_INDEX_ITEM       11  //获得物品音效
#define MUSIC_INDEX_BTN_CLICK  12  //按钮点击音效
#define MUSIC_INDEX_UP_SPELL   13  //升级法术音效
#define MUSIC_INDEX_LUMBER     14  //获得木材的声音

#define SOUND_POOL_SIZE 15  // 每个音效的对象池大小（可同时播放20个）

#endif
