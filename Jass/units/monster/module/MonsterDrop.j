#ifndef MonsterDropIncluded
#define MonsterDropIncluded

#include "Crainax/config/SharedMethod.h"
//! zinc
/*
怪物掉落内容
*/
library MonsterDrop {

    public module monsterDrop {

        module innerHT; // 内部哈希表

        //有几个掉落物
        method getDropCount ()  -> integer {
            return 0;
        }

        //第x个掉落物的内容
        method getDropItem(integer pos) -> itemtype {

        }

        //第x个掉落物的掉落率
        method getDropRate (integer pos)  -> real {

        }


    }

}

//! endzinc
#endif
