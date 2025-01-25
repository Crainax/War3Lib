globals
//globals from MapBoundsUtils:
constant boolean LIBRARY_MapBoundsUtils=true
//endglobals from MapBoundsUtils
//globals from MathUtils:
constant boolean LIBRARY_MathUtils=true
//endglobals from MathUtils
//globals from UnitAttrAttackModule:
constant boolean LIBRARY_UnitAttrAttackModule=true
//endglobals from UnitAttrAttackModule
//globals from UnitHashTable:
constant boolean LIBRARY_UnitHashTable=true
hashtable HASH_UNIT=InitHashtable()
//endglobals from UnitHashTable
//globals from UnitLifeCycle:
constant boolean LIBRARY_UnitLifeCycle=true
//endglobals from UnitLifeCycle
//globals from UnitTestFramwork:
constant boolean LIBRARY_UnitTestFramwork=true
trigger UnitTestFramwork__TUnitTest=null
hashtable UnitTestFramwork__HASH_UNITTEST=InitHashtable()
//endglobals from UnitTestFramwork
//globals from UnitUtils:
constant boolean LIBRARY_UnitUtils=true
//endglobals from UnitUtils
//globals from UnitAttr:
constant boolean LIBRARY_UnitAttr=true
//endglobals from UnitAttr
//globals from UTUnitAttr:
constant boolean LIBRARY_UTUnitAttr=true
unit UTUnitAttr___testUnit=null
integer UTUnitAttr___testAttr=0
//endglobals from UTUnitAttr
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
constant integer si__unitLifeCycle=3
unit s__unitLifeCycle_argsUnit=null
trigger s__unitLifeCycle_trCreate=null
trigger s__unitLifeCycle_trDestroy=null
constant integer si__assert=4
constant integer si__unitAttr=5
integer si__unitAttr_F=0
integer si__unitAttr_I=0
integer array si__unitAttr_V
integer s__unitAttr_ethis=0
unit array s__unitAttr_u
real array s__unitAttr_baseAtkRange
real array s__unitAttr_AtkRangeRateUp
real array s__unitAttr_AtkRangeRateDown
real array s__unitAttr_baseAtkSpeed
real array s__unitAttr_AtkSpeedRateDown
real array s__unitAttr_baseAtkInterval
real array s__unitAttr_AtkIntervalRateDown
real array s__unitAttr_baseHP
real array s__unitAttr_HPRateUp
real array s__unitAttr_HPRateDown
real array s__unitAttr_cachedHP
real array s__unitAttr_baseMP
real array s__unitAttr_MPRateUp
real array s__unitAttr_MPRateDown
real array s__unitAttr_cachedMP
real array s__unitAttr_baseAtk
real array s__unitAttr_AtkRateUp
real array s__unitAttr_AtkRateDown
real array s__unitAttr_AtkRateBonus
real array s__unitAttr_AtkFixedBonus
trigger s__unitAttr_trAtkChange=null
real array s__unitAttr_baseDef
real array s__unitAttr_DefRateUp
real array s__unitAttr_DefRateDown
real array s__unitAttr_DefRateBonus
real array s__unitAttr_DefFixedBonus
trigger s__unitAttr_trDefChange=null
real array s__unitAttr_SpellDmgRateUp
real array s__unitAttr_SpellDmgRateDown
real array s__unitAttr_FinalDmgRateRateUp
real array s__unitAttr_FinalDmgRateRateDown
trigger st__unitLifeCycle_onDestroyCB
trigger st__unitAttr_onDestroy
unit f__arg_unit1
integer f__arg_this

endglobals


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

//Generated method caller for unitAttr.onDestroy
function sc__unitAttr_onDestroy takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__unitAttr_onDestroy)
endfunction

//Generated allocator of unitAttr
function s__unitAttr__allocate takes nothing returns integer
 local integer this=si__unitAttr_F
    if (this!=0) then
        set si__unitAttr_F=si__unitAttr_V[this]
    else
        set si__unitAttr_I=si__unitAttr_I+1
        set this=si__unitAttr_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: unitAttr")
        return 0
    endif

    set si__unitAttr_V[this]=-1
 return this
endfunction

//Generated destructor of unitAttr
function sc__unitAttr_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: unitAttr")
        return
    elseif (si__unitAttr_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: unitAttr")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__unitAttr_onDestroy)
    set si__unitAttr_V[this]=si__unitAttr_F
    set si__unitAttr_F=this
endfunction

//Generated method caller for unitLifeCycle.onDestroyCB
function sc__unitLifeCycle_onDestroyCB takes unit u returns nothing
            set s__unitLifeCycle_argsUnit=u
            call TriggerEvaluate(s__unitLifeCycle_trDestroy) //然后再清除所有哈希表
            call FlushChildHashtable(HASH_UNIT, GetHandleId(u))
            set s__unitLifeCycle_argsUnit=null
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
function h__RemoveUnit takes unit a0 returns nothing
    //hook: unitLifeCycle.onDestroyCB
    call sc__unitLifeCycle_onDestroyCB(a0)
call RemoveUnit(a0)
endfunction

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
                set tan=Tan(( a ) * 0.0174538)
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
                set tan=Tan(( a ) * 0.0174538)
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
                set tan=Tan(( a ) * 0.0174538)
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
                set tan=Tan(( a ) * 0.0174538)
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
    function RealAdd3 takes real a1,real a2,real a3 returns real
        local real temp
        if ( RAbsBJ(a2) >= 1.0 ) then
            return RealAdd(a1 , a3)
        endif // 如果第三个参数绝对值>=1.0，直接返回前两个参数的计算结果
        if ( RAbsBJ(a3) >= 1.0 ) then
            return RealAdd(a1 , a2)
        endif // 先计算前两个参数的结果
        if ( a2 >= 0 ) then
            set temp=1.0 - ( 1.0 - a1 ) * ( 1.0 - a2 )
        else
            set temp=1.0 - ( 1.0 - a1 ) / ( 1.0 + a2 )
        endif // 再与第三个参数计算
        if ( a3 >= 0 ) then
            return 1.0 - ( 1.0 - temp ) * ( 1.0 - a3 )
        else
            return 1.0 - ( 1.0 - temp ) / ( 1.0 + a3 )
        endif
    endfunction

//library MathUtils ends
//library UnitAttrAttackModule:

//library UnitAttrAttackModule ends
//library UnitHashTable:

//library UnitHashTable ends
//library UnitLifeCycle:
        //private:
        function s__unitLifeCycle_registerDestroy takes code func returns nothing
            call TriggerAddCondition(s__unitLifeCycle_trDestroy, Condition(func))
        endfunction
        function s__unitLifeCycle_onDestroyCB takes unit u returns nothing
            set s__unitLifeCycle_argsUnit=u
            call TriggerEvaluate(s__unitLifeCycle_trDestroy) //然后再清除所有哈希表
            call FlushChildHashtable(HASH_UNIT, GetHandleId(u))
            set s__unitLifeCycle_argsUnit=null
        endfunction
        function s__unitLifeCycle_onInit takes nothing returns nothing
            set s__unitLifeCycle_trCreate=CreateTrigger()
            set s__unitLifeCycle_trDestroy=CreateTrigger()
        endfunction

//library UnitLifeCycle ends
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
            call SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState(u, UNIT_STATE_MANA) + mp))
        endif
    endfunction  //回蓝(定值)
    function RegenUnitMP takes unit u,real volume returns nothing
        call SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState(u, UNIT_STATE_MANA) + volume))
    endfunction  //回蓝(百分比)
    function RegenUnitMPPercent takes unit u,real rate returns nothing
        call SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState(u, UNIT_STATE_MANA) + GetUnitMP(u) * rate))
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
    endfunction
    function GetUnitInterval takes unit u returns real
        return GetUnitState(u, ConvertUnitState(0x25))
    endfunction  // 攻击间隔(虽然写着加,但是实际是减)
    function AddAttackInterval takes unit u,real value returns nothing
        call SetUnitState(u, ConvertUnitState(0x25), GetUnitInterval(u) - value)
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
        call h__RemoveUnit(u)
    endfunction

