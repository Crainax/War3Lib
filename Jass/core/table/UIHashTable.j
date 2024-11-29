#ifndef UIHashTableIncluded
#define UIHashTableIncluded

//! zinc
/*
UI哈希表
*/

// 0 - 1亿这里用
#define HASH_KEY_UI_TYPE  1820 //反推UI类型
#define HASH_KEY_UI_UI    1821 //反推UI实例

library UIHashTable {

    hashtable HASH_UI = InitHashtable();  // UI结构哈希表

    //frame是UI的父窗口，typeID是UI类型，ui是UI实例
    //由frame反推UIStruct用
    function BindFrameToUI (integer frame,integer typeID,integer ui) {
        SaveInteger(HASH_UI,GetHandleId(frame),HASH_KEY_UI_TYPE,typeID);
        SaveInteger(HASH_UI,GetHandleId(frame),HASH_KEY_UI_UI,ui);
    }

    //由绑定的frame反推UIStruct用
    function GetUIFromFrame (integer frame) -> integer {
        return LoadInteger(HASH_UI,GetHandleId(frame),HASH_KEY_UI_TYPE);
    }

    //由绑定的frame反推UIStruct用
    function GetTypeIDFromFrame (integer frame) -> integer {
        return LoadInteger(HASH_UI,GetHandleId(frame),HASH_KEY_UI_UI);
    }

}

//! endzinc
#endif
