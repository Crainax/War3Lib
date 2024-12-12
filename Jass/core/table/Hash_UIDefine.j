#ifndef HASHUIDefineIncluded
#define HASHUIDefineIncluded

/*
UI哈希表定义
*/

// 0 - 1亿这里用
#define HASH_KEY_UI_TYPE  1820 //反推UI类型
#define HASH_KEY_UI_UI    1821 //反推UI实例

#define HASH_KEY_UI_BASEANIM 1822    //储存的基础动画实例
#define HASH_KEY_UI_EVENT_DATA 1823  //储存的事件数据

#define HASH_KEY_UI_EXTEND_EVENT_LEFT_DOWN   1901 //储存的扩展事件:左键按下
#define HASH_KEY_UI_EXTEND_EVENT_LEFT_UP     1902 //储存的扩展事件:左键抬起
#define HASH_KEY_UI_EXTEND_EVENT_RIGHT_DOWN  1903 //储存的扩展事件:右键按下
#define HASH_KEY_UI_EXTEND_EVENT_RIGHT_UP    1904 //储存的扩展事件:右键抬起
#define HASH_KEY_UI_EXTEND_EVENT_RIGHT_CLICK 1905 //储存的扩展事件:右键点击

#define HASH_KEY_UI_SIMPLE_EVENT_ENTER       1910 //储存的简单事件:鼠标进入
#define HASH_KEY_UI_SIMPLE_EVENT_LEAVE       1911 //储存的简单事件:鼠标离开
#define HASH_KEY_UI_SIMPLE_EVENT_CLICK       1912 //储存的简单事件:鼠标点击
#define HASH_KEY_UI_SIMPLE_EVENT_RIGHT_CLICK 1913 //储存的简单事件:鼠标右键点击

#define HASH_KEY_UI_EXTEND_RESIZER            1940 //储存的扩展自适应器实例
#define HASH_KEY_UI_EXTEND_REPOINTER          1941 //储存的扩展位置重组器实例
#define HASH_KEY_UI_EXTEND_DRAGGER           1944 //储存的扩展拖拽器实例

#endif
