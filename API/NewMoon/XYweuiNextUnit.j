#ifndef XYweuiNextUnitIncluded
#define XYweuiNextUnitIncluded

#include "XYwebase.j"

library XYweuiNextUnit requires XYwebase

function XYweuiNextUnita takes group XYweuiNextUnita1,unit XYweuiNextUnita2 returns unit
    local group XYweuiNextUnita_1 
    local unit XYweuiNextUnita_2
    
    if CountUnitsInGroup(XYweuiNextUnita1)<=1 or IsUnitInGroup(XYweuiNextUnita2,XYweuiNextUnita1)==false then
        return XYweuiNextUnita2
    endif
    
    set XYweuiNextUnita_1=CreateGroup()
    call GroupAddGroup(XYweuiNextUnita1,XYweuiNextUnita_1)
    loop
        set XYweuiNextUnita_2=FirstOfGroup(XYweuiNextUnita_1)
        call GroupRemoveUnit(XYweuiNextUnita_1,XYweuiNextUnita_2)
        if ((XYweuiNextUnita_2==XYweuiNextUnita2)) then
            if CountUnitsInGroup(XYweuiNextUnita_1)==0 then
                set XYweuiNextUnita2=FirstOfGroup(XYweuiNextUnita1)
            else
                set XYweuiNextUnita2=FirstOfGroup(XYweuiNextUnita_1)
            endif
            exitwhen 0==0
        endif
    endloop
    call DestroyGroup(XYweuiNextUnita_1)
    set XYweuiNextUnita_1=null
    set XYweuiNextUnita_2=null
    call XYweuiOpenAll2()
    
    return XYweuiNextUnita2
endfunction

endlibrary

#endif /// XYweuiNextUnitIncluded
