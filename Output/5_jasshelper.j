globals
//globals from BzAPI:
constant boolean LIBRARY_BzAPI=true
//endglobals from BzAPI
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
//globals from MapBoundsUtils:
constant boolean LIBRARY_MapBoundsUtils=true
//endglobals from MapBoundsUtils
//globals from MathUtils:
constant boolean LIBRARY_MathUtils=true
//endglobals from MathUtils
//globals from UIEventModule:
constant boolean LIBRARY_UIEventModule=true
//endglobals from UIEventModule
//globals from UIHashTable:
constant boolean LIBRARY_UIHashTable=true
hashtable HASH_UI=InitHashtable()
//endglobals from UIHashTable
//globals from UIId:
constant boolean LIBRARY_UIId=true
//endglobals from UIId
//globals from UIImageModule:
constant boolean LIBRARY_UIImageModule=true
//endglobals from UIImageModule
//globals from UILifeCycle:
constant boolean LIBRARY_UILifeCycle=true
//endglobals from UILifeCycle
//globals from UnitTestFramwork:
constant boolean LIBRARY_UnitTestFramwork=true
trigger UnitTestFramwork___TUnitTest=null
//endglobals from UnitTestFramwork
//globals from YDTriggerSaveLoadSystem:
constant boolean LIBRARY_YDTriggerSaveLoadSystem=true
hashtable YDHT
hashtable YDLOC
//endglobals from YDTriggerSaveLoadSystem
//globals from Hardware:
constant boolean LIBRARY_Hardware=true
//endglobals from Hardware
//globals from UISimpleEvent:
constant boolean LIBRARY_UISimpleEvent=true
boolean UISimpleEvent___rcStartOnUI=false
integer UISimpleEvent___clickStartUI=0
//endglobals from UISimpleEvent
//globals from UITocInit:
constant boolean LIBRARY_UITocInit=true
//endglobals from UITocInit
//globals from UIUtils:
constant boolean LIBRARY_UIUtils=true
//endglobals from UIUtils
//globals from UIBaseModule:
constant boolean LIBRARY_UIBaseModule=true
//endglobals from UIBaseModule
//globals from UTUISimpleEvent:
constant boolean LIBRARY_UTUISimpleEvent=true
integer UTUISimpleEvent___btn=0
integer UTUISimpleEvent___img=0
//endglobals from UTUISimpleEvent
//globals from UIButton:
constant boolean LIBRARY_UIButton=true
//endglobals from UIButton
//globals from UIImage:
constant boolean LIBRARY_UIImage=true
//endglobals from UIImage
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
constant integer si__mapBounds=1
integer si__mapBounds_F=0
integer si__mapBounds_I=0
integer array si__mapBounds_V
real s__mapBounds_maxX=0.
real s__mapBounds_minX=0.
real s__mapBounds_maxY=0.
real s__mapBounds_minY=0.
constant integer si__radiationEnd=2
integer si__radiationEnd_F=0
integer si__radiationEnd_I=0
integer array si__radiationEnd_V
real s__radiationEnd_x=0
real s__radiationEnd_y=0
constant integer si__uiHashTable=3
integer s__uiHashTable_eventdata=(0)
integer s__uiHashTable_ui=(0)
constant integer si__UIHashTable___uiHTFrame=4
constant integer si__UIHashTable___uiHTEvent=5
constant integer si__uiId=6
hashtable s__uiId_ht
integer s__uiId_nextId
integer s__uiId_recycleCount
constant integer si__uiLifeCycle=7
integer s__uiLifeCycle_agrsUI=0
integer s__uiLifeCycle_agrsTypeID=0
integer s__uiLifeCycle_agrsFrame=0
trigger s__uiLifeCycle_trCreate=null
trigger s__uiLifeCycle_trDestroy=null
constant integer si__hardware=8
integer si__hardware_F=0
integer si__hardware_I=0
integer array si__hardware_V
trigger s__hardware_trWheel=null
trigger s__hardware_trUpdate=null
trigger s__hardware_trResize=null
trigger s__hardware_trMove=null
constant integer si__uiBtn=9
integer si__uiBtn_F=0
integer si__uiBtn_I=0
integer array si__uiBtn_V
integer array s__uiBtn_ui
integer array s__uiBtn_id
constant integer si__uiImage=10
integer si__uiImage_F=0
integer si__uiImage_I=0
integer array si__uiImage_V
integer array s__uiImage_ui
integer array s__uiImage_id
trigger st__uiBtn_isExist
trigger st__uiBtn_setAllPoint
trigger st__uiBtn_spEnter
trigger st__uiBtn_spLeave
trigger st__uiBtn_spClick
trigger st__uiBtn_spRightClick
trigger st__uiBtn_create
trigger st__uiBtn_onDestroy
trigger st__uiBtn_destroy
trigger st__uiImage_setPoint
trigger st__uiImage_setSize
trigger st__uiImage_texture
trigger st__uiImage_create
trigger st__uiImage_onDestroy
trigger array st___prototype19
integer f__arg_integer1
integer f__arg_integer2
integer f__arg_integer3
real f__arg_real1
real f__arg_real2
string f__arg_string1
integer f__arg_this
boolean f__result_boolean
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


//Generated allocator of mapBounds
function s__mapBounds__allocate takes nothing returns integer
 local integer this=si__mapBounds_F
    if (this!=0) then
        set si__mapBounds_F=si__mapBounds_V[this]
    else
        set si__mapBounds_I=si__mapBounds_I+1
        set this=si__mapBounds_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: mapBounds")
        return 0
    endif

    set si__mapBounds_V[this]=-1
 return this
endfunction

//Generated destructor of mapBounds
function s__mapBounds_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: mapBounds")
        return
    elseif (si__mapBounds_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: mapBounds")
        return
    endif
    set si__mapBounds_V[this]=si__mapBounds_F
    set si__mapBounds_F=this
endfunction

//Generated method caller for uiImage.setPoint
function sc__uiImage_setPoint takes integer this,integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns integer
    set f__arg_this=this
    set f__arg_integer1=anchor
    set f__arg_integer2=relative
    set f__arg_integer3=relativeAnchor
    set f__arg_real1=offsetX
    set f__arg_real2=offsetY
    call TriggerEvaluate(st__uiImage_setPoint)
 return f__result_integer
endfunction

//Generated method caller for uiImage.setSize
function sc__uiImage_setSize takes integer this,real width,real height returns integer
    set f__arg_this=this
    set f__arg_real1=width
    set f__arg_real2=height
    call TriggerEvaluate(st__uiImage_setSize)
 return f__result_integer
endfunction

//Generated method caller for uiImage.texture
function sc__uiImage_texture takes integer this,string path returns integer
    set f__arg_this=this
    set f__arg_string1=path
    call TriggerEvaluate(st__uiImage_texture)
 return f__result_integer
endfunction

//Generated method caller for uiImage.create
function sc__uiImage_create takes integer parent returns integer
    set f__arg_integer1=parent
    call TriggerEvaluate(st__uiImage_create)
 return f__result_integer
endfunction

//Generated method caller for uiImage.onDestroy
function sc__uiImage_onDestroy takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__uiImage_onDestroy)
endfunction

//Generated allocator of uiImage
function s__uiImage__allocate takes nothing returns integer
 local integer this=si__uiImage_F
    if (this!=0) then
        set si__uiImage_F=si__uiImage_V[this]
    else
        set si__uiImage_I=si__uiImage_I+1
        set this=si__uiImage_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: uiImage")
        return 0
    endif

    set si__uiImage_V[this]=-1
 return this
