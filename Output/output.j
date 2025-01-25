globals
//globals from MapBoundsUtils:
constant boolean LIBRARY_MapBoundsUtils=true
//endglobals from MapBoundsUtils
//globals from MathUtils:
constant boolean LIBRARY_MathUtils=true
//endglobals from MathUtils
//globals from UnitHashTable:
constant boolean LIBRARY_UnitHashTable=true
hashtable HASH_UNIT=InitHashtable()
//endglobals from UnitHashTable
//globals from UnitLifeCycle:
constant boolean LIBRARY_UnitLifeCycle=true
//endglobals from UnitLifeCycle
//globals from UnitRegen:
constant boolean LIBRARY_UnitRegen=true
//endglobals from UnitRegen
//globals from UnitTestFramwork:
constant boolean LIBRARY_UnitTestFramwork=true
trigger UnitTestFramwork__TUnitTest=null
hashtable UnitTestFramwork__HASH_UNITTEST=InitHashtable()
//endglobals from UnitTestFramwork
//globals from UTUnitRegen:
constant boolean LIBRARY_UTUnitRegen=true
unit UTUnitRegen__testUnit=null
unit UTUnitRegen__testUnit2=null
//endglobals from UTUnitRegen
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
constant integer si__unitRegen=4
integer si__unitRegen_F=0
integer si__unitRegen_I=0
integer array si__unitRegen_V
group s__unitRegen_regenGroup=CreateGroup()
unit array s__unitRegen_u
real array s__unitRegen_HPRegenFixed
real array s__unitRegen_MPRegenFixed
real array s__unitRegen_HPRegenPercent
real array s__unitRegen_MPRegenPercent
real array s__unitRegen_RegenEffectUp
real array s__unitRegen_RegenEffectDown
constant integer si__assert=5
trigger st__unitLifeCycle_onDestroyCB
trigger st__unitRegen_onDestroy
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

//Generated method caller for unitRegen.onDestroy
function sc__unitRegen_onDestroy takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__unitRegen_onDestroy)
endfunction

//Generated allocator of unitRegen
function s__unitRegen__allocate takes nothing returns integer
 local integer this=si__unitRegen_F
    if (this!=0) then
        set si__unitRegen_F=si__unitRegen_V[this]
    else
        set si__unitRegen_I=si__unitRegen_I+1
        set this=si__unitRegen_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: unitRegen")
        return 0
    endif

   set s__unitRegen_HPRegenFixed[this]=0.0 // 每秒定量回血 
   set s__unitRegen_MPRegenFixed[this]=0.0
   set s__unitRegen_HPRegenPercent[this]=0.0 // 每秒百分比回血 
   set s__unitRegen_MPRegenPercent[this]=0.0
   set s__unitRegen_RegenEffectUp[this]=0.0 // 回复效益增幅 
   set s__unitRegen_RegenEffectDown[this]=0.0
    set si__unitRegen_V[this]=-1
 return this
endfunction

