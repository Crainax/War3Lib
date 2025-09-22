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
//globals from YDTriggerSaveLoadSystem:
constant boolean LIBRARY_YDTriggerSaveLoadSystem=true
        hashtable YDHT
    hashtable YDLOC
//endglobals from YDTriggerSaveLoadSystem
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
//endglobals from CameraControl
//globals from DamageUtils:
constant boolean LIBRARY_DamageUtils=true
//endglobals from DamageUtils
//globals from UTDamageUtils:
constant boolean LIBRARY_UTDamageUtils=true
    unit UTDamageUtils___testDummy=null
    unit UTDamageUtils___testSource=null
    real UTDamageUtils___testDamage=100.0
    real UTDamageUtils___testRadius=300.0
    string UTDamageUtils___testEffect="Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl"
    trigger UTDamageUtils___damageEventTrigger=null
    boolean UTDamageUtils___isShowDamage=false
    boolean UTDamageUtils___isReflectDamage=false
    integer UTDamageUtils___reflectCount=0
//endglobals from UTDamageUtils
    // Generated
    rect gg_rct_Wave1 = null
    rect gg_rct_Wave2 = null
    rect gg_rct_Wave3 = null
    rect gg_rct_Wave4 = null
    rect gg_rct_Base = null
    rect gg_rct_BaseBack = null
    rect gg_rct_Home1 = null
    rect gg_rct_Home2 = null
    rect gg_rct_Home3 = null
    rect gg_rct_Home4 = null
    rect gg_rct_Fuben1 = null
    rect gg_rct_Fuben2 = null
    rect gg_rct_Fuben3 = null
    rect gg_rct_Fuben4 = null
    rect gg_rct_Fuben5 = null
    rect gg_rct_Fuben6 = null
    rect gg_rct_Fuben7 = null
    rect gg_rct_Fuben8 = null
    trigger gg_trg_______u = null
    unit gg_unit_hcas_0011 = null

trigger l__library_init
endglobals
//library BzAPI:
    //hardware
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
    //plus
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
    //sync
    native DzTriggerRegisterSyncData takes trigger trig, string prefix, boolean server returns nothing
    native DzSyncData takes string prefix, string data returns nothing
    native DzGetTriggerSyncPrefix takes nothing returns string
    native DzGetTriggerSyncData takes nothing returns string
    native DzGetTriggerSyncPlayer takes nothing returns player
    native DzSyncBuffer takes string prefix, string data, integer dataLen returns nothing
    //native DzGetPushContext takes nothing returns string
    native DzSyncDataImmediately takes string prefix, string data returns nothing 
    //gui
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
        //显示/隐藏SimpleFrame
    //native DzSimpleFrameShow takes integer frame, boolean enable returns nothing
    // 追加文字（支持TextArea）
    native DzFrameAddText takes integer frame, string text returns nothing
    // 沉默单位-禁用技能
    native DzUnitSilence takes unit whichUnit, boolean disable returns nothing
    // 禁用攻击
    native DzUnitDisableAttack takes unit whichUnit, boolean disable returns nothing
    // 禁用道具
    native DzUnitDisableInventory takes unit whichUnit, boolean disable returns nothing
    // 刷新小地图
    native DzUpdateMinimap takes nothing returns nothing
    // 修改单位alpha
    native DzUnitChangeAlpha takes unit whichUnit, integer alpha, boolean forceUpdate returns nothing
    // 设置单位是否可以选中
    native DzUnitSetCanSelect takes unit whichUnit, boolean state returns nothing
    // 修改单位是否可以被设置为目标
    native DzUnitSetTargetable takes unit whichUnit, boolean state returns nothing
    // 保存内存数据
    native DzSaveMemoryCache takes string cache returns nothing
    // 读取内存数据
    native DzGetMemoryCache takes nothing returns string
    // 设置加速倍率
    native DzSetSpeed takes real ratio returns nothing
    // 转换世界坐标为屏幕坐标-异步
    native DzConvertWorldPosition takes real x, real y, real z, code callback returns boolean
    // 转换世界坐标为屏幕坐标-获取转换后的X坐标
    native DzGetConvertWorldPositionX takes nothing returns real
    // 转换世界坐标为屏幕坐标-获取转换后的Y坐标
    native DzGetConvertWorldPositionY takes nothing returns real
    // 创建command button
    native DzCreateCommandButton takes integer parent, string icon, string name, string desc returns integer
    function DzTriggerRegisterMouseEventTrg takes trigger trg, integer status, integer btn returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseEvent(trg, btn, status, true, null)
    endfunction
    function DzTriggerRegisterKeyEventTrg takes trigger trg, integer status, integer btn returns nothing
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
        return ((GetUnitState(u,UNIT_STATE_LIFE)>0.405 and (GetUnitState(u,UNIT_STATE_LIFE)>0)) and (not (IsUnitType(u,UNIT_TYPE_SLEEPING)) and not (IsUnitType(u,UNIT_TYPE_STRUCTURE)) and not (IsUnitHidden(u)) and IsUnitEnemy(u,p) and IsUnitVisible(u,p))) and GetUnitAbilityLevel(u,'Avul')<1
    endfunction  //旧名：IsEnemy2
    function IsEnemyIncludeInvul takes unit u,player p returns boolean  //判断是否是敌方(能匹配到无敌单位)
        return ((GetUnitState(u,UNIT_STATE_LIFE)>0.405 and (GetUnitState(u,UNIT_STATE_LIFE)>0)) and (not (IsUnitType(u,UNIT_TYPE_SLEEPING)) and not (IsUnitType(u,UNIT_TYPE_STRUCTURE)) and not (IsUnitHidden(u)) and IsUnitEnemy(u,p) and IsUnitVisible(u,p)))
    endfunction  //判断是否是敌方非魔法免疫单位
    function IsEnemyMagic takes unit u,player p returns boolean
        return not (IsUnitType(u,UNIT_TYPE_MAGIC_IMMUNE)) and IsEnemy(u,p) and not (IsUnitType(u,UNIT_TYPE_RESISTANT))
    endfunction  //判断是否是敌方(简化版本,只检查基础状态和敌对关系)
    function IsEnemyBasic takes unit u,player p returns boolean
        return (GetUnitState(u,UNIT_STATE_LIFE)>0.405 and (GetUnitState(u,UNIT_STATE_LIFE)>0)) and IsUnitEnemy(u,p)
    endfunction  //判断是否是友方
    function IsAlly takes unit u,player p returns boolean
        return GetUnitState(u,UNIT_STATE_LIFE)>.405 and (not (IsUnitType(u,UNIT_TYPE_STRUCTURE))) and (not (IsUnitHidden(u))) and IsUnitAlly(u,p)
    endfunction  //判断两个单位是否互为敌人(不带无敌)
    function IsEnemyUnit takes unit target,unit caster returns boolean  //第一个参数是要受伤/中招的单位,第二个参数是锚定单位(施法者)
        return IsEnemy(target,GetOwningPlayer(caster))
    endfunction  //判断两个单位是否互为队友(不带无敌)
    function IsAllyUnit takes unit target,unit caster returns boolean
        return IsAlly(target,GetOwningPlayer(caster))
    endfunction  //判断两个单位是否互为敌人(简化版本,只检查基础状态和敌对关系)
    function IsEnemyBasicUnit takes unit target,unit caster returns boolean
        return (GetUnitState(target,UNIT_STATE_LIFE)>0.405 and (GetUnitState(target,UNIT_STATE_LIFE)>0)) and IsUnitEnemy(target,GetOwningPlayer(caster))
    endfunction  //判断是否是敌方非魔法免疫单位(双单位参数版)
    function IsEnemyMagicUnit takes unit target,unit caster returns boolean
        return IsEnemyMagic(target,GetOwningPlayer(caster))
    endfunction  // //判断单位是否属于指定常见种族或中立阵营

