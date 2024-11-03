#ifndef XYweuijnxtIncluded
#define XYweuijnxtIncluded

#include "XYwebase.j"
#include "YDWEJumpTimer.j"

library XYweuijnxt requires XYwebase, YDWEJumpTimer

function XYweuijnxta takes unit XYweuijnxta1, real XYweuijnxta2, real XYweuijnxta3, real XYweuijnxta4 returns nothing
    call YDWEJumpTimer(XYweuijnxta1, GetUnitFacing(XYweuijnxta1), 0.00,XYweuijnxta2,XYweuijnxta3,XYweuijnxta4)
    call XYweuiOpenAll2()
endfunction

endlibrary

#endif /// XYweuijnxtIncluded