endfunction

//Generated destructor of uiImage
function sc__uiImage_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: uiImage")
        return
    elseif (si__uiImage_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: uiImage")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__uiImage_onDestroy)
    set si__uiImage_V[this]=si__uiImage_F
    set si__uiImage_F=this
endfunction

//Generated method caller for uiBtn.isExist
function sc__uiBtn_isExist takes integer this returns boolean
    set f__arg_this=this
    call TriggerEvaluate(st__uiBtn_isExist)
 return f__result_boolean
endfunction

//Generated method caller for uiBtn.setAllPoint
function sc__uiBtn_setAllPoint takes integer this,integer relative returns integer
    set f__arg_this=this
    set f__arg_integer1=relative
    call TriggerEvaluate(st__uiBtn_setAllPoint)
 return f__result_integer
endfunction

//Generated method caller for uiBtn.spEnter
function sc__uiBtn_spEnter takes integer this,integer fun returns integer
    set f__arg_this=this
    set f__arg_integer1=fun
    call TriggerEvaluate(st__uiBtn_spEnter)
 return f__result_integer
endfunction

//Generated method caller for uiBtn.spLeave
function sc__uiBtn_spLeave takes integer this,integer fun returns integer
    set f__arg_this=this
    set f__arg_integer1=fun
    call TriggerEvaluate(st__uiBtn_spLeave)
 return f__result_integer
endfunction

//Generated method caller for uiBtn.spClick
function sc__uiBtn_spClick takes integer this,integer fun returns integer
    set f__arg_this=this
    set f__arg_integer1=fun
    call TriggerEvaluate(st__uiBtn_spClick)
 return f__result_integer
endfunction

//Generated method caller for uiBtn.spRightClick
function sc__uiBtn_spRightClick takes integer this,integer fun returns integer
    set f__arg_this=this
    set f__arg_integer1=fun
    call TriggerEvaluate(st__uiBtn_spRightClick)
 return f__result_integer
endfunction

//Generated method caller for uiBtn.create
function sc__uiBtn_create takes integer parent returns integer
    set f__arg_integer1=parent
    call TriggerEvaluate(st__uiBtn_create)
 return f__result_integer
endfunction

//Generated method caller for uiBtn.onDestroy
function sc__uiBtn_onDestroy takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__uiBtn_onDestroy)
endfunction

//Generated allocator of uiBtn
function s__uiBtn__allocate takes nothing returns integer
 local integer this=si__uiBtn_F
    if (this!=0) then
        set si__uiBtn_F=si__uiBtn_V[this]
    else
        set si__uiBtn_I=si__uiBtn_I+1
        set this=si__uiBtn_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: uiBtn")
        return 0
    endif

    set si__uiBtn_V[this]=-1
 return this
endfunction

