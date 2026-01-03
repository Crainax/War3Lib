#ifndef KKPREINCLUDE
#define KKPREINCLUDE


library LBKKPRE



    native DzSendKeyboard takes player p, integer key_code, integer is_down returns nothing
    native DzForceUiKeyboard takes player p, integer key_code, integer is_down returns nothing
    native DzDisableWindowKeyboard takes player p, integer key_code returns nothing 
    native DzDisableGameUIKeyboard takes player p, integer key_code returns nothing 
    native DzUnitCanPlaceAround takes widget obj, real x, real y returns boolean 

    function KKUnitCanPlaceAroundLoc takes widget obj, location loc returns boolean 
        return DzUnitCanPlaceAround(obj, GetLocationX(loc), GetLocationY(loc))
    endfunction     

    function kkUnitCanPlaceAroundItem takes widget obj, real x, real y returns boolean
        return DzUnitCanPlaceAround(obj, x, y)
    endfunction 

    function KKUnitCanPlaceAroundLocItem takes widget obj, location loc returns boolean
        return DzUnitCanPlaceAround(obj, GetLocationX(loc), GetLocationY(loc))
    endfunction 

    native DzPositionCanPlaceAround takes real x, real y, real collision_size, integer collision_type returns boolean 

    function KKPositionCanPlaceAroundLoc takes location loc, real collision_size, integer collision_type returns boolean 
        return DzPositionCanPlaceAround(GetLocationX(loc), GetLocationY(loc), collision_size, collision_type)
    endfunction 

    native DzGetTerrainZ takes real x, real y returns real 
    native DzGetUnitZ takes unit u returns real 
    native DzGetUnitOverheadOffset takes widget u returns real

    native DzFrameSetModelEnableWideScreen takes integer frame, boolean is_enable returns nothing 

    native DzSetUnitAbilityEnable takes unit u, integer abil_id returns boolean
    native DzSetUnitAbilityDisable takes unit u, integer abil_id returns boolean
    native DzGetUnitAbilityIsDisabled takes unit u, integer abil_id returns boolean
    native DzGetUnitAbilityDisabledCount takes unit u, integer abil_id returns integer
    native DzSetUnitAbilityTechReach takes unit u, integer abil_id, boolean reach returns boolean
    native DzGetUnitAbilityTechReach takes unit u, integer abil_id returns boolean
    native DzSetUnitAbilityTechReachTip takes unit u, integer abil_id, string tip returns boolean 

    native DzAsyncGetCurrentBuildingAbilityId takes nothing returns integer 
    native DzAsyncGetCurrentBuildingUnitId takes nothing returns integer 
    native DzFrameUnlockMouseRectLimit takes boolean is_unlock returns nothing 
    native KKSimpleFrameIsVisible takes integer simple_frame returns boolean
    native DzFrameGetChatEditBar takes nothing returns integer

    native DzGetLocalChatRecipient takes nothing returns integer 
    native DzPlayerSendChat takes player p, string msg, integer recipient returns nothing 

endlibrary

#endif

