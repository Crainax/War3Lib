#ifndef DYCbarsimoffIncluded
#define DYCbarsimoffIncluded

#include "DYCbase.j"
#include "XYwebase.j"

library DYCbarsimoff requires DYCbase, XYwebase

function DYCbarsimoff takes unit u returns nothing
    local integer hd=GetHandleId(u)
    call SaveInteger(UDGht,hd,StringHash("barsimj"),0)
    set u=null
    call XYweuiOpenAll2()
endfunction

endlibrary

#endif /// DYCbarsimoffIncluded