//library UnitFilter ends
//library UnitHashTable:

//library UnitHashTable ends
//library UnitTestFramwork:

    struct assert extends array  //断言布尔值
    //! pragma implicitthis
        static method Boolean takes boolean condition,string name returns nothing
            if (not condition)then
                call BJDebugMsg("FAIL: "+name)
            else
                call BJDebugMsg("PASS: "+name)
            endif
        endmethod  //断言字符串相等
        static method String takes string actual,string expected,string name returns nothing
            if (actual!=expected)then
                call BJDebugMsg("FAIL: "+name)
                call BJDebugMsg("  Expected: "+expected)
                call BJDebugMsg("  Actual: "+actual)
            else
                call BJDebugMsg("PASS: "+name)
            endif
        endmethod  //断言整数相等
        static method Integer takes integer actual,integer expected,string name returns nothing
            if (actual!=expected)then
                call BJDebugMsg("FAIL: "+name)
                call BJDebugMsg("  Expected: "+I2S(expected))
                call BJDebugMsg("  Actual: "+I2S(actual))
            else
                call BJDebugMsg("PASS: "+name)
            endif
        endmethod  //断言浮点数相等
        static method Real takes real actual,real expected,string name returns nothing  // 取两个数的绝对值的较大值
            local real maxValue=RMaxBJ(RAbsBJ(actual),RAbsBJ(expected))  // 相对误差为数值大小的万分之一
            local real epsilon=maxValue*0.00001  // 处理接近0的特殊情况
            if (maxValue<0.00001)then
                set epsilon=0.00001
            endif
            if (RAbsBJ(actual-expected)>epsilon)then
                call BJDebugMsg("FAIL: "+name)
                call BJDebugMsg("  Expected: "+R2SW(expected,0,1))
                call BJDebugMsg("  Actual: "+R2SW(actual,0,1))
            else
                call BJDebugMsg("PASS: "+name)
            endif
        endmethod
    endstruct  //注册单元测试事件(聊天内容),自动注入
    function UnitTestRegisterChatEvent takes code func returns nothing
        call TriggerAddAction(UnitTestFramwork__TUnitTest,func)
    endfunction  //指定开始时间与持续时间的定时器
        function UnitTestFramwork__anon__0 takes nothing returns nothing
            local real time=LoadReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),1)
            local real d=LoadReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),2)
            local trigger tr=LoadTriggerHandle(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),3)
            call BJDebugMsg("-----[单测 "+R2SW(time,0,1)+" - "+R2SW(time+d,0,1)+" 秒]开始------")
            call TriggerEvaluate(tr)
            call DestroyTrigger(tr)
            call FlushChildHashtable(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()))
            call DestroyTrigger(GetTriggeringTrigger())
            set tr=null
        endfunction
        function UnitTestFramwork__anon__1 takes nothing returns nothing
            local real time=LoadReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),1)
            local real d=LoadReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),2)
            local trigger tr=LoadTriggerHandle(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),3)
            call TriggerEvaluate(tr)
            call BJDebugMsg("-----[单测 "+R2SW(time,0,1)+" - "+R2SW(time+d,0,1)+" 秒]结束------")
            call DestroyTrigger(tr)
            call FlushChildHashtable(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()))
            call DestroyTrigger(GetTriggeringTrigger())
            set tr=null
        endfunction
    function UnitTestAutoTimer takes real time,real duration,code start,code end returns nothing
        local trigger t=CreateTrigger()
        local trigger tr=CreateTrigger()
        call TriggerAddCondition(t,Condition(start))
        call TriggerRegisterTimerEvent(tr,time,false)
        call SaveReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(tr),1,time)
        call SaveReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(tr),2,duration)
        call SaveTriggerHandle(UnitTestFramwork__HASH_UNITTEST,GetHandleId(tr),3,t)
        call TriggerAddCondition(tr,Condition(function UnitTestFramwork__anon__0))
        if (end!=null)then
            set t=CreateTrigger()
            set tr=CreateTrigger()
            call TriggerAddCondition(t,Condition(end))
            call TriggerRegisterTimerEvent(tr,time+duration,false)
            call SaveReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(tr),1,time)
            call SaveReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(tr),2,duration)
            call SaveTriggerHandle(UnitTestFramwork__HASH_UNITTEST,GetHandleId(tr),3,t)
            call TriggerAddCondition(tr,Condition(function UnitTestFramwork__anon__1))
        endif
        set tr=null
        set t=null
    endfunction
        function UnitTestFramwork__anon__2 takes nothing returns nothing  //在游戏开始0.1秒后再调用
            local integer i
            set i=1
            loop
            exitwhen (i>12)
                call SetPlayerName(ConvertedPlayer(i),"测试员"+I2S(i)+"号")  //迷雾全关
                call CreateFogModifierRectBJ(true,ConvertedPlayer(i),FOG_OF_WAR_VISIBLE,bj_mapInitialPlayableArea)
            set i = i+1
            endloop
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
    function UnitTestFramwork__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr,0.1,false)
        call TriggerAddCondition(tr,Condition(function UnitTestFramwork__anon__2))
        set tr=null
        set UnitTestFramwork__TUnitTest=CreateTrigger()
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest,Player(0),"",false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest,Player(1),"",false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest,Player(2),"",false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest,Player(3),"",false)
    endfunction

