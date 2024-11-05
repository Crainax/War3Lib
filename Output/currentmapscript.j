globals
//globals from BzAPI:
constant boolean LIBRARY_BzAPI=true
//endglobals from BzAPI
//globals from Constant:
constant boolean LIBRARY_Constant=true
integer playerCount=0
integer renshu=0
//endglobals from Constant
//globals from Geometry:
constant boolean LIBRARY_Geometry=true
//endglobals from Geometry
//globals from InnerJapi:
constant boolean LIBRARY_InnerJapi=true
//endglobals from InnerJapi
//globals from MathUtils:
constant boolean LIBRARY_MathUtils=true
//endglobals from MathUtils
//globals from NumberUtils:
constant boolean LIBRARY_NumberUtils=true
//endglobals from NumberUtils
//globals from UnitFilter:
constant boolean LIBRARY_UnitFilter=true
//endglobals from UnitFilter
//globals from UnitTestFramwork:
constant boolean LIBRARY_UnitTestFramwork=true
trigger UnitTestFramwork__TUnitTest=null
//endglobals from UnitTestFramwork
//globals from UnitUtils:
constant boolean LIBRARY_UnitUtils=true
//endglobals from UnitUtils
//globals from YDWEBase:
constant boolean LIBRARY_YDWEBase=true
//ȫ�ֹ�ϣ�� 
hashtable YDHT= null
string bj_AllString=".................................!.#$%&'()*+,-./0123456789:;<=>.@ABCDEFGHIJKLMNOPQRSTUVWXYZ[.]^_`abcdefghijklmnopqrstuvwxyz{|}~................................................................................................................................"
//全局系统变量
unit bj_lastAbilityCastingUnit=null
unit bj_lastAbilityTargetUnit=null
unit bj_lastPoolAbstractedUnit=null
unitpool bj_lastCreatedUnitPool=null
item bj_lastPoolAbstractedItem=null
itempool bj_lastCreatedItemPool=null
attacktype bj_lastSetAttackType= ATTACK_TYPE_NORMAL
damagetype bj_lastSetDamageType= DAMAGE_TYPE_NORMAL
weapontype bj_lastSetWeaponType= WEAPON_TYPE_WHOKNOWS
real yd_MapMaxX= 0
real yd_MapMinX= 0
real yd_MapMaxY= 0
real yd_MapMinY= 0
string array YDWEBase__yd_PlayerColor
trigger array YDWEBase__AbilityCastingOverEventQueue
integer array YDWEBase__AbilityCastingOverEventType
integer YDWEBase__AbilityCastingOverEventNumber= 0
//endglobals from YDWEBase
//globals from YDWEGetUnitsInRectMatchingNull:
constant boolean LIBRARY_YDWEGetUnitsInRectMatchingNull=true
group yd_NullTempGroup
//endglobals from YDWEGetUnitsInRectMatchingNull
//globals from YDWEJapiEffect:
constant boolean LIBRARY_YDWEJapiEffect=true
//endglobals from YDWEJapiEffect
//globals from GroupUtils:
constant boolean LIBRARY_GroupUtils=true
group GroupUtils__tempG=null
unit GroupUtils__tempU=null
//endglobals from GroupUtils
//globals from Variable:
constant boolean LIBRARY_Variable=true
unit array H
unit array USelected
hashtable UNTable=InitHashtable()
hashtable UTTable=InitHashtable()
hashtable TITable=InitHashtable()
hashtable GRTable=InitHashtable()
hashtable SPTable=InitHashtable()
trigger TrSelect=null
integer StType=0
integer StThis=0
trigger TrStruct=null
rect array RHome
rect array RFuben
//endglobals from Variable
//globals from YDWEGetUnitsInRectAllNull:
constant boolean LIBRARY_YDWEGetUnitsInRectAllNull=true
//endglobals from YDWEGetUnitsInRectAllNull
//globals from EffectUtils:
constant boolean LIBRARY_EffectUtils=true
//endglobals from EffectUtils
//globals from UTEffectUtils:
constant boolean LIBRARY_UTEffectUtils=true
effect UTEffectUtils___ef=null
unit UTEffectUtils___u1=null
unit UTEffectUtils___u2=null
trigger UTEffectUtils___trSY=null
integer array UTEffectUtils___fra
real UTEffectUtils___xLi=0.
real UTEffectUtils___yLi=0.
//endglobals from UTEffectUtils
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
constant integer si__radiationEnd=1
integer si__radiationEnd_F=0
integer si__radiationEnd_I=0
integer array si__radiationEnd_V
real s__radiationEnd_x=0
real s__radiationEnd_y=0
constant integer si__pd=2
integer array s__pd_gold
integer array s__pd_gem
integer array s__pd_kill
string array s__pd_name
integer array s__pd_goldRate
integer array s__pd_goldNega
integer array s__pd_gemRate
integer array s__pd_gemNega
integer array s__pd_killExtra
integer array s__pd_killNega
constant integer si__efut=3
integer s__efut_args1=0
group s__efut_g=null
constant integer si__missile=4
integer si__missile_F=0
integer si__missile_I=0
integer array si__missile_V
integer s__missile_ethis=0
timer s__missile_t=null
integer array s__missile_List
integer s__missile_size=0
integer array s__missile_uID
real array s__missile_x
real array s__missile_y
real array s__missile_z
real array s__missile_dx
real array s__missile_dy
real array s__missile_dz
real array s__missile_xySpeed
real array s__missile_zSpeed
real array s__missile_speed
effect array s__missile_e
trigger array s__missile_tr
boolean array s__missile_down
constant integer si__umissile=5
integer si__umissile_F=0
integer si__umissile_I=0
integer array si__umissile_V
integer s__umissile_ethis=0
timer s__umissile_t=null
integer array s__umissile_List
integer s__umissile_size=0
integer array s__umissile_uID
real array s__umissile_cd
real array s__umissile_ux
real array s__umissile_uy
real array s__umissile_uz
real array s__umissile_ex
real array s__umissile_ey
real array s__umissile_ez
real array s__umissile_nx
real array s__umissile_ny
real array s__umissile_nz
unit array s__umissile_u
effect array s__umissile_e
trigger array s__umissile_tr
constant integer si__pierce=6
integer si__pierce_F=0
integer si__pierce_I=0
integer array si__pierce_V
integer s__pierce_ethis=0
timer s__pierce_t=null
integer array s__pierce_List
integer s__pierce_size=0
integer array s__pierce_uID
real array s__pierce_x
real array s__pierce_y
real array s__pierce_dx
real array s__pierce_dy
real array s__pierce_speed
real array s__pierce_radius
effect array s__pierce_e
trigger array s__pierce_trU
trigger array s__pierce_trEnd
group array s__pierce_g
trigger st__missile_onDestroy
trigger st__umissile_onDestroy
trigger st__pierce_onDestroy
integer f__arg_this

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
	native EXGetEffectX takes effect e returns real
	native EXGetEffectY takes effect e returns real
	native EXGetEffectZ takes effect e returns real
	native EXSetEffectXY takes effect e, real x, real y returns nothing
	native EXSetEffectZ takes effect e, real z returns nothing
	native EXGetEffectSize takes effect e returns real
	native EXSetEffectSize takes effect e, real size returns nothing
	native EXEffectMatRotateX takes effect e, real angle returns nothing
	native EXEffectMatRotateY takes effect e, real angle returns nothing
	native EXEffectMatRotateZ takes effect e, real angle returns nothing
	native EXEffectMatScale takes effect e, real x, real y, real z returns nothing
	native EXEffectMatReset takes effect e returns nothing
	native EXSetEffectSpeed takes effect e, real speed returns nothing


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

//Generated method caller for pierce.onDestroy
function sc__pierce_onDestroy takes integer this returns nothing
            call DestroyEffect(s__pierce_e[this])
            call DestroyTrigger(s__pierce_trU[this])
            call DestroyTrigger(s__pierce_trEnd[this])
            call DestroyGroup(s__pierce_g[this])
            set s__pierce_e[this]=null
            set s__pierce_trU[this]=null
            set s__pierce_trEnd[this]=null
            set s__pierce_g[this]=null
endfunction

//Generated allocator of pierce
function s__pierce__allocate takes nothing returns integer
 local integer this=si__pierce_F
    if (this!=0) then
        set si__pierce_F=si__pierce_V[this]
    else
        set si__pierce_I=si__pierce_I+1
        set this=si__pierce_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: pierce")
        return 0
    endif

    set si__pierce_V[this]=-1
 return this
endfunction

