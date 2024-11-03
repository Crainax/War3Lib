#ifndef XYweuidjjcIncluded
#define XYweuidjjcIncluded

#include "XYwebase.j"

library XYweuidjjc initializer XYweuidjjcInit requires XYwebase

private function XYweuidjjcInit takes nothing returns nothing
    set islanmode=not SaveGameCache(GC)
endfunction

function XYweuidjjca takes nothing returns boolean
    call XYweuiOpenAll2()
    return islanmode
endfunction

endlibrary

#endif /// XYweuidjjcIncluded