//library UnitTestFramwork ends
//library UnitUtils:
    struct unitAttrObserver extends array
    //! pragma implicitthis
        static unit argsU=null
        static trigger attackIntervalCB=null  //攻击间隔的观察者事件注册
        static method registerAttackInterval takes code func returns nothing
            if (attackIntervalCB==null)then
                set attackIntervalCB=CreateTrigger()
            endif
            call TriggerAddCondition(attackIntervalCB,Condition(func))
        endmethod
    endstruct  //获取单位的攻击力/防御/生命/魔法值
    function GetUnitAttack takes unit u returns integer
        return R2I(GetUnitState(u,ConvertUnitState(0x12)))
    endfunction
    function GetUnitDefense takes unit u returns integer
        return R2I(GetUnitState(u,ConvertUnitState(0x20)))
    endfunction
    function GetUnitHP takes unit u returns real
        return GetUnitState(u,UNIT_STATE_MAX_LIFE)
    endfunction
    function GetUnitMP takes unit u returns real
        return GetUnitState(u,UNIT_STATE_MAX_MANA)
    endfunction  //设置攻击力
    function SetUnitAttack takes unit u,real attack returns nothing
        call SetUnitState(u,ConvertUnitState(0x12),attack)
    endfunction  //增加攻击力
    function AddUnitAttack takes unit u,real attack returns nothing
        call SetUnitAttack(u,GetUnitAttack(u)+attack)
    endfunction  //设置防御
    function SetUnitDefense takes unit u,real defense returns nothing
        call SetUnitState(u,ConvertUnitState(0x20),defense)
    endfunction  //增加防御
    function AddUnitDefense takes unit u,real defense returns nothing
        call SetUnitDefense(u,GetUnitDefense(u)+defense)
    endfunction  //修改生命最大值
    function SetUnitHP takes unit u,real hp returns nothing
        call SetUnitState(u,UNIT_STATE_MAX_LIFE,RMaxBJ(hp,2.0))
    endfunction  //增加生命最大值
    function AddUnitHP takes unit u,real hp returns nothing
        call SetUnitHP(u,RMaxBJ(GetUnitHP(u)+hp,10.0))
        if (hp>0)then
            call SetUnitState(u,UNIT_STATE_LIFE,RMaxBJ(0,GetUnitState(u,UNIT_STATE_LIFE)+hp))
        endif
    endfunction  //回血(定值)
    function RegenUnitHP takes unit u,real volume returns nothing
        call SetUnitState(u,UNIT_STATE_LIFE,RMaxBJ(0,GetUnitState(u,UNIT_STATE_LIFE)+volume))
    endfunction  //回蓝(百分比)
    function RegenUnitHPPercent takes unit u,real rate returns nothing
        call SetUnitState(u,UNIT_STATE_LIFE,RMaxBJ(0,GetUnitState(u,UNIT_STATE_LIFE)+GetUnitHP(u)*rate))
    endfunction  //设置魔法最大值
    function SetUnitMP takes unit u,real mp returns nothing
        call SetUnitState(u,UNIT_STATE_MAX_MANA,mp)
    endfunction  //增加魔法最大值
    function AddUnitMP takes unit u,real mp returns nothing
        call SetUnitMP(u,GetUnitMP(u)+mp)
        if (mp>0)then
            call SetUnitState(u,UNIT_STATE_MANA,RMaxBJ(0,GetUnitState(u,UNIT_STATE_MANA)+mp))
        endif
    endfunction  //回蓝(定值)
    function RegenUnitMP takes unit u,real volume returns nothing
        call SetUnitState(u,UNIT_STATE_MANA,RMaxBJ(0,GetUnitState(u,UNIT_STATE_MANA)+volume))
    endfunction  //回蓝(百分比)
    function RegenUnitMPPercent takes unit u,real rate returns nothing
        call SetUnitState(u,UNIT_STATE_MANA,RMaxBJ(0,GetUnitState(u,UNIT_STATE_MANA)+GetUnitMP(u)*rate))
    endfunction  // 获取移速
    function GetUnitSpeed takes unit u returns integer  //突破522与0的移速的Hook
        if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),237960560))then
            return LoadInteger(HASH_UNIT,GetHandleId(u),237960560)
        else
            return R2I(GetUnitMoveSpeed(u))
        endif
    endfunction  //todo: 这个UNTable其他地图需要兼容
    function AddUnitSpeed takes unit u,integer speed returns nothing  // 增加移速
        local integer value  //突破522与0的移速的Hook
        if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),237960560))then
            set value=LoadInteger(HASH_UNIT,GetHandleId(u),237960560)
            set value=value+speed
            call SaveInteger(HASH_UNIT,GetHandleId(u),237960560,value)
        else
            set value=R2I(GetUnitMoveSpeed(u))+speed
        endif
        call SetUnitMoveSpeed(u,value)
    endfunction  // 初始化突破移速
    function InitUnitSpeed takes unit u returns nothing
        call SaveInteger(HASH_UNIT,GetHandleId(u),237960560,R2I(GetUnitMoveSpeed(u)))
    endfunction  //射程(还会+警戒范围)
    function GetUnitAttackRange takes unit u returns real
        return GetUnitState(u,ConvertUnitState(0x16))
    endfunction  //设置射程(还会设置警戒范围)
    function SetUnitAttackRange takes unit u,real range returns nothing
        call SetUnitState(u,ConvertUnitState(0x16),range)
        call SetUnitAcquireRange(u,RMaxBJ(range,900.0))
    endfunction  //增加射程(还会+警戒范围)
    function AddUnitAttackRange takes unit u,real range returns nothing
        call SetUnitState(u,ConvertUnitState(0x16),GetUnitAttackRange(u)+range)
        call SetUnitAcquireRange(u,RMaxBJ(GetUnitAcquireRange(u)+range,900.0))
    endfunction  // 获取攻速
    function GetUnitAttackSpeed takes unit u returns real
        return GetUnitState(u,ConvertUnitState(0x51))
    endfunction  // 增加攻速
    function AddUnitAttackSpeed takes unit u,real speed returns nothing
        call SetUnitState(u,ConvertUnitState(0x51),GetUnitState(u,ConvertUnitState(0x51))+speed)
    endfunction  // (获取缓存的攻击间隔(可能为负))
    function GetUnitAttackIntervalCache takes unit u returns real
        return LoadReal(HASH_UNIT,GetHandleId(u),255610124)
    endfunction  // (获取单位的攻击间隔,不会小于0.1)
    function GetUnitAttackInterval takes unit u returns real
        return GetUnitState(u,ConvertUnitState(0x25))
    endfunction  // 攻击间隔(虽然写着加,但是实际是减) - 带最小值与观察者
    function AddAttackInterval takes unit u,real value returns nothing
        local real cacheValue
        local real newValue
        local integer uid
        set uid=GetHandleId(u)  // 检查是否已初始化缓存
        if (not (HaveSavedReal(HASH_UNIT,uid,255610124)))then  // 如果没有初始化，先保存当前攻击间隔到缓存
            call SaveReal(HASH_UNIT,uid,255610124,GetUnitAttackInterval(u))
        endif  // 获取当前缓存值并添加新值
        set cacheValue=LoadReal(HASH_UNIT,uid,255610124)
        set cacheValue=cacheValue+value  // 更新缓存
        call SaveReal(HASH_UNIT,uid,255610124,cacheValue)  // 设置实际攻击间隔（确保不小于MIN_ATTACK_INTERVAL）
        set newValue=RMaxBJ(cacheValue,0.2)
        call SetUnitState(u,ConvertUnitState(0x25),newValue)  // 观察者模式回调
        if (unitAttrObserver.attackIntervalCB!=null)then
            set unitAttrObserver.argsU=u
            call TriggerEvaluate(unitAttrObserver.attackIntervalCB)
        endif
    endfunction  //传送单位(带特效与镜头转换)
    function TransportUnit takes unit u,real x,real y,boolean camera returns nothing
        if (camera)then
            call PanCameraToTimedForPlayer(GetOwningPlayer(u),x,y,0.2)
        endif
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl",GetUnitX(u),GetUnitY(u)))
        call SetUnitPosition(u,x,y)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl",GetUnitX(u),GetUnitY(u)))
    endfunction  //删除单位
    function DeleteUnit takes unit u returns nothing
        call FlushChildHashtable(HASH_UNIT,GetHandleId(u))
        call RemoveUnit(u)
    endfunction

//library UnitUtils ends
//library YDLua:

    function initializeLua takes nothing returns integer
        call Cheat("exec-lua:plugin_main")
        return 0
    endfunction
        function YDLua__anon__0 takes nothing returns nothing  //在游戏开始0.0秒后再调用
            call BJDebugMsg("调用了YDLua引擎")
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
    function YDLua__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr,0.0,false)
        call TriggerAddCondition(tr,Condition(function YDLua__anon__0))
        set tr=null
    endfunction

//library YDLua ends
//library YDTriggerSaveLoadSystem:
//#  define YDTRIGGER_handle(SG)                          YDTRIGGER_HT##SG##(HashtableHandle)
    function YDTriggerSaveLoadSystem__Init takes nothing returns nothing
            set YDHT = InitHashtable()
        set YDLOC = InitHashtable()
    endfunction

