globals
//globals from BzAPI:
constant boolean LIBRARY_BzAPI=true
//endglobals from BzAPI
//globals from UnitFilter:
constant boolean LIBRARY_UnitFilter=true
//endglobals from UnitFilter
//globals from UnitHashTable:
constant boolean LIBRARY_UnitHashTable=true
hashtable HASH_UNIT=InitHashtable()
//endglobals from UnitHashTable
//globals from UnitTestFramwork:
constant boolean LIBRARY_UnitTestFramwork=true
trigger UnitTestFramwork__TUnitTest=null
hashtable UnitTestFramwork__HASH_UNITTEST=InitHashtable()
//endglobals from UnitTestFramwork
//globals from UnitUtils:
constant boolean LIBRARY_UnitUtils=true
//endglobals from UnitUtils
//globals from YDLua:
constant boolean LIBRARY_YDLua=true
//endglobals from YDLua
//globals from GroupUtils:
constant boolean LIBRARY_GroupUtils=true
group GroupUtils__tempG=null
player GroupUtils__tempP=null
//endglobals from GroupUtils
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
//globals from CameraControl:
constant boolean LIBRARY_CameraControl=true
integer CameraControl__ViewLevel=8
boolean CameraControl__ResetCam=false
real CameraControl__WheelSpeed=0.1
boolean CameraControl__WideScr=false
real CameraControl__X_ANGLE=304
boolean CameraControl__HeightLocked=false
//endglobals from CameraControl
//globals from DamageUtils:
constant boolean LIBRARY_DamageUtils=true
integer DamageUtils__lsTop=- 1
unit array DamageUtils__lsSource
real array DamageUtils__lsTotal
trigger DamageUtils__TrLifeSteal=null
unit DamageUtils__uArgs=null
real DamageUtils__rArgs=0.
//endglobals from DamageUtils
//globals from UTDamageUtils:
constant boolean LIBRARY_UTDamageUtils=true
unit UTDamageUtils__testDummy=null
unit UTDamageUtils__testSource=null
real UTDamageUtils__testDamage=100.0
real UTDamageUtils__testRadius=300.0
string UTDamageUtils__testEffect="Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl"
trigger UTDamageUtils__damageEventTrigger=null
boolean UTDamageUtils__isShowDamage=false
boolean UTDamageUtils__isReflectDamage=false
integer UTDamageUtils__reflectCount=0
boolean UTDamageUtils__isLifestealEnabled=false
real UTDamageUtils__totalLifesteal=0.0
//endglobals from UTDamageUtils
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
constant integer si__assert=1
constant integer si__unitAttrObserver=2
unit s__unitAttrObserver_argsU=null
trigger s__unitAttrObserver_attackIntervalCB=null
constant integer si__hardware=3
trigger s__hardware_trWheel=null
trigger s__hardware_trUpdate=null
trigger s__hardware_trResize=null
trigger s__hardware_trMove=null
constant integer si__cameraControl=4
integer si__cameraControl_F=0
integer si__cameraControl_I=0
integer array si__cameraControl_V
constant integer si__DmgP=5
integer si__DmgP_F=0
integer si__DmgP_I=0
integer array si__DmgP_V
unit array s__DmgP_source
string array s__DmgP_eft
real array s__DmgP_damage
boolean array s__DmgP_enableLifestealAggregation
real array s__DmgP_lifestealDealtTotal
constant integer si__DmgS=6
integer array s__DmgS_stack
integer s__DmgS_top=- 1
trigger st__DmgP_onDestroy
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


//Generated method caller for DmgP.onDestroy
function sc__DmgP_onDestroy takes integer this returns nothing
            set s__DmgP_source[this]=null // this.eft = null; // 可选
endfunction

//Generated allocator of DmgP
function s__DmgP__allocate takes nothing returns integer
 local integer this=si__DmgP_F
    if (this!=0) then
        set si__DmgP_F=si__DmgP_V[this]
    else
        set si__DmgP_I=si__DmgP_I+1
        set this=si__DmgP_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: DmgP")
        return 0
    endif

    set si__DmgP_V[this]=-1
 return this
endfunction

//Generated destructor of DmgP
function sc__DmgP_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: DmgP")
        return
    elseif (si__DmgP_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: DmgP")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__DmgP_onDestroy)
    set si__DmgP_V[this]=si__DmgP_F
    set si__DmgP_F=this
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
//library UnitFilter:
    function IsEnemy takes unit u,player p returns boolean
        return ( ( GetUnitState(u, UNIT_STATE_LIFE) > 0.405 and ( GetUnitState(u, UNIT_STATE_LIFE) > 0 ) ) and ( not ( IsUnitType(u, UNIT_TYPE_SLEEPING) ) and not ( IsUnitType(u, UNIT_TYPE_STRUCTURE) ) and not ( IsUnitHidden(u) ) and IsUnitEnemy(u, p) and IsUnitVisible(u, p) ) ) and GetUnitAbilityLevel(u, 'Avul') < 1
    endfunction  //旧名：IsEnemy2
    function IsEnemyIncludeInvul takes unit u,player p returns boolean
        return ( ( GetUnitState(u, UNIT_STATE_LIFE) > 0.405 and ( GetUnitState(u, UNIT_STATE_LIFE) > 0 ) ) and ( not ( IsUnitType(u, UNIT_TYPE_SLEEPING) ) and not ( IsUnitType(u, UNIT_TYPE_STRUCTURE) ) and not ( IsUnitHidden(u) ) and IsUnitEnemy(u, p) and IsUnitVisible(u, p) ) )
    endfunction  //判断是否是敌方非魔法免疫单位
    function IsEnemyMagic takes unit u,player p returns boolean
        return not ( IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) ) and IsEnemy(u , p) and not ( IsUnitType(u, UNIT_TYPE_RESISTANT) )
    endfunction  //判断是否是敌方(简化版本,只检查基础状态和敌对关系)
    function IsEnemyBasic takes unit u,player p returns boolean
        return ( GetUnitState(u, UNIT_STATE_LIFE) > 0.405 and ( GetUnitState(u, UNIT_STATE_LIFE) > 0 ) ) and IsUnitEnemy(u, p)
    endfunction  //判断是否是友方
    function IsAlly takes unit u,player p returns boolean
        return GetUnitState(u, UNIT_STATE_LIFE) > .405 and ( not ( IsUnitType(u, UNIT_TYPE_STRUCTURE) ) ) and ( not ( IsUnitHidden(u) ) ) and IsUnitAlly(u, p)
    endfunction  //判断两个单位是否互为敌人(不带无敌)
    function IsEnemyUnit takes unit target,unit caster returns boolean
        return IsEnemy(target , GetOwningPlayer(caster))
    endfunction  //判断两个单位是否互为队友(不带无敌)
    function IsAllyUnit takes unit target,unit caster returns boolean
        return IsAlly(target , GetOwningPlayer(caster))
    endfunction  //判断两个单位是否互为敌人(简化版本,只检查基础状态和敌对关系)
    function IsEnemyBasicUnit takes unit target,unit caster returns boolean
        return ( GetUnitState(target, UNIT_STATE_LIFE) > 0.405 and ( GetUnitState(target, UNIT_STATE_LIFE) > 0 ) ) and IsUnitEnemy(target, GetOwningPlayer(caster))
    endfunction  //判断是否是敌方非魔法免疫单位(双单位参数版)
    function IsEnemyMagicUnit takes unit target,unit caster returns boolean
        return IsEnemyMagic(target , GetOwningPlayer(caster))
    endfunction  // //判断单位是否属于指定常见种族或中立阵营

//library UnitFilter ends
//library UnitHashTable:

//library UnitHashTable ends
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
        call TriggerAddAction(UnitTestFramwork__TUnitTest, func)
    endfunction  //指定开始时间与持续时间的定时器
        function UnitTestFramwork__anon__0 takes nothing returns nothing
            local real time=LoadReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 1)
            local real d=LoadReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 2)
            local trigger tr=LoadTriggerHandle(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 3)
            call BJDebugMsg("-----[单测 " + R2SW(time, 0, 1) + " - " + R2SW(time + d, 0, 1) + " 秒]开始------")
            call TriggerEvaluate(tr)
            call DestroyTrigger(tr)
            call FlushChildHashtable(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()))
            call DestroyTrigger(GetTriggeringTrigger())
            set tr=null
        endfunction
        function UnitTestFramwork__anon__1 takes nothing returns nothing
            local real time=LoadReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 1)
            local real d=LoadReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 2)
            local trigger tr=LoadTriggerHandle(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 3)
            call TriggerEvaluate(tr)
            call BJDebugMsg("-----[单测 " + R2SW(time, 0, 1) + " - " + R2SW(time + d, 0, 1) + " 秒]结束------")
            call DestroyTrigger(tr)
            call FlushChildHashtable(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()))
            call DestroyTrigger(GetTriggeringTrigger())
            set tr=null
        endfunction
    function UnitTestAutoTimer takes real time,real duration,code start,code end returns nothing
        local trigger t=CreateTrigger()
        local trigger tr=CreateTrigger()
        call TriggerAddCondition(t, Condition(start))
        call TriggerRegisterTimerEvent(tr, time, false)
        call SaveReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(tr), 1, time)
        call SaveReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(tr), 2, duration)
        call SaveTriggerHandle(UnitTestFramwork__HASH_UNITTEST, GetHandleId(tr), 3, t)
        call TriggerAddCondition(tr, Condition(function UnitTestFramwork__anon__0))
        if ( end != null ) then
            set t=CreateTrigger()
            set tr=CreateTrigger()
            call TriggerAddCondition(t, Condition(end))
            call TriggerRegisterTimerEvent(tr, time + duration, false)
            call SaveReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(tr), 1, time)
            call SaveReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(tr), 2, duration)
            call SaveTriggerHandle(UnitTestFramwork__HASH_UNITTEST, GetHandleId(tr), 3, t)
            call TriggerAddCondition(tr, Condition(function UnitTestFramwork__anon__1))
        endif
        set tr=null
        set t=null
    endfunction
        function UnitTestFramwork__anon__2 takes nothing returns nothing
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
    function UnitTestFramwork__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr, 0.1, false)
        call TriggerAddCondition(tr, Condition(function UnitTestFramwork__anon__2))
        set tr=null
        set UnitTestFramwork__TUnitTest=CreateTrigger()
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(0), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(1), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(2), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(3), "", false)
    endfunction

//library UnitTestFramwork ends
//library UnitUtils:
        function s__unitAttrObserver_registerAttackInterval takes code func returns nothing
            if ( s__unitAttrObserver_attackIntervalCB == null ) then
                set s__unitAttrObserver_attackIntervalCB=CreateTrigger()
            endif
            call TriggerAddCondition(s__unitAttrObserver_attackIntervalCB, Condition(func))
        endfunction
    function GetUnitAttack takes unit u returns integer
        return R2I(GetUnitState(u, ConvertUnitState(0x12)))
    endfunction
    function GetUnitDefense takes unit u returns integer
        return R2I(GetUnitState(u, ConvertUnitState(0x20)))
    endfunction
    function GetUnitHP takes unit u returns real
        return GetUnitState(u, UNIT_STATE_MAX_LIFE)
    endfunction
    function GetUnitMP takes unit u returns real
        return GetUnitState(u, UNIT_STATE_MAX_MANA)
    endfunction  //设置攻击力
    function SetUnitAttack takes unit u,real attack returns nothing
        call SetUnitState(u, ConvertUnitState(0x12), attack)
    endfunction  //增加攻击力
    function AddUnitAttack takes unit u,real attack returns nothing
        call SetUnitAttack(u , GetUnitAttack(u) + attack)
    endfunction  //设置防御
    function SetUnitDefense takes unit u,real defense returns nothing
        call SetUnitState(u, ConvertUnitState(0x20), defense)
    endfunction  //增加防御
    function AddUnitDefense takes unit u,real defense returns nothing
        call SetUnitDefense(u , GetUnitDefense(u) + defense)
    endfunction  //修改生命最大值
    function SetUnitHP takes unit u,real hp returns nothing
        call SetUnitState(u, UNIT_STATE_MAX_LIFE, RMaxBJ(hp, 2.0))
    endfunction  //增加生命最大值
    function AddUnitHP takes unit u,real hp returns nothing
        call SetUnitHP(u , RMaxBJ(GetUnitHP(u) + hp, 10.0))
        if ( hp > 0 ) then
            call SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState(u, UNIT_STATE_LIFE) + hp))
        endif
    endfunction  //回血(定值)
    function RegenUnitHP takes unit u,real volume returns nothing
        call SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState(u, UNIT_STATE_LIFE) + volume))
    endfunction  //回蓝(百分比)
    function RegenUnitHPPercent takes unit u,real rate returns nothing
        call SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState(u, UNIT_STATE_LIFE) + GetUnitHP(u) * rate))
    endfunction  //设置魔法最大值
    function SetUnitMP takes unit u,real mp returns nothing
        call SetUnitState(u, UNIT_STATE_MAX_MANA, mp)
    endfunction  //增加魔法最大值
    function AddUnitMP takes unit u,real mp returns nothing
        call SetUnitMP(u , GetUnitMP(u) + mp)
        if ( mp > 0 ) then
            call SetUnitState(u, UNIT_STATE_MANA, RMaxBJ(0, GetUnitState(u, UNIT_STATE_MANA) + mp))
        endif
    endfunction  //回蓝(定值)
    function RegenUnitMP takes unit u,real volume returns nothing
        call SetUnitState(u, UNIT_STATE_MANA, RMaxBJ(0, GetUnitState(u, UNIT_STATE_MANA) + volume))
    endfunction  //回蓝(百分比)
    function RegenUnitMPPercent takes unit u,real rate returns nothing
        call SetUnitState(u, UNIT_STATE_MANA, RMaxBJ(0, GetUnitState(u, UNIT_STATE_MANA) + GetUnitMP(u) * rate))
    endfunction  // 获取移速
    function GetUnitSpeed takes unit u returns integer
        if ( HaveSavedInteger(HASH_UNIT, GetHandleId(u), 237960560) ) then
            return LoadInteger(HASH_UNIT, GetHandleId(u), 237960560)
        else
            return R2I(GetUnitMoveSpeed(u))
        endif
    endfunction  //todo: 这个UNTable其他地图需要兼容
    function AddUnitSpeed takes unit u,integer speed returns nothing
        local integer value
        if ( HaveSavedInteger(HASH_UNIT, GetHandleId(u), 237960560) ) then
            set value=LoadInteger(HASH_UNIT, GetHandleId(u), 237960560)
            set value=value + speed
            call SaveInteger(HASH_UNIT, GetHandleId(u), 237960560, value)
        else
            set value=R2I(GetUnitMoveSpeed(u)) + speed
        endif
        call SetUnitMoveSpeed(u, value)
    endfunction  // 初始化突破移速
    function InitUnitSpeed takes unit u returns nothing
        call SaveInteger(HASH_UNIT, GetHandleId(u), 237960560, R2I(GetUnitMoveSpeed(u)))
    endfunction  //射程(还会+警戒范围)
    function GetUnitAttackRange takes unit u returns real
        return GetUnitState(u, ConvertUnitState(0x16))
    endfunction  //设置射程(还会设置警戒范围)
    function SetUnitAttackRange takes unit u,real range returns nothing
        call SetUnitState(u, ConvertUnitState(0x16), range)
        call SetUnitAcquireRange(u, RMaxBJ(range, 900.0))
    endfunction  //增加射程(还会+警戒范围)
    function AddUnitAttackRange takes unit u,real range returns nothing
        call SetUnitState(u, ConvertUnitState(0x16), GetUnitAttackRange(u) + range)
        call SetUnitAcquireRange(u, RMaxBJ(GetUnitAcquireRange(u) + range, 900.0))
    endfunction  // 获取攻速
    function GetUnitAttackSpeed takes unit u returns real
        return GetUnitState(u, ConvertUnitState(0x51))
    endfunction  // 增加攻速
    function AddUnitAttackSpeed takes unit u,real speed returns nothing
        call SetUnitState(u, ConvertUnitState(0x51), GetUnitState(u, ConvertUnitState(0x51)) + speed)
    endfunction  // (获取缓存的攻击间隔(可能为负))
    function GetUnitAttackIntervalCache takes unit u returns real
        return LoadReal(HASH_UNIT, GetHandleId(u), 255610124)
    endfunction  // (获取单位的攻击间隔,不会小于0.1)
    function GetUnitAttackInterval takes unit u returns real
        return GetUnitState(u, ConvertUnitState(0x25))
    endfunction  // 攻击间隔(虽然写着加,但是实际是减) - 带最小值与观察者
    function AddAttackInterval takes unit u,real value returns nothing
        local real cacheValue
        local real newValue
        local integer uid
        set uid=GetHandleId(u) // 检查是否已初始化缓存
        if ( not ( HaveSavedReal(HASH_UNIT, uid, 255610124) ) ) then // 如果没有初始化，先保存当前攻击间隔到缓存
            call SaveReal(HASH_UNIT, uid, 255610124, GetUnitAttackInterval(u))
        endif // 获取当前缓存值并添加新值
        set cacheValue=LoadReal(HASH_UNIT, uid, 255610124)
        set cacheValue=cacheValue + value // 更新缓存
        call SaveReal(HASH_UNIT, uid, 255610124, cacheValue) // 设置实际攻击间隔（确保不小于MIN_ATTACK_INTERVAL）
        set newValue=RMaxBJ(cacheValue, 0.2)
        call SetUnitState(u, ConvertUnitState(0x25), newValue) // 观察者模式回调
        if ( s__unitAttrObserver_attackIntervalCB != null ) then
            set s__unitAttrObserver_argsU=u
            call TriggerEvaluate(s__unitAttrObserver_attackIntervalCB)
        endif
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
        call FlushChildHashtable(HASH_UNIT, GetHandleId(u))
        call RemoveUnit(u)
    endfunction