//Generated destructor of unitRegen
function sc__unitRegen_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: unitRegen")
        return
    elseif (si__unitRegen_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: unitRegen")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__unitRegen_onDestroy)
    set si__unitRegen_V[this]=si__unitRegen_F
    set si__unitRegen_F=this
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
//library UnitRegen:
        function s__unitRegen_isExist takes integer this returns boolean
            return ( this != null and si__unitRegen_V[this] == - 1 )
        endfunction
        function s__unitRegen_getCurrentRegenEffect takes integer this returns real
            return ( 1.0 + s__unitRegen_RegenEffectUp[this] ) * ( 1.0 - s__unitRegen_RegenEffectDown[this] )
        endfunction  // 增加定量回血
        function s__unitRegen_addHPFixedRegen takes integer this,real value returns nothing
            set s__unitRegen_HPRegenFixed[this]=s__unitRegen_HPRegenFixed[this] + value
        endfunction  // 增加定量回魔
        function s__unitRegen_addMPFixedRegen takes integer this,real value returns nothing
            set s__unitRegen_MPRegenFixed[this]=s__unitRegen_MPRegenFixed[this] + value
        endfunction  // 增加百分比回血
        function s__unitRegen_addHPPercentRegen takes integer this,real value returns nothing
            set s__unitRegen_HPRegenPercent[this]=s__unitRegen_HPRegenPercent[this] + value
        endfunction  // 增加百分比回魔
        function s__unitRegen_addMPPercentRegen takes integer this,real value returns nothing
            set s__unitRegen_MPRegenPercent[this]=s__unitRegen_MPRegenPercent[this] + value
        endfunction  // 增加回复效益增幅
        function s__unitRegen_addRegenEffectUp takes integer this,real up returns nothing
            set s__unitRegen_RegenEffectUp[this]=s__unitRegen_RegenEffectUp[this] + up
        endfunction  // 增加回复效益减幅
        function s__unitRegen_addRegenEffectDown takes integer this,real down returns nothing
            set s__unitRegen_RegenEffectDown[this]=RealAdd(s__unitRegen_RegenEffectDown[this] , down)
        endfunction
        function s__unitRegen_parse takes unit u returns integer
            local integer this
            local integer handleId=GetHandleId(u)
            if ( HaveSavedInteger(HASH_UNIT, handleId, 1728) ) then
                return LoadInteger(HASH_UNIT, handleId, 1728)
            endif // 不存在才创建新的
            set this=s__unitRegen__allocate()
            set s__unitRegen_u[this]=u
            call SaveInteger(HASH_UNIT, handleId, 1728, this) // 初始化所有回复相关的属性
            set s__unitRegen_HPRegenFixed[this]=0.0
            set s__unitRegen_MPRegenFixed[this]=0.0
            set s__unitRegen_HPRegenPercent[this]=0.0
            set s__unitRegen_MPRegenPercent[this]=0.0
            set s__unitRegen_RegenEffectUp[this]=0.0
            set s__unitRegen_RegenEffectDown[this]=0.0 // 将单位添加到回复组
            call GroupAddUnit(s__unitRegen_regenGroup, u)
            return this
        endfunction
        function s__unitRegen_get takes unit u returns integer
            if ( HaveSavedInteger(HASH_UNIT, GetHandleId(u), 1728) ) then
                return LoadInteger(HASH_UNIT, GetHandleId(u), 1728)
            endif
            return 0
        endfunction
        function s__unitRegen_onDestroy takes integer this returns nothing
            call GroupRemoveUnit(s__unitRegen_regenGroup, s__unitRegen_u[this])
            if ( HaveSavedInteger(HASH_UNIT, GetHandleId(s__unitRegen_u[this]), 1728) ) then
                call RemoveSavedInteger(HASH_UNIT, GetHandleId(s__unitRegen_u[this]), 1728)
            endif
        endfunction  // 初始化计时器

//Generated destructor of unitRegen
function s__unitRegen_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: unitRegen")
        return
    elseif (si__unitRegen_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: unitRegen")
        return
    endif
    call s__unitRegen_onDestroy(this)
    set si__unitRegen_V[this]=si__unitRegen_F
    set si__unitRegen_F=this
endfunction
                function s__unitRegen_anon__1 takes nothing returns nothing
                    local real hpRegen
                    local real mpRegen
                    local real eft
                    local integer this=s__unitRegen_get(GetEnumUnit())
                    if ( s__unitRegen_isExist(this) ) then
                        set eft=s__unitRegen_getCurrentRegenEffect(this) // 计算总回血量
                        set hpRegen=( s__unitRegen_HPRegenFixed[this] + GetUnitState(GetEnumUnit(), UNIT_STATE_MAX_LIFE) * s__unitRegen_HPRegenPercent[this] ) * eft * 0.25
                        if ( hpRegen > 0 and GetUnitState(GetEnumUnit(), UNIT_STATE_LIFE) > 0 ) then
                            call SetUnitState(GetEnumUnit(), UNIT_STATE_LIFE, GetUnitState(GetEnumUnit(), UNIT_STATE_LIFE) + hpRegen)
                        endif // 计算总回魔量
                        set mpRegen=( s__unitRegen_MPRegenFixed[this] + GetUnitState(GetEnumUnit(), UNIT_STATE_MAX_MANA) * s__unitRegen_MPRegenPercent[this] ) * eft * 0.25
                        if ( mpRegen > 0 ) then
                            call SetUnitState(GetEnumUnit(), UNIT_STATE_MANA, GetUnitState(GetEnumUnit(), UNIT_STATE_MANA) + mpRegen)
                        endif
                    endif
                endfunction
            function s__unitRegen_anon__0 takes nothing returns nothing
                call ForGroup(s__unitRegen_regenGroup, function s__unitRegen_anon__1)
            endfunction  // 单位销毁时销毁回复属性
            function s__unitRegen_anon__2 takes nothing returns nothing
                local unit u=s__unitLifeCycle_argsUnit
                local integer this=s__unitRegen_get(u)
                if ( s__unitRegen_isExist(this) ) then
                    call s__unitRegen_deallocate(this)
                endif
                set u=null
            endfunction
        function s__unitRegen_onInit takes nothing returns nothing
            call TimerStart(CreateTimer(), 0.25, true, function s__unitRegen_anon__0)
            call s__unitLifeCycle_registerDestroy(function s__unitRegen_anon__2)
        endfunction

//library UnitRegen ends
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
//library UTUnitRegen:

        function UTUnitRegen__anon__0 takes nothing returns nothing
            set UTUnitRegen__testUnit=CreateUnit(Player(0), 'hfoo', 0, 0, 0)
            set UTUnitRegen__testUnit2=CreateUnit(Player(0), 'hfoo', 100, 100, 0) // 设置初始生命值和魔法值为最大值的30%
            call SetUnitState(UTUnitRegen__testUnit, UNIT_STATE_MAX_MANA, 3000)
            call SetUnitState(UTUnitRegen__testUnit2, UNIT_STATE_MAX_MANA, 3000)
            call SetUnitState(UTUnitRegen__testUnit, UNIT_STATE_LIFE, GetUnitState(UTUnitRegen__testUnit, UNIT_STATE_MAX_LIFE) * 0.3)
            call SetUnitState(UTUnitRegen__testUnit, UNIT_STATE_MANA, GetUnitState(UTUnitRegen__testUnit, UNIT_STATE_MAX_MANA) * 0.3)
            call SetUnitState(UTUnitRegen__testUnit2, UNIT_STATE_LIFE, GetUnitState(UTUnitRegen__testUnit2, UNIT_STATE_MAX_LIFE) * 0.3)
            call SetUnitState(UTUnitRegen__testUnit2, UNIT_STATE_MANA, GetUnitState(UTUnitRegen__testUnit2, UNIT_STATE_MAX_MANA) * 0.3)
        endfunction  //end
        function UTUnitRegen__anon__1 takes nothing returns nothing
        endfunction  // RemoveUnit(testUnit); // RemoveUnit(testUnit2); // testUnit = null; // testUnit2 = null;
    function UTUnitRegen__Init takes nothing returns nothing
        call UnitTestAutoTimer(0.1 , 2.0 , function UTUnitRegen__anon__0 , function UTUnitRegen__anon__1)
    endfunction  // 测试定量回复
        function UTUnitRegen__anon__2 takes nothing returns nothing
            local timer t=GetExpiredTimer()
            call BJDebugMsg("10秒到了,现在单位的生命和魔法是:")
            call BJDebugMsg("生命值: " + R2S(GetUnitState(UTUnitRegen__testUnit, UNIT_STATE_LIFE)))
            call BJDebugMsg("魔法值: " + R2S(GetUnitState(UTUnitRegen__testUnit, UNIT_STATE_MANA)))
            call PauseTimer(t)
            call DestroyTimer(t)
            set t=null
        endfunction
    function UTUnitRegen__TTestUTUnitRegen1 takes player p returns nothing
        local integer oldRegen
        local integer regen
        set oldRegen=s__unitRegen_get(UTUnitRegen__testUnit)
        if ( s__unitRegen_isExist(oldRegen) ) then
            call s__unitRegen_deallocate(oldRegen)
        endif
        set regen=s__unitRegen_parse(UTUnitRegen__testUnit)
        call SetUnitState(UTUnitRegen__testUnit, UNIT_STATE_LIFE, 1)
        call SetUnitState(UTUnitRegen__testUnit, UNIT_STATE_MANA, 1)
        call s__unitRegen_addHPFixedRegen(regen,10.0)
        call s__unitRegen_addMPFixedRegen(regen,5.0)
        call TimerStart(CreateTimer(), 10, false, function UTUnitRegen__anon__2)
        call BJDebugMsg("测试1开始: 定量回复 - 每秒回血10点,回魔5点")
    endfunction  // 测试百分比回复
        function UTUnitRegen__anon__3 takes nothing returns nothing
            local timer t=GetExpiredTimer()
            call BJDebugMsg("10秒到了,现在单位的生命和魔法是:")
            call BJDebugMsg("生命值: " + R2S(GetUnitState(UTUnitRegen__testUnit, UNIT_STATE_LIFE)))
            call BJDebugMsg("魔法值: " + R2S(GetUnitState(UTUnitRegen__testUnit, UNIT_STATE_MANA)))
            call PauseTimer(t)
            call DestroyTimer(t)
            set t=null
        endfunction  // 每秒回5%最大生命值
    function UTUnitRegen__TTestUTUnitRegen2 takes player p returns nothing
        local integer oldRegen
        local integer regen
        set oldRegen=s__unitRegen_get(UTUnitRegen__testUnit)
        if ( s__unitRegen_isExist(oldRegen) ) then
            call s__unitRegen_deallocate(oldRegen)
        endif
        set regen=s__unitRegen_parse(UTUnitRegen__testUnit)
        call SetUnitState(UTUnitRegen__testUnit, UNIT_STATE_LIFE, 1)
        call SetUnitState(UTUnitRegen__testUnit, UNIT_STATE_MANA, 1)
        call TimerStart(CreateTimer(), 10, false, function UTUnitRegen__anon__3)
        call s__unitRegen_addHPPercentRegen(regen,0.05) // 每秒回3%最大魔法值
        call s__unitRegen_addMPPercentRegen(regen,0.03)
        call BJDebugMsg("测试2开始: 百分比回复 - 每秒回血5%,回魔3%")
    endfunction  // 测试回复效益增幅
        function UTUnitRegen__anon__4 takes nothing returns nothing
            local timer t=GetExpiredTimer()
            call BJDebugMsg("10秒到了,现在单位的生命和魔法是:")
            call BJDebugMsg("生命值: " + R2S(GetUnitState(UTUnitRegen__testUnit, UNIT_STATE_LIFE)))
            call BJDebugMsg("魔法值: " + R2S(GetUnitState(UTUnitRegen__testUnit, UNIT_STATE_MANA)))
            call PauseTimer(t)
            call DestroyTimer(t)
            set t=null
        endfunction
    function UTUnitRegen__TTestUTUnitRegen3 takes player p returns nothing
        local integer oldRegen
        local integer regen
        set oldRegen=s__unitRegen_get(UTUnitRegen__testUnit)
        if ( s__unitRegen_isExist(oldRegen) ) then
            call s__unitRegen_deallocate(oldRegen)
        endif
        set regen=s__unitRegen_parse(UTUnitRegen__testUnit)
        call SetUnitState(UTUnitRegen__testUnit, UNIT_STATE_LIFE, 1)
        call SetUnitState(UTUnitRegen__testUnit, UNIT_STATE_MANA, 1)
        call TimerStart(CreateTimer(), 10, false, function UTUnitRegen__anon__4)
        call s__unitRegen_addHPFixedRegen(regen,10.0) // 增加50%回复效益
        call s__unitRegen_addRegenEffectUp(regen,0.5)
        call BJDebugMsg("测试3开始: 回复效益增幅50% - 每秒实际回血15点")
    endfunction  // 测试回复效益减幅
        function UTUnitRegen__anon__5 takes nothing returns nothing
            local timer t=GetExpiredTimer()
            call BJDebugMsg("10秒到了,现在单位的生命和魔法是:")
            call BJDebugMsg("单位1生命值: " + R2S(GetUnitState(UTUnitRegen__testUnit, UNIT_STATE_LIFE)))
            call BJDebugMsg("单位1魔法值: " + R2S(GetUnitState(UTUnitRegen__testUnit, UNIT_STATE_MANA)))
            call BJDebugMsg("单位2生命值: " + R2S(GetUnitState(UTUnitRegen__testUnit2, UNIT_STATE_LIFE)))
            call BJDebugMsg("单位2魔法值: " + R2S(GetUnitState(UTUnitRegen__testUnit2, UNIT_STATE_MANA)))
            call PauseTimer(t)
            call DestroyTimer(t)
            set t=null
        endfunction
    function UTUnitRegen__TTestUTUnitRegen4 takes player p returns nothing
        local integer oldRegen
        local integer regen
        set oldRegen=s__unitRegen_get(UTUnitRegen__testUnit)
        if ( s__unitRegen_isExist(oldRegen) ) then
            call s__unitRegen_deallocate(oldRegen)
        endif
        set regen=s__unitRegen_parse(UTUnitRegen__testUnit)
        call SetUnitState(UTUnitRegen__testUnit, UNIT_STATE_LIFE, 1)
        call SetUnitState(UTUnitRegen__testUnit, UNIT_STATE_MANA, 1)
        call TimerStart(CreateTimer(), 10, false, function UTUnitRegen__anon__5)
        call s__unitRegen_addHPFixedRegen(regen,10.0) // 减少30%回复效益
        call s__unitRegen_addRegenEffectDown(regen,0.3)
        call BJDebugMsg("测试4开始: 回复效益减少30% - 每秒实际回血7点")
    endfunction  // 测试多单位回复
        function UTUnitRegen__anon__6 takes nothing returns nothing
            local timer t=GetExpiredTimer()
            call BJDebugMsg("10秒到了,现在单位的生命和魔法是:")
            call BJDebugMsg("生命值: " + R2S(GetUnitState(UTUnitRegen__testUnit, UNIT_STATE_LIFE)))
            call BJDebugMsg("魔法值: " + R2S(GetUnitState(UTUnitRegen__testUnit, UNIT_STATE_MANA)))
            call PauseTimer(t)
            call DestroyTimer(t)
            set t=null
        endfunction
    function UTUnitRegen__TTestUTUnitRegen5 takes player p returns nothing
        local integer oldRegen1
        local integer oldRegen2
        local integer regen1
        local integer regen2
        set oldRegen1=s__unitRegen_get(UTUnitRegen__testUnit)
        set oldRegen2=s__unitRegen_get(UTUnitRegen__testUnit2)
        if ( s__unitRegen_isExist(oldRegen1) ) then
            call s__unitRegen_deallocate(oldRegen1)
        endif
        if ( s__unitRegen_isExist(oldRegen2) ) then
            call s__unitRegen_deallocate(oldRegen2)
        endif
        set regen1=s__unitRegen_parse(UTUnitRegen__testUnit)
        set regen2=s__unitRegen_parse(UTUnitRegen__testUnit2)
        call SetUnitState(UTUnitRegen__testUnit, UNIT_STATE_LIFE, 1)
        call SetUnitState(UTUnitRegen__testUnit2, UNIT_STATE_LIFE, 1)
        call TimerStart(CreateTimer(), 10, false, function UTUnitRegen__anon__6)
        call s__unitRegen_addHPFixedRegen(regen1,10.0)
        call s__unitRegen_addHPFixedRegen(regen2,20.0)
        call BJDebugMsg("测试5开始: 多单位回复 - 单位1每秒回血10点,单位2每秒回血20点")
    endfunction
    function UTUnitRegen__TTestUTUnitRegen6 takes player p returns nothing
    endfunction
    function UTUnitRegen__TTestUTUnitRegen7 takes player p returns nothing
    endfunction
    function UTUnitRegen__TTestUTUnitRegen8 takes player p returns nothing
    endfunction
    function UTUnitRegen__TTestUTUnitRegen9 takes player p returns nothing
    endfunction
    function UTUnitRegen__TTestUTUnitRegen10 takes player p returns nothing
    endfunction
    function UTUnitRegen__TTestActUTUnitRegen1 takes string str returns nothing
        local player p=GetTriggerPlayer()
        local integer index=GetConvertedPlayerId(p)
        local integer i
        local integer num=0
        local integer len=StringLength(str)
        local string array paramS
        local integer array paramI
        local real array paramR
        local integer regen
        local integer oldRegen
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
        if ( paramS[0] == "a" ) then // 先销毁旧的回复属性
            set oldRegen=s__unitRegen_get(UTUnitRegen__testUnit)
            if ( s__unitRegen_isExist(oldRegen) ) then
                call s__unitRegen_deallocate(oldRegen)
            endif
            set regen=s__unitRegen_parse(UTUnitRegen__testUnit)
            call s__unitRegen_addHPFixedRegen(regen,paramR[1])
            call BJDebugMsg("设置定量回血值: " + R2S(paramR[1]))
        elseif ( paramS[0] == "b" ) then // 先销毁旧的回复属性
            set oldRegen=s__unitRegen_get(UTUnitRegen__testUnit)
            if ( s__unitRegen_isExist(oldRegen) ) then
                call s__unitRegen_deallocate(oldRegen)
            endif
            set regen=s__unitRegen_parse(UTUnitRegen__testUnit)
            call s__unitRegen_addMPFixedRegen(regen,paramR[1])
            call BJDebugMsg("设置定量回魔值: " + R2S(paramR[1]))
        elseif ( paramS[0] == "c" ) then // 先销毁旧的回复属性
            set oldRegen=s__unitRegen_get(UTUnitRegen__testUnit)
            if ( s__unitRegen_isExist(oldRegen) ) then
                call s__unitRegen_deallocate(oldRegen)
            endif
            set regen=s__unitRegen_parse(UTUnitRegen__testUnit)
            call s__unitRegen_addHPPercentRegen(regen,paramR[1])
            call BJDebugMsg("设置百分比回血值: " + R2S(paramR[1] * 100) + "%")
        elseif ( paramS[0] == "d" ) then // 先销毁旧的回复属性
            set oldRegen=s__unitRegen_get(UTUnitRegen__testUnit)
            if ( s__unitRegen_isExist(oldRegen) ) then
                call s__unitRegen_deallocate(oldRegen)
            endif
            set regen=s__unitRegen_parse(UTUnitRegen__testUnit)
            call s__unitRegen_addMPPercentRegen(regen,paramR[1])
            call BJDebugMsg("设置百分比回魔值: " + R2S(paramR[1] * 100) + "%")
        endif
        set p=null
    endfunction
        function UTUnitRegen__anon__7 takes nothing returns nothing
            call BJDebugMsg("[UnitRegen] 单元测试已加载")
            call UTUnitRegen__Init()
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTUnitRegen__anon__8 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            local integer i=1
            if ( SubString(str, ( 1 ) - 1, 1) == "-" ) then
                call UTUnitRegen__TTestActUTUnitRegen1(SubString(str, ( 2 ) - 1, StringLength(str)))
                return
            endif
            if ( str == "s1" ) then
                call UTUnitRegen__TTestUTUnitRegen1(GetTriggerPlayer())
            elseif ( str == "s2" ) then
                call UTUnitRegen__TTestUTUnitRegen2(GetTriggerPlayer())
            elseif ( str == "s3" ) then
                call UTUnitRegen__TTestUTUnitRegen3(GetTriggerPlayer())
            elseif ( str == "s4" ) then
                call UTUnitRegen__TTestUTUnitRegen4(GetTriggerPlayer())
            elseif ( str == "s5" ) then
                call UTUnitRegen__TTestUTUnitRegen5(GetTriggerPlayer())
            elseif ( str == "s6" ) then
                call UTUnitRegen__TTestUTUnitRegen6(GetTriggerPlayer())
            elseif ( str == "s7" ) then
                call UTUnitRegen__TTestUTUnitRegen7(GetTriggerPlayer())
            elseif ( str == "s8" ) then
                call UTUnitRegen__TTestUTUnitRegen8(GetTriggerPlayer())
            elseif ( str == "s9" ) then
                call UTUnitRegen__TTestUTUnitRegen9(GetTriggerPlayer())
            elseif ( str == "s10" ) then
                call UTUnitRegen__TTestUTUnitRegen10(GetTriggerPlayer())
            endif
        endfunction
    function UTUnitRegen__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr, 0.5, false)
        call TriggerAddCondition(tr, Condition(function UTUnitRegen__anon__7))
        set tr=null
        call UnitTestRegisterChatEvent(function UTUnitRegen__anon__8)
    endfunction

//library UTUnitRegen ends
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerSelectionEventBJ.h>
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerKeyEventBJ.h>
//#  define TriggerRegisterPlayerUnitEventSimple(trig, p, e)                 TriggerRegisterPlayerUnitEvent(trig, p, e, null)
//#  define TriggerRegisterPlayerEventVictory(trig, player)                  TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_VICTORY)
//#  define TriggerRegisterPlayerEventDefeat(trig, player)                   TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_DEFEAT)
//#  define TriggerRegisterPlayerEventLeave(trig, player)                    TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_LEAVE)
//#  define TriggerRegisterPlayerEventAllianceChanged(trig, player)          TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_ALLIANCE_CHANGED)
//#  define TriggerRegisterPlayerEventEndCinematic(trig, player)             TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_END_CINEMATIC)
// 原生UI的大小

//processed hook: hook RemoveUnit unitLifeCycle.onDestroyCB

// 结构体共用方法定义
//共享打印方法
// UI组件内部共享方法及成员
// UI组件依赖库
// UI组件创建时共享调用
// UI组件销毁时共享调用

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
    call SetCameraBounds(- 13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), - 13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), - 13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), - 13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    call NewSoundEnvironment("Default")
    call SetAmbientDaySound("NorthrendDay")
    call SetAmbientNightSound("NorthrendNight")
    call SetMapMusic("Music", true, 0)
    call CreateRegions()
    call CreateAllUnits()
    call InitBlizzard()

