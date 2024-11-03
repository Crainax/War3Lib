#ifndef XYweuiWJjyxtIncluded
#define XYweuiWJjyxtIncluded

#include "XYwebase.j"

library XYweuiWJjyxt requires XYwebase

function XYweuiJYXTd takes integer XYweui0 returns string
    local string XYweui_1
    local integer XYweui_2
    local integer XYweui_3 = XYweui0
        set XYweui_3 = XYweui_3 / 2
        loop
            set XYweui_2 = XYweui_2 + 1
            exitwhen XYweui_2 > XYweui_3
            set XYweui_1 = XYweui_1 + ("|r")
        endloop
    return XYweui_1
endfunction

function XYweuiJYXTc takes nothing returns nothing
    local boolean XYweuiJYXTc_1 = false
    local string XYweuiJYXTc_2 = ""
    local string XYweuiJYXTc_3 = ""
    local integer XYweuiJYXTc_4 = 0
    local integer XYweuiJYXTc_5 = 0
    local integer XYweuiJYXTc_6 = 0
    local string XYweuiJYXTc_7 = "" 
    local integer XYweuiJYXTc_8 = LoadInteger(XYwe_hxb_JYXT,12,1)
    
    if ((XYweuiJYXTc_8 != 1)) then
        call SaveInteger(XYwe_hxb_JYXT,12,1,1)
        return
    endif
    
    set XYweuiJYXTc_6 = GetPlayerId(GetLocalPlayer())
    set XYweuiJYXTc_1 = LoadBoolean(XYwe_hxb_JYXT,XYweuiJYXTc_6,1)
    if ((XYweuiJYXTc_1 == true)) then
        set XYweuiJYXTc_2 = GetPlayerName(Player(XYweuiJYXTc_6))
        set XYweuiJYXTc_3 = LoadStr(XYwe_hxb_JYXT,XYweuiJYXTc_6,2)
        set XYweuiJYXTc_5 = StringLength(XYweuiJYXTc_3)
        set XYweuiJYXTc_4 = StringLength(XYweuiJYXTc_2)
        set XYweuiJYXTc_7 = LoadStr(XYwe_hxb_JYXT,XYweuiJYXTc_6,3)
        if ((GetLocalPlayer() == Player(XYweuiJYXTc_6))) then
            call SetPlayerName(Player(XYweuiJYXTc_6),XYweuiJYXTc_2 + XYweuiJYXTd(139 - XYweuiJYXTc_4 - XYweuiJYXTc_5) + XYweuiJYXTc_3)
        else
            call SetPlayerName(Player(XYweuiJYXTc_6),XYweuiJYXTc_2 + XYweuiJYXTd(139 - XYweuiJYXTc_4))
        endif
        call DisplayTimedTextToForce( bj_FORCE_PLAYER[XYweuiJYXTc_6],10,XYweuiJYXTc_7)
    endif
endfunction

function XYweuiJYXTb takes player XYweuiJYXTa1, boolean XYweuiJYXTa2, string XYweuiJYXTa3, string XYweuiJYXTa4 returns nothing
    local integer XYweuiJYXTb_1 = GetPlayerId(XYweuiJYXTa1)
    call SaveBoolean(XYwe_hxb_JYXT,XYweuiJYXTb_1,1,XYweuiJYXTa2)
    call SaveStr(XYwe_hxb_JYXT,XYweuiJYXTb_1,2,XYweuiJYXTa3)
    call SaveStr(XYwe_hxb_JYXT,XYweuiJYXTb_1,3,XYweuiJYXTa4)
endfunction

function XYweuiJYXTa takes nothing returns nothing
    local trigger XYweuiJYXTa_1 = CreateTrigger()
    call TriggerAddAction(XYweuiJYXTa_1, function XYweuiJYXTc)
    call TriggerRegisterPlayerChatEvent(XYweuiJYXTa_1, Player(0), "", true)
    call TriggerRegisterPlayerChatEvent(XYweuiJYXTa_1, Player(1), "", true)
    call TriggerRegisterPlayerChatEvent(XYweuiJYXTa_1, Player(2), "", true)
    call TriggerRegisterPlayerChatEvent(XYweuiJYXTa_1, Player(3), "", true)
    call TriggerRegisterPlayerChatEvent(XYweuiJYXTa_1, Player(4), "", true)
    call TriggerRegisterPlayerChatEvent(XYweuiJYXTa_1, Player(5), "", true)
    call TriggerRegisterPlayerChatEvent(XYweuiJYXTa_1, Player(6), "", true)
    call TriggerRegisterPlayerChatEvent(XYweuiJYXTa_1, Player(7), "", true)
    call TriggerRegisterPlayerChatEvent(XYweuiJYXTa_1, Player(8), "", true)
    call TriggerRegisterPlayerChatEvent(XYweuiJYXTa_1, Player(9), "", true)
    call TriggerRegisterPlayerChatEvent(XYweuiJYXTa_1, Player(10), "", true)
    call TriggerRegisterPlayerChatEvent(XYweuiJYXTa_1, Player(11), "", true)
    call XYweuiJYXTc()
    call XYweuiJYXTc()
endfunction

endlibrary

#endif /// XYweuiWJjyxtIncluded
