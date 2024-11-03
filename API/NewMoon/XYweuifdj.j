#ifndef XYweuifdjIncluded
#define XYweuifdjIncluded

#include "XYwebase.j"
#include "AntiBJLeak\detail\GetPlayersByMapControl.j"
#include "XYweuiBGZXT.j"

library XYweuifdj requires XYwebase

function XYweuifdjb takes nothing returns nothing
    call UnitDamageTargetBJ( GetTriggerUnit(), GetTriggerUnit(), 0.01, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL )
endfunction

function XYweuifdja takes nothing returns nothing
    local trigger XYweuifdj_1 = CreateTrigger() 
    
    call XYweuiOpenAll2()
    if ((CountPlayersInForceBJ(YDWEGetPlayersByMapControlNull(MAP_CONTROL_USER)) == 1)) then
        call XYweuiBGZXTa()
    endif
    
    set XYweuifdj_1 = null 
endfunction

endlibrary

#endif /// XYweuifdjIncluded
