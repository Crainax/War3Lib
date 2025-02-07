globals
//globals from BzAPI:
constant boolean LIBRARY_BzAPI=true
//endglobals from BzAPI
//globals from HashTable:
constant boolean LIBRARY_HashTable=true
hashtable HASH_UNIT_TYPE=InitHashtable()
hashtable HASH_TIMER=InitHashtable()
hashtable HASH_GROUP=InitHashtable()
//endglobals from HashTable
//globals from LBKKAPI:
constant boolean LIBRARY_LBKKAPI=true
string MOVE_TYPE_NONE= "none"
string MOVE_TYPE_FOOT= "foot"
string MOVE_TYPE_HORSE= "horse"
string MOVE_TYPE_FLY= "fly"
string MOVE_TYPE_HOVER= "hover"
string MOVE_TYPE_FLOAT= "float"
string MOVE_TYPE_AMPH= "amph"
string MOVE_TYPE_UNBUILD= "unbuild"
constant integer DEFENSE_TYPE_LIGHT= 0
constant integer DEFENSE_TYPE_MEDIUM= 1
constant integer DEFENSE_TYPE_LARGE= 2
constant integer DEFENSE_TYPE_FORT= 3
constant integer DEFENSE_TYPE_NORMAL= 4
constant integer DEFENSE_TYPE_HERO= 5
constant integer DEFENSE_TYPE_DIVINE= 6
constant integer DEFENSE_TYPE_NONE= 7
//endglobals from LBKKAPI
//globals from SLKTable:
constant boolean LIBRARY_SLKTable=true
hashtable HASH_SLK=InitHashtable()
//endglobals from SLKTable
//globals from Spell:
constant boolean LIBRARY_Spell=true
//endglobals from Spell
//globals from SpellData:
constant boolean LIBRARY_SpellData=true
constant integer SPELL_TYPE_ENTITY=0
constant integer SPELL_TYPE_MIRROR=1
constant integer SPELL_TYPE_VIRTUAL=2
constant integer SPELL_TYPE_SIMPLE=3
//endglobals from SpellData
//globals from SpellTable:
constant boolean LIBRARY_SpellTable=true
hashtable HASH_SPELL=InitHashtable()
//endglobals from SpellTable
//globals from UnitTestFramwork:
constant boolean LIBRARY_UnitTestFramwork=true
trigger UnitTestFramwork___TUnitTest=null
hashtable UnitTestFramwork___HASH_UNITTEST=InitHashtable()
//endglobals from UnitTestFramwork
//globals from YDLua:
constant boolean LIBRARY_YDLua=true
//endglobals from YDLua
//globals from YDWEAbilityState:
constant boolean LIBRARY_YDWEAbilityState=true
constant integer YDWEAbilityState___ABILITY_STATE_COOLDOWN= 1
constant integer YDWEAbilityState___ABILITY_DATA_TARGS= 100
constant integer YDWEAbilityState___ABILITY_DATA_CAST= 101
constant integer YDWEAbilityState___ABILITY_DATA_DUR= 102
constant integer YDWEAbilityState___ABILITY_DATA_HERODUR= 103
constant integer YDWEAbilityState___ABILITY_DATA_COST= 104
constant integer YDWEAbilityState___ABILITY_DATA_COOL= 105
constant integer YDWEAbilityState___ABILITY_DATA_AREA= 106
constant integer YDWEAbilityState___ABILITY_DATA_RNG= 107
constant integer YDWEAbilityState___ABILITY_DATA_DATA_A= 108
constant integer YDWEAbilityState___ABILITY_DATA_DATA_B= 109
constant integer YDWEAbilityState___ABILITY_DATA_DATA_C= 110
constant integer YDWEAbilityState___ABILITY_DATA_DATA_D= 111
constant integer YDWEAbilityState___ABILITY_DATA_DATA_E= 112
constant integer YDWEAbilityState___ABILITY_DATA_DATA_F= 113
constant integer YDWEAbilityState___ABILITY_DATA_DATA_G= 114
constant integer YDWEAbilityState___ABILITY_DATA_DATA_H= 115
constant integer YDWEAbilityState___ABILITY_DATA_DATA_I= 116
constant integer YDWEAbilityState___ABILITY_DATA_UNITID= 117
constant integer YDWEAbilityState___ABILITY_DATA_HOTKET= 200
constant integer YDWEAbilityState___ABILITY_DATA_UNHOTKET= 201
constant integer YDWEAbilityState___ABILITY_DATA_RESEARCH_HOTKEY= 202
constant integer YDWEAbilityState___ABILITY_DATA_NAME= 203
constant integer YDWEAbilityState___ABILITY_DATA_ART= 204
constant integer YDWEAbilityState___ABILITY_DATA_TARGET_ART= 205
constant integer YDWEAbilityState___ABILITY_DATA_CASTER_ART= 206
constant integer YDWEAbilityState___ABILITY_DATA_EFFECT_ART= 207
constant integer YDWEAbilityState___ABILITY_DATA_AREAEFFECT_ART= 208
constant integer YDWEAbilityState___ABILITY_DATA_MISSILE_ART= 209
constant integer YDWEAbilityState___ABILITY_DATA_SPECIAL_ART= 210
constant integer YDWEAbilityState___ABILITY_DATA_LIGHTNING_EFFECT= 211
constant integer YDWEAbilityState___ABILITY_DATA_BUFF_TIP= 212
constant integer YDWEAbilityState___ABILITY_DATA_BUFF_UBERTIP= 213
constant integer YDWEAbilityState___ABILITY_DATA_RESEARCH_TIP= 214
constant integer YDWEAbilityState___ABILITY_DATA_TIP= 215
constant integer YDWEAbilityState___ABILITY_DATA_UNTIP= 216
constant integer YDWEAbilityState___ABILITY_DATA_RESEARCH_UBERTIP= 217
constant integer YDWEAbilityState___ABILITY_DATA_UBERTIP= 218
constant integer YDWEAbilityState___ABILITY_DATA_UNUBERTIP= 219
constant integer YDWEAbilityState___ABILITY_DATA_UNART= 220
//endglobals from YDWEAbilityState
//globals from Hardware:
constant boolean LIBRARY_Hardware=true
//endglobals from Hardware
//globals from Logger:
constant boolean LIBRARY_Logger=true
integer logger_level=0
string logger_msg=null
player logger_p=null
trigger logger_tr=null
//endglobals from Logger
//globals from UTSpell:
constant boolean LIBRARY_UTSpell=true
unit UTSpell___testArchmage=null
unit UTSpell___testFootman=null
unit UTSpell___testSpell=null
integer UTSpell___sp=0
integer array UTSpell___sd
integer UTSpell___count=10
boolean UTSpell___toggle5=false
//endglobals from UTSpell
//globals from UnitSelect:
constant boolean LIBRARY_UnitSelect=true
//endglobals from UnitSelect
    // Generated
rect gg_rct_Wave1= null
rect gg_rct_Wave2= null
rect gg_rct_Wave3= null
rect gg_rct_Wave4= null
rect gg_rct_Base= null
rect gg_rct_BaseBack= null
rect gg_rct_Home1= null
rect gg_rct_Home2= null
rect gg_rct_Home3= null
rect gg_rct_Home4= null
rect gg_rct_Fuben1= null
rect gg_rct_Fuben2= null
rect gg_rct_Fuben3= null
rect gg_rct_Fuben4= null
rect gg_rct_Fuben5= null
rect gg_rct_Fuben6= null
rect gg_rct_Fuben7= null
rect gg_rct_Fuben8= null
trigger gg_trg_______u= null
unit gg_unit_hcas_0011= null

trigger l__library_init

//JASSHelper struct globals:
constant integer si__spell=1
integer si__spell_F=0
integer si__spell_I=0
integer array si__spell_V
integer s__spell_ethis=0
unit array s__spell_u
integer array s__spell_spellType
integer array s__spell_id
integer array s__spell_sd
integer array s__spell_level
trigger array s__spell_trDestroy
constant integer si__spellData=2
integer s__spellData_counter=0
integer array s__spellData_id
integer array s__spellData_spellType
trigger array s__spellData_trInit
trigger array s__spellData_trDestroy
trigger array s__spellData_trUpgrade
integer array s__spellData_maxLevel
string array s__spellData_description
string array s__spellData_icon
constant integer si__assert=3
constant integer si__hardware=4
trigger s__hardware_trWheel=null
trigger s__hardware_trUpdate=null
trigger s__hardware_trResize=null
trigger s__hardware_trMove=null
constant integer si__unitSelect=5
unit s__unitSelect_args=null
unit s__unitSelect_argsSync=null
unit array s__unitSelect_currentU
trigger s__unitSelect_trAsync
trigger s__unitSelect_trAsyncUn
trigger s__unitSelect_trSync
trigger s__unitSelect_trSyncUn
unit s__unitSelect_asyncU=null
trigger st__spell_onDestroy
trigger st__spellData_byType
trigger st__unitSelect_onSync
integer f__arg_integer1
code f__arg_code1
integer f__arg_this
integer f__result_integer

