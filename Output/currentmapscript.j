globals
//globals from BzAPI:
constant boolean LIBRARY_BzAPI=true
//endglobals from BzAPI
//globals from GrowData:
constant boolean LIBRARY_GrowData=true
//endglobals from GrowData
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
//globals from UIAnimTimer:
constant boolean LIBRARY_UIAnimTimer=true
//endglobals from UIAnimTimer
//globals from UIEventModule:
constant boolean LIBRARY_UIEventModule=true
//endglobals from UIEventModule
//globals from UIHashTable:
constant boolean LIBRARY_UIHashTable=true
hashtable HASH_UI=InitHashtable()
integer UIHashTable__frame=0
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
//globals from UITextModule:
constant boolean LIBRARY_UITextModule=true
//endglobals from UITextModule
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
//globals from UITocInit:
constant boolean LIBRARY_UITocInit=true
//endglobals from UITocInit
//globals from UIUtils:
constant boolean LIBRARY_UIUtils=true
//endglobals from UIUtils
//globals from BaseAnim:
constant boolean LIBRARY_BaseAnim=true
//endglobals from BaseAnim
//globals from UIBaseModule:
constant boolean LIBRARY_UIBaseModule=true
//endglobals from UIBaseModule
//globals from UIExtendResize:
constant boolean LIBRARY_UIExtendResize=true
//endglobals from UIExtendResize
//globals from UIButton:
constant boolean LIBRARY_UIButton=true
//endglobals from UIButton
//globals from UIImage:
constant boolean LIBRARY_UIImage=true
//endglobals from UIImage
//globals from UISprite:
constant boolean LIBRARY_UISprite=true
//endglobals from UISprite
//globals from UIText:
constant boolean LIBRARY_UIText=true
//endglobals from UIText
//globals from ProgressAnim:
constant boolean LIBRARY_ProgressAnim=true
//endglobals from ProgressAnim
//globals from Icon:
constant boolean LIBRARY_Icon=true
//endglobals from Icon
//globals from UTIcon:
constant boolean LIBRARY_UTIcon=true
integer UTIcon__testIcon1=0
boolean UTIcon__isTest1Active=false
boolean UTIcon__isTest3Active=false
boolean UTIcon__isTest4Active=false
boolean UTIcon__isTest7Active=false
//endglobals from UTIcon
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
constant integer si__growdata=1
integer array s__growdata_max
integer array s__growdata_gap
real array s__growdata_scale
string array s__growdata_path
constant integer si__mapBounds=2
integer si__mapBounds_F=0
integer si__mapBounds_I=0
integer array si__mapBounds_V
real s__mapBounds_maxX=0.
real s__mapBounds_minX=0.
real s__mapBounds_maxY=0.
real s__mapBounds_minY=0.
constant integer si__radiationEnd=3
integer si__radiationEnd_F=0
integer si__radiationEnd_I=0
integer array si__radiationEnd_V
real s__radiationEnd_x=0
real s__radiationEnd_y=0
constant integer si__uianim=4
integer si__uianim_F=0
integer si__uianim_I=0
integer array si__uianim_V
integer array s__uianim_UIAList
integer s__uianim_size=0
trigger array s__uianim_trig
integer array s__uianim_trID
constant integer si__UIHashTable__uiHT=5
integer array s__UIHashTable__uiHT_eventdata
integer array s__UIHashTable__uiHT_ui
constant integer si__UIHashTable__uiHTFrame=6
constant integer si__UIHashTable__uiHTEvent=7
constant integer si__uiId=8
hashtable s__uiId_ht
integer s__uiId_nextId
integer s__uiId_recycleCount
constant integer si__uiLifeCycle=9
integer s__uiLifeCycle_agrsUI=0
integer s__uiLifeCycle_agrsTypeID=0
integer s__uiLifeCycle_agrsFrame=0
trigger s__uiLifeCycle_trCreate=null
trigger s__uiLifeCycle_trDestroy=null
constant integer si__hardware=10
integer si__hardware_F=0
integer si__hardware_I=0
integer array si__hardware_V
trigger s__hardware_trWheel=null
trigger s__hardware_trUpdate=null
trigger s__hardware_trResize=null
trigger s__hardware_trMove=null
constant integer si__baseanim=11
integer si__baseanim_F=0
integer si__baseanim_I=0
integer array si__baseanim_V
integer array s__baseanim_DList
integer array s__baseanim_MList
integer array s__baseanim_AList
integer array s__baseanim_ZList
integer array s__baseanim_SList
integer array s__baseanim_BList
integer array s__baseanim_LList
integer s__baseanim_DNum=0
integer s__baseanim_MNum=0
integer s__baseanim_ANum=0
integer s__baseanim_ZNum=0
integer s__baseanim_SNum=0
integer s__baseanim_BNum=0
integer s__baseanim_LNum=0
integer s__baseanim_UIA=0
integer s__baseanim_size=0
integer array s__baseanim_ui
integer array s__baseanim_dID
integer array s__baseanim_dTime
integer array s__baseanim_dNow
integer array s__baseanim_align
integer array s__baseanim_mTime
integer array s__baseanim_mNow
integer array s__baseanim_anchor1
integer array s__baseanim_anchor2
integer array s__baseanim_mID
real array s__baseanim_dist
real array s__baseanim_off
real array s__baseanim_angle
integer array s__baseanim_aID
integer array s__baseanim_aStart
integer array s__baseanim_aTar
integer array s__baseanim_aTime
integer array s__baseanim_aNow
integer array s__baseanim_zID
integer array s__baseanim_zTime
integer array s__baseanim_zNow
real array s__baseanim_zStartX
real array s__baseanim_zTarX
real array s__baseanim_zStartY
real array s__baseanim_zTarY
string array s__baseanim_sPath
integer array s__baseanim_sID
integer array s__baseanim_sMax
integer array s__baseanim_sPos
integer array s__baseanim_sGap
integer array s__baseanim_sGapPos
boolean array s__baseanim_sLoop
integer array s__baseanim_bID
integer array s__baseanim_bPeriod
integer array s__baseanim_bTime
integer array s__baseanim_bStart
boolean array s__baseanim_bOrient
integer array s__baseanim_lID
integer array s__baseanim_lPeriod
integer array s__baseanim_lTime
integer array s__baseanim_lCB
constant integer si__resizer=12
integer si__resizer_F=0
integer si__resizer_I=0
integer array si__resizer_V
integer array s__resizer_List
integer s__resizer_size=0
integer array s__resizer_frame
real array s__resizer_width
real array s__resizer_height
integer array s__resizer_uID
constant integer si__rePointer=13
integer si__rePointer_F=0
integer si__rePointer_I=0
integer array si__rePointer_V
integer array s__rePointer_List
integer s__rePointer_size=0
integer array s__rePointer_frame
integer array s__rePointer_anchor
integer array s__rePointer_relative
integer array s__rePointer_relativeAnchor
real array s__rePointer_offsetX
real array s__rePointer_offsetY
integer array s__rePointer_uID
constant integer si__uiBtn=14
integer si__uiBtn_F=0
integer si__uiBtn_I=0
integer array si__uiBtn_V
integer array s__uiBtn_ui
integer array s__uiBtn_id
constant integer si__uiImage=15
integer si__uiImage_F=0
integer si__uiImage_I=0
integer array si__uiImage_V
integer array s__uiImage_ui
integer array s__uiImage_id
constant integer si__uiSprite=16
integer si__uiSprite_F=0
integer si__uiSprite_I=0
integer array si__uiSprite_V
integer array s__uiSprite_ui
integer array s__uiSprite_id
constant integer si__uiText=17
integer si__uiText_F=0
integer si__uiText_I=0
integer array si__uiText_V
integer array s__uiText_ui
integer array s__uiText_id
constant integer si__progAnim=18
integer si__progAnim_F=0
integer si__progAnim_I=0
integer array si__progAnim_V
integer array s__progAnim_List
integer s__progAnim_size=0
integer s__progAnim_UIA=0
integer array s__progAnim_sprite
real array s__progAnim_from
real array s__progAnim_to
integer array s__progAnim_time
integer array s__progAnim_now
integer array s__progAnim_id
integer array s__progAnim_cb
constant integer si__icon=19
integer si__icon_F=0
integer si__icon_I=0
integer array si__icon_V
integer array s__icon_mainImage
integer array s__icon_shadowImage
integer array s__icon_cornerShade
integer array s__icon_glowImage
integer array s__icon_cornerText
integer array s__icon_clickBtn
integer array s__icon_cdSprite
integer array s__icon_glowAnim
integer array s__icon_gd
real array s__icon_sizeX
real array s__icon_sizeY
boolean array s__icon_isResize
boolean array s__icon_isSimple
integer array s__icon_spAnchor
integer array s__icon_spRelative
integer array s__icon_spRelativeAnchor
real array s__icon_spOffsetX
real array s__icon_spOffsetY
trigger st__baseanim_onDestroy
trigger st__resizer_onDestroy
trigger st__rePointer_onDestroy
trigger st__uiBtn_onDestroy
trigger st__uiImage_onDestroy
trigger st__uiSprite_onDestroy
trigger st__uiText_onDestroy
trigger st__progAnim_create
trigger st__progAnim_onDestroy
trigger st__icon_onDestroy
trigger array st___prototype20
integer f__arg_integer1
integer f__arg_integer2
integer f__arg_integer3
real f__arg_real1
real f__arg_real2
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


//Generated method caller for icon.onDestroy
function sc__icon_onDestroy takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__icon_onDestroy)
endfunction

//Generated allocator of icon
function s__icon__allocate takes nothing returns integer
 local integer this=si__icon_F
    if (this!=0) then
        set si__icon_F=si__icon_V[this]
    else
        set si__icon_I=si__icon_I+1
        set this=si__icon_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: icon")
        return 0
    endif

    set si__icon_V[this]=-1
 return this
endfunction

//Generated destructor of icon
function sc__icon_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: icon")
        return
    elseif (si__icon_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: icon")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__icon_onDestroy)
    set si__icon_V[this]=si__icon_F
    set si__icon_F=this
endfunction

//Generated method caller for progAnim.create
function sc__progAnim_create takes integer sprite,real from,real to,integer time,integer cb returns integer
    set f__arg_integer1=sprite
    set f__arg_real1=from
    set f__arg_real2=to
    set f__arg_integer2=time
    set f__arg_integer3=cb
    call TriggerEvaluate(st__progAnim_create)
 return f__result_integer
endfunction

//Generated method caller for progAnim.onDestroy
function sc__progAnim_onDestroy takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__progAnim_onDestroy)
endfunction

//Generated allocator of progAnim
function s__progAnim__allocate takes nothing returns integer
 local integer this=si__progAnim_F
    if (this!=0) then
        set si__progAnim_F=si__progAnim_V[this]
    else
        set si__progAnim_I=si__progAnim_I+1
        set this=si__progAnim_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: progAnim")
        return 0
    endif

    set si__progAnim_V[this]=-1
 return this
endfunction

//Generated destructor of progAnim
function sc__progAnim_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: progAnim")
        return
    elseif (si__progAnim_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: progAnim")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__progAnim_onDestroy)
    set si__progAnim_V[this]=si__progAnim_F
    set si__progAnim_F=this
endfunction

//Generated method caller for uiText.onDestroy
function sc__uiText_onDestroy takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__uiText_onDestroy)
endfunction

//Generated allocator of uiText
function s__uiText__allocate takes nothing returns integer
 local integer this=si__uiText_F
    if (this!=0) then
        set si__uiText_F=si__uiText_V[this]
    else
        set si__uiText_I=si__uiText_I+1
        set this=si__uiText_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: uiText")
        return 0
    endif

    set si__uiText_V[this]=-1
 return this
endfunction

//Generated destructor of uiText
function sc__uiText_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: uiText")
        return
    elseif (si__uiText_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: uiText")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__uiText_onDestroy)
    set si__uiText_V[this]=si__uiText_F
    set si__uiText_F=this
endfunction

//Generated method caller for uiSprite.onDestroy
function sc__uiSprite_onDestroy takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__uiSprite_onDestroy)
endfunction

//Generated allocator of uiSprite
function s__uiSprite__allocate takes nothing returns integer
 local integer this=si__uiSprite_F
    if (this!=0) then
        set si__uiSprite_F=si__uiSprite_V[this]
    else
        set si__uiSprite_I=si__uiSprite_I+1
        set this=si__uiSprite_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: uiSprite")
        return 0
    endif

    set si__uiSprite_V[this]=-1
 return this
endfunction

//Generated destructor of uiSprite
function sc__uiSprite_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: uiSprite")
        return
    elseif (si__uiSprite_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: uiSprite")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__uiSprite_onDestroy)
    set si__uiSprite_V[this]=si__uiSprite_F
    set si__uiSprite_F=this
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

//Generated method caller for rePointer.onDestroy
function sc__rePointer_onDestroy takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__rePointer_onDestroy)
endfunction

//Generated allocator of rePointer
function s__rePointer__allocate takes nothing returns integer
 local integer this=si__rePointer_F
    if (this!=0) then
        set si__rePointer_F=si__rePointer_V[this]
    else
        set si__rePointer_I=si__rePointer_I+1
        set this=si__rePointer_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: rePointer")
        return 0
    endif

    set si__rePointer_V[this]=-1
 return this
endfunction

//Generated destructor of rePointer
function sc__rePointer_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: rePointer")
        return
    elseif (si__rePointer_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: rePointer")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__rePointer_onDestroy)
    set si__rePointer_V[this]=si__rePointer_F
    set si__rePointer_F=this
endfunction

//Generated method caller for resizer.onDestroy
function sc__resizer_onDestroy takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__resizer_onDestroy)
endfunction

//Generated allocator of resizer
function s__resizer__allocate takes nothing returns integer
 local integer this=si__resizer_F
    if (this!=0) then
        set si__resizer_F=si__resizer_V[this]
    else
        set si__resizer_I=si__resizer_I+1
        set this=si__resizer_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: resizer")
        return 0
    endif

    set si__resizer_V[this]=-1
 return this
endfunction

