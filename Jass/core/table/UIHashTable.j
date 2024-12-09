#ifndef UIHashTableIncluded
#define UIHashTableIncluded

//! zinc
/*
UI哈希表通用函数
*/

#include "Crainax/core/table/Hash_UIDefine.j"

library UIHashTable {

    public hashtable HASH_UI = InitHashtable();  // UI结构哈希表

    public struct uiHashTable [] {
        static uiHTEvent eventdata = uiHTEvent[0];  //方便链式调用  uiHashTable.eventdata.set() 和 uiHashTable.eventdata.get()
        static uiHTFrame ui        = uiHTFrame[0];  //方便链式调用  uiHashTable.ui.bind() 和 uiHashTable.ui.get()
    }

    // 子结构体函数
    struct uiHTFrame [] {
        // 绑定UI实例到frame
        static method bind (integer frame,integer typeID,integer ui) {
            SaveInteger(HASH_UI,frame,HASH_KEY_UI_TYPE,typeID);
            SaveInteger(HASH_UI,frame,HASH_KEY_UI_UI,ui);
        }

        // 从frame获取UI实例
        static method get (integer frame) -> integer {
            return LoadInteger(HASH_UI,frame,HASH_KEY_UI_UI);
        }

        // 从frame获取UI类型
        static method getType (integer frame) -> integer {
            return LoadInteger(HASH_UI,frame,HASH_KEY_UI_TYPE);
        }
    }

    // 子结构体函数
    struct uiHTEvent [] {
        method bind (integer frame, integer value) {
            SaveInteger(HASH_UI,frame,HASH_KEY_UI_EVENT_DATA,value);
        }

        method get (integer frame) -> integer {
            return LoadInteger(HASH_UI,frame,HASH_KEY_UI_EVENT_DATA);
        }
    }

}

//! endzinc
#endif