endglobals
    native DzGetMouseTerrainX takes nothing returns real
    native DzGetMouseTerrainY takes nothing returns real
    native DzGetMouseTerrainZ takes nothing returns real
    native DzIsMouseOverUI takes nothing returns boolean
    native DzGetMouseX takes nothing returns integer
    native DzGetMouseY takes nothing returns integer
    native DzGetMouseXRelative takes nothing returns integer
    native DzGetMouseYRelative takes nothing returns integer
    native DzSetMousePos takes integer x, integer y returns nothing
    native DzTriggerRegisterMouseEvent takes trigger trig, integer btn, integer status, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseEventByCode takes trigger trig, integer btn, integer status, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterKeyEvent takes trigger trig, integer key, integer status, boolean sync, string func returns nothing
    native DzTriggerRegisterKeyEventByCode takes trigger trig, integer key, integer status, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterMouseWheelEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseWheelEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterMouseMoveEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseMoveEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzGetTriggerKey takes nothing returns integer
    native DzGetWheelDelta takes nothing returns integer
    native DzIsKeyDown takes integer iKey returns boolean
    native DzGetTriggerKeyPlayer takes nothing returns player
    native DzGetWindowWidth takes nothing returns integer
    native DzGetWindowHeight takes nothing returns integer
    native DzGetWindowX takes nothing returns integer
    native DzGetWindowY takes nothing returns integer
    native DzTriggerRegisterWindowResizeEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterWindowResizeEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzIsWindowActive takes nothing returns boolean
    native DzDestructablePosition takes destructable d, real x, real y returns nothing
    native DzSetUnitPosition takes unit whichUnit, real x, real y returns nothing
    native DzExecuteFunc takes string funcName returns nothing
    native DzGetUnitUnderMouse takes nothing returns unit
    native DzSetUnitTexture takes unit whichUnit, string path, integer texId returns nothing
    native DzSetMemory takes integer address, real value returns nothing
    native DzSetUnitID takes unit whichUnit, integer id returns nothing
    native DzSetUnitModel takes unit whichUnit, string path returns nothing
    native DzSetWar3MapMap takes string map returns nothing
    native DzGetLocale takes nothing returns string
    native DzGetUnitNeededXP takes unit whichUnit, integer level returns integer
    native DzTriggerRegisterSyncData takes trigger trig, string prefix, boolean server returns nothing
    native DzSyncData takes string prefix, string data returns nothing
    native DzGetTriggerSyncPrefix takes nothing returns string
    native DzGetTriggerSyncData takes nothing returns string
    native DzGetTriggerSyncPlayer takes nothing returns player
    native DzSyncBuffer takes string prefix, string data, integer dataLen returns nothing
    native DzSyncDataImmediately takes string prefix, string data returns nothing 
    native DzFrameHideInterface takes nothing returns nothing
    native DzFrameEditBlackBorders takes real upperHeight, real bottomHeight returns nothing
    native DzFrameGetPortrait takes nothing returns integer
    native DzFrameGetMinimap takes nothing returns integer
    native DzFrameGetCommandBarButton takes integer row, integer column returns integer
    native DzFrameGetHeroBarButton takes integer buttonId returns integer
    native DzFrameGetHeroHPBar takes integer buttonId returns integer
    native DzFrameGetHeroManaBar takes integer buttonId returns integer
    native DzFrameGetItemBarButton takes integer buttonId returns integer
    native DzFrameGetMinimapButton takes integer buttonId returns integer
    native DzFrameGetUpperButtonBarButton takes integer buttonId returns integer
    native DzFrameGetTooltip takes nothing returns integer
    native DzFrameGetChatMessage takes nothing returns integer
    native DzFrameGetUnitMessage takes nothing returns integer
    native DzFrameGetTopMessage takes nothing returns integer
    native DzGetColor takes integer r, integer g, integer b, integer a returns integer
    native DzFrameSetUpdateCallback takes string func returns nothing
    native DzFrameSetUpdateCallbackByCode takes code funcHandle returns nothing
    native DzFrameShow takes integer frame, boolean enable returns nothing
    native DzCreateFrame takes string frame, integer parent, integer id returns integer
    native DzCreateSimpleFrame takes string frame, integer parent, integer id returns integer
    native DzDestroyFrame takes integer frame returns nothing
    native DzLoadToc takes string fileName returns nothing
    native DzFrameSetPoint takes integer frame, integer point, integer relativeFrame, integer relativePoint, real x, real y returns nothing
    native DzFrameSetAbsolutePoint takes integer frame, integer point, real x, real y returns nothing
    native DzFrameClearAllPoints takes integer frame returns nothing
    native DzFrameSetEnable takes integer name, boolean enable returns nothing
    native DzFrameSetScript takes integer frame, integer eventId, string func, boolean sync returns nothing
    native DzFrameSetScriptByCode takes integer frame, integer eventId, code funcHandle, boolean sync returns nothing
    native DzGetTriggerUIEventPlayer takes nothing returns player
    native DzGetTriggerUIEventFrame takes nothing returns integer
    native DzFrameFindByName takes string name, integer id returns integer
    native DzSimpleFrameFindByName takes string name, integer id returns integer
    native DzSimpleFontStringFindByName takes string name, integer id returns integer
    native DzSimpleTextureFindByName takes string name, integer id returns integer
    native DzGetGameUI takes nothing returns integer
    native DzClickFrame takes integer frame returns nothing
    native DzSetCustomFovFix takes real value returns nothing
    native DzEnableWideScreen takes boolean enable returns nothing
    native DzFrameSetText takes integer frame, string text returns nothing
    native DzFrameGetText takes integer frame returns string
    native DzFrameSetTextSizeLimit takes integer frame, integer size returns nothing
    native DzFrameGetTextSizeLimit takes integer frame returns integer
    native DzFrameSetTextColor takes integer frame, integer color returns nothing
    native DzGetMouseFocus takes nothing returns integer
    native DzFrameSetAllPoints takes integer frame, integer relativeFrame returns boolean
    native DzFrameSetFocus takes integer frame, boolean enable returns boolean
    native DzFrameSetModel takes integer frame, string modelFile, integer modelType, integer flag returns nothing
    native DzFrameGetEnable takes integer frame returns boolean
    native DzFrameSetAlpha takes integer frame, integer alpha returns nothing
    native DzFrameGetAlpha takes integer frame returns integer
    native DzFrameSetAnimate takes integer frame, integer animId, boolean autocast returns nothing
    native DzFrameSetAnimateOffset takes integer frame, real offset returns nothing
    native DzFrameSetTexture takes integer frame, string texture, integer flag returns nothing
    native DzFrameSetScale takes integer frame, real scale returns nothing
    native DzFrameSetTooltip takes integer frame, integer tooltip returns nothing
    native DzFrameCageMouse takes integer frame, boolean enable returns nothing
    native DzFrameGetValue takes integer frame returns real
    native DzFrameSetMinMaxValue takes integer frame, real minValue, real maxValue returns nothing
    native DzFrameSetStepValue takes integer frame, real step returns nothing
    native DzFrameSetValue takes integer frame, real value returns nothing
    native DzFrameSetSize takes integer frame, real w, real h returns nothing
    native DzCreateFrameByTagName takes string frameType, string name, integer parent, string template, integer id returns integer
    native DzFrameSetVertexColor takes integer frame, integer color returns nothing
    native DzOriginalUIAutoResetPoint takes boolean enable returns nothing
    native DzFrameSetPriority takes integer frame, integer priority returns nothing
    native DzFrameSetParent takes integer frame, integer parent returns nothing
    native DzFrameGetHeight takes integer frame returns real
    native DzFrameSetFont takes integer frame, string fileName, real height, integer flag returns nothing
    native DzFrameGetParent takes integer frame returns integer
    native DzFrameSetTextAlignment takes integer frame, integer align returns nothing
    native DzFrameGetName takes integer frame returns string
    native DzGetClientWidth takes nothing returns integer
    native DzGetClientHeight takes nothing returns integer
    native DzFrameIsVisible takes integer frame returns boolean
    native DzFrameAddText takes integer frame, string text returns nothing
    native DzUnitSilence takes unit whichUnit, boolean disable returns nothing
    native DzUnitDisableAttack takes unit whichUnit, boolean disable returns nothing
    native DzUnitDisableInventory takes unit whichUnit, boolean disable returns nothing
    native DzUpdateMinimap takes nothing returns nothing
    native DzUnitChangeAlpha takes unit whichUnit, integer alpha, boolean forceUpdate returns nothing
    native DzUnitSetCanSelect takes unit whichUnit, boolean state returns nothing
    native DzUnitSetTargetable takes unit whichUnit, boolean state returns nothing
    native DzSaveMemoryCache takes string cache returns nothing
    native DzGetMemoryCache takes nothing returns string
    native DzSetSpeed takes real ratio returns nothing
    native DzConvertWorldPosition takes real x, real y, real z, code callback returns boolean
    native DzGetConvertWorldPositionX takes nothing returns real
    native DzGetConvertWorldPositionY takes nothing returns real
    native DzCreateCommandButton takes integer parent, string icon, string name, string desc returns integer
        native DzGetSelectedLeaderUnit takes nothing returns unit 
        native DzIsChatBoxOpen takes nothing returns boolean 
        native DzSetUnitPreselectUIVisible takes unit whichUnit, boolean visible returns nothing 
        native DzSetEffectAnimation takes effect whichEffect, integer index, integer flag returns nothing 
        native DzSetEffectPos takes effect whichEffect, real x, real y, real z returns nothing 
        native DzSetEffectVertexColor takes effect whichEffect, integer color returns nothing 
        native DzSetEffectVertexAlpha takes effect whichEffect, integer alpha returns nothing 
        native DzSetEffectModel takes effect whichEffect, string model returns nothing
        native DzSetEffectTeamColor takes effect whichHandle, integer playerId returns nothing
        native DzFrameSetClip takes integer whichframe, boolean enable returns nothing 
        native DzChangeWindowSize takes integer width, integer height returns boolean 
        native DzPlayEffectAnimation takes effect whichEffect, string anim, string link returns nothing 
        native DzBindEffect takes widget parent, string attachPoint, effect whichEffect returns nothing 
        native DzUnbindEffect takes effect whichEffect returns nothing 
        native DzSetWidgetSpriteScale takes widget whichUnit, real scale returns nothing 
        native DzSetEffectScale takes effect whichHandle, real scale returns nothing 
        native DzGetEffectVertexColor takes effect whichEffect returns integer 
        native DzGetEffectVertexAlpha takes effect whichEffect returns integer 
        native DzGetItemAbility takes item whichEffect, integer index returns ability 
        native DzFrameGetChildrenCount takes integer whichframe returns integer 
        native DzFrameGetChild takes integer whichframe, integer index returns integer 
        native DzUnlockBlpSizeLimit takes boolean enable returns nothing 
        native DzGetActivePatron takes unit store, player p returns unit 
        native DzGetLocalSelectUnitCount takes nothing returns integer 
        native DzGetLocalSelectUnit takes integer index returns unit 
        native DzGetJassStringTableCount takes nothing returns integer 
        native DzModelRemoveFromCache takes string path returns nothing 
        native DzModelRemoveAllFromCache takes nothing returns nothing 
        native DzFrameGetInfoPanelSelectButton takes integer index returns integer 
        native DzFrameGetInfoPanelBuffButton takes integer index returns integer 
        native DzFrameGetPeonBar takes nothing returns integer 
        native DzFrameGetCommandBarButtonNumberText takes integer whichframe returns integer 
        native DzFrameGetCommandBarButtonNumberOverlay takes integer whichframe returns integer 
        native DzFrameGetCommandBarButtonCooldownIndicator takes integer whichframe returns integer 
        native DzFrameGetCommandBarButtonAutoCastIndicator takes integer whichframe returns integer 
        native DzToggleFPS takes boolean show returns nothing 
        native DzGetFPS takes nothing returns integer 
        native DzFrameWorldToMinimapPosX takes real x, real y returns real 
        native DzFrameWorldToMinimapPosY takes real x, real y returns real 
        native DzWidgetSetMinimapIcon takes unit whichunit, string path returns nothing 
        native DzWidgetSetMinimapIconEnable takes unit whichunit, boolean enable returns nothing 
        native DzFrameGetWorldFrameMessage takes nothing returns integer 
        native DzSimpleMessageFrameAddMessage takes integer whichframe, string text, integer color, real duration, boolean permanent returns nothing 
        native DzSimpleMessageFrameClear takes integer whichframe returns nothing 
        native DzConvertScreenPositionX takes real x, real y returns real 
        native DzConvertScreenPositionY takes real x, real y returns real 
        native DzRegisterOnBuildLocal takes code func returns nothing 
        native DzGetOnBuildOrderId takes nothing returns integer 
        native DzGetOnBuildOrderType takes nothing returns integer 
        native DzGetOnBuildAgent takes nothing returns widget 
        native DzRegisterOnTargetLocal takes code func returns nothing 
        native DzGetOnTargetAbilId takes nothing returns integer 
        native DzGetOnTargetOrderId takes nothing returns integer 
        native DzGetOnTargetOrderType takes nothing returns integer 
        native DzGetOnTargetAgent takes nothing returns widget 
        native DzGetOnTargetInstantTarget takes nothing returns widget 
        native DzOpenQQGroupUrl takes string url returns boolean 
        native DzFrameEnableClipRect takes boolean enable returns nothing 
        native DzSetUnitName takes unit whichUnit, string name returns nothing 
        native DzSetUnitPortrait takes unit whichUnit, string modelFile returns nothing 
        native DzSetUnitDescription takes unit whichUnit, string value returns nothing 
        native DzSetUnitMissileArc takes unit whichUnit, real arc returns nothing 
        native DzSetUnitMissileModel takes unit whichUnit, string modelFile returns nothing 
        native DzSetUnitProperName takes unit whichUnit, string name returns nothing 
        native DzSetUnitMissileHoming takes unit whichUnit, boolean enable returns nothing 
        native DzSetUnitMissileSpeed takes unit whichUnit, real speed returns nothing 
        native DzSetEffectVisible takes effect whichHandle, boolean enable returns nothing 
        native DzReviveUnit takes unit whichUnit, player whichPlayer, real hp, real mp, real x, real y returns nothing 
        native DzGetAttackAbility takes unit whichUnit returns ability 
        native DzAttackAbilityEndCooldown takes ability whichHandle returns nothing 
        native EXSetUnitArrayString takes integer uid, integer id, integer n, string name returns boolean 
        native EXSetUnitInteger takes integer uid, integer id, integer n returns boolean 
        native DzDoodadCreate takes integer id, integer var, real x, real y, real z, real rotate, real scale returns integer 
        native DzDoodadGetTypeId takes integer doodad returns integer 
        native DzDoodadSetModel takes integer doodad, string modelFile returns nothing 
        native DzDoodadSetTeamColor takes integer doodad, integer color returns nothing 
        native DzDoodadSetColor takes integer doodad, integer color returns nothing 
        native DzDoodadGetX takes integer doodad returns real 
        native DzDoodadGetY takes integer doodad returns real 
        native DzDoodadGetZ takes integer doodad returns real 
        native DzDoodadSetPosition takes integer doodad, real x, real y, real z returns nothing 
        native DzDoodadSetOrientMatrixRotate takes integer doodad, real angle, real axisX, real axisY, real axisZ returns nothing 
        native DzDoodadSetOrientMatrixScale takes integer doodad, real x, real y, real z returns nothing 
        native DzDoodadSetOrientMatrixResize takes integer doodad returns nothing 
        native DzDoodadSetVisible takes integer doodad, boolean enable returns nothing 
        native DzDoodadSetAnimation takes integer doodad, string animName, boolean animRandom returns nothing 
        native DzDoodadSetTimeScale takes integer doodad, real scale returns nothing 
        native DzDoodadGetTimeScale takes integer doodad returns real 
        native DzDoodadGetCurrentAnimationIndex takes integer doodad returns integer 
        native DzDoodadGetAnimationCount takes integer doodad returns integer 
        native DzDoodadGetAnimationName takes integer doodad, integer index returns string 
        native DzDoodadGetAnimationTime takes integer doodad, integer index returns integer 
        native DzUnlockOpCodeLimit takes boolean enable returns nothing
        native DzSetClipboard takes string content returns boolean
        native DzDoodadRemove takes integer doodad returns nothing
        native DzRemovePlayerTechResearched takes player whichPlayer, integer techid, integer removelevels returns nothing
        native DzUnitFindAbility takes unit whichUnit, integer abilcode returns ability
        native DzAbilitySetStringData takes ability whichAbility, string key, string value returns nothing
        native DzAbilitySetEnable takes ability whichAbility, boolean enable, boolean hideUI returns nothing
        native DzUnitSetMoveType takes unit whichUnit, string moveType returns nothing
        native DzFrameGetWidth takes integer frame returns real
        native DzFrameSetAnimateByIndex takes integer frame, integer index, integer flag returns nothing
        native DzSetUnitDataCacheInteger takes integer uid, integer id,integer index,integer v returns nothing
        native DzUnitUIAddLevelArrayInteger takes integer uid, integer id,integer lv,integer v returns nothing
        native DzItemSetModel takes item whichItem, string file returns nothing
        native DzItemSetVertexColor takes item whichItem, integer color returns nothing
        native DzItemSetAlpha takes item whichItem, integer color returns nothing
        native DzItemSetPortrait takes item whichItem, string modelPath returns nothing
	native EXGetUnitAbility takes unit u, integer abilcode returns ability
	native EXGetUnitAbilityByIndex takes unit u, integer index returns ability
	native EXGetAbilityId takes ability abil returns integer
	native EXGetAbilityState takes ability abil, integer state_type returns real
	native EXSetAbilityState takes ability abil, integer state_type, real value returns boolean
	native EXGetAbilityDataReal takes ability abil, integer level, integer data_type returns real
	native EXSetAbilityDataReal takes ability abil, integer level, integer data_type, real value returns boolean
	native EXGetAbilityDataInteger takes ability abil, integer level, integer data_type returns integer
	native EXSetAbilityDataInteger takes ability abil, integer level, integer data_type, integer value returns boolean
	native EXGetAbilityDataString takes ability abil, integer level, integer data_type returns string
	native EXSetAbilityDataString takes ability abil, integer level, integer data_type, string value returns boolean
	native EXSetAbilityAEmeDataA takes ability abil, integer unitid returns boolean
	native EXGetItemDataString takes integer itemcode, integer data_type returns string
	native EXSetItemDataString takes integer itemcode, integer data_type, string value returns boolean


