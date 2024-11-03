#ifndef XYwembhbkgmIncluded
#define XYwembhbkgmIncluded

#include "XYwebase.j"

library XYwembhbkgm requires XYwebase

function XYwembhbkgmb takes nothing returns nothing
    local item XYwembhbkgmb_wp_1
    local integer XYwembhbkgmb_xh_1
    local integer XYwembhbkgmb_xh_2
    if (GetItemType(GetManipulatedItem()) == ITEM_TYPE_PURCHASABLE) then
        set XYwembhbkgmb_xh_1 = 1
        set XYwembhbkgmb_xh_2 = 6
        loop
            exitwhen XYwembhbkgmb_xh_1 > XYwembhbkgmb_xh_2
            set XYwembhbkgmb_wp_1 = UnitItemInSlotBJ(GetManipulatingUnit(), XYwembhbkgmb_xh_1)
            if ((GetItemTypeId(XYwembhbkgmb_wp_1) == GetItemTypeId(GetManipulatedItem())) and (XYwembhbkgmb_wp_1 != GetManipulatedItem())) then
                call SetItemCharges(XYwembhbkgmb_wp_1, ( GetItemCharges(XYwembhbkgmb_wp_1) + GetItemCharges(GetManipulatedItem()) ) )
                call RemoveItem( GetManipulatedItem() )
            endif
            set XYwembhbkgmb_xh_1 = XYwembhbkgmb_xh_1 + 1
        endloop
    endif
endfunction

function XYwembhbkgma takes nothing returns nothing
    local trigger XYwembhbkgma_fcq_1 = CreateTrigger()
    call XYweuiOpenAll2()
    call TriggerRegisterAnyUnitEventBJ(XYwembhbkgma_fcq_1, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddAction(XYwembhbkgma_fcq_1,function XYwembhbkgmb)
    
    set XYwembhbkgma_fcq_1 = null 
endfunction

function XYwembhbkgmd takes nothing returns nothing
    local item XYwembhbkgmd_wp_1
    local integer XYwembhbkgmd_xh_1
    local integer XYwembhbkgmd_xh_2
    if (GetItemType(GetManipulatedItem()) == ITEM_TYPE_CHARGED) then
        set XYwembhbkgmd_xh_1 = 1
        set XYwembhbkgmd_xh_2 = 6
        loop
            exitwhen XYwembhbkgmd_xh_1 > XYwembhbkgmd_xh_2
            set XYwembhbkgmd_wp_1 = UnitItemInSlotBJ(GetManipulatingUnit(), XYwembhbkgmd_xh_1)
            if ((GetItemTypeId(XYwembhbkgmd_wp_1) == GetItemTypeId(GetManipulatedItem())) and (XYwembhbkgmd_wp_1 != GetManipulatedItem())) then
                call SetItemCharges(XYwembhbkgmd_wp_1, ( GetItemCharges(XYwembhbkgmd_wp_1) + GetItemCharges(GetManipulatedItem()) ) )
                call RemoveItem( GetManipulatedItem() )
            endif
            set XYwembhbkgmd_xh_1 = XYwembhbkgmd_xh_1 + 1
        endloop
    endif
endfunction

function XYwembhbkgmc takes nothing returns nothing
    local trigger XYwembhbkgmc_fcq_1 = CreateTrigger()
    call XYweuiOpenAll2()
    call TriggerRegisterAnyUnitEventBJ(XYwembhbkgmc_fcq_1, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddAction(XYwembhbkgmc_fcq_1,function XYwembhbkgmd)
    
    set XYwembhbkgmc_fcq_1 = null 
endfunction

endlibrary

#endif /// XYwembhbkgmIncluded
