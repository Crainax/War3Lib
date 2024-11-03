#ifndef XYweuiddjlIncluded
#define XYweuiddjlIncluded

#include "XYwebase.j"

library XYweuiddjl requires XYwebase

function XYweuiddjla takes real XYweuiddjlr returns boolean
    local boolean XYweuiddjlb = FALSE
    call XYweuiOpenAll2()
    if ( XYweuiddjlr <= 0.00 ) then
        set XYweuiddjlb = false
    else
        if  (( XYweuiddjlr > 0.00 ) and ( XYweuiddjlr < 100.00 )) then
            if ( GetRandomReal(0.00, 100.00) <= XYweuiddjlr ) then
                set XYweuiddjlb = true
            else
                set XYweuiddjlb = false
            endif
        else
            if ( XYweuiddjlr >= 100.0 ) then
                set XYweuiddjlb = TRUE
            endif
        endif
    endif
    
    return XYweuiddjlb
endfunction

function Probability takes real XYweuiddjlr returns boolean
    local boolean XYweuiddjlb = FALSE
    
    if ((XYweuiddjla(XYweuiddjlr)) == true) then
        set XYweuiddjlb = TRUE
    endif
    
    return XYweuiddjlb
endfunction

//////////////////////////////
////////////DWPD//////////////

function XYweuidwpda takes unit XYweuidwpda1, player XYweuidwpda2, integer XYweuidwpda3, boolean XYweuidwpda4, integer XYweuidwpda5, integer XYweuidwpda6 returns boolean
    local boolean XYweuidwpda_1
    local integer XYweuidwpda_2 = 0
    call XYweuiOpenAll2()
    if ((((XYweuidwpda3 == 1) and (IsUnitEnemy(XYweuidwpda1, XYweuidwpda2) == true)) or ((XYweuidwpda3 == 2) and (IsUnitEnemy(XYweuidwpda1, XYweuidwpda2) == false)) or (XYweuidwpda3 == 3)) or ((XYweuidwpda4 == true) and ((IsUnitOwnedByPlayer(XYweuidwpda1, Player(PLAYER_NEUTRAL_AGGRESSIVE)) == true)))) then
        set XYweuidwpda_2 = (XYweuidwpda_2 + 1)
    endif
    if ((XYweuidwpda5 == 1) and ((IsUnitType(XYweuidwpda1, UNIT_TYPE_STRUCTURE) == false) and (IsUnitType(XYweuidwpda1, UNIT_TYPE_MECHANICAL) == false))) then
        set XYweuidwpda_2 = (XYweuidwpda_2 + 1)
    endif
    if ((XYweuidwpda5 == 2) and ((IsUnitType(XYweuidwpda1, UNIT_TYPE_STRUCTURE) == false) and (IsUnitType(XYweuidwpda1, UNIT_TYPE_MECHANICAL) == false)) and (IsUnitType(XYweuidwpda1, UNIT_TYPE_HERO) == false)) then
        set XYweuidwpda_2 = (XYweuidwpda_2 + 1)
    endif
    if ((XYweuidwpda5 == 3) and ((IsUnitType(XYweuidwpda1, UNIT_TYPE_STRUCTURE) == true)) and (IsUnitType(XYweuidwpda1, UNIT_TYPE_MECHANICAL) == true)) then
        set XYweuidwpda_2 = (XYweuidwpda_2 + 1)
    endif
    if ((XYweuidwpda5 == 4) and ((IsUnitType(XYweuidwpda1, UNIT_TYPE_HERO) == true))) then
        set XYweuidwpda_2 = (XYweuidwpda_2 + 1)
    endif
    if ((XYweuidwpda5 == 5) and ((IsUnitType(XYweuidwpda1, UNIT_TYPE_HERO) == false))) then
        set XYweuidwpda_2 = (XYweuidwpda_2 + 1)
    endif
    if ((XYweuidwpda5 == 6) and ((IsUnitType(XYweuidwpda1, UNIT_TYPE_HERO) == false)) and ((IsUnitType(XYweuidwpda1, UNIT_TYPE_STRUCTURE) == false) and (IsUnitType(XYweuidwpda1, UNIT_TYPE_MECHANICAL) == false))) then
        set XYweuidwpda_2 = (XYweuidwpda_2 + 1)
    endif
    if (XYweuidwpda5 == 7) then
        set XYweuidwpda_2 = (XYweuidwpda_2 + 1)
    endif
    if ((XYweuidwpda6 == 1) and ((IsUnitType(XYweuidwpda1, UNIT_TYPE_DEAD) == false))) then
        set XYweuidwpda_2 = (XYweuidwpda_2 + 1)
    endif
    if ((XYweuidwpda6 == 2) and ((IsUnitType(XYweuidwpda1, UNIT_TYPE_DEAD) == true))) then
        set XYweuidwpda_2 = (XYweuidwpda_2 + 1)
    endif
    if (XYweuidwpda6 == 3) then
        set XYweuidwpda_2 = (XYweuidwpda_2 + 1)
    endif
    
    if (XYweuidwpda_2 == 3) then
        set XYweuidwpda_1 = true
    else
        set XYweuidwpda_1 = false
    endif

    return XYweuidwpda_1
endfunction


function XYweuiSXXQPDa takes unit XYweuiSXXQPDa1, real XYweuiSXXQPDa4, real XYweuiSXXQPDa3, unit XYweuiSXXQPDa2 returns boolean
    local location XYweuiSXXQPDa_1 = GetUnitLoc(XYweuiSXXQPDa1)
    local location XYweuiSXXQPDa_2 = GetUnitLoc(XYweuiSXXQPDa2)
    local real XYweuiSXXQPDa_3 = AngleBetweenPoints(XYweuiSXXQPDa_1,XYweuiSXXQPDa_2)
    local boolean XYweuiSXXQPDa_4
    call XYweuiOpenAll2()
    if (((XYweuiSXXQPDa_3 <= ( XYweuiSXXQPDa3 + XYweuiSXXQPDa4 ))) and (((XYweuiSXXQPDa_3 >= ( ( 360.00 - XYweuiSXXQPDa_3 ) + XYweuiSXXQPDa4 ))) or ((( ( 360.00 - XYweuiSXXQPDa3 ) + XYweuiSXXQPDa4 ) > 360.00) and (XYweuiSXXQPDa_3 >= ( ( XYweuiSXXQPDa3 * -1.00 ) + XYweuiSXXQPDa4 ))))) then
        set XYweuiSXXQPDa_4 = true
    else
        set XYweuiSXXQPDa_4 = false
    endif
    call RemoveLocation(XYweuiSXXQPDa_1)
    call RemoveLocation(XYweuiSXXQPDa_2)
    set XYweuiSXXQPDa_3 = 0.01
    
    return XYweuiSXXQPDa_4
endfunction

endlibrary 

#endif /// XYweuiddjlIncluded
