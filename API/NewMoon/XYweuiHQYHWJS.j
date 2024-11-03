#ifndef XYweuiHQYHWJSIncluded
#define XYweuiHQYHWJSIncluded

#include "XYwebase.j"
#include "AntiBJLeak\detail\GetPlayersByMapControl.j"

library XYweuiHQYHWJS requires XYwebase

function XYweuiHQYHWJSa takes nothing returns integer
     local integer XYweuiHQYHWJSa_1 = 0
     local integer XYweuiHQYHWJSa_2=0
     call XYweuiOpenAll2()
     loop
         exitwhen XYweuiHQYHWJSa_2>11
         if ((GetPlayerController(Player(XYweuiHQYHWJSa_2))==MAP_CONTROL_USER) and (GetPlayerSlotState(Player(XYweuiHQYHWJSa_2))==PLAYER_SLOT_STATE_PLAYING)) then
             set XYweuiHQYHWJSa_1 = XYweuiHQYHWJSa_1 + 1
         endif
         set XYweuiHQYHWJSa_2 = XYweuiHQYHWJSa_2 + 1
     endloop
     return XYweuiHQYHWJSa_1
endfunction

endlibrary

#endif /// XYweuiHQYHWJSIncluded
