#ifndef HeroTypeIncluded
#define HeroTypeIncluded

#include "Crainax/config/SharedMethod.h"

//! zinc
/*
英雄基础结构体
*/
library HeroType {

    public struct hero {

        unit u;
        STRUCT_SHARED_METHODS(hero)

        static method bindUnit (unit u) -> thistype {
            thistype this = allocate();
            this.u = u;
            return this;
        }

        method onDestroy () {

            RemoveUnit(u); //删除单位
        }

    }

}

//! endzinc
#endif
