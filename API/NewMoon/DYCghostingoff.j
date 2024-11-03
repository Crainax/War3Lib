#ifndef DYCghostingoffIncluded
#define DYCghostingoffIncluded

#include "DYCbase.j"
#include "XYwebase.j"

library DYCghostingoff requires DYCbase, XYwebase

function DYCghostingoff takes unit u returns nothing
    local integer hd=GetHandleId(u)
    call SaveInteger(UDGht,hd,StringHash("ghostingj"),0)
    set u=null
    call XYweuiOpenAll2()
endfunction

endlibrary

#endif /// DYCghostingoffIncluded
