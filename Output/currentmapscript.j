globals
//globals from BzAPI:
constant boolean LIBRARY_BzAPI=true
//endglobals from BzAPI
//globals from UnitTestFramwork:
constant boolean LIBRARY_UnitTestFramwork=true
trigger UnitTestFramwork___TUnitTest=null
//endglobals from UnitTestFramwork
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
//globals from YDWEPolledWaitNull:
constant boolean LIBRARY_YDWEPolledWaitNull=true
//endglobals from YDWEPolledWaitNull
//globals from HardwellEvent:
constant boolean LIBRARY_HardwellEvent=true
//endglobals from HardwellEvent
//globals from Zinc:
constant boolean LIBRARY_Zinc=true
//endglobals from Zinc
//globals from CameraControl:
constant boolean LIBRARY_CameraControl=true
integer CameraControl___ViewLevel=8
boolean CameraControl___ResetCam=false
real CameraControl___WheelSpeed=0.1
boolean CameraControl___WideScr=false
real CameraControl___X_ANGLE=304
//endglobals from CameraControl
//globals from UTZinc:
constant boolean LIBRARY_UTZinc=true
integer UTZinc___IIII=0
real array UTZinc___x
// processed:     real  array UTZinc___y[16000]
//endglobals from UTZinc
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
constant integer si__pd=1
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
constant integer si__hardwellEvent=2
integer si__hardwellEvent_F=0
integer si__hardwellEvent_I=0
integer array si__hardwellEvent_V
trigger s__hardwellEvent_trWheel=null
trigger s__hardwellEvent_trUpdate=null
trigger s__hardwellEvent_trResize=null
constant integer si__cameraControl=3
integer si__cameraControl_F=0
integer si__cameraControl_I=0
integer array si__cameraControl_V
constant integer si__UTZinc___ceshi=4
integer si__UTZinc___ceshi_F=0
integer si__UTZinc___ceshi_I=0
integer array si__UTZinc___ceshi_V
integer array s__UTZinc___ceshi_UTZinc___x
constant integer si__UTZinc___A=5
integer si__UTZinc___A_F=0
integer si__UTZinc___A_I=0
integer array si__UTZinc___A_V
integer array si__UTZinc___A_type
trigger array st__UTZinc___A_onDestroy
trigger array st__UTZinc___A_AFunc
constant integer si__UTZinc___B=6
constant integer si__C=7
integer array s__C_UTZinc___x
integer array s__C_UTZinc___y
integer si__UTZinc___D_I=0
integer si__UTZinc___D_F=0
integer array s__UTZinc___D
constant integer s__UTZinc___D_size=10
integer array si__UTZinc___D_V
constant integer si__UTZinc___E=9
integer si__UTZinc___E_F=0
integer si__UTZinc___E_I=0
integer array si__UTZinc___E_V
integer array s__UTZinc___E_UTZinc___x
integer array s__UTZinc___E_UTZinc___y
integer s__UTZinc___E_z=0
real array s__UTZinc___y
real array s__2UTZinc___y
trigger array st___prototype10
trigger array st___prototype12
trigger array st___prototype13
player f__arg_player1
integer f__arg_integer1
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


function sg__UTZinc___y_get takes integer i returns real
    if(i<8191) then
        return s__UTZinc___y[i]
    else
        return s__2UTZinc___y[i-8191]
    endif
endfunction

function sg__UTZinc___y_set takes integer i,real v returns nothing
    if(i<8191) then
        set s__UTZinc___y[i]=v
    else
        set s__2UTZinc___y[i-8191]=v
    endif
endfunction

//Generated allocator of UTZinc___E
function s__UTZinc___E__allocate takes nothing returns integer
 local integer this=si__UTZinc___E_F
    if (this!=0) then
        set si__UTZinc___E_F=si__UTZinc___E_V[this]
    else
        set si__UTZinc___E_I=si__UTZinc___E_I+1
        set this=si__UTZinc___E_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: UTZinc___E")
        return 0
    endif

    set si__UTZinc___E_V[this]=-1
 return this
endfunction

