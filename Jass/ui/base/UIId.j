#ifndef UIIdIncluded
#define UIIdIncluded

//! zinc

/*
ID复用器
*/
// 使用常量定义父键，使代码更清晰
#define RECYCLE_POOL  1  // 存储回收的ID
#define ID_STATUS     2  // 存储ID状态

library UIId {

    public struct uiId []{
        static hashtable ht;
        static integer nextId;
        static integer recycleCount;

        static method onInit () {
            thistype.ht = InitHashtable();
            thistype.nextId = 1;
            thistype.recycleCount = 0;
        }

        static method get ()  -> integer {
            integer id;

            // 如果有已回收的ID，优先使用
            if (recycleCount > 0) {
                // 获取最后一个回收的ID
                id = LoadInteger(ht, RECYCLE_POOL, recycleCount - 1);
                // 从回收池中删除这个ID
                RemoveSavedInteger(ht, RECYCLE_POOL, recycleCount - 1);
                // 从状态表中删除
                RemoveSavedBoolean(ht, ID_STATUS, id);
                recycleCount = recycleCount - 1;
                return id;
            }

            // 如果没有可复用的ID，返回新的ID
            id = nextId;
            nextId = nextId + 1;
            return id;
        }

        static method recycle (integer id) {
            // 快速检查ID是否已经在回收池中
            if (!HaveSavedBoolean(ht, ID_STATUS, id)) {
                // 将ID存入回收池
                SaveInteger(ht, RECYCLE_POOL, recycleCount, id);
                // 标记该ID已被回收
                SaveBoolean(ht, ID_STATUS, id, true);
                recycleCount = recycleCount + 1;
            }
        }

        // 获取回收池中ID的数量
        static method getRecycledCount() -> integer {
            return recycleCount;
        }

        // 获取当前正在使用的ID数量
        static method getActiveCount() -> integer {
            // 最大ID减去已回收的ID数量
            return (nextId - 1) - recycleCount;
        }

    }
}

#undef RECYCLE_POOL
#undef ID_STATUS

//! endzinc
#endif