//library UnitUtils ends
//library UnitAttr:
        function s__unitAttr_isExist takes integer this returns boolean
            return ( this != null and si__unitAttr_V[this] == - 1 )
        endfunction
        function s__unitAttr_get takes unit u returns integer
            if ( HaveSavedInteger(HASH_UNIT, GetHandleId(u), 1726) ) then
                return LoadInteger(HASH_UNIT, GetHandleId(u), 1726)
            endif
            return 0
        endfunction  //同步并刷新当前单位的HP
        function s__unitAttr_syncHPRate takes integer this returns nothing
            local real desiredHP
            local real diff
            set desiredHP=s__unitAttr_baseHP[this] * ( 1.0 + s__unitAttr_HPRateUp[this] ) * ( 1.0 - s__unitAttr_HPRateDown[this] ) //计算差值
            set diff=desiredHP - s__unitAttr_cachedHP[this] //只有当差值的绝对值大于等于1时才更新
            if ( diff >= 1.0 or diff <= - 1.0 ) then //设置最大值
                call SetUnitState(s__unitAttr_u[this], UNIT_STATE_MAX_LIFE, RMaxBJ(desiredHP, 2.0)) //如果是增加值，同时增加当前值
                if ( diff > 0 ) then
                    call SetUnitState(s__unitAttr_u[this], UNIT_STATE_LIFE, GetUnitState(s__unitAttr_u[this], UNIT_STATE_LIFE) + diff)
                endif
                set s__unitAttr_cachedHP[this]=desiredHP
            endif
        endfunction  //同步并刷新当前单位的MP
        function s__unitAttr_syncMPRate takes integer this returns nothing
            local real desiredMP
            local real diff
            set desiredMP=s__unitAttr_baseMP[this] * ( 1.0 + s__unitAttr_MPRateUp[this] ) * ( 1.0 - s__unitAttr_MPRateDown[this] ) //计算差值
            set diff=desiredMP - s__unitAttr_cachedMP[this] //只有当差值的绝对值大于等于1时才更新
            if ( diff >= 1.0 or diff <= - 1.0 ) then //设置最大值
                call SetUnitState(s__unitAttr_u[this], UNIT_STATE_MAX_MANA, RMaxBJ(desiredMP, 2.0)) //如果是增加值，同时增加当前值
                if ( diff > 0 ) then
                    call SetUnitState(s__unitAttr_u[this], UNIT_STATE_MANA, GetUnitState(s__unitAttr_u[this], UNIT_STATE_MANA) + diff)
                endif
                set s__unitAttr_cachedMP[this]=desiredMP
            endif
        endfunction  // 同步并刷新当前单位的攻击
        function s__unitAttr_syncAtkRate takes integer this returns nothing
            set s__unitAttr_AtkRateBonus[this]=s__unitAttr_baseAtk[this] * ( 1.0 + s__unitAttr_AtkRateUp[this] ) * ( 1.0 - s__unitAttr_AtkRateDown[this] ) - s__unitAttr_baseAtk[this]
            call SetUnitState(s__unitAttr_u[this], ConvertUnitState(0x12), RMaxBJ(s__unitAttr_baseAtk[this] + s__unitAttr_AtkRateBonus[this] + s__unitAttr_AtkFixedBonus[this], 0.0))
            if ( s__unitAttr_trAtkChange != null ) then
                set s__unitAttr_ethis=this
                call TriggerEvaluate(s__unitAttr_trAtkChange)
            endif
        endfunction  // 同步并刷新当前单位的防御
        function s__unitAttr_syncDefRate takes integer this returns nothing
            set s__unitAttr_DefRateBonus[this]=s__unitAttr_baseDef[this] * ( 1.0 + s__unitAttr_DefRateUp[this] ) * ( 1.0 - s__unitAttr_DefRateDown[this] ) - s__unitAttr_baseDef[this]
            call SetUnitState(s__unitAttr_u[this], ConvertUnitState(0x20), s__unitAttr_baseDef[this] + s__unitAttr_DefRateBonus[this] + s__unitAttr_DefFixedBonus[this])
            if ( s__unitAttr_trDefChange != null ) then
                set s__unitAttr_ethis=this
                call TriggerEvaluate(s__unitAttr_trDefChange)
            endif
        endfunction  // 引入攻击相关属性模块