//library YDTriggerSaveLoadSystem ends
//library GroupUtils:
    function GroupEnumUnitsInRangeEx takes group whichGroup,real x,real y,real radius,boolexpr filter returns nothing
        call GroupEnumUnitsInRange(whichGroup,x,y,radius,filter)
        call DestroyBoolExpr(filter)
    endfunction  //库补充,防内存泄漏
    function GroupEnumUnitsInRectEx takes group whichGroup,rect r,boolexpr filter returns nothing
        call GroupEnumUnitsInRect(whichGroup,r,filter)
        call DestroyBoolExpr(filter)
    endfunction  //获取单位组:[敌方]
        function GroupUtils__anon__0 takes nothing returns boolean
            if (IsEnemy(GetFilterUnit(),GroupUtils__tempP))then
                return true
            endif
            return false
        endfunction
    function GetEnemyGroup takes player p,real x,real y,real radius returns group
        set GroupUtils__tempG=CreateGroup()
        set GroupUtils__tempP=p
        call GroupEnumUnitsInRangeEx(GroupUtils__tempG,x,y,radius,Filter(function GroupUtils__anon__0))
        set GroupUtils__tempP=null
        return GroupUtils__tempG
    endfunction  //获取圆形随机单位
    function GetRandomEnemy takes player p,real x,real y,real radius returns unit
        return GroupPickRandomUnit(GetEnemyGroup(p,x,y,radius))
    endfunction

//library GroupUtils ends
//library Hardware:
    struct hardware extends array  // 注册一个左键抬起事件
    //! pragma implicitthis
        static method regLeftUpEvent takes code func returns nothing
            call DzTriggerRegisterMouseEventByCode(null,1,0,false,func)
        endmethod  // 注册一个左键按下事件
        static method regLeftDownEvent takes code func returns nothing
            call DzTriggerRegisterMouseEventByCode(null,1,1,false,func)
        endmethod  // 注册一个右键按下事件
        static method regRightDownEvent takes code func returns nothing
            call DzTriggerRegisterMouseEventByCode(null,2,1,false,func)
        endmethod  // 注册一个右键抬起事件
        static method regRightUpEvent takes code func returns nothing
            call DzTriggerRegisterMouseEventByCode(null,2,0,false,func)
        endmethod  // 注册一个滚轮事件,不能异步注册
        static method regWheelEvent takes code func returns nothing
            if (trWheel==null)then
                set trWheel=CreateTrigger()
            endif
            call TriggerAddCondition(trWheel,Condition(func))
        endmethod  // 注册一个绘制事件,不能异步注册
        static method regUpdateEvent takes code func returns nothing
            if (trUpdate==null)then
                set trUpdate=CreateTrigger()
            endif
            call TriggerAddCondition(trUpdate,Condition(func))
        endmethod  // 注册一个窗口变化事件,不能异步注册
        static method regResizeEvent takes code func returns nothing
            if (trResize==null)then
                set trResize=CreateTrigger()
            endif
            call TriggerAddCondition(trResize,Condition(func))
        endmethod  // 注册一个鼠标移动事件,不能异步注册
        static method regMoveEvent takes code func returns nothing
            call BJDebugMsg("注册鼠标移动事件")
            if (trMove==null)then
                set trMove=CreateTrigger()
            endif
            call TriggerAddCondition(trMove,Condition(func))
        endmethod  // 获取鼠标的实数坐标X(0-0.8)
        static method getMouseX takes nothing returns real
            local integer width=DzGetClientWidth()
            if (width>0)then
                return DzGetMouseXRelative()*0.8/width
            else
                return 0.1
            endif
        endmethod  // 获取鼠标的实数坐标Y(0-0.6)
        static method getMouseY takes nothing returns real
            local integer height=DzGetClientHeight()
            if (height>0)then  // 防止除以0
                return 0.6-DzGetMouseYRelative()*0.6/height
            else
                return 0.1
            endif
        endmethod
        //private:
            private static trigger trWheel=null
            private static trigger trUpdate=null
            private static trigger trResize=null
            private static trigger trMove=null
                private static method anon__1 takes nothing returns nothing  //在游戏开始0.0秒后再调用 // 滚轮事件
                    call TriggerEvaluate(trWheel)
                endmethod  // 帧绘制事件
                private static method anon__2 takes nothing returns nothing
                    call TriggerEvaluate(trUpdate)
                endmethod  // 窗口大小变化事件
                private static method anon__3 takes nothing returns nothing
                    call TriggerEvaluate(trResize)
                endmethod  // 鼠标移动事件
                private static method anon__4 takes nothing returns nothing
                    call TriggerEvaluate(trMove)
                endmethod
            private static method anon__0 takes nothing returns nothing
                call DzTriggerRegisterMouseWheelEventByCode(null,false,function thistype.anon__1)
                call DzFrameSetUpdateCallbackByCode(function thistype.anon__2)
                call DzTriggerRegisterWindowResizeEventByCode(null,false,function thistype.anon__3)
                call DzTriggerRegisterMouseMoveEventByCode(null,false,function thistype.anon__4)
                call DestroyTrigger(GetTriggeringTrigger())
            endmethod
        static method onInit takes nothing returns nothing
            local trigger tr=CreateTrigger()
            call TriggerRegisterTimerEvent(tr,0.0,false)
            call TriggerAddCondition(tr,Condition(function thistype.anon__0))
            set tr=null
        endmethod
    endstruct

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
    function Logger__onInit takes nothing returns nothing  //日志打印系统初始化
        call Cheat("exec-lua:depends.debug.logger")
    endfunction

//library Logger ends
//library CameraControl:

    struct cameraControl   // 打开滚轮控制镜头高度
    //! pragma implicitthis
        static method openWheel takes nothing returns nothing
            call DoNothing()
        endmethod
    endstruct  // 滚轮控制镜头
        function CameraControl__anon__0 takes nothing returns nothing  // 初始化就调用 //注册滚轮事件 //滚轮变化量
            local integer delta=DzGetWheelDelta()  //如果鼠标不在游戏内，就不响应鼠标滚轮
            if (not (DzIsMouseOverUI()))then  //标记需要重置镜头属性
                return
            endif
            set CameraControl__ResetCam=true  //滚轮下滑
            if (delta<0)then  //视野等级上限
                if (CameraControl__ViewLevel<14)then  //滚轮上滑
                    set CameraControl__ViewLevel=CameraControl__ViewLevel+1
                endif
            elseif (CameraControl__ViewLevel>3)then  //视野等级下限
                set CameraControl__ViewLevel=CameraControl__ViewLevel-1
            endif
            set CameraControl__X_ANGLE=Rad2Deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK))  //记录滚动前的镜头角度
        endfunction  //注册每帧渲染事件
        function CameraControl__anon__1 takes nothing returns nothing  //重设镜头角度和高度
            if (CameraControl__ResetCam)then
                call SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK,CameraControl__X_ANGLE,0)
                call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE,CameraControl__ViewLevel*200,CameraControl__WheelSpeed)
                set CameraControl__ResetCam=false
            endif
        endfunction  //注册按下键码为145的按键(ScrollLock)事件
        function CameraControl__anon__2 takes nothing returns nothing
            set CameraControl__WideScr=not CameraControl__WideScr
            call DzEnableWideScreen(CameraControl__WideScr)
        endfunction
    function CameraControl__onInit takes nothing returns nothing
        call hardware.regWheelEvent(function CameraControl__anon__0)
        call hardware.regUpdateEvent(function CameraControl__anon__1)
        call DzTriggerRegisterKeyEventByCode(null,145,1,false,function CameraControl__anon__2)
    endfunction

