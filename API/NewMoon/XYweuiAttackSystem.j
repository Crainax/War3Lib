#ifndef XYweuiAttackSystemIncluded
#define XYweuiAttackSystemIncluded

library XYweuiAttackSystem
//! external ObjectMerger w3a AIsr AtkS anam " Îï¹¥²¶×½¸¨Öú" isr2 1 2.00  |
    
    globals
        trigger UnitEnterMap = null
        trigger UnitDamaged = null
        hashtable HT = null
        boolean RealDamage = true
    endglobals

    //Begin to reset the damage.
    //If the damage can kill the one,slay it immediately for exp;
    //If not,reset the hp for the one
    function UnitDamage takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer pk = GetHandleId(t)
        local unit u1 = LoadUnitHandle( HT, pk, 0)
        local unit u2  = LoadUnitHandle( HT, pk, 1)
        local player p = GetOwningPlayer(u1)
        local real value = LoadReal( HT,pk,2)
        local integer i = 0
        if value >= GetUnitState( u1, UNIT_STATE_LIFE) then
            call SetUnitState(u1,UNIT_STATE_LIFE, 1.0)
            call UnitRemoveAbility( u1,'AtkS')
            set RealDamage = false
            //Different maps have different settings,we need to try every single type to confirm that it will be slayed.
            loop
                call UnitDamageTarget(u2,u1, 100000000.00, false, false, ConvertAttackType(i), DAMAGE_TYPE_UNIVERSAL, WEAPON_TYPE_WHOKNOWS )
                set i = i + 1
                exitwhen i == 7
            endloop
            set RealDamage = true
            call UnitAddAbility( u1, 'AtkS' )
        else
            call SetUnitState(u1,UNIT_STATE_LIFE, GetUnitState(u1,UNIT_STATE_LIFE) - value)
        endif
        call FlushChildHashtable(HT,pk)
        call DestroyTimer(t)
        set u1 = null
        set u2 = null
        set t = null
    endfunction

    function UnitDamagedAction takes nothing returns nothing
        local real value = GetEventDamage()
        local unit u1 = GetTriggerUnit()
        local unit u2 = GetEventDamageSource()
        local real minus = GetUnitState(u1, UNIT_STATE_MAX_LIFE) - GetUnitState(u1, UNIT_STATE_LIFE)
        local timer t = null
        local integer pk = 0
        local real rate = 1.00-LoadReal(HT,GetHandleId(u1),0)
        //Reset the value of damage in 0 second
        if value < 0.0 then
            set value = -value
            if value <= minus then
                set value = (1 + rate)*value
            else
                set value = minus + value*rate
            endif
            set t = CreateTimer()
            set pk = GetHandleId(t)
            call SaveUnitHandle(HT,pk,0,u1)
            call SaveUnitHandle(HT,pk,1,u2)
            call SaveReal(HT,pk,2,value)
            call TimerStart( t, 0.00,false,function UnitDamage)
            set t = null
        endif
        set u1 = null
        set u2 = null
    endfunction

    //To register the units placed in the map
    function AnyUnitDamagedFilter takes nothing returns boolean
        local unit u = GetFilterUnit()
        if GetUnitAbilityLevel( u, 'Aloc') == 0 then
            call TriggerRegisterUnitEvent(UnitDamaged, u, EVENT_UNIT_DAMAGED)
            call UnitAddAbility( u, 'AtkS' )
            call UnitMakeAbilityPermanent( u, true, 'AtkS' )
        endif
        set u = null
    return false
    endfunction

    function XYweuiAttackSystemInit takes nothing returns nothing
        //When a unit enter the map,register a event for damage
        local region rectRegion = CreateRegion()
        local group g = CreateGroup()
        local rect r = GetWorldBounds()
        
        set UnitDamaged = CreateTrigger()//For units getting damage
        call TriggerAddCondition(UnitDamaged,Condition(function UnitDamagedAction))
        
        call GroupEnumUnitsInRect(g, r, Condition(function AnyUnitDamagedFilter))
        call DestroyGroup(g)
        set g = null
        
        set UnitEnterMap = CreateTrigger()//For units entering map        
        call RegionAddRect(rectRegion, r)
        call TriggerRegisterEnterRegion(UnitEnterMap, rectRegion, Condition(function AnyUnitDamagedFilter))
        set r = null

        set HT = InitHashtable()
    endfunction
//================================================================================
    //API
    //To distinguish the type of damage
    function IsPhysicalAttack takes nothing returns boolean
        return GetEventDamage() > 0
    endfunction
    
    function IsRealDamage takes nothing returns boolean
        local boolean XYweui0 = RealDamage
        
        return XYweui0
    endfunction

    //To set the rate of magical defence for a unit
    function SetUnitMagicalDefence takes unit u,real rate returns nothing
        call SaveReal(HT,GetHandleId(u),0, rate )
    endfunction
//================================================================================
    //Redefine the function of getting damage value
    function GetEventDamageEx takes nothing returns real
        local real damage = GetEventDamage()
        if damage >= 0 then
            return damage
        else
            return -damage*(1.00-LoadReal(HT,GetHandleId(GetTriggerUnit()),0))
        endif
    endfunction
    #define GetEventDamage GetEventDamageEx

    function InitBlizzardEx takes nothing returns nothing
        call InitBlizzard()
        call XYweuiAttackSystemInit()
    endfunction
    #define InitBlizzard InitBlizzardEx
    //Use Define instead of using Initializer so as to confirm it will be initializered before any other systems
    
    endlibrary

#endif /// XYweuiAttackSystemIncluded
