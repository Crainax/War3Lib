#ifndef XYweuiYBXTtxxtIncluded
#define XYweuiYBXTtxxtIncluded

#include "XYwebase.j"

library XYweuiYBXTtxxt requires XYwebase

function XYweuiYBXTtxxta takes player XYweui0,real XYweui1,real XYweui2,real XYweui3,integer XYweui4,string XYweui5,string XYweui6 returns nothing
    local integer XYweui_1 = 1
    loop
        exitwhen XYweui_1 > XYweui4
        if (GetLocalPlayer() == XYweui0) then
            call DestroyEffect(AddSpecialEffect(XYweui5,XYweui1+Cos(GetRandomReal(0,6.28))*GetRandomReal(0,XYweui3),XYweui2+Sin(GetRandomReal(0,6.28))*GetRandomReal(0,XYweui3)))
        else
            call DestroyEffect(AddSpecialEffect(XYweui6,XYweui1+Cos(GetRandomReal(0,6.28))*GetRandomReal(0,XYweui3),XYweui2+Sin(GetRandomReal(0,6.28))*GetRandomReal(0,XYweui3)))
        endif
        set XYweui_1 = XYweui_1 + 1
    endloop
    call XYweuiOpenAll2()
endfunction

function XYweuiYBXTtxxtb takes player XYweui0,real XYweui1,real XYweui2,string XYweui3,string XYweui4 returns nothing
    if (GetLocalPlayer() == XYweui0) then
        call DestroyEffect(AddSpecialEffect(XYweui3,XYweui1,XYweui2))
    else
        call DestroyEffect(AddSpecialEffect(XYweui4,XYweui1,XYweui2))
    endif
    call XYweuiOpenAll2()
endfunction

endlibrary 

#endif /// XYweuiYBXTtxxtIncluded