//Generated destructor of pierce
function sc__pierce_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: pierce")
        return
    elseif (si__pierce_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: pierce")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__pierce_onDestroy)
    set si__pierce_V[this]=si__pierce_F
    set si__pierce_F=this
endfunction

//Generated method caller for umissile.onDestroy
function sc__umissile_onDestroy takes integer this returns nothing
            call DestroyEffect(s__umissile_e[this])
            call DestroyTrigger(s__umissile_tr[this])
            set s__umissile_e[this]=null
            set s__umissile_tr[this]=null
            set s__umissile_u[this]=null
endfunction

//Generated allocator of umissile
function s__umissile__allocate takes nothing returns integer
 local integer this=si__umissile_F
    if (this!=0) then
        set si__umissile_F=si__umissile_V[this]
    else
        set si__umissile_I=si__umissile_I+1
        set this=si__umissile_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: umissile")
        return 0
    endif

    set si__umissile_V[this]=-1
 return this
endfunction

//Generated destructor of umissile
function sc__umissile_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: umissile")
        return
    elseif (si__umissile_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: umissile")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__umissile_onDestroy)
    set si__umissile_V[this]=si__umissile_F
    set si__umissile_F=this
endfunction

//Generated method caller for missile.onDestroy
function sc__missile_onDestroy takes integer this returns nothing
            call DestroyEffect(s__missile_e[this])
            call DestroyTrigger(s__missile_tr[this])
            set s__missile_e[this]=null
            set s__missile_tr[this]=null
endfunction

//Generated allocator of missile
function s__missile__allocate takes nothing returns integer
 local integer this=si__missile_F
    if (this!=0) then
        set si__missile_F=si__missile_V[this]
    else
        set si__missile_I=si__missile_I+1
        set this=si__missile_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: missile")
        return 0
    endif

    set si__missile_V[this]=-1
 return this
endfunction

//Generated destructor of missile
function sc__missile_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: missile")
        return
    elseif (si__missile_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: missile")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__missile_onDestroy)
    set si__missile_V[this]=si__missile_F
    set si__missile_F=this
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
    function DzGetTriggerMallItemPlayer takes nothing returns player
        return DzGetTriggerSyncPlayer()
    endfunction
    function DzGetTriggerMallItem takes nothing returns string
        return DzGetTriggerSyncData()
    endfunction

//library BzAPI ends
//library Constant:

    function Constant___onInit takes nothing returns nothing
        local integer i
        set i=1
        loop
        exitwhen ( i > 4 )
            if ( ( GetPlayerSlotState(ConvertedPlayer(i)) == PLAYER_SLOT_STATE_PLAYING ) and ( GetPlayerController(ConvertedPlayer(i)) == MAP_CONTROL_USER ) ) then
                set playerCount=playerCount + 1
                set renshu=renshu + 1
            endif
        set i=i + 1
        endloop
    endfunction

//library Constant ends
//library Geometry:
    function GetDistance takes real x1,real y1,real x2,real y2 returns real
        local real dx=x2 - x1
        local real dy=y2 - y1
        return SquareRoot(dx * dx + dy * dy)
    endfunction  // 6个坐标的距离
    function GetDistanceZ takes real x1,real y1,real z1,real x2,real y2,real z2 returns real
        local real dx=x2 - x1
        local real dy=y2 - y1
        local real dz=z2 - z1
        return SquareRoot(dx * dx + dy * dy + dz * dz)
    endfunction  // 4个坐标的角度,前面是人的位置，后面是点的位置
    function GetFacing takes real x1,real y1,real x2,real y2 returns real
        return Atan2BJ(y2 - y1, x2 - x1)
    endfunction

//library Geometry ends
//library InnerJapi:

    function EXExecuteScript takes string p1 returns string
        call GetTriggeringTrigger()
        return ""
    endfunction  // 显示屏幕中间的 FPS 文本
    function ShowFpsText takes boolean show returns nothing
        call GetTriggeringTrigger()
    endfunction  // 异步获取 玩家当前的帧数
    function GetFps takes nothing returns real
        call GetTriggeringTrigger()
        return 0.0
    endfunction  // 解锁帧数上限 突破 60 帧
    function UnlockFps takes boolean is_unlock returns nothing
        call GetTriggeringTrigger()
    endfunction
    function GetCacheStringCount takes nothing returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction
    function ReleaseString takes string str returns nothing
        call GetTriggeringTrigger()
    endfunction
    function ReleaseAllString takes nothing returns nothing
        call GetTriggeringTrigger()
    endfunction
    function DumpAllString takes string filename returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 用来清空魔兽的模型文件缓存 降低内存占用 直到下一次读取 才会重新占用。
    function ReleaseModel takes string model_path returns nothing
        call GetTriggeringTrigger()
    endfunction
    function ReleaseAllModel takes nothing returns nothing
        call GetTriggeringTrigger()
    endfunction
    function GetCacheModelCount takes nothing returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 异步获取 获取当前指向单位 一般用来做 UI 操作时需要用到的接口,注意返回是异步的 handle，切记小心使用
    function GetTargetObject takes nothing returns unit
        call GetTriggeringTrigger()
        return null
    endfunction  // 异步获取 当前玩家大头像模型的单位 当框选一群单位时 切换选择也会改变返回值 一般用来做 UI 操作时需要用到的接口
    function GetRealSelectUnit takes nothing returns unit
        call GetTriggeringTrigger()
        return null
    endfunction  // 异步获取 玩家的聊天框是否被打开 一般用来做键盘操作时 避免与输入冲突
    function GetChatState takes nothing returns boolean
        call GetTriggeringTrigger()
        return false
    endfunction  //解锁 blp 贴图的像素上限 原本魔兽高清图片也会被限制在 512p 之内
    function UnlockBlpSize takes boolean is_unlock returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位名字 每个单位独立 互相不影响 修改后 获取单位名字 还是返回原值
    function SetUnitName takes unit u,string name returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位头像模型 设置之后会立即改变 当 设置单位模型时 会被新的自动覆盖掉
    function SetUnitPortrait takes unit u,string model returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位普攻弹道弧度 每个单位独立 互相不影响 会被法球覆盖
    function SetUnitMissileArc takes unit u,real value returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位普攻弹道模型 每个单位独立 互相不影响 会被法球覆盖
    function SetUnitMissileModel takes unit u,string model returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位普攻弹道是否自动追踪 每个单位独立 互相不影响 会被法球覆盖
    function SetUnitMissileHoming takes unit u,boolean value returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位普攻弹道速度 每个单位独立 互相不影响 会被法球覆盖
    function SetUnitMissileSpeed takes unit u,real value returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位模型 包括大头像模型也会自动设置 该接口 也可以给物品 特效 可破坏物 更换模型
    function SetUnitModel takes unit u,string model returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位贴图 替换单位身上的 id 贴图 例如队伍颜色的 id 贴图是 0 队伍光晕 id 是 1
    function SetUnitTexture takes unit u,string texture,integer id returns nothing
        call GetTriggeringTrigger()
    endfunction  //隐藏单位跟物品 鼠标指向时显示的 UI 包括单位血条
    function SetUnitPressUIVisible takes unit u,boolean is_show returns nothing
        call GetTriggeringTrigger()
    endfunction  // 设置特效动画
    function EXSetEffectAnimation takes effect e,integer index returns nothing
        call GetTriggeringTrigger()
    endfunction  // 设置特效 X Y 轴坐标
    function EXSetEffectVisible takes effect e,boolean visible returns nothing
        call GetTriggeringTrigger()
    endfunction  // 设置特效是否在迷雾中可见
    function EXSetEffectFogVisible takes effect e,boolean visible returns nothing
        call GetTriggeringTrigger()
    endfunction  // 设置特效是否在阴影中可见
    function EXSetEffectMaskVisible takes effect e,boolean visible returns nothing
        call GetTriggeringTrigger()
    endfunction  // 设置特效颜色 透明值无效 16进制
    function EXSetEffectColor takes effect e,integer color returns nothing
        call GetTriggeringTrigger()
    endfunction  // 获取特效的颜色 跟 设置特效颜色 配合使用
    function EXGetEffectColor takes effect e returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 设置英雄称谓 每个单位独立 互相不影响 GetHeroProperName 获取英雄称谓 是修改后的值。
    function SetUnitProperName takes unit u,string name returns nothing
        call GetTriggeringTrigger()
    endfunction  // 获取指定商店 选择 指定玩家的哪个单位 返回值是同步的接口 可以安全使用
    function GetStoreTarget takes unit store,player p returns unit
        call GetTriggeringTrigger()
        return null
    endfunction  // 获取指定 frame 的子控件 不能对 simple 类型的控件使用
    function FrameGetChilds takes integer frame,boolean last returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 获取指定 frame 的父控件 不能对 simple 类型的控件使用 可以获取 大头像模型 的父控件 然后为其新建子控件 用来放置在所有界面之下
    function FrameGetParent takes integer frame returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 全屏状态下 返回 false 窗口化模式 返回 true
    function IsWindowMode takes nothing returns boolean
        call GetTriggeringTrigger()
        return false
    endfunction  // 设置指定 frame 是否启用视口
    function FrameSetViewPort takes integer frame,boolean enable returns nothing
        call GetTriggeringTrigger()
    endfunction  // 设置窗口大小
    function SetWindowSize takes integer width,integer height returns nothing
        call GetTriggeringTrigger()
    endfunction  // 播放特效动画
    function EXPlayEffectAnimation takes effect e,string animation_name,string link_name returns nothing
        call GetTriggeringTrigger()
    endfunction  // 绑定特效
    function BindEffect takes widget u,string socket,effect e returns nothing
        call GetTriggeringTrigger()
    endfunction  // 解除特效绑定
    function UnBindEffect takes effect e returns nothing
        call GetTriggeringTrigger()
    endfunction  //内置默认是 解锁 frame 控件的 屏幕限制的 就是可以随便移动到屏幕之外的位置， 但是有个别用户 依赖这个限制 用网易的接口写了 ui 导致加了内置之后 位置变了， 故此新增这个接口 自行决定是否解锁。
    function SetFrameLimitScreen takes integer frame,boolean is_limit returns nothing
        call GetTriggeringTrigger()
    endfunction  // 获取当前玩家 id
    function GetUserId takes nothing returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  //异步获取 当前玩家在 11 或网易平台游戏时的 uid， 本地返回 0
    function GetUserIdEx takes nothing returns string
        call GetTriggeringTrigger()
        return ""
    endfunction  // 设置单位碰撞体积
    function SetUnitCollisionSize takes unit u,real size returns nothing
        call GetTriggeringTrigger()
    endfunction  // 设置单位移动类型
    function SetUnitMoveType takes unit u,string s returns nothing
        call GetTriggeringTrigger()
    endfunction  // 获取 框选按钮 slot 从0 ~ 11
    function FrameGetInfoSelectButton takes integer slot returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 获取 下方buff按钮 slot 从0 ~ 7
    function FrameGetBuffButton takes integer slot returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 获取 农民按钮
    function FrameGetUnitButton takes nothing returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 获取 技能右下角数字文本控件 button = 技能按钮  返回值 = SimpleString 类型控件
    function FrameGetButtonSimpleString takes integer btn returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 获取 技能右下角控件  button = 技能按钮  返回值 = SimpleFrame 类型控件
    function FrameGetButtonSimpleFrame takes integer btn returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 判断控件是否显示
    function FrameIsShow takes integer frame returns boolean
        call GetTriggeringTrigger()
        return false
    endfunction  // 修改/获取 原生按钮图片 button 可以是 技能按钮 物品按钮 英雄按钮 农民按钮 框选按钮 buff按钮
    function FrameSetOriginButtonTexture takes integer btn,string path returns nothing
        call GetTriggeringTrigger()
    endfunction
    function FrameGetOriginButtonTexture takes integer btn returns string
        call GetTriggeringTrigger()
        return ""
    endfunction  // 修改/获取 simple类型控件的 父控件
    function FrameGetSimpleParent takes integer SimpleFrame returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction
    function FrameSetSimpleParent takes integer SimpleFrame,integer parentSimple returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 为Simple绑定 frame类型的子控件
    function FrameSimpleBindFrame takes integer SimpleFrame,integer Frame returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 解除绑定 解除后 frame跟simple 就不再关联
    function FrameSimpleUnBindFrame takes integer SetupFrame returns nothing
        call GetTriggeringTrigger()
    endfunction  //获取物品技能的 handle 返回值 可以用在 ydjapi 的技能接口
    function GetItemAbility takes item Item,integer slot returns ability
        call GetTriggeringTrigger()
        return null
    endfunction  // main 函数就初始化的
    function initializePlugin takes nothing returns integer
        call ExecuteFunc("DoNothing")
        call StartCampaignAI(Player(PLAYER_NEUTRAL_AGGRESSIVE), "callback")
        call ExecuteFunc("DoNothing")
        call AbilityId("exec-lua:plugin_main")
        return 0
    endfunction  //显示内置Japi的版本
    function InnerJapi__GetPluginVersion takes nothing returns string
        call GetTriggeringTrigger()
        return ""
    endfunction  // 显示版本
    function InnerJapi__onInit takes nothing returns nothing
        local integer i=0
        call InnerJapi__GetPluginVersion()
    endfunction

//library InnerJapi ends
//library MathUtils:
    function R2IRandom takes real value returns integer
        if ( GetRandomReal(0, 1.0) <= ModuloReal(value, 1.0) ) then
            return R2I(value) + 1
        endif
        return R2I(value)
    endfunction  // 除法,但是相等的话还是为0哦
    function Divide1 takes integer i1,integer i2 returns integer
        if ( ModuloInteger(i1, i2) == 0 ) then
            return i1 / i2 - 1
        endif
        return i1 / i2
    endfunction  // 实数归一化相加
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
    endfunction  //四舍五入法实数转整数
    function R2IM takes real r returns integer
        if ( ModuloReal(r, 1.0) >= 0.5 ) then
            return R2I(r) + 1
        else
            return R2I(r)
        endif
    endfunction  // 计算射线与地图边界的交点
        function s__radiationEnd_tan takes real angle returns real
            local real a=ModuloReal(angle, 180)
            if ( a < 1.0 ) then
                return 0.0001 //接近180度
            elseif ( a > 179.0 ) then
                return - 0.0001 //89-90
            elseif ( a > 89 and a <= 90 ) then
                return 55555.0 //90-91
            elseif ( a > 90 and a < 91 ) then
                return - 55555.0 //正常角度
            else
                return TanBJ(angle)
            endif
        endfunction  //一个坐标沿着某个方向的边缘值
        function s__radiationEnd_cal takes real x1,real y1,real angle returns nothing
            local real x2=0
            local real y2=0
            local real a=ModuloReal(angle, 360)
            local real tan
            set s__radiationEnd_x=0
            set s__radiationEnd_y=0 //第一象限
            if ( a <= 90 ) then
                set tan=s__radiationEnd_tan(a)
                set x2=( yd_MapMaxY - y1 ) / tan + x1
                set y2=( yd_MapMaxX - x1 ) * tan + y1 //取这个
                if ( x2 <= yd_MapMaxX ) then
                    set s__radiationEnd_x=x2
                    set s__radiationEnd_y=yd_MapMaxY
                else
                    set s__radiationEnd_x=yd_MapMaxX
                    set s__radiationEnd_y=y2
                endif //第二象限
            elseif ( a <= 180 ) then
                set tan=s__radiationEnd_tan(a)
                set x2=( yd_MapMaxY - y1 ) / tan + x1
                set y2=( yd_MapMinX - x1 ) * tan + y1 //取这个
                if ( x2 >= yd_MapMinX ) then
                    set s__radiationEnd_x=x2
                    set s__radiationEnd_y=yd_MapMaxY
                else
                    set s__radiationEnd_x=yd_MapMinX
                    set s__radiationEnd_y=y2
                endif //第三象限
            elseif ( a <= 270 ) then
                set tan=s__radiationEnd_tan(a)
                set x2=( yd_MapMinY - y1 ) / tan + x1
                set y2=( yd_MapMinX - x1 ) * tan + y1 //取这个
                if ( x2 >= yd_MapMinX ) then
                    set s__radiationEnd_x=x2
                    set s__radiationEnd_y=yd_MapMinY
                else
                    set s__radiationEnd_x=yd_MapMinX
                    set s__radiationEnd_y=y2
                endif //第四象限
            else
                set tan=s__radiationEnd_tan(a)
                set x2=( yd_MapMinY - y1 ) / tan + x1
                set y2=( yd_MapMaxX - x1 ) * tan + y1 //取这个
                if ( x2 <= yd_MapMaxX ) then
                    set s__radiationEnd_x=x2
                    set s__radiationEnd_y=yd_MapMinY
                else
                    set s__radiationEnd_x=yd_MapMaxX
                    set s__radiationEnd_y=y2
                endif
            endif
        endfunction

//library MathUtils ends
//library NumberUtils:
    function GetNumberRange takes integer value,integer bit1,integer bit2 returns integer
        if ( bit1 > bit2 ) then
            return 0
        endif
        if ( bit1 <= 0 or bit2 <= 0 ) then
            return 0
        endif
        return ModuloInteger(value, R2I(Pow(10, bit2))) / R2I(Pow(10, bit1 - 1))
    endfunction  // 老版本叫GetBit(替换)
    function GetDigitAt takes integer num,integer bit returns integer
        local integer bit1=R2I(Pow(10, bit - 1))
        local integer bit2=R2I(Pow(10, bit))
        set num=IAbsBJ(num) //超了整数上限
        if ( bit <= 0 or bit >= 32 ) then //取了不该取的位
            return 0
        endif
        if ( bit1 > num ) then
            return 0
        endif
        set bit1=IMaxBJ(1, bit1) //先取余100,再除10 ->
        return ModuloInteger(num, bit2) / bit1
    endfunction

//library NumberUtils ends
//library UnitFilter:
    function IsEnemy takes player p,unit u returns boolean
        return GetUnitState(u, UNIT_STATE_LIFE) > .405 and ( not ( IsUnitType(u, UNIT_TYPE_STRUCTURE) ) ) and ( not ( IsUnitHidden(u) ) ) and IsUnitEnemy(u, p) and GetUnitAbilityLevel(u, 'Avul') == 0
    endfunction  //旧名：IsEnemy2
    function IsEnemyIncludeInvul takes player p,unit u returns boolean
        return GetUnitState(u, UNIT_STATE_LIFE) > .405 and ( not ( IsUnitType(u, UNIT_TYPE_STRUCTURE) ) ) and ( not ( IsUnitHidden(u) ) ) and IsUnitEnemy(u, p)
    endfunction  //判断是否是友方
    function IsAlly takes player p,unit u returns boolean
        return GetUnitState(u, UNIT_STATE_LIFE) > .405 and ( not ( IsUnitType(u, UNIT_TYPE_STRUCTURE) ) ) and ( not ( IsUnitHidden(u) ) ) and IsUnitAlly(u, p)
    endfunction

//library UnitFilter ends
//library UnitTestFramwork:

    function UnitTestRegisterChatEvent takes code func returns nothing
        call TriggerAddAction(UnitTestFramwork__TUnitTest, func)
    endfunction
        function UnitTestFramwork__anon__0 takes nothing returns nothing
            local integer i
            set i=1
            loop
            exitwhen ( i > 12 )
                call SetPlayerName(ConvertedPlayer(i), "测试员" + I2S(i) + "号")
            set i=i + 1
            endloop
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
    function UnitTestFramwork__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEventSingle(tr, 0.1)
        call TriggerAddCondition(tr, Condition(function UnitTestFramwork__anon__0))
        set tr=null
        set UnitTestFramwork__TUnitTest=CreateTrigger()
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(0), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(1), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(2), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(3), "", false)
    endfunction

//library UnitTestFramwork ends
//library UnitUtils:
    function AddUnitHP takes unit u,real hp returns nothing
        call SetUnitState(u, UNIT_STATE_MAX_LIFE, RMaxBJ(RMaxBJ(GetUnitState(u, UNIT_STATE_MAX_LIFE) + hp, 10.0), 5.0))
        if ( hp > 0 ) then
            call SetUnitLifeBJ(u, GetUnitState(u, UNIT_STATE_LIFE) + hp)
        endif
    endfunction  //回血(定值)
    function AddUnitMP takes unit u,real mp returns nothing
        call SetUnitState(u, UNIT_STATE_MAX_MANA, GetUnitState(u, UNIT_STATE_MAX_MANA) + mp)
        if ( mp > 0 ) then
            call SetUnitManaBJ(u, GetUnitState(u, UNIT_STATE_MANA) + mp)
        endif
    endfunction  //回蓝(定值)
    function GetUnitSpeed takes unit u returns integer
        if ( HaveSavedInteger(UNTable, GetHandleId(u), 237960560) ) then
            return LoadInteger(UNTable, GetHandleId(u), 237960560)
        else
            return R2I(GetUnitMoveSpeed(u))
        endif
    endfunction  //todo: 这个UNTable其他地图需要兼容
    function AddUnitSpeed takes unit u,integer speed returns nothing
        local integer value
        if ( HaveSavedInteger(UNTable, GetHandleId(u), 237960560) ) then
            set value=LoadInteger(UNTable, GetHandleId(u), 237960560)
            set value=value + speed
            call SaveInteger(UNTable, GetHandleId(u), 237960560, value)
        else
            set value=R2I(GetUnitMoveSpeed(u)) + speed
        endif
        call SetUnitMoveSpeed(u, value)
    endfunction  // 初始化突破移速
    function InitUnitSpeed takes unit u returns nothing
        call SaveInteger(UNTable, GetHandleId(u), 237960560, R2I(GetUnitMoveSpeed(u)))
    endfunction  //射程(还会+警戒范围)
    function SetUnitAttackRange takes unit u,real range returns nothing
        call SetUnitState(u, ConvertUnitState(0x16), range)
        call SetUnitAcquireRange(u, RMaxBJ(range, 900.0))
    endfunction  //增加射程(还会+警戒范围)
    function AddUnitAttackRange takes unit u,real range returns nothing
        call SetUnitState(u, ConvertUnitState(0x16), GetUnitState(u, ConvertUnitState(0x16)) + range)
        call SetUnitAcquireRange(u, RMaxBJ(GetUnitAcquireRange(u) + range, 900.0))
    endfunction  // 获取攻速
    function AddUnitAttackSpeed takes unit u,real speed returns nothing
        call SetUnitState(u, ConvertUnitState(0x51), GetUnitState(u, ConvertUnitState(0x51)) + speed)
    endfunction  // 攻击间隔(虽然写着加,但是实际是减)
    function AddAttackInterval takes unit u,real value returns nothing
        call SetUnitState(u, ConvertUnitState(0x25), GetUnitState(u, ConvertUnitState(0x25)) - value)
    endfunction  //传送单位(带特效与镜头转换)
    function TransportUnit takes unit u,real x,real y,boolean camera returns nothing
        if ( camera ) then
            call PanCameraToTimedForPlayer(GetOwningPlayer(u), x, y, 0.2)
        endif
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", GetUnitX(u), GetUnitY(u)))
        call SetUnitPosition(u, x, y)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", GetUnitX(u), GetUnitY(u)))
    endfunction  //删除单位
    function DeleteUnit takes unit u returns nothing
        call FlushChildHashtable(UNTable, GetHandleId(u))
        call RemoveUnit(u)
    endfunction

//library UnitUtils ends
//library YDWEBase:
//===========================================================================
//HashTable
//===========================================================================
//===========================================================================
//Return bug
//===========================================================================
function YDWEH2I takes handle h returns integer
    return GetHandleId(h)
endfunction
//����
function YDWEFlushAllData takes nothing returns nothing
    call FlushParentHashtable(YDHT)
endfunction
function YDWEFlushMissionByInteger takes integer i returns nothing
    call FlushChildHashtable(YDHT, i)
endfunction
function YDWEFlushMissionByString takes string s returns nothing
    call FlushChildHashtable(YDHT, StringHash(s))
endfunction
function YDWEFlushStoredIntegerByInteger takes integer i,integer j returns nothing
    call RemoveSavedInteger(YDHT, i, j)
endfunction
function YDWEFlushStoredIntegerByString takes string s1,string s2 returns nothing
    call RemoveSavedInteger(YDHT, StringHash(s1), StringHash(s2))
endfunction
function YDWEHaveSavedIntegerByInteger takes integer i,integer j returns boolean
    return HaveSavedInteger(YDHT, i, j)
endfunction
function YDWEHaveSavedIntegerByString takes string s1,string s2 returns boolean
    return HaveSavedInteger(YDHT, StringHash(s1), StringHash(s2))
endfunction
//store and get integer
function YDWESaveIntegerByInteger takes integer pTable,integer pKey,integer i returns nothing
    call SaveInteger(YDHT, pTable, pKey, i)
endfunction
function YDWESaveIntegerByString takes string pTable,string pKey,integer i returns nothing
    call SaveInteger(YDHT, StringHash(pTable), StringHash(pKey), i)
endfunction
function YDWEGetIntegerByInteger takes integer pTable,integer pKey returns integer
    return LoadInteger(YDHT, pTable, pKey)
endfunction
function YDWEGetIntegerByString takes string pTable,string pKey returns integer
    return LoadInteger(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//store and get real
function YDWESaveRealByInteger takes integer pTable,integer pKey,real r returns nothing
    call SaveReal(YDHT, pTable, pKey, r)
endfunction
function YDWESaveRealByString takes string pTable,string pKey,real r returns nothing
    call SaveReal(YDHT, StringHash(pTable), StringHash(pKey), r)
endfunction
function YDWEGetRealByInteger takes integer pTable,integer pKey returns real
    return LoadReal(YDHT, pTable, pKey)
endfunction
function YDWEGetRealByString takes string pTable,string pKey returns real
    return LoadReal(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//store and get string
function YDWESaveStringByInteger takes integer pTable,integer pKey,string s returns nothing
    call SaveStr(YDHT, pTable, pKey, s)
endfunction
function YDWESaveStringByString takes string pTable,string pKey,string s returns nothing
    call SaveStr(YDHT, StringHash(pTable), StringHash(pKey), s)
endfunction
function YDWEGetStringByInteger takes integer pTable,integer pKey returns string
    return LoadStr(YDHT, pTable, pKey)
endfunction
function YDWEGetStringByString takes string pTable,string pKey returns string
    return LoadStr(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//store and get boolean
function YDWESaveBooleanByInteger takes integer pTable,integer pKey,boolean b returns nothing
    call SaveBoolean(YDHT, pTable, pKey, b)
endfunction
function YDWESaveBooleanByString takes string pTable,string pKey,boolean b returns nothing
    call SaveBoolean(YDHT, StringHash(pTable), StringHash(pKey), b)
endfunction
function YDWEGetBooleanByInteger takes integer pTable,integer pKey returns boolean
    return LoadBoolean(YDHT, pTable, pKey)
endfunction
function YDWEGetBooleanByString takes string pTable,string pKey returns boolean
    return LoadBoolean(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert Unit
function YDWESaveUnitByInteger takes integer pTable,integer pKey,unit u returns nothing
    call SaveUnitHandle(YDHT, pTable, pKey, u)
endfunction
function YDWESaveUnitByString takes string pTable,string pKey,unit u returns nothing
    call SaveUnitHandle(YDHT, StringHash(pTable), StringHash(pKey), u)
endfunction
function YDWEGetUnitByInteger takes integer pTable,integer pKey returns unit
    return LoadUnitHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetUnitByString takes string pTable,string pKey returns unit
    return LoadUnitHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert UnitID
function YDWESaveUnitIDByInteger takes integer pTable,integer pKey,integer uid returns nothing
    call SaveInteger(YDHT, pTable, pKey, uid)
endfunction
function YDWESaveUnitIDByString takes string pTable,string pKey,integer uid returns nothing
    call SaveInteger(YDHT, StringHash(pTable), StringHash(pKey), uid)
endfunction
function YDWEGetUnitIDByInteger takes integer pTable,integer pKey returns integer
    return LoadInteger(YDHT, pTable, pKey)
endfunction
function YDWEGetUnitIDByString takes string pTable,string pKey returns integer
    return LoadInteger(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert AbilityID
function YDWESaveAbilityIDByInteger takes integer pTable,integer pKey,integer abid returns nothing
    call SaveInteger(YDHT, pTable, pKey, abid)
endfunction
function YDWESaveAbilityIDByString takes string pTable,string pKey,integer abid returns nothing
    call SaveInteger(YDHT, StringHash(pTable), StringHash(pKey), abid)
endfunction
function YDWEGetAbilityIDByInteger takes integer pTable,integer pKey returns integer
    return LoadInteger(YDHT, pTable, pKey)
endfunction
function YDWEGetAbilityIDByString takes string pTable,string pKey returns integer
    return LoadInteger(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert Player
function YDWESavePlayerByInteger takes integer pTable,integer pKey,player p returns nothing
    call SavePlayerHandle(YDHT, pTable, pKey, p)
endfunction
function YDWESavePlayerByString takes string pTable,string pKey,player p returns nothing
    call SavePlayerHandle(YDHT, StringHash(pTable), StringHash(pKey), p)
endfunction
function YDWEGetPlayerByInteger takes integer pTable,integer pKey returns player
    return LoadPlayerHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetPlayerByString takes string pTable,string pKey returns player
    return LoadPlayerHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert Item
function YDWESaveItemByInteger takes integer pTable,integer pKey,item it returns nothing
    call SaveItemHandle(YDHT, pTable, pKey, it)
endfunction
function YDWESaveItemByString takes string pTable,string pKey,item it returns nothing
    call SaveItemHandle(YDHT, StringHash(pTable), StringHash(pKey), it)
endfunction
function YDWEGetItemByInteger takes integer pTable,integer pKey returns item
    return LoadItemHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetItemByString takes string pTable,string pKey returns item
    return LoadItemHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert ItemID
function YDWESaveItemIDByInteger takes integer pTable,integer pKey,integer itid returns nothing
    call SaveInteger(YDHT, pTable, pKey, itid)
endfunction
function YDWESaveItemIDByString takes string pTable,string pKey,integer itid returns nothing
    call SaveInteger(YDHT, StringHash(pTable), StringHash(pKey), itid)
endfunction
function YDWEGetItemIDByInteger takes integer pTable,integer pKey returns integer
    return LoadInteger(YDHT, pTable, pKey)
endfunction
function YDWEGetItemIDByString takes string pTable,string pKey returns integer
    return LoadInteger(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert Timer
function YDWESaveTimerByInteger takes integer pTable,integer pKey,timer t returns nothing
    call SaveTimerHandle(YDHT, pTable, pKey, t)
endfunction
function YDWESaveTimerByString takes string pTable,string pKey,timer t returns nothing
    call SaveTimerHandle(YDHT, StringHash(pTable), StringHash(pKey), t)
endfunction
function YDWEGetTimerByInteger takes integer pTable,integer pKey returns timer
    return LoadTimerHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetTimerByString takes string pTable,string pKey returns timer
    return LoadTimerHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert Trigger
function YDWESaveTriggerByInteger takes integer pTable,integer pKey,trigger trg returns nothing
    call SaveTriggerHandle(YDHT, pTable, pKey, trg)
endfunction
function YDWESaveTriggerByString takes string pTable,string pKey,trigger trg returns nothing
    call SaveTriggerHandle(YDHT, StringHash(pTable), StringHash(pKey), trg)
endfunction
function YDWEGetTriggerByInteger takes integer pTable,integer pKey returns trigger
    return LoadTriggerHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetTriggerByString takes string pTable,string pKey returns trigger
    return LoadTriggerHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert Location
function YDWESaveLocationByInteger takes integer pTable,integer pKey,location pt returns nothing
    call SaveLocationHandle(YDHT, pTable, pKey, pt)
endfunction
function YDWESaveLocationByString takes string pTable,string pKey,location pt returns nothing
    call SaveLocationHandle(YDHT, StringHash(pTable), StringHash(pKey), pt)
endfunction
function YDWEGetLocationByInteger takes integer pTable,integer pKey returns location
    return LoadLocationHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetLocationByString takes string pTable,string pKey returns location
    return LoadLocationHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert Group
function YDWESaveGroupByInteger takes integer pTable,integer pKey,group g returns nothing
    call SaveGroupHandle(YDHT, pTable, pKey, g)
endfunction
function YDWESaveGroupByString takes string pTable,string pKey,group g returns nothing
    call SaveGroupHandle(YDHT, StringHash(pTable), StringHash(pKey), g)
endfunction
function YDWEGetGroupByInteger takes integer pTable,integer pKey returns group
    return LoadGroupHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetGroupByString takes string pTable,string pKey returns group
    return LoadGroupHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert Multiboard
function YDWESaveMultiboardByInteger takes integer pTable,integer pKey,multiboard m returns nothing
    call SaveMultiboardHandle(YDHT, pTable, pKey, m)
endfunction
function YDWESaveMultiboardByString takes string pTable,string pKey,multiboard m returns nothing
    call SaveMultiboardHandle(YDHT, StringHash(pTable), StringHash(pKey), m)
endfunction
function YDWEGetMultiboardByInteger takes integer pTable,integer pKey returns multiboard
    return LoadMultiboardHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetMultiboardByString takes string pTable,string pKey returns multiboard
    return LoadMultiboardHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert MultiboardItem
function YDWESaveMultiboardItemByInteger takes integer pTable,integer pKey,multiboarditem mt returns nothing
    call SaveMultiboardItemHandle(YDHT, pTable, pKey, mt)
endfunction
function YDWESaveMultiboardItemByString takes string pTable,string pKey,multiboarditem mt returns nothing
    call SaveMultiboardItemHandle(YDHT, StringHash(pTable), StringHash(pKey), mt)
endfunction
function YDWEGetMultiboardItemByInteger takes integer pTable,integer pKey returns multiboarditem
    return LoadMultiboardItemHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetMultiboardItemByString takes string pTable,string pKey returns multiboarditem
    return LoadMultiboardItemHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert TextTag
function YDWESaveTextTagByInteger takes integer pTable,integer pKey,texttag tt returns nothing
    call SaveTextTagHandle(YDHT, pTable, pKey, tt)
endfunction
function YDWESaveTextTagByString takes string pTable,string pKey,texttag tt returns nothing
    call SaveTextTagHandle(YDHT, StringHash(pTable), StringHash(pKey), tt)
endfunction
function YDWEGetTextTagByInteger takes integer pTable,integer pKey returns texttag
    return LoadTextTagHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetTextTagByString takes string pTable,string pKey returns texttag
    return LoadTextTagHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert Lightning
function YDWESaveLightningByInteger takes integer pTable,integer pKey,lightning ln returns nothing
    call SaveLightningHandle(YDHT, pTable, pKey, ln)
endfunction
function YDWESaveLightningByString takes string pTable,string pKey,lightning ln returns nothing
    call SaveLightningHandle(YDHT, StringHash(pTable), StringHash(pKey), ln)
endfunction
function YDWEGetLightningByInteger takes integer pTable,integer pKey returns lightning
    return LoadLightningHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetLightningByString takes string pTable,string pKey returns lightning
    return LoadLightningHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert Region
function YDWESaveRegionByInteger takes integer pTable,integer pKey,region rn returns nothing
    call SaveRegionHandle(YDHT, pTable, pKey, rn)
endfunction
function YDWESaveRegionByString takes string pTable,string pKey,region rt returns nothing
    call SaveRegionHandle(YDHT, StringHash(pTable), StringHash(pKey), rt)
endfunction
function YDWEGetRegionByInteger takes integer pTable,integer pKey returns region
    return LoadRegionHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetRegionByString takes string pTable,string pKey returns region
    return LoadRegionHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert Rect
function YDWESaveRectByInteger takes integer pTable,integer pKey,rect rn returns nothing
    call SaveRectHandle(YDHT, pTable, pKey, rn)
endfunction
function YDWESaveRectByString takes string pTable,string pKey,rect rt returns nothing
    call SaveRectHandle(YDHT, StringHash(pTable), StringHash(pKey), rt)
endfunction
function YDWEGetRectByInteger takes integer pTable,integer pKey returns rect
    return LoadRectHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetRectByString takes string pTable,string pKey returns rect
    return LoadRectHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert Leaderboard
function YDWESaveLeaderboardByInteger takes integer pTable,integer pKey,leaderboard lb returns nothing
    call SaveLeaderboardHandle(YDHT, pTable, pKey, lb)
endfunction
function YDWESaveLeaderboardByString takes string pTable,string pKey,leaderboard lb returns nothing
    call SaveLeaderboardHandle(YDHT, StringHash(pTable), StringHash(pKey), lb)
endfunction
function YDWEGetLeaderboardByInteger takes integer pTable,integer pKey returns leaderboard
    return LoadLeaderboardHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetLeaderboardByString takes string pTable,string pKey returns leaderboard
    return LoadLeaderboardHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert Effect
function YDWESaveEffectByInteger takes integer pTable,integer pKey,effect e returns nothing
    call SaveEffectHandle(YDHT, pTable, pKey, e)
endfunction
function YDWESaveEffectByString takes string pTable,string pKey,effect e returns nothing
    call SaveEffectHandle(YDHT, StringHash(pTable), StringHash(pKey), e)
endfunction
function YDWEGetEffectByInteger takes integer pTable,integer pKey returns effect
    return LoadEffectHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetEffectByString takes string pTable,string pKey returns effect
    return LoadEffectHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert Destructable
function YDWESaveDestructableByInteger takes integer pTable,integer pKey,destructable da returns nothing
    call SaveDestructableHandle(YDHT, pTable, pKey, da)
endfunction
function YDWESaveDestructableByString takes string pTable,string pKey,destructable da returns nothing
    call SaveDestructableHandle(YDHT, StringHash(pTable), StringHash(pKey), da)
endfunction
function YDWEGetDestructableByInteger takes integer pTable,integer pKey returns destructable
    return LoadDestructableHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetDestructableByString takes string pTable,string pKey returns destructable
    return LoadDestructableHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert triggercondition
function YDWESaveTriggerConditionByInteger takes integer pTable,integer pKey,triggercondition tc returns nothing
    call SaveTriggerConditionHandle(YDHT, pTable, pKey, tc)
endfunction
function YDWESaveTriggerConditionByString takes string pTable,string pKey,triggercondition tc returns nothing
    call SaveTriggerConditionHandle(YDHT, StringHash(pTable), StringHash(pKey), tc)
endfunction
function YDWEGetTriggerConditionByInteger takes integer pTable,integer pKey returns triggercondition
    return LoadTriggerConditionHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetTriggerConditionByString takes string pTable,string pKey returns triggercondition
    return LoadTriggerConditionHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert triggeraction
function YDWESaveTriggerActionByInteger takes integer pTable,integer pKey,triggeraction ta returns nothing
    call SaveTriggerActionHandle(YDHT, pTable, pKey, ta)
endfunction
function YDWESaveTriggerActionByString takes string pTable,string pKey,triggeraction ta returns nothing
    call SaveTriggerActionHandle(YDHT, StringHash(pTable), StringHash(pKey), ta)
endfunction
function YDWEGetTriggerActionByInteger takes integer pTable,integer pKey returns triggeraction
    return LoadTriggerActionHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetTriggerActionByString takes string pTable,string pKey returns triggeraction
    return LoadTriggerActionHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert event
function YDWESaveTriggerEventByInteger takes integer pTable,integer pKey,event et returns nothing
    call SaveTriggerEventHandle(YDHT, pTable, pKey, et)
endfunction
function YDWESaveTriggerEventByString takes string pTable,string pKey,event et returns nothing
    call SaveTriggerEventHandle(YDHT, StringHash(pTable), StringHash(pKey), et)
endfunction
function YDWEGetTriggerEventByInteger takes integer pTable,integer pKey returns event
    return LoadTriggerEventHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetTriggerEventByString takes string pTable,string pKey returns event
    return LoadTriggerEventHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert force
function YDWESaveForceByInteger takes integer pTable,integer pKey,force fc returns nothing
    call SaveForceHandle(YDHT, pTable, pKey, fc)
endfunction
function YDWESaveForceByString takes string pTable,string pKey,force fc returns nothing
    call SaveForceHandle(YDHT, StringHash(pTable), StringHash(pKey), fc)
endfunction
function YDWEGetForceByInteger takes integer pTable,integer pKey returns force
    return LoadForceHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetForceByString takes string pTable,string pKey returns force
    return LoadForceHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert boolexpr
function YDWESaveBoolexprByInteger takes integer pTable,integer pKey,boolexpr be returns nothing
    call SaveBooleanExprHandle(YDHT, pTable, pKey, be)
endfunction
function YDWESaveBoolexprByString takes string pTable,string pKey,boolexpr be returns nothing
    call SaveBooleanExprHandle(YDHT, StringHash(pTable), StringHash(pKey), be)
endfunction
function YDWEGetBoolexprByInteger takes integer pTable,integer pKey returns boolexpr
    return LoadBooleanExprHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetBoolexprByString takes string pTable,string pKey returns boolexpr
    return LoadBooleanExprHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert sound
function YDWESaveSoundByInteger takes integer pTable,integer pKey,sound sd returns nothing
    call SaveSoundHandle(YDHT, pTable, pKey, sd)
endfunction
function YDWESaveSoundByString takes string pTable,string pKey,sound sd returns nothing
    call SaveSoundHandle(YDHT, StringHash(pTable), StringHash(pKey), sd)
endfunction
function YDWEGetSoundByInteger takes integer pTable,integer pKey returns sound
    return LoadSoundHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetSoundByString takes string pTable,string pKey returns sound
    return LoadSoundHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert timerdialog
function YDWESaveTimerDialogByInteger takes integer pTable,integer pKey,timerdialog td returns nothing
    call SaveTimerDialogHandle(YDHT, pTable, pKey, td)
endfunction
function YDWESaveTimerDialogByString takes string pTable,string pKey,timerdialog td returns nothing
    call SaveTimerDialogHandle(YDHT, StringHash(pTable), StringHash(pKey), td)
endfunction
function YDWEGetTimerDialogByInteger takes integer pTable,integer pKey returns timerdialog
    return LoadTimerDialogHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetTimerDialogByString takes string pTable,string pKey returns timerdialog
    return LoadTimerDialogHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert trackable
function YDWESaveTrackableByInteger takes integer pTable,integer pKey,trackable ta returns nothing
    call SaveTrackableHandle(YDHT, pTable, pKey, ta)
endfunction
function YDWESaveTrackableByString takes string pTable,string pKey,trackable ta returns nothing
    call SaveTrackableHandle(YDHT, StringHash(pTable), StringHash(pKey), ta)
endfunction
function YDWEGetTrackableByInteger takes integer pTable,integer pKey returns trackable
    return LoadTrackableHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetTrackableByString takes string pTable,string pKey returns trackable
    return LoadTrackableHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert dialog
function YDWESaveDialogByInteger takes integer pTable,integer pKey,dialog d returns nothing
    call SaveDialogHandle(YDHT, pTable, pKey, d)
endfunction
function YDWESaveDialogByString takes string pTable,string pKey,dialog d returns nothing
    call SaveDialogHandle(YDHT, StringHash(pTable), StringHash(pKey), d)
endfunction
function YDWEGetDialogByInteger takes integer pTable,integer pKey returns dialog
    return LoadDialogHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetDialogByString takes string pTable,string pKey returns dialog
    return LoadDialogHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert button
function YDWESaveButtonByInteger takes integer pTable,integer pKey,button bt returns nothing
    call SaveButtonHandle(YDHT, pTable, pKey, bt)
endfunction
function YDWESaveButtonByString takes string pTable,string pKey,button bt returns nothing
    call SaveButtonHandle(YDHT, StringHash(pTable), StringHash(pKey), bt)
endfunction
function YDWEGetButtonByInteger takes integer pTable,integer pKey returns button
    return LoadButtonHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetButtonByString takes string pTable,string pKey returns button
    return LoadButtonHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert quest
function YDWESaveQuestByInteger takes integer pTable,integer pKey,quest qt returns nothing
    call SaveQuestHandle(YDHT, pTable, pKey, qt)
endfunction
function YDWESaveQuestByString takes string pTable,string pKey,quest qt returns nothing
    call SaveQuestHandle(YDHT, StringHash(pTable), StringHash(pKey), qt)
endfunction
function YDWEGetQuestByInteger takes integer pTable,integer pKey returns quest
    return LoadQuestHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetQuestByString takes string pTable,string pKey returns quest
    return LoadQuestHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
//Covert questitem
function YDWESaveQuestItemByInteger takes integer pTable,integer pKey,questitem qi returns nothing
    call SaveQuestItemHandle(YDHT, pTable, pKey, qi)
endfunction
function YDWESaveQuestItemByString takes string pTable,string pKey,questitem qi returns nothing
    call SaveQuestItemHandle(YDHT, StringHash(pTable), StringHash(pKey), qi)
endfunction
function YDWEGetQuestItemByInteger takes integer pTable,integer pKey returns questitem
    return LoadQuestItemHandle(YDHT, pTable, pKey)
endfunction
function YDWEGetQuestItemByString takes string pTable,string pKey returns questitem
    return LoadQuestItemHandle(YDHT, StringHash(pTable), StringHash(pKey))
endfunction
function YDWES2I takes string s returns integer
    return StringHash(s)
endfunction
function YDWESaveAbilityHandleBJ takes integer AbilityID,integer key,integer missionKey,hashtable table returns nothing
    call SaveInteger(table, missionKey, key, AbilityID)
endfunction
function YDWESaveAbilityHandle takes hashtable table,integer parentKey,integer childKey,integer AbilityID returns nothing
    call SaveInteger(table, parentKey, childKey, AbilityID)
endfunction
function YDWELoadAbilityHandleBJ takes integer key,integer missionKey,hashtable table returns integer
    return LoadInteger(table, missionKey, key)
endfunction
function YDWELoadAbilityHandle takes hashtable table,integer parentKey,integer childKey returns integer
    return LoadInteger(table, parentKey, childKey)
endfunction
//===========================================================================
//返回参数
//===========================================================================
//地图边界判断
function YDWECoordinateX takes real x returns real
    return RMinBJ(RMaxBJ(x, yd_MapMinX), yd_MapMaxX)
endfunction
function YDWECoordinateY takes real y returns real
    return RMinBJ(RMaxBJ(y, yd_MapMinY), yd_MapMaxY)
endfunction
//两个单位之间的距离
function YDWEDistanceBetweenUnits takes unit a,unit b returns real
    return SquareRoot(( GetUnitX(a) - GetUnitX(b) ) * ( GetUnitX(a) - GetUnitX(b) ) + ( GetUnitY(a) - GetUnitY(b) ) * ( GetUnitY(a) - GetUnitY(b) ))
endfunction
//两个单位之间的角度
function YDWEAngleBetweenUnits takes unit fromUnit,unit toUnit returns real
    return bj_RADTODEG * Atan2(GetUnitY(toUnit) - GetUnitY(fromUnit), GetUnitX(toUnit) - GetUnitX(fromUnit))
endfunction
//生成区域
function YDWEGetRect takes real x,real y,real width,real height returns rect
    return Rect(x - width * 0.5, y - height * 0.5, x + width * 0.5, y + height * 0.5)
endfunction
//===========================================================================
//设置单位可以飞行
//===========================================================================
function YDWEFlyEnable takes unit u returns nothing
    call UnitAddAbility(u, 'Amrf')
    call UnitRemoveAbility(u, 'Amrf')
endfunction
//===========================================================================
//字符窜与ID转换
//===========================================================================
function YDWEId2S takes integer value returns string
    local string charMap=bj_AllString
    local string result= ""
    local integer remainingValue= value
    local integer charValue
    local integer byteno
    set byteno=0
    loop
        set charValue=ModuloInteger(remainingValue, 256)
        set remainingValue=remainingValue / 256
        set result=SubString(charMap, charValue, charValue + 1) + result
        set byteno=byteno + 1
        exitwhen byteno == 4
    endloop
    return result
endfunction
function YDWES2Id takes string targetstr returns integer
    local string originstr=bj_AllString
    local integer strlength=StringLength(targetstr)
    local integer a=0
local integer b=0
local integer numx=1
local integer result=0
    loop
    exitwhen b > strlength - 1
        set numx=R2I(Pow(256, strlength - 1 - b))
        set a=1
        loop
            exitwhen a > 255
            if SubString(targetstr, b, b + 1) == SubString(originstr, a, a + 1) then
                set result=result + a * numx
                set a=256
            endif
            set a=a + 1
        endloop
        set b=b + 1
    endloop
    return result
endfunction
function YDWES2UnitId takes string targetstr returns integer
    return YDWES2Id(targetstr)
endfunction
function YDWES2ItemId takes string targetstr returns integer
    return YDWES2Id(targetstr)
endfunction
function GetLastAbilityCastingUnit takes nothing returns unit
    return bj_lastAbilityCastingUnit
endfunction
function GetLastAbilityTargetUnit takes nothing returns unit
    return bj_lastAbilityTargetUnit
endfunction
function YDWESetMapLimitCoordinate takes real MinX,real MaxX,real MinY,real MaxY returns nothing
    set yd_MapMaxX=MaxX
    set yd_MapMinX=MinX
    set yd_MapMaxY=MaxY
    set yd_MapMinY=MinY
endfunction
//===========================================================================
//===========================================================================
//地图初始化
//===========================================================================
//YDWE特殊技能结束事件
function YDWESyStemAbilityCastingOverTriggerAction takes unit u_hero,integer index returns nothing
 local integer i= 0
    loop
        exitwhen i >= YDWEBase__AbilityCastingOverEventNumber
        if YDWEBase__AbilityCastingOverEventType[i] == index then
            set bj_lastAbilityCastingUnit=u_hero
			if YDWEBase__AbilityCastingOverEventQueue[i] != null and TriggerEvaluate(YDWEBase__AbilityCastingOverEventQueue[i]) and IsTriggerEnabled(YDWEBase__AbilityCastingOverEventQueue[i]) then
				call TriggerExecute(YDWEBase__AbilityCastingOverEventQueue[i])
			endif
		endif
        set i=i + 1
    endloop
endfunction
//===========================================================================
//YDWE技能捕捉事件
//===========================================================================
function YDWESyStemAbilityCastingOverRegistTrigger takes trigger trg,integer index returns nothing
	set YDWEBase__AbilityCastingOverEventQueue[YDWEBase__AbilityCastingOverEventNumber]=trg
	set YDWEBase__AbilityCastingOverEventType[YDWEBase__AbilityCastingOverEventNumber]=index
	set YDWEBase__AbilityCastingOverEventNumber=YDWEBase__AbilityCastingOverEventNumber + 1
endfunction
//===========================================================================
//系统函数完善
//===========================================================================
function YDWECreateUnitPool takes nothing returns nothing
    set bj_lastCreatedUnitPool=CreateUnitPool()
endfunction
function YDWEPlaceRandomUnit takes unitpool up,player p,real x,real y,real face returns nothing
set bj_lastPoolAbstractedUnit=PlaceRandomUnit(up, p, x, y, face)
endfunction
function YDWEGetLastUnitPool takes nothing returns unitpool
    return bj_lastCreatedUnitPool
endfunction
function YDWEGetLastPoolAbstractedUnit takes nothing returns unit
    return bj_lastPoolAbstractedUnit
endfunction
function YDWECreateItemPool takes nothing returns nothing
    set bj_lastCreatedItemPool=CreateItemPool()
endfunction
function YDWEPlaceRandomItem takes itempool ip,real x,real y returns nothing
set bj_lastPoolAbstractedItem=PlaceRandomItem(ip, x, y)
endfunction
function YDWEGetLastItemPool takes nothing returns itempool
    return bj_lastCreatedItemPool
endfunction
function YDWEGetLastPoolAbstractedItem takes nothing returns item
    return bj_lastPoolAbstractedItem
endfunction
function YDWESetAttackDamageWeaponType takes attacktype at,damagetype dt,weapontype wt returns nothing
    set bj_lastSetAttackType=at
    set bj_lastSetDamageType=dt
    set bj_lastSetWeaponType=wt
endfunction
//unitpool bj_lastCreatedPool=null
//unit bj_lastPoolAbstractedUnit=null
function YDWEGetPlayerColorString takes player p,string s returns string
    return YDWEBase__yd_PlayerColor[GetHandleId(GetPlayerColor(p))] + s + "|r"
endfunction
//===========================================================================
//===========================================================================
//系统函数补充
//===========================================================================
//===========================================================================
function YDWEGetUnitItemSoftId takes unit u_hero,item it returns integer
    local integer i= 0
    loop
         exitwhen i > 5
         if UnitItemInSlot(u_hero, i) == it then
            return i + 1
         endif
         set i=i + 1
    endloop
    return 0
endfunction
//===========================================================================
//===========================================================================
//地图初始化
//===========================================================================
//===========================================================================
//显示版本
function YDWEVersion_Display takes nothing returns boolean
    call DisplayTimedTextToPlayer(GetTriggerPlayer(), 0, 0, 30, "|cFF1E90FF当前编辑器版本为： |r|cFF00FF00YDWE ")
    return false
endfunction
function YDWEVersion_Init takes nothing returns nothing
    local trigger t= CreateTrigger()
    local integer i= 0
    loop
        exitwhen i == 12
        call TriggerRegisterPlayerChatEvent(t, Player(i), "YDWE Version", true)
        set i=i + 1
    endloop
    call TriggerAddCondition(t, Condition(function YDWEVersion_Display))
    set t=null
endfunction
function InitializeYD takes nothing returns nothing
     set YDHT=InitHashtable()
	//=================设置变量=====================
	set yd_MapMinX=GetCameraBoundMinX() - GetCameraMargin(CAMERA_MARGIN_LEFT)
	set yd_MapMinY=GetCameraBoundMinY() - GetCameraMargin(CAMERA_MARGIN_BOTTOM)
	set yd_MapMaxX=GetCameraBoundMaxX() + GetCameraMargin(CAMERA_MARGIN_RIGHT)
	set yd_MapMaxY=GetCameraBoundMaxY() + GetCameraMargin(CAMERA_MARGIN_TOP)
    set YDWEBase__yd_PlayerColor[0]="|cFFFF0303"
    set YDWEBase__yd_PlayerColor[1]="|cFF0042FF"
    set YDWEBase__yd_PlayerColor[2]="|cFF1CE6B9"
    set YDWEBase__yd_PlayerColor[3]="|cFF540081"
    set YDWEBase__yd_PlayerColor[4]="|cFFFFFC01"
    set YDWEBase__yd_PlayerColor[5]="|cFFFE8A0E"
    set YDWEBase__yd_PlayerColor[6]="|cFF20C000"
    set YDWEBase__yd_PlayerColor[7]="|cFFE55BB0"
    set YDWEBase__yd_PlayerColor[8]="|cFF959697"
    set YDWEBase__yd_PlayerColor[9]="|cFF7EBFF1"
    set YDWEBase__yd_PlayerColor[10]="|cFF106246"
    set YDWEBase__yd_PlayerColor[11]="|cFF4E2A04"
    set YDWEBase__yd_PlayerColor[12]="|cFF282828"
    set YDWEBase__yd_PlayerColor[13]="|cFF282828"
    set YDWEBase__yd_PlayerColor[14]="|cFF282828"
    set YDWEBase__yd_PlayerColor[15]="|cFF282828"
    //=================显示版本=====================
    call YDWEVersion_Init()
endfunction

//library YDWEBase ends
//library YDWEGetUnitsInRectMatchingNull:
function YDWEGetUnitsInRectMatchingNull takes rect r,boolexpr filter returns group
    local group g= CreateGroup()
    call GroupEnumUnitsInRect(g, r, filter)
    call DestroyBoolExpr(filter)
    set yd_NullTempGroup=g
    set g=null
    return yd_NullTempGroup
endfunction

//library YDWEGetUnitsInRectMatchingNull ends
//library YDWEJapiEffect:













 function YDWESetEffectLoc takes effect e,location loc returns nothing
		call EXSetEffectXY(e, GetLocationX(loc), GetLocationY(loc))
	endfunction

//library YDWEJapiEffect ends
//library GroupUtils:
    function GroupEnumUnitsInRangeEx takes group whichGroup,real x,real y,real radius,boolexpr filter returns nothing
        call GroupEnumUnitsInRange(whichGroup, x, y, radius, filter)
        call DestroyBoolExpr(filter)
    endfunction  //库补充,防内存泄漏
    function GroupEnumUnitsInRectEx takes group whichGroup,rect r,boolexpr filter returns nothing
        call GroupEnumUnitsInRect(whichGroup, r, filter)
        call DestroyBoolExpr(filter)
    endfunction  //获取单位组:[敌方]
        function GroupUtils__anon__0 takes nothing returns boolean
            if ( IsEnemy(GetOwningPlayer(GroupUtils__tempU) , GetFilterUnit()) ) then
                return true
            endif
            return false
        endfunction
    function GetEnemyGroup takes unit u,real x,real y,real radius returns group
        set GroupUtils__tempG=CreateGroup()
        set GroupUtils__tempU=u
        call GroupEnumUnitsInRangeEx(GroupUtils__tempG , x , y , radius , Filter(function GroupUtils__anon__0))
        set GroupUtils__tempU=null
        return GroupUtils__tempG
    endfunction  //获取圆形随机单位
    function GetRandomEnemy takes unit u,real x,real y,real radius returns unit
        return GroupPickRandomUnit(GetEnemyGroup(u , x , y , radius))
    endfunction

//library GroupUtils ends
//library Variable:

    function OnStructCreate takes integer typeid,integer stthis returns nothing
        set StType=typeid
        set StThis=stthis
        if ( TrStruct != null ) then
            call TriggerEvaluate(TrStruct)
        endif
    endfunction
        function Variable___anon__0 takes nothing returns nothing
            local integer i
            set i=1
            loop
            exitwhen ( i > 4 )
                set s__pd_name[(i)]=GetPlayerName(ConvertedPlayer(i))
            set i=i + 1
            endloop
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function Variable___anon__1 takes nothing returns nothing
            local integer index=GetConvertedPlayerId(GetTriggerPlayer())
            set USelected[index]=GetTriggerUnit()
        endfunction
    function Variable___onInit takes nothing returns nothing
        local integer i=1
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEventSingle(tr, 0.2)
        call TriggerAddCondition(tr, Condition(function Variable___anon__0))
        set tr=null
        set TrSelect=CreateTrigger()
        set i=1
        loop
        exitwhen ( i > 4 )
            call TriggerRegisterPlayerSelectionEventBJ(TrSelect, ConvertedPlayer(i), true)
        set i=i + 1
        endloop
        call TriggerAddCondition(TrSelect, Condition(function Variable___anon__1))
    endfunction

//library Variable ends
//library YDWEGetUnitsInRectAllNull:
function YDWEGetUnitsInRectAllNull takes rect r returns group
    return YDWEGetUnitsInRectMatchingNull(r , null)
endfunction

//library YDWEGetUnitsInRectAllNull ends
//library EffectUtils:
        function s__missile_isExist takes integer this returns boolean
            return ( this != null and si__missile_V[this] == - 1 )
        endfunction
        function s__missile_onDestroy takes integer this returns nothing
            call DestroyEffect(s__missile_e[this])
            call DestroyTrigger(s__missile_tr[this])
            set s__missile_e[this]=null
            set s__missile_tr[this]=null
        endfunction

//Generated destructor of missile
function s__missile_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: missile")
        return
    elseif (si__missile_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: missile")
        return
    endif
    call s__missile_onDestroy(this)
    set si__missile_V[this]=si__missile_F
    set si__missile_F=this
endfunction
        function s__missile_unreg takes integer this returns nothing
            if ( ( not ( s__missile_isExist(this) ) ) ) then
                return
            endif
            if ( s__missile_uID[this] != 0 ) then //这个其实就是将List的[2]设成5  假设2是删  5是最长
                set s__missile_List[s__missile_uID[this]]=s__missile_List[s__missile_size] //然后实例5的trID设成了2(之后再新建的话又是5了  这个基本也是独立) //但是实例[2]本身的内容已经被清除. 循环读的是List不受影响(虽然List[5]还是5但是无影响)
                set s__missile_uID[s__missile_List[s__missile_uID[this]]]=s__missile_uID[this]
                set s__missile_size=s__missile_size - 1
                set s__missile_uID[this]=0
            endif
            call s__missile_deallocate(this)
        endfunction  //func1 是结束时调用
                function s__missile_anon__1 takes nothing returns boolean
                    local integer this=s__efut_args1
                    local real angle=GetFacing(s__missile_x[this] , s__missile_y[this] , s__missile_dx[this] , s__missile_dy[this])
                    local real nx=YDWECoordinateX(s__missile_x[this] + s__missile_xySpeed[this] * CosBJ(angle))
                    local real ny=YDWECoordinateY(s__missile_y[this] + s__missile_xySpeed[this] * SinBJ(angle))
                    local real nz
                    if ( s__missile_down[this] ) then //向上运动,z速是正数
                        set nz=RMaxBJ(s__missile_dz[this], s__missile_z[this] - s__missile_zSpeed[this])
                    else
                        set nz=RMinBJ(s__missile_dz[this], s__missile_zSpeed[this] + s__missile_z[this])
                    endif
                    call EXSetEffectXY(s__missile_e[this], nx, ny)
                    call EXSetEffectZ(s__missile_e[this], nz) //到地方了
                    if ( GetDistanceZ(nx , ny , nz , s__missile_dx[this] , s__missile_dy[this] , s__missile_dz[this]) <= s__missile_speed[this] ) then
                        if ( s__missile_tr[this] != null ) then
                            set s__missile_ethis=this
                            call TriggerEvaluate(s__missile_tr[this])
                        endif
                        call s__missile_unreg(this)
                        return false //没到 存一下地点
                    else
                        set s__missile_x[this]=nx
                        set s__missile_y[this]=ny
                        set s__missile_z[this]=nz
                    endif
                    return true
                endfunction
            function s__missile_anon__0 takes nothing returns nothing
                local trigger tr
                local integer i
                local integer this
                local boolean b
                if ( s__missile_size > 0 ) then
                    set i=1
                    loop
                    exitwhen ( i > s__missile_size )
                        set tr=CreateTrigger()
                        set s__efut_args1=s__missile_List[i]
                        call TriggerAddCondition(tr, Condition(function s__missile_anon__1))
                        set b=TriggerEvaluate(tr)
                        call DestroyTrigger(tr)
                        set tr=null //代替在里面的减
                        if ( not b ) then
                            set i=i - 1
                        endif
                    set i=i + 1
                    endloop
                endif //这里就删计时器吧
                if ( s__missile_size <= 0 ) then
                    call PauseTimer(s__missile_t)
                    call DestroyTimer(s__missile_t)
                    set s__missile_t=null
                endif
            endfunction
        function s__missile_reg takes string s,real x,real y,real z,real dx,real dy,real dz,real speed,code func1 returns integer
            local real distanceXY
            local real distance
            local real distanceZ
            local integer this=s__missile__allocate()
            if ( this <= 0 ) then
                return this
            endif
            if ( s__missile_size > 8190 ) then
                return this
            endif
            if ( func1 != null ) then
                set s__missile_tr[this]=CreateTrigger()
                call TriggerAddCondition(s__missile_tr[this], Condition(func1))
            endif
            set s__missile_e[this]=AddSpecialEffect(s, x, y)
            call EXSetEffectZ(s__missile_e[this], z)
            call EXEffectMatRotateZ(s__missile_e[this], GetFacing(x , y , dx , dy))
            set s__missile_x[this]=x
            set s__missile_y[this]=y
            set s__missile_z[this]=z
            set s__missile_dx[this]=dx
            set s__missile_dy[this]=dy
            set s__missile_dz[this]=dz
            set distanceXY=GetDistance(x , y , dx , dy)
            set distanceZ=RAbsBJ(z - dz)
            set distance=GetDistanceZ(x , y , z , dx , dy , dz)
            if ( distance > 0 ) then
                set s__missile_speed[this]=speed
                set s__missile_xySpeed[this]=speed * SquareRoot(distanceXY * distanceXY / distance / distance)
                set s__missile_zSpeed[this]=speed * SquareRoot(distanceZ * distanceZ / distance / distance)
                if ( dz > z ) then
                    set s__missile_down[this]=false
                else
                    set s__missile_down[this]=true
                endif
            else
                if ( s__missile_tr[this] != null ) then
                    set s__missile_ethis=this
                    call TriggerEvaluate(s__missile_tr[this])
                endif
                call s__missile_deallocate(this)
                return 0
            endif
            if ( s__missile_uID[this] == 0 ) then
                set s__missile_size=s__missile_size + 1
                set s__missile_List[s__missile_size]=this
                set s__missile_uID[this]=s__missile_size
            endif
            if ( s__missile_t == null ) then
                set s__missile_t=CreateTimer()
                call TimerStart(s__missile_t, 0.05, true, function s__missile_anon__0)
            endif
            return this
        endfunction
        function s__umissile_isExist takes integer this returns boolean
            return ( this != null and si__umissile_V[this] == - 1 )
        endfunction
        function s__umissile_onDestroy takes integer this returns nothing
            call DestroyEffect(s__umissile_e[this])
            call DestroyTrigger(s__umissile_tr[this])
            set s__umissile_e[this]=null
            set s__umissile_tr[this]=null
            set s__umissile_u[this]=null
        endfunction

//Generated destructor of umissile
function s__umissile_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: umissile")
        return
    elseif (si__umissile_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: umissile")
        return
    endif
    call s__umissile_onDestroy(this)
    set si__umissile_V[this]=si__umissile_F
    set si__umissile_F=this
endfunction
        function s__umissile_unreg takes integer this returns nothing
            if ( ( not ( s__umissile_isExist(this) ) ) ) then
                return
            endif
            if ( s__umissile_uID[this] != 0 ) then //这个其实就是将List的[2]设成5  假设2是删  5是最长
                set s__umissile_List[s__umissile_uID[this]]=s__umissile_List[s__umissile_size] //然后实例5的trID设成了2(之后再新建的话又是5了  这个基本也是独立) //但是实例[2]本身的内容已经被清除. 循环读的是List不受影响(虽然List[5]还是5但是无影响)
                set s__umissile_uID[s__umissile_List[s__umissile_uID[this]]]=s__umissile_uID[this]
                set s__umissile_size=s__umissile_size - 1
                set s__umissile_uID[this]=0
            endif
            call s__umissile_deallocate(this)
        endfunction  //由于是跟踪型,目标
                function s__umissile_anon__3 takes nothing returns boolean
                    local integer this=s__efut_args1
                    local real tx
                    local real ty
                    local real tz
                    local real txi
                    local real tyi
                    if ( s__umissile_cd[this] > 0.98 ) then //到地方了
                        if ( s__umissile_tr[this] != null ) then
                            set s__umissile_ethis=this
                            call TriggerEvaluate(s__umissile_tr[this])
                        endif
                        call s__umissile_unreg(this)
                        return false //没到 存一下地点以防万一
                    else //活着跟踪
                        if ( IsUnitAliveBJ(s__umissile_u[this]) ) then
                            set s__umissile_nx[this]=GetUnitX(s__umissile_u[this])
                            set s__umissile_ny[this]=GetUnitY(s__umissile_u[this])
                            set s__umissile_nz[this]=GetUnitFlyHeight(s__umissile_u[this]) + 50 //没活着就
                        endif
                        set s__umissile_cd[this]=s__umissile_cd[this] + 0.02
                        set tx=Pow(( 1 - s__umissile_cd[this] ), 2) * s__umissile_ux[this] + 2 * s__umissile_cd[this] * ( 1 - s__umissile_cd[this] ) * s__umissile_ex[this] + Pow(s__umissile_cd[this], 2) * s__umissile_nx[this]
                        set ty=Pow(( 1 - s__umissile_cd[this] ), 2) * s__umissile_uy[this] + 2 * s__umissile_cd[this] * ( 1 - s__umissile_cd[this] ) * s__umissile_ey[this] + Pow(s__umissile_cd[this], 2) * s__umissile_ny[this]
                        set tz=Pow(( 1 - s__umissile_cd[this] ), 2) * s__umissile_uz[this] + 2 * s__umissile_cd[this] * ( 1 - s__umissile_cd[this] ) * s__umissile_ez[this] + Pow(s__umissile_cd[this], 2) * s__umissile_nz[this]
                        call EXSetEffectZ(s__umissile_e[this], tz)
                        call EXSetEffectXY(s__umissile_e[this], tx, ty)
                        call EXEffectMatReset(s__umissile_e[this])
                        set txi=Pow(( 1 - ( s__umissile_cd[this] + 0.02 ) ), 2) * s__umissile_ux[this] + 2 * ( s__umissile_cd[this] + 0.02 ) * ( 1 - ( s__umissile_cd[this] + 0.02 ) ) * s__umissile_ex[this] + Pow(( s__umissile_cd[this] + 0.02 ), 2) * s__umissile_nx[this]
                        set tyi=Pow(( 1 - ( s__umissile_cd[this] + 0.02 ) ), 2) * s__umissile_uy[this] + 2 * ( s__umissile_cd[this] + 0.02 ) * ( 1 - ( s__umissile_cd[this] + 0.02 ) ) * s__umissile_ey[this] + Pow(( s__umissile_cd[this] + 0.02 ), 2) * s__umissile_ny[this]
                        call EXEffectMatRotateZ(s__umissile_e[this], GetFacing(tx , ty , txi , tyi))
                    endif
                    return true
                endfunction
            function s__umissile_anon__2 takes nothing returns nothing
                local trigger tr
                local integer i
                local integer this
                local boolean b
                if ( s__umissile_size > 0 ) then
                    set i=1
                    loop
                    exitwhen ( i > s__umissile_size )
                        set tr=CreateTrigger()
                        set s__efut_args1=s__umissile_List[i]
                        call TriggerAddCondition(tr, Condition(function s__umissile_anon__3))
                        set b=TriggerEvaluate(tr)
                        call DestroyTrigger(tr)
                        set tr=null //代替在里面的减
                        if ( not b ) then
                            set i=i - 1
                        endif
                    set i=i + 1
                    endloop
                endif //这里就删计时器吧
                if ( s__umissile_size <= 0 ) then
                    call PauseTimer(s__umissile_t)
                    call DestroyTimer(s__umissile_t)
                    set s__umissile_t=null
                endif
            endfunction
        function s__umissile_reg takes string s,real x,real y,real z,unit target,code func1 returns integer
            local real angle
            local real angle2
            local real x1
            local real y1
            local integer random
            local integer this=s__umissile__allocate()
            if ( this <= 0 ) then
                return this
            endif
            if ( s__umissile_size > 8190 ) then
                return this
            endif
            if ( func1 != null ) then
                set s__umissile_tr[this]=CreateTrigger()
                call TriggerAddCondition(s__umissile_tr[this], Condition(func1))
            endif
            set angle=GetFacing(x , y , GetUnitX(target) , GetUnitY(target))
            set s__umissile_ux[this]=YDWECoordinateX(x - 60 * CosBJ(angle))
            set s__umissile_uy[this]=YDWECoordinateY(y - 60 * SinBJ(angle))
            set s__umissile_uz[this]=z + 80
            set x1=YDWECoordinateX(x - 1 * CosBJ(angle))
            set y1=YDWECoordinateY(y - 1 * SinBJ(angle))
            set angle2=GetFacing(x , y , x1 , y1)
            set random=GetRandomInt(1, 10)
            set s__umissile_ex[this]=CosBJ(90 - ( 18 * random + angle2 )) * 1000 + x1
            set s__umissile_ey[this]=SinBJ(90 - ( 18 * random + angle2 )) * 1000 + y1
            set s__umissile_ez[this]=600
            set s__umissile_e[this]=AddSpecialEffect(s, s__umissile_ux[this], s__umissile_uy[this])
            set s__umissile_u[this]=target
            set s__umissile_cd[this]=0.
            set s__umissile_nx[this]=GetUnitX(target)
            set s__umissile_ny[this]=GetUnitY(target)
            set s__umissile_nz[this]=GetUnitFlyHeight(target) + 50
            call EXSetEffectZ(s__umissile_e[this], s__umissile_uz[this])
            if ( s__umissile_uID[this] == 0 ) then
                set s__umissile_size=s__umissile_size + 1
                set s__umissile_List[s__umissile_size]=this
                set s__umissile_uID[this]=s__umissile_size
            endif
            if ( s__umissile_t == null ) then
                set s__umissile_t=CreateTimer()
                call TimerStart(s__umissile_t, 0.03, true, function s__umissile_anon__2)
            endif
            return this
        endfunction
        function s__pierce_isExist takes integer this returns boolean
            return ( this != null and si__pierce_V[this] == - 1 )
        endfunction
        function s__pierce_onDestroy takes integer this returns nothing
            call DestroyEffect(s__pierce_e[this])
            call DestroyTrigger(s__pierce_trU[this])
            call DestroyTrigger(s__pierce_trEnd[this])
            call DestroyGroup(s__pierce_g[this])
            set s__pierce_e[this]=null
            set s__pierce_trU[this]=null
            set s__pierce_trEnd[this]=null
            set s__pierce_g[this]=null
        endfunction

//Generated destructor of pierce
function s__pierce_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: pierce")
        return
    elseif (si__pierce_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: pierce")
        return
    endif
    call s__pierce_onDestroy(this)
    set si__pierce_V[this]=si__pierce_F
    set si__pierce_F=this
endfunction
        function s__pierce_unreg takes integer this returns nothing
            if ( ( not ( s__pierce_isExist(this) ) ) ) then
                return
            endif
            if ( s__pierce_uID[this] != 0 ) then //这个其实就是将List的[2]设成5  假设2是删  5是最长
                set s__pierce_List[s__pierce_uID[this]]=s__pierce_List[s__pierce_size] //然后实例5的trID设成了2(之后再新建的话又是5了  这个基本也是独立) //但是实例[2]本身的内容已经被清除. 循环读的是List不受影响(虽然List[5]还是5但是无影响)
                set s__pierce_uID[s__pierce_List[s__pierce_uID[this]]]=s__pierce_uID[this]
                set s__pierce_size=s__pierce_size - 1
                set s__pierce_uID[this]=0
            endif
            call s__pierce_deallocate(this)
        endfunction  //func1 是结束时调用
                    function s__pierce_anon__6 takes nothing returns boolean
                        local integer this=s__efut_args1
                        if ( not ( IsUnitInGroup(GetFilterUnit(), s__pierce_g[this]) ) ) then
                            call GroupAddUnit(s__pierce_g[this], GetFilterUnit())
                            return true
                        endif
                        return false
                    endfunction  //针对每个穿刺到的单位进行操作,也自动归进单位组了
                function s__pierce_anon__5 takes nothing returns boolean
                    local integer this=s__efut_args1
                    local real angle=GetFacing(s__pierce_x[this] , s__pierce_y[this] , s__pierce_dx[this] , s__pierce_dy[this])
                    local real nx=YDWECoordinateX(s__pierce_x[this] + s__pierce_speed[this] * CosBJ(angle))
                    local real ny=YDWECoordinateY(s__pierce_y[this] + s__pierce_speed[this] * SinBJ(angle))
                    call EXSetEffectXY(s__pierce_e[this], nx, ny)
                    set s__efut_g=CreateGroup()
                    set s__efut_args1=this
                    call GroupEnumUnitsInRangeEx(s__efut_g , nx , ny , s__pierce_radius[this] , Filter(function s__pierce_anon__6))
                    if ( s__pierce_trU[this] != null ) then
                        set s__pierce_ethis=this //Frame也写到这里吧 帧事件
                        call TriggerEvaluate(s__pierce_trU[this])
                    endif
                    call DestroyGroup(s__efut_g)
                    set s__efut_g=null //到地方了
                    if ( GetDistance(nx , ny , s__pierce_dx[this] , s__pierce_dy[this]) <= s__pierce_speed[this] ) then
                        if ( s__pierce_trEnd[this] != null ) then
                            set s__pierce_ethis=this
                            call TriggerEvaluate(s__pierce_trEnd[this])
                        endif
                        call s__pierce_unreg(this)
                        return false //没到 存一下地点
                    else
                        set s__pierce_x[this]=nx
                        set s__pierce_y[this]=ny
                    endif
                    return true
                endfunction
            function s__pierce_anon__4 takes nothing returns nothing
                local trigger tr
                local integer i
                local integer this
                local boolean b
                if ( s__pierce_size > 0 ) then
                    set i=1
                    loop
                    exitwhen ( i > s__pierce_size )
                        set tr=CreateTrigger()
                        set s__efut_args1=s__pierce_List[i]
                        call TriggerAddCondition(tr, Condition(function s__pierce_anon__5))
                        set b=TriggerEvaluate(tr)
                        call DestroyTrigger(tr)
                        set tr=null //代替在里面的减
                        if ( not b ) then
                            set i=i - 1
                        endif
                    set i=i + 1
                    endloop
                endif //这里就删计时器吧
                if ( s__pierce_size <= 0 ) then
                    call PauseTimer(s__pierce_t)
                    call DestroyTimer(s__pierce_t)
                    set s__pierce_t=null
                endif
            endfunction
        function s__pierce_reg takes string s,real x,real y,real dx,real dy,real speed,real radius,code funU,code funEnd returns integer
            local integer this=s__pierce__allocate()
            if ( this <= 0 ) then
                return this
            endif
            if ( s__pierce_size > 8190 ) then
                return this
            endif
            if ( funU != null ) then
                set s__pierce_trU[this]=CreateTrigger()
                call TriggerAddCondition(s__pierce_trU[this], Condition(funU))
            endif
            if ( funEnd != null ) then
                set s__pierce_trEnd[this]=CreateTrigger()
                call TriggerAddCondition(s__pierce_trEnd[this], Condition(funEnd))
            endif
            set s__pierce_e[this]=AddSpecialEffect(s, x, y)
            call EXEffectMatRotateZ(s__pierce_e[this], GetFacing(x , y , dx , dy))
            set s__pierce_x[this]=x
            set s__pierce_y[this]=y
            set s__pierce_dx[this]=dx
            set s__pierce_dy[this]=dy
            set s__pierce_speed[this]=speed
            set s__pierce_radius[this]=radius
            set s__pierce_g[this]=CreateGroup()
            if ( s__pierce_uID[this] == 0 ) then
                set s__pierce_size=s__pierce_size + 1
                set s__pierce_List[s__pierce_size]=this
                set s__pierce_uID[this]=s__pierce_size
            endif
            if ( s__pierce_t == null ) then
                set s__pierce_t=CreateTimer()
                call TimerStart(s__pierce_t, 0.05, true, function s__pierce_anon__4)
            endif
            return this
        endfunction

//library EffectUtils ends
//library UTEffectUtils:

    function UTEffectUtils___TTestUTEffectUtils1 takes player p returns nothing
        call MemoryLeakShow()
        call StructShow()
        call GetLocalizedHotkey("yd_leak_monitor::create_report")
        call DumpAllString("PO_stringTT.txt")
    endfunction  //blp
        function UTEffectUtils___anon__0 takes nothing returns nothing
            call BJDebugMsg("到达地点咯!")
        endfunction
    function UTEffectUtils___TTestUTEffectUtils2 takes player p returns nothing
        local integer ms
        local integer i
        set i=1
        loop
        exitwhen ( i > 10 )
            set ms=s__missile_reg("units\\human\\phoenix\\phoenix.mdl" , GetRandomReal(- 2000, 2000) , GetRandomReal(- 2000, 2000) , 0 , GetRandomReal(- 2000, 2000) , GetRandomReal(- 2000, 2000) , 0 , GetRandomReal(30, 100) , function UTEffectUtils___anon__0)
        set i=i + 1
        endloop
    endfunction  //測試一下向上飞的直线弹幕
        function UTEffectUtils___anon__1 takes nothing returns nothing
            call BJDebugMsg("飞天咯!")
        endfunction
    function UTEffectUtils___TTestUTEffectUtils3 takes player p returns nothing
        local integer ms
        local integer i
        local real x
        local real y
        set i=1
        loop
        exitwhen ( i > 10 )
            set x=GetRandomReal(- 1000, 2000)
            set y=GetRandomReal(- 1000, 2000)
            set ms=s__missile_reg("units\\human\\phoenix\\phoenix.mdl" , x , y , 0 , x , y , GetRandomReal(2000, 3000) , GetRandomReal(30, 100) , function UTEffectUtils___anon__1)
            call EXEffectMatRotateY(s__missile_e[ms], 270) // EXEffectMatRotateY(ms.e,90);
        set i=i + 1
        endloop
    endfunction  //測試一下向下飞的直线弹幕
        function UTEffectUtils___anon__2 takes nothing returns nothing
            call BJDebugMsg("落地咯!")
        endfunction
    function UTEffectUtils___TTestUTEffectUtils4 takes player p returns nothing
        local integer ms
        local integer i
        local real x
        local real y
        set i=1
        loop
        exitwhen ( i > 10 )
            set x=GetRandomReal(- 1000, 2000)
            set y=GetRandomReal(- 1000, 2000)
            set ms=s__missile_reg("units\\human\\phoenix\\phoenix.mdl" , x , y , GetRandomReal(2000, 3000) , x , y , 0 , GetRandomReal(30, 100) , function UTEffectUtils___anon__2)
            call EXEffectMatRotateY(s__missile_e[ms], 90)
        set i=i + 1
        endloop
    endfunction
        function UTEffectUtils___anon__3 takes nothing returns nothing
            local timer t=GetExpiredTimer()
            local integer id=GetHandleId(t)
            local integer i=LoadInteger(TITable, id, 1)
            if ( i <= 360 ) then
                call EXEffectMatRotateX(UTEffectUtils___ef, 1.0)
                set i=i + 1
                call SaveInteger(TITable, id, 1, i)
            else
                call PauseTimer(t)
                call FlushChildHashtable(TITable, id)
                call DestroyTimer(t)
            endif
            set t=null
        endfunction
    function UTEffectUtils___TTestUTEffectUtils5 takes player p returns nothing
        local timer t
        if ( UTEffectUtils___ef == null ) then
            set UTEffectUtils___ef=AddSpecialEffect("units\\human\\phoenix\\phoenix.mdl", 0, 0)
            call EXSetEffectZ(UTEffectUtils___ef, 100)
            call EXEffectMatScale(UTEffectUtils___ef, 2.0, 2.0, 2.0)
        endif
        set t=CreateTimer()
        call SaveInteger(TITable, GetHandleId(t), 1, 1)
        call TimerStart(t, 0.02, true, function UTEffectUtils___anon__3)
        set t=null
    endfunction  //研究一下特效Y轴旋转
        function UTEffectUtils___anon__4 takes nothing returns nothing
            local timer t=GetExpiredTimer()
            local integer id=GetHandleId(t)
            local integer i=LoadInteger(TITable, id, 1)
            if ( i <= 360 ) then
                call EXEffectMatRotateY(UTEffectUtils___ef, 1.0)
                set i=i + 1
                call SaveInteger(TITable, id, 1, i)
            else
                call PauseTimer(t)
                call FlushChildHashtable(TITable, id)
                call DestroyTimer(t)
            endif
            set t=null
        endfunction
    function UTEffectUtils___TTestUTEffectUtils6 takes player p returns nothing
        local timer t
        if ( UTEffectUtils___ef == null ) then
            set UTEffectUtils___ef=AddSpecialEffect("units\\human\\phoenix\\phoenix.mdl", 0, 0)
            call EXSetEffectZ(UTEffectUtils___ef, 100)
            call EXEffectMatScale(UTEffectUtils___ef, 2.0, 2.0, 2.0)
        endif
        set t=CreateTimer()
        call SaveInteger(TITable, GetHandleId(t), 1, 1)
        call TimerStart(t, 0.02, true, function UTEffectUtils___anon__4)
        set t=null
    endfunction  //研究一下特效Z轴旋转:就是普通的
        function UTEffectUtils___anon__5 takes nothing returns nothing
            local timer t=GetExpiredTimer()
            local integer id=GetHandleId(t)
            local integer i=LoadInteger(TITable, id, 1)
            if ( i <= 360 ) then
                call EXEffectMatRotateZ(UTEffectUtils___ef, 1.0)
                set i=i + 1
                call SaveInteger(TITable, id, 1, i)
            else
                call PauseTimer(t)
                call FlushChildHashtable(TITable, id)
                call DestroyTimer(t)
            endif
            set t=null
        endfunction
    function UTEffectUtils___TTestUTEffectUtils7 takes player p returns nothing
        local timer t
        if ( UTEffectUtils___ef == null ) then
            set UTEffectUtils___ef=AddSpecialEffect("units\\human\\phoenix\\phoenix.mdl", 0, 0)
            call EXSetEffectZ(UTEffectUtils___ef, 100)
            call EXEffectMatScale(UTEffectUtils___ef, 2.0, 2.0, 2.0)
        endif
        set t=CreateTimer()
        call SaveInteger(TITable, GetHandleId(t), 1, 1)
        call TimerStart(t, 0.02, true, function UTEffectUtils___anon__5)
        set t=null
    endfunction
        function UTEffectUtils___anon__6 takes nothing returns nothing
            if ( GetIssuedOrderId() == String2OrderIdBJ("smart") ) then
                call DzSetUnitPosition(GetTriggerUnit(), GetOrderPointX(), GetOrderPointY())
            endif
        endfunction
            function UTEffectUtils___anon__8 takes nothing returns nothing
                local timer t2=GetExpiredTimer()
                local integer id=GetHandleId(t2)
                local real cd=LoadReal(TITable, id, 1)
                local real ux=LoadReal(TITable, id, 2)
                local real uy=LoadReal(TITable, id, 3)
                local real uz=LoadReal(TITable, id, 4)
                local real ex=LoadReal(TITable, id, 5)
                local real ey=LoadReal(TITable, id, 6)
                local real ez=LoadReal(TITable, id, 7)
                local effect e=LoadEffectHandle(TITable, id, 8)
                local real nx
                local real ny
                local real nz
                local real tx
                local real ty
                local real tz
                local real txi
                local real tyi
                if ( cd <= 0.98 ) then
                    set nx=GetUnitX(UTEffectUtils___u2)
                    set ny=GetUnitY(UTEffectUtils___u2)
                    set nz=GetUnitFlyHeight(UTEffectUtils___u2) + 50
                    set cd=cd + 0.02
                    set tx=Pow(( 1 - cd ), 2) * ux + 2 * cd * ( 1 - cd ) * ex + Pow(cd, 2) * nx
                    set ty=Pow(( 1 - cd ), 2) * uy + 2 * cd * ( 1 - cd ) * ey + Pow(cd, 2) * ny
                    set tz=Pow(( 1 - cd ), 2) * uz + 2 * cd * ( 1 - cd ) * ez + Pow(cd, 2) * nz
                    call EXSetEffectZ(e, tz)
                    call EXSetEffectXY(e, tx, ty)
                    call EXEffectMatReset(e)
                    set txi=Pow(( 1 - ( cd + 0.02 ) ), 2) * ux + 2 * ( cd + 0.02 ) * ( 1 - ( cd + 0.02 ) ) * ex + Pow(( cd + 0.02 ), 2) * nx
                    set tyi=Pow(( 1 - ( cd + 0.02 ) ), 2) * uy + 2 * ( cd + 0.02 ) * ( 1 - ( cd + 0.02 ) ) * ey + Pow(( cd + 0.02 ), 2) * ny
                    call EXEffectMatRotateZ(e, GetFacing(tx , ty , txi , tyi))
                    call SaveReal(TITable, id, 1, cd)
                else
                    call DestroyEffect(e)
                    call PauseTimer(t2)
                    call FlushChildHashtable(TITable, id)
                    call DestroyTimer(t2)
                endif
                set t2=null
                set e=null
            endfunction
        function UTEffectUtils___anon__7 takes nothing returns nothing
            local timer t2
            local timer t=GetExpiredTimer()
            local integer id=GetHandleId(t)
            local integer i=LoadInteger(TITable, id, 1)
            local real angle=GetFacing(GetUnitX(UTEffectUtils___u1) , GetUnitY(UTEffectUtils___u1) , GetUnitX(UTEffectUtils___u2) , GetUnitY(UTEffectUtils___u2))
            local real ux=GetUnitX(UTEffectUtils___u1) - 60 * CosBJ(angle)
            local real uy=GetUnitY(UTEffectUtils___u1) - 60 * SinBJ(angle)
            local real uz=GetUnitFlyHeight(UTEffectUtils___u1) + 80
            local real x1=GetUnitX(UTEffectUtils___u1) - 1 * CosBJ(angle)
            local real y1=GetUnitY(UTEffectUtils___u1) - 1 * SinBJ(angle)
            local real angle2=GetFacing(GetUnitX(UTEffectUtils___u1) , GetUnitY(UTEffectUtils___u1) , x1 , y1)
            local integer random=GetRandomInt(1, 10)
            local real ex=CosBJ(90 - ( 18 * random + angle2 )) * 1000 + x1
            local real ey=SinBJ(90 - ( 18 * random + angle2 )) * 1000 + y1
            local real ez=600
            local effect e=AddSpecialEffect("Abilities\\Weapons\\PoisonArrow\\PoisonArrowMissile.mdl", ux, uy)
            call EXSetEffectZ(e, uz)
            if ( i <= 100 ) then
                set t2=CreateTimer()
                call SaveReal(TITable, GetHandleId(t2), 1, 0.0)
                call SaveReal(TITable, GetHandleId(t2), 2, ux)
                call SaveReal(TITable, GetHandleId(t2), 3, uy)
                call SaveReal(TITable, GetHandleId(t2), 4, uz)
                call SaveReal(TITable, GetHandleId(t2), 5, ex)
                call SaveReal(TITable, GetHandleId(t2), 6, ey)
                call SaveReal(TITable, GetHandleId(t2), 7, ez)
                call SaveEffectHandle(TITable, GetHandleId(t2), 8, e)
                call TimerStart(t2, 0.03, true, function UTEffectUtils___anon__8)
                set t2=null
                set i=i + 1
                call SaveInteger(TITable, id, 1, i)
            else
                call DestroyEffect(e)
                call PauseTimer(t)
                call FlushChildHashtable(TITable, id)
                call DestroyTimer(t)
            endif
            set t=null
            set e=null
        endfunction
    function UTEffectUtils___TTestUTEffectUtils8 takes player p returns nothing
        local timer t
        if ( UTEffectUtils___trSY == null ) then
            set UTEffectUtils___trSY=CreateTrigger()
            call TriggerAddCondition(UTEffectUtils___trSY, Condition(function UTEffectUtils___anon__6))
        endif
        if ( UTEffectUtils___u1 == null ) then
            set UTEffectUtils___u1=CreateUnit(p, 'Hpal', 0, 0, 0)
            call TriggerRegisterUnitEvent(UTEffectUtils___trSY, UTEffectUtils___u1, EVENT_UNIT_ISSUED_POINT_ORDER)
        endif
        if ( UTEffectUtils___u2 == null ) then
            set UTEffectUtils___u2=CreateUnit(p, 'Ewar', 1000, 1000, 0)
            call TriggerRegisterUnitEvent(UTEffectUtils___trSY, UTEffectUtils___u2, EVENT_UNIT_ISSUED_POINT_ORDER)
        endif
        set t=CreateTimer()
        call SaveInteger(TITable, GetHandleId(t), 1, 1)
        call TimerStart(t, 0.1, true, function UTEffectUtils___anon__7)
        set t=null
    endfunction  //测试一下umissile
        function UTEffectUtils___anon__9 takes nothing returns nothing
            if ( GetIssuedOrderId() == String2OrderIdBJ("smart") ) then
                call DzSetUnitPosition(GetTriggerUnit(), GetOrderPointX(), GetOrderPointY())
            endif
        endfunction
            function UTEffectUtils___anon__11 takes nothing returns nothing
                call BJDebugMsg("击中了哦.")
            endfunction
        function UTEffectUtils___anon__10 takes nothing returns nothing
            local timer t=GetExpiredTimer()
            local integer id=GetHandleId(t)
            local integer i=LoadInteger(TITable, id, 1)
            if ( i <= 100 ) then
                call s__umissile_reg("Abilities\\Weapons\\PoisonArrow\\PoisonArrowMissile.mdl" , GetUnitX(UTEffectUtils___u1) , GetUnitY(UTEffectUtils___u1) , GetUnitFlyHeight(UTEffectUtils___u1) , UTEffectUtils___u2 , function UTEffectUtils___anon__11)
                set i=i + 1
                call SaveInteger(TITable, id, 1, i)
            else
                call PauseTimer(t)
                call FlushChildHashtable(TITable, id)
                call DestroyTimer(t)
            endif
            set t=null
        endfunction
    function UTEffectUtils___TTestUTEffectUtils9 takes player p returns nothing
        local timer t
        if ( UTEffectUtils___trSY == null ) then
            set UTEffectUtils___trSY=CreateTrigger()
            call TriggerAddCondition(UTEffectUtils___trSY, Condition(function UTEffectUtils___anon__9))
        endif
        if ( UTEffectUtils___u1 == null ) then
            set UTEffectUtils___u1=CreateUnit(p, 'Hpal', 0, 0, 0)
            call TriggerRegisterUnitEvent(UTEffectUtils___trSY, UTEffectUtils___u1, EVENT_UNIT_ISSUED_POINT_ORDER)
        endif
        if ( UTEffectUtils___u2 == null ) then
            set UTEffectUtils___u2=CreateUnit(p, 'Ewar', 1000, 1000, 0)
            call TriggerRegisterUnitEvent(UTEffectUtils___trSY, UTEffectUtils___u2, EVENT_UNIT_ISSUED_POINT_ORDER)
        endif
        set t=CreateTimer()
        call SaveInteger(TITable, GetHandleId(t), 1, 1)
        call TimerStart(t, 0.1, true, function UTEffectUtils___anon__10)
        set t=null
    endfunction
        function UTEffectUtils___anon__12 takes nothing returns nothing
            if ( GetUnitTypeId(GetEnumUnit()) == 'nmam' ) then
                call RemoveUnit(GetEnumUnit())
            endif
        endfunction  // for (1 <= i <= 10) {
            function UTEffectUtils___anon__14 takes nothing returns nothing
                local integer pe=s__pierce_ethis
                local integer index=1
                if ( IsEnemyIncludeInvul(Player(0) , GetEnumUnit()) ) then
                    call BJDebugMsg(s__pd_name[(index)] + "的敌人:" + GetUnitName(GetEnumUnit()))
                    call KillUnit(GetEnumUnit())
                elseif ( IsAlly(Player(0) , GetEnumUnit()) ) then
                    call BJDebugMsg(s__pd_name[(index)] + "的队友:" + GetUnitName(GetEnumUnit()))
                    call SetUnitState(GetEnumUnit(), UNIT_STATE_LIFE, 100)
                else
                    call BJDebugMsg("已经死亡的:" + GetUnitName(GetEnumUnit()))
                endif
            endfunction
        function UTEffectUtils___anon__13 takes nothing returns nothing
            local integer pe=s__pierce_ethis
            if ( CountUnitsInGroup(s__efut_g) > 0 ) then
                call ForGroup(s__efut_g, function UTEffectUtils___anon__14)
            endif
            set UTEffectUtils___fra[pe]=ModuloInteger(UTEffectUtils___fra[pe], 3) + 1
            if ( ModuloInteger(UTEffectUtils___fra[pe], 3) == 0 ) then
                call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl", s__pierce_x[pe], s__pierce_y[pe]))
            endif
        endfunction  //结束事件
        function UTEffectUtils___anon__15 takes nothing returns nothing
            local integer pe=s__pierce_ethis
            call BJDebugMsg("结束啦!!")
        endfunction  // pe.h = MH[index];
    function UTEffectUtils___TTestUTEffectUtils10 takes player p returns nothing
        local integer pe
        local integer i
        local integer index=GetConvertedPlayerId(p)
        call ForGroup(YDWEGetUnitsInRectAllNull(GetPlayableMapRect()), function UTEffectUtils___anon__12)
        set pe=s__pierce_reg("Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl" , GetRandomReal(- 2000, - 1000) , GetRandomReal(- 2000, - 1000) , GetRandomReal(1000, 2000) , GetRandomReal(1000, 2000) , 100 , 450 , function UTEffectUtils___anon__13 , function UTEffectUtils___anon__15)
        set UTEffectUtils___fra[pe]=0
        call EXEffectMatScale(s__pierce_e[pe], 3.0, 3.0, 3.0)
        call EXSetEffectZ(s__pierce_e[pe], 200) // }
        set i=1 //创建几个单位
        loop
        exitwhen ( i > 20 )
            call CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'nmam', GetRandomReal(- 200, 200), GetRandomReal(- 200, 200), 0)
            call CreateUnit(Player(0), 'nmam', GetRandomReal(- 200, 200), GetRandomReal(- 200, 200), 0)
        set i=i + 1
        endloop
    endfunction
                function UTEffectUtils___anon__18 takes nothing returns nothing
                    local integer pe=s__pierce_ethis
                    call BJDebugMsg("单位名字:" + GetUnitName(GetEnumUnit()))
                endfunction
            function UTEffectUtils___anon__17 takes nothing returns nothing
                local integer pe=s__pierce_ethis
                if ( CountUnitsInGroup(s__efut_g) > 0 ) then
                    call ForGroup(s__efut_g, function UTEffectUtils___anon__18)
                endif
            endfunction  //结束事件
            function UTEffectUtils___anon__19 takes nothing returns nothing
                local integer pe=s__pierce_ethis
                call BJDebugMsg("光波(" + I2S(pe) + ")结束啦:" + R2S(s__pierce_x[pe]) + "," + R2S(s__pierce_y[pe]))
            endfunction
        function UTEffectUtils___anon__16 takes nothing returns nothing
            local timer t=GetExpiredTimer()
            local integer id=GetHandleId(t)
            local integer i=LoadInteger(TITable, id, 1)
            local integer pe
            if ( i <= 720 ) then
                call s__radiationEnd_cal(UTEffectUtils___xLi , UTEffectUtils___yLi , i * 0.5)
                set pe=s__pierce_reg("Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl" , UTEffectUtils___xLi , UTEffectUtils___yLi , YDWECoordinateX(s__radiationEnd_x) , YDWECoordinateY(s__radiationEnd_y) , 100 , 450 , function UTEffectUtils___anon__17 , function UTEffectUtils___anon__19)
                set i=i + 1
                call SaveInteger(TITable, id, 1, i)
            else
                call PauseTimer(t)
                call FlushChildHashtable(TITable, id)
                call DestroyTimer(t)
            endif
            set t=null
        endfunction
    function UTEffectUtils___TTestUTEffectUtils11 takes player p returns nothing
        local timer t
        set t=CreateTimer()
        call SaveInteger(TITable, GetHandleId(t), 1, 1)
        call TimerStart(t, 0.05, true, function UTEffectUtils___anon__16)
        set t=null
    endfunction
    function UTEffectUtils___TTestUTEffectUtils12 takes player p returns nothing
    endfunction
    function UTEffectUtils___TTestUTEffectUtils13 takes player p returns nothing
    endfunction
    function UTEffectUtils___TTestUTEffectUtils14 takes player p returns nothing
    endfunction
    function UTEffectUtils___TTestUTEffectUtils15 takes player p returns nothing
    endfunction
    function UTEffectUtils___TTestUTEffectUtils16 takes player p returns nothing
    endfunction
    function UTEffectUtils___TTestUTEffectUtils17 takes player p returns nothing
    endfunction
    function UTEffectUtils___TTestUTEffectUtils18 takes player p returns nothing
    endfunction
    function UTEffectUtils___TTestUTEffectUtils19 takes player p returns nothing
    endfunction
    function UTEffectUtils___TTestUTEffectUtils20 takes player p returns nothing
    endfunction
    function UTEffectUtils___TTestActUTEffectUtils1 takes string str returns nothing
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
        set num=num + 1 //测试一下混合的特效
        if ( paramS[0] == "x" ) then
            call EXEffectMatRotateX(UTEffectUtils___ef, paramR[1])
        elseif ( paramS[0] == "y" ) then
            call EXEffectMatRotateY(UTEffectUtils___ef, paramR[1])
        elseif ( paramS[0] == "z" ) then
            call EXEffectMatRotateZ(UTEffectUtils___ef, paramR[1]) //高度
        elseif ( paramS[0] == "height" ) then
            call EXSetEffectZ(UTEffectUtils___ef, paramR[1]) //恢复
        elseif ( paramS[0] == "reset" ) then
            call EXEffectMatReset(UTEffectUtils___ef)
            call EXEffectMatScale(UTEffectUtils___ef, 2.0, 2.0, 2.0) //设置一下s11的初始位置
        elseif ( paramS[0] == "xl" ) then
            set UTEffectUtils___xLi=paramR[1]
            call BJDebugMsg("xLi" + ":" + R2S(UTEffectUtils___xLi)) //设置一下s11的初始位置
        elseif ( paramS[0] == "yl" ) then
            set UTEffectUtils___yLi=paramR[1]
            call BJDebugMsg("yLi" + ":" + R2S(UTEffectUtils___yLi))
        endif
        set p=null
    endfunction  //blpend
        function UTEffectUtils___anon__20 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            local integer i=1
            if ( SubStringBJ(str, 1, 1) == "-" ) then
                call UTEffectUtils___TTestActUTEffectUtils1(SubStringBJ(str, 2, StringLength(str)))
                return
            endif
            if ( str == "s1" ) then
                call UTEffectUtils___TTestUTEffectUtils1(GetTriggerPlayer())
            elseif ( str == "s2" ) then
                call UTEffectUtils___TTestUTEffectUtils2(GetTriggerPlayer())
            elseif ( str == "s3" ) then
                call UTEffectUtils___TTestUTEffectUtils3(GetTriggerPlayer())
            elseif ( str == "s4" ) then
                call UTEffectUtils___TTestUTEffectUtils4(GetTriggerPlayer())
            elseif ( str == "s5" ) then
                call UTEffectUtils___TTestUTEffectUtils5(GetTriggerPlayer())
            elseif ( str == "s6" ) then
                call UTEffectUtils___TTestUTEffectUtils6(GetTriggerPlayer())
            elseif ( str == "s7" ) then
                call UTEffectUtils___TTestUTEffectUtils7(GetTriggerPlayer())
            elseif ( str == "s8" ) then
                call UTEffectUtils___TTestUTEffectUtils8(GetTriggerPlayer())
            elseif ( str == "s9" ) then
                call UTEffectUtils___TTestUTEffectUtils9(GetTriggerPlayer())
            elseif ( str == "s10" ) then
                call UTEffectUtils___TTestUTEffectUtils10(GetTriggerPlayer())
            elseif ( str == "s11" ) then
                call UTEffectUtils___TTestUTEffectUtils11(GetTriggerPlayer())
            elseif ( str == "s12" ) then
                call UTEffectUtils___TTestUTEffectUtils12(GetTriggerPlayer())
            elseif ( str == "s13" ) then
                call UTEffectUtils___TTestUTEffectUtils13(GetTriggerPlayer())
            elseif ( str == "s14" ) then
                call UTEffectUtils___TTestUTEffectUtils14(GetTriggerPlayer())
            elseif ( str == "s15" ) then
                call UTEffectUtils___TTestUTEffectUtils15(GetTriggerPlayer())
            elseif ( str == "s16" ) then
                call UTEffectUtils___TTestUTEffectUtils16(GetTriggerPlayer())
            elseif ( str == "s17" ) then
                call UTEffectUtils___TTestUTEffectUtils17(GetTriggerPlayer())
            elseif ( str == "s18" ) then
                call UTEffectUtils___TTestUTEffectUtils18(GetTriggerPlayer())
            elseif ( str == "s19" ) then
                call UTEffectUtils___TTestUTEffectUtils19(GetTriggerPlayer())
            elseif ( str == "s20" ) then
                call UTEffectUtils___TTestUTEffectUtils20(GetTriggerPlayer())
            endif
        endfunction
    function UTEffectUtils___onInit takes nothing returns nothing
        local integer i
        set i=1
        loop
        exitwhen ( i > 16 )
            call CreateFogModifierRectBJ(true, ConvertedPlayer(i), FOG_OF_WAR_VISIBLE, GetPlayableMapRect())
        set i=i + 1
        endloop
        call UnitTestRegisterChatEvent(function UTEffectUtils___anon__20)
    endfunction

//library UTEffectUtils ends
// API文档: https://japi.war3rpg.top/

//魔兽版本 用GetGameVersion 来获取当前版本 来对比以下具体版本做出相应操作
//-----------模拟聊天------------------
//---------技能数据类型---------------
//冷却时间
//目标允许
//施放时间
//持续时间
//持续时间
//魔法消耗
//施放间隔
//影响区域
//施法距离
//数据A
//数据B
//数据C
//数据D
//数据E
//数据F
//数据G
//数据H
//数据I
//单位类型
//热键
//关闭热键
//学习热键
//名字
//图标
//目标效果
//施法者效果
//目标点效果
//区域效果
//投射物
//特殊效果
//闪电效果
//buff提示
//buff提示
//学习提示
//提示
//关闭提示
//学习提示
//提示
//关闭提示
//----------物品数据类型----------------------
//物品图标
//物品提示
//物品扩展提示
//物品名字
//物品说明
//------------单位数据类型--------------
//攻击1 伤害骰子数量
//攻击1 伤害骰子面数
//攻击1 基础伤害
//攻击1 升级奖励
//攻击1 最小伤害
//攻击1 最大伤害
//攻击1 全伤害范围
//装甲
// attack 1 attribute adds
//攻击1 伤害衰减参数
//攻击1 武器声音
//攻击1 攻击类型
//攻击1 最大目标数
//攻击1 攻击间隔
//攻击1 攻击延迟/summary>
//攻击1 弹射弧度
//攻击1 攻击范围缓冲
//攻击1 目标允许
//攻击1 溅出区域
//攻击1 溅出半径
//攻击1 武器类型
// attack 2 attributes (sorted in a sequencial order based on memory address)
//攻击2 伤害骰子数量
//攻击2 伤害骰子面数
//攻击2 基础伤害
//攻击2 升级奖励
//攻击2 伤害衰减参数
//攻击2 武器声音
//攻击2 攻击类型
//攻击2 最大目标数
//攻击2 攻击间隔
//攻击2 攻击延迟
//攻击2 攻击范围
//攻击2 攻击缓冲
//攻击2 最小伤害
//攻击2 最大伤害
//攻击2 弹射弧度
//攻击2 目标允许类型
//攻击2 溅出区域
//攻击2 溅出半径
//攻击2 武器类型
//装甲类型

//魔兽版本 用GetGameVersion 来获取当前版本 来对比以下具体版本做出相应操作
//-----------模拟聊天------------------
//---------技能数据类型---------------
//----------物品数据类型----------------------
//物品图标
//物品提示
//物品扩展提示
//物品名字
//物品说明
//------------单位数据类型--------------
//攻击1 伤害骰子数量
//攻击1 伤害骰子面数
//攻击1 基础伤害
//攻击1 升级奖励
//攻击1 最小伤害
//攻击1 最大伤害
//攻击1 全伤害范围
//装甲
// attack 1 attribute adds
//攻击1 伤害衰减参数
//攻击1 武器声音
//攻击1 攻击类型
//攻击1 最大目标数
//攻击1 攻击间隔
//攻击1 攻击延迟/summary>
//攻击1 弹射弧度
//攻击1 攻击范围缓冲
//攻击1 目标允许
//攻击1 溅出区域
//攻击1 溅出半径
//攻击1 武器类型
// attack 2 attributes (sorted in a sequencial order based on memory address)
//攻击2 伤害骰子数量
//攻击2 伤害骰子面数
//攻击2 基础伤害
//攻击2 升级奖励
//攻击2 伤害衰减参数
//攻击2 武器声音
//攻击2 攻击类型
//攻击2 最大目标数
//攻击2 攻击间隔
//攻击2 攻击延迟
//攻击2 攻击范围
//攻击2 攻击缓冲
//攻击2 最小伤害
//攻击2 最大伤害
//攻击2 弹射弧度
//攻击2 目标允许类型
//攻击2 溅出区域
//攻击2 溅出半径
//攻击2 武器类型
//装甲类型

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
// #define StructMode // todo:结构体数量查看模式:用条件编译直接全部搞定
//函数入口
// 用原始地图测试
// 用空地图测试

//玩家总数
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
    call initializePlugin()
 call SetCameraBounds(- 13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), - 13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), - 13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), - 13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    call NewSoundEnvironment("Default")
    call SetAmbientDaySound("NorthrendDay")
    call SetAmbientNightSound("NorthrendNight")
    call SetMapMusic("Music", true, 0)
    call CreateRegions()
    call CreateAllUnits()
    call InitBlizzard()

call ExecuteFunc("jasshelper__initstructs160132703")
call ExecuteFunc("Constant___onInit")
call ExecuteFunc("InnerJapi__onInit")
call ExecuteFunc("UnitTestFramwork__onInit")
call ExecuteFunc("InitializeYD")
call ExecuteFunc("Variable___onInit")
call ExecuteFunc("UTEffectUtils___onInit")

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
function sa__pierce_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            call DestroyEffect(s__pierce_e[this])
            call DestroyTrigger(s__pierce_trU[this])
            call DestroyTrigger(s__pierce_trEnd[this])
            call DestroyGroup(s__pierce_g[this])
            set s__pierce_e[this]=null
            set s__pierce_trU[this]=null
            set s__pierce_trEnd[this]=null
            set s__pierce_g[this]=null
   return true
endfunction
function sa__umissile_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            call DestroyEffect(s__umissile_e[this])
            call DestroyTrigger(s__umissile_tr[this])
            set s__umissile_e[this]=null
            set s__umissile_tr[this]=null
            set s__umissile_u[this]=null
   return true
endfunction
function sa__missile_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            call DestroyEffect(s__missile_e[this])
            call DestroyTrigger(s__missile_tr[this])
            set s__missile_e[this]=null
            set s__missile_tr[this]=null
   return true
endfunction

function jasshelper__initstructs160132703 takes nothing returns nothing
    set st__pierce_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__pierce_onDestroy,Condition( function sa__pierce_onDestroy))
    set st__umissile_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__umissile_onDestroy,Condition( function sa__umissile_onDestroy))
    set st__missile_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__missile_onDestroy,Condition( function sa__missile_onDestroy))







endfunction

