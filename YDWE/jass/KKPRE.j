#ifndef KKPREINCLUDE
#define KKPREINCLUDE


library LBKKPRE

   
    native DzSetUnitAbilityArt takes unit u, integer abil_id, string art_path returns boolean
    native DzGetUnitAbilityArt takes unit u, integer abil_id returns string
    native DzSetUnitAbilityTip takes unit u, integer abil_id, string tip returns boolean
    native DzGetUnitAbilityTip takes unit u, integer abil_id returns string
    native DzSetUnitAbilityUberTip takes unit u, integer abil_id, string ubertip returns boolean
    native DzGetUnitAbilityUberTip takes unit u, integer abil_id returns string
    native DzSetUnitAbilityUpdate takes unit u, integer abil_id returns boolean 
    native DzSetUnitAbilityOrderId takes unit u, integer abil_id, integer order_id returns boolean
    native DzGetUnitAbilityOrderId takes unit u, integer abil_id returns integer
    native DzSetUnitAbilitySpellBookList takes unit u, integer abil_id, string abil_list, boolean save_cooldown returns boolean 
    native DzGetUnitAbilitySpellBookList takes unit u, integer abil_id returns string 
    native DzSetUnitAbilityMissileArt takes unit u, integer abil_id, string missile_art returns boolean
    native DzGetUnitAbilityMissileArt takes unit u, integer abil_id returns string
    native DzSetUnitAbilityMissileSpeed takes unit u, integer abil_id, real missile_speed returns boolean
    native DzGetUnitAbilityMissileSpeed takes unit u, integer abil_id returns real
    native DzSetUnitAbilityMissileArc takes unit u, integer abil_id, real missile_arc returns boolean
    native DzGetUnitAbilityMissileArc takes unit u, integer abil_id returns real
    native DzSetUnitAbilityMissileHoming takes unit u, integer abil_id, boolean missile_homing returns boolean
    native DzGetUnitAbilityMissileHoming takes unit u, integer abil_id returns boolean
    native DzSetUnitAbilityMissileCount takes unit u, integer abil_id, integer missile_count returns boolean
    native DzGetUnitAbilityMissileCount takes unit u, integer abil_id returns integer
    native DzSetUnitAbilityMissileDamage takes unit u, integer abil_id, real damage, real max_damage, attacktype atktp, damagetype dmgtp returns boolean
    native DzGetUnitAbilityMissileDamage takes unit u, integer abil_id returns real
    native DzGetUnitAbilityMissileMaxDamage takes unit u, integer abil_id returns real
    

endlibrary

#endif

