#ifndef XYweuiHQDXGDIncluded
#define XYweuiHQDXGDIncluded

#include "XYwebase.j"

library XYweuiHQDXGD requires XYwebase

function XYweuiHQDXGDa takes real XYweuiHQDXGDa1, real XYweuiHQDXGDa2 returns real
    call XYweuiOpenAll2()
    call MoveLocation(L,XYweuiHQDXGDa1,XYweuiHQDXGDa2)
    return GetLocationZ(L)
endfunction

endlibrary

#endif /// XYweuiHQDXGDIncluded