//Generated method caller for spell.onDestroy
function sc__spell_onDestroy takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__spell_onDestroy)
endfunction

//Generated allocator of spell
function s__spell__allocate takes nothing returns integer
 local integer this=si__spell_F
    if (this!=0) then
        set si__spell_F=si__spell_V[this]
    else
        set si__spell_I=si__spell_I+1
        set this=si__spell_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: spell")
        return 0
    endif

    set si__spell_V[this]=-1
 return this
endfunction

//Generated destructor of spell
function sc__spell_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: spell")
        return
    elseif (si__spell_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: spell")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__spell_onDestroy)
    set si__spell_V[this]=si__spell_F
    set si__spell_F=this
endfunction

//Generated method caller for unitSelect.onSync
function sc__unitSelect_onSync takes code func returns nothing
            call TriggerAddCondition(s__unitSelect_trSync, Condition(func))
endfunction

//Generated method caller for spellData.byType
function sc__spellData_byType takes integer at returns integer
    set f__arg_integer1=at
    call TriggerEvaluate(st__spellData_byType)
 return f__result_integer
endfunction

//library BzAPI:
    //hardware




























    //plus











    //sync






    //native DzGetPushContext takes nothing returns string

    //gui











































































        //显示/隐藏SimpleFrame
    //native DzSimpleFrameShow takes integer frame, boolean enable returns nothing
    // 追加文字（支持TextArea）

    // 沉默单位-禁用技能

    // 禁用攻击

    // 禁用道具

    // 刷新小地图

    // 修改单位alpha

    // 设置单位是否可以选中

    // 修改单位是否可以被设置为目标

    // 保存内存数据

    // 读取内存数据

    // 设置加速倍率

    // 转换世界坐标为屏幕坐标-异步

    // 转换世界坐标为屏幕坐标-获取转换后的X坐标

    // 转换世界坐标为屏幕坐标-获取转换后的Y坐标

    // 创建command button

    function DzTriggerRegisterMouseEventTrg takes trigger trg,integer status,integer btn returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseEvent(trg, btn, status, true, null)
    endfunction
    function DzTriggerRegisterKeyEventTrg takes trigger trg,integer status,integer btn returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterKeyEvent(trg, btn, status, true, null)
    endfunction
    function DzTriggerRegisterMouseMoveEventTrg takes trigger trg returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseMoveEvent(trg, true, null)
    endfunction
    function DzTriggerRegisterMouseWheelEventTrg takes trigger trg returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseWheelEvent(trg, true, null)
    endfunction
    function DzTriggerRegisterWindowResizeEventTrg takes trigger trg returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterWindowResizeEvent(trg, true, null)
    endfunction
    function DzF2I takes integer i returns integer
        return i
    endfunction
    function DzI2F takes integer i returns integer
        return i
    endfunction
    function DzK2I takes integer i returns integer
        return i
    endfunction
    function DzI2K takes integer i returns integer
        return i
    endfunction
    function DzTriggerRegisterMallItemSyncData takes trigger trig returns nothing
        call DzTriggerRegisterSyncData(trig, "DZMIA", true)
    endfunction
    //玩家消耗/使用商城道具事件
    function DzTriggerRegisterMallItemConsumeEvent takes trigger trig returns nothing
        call DzTriggerRegisterSyncData(trig, "DZMIC", true)
    endfunction
    //玩家删除商城道具事件
    function DzTriggerRegisterMallItemRemoveEvent takes trigger trig returns nothing
        call DzTriggerRegisterSyncData(trig, "DZMID", true)
    endfunction
    function DzGetTriggerMallItemPlayer takes nothing returns player
        return DzGetTriggerSyncPlayer()
    endfunction
    function DzGetTriggerMallItem takes nothing returns string
        return DzGetTriggerSyncData()
    endfunction
    

//library BzAPI ends
//library HashTable:
    //public:  // 单位类型哈希表

//library HashTable ends
//library LBKKAPI:












































        //转换屏幕坐标到世界坐标  


        //监听建筑选位置  

        //等于0时是结束事件  



        //监听技能选目标  

        //等于0时是结束事件  





        // 打开QQ群链接  
















        function DzSetHeroTypeProperName takes integer uid,string name returns nothing
                call EXSetUnitArrayString(uid, 61, 0, name)
                call EXSetUnitInteger(uid, 61, 1)
        endfunction 
        function DzSetUnitTypeName takes integer uid,string name returns nothing
                call EXSetUnitArrayString(uid, 10, 0, name)
                call EXSetUnitInteger(uid, 10, 1)
        endfunction 
        function DzIsUnitAttackType takes unit whichUnit,integer index,attacktype attackType returns boolean
                return ConvertAttackType(R2I(GetUnitState(whichUnit, ConvertUnitState(16 + 19 * index)))) == attackType
        endfunction 
        function DzSetUnitAttackType takes unit whichUnit,integer index,attacktype attackType returns nothing
                call SetUnitState(whichUnit, ConvertUnitState(16 + 19 * index), GetHandleId(attackType))
        endfunction 
        function DzIsUnitDefenseType takes unit whichUnit,integer defenseType returns boolean
                return R2I(GetUnitState(whichUnit, ConvertUnitState(0x50))) == defenseType
        endfunction 
        function DzSetUnitDefenseType takes unit whichUnit,integer defenseType returns nothing
                call SetUnitState(whichUnit, ConvertUnitState(0x50), defenseType)
        endfunction 
        // 地形装饰物




















        // 解锁JASS字节码限制

        // 设置剪切板内容

        //删除装饰物

        //移除科技等级

        
        // 查找单位技能

        // 修改技能数据-字符串

                
        // 启用/禁用技能

        // 设置单位移动类型

        // 获取控件宽度




        function KKWESetUnitDataCacheInteger takes integer uid,integer id,integer v returns nothing
                call DzSetUnitDataCacheInteger(uid, id, 0, v)
        endfunction
        function KKWEUnitUIAddUpgradesIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger(uid, 94, id, v)
        endfunction
        function KKWEUnitUIAddBuildsIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger(uid, 100, id, v)
        endfunction
        function KKWEUnitUIAddResearchesIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger(uid, 112, id, v)
        endfunction
        function KKWEUnitUIAddTrainsIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger(uid, 106, id, v)
        endfunction
        function KKWEUnitUIAddSellsUnitIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger(uid, 118, id, v)
        endfunction
        function KKWEUnitUIAddSellsItemIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger(uid, 124, id, v)
        endfunction
        function KKWEUnitUIAddMakesItemIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger(uid, 130, id, v)
        endfunction
        function KKWEUnitUIAddRequiresUnitCode takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger(uid, 166, id, v)
        endfunction
        function KKWEUnitUIAddRequiresTechcode takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger(uid, 166, id, v)
        endfunction
        function KKWEUnitUIAddRequiresAmounts takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger(uid, 172, id, v)
        endfunction
         // 设置道具模型

        // 设置道具颜色

        // 设置道具透明度

        // 设置道具头像


//library LBKKAPI ends
//library SLKTable:

//library SLKTable ends
//library Spell:
    function GetHashValue takes integer handleID,integer customId returns integer
        local integer prime1=131071 // 2^17-1 
        local integer prime2=179424673
        return ( handleID * prime1 ) + ( customId * prime2 )
    endfunction
        function s__spell_isExist takes integer this returns boolean
            return ( this != null and si__spell_V[this] == - 1 )
        endfunction
        function s__spell_entity takes unit u,integer id,integer level returns integer
            local integer this
            local integer key=GetHashValue(GetHandleId(u) , id)
            if ( key == 0 ) then
                return 0
            endif // 先检查是否已存在
            if ( HaveSavedInteger(HASH_SPELL, key, 15) ) then
                return LoadInteger(HASH_SPELL, key, 15)
            endif //没技能就添加技能
            if ( GetUnitAbilityLevel(u, id) == 0 ) then
                call UnitAddAbility(u, id)
            endif // 不存在才创建新的
            set this=s__spell__allocate()
            set s__spell_u[this]=u
            set s__spell_id[this]=id
            set s__spell_sd[this]=sc__spellData_byType(id)
            set s__spell_level[this]=level
            set s__spell_spellType[this]=SPELL_TYPE_ENTITY //实体技能要设置等级
            call SetUnitAbilityLevel(u, id, level)
            call SaveInteger(HASH_SPELL, key, 15, this)
            return this
        endfunction  // 创建镜像技能(无ID)
        function s__spell_mirror takes unit u,integer id,integer sd,integer level returns integer
            local integer this
            local integer key=GetHashValue(GetHandleId(u) , id)
            if ( HaveSavedInteger(HASH_SPELL, key, 15) ) then
                return LoadInteger(HASH_SPELL, key, 15)
            endif //没技能就添加技能
            if ( GetUnitAbilityLevel(u, id) == 0 ) then
                call UnitAddAbility(u, id)
            endif // 不存在才创建新的
            set this=s__spell__allocate()
            set s__spell_u[this]=u
            set s__spell_id[this]=id
            set s__spell_spellType[this]=SPELL_TYPE_MIRROR
            set s__spell_sd[this]=sd
            set s__spell_level[this]=level
            call SaveInteger(HASH_SPELL, key, 15, this)
            return this
        endfunction  // 创建虚拟技能(无ID)
        function s__spell_virtual takes unit u,integer sd,integer level returns integer
            local integer this
            local integer key=GetHashValue(GetHandleId(u) , sd)
            if ( HaveSavedInteger(HASH_SPELL, key, 15) ) then
                return LoadInteger(HASH_SPELL, key, 15)
            endif // 不存在才创建新的
            set this=s__spell__allocate()
            set s__spell_u[this]=u
            set s__spell_id[this]=0
            set s__spell_spellType[this]=SPELL_TYPE_VIRTUAL
            set s__spell_sd[this]=sd
            set s__spell_level[this]=level
            call SaveInteger(HASH_SPELL, key, 15, this)
            return this
        endfunction  // 获取技能结构体
        function s__spell_get takes unit u,integer id returns integer
            if ( HaveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(u) , id), 15) ) then
                return LoadInteger(HASH_SPELL, GetHashValue(GetHandleId(u) , id), 15)
            endif
            return 0
        endfunction  // 注册销毁时的回调
        function s__spell_registerDestroy takes integer this,code func returns nothing
            if ( not ( s__spell_isExist(this) ) ) then
                return
            endif
            if ( s__spell_trDestroy[this] == null ) then
                set s__spell_trDestroy[this]=CreateTrigger()
            endif
            call TriggerAddCondition(s__spell_trDestroy[this], Condition(func))
        endfunction  //销毁时调用
        function s__spell_onDestroy takes integer this returns nothing
            if ( not ( s__spell_isExist(this) ) ) then
                return
            endif
            if ( s__spell_trDestroy[this] != null ) then
                set s__spell_ethis=this
                call TriggerEvaluate(s__spell_trDestroy[this])
                call DestroyTrigger(s__spell_trDestroy[this])
                set s__spell_trDestroy[this]=null
            endif //虚拟技能
            if ( s__spell_spellType[this] == SPELL_TYPE_VIRTUAL ) then
                if ( HaveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(s__spell_u[this]) , s__spell_sd[this]), 15) ) then
                    call RemoveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(s__spell_u[this]) , s__spell_sd[this]), 15)
                endif //有ID的技能
            elseif ( HaveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(s__spell_u[this]) , s__spell_id[this]), 15) ) then
                call RemoveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(s__spell_u[this]) , s__spell_id[this]), 15)
            endif
            if ( s__spell_id[this] != 0 ) then
                call UnitRemoveAbility(s__spell_u[this], s__spell_id[this])
            endif
            set s__spell_u[this]=null
            set s__spell_id[this]=0
            set s__spell_sd[this]=0
        endfunction  // HOOK:这里的id仅是物编ID没有virtual

