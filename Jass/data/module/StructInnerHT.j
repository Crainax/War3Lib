#ifndef ModuleInnerHTIncluded
#define ModuleInnerHTIncluded

//! zinc
/*
公有的内部哈希表模块
*/
library ModuleInnerHT {

    public module innerHT {

        static hashtable table = InitHashtable();  // 存储绑定数据的哈希表

        // 保存整数数据
        method saveInt (integer key,integer value) {
            SaveInteger(table, this, key, value);
        }

        // 获取整数数据
        method getInt (integer key) -> integer {
            return LoadInteger(table, this, key);
        }

        // 保存整数数据
        method savePlayer (integer key,player value) {
            SavePlayerHandle(table, this, key, value);
        }

        // 获取整数数据
        method getPlayer (integer key) -> player {
            return LoadPlayerHandle(table, this, key);
        }

    }

}

//! endzinc
#endif
