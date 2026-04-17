#ifndef KKPREINCLUDE
#define KKPREINCLUDE


library LBKKPRE


    native DzGetUnitPojectileLaunchX takes unit u returns real
    native DzGetUnitPojectileLaunchY takes unit u returns real
    native DzGetUnitPojectileLaunchZ takes unit u returns real

    native DzLaunchMissile takes unit source, widget target, string model, integer team_color, integer color, real x, real y, real z, real scale, real speed, attacktype attack_type, damagetype damage_type, weapontype weapon_type, real damage, real arc, boolean homing, boolean can_miss, boolean never_miss, boolean attack, integer flags returns boolean
    native DzLaunchMissileBounce takes unit source, widget target, string model, integer team_color, integer color, real x, real y, real z, real scale, real speed, attacktype attack_type, damagetype damage_type, weapontype weapon_type, real damage, real arc, boolean homing, boolean can_miss, boolean never_miss, boolean attack, integer flags, integer target_flags, integer target_count, real bounce_range, real damage_loss returns boolean
    native DzLaunchMissileLine takes unit source, widget target, string model, integer team_color, integer color, real x, real y, real z, real scale, real speed, attacktype attack_type, damagetype damage_type, weapontype weapon_type, real damage, real arc, boolean homing, boolean can_miss, boolean never_miss, boolean attack, integer flags, integer target_flags, real damage_loss, real distance, real range returns boolean
    native DzLaunchMissileSplash takes unit source, widget target, string model, integer team_color, integer color, real x, real y, real z, real scale, real speed, attacktype attack_type, damagetype damage_type, weapontype weapon_type, real damage, real arc, boolean homing, boolean can_miss, boolean never_miss, boolean attack, integer flags, integer target_flags, real half_factor, real quar_factor, real full_area, real half_area, real quar_area returns boolean
    native DzLaunchArtillery takes unit source, widget target, real target_x, real target_y, string model, integer team_color, integer color, real x, real y, real z, real scale, real speed, attacktype attack_type, damagetype damage_type, weapontype weapon_type, real damage, real arc, boolean attack, integer flags, real min_distance, integer target_flags, real half_factor, real quar_factor, real full_area, real half_area, real quar_area returns boolean
    native DzLaunchArtilleryLine takes unit source, widget target, real target_x, real target_y, string model, integer team_color, integer color, real x, real y, real z, real scale, real speed, attacktype attack_type, damagetype damage_type, weapontype weapon_type, real damage, real arc, boolean attack, integer flags, real min_distance, integer target_flags, real half_factor, real quar_factor, real full_area, real half_area, real quar_area, real damage_loss, real distance, real range returns boolean
    native DzLaunchMissileCarrionSwarmEx takes unit source, string model, integer team_color, integer color, real x, real y, real z, real facing, real distance, real scale, real speed, attacktype attack_type, damagetype damage_type, weapontype weapon_type, real damage, integer flags, integer target_flags, real start_radius, real end_radius, real max_damage, integer buffID returns boolean
    
    native DzKillUnit takes unit whichUnit, unit killer returns boolean
    native DzSetUnitXY takes unit whichUnit, real x, real y returns boolean
    native DzSetUnitAbilityEngineeringUpgrade takes unit whichUnit, integer old_id, integer new_id, boolean update_hero_ability returns boolean 
    native DzSetUnitAbilityEngineeringUpgradeCancel takes unit whichUnit, integer old_id returns boolean 
    native DzGetUnitAbilityEngineeringUpgradeNewId takes unit whichUnit, integer old_id returns integer 
    native DzGetUnitAbilityEngineeringUpgradeOldId takes unit whichUnit, integer new_id returns integer 


    native DzSetUnitAbilityCastTime takes unit u, integer abil_id, real value returns boolean 
    native DzGetUnitAbilityCastTime takes unit u, integer abil_id returns real 
    native DzSetUnitAbilityDuration takes unit u, integer abil_id, real value returns boolean 
    native DzGetUnitAbilityDuration takes unit u, integer abil_id returns real 
    native DzSetUnitAbilityHeroDuration takes unit u, integer abil_id, real value returns boolean 
    native DzGetUnitAbilityHeroDuration takes unit u, integer abil_id returns real 
    native DzSetUnitAbilityCastPoint takes unit u, integer abil_id, real value returns boolean 
    native DzGetUnitAbilityCastPoint takes unit u, integer abil_id returns real 
    native DzSetUnitAbilityBackSwing takes unit u, integer abil_id, real value returns boolean 
    native DzGetUnitAbilityBackSwing takes unit u, integer abil_id returns real 


    native DzSetUnitLifeRegen takes unit whichUnit, real regen returns boolean
    native DzGetUnitLifeRegen takes unit whichUnit returns real
    native DzSetUnitManaRegen takes unit whichUnit, real regen returns boolean
    native DzGetUnitManaRegen takes unit whichUnit returns real
    native DzSetUnitMinSpeed takes unit whichUnit, real speed, boolean ignore_polymorph returns boolean
    native DzGetUnitMinSpeed takes unit whichUnit returns real
    native DzSetUnitMaxSpeed takes unit whichUnit, real speed, boolean ignore_polymorph returns boolean
    native DzGetUnitMaxSpeed takes unit whichUnit returns real
    native DzSetUnitCastPoint takes unit whichUnit, real cast_point returns boolean
    native DzGetUnitCastPoint takes unit whichUnit returns real
    native DzSetUnitBackSwing takes unit whichUnit, real back_swing returns boolean
    native DzGetUnitBackSwing takes unit whichUnit returns real
    native DzSetUnitAttackTargetCount takes unit whichUnit, integer index, integer target_count returns boolean
    native DzGetUnitAttackTargetCount takes unit whichUnit, integer index returns integer
    native DzSetHeroPrimaryAttributeType takes unit whichUnit, integer attribute, boolean keep_primary_bonus returns boolean
    native DzGetHeroPrimaryAttributeType takes unit whichUnit returns integer
    native DzSetHeroPrimaryAttribute takes unit whichUnit, integer attribute returns boolean
    native DzGetHeroPrimaryAttribute takes unit whichUnit, boolean include_bonus returns integer
    native DzSetHeroPrimaryAttributePlus takes unit whichUnit, integer attreibute, real value, boolean keep_current_bonus returns boolean
    native DzGetHeroPrimaryAttributePlus takes unit whichUnit, integer attribute returns real
    native DzDisableAttackSpeedLimit takes nothing returns nothing
    native DzSetMinMaxAttackSpeedFactor takes real min_factor, real max_factor returns nothing
    native DzSetMoveSpeedBonusesStack takes boolean is_enable returns nothing
    native DzSetGlobalUnitMinMaxMoveSpeed takes real building_min, real building_max, real unit_min, real unit_max, real GC_building_min, real GC_building_max, real GC_unit_min, real GC_unit_max, real harvest_min, real windwalk_max returns nothing
    
endlibrary

#endif