//Generated destructor of spell
function s__spell_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: spell")
        return
    elseif (si__spell_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: spell")
        return
    endif
    call s__spell_onDestroy(this)
    set si__spell_V[this]=si__spell_F
    set si__spell_F=this
endfunction

//library Spell ends
//library SpellData:
        function s__spellData_byType takes integer at returns integer
            local integer this
            if ( HaveSavedInteger(HASH_SLK, at, 1727) ) then
                set this=LoadInteger(HASH_SLK, at, 1727)
            else
                set s__spellData_counter=s__spellData_counter + 1
                set this=(s__spellData_counter)
                call SaveInteger(HASH_SLK, at, 1727, this)
                set s__spellData_id[this]=at //默认最大等级1级
                set s__spellData_maxLevel[this]=1
            endif
            return this
        endfunction

//library SpellData ends
//library SpellTable:

//library SpellTable ends
//library UnitTestFramwork:

        function s__assert_Boolean takes boolean condition,string name returns nothing
            if ( not condition ) then
                call BJDebugMsg("FAIL: " + name)
            else
                call BJDebugMsg("PASS: " + name)
            endif
        endfunction  //断言字符串相等
        function s__assert_String takes string actual,string expected,string name returns nothing
            if ( actual != expected ) then
                call BJDebugMsg("FAIL: " + name)
                call BJDebugMsg("  Expected: " + expected)
                call BJDebugMsg("  Actual: " + actual)
            else
                call BJDebugMsg("PASS: " + name)
            endif
        endfunction  //断言整数相等
        function s__assert_Integer takes integer actual,integer expected,string name returns nothing
            if ( actual != expected ) then
                call BJDebugMsg("FAIL: " + name)
                call BJDebugMsg("  Expected: " + I2S(expected))
                call BJDebugMsg("  Actual: " + I2S(actual))
            else
                call BJDebugMsg("PASS: " + name)
            endif
        endfunction  //断言浮点数相等
        function s__assert_Real takes real actual,real expected,string name returns nothing
            local real maxValue=RMaxBJ(RAbsBJ(actual), RAbsBJ(expected))
            local real epsilon=maxValue * 0.00001
            if ( maxValue < 0.00001 ) then
                set epsilon=0.00001
            endif
            if ( RAbsBJ(actual - expected) > epsilon ) then
                call BJDebugMsg("FAIL: " + name)
                call BJDebugMsg("  Expected: " + R2SW(expected, 0, 1))
                call BJDebugMsg("  Actual: " + R2SW(actual, 0, 1))
            else
                call BJDebugMsg("PASS: " + name)
            endif
        endfunction
    function UnitTestRegisterChatEvent takes code func returns nothing
        call TriggerAddAction(UnitTestFramwork___TUnitTest, func)
    endfunction  //指定开始时间与持续时间的定时器
        function UnitTestFramwork___anon__0 takes nothing returns nothing
            local real time=LoadReal(UnitTestFramwork___HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 1)
            local real d=LoadReal(UnitTestFramwork___HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 2)
            local trigger tr=LoadTriggerHandle(UnitTestFramwork___HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 3)
            call BJDebugMsg("-----[单测 " + R2SW(time, 0, 1) + " - " + R2SW(time + d, 0, 1) + " 秒]开始------")
            call TriggerEvaluate(tr)
            call DestroyTrigger(tr)
            call FlushChildHashtable(UnitTestFramwork___HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()))
            call DestroyTrigger(GetTriggeringTrigger())
            set tr=null
        endfunction
        function UnitTestFramwork___anon__1 takes nothing returns nothing
            local real time=LoadReal(UnitTestFramwork___HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 1)
            local real d=LoadReal(UnitTestFramwork___HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 2)
            local trigger tr=LoadTriggerHandle(UnitTestFramwork___HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 3)
            call TriggerEvaluate(tr)
            call BJDebugMsg("-----[单测 " + R2SW(time, 0, 1) + " - " + R2SW(time + d, 0, 1) + " 秒]结束------")
            call DestroyTrigger(tr)
            call FlushChildHashtable(UnitTestFramwork___HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()))
            call DestroyTrigger(GetTriggeringTrigger())
            set tr=null
        endfunction
    function UnitTestAutoTimer takes real time,real duration,code start,code end returns nothing
        local trigger t=CreateTrigger()
        local trigger tr=CreateTrigger()
        call TriggerAddCondition(t, Condition(start))
        call TriggerRegisterTimerEvent(tr, time, false)
        call SaveReal(UnitTestFramwork___HASH_UNITTEST, GetHandleId(tr), 1, time)
        call SaveReal(UnitTestFramwork___HASH_UNITTEST, GetHandleId(tr), 2, duration)
        call SaveTriggerHandle(UnitTestFramwork___HASH_UNITTEST, GetHandleId(tr), 3, t)
        call TriggerAddCondition(tr, Condition(function UnitTestFramwork___anon__0))
        if ( end != null ) then
            set t=CreateTrigger()
            set tr=CreateTrigger()
            call TriggerAddCondition(t, Condition(end))
            call TriggerRegisterTimerEvent(tr, time + duration, false)
            call SaveReal(UnitTestFramwork___HASH_UNITTEST, GetHandleId(tr), 1, time)
            call SaveReal(UnitTestFramwork___HASH_UNITTEST, GetHandleId(tr), 2, duration)
            call SaveTriggerHandle(UnitTestFramwork___HASH_UNITTEST, GetHandleId(tr), 3, t)
            call TriggerAddCondition(tr, Condition(function UnitTestFramwork___anon__1))
        endif
        set tr=null
        set t=null
    endfunction
        function UnitTestFramwork___anon__2 takes nothing returns nothing
            local integer i
            set i=1
            loop
            exitwhen ( i > 12 )
                call SetPlayerName(ConvertedPlayer(i), "测试员" + I2S(i) + "号") //迷雾全关
                call CreateFogModifierRectBJ(true, ConvertedPlayer(i), FOG_OF_WAR_VISIBLE, bj_mapInitialPlayableArea)
            set i=i + 1
            endloop
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
    function UnitTestFramwork___onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr, 0.1, false)
        call TriggerAddCondition(tr, Condition(function UnitTestFramwork___anon__2))
        set tr=null
        set UnitTestFramwork___TUnitTest=CreateTrigger()
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest, Player(0), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest, Player(1), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest, Player(2), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest, Player(3), "", false)
    endfunction