//Generated destructor of UTZinc___E
function s__UTZinc___E_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: UTZinc___E")
        return
    elseif (si__UTZinc___E_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: UTZinc___E")
        return
    endif
    set si__UTZinc___E_V[this]=si__UTZinc___E_F
    set si__UTZinc___E_F=this
endfunction

//Generated allocator of UTZinc___D
function s__UTZinc___D__allocate takes nothing returns integer
 local integer this=si__UTZinc___D_F
    if (this!=0) then
        set si__UTZinc___D_F=si__UTZinc___D_V[this]
    else
        set si__UTZinc___D_I=si__UTZinc___D_I+10
        set this=si__UTZinc___D_I
    endif
    if (this>8181) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: UTZinc___D")
        return 0
    endif

    set si__UTZinc___D_V[this]=-1
 return this
endfunction

//Generated destructor of UTZinc___D
function s__UTZinc___D_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: UTZinc___D")
        return
    elseif (si__UTZinc___D_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: UTZinc___D")
        return
    endif
    set si__UTZinc___D_V[this]=si__UTZinc___D_F
    set si__UTZinc___D_F=this
endfunction

//Generated allocator of hardwellEvent
function s__hardwellEvent__allocate takes nothing returns integer
 local integer this=si__hardwellEvent_F
    if (this!=0) then
        set si__hardwellEvent_F=si__hardwellEvent_V[this]
    else
        set si__hardwellEvent_I=si__hardwellEvent_I+1
        set this=si__hardwellEvent_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: hardwellEvent")
        return 0
    endif

    set si__hardwellEvent_V[this]=-1
 return this
endfunction

//Generated destructor of hardwellEvent
function s__hardwellEvent_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: hardwellEvent")
        return
    elseif (si__hardwellEvent_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: hardwellEvent")
        return
    endif
    set si__hardwellEvent_V[this]=si__hardwellEvent_F
    set si__hardwellEvent_F=this
endfunction

//Generated method caller for UTZinc___A.AFunc
function sc__UTZinc___A_AFunc takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__UTZinc___A_AFunc[si__UTZinc___A_type[this]])
endfunction

//Generated method executor for UTZinc___A.AFunc
function sx__UTZinc___A_AFunc takes integer this returns nothing
    set f__arg_this=this
    call TriggerExecute(st__UTZinc___A_AFunc[si__UTZinc___A_type[this]])
endfunction
//Generated destructor of UTZinc___A
function sc__UTZinc___A_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: UTZinc___A")
        return
    elseif (si__UTZinc___A_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: UTZinc___A")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__UTZinc___A_onDestroy[si__UTZinc___A_type[this]])
    set si__UTZinc___A_V[this]=si__UTZinc___A_F
    set si__UTZinc___A_F=this
endfunction

//Generated allocator of UTZinc___ceshi
function s__UTZinc___ceshi__allocate takes nothing returns integer
 local integer this=si__UTZinc___ceshi_F
    if (this!=0) then
        set si__UTZinc___ceshi_F=si__UTZinc___ceshi_V[this]
    else
        set si__UTZinc___ceshi_I=si__UTZinc___ceshi_I+1
        set this=si__UTZinc___ceshi_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: UTZinc___ceshi")
        return 0
    endif

    set si__UTZinc___ceshi_V[this]=-1
 return this
endfunction

//Generated destructor of UTZinc___ceshi
function s__UTZinc___ceshi_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: UTZinc___ceshi")
        return
    elseif (si__UTZinc___ceshi_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: UTZinc___ceshi")
        return
    endif
    set si__UTZinc___ceshi_V[this]=si__UTZinc___ceshi_F
    set si__UTZinc___ceshi_F=this
endfunction

//Generated allocator of cameraControl
function s__cameraControl__allocate takes nothing returns integer
 local integer this=si__cameraControl_F
    if (this!=0) then
        set si__cameraControl_F=si__cameraControl_V[this]
    else
        set si__cameraControl_I=si__cameraControl_I+1
        set this=si__cameraControl_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: cameraControl")
        return 0
    endif

    set si__cameraControl_V[this]=-1
 return this
endfunction

//Generated destructor of cameraControl
function s__cameraControl_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: cameraControl")
        return
    elseif (si__cameraControl_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: cameraControl")
        return
    endif
    set si__cameraControl_V[this]=si__cameraControl_F
    set si__cameraControl_F=this
endfunction

//Generated method caller for UTZinc___B.AFunc
function sc__UTZinc___B_AFunc takes integer this returns nothing
endfunction

//Generated allocator of UTZinc___B
function s__UTZinc___B__allocate takes nothing returns integer
 local integer kthis
 local integer this=si__UTZinc___A_F
    if (this!=0) then
        set si__UTZinc___A_F=si__UTZinc___A_V[this]
    else
        set si__UTZinc___A_I=si__UTZinc___A_I+1
        set this=si__UTZinc___A_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: UTZinc___B")
        return 0
    endif

    set si__UTZinc___A_type[this]=6
    set kthis=this

    set si__UTZinc___A_V[this]=-1
 return this
endfunction

function sc___prototype10_execute takes integer i,player a1 returns nothing
    set f__arg_player1=a1

    call TriggerExecute(st___prototype10[i])
endfunction
function sc___prototype10_evaluate takes integer i,player a1 returns nothing
    set f__arg_player1=a1

    call TriggerEvaluate(st___prototype10[i])

endfunction
function sc___prototype12_execute takes integer i,player a1,integer a2 returns nothing
    set f__arg_player1=a1
    set f__arg_integer1=a2

    call TriggerExecute(st___prototype12[i])
endfunction
function sc___prototype12_evaluate takes integer i,player a1,integer a2 returns nothing
    set f__arg_player1=a1
    set f__arg_integer1=a2

    call TriggerEvaluate(st___prototype12[i])

endfunction
function sc___prototype13_execute takes integer i,integer a1 returns nothing
    set f__arg_integer1=a1

    call TriggerExecute(st___prototype13[i])
endfunction
function sc___prototype13_evaluate takes integer i,integer a1 returns nothing
    set f__arg_integer1=a1

    call TriggerEvaluate(st___prototype13[i])

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
//library UnitTestFramwork:

    function UnitTestRegisterChatEvent takes code func returns nothing
        call TriggerAddAction(UnitTestFramwork___TUnitTest, func)
    endfunction
        function UnitTestFramwork___anon__0 takes nothing returns nothing
            local integer i
            set i=1
            loop
            exitwhen ( i > 12 )
                call SetPlayerName(ConvertedPlayer(i), "测试员" + I2S(i) + "号")
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
            exitwhen ( i > MAX_PLAYER_COUNT )
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
        exitwhen ( i > MAX_PLAYER_COUNT )
            call TriggerRegisterPlayerSelectionEventBJ(TrSelect, ConvertedPlayer(i), true)
        set i=i + 1
        endloop
        call TriggerAddCondition(TrSelect, Condition(function Variable___anon__1))
    endfunction

//library Variable ends
//library YDWEPolledWaitNull:
function YDWEPolledWaitNull takes real duration returns nothing
    local timer t
    local real timeRemaining
    if ( duration > 0 ) then
        set t=CreateTimer()
        call TimerStart(t, duration, false, null)
        loop
            set timeRemaining=TimerGetRemaining(t)
            exitwhen timeRemaining <= 0
            // If we have a bit of time left, skip past 10% of the remaining
            // duration instead of checking every interval, to minimize the
            // polling on long waits.
            if ( timeRemaining > bj_POLLED_WAIT_SKIP_THRESHOLD ) then
                call TriggerSleepAction(0.1 * timeRemaining)
            else
                call TriggerSleepAction(bj_POLLED_WAIT_INTERVAL)
            endif
        endloop
        call DestroyTimer(t)
    endif
    set t=null
endfunction

//library YDWEPolledWaitNull ends
//library HardwellEvent:
        function s__hardwellEvent_RegLeftClickEvent takes code func returns nothing
            call DzTriggerRegisterMouseEventByCode(null, 1, 0, false, func)
        endfunction  // 注册一个左键按下事件
        function s__hardwellEvent_RegLeftDownEvent takes code func returns nothing
            call DzTriggerRegisterMouseEventByCode(null, 1, 1, false, func)
        endfunction  // 注册一个左键按下事件
        function s__hardwellEvent_RegRightClickEvent takes code func returns nothing
            call DzTriggerRegisterMouseEventByCode(null, 2, 0, false, func)
        endfunction  // 注册一个滚轮事件
        function s__hardwellEvent_RegWheelEvent takes code func returns nothing
            if ( s__hardwellEvent_trWheel == null ) then
                set s__hardwellEvent_trWheel=CreateTrigger()
            endif
            call TriggerAddCondition(s__hardwellEvent_trWheel, Condition(func))
        endfunction  // 注册一个绘制事件
        function s__hardwellEvent_RegUpdateEvent takes code func returns nothing
            if ( s__hardwellEvent_trUpdate == null ) then
                set s__hardwellEvent_trUpdate=CreateTrigger()
            endif
            call TriggerAddCondition(s__hardwellEvent_trUpdate, Condition(func))
        endfunction  // 注册一个窗口变化事件
        function s__hardwellEvent_RegResizeEvent takes code func returns nothing
            if ( s__hardwellEvent_trResize == null ) then
                set s__hardwellEvent_trResize=CreateTrigger()
            endif
            call TriggerAddCondition(s__hardwellEvent_trResize, Condition(func))
        endfunction
            function s__hardwellEvent_anon__0 takes nothing returns nothing
                call TriggerEvaluate(s__hardwellEvent_trWheel)
            endfunction  // 帧绘制事件
            function s__hardwellEvent_anon__1 takes nothing returns nothing
                call TriggerEvaluate(s__hardwellEvent_trUpdate)
            endfunction  // 窗口大小变化事件
            function s__hardwellEvent_anon__2 takes nothing returns nothing
                call TriggerEvaluate(s__hardwellEvent_trResize)
            endfunction
        function s__hardwellEvent_onInit takes nothing returns nothing
            call DzTriggerRegisterMouseWheelEventByCode(null, false, function s__hardwellEvent_anon__0)
            call DzFrameSetUpdateCallbackByCode(function s__hardwellEvent_anon__1)
            call DzTriggerRegisterWindowResizeEventByCode(null, false, function s__hardwellEvent_anon__2)
        endfunction

//library HardwellEvent ends
//library Zinc:

    function Zinc___onInit takes nothing returns nothing
    endfunction

//library Zinc ends
//library CameraControl:

        function s__cameraControl_openWheel takes nothing returns nothing
            call DoNothing()
        endfunction
        function CameraControl___anon__0 takes nothing returns nothing
            local integer delta=DzGetWheelDelta()
            if ( not ( DzIsMouseOverUI() ) ) then //标记需要重置镜头属性
                return
            endif
            set CameraControl___ResetCam=true //滚轮下滑
            if ( delta < 0 ) then //视野等级上限
                if ( CameraControl___ViewLevel < 14 ) then //滚轮上滑
                    set CameraControl___ViewLevel=CameraControl___ViewLevel + 1
                endif
            elseif ( CameraControl___ViewLevel > 3 ) then //视野等级下限
                set CameraControl___ViewLevel=CameraControl___ViewLevel - 1
            endif
            set CameraControl___X_ANGLE=Rad2Deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK)) //记录滚动前的镜头角度
        endfunction  //注册每帧渲染事件
        function CameraControl___anon__1 takes nothing returns nothing
            if ( CameraControl___ResetCam ) then
                call SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, CameraControl___X_ANGLE, 0)
                call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, CameraControl___ViewLevel * 200, CameraControl___WheelSpeed)
                set CameraControl___ResetCam=false
            endif
        endfunction  //注册按下键码为145的按键(ScrollLock)事件
        function CameraControl___anon__2 takes nothing returns nothing
            set CameraControl___WideScr=not CameraControl___WideScr
            call DzEnableWideScreen(CameraControl___WideScr)
        endfunction
    function CameraControl___onInit takes nothing returns nothing
        call s__hardwellEvent_RegWheelEvent(function CameraControl___anon__0)
        call s__hardwellEvent_RegUpdateEvent(function CameraControl___anon__1)
        call DzTriggerRegisterKeyEventByCode(null, 145, 1, false, function CameraControl___anon__2)
    endfunction

//library CameraControl ends
//library UTZinc:

    function UTZinc___TTestUTZinc1 takes player p returns nothing
        local integer i
        local integer index=1
        set i=0
        loop
        exitwhen ( i >= UTZinc___IIII )
            set index=index * 3
        set i=i + 1
        endloop
    endfunction
    function UTZinc___TTestUTZinc2 takes player p returns nothing
        local integer array i
        local integer j
        local string s=""
        local integer index=GetConvertedPlayerId(p)
        local unit u=null
        set j=0 // for (0 <= i[1] < 10) {}
        loop
        exitwhen ( j >= 10 )
            set i[2]=i[2] * 5
            set s=s + "nimabi"
        set j=j + 1
        endloop //编译后j从9开始
        set j=( 10 ) - 1
        loop
        exitwhen ( j < 1 )
            set i[1]=i[1] + 5
        set j=j - 1
        endloop
        set j=2 //这种写法编译不给过
        loop
        exitwhen j > 100
            call BJDebugMsg("hehe")
        set j=j + 2
        endloop
    endfunction  // for (BJDebugMsg("1");j <= 100;BJDebugMsg("2")) {}
    function UTZinc___TTestUTZinc3 takes player p returns nothing
        call YDWEPolledWaitNull(1.0) //SelectUnitSingle(u); //一些Bj优化如果不过编译就手动改一下吧 //AntiBJLeak倒是没问题,因为只是单纯替换文件
    endfunction
        function UTZinc___anon__0 takes nothing returns boolean
            return true
        endfunction
        function UTZinc___anon__1 takes nothing returns nothing
            call BJDebugMsg("haha")
        endfunction
    function UTZinc___TTestUTZinc4 takes player p returns nothing
        local trigger t=CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DEATH)
        call TriggerAddCondition(t, Condition(function UTZinc___anon__0))
        call TriggerAddAction(t, function UTZinc___anon__1)
        set t=null
    endfunction
    function UTZinc___TTestUTZinc5 takes player p returns nothing
        local integer c=s__UTZinc___ceshi__allocate()
        local integer i=c
        set s__UTZinc___ceshi_UTZinc___x[c]=5
        call BJDebugMsg(I2S(i))
        call BJDebugMsg(I2S(c))
        call s__UTZinc___ceshi_deallocate(c)
    endfunction
        function s__UTZinc___B_AFunc takes integer this returns nothing
        endfunction
    function UTZinc___TTestUTZinc6 takes player p returns nothing
        set s__C_UTZinc___x[(2)]=5
        set s__C_UTZinc___y[(2)]=10
    endfunction  //要加个分号 你妈的
