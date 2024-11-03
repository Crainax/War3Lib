#ifndef XYweuiHQZJWJIncluded
#define XYweuiHQZJWJIncluded

#include "XYwebase.j"

library XYweuiHQZJWJ requires XYwebase

function XYweuiHQZJWJa takes nothing returns player
    call XYweuiOpenAll2()
    call StoreInteger(GC,"hostdetect","hostdetect",GetPlayerId(GetLocalPlayer())+1)
    call TriggerSyncStart()
    call SyncStoredInteger(GC,"hostdetect","hostdetect")
    call TriggerSyncReady()
    return Player(GetStoredInteger(GC,"hostdetect","hostdetect")-1)
endfunction

endlibrary

#endif /// XYweuiHQZJWJIncluded