//library UnitTestFramwork ends
//library YDLua:

    function initializeLua takes nothing returns integer
        call Cheat("exec-lua:plugin_main")
        return 0
    endfunction
        function YDLua___anon__0 takes nothing returns nothing
            call BJDebugMsg("调用了YDLua引擎")
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
    function YDLua___onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr, 0.0, false)
        call TriggerAddCondition(tr, Condition(function YDLua___anon__0))
        set tr=null
    endfunction

//library YDLua ends
//library YDWEAbilityState:











 function YDWEGetUnitAbilityState takes unit u,integer abilcode,integer state_type returns real
		return EXGetAbilityState(EXGetUnitAbility(u, abilcode), state_type)
	endfunction
 function YDWEGetUnitAbilityDataInteger takes unit u,integer abilcode,integer level,integer data_type returns integer
		return EXGetAbilityDataInteger(EXGetUnitAbility(u, abilcode), level, data_type)
	endfunction
 function YDWEGetUnitAbilityDataReal takes unit u,integer abilcode,integer level,integer data_type returns real
		return EXGetAbilityDataReal(EXGetUnitAbility(u, abilcode), level, data_type)
	endfunction
 function YDWEGetUnitAbilityDataString takes unit u,integer abilcode,integer level,integer data_type returns string
		return EXGetAbilityDataString(EXGetUnitAbility(u, abilcode), level, data_type)
	endfunction
 function YDWESetUnitAbilityState takes unit u,integer abilcode,integer state_type,real value returns boolean
		return EXSetAbilityState(EXGetUnitAbility(u, abilcode), state_type, value)
	endfunction
 function YDWESetUnitAbilityDataInteger takes unit u,integer abilcode,integer level,integer data_type,integer value returns boolean
		return EXSetAbilityDataInteger(EXGetUnitAbility(u, abilcode), level, data_type, value)
	endfunction
 function YDWESetUnitAbilityDataReal takes unit u,integer abilcode,integer level,integer data_type,real value returns boolean
		return EXSetAbilityDataReal(EXGetUnitAbility(u, abilcode), level, data_type, value)
	endfunction
 function YDWESetUnitAbilityDataString takes unit u,integer abilcode,integer level,integer data_type,string value returns boolean
		return EXSetAbilityDataString(EXGetUnitAbility(u, abilcode), level, data_type, value)
	endfunction

 function YDWEUnitTransform takes unit u,integer abilcode,integer targetid returns nothing
		call UnitAddAbility(u, abilcode)
		call EXSetAbilityDataInteger(EXGetUnitAbility(u, abilcode), 1, YDWEAbilityState___ABILITY_DATA_UNITID, GetUnitTypeId(u))
		call EXSetAbilityAEmeDataA(EXGetUnitAbility(u, abilcode), GetUnitTypeId(u))
		call UnitRemoveAbility(u, abilcode)
		call UnitAddAbility(u, abilcode)
		call EXSetAbilityAEmeDataA(EXGetUnitAbility(u, abilcode), targetid)
		call UnitRemoveAbility(u, abilcode)
	endfunction


 function YDWEGetItemDataString takes integer itemcode,integer data_type returns string
		return EXGetItemDataString(itemcode, data_type)
	endfunction
 function YDWESetItemDataString takes integer itemcode,integer data_type,string value returns boolean
		return EXSetItemDataString(itemcode, data_type, value)
	endfunction

//library YDWEAbilityState ends
//library Hardware:
        function s__hardware_regLeftUpEvent takes code func returns nothing
            call DzTriggerRegisterMouseEventByCode(null, 1, 0, false, func)
        endfunction  // 注册一个左键按下事件
        function s__hardware_regLeftDownEvent takes code func returns nothing
            call DzTriggerRegisterMouseEventByCode(null, 1, 1, false, func)
        endfunction  // 注册一个右键按下事件
        function s__hardware_regRightDownEvent takes code func returns nothing
            call DzTriggerRegisterMouseEventByCode(null, 2, 1, false, func)
        endfunction  // 注册一个右键抬起事件
        function s__hardware_regRightUpEvent takes code func returns nothing
            call DzTriggerRegisterMouseEventByCode(null, 2, 0, false, func)
        endfunction  // 注册一个滚轮事件,不能异步注册
        function s__hardware_regWheelEvent takes code func returns nothing
            if ( s__hardware_trWheel == null ) then
                set s__hardware_trWheel=CreateTrigger()
            endif
            call TriggerAddCondition(s__hardware_trWheel, Condition(func))
        endfunction  // 注册一个绘制事件,不能异步注册
        function s__hardware_regUpdateEvent takes code func returns nothing
            if ( s__hardware_trUpdate == null ) then
                set s__hardware_trUpdate=CreateTrigger()
            endif
            call TriggerAddCondition(s__hardware_trUpdate, Condition(func))
        endfunction  // 注册一个窗口变化事件,不能异步注册
        function s__hardware_regResizeEvent takes code func returns nothing
            if ( s__hardware_trResize == null ) then
                set s__hardware_trResize=CreateTrigger()
            endif
            call TriggerAddCondition(s__hardware_trResize, Condition(func))
        endfunction  // 注册一个鼠标移动事件,不能异步注册
        function s__hardware_regMoveEvent takes code func returns nothing
            call BJDebugMsg("注册鼠标移动事件")
            if ( s__hardware_trMove == null ) then
                set s__hardware_trMove=CreateTrigger()
            endif
            call TriggerAddCondition(s__hardware_trMove, Condition(func))
        endfunction  // 获取鼠标的实数坐标X(0-0.8)
        function s__hardware_getMouseX takes nothing returns real
            local integer width=DzGetClientWidth()
            if ( width > 0 ) then
                return DzGetMouseXRelative() * 0.8 / width
            else
                return 0.1
            endif
        endfunction  // 获取鼠标的实数坐标Y(0-0.6)
        function s__hardware_getMouseY takes nothing returns real
            local integer height=DzGetClientHeight()
            if ( height > 0 ) then // 防止除以0
                return 0.6 - DzGetMouseYRelative() * 0.6 / height
            else
                return 0.1
            endif
        endfunction
        //private:
            function s__hardware_anon__0 takes nothing returns nothing
                call TriggerEvaluate(s__hardware_trWheel)
            endfunction  // 帧绘制事件
            function s__hardware_anon__1 takes nothing returns nothing
                call TriggerEvaluate(s__hardware_trUpdate)
            endfunction  // 窗口大小变化事件
            function s__hardware_anon__2 takes nothing returns nothing
                call TriggerEvaluate(s__hardware_trResize)
            endfunction  // 鼠标移动事件
            function s__hardware_anon__3 takes nothing returns nothing
                call TriggerEvaluate(s__hardware_trMove)
            endfunction
        function s__hardware_onInit takes nothing returns nothing
            call DzTriggerRegisterMouseWheelEventByCode(null, false, function s__hardware_anon__0)
            call DzFrameSetUpdateCallbackByCode(function s__hardware_anon__1)
            call DzTriggerRegisterWindowResizeEventByCode(null, false, function s__hardware_anon__2)
            call DzTriggerRegisterMouseMoveEventByCode(null, false, function s__hardware_anon__3)
        endfunction

//library Hardware ends
//library Logger:

    function Trace takes string msg returns nothing
        set logger_msg=msg
        set logger_level=0
        set logger_p=GetLocalPlayer()
        call TriggerEvaluate(logger_tr)
    endfunction  // 调试级别日志(绿色),用于输出变量值等调试信息
    function Debug takes string msg returns nothing
        set logger_msg=msg
        set logger_level=1
        set logger_p=GetLocalPlayer()
        call TriggerEvaluate(logger_tr)
    endfunction  // 信息级别日志(白色),用于输出普通提示信息
    function Info takes string msg returns nothing
        set logger_msg=msg
        set logger_level=2
        set logger_p=GetLocalPlayer()
        call TriggerEvaluate(logger_tr)
    endfunction  // 警告级别日志(黄色),用于输出警告信息
    function Warn takes string msg returns nothing
        set logger_msg=msg
        set logger_level=3
        set logger_p=GetLocalPlayer()
        call TriggerEvaluate(logger_tr)
    endfunction  // 错误级别日志(红色),用于输出错误信息
    function Error takes string msg returns nothing
        set logger_msg=msg
        set logger_level=4
        set logger_p=GetLocalPlayer()
        call TriggerEvaluate(logger_tr)
    endfunction  // 向指定玩家输出追踪日志(灰色)
    function TraceToPlayer takes player p,string msg returns nothing
        set logger_msg=msg
        set logger_level=0
        set logger_p=p
        call TriggerEvaluate(logger_tr)
    endfunction  // 向指定玩家输出调试日志(绿色)
    function DebugToPlayer takes player p,string msg returns nothing
        set logger_msg=msg
        set logger_level=1
        set logger_p=p
        call TriggerEvaluate(logger_tr)
    endfunction  // 向指定玩家输出信息日志(白色)
    function InfoToPlayer takes player p,string msg returns nothing
        set logger_msg=msg
        set logger_level=2
        set logger_p=p
        call TriggerEvaluate(logger_tr)
    endfunction  // 向指定玩家输出警告日志(黄色)
    function WarnToPlayer takes player p,string msg returns nothing
        set logger_msg=msg
        set logger_level=3
        set logger_p=p
        call TriggerEvaluate(logger_tr)
    endfunction  // 向指定玩家输出错误日志(红色)
    function ErrorToPlayer takes player p,string msg returns nothing
        set logger_msg=msg
        set logger_level=4
        set logger_p=p
        call TriggerEvaluate(logger_tr)
    endfunction
    function Logger___onInit takes nothing returns nothing
        call Cheat("exec-lua:depends.debug.logger")
    endfunction