//library CameraControl ends
//library DamageUtils:
    function ApplyPhysicalDamage takes unit u,unit target,real dmg returns nothing  //单体伤害:物理
        static if LIBRARY_Damage then
            set dmgF.isBJ=bj
        endif
        call UnitDamageTarget(u,target,dmg,false,false,ATTACK_TYPE_HERO,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_WHOKNOWS)
    endfunction  //单体伤害:魔法
    function ApplyMagicDamage takes unit u,unit target,real dmg returns nothing
        static if LIBRARY_Damage then
            set dmgF.isBJ=bj
        endif
        call UnitDamageTarget(u,target,dmg,false,true,ATTACK_TYPE_MAGIC,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
    endfunction  //单体伤害:真实
    function ApplyPureDamage takes unit u,unit target,real dmg returns nothing
        static if LIBRARY_Damage then
            set dmgF.isBJ=bj
        endif
        call UnitDamageTarget(u,target,dmg,false,true,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_SLOW_POISON,WEAPON_TYPE_WHOKNOWS)
    endfunction  //模拟普攻(最后一个参数代表额外的终伤,0)
    function SimulateBasicAttack takes unit u,unit target,real fd returns nothing
        call UnitDamageTarget(u,target,GetUnitState(u,ConvertUnitState(0x12))*(1.0+fd),true,false,ATTACK_TYPE_HERO,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_WHOKNOWS)
    endfunction  // 伤害参数结构体
    struct DamageUtils__DmgP 
    //! pragma implicitthis
        unit source
        string eft
        real damage  // 正确使用 onDestroy，而不是 destroy
        method onDestroy takes nothing returns nothing
            set this.source=null  // this.eft = null; // 可选
        endmethod
    endstruct  // 伤害参数栈
    struct DmgS extends array
    //! pragma implicitthis
        private static DamageUtils__DmgP  array stack
        private static integer top=-1
        static method push takes DamageUtils__DmgP params returns nothing
            if (thistype.top>=8190)then  // 调试期提示或直接 return，避免越界
                call BJDebugMsg("DmgS overflow")
                return
            endif
            set thistype.top=thistype.top+1
            set thistype.stack[thistype.top]=params
        endmethod
        static method pop takes nothing returns DamageUtils__DmgP
            local DamageUtils__DmgP params=thistype.stack[thistype.top]
            if (thistype.top<0)then
                call BJDebugMsg("DmgS underflow")
                return 0
            endif
            set thistype.stack[thistype.top]=0
            set thistype.top=thistype.top-1
            return params
        endmethod
        static method current takes nothing returns DamageUtils__DmgP
            return thistype.stack[thistype.top]
        endmethod
    endstruct  // 范围普通伤害
        function DamageUtils__anon__0 takes nothing returns boolean
            local DamageUtils__DmgP current=DmgS.current()
            if (IsEnemy(GetFilterUnit(),GetOwningPlayer(current.source)))then
                call ApplyPhysicalDamage(current.source,GetFilterUnit(),current.damage)
                if (current.eft!=null)then
                    call DestroyEffect(AddSpecialEffect(current.eft,GetUnitX(GetFilterUnit()),GetUnitY(GetFilterUnit())))
                endif
                return true
            endif
            return false
        endfunction
    function DamageAreaPhysical takes unit u,real x,real y,real radius,real damage,string efx returns nothing
        local group g=CreateGroup()
        local DamageUtils__DmgP params=DamageUtils__DmgP.create()
        set params.source=u
        set params.eft=efx
        set params.damage=damage
        call DmgS.push(params)
        call GroupEnumUnitsInRangeEx(g,x,y,radius,Filter(function DamageUtils__anon__0))
        set params=DmgS.pop()  // 现在会真正释放实例，并调用 onDestroy
        call params.destroy()
        call DestroyGroup(g)
        set g=null
    endfunction  //范围魔法伤害
        function DamageUtils__anon__1 takes nothing returns boolean
            local DamageUtils__DmgP current=DmgS.current()
            if (IsEnemy(GetFilterUnit(),GetOwningPlayer(current.source)))then
                call ApplyMagicDamage(current.source,GetFilterUnit(),current.damage)
                if (current.eft!=null)then
                    call DestroyEffect(AddSpecialEffect(current.eft,GetUnitX(GetFilterUnit()),GetUnitY(GetFilterUnit())))
                endif
                return true
            endif
            return false
        endfunction
    function DamageAreaMagic takes unit u,real x,real y,real radius,real damage,string efx returns nothing
        local group g=CreateGroup()
        local DamageUtils__DmgP params=DamageUtils__DmgP.create()
        set params.source=u
        set params.eft=efx
        set params.damage=damage
        call DmgS.push(params)
        call GroupEnumUnitsInRangeEx(g,x,y,radius,Filter(function DamageUtils__anon__1))
        set params=DmgS.pop()
        call params.destroy()
        call DestroyGroup(g)
        set g=null
    endfunction  //范围真实伤害
        function DamageUtils__anon__2 takes nothing returns boolean
            local DamageUtils__DmgP current=DmgS.current()
            if (IsEnemy(GetFilterUnit(),GetOwningPlayer(current.source)))then
                call ApplyPureDamage(current.source,GetFilterUnit(),current.damage)
                if (current.eft!=null)then
                    call DestroyEffect(AddSpecialEffect(current.eft,GetUnitX(GetFilterUnit()),GetUnitY(GetFilterUnit())))
                endif
                return true
            endif
            return false
        endfunction
    function DamageAreaPure takes unit u,real x,real y,real radius,real damage,string efx returns nothing
        local group g=CreateGroup()
        local DamageUtils__DmgP params=DamageUtils__DmgP.create()
        set params.source=u
        set params.eft=efx
        set params.damage=damage
        call DmgS.push(params)
        call GroupEnumUnitsInRangeEx(g,x,y,radius,Filter(function DamageUtils__anon__2))
        set params=DmgS.pop()
        call params.destroy()
        call DestroyGroup(g)
        set g=null
    endfunction

//library DamageUtils ends
//library UTDamageUtils:

        function UTDamageUtils___anon__0 takes nothing returns nothing  // 清理所有已存在的测试单位
            local unit u=GetEnumUnit()
            if (GetUnitTypeId(u)=='opeo' or GetUnitTypeId(u)=='hpea')then
                call RemoveUnit(u)
            endif
            set u=null
        endfunction
    function UTDamageUtils___CreateTestEnv takes player p returns nothing
        local real x=GetPlayerStartLocationX(p)
        local real y=GetPlayerStartLocationY(p)
        local real angle
        local integer i
        local group g=CreateGroup()
        local unit dummy
        call GroupEnumUnitsInRange(g,x,y,1000,null)
        call ForGroup(g,function UTDamageUtils___anon__0)
        call DestroyGroup(g)
        set g=null
        set UTDamageUtils___testDummy=null
        set UTDamageUtils___testSource=null  // 创建中心苦工单位
        set UTDamageUtils___testDummy=CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE),'opeo',x+200,y,270)
        call SetUnitInvulnerable(UTDamageUtils___testDummy,false)
        call SetUnitState(UTDamageUtils___testDummy,UNIT_STATE_LIFE,GetUnitState(UTDamageUtils___testDummy,UNIT_STATE_MAX_LIFE))  // 注册伤害事件
        call TriggerRegisterUnitEvent(UTDamageUtils___damageEventTrigger,UTDamageUtils___testDummy,EVENT_UNIT_DAMAGED)  // 创建环形分布的额外苦工
        set i=0
        loop
        exitwhen (i>=8)
            set angle=i*45.0*0.0174538
            set dummy=CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE),'opeo',x+200+UTDamageUtils___testRadius*Cos(angle),y+UTDamageUtils___testRadius*Sin(angle),270)
            call TriggerRegisterUnitEvent(UTDamageUtils___damageEventTrigger,dummy,EVENT_UNIT_DAMAGED)  // 为每个苦工注册伤害事件
        set i = i+1
        endloop  // 创建伤害源(农民)
        set UTDamageUtils___testSource=CreateUnit(p,'hpea',x,y,90)
        call SetUnitAttack(UTDamageUtils___testSource,50)  // 为农民也注册伤害事件
        call TriggerRegisterUnitEvent(UTDamageUtils___damageEventTrigger,UTDamageUtils___testSource,EVENT_UNIT_DAMAGED)
    endfunction  // 测试物理伤害
    function UTDamageUtils___TTestUTDamageUtils1 takes player p returns nothing
        call UTDamageUtils___CreateTestEnv(p)
        call Trace("测试物理伤害: "+R2S(UTDamageUtils___testDamage))
        call ApplyPhysicalDamage(UTDamageUtils___testSource,UTDamageUtils___testDummy,UTDamageUtils___testDamage)
    endfunction  // 测试真实伤害
    function UTDamageUtils___TTestUTDamageUtils2 takes player p returns nothing
        call UTDamageUtils___CreateTestEnv(p)
        call Trace("测试真实伤害: "+R2S(UTDamageUtils___testDamage))
        call ApplyPureDamage(UTDamageUtils___testSource,UTDamageUtils___testDummy,UTDamageUtils___testDamage)
    endfunction  // 测试模拟普攻
    function UTDamageUtils___TTestUTDamageUtils3 takes player p returns nothing
        call UTDamageUtils___CreateTestEnv(p)
        call Trace("测试模拟普攻，基础攻击: 50")
        call SimulateBasicAttack(UTDamageUtils___testSource,UTDamageUtils___testDummy,0)
    endfunction  // 测试范围物理伤害
    function UTDamageUtils___TTestUTDamageUtils4 takes player p returns nothing
        call UTDamageUtils___CreateTestEnv(p)
        call Trace("测试范围物理伤害: "+R2S(UTDamageUtils___testDamage)+" 范围: "+R2S(UTDamageUtils___testRadius))
        call Trace("中心点有1个假人，半径 "+R2S(UTDamageUtils___testRadius)+" 处有8个假人")
        call Trace("范围内的假人都会受到伤害和特效")
        call DamageAreaPhysical(UTDamageUtils___testSource,GetUnitX(UTDamageUtils___testSource),GetUnitY(UTDamageUtils___testSource),UTDamageUtils___testRadius,UTDamageUtils___testDamage,UTDamageUtils___testEffect)
    endfunction  // 测试范围真实伤害
    function UTDamageUtils___TTestUTDamageUtils5 takes player p returns nothing
        call UTDamageUtils___CreateTestEnv(p)
        call Trace("测试范围真实伤害: "+R2S(UTDamageUtils___testDamage)+" 范围: "+R2S(UTDamageUtils___testRadius))
        call Trace("中心点有1个假人，半径 "+R2S(UTDamageUtils___testRadius)+" 处有8个假人")
        call Trace("范围内的假人都会受到伤害和特效")
        call DamageAreaPure(UTDamageUtils___testSource,GetUnitX(UTDamageUtils___testSource),GetUnitY(UTDamageUtils___testSource),UTDamageUtils___testRadius,UTDamageUtils___testDamage,UTDamageUtils___testEffect)
    endfunction  // 测试伤害显示开关
    function UTDamageUtils___TTestUTDamageUtils6 takes player p returns nothing
        set UTDamageUtils___isShowDamage=not UTDamageUtils___isShowDamage
        if (UTDamageUtils___isShowDamage)then
            call Trace("|cff00ff00开启|r伤害数值显示")
        else
            call Trace("|cffff0000关闭|r伤害数值显示")
        endif
    endfunction  // 测试反伤开关
    function UTDamageUtils___TTestUTDamageUtils7 takes player p returns nothing
        set UTDamageUtils___isReflectDamage=not UTDamageUtils___isReflectDamage
        if (UTDamageUtils___isReflectDamage)then  // 重置反伤计数
            set UTDamageUtils___reflectCount=0
            call Trace("|cff00ff00开启|r伤害反弹测试 - 受伤单位将反弹50%伤害(最多5次)")
        else
            call Trace("|cffff0000关闭|r伤害反弹测试")
        endif
    endfunction  // 处理参数设置命令
    function UTDamageUtils___TTestActUTDamageUtils1 takes string str returns nothing
        local player p=GetTriggerPlayer()
        local integer index=GetConvertedPlayerId(p)
        local integer i  // 所有参数S
        local integer num=0
        local integer len=StringLength(str)
        local string  array paramS  // 所有参数I
        local integer  array paramI  // 所有参数R
        local real  array paramR  // 解析参数
        set i=0
        loop
        exitwhen (i>len-1)
            if (SubString(str,i,i+1)==" ")then
                set paramS[num]=SubString(str,0,i)
                set paramI[num]=S2I(paramS[num])
                set paramR[num]=S2R(paramS[num])
                set num=num+1
                set str=SubString(str,i+1,len)
                set len=StringLength(str)
                set i=-1
            endif
        set i = i+1
        endloop
        set paramS[num]=str
        set paramI[num]=S2I(paramS[num])
        set paramR[num]=S2R(paramS[num])
        set num=num+1  // 处理命令
        if (paramS[0]=="d")then
            set UTDamageUtils___testDamage=paramR[1]
            call Trace("设置伤害值为: "+R2S(UTDamageUtils___testDamage))
        elseif (paramS[0]=="r")then
            set UTDamageUtils___testRadius=paramR[1]
            call Trace("设置范围值为: "+R2S(UTDamageUtils___testRadius))
        elseif (paramS[0]=="e")then
            set UTDamageUtils___testEffect=paramS[1]
            call Trace("设置特效为: "+UTDamageUtils___testEffect)
        endif
        set p=null
    endfunction
        function UTDamageUtils___anon__1 takes nothing returns nothing
            call Trace("|cff00ff00[DamageUtils测试]|r 输入以下命令进行测试:")
            call Trace("s1 - 测试物理伤害")
            call Trace("s2 - 测试真实伤害")
            call Trace("s3 - 测试模拟普攻")
            call Trace("s4 - 测试范围物理伤害")
            call Trace("s5 - 测试范围真实伤害")
            call Trace("s6 - 切换伤害数值显示")
            call Trace("s7 - 切换伤害反弹测试")
            call Trace("参数设置:")
            call Trace("-d [数值] - 设置伤害值")
            call Trace("-r [数值] - 设置范围值")
            call Trace("-e [路径] - 设置特效")
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTDamageUtils___anon__2 takes nothing returns nothing  // 创建伤害事件触发器
            local unit source=GetEventDamageSource()
            local unit target=GetTriggerUnit()
            local real damage=GetEventDamage()  // 显示伤害信息
            if (UTDamageUtils___isShowDamage)then
                call Trace("|cffff0000伤害事件|r - 来源: "+GetUnitName(source)+" 目标: "+GetUnitName(target)+"("+I2S(GetHandleId(target))+") 伤害: "+R2S(damage)+" 当前栈层: "+I2S(DmgS.getTop()))
            endif  // 反伤测试
            if (UTDamageUtils___isReflectDamage and UTDamageUtils___reflectCount<5)then  // 限制反伤次数 // 增加反伤计数
                set UTDamageUtils___reflectCount=UTDamageUtils___reflectCount+1
                call Trace("第 "+I2S(UTDamageUtils___reflectCount)+" 次反伤")  // 造成反伤
                call DamageAreaPhysical(target,GetUnitX(target),GetUnitY(target),100,damage*0.5,I2S(DmgS.getTop()))
                if (UTDamageUtils___reflectCount>=5)then
                    call Trace("|cffff0000达到最大反伤次数(5次),现在栈层: "+I2S(DmgS.getTop()))
                endif
            endif
        endfunction  // 注册聊天事件
        function UTDamageUtils___anon__3 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            if (SubString(str,0,1)=="-")then
                call UTDamageUtils___TTestActUTDamageUtils1(SubString(str,1,StringLength(str)))
                return
            endif
            if (str=="s1")then
                call UTDamageUtils___TTestUTDamageUtils1(GetTriggerPlayer())
            elseif (str=="s2")then
                call UTDamageUtils___TTestUTDamageUtils2(GetTriggerPlayer())
            elseif (str=="s3")then
                call UTDamageUtils___TTestUTDamageUtils3(GetTriggerPlayer())
            elseif (str=="s4")then
                call UTDamageUtils___TTestUTDamageUtils4(GetTriggerPlayer())
            elseif (str=="s5")then
                call UTDamageUtils___TTestUTDamageUtils5(GetTriggerPlayer())
            elseif (str=="s6")then  // 新增命令
                call UTDamageUtils___TTestUTDamageUtils6(GetTriggerPlayer())
            elseif (str=="s7")then
                call UTDamageUtils___TTestUTDamageUtils7(GetTriggerPlayer())
            endif
        endfunction
    function UTDamageUtils___onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr,0.5,false)
        call TriggerAddCondition(tr,Condition(function UTDamageUtils___anon__1))
        set tr=null
        set UTDamageUtils___damageEventTrigger=CreateTrigger()
        call TriggerAddCondition(UTDamageUtils___damageEventTrigger,Condition(function UTDamageUtils___anon__2))
        call UnitTestRegisterChatEvent(function UTDamageUtils___anon__3)
        call cameraControl.openWheel()
    endfunction
    function UTDamageUtils___onDestroy takes nothing returns nothing
        call DestroyTrigger(UTDamageUtils___damageEventTrigger)
        set UTDamageUtils___damageEventTrigger=null
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