//Implemented from module UnitAttrAttackModule:
        function s__unitAttr_getCurrentAtkRange takes integer this returns real
            return s__unitAttr_baseAtkRange[this] * ( 1.0 + s__unitAttr_AtkRangeRateUp[this] ) * ( 1.0 - s__unitAttr_AtkRangeRateDown[this] )
        endfunction  // 同步并刷新当前单位的攻击范围
        function s__unitAttr_UnitAttrAttackModule__syncAtkRange takes integer this returns nothing
            local real desiredRange=s__unitAttr_getCurrentAtkRange(this)
            call SetUnitState(s__unitAttr_u[this], 0x16, desiredRange) // 同时更新单位的主动攻击范围，但不超过900
            call SetUnitAcquireRange(s__unitAttr_u[this], RMaxBJ(desiredRange, 900.0))
        endfunction  // 攻击范围相关属性和方法
        function s__unitAttr_addAtkRange takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_baseAtkRange[this]=s__unitAttr_baseAtkRange[this] + value
                call s__unitAttr_UnitAttrAttackModule__syncAtkRange(this)
            endif
        endfunction
        function s__unitAttr_addAtkRangeRateUp takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_AtkRangeRateUp[this]=s__unitAttr_AtkRangeRateUp[this] + value
                call s__unitAttr_UnitAttrAttackModule__syncAtkRange(this)
            endif
        endfunction
        function s__unitAttr_addAtkRangeRateDown takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_AtkRangeRateDown[this]=RealAdd(s__unitAttr_AtkRangeRateDown[this] , value)
                call s__unitAttr_UnitAttrAttackModule__syncAtkRange(this)
            endif
        endfunction  // 攻击速度相关属性和方法
        function s__unitAttr_getCurrentAtkSpeed takes nothing returns real
            return s__unitAttr_baseAtkSpeed[this] * ( 1.0 - s__unitAttr_AtkSpeedRateDown[this] )
        endfunction  // 同步并刷新当前单位的攻击速度
        function s__unitAttr_UnitAttrAttackModule__syncAtkSpeed takes integer this returns nothing
            call SetUnitState(s__unitAttr_u[this], ConvertUnitState(0x51), s__unitAttr_getCurrentAtkSpeed())
        endfunction
        function s__unitAttr_addAtkSpeed takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_baseAtkSpeed[this]=s__unitAttr_baseAtkSpeed[this] + value
                call s__unitAttr_UnitAttrAttackModule__syncAtkSpeed(this)
            endif
        endfunction
        function s__unitAttr_addAtkSpdDown takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_AtkSpeedRateDown[this]=RealAdd(s__unitAttr_AtkSpeedRateDown[this] , value)
                call s__unitAttr_UnitAttrAttackModule__syncAtkSpeed(this)
            endif
        endfunction  // 攻击间隔相关属性和方法
        function s__unitAttr_getCurrentAtkInterval takes nothing returns real
            return s__unitAttr_baseAtkInterval[this] * ( 1.0 - s__unitAttr_AtkIntervalRateDown[this] )
        endfunction  // 同步并刷新当前单位的攻击间隔
        function s__unitAttr_UnitAttrAttackModule__syncAtkInterval takes integer this returns nothing
            call SetUnitState(s__unitAttr_u[this], ConvertUnitState(0x25), s__unitAttr_getCurrentAtkInterval())
        endfunction  // 设置基础的攻击间隔(这个一般不需要改)
        function s__unitAttr_setAtkInterval takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_baseAtkInterval[this]=s__unitAttr_baseAtkInterval[this] + value
                call s__unitAttr_UnitAttrAttackModule__syncAtkInterval(this)
            endif
        endfunction  // 按比例减少攻击间隔
        function s__unitAttr_addAtkItvDown takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_AtkIntervalRateDown[this]=RealAdd(s__unitAttr_AtkIntervalRateDown[this] , value)
                call s__unitAttr_UnitAttrAttackModule__syncAtkInterval(this)
            endif
        endfunction  // 初始化攻击相关属性
        function s__unitAttr_initAttackAttributes takes integer this returns nothing
            set s__unitAttr_baseAtkRange[this]=128
            set s__unitAttr_AtkRangeRateUp[this]=0
            set s__unitAttr_AtkRangeRateDown[this]=0
            call s__unitAttr_UnitAttrAttackModule__syncAtkRange(this) // 初始化攻击速度
            set s__unitAttr_baseAtkSpeed[this]=1.0
            set s__unitAttr_AtkSpeedRateDown[this]=0.0
            call s__unitAttr_UnitAttrAttackModule__syncAtkSpeed(this) // 初始化攻击间隔
            set s__unitAttr_baseAtkInterval[this]=1.0
            set s__unitAttr_AtkIntervalRateDown[this]=0.0
            call s__unitAttr_UnitAttrAttackModule__syncAtkInterval(this)
        endfunction
        function s__unitAttr_parse takes unit u returns integer
            local integer this
            local integer handleId=GetHandleId(u)
            if ( HaveSavedInteger(HASH_UNIT, handleId, 1726) ) then
                return LoadInteger(HASH_UNIT, handleId, 1726)
            endif // 不存在才创建新的
            set this=s__unitAttr__allocate()
            set s__unitAttr_u[this]=u
            set s__unitAttr_baseHP[this]=0
            set s__unitAttr_HPRateUp[this]=0
            set s__unitAttr_HPRateDown[this]=0
            set s__unitAttr_cachedHP[this]=0
            set s__unitAttr_baseMP[this]=0
            set s__unitAttr_MPRateUp[this]=0
            set s__unitAttr_MPRateDown[this]=0
            set s__unitAttr_cachedMP[this]=0
            set s__unitAttr_baseAtk[this]=0.0 // 初始化攻击力和防御力相关属性
            set s__unitAttr_AtkRateUp[this]=0.0
            set s__unitAttr_AtkRateDown[this]=0.0
            set s__unitAttr_AtkRateBonus[this]=0.0
            set s__unitAttr_AtkFixedBonus[this]=0.0
            set s__unitAttr_baseDef[this]=0.0
            set s__unitAttr_DefRateUp[this]=0.0
            set s__unitAttr_DefRateDown[this]=0.0
            set s__unitAttr_DefRateBonus[this]=0.0
            set s__unitAttr_DefFixedBonus[this]=0.0
            set s__unitAttr_SpellDmgRateUp[this]=0.0 // 初始化技能伤害增幅
            set s__unitAttr_SpellDmgRateDown[this]=0.0
            set s__unitAttr_FinalDmgRateRateUp[this]=0.0
            set s__unitAttr_FinalDmgRateRateDown[this]=0.0
            call s__unitAttr_initAttackAttributes(this) // 初始化攻击相关属性 //其他地图的自定义属性