//Generated destructor of resizer
function sc__resizer_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: resizer")
        return
    elseif (si__resizer_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: resizer")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__resizer_onDestroy)
    set si__resizer_V[this]=si__resizer_F
    set si__resizer_F=this
endfunction

//Generated method caller for baseanim.onDestroy
function sc__baseanim_onDestroy takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__baseanim_onDestroy)
endfunction

//Generated allocator of baseanim
function s__baseanim__allocate takes nothing returns integer
 local integer this=si__baseanim_F
    if (this!=0) then
        set si__baseanim_F=si__baseanim_V[this]
    else
        set si__baseanim_I=si__baseanim_I+1
        set this=si__baseanim_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: baseanim")
        return 0
    endif

    set si__baseanim_V[this]=-1
 return this
endfunction

//Generated destructor of baseanim
function sc__baseanim_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: baseanim")
        return
    elseif (si__baseanim_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: baseanim")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__baseanim_onDestroy)
    set si__baseanim_V[this]=si__baseanim_F
    set si__baseanim_F=this
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

//Generated allocator of uianim
function s__uianim__allocate takes nothing returns integer
 local integer this=si__uianim_F
    if (this!=0) then
        set si__uianim_F=si__uianim_V[this]
    else
        set si__uianim_I=si__uianim_I+1
        set this=si__uianim_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: uianim")
        return 0
    endif

    set si__uianim_V[this]=-1
 return this
endfunction

//Generated destructor of uianim
function s__uianim_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: uianim")
        return
    elseif (si__uianim_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: uianim")
        return
    endif
    set si__uianim_V[this]=si__uianim_F
    set si__uianim_F=this
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
function sc___prototype20_execute takes integer i,integer a1 returns nothing
    set f__arg_integer1=a1

    call TriggerExecute(st___prototype20[i])
endfunction
function sc___prototype20_evaluate takes integer i,integer a1 returns nothing
    set f__arg_integer1=a1

    call TriggerEvaluate(st___prototype20[i])

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
//library GrowData:
        //public:  //帧数周期
        function s__growdata_onInit takes nothing returns nothing
            set s__growdata_max[(2)]=11
            set s__growdata_gap[(2)]=3
            set s__growdata_scale[(2)]=1.4
            set s__growdata_path[(2)]="ui\\icongrow\\ig2_"
        endfunction

//library GrowData ends
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
//library UIAnimTimer:
        function s__uianim_isExist takes integer this returns boolean
            return ( this != null and si__uianim_V[this] == - 1 )
        endfunction
        function s__uianim_create takes code fun returns integer
            local integer this=s__uianim__allocate()
            set s__uianim_trig[this]=CreateTrigger()
            call TriggerAddCondition(s__uianim_trig[this], Condition(fun))
            return this
        endfunction  //动画启动,可重复调用
        function s__uianim_reg takes integer this returns nothing
            if ( not ( s__uianim_isExist(this) ) ) then
                return
            endif
            if ( s__uianim_trID[this] == 0 ) then
                set s__uianim_size=s__uianim_size + 1
                set s__uianim_UIAList[s__uianim_size]=this
                set s__uianim_trID[this]=s__uianim_size
            endif
        endfunction  //关
        function s__uianim_unreg takes integer this returns nothing
            if ( s__uianim_trID[this] != 0 ) then //这个其实就是将List的[2]设成5  假设2是删  5是最长
                set s__uianim_UIAList[s__uianim_trID[this]]=s__uianim_UIAList[s__uianim_size] //然后实例5的trID设成了2(之后再新建的话又是5了  这个基本也是独立) //但是实例[2]本身的内容已经被清除 循环读的是List不受影响(虽然List[5]还是5但是无影响)
                set s__uianim_trID[s__uianim_UIAList[s__uianim_trID[this]]]=s__uianim_trID[this]
                set s__uianim_size=s__uianim_size - 1
                set s__uianim_trID[this]=0
            endif
        endfunction  //共享打印方法
        function s__uianim_toString takes nothing returns string
            local string s=I2S(s__uianim_size) + "个:"
            local integer i
            set i=1
            loop
            exitwhen ( i > s__uianim_size )
                set s=s + "[" + I2S(i) + "]|r" + I2S(s__uianim_UIAList[i]) + "->"
            set i=i + 1
            endloop
            set s=s + "/"
            return s
        endfunction
            function s__uianim_anon__0 takes nothing returns nothing
                local integer i
                local integer this
                if ( s__uianim_size > 0 ) then
                    set i=1
                    loop
                    exitwhen ( i > s__uianim_size )
                        set this=s__uianim_UIAList[i] //这里可以设置一个静态成员来传参获得是第几个uia
                        call TriggerEvaluate(s__uianim_trig[this])
                    set i=i + 1
                    endloop
                endif
            endfunction
        function s__uianim_onInit takes nothing returns nothing
            local timer t=CreateTimer()
            call TimerStart(t, 0.02, true, function s__uianim_anon__0)
            set t=null
        endfunction

//library UIAnimTimer ends
//library UIEventModule:

//library UIEventModule ends
//library UIHashTable:
    function uiHashTable takes integer f returns integer
        set UIHashTable__frame=f
        return (0)
    endfunction  //私有
        function s__UIHashTable__uiHTFrame_bind takes integer this,integer typeID,integer ui returns nothing
            call SaveInteger(HASH_UI, UIHashTable__frame, 1820, typeID)
            call SaveInteger(HASH_UI, UIHashTable__frame, 1821, ui)
        endfunction  // 从frame获取UI实例
        function s__UIHashTable__uiHTFrame_get takes integer this returns integer
            return LoadInteger(HASH_UI, UIHashTable__frame, 1821)
        endfunction  // 从frame获取UI类型
        function s__UIHashTable__uiHTFrame_getType takes integer this returns integer
            return LoadInteger(HASH_UI, UIHashTable__frame, 1820)
        endfunction
        function s__UIHashTable__uiHTEvent_bind takes integer this,integer value returns nothing
            call SaveInteger(HASH_UI, UIHashTable__frame, 1823, value)
        endfunction
        function s__UIHashTable__uiHTEvent_get takes integer this returns integer
            return LoadInteger(HASH_UI, UIHashTable__frame, 1823)
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
//library UITextModule:

//library UITextModule ends
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
    function YDTriggerSaveLoadSystem__Init takes nothing returns nothing
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
//library UITocInit:

    function UITocInit__onInit takes nothing returns nothing
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
//library BaseAnim:
//processed:     function interface onLifeEnd takes baseanim arg0 returns nothing
        function s__baseanim_isExist takes integer this returns boolean
            return ( this != null and si__baseanim_V[this] == - 1 )
        endfunction
        function s__baseanim_create takes integer ui returns integer
            local integer this=s__baseanim__allocate()
            set s__baseanim_ui[this]=ui
            call SaveInteger(HASH_UI, ui, 1822, this) //统计数量++
            set s__baseanim_size=s__baseanim_size + 1
            return this
        endfunction  //延迟组
        function s__baseanim_addDelay takes integer this,integer time returns nothing
            if ( time <= 0 or ( not ( s__baseanim_isExist(this) ) ) ) then //数据设置都放这
                return
            endif
            set s__baseanim_dTime[this]=time
            set s__baseanim_dNow[this]=0 //这里是初始化时的设置内容,不需要改
            if ( s__baseanim_dID[this] == 0 ) then
                set s__baseanim_DNum=s__baseanim_DNum + 1
                set s__baseanim_DList[s__baseanim_DNum]=this
                set s__baseanim_dID[this]=s__baseanim_DNum
            endif //Add了后就调用了这个自动开始
            call s__uianim_reg(s__baseanim_UIA)
        endfunction
        function s__baseanim_delDelay takes integer this returns nothing
            if ( s__baseanim_dID[this] != 0 ) then
                set s__baseanim_DList[s__baseanim_dID[this]]=s__baseanim_DList[s__baseanim_DNum]
                set s__baseanim_dID[s__baseanim_DList[s__baseanim_dID[this]]]=s__baseanim_dID[this]
                set s__baseanim_DNum=s__baseanim_DNum - 1
                set s__baseanim_dID[this]=0
            endif
        endfunction  //移动组
        function s__baseanim_addMove takes integer this,integer align,real off,real dist,integer time,real angle,integer anchor1,integer anchor2 returns nothing
            if ( dist <= 0. or ( not ( s__baseanim_isExist(this) ) ) ) then //数据设置都放这
                return
            endif
            set s__baseanim_align[this]=align
            set s__baseanim_dist[this]=dist
            set s__baseanim_off[this]=off
            set s__baseanim_mTime[this]=time
            set s__baseanim_mNow[this]=0
            set s__baseanim_angle[this]=angle
            set s__baseanim_anchor1[this]=anchor1
            set s__baseanim_anchor2[this]=anchor2 //这里是初始化时的设置内容,不需要改
            if ( s__baseanim_mID[this] == 0 ) then
                set s__baseanim_MNum=s__baseanim_MNum + 1
                set s__baseanim_MList[s__baseanim_MNum]=this
                set s__baseanim_mID[this]=s__baseanim_MNum
            endif
            call DzFrameSetPoint(s__baseanim_ui[this], anchor1, align, anchor2, CosBJ(angle) * off, SinBJ(angle) * off) //Add了后就调用了这个自动开始
            call s__uianim_reg(s__baseanim_UIA)
        endfunction
        function s__baseanim_delMove takes integer this returns nothing
            if ( s__baseanim_mID[this] != 0 ) then
                set s__baseanim_MList[s__baseanim_mID[this]]=s__baseanim_MList[s__baseanim_MNum]
                set s__baseanim_mID[s__baseanim_MList[s__baseanim_mID[this]]]=s__baseanim_mID[this]
                set s__baseanim_MNum=s__baseanim_MNum - 1
                set s__baseanim_mID[this]=0
            endif
        endfunction  //透明组
        function s__baseanim_addAlpha takes integer this,integer start,integer tar,integer time returns nothing
            if ( time <= 0 or ( not ( s__baseanim_isExist(this) ) ) ) then //数据设置都放这
                return
            endif
            set s__baseanim_aStart[this]=start
            set s__baseanim_aTar[this]=tar
            set s__baseanim_aTime[this]=time
            set s__baseanim_aNow[this]=0 //这里是初始化时的设置内容,不需要改
            if ( s__baseanim_aID[this] == 0 ) then
                set s__baseanim_ANum=s__baseanim_ANum + 1
                set s__baseanim_AList[s__baseanim_ANum]=this
                set s__baseanim_aID[this]=s__baseanim_ANum
            endif //这个不能设置的原因是有可能有2个一起设置，存在延迟;
            call DzFrameSetAlpha(s__baseanim_ui[this], start) //Add了后就调用了这个自动开始
            call s__uianim_reg(s__baseanim_UIA)
        endfunction
        function s__baseanim_delAlpha takes integer this returns nothing
            if ( s__baseanim_aID[this] != 0 ) then
                set s__baseanim_AList[s__baseanim_aID[this]]=s__baseanim_AList[s__baseanim_ANum]
                set s__baseanim_aID[s__baseanim_AList[s__baseanim_aID[this]]]=s__baseanim_aID[this]
                set s__baseanim_ANum=s__baseanim_ANum - 1
                set s__baseanim_aID[this]=0
            endif
        endfunction  //放大组[垃圾scale还是用size香]
        function s__baseanim_addZoom takes integer this,real startX,real tarX,real startY,real tarY,integer time returns nothing
            if ( time <= 0 or ( not ( s__baseanim_isExist(this) ) ) ) then //数据设置都放这
                return
            endif
            set s__baseanim_zStartX[this]=startX
            set s__baseanim_zTarX[this]=tarX
            set s__baseanim_zStartY[this]=startY
            set s__baseanim_zTarY[this]=tarY
            set s__baseanim_zTime[this]=time
            set s__baseanim_zNow[this]=0 //这里是初始化时的设置内容,不需要改
            if ( s__baseanim_zID[this] == 0 ) then
                set s__baseanim_ZNum=s__baseanim_ZNum + 1
                set s__baseanim_ZList[s__baseanim_ZNum]=this
                set s__baseanim_zID[this]=s__baseanim_ZNum
            endif
            call DzFrameSetSize(s__baseanim_ui[this], startX, startY) //Add了后就调用了这个自动开始
            call s__uianim_reg(s__baseanim_UIA)
        endfunction
        function s__baseanim_delZoom takes integer this returns nothing
            if ( s__baseanim_zID[this] != 0 ) then
                set s__baseanim_ZList[s__baseanim_zID[this]]=s__baseanim_ZList[s__baseanim_ZNum]
                set s__baseanim_zID[s__baseanim_ZList[s__baseanim_zID[this]]]=s__baseanim_zID[this]
                set s__baseanim_ZNum=s__baseanim_ZNum - 1
                set s__baseanim_zID[this]=0
            endif
        endfunction  //序列组(永恒序列/一次性序列)
        function s__baseanim_addSequ takes integer this,string path,integer maxFrame,integer interval,boolean isL returns nothing
            if ( maxFrame <= 0 or ( not ( s__baseanim_isExist(this) ) ) ) then //数据设置都放这
                return
            endif
            set s__baseanim_sPath[this]=path //路径; //最大帧数;
            set s__baseanim_sMax[this]=maxFrame //当前帧;
            set s__baseanim_sPos[this]=0 //帧间隔;
            set s__baseanim_sGap[this]=interval //帧间隔;
            set s__baseanim_sGapPos[this]=0 //是否循环;
            set s__baseanim_sLoop[this]=isL //这里是初始化时的设置内容,不需要改
            if ( s__baseanim_sID[this] == 0 ) then
                set s__baseanim_SNum=s__baseanim_SNum + 1
                set s__baseanim_SList[s__baseanim_SNum]=this
                set s__baseanim_sID[this]=s__baseanim_SNum
            endif
            call DzFrameSetTexture(s__baseanim_ui[this], s__baseanim_sPath[this] + "0.blp", 0) //Add了后就调用了这个自动开始
            call s__uianim_reg(s__baseanim_UIA)
        endfunction
        function s__baseanim_delSequ takes integer this returns nothing
            set s__baseanim_sPath[this]=null
            if ( s__baseanim_sID[this] != 0 ) then
                set s__baseanim_SList[s__baseanim_sID[this]]=s__baseanim_SList[s__baseanim_SNum]
                set s__baseanim_sID[s__baseanim_SList[s__baseanim_sID[this]]]=s__baseanim_sID[this]
                set s__baseanim_SNum=s__baseanim_SNum - 1
                set s__baseanim_sID[this]=0
            endif
        endfunction  //闪烁组
        function s__baseanim_addBlink takes integer this,integer start,integer period returns nothing
            if ( period <= 0 or ( not ( s__baseanim_isExist(this) ) ) ) then //数据设置都放这
                return
            endif
            set s__baseanim_bStart[this]=start
            set s__baseanim_bOrient[this]=false
            set s__baseanim_bPeriod[this]=period
            set s__baseanim_bTime[this]=0 //这里是初始化时的设置内容,不需要改
            if ( s__baseanim_bID[this] == 0 ) then
                set s__baseanim_BNum=s__baseanim_BNum + 1
                set s__baseanim_BList[s__baseanim_BNum]=this
                set s__baseanim_bID[this]=s__baseanim_BNum
            endif
            call DzFrameSetAlpha(s__baseanim_ui[this], start) //Add了后就调用了这个自动开始
            call s__uianim_reg(s__baseanim_UIA)
        endfunction
        function s__baseanim_delBlink takes integer this returns nothing
            if ( s__baseanim_bID[this] != 0 ) then
                set s__baseanim_BList[s__baseanim_bID[this]]=s__baseanim_BList[s__baseanim_BNum]
                set s__baseanim_bID[s__baseanim_BList[s__baseanim_bID[this]]]=s__baseanim_bID[this]
                set s__baseanim_BNum=s__baseanim_BNum - 1
                set s__baseanim_bID[this]=0
            endif
        endfunction  //生命周期组
        function s__baseanim_addLife takes integer this,integer period,integer lCB returns nothing
            if ( period <= 0 or ( not ( s__baseanim_isExist(this) ) ) ) then //数据设置都放这
                return
            endif
            set s__baseanim_lPeriod[this]=period
            set s__baseanim_lTime[this]=0
            set s__baseanim_lCB[this]=lCB //这里是初始化时的设置内容,不需要改
            if ( s__baseanim_lID[this] == 0 ) then
                set s__baseanim_LNum=s__baseanim_LNum + 1
                set s__baseanim_LList[s__baseanim_LNum]=this
                set s__baseanim_lID[this]=s__baseanim_LNum
            endif //Add了后就调用了这个自动开始
            call s__uianim_reg(s__baseanim_UIA)
        endfunction
        function s__baseanim_delLife takes integer this returns nothing
            set s__baseanim_lTime[this]=0
            if ( s__baseanim_lID[this] != 0 ) then //这里开始删ui
                if ( s__baseanim_ui[this] != 0 and s__baseanim_lCB[this] != 0 ) then //因为会自动排泄,防止在回调删UI的时候继续再调用一次
                    call RemoveSavedInteger(HASH_UI, s__baseanim_ui[this], 1822)
                    call sc___prototype20_evaluate(s__baseanim_lCB[this],this)
                endif
                set s__baseanim_LList[s__baseanim_lID[this]]=s__baseanim_LList[s__baseanim_LNum]
                set s__baseanim_lID[s__baseanim_LList[s__baseanim_lID[this]]]=s__baseanim_lID[this]
                set s__baseanim_LNum=s__baseanim_LNum - 1
                set s__baseanim_lID[this]=0
            endif
        endfunction  //析构,手动调用或者生命周期结束时自动调用
        function s__baseanim_onDestroy takes integer this returns nothing
            if ( not ( s__baseanim_isExist(this) ) ) then
                return
            endif
            call s__baseanim_delDelay(this)
            call s__baseanim_delMove(this)
            call s__baseanim_delZoom(this)
            call s__baseanim_delAlpha(this)
            call s__baseanim_delSequ(this)
            call s__baseanim_delBlink(this)
            call s__baseanim_delLife(this)
            if ( HaveSavedInteger(HASH_UI, s__baseanim_ui[this], 1822) ) then
                call RemoveSavedInteger(HASH_UI, s__baseanim_ui[this], 1822)
            endif
            set s__baseanim_ui[this]=0 //统计数量--
            set s__baseanim_size=s__baseanim_size - 1
        endfunction  //查看当前的东西

//Generated destructor of baseanim
function s__baseanim_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: baseanim")
        return
    elseif (si__baseanim_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: baseanim")
        return
    endif
    call s__baseanim_onDestroy(this)
    set si__baseanim_V[this]=si__baseanim_F
    set si__baseanim_F=this
endfunction
        function s__baseanim_toString takes nothing returns string
            local string s=""
            set s=s + "[DNum]" + I2S(s__baseanim_DNum) + "->"
            set s=s + "[MNum]" + I2S(s__baseanim_MNum) + "->"
            set s=s + "[ANum]" + I2S(s__baseanim_ANum) + "->"
            set s=s + "[ZNum]" + I2S(s__baseanim_ZNum) + "->"
            set s=s + "[SNum]" + I2S(s__baseanim_SNum) + "->"
            set s=s + "[BNum]" + I2S(s__baseanim_BNum) + "->"
            set s=s + "[LNum]" + I2S(s__baseanim_LNum)
            return s
        endfunction
            function s__baseanim_anon__0 takes nothing returns nothing
                local integer i
                local integer this
                local real r
                if ( s__baseanim_DNum > 0 ) then
                    set i=1 //从结论来说i就是dID
                    loop
                    exitwhen ( i > s__baseanim_DNum )
                        set this=s__baseanim_DList[i]
                        set s__baseanim_dNow[this]=s__baseanim_dNow[this] + 1 //结束了
                        if ( s__baseanim_dNow[this] >= s__baseanim_dTime[this] ) then
                            set s__baseanim_DList[i]=s__baseanim_DList[s__baseanim_DNum]
                            set s__baseanim_dID[s__baseanim_DList[i]]=i
                            set s__baseanim_DNum=s__baseanim_DNum - 1
                            set s__baseanim_dID[this]=0
                            set i=i - 1
                        endif
                    set i=i + 1
                    endloop
                endif //移动
                if ( s__baseanim_MNum > 0 ) then
                    set i=1 //从结论来说i就是mID
                    loop
                    exitwhen ( i > s__baseanim_MNum )
                        set this=s__baseanim_MList[i]
                        if ( s__baseanim_dID[this] == 0 ) then //结束了
                            if ( s__baseanim_mNow[this] >= s__baseanim_mTime[this] ) then
                                call DzFrameClearAllPoints(s__baseanim_ui[this])
                                call DzFrameSetPoint(s__baseanim_ui[this], s__baseanim_anchor1[this], s__baseanim_align[this], s__baseanim_anchor2[this], CosBJ(s__baseanim_angle[this]) * ( s__baseanim_off[this] + s__baseanim_dist[this] ), SinBJ(s__baseanim_angle[this]) * ( s__baseanim_off[this] + s__baseanim_dist[this] ))
                                set s__baseanim_MList[i]=s__baseanim_MList[s__baseanim_MNum]
                                set s__baseanim_mID[s__baseanim_MList[i]]=i
                                set s__baseanim_MNum=s__baseanim_MNum - 1
                                set i=i - 1
                                set s__baseanim_mID[this]=0
                            else
                                set s__baseanim_mNow[this]=s__baseanim_mNow[this] + 1
                                call DzFrameClearAllPoints(s__baseanim_ui[this])
                                call DzFrameSetPoint(s__baseanim_ui[this], s__baseanim_anchor1[this], s__baseanim_align[this], s__baseanim_anchor2[this], CosBJ(s__baseanim_angle[this]) * ( s__baseanim_off[this] + s__baseanim_dist[this] * s__baseanim_mNow[this] / s__baseanim_mTime[this] ), SinBJ(s__baseanim_angle[this]) * ( s__baseanim_off[this] + s__baseanim_dist[this] * s__baseanim_mNow[this] / s__baseanim_mTime[this] ))
                            endif //还在延迟中不进行操作
                        endif
                    set i=i + 1
                    endloop
                endif //透明度
                if ( s__baseanim_ANum > 0 ) then
                    set i=1 //从结论来说i就是aID
                    loop
                    exitwhen ( i > s__baseanim_ANum )
                        set this=s__baseanim_AList[i] // 结束了
                        if ( s__baseanim_dID[this] == 0 ) then
                            if ( s__baseanim_aNow[this] >= s__baseanim_aTime[this] ) then
                                call DzFrameSetAlpha(s__baseanim_ui[this], s__baseanim_aTar[this])
                                if ( s__baseanim_aTar[this] <= 0 ) then
                                    call DzFrameShow(s__baseanim_ui[this], false)
                                endif
                                set s__baseanim_AList[i]=s__baseanim_AList[s__baseanim_ANum]
                                set s__baseanim_aID[s__baseanim_AList[i]]=i
                                set s__baseanim_ANum=s__baseanim_ANum - 1
                                set i=i - 1
                                set s__baseanim_aID[this]=0
                            else
                                set s__baseanim_aNow[this]=s__baseanim_aNow[this] + 1
                                call DzFrameSetAlpha(s__baseanim_ui[this], R2I(s__baseanim_aStart[this] + ( s__baseanim_aTar[this] - s__baseanim_aStart[this] ) * ( I2R(s__baseanim_aNow[this]) / s__baseanim_aTime[this] )))
                            endif //还在延迟中不进行操作
                        endif
                    set i=i + 1
                    endloop
                endif //放大组
                if ( s__baseanim_ZNum > 0 ) then
                    set i=1 //从结论来说i就是aID
                    loop
                    exitwhen ( i > s__baseanim_ZNum )
                        set this=s__baseanim_ZList[i] // 结束了
                        if ( s__baseanim_dID[this] == 0 ) then
                            if ( s__baseanim_zNow[this] >= s__baseanim_zTime[this] ) then //DzFrameSetScale(ui,zTar);
                                call DzFrameSetSize(s__baseanim_ui[this], s__baseanim_zTarX[this], s__baseanim_zTarY[this])
                                set s__baseanim_ZList[i]=s__baseanim_ZList[s__baseanim_ZNum]
                                set s__baseanim_zID[s__baseanim_ZList[i]]=i
                                set s__baseanim_ZNum=s__baseanim_ZNum - 1
                                set i=i - 1
                                set s__baseanim_zID[this]=0
                            else
                                set s__baseanim_zNow[this]=s__baseanim_zNow[this] + 1
                                call DzFrameSetSize(s__baseanim_ui[this], s__baseanim_zStartX[this] + ( s__baseanim_zTarX[this] - s__baseanim_zStartX[this] ) * ( I2R(s__baseanim_zNow[this]) / s__baseanim_zTime[this] ), s__baseanim_zStartY[this] + ( s__baseanim_zTarY[this] - s__baseanim_zStartY[this] ) * ( I2R(s__baseanim_zNow[this]) / s__baseanim_zTime[this] ))
                            endif //还在延迟中不进行操作
                        endif
                    set i=i + 1
                    endloop
                endif //序列帧
                if ( s__baseanim_SNum > 0 ) then
                    set i=1 //从结论来说i就是sID
                    loop
                    exitwhen ( i > s__baseanim_SNum )
                        set this=s__baseanim_SList[i]
                        if ( s__baseanim_dID[this] == 0 ) then
                            set s__baseanim_sGapPos[this]=s__baseanim_sGapPos[this] + 1 //几帧一绘
                            if ( s__baseanim_sGapPos[this] >= s__baseanim_sGap[this] ) then
                                set s__baseanim_sGapPos[this]=0
                                set s__baseanim_sPos[this]=s__baseanim_sPos[this] + 1 // 结束了,且不循环
                                if ( s__baseanim_sPos[this] > s__baseanim_sMax[this] ) then
                                    set s__baseanim_sPos[this]=0 //不循环
                                    if ( not s__baseanim_sLoop[this] ) then
                                        call DzFrameSetTexture(s__baseanim_ui[this], s__baseanim_sPath[this] + I2S(s__baseanim_sMax[this]) + ".blp", 0)
                                        set s__baseanim_SList[i]=s__baseanim_SList[s__baseanim_SNum]
                                        set s__baseanim_sID[s__baseanim_SList[i]]=i
                                        set s__baseanim_SNum=s__baseanim_SNum - 1
                                        set i=i - 1
                                        set s__baseanim_sID[this]=0
                                    else
                                        call DzFrameSetTexture(s__baseanim_ui[this], s__baseanim_sPath[this] + "0.blp", 0)
                                    endif
                                else //正常绘帧
                                    call DzFrameSetTexture(s__baseanim_ui[this], s__baseanim_sPath[this] + I2S(s__baseanim_sPos[this]) + ".blp", 0)
                                endif
                            endif //还在延迟中不进行操作
                        endif
                    set i=i + 1
                    endloop
                endif //闪烁组
                if ( s__baseanim_BNum > 0 ) then
                    set i=1 //从结论来说i就是aID
                    loop
                    exitwhen ( i > s__baseanim_BNum )
                        set this=s__baseanim_BList[i]
                        if ( s__baseanim_dID[this] == 0 ) then //变透明
                            if ( s__baseanim_bOrient[this] ) then
                                set s__baseanim_bTime[this]=s__baseanim_bTime[this] - 1 //实体化
                            else
                                set s__baseanim_bTime[this]=s__baseanim_bTime[this] + 1
                            endif
                            if ( s__baseanim_bTime[this] >= R2I(s__baseanim_bPeriod[this] * 0.5) or s__baseanim_bTime[this] <= 0 ) then
                                set s__baseanim_bOrient[this]=not s__baseanim_bOrient[this]
                            endif
                            call DzFrameSetAlpha(s__baseanim_ui[this], R2I(255 * ( I2R(s__baseanim_bTime[this]) / s__baseanim_bPeriod[this] * 2 ))) //还在延迟中不进行操作
                        endif
                    set i=i + 1
                    endloop
                endif //生命周期[不受延迟组影响]
                if ( s__baseanim_LNum > 0 ) then
                    set i=1 //从结论来说i就是dID
                    loop
                    exitwhen ( i > s__baseanim_LNum )
                        set this=s__baseanim_LList[i]
                        set s__baseanim_lTime[this]=s__baseanim_lTime[this] + 1 //结束了
                        if ( s__baseanim_lTime[this] >= s__baseanim_lPeriod[this] ) then
                            call s__baseanim_deallocate(this)
                            set i=i - 1
                        endif
                    set i=i + 1
                    endloop
                endif
                if ( s__baseanim_DNum <= 0 and s__baseanim_MNum <= 0 and s__baseanim_ANum <= 0 and s__baseanim_ZNum <= 0 and s__baseanim_SNum <= 0 and s__baseanim_BNum <= 0 and s__baseanim_LNum <= 0 ) then //这里就删计时器吧
                    call s__uianim_unreg(s__baseanim_UIA)
                    call BJDebugMsg("baseanim停止了")
                endif
            endfunction  // UI销毁时回调删除基础动画(UI销毁时会自动调用),但是不需要再删ba了,
            function s__baseanim_anon__1 takes nothing returns nothing
                local integer ui=s__uiLifeCycle_agrsFrame
                local integer this
                if ( HaveSavedInteger(HASH_UI, ui, 1822) ) then
                    set this=LoadInteger(HASH_UI, ui, 1822)
                    if ( s__baseanim_isExist(this) ) then
                        call s__baseanim_deallocate(this)
                    endif
                endif
            endfunction
        function s__baseanim_onInit takes nothing returns nothing
            set s__baseanim_UIA=s__uianim_create(function s__baseanim_anon__0)
            call s__uiLifeCycle_registerDestroy(function s__baseanim_anon__1)
        endfunction

//library BaseAnim ends
//library UIBaseModule:

//library UIBaseModule ends
//library UIExtendResize:

        function s__resizer_isExist takes integer this returns boolean
            return ( this != null and si__resizer_V[this] == - 1 )
        endfunction
        function s__resizer_create takes integer frame,real width,real height returns integer
            local integer this=s__resizer__allocate()
            set s__resizer_frame[this]=frame
            set s__resizer_width[this]=width
            set s__resizer_height[this]=height //这里是初始化时的设置内容,不需要改
            if ( s__resizer_uID[this] == 0 ) then
                set s__resizer_size=s__resizer_size + 1
                set s__resizer_List[s__resizer_size]=this
                set s__resizer_uID[this]=s__resizer_size
            endif
            return this
        endfunction
        function s__resizer_toString takes nothing returns string
            local string s=I2S(s__resizer_size) + "个:"
            local integer i
            set i=1
            loop
            exitwhen ( i > s__resizer_size )
                set s=s + "[" + I2S(i) + "]|r" + I2S(s__resizer_List[i]) + "->"
            set i=i + 1
            endloop
            set s=s + "/"
            return s
        endfunction
        function s__resizer_onDestroy takes integer this returns nothing
            set s__resizer_frame[this]=0
            if ( s__resizer_uID[this] != 0 ) then
                set s__resizer_List[s__resizer_uID[this]]=s__resizer_List[s__resizer_size]
                set s__resizer_uID[s__resizer_List[s__resizer_uID[this]]]=s__resizer_uID[this]
                set s__resizer_size=s__resizer_size - 1
                set s__resizer_uID[this]=0
            endif
        endfunction

//Generated destructor of resizer
function s__resizer_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: resizer")
        return
    elseif (si__resizer_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: resizer")
        return
    endif
    call s__resizer_onDestroy(this)
    set si__resizer_V[this]=si__resizer_F
    set si__resizer_F=this
endfunction
        function s__rePointer_isExist takes integer this returns boolean
            return ( this != null and si__rePointer_V[this] == - 1 )
        endfunction
        function s__rePointer_create takes integer frame,integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns integer
            local integer this=s__rePointer__allocate()
            set s__rePointer_frame[this]=frame
            set s__rePointer_anchor[this]=anchor
            set s__rePointer_relative[this]=relative
            set s__rePointer_relativeAnchor[this]=relativeAnchor
            set s__rePointer_offsetX[this]=offsetX
            set s__rePointer_offsetY[this]=offsetY //这里是初始化时的设置内容,不需要改
            if ( s__rePointer_uID[this] == 0 ) then
                set s__rePointer_size=s__rePointer_size + 1
                set s__rePointer_List[s__rePointer_size]=this
                set s__rePointer_uID[this]=s__rePointer_size
            endif
            return this
        endfunction
        function s__rePointer_toString takes nothing returns string
            local string s=I2S(s__rePointer_size) + "个:"
            local integer i
            set i=1
            loop
            exitwhen ( i > s__rePointer_size )
                set s=s + "[" + I2S(i) + "]|r" + I2S(s__rePointer_List[i]) + "->"
            set i=i + 1
            endloop
            set s=s + "/"
            return s
        endfunction
        function s__rePointer_onDestroy takes integer this returns nothing
            set s__rePointer_frame[this]=0
            if ( s__rePointer_uID[this] != 0 ) then
                set s__rePointer_List[s__rePointer_uID[this]]=s__rePointer_List[s__rePointer_size]
                set s__rePointer_uID[s__rePointer_List[s__rePointer_uID[this]]]=s__rePointer_uID[this]
                set s__rePointer_size=s__rePointer_size - 1
                set s__rePointer_uID[this]=0
            endif
        endfunction

//Generated destructor of rePointer
function s__rePointer_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: rePointer")
        return
    elseif (si__rePointer_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: rePointer")
        return
    endif
    call s__rePointer_onDestroy(this)
    set si__rePointer_V[this]=si__rePointer_F
    set si__rePointer_F=this
endfunction
        function UIExtendResize__anon__0 takes nothing returns nothing
            local real resizeX=GetResizeRate()
            local integer i
            local integer ser
            if ( s__resizer_size > 0 ) then //反向遍历可以删除下面的　i-= 1
                set i=s__resizer_size //从结论来说i就是.uID
                loop
                exitwhen i < 1
                    set ser=s__resizer_List[i]
                    call DzFrameSetSize(s__resizer_frame[ser], s__resizer_width[ser] * resizeX, s__resizer_height[ser])
                set i=i - 1
                endloop
            endif
        endfunction  //注册窗口大小变化事件
        function UIExtendResize__anon__1 takes nothing returns nothing
            local real resizeX=GetResizeRate()
            local integer i
            local integer ptr
            if ( s__rePointer_size > 0 ) then //反向遍历可以删除下面的　i-= 1
                set i=s__rePointer_size //从结论来说i就是.uID
                loop
                exitwhen i < 1
                    set ptr=s__rePointer_List[i]
                    call DzFrameSetPoint(s__rePointer_frame[ptr], s__rePointer_anchor[ptr], s__rePointer_relative[ptr], s__rePointer_relativeAnchor[ptr], s__rePointer_offsetX[ptr] * resizeX, s__rePointer_offsetY[ptr])
                set i=i - 1
                endloop
            endif
        endfunction  //UI的销毁回调事件
        function UIExtendResize__anon__2 takes nothing returns nothing
            local integer frame=s__uiLifeCycle_agrsFrame
            local integer ser
            local integer ptr
            if ( HaveSavedInteger(HASH_UI, frame, 1940) ) then
                set ser=LoadInteger(HASH_UI, frame, 1940)
                if ( s__resizer_isExist(ser) ) then
                    call s__resizer_deallocate(ser)
                endif
            endif
            if ( HaveSavedInteger(HASH_UI, frame, 1941) ) then
                set ptr=LoadInteger(HASH_UI, frame, 1941)
                if ( s__rePointer_isExist(ptr) ) then
                    call s__rePointer_deallocate(ptr)
                endif
            endif
        endfunction
    function UIExtendResize__onInit takes nothing returns nothing
        call s__hardware_regResizeEvent(function UIExtendResize__anon__0)
        call s__hardware_regResizeEvent(function UIExtendResize__anon__1)
        call s__uiLifeCycle_registerDestroy(function UIExtendResize__anon__2)
    endfunction

//library UIExtendResize ends
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
        endfunction  // 显示控件
        function s__uiBtn_show takes integer this,boolean flag returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameShow(s__uiBtn_ui[this], flag)
            return this
        endfunction  //透明度(0-255)
        function s__uiBtn_setAlpha takes integer this,integer value returns integer
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAlpha(s__uiBtn_ui[this], value)
            return this
        endfunction  //扩展自适应大小方法
        function s__uiBtn_exReSize takes integer this,real width,real height returns integer
            local integer ser
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            if ( HaveSavedInteger(HASH_UI, s__uiBtn_ui[this], 1940) ) then
                set ser=LoadInteger(HASH_UI, s__uiBtn_ui[this], 1940)
                set s__resizer_frame[ser]=s__uiBtn_ui[this]
                set s__resizer_width[ser]=width
                set s__resizer_height[ser]=height
            else
                set ser=s__resizer_create(s__uiBtn_ui[this] , width , height)
                call SaveInteger(HASH_UI, s__uiBtn_ui[this], 1940, ser)
            endif
            call DzFrameSetSize(s__uiBtn_ui[this], width * GetResizeRate(), height)
            return this
        endfunction
        function s__uiBtn_exRePoint takes integer this,integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns integer
            local integer ptr
            if ( not ( s__uiBtn_isExist(this) ) ) then
                return this
            endif
            if ( HaveSavedInteger(HASH_UI, s__uiBtn_ui[this], 1941) ) then
                set ptr=LoadInteger(HASH_UI, s__uiBtn_ui[this], 1941)
                set s__rePointer_frame[ptr]=s__uiBtn_ui[this]
                set s__rePointer_anchor[ptr]=anchor
                set s__rePointer_relative[ptr]=relative
                set s__rePointer_relativeAnchor[ptr]=relativeAnchor
                set s__rePointer_offsetX[ptr]=offsetX
                set s__rePointer_offsetY[ptr]=offsetY
            else
                set ptr=s__rePointer_create(s__uiBtn_ui[this] , anchor , relative , relativeAnchor , offsetX , offsetY)
                call SaveInteger(HASH_UI, s__uiBtn_ui[this], 1941, ptr)
            endif
            call DzFrameSetPoint(s__uiBtn_ui[this], anchor, relative, relativeAnchor, offsetX * GetResizeRate(), offsetY)
            return this
        endfunction
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
        function s__uiBtn_create takes integer parent returns integer
            local integer this=s__uiBtn__allocate()
            set s__uiBtn_id[this]=s__uiId_get() //有高亮无声音的图标
            set s__uiBtn_ui[this]=DzCreateFrameByTagName("BUTTON", "Btn" + I2S(s__uiBtn_id[this]), parent, "BT", 0)
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiBtn , s__uiBtn_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiBtn_ui[this])],si__uiBtn , this)
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
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiBtn_ui[this])],si__uiBtn , this)
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
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiBtn_ui[this])],si__uiBtn , this)
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
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiBtn_ui[this])],si__uiBtn , this)
//#             endif
            return this
        endfunction  // 创建一个用在原生Frame里的按钮,这种按钮是不能destroy的!
        function s__uiBtn_createSimple takes integer parent returns integer
            local integer this=s__uiBtn__allocate()
            set s__uiBtn_id[this]=s__uiId_get()
            set s__uiBtn_ui[this]=DzCreateFrameByTagName("SIMPLEBUTTON", "Btn" + I2S(s__uiBtn_id[this]), parent, "简单按钮", s__uiBtn_id[this])
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiBtn , s__uiBtn_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiBtn_ui[this])],si__uiBtn , this)
//#             endif
            return this
        endfunction  //绑定原生的Button成为SimpleButton,注意不能删除哦
        function s__uiBtn_bindCreated takes integer frame returns integer
            local integer this=s__uiBtn__allocate()
            set s__uiBtn_id[this]=s__uiId_get()
            set s__uiBtn_ui[this]=frame
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiBtn , s__uiBtn_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiBtn_ui[this])],si__uiBtn , this)
//#             endif
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
        endfunction  // 显示控件
        function s__uiImage_show takes integer this,boolean flag returns integer
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            call DzFrameShow(s__uiImage_ui[this], flag)
            return this
        endfunction  //透明度(0-255)
        function s__uiImage_setAlpha takes integer this,integer value returns integer
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAlpha(s__uiImage_ui[this], value)
            return this
        endfunction  //扩展自适应大小方法
        function s__uiImage_exReSize takes integer this,real width,real height returns integer
            local integer ser
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            if ( HaveSavedInteger(HASH_UI, s__uiImage_ui[this], 1940) ) then
                set ser=LoadInteger(HASH_UI, s__uiImage_ui[this], 1940)
                set s__resizer_frame[ser]=s__uiImage_ui[this]
                set s__resizer_width[ser]=width
                set s__resizer_height[ser]=height
            else
                set ser=s__resizer_create(s__uiImage_ui[this] , width , height)
                call SaveInteger(HASH_UI, s__uiImage_ui[this], 1940, ser)
            endif
            call DzFrameSetSize(s__uiImage_ui[this], width * GetResizeRate(), height)
            return this
        endfunction
        function s__uiImage_exRePoint takes integer this,integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns integer
            local integer ptr
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            if ( HaveSavedInteger(HASH_UI, s__uiImage_ui[this], 1941) ) then
                set ptr=LoadInteger(HASH_UI, s__uiImage_ui[this], 1941)
                set s__rePointer_frame[ptr]=s__uiImage_ui[this]
                set s__rePointer_anchor[ptr]=anchor
                set s__rePointer_relative[ptr]=relative
                set s__rePointer_relativeAnchor[ptr]=relativeAnchor
                set s__rePointer_offsetX[ptr]=offsetX
                set s__rePointer_offsetY[ptr]=offsetY
            else
                set ptr=s__rePointer_create(s__uiImage_ui[this] , anchor , relative , relativeAnchor , offsetX , offsetY)
                call SaveInteger(HASH_UI, s__uiImage_ui[this], 1941, ptr)
            endif
            call DzFrameSetPoint(s__uiImage_ui[this], anchor, relative, relativeAnchor, offsetX * GetResizeRate(), offsetY)
            return this
        endfunction