//processed :    type UTZinc___D extends integer array [10]
    function UTZinc___TTestUTZinc7 takes player p returns nothing
        local integer d=s__UTZinc___D__allocate()
        set s__UTZinc___D[d+1]=50
        set s__UTZinc___D[d+2]=50
        call s__UTZinc___D_deallocate(d)
    endfunction  //这里测一下函数指针,比自己写Trigger再调用要方便,就是不能递归调用,最好统筹一下队列.
//processed:     function interface UTZinc___funA takes player arg0 returns nothing
//processed:     function interface UTZinc___funC takes player arg0 returns nothing
//processed:     function interface UTZinc___funD takes player arg0, integer arg1 returns nothing
        function UTZinc___anon__2 takes player p returns nothing
            call BJDebugMsg(GetPlayerName(p))
        endfunction
        function UTZinc___anon__3 takes player p returns nothing
            call BJDebugMsg(GetPlayerName(p))
        endfunction
        function UTZinc___anon__4 takes player p,integer i returns nothing
            call BJDebugMsg(GetPlayerName(p) + I2S(i))
        endfunction  //这里的p都是相同的,编译成相同东西
    function UTZinc___TTestUTZinc8 takes player p returns nothing
        local integer fa=(1)
        local integer fc=(2)
        local integer fd=(1)
        call sc___prototype10_evaluate(fa,p) //这里的p都是相同的,编译成相同东西
        call sc___prototype10_evaluate(fc,p) //这里的p都是相同的,编译成相同东西,后面的i和下面的i也是相同的
        call sc___prototype12_evaluate(fd,p , GetConvertedPlayerId(p))
    endfunction
