#ifndef BigPanelIncluded
#define BigPanelIncluded


#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量
#include "Crainax/data/audio/MusicConstant.j" // UI常量

//! zinc
/*
大面板(存档面板)
*/
library BigPanel requires Tooltip,ToastHint,Music,Icon,ImageAnim {

    private struct bigPanelData [] {

    }

    public struct bigpanel {
        STRUCT_SHARED_METHODS(bigpanel)

    }

}

//! endzinc
#endif
