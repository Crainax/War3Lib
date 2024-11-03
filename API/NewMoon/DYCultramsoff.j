#ifndef DYCultramsoffIncluded
#define DYCultramsoffIncluded

#include "DYCbase.j"
#include "XYwebase.j"

library DYCultramsoff requires DYCbase, XYwebase

function DYCultramsoff takes unit u returns nothing
    local integer hd=GetHandleId(u)
    call SaveInteger(UDGht,hd,StringHash("ultramsj"),0)
    set u=null
    call XYweuiOpenAll2()
endfunction

endlibrary

#endif /// DYCultramsoffIncluded