//processed:     function interface UTZinc___funB takes integer arg0 returns nothing
        function s__UTZinc___E_a takes integer this returns nothing
            set s__UTZinc___E_UTZinc___x[this]=s__UTZinc___E_UTZinc___x[this] + 100 // .x += 100; // .y += 200;
            set s__UTZinc___E_UTZinc___y[this]=s__UTZinc___E_UTZinc___y[this] + 200
        endfunction
            function s__UTZinc___E_anon__5 takes integer this returns nothing
                call BJDebugMsg("haha")
            endfunction
        function s__UTZinc___E_b takes integer this returns nothing
            local integer fn=(1)
            call sc___prototype13_evaluate(fn,this)
        endfunction
        function s__UTZinc___E_onInit takes nothing returns nothing
            set s__UTZinc___E_z=s__UTZinc___E_z + 200
        endfunction
    function UTZinc___TTestUTZinc9 takes player p returns nothing
    endfunction
    function UTZinc___TTestUTZinc10 takes player p returns nothing
    endfunction
    function UTZinc___TTestUTZinc11 takes player p returns nothing
    endfunction
    function UTZinc___TTestUTZinc12 takes player p returns nothing
    endfunction
    function UTZinc___TTestUTZinc13 takes player p returns nothing
    endfunction
    function UTZinc___TTestUTZinc14 takes player p returns nothing
    endfunction
    function UTZinc___TTestUTZinc15 takes player p returns nothing
    endfunction
    function UTZinc___TTestUTZinc16 takes player p returns nothing
    endfunction
    function UTZinc___TTestUTZinc17 takes player p returns nothing
    endfunction
    function UTZinc___TTestUTZinc18 takes player p returns nothing
    endfunction
    function UTZinc___TTestUTZinc19 takes player p returns nothing
    endfunction
    function UTZinc___TTestUTZinc20 takes player p returns nothing
    endfunction
    function UTZinc___TTestActUTZinc1 takes string str returns nothing
        local player p=GetTriggerPlayer()
        local integer index=GetConvertedPlayerId(p)
        local integer iData1=S2I(SubStringBJ(str, 2, StringLength(str)))
        local string s=SubStringBJ(str, 1, 1)
        local real rData1=S2R(SubStringBJ(str, 2, StringLength(str)))
        if ( s == "a" ) then //后面写上注释
        elseif ( s == "b" ) then
        endif
        set p=null
        set s=null
    endfunction
        function UTZinc___anon__6 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            local integer i=1
            if ( SubStringBJ(str, 1, 1 + 1) == "ss" ) then
                call UTZinc___TTestActUTZinc1(SubStringBJ(str, 2 + 1, StringLength(str)))
                return
            endif
            if ( str == "s1" ) then
                call UTZinc___TTestUTZinc1(GetTriggerPlayer())
            elseif ( str == "s2" ) then
                call UTZinc___TTestUTZinc2(GetTriggerPlayer())
            elseif ( str == "s3" ) then
                call UTZinc___TTestUTZinc3(GetTriggerPlayer())
            elseif ( str == "s4" ) then
                call UTZinc___TTestUTZinc4(GetTriggerPlayer())
            elseif ( str == "s5" ) then
                call UTZinc___TTestUTZinc5(GetTriggerPlayer())
            elseif ( str == "s6" ) then
                call UTZinc___TTestUTZinc6(GetTriggerPlayer())
            elseif ( str == "s7" ) then
                call UTZinc___TTestUTZinc7(GetTriggerPlayer())
            elseif ( str == "s8" ) then
                call UTZinc___TTestUTZinc8(GetTriggerPlayer())
            elseif ( str == "s9" ) then
                call UTZinc___TTestUTZinc9(GetTriggerPlayer())
            elseif ( str == "s10" ) then
                call UTZinc___TTestUTZinc10(GetTriggerPlayer())
            elseif ( str == "sa" ) then
                call UTZinc___TTestUTZinc11(GetTriggerPlayer())
            elseif ( str == "sb" ) then
                call UTZinc___TTestUTZinc12(GetTriggerPlayer())
            elseif ( str == "sc" ) then
                call UTZinc___TTestUTZinc13(GetTriggerPlayer())
            elseif ( str == "sd" ) then
                call UTZinc___TTestUTZinc14(GetTriggerPlayer())
            elseif ( str == "se" ) then
                call UTZinc___TTestUTZinc15(GetTriggerPlayer())
            elseif ( str == "sf" ) then
                call UTZinc___TTestUTZinc16(GetTriggerPlayer())
            elseif ( str == "sg" ) then
                call UTZinc___TTestUTZinc17(GetTriggerPlayer())
            elseif ( str == "sh" ) then
                call UTZinc___TTestUTZinc18(GetTriggerPlayer())
            elseif ( str == "si" ) then
                call UTZinc___TTestUTZinc19(GetTriggerPlayer())
            elseif ( str == "sj" ) then
                call UTZinc___TTestUTZinc20(GetTriggerPlayer())
            endif
        endfunction
        function UTZinc___anon__7 takes nothing returns nothing
            local timer t=GetExpiredTimer()
            local integer id=GetHandleId(t)
            call BJDebugMsg("这是Zinc测试")
            call PauseTimer(t)
            call FlushChildHashtable(TITable, id)
            call DestroyTimer(t)
            set t=null
        endfunction
    function UTZinc___onInit takes nothing returns nothing
        local integer i2=1
        local timer t
        call UnitTestRegisterChatEvent(function UTZinc___anon__6)
        set t=CreateTimer()
        call TimerStart(t, 1, false, function UTZinc___anon__7)
        set t=null //打开滚轮控制镜头
        call s__cameraControl_openWheel()
    endfunction

