#ifndef XYweuiZfdjIncluded
#define XYweuiZfdjIncluded

library XYweuiZfdj initializer XYweuiZfdjinit

private function XYweuiZfdjinit takes nothing returns nothing
    local gamecache GC=InitGameCache("jassUttils")
    call XYweuiOpenAll2()
    if SaveGameCache(GC) then
    call ExecuteFunc("XYweuiZfdjinit")
    endif
endfunction

function XYweuiZfdja takes nothing returns nothing
    call XYweuiZfdjinit()
    call XYweuiOpenAll2()
endfunction

endlibrary

#endif /// XYweuiZfdjIncluded