//#             static if LIBRARY_AllUnitAttr then
//#                 call this.initAllUnitAttr()
//#             endif
            call SaveInteger(HASH_UNIT, handleId, 1726, this)
            return this
        endfunction  // 使用宏定义生成HP相关属性和方法
        function s__unitAttr_addHP takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_baseHP[this]=s__unitAttr_baseHP[this] + value
                call s__unitAttr_syncHPRate(this)
            endif
        endfunction
        function s__unitAttr_addHPRateUp takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_HPRateUp[this]=s__unitAttr_HPRateUp[this] + value
                call s__unitAttr_syncHPRate(this)
            endif
        endfunction
        function s__unitAttr_addHPRateDown takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_HPRateDown[this]=RealAdd(s__unitAttr_HPRateDown[this] , value)
                call s__unitAttr_syncHPRate(this)
            endif
        endfunction
        function s__unitAttr_getCurrentHPRate takes integer this returns real
            return ( 1.0 + s__unitAttr_HPRateUp[this] ) * ( 1.0 - s__unitAttr_HPRateDown[this] ) - 1.0
        endfunction
        function s__unitAttr_getCurrentHP takes integer this returns real
            return s__unitAttr_cachedHP[this]
        endfunction
        function s__unitAttr_addMP takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_baseMP[this]=s__unitAttr_baseMP[this] + value
                call s__unitAttr_syncMPRate(this)
            endif
        endfunction
        function s__unitAttr_addMPRateUp takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_MPRateUp[this]=s__unitAttr_MPRateUp[this] + value
                call s__unitAttr_syncMPRate(this)
            endif
        endfunction
        function s__unitAttr_addMPRateDown takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_MPRateDown[this]=RealAdd(s__unitAttr_MPRateDown[this] , value)
                call s__unitAttr_syncMPRate(this)
            endif
        endfunction
        function s__unitAttr_getCurrentMPRate takes integer this returns real
            return ( 1.0 + s__unitAttr_MPRateUp[this] ) * ( 1.0 - s__unitAttr_MPRateDown[this] ) - 1.0
        endfunction
        function s__unitAttr_getCurrentMP takes integer this returns real
            return s__unitAttr_cachedMP[this]
        endfunction
        function s__unitAttr_setBaseAtk takes integer this,real value returns nothing
            if ( s__unitAttr_baseAtk[this] != value ) then
                set s__unitAttr_baseAtk[this]=value
                call s__unitAttr_syncAtkRate(this)
            endif
        endfunction
        function s__unitAttr_addBaseAtk takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_baseAtk[this]=s__unitAttr_baseAtk[this] + value
                call s__unitAttr_syncAtkRate(this)
            endif
        endfunction
        function s__unitAttr_addAtkFixedBonus takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_AtkFixedBonus[this]=s__unitAttr_AtkFixedBonus[this] + value
                call s__unitAttr_syncAtkRate(this)
            endif
        endfunction
        function s__unitAttr_addAtkRateUp takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_AtkRateUp[this]=s__unitAttr_AtkRateUp[this] + value
                call s__unitAttr_syncAtkRate(this)
            endif
        endfunction
        function s__unitAttr_addAtkRateDown takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_AtkRateDown[this]=RealAdd(s__unitAttr_AtkRateDown[this] , value)
                call s__unitAttr_syncAtkRate(this)
            endif
        endfunction
        function s__unitAttr_getCurrentAtk takes integer this returns real
            return s__unitAttr_baseAtk[this] + s__unitAttr_AtkRateBonus[this] + s__unitAttr_AtkFixedBonus[this]
        endfunction
        function s__unitAttr_getCurrentAtkRate takes integer this returns real
            return ( 1.0 + s__unitAttr_AtkRateUp[this] ) * ( 1.0 - s__unitAttr_AtkRateDown[this] ) - 1.0
        endfunction
        function s__unitAttr_onAtkChange takes code func returns nothing
            if ( s__unitAttr_trAtkChange == null ) then
                set s__unitAttr_trAtkChange=CreateTrigger()
            endif
            call TriggerAddCondition(s__unitAttr_trAtkChange, Condition(func))
        endfunction
        function s__unitAttr_setBaseDef takes integer this,real value returns nothing
            if ( s__unitAttr_baseDef[this] != value ) then
                set s__unitAttr_baseDef[this]=value
                call s__unitAttr_syncDefRate(this)
            endif
        endfunction
        function s__unitAttr_addBaseDef takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_baseDef[this]=s__unitAttr_baseDef[this] + value
                call s__unitAttr_syncDefRate(this)
            endif
        endfunction
        function s__unitAttr_addDefFixedBonus takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_DefFixedBonus[this]=s__unitAttr_DefFixedBonus[this] + value
                call s__unitAttr_syncDefRate(this)
            endif
        endfunction
        function s__unitAttr_addDefRateUp takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_DefRateUp[this]=s__unitAttr_DefRateUp[this] + value
                call s__unitAttr_syncDefRate(this)
            endif
        endfunction
        function s__unitAttr_addDefRateDown takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_DefRateDown[this]=RealAdd(s__unitAttr_DefRateDown[this] , value)
                call s__unitAttr_syncDefRate(this)
            endif
        endfunction
        function s__unitAttr_getCurrentDef takes integer this returns real
            return s__unitAttr_baseDef[this] + s__unitAttr_DefRateBonus[this] + s__unitAttr_DefFixedBonus[this]
        endfunction
        function s__unitAttr_getCurrentDefRate takes integer this returns real
            return ( 1.0 + s__unitAttr_DefRateUp[this] ) * ( 1.0 - s__unitAttr_DefRateDown[this] ) - 1.0
        endfunction
        function s__unitAttr_onDefChange takes code func returns nothing
            if ( s__unitAttr_trDefChange == null ) then
                set s__unitAttr_trDefChange=CreateTrigger()
            endif
            call TriggerAddCondition(s__unitAttr_trDefChange, Condition(func))
        endfunction
        function s__unitAttr_addSpellDmgRateUp takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_SpellDmgRateUp[this]=s__unitAttr_SpellDmgRateUp[this] + value
            endif
        endfunction
        function s__unitAttr_addSpellDmgRateDown takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_SpellDmgRateDown[this]=RealAdd(s__unitAttr_SpellDmgRateDown[this] , value)
            endif
        endfunction
        function s__unitAttr_getCurrentSpellDmg takes integer this returns real
            return ( 1.0 + s__unitAttr_SpellDmgRateUp[this] ) * ( 1.0 - s__unitAttr_SpellDmgRateDown[this] ) - 1.0
        endfunction
        function s__unitAttr_addFinalDmgRateRateUp takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_FinalDmgRateRateUp[this]=s__unitAttr_FinalDmgRateRateUp[this] + value
            endif
        endfunction
        function s__unitAttr_addFinalDmgRateRateDown takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__unitAttr_FinalDmgRateRateDown[this]=RealAdd(s__unitAttr_FinalDmgRateRateDown[this] , value)
            endif
        endfunction
        function s__unitAttr_getCurrentFinalDmgRate takes integer this returns real
            return ( 1.0 + s__unitAttr_FinalDmgRateRateUp[this] ) * ( 1.0 - s__unitAttr_FinalDmgRateRateDown[this] ) - 1.0
        endfunction
        function s__unitAttr_onDestroy takes integer this returns nothing
            if ( HaveSavedInteger(HASH_UNIT, GetHandleId(s__unitAttr_u[this]), 1726) ) then
                call RemoveSavedInteger(HASH_UNIT, GetHandleId(s__unitAttr_u[this]), 1726)
            endif
            set s__unitAttr_u[this]=null
        endfunction  //注册到周期结束中