//library UTZinc ends

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

call ExecuteFunc("jasshelper__initstructs75903546")
call ExecuteFunc("UnitTestFramwork___onInit")
call ExecuteFunc("Variable___onInit")
call ExecuteFunc("Zinc___onInit")
call ExecuteFunc("CameraControl___onInit")
call ExecuteFunc("UTZinc___onInit")

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

//Functions for BigArrays:
function sa__UTZinc___B_AFunc takes nothing returns boolean
local integer this=f__arg_this
   return true
endfunction
function sa___prototype10_UTZinc___anon__2 takes nothing returns boolean
 local player p=f__arg_player1

            call BJDebugMsg(GetPlayerName(p))
    return true
endfunction
function sa___prototype10_UTZinc___anon__3 takes nothing returns boolean
 local player p=f__arg_player1

            call BJDebugMsg(GetPlayerName(p))
    return true
endfunction
function sa___prototype12_UTZinc___anon__4 takes nothing returns boolean
 local player p=f__arg_player1
 local integer i=f__arg_integer1

            call BJDebugMsg(GetPlayerName(p) + I2S(i))
    return true
endfunction
function sa___prototype13_s__UTZinc___E_anon__5 takes nothing returns boolean
 local integer this=f__arg_integer1

                call BJDebugMsg("haha")
    return true