//library UnitUtils ends
//library YDLua:

    function initializeLua takes nothing returns integer
        call Cheat("exec-lua:plugin_main")
        return 0
    endfunction
        function YDLua__anon__0 takes nothing returns nothing
            call BJDebugMsg("调用了YDLua引擎")
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
    function YDLua__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr, 0.0, false)
        call TriggerAddCondition(tr, Condition(function YDLua__anon__0))
        set tr=null
    endfunction

//library YDLua ends
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
            if ( IsEnemy(GetFilterUnit() , GroupUtils__tempP) ) then
                return true
            endif
            return false
        endfunction
    function GetEnemyGroup takes player p,real x,real y,real radius returns group
        set GroupUtils__tempG=CreateGroup()
        set GroupUtils__tempP=p
        call GroupEnumUnitsInRangeEx(GroupUtils__tempG , x , y , radius , Filter(function GroupUtils__anon__0))
        set GroupUtils__tempP=null
        return GroupUtils__tempG
    endfunction  //获取圆形随机单位
    function GetRandomEnemy takes player p,real x,real y,real radius returns unit
        return GroupPickRandomUnit(GetEnemyGroup(p , x , y , radius))
    endfunction  //复制单位组
    function CopyGroup takes group g1 returns group
        set GroupUtils__tempG=CreateGroup()
        call GroupAddGroup(g1, GroupUtils__tempG)
        return GroupUtils__tempG
    endfunction

//library GroupUtils ends
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
                function s__hardware_anon__1 takes nothing returns nothing
                    call TriggerEvaluate(s__hardware_trWheel)
                endfunction  // 帧绘制事件
                function s__hardware_anon__2 takes nothing returns nothing
                    call TriggerEvaluate(s__hardware_trUpdate)
                endfunction  // 窗口大小变化事件
                function s__hardware_anon__3 takes nothing returns nothing
                    call TriggerEvaluate(s__hardware_trResize)
                endfunction  // 鼠标移动事件
                function s__hardware_anon__4 takes nothing returns nothing
                    call TriggerEvaluate(s__hardware_trMove)
                endfunction
            function s__hardware_anon__0 takes nothing returns nothing
                call DzTriggerRegisterMouseWheelEventByCode(null, false, function s__hardware_anon__1)
                call DzFrameSetUpdateCallbackByCode(function s__hardware_anon__2)
                call DzTriggerRegisterWindowResizeEventByCode(null, false, function s__hardware_anon__3)
                call DzTriggerRegisterMouseMoveEventByCode(null, false, function s__hardware_anon__4)
                call DestroyTrigger(GetTriggeringTrigger())
            endfunction
        function s__hardware_onInit takes nothing returns nothing
            local trigger tr=CreateTrigger()
            call TriggerRegisterTimerEvent(tr, 0.0, false)
            call TriggerAddCondition(tr, Condition(function s__hardware_anon__0))
            set tr=null
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
    function Logger__onInit takes nothing returns nothing
        call Cheat("exec-lua:depends.debug.logger")
    endfunction

//library Logger ends
//library CameraControl:

        function s__cameraControl_openWheel takes nothing returns nothing
            call DoNothing()
        endfunction
        function s__cameraControl_lockHeight takes nothing returns nothing
            set CameraControl__HeightLocked=true
        endfunction
        function s__cameraControl_unlockHeight takes nothing returns nothing
            set CameraControl__HeightLocked=false
        endfunction
        function s__cameraControl_isHeightLocked takes nothing returns boolean
            return CameraControl__HeightLocked
        endfunction
        function s__cameraControl_initCamera takes player p returns nothing
            if ( GetLocalPlayer() != p ) then
                return
            endif
            set CameraControl__ResetCam=true // 增加1000高度（1000/200=5）
            set CameraControl__ViewLevel=CameraControl__ViewLevel + 5
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, CameraControl__ViewLevel * 200, 0.1)
            set CameraControl__X_ANGLE=Rad2Deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK))
        endfunction  // 增加镜头高度400（仅对指定玩家生效）
        function s__cameraControl_increaseHeight takes player p returns nothing
            if ( GetLocalPlayer() != p ) then
                return
            endif
            set CameraControl__ResetCam=true // 确保不超过上限（3600-400=3200，3200/200=16）
            if ( CameraControl__ViewLevel < 16 ) then // 增加400高度（400/200=2）
                set CameraControl__ViewLevel=CameraControl__ViewLevel + 2
                call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, CameraControl__ViewLevel * 200, 0.1)
                set CameraControl__X_ANGLE=Rad2Deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK))
            endif
        endfunction  // 减少镜头高度400（仅对指定玩家生效）
        function s__cameraControl_decreaseHeight takes player p returns nothing
            if ( GetLocalPlayer() != p ) then
                return
            endif
            set CameraControl__ResetCam=true // 确保不低于下限（600+400=1000，1000/200=5）
            if ( CameraControl__ViewLevel > 5 ) then // 减少400高度（400/200=2）
                set CameraControl__ViewLevel=CameraControl__ViewLevel - 2
                call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, CameraControl__ViewLevel * 200, 0.1)
                set CameraControl__X_ANGLE=Rad2Deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK))
            endif
        endfunction
        function CameraControl__anon__0 takes nothing returns nothing
            local integer delta=DzGetWheelDelta()
            if ( ( not ( DzIsMouseOverUI() ) ) or DzGetMouseFocus() != 0 ) then //标记需要重置镜头属性
                return
            endif
            set CameraControl__ResetCam=true
            if ( not CameraControl__HeightLocked ) then // 使用 600 ~ 3600 的高度范围（步长 200）
                if ( delta < 0 ) then //滚轮下滑 -> 拉远 //上限 3600/200=18
                    if ( CameraControl__ViewLevel < 18 ) then //滚轮上滑 -> 拉近
                        set CameraControl__ViewLevel=CameraControl__ViewLevel + 1
                    endif
                elseif ( CameraControl__ViewLevel > 3 ) then //下限 600/200=3
                    set CameraControl__ViewLevel=CameraControl__ViewLevel - 1
                endif
            else // 锁定时维持当前高度
                call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, CameraControl__ViewLevel * 200, 0.1)
            endif //记录滚动前的镜头角度
            set CameraControl__X_ANGLE=Rad2Deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK))
        endfunction  //注册每帧渲染事件
        function CameraControl__anon__1 takes nothing returns nothing
            if ( CameraControl__ResetCam ) then
                call SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, CameraControl__X_ANGLE, 0)
                call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, CameraControl__ViewLevel * 200, CameraControl__WheelSpeed)
                set CameraControl__ResetCam=false
            endif
        endfunction  //注册按下键码为145的按键(ScrollLock)事件
        function CameraControl__anon__2 takes nothing returns nothing
            set CameraControl__WideScr=not CameraControl__WideScr
            call DzEnableWideScreen(CameraControl__WideScr)
        endfunction
    function CameraControl__onInit takes nothing returns nothing
        call s__hardware_regWheelEvent(function CameraControl__anon__0)
        call s__hardware_regUpdateEvent(function CameraControl__anon__1)
        call DzTriggerRegisterKeyEventByCode(null, 145, 1, false, function CameraControl__anon__2)
    endfunction