//Generated destructor of unitAttr
function s__unitAttr_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: unitAttr")
        return
    elseif (si__unitAttr_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: unitAttr")
        return
    endif
    call s__unitAttr_onDestroy(this)
    set si__unitAttr_V[this]=si__unitAttr_F
    set si__unitAttr_F=this
endfunction
            function s__unitAttr_anon__0 takes nothing returns nothing
                local unit u=s__unitLifeCycle_argsUnit
                local integer this=s__unitAttr_parse(u)
                if ( s__unitAttr_isExist(this) ) then
                    call s__unitAttr_deallocate(this)
                endif
                set u=null
            endfunction
        function s__unitAttr_onInit takes nothing returns nothing
            call s__unitLifeCycle_registerDestroy(function s__unitAttr_anon__0)
        endfunction

//library UnitAttr ends
//library UTUnitAttr:

    function UTUnitAttr___CreateTestUnit takes player p returns nothing
        if ( UTUnitAttr___testUnit != null ) then
            call h__RemoveUnit(UTUnitAttr___testUnit)
        endif // 默认使用步兵作为测试单位
        set UTUnitAttr___testUnit=CreateUnit(p, 'hfoo', 0, 0, 0)
        set UTUnitAttr___testAttr=s__unitAttr_parse(UTUnitAttr___testUnit)
        call s__unitAttr_addHP(UTUnitAttr___testAttr,100)
        call SelectUnit(UTUnitAttr___testUnit, true)
    endfunction  // 创建弓箭手测试单位
    function UTUnitAttr___CreateArcherUnit takes player p returns nothing
        if ( UTUnitAttr___testUnit != null ) then
            call h__RemoveUnit(UTUnitAttr___testUnit)
        endif // 使用精灵弓箭手
        set UTUnitAttr___testUnit=CreateUnit(p, 'earc', 0, 0, 0)
        set UTUnitAttr___testAttr=s__unitAttr_parse(UTUnitAttr___testUnit)
        call s__unitAttr_addHP(UTUnitAttr___testAttr,100)
        call SelectUnit(UTUnitAttr___testUnit, true)
    endfunction  // 测试基础HP的增减
    function UTUnitAttr___TTestUTUnitAttr1 takes player p returns nothing
    endfunction  // 测试HP增幅比例
    function UTUnitAttr___TTestUTUnitAttr2 takes player p returns nothing
    endfunction  // 测试HP减幅比例
    function UTUnitAttr___TTestUTUnitAttr3 takes player p returns nothing
    endfunction  // 测试HP增减幅组合效果
    function UTUnitAttr___TTestUTUnitAttr4 takes player p returns nothing
    endfunction  // 参数化测试处理函数
    function UTUnitAttr___TTestActUTUnitAttr1 takes string str returns nothing
        local player p=GetTriggerPlayer()
        local integer index=GetConvertedPlayerId(p)
        local integer i
        local integer num=0
        local integer len=StringLength(str)
        local string array paramS
        local integer array paramI
        local real array paramR
        local unit enemy
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
        if ( UTUnitAttr___testUnit == null ) then
            call UTUnitAttr___CreateTestUnit(p)
        endif // HP相关命令
        if ( paramS[0] == "addhp" ) then // 增加基础HP
            call s__unitAttr_addHP(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("增加基础HP: " + R2S(paramR[1]))
        elseif ( paramS[0] == "hpup" ) then // 设置HP增幅
            call s__unitAttr_addHPRateUp(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("设置HP增幅为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "hpdown" ) then // 设置HP减幅
            call s__unitAttr_addHPRateDown(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("设置HP减幅为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "addmp" ) then // MP相关命令 // 增加基础MP
            call s__unitAttr_addMP(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("增加基础MP: " + R2S(paramR[1]))
        elseif ( paramS[0] == "mpup" ) then // 设置MP增幅
            call s__unitAttr_addMPRateUp(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("设置MP增幅为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "mpdown" ) then // 设置MP减幅
            call s__unitAttr_addMPRateDown(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("设置MP减幅为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "atk" ) then // 攻击力相关命令 // 设置基础攻击力
            call s__unitAttr_setBaseAtk(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("设置基础攻击力为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "addatk" ) then // 增加基础攻击力
            call s__unitAttr_addBaseAtk(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("增加基础攻击力: " + R2S(paramR[1]))
        elseif ( paramS[0] == "atkup" ) then // 设置攻击力增幅
            call s__unitAttr_addAtkRateUp(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("设置攻击力增幅为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "atkdown" ) then // 设置攻击力减幅
            call s__unitAttr_addAtkRateDown(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("设置攻击力减幅为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "atkbonus" ) then // 设置固定加成
            call s__unitAttr_addAtkFixedBonus(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("设置固定加成为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "def" ) then // 防御力相关命令 // 设置基础防御力
            call s__unitAttr_setBaseDef(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("设置基础防御力为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "adddef" ) then // 增加基础防御力
            call s__unitAttr_addBaseDef(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("增加基础防御力: " + R2S(paramR[1]))
        elseif ( paramS[0] == "defup" ) then // 设置防御力增幅
            call s__unitAttr_addDefRateUp(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("设置防御力增幅为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "defdown" ) then // 设置防御力减幅
            call s__unitAttr_addDefRateDown(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("设置防御力减幅为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "defbonus" ) then // 设置固定加成
            call s__unitAttr_addDefFixedBonus(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("设置防御力固定加成为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "atkspd" ) then // 攻击速度相关命令 // 增加基础攻击速度
            call s__unitAttr_addAtkSpeed(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("增加基础攻击速度: " + R2S(paramR[1]))
            call BJDebugMsg("当前攻击速度: " + R2S(s__unitAttr_getCurrentAtkSpeed()))
        elseif ( paramS[0] == "atkspddown" ) then // 设置攻击速度减速比例
            call s__unitAttr_addAtkSpdDown(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("设置攻击速度减速比例: " + R2S(paramR[1]))
            call BJDebugMsg("当前攻击速度: " + R2S(s__unitAttr_getCurrentAtkSpeed()))
        elseif ( paramS[0] == "atkrange" ) then // 攻击范围相关命令 // 增加基础攻击范围
            call s__unitAttr_addAtkRange(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("增加基础攻击范围: " + R2S(paramR[1]))
            call BJDebugMsg("当前攻击范围: " + R2S(s__unitAttr_getCurrentAtkRange(UTUnitAttr___testAttr)))
        elseif ( paramS[0] == "atkrangeup" ) then // 设置攻击范围增幅
            call s__unitAttr_addAtkRangeRateUp(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("设置攻击范围增幅: " + R2S(paramR[1]))
            call BJDebugMsg("当前攻击范围: " + R2S(s__unitAttr_getCurrentAtkRange(UTUnitAttr___testAttr)))
        elseif ( paramS[0] == "atkrangedown" ) then // 设置攻击范围减幅
            call s__unitAttr_addAtkRangeRateDown(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("设置攻击范围减幅: " + R2S(paramR[1]))
            call BJDebugMsg("当前攻击范围: " + R2S(s__unitAttr_getCurrentAtkRange(UTUnitAttr___testAttr)))
        elseif ( paramS[0] == "atkinterval" ) then // 攻击间隔相关命令 // 增加基础攻击间隔
            call s__unitAttr_addAtkItvDown(UTUnitAttr___testAttr,paramR[1])
            call BJDebugMsg("攻击间隔百分比减少: " + R2S(paramR[1]))
            call BJDebugMsg("当前攻击间隔: " + R2S(s__unitAttr_getCurrentAtkInterval()))
        elseif ( paramS[0] == "archer" ) then // 其他测试命令 // 切换为弓箭手单位
            call UTUnitAttr___CreateArcherUnit(p)
            call BJDebugMsg("已切换为弓箭手单位进行测试")
        elseif ( paramS[0] == "enemy" ) then // 创建敌对单位
            set i=0
            loop
            exitwhen ( i >= paramI[1] )
                set enemy=CreateUnit(Player(11), 'hfoo', 500, 200 + i * 100, 270)
                call SetUnitOwner(enemy, Player(11), true) // 设置敌对关系
                call SetPlayerAllianceStateAllyBJ(Player(11), p, false)
                call SetPlayerAllianceStateVisionBJ(Player(11), p, false)
            set i=i + 1
            endloop
            call BJDebugMsg("已创建 " + I2S(paramI[1]) + " 个敌对单位")
        endif // 显示当前状态
        if ( paramS[0] == "addhp" or paramS[0] == "hpup" or paramS[0] == "hpdown" ) then
            call BJDebugMsg("当前HP: " + R2S(s__unitAttr_getCurrentHP(UTUnitAttr___testAttr)))
            call BJDebugMsg("当前HP倍率: " + R2S(s__unitAttr_getCurrentHPRate(UTUnitAttr___testAttr)))
        elseif ( paramS[0] == "addmp" or paramS[0] == "mpup" or paramS[0] == "mpdown" ) then
            call BJDebugMsg("当前MP: " + R2S(s__unitAttr_getCurrentMP(UTUnitAttr___testAttr)))
            call BJDebugMsg("当前MP倍率: " + R2S(s__unitAttr_getCurrentMPRate(UTUnitAttr___testAttr)))
        elseif ( paramS[0] == "def" or paramS[0] == "adddef" or paramS[0] == "defup" or paramS[0] == "defdown" or paramS[0] == "defbonus" ) then
            call BJDebugMsg("防御力: " + R2S(s__unitAttr_baseDef[UTUnitAttr___testAttr]) + " + " + R2S(s__unitAttr_DefRateBonus[UTUnitAttr___testAttr] + s__unitAttr_DefFixedBonus[UTUnitAttr___testAttr]))
        else
            call BJDebugMsg("攻击力: " + R2S(s__unitAttr_baseAtk[UTUnitAttr___testAttr]) + " + " + R2S(s__unitAttr_AtkRateBonus[UTUnitAttr___testAttr] + s__unitAttr_AtkFixedBonus[UTUnitAttr___testAttr]))
        endif
        set p=null
    endfunction
        function UTUnitAttr___anon__0 takes nothing returns nothing
            call s__assert_Real(s__unitAttr_getCurrentHP(UTUnitAttr___testAttr) , 100.0 , "初始HP应为100")
        endfunction  // 测试1.2：测试增加HP
        function UTUnitAttr___anon__1 takes nothing returns nothing
            call s__unitAttr_addHP(UTUnitAttr___testAttr,50)
            call s__assert_Real(s__unitAttr_getCurrentHP(UTUnitAttr___testAttr) , 150.0 , "增加50点HP后应为150")
        endfunction  // 测试1.3：测试减少HP
        function UTUnitAttr___anon__2 takes nothing returns nothing
            call s__unitAttr_addHP(UTUnitAttr___testAttr,- 30)
            call s__assert_Real(s__unitAttr_getCurrentHP(UTUnitAttr___testAttr) , 120.0 , "减少30点HP后应为120")
        endfunction  // 测试2：HP增幅比例测试
        function UTUnitAttr___anon__3 takes nothing returns nothing
            call UTUnitAttr___CreateTestUnit(Player(0))
            call s__unitAttr_addHPRateUp(UTUnitAttr___testAttr,0.5)
            call s__assert_Real(s__unitAttr_getCurrentHP(UTUnitAttr___testAttr) , 150.0 , "增加50%增幅后应为150")
            call s__assert_Real(s__unitAttr_getCurrentHPRate(UTUnitAttr___testAttr) , 0.5 , "当前HP倍率应为0.5")
        endfunction  // 测试3：HP减幅比例测试
        function UTUnitAttr___anon__4 takes nothing returns nothing
            call UTUnitAttr___CreateTestUnit(Player(0))
            call s__unitAttr_addHPRateDown(UTUnitAttr___testAttr,0.3)
            call s__assert_Real(s__unitAttr_getCurrentHP(UTUnitAttr___testAttr) , 70.0 , "增加30%减幅后应为70")
            call s__assert_Real(s__unitAttr_getCurrentHPRate(UTUnitAttr___testAttr) , - 0.3 , "当前HP倍率应为-0.3")
        endfunction  // 测试4：HP增减幅组合效果测试
        function UTUnitAttr___anon__5 takes nothing returns nothing
            call UTUnitAttr___CreateTestUnit(Player(0))
            call s__unitAttr_addHPRateUp(UTUnitAttr___testAttr,0.5)
            call s__unitAttr_addHPRateDown(UTUnitAttr___testAttr,0.2)
            call s__assert_Real(s__unitAttr_getCurrentHP(UTUnitAttr___testAttr) , 120.0 , "增加50%增幅,20%减幅后应为120")
            call s__assert_Real(s__unitAttr_getCurrentHPRate(UTUnitAttr___testAttr) , 0.2 , "当前HP倍率应为0.2")
        endfunction  // 测试5：HP减幅的递减收益测试
        function UTUnitAttr___anon__6 takes nothing returns nothing
            call UTUnitAttr___CreateTestUnit(Player(0)) // 测试两个30%减幅的叠加
            call s__unitAttr_addHPRateDown(UTUnitAttr___testAttr,0.3)
            call s__unitAttr_addHPRateDown(UTUnitAttr___testAttr,0.3) // 期望值：1 - (1-0.3)*(1-0.3) = 0.51，所以最终HP应该是100*(1-0.51)=49
            call s__assert_Real(s__unitAttr_getCurrentHP(UTUnitAttr___testAttr) , 49.0 , "两个30%减幅叠加后应为49")
            call s__assert_Real(s__unitAttr_HPRateDown[UTUnitAttr___testAttr] , 0.51 , "两个30%减幅叠加后减幅值应为0.51") // 测试第三个30%减幅的叠加
            call s__unitAttr_addHPRateDown(UTUnitAttr___testAttr,0.3) // 期望值：1 - (1-0.51)*(1-0.3) ≈ 0.657，所以最终HP应该是100*(1-0.657)=34.3
            call s__assert_Real(s__unitAttr_getCurrentHP(UTUnitAttr___testAttr) , 34.3 , "三个30%减幅叠加后应为34.3")
            call s__assert_Real(s__unitAttr_HPRateDown[UTUnitAttr___testAttr] , 0.657 , "三个30%减幅叠加后减幅值应为0.657")
        endfunction  // 测试6：HP减幅的反向恢复测试
        function UTUnitAttr___anon__7 takes nothing returns nothing
            call UTUnitAttr___CreateTestUnit(Player(0)) // 先加一个减幅
            call s__unitAttr_addHPRateDown(UTUnitAttr___testAttr,0.3)
            call s__assert_Real(s__unitAttr_getCurrentHP(UTUnitAttr___testAttr) , 70.0 , "30%减幅后应为70") // 加入反向值测试恢复
            call s__unitAttr_addHPRateDown(UTUnitAttr___testAttr,- 0.3)
            call s__assert_Real(s__unitAttr_getCurrentHP(UTUnitAttr___testAttr) , 100.0 , "加入反向值后应恢复到100")
            call s__assert_Real(s__unitAttr_HPRateDown[UTUnitAttr___testAttr] , 0.0 , "加入反向值后减幅应为0")
        endfunction  // 测试7：HP减幅的复杂叠加测试
        function UTUnitAttr___anon__8 takes nothing returns nothing
            call UTUnitAttr___CreateTestUnit(Player(0)) // 测试多个不同数值的减幅叠加
            call s__unitAttr_addHPRateDown(UTUnitAttr___testAttr,0.2) // 20%减幅 // 30%减幅
            call s__unitAttr_addHPRateDown(UTUnitAttr___testAttr,0.3) // 10%减幅
            call s__unitAttr_addHPRateDown(UTUnitAttr___testAttr,0.1) // 计算期望值：
            call s__assert_Real(s__unitAttr_getCurrentHP(UTUnitAttr___testAttr) , 50.4 , "20%,30%,10%减幅叠加后应为50.4") // 第一次：0.2 // 第二次：1-(1-0.2)*(1-0.3) = 0.44 // 第三次：1-(1-0.44)*(1-0.1) ≈ 0.496
            call s__assert_Real(s__unitAttr_HPRateDown[UTUnitAttr___testAttr] , 0.496 , "20%,30%,10%减幅叠加后减幅值应为0.496")
        endfunction  // 测试8：基础攻击力测试
        function UTUnitAttr___anon__9 takes nothing returns nothing
            call UTUnitAttr___CreateTestUnit(Player(0)) // 测试设置基础攻击力
            call s__unitAttr_setBaseAtk(UTUnitAttr___testAttr,100.0)
            call s__assert_Real(s__unitAttr_baseAtk[UTUnitAttr___testAttr] , 100.0 , "设置基础攻击力应为100")
            call s__assert_Real(s__unitAttr_getCurrentAtk(UTUnitAttr___testAttr) , 100.0 , "当前攻击力应为100") // 测试增加基础攻击力
            call s__unitAttr_addBaseAtk(UTUnitAttr___testAttr,50.0)
            call s__assert_Real(s__unitAttr_baseAtk[UTUnitAttr___testAttr] , 150.0 , "增加50点后基础攻击力应为150")
            call s__assert_Real(s__unitAttr_getCurrentAtk(UTUnitAttr___testAttr) , 150.0 , "当前攻击力应为150")
        endfunction  // 测试9：攻击力增幅测试
        function UTUnitAttr___anon__10 takes nothing returns nothing
            call UTUnitAttr___CreateTestUnit(Player(0))
            call s__unitAttr_setBaseAtk(UTUnitAttr___testAttr,100.0) // 测试增幅效果
            call s__unitAttr_addAtkRateUp(UTUnitAttr___testAttr,0.5) // 增加50%
            call s__assert_Real(s__unitAttr_getCurrentAtk(UTUnitAttr___testAttr) , 150.0 , "50%增幅后攻击力应为150")
            call s__assert_Real(s__unitAttr_getCurrentAtkRate(UTUnitAttr___testAttr) , 0.5 , "当前攻击力倍率应为0.5") // 测试固定加成
            call s__unitAttr_addAtkFixedBonus(UTUnitAttr___testAttr,30.0)
            call s__assert_Real(s__unitAttr_getCurrentAtk(UTUnitAttr___testAttr) , 180.0 , "加30点固定加成后应为180")
            call s__assert_Real(s__unitAttr_AtkFixedBonus[UTUnitAttr___testAttr] , 30.0 , "固定加成应为30")
        endfunction  // 测试10：攻击力减幅的递减收益测试
        function UTUnitAttr___anon__11 takes nothing returns nothing
            call UTUnitAttr___CreateTestUnit(Player(0))
            call s__unitAttr_setBaseAtk(UTUnitAttr___testAttr,100.0) // 测试两个30%减幅的叠加
            call s__unitAttr_addAtkRateDown(UTUnitAttr___testAttr,0.3)
            call s__unitAttr_addAtkRateDown(UTUnitAttr___testAttr,0.3) // 期望值：1 - (1-0.3)*(1-0.3) = 0.51
            call s__assert_Real(s__unitAttr_getCurrentAtk(UTUnitAttr___testAttr) , 49.0 , "两个30%减幅叠加后攻击力应为49")
            call s__assert_Real(s__unitAttr_AtkRateDown[UTUnitAttr___testAttr] , 0.51 , "两个30%减幅叠加后减幅值应为0.51") // 测试第三个30%减幅的叠加
            call s__unitAttr_addAtkRateDown(UTUnitAttr___testAttr,0.3) // 期望值：1 - (1-0.51)*(1-0.3) ≈ 0.657
            call s__assert_Real(s__unitAttr_getCurrentAtk(UTUnitAttr___testAttr) , 34.3 , "三个30%减幅叠加后攻击力应为34.3")
            call s__assert_Real(s__unitAttr_AtkRateDown[UTUnitAttr___testAttr] , 0.657 , "三个30%减幅叠加后减幅值应为0.657") // 测试恢复减幅效果
            call s__unitAttr_addAtkRateDown(UTUnitAttr___testAttr,- 0.3)
            call s__unitAttr_addAtkRateDown(UTUnitAttr___testAttr,- 0.3)
            call s__unitAttr_addAtkRateDown(UTUnitAttr___testAttr,- 0.3)
            call s__assert_Real(s__unitAttr_getCurrentAtk(UTUnitAttr___testAttr) , 100.0 , "三个-30%减幅叠加后攻击力应恢复为100")
            call s__assert_Real(s__unitAttr_AtkRateDown[UTUnitAttr___testAttr] , 0.0 , "三个-30%减幅叠加后减幅值应恢复为0")
        endfunction  // 测试11：攻击力增减幅组合效果测试
        function UTUnitAttr___anon__12 takes nothing returns nothing
            call UTUnitAttr___CreateTestUnit(Player(0))
            call s__unitAttr_setBaseAtk(UTUnitAttr___testAttr,100.0) // 测试增幅和减幅的组合效果
            call s__unitAttr_addAtkRateUp(UTUnitAttr___testAttr,0.5) // 增加50% // 减少20%
            call s__unitAttr_addAtkRateDown(UTUnitAttr___testAttr,0.2) // 计算：100 * (1 + 0.5) * (1 - 0.2) = 120
            call s__assert_Real(s__unitAttr_getCurrentAtk(UTUnitAttr___testAttr) , 120.0 , "50%增幅20%减幅后攻击力应为120")
            call s__assert_Real(s__unitAttr_getCurrentAtkRate(UTUnitAttr___testAttr) , 0.2 , "当前攻击力倍率应为0.2") // 添加固定加成测试
            call s__unitAttr_addAtkFixedBonus(UTUnitAttr___testAttr,30.0)
            call s__assert_Real(s__unitAttr_getCurrentAtk(UTUnitAttr___testAttr) , 150.0 , "加30点固定加成后应为150")
        endfunction
    function UTUnitAttr___Init takes nothing returns nothing
        local player p=Player(0)
        call BJDebugMsg("=== UnitAttr测试系统已加载 ===")
        call UTUnitAttr___CreateTestUnit(p)
        call UnitTestAutoTimer(0.1 , 0 , function UTUnitAttr___anon__0 , null)
        call UnitTestAutoTimer(0.6 , 0 , function UTUnitAttr___anon__1 , null)
        call UnitTestAutoTimer(1.1 , 0 , function UTUnitAttr___anon__2 , null)
        call UnitTestAutoTimer(1.6 , 0 , function UTUnitAttr___anon__3 , null)
        call UnitTestAutoTimer(2.1 , 0 , function UTUnitAttr___anon__4 , null)
        call UnitTestAutoTimer(2.6 , 0 , function UTUnitAttr___anon__5 , null)
        call UnitTestAutoTimer(3.1 , 0 , function UTUnitAttr___anon__6 , null)
        call UnitTestAutoTimer(3.6 , 0 , function UTUnitAttr___anon__7 , null)
        call UnitTestAutoTimer(4.1 , 0 , function UTUnitAttr___anon__8 , null)
        call UnitTestAutoTimer(4.6 , 0 , function UTUnitAttr___anon__9 , null)
        call UnitTestAutoTimer(5.1 , 0 , function UTUnitAttr___anon__10 , null)
        call UnitTestAutoTimer(5.6 , 0 , function UTUnitAttr___anon__11 , null)
        call UnitTestAutoTimer(6.1 , 0 , function UTUnitAttr___anon__12 , null)
        set p=null
    endfunction
        function UTUnitAttr___anon__13 takes nothing returns nothing
            call UTUnitAttr___Init()
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTUnitAttr___anon__14 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            if ( SubString(str, ( 1 ) - 1, 1) == "-" ) then
                call UTUnitAttr___TTestActUTUnitAttr1(SubString(str, ( 2 ) - 1, StringLength(str)))
                return
            endif
            if ( str == "hp1" ) then
                call UTUnitAttr___TTestUTUnitAttr1(GetTriggerPlayer())
            elseif ( str == "hp2" ) then
                call UTUnitAttr___TTestUTUnitAttr2(GetTriggerPlayer())
            elseif ( str == "hp3" ) then
                call UTUnitAttr___TTestUTUnitAttr3(GetTriggerPlayer())
            elseif ( str == "hp4" ) then
                call UTUnitAttr___TTestUTUnitAttr4(GetTriggerPlayer())
            endif
        endfunction
    function UTUnitAttr___onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr, 0.5, false)
        call TriggerAddCondition(tr, Condition(function UTUnitAttr___anon__13))
        set tr=null
        call UnitTestRegisterChatEvent(function UTUnitAttr___anon__14)
    endfunction

//library UTUnitAttr ends
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerSelectionEventBJ.h>
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerKeyEventBJ.h>
//#  define TriggerRegisterPlayerUnitEventSimple(trig, p, e)                 TriggerRegisterPlayerUnitEvent(trig, p, e, null)
//#  define TriggerRegisterPlayerEventVictory(trig, player)                  TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_VICTORY)
//#  define TriggerRegisterPlayerEventDefeat(trig, player)                   TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_DEFEAT)
//#  define TriggerRegisterPlayerEventLeave(trig, player)                    TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_LEAVE)
//#  define TriggerRegisterPlayerEventAllianceChanged(trig, player)          TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_ALLIANCE_CHANGED)
//#  define TriggerRegisterPlayerEventEndCinematic(trig, player)             TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_END_CINEMATIC)
// 原生UI的大小

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










// 结构体共用方法定义
//共享打印方法
// UI组件内部共享方法及成员
// UI组件依赖库
// UI组件创建时共享调用
// UI组件销毁时共享调用

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
//processed hook: hook RemoveUnit unitLifeCycle.onDestroyCB
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

call ExecuteFunc("jasshelper__initstructs28983796")
call ExecuteFunc("UnitTestFramwork__onInit")
call ExecuteFunc("UTUnitAttr___onInit")

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
function sa__unitAttr_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            if ( HaveSavedInteger(HASH_UNIT, GetHandleId(s__unitAttr_u[this]), 1726) ) then
                call RemoveSavedInteger(HASH_UNIT, GetHandleId(s__unitAttr_u[this]), 1726)
            endif
            set s__unitAttr_u[this]=null
   return true
endfunction
function sa__unitLifeCycle_onDestroyCB takes nothing returns boolean
    call s__unitLifeCycle_onDestroyCB(f__arg_unit1)
   return true
endfunction

function jasshelper__initstructs28983796 takes nothing returns nothing
    set st__unitAttr_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__unitAttr_onDestroy,Condition( function sa__unitAttr_onDestroy))
    set st__unitLifeCycle_onDestroyCB=CreateTrigger()
    call TriggerAddCondition(st__unitLifeCycle_onDestroyCB,Condition( function sa__unitLifeCycle_onDestroyCB))






    call ExecuteFunc("s__mapBounds_onInit")
    call ExecuteFunc("s__unitLifeCycle_onInit")
    call ExecuteFunc("s__unitAttr_onInit")
endfunction