endfunction

function jasshelper__initstructs75903546 takes nothing returns nothing
    set st__UTZinc___A_AFunc[6]=CreateTrigger()
    call TriggerAddCondition(st__UTZinc___A_AFunc[6],Condition( function sa__UTZinc___B_AFunc))
    call TriggerAddAction(st__UTZinc___A_AFunc[6], function sa__UTZinc___B_AFunc)
    set st__UTZinc___A_onDestroy[6]=null
    set st___prototype10[1]=CreateTrigger()
    call TriggerAddAction(st___prototype10[1],function sa___prototype10_UTZinc___anon__2)
    call TriggerAddCondition(st___prototype10[1],Condition(function sa___prototype10_UTZinc___anon__2))
    set st___prototype10[2]=CreateTrigger()
    call TriggerAddAction(st___prototype10[2],function sa___prototype10_UTZinc___anon__3)
    call TriggerAddCondition(st___prototype10[2],Condition(function sa___prototype10_UTZinc___anon__3))
    set st___prototype12[1]=CreateTrigger()
    call TriggerAddAction(st___prototype12[1],function sa___prototype12_UTZinc___anon__4)
    call TriggerAddCondition(st___prototype12[1],Condition(function sa___prototype12_UTZinc___anon__4))
    set st___prototype13[1]=CreateTrigger()
    call TriggerAddAction(st___prototype13[1],function sa___prototype13_s__UTZinc___E_anon__5)
    call TriggerAddCondition(st___prototype13[1],Condition(function sa___prototype13_s__UTZinc___E_anon__5))














    call ExecuteFunc("s__hardwellEvent_onInit")
    call ExecuteFunc("s__UTZinc___E_onInit")
endfunction