// 怪物掉落相关键值 (预留20个空间 1800-1819)
// 怪物掉落概率相关键值 (预留20个空间 1820-1839)
// 怪物掉落数量键值
// 单位技能相关键值 (预留200个空间 1800-1999)
// 2400开始可继续添加新的键值定义...

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
// redeclaration of library YDTriggerSaveLoadSystem skipped
function InitGlobals takes nothing returns nothing
endfunction
//***************************************************************************
//*
//*  Unit Creation
//*
//***************************************************************************
//===========================================================================
function CreateBuildingsForPlayer8 takes nothing returns nothing
    local player p = Player(8)
    local unit u
    local integer unitID
    local trigger t
    local real life
    set gg_unit_hcas_0011 = CreateUnit( p, 'hcas', -64.0, -1984.0, 270.000 )
endfunction
//===========================================================================
function CreatePlayerBuildings takes nothing returns nothing
    call CreateBuildingsForPlayer8( )
endfunction
//===========================================================================
function CreatePlayerUnits takes nothing returns nothing
endfunction
//===========================================================================
function CreateAllUnits takes nothing returns nothing
    call CreatePlayerBuildings( )
    call CreatePlayerUnits( )
endfunction
//***************************************************************************
//*
//*  Regions
//*
//***************************************************************************
function CreateRegions takes nothing returns nothing
    local weathereffect we
    set gg_rct_Wave1 = Rect( -5088.0, 3168.0, -4448.0, 3968.0 )
    set gg_rct_Wave2 = Rect( -1568.0, 3360.0, -928.0, 4160.0 )
    set gg_rct_Wave3 = Rect( 1312.0, 3584.0, 1952.0, 4384.0 )
    set gg_rct_Wave4 = Rect( 4320.0, 3232.0, 4960.0, 4032.0 )
    set gg_rct_Base = Rect( -320.0, -2304.0, 192.0, -1664.0 )
    set gg_rct_BaseBack = Rect( -320.0, -3328.0, 160.0, -2848.0 )
    set gg_rct_Home1 = Rect( -10496.0, 1440.0, -8128.0, 3776.0 )
    set gg_rct_Home2 = Rect( 7712.0, 1568.0, 10080.0, 3904.0 )
    set gg_rct_Home3 = Rect( -10464.0, -3680.0, -8096.0, -1344.0 )
    set gg_rct_Home4 = Rect( 7712.0, -3552.0, 10080.0, -1216.0 )
    set gg_rct_Fuben1 = Rect( -11872.0, 7968.0, -8224.0, 11584.0 )
    set gg_rct_Fuben2 = Rect( -5472.0, 8000.0, -1824.0, 11616.0 )
    set gg_rct_Fuben3 = Rect( 1184.0, 8000.0, 4832.0, 11616.0 )
    set gg_rct_Fuben4 = Rect( 7712.0, 7968.0, 11360.0, 11584.0 )
    set gg_rct_Fuben5 = Rect( -11872.0, -11328.0, -8224.0, -7712.0 )
    set gg_rct_Fuben6 = Rect( -5472.0, -11328.0, -1824.0, -7712.0 )
    set gg_rct_Fuben7 = Rect( 1184.0, -11328.0, 4832.0, -7712.0 )
    set gg_rct_Fuben8 = Rect( 7712.0, -11328.0, 11360.0, -7712.0 )
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
    set gg_trg_______u = CreateTrigger()
    call DoNothing()
    call TriggerAddAction(gg_trg_______u, function Trig_______uActions)