//library Logger ends
//library UTSpell:

        function UTSpell___anon__0 takes nothing returns nothing
            set UTSpell___sd[1]=s__spellData_byType('A001')
        endfunction  //end
        function UTSpell___anon__1 takes nothing returns nothing
        endfunction
        function UTSpell___anon__2 takes nothing returns nothing
        endfunction  //spell
        function UTSpell___anon__3 takes nothing returns nothing
            local unit u=s__unitSelect_argsSync //DzUnitFindAbility获取正常Handle技能,未学习的技能没有Handle,学习后的Handle不是最大的(代表不是新建的) //AInv这个物品栏技能不知道为什么步兵也有 
            local integer index
            local ability a=null
            local ability b=null
            call Trace("已选择单位:" + GetUnitName(u) + "(" + I2S(GetHandleId(u)) + ")")
            set b=DzUnitFindAbility(u, 'AHbz')
            call Trace(" AHbz: " + I2S(GetHandleId(b)))
            set b=DzUnitFindAbility(u, 'AHab')
            call Trace(" AHab: " + I2S(GetHandleId(b)))
            set b=DzUnitFindAbility(u, 'AHwe')
            call Trace(" AHwe: " + I2S(GetHandleId(b)))
            set b=DzUnitFindAbility(u, 'AHmt')
            call Trace(" AHmt: " + I2S(GetHandleId(b)))
            set b=DzUnitFindAbility(u, 'AInv')
            call Trace(" AInv: " + I2S(GetHandleId(b)))
            set b=DzUnitFindAbility(u, 'Adef')
            call Trace(" Adef: " + I2S(GetHandleId(b)))
            set u=null
        endfunction
    function UTSpell___Init takes nothing returns nothing
        call UnitTestAutoTimer(0.1 , 2.0 , function UTSpell___anon__0 , function UTSpell___anon__1)
        call UnitTestAutoTimer(0.1 , 2.0 , function UTSpell___anon__2 , null)
        call sc__unitSelect_onSync(function UTSpell___anon__3)
    endfunction  //测试一下Japi获取的技能
    function UTSpell___TTestUTSpell1 takes player p returns nothing
        set UTSpell___testArchmage=CreateUnit(p, 'Hamg', 0, 0, 270) // 在(200,0)位置创建步兵
        set UTSpell___testFootman=CreateUnit(p, 'hfoo', 200, 0, 270) // 将大法师升到10级
        call SetHeroLevel(UTSpell___testArchmage, 10, true)
        call Trace("已创建大法师和步兵用于测试")
    endfunction
    function UTSpell___TTestUTSpell2 takes player p returns nothing
        if ( UTSpell___testFootman != null ) then // 移除防御技能
            call UnitRemoveAbility(UTSpell___testFootman, 'Adef')
            call Trace("已移除步兵的防御技能")
        else
            call Trace("错误：请先使用s1创建测试单位")
        endif
    endfunction
    function UTSpell___TTestUTSpell3 takes player p returns nothing
        if ( UTSpell___testFootman != null ) then // 添加防御技能
            call UnitAddAbility(UTSpell___testFootman, 'Adef')
            call Trace("已给步兵添加防御技能")
        else
            call Trace("错误：请先使用s1创建测试单位")
        endif
    endfunction
        function UTSpell___anon__4 takes nothing returns nothing
            local timer t=GetExpiredTimer()
            local integer id=GetHandleId(t)
            local integer testCount=LoadInteger(HASH_TIMER, id, 1)
            local integer abilityId
            local unit testUnit
            local integer i
            if ( testCount <= 100 ) then
                set testUnit=CreateUnit(Player(0), 'hfoo', 0, 0, 270)
                call Trace("第" + I2S(testCount) + "个单位的测试结果:") // 先测试1-5的普通值
                call Trace("普通值测试结果:")
                set i=1
                loop
                exitwhen ( i > 5 )
                    call Trace("数值" + I2S(i) + "的HashValue: " + I2S(GetHashValue(GetHandleId(testUnit) , i)))
                set i=i + 1
                endloop // 再测试所有技能
                call Trace("技能测试结果:")
                set i=0
                loop
                exitwhen ( i >= 30 )
                    set abilityId=LoadInteger(HASH_TIMER, id, 100 + i)
                    call Trace("技能" + GetAbilityName(abilityId) + "的HashValue: " + I2S(GetHashValue(GetHandleId(testUnit) , abilityId)))
                set i=i + 1
                endloop
                set testCount=testCount + 1
                call SaveInteger(HASH_TIMER, id, 1, testCount)
            else
                call Trace("测试完成！")
                call PauseTimer(t)
                call FlushChildHashtable(HASH_TIMER, id)
                call DestroyTimer(t)
            endif
            set t=null
        endfunction
    function UTSpell___TTestUTSpell4 takes player p returns nothing
        local timer t
        set t=CreateTimer()
        call SaveInteger(HASH_TIMER, GetHandleId(t), 1, 1)
        call SaveInteger(HASH_TIMER, GetHandleId(t), 100, 'AAns')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 101, 'ACac')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 102, 'ACad')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 103, 'ACah')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 104, 'ACam')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 105, 'ACat')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 106, 'ACav')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 107, 'ACba')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 108, 'ACbb')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 109, 'ACbc')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 110, 'ACbf')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 111, 'ACbh')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 112, 'ACbk')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 113, 'ACbl')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 114, 'ACbn')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 115, 'ACbz')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 116, 'ACc2')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 117, 'ACc3')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 118, 'ACca')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 119, 'ACcb')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 120, 'ACce')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 121, 'ACch')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 122, 'ACcl')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 123, 'ACcn')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 124, 'ACcr')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 125, 'ACcs')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 126, 'ACct')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 127, 'ACcv')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 128, 'ACcw')
        call SaveInteger(HASH_TIMER, GetHandleId(t), 129, 'ACcy')
        call TimerStart(t, 0.1, true, function UTSpell___anon__4)
        set t=null
    endfunction
        function UTSpell___anon__5 takes nothing returns nothing
            local unit u=GetEnumUnit()
            local integer sp1=s__spell_get(u , 'A001')
            if ( s__spell_isExist(sp1) ) then
                call s__spell_deallocate(sp1)
            endif
            set u=null
        endfunction
    function UTSpell___TTestUTSpell5 takes player p returns nothing
        local integer i
        local unit u
        local group g
        local integer sp1
        set g=CreateGroup()
        call GroupEnumUnitsInRect(g, bj_mapInitialPlayableArea, null)
        call ForGroup(g, function UTSpell___anon__5)
        call DestroyGroup(g)
        set g=null
        call Trace("已清理所有技能实例")
        if ( UTSpell___toggle5 ) then
        else
        endif
        set UTSpell___toggle5=not UTSpell___toggle5
    endfunction
        function UTSpell___anon__6 takes nothing returns nothing
            call Trace("技能ID:" + I2S(s__spell_ethis) + "被销毁了(群)")
        endfunction
    function UTSpell___TTestUTSpell6 takes player p returns nothing
        local integer i
        local unit u
        local group g
        local integer sp1
        call Trace("准备创建 " + I2S(UTSpell___count) + " 个测试单位")
        set i=0
        loop
        exitwhen ( i >= UTSpell___count )
            set u=CreateUnit(p, 'nsm1', GetRandomReal(- 1000, 1000), GetRandomReal(- 1000, 1000), GetRandomReal(0, 360))
            set sp1=s__spell_entity(u , 'A001' , 1)
            call s__spell_registerDestroy(sp1,function UTSpell___anon__6)
            if ( s__spell_isExist(sp1) ) then
                call Trace("创建第 " + I2S(i + 1) + " 个单位的技能实例成功")
            endif
            set u=null
        set i=i + 1
        endloop
        set UTSpell___count=UTSpell___count - 1
        call Trace("完成创建测试单位")
    endfunction
    function UTSpell___TTestUTSpell7 takes player p returns nothing
    endfunction
    function UTSpell___TTestUTSpell8 takes player p returns nothing
    endfunction
    function UTSpell___TTestUTSpell9 takes player p returns nothing
    endfunction
    function UTSpell___TTestUTSpell10 takes player p returns nothing
    endfunction
        function UTSpell___anon__7 takes nothing returns nothing
            call Trace("技能ID:" + I2S(s__spell_ethis) + "被销毁了(独)")
        endfunction
    function UTSpell___TTestActUTSpell1 takes string str returns nothing
        local player p
        local integer index
        local integer i
        local integer num
        local integer len
        local string array paramS
        local integer array paramI
        local real array paramR
        set p=GetTriggerPlayer()
        set index=GetConvertedPlayerId(p)
        set num=0
        set len=StringLength(str)
        set i=0
        loop
        exitwhen ( i > len - 1 )
            if ( SubString(str, i, i + 1) == " " ) then
                set paramS[num]=SubString(str, 0, i)
                set paramI[num]=S2I(paramS[num])
                set paramR[num]=S2R(paramS[num])
                set num=num + 1
                set str=SubString(str, i + 1, len)
                set len=StringLength(str)
                set i=- 1
            endif
        set i=i + 1
        endloop
        set paramS[num]=str
        set paramI[num]=S2I(paramS[num])
        set paramR[num]=S2R(paramS[num])
        set num=num + 1
        if ( paramS[0] == "a" ) then
        elseif ( paramS[0] == "b" ) then
        elseif ( paramS[0] == "destroy" ) then
            if ( UTSpell___sp != 0 ) then
                call s__spell_deallocate(UTSpell___sp)
                set UTSpell___sp=0
                call Trace("已销毁技能结构体sp")
            else
                call Trace("错误：sp已经是空的了")
            endif
        elseif ( paramS[0] == "new" ) then
            if ( UTSpell___sp != 0 ) then
                call s__spell_deallocate(UTSpell___sp)
            endif
            call RemoveUnit(UTSpell___testSpell)
            set UTSpell___testSpell=CreateUnit(Player(0), 'nsm1', 0, 0, 0)
            set UTSpell___sp=s__spell_entity(UTSpell___testSpell , 'A001' , 1)
            call s__spell_registerDestroy(UTSpell___sp,function UTSpell___anon__7)
            call Trace("测试单位创建完成了")
        elseif ( paramS[0] == "remove" ) then // 删除testSpell的'A001'技能
            if ( UTSpell___testSpell != null ) then
                call UnitRemoveAbility(UTSpell___testSpell, 'A001')
                call Trace("已移除testSpell的A001技能")
            else
                call Trace("错误：testSpell不存在，请先创建测试单位")
            endif
        endif
        set p=null
    endfunction
        function UTSpell___anon__8 takes nothing returns nothing
            call BJDebugMsg("[Spell] 单元测试已加载")
            call UTSpell___Init()
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTSpell___anon__9 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            local integer i=1
            if ( SubString(str, ( 1 ) - 1, 1) == "-" ) then
                call UTSpell___TTestActUTSpell1(SubString(str, ( 2 ) - 1, StringLength(str)))
                return
            endif
            if ( str == "s1" ) then
                call UTSpell___TTestUTSpell1(GetTriggerPlayer())
            elseif ( str == "s2" ) then
                call UTSpell___TTestUTSpell2(GetTriggerPlayer())
            elseif ( str == "s3" ) then
                call UTSpell___TTestUTSpell3(GetTriggerPlayer())
            elseif ( str == "s4" ) then
                call UTSpell___TTestUTSpell4(GetTriggerPlayer())
            elseif ( str == "s5" ) then
                call UTSpell___TTestUTSpell5(GetTriggerPlayer())
            elseif ( str == "s6" ) then
                call UTSpell___TTestUTSpell6(GetTriggerPlayer())
            elseif ( str == "s7" ) then
                call UTSpell___TTestUTSpell7(GetTriggerPlayer())
            elseif ( str == "s8" ) then
                call UTSpell___TTestUTSpell8(GetTriggerPlayer())
            elseif ( str == "s9" ) then
                call UTSpell___TTestUTSpell9(GetTriggerPlayer())
            elseif ( str == "s10" ) then
                call UTSpell___TTestUTSpell10(GetTriggerPlayer())
            endif
        endfunction
    function UTSpell___onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr, 0.5, false)
        call TriggerAddCondition(tr, Condition(function UTSpell___anon__8))
        set tr=null
        call UnitTestRegisterChatEvent(function UTSpell___anon__9)
    endfunction