//Generated destructor of uiBtn
function sc__uiBtn_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: uiBtn")
        return
    elseif (si__uiBtn_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: uiBtn")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__uiBtn_onDestroy)
    set si__uiBtn_V[this]=si__uiBtn_F
    set si__uiBtn_F=this
endfunction

//Generated allocator of hardware
function s__hardware__allocate takes nothing returns integer
 local integer this=si__hardware_F
    if (this!=0) then
        set si__hardware_F=si__hardware_V[this]
    else
        set si__hardware_I=si__hardware_I+1
        set this=si__hardware_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: hardware")
        return 0
    endif

    set si__hardware_V[this]=-1
 return this
endfunction

//Generated destructor of hardware
function s__hardware_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: hardware")
        return
    elseif (si__hardware_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: hardware")
        return
    endif
    set si__hardware_V[this]=si__hardware_F
    set si__hardware_F=this
endfunction

//Generated allocator of radiationEnd
function s__radiationEnd__allocate takes nothing returns integer
 local integer this=si__radiationEnd_F
    if (this!=0) then
        set si__radiationEnd_F=si__radiationEnd_V[this]
    else
        set si__radiationEnd_I=si__radiationEnd_I+1
        set this=si__radiationEnd_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: radiationEnd")
        return 0
    endif

    set si__radiationEnd_V[this]=-1
 return this
endfunction

//Generated destructor of radiationEnd
function s__radiationEnd_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: radiationEnd")
        return
    elseif (si__radiationEnd_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: radiationEnd")
        return
    endif
    set si__radiationEnd_V[this]=si__radiationEnd_F
    set si__radiationEnd_F=this
endfunction
function sc___prototype19_execute takes integer i,integer a1 returns nothing
    set f__arg_integer1=a1

    call TriggerExecute(st___prototype19[i])
endfunction
function sc___prototype19_evaluate takes integer i,integer a1 returns nothing
    set f__arg_integer1=a1

    call TriggerEvaluate(st___prototype19[i])

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
//library MapBoundsUtils:
        function s__mapBounds_X takes real x returns real
            return RMinBJ(RMaxBJ(x, s__mapBounds_minX), s__mapBounds_maxX)
        endfunction  // 限制Y坐标在地图范围内
        function s__mapBounds_Y takes real y returns real
            return RMinBJ(RMaxBJ(y, s__mapBounds_minY), s__mapBounds_maxY)
        endfunction  // 初始化
        function s__mapBounds_onInit takes nothing returns nothing
            set s__mapBounds_minX=GetCameraBoundMinX() - GetCameraMargin(CAMERA_MARGIN_LEFT)
            set s__mapBounds_minY=GetCameraBoundMinY() - GetCameraMargin(CAMERA_MARGIN_BOTTOM)
            set s__mapBounds_maxX=GetCameraBoundMaxX() + GetCameraMargin(CAMERA_MARGIN_RIGHT)
            set s__mapBounds_maxY=GetCameraBoundMaxY() + GetCameraMargin(CAMERA_MARGIN_TOP)
        endfunction

//library MapBoundsUtils ends
//library MathUtils:
    function R2IRandom takes real value returns integer
        if ( GetRandomReal(0, 1.0) <= ModuloReal(value, 1.0) ) then
            return R2I(value) + 1
        endif
        return R2I(value)
    endfunction  // 进行整数除法，若能整除则结果减1
    function Divide1 takes integer i1,integer i2 returns integer
        if ( ModuloInteger(i1, i2) == 0 ) then
            return i1 / i2 - 1
        endif
        return i1 / i2
    endfunction  // 实现特殊的数值叠加计算，主要用于游戏中各种加成效果的叠加
    function RealAdd takes real a1,real a2 returns real
        if ( RAbsBJ(a2) >= 1.0 ) then
            return a1
        endif
        if ( a2 >= 0 ) then
            return 1.0 - ( 1.0 - a1 ) * ( 1.0 - a2 )
        else
            return 1.0 - ( 1.0 - a1 ) / ( 1.0 + a2 )
        endif
    endfunction  // 最小最大值限制
    function ILimit takes integer target,integer min,integer max returns integer
        if ( target < min ) then
            return min
        elseif ( target > max ) then
            return max
        else
            return target
        endif
    endfunction  // 最小最大值限制
    function RLimit takes real target,real min,real max returns real
        if ( target < min ) then
            return min
        elseif ( target > max ) then
            return max
        else
            return target
        endif
    endfunction  // 四舍五入法实数转整数
    function R2IM takes real r returns integer
        if ( ModuloReal(r, 1.0) >= 0.5 ) then
            return R2I(r) + 1
        else
            return R2I(r)
        endif
    endfunction  // 计算射线与地图边界的交点
        function s__radiationEnd_cal takes real x1,real y1,real angle returns nothing
            local real x2=0
            local real y2=0
            local real a=ModuloReal(angle, 360)
            local real tan
            set s__radiationEnd_x=0
            set s__radiationEnd_y=0 // 处理特殊角度
            if ( a == 0 ) then // 正右方
                set s__radiationEnd_x=s__mapBounds_maxX
                set s__radiationEnd_y=y1
                return
            endif // 正上方
            if ( a == 90 ) then
                set s__radiationEnd_x=x1
                set s__radiationEnd_y=s__mapBounds_maxY
                return
            endif // 正左方
            if ( a == 180 ) then
                set s__radiationEnd_x=s__mapBounds_minX
                set s__radiationEnd_y=y1
                return
            endif // 正下方
            if ( a == 270 ) then
                set s__radiationEnd_x=x1
                set s__radiationEnd_y=s__mapBounds_minY
                return
            endif // 处理一般角度
            if ( a < 90 ) then //第一象限
                set tan=TanBJ(a)
                set x2=( s__mapBounds_maxY - y1 ) / tan + x1
                set y2=( s__mapBounds_maxX - x1 ) * tan + y1 //取这个
                if ( x2 <= s__mapBounds_maxX ) then
                    set s__radiationEnd_x=x2
                    set s__radiationEnd_y=s__mapBounds_maxY
                else
                    set s__radiationEnd_x=s__mapBounds_maxX
                    set s__radiationEnd_y=y2
                endif //第二象限
            elseif ( a < 180 ) then
                set tan=TanBJ(a)
                set x2=( s__mapBounds_maxY - y1 ) / tan + x1
                set y2=( s__mapBounds_minX - x1 ) * tan + y1 //取这个
                if ( x2 >= s__mapBounds_minX ) then
                    set s__radiationEnd_x=x2
                    set s__radiationEnd_y=s__mapBounds_maxY
                else
                    set s__radiationEnd_x=s__mapBounds_minX
                    set s__radiationEnd_y=y2
                endif //第三象限
            elseif ( a < 270 ) then
                set tan=TanBJ(a)
                set x2=( s__mapBounds_minY - y1 ) / tan + x1
                set y2=( s__mapBounds_minX - x1 ) * tan + y1 //取这个
                if ( x2 >= s__mapBounds_minX ) then
                    set s__radiationEnd_x=x2
                    set s__radiationEnd_y=s__mapBounds_minY
                else
                    set s__radiationEnd_x=s__mapBounds_minX
                    set s__radiationEnd_y=y2
                endif //第四象限
            else
                set tan=TanBJ(a)
                set x2=( s__mapBounds_minY - y1 ) / tan + x1
                set y2=( s__mapBounds_maxX - x1 ) * tan + y1 //取这个
                if ( x2 <= s__mapBounds_maxX ) then
                    set s__radiationEnd_x=x2
                    set s__radiationEnd_y=s__mapBounds_minY
                else
                    set s__radiationEnd_x=s__mapBounds_maxX
                    set s__radiationEnd_y=y2
                endif
            endif
        endfunction

//library MathUtils ends
//library UIEventModule:

//library UIEventModule ends
//library UIHashTable:
        function s__UIHashTable___uiHTFrame_bind takes integer frame,integer typeID,integer ui returns nothing
            call SaveInteger(HASH_UI, frame, 1820, typeID)
            call SaveInteger(HASH_UI, frame, 1821, ui)
        endfunction  // 从frame获取UI实例
        function s__UIHashTable___uiHTFrame_get takes integer frame returns integer
            return LoadInteger(HASH_UI, frame, 1821)
        endfunction  // 从frame获取UI类型
        function s__UIHashTable___uiHTFrame_getType takes integer frame returns integer
            return LoadInteger(HASH_UI, frame, 1820)
        endfunction
        function s__UIHashTable___uiHTEvent_bind takes integer this,integer frame,integer value returns nothing
            call SaveInteger(HASH_UI, frame, 1823, value)
        endfunction
        function s__UIHashTable___uiHTEvent_get takes integer this,integer frame returns integer
            return LoadInteger(HASH_UI, frame, 1823)
        endfunction

//library UIHashTable ends
//library UIId:
        function s__uiId_onInit takes nothing returns nothing
            set s__uiId_ht=InitHashtable()
            set s__uiId_nextId=1
            set s__uiId_recycleCount=0
        endfunction
        function s__uiId_get takes nothing returns integer
            local integer id
            if ( s__uiId_recycleCount > 0 ) then // 获取最后一个回收的ID
                set id=LoadInteger(s__uiId_ht, 1, s__uiId_recycleCount - 1) // 从回收池中删除这个ID
                call RemoveSavedInteger(s__uiId_ht, 1, s__uiId_recycleCount - 1) // 从状态表中删除
                call RemoveSavedBoolean(s__uiId_ht, 2, id)
                set s__uiId_recycleCount=s__uiId_recycleCount - 1
                return id
            endif // 如果没有可复用的ID，返回新的ID
            set id=s__uiId_nextId
            set s__uiId_nextId=s__uiId_nextId + 1
            return id
        endfunction
        function s__uiId_recycle takes integer id returns nothing
            if ( not ( HaveSavedBoolean(s__uiId_ht, 2, id) ) ) then // 将ID存入回收池
                call SaveInteger(s__uiId_ht, 1, s__uiId_recycleCount, id) // 标记该ID已被回收
                call SaveBoolean(s__uiId_ht, 2, id, true)
                set s__uiId_recycleCount=s__uiId_recycleCount + 1
            endif
        endfunction  // 获取回收池中ID的数量
        function s__uiId_getRecycledCount takes nothing returns integer
            return s__uiId_recycleCount
        endfunction  // 获取当前正在使用的ID数量
        function s__uiId_getActiveCount takes nothing returns integer
            return ( s__uiId_nextId - 1 ) - s__uiId_recycleCount
        endfunction

//library UIId ends
//library UIImageModule:

//library UIImageModule ends
//library UILifeCycle:
        //private:
        function s__uiLifeCycle_registerCreate takes code func returns nothing
            call TriggerAddCondition(s__uiLifeCycle_trCreate, Condition(func))
        endfunction  // 注册销毁回调
        function s__uiLifeCycle_registerDestroy takes code func returns nothing
            call TriggerAddCondition(s__uiLifeCycle_trDestroy, Condition(func))
        endfunction
        function s__uiLifeCycle_onCreateCB takes integer ui,integer typeID,integer frame returns nothing
            set s__uiLifeCycle_agrsUI=ui
            set s__uiLifeCycle_agrsTypeID=typeID
            set s__uiLifeCycle_agrsFrame=frame
            call TriggerEvaluate(s__uiLifeCycle_trCreate)
        endfunction
        function s__uiLifeCycle_onDestroyCB takes integer ui,integer typeID,integer frame returns nothing
            set s__uiLifeCycle_agrsUI=ui
            set s__uiLifeCycle_agrsTypeID=typeID
            set s__uiLifeCycle_agrsFrame=frame
            call TriggerEvaluate(s__uiLifeCycle_trDestroy)
        endfunction
        function s__uiLifeCycle_onInit takes nothing returns nothing
            set s__uiLifeCycle_trCreate=CreateTrigger()
            set s__uiLifeCycle_trDestroy=CreateTrigger()
        endfunction

//library UILifeCycle ends
//library UnitTestFramwork:

    function UnitTestRegisterChatEvent takes code func returns nothing
        call TriggerAddAction(UnitTestFramwork___TUnitTest, func)
    endfunction
        function UnitTestFramwork___anon__0 takes nothing returns nothing
            local integer i
            set i=1
            loop
            exitwhen ( i > 12 )
                call SetPlayerName(ConvertedPlayer(i), "测试员" + I2S(i) + "号") //迷雾全关
                call CreateFogModifierRectBJ(true, ConvertedPlayer(i), FOG_OF_WAR_VISIBLE, GetPlayableMapRect())
            set i=i + 1
            endloop
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
    function UnitTestFramwork___onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEventSingle(tr, 0.1)
        call TriggerAddCondition(tr, Condition(function UnitTestFramwork___anon__0))
        set tr=null
        set UnitTestFramwork___TUnitTest=CreateTrigger()
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest, Player(0), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest, Player(1), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest, Player(2), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest, Player(3), "", false)
    endfunction

//library UnitTestFramwork ends
//library YDTriggerSaveLoadSystem:
//#  define YDTRIGGER_handle(SG)                          YDTRIGGER_HT##SG##(HashtableHandle)
    function YDTriggerSaveLoadSystem___Init takes nothing returns nothing
            set YDHT=InitHashtable()
        set YDLOC=InitHashtable()
    endfunction

//library YDTriggerSaveLoadSystem ends
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
            if ( s__hardware_trMove == null ) then
                set s__hardware_trMove=CreateTrigger()
            endif
            call TriggerAddCondition(s__hardware_trMove, Condition(func))
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
//library UISimpleEvent:

//processed:     function interface uiEvent takes integer arg0 returns nothing  // 是否开始右键点击
        function UISimpleEvent___anon__3 takes nothing returns nothing
            if ( UISimpleEvent___clickStartUI != 0 ) then
                set UISimpleEvent___rcStartOnUI=true
            endif // 新增的click判断逻辑
        endfunction  //注册右键抬起事件
        function UISimpleEvent___anon__4 takes nothing returns nothing
            local integer func
            if ( UISimpleEvent___rcStartOnUI and UISimpleEvent___clickStartUI != 0 ) then
                if ( HaveSavedInteger(HASH_UI, UISimpleEvent___clickStartUI, 1913) ) then
                    set func=LoadInteger(HASH_UI, UISimpleEvent___clickStartUI, 1913)
                    call sc___prototype19_evaluate(func,UISimpleEvent___clickStartUI)
                endif
            endif
            set UISimpleEvent___rcStartOnUI=false
        endfunction  // UI销毁时如果鼠标正在上面,则触发一次离开事件
        function UISimpleEvent___anon__5 takes nothing returns nothing
            local integer ui=s__uiLifeCycle_agrsFrame
            local integer func
            if ( UISimpleEvent___clickStartUI == ui and HaveSavedInteger(HASH_UI, ui, 1911) ) then
                set func=LoadInteger(HASH_UI, UISimpleEvent___clickStartUI, 1911)
                call sc___prototype19_evaluate(func,UISimpleEvent___clickStartUI)
            endif
            set UISimpleEvent___clickStartUI=0
        endfunction
    function UISimpleEvent___onInit takes nothing returns nothing
        call s__hardware_regRightDownEvent(function UISimpleEvent___anon__3)
        call s__hardware_regRightUpEvent(function UISimpleEvent___anon__4)
        call s__uiLifeCycle_registerDestroy(function UISimpleEvent___anon__5)
    endfunction

//library UISimpleEvent ends
//library UITocInit:

    function UITocInit___onInit takes nothing returns nothing
        call DzLoadToc("ui\\Crainax.toc")
        call DzFrameEnableClipRect(false)
    endfunction

//library UITocInit ends
//library UIUtils:
    function GetResizeRate takes nothing returns real
        if ( DzGetWindowWidth() > 0 ) then
            return DzGetWindowHeight() / 600.0 * 800.0 / DzGetWindowWidth()
        else
            return 1.0
        endif
    endfunction  // 获取鼠标位置X(绝对坐标)[修正版]
    function GetMouseXEx takes nothing returns real
        local integer width=DzGetClientWidth()
        if ( width > 0 ) then
            return DzGetMouseXRelative() * 0.80 / width
        else
            return 0.1
        endif
    endfunction  // 获取鼠标位置Y(绝对坐标)[修正版]
    function GetMouseYEx takes nothing returns real
        local integer height=DzGetClientHeight()
        if ( height > 0 ) then
            return 0.60 - DzGetMouseYRelative() * 0.60 / height
        else
            return 0.1
        endif
    endfunction  // 限制一个值是在一定区域内以防UI超出这个区域
    function GetFixedMouseX takes real min,real max returns real
        return RLimit(GetMouseXEx() , min , max)
    endfunction  // 限制一个值是在一定区域内以防UI超出这个区域
    function GetFixedMouseY takes real min,real max returns real
        return RLimit(GetMouseYEx() , min , max)
    endfunction

//library UIUtils ends
//library UIBaseModule:

//library UIBaseModule ends
//library UTUISimpleEvent:

        function UTUISimpleEvent___anon__0 takes integer frame returns nothing
            local integer data=s__UIHashTable___uiHTEvent_get(s__uiHashTable_eventdata,frame)
            call BJDebugMsg("enter:" + I2S(data))
        endfunction
        function UTUISimpleEvent___anon__1 takes integer frame returns nothing
            local integer data=s__UIHashTable___uiHTEvent_get(s__uiHashTable_eventdata,frame)
            call BJDebugMsg("leave:" + I2S(data))
        endfunction
        function UTUISimpleEvent___anon__2 takes integer frame returns nothing
            local integer data=s__UIHashTable___uiHTEvent_get(s__uiHashTable_eventdata,frame)
            call BJDebugMsg("click:" + I2S(data))
        endfunction
        function UTUISimpleEvent___anon__3 takes integer frame returns nothing
            local integer data=s__UIHashTable___uiHTEvent_get(s__uiHashTable_eventdata,frame)
            call BJDebugMsg("RightClick:" + I2S(data))
        endfunction
    function UTUISimpleEvent___TTestUTUISimpleEvent1 takes player p returns nothing
        set UTUISimpleEvent___img=sc__uiImage_texture(sc__uiImage_setPoint(sc__uiImage_setSize(sc__uiImage_create(DzGetGameUI()),0.035 , 0.035),4 , DzGetGameUI() , 4 , 0.0 , 0.0),"ReplaceableTextures\\CommandButtons\\BTNKeeperOfTheGrove.blp")
        set UTUISimpleEvent___btn=sc__uiBtn_spRightClick(sc__uiBtn_spClick(sc__uiBtn_spLeave(sc__uiBtn_spEnter(sc__uiBtn_setAllPoint(sc__uiBtn_create(DzGetGameUI()),s__uiImage_ui[UTUISimpleEvent___img]),(1)),(2)),(3)),(4))
        call s__UIHashTable___uiHTEvent_bind(s__uiHashTable_eventdata,s__uiBtn_ui[UTUISimpleEvent___btn] , 8174)
    endfunction
    function UTUISimpleEvent___TTestUTUISimpleEvent2 takes player p returns nothing
        if ( sc__uiBtn_isExist(UTUISimpleEvent___btn) ) then
            call sc__uiBtn_deallocate(UTUISimpleEvent___btn)
            call BJDebugMsg("删除了,方便测试离开事件:" + I2S(s__uiBtn_ui[UTUISimpleEvent___btn]))
        endif
    endfunction
    function UTUISimpleEvent___TTestUTUISimpleEvent3 takes player p returns nothing
    endfunction
    function UTUISimpleEvent___TTestUTUISimpleEvent4 takes player p returns nothing
    endfunction
    function UTUISimpleEvent___TTestUTUISimpleEvent5 takes player p returns nothing
    endfunction
    function UTUISimpleEvent___TTestUTUISimpleEvent6 takes player p returns nothing
    endfunction
    function UTUISimpleEvent___TTestUTUISimpleEvent7 takes player p returns nothing
    endfunction
    function UTUISimpleEvent___TTestUTUISimpleEvent8 takes player p returns nothing
    endfunction
    function UTUISimpleEvent___TTestUTUISimpleEvent9 takes player p returns nothing
    endfunction
    function UTUISimpleEvent___TTestUTUISimpleEvent10 takes player p returns nothing
    endfunction
    function UTUISimpleEvent___TTestActUTUISimpleEvent1 takes string str returns nothing
        local player p=GetTriggerPlayer()
        local integer index=GetConvertedPlayerId(p)
        local integer i
        local integer num=0
        local integer len=StringLength(str)
        local string array paramS
        local integer array paramI
        local real array paramR
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
        endif
        set p=null
    endfunction
        function UTUISimpleEvent___anon__4 takes nothing returns nothing
            call BJDebugMsg("[UISimpleEvent] 单元测试已加载")
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTUISimpleEvent___anon__5 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            local integer i=1
            if ( SubStringBJ(str, 1, 1) == "-" ) then
                call UTUISimpleEvent___TTestActUTUISimpleEvent1(SubStringBJ(str, 2, StringLength(str)))
                return
            endif
            if ( str == "s1" ) then
                call UTUISimpleEvent___TTestUTUISimpleEvent1(GetTriggerPlayer())
            elseif ( str == "s2" ) then
                call UTUISimpleEvent___TTestUTUISimpleEvent2(GetTriggerPlayer())
            elseif ( str == "s3" ) then
                call UTUISimpleEvent___TTestUTUISimpleEvent3(GetTriggerPlayer())
            elseif ( str == "s4" ) then
                call UTUISimpleEvent___TTestUTUISimpleEvent4(GetTriggerPlayer())
            elseif ( str == "s5" ) then
                call UTUISimpleEvent___TTestUTUISimpleEvent5(GetTriggerPlayer())
            elseif ( str == "s6" ) then
                call UTUISimpleEvent___TTestUTUISimpleEvent6(GetTriggerPlayer())
            elseif ( str == "s7" ) then
                call UTUISimpleEvent___TTestUTUISimpleEvent7(GetTriggerPlayer())
            elseif ( str == "s8" ) then
                call UTUISimpleEvent___TTestUTUISimpleEvent8(GetTriggerPlayer())
            elseif ( str == "s9" ) then
                call UTUISimpleEvent___TTestUTUISimpleEvent9(GetTriggerPlayer())
            elseif ( str == "s10" ) then
                call UTUISimpleEvent___TTestUTUISimpleEvent10(GetTriggerPlayer())
            endif
        endfunction
    function UTUISimpleEvent___onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEventSingle(tr, 0.5)
        call TriggerAddCondition(tr, Condition(function UTUISimpleEvent___anon__4))
        set tr=null
        call UnitTestRegisterChatEvent(function UTUISimpleEvent___anon__5)
    endfunction

//library UTUISimpleEvent ends
//library UIButton:
        function s__uiBtn_isExist takes integer this returns boolean
            return ( this != null and si__uiBtn_V[this] == - 1 )
        endfunction
//Implemented from module uiBaseModule:
        function s__uiBtn_setPoint takes integer this,integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetPoint(s__uiBtn_ui[this], anchor, relative, relativeAnchor, offsetX, offsetY)
            return this
        endfunction  // 大小完全对齐父框架
        function s__uiBtn_setAllPoint takes integer this,integer relative returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAllPoints(s__uiBtn_ui[this], relative)
            return this
        endfunction  //绝对位置
        function s__uiBtn_setAbsPoint takes integer this,integer anchor,real x,real y returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAbsolutePoint(s__uiBtn_ui[this], anchor, x, y)
            return this
        endfunction  // 清除所有位置
        function s__uiBtn_clearPoint takes integer this returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameClearAllPoints(s__uiBtn_ui[this])
            return this
        endfunction  // 设置大小
        function s__uiBtn_setSize takes integer this,real width,real height returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetSize(s__uiBtn_ui[this], width, height)
            return this
        endfunction  // 设置大小(校正后的),只显示一次,此时改窗口大小不会变化
        function s__uiBtn_setSizeFix takes integer this,real width,real height returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetSize(s__uiBtn_ui[this], width * GetResizeRate(), height)
            return this
        endfunction  // 隐藏控件
        function s__uiBtn_hide takes integer this returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameShow(s__uiBtn_ui[this], false)
            return this
        endfunction  // 显示控件
        function s__uiBtn_show takes integer this returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameShow(s__uiBtn_ui[this], true)
            return this
        endfunction  //透明度(0-255)
        function s__uiBtn_setAlpha takes integer this,integer value returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAlpha(s__uiBtn_ui[this], value)
            return this
        endfunction  //扩展自适应大小方法
//Implemented from module uiBaseModule:
//Implemented from module uiEventModule:
        function s__uiBtn_onMouseEnter takes integer this,code fun returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetScriptByCode(s__uiBtn_ui[this], 2, fun, false)
            return this
        endfunction  // 鼠标离开事件
        function s__uiBtn_onMouseLeave takes integer this,code fun returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetScriptByCode(s__uiBtn_ui[this], 3, fun, false)
            return this
        endfunction  // 鼠标松开事件,和点击一样,基本可以当相同事件
        function s__uiBtn_onMouseClick takes integer this,code fun returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetScriptByCode(s__uiBtn_ui[this], 1, fun, false)
            return this
        endfunction  // 鼠标滚轮事件
        function s__uiBtn_onMouseWheel takes integer this,code fun returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetScriptByCode(s__uiBtn_ui[this], 6, fun, false)
            return this
        endfunction  // 鼠标双击事件
        function s__uiBtn_onMouseDoubleClick takes integer this,code fun returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetScriptByCode(s__uiBtn_ui[this], 12, fun, false)
            return this
        endfunction  //扩展事件
            function s__uiBtn_simpleEvent__anon__0 takes nothing returns nothing
                local integer frame=DzGetTriggerUIEventFrame()
                local integer func
                set UISimpleEvent___clickStartUI=frame
                if ( HaveSavedInteger(HASH_UI, frame, 1910) ) then
                    set func=LoadInteger(HASH_UI, frame, 1910)
                    call sc___prototype19_evaluate(func,frame)
                endif
            endfunction
        function s__uiBtn_spEnter takes integer this,integer fun returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call SaveInteger(HASH_UI, s__uiBtn_ui[this], 1910, fun)
            call DzFrameSetScriptByCode(s__uiBtn_ui[this], 2, function s__uiBtn_simpleEvent__anon__0, false)
            return this
        endfunction  // 鼠标离开事件(右键前提强化版)
            function s__uiBtn_simpleEvent__anon__1 takes nothing returns nothing
                local integer frame=DzGetTriggerUIEventFrame()
                local integer func
                set UISimpleEvent___clickStartUI=0
                if ( HaveSavedInteger(HASH_UI, frame, 1911) ) then
                    set func=LoadInteger(HASH_UI, frame, 1911)
                    call sc___prototype19_evaluate(func,frame)
                endif
            endfunction
        function s__uiBtn_spLeave takes integer this,integer fun returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call SaveInteger(HASH_UI, s__uiBtn_ui[this], 1911, fun)
            call DzFrameSetScriptByCode(s__uiBtn_ui[this], 3, function s__uiBtn_simpleEvent__anon__1, false)
            return this
        endfunction  // 鼠标点击事件,其实这个不是必须项,只是为了统一写法硬加的
            function s__uiBtn_simpleEvent__anon__2 takes nothing returns nothing
                local integer frame=DzGetTriggerUIEventFrame()
                local integer func
                if ( HaveSavedInteger(HASH_UI, frame, 1912) ) then
                    set func=LoadInteger(HASH_UI, frame, 1912)
                    call sc___prototype19_evaluate(func,frame)
                endif
            endfunction
        function s__uiBtn_spClick takes integer this,integer fun returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call SaveInteger(HASH_UI, s__uiBtn_ui[this], 1912, fun)
            call DzFrameSetScriptByCode(s__uiBtn_ui[this], 1, function s__uiBtn_simpleEvent__anon__2, false)
            return this
        endfunction  // 鼠标右键点击事件
        function s__uiBtn_spRightClick takes integer this,integer fun returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call SaveInteger(HASH_UI, s__uiBtn_ui[this], 1913, fun)
            return this
        endfunction
        function s__uiBtn_create takes integer parent returns integer
            local integer this=s__uiBtn__allocate()
            set s__uiBtn_id[this]=s__uiId_get() //有高亮无声音的图标
            set s__uiBtn_ui[this]=DzCreateFrameByTagName("BUTTON", "Btn" + I2S(s__uiBtn_id[this]), parent, "BT", 0)
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiBtn , s__uiBtn_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable___uiHTFrame_bind(s__uiBtn_ui[this] , si__uiBtn , this)
//#             endif
            return this
        endfunction  //普通带声效系
        function s__uiBtn_createSound takes integer parent returns integer
            local integer this=s__uiBtn__allocate()
            set s__uiBtn_id[this]=s__uiId_get() //有高亮有声音的图标
            set s__uiBtn_ui[this]=DzCreateFrameByTagName("GLUEBUTTON", "Btn" + I2S(s__uiBtn_id[this]), parent, "BT", 0)
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiBtn , s__uiBtn_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable___uiHTFrame_bind(s__uiBtn_ui[this] , si__uiBtn , this)
//#             endif
            return this
        endfunction  //右键菜单系
        function s__uiBtn_createRC takes integer parent returns integer
            local integer this=s__uiBtn__allocate()
            set s__uiBtn_id[this]=s__uiId_get() //配合异度下的菜单使用,要导入:ui\image\textbutton_highlight.blp
            set s__uiBtn_ui[this]=DzCreateFrameByTagName("GLUEBUTTON", "Btn" + I2S(s__uiBtn_id[this]), parent, "TBT", 0)
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiBtn , s__uiBtn_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable___uiHTFrame_bind(s__uiBtn_ui[this] , si__uiBtn , this)
//#             endif
            return this
        endfunction  // 创建空白按钮
        function s__uiBtn_createBlank takes integer parent returns integer
            local integer this=s__uiBtn__allocate()
            set s__uiBtn_id[this]=s__uiId_get()
            set s__uiBtn_ui[this]=DzCreateFrameByTagName("BUTTON", "Btn" + I2S(s__uiBtn_id[this]), parent, "BB", 0)
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiBtn , s__uiBtn_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable___uiHTFrame_bind(s__uiBtn_ui[this] , si__uiBtn , this)
//#             endif
            return this
        endfunction  // 创建一个用在原生Frame里的按钮,这种按钮是不能destroy的!
        function s__uiBtn_createSimple takes integer parent returns integer
            local integer this=s__uiBtn__allocate()
            set s__uiBtn_id[this]=s__uiId_get()
            set s__uiBtn_ui[this]=DzCreateFrameByTagName("SIMPLEBUTTON", "Btn" + I2S(s__uiBtn_id[this]), parent, "按钮模板", 1)
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiBtn , s__uiBtn_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable___uiHTFrame_bind(s__uiBtn_ui[this] , si__uiBtn , this)
//#             endif
            return this
        endfunction  //绑定原生的Button成为SimpleButton,注意不能删除哦
        function s__uiBtn_bindSimple takes integer frame returns integer
            local integer this=s__uiBtn__allocate()
            set s__uiBtn_id[this]=s__uiId_get()
            set s__uiBtn_ui[this]=frame
            return this
        endfunction
        function s__uiBtn_onDestroy takes integer this returns nothing
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return
            endif
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onDestroyCB(this , si__uiBtn , s__uiBtn_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call FlushChildHashtable(HASH_UI, s__uiBtn_ui[this])
//#             endif
            call DzDestroyFrame(s__uiBtn_ui[this])
            call s__uiId_recycle(s__uiBtn_id[this])
        endfunction

//Generated destructor of uiBtn
function s__uiBtn_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: uiBtn")
        return
    elseif (si__uiBtn_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: uiBtn")
        return
    endif
    call s__uiBtn_onDestroy(this)
    set si__uiBtn_V[this]=si__uiBtn_F
    set si__uiBtn_F=this
endfunction

//library UIButton ends
//library UIImage:
        function s__uiImage_isExist takes integer this returns boolean
            return ( this != null and si__uiImage_V[this] == - 1 )
        endfunction
//Implemented from module uiBaseModule:
        function s__uiImage_setPoint takes integer this,integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns integer
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetPoint(s__uiImage_ui[this], anchor, relative, relativeAnchor, offsetX, offsetY)
            return this
        endfunction  // 大小完全对齐父框架
        function s__uiImage_setAllPoint takes integer this,integer relative returns integer
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAllPoints(s__uiImage_ui[this], relative)
            return this
        endfunction  //绝对位置
        function s__uiImage_setAbsPoint takes integer this,integer anchor,real x,real y returns integer
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAbsolutePoint(s__uiImage_ui[this], anchor, x, y)
            return this
        endfunction  // 清除所有位置
        function s__uiImage_clearPoint takes integer this returns integer
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            call DzFrameClearAllPoints(s__uiImage_ui[this])
            return this
        endfunction  // 设置大小
        function s__uiImage_setSize takes integer this,real width,real height returns integer
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetSize(s__uiImage_ui[this], width, height)
            return this
        endfunction  // 设置大小(校正后的),只显示一次,此时改窗口大小不会变化
        function s__uiImage_setSizeFix takes integer this,real width,real height returns integer
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetSize(s__uiImage_ui[this], width * GetResizeRate(), height)
            return this
        endfunction  // 隐藏控件
        function s__uiImage_hide takes integer this returns integer
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            call DzFrameShow(s__uiImage_ui[this], false)
            return this
        endfunction  // 显示控件
        function s__uiImage_show takes integer this returns integer
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            call DzFrameShow(s__uiImage_ui[this], true)
            return this
        endfunction  //透明度(0-255)
        function s__uiImage_setAlpha takes integer this,integer value returns integer
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAlpha(s__uiImage_ui[this], value)
            return this
        endfunction  //扩展自适应大小方法
//Implemented from module uiImageModule:
        function s__uiImage_texture takes integer this,string path returns integer
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetTexture(s__uiImage_ui[this], path, 0)
            return this
        endfunction
        function s__uiImage_create takes integer parent returns integer
            local integer this=s__uiImage__allocate()
            set s__uiImage_id[this]=s__uiId_get()
            set s__uiImage_ui[this]=DzCreateFrameByTagName("BACKDROP", "Img" + I2S(s__uiImage_id[this]), parent, "IT", 0)
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiImage , s__uiImage_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable___uiHTFrame_bind(s__uiImage_ui[this] , si__uiImage , this)
//#             endif
            return this
        endfunction  // 创建工具提示背景图片(种类1)
        function s__uiImage_createToolTips takes integer parent returns integer
            local integer this=s__uiImage__allocate()
            set s__uiImage_id[this]=s__uiId_get()
            set s__uiImage_ui[this]=DzCreateFrameByTagName("BACKDROP", "Img" + I2S(s__uiImage_id[this]), parent, "ToolTipsTemplate", 0)
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiImage , s__uiImage_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable___uiHTFrame_bind(s__uiImage_ui[this] , si__uiImage , this)
//#             endif
            return this
        endfunction  // 创建工具提示背景图片(种类2)
        function s__uiImage_createToolTips2 takes integer parent returns integer
            local integer this=s__uiImage__allocate()
            set s__uiImage_id[this]=s__uiId_get()
            set s__uiImage_ui[this]=DzCreateFrameByTagName("BACKDROP", "Img" + I2S(s__uiImage_id[this]), parent, "ToolTipsTemplate2", 0)
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiImage , s__uiImage_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable___uiHTFrame_bind(s__uiImage_ui[this] , si__uiImage , this)
//#             endif
            return this
        endfunction
        function s__uiImage_onDestroy takes integer this returns nothing
            if ( not ( s__uiImage_isExist(this) ) ) then
                return
            endif
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onDestroyCB(this , si__uiImage , s__uiImage_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call FlushChildHashtable(HASH_UI, s__uiImage_ui[this])
//#             endif
            call DzDestroyFrame(s__uiImage_ui[this])
            call s__uiId_recycle(s__uiImage_id[this])
        endfunction

//Generated destructor of uiImage
function s__uiImage_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: uiImage")
        return
    elseif (si__uiImage_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: uiImage")
        return
    endif
    call s__uiImage_onDestroy(this)
    set si__uiImage_V[this]=si__uiImage_F
    set si__uiImage_F=this
endfunction

//library UIImage ends
// 锚点常量
// 事件常量
//鼠标点击事件
//Index名:
//默认原生图片路径
//模板名
//TEXT对齐常量:(uiText.setAlign)
// 结构体共用方法定义
//共享打印方法
// UI组件内部共享方法及成员
// UI组件依赖库
// UI组件创建时共享调用
// UI组件销毁时共享调用

// 0 - 1亿这里用
//窗口的大小
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

//控件的共用基本方法
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
    call SetCameraBounds(- 13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), - 13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), - 13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), - 13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    call NewSoundEnvironment("Default")
    call SetAmbientDaySound("NorthrendDay")
    call SetAmbientNightSound("NorthrendNight")
    call SetMapMusic("Music", true, 0)
    call CreateRegions()
    call CreateAllUnits()
    call InitBlizzard()

call ExecuteFunc("jasshelper__initstructs1382390")
call ExecuteFunc("UnitTestFramwork___onInit")
call ExecuteFunc("YDTriggerSaveLoadSystem___Init")
call ExecuteFunc("UISimpleEvent___onInit")
call ExecuteFunc("UITocInit___onInit")
call ExecuteFunc("UTUISimpleEvent___onInit")

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
function sa__uiImage_setPoint takes nothing returns boolean
local integer this=f__arg_this
local integer anchor=f__arg_integer1
local integer relative=f__arg_integer2
local integer relativeAnchor=f__arg_integer3
local real offsetX=f__arg_real1
local real offsetY=f__arg_real2
            if ( not ( s__uiImage_isExist(this) ) ) then
set f__result_integer= this
return true
            endif
            call DzFrameSetPoint(s__uiImage_ui[this], anchor, relative, relativeAnchor, offsetX, offsetY)
set f__result_integer= this
   return true
endfunction
function sa__uiImage_setSize takes nothing returns boolean
local integer this=f__arg_this
local real width=f__arg_real1
local real height=f__arg_real2
            if ( not ( s__uiImage_isExist(this) ) ) then
set f__result_integer= this
return true
            endif
            call DzFrameSetSize(s__uiImage_ui[this], width, height)
set f__result_integer= this
   return true
endfunction
function sa__uiImage_texture takes nothing returns boolean
local integer this=f__arg_this
local string path=f__arg_string1
            if ( not ( s__uiImage_isExist(this) ) ) then
set f__result_integer= this
return true
            endif
            call DzFrameSetTexture(s__uiImage_ui[this], path, 0)
set f__result_integer= this
   return true
endfunction
function sa__uiImage_create takes nothing returns boolean
local integer parent=f__arg_integer1
            local integer this=s__uiImage__allocate()
            set s__uiImage_id[this]=s__uiId_get()
            set s__uiImage_ui[this]=DzCreateFrameByTagName("BACKDROP", "Img" + I2S(s__uiImage_id[this]), parent, "IT", 0)
                    call s__uiLifeCycle_onCreateCB(this , si__uiImage , s__uiImage_ui[this])
                    call s__UIHashTable___uiHTFrame_bind(s__uiImage_ui[this] , si__uiImage , this)
set f__result_integer= this
   return true
endfunction
function sa__uiImage_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            if ( not ( s__uiImage_isExist(this) ) ) then
return true
            endif
                    call s__uiLifeCycle_onDestroyCB(this , si__uiImage , s__uiImage_ui[this])
                    call FlushChildHashtable(HASH_UI, s__uiImage_ui[this])
            call DzDestroyFrame(s__uiImage_ui[this])
            call s__uiId_recycle(s__uiImage_id[this])
   return true
endfunction
function sa__uiBtn_isExist takes nothing returns boolean
local integer this=f__arg_this
set f__result_boolean= ( this != null and si__uiBtn_V[this] == - 1 )
   return true
endfunction
function sa__uiBtn_setAllPoint takes nothing returns boolean
local integer this=f__arg_this
local integer relative=f__arg_integer1
            if ( not ( s__uiBtn_isExist(this) ) ) then
set f__result_integer= this
return true
            endif
            call DzFrameSetAllPoints(s__uiBtn_ui[this], relative)
set f__result_integer= this
   return true
endfunction
function sa__uiBtn_spEnter takes nothing returns boolean
local integer this=f__arg_this
local integer fun=f__arg_integer1
            if ( not ( s__uiBtn_isExist(this) ) ) then
set f__result_integer= this
return true
            endif
            call SaveInteger(HASH_UI, s__uiBtn_ui[this], 1910, fun)
            call DzFrameSetScriptByCode(s__uiBtn_ui[this], 2, function s__uiBtn_simpleEvent__anon__0, false)
set f__result_integer= this
   return true
endfunction
function sa__uiBtn_spLeave takes nothing returns boolean
local integer this=f__arg_this
local integer fun=f__arg_integer1
            if ( not ( s__uiBtn_isExist(this) ) ) then
set f__result_integer= this
return true
            endif
            call SaveInteger(HASH_UI, s__uiBtn_ui[this], 1911, fun)
            call DzFrameSetScriptByCode(s__uiBtn_ui[this], 3, function s__uiBtn_simpleEvent__anon__1, false)
set f__result_integer= this
   return true
endfunction
function sa__uiBtn_spClick takes nothing returns boolean
local integer this=f__arg_this
local integer fun=f__arg_integer1
            if ( not ( s__uiBtn_isExist(this) ) ) then
set f__result_integer= this
return true
            endif
            call SaveInteger(HASH_UI, s__uiBtn_ui[this], 1912, fun)
            call DzFrameSetScriptByCode(s__uiBtn_ui[this], 1, function s__uiBtn_simpleEvent__anon__2, false)
set f__result_integer= this
   return true
endfunction
function sa__uiBtn_spRightClick takes nothing returns boolean
local integer this=f__arg_this
local integer fun=f__arg_integer1
            if ( not ( s__uiBtn_isExist(this) ) ) then
set f__result_integer= this
return true
            endif
            call SaveInteger(HASH_UI, s__uiBtn_ui[this], 1913, fun)
set f__result_integer= this
   return true
endfunction
function sa__uiBtn_create takes nothing returns boolean
local integer parent=f__arg_integer1
            local integer this=s__uiBtn__allocate()
            set s__uiBtn_id[this]=s__uiId_get() //有高亮无声音的图标
            set s__uiBtn_ui[this]=DzCreateFrameByTagName("BUTTON", "Btn" + I2S(s__uiBtn_id[this]), parent, "BT", 0)
                    call s__uiLifeCycle_onCreateCB(this , si__uiBtn , s__uiBtn_ui[this])
                    call s__UIHashTable___uiHTFrame_bind(s__uiBtn_ui[this] , si__uiBtn , this)
set f__result_integer= this
   return true
endfunction
function sa__uiBtn_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            if ( not ( s__uiBtn_isExist(this) ) ) then
return true
            endif
                    call s__uiLifeCycle_onDestroyCB(this , si__uiBtn , s__uiBtn_ui[this])
                    call FlushChildHashtable(HASH_UI, s__uiBtn_ui[this])
            call DzDestroyFrame(s__uiBtn_ui[this])
            call s__uiId_recycle(s__uiBtn_id[this])
   return true
endfunction
function sa___prototype19_UTUISimpleEvent___anon__0 takes nothing returns boolean
 local integer frame=f__arg_integer1

            local integer data=s__UIHashTable___uiHTEvent_get(s__uiHashTable_eventdata,frame)
            call BJDebugMsg("enter:" + I2S(data))
    return true
endfunction
function sa___prototype19_UTUISimpleEvent___anon__1 takes nothing returns boolean
 local integer frame=f__arg_integer1

            local integer data=s__UIHashTable___uiHTEvent_get(s__uiHashTable_eventdata,frame)
            call BJDebugMsg("leave:" + I2S(data))
    return true
endfunction
function sa___prototype19_UTUISimpleEvent___anon__2 takes nothing returns boolean
 local integer frame=f__arg_integer1

            local integer data=s__UIHashTable___uiHTEvent_get(s__uiHashTable_eventdata,frame)
            call BJDebugMsg("click:" + I2S(data))
    return true
endfunction
function sa___prototype19_UTUISimpleEvent___anon__3 takes nothing returns boolean
 local integer frame=f__arg_integer1

            local integer data=s__UIHashTable___uiHTEvent_get(s__uiHashTable_eventdata,frame)
            call BJDebugMsg("RightClick:" + I2S(data))
    return true
endfunction

function jasshelper__initstructs1382390 takes nothing returns nothing
    set st__uiImage_setPoint=CreateTrigger()
    call TriggerAddCondition(st__uiImage_setPoint,Condition( function sa__uiImage_setPoint))
    set st__uiImage_setSize=CreateTrigger()
    call TriggerAddCondition(st__uiImage_setSize,Condition( function sa__uiImage_setSize))
    set st__uiImage_texture=CreateTrigger()
    call TriggerAddCondition(st__uiImage_texture,Condition( function sa__uiImage_texture))
    set st__uiImage_create=CreateTrigger()
    call TriggerAddCondition(st__uiImage_create,Condition( function sa__uiImage_create))
    set st__uiImage_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__uiImage_onDestroy,Condition( function sa__uiImage_onDestroy))
    set st__uiBtn_isExist=CreateTrigger()
    call TriggerAddCondition(st__uiBtn_isExist,Condition( function sa__uiBtn_isExist))
    set st__uiBtn_setAllPoint=CreateTrigger()
    call TriggerAddCondition(st__uiBtn_setAllPoint,Condition( function sa__uiBtn_setAllPoint))
    set st__uiBtn_spEnter=CreateTrigger()
    call TriggerAddCondition(st__uiBtn_spEnter,Condition( function sa__uiBtn_spEnter))
    set st__uiBtn_spLeave=CreateTrigger()
    call TriggerAddCondition(st__uiBtn_spLeave,Condition( function sa__uiBtn_spLeave))
    set st__uiBtn_spClick=CreateTrigger()
    call TriggerAddCondition(st__uiBtn_spClick,Condition( function sa__uiBtn_spClick))
    set st__uiBtn_spRightClick=CreateTrigger()
    call TriggerAddCondition(st__uiBtn_spRightClick,Condition( function sa__uiBtn_spRightClick))
    set st__uiBtn_create=CreateTrigger()
    call TriggerAddCondition(st__uiBtn_create,Condition( function sa__uiBtn_create))
    set st__uiBtn_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__uiBtn_onDestroy,Condition( function sa__uiBtn_onDestroy))
    set st___prototype19[1]=CreateTrigger()
    call TriggerAddAction(st___prototype19[1],function sa___prototype19_UTUISimpleEvent___anon__0)
    call TriggerAddCondition(st___prototype19[1],Condition(function sa___prototype19_UTUISimpleEvent___anon__0))
    set st___prototype19[2]=CreateTrigger()
    call TriggerAddAction(st___prototype19[2],function sa___prototype19_UTUISimpleEvent___anon__1)
    call TriggerAddCondition(st___prototype19[2],Condition(function sa___prototype19_UTUISimpleEvent___anon__1))
    set st___prototype19[3]=CreateTrigger()
    call TriggerAddAction(st___prototype19[3],function sa___prototype19_UTUISimpleEvent___anon__2)
    call TriggerAddCondition(st___prototype19[3],Condition(function sa___prototype19_UTUISimpleEvent___anon__2))
    set st___prototype19[4]=CreateTrigger()
    call TriggerAddAction(st___prototype19[4],function sa___prototype19_UTUISimpleEvent___anon__3)
    call TriggerAddCondition(st___prototype19[4],Condition(function sa___prototype19_UTUISimpleEvent___anon__3))












    call ExecuteFunc("s__mapBounds_onInit")
    call ExecuteFunc("s__uiId_onInit")
    call ExecuteFunc("s__uiLifeCycle_onInit")
    call ExecuteFunc("s__hardware_onInit")
endfunction

