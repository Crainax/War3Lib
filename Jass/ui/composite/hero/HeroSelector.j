#ifndef HeroSelectorIncluded
#define HeroSelectorIncluded

//! zinc
/*
老的英雄UI
*/
library HeroSelector {

    public struct heroSelector [] {

        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(heroSelector)

    }

    public struct heroData [] {
        STRUCT_SHARED_METHODS(heroData)

    }


    function onInit () {

    }


}

//! endzinc
#endif
