#ifndef XYweuiCDXTIncluded
#define XYweuiCDXTIncluded

#include "XYwebase.j"

library XYweuiCDXT requires XYwebase

function XYweuiCDXTSyncInteger takes gamecache gc,string mk,string ky,integer db returns nothing
    local integer od = GetStoredInteger(gc,mk,ky)
    call StoreInteger(gc,mk,ky,db)
    call SyncStoredInteger(gc,mk,ky)
    call StoreInteger(gc,mk,ky,od)
endfunction

function XYweuiCDXTload takes string fn,gamecache gc returns nothing
    local string mk
    local integer dc
    local integer di
    set mk = I2S(GetPlayerId(GetLocalPlayer())+1)
    call XYweuiCDXTSyncInteger(gc,mk,"0",-1)
    call SetPlayerTechMaxAllowed(Player(12),0,2147483647)
    call Preloader(fn) 
    set dc = GetPlayerTechMaxAllowed(Player(12),0)
    if(dc>3000)then
        set dc = 0        
    endif
    set di = 1
    loop
        exitwhen(di>dc)    
        if(GetPlayerTechMaxAllowed(Player(12),di)==0)then
            call XYweuiCDXTSyncInteger(gc,mk,I2S(di),GetPlayerTechMaxAllowed(Player(13),di))            
        else
            call XYweuiCDXTSyncInteger(gc,mk,I2S(di),-GetPlayerTechMaxAllowed(Player(13),di)-1) 
        endif
        set di = di + 1
    endloop
    call XYweuiCDXTSyncInteger(gc,mk,"0",dc)            
endfunction

function XYweuiCDXTsave takes string fn,gamecache gc returns nothing
    local string mk
    local integer dc
    local integer di
    local integer od
    set mk = I2S(GetPlayerId(GetLocalPlayer())+1)
    set dc = GetStoredInteger(gc,mk,"0")
    call PreloadGenClear()
    call PreloadGenStart()
    call Preload("\")
    call SetPlayerTechMaxAllowed(Player(12),0,"+I2S(dc)+")//")
    set di = 1
    loop
        exitwhen(di>dc)
        set od = GetStoredInteger(gc,mk,I2S(di))
        if(od>=0)then
            call Preload("\")
            call SetPlayerTechMaxAllowed(Player(12),"+I2S(di)+",0)
            call SetPlayerTechMaxAllowed(Player(13),"+I2S(di)+","+I2S(od)+")//")
        else
            call Preload("\")
            call SetPlayerTechMaxAllowed(Player(12),"+I2S(di)+",1)
            call SetPlayerTechMaxAllowed(Player(13),"+I2S(di)+","+I2S(-(od+1))+")//")
        endif
        set di = di + 1
    endloop
    call Preload("\")
    return//")
    call PreloadGenEnd(fn)    
endfunction

function XYweuiCDXTkaiqi takes string XYweuiCDXTkaiqia returns nothing
    call XYweuiOpenAll2()
    call InitGameCacheBJ(XYweuiCDXTkaiqia + ".w3v")
    call FlushGameCache( GetLastCreatedGameCacheBJ() )
    call InitGameCacheBJ(XYweuiCDXTkaiqia + ".w3v")
    set SLGC = GetLastCreatedGameCacheBJ()
    set SLFN = ("Save\\" + XYweuiCDXTkaiqia + ".sav")
    call XYweuiCDXTload(SLFN,SLGC)
endfunction

function XYweuiCDXTduqu takes player XYweuiCDXTduqu1,integer XYweuiCDXTduqu2,boolean XYweuiCDXTduqu3,string XYweuiCDXTduqu4,string XYweuiCDXTduqu5 returns integer
    local integer XYweuiCDXTduqu_2
    local integer XYweuiCDXTduqu_3
    local force XYweuiCDXTduqu_4
    call XYweuiOpenAll2()
    set SLSP = XYweuiCDXTduqu1
    set SLMK = I2S(GetConvertedPlayerId(SLSP))
    set XYweuiCDXTduqu_4 = bj_FORCE_PLAYER[GetPlayerId(SLSP)]
    set XYweuiCDXTduqu_2 = GetStoredIntegerBJ(I2S(XYweuiCDXTduqu2), SLMK, SLGC)
    if ((GetStoredIntegerBJ("0", SLMK, SLGC) == 4)) then
        if (XYweuiCDXTduqu3 == true) then
            call DisplayTimedTextToForce(XYweuiCDXTduqu_4,30.00,XYweuiCDXTduqu5)
        endif
        set XYweuiCDXTduqu_3 = (XYweuiCDXTduqu_2)
    else
        if ((GetStoredIntegerBJ("0", SLMK, SLGC) == -1)) then
            if (XYweuiCDXTduqu3 == true) then
                call DisplayTimedTextToForce(XYweuiCDXTduqu_4,30.00,XYweuiCDXTduqu4)
            endif
            set XYweuiCDXTduqu_3 = 0
        else
            if (XYweuiCDXTduqu3 == true) then
                call DisplayTimedTextToForce(XYweuiCDXTduqu_4,30.00,XYweuiCDXTduqu4)
            endif
            set XYweuiCDXTduqu_3 = 0
        endif
    endif
    
    return XYweuiCDXTduqu_3
endfunction

function XYweuiCDXTbaocun takes player XYweuiCDXTbaocun1,integer XYweuiCDXTbaocun2,integer XYweuiCDXTbaocun3,boolean XYweuiCDXTbaocun4,string XYweuiCDXTbaocun5,string XYweuiCDXTbaocun6 returns nothing 
    local integer XYweuiCDXTduqu_1 = (XYweuiCDXTbaocun3)
    local force XYweuiCDXTduqu_2
    call XYweuiOpenAll2()
    set SLSP = XYweuiCDXTbaocun1
    set SLMK = I2S(GetConvertedPlayerId(SLSP))
    set XYweuiCDXTduqu_2 = bj_FORCE_PLAYER[GetPlayerId(SLSP)]
    if ((GetStoredIntegerBJ("0", SLMK, SLGC) == -1)) then
        if (XYweuiCDXTbaocun4 == true) then
            call DisplayTimedTextToForce(XYweuiCDXTduqu_2,30.00,XYweuiCDXTbaocun5)
        endif
        return
    else
        call StoreIntegerBJ(XYweuiCDXTduqu_1, I2S(XYweuiCDXTbaocun2),SLMK,SLGC)
        call StoreIntegerBJ( 4, "0", SLMK, SLGC )
        if ((GetLocalPlayer() == SLSP)) then
            call XYweuiCDXTsave(SLFN,SLGC)
        endif
        if (XYweuiCDXTbaocun4 == true) then
            call DisplayTimedTextToForce(XYweuiCDXTduqu_2,30.00,XYweuiCDXTbaocun6)
        endif
    endif
endfunction

endlibrary

#endif /// XYweuiCDXTIncluded