//Implemented from module uiImageModule:
        function s__uiImage_setTexture takes integer this,string path returns integer
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetTexture(s__uiImage_ui[this], path, 0)
            return this
        endfunction  // 设置图片控件视口,防止模型超出范围
        function s__uiImage_setClip takes integer this,boolean clip returns integer
            if ( not ( s__uiImage_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetClip(s__uiImage_ui[this], clip)
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
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiImage_ui[this])],si__uiImage , this)
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
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiImage_ui[this])],si__uiImage , this)
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
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiImage_ui[this])],si__uiImage , this)
//#             endif
            return this
        endfunction  // 创建边角(图标系的)
        function s__uiImage_createCornerBorder takes integer parent returns integer
            local integer this=s__uiImage__allocate()
            set s__uiImage_id[this]=s__uiId_get()
            set s__uiImage_ui[this]=DzCreateFrameByTagName("BACKDROP", "Img" + I2S(s__uiImage_id[this]), parent, "CornerBorder", 0)
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiImage , s__uiImage_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiImage_ui[this])],si__uiImage , this)
//#             endif
            return this
        endfunction  // 创建一个用在原生Frame里的图片,这种图片是不能destroy的!
        function s__uiImage_createSimple takes integer parent returns integer
            local integer this=s__uiImage__allocate()
            set s__uiImage_id[this]=s__uiId_get()
            call DzCreateFrameByTagName("SIMPLEFRAME", "Img" + I2S(s__uiImage_id[this]), parent, "简单图片", s__uiImage_id[this])
            set s__uiImage_ui[this]=DzSimpleTextureFindByName("简单图片内容", s__uiImage_id[this])
            call DzFrameClearAllPoints(s__uiImage_ui[this])
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiImage , s__uiImage_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiImage_ui[this])],si__uiImage , this)
//#             endif
            return this
        endfunction  // 绑定原生图片
        function s__uiImage_bindSimple takes string name,integer index returns integer
            local integer this=s__uiImage__allocate()
            set s__uiImage_id[this]=s__uiId_get()
            set s__uiImage_ui[this]=DzSimpleTextureFindByName(name, index)
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiImage , s__uiImage_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiImage_ui[this])],si__uiImage , this)
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
//library UISprite:
        function s__uiSprite_isExist takes integer this returns boolean
            return ( this != null and si__uiSprite_V[this] == - 1 )
        endfunction