call ExecuteFunc("jasshelper__initstructs38026187")
call ExecuteFunc("UnitTestFramwork__onInit")
call ExecuteFunc("UTUnitRegen__onInit")

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
function sa__unitRegen_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            call GroupRemoveUnit(s__unitRegen_regenGroup, s__unitRegen_u[this])
            if ( HaveSavedInteger(HASH_UNIT, GetHandleId(s__unitRegen_u[this]), 1728) ) then
                call RemoveSavedInteger(HASH_UNIT, GetHandleId(s__unitRegen_u[this]), 1728)
            endif
   return true
endfunction
function sa__unitLifeCycle_onDestroyCB takes nothing returns boolean
    call s__unitLifeCycle_onDestroyCB(f__arg_unit1)
   return true
endfunction

function jasshelper__initstructs38026187 takes nothing returns nothing
    set st__unitRegen_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__unitRegen_onDestroy,Condition( function sa__unitRegen_onDestroy))
    set st__unitLifeCycle_onDestroyCB=CreateTrigger()
    call TriggerAddCondition(st__unitLifeCycle_onDestroyCB,Condition( function sa__unitLifeCycle_onDestroyCB))






    call ExecuteFunc("s__mapBounds_onInit")
    call ExecuteFunc("s__unitLifeCycle_onInit")
    call ExecuteFunc("s__unitRegen_onInit")
endfunction