endfunction
//===========================================================================
function InitCustomTriggers takes nothing returns nothing
    call InitTrig_______u( )
endfunction
//***************************************************************************
//*
//*  Players
//*
//***************************************************************************
function InitCustomPlayerSlots takes nothing returns nothing
    // Player 0
    call SetPlayerStartLocation( Player(0), 0 )
    call ForcePlayerStartLocation( Player(0), 0 )
    call SetPlayerColor( Player(0), ConvertPlayerColor(0) )
    call SetPlayerRacePreference( Player(0), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(0), false )
    call SetPlayerController( Player(0), MAP_CONTROL_USER )
    // Player 1
    call SetPlayerStartLocation( Player(1), 1 )
    call ForcePlayerStartLocation( Player(1), 1 )
    call SetPlayerColor( Player(1), ConvertPlayerColor(1) )
    call SetPlayerRacePreference( Player(1), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(1), false )
    call SetPlayerController( Player(1), MAP_CONTROL_USER )
    // Player 2
    call SetPlayerStartLocation( Player(2), 2 )
    call ForcePlayerStartLocation( Player(2), 2 )
    call SetPlayerColor( Player(2), ConvertPlayerColor(2) )
    call SetPlayerRacePreference( Player(2), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(2), false )
    call SetPlayerController( Player(2), MAP_CONTROL_USER )
    // Player 3
    call SetPlayerStartLocation( Player(3), 3 )
    call ForcePlayerStartLocation( Player(3), 3 )
    call SetPlayerColor( Player(3), ConvertPlayerColor(3) )
    call SetPlayerRacePreference( Player(3), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(3), false )
    call SetPlayerController( Player(3), MAP_CONTROL_USER )
    // Player 4
    call SetPlayerStartLocation( Player(4), 4 )
    call ForcePlayerStartLocation( Player(4), 4 )
    call SetPlayerColor( Player(4), ConvertPlayerColor(4) )
    call SetPlayerRacePreference( Player(4), RACE_PREF_NIGHTELF )
    call SetPlayerRaceSelectable( Player(4), false )
    call SetPlayerController( Player(4), MAP_CONTROL_COMPUTER )
    // Player 5
    call SetPlayerStartLocation( Player(5), 5 )
    call ForcePlayerStartLocation( Player(5), 5 )
    call SetPlayerColor( Player(5), ConvertPlayerColor(5) )
    call SetPlayerRacePreference( Player(5), RACE_PREF_NIGHTELF )
    call SetPlayerRaceSelectable( Player(5), false )
    call SetPlayerController( Player(5), MAP_CONTROL_COMPUTER )
    // Player 6
    call SetPlayerStartLocation( Player(6), 6 )
    call ForcePlayerStartLocation( Player(6), 6 )
    call SetPlayerColor( Player(6), ConvertPlayerColor(6) )
    call SetPlayerRacePreference( Player(6), RACE_PREF_NIGHTELF )
    call SetPlayerRaceSelectable( Player(6), false )
    call SetPlayerController( Player(6), MAP_CONTROL_COMPUTER )
    // Player 7
    call SetPlayerStartLocation( Player(7), 7 )
    call ForcePlayerStartLocation( Player(7), 7 )
    call SetPlayerColor( Player(7), ConvertPlayerColor(7) )
    call SetPlayerRacePreference( Player(7), RACE_PREF_NIGHTELF )
    call SetPlayerRaceSelectable( Player(7), false )
    call SetPlayerController( Player(7), MAP_CONTROL_COMPUTER )
    // Player 8
    call SetPlayerStartLocation( Player(8), 8 )
    call ForcePlayerStartLocation( Player(8), 8 )
    call SetPlayerColor( Player(8), ConvertPlayerColor(8) )
    call SetPlayerRacePreference( Player(8), RACE_PREF_NIGHTELF )
    call SetPlayerRaceSelectable( Player(8), false )
    call SetPlayerController( Player(8), MAP_CONTROL_COMPUTER )
    // Player 9
    call SetPlayerStartLocation( Player(9), 9 )
    call ForcePlayerStartLocation( Player(9), 9 )
    call SetPlayerColor( Player(9), ConvertPlayerColor(9) )
    call SetPlayerRacePreference( Player(9), RACE_PREF_UNDEAD )
    call SetPlayerRaceSelectable( Player(9), false )
    call SetPlayerController( Player(9), MAP_CONTROL_COMPUTER )
    // Player 10
    call SetPlayerStartLocation( Player(10), 10 )
    call ForcePlayerStartLocation( Player(10), 10 )
    call SetPlayerColor( Player(10), ConvertPlayerColor(10) )
    call SetPlayerRacePreference( Player(10), RACE_PREF_UNDEAD )
    call SetPlayerRaceSelectable( Player(10), false )
    call SetPlayerController( Player(10), MAP_CONTROL_COMPUTER )
    // Player 11
    call SetPlayerStartLocation( Player(11), 11 )
    call ForcePlayerStartLocation( Player(11), 11 )
    call SetPlayerColor( Player(11), ConvertPlayerColor(11) )
    call SetPlayerRacePreference( Player(11), RACE_PREF_UNDEAD )
    call SetPlayerRaceSelectable( Player(11), false )
    call SetPlayerController( Player(11), MAP_CONTROL_COMPUTER )
