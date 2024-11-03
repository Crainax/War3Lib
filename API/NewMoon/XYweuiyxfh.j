#ifndef XYweuiyxfhIncluded
#define XYweuiyxfhIncluded

#include "XYwebase.j"

library XYweuiyxfh requires XYwebase

function XYweuiyxfhb takes nothing returns nothing
    local timer XYweui_1 = GetExpiredTimer()
    local integer XYweui_2 = GetHandleId(XYweui_1)
    local unit XYweui_3 = LoadUnitHandle(XYwe_hxb_4,XYweui_2,1)
    local location XYweui_4 = LoadLocationHandle(XYwe_hxb_4,XYweui_2,2)
    local timer XYweui_5 = LoadTimerHandle(XYwe_hxb_4,XYweui_2,4)
    local timerdialog XYweui_6 = LoadTimerDialogHandle(XYwe_hxb_4,XYweui_2,3)
    local integer XYweui_7 = GetHandleId(XYweui_6)
    if ((IsUnitDeadBJ(XYweui_3) == true)) then
        call ReviveHeroLoc(XYweui_3,XYweui_4,true)
    endif
    call PauseTimer(XYweui_1)
    call DestroyTimer(XYweui_1)
    call PauseTimer(XYweui_5)
    call DestroyTimer(XYweui_5)
    call DestroyTimerDialog(XYweui_6)
    call RemoveLocation(XYweui_4)
    call FlushChildHashtable(XYwe_hxb_4,XYweui_2)
    call FlushChildHashtable(XYwe_hxb_4,XYweui_7)
    set XYweui_1 = null
    set XYweui_3 = null 
    set XYweui_4 = null 
    set XYweui_5 = null 
    set XYweui_6 = null 
endfunction

function XYweuiyxfhc takes nothing returns nothing
    local timer XYweui_1 = GetExpiredTimer()
    local integer XYweui_2 = GetHandleId(XYweui_1)
    local unit XYweui_3 = LoadUnitHandle(XYwe_hxb_4,XYweui_2,1)
    local timer XYweui_4 = LoadTimerHandle(XYwe_hxb_4,XYweui_2,2)
    local timerdialog XYweui_5 = LoadTimerDialogHandle(XYwe_hxb_4,XYweui_2,3)
    local integer XYweui_6 = GetHandleId(XYweui_4)
    local location XYweui_7 = LoadLocationHandle(XYwe_hxb_4,XYweui_6,2)
    if (IsUnitDeadBJ(XYweui_3) == false) then
        call PauseTimer(XYweui_1)
        call DestroyTimer(XYweui_1)
        call PauseTimer(XYweui_4)
        call DestroyTimer(XYweui_4)
        call DestroyTimerDialog(XYweui_5)
        call RemoveLocation(XYweui_7)
        call FlushChildHashtable(XYwe_hxb_4,XYweui_2)
        call FlushChildHashtable(XYwe_hxb_4,XYweui_6)
    endif
    set XYweui_1 = null
    set XYweui_3 = null
    set XYweui_4 = null
    set XYweui_5 = null
    set XYweui_7 = null
endfunction

function XYweuiyxfha takes real XYweui1, location XYweui2, unit XYweui3, boolean XYweui4 returns nothing
    local timer XYweui_1 = CreateTimer()
    local timer XYweui_2 = CreateTimer()
    local timerdialog XYweui_3
    local integer XYweui_4 = GetHandleId(XYweui_1)
    local integer XYweui_5 = GetHandleId(XYweui_2)
    call SaveUnitHandle(XYwe_hxb_4,XYweui_4,1,XYweui3)
    call SaveLocationHandle(XYwe_hxb_4,XYweui_4,2,XYweui2)
    call TimerStart(XYweui_1,XYweui1,false,function XYweuiyxfhb)
    call CreateTimerDialogBJ(XYweui_1,("距离" + ( GetUnitName(XYweui3) + "复活还有： ")))
    set XYweui_3 = GetLastCreatedTimerDialogBJ()
    if (XYweui4 == false) then
        call TimerDialogDisplay(XYweui_3,false)
    endif
    call SaveTimerDialogHandle(XYwe_hxb_4,XYweui_4,3,XYweui_3)
    call SaveTimerHandle(XYwe_hxb_4,XYweui_4,4,XYweui_2)
    call SaveUnitHandle(XYwe_hxb_4,XYweui_5,1,XYweui3)
    call SaveTimerHandle(XYwe_hxb_4,XYweui_5,2,XYweui_1)
    call SaveTimerDialogHandle(XYwe_hxb_4,XYweui_5,3,XYweui_3)
    call TimerStart(XYweui_2,0.1,true,function XYweuiyxfhc)
    call XYweuiOpenAll2()
    set XYweui_1 = null
    set XYweui_2 = null 
    set XYweui_3 = null
endfunction

endlibrary

#endif /// XYweuiyxfhIncluded