//library UTSpell ends
//library UnitSelect:
        //private:
        function s__unitSelect_onAsync takes code func returns nothing
            call TriggerAddCondition(s__unitSelect_trAsync, Condition(func))
        endfunction  // 异步时取消选择单位调用
        function s__unitSelect_onAsyncUn takes code func returns nothing
            call TriggerAddCondition(s__unitSelect_trAsyncUn, Condition(func))
        endfunction  // 同步时选中单位调用
        function s__unitSelect_onSync takes code func returns nothing
            call TriggerAddCondition(s__unitSelect_trSync, Condition(func))
        endfunction  // 同步时取消选择单位调用
        function s__unitSelect_onSyncUn takes code func returns nothing
            call TriggerAddCondition(s__unitSelect_trSyncUn, Condition(func))
        endfunction  //初始化
            function s__unitSelect_anon__0 takes nothing returns nothing
                local integer index=GetConvertedPlayerId(GetTriggerPlayer())
                if ( GetTriggerUnit() != s__unitSelect_currentU[index] ) then
                    set s__unitSelect_argsSync=s__unitSelect_currentU[index] //事件里用unitSelect.argsSync来指代
                    call TriggerEvaluate(s__unitSelect_trSyncUn)
                    set s__unitSelect_argsSync=GetTriggerUnit() //事件里用unitSelect.argsSync来指代
                    call TriggerEvaluate(s__unitSelect_trSync)
                    set s__unitSelect_currentU[index]=GetTriggerUnit()
                    set s__unitSelect_argsSync=null
                endif
            endfunction  //注册2个事件:选择单位,与不选择事件
            function s__unitSelect_anon__1 takes nothing returns nothing
                if ( DzGetSelectedLeaderUnit() != s__unitSelect_asyncU ) then
                    set s__unitSelect_args=s__unitSelect_asyncU //事件里用unitSelect.args来指代
                    call TriggerEvaluate(s__unitSelect_trAsyncUn)
                    set s__unitSelect_args=DzGetSelectedLeaderUnit() //事件里用unitSelect.args来指代
                    call TriggerEvaluate(s__unitSelect_trAsync)
                    set s__unitSelect_asyncU=DzGetSelectedLeaderUnit()
                    set s__unitSelect_args=null
                endif
            endfunction
        function s__unitSelect_onInit takes nothing returns nothing
            local integer i
            local trigger tr=CreateTrigger()
            set s__unitSelect_trAsync=CreateTrigger()
            set s__unitSelect_trAsyncUn=CreateTrigger()
            set s__unitSelect_trSync=CreateTrigger()
            set s__unitSelect_trSyncUn=CreateTrigger()
            set i=1
            loop
            exitwhen ( i > 12 )
                call TriggerRegisterPlayerSelectionEventBJ(tr, ConvertedPlayer(i), true)
            set i=i + 1
            endloop
            call TriggerAddCondition(tr, Condition(function s__unitSelect_anon__0))
            call s__hardware_regUpdateEvent(function s__unitSelect_anon__1)
        endfunction

//library UnitSelect ends
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerSelectionEventBJ.h>
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerKeyEventBJ.h>
//#  define TriggerRegisterPlayerUnitEventSimple(trig, p, e)                 TriggerRegisterPlayerUnitEvent(trig, p, e, null)
//#  define TriggerRegisterPlayerEventVictory(trig, player)                  TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_VICTORY)
//#  define TriggerRegisterPlayerEventDefeat(trig, player)                   TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_DEFEAT)
//#  define TriggerRegisterPlayerEventLeave(trig, player)                    TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_LEAVE)
//#  define TriggerRegisterPlayerEventAllianceChanged(trig, player)          TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_ALLIANCE_CHANGED)
//#  define TriggerRegisterPlayerEventEndCinematic(trig, player)             TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_END_CINEMATIC)
// 原生UI的大小

// 常用哈希表

// 物品掉落相关键值 (预留20个空间 1800-1819/1820-1839)  MonsterData
// 技能相关键值 (预留200个空间 2000-2199) UnitData
// 2400开始可继续添加新的键值定义...
// 结构体共用方法定义
//共享打印方法
// UI组件内部共享方法及成员
// UI组件依赖库
// UI组件创建时共享调用
// UI组件销毁时共享调用

// hook UnitRemoveAbility spell.RemoveHook

// 0 - 1亿这里用
// 锚点常量
// 事件常量
//鼠标点击事件
//Index名:
//默认原生图片路径
//模板名
//TEXT对齐常量:(uiText.setAlign)
// [DzSetUnitMoveType]  
// title = "设置单位移动类型[NEW]"  
// description = "设置 ${单位} 的移动类型：${movetype} "  
// comment = ""  
// category = TC_KKPRE  
// [[.args]]  
// type = unit  
// [[.args]]  
// type = MoveTypeName  
// default = MoveTypeName01  
//===========================================================================
//
// - |cff00ff00单元测试地图|r -
//
//   Warcraft III map script
//   Generated by the Warcraft III World Editor
//   Date: Sun Nov 27 05:00:30 2022
//   Map Author: Crainax
//
//===========================================================================
//***************************************************************************
//*
//*  Global Variables
//*
//***************************************************************************
function InitGlobals takes nothing returns nothing
endfunction
//***************************************************************************
//*
//*  Unit Creation
//*
//***************************************************************************
//===========================================================================
function CreateBuildingsForPlayer8 takes nothing returns nothing
    local player p= Player(8)
    local unit u
    local integer unitID
    local trigger t
    local real life
    set gg_unit_hcas_0011=CreateUnit(p, 'hcas', - 64.0, - 1984.0, 270.000)
endfunction
//===========================================================================
function CreatePlayerBuildings takes nothing returns nothing
    call CreateBuildingsForPlayer8()
endfunction
//===========================================================================
function CreatePlayerUnits takes nothing returns nothing
endfunction
//===========================================================================
function CreateAllUnits takes nothing returns nothing
    call CreatePlayerBuildings()
    call CreatePlayerUnits()
endfunction
//***************************************************************************
//*
//*  Regions
//*
//***************************************************************************
function CreateRegions takes nothing returns nothing
    local weathereffect we
    set gg_rct_Wave1=Rect(- 5088.0, 3168.0, - 4448.0, 3968.0)
    set gg_rct_Wave2=Rect(- 1568.0, 3360.0, - 928.0, 4160.0)
    set gg_rct_Wave3=Rect(1312.0, 3584.0, 1952.0, 4384.0)
    set gg_rct_Wave4=Rect(4320.0, 3232.0, 4960.0, 4032.0)
    set gg_rct_Base=Rect(- 320.0, - 2304.0, 192.0, - 1664.0)
    set gg_rct_BaseBack=Rect(- 320.0, - 3328.0, 160.0, - 2848.0)
    set gg_rct_Home1=Rect(- 10496.0, 1440.0, - 8128.0, 3776.0)
    set gg_rct_Home2=Rect(7712.0, 1568.0, 10080.0, 3904.0)
    set gg_rct_Home3=Rect(- 10464.0, - 3680.0, - 8096.0, - 1344.0)
    set gg_rct_Home4=Rect(7712.0, - 3552.0, 10080.0, - 1216.0)
    set gg_rct_Fuben1=Rect(- 11872.0, 7968.0, - 8224.0, 11584.0)
    set gg_rct_Fuben2=Rect(- 5472.0, 8000.0, - 1824.0, 11616.0)
    set gg_rct_Fuben3=Rect(1184.0, 8000.0, 4832.0, 11616.0)
    set gg_rct_Fuben4=Rect(7712.0, 7968.0, 11360.0, 11584.0)
    set gg_rct_Fuben5=Rect(- 11872.0, - 11328.0, - 8224.0, - 7712.0)
    set gg_rct_Fuben6=Rect(- 5472.0, - 11328.0, - 1824.0, - 7712.0)
    set gg_rct_Fuben7=Rect(1184.0, - 11328.0, 4832.0, - 7712.0)
    set gg_rct_Fuben8=Rect(7712.0, - 11328.0, 11360.0, - 7712.0)
endfunction
//***************************************************************************
//*
//*  Custom Script Code
//*
//***************************************************************************
//TESH.scrollpos=0
//TESH.alwaysfold=0
// 当前构建版本
// 当前的平台分包
    // 单元测试
    // lua_print: 单元测试
//这两条是用到YDWE函数就要导入的,没用到就不用导入
// 原生UI的大小
//函数入口
// 用原始地图测试
// 用空地图测试
// 用原始地图测试
// lua_print: 空白地图
//***************************************************************************
//*
//*  Triggers
//*
//***************************************************************************
//===========================================================================
// Trigger: 简介
//===========================================================================
function Trig_______uActions takes nothing returns nothing
    // 欢迎使用世界编辑器，开始你的地图创造之旅。
    // 你可以从dz.163.com获取最新编辑器咨询。
    // 当你的地图意外损坏时，你可以在backups目录找到你最近26次保存的地图。
    // 任何疑问请加官方作者群：QQ35063417。
    // 本次更新添加判断玩家是否为平台AI玩家，现在平台已经添加虚拟玩家，不用再担心匹配没人问题了！如果你的地图有AI，试试在作者之家开启这个功能吧！
endfunction
//===========================================================================
function InitTrig_______u takes nothing returns nothing
    set gg_trg_______u=CreateTrigger()
    call DoNothing()
    call TriggerAddAction(gg_trg_______u, function Trig_______uActions)
endfunction
//===========================================================================
function InitCustomTriggers takes nothing returns nothing
    call InitTrig_______u()
