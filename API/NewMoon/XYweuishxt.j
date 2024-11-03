#ifndef XYweuishxtIncluded
#define XYweuishxtIncluded

#include "XYwebase.j"

library XYweuishxt requires XYwebase

function XYweuishxta takes unit XYweuishxta1,unit XYweuishxta2,unit XYweuishxta3,unit XYweuishxta4,real XYweuishxta5,boolean XYweuishxta6,boolean XYweuishxta7,unit XYweuishxta8,integer XYweuishxta9,integer XYweuishxta10 returns nothing
    local integer XYweuishxta_1_1 = GetHandleId(XYweuishxta1) 
    local integer XYweuishxta_1_2 = GetHandleId(XYweuishxta2) 
    local integer XYweuishxta_1_3 = GetHandleId(XYweuishxta3)  
    local integer XYweuishxta_1_4 = GetHandleId(XYweuishxta4) 
    local integer XYweuishxta_1_5 = XYweuishxta9
    local real XYweuishxta_2_0 = LoadReal(XYwe_open,2,(1 + XYweuishxta_1_5)) 
    local real XYweuishxta_2_1 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_3,(1 + XYweuishxta_1_5)) 
    local real XYweuishxta_2_2 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_3,(2 + XYweuishxta_1_5))
    local real XYweuishxta_2_3 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_3,(3 + XYweuishxta_1_5))
    local real XYweuishxta_2_4 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_3,(4 + XYweuishxta_1_5))
    local real XYweuishxta_2_5 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(5 + XYweuishxta_1_5))
    local real XYweuishxta_2_6 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(6 + XYweuishxta_1_5))
    local real XYweuishxta_2_7 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(7 + XYweuishxta_1_5))
    local real XYweuishxta_2_8 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(8 + XYweuishxta_1_5))
    local real XYweuishxta_2_9 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(9 + XYweuishxta_1_5))
    local real XYweuishxta_2_10 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(10 + XYweuishxta_1_5))
    local real XYweuishxta_2_11 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(11 + XYweuishxta_1_5))
    local real XYweuishxta_3_1 = ((XYweuishxta_2_1 - XYweuishxta_2_5) - ((XYweuishxta_2_1 * XYweuishxta_2_6)/100.00))
    local real XYweuishxta_3_2 
    local real XYweuishxta_3_3
    local real XYweuishxta_3_4  
    local real XYweuishxta_3_5  
    local real XYweuishxta_3_6  
    local real XYweuishxta_2_12 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(12 + XYweuishxta_1_5))
    local real XYweuishxta_2_13 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(13 + XYweuishxta_1_5))
    local real XYweuishxta_2_14
    
    call SaveInteger(XYwe_hxb_shys,XYweuishxta_1_1,XYweuishxta_1_5,XYweuishxta10)
    if (XYweuishxta7 == true) then  
        if ( XYweuishxta_2_9 <= 0.00 ) then
            set XYweuishxta_3_3 = (((XYweuishxta5* (100.00 + XYweuishxta_2_11))/100.00) + XYweuishxta_2_13) 
            set XYweuishxta_3_2 = (XYweuishxta_2_2 +((XYweuishxta_3_3 * XYweuishxta_2_3)/100.00))  
        else
            if  (( XYweuishxta_2_9 > 0.00 ) and ( XYweuishxta_2_9 < 100.00 )) then
                if ( GetRandomReal(0.00, 100.00) <= XYweuishxta_2_9 ) then
                    set XYweuishxta_3_3 = ((((((XYweuishxta5 * (100.00 + XYweuishxta_2_8))/100.00) + XYweuishxta_2_7) * (100.00 + XYweuishxta_2_11))/100.00) + XYweuishxta_2_13)
                    set XYweuishxta_3_2 = (XYweuishxta_2_2 +((XYweuishxta_3_3 * XYweuishxta_2_3)/100.00))
                else
                    set XYweuishxta_3_3 = (((XYweuishxta5* (100.00 + XYweuishxta_2_11))/100.00) + XYweuishxta_2_13) 
                    set XYweuishxta_3_2 = (XYweuishxta_2_2 +((XYweuishxta_3_3 * XYweuishxta_2_3)/100.00))
                endif
            else
                if ( XYweuishxta_2_9 >= 100.0 ) then
                    set XYweuishxta_3_3 = ((((((XYweuishxta5 * (100.00 + XYweuishxta_2_8))/100.00) + XYweuishxta_2_7) * (100.00 + XYweuishxta_2_11))/100.00) + XYweuishxta_2_13)
                    set XYweuishxta_3_2 = (XYweuishxta_2_2 +((XYweuishxta_3_3 * XYweuishxta_2_3)/100.00))
                endif
            endif
        endif
    else
        set XYweuishxta_3_3 = (((XYweuishxta5* (100.00 + XYweuishxta_2_11))/100.00) + XYweuishxta_2_13) 
        set XYweuishxta_3_2 = (XYweuishxta_2_2 +((XYweuishxta_3_3 * XYweuishxta_2_3)/100.00))
    endif

    if (XYweuishxta_3_2 >= XYweuishxta_3_3) then 
        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,0.00,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
    else
        set XYweuishxta_3_4 = (XYweuishxta_3_3 - XYweuishxta_3_2) 
        if (XYweuishxta_2_4 >= XYweuishxta_3_4) then 
            call UnitDamageTarget(XYweuishxta1,XYweuishxta2,0.00,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
            call SaveReal(XYwe_hxb_sh,XYweuishxta_1_2,(4 + XYweuishxta_1_5),(XYweuishxta_2_4 - XYweuishxta_3_4))
        else
            if (XYweuishxta_2_4 > 0) then
                call SaveReal(XYwe_hxb_sh,XYweuishxta_1_2,(4 + XYweuishxta_1_5),0.00)
                set XYweuishxta_3_5 = (XYweuishxta_3_4 - XYweuishxta_2_4)  
                if (XYweuishxta6 == true) then 
                    if (XYweuishxta_3_1 < 0) then
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00+(2.00 - Pow((1.00 - XYweuishxta_2_0 ),XYweuishxta_3_1))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    else
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00-((XYweuishxta_2_0 * XYweuishxta_2_1) / ( (XYweuishxta_2_0 * XYweuishxta_2_1) + 1.00))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    endif
                else
                    if (XYweuishxta_3_1 < 0) then
                        set XYweuishxta_3_1 = 0.00
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00 - ((XYweuishxta_2_0 * XYweuishxta_3_1) / ((XYweuishxta_2_0 * XYweuishxta_3_1) + 1.00))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    else
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00 - ((XYweuishxta_2_0 * XYweuishxta_3_1) / ((XYweuishxta_2_0 * XYweuishxta_3_1) + 1.00))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    endif
                endif
            else
                set XYweuishxta_3_5 = XYweuishxta_3_4
                if (XYweuishxta6 == true) then 
                    if (XYweuishxta_3_1 < 0) then
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00+(2.00 - Pow((1.00 - XYweuishxta_2_0 ),XYweuishxta_3_1))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    else
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00-((XYweuishxta_2_0 * XYweuishxta_2_1) / ( (XYweuishxta_2_0 * XYweuishxta_2_1) + 1.00))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    endif
                else
                    if (XYweuishxta_3_1 < 0) then
                        set XYweuishxta_3_1 = 0.00
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00 - ((XYweuishxta_2_0 * XYweuishxta_3_1) / ((XYweuishxta_2_0 * XYweuishxta_3_1) + 1.00))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    else
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00 - ((XYweuishxta_2_0 * XYweuishxta_3_1) / ((XYweuishxta_2_0 * XYweuishxta_3_1) + 1.00))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    endif
                endif
            endif
        endif
    endif
    call SaveInteger(XYwe_hxb_shys,XYweuishxta_1_1,XYweuishxta_1_5,(XYweuishxta10 + 1))
    call XYweuiOpenAll2()
endfunction

function XYweuishxtb takes unit XYweuishxtb1, integer XYweuishxtb4,integer XYweuishxtb3, integer XYweuishxtb2, real XYweuishxtb5 returns nothing
    local integer XYweuishxtb_1 = GetHandleId(XYweuishxtb1)
    local integer XYweuishxtb_2 = (XYweuishxtb4 * 100000)
    local integer XYweuishxtb_3 = (XYweuishxtb_2 + XYweuishxtb2)
    
    if (XYweuishxtb2 == 1) then
        call SaveReal(XYwe_hxb_sh,XYweuishxtb_1,XYweuishxtb_3,((LoadReal(XYwe_hxb_sh,XYweuishxtb_1,XYweuishxtb_3)) + XYweuishxtb5))
    endif
    if (XYweuishxtb2 == 2) then
        call SaveReal(XYwe_hxb_sh,XYweuishxtb_1,XYweuishxtb_3,XYweuishxtb5)
    endif
    if (XYweuishxtb2 == 3) then
        call SaveReal(XYwe_hxb_sh,XYweuishxtb_1,XYweuishxtb_3,((LoadReal(XYwe_hxb_sh,XYweuishxtb_1,XYweuishxtb_3)) - XYweuishxtb5))
    endif
    call XYweuiOpenAll2()
endfunction

function XYweuishxtc takes integer XYweuishxtc1, real XYweuishxtc2 returns nothing 
    call SaveReal(XYwe_open,2,(1 + (XYweuishxtc1 * 100000)),XYweuishxtc2)
endfunction

function XYweuishxtd takes unit XYweuishxtd1, integer XYweuishxtd2,integer XYweuishxtd3 returns real
    local integer XYweuishxtd_1 = GetHandleId(XYweuishxtd1)
    local integer XYweuishxtd_2 = (XYweuishxtd2 * 100000)
    local integer XYweuishxtd_3 = (XYweuishxtd_2 + XYweuishxtd3)
    local real XYweuishxtd_4 
    call XYweuiOpenAll2()
    set XYweuishxtd_4 = LoadReal(XYwe_hxb_sh,XYweuishxtd_1,XYweuishxtd_3)
    
    return XYweuishxtd_4
endfunction

function XYweuishxte takes integer XYweuishxte1 returns real
    local real XYweuishxte_1
    call XYweuiOpenAll2()
    set XYweuishxte_1 = LoadReal(XYwe_open,2,(1 + (XYweuishxte1 * 100000)))
    
    return XYweuishxte_1
endfunction

function XYweuishxtf takes unit XYweuishxtf1, integer XYweuishxtf2, integer XYweuishxtf3 returns boolean
    local integer XYweuishxtf_1 = GetHandleId(XYweuishxtf1)
    local boolean XYweuishxtf_2 = false
    if ((LoadInteger(XYwe_hxb_shys,XYweuishxtf_1,XYweuishxtf2)) == XYweuishxtf3) then
        set XYweuishxtf_2 = true
    endif
    call XYweuiOpenAll2()
    
    return XYweuishxtf_2
endfunction

function XYweuishxtg takes unit XYweuishxtg1,unit XYweuishxtg2,real XYweuishxtg3,boolean XYweuishxtg4,boolean XYweuishxtg5,attacktype XYweuishxtg6,damagetype XYweuishxtg7,integer XYweuishxtg8 returns nothing
    local integer XYweuishxtf_1 = GetHandleId(XYweuishxtg1) 
    call SaveBoolean(XYwe_hxb_shys,XYweuishxtf_1,XYweuishxtg8,true)
    call UnitDamageTarget(XYweuishxtg1,XYweuishxtg2,XYweuishxtg3,XYweuishxtg4,XYweuishxtg5,XYweuishxtg6,XYweuishxtg7,WEAPON_TYPE_WHOKNOWS)
    call SaveBoolean(XYwe_hxb_shys,XYweuishxtf_1,XYweuishxtg8,false)
    call XYweuiOpenAll2()
endfunction

function XYweuishxth takes unit XYweuishxta1,unit XYweuishxta2,unit XYweuishxta3,unit XYweuishxta4,real XYweuishxta5,boolean XYweuishxta6,boolean XYweuishxta7,unit XYweuishxta8,integer XYweuishxta9,integer XYweuishxta10 returns nothing
    local integer XYweuishxta_1_1 = GetHandleId(XYweuishxta1) 
    local integer XYweuishxta_1_2 = GetHandleId(XYweuishxta2) 
    local integer XYweuishxta_1_3 = GetHandleId(XYweuishxta3)  
    local integer XYweuishxta_1_4 = GetHandleId(XYweuishxta4) 
    local integer XYweuishxta_1_5 = XYweuishxta9
    local real XYweuishxta_2_0 = LoadReal(XYwe_open,2,(1 + XYweuishxta_1_5)) 
    local real XYweuishxta_2_1 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_3,(1 + XYweuishxta_1_5)) 
    local real XYweuishxta_2_2 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_3,(2 + XYweuishxta_1_5))
    local real XYweuishxta_2_3 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_3,(3 + XYweuishxta_1_5))
    local real XYweuishxta_2_4 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_3,(4 + XYweuishxta_1_5))
    local real XYweuishxta_2_5 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(5 + XYweuishxta_1_5))
    local real XYweuishxta_2_6 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(6 + XYweuishxta_1_5))
    local real XYweuishxta_2_7 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(7 + XYweuishxta_1_5))
    local real XYweuishxta_2_8 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(8 + XYweuishxta_1_5))
    local real XYweuishxta_2_9 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(9 + XYweuishxta_1_5))
    local real XYweuishxta_2_10 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(10 + XYweuishxta_1_5))
    local real XYweuishxta_2_11 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(11 + XYweuishxta_1_5))
    local real XYweuishxta_3_1 = ((XYweuishxta_2_1 - XYweuishxta_2_5) - ((XYweuishxta_2_1 * XYweuishxta_2_6)/100.00))
    local real XYweuishxta_3_2 
    local real XYweuishxta_3_3
    local real XYweuishxta_3_4  
    local real XYweuishxta_3_5  
    local real XYweuishxta_3_6  
    local real XYweuishxta_2_12 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(12 + XYweuishxta_1_5))
    local real XYweuishxta_2_13 = LoadReal(XYwe_hxb_sh,XYweuishxta_1_4,(13 + XYweuishxta_1_5))
    local real XYweuishxta_2_14
    
    call SaveInteger(XYwe_hxb_shys,XYweuishxta_1_1,XYweuishxta_1_5,XYweuishxta10)
    if (XYweuishxta7 == true) then  
        if ( XYweuishxta_2_9 <= 0.00 ) then
            set XYweuishxta_3_3 = (((XYweuishxta5* (100.00 + XYweuishxta_2_11))/100.00) + XYweuishxta_2_13) 
            set XYweuishxta_3_2 = (XYweuishxta_2_2 +((XYweuishxta_3_3 * XYweuishxta_2_3)/100.00))  
        else
            if  (( XYweuishxta_2_9 > 0.00 ) and ( XYweuishxta_2_9 < 100.00 )) then
                if ( GetRandomReal(0.00, 100.00) <= XYweuishxta_2_9 ) then
                    set XYweuishxta_3_3 = ((((((XYweuishxta5 * (100.00 + XYweuishxta_2_8))/100.00) + XYweuishxta_2_7) * (100.00 + XYweuishxta_2_11))/100.00) + XYweuishxta_2_13)
                    set XYweuishxta_3_2 = (XYweuishxta_2_2 +((XYweuishxta_3_3 * XYweuishxta_2_3)/100.00))
                else
                    set XYweuishxta_3_3 = (((XYweuishxta5* (100.00 + XYweuishxta_2_11))/100.00) + XYweuishxta_2_13) 
                    set XYweuishxta_3_2 = (XYweuishxta_2_2 +((XYweuishxta_3_3 * XYweuishxta_2_3)/100.00))
                endif
            else
                if ( XYweuishxta_2_9 >= 100.0 ) then
                    set XYweuishxta_3_3 = ((((((XYweuishxta5 * (100.00 + XYweuishxta_2_8))/100.00) + XYweuishxta_2_7) * (100.00 + XYweuishxta_2_11))/100.00) + XYweuishxta_2_13)
                    set XYweuishxta_3_2 = (XYweuishxta_2_2 +((XYweuishxta_3_3 * XYweuishxta_2_3)/100.00))
                endif
            endif
        endif
    else
        set XYweuishxta_3_3 = (((XYweuishxta5* (100.00 + XYweuishxta_2_11))/100.00) + XYweuishxta_2_13) 
        set XYweuishxta_3_2 = (XYweuishxta_2_2 +((XYweuishxta_3_3 * XYweuishxta_2_3)/100.00))
    endif

    if (XYweuishxta_3_2 >= XYweuishxta_3_3) then 
        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,0.00,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
    else
        set XYweuishxta_3_4 = (XYweuishxta_3_3 - XYweuishxta_3_2) 
        if (XYweuishxta_2_4 >= XYweuishxta_3_4) then 
            call UnitDamageTarget(XYweuishxta1,XYweuishxta2,0.00,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
            call SaveReal(XYwe_hxb_sh,XYweuishxta_1_2,(4 + XYweuishxta_1_5),(XYweuishxta_2_4 - XYweuishxta_3_4))
        else
            if (XYweuishxta_2_4 > 0) then
                call SaveReal(XYwe_hxb_sh,XYweuishxta_1_2,(4 + XYweuishxta_1_5),0.00)
                set XYweuishxta_3_5 = (XYweuishxta_3_4 - XYweuishxta_2_4)  
                if (XYweuishxta6 == true) then 
                    if (XYweuishxta_3_1 < 0) then
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00+(2.00 - Pow((1.00 - XYweuishxta_2_0 ),XYweuishxta_3_1))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_MAGIC,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    else
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00-((XYweuishxta_2_0 * XYweuishxta_2_1) / ( (XYweuishxta_2_0 * XYweuishxta_2_1) + 1.00))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_MAGIC,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    endif
                else
                    if (XYweuishxta_3_1 < 0) then
                        set XYweuishxta_3_1 = 0.00
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00 - ((XYweuishxta_2_0 * XYweuishxta_3_1) / ((XYweuishxta_2_0 * XYweuishxta_3_1) + 1.00))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_MAGIC,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    else
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00 - ((XYweuishxta_2_0 * XYweuishxta_3_1) / ((XYweuishxta_2_0 * XYweuishxta_3_1) + 1.00))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_MAGIC,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    endif
                endif
            else
                set XYweuishxta_3_5 = XYweuishxta_3_4
                if (XYweuishxta6 == true) then 
                    if (XYweuishxta_3_1 < 0) then
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00+(2.00 - Pow((1.00 - XYweuishxta_2_0 ),XYweuishxta_3_1))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_MAGIC,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    else
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00-((XYweuishxta_2_0 * XYweuishxta_2_1) / ( (XYweuishxta_2_0 * XYweuishxta_2_1) + 1.00))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_MAGIC,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    endif
                else
                    if (XYweuishxta_3_1 < 0) then
                        set XYweuishxta_3_1 = 0.00
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00 - ((XYweuishxta_2_0 * XYweuishxta_3_1) / ((XYweuishxta_2_0 * XYweuishxta_3_1) + 1.00))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_MAGIC,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    else
                        set XYweuishxta_3_6 = (XYweuishxta_3_5 * (1.00 - ((XYweuishxta_2_0 * XYweuishxta_3_1) / ((XYweuishxta_2_0 * XYweuishxta_3_1) + 1.00))))
                        call UnitDamageTarget(XYweuishxta1,XYweuishxta2,XYweuishxta_3_6,false,false,ATTACK_TYPE_MAGIC,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
                        if (XYweuishxta8 != null) then
                            set XYweuishxta_2_14 = (((XYweuishxta_3_6 * XYweuishxta_2_10)/100.00) + XYweuishxta_2_12)
                            call SetUnitLifeBJ(XYweuishxta8,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuishxta8)+ XYweuishxta_2_14))
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuishxta_2_14) + "|r")),XYweuishxta8, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    endif
                endif
            endif
        endif
    endif
    call SaveInteger(XYwe_hxb_shys,XYweuishxta_1_1,XYweuishxta_1_5,(XYweuishxta10 + 1))
    call XYweuiOpenAll2()
endfunction

function XYweuishxti takes unit XYweui0 returns nothing
    local integer XYweui_0 = GetHandleId(XYweui0)
    call FlushChildHashtable(XYwe_hxb_sh,XYweui_0)
    call FlushChildHashtable(XYwe_hxb_shys,XYweui_0)
endfunction

endlibrary

#endif /// XYweuishxtIncluded
