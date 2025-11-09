#ifndef KKPREINCLUDE
#define KKPREINCLUDE


library LBKKPRE

    
    native DzEnableDrawSkillPanel takes unit u, boolean is_enable returns nothing 
    native DzEnableDrawSkillPanelByPlayer takes player p, boolean is_enable returns nothing 
    native DzSetEffectFogVisible takes effect eff, boolean is_visible returns nothing 
    native DzSetEffectMaskVisible takes effect eff, boolean is_visible returns nothing 

    native DzFrameBindWidget takes integer frame, widget u, real world_x, real world_y, real world_z, real screen_x, real screen_y, boolean fog_visible, boolean unit_visible, boolean dead_visible returns nothing 
    native DzFrameBindWorldPos takes integer frame, real world_x, real world_y, real world_z, real screen_x, real screen_y, boolean fog_visible returns nothing
    native DzFrameUnBind takes integer frame returns nothing 

    function KKFrameBindItem takes integer frame, widget u, real world_x, real world_y, real world_z, real screen_x, real screen_y, boolean fog_visible, boolean item_visible returns nothing 
        call DzFrameBindWidget(frame, u, world_x, world_y, world_z, screen_x, screen_y, fog_visible, item_visible, false)
    endfunction

    native DzDisableUnitPreselectUi takes nothing returns nothing
    native DzDisableItemPreselectUi takes nothing returns nothing
    native DzFrameGetLowerLevelFrame takes nothing returns integer 
    native DzFrameSetCheckBoxState takes integer check_box_frame, boolean checked returns nothing
    native DzFrameGetCheckBoxState takes integer check_box_frame returns boolean
    native DzFrameIsFocus takes integer frame returns boolean 
    native DzFrameSetEditBoxActive takes integer frame, boolean is_active returns nothing 
    native DzFrameSetEditBoxDisableIme takes integer frame, boolean is_disable returns nothing 

    native DzIsWindowMode takes nothing returns boolean 
    native DzIsWindowActive takes nothing returns boolean
    native DzWindowSetPoint takes integer x, integer y returns nothing 
    native DzWindowSetSize takes integer width, integer height returns nothing 
    native DzGetSystemMetricsWidth takes nothing returns integer 
    native DzGetSystemMetricsHeight takes nothing returns integer 

    native DzGetDoodadsCount takes nothing returns integer 
    native DzSetDoodadsMatScale takes integer doodads_index, real x, real y, real z returns nothing 
    native DzSetDoodadsMatRotateX takes integer doodads_index, real x returns nothing 
    native DzSetDoodadsMatRotateY takes integer doodads_index, real y returns nothing 
    native DzSetDoodadsMatRotateZ takes integer doodads_index, real z returns nothing 
    native DzSetDoodadsMatReset takes integer doodads_index returns nothing 
endlibrary

#endif