//library CameraControl ends
//library DamageUtils:
    function DamageUtils__LS_begin takes unit src returns nothing
        set DamageUtils__lsTop=DamageUtils__lsTop + 1
        set DamageUtils__lsSource[DamageUtils__lsTop]=src
        set DamageUtils__lsTotal[DamageUtils__lsTop]=0.0
    endfunction
    function DamageUtils__LS_end takes nothing returns real
        local real dealt
        if ( DamageUtils__lsTop < 0 ) then
            return 0.0
        endif
        set dealt=DamageUtils__lsTotal[DamageUtils__lsTop]
        set DamageUtils__lsSource[DamageUtils__lsTop]=null
        set DamageUtils__lsTotal[DamageUtils__lsTop]=0.0
        set DamageUtils__lsTop=DamageUtils__lsTop - 1
        return dealt
    endfunction
    function SingleDamageLSIsActive takes unit src returns boolean
        if ( DamageUtils__lsTop < 0 ) then
            return false
        endif
        return DamageUtils__lsSource[DamageUtils__lsTop] == src
    endfunction
    function SingleDamageLSAdd takes real amount returns nothing
        if ( DamageUtils__lsTop < 0 ) then
            return
        endif
        if ( amount > 0.0 ) then
            set DamageUtils__lsTotal[DamageUtils__lsTop]=DamageUtils__lsTotal[DamageUtils__lsTop] + amount
        endif
    endfunction  //旧名替换:DamageSingle
    function ApplyPhysicalDamage takes unit u,unit target,real dmg returns nothing
        local real dealt
        if ( DamageUtils__TrLifeSteal != null ) then
            call DamageUtils__LS_begin(u)
            call UnitDamageTarget(u, target, dmg, false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
            set dealt=DamageUtils__LS_end() //触发回调
            set DamageUtils__uArgs=u //回调参数 //回调参数
            set DamageUtils__rArgs=dealt
            call TriggerEvaluate(DamageUtils__TrLifeSteal)
            set DamageUtils__uArgs=null
            set DamageUtils__rArgs=0.
        else
            call UnitDamageTarget(u, target, dmg, false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
        endif
    endfunction  //单体伤害:魔法
    function ApplyMagicDamage takes unit u,unit target,real dmg returns nothing
        local real dealt
        if ( DamageUtils__TrLifeSteal != null ) then
            call DamageUtils__LS_begin(u)
            call UnitDamageTarget(u, target, dmg, false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            set dealt=DamageUtils__LS_end() //触发回调
            set DamageUtils__uArgs=u //回调参数 //回调参数
            set DamageUtils__rArgs=dealt
            call TriggerEvaluate(DamageUtils__TrLifeSteal)
            set DamageUtils__uArgs=null
            set DamageUtils__rArgs=0.
        else
            call UnitDamageTarget(u, target, dmg, false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        endif
    endfunction  //单体伤害:真实
    function ApplyPureDamage takes unit u,unit target,real dmg returns nothing
        local real dealt
        if ( DamageUtils__TrLifeSteal != null ) then
            call DamageUtils__LS_begin(u)
            call UnitDamageTarget(u, target, dmg, false, true, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_SLOW_POISON, WEAPON_TYPE_WHOKNOWS)
            set dealt=DamageUtils__LS_end() //触发回调
            set DamageUtils__uArgs=u //回调参数 //回调参数
            set DamageUtils__rArgs=dealt
            call TriggerEvaluate(DamageUtils__TrLifeSteal)
            set DamageUtils__uArgs=null
            set DamageUtils__rArgs=0.
        else
            call UnitDamageTarget(u, target, dmg, false, true, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_SLOW_POISON, WEAPON_TYPE_WHOKNOWS)
        endif
    endfunction  //模拟普攻(最后一个参数代表额外的终伤,0)
    function SimulateBasicAttack takes unit u,unit target,real fd returns nothing
        call UnitDamageTarget(u, target, GetUnitState(u, ConvertUnitState(0x12)) * ( 1.0 + fd ), true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
    endfunction  // 伤害参数结构体
        function s__DmgP_onDestroy takes integer this returns nothing
            set s__DmgP_source[this]=null // this.eft = null; // 可选
        endfunction

//Generated destructor of DmgP
function s__DmgP_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: DmgP")
        return
    elseif (si__DmgP_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: DmgP")
        return
    endif
    call s__DmgP_onDestroy(this)
    set si__DmgP_V[this]=si__DmgP_F
    set si__DmgP_F=this
endfunction
        function s__DmgS_push takes integer params returns nothing
            if ( s__DmgS_top >= 8190 ) then // 调试期提示或直接 return，避免越界
                call BJDebugMsg("DmgS overflow")
                return
            endif
            set s__DmgS_top=s__DmgS_top + 1
            set s__DmgS_stack[s__DmgS_top]=params
        endfunction
        function s__DmgS_pop takes nothing returns integer
            local integer params=s__DmgS_stack[s__DmgS_top]
            if ( s__DmgS_top < 0 ) then
                call BJDebugMsg("DmgS underflow")
                return 0
            endif
            set s__DmgS_stack[s__DmgS_top]=0
            set s__DmgS_top=s__DmgS_top - 1
            return params
        endfunction
        function s__DmgS_current takes nothing returns integer
            return s__DmgS_stack[s__DmgS_top]
        endfunction  // 是否存在可用的上下文，且开启了技能吸血聚合，并且来源匹配
        function s__DmgS_hasAggregation takes unit src returns boolean
            local integer p
            if ( s__DmgS_top < 0 ) then
                return false
            endif
            set p=s__DmgS_stack[s__DmgS_top]
            return s__DmgP_enableLifestealAggregation[p] and s__DmgP_source[p] == src
        endfunction  // 聚合一次最终造成的伤害（由 DamageSystem 在事件最终阶段调用）
        function s__DmgS_aggregate takes real amount returns nothing
            local integer p
            if ( s__DmgS_top < 0 ) then
                return
            endif
            set p=s__DmgS_stack[s__DmgS_top]
            if ( s__DmgP_enableLifestealAggregation[p] and amount > 0 ) then
                set s__DmgP_lifestealDealtTotal[p]=s__DmgP_lifestealDealtTotal[p] + amount // 写回（结构体为值语义）
                set s__DmgS_stack[s__DmgS_top]=p
            endif
        endfunction
        function DamageUtils__anon__0 takes nothing returns boolean
            local integer current=s__DmgS_current()
            if ( IsEnemy(GetFilterUnit() , GetOwningPlayer(s__DmgP_source[current])) ) then
                call UnitDamageTarget(s__DmgP_source[current], GetFilterUnit(), s__DmgP_damage[current], false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                if ( s__DmgP_eft[current] != null ) then
                    call DestroyEffect(AddSpecialEffect(s__DmgP_eft[current], GetUnitX(GetFilterUnit()), GetUnitY(GetFilterUnit())))
                endif
                return true
            endif
            return false
        endfunction
    function DamageAreaPhysical takes unit u,real x,real y,real radius,real damage,string efx returns nothing
        local group g
        local real dealt
        local integer params
        set g=CreateGroup()
        set params=s__DmgP__allocate()
        set s__DmgP_source[params]=u
        set s__DmgP_eft[params]=efx
        set s__DmgP_damage[params]=damage
        set s__DmgP_enableLifestealAggregation[params]=( DamageUtils__TrLifeSteal != null )
        set s__DmgP_lifestealDealtTotal[params]=0.0
        call s__DmgS_push(params)
        call GroupEnumUnitsInRangeEx(g , x , y , radius , Filter(function DamageUtils__anon__0))
        set params=s__DmgS_pop()
        set dealt=s__DmgP_lifestealDealtTotal[params]
        call s__DmgP_deallocate(params)
        call DestroyGroup(g)
        set g=null // 如果有吸血回调且造成了伤害，触发回调
        if ( DamageUtils__TrLifeSteal != null and dealt > 0.0 ) then
            set DamageUtils__uArgs=u
            set DamageUtils__rArgs=dealt
            call TriggerEvaluate(DamageUtils__TrLifeSteal)
            set DamageUtils__uArgs=null
            set DamageUtils__rArgs=0.
        endif
    endfunction  //范围魔法伤害
        function DamageUtils__anon__1 takes nothing returns boolean
            local integer current=s__DmgS_current()
            if ( IsEnemy(GetFilterUnit() , GetOwningPlayer(s__DmgP_source[current])) ) then
                call UnitDamageTarget(s__DmgP_source[current], GetFilterUnit(), s__DmgP_damage[current], false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
                if ( s__DmgP_eft[current] != null ) then
                    call DestroyEffect(AddSpecialEffect(s__DmgP_eft[current], GetUnitX(GetFilterUnit()), GetUnitY(GetFilterUnit())))
                endif
                return true
            endif
            return false
        endfunction
    function DamageAreaMagic takes unit u,real x,real y,real radius,real damage,string efx returns nothing
        local group g
        local real dealt
        local integer params
        set g=CreateGroup()
        set params=s__DmgP__allocate()
        set s__DmgP_source[params]=u
        set s__DmgP_eft[params]=efx
        set s__DmgP_damage[params]=damage
        set s__DmgP_enableLifestealAggregation[params]=( DamageUtils__TrLifeSteal != null )
        set s__DmgP_lifestealDealtTotal[params]=0.0
        call s__DmgS_push(params)
        call GroupEnumUnitsInRangeEx(g , x , y , radius , Filter(function DamageUtils__anon__1))
        set params=s__DmgS_pop()
        set dealt=s__DmgP_lifestealDealtTotal[params]
        call s__DmgP_deallocate(params)
        call DestroyGroup(g)
        set g=null // 如果有吸血回调且造成了伤害，触发回调
        if ( DamageUtils__TrLifeSteal != null and dealt > 0.0 ) then
            set DamageUtils__uArgs=u
            set DamageUtils__rArgs=dealt
            call TriggerEvaluate(DamageUtils__TrLifeSteal)
            set DamageUtils__uArgs=null
            set DamageUtils__rArgs=0.
        endif
    endfunction  //范围真实伤害
        function DamageUtils__anon__2 takes nothing returns boolean
            local integer current=s__DmgS_current()
            if ( IsEnemy(GetFilterUnit() , GetOwningPlayer(s__DmgP_source[current])) ) then
                call UnitDamageTarget(s__DmgP_source[current], GetFilterUnit(), s__DmgP_damage[current], false, true, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_SLOW_POISON, WEAPON_TYPE_WHOKNOWS)
                if ( s__DmgP_eft[current] != null ) then
                    call DestroyEffect(AddSpecialEffect(s__DmgP_eft[current], GetUnitX(GetFilterUnit()), GetUnitY(GetFilterUnit())))
                endif
                return true
            endif
            return false
        endfunction
    function DamageAreaPure takes unit u,real x,real y,real radius,real damage,string efx returns nothing
        local group g
        local real dealt
        local integer params
        set g=CreateGroup()
        set params=s__DmgP__allocate()
        set s__DmgP_source[params]=u
        set s__DmgP_eft[params]=efx
        set s__DmgP_damage[params]=damage
        set s__DmgP_enableLifestealAggregation[params]=( DamageUtils__TrLifeSteal != null )
        set s__DmgP_lifestealDealtTotal[params]=0.0
        call s__DmgS_push(params)
        call GroupEnumUnitsInRangeEx(g , x , y , radius , Filter(function DamageUtils__anon__2))
        set params=s__DmgS_pop()
        set dealt=s__DmgP_lifestealDealtTotal[params]
        call s__DmgP_deallocate(params)
        call DestroyGroup(g)
        set g=null // 如果有吸血回调且造成了伤害，触发回调
        if ( DamageUtils__TrLifeSteal != null and dealt > 0.0 ) then
            set DamageUtils__uArgs=u
            set DamageUtils__rArgs=dealt
            call TriggerEvaluate(DamageUtils__TrLifeSteal)
            set DamageUtils__uArgs=null
            set DamageUtils__rArgs=0.
        endif
    endfunction  //范围秒杀
        function DamageUtils__anon__3 takes nothing returns boolean
            local integer current=s__DmgS_current()
            if ( IsEnemy(GetFilterUnit() , GetOwningPlayer(s__DmgP_source[current])) ) then
                call UnitDamageTarget(s__DmgP_source[current], GetFilterUnit(), GetUnitState(GetFilterUnit(), UNIT_STATE_MAX_LIFE) * 1.2, false, true, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_SLOW_POISON, WEAPON_TYPE_WHOKNOWS)
                if ( s__DmgP_eft[current] != null ) then
                    call DestroyEffect(AddSpecialEffect(s__DmgP_eft[current], GetUnitX(GetFilterUnit()), GetUnitY(GetFilterUnit())))
                endif
                return true
            endif
            return false
        endfunction
    function DamageAreaKill takes unit u,real x,real y,real radius,string efx returns nothing
        local group g
        local real dealt
        local integer params
        set g=CreateGroup()
        set params=s__DmgP__allocate()
        set s__DmgP_source[params]=u
        set s__DmgP_eft[params]=efx
        set s__DmgP_enableLifestealAggregation[params]=( DamageUtils__TrLifeSteal != null )
        set s__DmgP_lifestealDealtTotal[params]=0.0
        call s__DmgS_push(params)
        call GroupEnumUnitsInRangeEx(g , x , y , radius , Filter(function DamageUtils__anon__3))
        set params=s__DmgS_pop()
        set dealt=s__DmgP_lifestealDealtTotal[params]
        call s__DmgP_deallocate(params)
        call DestroyGroup(g)
        set g=null // 如果有吸血回调且造成了伤害，触发回调
        if ( DamageUtils__TrLifeSteal != null and dealt > 0.0 ) then
            set DamageUtils__uArgs=u
            set DamageUtils__rArgs=dealt
            call TriggerEvaluate(DamageUtils__TrLifeSteal)
            set DamageUtils__uArgs=null
            set DamageUtils__rArgs=0.
        endif
    endfunction  //回调触发器
    function RegisterDamageLifeSteal takes code func returns nothing
        if ( DamageUtils__TrLifeSteal == null ) then
            set DamageUtils__TrLifeSteal=CreateTrigger()
        endif
        call TriggerAddCondition(DamageUtils__TrLifeSteal, Condition(func))
    endfunction  //吸血的单位
    function GetDamageLifeStealUnit takes nothing returns unit
        return DamageUtils__uArgs
    endfunction
    function GetDamageLifeStealReal takes nothing returns real
        return DamageUtils__rArgs
    endfunction

//library DamageUtils ends
//library UTDamageUtils:

        function UTDamageUtils__anon__0 takes nothing returns nothing
            local unit u=GetEnumUnit()
            if ( GetUnitTypeId(u) == 'opeo' or GetUnitTypeId(u) == 'hpea' ) then
                call RemoveUnit(u)
            endif
            set u=null
        endfunction
    function UTDamageUtils__CreateTestEnv takes player p returns nothing
        local real x=GetPlayerStartLocationX(p)
        local real y=GetPlayerStartLocationY(p)
        local real angle
        local integer i
        local group g=CreateGroup()
        local unit dummy
        call GroupEnumUnitsInRange(g, x, y, 1000, null)
        call ForGroup(g, function UTDamageUtils__anon__0)
        call DestroyGroup(g)
        set g=null
        set UTDamageUtils__testDummy=null
        set UTDamageUtils__testSource=null // 创建中心苦工单位
        set UTDamageUtils__testDummy=CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'opeo', x + 200, y, 270)
        call SetUnitInvulnerable(UTDamageUtils__testDummy, false)
        call SetUnitState(UTDamageUtils__testDummy, UNIT_STATE_LIFE, GetUnitState(UTDamageUtils__testDummy, UNIT_STATE_MAX_LIFE)) // 注册伤害事件
        call TriggerRegisterUnitEvent(UTDamageUtils__damageEventTrigger, UTDamageUtils__testDummy, EVENT_UNIT_DAMAGED) // 创建环形分布的额外苦工
        set i=0
        loop
        exitwhen ( i >= 8 )
            set angle=i * 45.0 * 0.0174538
            set dummy=CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'opeo', x + 200 + UTDamageUtils__testRadius * Cos(angle), y + UTDamageUtils__testRadius * Sin(angle), 270)
            call TriggerRegisterUnitEvent(UTDamageUtils__damageEventTrigger, dummy, EVENT_UNIT_DAMAGED) // 为每个苦工注册伤害事件
        set i=i + 1
        endloop // 创建伤害源(农民)
        set UTDamageUtils__testSource=CreateUnit(p, 'hpea', x, y, 90)
        call SetUnitAttack(UTDamageUtils__testSource , 50) // 为农民也注册伤害事件
        call TriggerRegisterUnitEvent(UTDamageUtils__damageEventTrigger, UTDamageUtils__testSource, EVENT_UNIT_DAMAGED)
    endfunction  // 测试物理伤害
    function UTDamageUtils__TTestUTDamageUtils1 takes player p returns nothing
        call UTDamageUtils__CreateTestEnv(p)
        call Trace("测试物理伤害: " + R2S(UTDamageUtils__testDamage))
        call ApplyPhysicalDamage(UTDamageUtils__testSource , UTDamageUtils__testDummy , UTDamageUtils__testDamage)
    endfunction  // 测试真实伤害
    function UTDamageUtils__TTestUTDamageUtils2 takes player p returns nothing
        call UTDamageUtils__CreateTestEnv(p)
        call Trace("测试真实伤害: " + R2S(UTDamageUtils__testDamage))
        call ApplyPureDamage(UTDamageUtils__testSource , UTDamageUtils__testDummy , UTDamageUtils__testDamage)
    endfunction  // 测试模拟普攻
    function UTDamageUtils__TTestUTDamageUtils3 takes player p returns nothing
        call UTDamageUtils__CreateTestEnv(p)
        call Trace("测试模拟普攻，基础攻击: 50")
        call SimulateBasicAttack(UTDamageUtils__testSource , UTDamageUtils__testDummy , 0)
    endfunction  // 测试范围物理伤害
    function UTDamageUtils__TTestUTDamageUtils4 takes player p returns nothing
        call UTDamageUtils__CreateTestEnv(p)
        call Trace("测试范围物理伤害: " + R2S(UTDamageUtils__testDamage) + " 范围: " + R2S(UTDamageUtils__testRadius))
        call Trace("中心点有1个假人，半径 " + R2S(UTDamageUtils__testRadius) + " 处有8个假人")
        call Trace("范围内的假人都会受到伤害和特效")
        call DamageAreaPhysical(UTDamageUtils__testSource , GetUnitX(UTDamageUtils__testSource) , GetUnitY(UTDamageUtils__testSource) , UTDamageUtils__testRadius , UTDamageUtils__testDamage , UTDamageUtils__testEffect)
    endfunction  // 测试范围真实伤害
    function UTDamageUtils__TTestUTDamageUtils5 takes player p returns nothing
        call UTDamageUtils__CreateTestEnv(p)
        call Trace("测试范围真实伤害: " + R2S(UTDamageUtils__testDamage) + " 范围: " + R2S(UTDamageUtils__testRadius))
        call Trace("中心点有1个假人，半径 " + R2S(UTDamageUtils__testRadius) + " 处有8个假人")
        call Trace("范围内的假人都会受到伤害和特效")
        call DamageAreaPure(UTDamageUtils__testSource , GetUnitX(UTDamageUtils__testSource) , GetUnitY(UTDamageUtils__testSource) , UTDamageUtils__testRadius , UTDamageUtils__testDamage , UTDamageUtils__testEffect)
    endfunction  // 测试伤害显示开关
    function UTDamageUtils__TTestUTDamageUtils6 takes player p returns nothing
        set UTDamageUtils__isShowDamage=not UTDamageUtils__isShowDamage
        if ( UTDamageUtils__isShowDamage ) then
            call Trace("|cff00ff00开启|r伤害数值显示")
        else
            call Trace("|cffff0000关闭|r伤害数值显示")
        endif
    endfunction  // 测试反伤开关
    function UTDamageUtils__TTestUTDamageUtils7 takes player p returns nothing
        set UTDamageUtils__isReflectDamage=not UTDamageUtils__isReflectDamage
        if ( UTDamageUtils__isReflectDamage ) then // 重置反伤计数
            set UTDamageUtils__reflectCount=0
            call Trace("|cff00ff00开启|r伤害反弹测试 - 受伤单位将反弹50%伤害(最多5次)")
        else
            call Trace("|cffff0000关闭|r伤害反弹测试")
        endif
    endfunction  // 测试范围秒杀
    function UTDamageUtils__TTestUTDamageUtils8 takes player p returns nothing
        call UTDamageUtils__CreateTestEnv(p)
        call Trace("测试范围秒杀: 范围 " + R2S(UTDamageUtils__testRadius))
        call Trace("中心点有1个假人，半径 " + R2S(UTDamageUtils__testRadius) + " 处有8个假人")
        call Trace("范围内的假人都会被秒杀")
        call DamageAreaKill(UTDamageUtils__testSource , GetUnitX(UTDamageUtils__testSource) , GetUnitY(UTDamageUtils__testSource) , UTDamageUtils__testRadius , UTDamageUtils__testEffect)
    endfunction  // 切换吸血回调测试
        function UTDamageUtils__anon__1 takes nothing returns boolean
            local unit u
            local real damage
            local real heal
            set u=GetDamageLifeStealUnit()
            set damage=GetDamageLifeStealReal() // 30%吸血率
            set heal=damage * 0.3
            if ( u != null and heal > 0.0 ) then
                call SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_LIFE) + heal)
                set UTDamageUtils__totalLifesteal=UTDamageUtils__totalLifesteal + heal
                call Trace("|cff00ff88吸血|r - " + GetUnitName(u) + " 造成伤害: " + R2S(damage) + ", 回血: " + R2S(heal) + ", 累计: " + R2S(UTDamageUtils__totalLifesteal))
            endif
            set u=null
            return true
        endfunction
    function UTDamageUtils__TTestUTDamageUtils9 takes player p returns nothing
        set UTDamageUtils__isLifestealEnabled=not UTDamageUtils__isLifestealEnabled
        if ( UTDamageUtils__isLifestealEnabled ) then
            set UTDamageUtils__totalLifesteal=0.0
            call Trace("|cff00ff00开启|r吸血回调测试 - 伤害后将按照实际伤害的30%进行回血")
            call RegisterDamageLifeSteal(function UTDamageUtils__anon__1)
        else
            call Trace("|cffff0000关闭|r吸血回调测试") // 注意: 这里不能取消注册，因为没有提供取消接口
        endif
    endfunction  // 测试物理伤害(带吸血)
    function UTDamageUtils__TTestUTDamageUtils10 takes player p returns nothing
        call UTDamageUtils__CreateTestEnv(p)
        if ( not UTDamageUtils__isLifestealEnabled ) then
            call Trace("|cffff0000警告|r: 请先使用 s9 开启吸血回调测试")
            return
        endif
        call Trace("测试物理伤害(带吸血): " + R2S(UTDamageUtils__testDamage))
        call ApplyPhysicalDamage(UTDamageUtils__testSource , UTDamageUtils__testDummy , UTDamageUtils__testDamage)
    endfunction  // 测试魔法伤害(带吸血)
    function UTDamageUtils__TTestUTDamageUtils11 takes player p returns nothing
        call UTDamageUtils__CreateTestEnv(p)
        if ( not UTDamageUtils__isLifestealEnabled ) then
            call Trace("|cffff0000警告|r: 请先使用 s9 开启吸血回调测试")
            return
        endif
        call Trace("测试魔法伤害(带吸血): " + R2S(UTDamageUtils__testDamage))
        call ApplyMagicDamage(UTDamageUtils__testSource , UTDamageUtils__testDummy , UTDamageUtils__testDamage)
    endfunction  // 测试真实伤害(带吸血)
    function UTDamageUtils__TTestUTDamageUtils12 takes player p returns nothing
        call UTDamageUtils__CreateTestEnv(p)
        if ( not UTDamageUtils__isLifestealEnabled ) then
            call Trace("|cffff0000警告|r: 请先使用 s9 开启吸血回调测试")
            return
        endif
        call Trace("测试真实伤害(带吸血): " + R2S(UTDamageUtils__testDamage))
        call ApplyPureDamage(UTDamageUtils__testSource , UTDamageUtils__testDummy , UTDamageUtils__testDamage)
    endfunction  // 测试范围物理伤害(带吸血)
    function UTDamageUtils__TTestUTDamageUtils13 takes player p returns nothing
        call UTDamageUtils__CreateTestEnv(p)
        if ( not UTDamageUtils__isLifestealEnabled ) then
            call Trace("|cffff0000警告|r: 请先使用 s9 开启吸血回调测试")
            return
        endif
        call Trace("测试范围物理伤害(带吸血): " + R2S(UTDamageUtils__testDamage) + " 范围: " + R2S(UTDamageUtils__testRadius))
        call Trace("中心点1个假人，半径 " + R2S(UTDamageUtils__testRadius) + " 处有8个假人")
        call Trace("范围内的假人都会受到伤害，并触发吸血回调")
        call DamageAreaPhysical(UTDamageUtils__testSource , GetUnitX(UTDamageUtils__testSource) , GetUnitY(UTDamageUtils__testSource) , UTDamageUtils__testRadius , UTDamageUtils__testDamage , UTDamageUtils__testEffect)
    endfunction  // 测试范围魔法伤害(带吸血)
    function UTDamageUtils__TTestUTDamageUtils14 takes player p returns nothing
        call UTDamageUtils__CreateTestEnv(p)
        if ( not UTDamageUtils__isLifestealEnabled ) then
            call Trace("|cffff0000警告|r: 请先使用 s9 开启吸血回调测试")
            return
        endif
        call Trace("测试范围魔法伤害(带吸血): " + R2S(UTDamageUtils__testDamage) + " 范围: " + R2S(UTDamageUtils__testRadius))
        call Trace("中心点1个假人，半径 " + R2S(UTDamageUtils__testRadius) + " 处有8个假人")
        call Trace("范围内的假人都会受到伤害，并触发吸血回调")
        call DamageAreaMagic(UTDamageUtils__testSource , GetUnitX(UTDamageUtils__testSource) , GetUnitY(UTDamageUtils__testSource) , UTDamageUtils__testRadius , UTDamageUtils__testDamage , UTDamageUtils__testEffect)
    endfunction  // 测试范围真实伤害(带吸血)
    function UTDamageUtils__TTestUTDamageUtils15 takes player p returns nothing
        call UTDamageUtils__CreateTestEnv(p)
        if ( not UTDamageUtils__isLifestealEnabled ) then
            call Trace("|cffff0000警告|r: 请先使用 s9 开启吸血回调测试")
            return
        endif
        call Trace("测试范围真实伤害(带吸血): " + R2S(UTDamageUtils__testDamage) + " 范围: " + R2S(UTDamageUtils__testRadius))
        call Trace("中心点1个假人，半径 " + R2S(UTDamageUtils__testRadius) + " 处有8个假人")
        call Trace("范围内的假人都会受到伤害，并触发吸血回调")
        call DamageAreaPure(UTDamageUtils__testSource , GetUnitX(UTDamageUtils__testSource) , GetUnitY(UTDamageUtils__testSource) , UTDamageUtils__testRadius , UTDamageUtils__testDamage , UTDamageUtils__testEffect)
    endfunction  // 测试范围秒杀(带吸血)
    function UTDamageUtils__TTestUTDamageUtils16 takes player p returns nothing
        call UTDamageUtils__CreateTestEnv(p)
        if ( not UTDamageUtils__isLifestealEnabled ) then
            call Trace("|cffff0000警告|r: 请先使用 s9 开启吸血回调测试")
            return
        endif
        call Trace("测试范围秒杀(带吸血): 范围 " + R2S(UTDamageUtils__testRadius))
        call Trace("中心点1个假人，半径 " + R2S(UTDamageUtils__testRadius) + " 处有8个假人")
        call Trace("范围内的假人都会被秒杀，并按照实际伤害触发吸血回调")
        call DamageAreaKill(UTDamageUtils__testSource , GetUnitX(UTDamageUtils__testSource) , GetUnitY(UTDamageUtils__testSource) , UTDamageUtils__testRadius , UTDamageUtils__testEffect)
    endfunction  // 处理参数设置命令
    function UTDamageUtils__TTestActUTDamageUtils1 takes string str returns nothing
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
        set num=num + 1 // 处理命令
        if ( paramS[0] == "d" ) then
            set UTDamageUtils__testDamage=paramR[1]
            call Trace("设置伤害值为: " + R2S(UTDamageUtils__testDamage))
        elseif ( paramS[0] == "r" ) then
            set UTDamageUtils__testRadius=paramR[1]
            call Trace("设置范围值为: " + R2S(UTDamageUtils__testRadius))
        elseif ( paramS[0] == "e" ) then
            set UTDamageUtils__testEffect=paramS[1]
            call Trace("设置特效为: " + UTDamageUtils__testEffect)
        endif
        set p=null
    endfunction
        function UTDamageUtils__anon__2 takes nothing returns nothing
            call Trace("|cff00ff00[DamageUtils测试]|r 输入以下命令进行测试:")
            call Trace("|cffaaaaaa=== 基础伤害测试 ===|r")
            call Trace("s1 - 测试物理伤害")
            call Trace("s2 - 测试真实伤害")
            call Trace("s3 - 测试模拟普攻")
            call Trace("s4 - 测试范围物理伤害")
            call Trace("s5 - 测试范围真实伤害")
            call Trace("s8 - 测试范围秒杀")
            call Trace("|cffaaaaaa=== 吸血相关测试 ===|r")
            call Trace("s9 - 切换吸血回调测试")
            call Trace("s10 - 测试物理伤害(带吸血)")
            call Trace("s11 - 测试魔法伤害(带吸血)")
            call Trace("s12 - 测试真实伤害(带吸血)")
            call Trace("s13 - 测试范围物理伤害(带吸血)")
            call Trace("s14 - 测试范围魔法伤害(带吸血)")
            call Trace("s15 - 测试范围真实伤害(带吸血)")
            call Trace("s16 - 测试范围秒杀(带吸血)")
            call Trace("|cffaaaaaa=== 其他测试 ===|r")
            call Trace("s6 - 切换伤害数值显示")
            call Trace("s7 - 切换伤害反弹测试")
            call Trace("|cffaaaaaa=== 参数设置 ===|r")
            call Trace("-d [数值] - 设置伤害值")
            call Trace("-r [数值] - 设置范围值")
            call Trace("-e [路径] - 设置特效")
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTDamageUtils__anon__3 takes nothing returns nothing
            local unit source=GetEventDamageSource()
            local unit target=GetTriggerUnit()
            local real damage=GetEventDamage()
            if ( UTDamageUtils__isShowDamage ) then
                call Trace("|cffff0000伤害事件|r - 来源: " + GetUnitName(source) + " 目标: " + GetUnitName(target) + "(" + I2S(GetHandleId(target)) + ") 伤害: " + R2S(damage) + " 当前栈层: " + I2S(s__DmgS_current()))
            endif // 反伤测试
            if ( UTDamageUtils__isReflectDamage and UTDamageUtils__reflectCount < 5 ) then // 限制反伤次数 // 增加反伤计数
                set UTDamageUtils__reflectCount=UTDamageUtils__reflectCount + 1
                call Trace("第 " + I2S(UTDamageUtils__reflectCount) + " 次反伤") // 造成反伤
                call DamageAreaPhysical(target , GetUnitX(target) , GetUnitY(target) , 100 , damage * 0.5 , I2S(s__DmgS_current()))
                if ( UTDamageUtils__reflectCount >= 5 ) then
                    call Trace("|cffff0000达到最大反伤次数(5次),现在栈层: " + I2S(s__DmgS_current()))
                endif
            endif // 单体聚合（LS 栈）
            if ( SingleDamageLSIsActive(source) ) then
                call SingleDamageLSAdd(GetEventDamage())
                call Trace("|cff00ff00吸血聚合|r - 来源: " + GetUnitName(source) + " 伤害: " + R2S(damage))
            endif // AoE 聚合（DmgS 栈）
            if ( s__DmgS_hasAggregation(source) ) then
                call s__DmgS_aggregate(GetEventDamage())
                call Trace("|cff00ff00范围伤害聚合|r - 来源: " + GetUnitName(source) + " 伤害: " + R2S(damage))
            endif
        endfunction  // 注册聊天事件
        function UTDamageUtils__anon__4 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            if ( SubString(str, 0, 1) == "-" ) then
                call UTDamageUtils__TTestActUTDamageUtils1(SubString(str, 1, StringLength(str)))
                return
            endif
            if ( str == "s1" ) then
                call UTDamageUtils__TTestUTDamageUtils1(GetTriggerPlayer())
            elseif ( str == "s2" ) then
                call UTDamageUtils__TTestUTDamageUtils2(GetTriggerPlayer())
            elseif ( str == "s3" ) then
                call UTDamageUtils__TTestUTDamageUtils3(GetTriggerPlayer())
            elseif ( str == "s4" ) then
                call UTDamageUtils__TTestUTDamageUtils4(GetTriggerPlayer())
            elseif ( str == "s5" ) then
                call UTDamageUtils__TTestUTDamageUtils5(GetTriggerPlayer())
            elseif ( str == "s6" ) then
                call UTDamageUtils__TTestUTDamageUtils6(GetTriggerPlayer())
            elseif ( str == "s7" ) then
                call UTDamageUtils__TTestUTDamageUtils7(GetTriggerPlayer())
            elseif ( str == "s8" ) then
                call UTDamageUtils__TTestUTDamageUtils8(GetTriggerPlayer())
            elseif ( str == "s9" ) then
                call UTDamageUtils__TTestUTDamageUtils9(GetTriggerPlayer())
            elseif ( str == "s10" ) then
                call UTDamageUtils__TTestUTDamageUtils10(GetTriggerPlayer())
            elseif ( str == "s11" ) then
                call UTDamageUtils__TTestUTDamageUtils11(GetTriggerPlayer())
            elseif ( str == "s12" ) then
                call UTDamageUtils__TTestUTDamageUtils12(GetTriggerPlayer())
            elseif ( str == "s13" ) then
                call UTDamageUtils__TTestUTDamageUtils13(GetTriggerPlayer())
            elseif ( str == "s14" ) then
                call UTDamageUtils__TTestUTDamageUtils14(GetTriggerPlayer())
            elseif ( str == "s15" ) then
                call UTDamageUtils__TTestUTDamageUtils15(GetTriggerPlayer())
            elseif ( str == "s16" ) then
                call UTDamageUtils__TTestUTDamageUtils16(GetTriggerPlayer())
            endif
        endfunction
    function UTDamageUtils__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr, 0.5, false)
        call TriggerAddCondition(tr, Condition(function UTDamageUtils__anon__2))
        set tr=null
        set UTDamageUtils__damageEventTrigger=CreateTrigger()
        call TriggerAddCondition(UTDamageUtils__damageEventTrigger, Condition(function UTDamageUtils__anon__3))
        call UnitTestRegisterChatEvent(function UTDamageUtils__anon__4)
        call s__cameraControl_openWheel()
    endfunction
    function UTDamageUtils__onDestroy takes nothing returns nothing
        call DestroyTrigger(UTDamageUtils__damageEventTrigger)
        set UTDamageUtils__damageEventTrigger=null
    endfunction

//library UTDamageUtils ends
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerSelectionEventBJ.h>
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerKeyEventBJ.h>
//#  define TriggerRegisterPlayerUnitEventSimple(trig, p, e)                 TriggerRegisterPlayerUnitEvent(trig, p, e, null)
//#  define TriggerRegisterPlayerEventVictory(trig, player)                  TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_VICTORY)
//#  define TriggerRegisterPlayerEventDefeat(trig, player)                   TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_DEFEAT)
//#  define TriggerRegisterPlayerEventLeave(trig, player)                    TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_LEAVE)
//#  define TriggerRegisterPlayerEventAllianceChanged(trig, player)          TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_ALLIANCE_CHANGED)
//#  define TriggerRegisterPlayerEventEndCinematic(trig, player)             TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_END_CINEMATIC)
// 当前构建版本
// 当前的平台分包
// 原生UI的大小
//地图的最低攻击间隔(非特殊情况)
//冲刺最大槽位数


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

// 0 - 1亿这里用
// 锚点常量
// 事件常量
//鼠标点击事件
//Index名:
//默认原生图片路径
//模板名
//TEXT对齐常量:(uiText.setAlign)

// 怪物掉落相关键值 (预留20个空间 1800-1819)
// 怪物掉落概率相关键值 (预留20个空间 1820-1839)
// 怪物掉落数量键值
// 单位技能相关键值 (预留200个空间 1800-1999)
// 2400开始可继续添加新的键值定义...
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
// 原生UI的大小
//地图的最低攻击间隔(非特殊情况)
//冲刺最大槽位数
    // 单元测试
    // lua_print: 单元测试
//这两条是用到YDWE函数就要导入的,没用到就不用导入
//函数入口
// 用原始地图测试
// 用空地图测试
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

call ExecuteFunc("jasshelper__initstructs39057921")
call ExecuteFunc("UnitTestFramwork__onInit")
call ExecuteFunc("YDLua__onInit")
call ExecuteFunc("Logger__onInit")
call ExecuteFunc("CameraControl__onInit")
call ExecuteFunc("UTDamageUtils__onInit")

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
function sa__DmgP_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            set s__DmgP_source[this]=null // this.eft = null; // 可选
   return true
endfunction

function jasshelper__initstructs39057921 takes nothing returns nothing
    set st__DmgP_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__DmgP_onDestroy,Condition( function sa__DmgP_onDestroy))







    call ExecuteFunc("s__hardware_onInit")
endfunction

