#ifndef XYweuidwbezpdIncluded
#define XYweuidwbezpdIncluded

#include "XYwebase.j"
#include "WM/IsUnitInvulnerable.j"
#include "UnitAlive.j"

library XYweuidwbezpd requires XYwebase, IsUnitInvulnerable, UnitAlive 

function XYweuidwbezpda /*
    */takes /*
    */ unit XYweuidwbezpda1, player XYweuidwbezpda2, integer XYweuidwbezpda3, integer XYweuidwbezpda4, integer XYweuidwbezpda5,/*
    */ integer XYweuidwbezpda6, integer XYweuidwbezpda7, integer XYweuidwbezpda8, integer XYweuidwbezpda9, integer XYweuidwbezpda10 returns boolean
    local boolean XYweuidwbezpda_1 = FALSE
    local integer XYweuidwbezpda_2 = 0
    call XYweuiOpenAll2()
    if ((XYweuidwbezpda3 == 1) and ((IsUnitEnemy(XYweuidwbezpda1, XYweuidwbezpda2) == true) or (GetOwningPlayer(XYweuidwbezpda1) == Player(PLAYER_NEUTRAL_AGGRESSIVE)))) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda3 == 2) and ((IsUnitEnemy(XYweuidwbezpda1, XYweuidwbezpda2) != true) or (GetOwningPlayer(XYweuidwbezpda1) == Player(PLAYER_NEUTRAL_AGGRESSIVE)))) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda3 == 4) and ((IsUnitEnemy(XYweuidwbezpda1, XYweuidwbezpda2) == true) or (GetOwningPlayer(XYweuidwbezpda1) != Player(PLAYER_NEUTRAL_AGGRESSIVE)))) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda3 == 5) and ((IsUnitEnemy(XYweuidwbezpda1, XYweuidwbezpda2) != true) or (GetOwningPlayer(XYweuidwbezpda1) != Player(PLAYER_NEUTRAL_AGGRESSIVE)))) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda3 == 6) and (GetOwningPlayer(XYweuidwbezpda1) != Player(PLAYER_NEUTRAL_AGGRESSIVE))) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda4 == 1) and (UnitAlive(XYweuidwbezpda1) == true)) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda4 == 2) and (UnitAlive(XYweuidwbezpda1) != true)) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda5 == 1) and (IsUnitInvulnerable(XYweuidwbezpda1) == true)) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda5 == 2) and (IsUnitInvulnerable(XYweuidwbezpda1) != true)) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda6 == 1) and (IsUnitType(XYweuidwbezpda1, UNIT_TYPE_MAGIC_IMMUNE) == true)) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda6 == 2) and (IsUnitType(XYweuidwbezpda1, UNIT_TYPE_MAGIC_IMMUNE) != true)) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda7 == 1) and (IsUnitType(XYweuidwbezpda1, UNIT_TYPE_HERO) == true)) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda7 == 2) and (IsUnitType(XYweuidwbezpda1, UNIT_TYPE_HERO) != true)) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda8 == 1) and (IsUnitType(XYweuidwbezpda1, UNIT_TYPE_STRUCTURE) == true)) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda8 == 2) and (IsUnitType(XYweuidwbezpda1, UNIT_TYPE_STRUCTURE) != true)) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda9 == 1) and (IsUnitType(XYweuidwbezpda1, UNIT_TYPE_SUMMONED) == true)) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda9 == 2) and (IsUnitType(XYweuidwbezpda1, UNIT_TYPE_SUMMONED) != true)) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda10 == 1) and (IsUnitType(XYweuidwbezpda1, UNIT_TYPE_MECHANICAL) == true)) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if ((XYweuidwbezpda10 == 2) and (IsUnitType(XYweuidwbezpda1, UNIT_TYPE_MECHANICAL) != true)) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if (XYweuidwbezpda3 == 3) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if (XYweuidwbezpda4 == 3) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if (XYweuidwbezpda5 == 3) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if (XYweuidwbezpda6 == 3) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if (XYweuidwbezpda7 == 3) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if (XYweuidwbezpda8 == 3) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if (XYweuidwbezpda9 == 3) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    if (XYweuidwbezpda10 == 3) then
        set XYweuidwbezpda_2 = XYweuidwbezpda_2 + 1
    endif
    
    if (XYweuidwbezpda_2 == 8) then
        set XYweuidwbezpda_1 = TRUE
        return XYweuidwbezpda_1
    else
        return XYweuidwbezpda_1
    endif
endfunction

endlibrary

#endif /// XYweuidwbezpdIncluded