endfunction
//***************************************************************************
//*
//*  Players
//*
//***************************************************************************
function InitCustomPlayerSlots takes nothing returns nothing
    // Player 0
    call SetPlayerStartLocation(Player(0), 0)
    call ForcePlayerStartLocation(Player(0), 0)
    call SetPlayerColor(Player(0), ConvertPlayerColor(0))
    call SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(0), false)
    call SetPlayerController(Player(0), MAP_CONTROL_USER)
    // Player 1
    call SetPlayerStartLocation(Player(1), 1)
    call ForcePlayerStartLocation(Player(1), 1)
    call SetPlayerColor(Player(1), ConvertPlayerColor(1))
    call SetPlayerRacePreference(Player(1), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(1), false)
    call SetPlayerController(Player(1), MAP_CONTROL_USER)
    // Player 2
    call SetPlayerStartLocation(Player(2), 2)
    call ForcePlayerStartLocation(Player(2), 2)
    call SetPlayerColor(Player(2), ConvertPlayerColor(2))
    call SetPlayerRacePreference(Player(2), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(2), false)
    call SetPlayerController(Player(2), MAP_CONTROL_USER)
    // Player 3
    call SetPlayerStartLocation(Player(3), 3)
    call ForcePlayerStartLocation(Player(3), 3)
    call SetPlayerColor(Player(3), ConvertPlayerColor(3))
    call SetPlayerRacePreference(Player(3), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(3), false)
    call SetPlayerController(Player(3), MAP_CONTROL_USER)
    // Player 4
    call SetPlayerStartLocation(Player(4), 4)
    call ForcePlayerStartLocation(Player(4), 4)
    call SetPlayerColor(Player(4), ConvertPlayerColor(4))
    call SetPlayerRacePreference(Player(4), RACE_PREF_NIGHTELF)
    call SetPlayerRaceSelectable(Player(4), false)
    call SetPlayerController(Player(4), MAP_CONTROL_COMPUTER)
    // Player 5
    call SetPlayerStartLocation(Player(5), 5)
    call ForcePlayerStartLocation(Player(5), 5)
    call SetPlayerColor(Player(5), ConvertPlayerColor(5))
    call SetPlayerRacePreference(Player(5), RACE_PREF_NIGHTELF)
    call SetPlayerRaceSelectable(Player(5), false)
    call SetPlayerController(Player(5), MAP_CONTROL_COMPUTER)
    // Player 6
    call SetPlayerStartLocation(Player(6), 6)
    call ForcePlayerStartLocation(Player(6), 6)
    call SetPlayerColor(Player(6), ConvertPlayerColor(6))
    call SetPlayerRacePreference(Player(6), RACE_PREF_NIGHTELF)
    call SetPlayerRaceSelectable(Player(6), false)
    call SetPlayerController(Player(6), MAP_CONTROL_COMPUTER)
    // Player 7
    call SetPlayerStartLocation(Player(7), 7)
    call ForcePlayerStartLocation(Player(7), 7)
    call SetPlayerColor(Player(7), ConvertPlayerColor(7))
    call SetPlayerRacePreference(Player(7), RACE_PREF_NIGHTELF)
    call SetPlayerRaceSelectable(Player(7), false)
    call SetPlayerController(Player(7), MAP_CONTROL_COMPUTER)
    // Player 8
    call SetPlayerStartLocation(Player(8), 8)
    call ForcePlayerStartLocation(Player(8), 8)
    call SetPlayerColor(Player(8), ConvertPlayerColor(8))
    call SetPlayerRacePreference(Player(8), RACE_PREF_NIGHTELF)
    call SetPlayerRaceSelectable(Player(8), false)
    call SetPlayerController(Player(8), MAP_CONTROL_COMPUTER)
    // Player 9
    call SetPlayerStartLocation(Player(9), 9)
    call ForcePlayerStartLocation(Player(9), 9)
    call SetPlayerColor(Player(9), ConvertPlayerColor(9))
    call SetPlayerRacePreference(Player(9), RACE_PREF_UNDEAD)
    call SetPlayerRaceSelectable(Player(9), false)
    call SetPlayerController(Player(9), MAP_CONTROL_COMPUTER)
    // Player 10
    call SetPlayerStartLocation(Player(10), 10)
    call ForcePlayerStartLocation(Player(10), 10)
    call SetPlayerColor(Player(10), ConvertPlayerColor(10))
    call SetPlayerRacePreference(Player(10), RACE_PREF_UNDEAD)
    call SetPlayerRaceSelectable(Player(10), false)
    call SetPlayerController(Player(10), MAP_CONTROL_COMPUTER)
    // Player 11
    call SetPlayerStartLocation(Player(11), 11)
    call ForcePlayerStartLocation(Player(11), 11)
    call SetPlayerColor(Player(11), ConvertPlayerColor(11))
    call SetPlayerRacePreference(Player(11), RACE_PREF_UNDEAD)
    call SetPlayerRaceSelectable(Player(11), false)
    call SetPlayerController(Player(11), MAP_CONTROL_COMPUTER)
endfunction
function InitCustomTeams takes nothing returns nothing
    // Force: TRIGSTR_013
    call SetPlayerTeam(Player(0), 0)
    call SetPlayerTeam(Player(1), 0)
    call SetPlayerTeam(Player(2), 0)
    call SetPlayerTeam(Player(3), 0)
    call SetPlayerTeam(Player(4), 0)
    call SetPlayerTeam(Player(5), 0)
    call SetPlayerTeam(Player(6), 0)
    call SetPlayerTeam(Player(7), 0)
    call SetPlayerTeam(Player(8), 0)
    //   Allied
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(7), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(7), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(7), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(7), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(7), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(7), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(7), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(7), true)
    //   Shared Vision
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(7), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(7), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(7), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(7), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(7), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(7), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(7), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(7), true)
    // Force: TRIGSTR_014
    call SetPlayerTeam(Player(9), 1)
    call SetPlayerTeam(Player(10), 1)
    call SetPlayerTeam(Player(11), 1)
    //   Allied
    call SetPlayerAllianceStateAllyBJ(Player(9), Player(10), true)
    call SetPlayerAllianceStateAllyBJ(Player(9), Player(11), true)
    call SetPlayerAllianceStateAllyBJ(Player(10), Player(9), true)
    call SetPlayerAllianceStateAllyBJ(Player(10), Player(11), true)
    call SetPlayerAllianceStateAllyBJ(Player(11), Player(9), true)
    call SetPlayerAllianceStateAllyBJ(Player(11), Player(10), true)
    //   Shared Vision
    call SetPlayerAllianceStateVisionBJ(Player(9), Player(10), true)
    call SetPlayerAllianceStateVisionBJ(Player(9), Player(11), true)
    call SetPlayerAllianceStateVisionBJ(Player(10), Player(9), true)
    call SetPlayerAllianceStateVisionBJ(Player(10), Player(11), true)
    call SetPlayerAllianceStateVisionBJ(Player(11), Player(9), true)
    call SetPlayerAllianceStateVisionBJ(Player(11), Player(10), true)
endfunction
function InitAllyPriorities takes nothing returns nothing
    call SetStartLocPrioCount(0, 3)
    call SetStartLocPrio(0, 0, 1, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(0, 1, 2, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(0, 2, 3, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrioCount(1, 3)
    call SetStartLocPrio(1, 0, 0, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(1, 1, 2, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(1, 2, 3, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrioCount(2, 3)
    call SetStartLocPrio(2, 0, 0, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(2, 1, 1, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(2, 2, 3, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrioCount(3, 3)
    call SetStartLocPrio(3, 0, 0, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(3, 1, 1, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(3, 2, 2, MAP_LOC_PRIO_HIGH)
endfunction
//***************************************************************************
//*
//*  Main Initialization
//*
//***************************************************************************
//===========================================================================
function main takes nothing returns nothing
    call initializeLua()
 call SetCameraBounds(- 13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), - 13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), - 13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), - 13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    call NewSoundEnvironment("Default")
    call SetAmbientDaySound("NorthrendDay")
    call SetAmbientNightSound("NorthrendNight")
    call SetMapMusic("Music", true, 0)
    call CreateRegions()
    call CreateAllUnits()
    call InitBlizzard()

call ExecuteFunc("jasshelper__initstructs12241906")
call ExecuteFunc("UnitTestFramwork___onInit")
call ExecuteFunc("YDLua___onInit")
call ExecuteFunc("Logger___onInit")
call ExecuteFunc("UTSpell___onInit")

    call InitGlobals()
    call InitCustomTriggers()
endfunction
//***************************************************************************
//*
//*  Map Configuration
//*
//***************************************************************************
function config takes nothing returns nothing
    call SetMapName("TRIGSTR_1232")
    call SetMapDescription("TRIGSTR_1234")
    call SetPlayers(12)
    call SetTeams(12)
    call SetGamePlacement(MAP_PLACEMENT_TEAMS_TOGETHER)
    call DefineStartLocation(0, 0.0, 0.0)
    call DefineStartLocation(1, 0.0, 0.0)
    call DefineStartLocation(2, 0.0, 0.0)
    call DefineStartLocation(3, 0.0, 0.0)
    call DefineStartLocation(4, 0.0, 0.0)
    call DefineStartLocation(5, 0.0, 0.0)
    call DefineStartLocation(6, 0.0, 0.0)
    call DefineStartLocation(7, 0.0, 0.0)
    call DefineStartLocation(8, 0.0, 0.0)
    call DefineStartLocation(9, 0.0, 0.0)
    call DefineStartLocation(10, 0.0, 0.0)
    call DefineStartLocation(11, 0.0, 0.0)
    // Player setup
    call InitCustomPlayerSlots()
    call InitCustomTeams()
    call InitAllyPriorities()
endfunction




//Struct method generated initializers/callers:
function sa__spell_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            if ( not ( s__spell_isExist(this) ) ) then
return true
            endif
            if ( s__spell_trDestroy[this] != null ) then
                set s__spell_ethis=this
                call TriggerEvaluate(s__spell_trDestroy[this])
                call DestroyTrigger(s__spell_trDestroy[this])
                set s__spell_trDestroy[this]=null
            endif //虚拟技能
            if ( s__spell_spellType[this] == SPELL_TYPE_VIRTUAL ) then
                if ( HaveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(s__spell_u[this]) , s__spell_sd[this]), 15) ) then
                    call RemoveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(s__spell_u[this]) , s__spell_sd[this]), 15)
                endif //有ID的技能
            elseif ( HaveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(s__spell_u[this]) , s__spell_id[this]), 15) ) then
                call RemoveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(s__spell_u[this]) , s__spell_id[this]), 15)
            endif
            if ( s__spell_id[this] != 0 ) then
                call UnitRemoveAbility(s__spell_u[this], s__spell_id[this])
            endif
            set s__spell_u[this]=null
            set s__spell_id[this]=0
            set s__spell_sd[this]=0
   return true
endfunction
function sa__unitSelect_onSync takes nothing returns boolean
local code func=f__arg_code1
            call TriggerAddCondition(s__unitSelect_trSync, Condition(func))
   return true
endfunction
function sa__spellData_byType takes nothing returns boolean
local integer at=f__arg_integer1
            local integer this
            if ( HaveSavedInteger(HASH_SLK, at, 1727) ) then
                set this=LoadInteger(HASH_SLK, at, 1727)
            else
                set s__spellData_counter=s__spellData_counter + 1
                set this=(s__spellData_counter)
                call SaveInteger(HASH_SLK, at, 1727, this)
                set s__spellData_id[this]=at //默认最大等级1级
                set s__spellData_maxLevel[this]=1
            endif
set f__result_integer= this
   return true
endfunction

function jasshelper__initstructs12241906 takes nothing returns nothing
    set st__spell_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__spell_onDestroy,Condition( function sa__spell_onDestroy))
    set st__unitSelect_onSync=CreateTrigger()
    call TriggerAddCondition(st__unitSelect_onSync,Condition( function sa__unitSelect_onSync))
    set st__spellData_byType=CreateTrigger()
    call TriggerAddCondition(st__spellData_byType,Condition( function sa__spellData_byType))






    call ExecuteFunc("s__hardware_onInit")
    call ExecuteFunc("s__unitSelect_onInit")
endfunction

