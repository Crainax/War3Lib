#ifndef KKPREINCLUDE
#define KKPREINCLUDE


library LBKKPRE

    native DzSetUnitInventorySize                  takes unit whichUnit, integer size returns boolean

    native DzUnitAddBuffBHcaV2                      takes unit target, unit source, integer buffId, integer level, integer priority, real duration, real damage, real moveSpeed, real attackSpeed, integer stackType returns boolean
    native DzUnitAddBuffBcri                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, real moveSpeed, real attackSpeed, real attackReduce returns boolean
    native DzUnitAddBuffBcy2                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration returns boolean
    native DzUnitAddBuffBcyc                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration returns boolean
    native DzUnitAddBuffBroa                        takes unit target, integer buffId, integer level, integer priority, real duration, real attack, real armor, real lifeRegen, real manaRegen returns boolean
    native DzUnitAddBuffBNbr                        takes unit target, integer buffId, integer level, integer priority, real duration, real attack, real armor, real lifeRegen, real manaRegen returns boolean
    native DzUnitAddBuffBEst                        takes unit target, integer buffId, integer level, integer priority, real duration returns boolean
    native DzUnitAddBuffBEsh                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, real damage, real interval, real moveSpeed, real attackSpeed, real decay returns boolean
    native DzUnitAddBuffBNsi                        takes unit target, integer buffId, integer level, integer priority, real duration, real moveSpeed, real attackSpeed, integer disableType, real missChance returns boolean
    native DzUnitAddBuffBUsl                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration returns boolean
    native DzUnitAddBuffBUsp                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration returns boolean
    native DzUnitAddBuffBNdc                        takes unit target, unit source, integer buffId, integer level, integer priority, integer unitId returns boolean
    native DzUnitAddBuffBslo                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, real moveSpeed, real attackSpeed returns boolean
    native DzUnitAddBuffBspe                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, real moveSpeed, real attackSpeed returns boolean
    native DzUnitAddBuffBNss                        takes unit target, integer buffId, integer level, integer priority, real duration returns boolean
    native DzUnitAddBuffBspl                        takes unit target, integer buffId, integer level, integer priority, real duration, real damageShare returns boolean
    native DzUnitAddBuffBEsv                        takes unit target, integer buffId, integer level, integer priority, real duration returns boolean
    native DzUnitAddBuffBvng                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration returns boolean
    native DzUnitAddBuffBOsf                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration returns boolean
    native DzUnitAddBuffBIsh                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration returns boolean
    native DzUnitAddBuffBstt                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration returns boolean
    native DzUnitAddBuffBBAR                        takes unit target, integer buffId, integer level, integer priority, real duration returns boolean
    native DzUnitAddBuffBsha                        takes unit target, integer buffId, integer level, integer priority, real duration, player owner, integer detectionType returns boolean
    native DzUnitAddBuffBdvv                        takes unit target, integer buffId, integer level, integer priority, real duration, player owner, integer detectionType returns boolean
    native DzUnitAddBuffBbar2                       takes unit target, integer buffId, integer level, integer priority, real duration, real armor returns boolean
    native DzUnitAddBuffBprv                        takes unit target, integer buffId, integer level, integer priority, real duration, integer playerMask returns boolean
    native DzUnitAddBuffBHav                        takes unit target, integer buffId, integer level, integer priority, real duration, real armor, real life, integer attack, real magicReduce returns boolean
    native DzUnitAddBuffBrpl                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration returns boolean
    native DzUnitAddBuffBrpm                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration returns boolean
    native DzUnitAddBuffBoar                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, integer percentage, real regen returns boolean
    native DzUnitAddBuffBarm                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, integer percentage, real regen returns boolean
    native DzUnitAddBuffBabr                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, integer percentage, real regen returns boolean
    native DzUnitAddBuffBHab                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, integer percentage, real regen returns boolean
    native DzUnitAddBuffBOac                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, integer melee, integer ranged, integer percentage, real attack returns boolean
    native DzUnitAddBuffBakb                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, integer melee, integer ranged, integer percentage, real attack returns boolean
    native DzUnitAddBuffBEar                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, integer melee, integer ranged, integer percentage, real attack returns boolean
    native DzUnitAddBuffBHad                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, integer percentage, real armor returns boolean
    native DzUnitAddBuffBOae                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, real moveSpeed, real attackSpeed returns boolean
    native DzUnitAddBuffBasl                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, real moveSpeed, real attackSpeed returns boolean
    native DzUnitAddBuffBEah                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, real reflected, integer percentage returns boolean
    native DzUnitAddBuffBUau                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, integer percentage, real moveSpeed, real lifeRegen returns boolean
    native DzUnitAddBuffBUav                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, real lifeSteal returns boolean
    native DzUnitAddBuffBNtm                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, player owner, real gold, real lumber, integer bonus returns boolean
    native DzUnitAddBuffBHbd                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, real damage returns boolean
    native DzUnitAddBuffBpxf                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, real damage returns boolean
    native DzUnitAddBuffBapl                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, real damage returns boolean
    native DzUnitAddBuffBchd                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, real moveUpdates, real attackUpdates, real unitParalyze, real heroParalyze returns boolean
    native DzUnitAddBuffBdbb                        takes unit target, integer buffId, integer level, integer priority, real duration, real lifeLimit, real manaLimit, real lifeDecay, real manaDecay, real lifeOffset, real manaOffset, integer lifePercentage, integer manaPercentage, real lifeBonus, real manaBonus returns boolean
    native DzUnitAddBuffBdbl                        takes unit target, integer buffId, integer level, integer priority, real duration, real lifeLimit, real manaLimit, real lifeDecay, real manaDecay, real lifeOffset, real manaOffset, integer lifePercentage, integer manaPercentage, real lifeBonus, real manaBonus returns boolean
    native DzUnitAddBuffBdbm                        takes unit target, integer buffId, integer level, integer priority, real duration, real lifeLimit, real manaLimit, real lifeDecay, real manaDecay, real lifeOffset, real manaOffset, integer lifePercentage, integer manaPercentage, real lifeBonus, real manaBonus returns boolean
    native DzUnitAddBuffBcrs                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, real missChance returns boolean
    native DzUnitAddBuffBHca                        takes unit target, unit source, integer buffId, integer level, integer priority, real duration, real moveSpeed, real attackSpeed, integer stackType returns boolean

    native DzCommandBarResize                       takes integer row, integer col returns nothing
    native DzGetCommandBarButton                    takes integer x, integer y returns integer
    native DzConvertForce2PlayerIdMark              takes force whichForce returns integer

    native DzTriggerRegisterPlayerUnitBuffAcquireEvent takes trigger whichTrigger, player whichPlayer returns event
    native DzTriggerRegisterPlayerUnitBuffLoseEvent    takes trigger whichTrigger, player whichPlayer returns event
    native DzGetTriggerBuffId                       takes nothing returns integer
    native DzGetTriggerBuffLevel                    takes nothing returns integer
    native DzGetTriggerBuffUnit                     takes nothing returns unit

    native DzSetItemArt takes item whichItem, string art returns boolean
    native DzGetItemArt takes item whichItem returns string
    native DzSetItemTip takes item whichItem, string tip returns boolean
    native DzGetItemTip takes item whichItem returns string
    native DzSetItemUberTip takes item whichItem, string ubertip returns boolean
    native DzGetItemUberTip takes item whichItem returns string
    native DzSetItemUpdate takes item whichItem returns nothing
    native DzSetItemAbilityRange takes item whichItem, integer slot_index, real range returns boolean
    native DzGetItemAbilityRange takes item whichItem, integer slot_index returns real
    native DzSetItemAbilityArea takes item whichItem, integer slot_index, real area returns boolean
    native DzGetItemAbilityArea takes item whichItem, integer slot_index returns real
    native DzSetItemAbilityCool takes item whichItem, integer slot_index, real cool, real max_cool returns boolean
    native DzGetItemAbilityCool takes item whichItem, integer slot_index returns real
    native DzGetItemAbilityMaxCool takes item whichItem, integer slot_index returns real
    native DzSetItemAbilityTargs takes item whichItem, integer slot_index, integer target_flags returns boolean
    native DzGetItemAbilityTargs takes item whichItem, integer slot_index returns integer
    native DzSetItemAbilityCost takes item whichItem, integer slot_index, integer cost returns boolean
    native DzGetItemAbilityCost takes item whichItem, integer slot_index returns integer
    native DzSetItemAbilityReqLevel takes item whichItem, integer slot_index, integer required_level returns boolean
    native DzGetItemAbilityReqLevel takes item whichItem, integer slot_index returns integer

endlibrary

#endif
