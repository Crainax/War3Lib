#ifndef UIHashTableIncluded
#define UIHashTableIncluded

//! zinc
/*
UI哈希表通用函数
*/

#include "Crainax/core/table/Hash_UIDefine.j"

library UIHashTable {

    public hashtable HASH_UI = InitHashtable();  // UI结构哈希表
    integer frame = 0;

    //对外接口,方便链式调用
    public function uiHashTable (integer f) -> uiHT {
        frame = f;
        return uiHT[0];
    }

    //私有
    struct uiHT [] {
        static integer frame = 0;
        static uiHTEvent eventdata = uiHTEvent[0];  //方便链式调用  uiHashTable(frame).eventdata.bind(8174);
        static uiHTFrame ui        = uiHTFrame[0];  //方便链式调用  uiHashTable(frame).ui.bind(8174);
    }

    // 子结构体函数
    struct uiHTFrame [] {
        // 绑定UI实例到frame
        static method bind (integer typeID,integer ui) {
            SaveInteger(HASH_UI,frame,HASH_KEY_UI_TYPE,typeID);
            SaveInteger(HASH_UI,frame,HASH_KEY_UI_UI,ui);
        }

        // 从frame获取UI实例
        static method get () -> integer {
            return LoadInteger(HASH_UI,frame,HASH_KEY_UI_UI);
        }

        // 从frame获取UI类型
        static method getType () -> integer {
            return LoadInteger(HASH_UI,frame,HASH_KEY_UI_TYPE);
        }
    }

    // 子结构体函数
    struct uiHTEvent [] {
        static method bind (integer value) {
            SaveInteger(HASH_UI,frame,HASH_KEY_UI_EVENT_DATA,value);
        }

        static method get () -> integer {
            return LoadInteger(HASH_UI,frame,HASH_KEY_UI_EVENT_DATA);
        }
    }

}

//! endzinc
#endif