//Implemented from module uiBaseModule:
        function s__uiSprite_setPoint takes integer this,integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns integer
            if ( not ( s__uiSprite_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetPoint(s__uiSprite_ui[this], anchor, relative, relativeAnchor, offsetX, offsetY)
            return this
        endfunction  // 大小完全对齐父框架
        function s__uiSprite_setAllPoint takes integer this,integer relative returns integer
            if ( not ( s__uiSprite_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAllPoints(s__uiSprite_ui[this], relative)
            return this
        endfunction  //绝对位置
        function s__uiSprite_setAbsPoint takes integer this,integer anchor,real x,real y returns integer
            if ( not ( s__uiSprite_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAbsolutePoint(s__uiSprite_ui[this], anchor, x, y)
            return this
        endfunction  // 清除所有位置
        function s__uiSprite_clearPoint takes integer this returns integer
            if ( not ( s__uiSprite_isExist(this) ) ) then
                return this
            endif
            call DzFrameClearAllPoints(s__uiSprite_ui[this])
            return this
        endfunction  // 设置大小
        function s__uiSprite_setSize takes integer this,real width,real height returns integer
            if ( not ( s__uiSprite_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetSize(s__uiSprite_ui[this], width, height)
            return this
        endfunction  // 设置大小(校正后的),只显示一次,此时改窗口大小不会变化
        function s__uiSprite_setSizeFix takes integer this,real width,real height returns integer
            if ( not ( s__uiSprite_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetSize(s__uiSprite_ui[this], width * GetResizeRate(), height)
            return this
        endfunction  // 显示控件
        function s__uiSprite_show takes integer this,boolean flag returns integer
            if ( not ( s__uiSprite_isExist(this) ) ) then
                return this
            endif
            call DzFrameShow(s__uiSprite_ui[this], flag)
            return this
        endfunction  //透明度(0-255)
        function s__uiSprite_setAlpha takes integer this,integer value returns integer
            if ( not ( s__uiSprite_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAlpha(s__uiSprite_ui[this], value)
            return this
        endfunction  //扩展自适应大小方法
        function s__uiSprite_exReSize takes integer this,real width,real height returns integer
            local integer ser
            if ( not ( s__uiSprite_isExist(this) ) ) then
                return this
            endif
            if ( HaveSavedInteger(HASH_UI, s__uiSprite_ui[this], 1940) ) then
                set ser=LoadInteger(HASH_UI, s__uiSprite_ui[this], 1940)
                set s__resizer_frame[ser]=s__uiSprite_ui[this]
                set s__resizer_width[ser]=width
                set s__resizer_height[ser]=height
            else
                set ser=s__resizer_create(s__uiSprite_ui[this] , width , height)
                call SaveInteger(HASH_UI, s__uiSprite_ui[this], 1940, ser)
            endif
            call DzFrameSetSize(s__uiSprite_ui[this], width * GetResizeRate(), height)
            return this
        endfunction
        function s__uiSprite_exRePoint takes integer this,integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns integer
            local integer ptr
            if ( not ( s__uiSprite_isExist(this) ) ) then
                return this
            endif
            if ( HaveSavedInteger(HASH_UI, s__uiSprite_ui[this], 1941) ) then
                set ptr=LoadInteger(HASH_UI, s__uiSprite_ui[this], 1941)
                set s__rePointer_frame[ptr]=s__uiSprite_ui[this]
                set s__rePointer_anchor[ptr]=anchor
                set s__rePointer_relative[ptr]=relative
                set s__rePointer_relativeAnchor[ptr]=relativeAnchor
                set s__rePointer_offsetX[ptr]=offsetX
                set s__rePointer_offsetY[ptr]=offsetY
            else
                set ptr=s__rePointer_create(s__uiSprite_ui[this] , anchor , relative , relativeAnchor , offsetX , offsetY)
                call SaveInteger(HASH_UI, s__uiSprite_ui[this], 1941, ptr)
            endif
            call DzFrameSetPoint(s__uiSprite_ui[this], anchor, relative, relativeAnchor, offsetX * GetResizeRate(), offsetY)
            return this
        endfunction
//Implemented from module panimable:
        function s__uiSprite_progAnimate takes integer this,real from,real to,real duration,integer cb returns integer
            local integer anim
            if ( not ( s__uiSprite_isExist(this) ) ) then // 检查是否已存在progAnim实例
                return this
            endif
            if ( HaveSavedInteger(HASH_UI, s__uiSprite_ui[this], 1945) ) then
                set anim=LoadInteger(HASH_UI, s__uiSprite_ui[this], 1945) // 更新动画参数
                set s__progAnim_sprite[anim]=this
                set s__progAnim_from[anim]=from
                set s__progAnim_to[anim]=to
                set s__progAnim_time[anim]=R2I(duration * 50)
                set s__progAnim_now[anim]=0
                set s__progAnim_cb[anim]=cb
            else // 创建新实例
                set anim=sc__progAnim_create(this , from , to , R2I(duration * 50) , cb)
                call SaveInteger(HASH_UI, s__uiSprite_ui[this], 1945, anim)
            endif
            return this
        endfunction
        function s__uiSprite_create takes integer parent returns integer
            local integer this=s__uiSprite__allocate()
            set s__uiSprite_id[this]=s__uiId_get()
            set s__uiSprite_ui[this]=DzCreateFrameByTagName("SPRITE", "Sprite" + I2S(s__uiSprite_id[this]), parent, "SpriteTemplate", 0)
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiSprite , s__uiSprite_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiSprite_ui[this])],si__uiSprite , this)
//#             endif
            return this
        endfunction  // 设置模型(目前只做平面型就行了,后面2个0固定了)
        function s__uiSprite_setModel takes integer this,string path,integer modelType,integer flag returns integer
            if ( not ( s__uiSprite_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetModel(s__uiSprite_ui[this], path, modelType, flag)
            return this
        endfunction  // 设置缩放
        function s__uiSprite_setScale takes integer this,real scale returns integer
            if ( not ( s__uiSprite_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetScale(s__uiSprite_ui[this], scale)
            return this
        endfunction  // 设置动画
        function s__uiSprite_setAnimate takes integer this,integer animate,boolean auto returns integer
            if ( not ( s__uiSprite_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAnimate(s__uiSprite_ui[this], animate, auto)
            return this
        endfunction  // 设置进度
        function s__uiSprite_setProgress takes integer this,real progress returns integer
            if ( not ( s__uiSprite_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAnimateOffset(s__uiSprite_ui[this], progress)
            return this
        endfunction
        function s__uiSprite_onDestroy takes integer this returns nothing
            if ( not ( s__uiSprite_isExist(this) ) ) then
                return
            endif
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onDestroyCB(this , si__uiSprite , s__uiSprite_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call FlushChildHashtable(HASH_UI, s__uiSprite_ui[this])
//#             endif
            call DzDestroyFrame(s__uiSprite_ui[this])
            call s__uiId_recycle(s__uiSprite_id[this])
        endfunction

//Generated destructor of uiSprite
function s__uiSprite_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: uiSprite")
        return
    elseif (si__uiSprite_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: uiSprite")
        return
    endif
    call s__uiSprite_onDestroy(this)
    set si__uiSprite_V[this]=si__uiSprite_F
    set si__uiSprite_F=this
endfunction

//library UISprite ends
//library UIText:
        function s__uiText_isExist takes integer this returns boolean
            return ( this != null and si__uiText_V[this] == - 1 )
        endfunction
//Implemented from module uiBaseModule:
        function s__uiText_setPoint takes integer this,integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns integer
            if ( not ( s__uiText_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetPoint(s__uiText_ui[this], anchor, relative, relativeAnchor, offsetX, offsetY)
            return this
        endfunction  // 大小完全对齐父框架
        function s__uiText_setAllPoint takes integer this,integer relative returns integer
            if ( not ( s__uiText_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAllPoints(s__uiText_ui[this], relative)
            return this
        endfunction  //绝对位置
        function s__uiText_setAbsPoint takes integer this,integer anchor,real x,real y returns integer
            if ( not ( s__uiText_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAbsolutePoint(s__uiText_ui[this], anchor, x, y)
            return this
        endfunction  // 清除所有位置
        function s__uiText_clearPoint takes integer this returns integer
            if ( not ( s__uiText_isExist(this) ) ) then
                return this
            endif
            call DzFrameClearAllPoints(s__uiText_ui[this])
            return this
        endfunction  // 设置大小
        function s__uiText_setSize takes integer this,real width,real height returns integer
            if ( not ( s__uiText_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetSize(s__uiText_ui[this], width, height)
            return this
        endfunction  // 设置大小(校正后的),只显示一次,此时改窗口大小不会变化
        function s__uiText_setSizeFix takes integer this,real width,real height returns integer
            if ( not ( s__uiText_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetSize(s__uiText_ui[this], width * GetResizeRate(), height)
            return this
        endfunction  // 显示控件
        function s__uiText_show takes integer this,boolean flag returns integer
            if ( not ( s__uiText_isExist(this) ) ) then
                return this
            endif
            call DzFrameShow(s__uiText_ui[this], flag)
            return this
        endfunction  //透明度(0-255)
        function s__uiText_setAlpha takes integer this,integer value returns integer
            if ( not ( s__uiText_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetAlpha(s__uiText_ui[this], value)
            return this
        endfunction  //扩展自适应大小方法
        function s__uiText_exReSize takes integer this,real width,real height returns integer
            local integer ser
            if ( not ( s__uiText_isExist(this) ) ) then
                return this
            endif
            if ( HaveSavedInteger(HASH_UI, s__uiText_ui[this], 1940) ) then
                set ser=LoadInteger(HASH_UI, s__uiText_ui[this], 1940)
                set s__resizer_frame[ser]=s__uiText_ui[this]
                set s__resizer_width[ser]=width
                set s__resizer_height[ser]=height
            else
                set ser=s__resizer_create(s__uiText_ui[this] , width , height)
                call SaveInteger(HASH_UI, s__uiText_ui[this], 1940, ser)
            endif
            call DzFrameSetSize(s__uiText_ui[this], width * GetResizeRate(), height)
            return this
        endfunction
        function s__uiText_exRePoint takes integer this,integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns integer
            local integer ptr
            if ( not ( s__uiText_isExist(this) ) ) then
                return this
            endif
            if ( HaveSavedInteger(HASH_UI, s__uiText_ui[this], 1941) ) then
                set ptr=LoadInteger(HASH_UI, s__uiText_ui[this], 1941)
                set s__rePointer_frame[ptr]=s__uiText_ui[this]
                set s__rePointer_anchor[ptr]=anchor
                set s__rePointer_relative[ptr]=relative
                set s__rePointer_relativeAnchor[ptr]=relativeAnchor
                set s__rePointer_offsetX[ptr]=offsetX
                set s__rePointer_offsetY[ptr]=offsetY
            else
                set ptr=s__rePointer_create(s__uiText_ui[this] , anchor , relative , relativeAnchor , offsetX , offsetY)
                call SaveInteger(HASH_UI, s__uiText_ui[this], 1941, ptr)
            endif
            call DzFrameSetPoint(s__uiText_ui[this], anchor, relative, relativeAnchor, offsetX * GetResizeRate(), offsetY)
            return this
        endfunction
//Implemented from module uiTextModule:
        function s__uiText_setFontSize takes integer this,integer size returns integer
            local real fontSize=0.01
            if ( not ( s__uiText_isExist(this) ) ) then
                return this
            endif
            if ( size == 1 ) then
                set fontSize=0.006
            elseif ( size == 2 ) then
                set fontSize=0.008
            elseif ( size == 3 ) then
                set fontSize=0.009
            elseif ( size == 4 ) then
                set fontSize=0.01
            elseif ( size == 5 ) then
                set fontSize=0.011
            elseif ( size == 6 ) then
                set fontSize=0.012
            elseif ( size == 7 ) then
                set fontSize=0.015
            endif
            call DzFrameSetFont(s__uiText_ui[this], "fonts\\zt.ttf", fontSize, 0)
            return this
        endfunction  // 设置对齐方式(前提要先定好大小,不然无处对齐)
        function s__uiText_setAlign takes integer this,integer align returns integer
            local integer finalAlign=align
            if ( not ( s__uiText_isExist(this) ) ) then // 如果输入0-8,转换为对应的组合值
                return this
            endif
            if ( align >= 0 and align <= 8 ) then
                if ( align == 0 ) then // 左上
                    set finalAlign=9
                elseif ( align == 1 ) then // 顶部居中
                    set finalAlign=17
                elseif ( align == 2 ) then // 右上
                    set finalAlign=33
                elseif ( align == 3 ) then // 左中
                    set finalAlign=10
                elseif ( align == 4 ) then // 居中
                    set finalAlign=18
                elseif ( align == 5 ) then // 右中
                    set finalAlign=34
                elseif ( align == 6 ) then // 左下
                    set finalAlign=12
                elseif ( align == 7 ) then // 底部居中
                    set finalAlign=20
                elseif ( align == 8 ) then // 右下
                    set finalAlign=36
                endif
            endif
            call DzFrameSetTextAlignment(s__uiText_ui[this], finalAlign)
            return this
        endfunction  // 设置文本内容
        function s__uiText_setText takes integer this,string text returns integer
            if ( not ( s__uiText_isExist(this) ) ) then
                return this
            endif
            call DzFrameSetText(s__uiText_ui[this], text)
            return this
        endfunction
        function s__uiText_create takes integer parent returns integer
            local integer this=s__uiText__allocate()
            set s__uiText_id[this]=s__uiId_get()
            set s__uiText_ui[this]=DzCreateFrameByTagName("TEXT", "Text" + I2S(s__uiText_id[this]), parent, "T1", 0)
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiText , s__uiText_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiText_ui[this])],si__uiText , this)
//#             endif
            return this
        endfunction  // 创建一个用在原生Frame里的文本,这种文本是不能destroy的!
        function s__uiText_createSimple takes integer parent returns integer
            local integer this=s__uiText__allocate()
            set s__uiText_id[this]=s__uiId_get()
            call DzCreateFrameByTagName("SIMPLEFRAME", "Text" + I2S(s__uiText_id[this]), parent, "简单文字", s__uiText_id[this])
            set s__uiText_ui[this]=DzSimpleFontStringFindByName("简单文字内容", s__uiText_id[this])
            call DzFrameClearAllPoints(s__uiText_ui[this])
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiText , s__uiText_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiText_ui[this])],si__uiText , this)
//#             endif
            return this
        endfunction  // 绑定原生文本
        function s__uiText_bindSimple takes string name,integer index returns integer
            local integer this=s__uiText__allocate()
            set s__uiText_id[this]=s__uiId_get()
            set s__uiText_ui[this]=DzSimpleFontStringFindByName(name, index)
            call DzFrameClearAllPoints(s__uiText_ui[this])
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onCreateCB(this , si__uiText , s__uiText_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call s__UIHashTable__uiHTFrame_bind(s__UIHashTable__uiHT_ui[uiHashTable(s__uiText_ui[this])],si__uiText , this)
//#             endif
            return this
        endfunction
        function s__uiText_onDestroy takes integer this returns nothing
            if ( not ( s__uiText_isExist(this) ) ) then
                return
            endif
//#             static if LIBRARY_UILifeCycle then
                    call s__uiLifeCycle_onDestroyCB(this , si__uiText , s__uiText_ui[this])
//#             endif
//#             static if LIBRARY_UIHashTable then
                    call FlushChildHashtable(HASH_UI, s__uiText_ui[this])
//#             endif
            call DzDestroyFrame(s__uiText_ui[this])
            call s__uiId_recycle(s__uiText_id[this])
        endfunction

//Generated destructor of uiText
function s__uiText_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: uiText")
        return
    elseif (si__uiText_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: uiText")
        return
    endif
    call s__uiText_onDestroy(this)
    set si__uiText_V[this]=si__uiText_F
    set si__uiText_F=this
endfunction

//library UIText ends
//library ProgressAnim:
//processed:     function interface onProgressEnd takes uiSprite arg0 returns nothing
        function s__progAnim_isExist takes integer this returns boolean
            return ( this != null and si__progAnim_V[this] == - 1 )
        endfunction
        function s__progAnim_create takes integer sprite,real from,real to,integer time,integer cb returns integer
            local integer this=s__progAnim__allocate()
            set s__progAnim_sprite[this]=sprite
            set s__progAnim_from[this]=from
            set s__progAnim_to[this]=to
            set s__progAnim_time[this]=time
            set s__progAnim_now[this]=0
            set s__progAnim_cb[this]=cb // 这里是初始化时的设置内容,不需要改
            if ( s__progAnim_id[this] == 0 ) then
                set s__progAnim_size=s__progAnim_size + 1
                set s__progAnim_List[s__progAnim_size]=this
                set s__progAnim_id[this]=s__progAnim_size
            endif
            call s__uianim_reg(s__progAnim_UIA)
            return this
        endfunction
        function s__progAnim_onDestroy takes integer this returns nothing
            if ( s__uiSprite_isExist(s__progAnim_sprite[this]) and HaveSavedInteger(HASH_UI, s__uiSprite_ui[s__progAnim_sprite[this]], 1945) ) then
                call RemoveSavedInteger(HASH_UI, s__uiSprite_ui[s__progAnim_sprite[this]], 1945)
            endif
            set s__progAnim_sprite[this]=0
            set s__progAnim_cb[this]=0
            if ( s__progAnim_id[this] != 0 ) then
                set s__progAnim_List[s__progAnim_id[this]]=s__progAnim_List[s__progAnim_size]
                set s__progAnim_id[s__progAnim_List[s__progAnim_id[this]]]=s__progAnim_id[this]
                set s__progAnim_size=s__progAnim_size - 1
                set s__progAnim_id[this]=0
            endif
            if ( s__progAnim_size <= 0 ) then // 这里就删计时器
                call s__uianim_unreg(s__progAnim_UIA) // 添加调试输出
                call BJDebugMsg("progAnim计时器已停止")
            endif
        endfunction

//Generated destructor of progAnim
function s__progAnim_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: progAnim")
        return
    elseif (si__progAnim_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: progAnim")
        return
    endif
    call s__progAnim_onDestroy(this)
    set si__progAnim_V[this]=si__progAnim_F
    set si__progAnim_F=this
endfunction
            function s__progAnim_anon__0 takes nothing returns nothing
                local integer i
                local integer this
                local real progress
                if ( s__progAnim_size > 0 ) then
                    set i=1 // 从结论来说i就是.id
                    loop
                    exitwhen ( i > s__progAnim_size )
                        set this=s__progAnim_List[i]
                        set s__progAnim_now[this]=s__progAnim_now[this] + 1 // 删除的条件
                        if ( s__progAnim_now[this] >= s__progAnim_time[this] ) then
                            call s__uiSprite_setProgress(s__progAnim_sprite[this],s__progAnim_to[this])
                            if ( s__progAnim_cb[this] != 0 ) then //因为会自动排泄,防止在回调删UI的时候继续再调用一次
                                call RemoveSavedInteger(HASH_UI, s__uiSprite_ui[s__progAnim_sprite[this]], 1945)
                                call sc___prototype20_evaluate(s__progAnim_cb[this],s__progAnim_sprite[this])
                            endif
                            call s__progAnim_deallocate(this) // 正向遍历必须要保留这条
                            set i=i - 1
                        else
                            set progress=s__progAnim_from[this] + ( s__progAnim_to[this] - s__progAnim_from[this] ) * ( I2R(s__progAnim_now[this]) / s__progAnim_time[this] )
                            call s__uiSprite_setProgress(s__progAnim_sprite[this],progress)
                        endif
                    set i=i + 1
                    endloop
                endif
            endfunction  // UI销毁时回调删除进度动画
            function s__progAnim_anon__1 takes nothing returns nothing
                local integer ui=s__uiLifeCycle_agrsFrame
                local integer this
                if ( HaveSavedInteger(HASH_UI, ui, 1945) ) then
                    set this=LoadInteger(HASH_UI, ui, 1945) // 检查实例是否存在
                    if ( s__progAnim_isExist(this) ) then
                        call s__progAnim_deallocate(this)
                    endif
                endif
            endfunction
        function s__progAnim_onInit takes nothing returns nothing
            set s__progAnim_UIA=s__uianim_create(function s__progAnim_anon__0)
            call s__uiLifeCycle_registerDestroy(function s__progAnim_anon__1)
        endfunction

//library ProgressAnim ends
//library Icon:
        function s__icon_isExist takes integer this returns boolean
            return ( this != null and si__icon_V[this] == - 1 )
        endfunction
        function s__icon_init takes integer this returns nothing
            set s__icon_mainImage[this]=0
            set s__icon_shadowImage[this]=0
            set s__icon_cornerShade[this]=0
            set s__icon_cornerText[this]=0
            set s__icon_clickBtn[this]=0
            set s__icon_glowImage[this]=0
            set s__icon_cdSprite[this]=0 // 动画相关
            set s__icon_glowAnim[this]=0
            set s__icon_gd[this]=0 // 尺寸初始化为0
            set s__icon_sizeX[this]=0
            set s__icon_sizeY[this]=0
            set s__icon_isResize[this]=false
        endfunction  // 普通创建方法
        function s__icon_create takes integer parent returns integer
            local integer this=s__icon__allocate()
            call s__icon_init(this)
            set s__icon_isSimple[this]=false // 创建必需组件
            set s__icon_mainImage[this]=s__uiImage_setClip(s__uiImage_create(parent),true)
            call s__uiImage_show(s__icon_mainImage[this],false)
            return this
        endfunction  // 从现有UI创建图标
        function s__icon_fromExistingUI takes integer existingImage returns integer
            local integer this=s__icon__allocate()
            call s__icon_init(this)
            set s__icon_isSimple[this]=true
            set s__icon_spAnchor[this]=0
            set s__icon_spRelative[this]=0
            set s__icon_spRelativeAnchor[this]=0
            set s__icon_spOffsetX[this]=0
            set s__icon_spOffsetY[this]=0 // 绑定现有图片
            set s__icon_mainImage[this]=existingImage
            if ( s__uiImage_isExist(s__icon_mainImage[this]) ) then
                set s__icon_sizeX[this]=DzFrameGetWidth(s__uiImage_ui[s__icon_mainImage[this]])
                set s__icon_sizeY[this]=DzFrameGetHeight(s__uiImage_ui[s__icon_mainImage[this]])
                call BJDebugMsg("sizeX:" + R2S(s__icon_sizeX[this]) + " sizeY:" + R2S(s__icon_sizeY[this]))
            endif
            return this
        endfunction  // 更新流光尺寸
        function s__icon_updateGlowSize takes integer this returns nothing
            if ( s__uiImage_isExist(s__icon_glowImage[this]) ) then
                if ( s__icon_isResize[this] ) then
                    call s__uiImage_exReSize(s__icon_glowImage[this],s__icon_sizeX[this] * s__growdata_scale[s__icon_gd[this]] , s__icon_sizeY[this] * s__growdata_scale[s__icon_gd[this]])
                else
                    call s__uiImage_setSize(s__icon_glowImage[this],s__icon_sizeX[this] * s__growdata_scale[s__icon_gd[this]] , s__icon_sizeY[this] * s__growdata_scale[s__icon_gd[this]])
                endif
            endif
        endfunction  // 加入流光效果
        function s__icon_grow takes integer this,integer parent,integer gd returns integer
            if ( not ( s__icon_isExist(this) ) ) then
                return this
            endif
            if ( not ( s__uiImage_isExist(s__icon_glowImage[this]) ) ) then
                set s__icon_glowImage[this]=s__uiImage_setPoint(s__uiImage_create(parent),4 , s__uiImage_ui[s__icon_mainImage[this]] , 4 , 0 , 0)
                call s__icon_updateGlowSize(this)
            endif // 显示流光
            call s__uiImage_show(s__icon_glowImage[this],true)
            if ( gd != s__icon_gd[this] ) then
                set s__icon_gd[this]=gd
            endif
            if ( not ( s__baseanim_isExist(s__icon_glowAnim[this]) ) ) then
                set s__icon_glowAnim[this]=s__baseanim_create(s__uiImage_ui[s__icon_glowImage[this]])
                call s__baseanim_addSequ(s__icon_glowAnim[this],s__growdata_path[gd] , s__growdata_max[gd] , s__growdata_gap[gd] , true)
            endif
            call s__icon_updateGlowSize(this)
            return this
        endfunction  // 取消流光
        function s__icon_unGrow takes integer this returns integer
            if ( not ( s__icon_isExist(this) ) ) then
                return this
            endif
            if ( s__uiImage_isExist(s__icon_glowImage[this]) ) then
                call s__uiImage_show(s__icon_glowImage[this],false)
            endif
            if ( s__baseanim_isExist(s__icon_glowAnim[this]) ) then
                call s__baseanim_deallocate(s__icon_glowAnim[this])
                set s__icon_glowAnim[this]=0
            endif
            return this
        endfunction  // 设置尺寸
        function s__icon_setSize takes integer this,real x,real y returns integer
            if ( not ( s__icon_isExist(this) ) ) then
                return this
            endif
            if ( s__icon_sizeX[this] <= 0 or s__icon_sizeY[this] <= 0 ) then
                return this
            endif
            if ( s__icon_isResize[this] ) then
                call s__uiImage_exReSize(s__icon_mainImage[this],x , y)
            else
                call s__uiImage_setSize(s__icon_mainImage[this],x , y)
            endif
            call s__icon_updateGlowSize(this)
            set s__icon_sizeX[this]=x
            set s__icon_sizeY[this]=y
            return this
        endfunction
        function s__icon_enableResize takes integer this returns integer
            if ( not ( s__icon_isExist(this) ) ) then
                return this
            endif
            set s__icon_isResize[this]=true
            call s__icon_setSize(this,s__icon_sizeX[this] , s__icon_sizeY[this])
            return this
        endfunction  // 设置数字
        function s__icon_setCornerText takes integer this,string value returns integer
            local real padding
            if ( not ( s__icon_isExist(this) ) ) then
                return this
            endif
            if ( not ( s__uiText_isExist(s__icon_cornerText[this]) ) ) then
                set s__icon_cornerShade[this]=s__uiImage_createCornerBorder(s__uiImage_ui[s__icon_mainImage[this]])
                set s__icon_cornerText[this]=s__uiText_setPoint(s__uiText_setFontSize(s__uiText_create(s__uiImage_ui[s__icon_cornerShade[this]]),2),8 , s__uiImage_ui[s__icon_mainImage[this]] , 8 , - 0.003 , 0.003)
                set padding=0.003
                call s__uiImage_setPoint(s__uiImage_setPoint(s__icon_cornerShade[this],0 , s__uiText_ui[s__icon_cornerText[this]] , 0 , - padding , padding),8 , s__uiText_ui[s__icon_cornerText[this]] , 8 , padding , - padding)
            endif
            call s__uiText_setText(s__icon_cornerText[this],value)
            return this
        endfunction  // 显示/隐藏数字
        function s__icon_showCornerText takes integer this,boolean flag returns integer
            if ( not ( s__icon_isExist(this) ) ) then
                return this
            endif
            if ( s__uiText_isExist(s__icon_cornerText[this]) ) then
                call s__uiText_show(s__icon_cornerText[this],flag)
                call s__uiImage_show(s__icon_cornerShade[this],flag)
            endif
            return this
        endfunction  // 设置图标暗遮罩
        function s__icon_setShadow takes integer this,boolean flag returns integer
            if ( not ( s__icon_isExist(this) ) ) then
                return this
            endif
            if ( not ( s__uiImage_isExist(s__icon_shadowImage[this]) ) and flag ) then
                set s__icon_shadowImage[this]=s__uiImage_setAllPoint(s__uiImage_setTexture(s__uiImage_create(s__uiImage_ui[s__icon_mainImage[this]]),"UI\\Widgets\\EscMenu\\Human\\editbox-background.blp"),s__uiImage_ui[s__icon_mainImage[this]])
            endif
            if ( s__uiImage_isExist(s__icon_shadowImage[this]) ) then
                call s__uiImage_show(s__icon_shadowImage[this],flag)
            endif
            return this
        endfunction  // CD显示相关方法
        function s__icon_startCooldown takes integer this,real duration,integer func returns integer
            if ( not ( s__icon_isExist(this) ) ) then
                return this
            endif
            if ( not ( s__uiSprite_isExist(s__icon_cdSprite[this]) ) ) then
                set s__icon_cdSprite[this]=s__uiSprite_setAnimate(s__uiSprite_setModel(s__uiSprite_setSize(s__uiSprite_setPoint(s__uiSprite_create(s__uiImage_ui[s__icon_mainImage[this]]),4 , s__uiImage_ui[s__icon_mainImage[this]] , 4 , 0 , 0),0.001 , 0.001),"ui\\model\\cooldown_center.mdx" , 0 , 0),0 , false)
                call s__UIHashTable__uiHTEvent_bind(s__UIHashTable__uiHT_eventdata[uiHashTable(s__icon_cdSprite[this])],this)
            endif
            call s__uiSprite_progAnimate(s__icon_cdSprite[this],0 , 1 , duration , func)
            call s__uiSprite_setScale(s__icon_cdSprite[this],s__icon_sizeY[this] / 0.038)
            return this
        endfunction  // 获取按钮,然后再在外面设按钮相关的事件
        function s__icon_getClickBtn takes integer this returns integer
            if ( not ( s__icon_isExist(this) ) ) then
                return 0
            endif
            if ( not ( s__uiBtn_isExist(s__icon_clickBtn[this]) ) ) then
                set s__icon_clickBtn[this]=s__uiBtn_setAllPoint(s__uiBtn_create(s__uiImage_ui[s__icon_mainImage[this]]),s__uiImage_ui[s__icon_mainImage[this]])
            endif
            return s__icon_clickBtn[this]
        endfunction  // 设置图标贴图
        function s__icon_setTexture takes integer this,string path returns integer
            if ( not ( s__icon_isExist(this) ) ) then
                return this
            endif
            call s__uiImage_setTexture(s__icon_mainImage[this],path)
            return this
        endfunction  // 设置位置(顺便存位置)
        function s__icon_setPoint takes integer this,integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns integer
            if ( not ( s__icon_isExist(this) ) ) then
                return this
            endif
            call BJDebugMsg("[Icon.setPoint] 开始设置位置")
            call BJDebugMsg("[Icon.setPoint] isSimple=" + B2S(s__icon_isSimple[this]))
            if ( s__icon_isSimple[this] ) then
                call BJDebugMsg("[Icon.setPoint] 设置Simple图标位置: anchor=" + I2S(anchor) + " offsetX=" + R2S(offsetX) + " offsetY=" + R2S(offsetY))
                call s__uiImage_setPoint(s__uiImage_clearPoint(s__icon_mainImage[this]),anchor , relative , relativeAnchor , offsetX , offsetY)
                set s__icon_spAnchor[this]=anchor
                set s__icon_spRelative[this]=relative
                set s__icon_spRelativeAnchor[this]=relativeAnchor
                set s__icon_spOffsetX[this]=offsetX
                set s__icon_spOffsetY[this]=offsetY
            else
                call BJDebugMsg("[Icon.setPoint] 设置普通图标位置: anchor=" + I2S(anchor) + " offsetX=" + R2S(offsetX) + " offsetY=" + R2S(offsetY))
                call s__uiImage_setPoint(s__icon_mainImage[this],anchor , relative , relativeAnchor , offsetX , offsetY)
            endif
            call BJDebugMsg("[Icon.setPoint] 位置设置完成")
            return this
        endfunction  // 显示/隐藏整个图标(Simple无效)
        function s__icon_show takes integer this,boolean flag returns integer
            if ( not ( s__icon_isExist(this) ) ) then
                return this
            endif
            call BJDebugMsg("[Icon.show] 开始设置显示状态") //原生就移到屏幕外
            if ( s__icon_isSimple[this] ) then //显示
                if ( flag ) then
                    call BJDebugMsg("[Icon.show] 显示Simple图标: offsetX=" + R2S(s__icon_spOffsetX[this]) + " offsetY=" + R2S(s__icon_spOffsetY[this]))
                    call s__uiImage_setPoint(s__uiImage_clearPoint(s__icon_mainImage[this]),s__icon_spAnchor[this] , s__icon_spRelative[this] , s__icon_spRelativeAnchor[this] , s__icon_spOffsetX[this] , s__icon_spOffsetY[this])
                else //隐藏
                    call BJDebugMsg("[Icon.show] 隐藏Simple图标")
                    call s__uiImage_setPoint(s__uiImage_clearPoint(s__icon_mainImage[this]),4 , DzGetGameUI() , 4 , - 0.8 , 0.0)
                endif //非原生才能用这个函数
            else
                if ( flag ) then
                    call BJDebugMsg("[Icon.show] 设置普通图标显示状态: flag=true")
                else
                    call BJDebugMsg("[Icon.show] 设置普通图标显示状态: flag=false")
                endif
                call s__uiImage_show(s__icon_mainImage[this],flag)
                if ( s__uiImage_isExist(s__icon_glowImage[this]) ) then
                    call s__uiImage_show(s__icon_glowImage[this],flag)
                endif
            endif
            call BJDebugMsg("[Icon.show] 显示状态设置完成")
            return this
        endfunction
        function s__icon_onDestroy takes integer this returns nothing
            if ( s__baseanim_isExist(s__icon_glowAnim[this]) ) then
                call s__baseanim_deallocate(s__icon_glowAnim[this])
                set s__icon_glowAnim[this]=0
            endif
            if ( s__uiSprite_isExist(s__icon_cdSprite[this]) ) then
                call s__uiSprite_deallocate(s__icon_cdSprite[this])
                set s__icon_cdSprite[this]=0
            endif
            if ( s__uiImage_isExist(s__icon_shadowImage[this]) ) then
                call s__uiImage_deallocate(s__icon_shadowImage[this])
                set s__icon_shadowImage[this]=0
            endif
            if ( s__uiImage_isExist(s__icon_cornerShade[this]) ) then
                call s__uiImage_deallocate(s__icon_cornerShade[this])
                set s__icon_cornerShade[this]=0
            endif
            if ( s__uiText_isExist(s__icon_cornerText[this]) ) then
                call s__uiText_deallocate(s__icon_cornerText[this])
                set s__icon_cornerText[this]=0
            endif
            if ( s__uiBtn_isExist(s__icon_clickBtn[this]) ) then
                call s__uiBtn_deallocate(s__icon_clickBtn[this])
                set s__icon_clickBtn[this]=0
            endif
            if ( s__uiImage_isExist(s__icon_glowImage[this]) ) then
                call s__uiImage_deallocate(s__icon_glowImage[this])
                set s__icon_glowImage[this]=0
            endif
            if ( s__uiImage_isExist(s__icon_mainImage[this]) ) then
                call s__uiImage_deallocate(s__icon_mainImage[this])
                set s__icon_mainImage[this]=0
            endif
        endfunction

//Generated destructor of icon
function s__icon_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: icon")
        return
    elseif (si__icon_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: icon")
        return
    endif
    call s__icon_onDestroy(this)
    set si__icon_V[this]=si__icon_F
    set si__icon_F=this
endfunction

//library Icon ends
//library UTIcon:

    function UTIcon__TTestUTIcon1 takes player p returns nothing
        if ( not UTIcon__isTest1Active ) then
            set UTIcon__testIcon1=s__icon_show(s__icon_setPoint(s__icon_setSize(s__icon_setTexture(s__icon_create(DzGetGameUI()),"ReplaceableTextures\\CommandButtons\\BTNChainLightning.blp"),0.04 , 0.04),4 , DzGetGameUI() , 4 , 0 , 0),true)
            set UTIcon__isTest1Active=true
            call BJDebugMsg("基础图标已创建 - 输入s1可关闭")
        else
            call s__icon_deallocate(UTIcon__testIcon1)
            set UTIcon__testIcon1=0
            set UTIcon__isTest1Active=false
            call BJDebugMsg("基础图标已关闭")
        endif
    endfunction  // 添加新的测试函数
    function UTIcon__TTestUTIcon1a takes player p returns nothing
        local integer parent
        local integer img=0
        if ( not UTIcon__isTest1Active ) then //防御的父框架
            set parent=DzSimpleFrameFindByName("SimpleInfoPanelIconArmor", 2)
            set img=s__uiImage_createSimple(parent) // 从现有UI创建icon
            set UTIcon__testIcon1=s__icon_setTexture(s__icon_setPoint(s__icon_setSize(s__icon_fromExistingUI(img),0.08 , 0.08),4 , DzGetGameUI() , 4 , 0.0 , 0.0),"ReplaceableTextures\\CommandButtons\\BTNSorceress.blp")
            set UTIcon__isTest1Active=true
            call BJDebugMsg("已从现有UI创建图标 - 输入s1a可关闭")
        else
            call s__icon_deallocate(UTIcon__testIcon1)
            set UTIcon__testIcon1=0
            set UTIcon__isTest1Active=false
            call BJDebugMsg("从现有UI创建的图标已关闭")
        endif
    endfunction  // 角落文字测试
    function UTIcon__TTestUTIcon2 takes player p returns nothing
        if ( not ( s__icon_isExist(UTIcon__testIcon1) ) ) then
            call BJDebugMsg("请先使用s1创建基础图标")
            return
        endif
        call s__icon_setCornerText(UTIcon__testIcon1,I2S(GetRandomInt(1, 99)))
        call s__icon_showCornerText(UTIcon__testIcon1,true)
        call BJDebugMsg("已更新角落文字 - 再次输入s2随机新数字")
    endfunction  // 流光效果测试
    function UTIcon__TTestUTIcon3 takes player p returns nothing
        if ( not ( s__icon_isExist(UTIcon__testIcon1) ) ) then
            call BJDebugMsg("请先使用s1创建基础图标")
            return
        endif
        if ( not UTIcon__isTest3Active ) then
            call s__icon_grow(UTIcon__testIcon1,DzGetGameUI() , (2))
            set UTIcon__isTest3Active=true
            call BJDebugMsg("流光效果已开启 - 输入s3可关闭")
        else
            call s__icon_unGrow(UTIcon__testIcon1)
            set UTIcon__isTest3Active=false
            call BJDebugMsg("流光效果已关闭")
        endif
    endfunction  // 暗遮罩测试
    function UTIcon__TTestUTIcon4 takes player p returns nothing
        if ( not ( s__icon_isExist(UTIcon__testIcon1) ) ) then
            call BJDebugMsg("请先使用s1创建基础图标")
            return
        endif
        if ( not UTIcon__isTest4Active ) then
            call s__icon_setShadow(UTIcon__testIcon1,true)
            set UTIcon__isTest4Active=true
            call BJDebugMsg("暗遮罩已开启 - 输入s4可关闭")
        else
            call s__icon_setShadow(UTIcon__testIcon1,false)
            set UTIcon__isTest4Active=false
            call BJDebugMsg("暗遮罩已关闭")
        endif
    endfunction  // 点击事件测试
        function UTIcon__anon__0 takes nothing returns nothing
            call BJDebugMsg("图标被点击!")
        endfunction
    function UTIcon__TTestUTIcon5 takes player p returns nothing
        local integer btn
        if ( not ( s__icon_isExist(UTIcon__testIcon1) ) ) then
            call BJDebugMsg("请先使用s1创建基础图标")
            return
        endif
        set btn=s__icon_getClickBtn(UTIcon__testIcon1)
        call s__uiBtn_onMouseClick(btn,function UTIcon__anon__0)
        call BJDebugMsg("点击事件已绑定 - 请点击图标测试")
    endfunction  // CD显示测试
    function UTIcon__TTestUTIcon6 takes player p returns nothing
        if ( not ( s__icon_isExist(UTIcon__testIcon1) ) ) then
            call BJDebugMsg("请先使用s1创建基础图标")
            return
        endif
        call s__icon_startCooldown(UTIcon__testIcon1,10.0 , 0)
        call BJDebugMsg("CD显示已开始 - 持续10秒")
    endfunction  // 显示/隐藏测试
    function UTIcon__TTestUTIcon7 takes player p returns nothing
        if ( not ( s__icon_isExist(UTIcon__testIcon1) ) ) then
            call BJDebugMsg("请先使用s1创建基础图标")
            return
        endif
        if ( not UTIcon__isTest7Active ) then
            call s__icon_show(UTIcon__testIcon1,false)
            set UTIcon__isTest7Active=true
            call BJDebugMsg("图标已隐藏 - 输入s7可显示")
        else
            call s__icon_show(UTIcon__testIcon1,true)
            set UTIcon__isTest7Active=false
            call BJDebugMsg("图标已显示")
        endif
    endfunction  // 大小调整测试
    function UTIcon__TTestUTIcon8 takes player p returns nothing
        if ( not ( s__icon_isExist(UTIcon__testIcon1) ) ) then
            call BJDebugMsg("请先使用s1创建基础图标")
            return
        endif
        call s__icon_enableResize(UTIcon__testIcon1)
        call BJDebugMsg("大小调整已开启")
    endfunction
    function UTIcon__TTestUTIcon9 takes player p returns nothing
    endfunction
    function UTIcon__TTestUTIcon10 takes player p returns nothing
    endfunction
    function UTIcon__TTestActUTIcon1 takes string str returns nothing
        local player p=GetTriggerPlayer()
        local integer index=GetConvertedPlayerId(p)
        local integer i
        local integer num=0
        local integer len=StringLength(str)
        local string array paramS
        local integer array paramI
        local real array paramR
        if ( str == "destroy" ) then
            if ( s__icon_isExist(UTIcon__testIcon1) ) then
                call s__icon_deallocate(UTIcon__testIcon1)
                set UTIcon__testIcon1=0
                set UTIcon__isTest1Active=false
                call BJDebugMsg("图标已销毁")
            else
                call BJDebugMsg("没有可销毁的图标")
            endif
            set p=null
            return
        endif
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
        function UTIcon__anon__1 takes nothing returns nothing
            call BJDebugMsg("[Icon] 单元测试已加载")
            call BJDebugMsg("测试指令:")
            call BJDebugMsg("s1 - 创建/销毁基础图标")
            call BJDebugMsg(" s1a - 从现有UI创建图标")
            call BJDebugMsg("s2 - 更新角落文字")
            call BJDebugMsg("s3 - 开启/关闭流光效果")
            call BJDebugMsg("s4 - 开启/关闭暗遮罩")
            call BJDebugMsg("s5 - 测试点击事件")
            call BJDebugMsg("s6 - 测试CD显示(10秒)")
            call BJDebugMsg("s7 - 显示/隐藏图标")
            call BJDebugMsg("s8 - 开启自动尺寸")
            call BJDebugMsg("-destroy - 销毁图标")
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTIcon__anon__2 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            local integer i=1
            if ( SubStringBJ(str, 1, 1) == "-" ) then
                call UTIcon__TTestActUTIcon1(SubStringBJ(str, 2, StringLength(str)))
                return
            endif
            if ( str == "s1" ) then
                call UTIcon__TTestUTIcon1(GetTriggerPlayer())
            elseif ( str == "s1a" ) then
                call UTIcon__TTestUTIcon1a(GetTriggerPlayer())
            elseif ( str == "s2" ) then
                call UTIcon__TTestUTIcon2(GetTriggerPlayer())
            elseif ( str == "s3" ) then
                call UTIcon__TTestUTIcon3(GetTriggerPlayer())
            elseif ( str == "s4" ) then
                call UTIcon__TTestUTIcon4(GetTriggerPlayer())
            elseif ( str == "s5" ) then
                call UTIcon__TTestUTIcon5(GetTriggerPlayer())
            elseif ( str == "s6" ) then
                call UTIcon__TTestUTIcon6(GetTriggerPlayer())
            elseif ( str == "s7" ) then
                call UTIcon__TTestUTIcon7(GetTriggerPlayer())
            elseif ( str == "s8" ) then
                call UTIcon__TTestUTIcon8(GetTriggerPlayer())
            elseif ( str == "s9" ) then
                call UTIcon__TTestUTIcon9(GetTriggerPlayer())
            elseif ( str == "s10" ) then
                call UTIcon__TTestUTIcon10(GetTriggerPlayer())
            endif
        endfunction
    function UTIcon__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEventSingle(tr, 0.5)
        call TriggerAddCondition(tr, Condition(function UTIcon__anon__1))
        set tr=null
        call UnitTestRegisterChatEvent(function UTIcon__anon__2)
    endfunction

//library UTIcon ends
// 结构体共用方法定义
//共享打印方法
// UI组件内部共享方法及成员
// UI组件依赖库
// UI组件创建时共享调用
// UI组件销毁时共享调用

// 0 - 1亿这里用
// 锚点常量
// 事件常量
//鼠标点击事件
//Index名:
//默认原生图片路径
//模板名
//TEXT对齐常量:(uiText.setAlign)
//窗口的大小
//===========================================================================
// Icon.j
//===========================================================================
//
// 模块描述：
//   实现了魔兽争霸3中通用的图标UI组件，支持图标显示、数字标记、
//   按钮功能、流光特效等特性。
//
// 作者：[你的名字]
// 创建日期：[创建日期]
// 最后修改：[最后修改日期]
//
// 依赖项：
//   - UIBase
//   - UIAnim
//   - GrowData
//   - UIText
//   - UIImage
//   - UIButton
//   - UISprite
//
// 使用示例：
//   icon myIcon = icon.create(parentFrame, true, true);
//   myIcon.size(0.04, 0.04);
//
//===========================================================================
//# dependency:ui/model/cooldown_center.mdx


//控件的共用基本方法
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

call ExecuteFunc("jasshelper__initstructs114316750")
call ExecuteFunc("UnitTestFramwork___onInit")
call ExecuteFunc("YDTriggerSaveLoadSystem__Init")
call ExecuteFunc("UITocInit__onInit")
call ExecuteFunc("UIExtendResize__onInit")
call ExecuteFunc("UTIcon__onInit")

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
function sa__icon_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            if ( s__baseanim_isExist(s__icon_glowAnim[this]) ) then
                call s__baseanim_deallocate(s__icon_glowAnim[this])
                set s__icon_glowAnim[this]=0
            endif
            if ( s__uiSprite_isExist(s__icon_cdSprite[this]) ) then
                call s__uiSprite_deallocate(s__icon_cdSprite[this])
                set s__icon_cdSprite[this]=0
            endif
            if ( s__uiImage_isExist(s__icon_shadowImage[this]) ) then
                call s__uiImage_deallocate(s__icon_shadowImage[this])
                set s__icon_shadowImage[this]=0
            endif
            if ( s__uiImage_isExist(s__icon_cornerShade[this]) ) then
                call s__uiImage_deallocate(s__icon_cornerShade[this])
                set s__icon_cornerShade[this]=0
            endif
            if ( s__uiText_isExist(s__icon_cornerText[this]) ) then
                call s__uiText_deallocate(s__icon_cornerText[this])
                set s__icon_cornerText[this]=0
            endif
            if ( s__uiBtn_isExist(s__icon_clickBtn[this]) ) then
                call s__uiBtn_deallocate(s__icon_clickBtn[this])
                set s__icon_clickBtn[this]=0
            endif
            if ( s__uiImage_isExist(s__icon_glowImage[this]) ) then
                call s__uiImage_deallocate(s__icon_glowImage[this])
                set s__icon_glowImage[this]=0
            endif
            if ( s__uiImage_isExist(s__icon_mainImage[this]) ) then
                call s__uiImage_deallocate(s__icon_mainImage[this])
                set s__icon_mainImage[this]=0
            endif
   return true
endfunction
function sa__progAnim_create takes nothing returns boolean
local integer sprite=f__arg_integer1
local real from=f__arg_real1
local real to=f__arg_real2
local integer time=f__arg_integer2
local integer cb=f__arg_integer3
            local integer this=s__progAnim__allocate()
            set s__progAnim_sprite[this]=sprite
            set s__progAnim_from[this]=from
            set s__progAnim_to[this]=to
            set s__progAnim_time[this]=time
            set s__progAnim_now[this]=0
            set s__progAnim_cb[this]=cb // 这里是初始化时的设置内容,不需要改
            if ( s__progAnim_id[this] == 0 ) then
                set s__progAnim_size=s__progAnim_size + 1
                set s__progAnim_List[s__progAnim_size]=this
                set s__progAnim_id[this]=s__progAnim_size
            endif
            call s__uianim_reg(s__progAnim_UIA)
set f__result_integer= this
   return true
endfunction
function sa__progAnim_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            if ( s__uiSprite_isExist(s__progAnim_sprite[this]) and HaveSavedInteger(HASH_UI, s__uiSprite_ui[s__progAnim_sprite[this]], 1945) ) then
                call RemoveSavedInteger(HASH_UI, s__uiSprite_ui[s__progAnim_sprite[this]], 1945)
            endif
            set s__progAnim_sprite[this]=0
            set s__progAnim_cb[this]=0
            if ( s__progAnim_id[this] != 0 ) then
                set s__progAnim_List[s__progAnim_id[this]]=s__progAnim_List[s__progAnim_size]
                set s__progAnim_id[s__progAnim_List[s__progAnim_id[this]]]=s__progAnim_id[this]
                set s__progAnim_size=s__progAnim_size - 1
                set s__progAnim_id[this]=0
            endif
            if ( s__progAnim_size <= 0 ) then // 这里就删计时器
                call s__uianim_unreg(s__progAnim_UIA) // 添加调试输出
                call BJDebugMsg("progAnim计时器已停止")
            endif
   return true
endfunction
function sa__uiText_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            if ( not ( s__uiText_isExist(this) ) ) then
return true
            endif
                    call s__uiLifeCycle_onDestroyCB(this , si__uiText , s__uiText_ui[this])
                    call FlushChildHashtable(HASH_UI, s__uiText_ui[this])
            call DzDestroyFrame(s__uiText_ui[this])
            call s__uiId_recycle(s__uiText_id[this])
   return true
endfunction
function sa__uiSprite_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            if ( not ( s__uiSprite_isExist(this) ) ) then
return true
            endif
                    call s__uiLifeCycle_onDestroyCB(this , si__uiSprite , s__uiSprite_ui[this])
                    call FlushChildHashtable(HASH_UI, s__uiSprite_ui[this])
            call DzDestroyFrame(s__uiSprite_ui[this])
            call s__uiId_recycle(s__uiSprite_id[this])
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
function sa__rePointer_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            set s__rePointer_frame[this]=0
            if ( s__rePointer_uID[this] != 0 ) then
                set s__rePointer_List[s__rePointer_uID[this]]=s__rePointer_List[s__rePointer_size]
                set s__rePointer_uID[s__rePointer_List[s__rePointer_uID[this]]]=s__rePointer_uID[this]
                set s__rePointer_size=s__rePointer_size - 1
                set s__rePointer_uID[this]=0
            endif
   return true
endfunction
function sa__resizer_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            set s__resizer_frame[this]=0
            if ( s__resizer_uID[this] != 0 ) then
                set s__resizer_List[s__resizer_uID[this]]=s__resizer_List[s__resizer_size]
                set s__resizer_uID[s__resizer_List[s__resizer_uID[this]]]=s__resizer_uID[this]
                set s__resizer_size=s__resizer_size - 1
                set s__resizer_uID[this]=0
            endif
   return true
endfunction
function sa__baseanim_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            if ( not ( s__baseanim_isExist(this) ) ) then
return true
            endif
            call s__baseanim_delDelay(this)
            call s__baseanim_delMove(this)
            call s__baseanim_delZoom(this)
            call s__baseanim_delAlpha(this)
            call s__baseanim_delSequ(this)
            call s__baseanim_delBlink(this)
            call s__baseanim_delLife(this)
            if ( HaveSavedInteger(HASH_UI, s__baseanim_ui[this], 1822) ) then
                call RemoveSavedInteger(HASH_UI, s__baseanim_ui[this], 1822)
            endif
            set s__baseanim_ui[this]=0 //统计数量--
            set s__baseanim_size=s__baseanim_size - 1
   return true
endfunction

function jasshelper__initstructs114316750 takes nothing returns nothing
    set st__icon_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__icon_onDestroy,Condition( function sa__icon_onDestroy))
    set st__progAnim_create=CreateTrigger()
    call TriggerAddCondition(st__progAnim_create,Condition( function sa__progAnim_create))
    set st__progAnim_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__progAnim_onDestroy,Condition( function sa__progAnim_onDestroy))
    set st__uiText_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__uiText_onDestroy,Condition( function sa__uiText_onDestroy))
    set st__uiSprite_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__uiSprite_onDestroy,Condition( function sa__uiSprite_onDestroy))
    set st__uiImage_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__uiImage_onDestroy,Condition( function sa__uiImage_onDestroy))
    set st__uiBtn_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__uiBtn_onDestroy,Condition( function sa__uiBtn_onDestroy))
    set st__rePointer_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__rePointer_onDestroy,Condition( function sa__rePointer_onDestroy))
    set st__resizer_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__resizer_onDestroy,Condition( function sa__resizer_onDestroy))
    set st__baseanim_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__baseanim_onDestroy,Condition( function sa__baseanim_onDestroy))






















    call ExecuteFunc("s__growdata_onInit")
    call ExecuteFunc("s__mapBounds_onInit")
    call ExecuteFunc("s__uianim_onInit")
    call ExecuteFunc("s__uiId_onInit")
    call ExecuteFunc("s__uiLifeCycle_onInit")
    call ExecuteFunc("s__hardware_onInit")
    call ExecuteFunc("s__baseanim_onInit")
    call ExecuteFunc("s__progAnim_onInit")
endfunction

