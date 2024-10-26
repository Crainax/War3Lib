#ifndef KKPREINCLUDE
#define KKPREINCLUDE


library LBKKPRE

    // 设置道具模型
    native DzItemSetModel takes item whichItem, string file returns nothing
    // 设置道具颜色
    native DzItemSetVertexColor takes item whichItem, integer color returns nothing
    // 设置道具透明度
    native DzItemSetAlpha takes item whichItem, integer color returns nothing
    // 解锁JASS字节码限制
    native DzUnlockOpCodeLimit takes boolean enable returns nothing

endlibrary

#endif