endfunction
function InitCustomTeams takes nothing returns nothing
    // Force: TRIGSTR_013
    call SetPlayerTeam( Player(0), 0 )
    call SetPlayerTeam( Player(1), 0 )
    call SetPlayerTeam( Player(2), 0 )
    call SetPlayerTeam( Player(3), 0 )
    call SetPlayerTeam( Player(4), 0 )
    call SetPlayerTeam( Player(5), 0 )
    call SetPlayerTeam( Player(6), 0 )
    call SetPlayerTeam( Player(7), 0 )
    call SetPlayerTeam( Player(8), 0 )
    //   Allied
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(7), true )
    //   Shared Vision
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(7), true )
    // Force: TRIGSTR_014
    call SetPlayerTeam( Player(9), 1 )
    call SetPlayerTeam( Player(10), 1 )
    call SetPlayerTeam( Player(11), 1 )
    //   Allied
    call SetPlayerAllianceStateAllyBJ( Player(9), Player(10), true )
    call SetPlayerAllianceStateAllyBJ( Player(9), Player(11), true )
    call SetPlayerAllianceStateAllyBJ( Player(10), Player(9), true )
    call SetPlayerAllianceStateAllyBJ( Player(10), Player(11), true )
    call SetPlayerAllianceStateAllyBJ( Player(11), Player(9), true )
    call SetPlayerAllianceStateAllyBJ( Player(11), Player(10), true )
    //   Shared Vision
    call SetPlayerAllianceStateVisionBJ( Player(9), Player(10), true )
    call SetPlayerAllianceStateVisionBJ( Player(9), Player(11), true )
    call SetPlayerAllianceStateVisionBJ( Player(10), Player(9), true )
    call SetPlayerAllianceStateVisionBJ( Player(10), Player(11), true )
    call SetPlayerAllianceStateVisionBJ( Player(11), Player(9), true )
    call SetPlayerAllianceStateVisionBJ( Player(11), Player(10), true )
endfunction
function InitAllyPriorities takes nothing returns nothing
    call SetStartLocPrioCount( 0, 3 )
    call SetStartLocPrio( 0, 0, 1, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 0, 1, 2, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 0, 2, 3, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrioCount( 1, 3 )
    call SetStartLocPrio( 1, 0, 0, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 1, 1, 2, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 1, 2, 3, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrioCount( 2, 3 )
    call SetStartLocPrio( 2, 0, 0, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 2, 1, 1, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 2, 2, 3, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrioCount( 3, 3 )
    call SetStartLocPrio( 3, 0, 0, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 3, 1, 1, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 3, 2, 2, MAP_LOC_PRIO_HIGH )
endfunction
//***************************************************************************
//*
//*  Main Initialization
//*
//***************************************************************************
//===========================================================================
function main takes nothing returns nothing
    call initializeLua() 
 call SetCameraBounds( -13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM) )
    call SetDayNightModels( "Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl" )
    call NewSoundEnvironment( "Default" )
    call SetAmbientDaySound( "NorthrendDay" )
    call SetAmbientNightSound( "NorthrendNight" )
    call SetMapMusic( "Music", true, 0 )
    call CreateRegions( )
    call CreateAllUnits( )
    call InitBlizzard( )

//! initstructs
call ExecuteFunc("UnitTestFramwork__onInit")
call ExecuteFunc("YDLua__onInit")
call ExecuteFunc("YDTriggerSaveLoadSystem__Init")
call ExecuteFunc("Logger__onInit")
call ExecuteFunc("CameraControl__onInit")
call ExecuteFunc("UTDamageUtils___onInit")

//! initdatastructs
    call InitGlobals( )
    call InitCustomTriggers( )
endfunction
//***************************************************************************
//*
//*  Map Configuration
//*
//***************************************************************************
function config takes nothing returns nothing
    call SetMapName( "TRIGSTR_1232" )
    call SetMapDescription( "TRIGSTR_1234" )
    call SetPlayers( 12 )
    call SetTeams( 12 )
    call SetGamePlacement( MAP_PLACEMENT_TEAMS_TOGETHER )
    call DefineStartLocation( 0, 0.0, 0.0 )
    call DefineStartLocation( 1, 0.0, 0.0 )
    call DefineStartLocation( 2, 0.0, 0.0 )
    call DefineStartLocation( 3, 0.0, 0.0 )
    call DefineStartLocation( 4, 0.0, 0.0 )
    call DefineStartLocation( 5, 0.0, 0.0 )
    call DefineStartLocation( 6, 0.0, 0.0 )
    call DefineStartLocation( 7, 0.0, 0.0 )
    call DefineStartLocation( 8, 0.0, 0.0 )
    call DefineStartLocation( 9, 0.0, 0.0 )
    call DefineStartLocation( 10, 0.0, 0.0 )
    call DefineStartLocation( 11, 0.0, 0.0 )
    // Player setup
    call InitCustomPlayerSlots( )
    call InitCustomTeams( )
    call InitAllyPriorities( )
endfunction



