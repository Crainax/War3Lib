globals
//globals from ConversionUtils:
constant boolean LIBRARY_ConversionUtils=true
//endglobals from ConversionUtils
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
//globals from Logger:
constant boolean LIBRARY_Logger=true
integer logger_level=0
string logger_msg=null
player logger_p=null
trigger logger_tr=null
//endglobals from Logger
//globals from UnitAttr:
constant boolean LIBRARY_UnitAttr=true
//endglobals from UnitAttr
//globals from HeroAttr:
constant boolean LIBRARY_HeroAttr=true
constant integer MAIN_ATTR_STR=0
constant integer MAIN_ATTR_AGI=1
constant integer MAIN_ATTR_INT=2
//endglobals from HeroAttr
//globals from UTHeroAttr:
constant boolean LIBRARY_UTHeroAttr=true
unit UTHeroAttr__testHeroStr=null
unit UTHeroAttr__testHeroAgi=null
integer UTHeroAttr__attrStr=0
integer UTHeroAttr__attrAgi=0
//endglobals from UTHeroAttr
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
unit array s__unitAttr_u
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
real array s__unitAttr_baseDef
real array s__unitAttr_DefRateUp
real array s__unitAttr_DefRateDown
real array s__unitAttr_DefRateBonus
real array s__unitAttr_DefFixedBonus
real array s__unitAttr_SpellDmgRateUp
real array s__unitAttr_SpellDmgRateDown
constant integer si__heroAttr=6
integer si__heroAttr_F=0
integer si__heroAttr_I=0
integer array si__heroAttr_V
integer s__heroAttr_ethis=0
unit array s__heroAttr_u
integer array s__heroAttr_mainAttrType
real array s__heroAttr_mainAttrBase
real array s__heroAttr_mainAttrRateUp
real array s__heroAttr_mainAttrRateDown
real array s__heroAttr_mainAttrFixedBonus
real array s__heroAttr_subAttrBase
real array s__heroAttr_subAttrRateUp
real array s__heroAttr_subAttrRateDown
real array s__heroAttr_subAttrFixedBonus
real array s__heroAttr_baseStr
real array s__heroAttr_StrRateUp
real array s__heroAttr_StrRateDown
real array s__heroAttr_StrRateBonus
real array s__heroAttr_StrFixedBonus
trigger s__heroAttr_trStrChange=null
trigger st__unitLifeCycle_onDestroyCB
trigger st__unitAttr_onDestroy
trigger st__heroAttr_onDestroy
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

//Generated method caller for heroAttr.onDestroy
function sc__heroAttr_onDestroy takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__heroAttr_onDestroy)
endfunction

//Generated allocator of heroAttr
function s__heroAttr__allocate takes nothing returns integer
 local integer this=si__heroAttr_F
    if (this!=0) then
        set si__heroAttr_F=si__heroAttr_V[this]
    else
        set si__heroAttr_I=si__heroAttr_I+1
        set this=si__heroAttr_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: heroAttr")
        return 0
    endif

    set si__heroAttr_V[this]=-1
 return this
endfunction

//Generated destructor of heroAttr
function sc__heroAttr_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: heroAttr")
        return
    elseif (si__heroAttr_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: heroAttr")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__heroAttr_onDestroy)
    set si__heroAttr_V[this]=si__heroAttr_F
    set si__heroAttr_F=this
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

//library ConversionUtils:
    function B2S takes boolean b returns string
        if ( b ) then
            return "true"
        else
            return "false"
        endif
    endfunction  //三目运算符
    function S3 takes boolean b,string s1,string s2 returns string
        if ( b ) then
            return s1
        else
            return s2
        endif
    endfunction  //三目运算符
    function U3 takes boolean b,unit u1,unit u2 returns unit
        if ( b ) then
            return u1
        else
            return u2
        endif
    endfunction  //三目运算符
    function I3 takes boolean b,integer i1,integer i2 returns integer
        if ( b ) then
            return i1
        else
            return i2
        endif
    endfunction  //三目运算符
    function R3 takes boolean b,real r1,real r2 returns real
        if ( b ) then
            return r1
        else
            return r2
        endif
    endfunction  // 将数字转换为魔兽的四字符ID,使用256进制但限制36个数一进位
    function GetIDSymbol takes integer pos returns integer
        local integer bit=pos / 36
        set pos=ModuloInteger(pos, 36)
        if ( pos < 10 ) then
            return pos + bit * 256
        else
            return '000a' - '0000' + pos - 10 + bit * 256
        endif
    endfunction  // 将魔兽的四字符ID转换回对应数字
    function GetSymbolID takes integer s returns integer
        local integer i1=s / 256
        local integer i2=ModuloInteger(s, 256)
        if ( i2 < 10 ) then
            return i1 * 36 + i2
        else
            return i2 - '000a' + '0000' + 10 + i1 * 36
        endif
    endfunction

//library ConversionUtils ends
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
//library UnitAttr:
        function s__unitAttr_isExist takes integer this returns boolean
            return ( this != null and si__unitAttr_V[this] == - 1 )
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
            call SaveInteger(HASH_UNIT, handleId, 1726, this)
            return this
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
        endfunction  // 同步并刷新当前单位的防御
        function s__unitAttr_syncDefRate takes integer this returns nothing
            set s__unitAttr_DefRateBonus[this]=s__unitAttr_baseDef[this] * ( 1.0 + s__unitAttr_DefRateUp[this] ) * ( 1.0 - s__unitAttr_DefRateDown[this] ) - s__unitAttr_baseDef[this]
            call SetUnitState(s__unitAttr_u[this], ConvertUnitState(0x20), s__unitAttr_baseDef[this] + s__unitAttr_DefRateBonus[this] + s__unitAttr_DefFixedBonus[this])
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
        function s__unitAttr_getSpellDmgMultiplier takes integer this returns real
            return ( 1.0 + s__unitAttr_SpellDmgRateUp[this] ) * ( 1.0 - s__unitAttr_SpellDmgRateDown[this] ) - 1.0
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
//library HeroAttr:
        function s__heroAttr_isExist takes integer this returns boolean
            return ( this != null and si__heroAttr_V[this] == - 1 )
        endfunction
        function s__heroAttr_getBaseStr takes integer this returns real
            if ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_STR ) then
                return s__heroAttr_baseStr[this] + s__heroAttr_mainAttrBase[this]
            else
                return s__heroAttr_baseStr[this] + s__heroAttr_subAttrBase[this]
            endif
        endfunction  // 获取额外Str(绿字)
        function s__heroAttr_getExtraStr takes integer this returns real
            if ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_STR ) then
                return s__heroAttr_StrRateBonus[this] + s__heroAttr_StrFixedBonus[this] + s__heroAttr_mainAttrFixedBonus[this]
            else
                return s__heroAttr_StrRateBonus[this] + s__heroAttr_StrFixedBonus[this] + s__heroAttr_subAttrFixedBonus[this]
            endif
        endfunction
        function s__heroAttr_getCurrentStr takes integer this returns real
            if ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_STR ) then
                return s__heroAttr_baseStr[this] + s__heroAttr_mainAttrBase[this] + s__heroAttr_StrRateBonus[this] + s__heroAttr_StrFixedBonus[this] + s__heroAttr_mainAttrFixedBonus[this]
            else
                return s__heroAttr_baseStr[this] + s__heroAttr_subAttrBase[this] + s__heroAttr_StrRateBonus[this] + s__heroAttr_StrFixedBonus[this] + s__heroAttr_subAttrFixedBonus[this]
            endif
        endfunction
        function s__heroAttr_getCurrentStrRate takes integer this returns real
            if ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_STR ) then
                return ( 1.0 + s__heroAttr_StrRateUp[this] + s__heroAttr_mainAttrRateUp[this] ) * ( 1.0 - s__heroAttr_StrRateDown[this] ) * ( 1.0 - s__heroAttr_mainAttrRateDown[this] ) - 1.0
            else
                return ( 1.0 + s__heroAttr_StrRateUp[this] + s__heroAttr_subAttrRateUp[this] ) * ( 1.0 - s__heroAttr_StrRateDown[this] ) * ( 1.0 - s__heroAttr_subAttrRateDown[this] ) - 1.0
            endif
        endfunction  // 同步并刷新当前单位的力量
        function s__heroAttr_syncStrRate takes integer this returns nothing
            set s__heroAttr_StrRateBonus[this]=s__heroAttr_baseStr[this] * s__heroAttr_getCurrentStrRate(this)
            call SetHeroStr(s__heroAttr_u[this], R2I(RMaxBJ(s__heroAttr_getCurrentStr(this), 0.0)), true)
            if ( s__heroAttr_trStrChange != null ) then
                set s__heroAttr_ethis=this
                call TriggerEvaluate(s__heroAttr_trStrChange)
            endif
        endfunction
        function s__heroAttr_setBaseStr takes integer this,real value returns nothing
            if ( s__heroAttr_baseStr[this] != value ) then
                set s__heroAttr_baseStr[this]=value
                call s__heroAttr_syncStrRate(this)
            endif
        endfunction
        function s__heroAttr_addBaseStr takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__heroAttr_baseStr[this]=s__heroAttr_baseStr[this] + value
                call s__heroAttr_syncStrRate(this)
            endif
        endfunction
        function s__heroAttr_addStrFixedBonus takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__heroAttr_StrFixedBonus[this]=s__heroAttr_StrFixedBonus[this] + value
                call s__heroAttr_syncStrRate(this)
            endif
        endfunction
        function s__heroAttr_addStrRateUp takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__heroAttr_StrRateUp[this]=s__heroAttr_StrRateUp[this] + value
                call s__heroAttr_syncStrRate(this)
            endif
        endfunction
        function s__heroAttr_addStrRateDown takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__heroAttr_StrRateDown[this]=RealAdd(s__heroAttr_StrRateDown[this] , value)
                call s__heroAttr_syncStrRate(this)
            endif
        endfunction
        function s__heroAttr_onStrChange takes code func returns nothing
            if ( s__heroAttr_trStrChange == null ) then
                set s__heroAttr_trStrChange=CreateTrigger()
            endif
            call TriggerAddCondition(s__heroAttr_trStrChange, Condition(func))
        endfunction  // 同步并刷新当前单位的敏捷
        function s__heroAttr_syncAgiRate takes integer this returns nothing
        endfunction  // 同步并刷新当前单位的智力
        function s__heroAttr_syncIntRate takes integer this returns nothing
        endfunction
        function s__heroAttr_parse takes unit u,integer mainAttrType returns integer
            local integer this
            local integer handleId=GetHandleId(u)
            if ( HaveSavedInteger(HASH_UNIT, handleId, 1727) ) then
                return LoadInteger(HASH_UNIT, handleId, 1727)
            elseif ( not ( IsHeroUnitId(GetUnitTypeId(u)) ) ) then // 如果不是英雄单位就不给创建
                return 0
            endif // 不存在才创建新的
            set this=s__heroAttr__allocate()
            set s__heroAttr_u[this]=u
            set s__heroAttr_mainAttrType[this]=mainAttrType
            set s__heroAttr_mainAttrBase[this]=0.0
            set s__heroAttr_mainAttrRateUp[this]=0.0
            set s__heroAttr_mainAttrRateDown[this]=0.0
            set s__heroAttr_mainAttrFixedBonus[this]=0.0
            set s__heroAttr_subAttrBase[this]=0.0
            set s__heroAttr_subAttrRateUp[this]=0.0
            set s__heroAttr_subAttrRateDown[this]=0.0
            set s__heroAttr_subAttrFixedBonus[this]=0.0
            set s__heroAttr_baseStr[this]=0.0
            set s__heroAttr_StrRateUp[this]=0.0
            set s__heroAttr_StrRateDown[this]=0.0
            set s__heroAttr_StrRateBonus[this]=0.0
            set s__heroAttr_StrFixedBonus[this]=0.0
            call SaveInteger(HASH_UNIT, handleId, 1727, this) // INIT_COMBAT_ATTR(Agi) // INIT_COMBAT_ATTR(Int)
            return this
        endfunction
        function s__heroAttr_addMainAttrBase takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__heroAttr_mainAttrBase[this]=s__heroAttr_mainAttrBase[this] + value // 根据主属性类型同步相应属性
                if ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_STR ) then
                    call s__heroAttr_syncStrRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_AGI ) then
                    call s__heroAttr_syncAgiRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_INT ) then
                    call s__heroAttr_syncIntRate(this)
                endif
            endif
        endfunction
        function s__heroAttr_addSubAttrBase takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__heroAttr_subAttrBase[this]=s__heroAttr_subAttrBase[this] + value // 根据主属性类型同步次属性
                if ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_STR ) then
                    call s__heroAttr_syncAgiRate(this)
                    call s__heroAttr_syncIntRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_AGI ) then
                    call s__heroAttr_syncStrRate(this)
                    call s__heroAttr_syncIntRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_INT ) then
                    call s__heroAttr_syncStrRate(this)
                    call s__heroAttr_syncAgiRate(this)
                endif
            endif
        endfunction  // 添加主属性相关方法
        function s__heroAttr_addMainAttrRateUp takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__heroAttr_mainAttrRateUp[this]=s__heroAttr_mainAttrRateUp[this] + value
                if ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_STR ) then
                    call s__heroAttr_syncStrRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_AGI ) then
                    call s__heroAttr_syncAgiRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_INT ) then
                    call s__heroAttr_syncIntRate(this)
                endif
            endif
        endfunction
        function s__heroAttr_addMainAttrRateDown takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__heroAttr_mainAttrRateDown[this]=RealAdd(s__heroAttr_mainAttrRateDown[this] , value)
                if ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_STR ) then
                    call s__heroAttr_syncStrRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_AGI ) then
                    call s__heroAttr_syncAgiRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_INT ) then
                    call s__heroAttr_syncIntRate(this)
                endif
            endif
        endfunction
        function s__heroAttr_addMainAttrFixedBonus takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__heroAttr_mainAttrFixedBonus[this]=s__heroAttr_mainAttrFixedBonus[this] + value
                if ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_STR ) then
                    call s__heroAttr_syncStrRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_AGI ) then
                    call s__heroAttr_syncAgiRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_INT ) then
                    call s__heroAttr_syncIntRate(this)
                endif
            endif
        endfunction  // 添加次属性相关方法
        function s__heroAttr_addSubAttrRateUp takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__heroAttr_subAttrRateUp[this]=s__heroAttr_subAttrRateUp[this] + value
                if ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_STR ) then
                    call s__heroAttr_syncAgiRate(this)
                    call s__heroAttr_syncIntRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_AGI ) then
                    call s__heroAttr_syncStrRate(this)
                    call s__heroAttr_syncIntRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_INT ) then
                    call s__heroAttr_syncStrRate(this)
                    call s__heroAttr_syncAgiRate(this)
                endif
            endif
        endfunction
        function s__heroAttr_addSubAttrRateDown takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__heroAttr_subAttrRateDown[this]=RealAdd(s__heroAttr_subAttrRateDown[this] , value)
                if ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_STR ) then
                    call s__heroAttr_syncAgiRate(this)
                    call s__heroAttr_syncIntRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_AGI ) then
                    call s__heroAttr_syncStrRate(this)
                    call s__heroAttr_syncIntRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_INT ) then
                    call s__heroAttr_syncStrRate(this)
                    call s__heroAttr_syncAgiRate(this)
                endif
            endif
        endfunction
        function s__heroAttr_addSubAttrFixedBonus takes integer this,real value returns nothing
            if ( value != 0 ) then
                set s__heroAttr_subAttrFixedBonus[this]=s__heroAttr_subAttrFixedBonus[this] + value
                if ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_STR ) then
                    call s__heroAttr_syncAgiRate(this)
                    call s__heroAttr_syncIntRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_AGI ) then
                    call s__heroAttr_syncStrRate(this)
                    call s__heroAttr_syncIntRate(this)
                elseif ( s__heroAttr_mainAttrType[this] == MAIN_ATTR_INT ) then
                    call s__heroAttr_syncStrRate(this)
                    call s__heroAttr_syncAgiRate(this)
                endif
            endif
        endfunction  //单位删除会调用
        function s__heroAttr_onDestroy takes integer this returns nothing
            if ( HaveSavedInteger(HASH_UNIT, GetHandleId(s__heroAttr_u[this]), 1727) ) then
                call RemoveSavedInteger(HASH_UNIT, GetHandleId(s__heroAttr_u[this]), 1727)
            endif
            set s__heroAttr_u[this]=null
        endfunction  //注册到周期结束中

//Generated destructor of heroAttr
function s__heroAttr_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: heroAttr")
        return
    elseif (si__heroAttr_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: heroAttr")
        return
    endif
    call s__heroAttr_onDestroy(this)
    set si__heroAttr_V[this]=si__heroAttr_F
    set si__heroAttr_F=this
endfunction
            function s__heroAttr_anon__0 takes nothing returns nothing
                local unit u=s__unitLifeCycle_argsUnit
                local integer this=s__unitAttr_parse(u)
                if ( s__heroAttr_isExist(this) ) then
                    call s__heroAttr_deallocate(this)
                endif
                set u=null
            endfunction
        function s__heroAttr_onInit takes nothing returns nothing
            call s__unitLifeCycle_registerDestroy(function s__heroAttr_anon__0)
        endfunction

//library HeroAttr ends
//library UTHeroAttr:

    function UTHeroAttr__CreateTestHeroes takes player p returns nothing
        if ( UTHeroAttr__testHeroStr != null ) then
            call h__RemoveUnit(UTHeroAttr__testHeroStr)
        endif
        if ( UTHeroAttr__testHeroAgi != null ) then
            call h__RemoveUnit(UTHeroAttr__testHeroAgi)
        endif // 创建一个力量型英雄和一个敏捷型英雄
        set UTHeroAttr__testHeroStr=CreateUnit(p, 'Hmkg', 0, 0, 0) // 山丘之王 // 恶魔猎手
        set UTHeroAttr__testHeroAgi=CreateUnit(p, 'Edem', 200, 0, 0) // 初始化属性系统
        set UTHeroAttr__attrStr=s__heroAttr_parse(UTHeroAttr__testHeroStr , MAIN_ATTR_STR)
        set UTHeroAttr__attrAgi=s__heroAttr_parse(UTHeroAttr__testHeroAgi , MAIN_ATTR_AGI) // 设置基础属性值方便测试
        call s__heroAttr_setBaseStr(UTHeroAttr__attrStr,100)
        call s__heroAttr_setBaseStr(UTHeroAttr__attrAgi,80)
        call SelectUnit(UTHeroAttr__testHeroStr, true)
    endfunction
        function UTHeroAttr__anon__0 takes nothing returns nothing
            local integer ha=s__heroAttr_ethis
            call BJDebugMsg("[单位]: " + GetUnitName(s__heroAttr_u[ha]) + " [Str]: " + I2S(s__heroAttr_getCurrentStr(ha)))
        endfunction  // 创建测试英雄
        function UTHeroAttr__anon__1 takes nothing returns nothing
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrStr) , 100.0 , "力量英雄初始Str应为100")
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrAgi) , 80.0 , "敏捷英雄初始Str应为80")
        endfunction  // 测试2：主属性增幅测试
        function UTHeroAttr__anon__2 takes nothing returns nothing
            call s__heroAttr_addMainAttrRateUp(UTHeroAttr__attrStr,0.5)
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrStr) , 150.0 , "力量英雄50%主属性增幅后Str应为150") // 给敏捷英雄加50%主属性增幅(不应影响力量)
            call s__heroAttr_addMainAttrRateUp(UTHeroAttr__attrAgi,0.5)
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrAgi) , 80.0 , "敏捷英雄主属性增幅不应影响Str")
        endfunction  // 测试3：次属性增幅测试
        function UTHeroAttr__anon__3 takes nothing returns nothing
            call UTHeroAttr__CreateTestHeroes(Player(0)) // 给力量英雄加30%次属性增幅
            call s__heroAttr_addSubAttrRateUp(UTHeroAttr__attrStr,0.3)
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrStr) , 100.0 , "力量英雄次属性增幅不应影响Str") // 给敏捷英雄加30%次属性增幅(应影响力量)
            call s__heroAttr_addSubAttrRateUp(UTHeroAttr__attrAgi,0.3)
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrAgi) , 104.0 , "敏捷英雄30%次属性增幅后Str应为104")
        endfunction  // 测试4：属性固定加成测试
        function UTHeroAttr__anon__4 takes nothing returns nothing
            call UTHeroAttr__CreateTestHeroes(Player(0)) // 测试主属性固定加成
            call s__heroAttr_addMainAttrFixedBonus(UTHeroAttr__attrStr,50.0)
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrStr) , 150.0 , "力量英雄加50点主属性固定加成后Str应为150") // 测试次属性固定加成
            call s__heroAttr_addSubAttrFixedBonus(UTHeroAttr__attrAgi,30.0)
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrAgi) , 110.0 , "敏捷英雄加30点次属性固定加成后Str应为110")
        endfunction  // 测试5：力量属性各种增减幅组合测试
        function UTHeroAttr__anon__5 takes nothing returns nothing
            call UTHeroAttr__CreateTestHeroes(Player(0)) // 设置基础力量为100
            call s__heroAttr_setBaseStr(UTHeroAttr__attrStr,100) // 添加力量增减幅
            call s__heroAttr_addStrRateUp(UTHeroAttr__attrStr,0.3) // +30% // -10%
            call s__heroAttr_addStrRateDown(UTHeroAttr__attrStr,0.1) // 添加主属性增减幅
            call s__heroAttr_addMainAttrRateUp(UTHeroAttr__attrStr,0.2) // +20% // -5%
            call s__heroAttr_addMainAttrRateDown(UTHeroAttr__attrStr,0.05) // 计算期望值：
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrStr) , 128.25 , "力量英雄复杂增减幅组合测试1") // 基础值: 100 // 所有增幅相加: (1 + 0.3 + 0.2) = 1.5 // 所有减幅相乘: (1 - 0.1) * (1 - 0.05) = 0.9 * 0.95 = 0.855 // 最终计算: 100 * 1.5 * 0.855 = 128.25 // 添加固定加成
            call s__heroAttr_addStrFixedBonus(UTHeroAttr__attrStr,50)
            call s__heroAttr_addMainAttrFixedBonus(UTHeroAttr__attrStr,30) // 最终结果应为: 128.25 + 50 + 30 = 208.25
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrStr) , 208.25 , "力量英雄复杂增减幅组合测试2")
        endfunction  // 测试6：次属性对力量的影响组合测试
        function UTHeroAttr__anon__6 takes nothing returns nothing
            call UTHeroAttr__CreateTestHeroes(Player(0)) // 设置基础属性
            call s__heroAttr_setBaseStr(UTHeroAttr__attrAgi,100) // 添加力量相关增减幅
            call s__heroAttr_addStrRateUp(UTHeroAttr__attrAgi,0.2) // +20% // -10%
            call s__heroAttr_addStrRateDown(UTHeroAttr__attrAgi,0.1) // 添加次属性增减幅
            call s__heroAttr_addSubAttrRateUp(UTHeroAttr__attrAgi,0.3) // +30% // -15%
            call s__heroAttr_addSubAttrRateDown(UTHeroAttr__attrAgi,0.15) // 计算期望值：
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrAgi) , 114.75 , "敏捷英雄力量复杂增减幅组合测试1") // 基础值: 100 // 所有增幅相加: (1 + 0.2 + 0.3) = 1.5 // 所有减幅相乘: (1 - 0.1) * (1 - 0.15) = 0.9 * 0.85 = 0.765 // 最终计算: 100 * 1.5 * 0.765 = 114.75 // 添加固定加成
            call s__heroAttr_addStrFixedBonus(UTHeroAttr__attrAgi,40)
            call s__heroAttr_addSubAttrFixedBonus(UTHeroAttr__attrAgi,20) // 最终结果应为: 114.75 + 40 + 20 = 174.75
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrAgi) , 174.75 , "敏捷英雄力量复杂增减幅组合测试2")
        endfunction  // 测试7：极限值测试
        function UTHeroAttr__anon__7 takes nothing returns nothing
            call UTHeroAttr__CreateTestHeroes(Player(0)) // 设置一个较大的基础值
            call s__heroAttr_setBaseStr(UTHeroAttr__attrStr,1000) // 添加多个大幅度的增减幅
            call s__heroAttr_addStrRateUp(UTHeroAttr__attrStr,2.0) // +200% // +150%
            call s__heroAttr_addMainAttrRateUp(UTHeroAttr__attrStr,1.5) // -40%
            call s__heroAttr_addStrRateDown(UTHeroAttr__attrStr,0.4) // -30%
            call s__heroAttr_addMainAttrRateDown(UTHeroAttr__attrStr,0.3) // 添加大量固定加成
            call s__heroAttr_addStrFixedBonus(UTHeroAttr__attrStr,500)
            call s__heroAttr_addMainAttrFixedBonus(UTHeroAttr__attrStr,300) // 计算期望值：
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrStr) , 2690.0 , "力量英雄极限值测试") // 基础值: 1000 // 所有增幅相加: (1 + 2.0 + 1.5) = 4.5 // 所有减幅相乘: (1 - 0.4) * (1 - 0.3) = 0.6 * 0.7 = 0.42 // 属性计算: 1000 * 4.5 * 0.42 = 1890 // 加上固定加成: 1890 + 500 + 300 = 2690
        endfunction  // 测试8：主属性基础值测试
        function UTHeroAttr__anon__8 takes nothing returns nothing
            call UTHeroAttr__CreateTestHeroes(Player(0)) // 测试力量英雄的主属性基础值
            call s__heroAttr_addMainAttrBase(UTHeroAttr__attrStr,50)
            call s__assert_Real(s__heroAttr_getBaseStr(UTHeroAttr__attrStr) , 150.0 , "力量英雄加50主属性基础值后白字应为150")
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrStr) , 150.0 , "力量英雄加50主属性基础值后总值应为150") // 测试敏捷英雄的主属性基础值(不应影响力量)
            call s__heroAttr_addMainAttrBase(UTHeroAttr__attrAgi,50)
            call s__assert_Real(s__heroAttr_getBaseStr(UTHeroAttr__attrAgi) , 80.0 , "敏捷英雄加50主属性基础值后力量白字应为80")
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrAgi) , 80.0 , "敏捷英雄加50主属性基础值后力量总值应为80")
        endfunction  // 测试9：次属性基础值测试
        function UTHeroAttr__anon__9 takes nothing returns nothing
            call UTHeroAttr__CreateTestHeroes(Player(0)) // 测试力量英雄的次属性基础值(不应影响力量)
            call s__heroAttr_addSubAttrBase(UTHeroAttr__attrStr,30)
            call s__assert_Real(s__heroAttr_getBaseStr(UTHeroAttr__attrStr) , 100.0 , "力量英雄加30次属性基础值后力量白字应为100")
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrStr) , 100.0 , "力量英雄加30次属性基础值后力量总值应为100") // 测试敏捷英雄的次属性基础值(应影响力量)
            call s__heroAttr_addSubAttrBase(UTHeroAttr__attrAgi,30)
            call s__assert_Real(s__heroAttr_getBaseStr(UTHeroAttr__attrAgi) , 110.0 , "敏捷英雄加30次属性基础值后力量白字应为110")
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrAgi) , 110.0 , "敏捷英雄加30次属性基础值后力量总值应为110")
        endfunction  // 测试10：主属性和次属性基础值组合测试
        function UTHeroAttr__anon__10 takes nothing returns nothing
            call UTHeroAttr__CreateTestHeroes(Player(0)) // 设置基础属性和增减幅
            call s__heroAttr_setBaseStr(UTHeroAttr__attrAgi,100) // +50%
            call s__heroAttr_addStrRateUp(UTHeroAttr__attrAgi,0.5) // +30%
            call s__heroAttr_addSubAttrRateUp(UTHeroAttr__attrAgi,0.3) // 添加主属性和次属性基础值
            call s__heroAttr_addMainAttrBase(UTHeroAttr__attrAgi,20) // 不影响力量 // 影响力量
            call s__heroAttr_addSubAttrBase(UTHeroAttr__attrAgi,50) // 计算期望值：
            call s__assert_Real(s__heroAttr_getBaseStr(UTHeroAttr__attrAgi) , 150.0 , "敏捷英雄复杂组合后力量白字应为150") // 增幅: 100 * (1 + 0.5 + 0.3) + 50 = 230
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrAgi) , 230.0 , "敏捷英雄复杂组合后力量总值应为230")
        endfunction  // 测试11：多重增幅叠加测试
        function UTHeroAttr__anon__11 takes nothing returns nothing
            call UTHeroAttr__CreateTestHeroes(Player(0)) // 设置基础属性
            call s__heroAttr_setBaseStr(UTHeroAttr__attrStr,100) // 添加多次力量增幅
            call s__heroAttr_addStrRateUp(UTHeroAttr__attrStr,0.2) // +20% // +30%
            call s__heroAttr_addStrRateUp(UTHeroAttr__attrStr,0.3) // +15%
            call s__heroAttr_addStrRateUp(UTHeroAttr__attrStr,0.15) // 添加多次主属性增幅
            call s__heroAttr_addMainAttrRateUp(UTHeroAttr__attrStr,0.25) // +25% // +35%
            call s__heroAttr_addMainAttrRateUp(UTHeroAttr__attrStr,0.35) // 添加多次次属性增幅
            call s__heroAttr_addSubAttrRateUp(UTHeroAttr__attrStr,0.1) // +10% // +20%
            call s__heroAttr_addSubAttrRateUp(UTHeroAttr__attrStr,0.2) // 计算期望值：
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrStr) , 225.0 , "力量英雄多重增幅叠加测试1") // 基础值: 100 // 力量增幅总和: 0.2 + 0.3 + 0.15 = 0.65 // 主属性增幅总和: 0.25 + 0.35 = 0.6 // 次属性增幅总和: 0.1 + 0.2 = 0.3 // 所有增幅相加: (1 + 0.65 + 0.6) = 2.25 // 最终计算: 100 * 2.25 = 225 // 再添加一些减幅测试
            call s__heroAttr_addStrRateDown(UTHeroAttr__attrStr,0.2) // -20% // -10%
            call s__heroAttr_addMainAttrRateDown(UTHeroAttr__attrStr,0.1) // 计算最终期望值：
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrStr) , 162 , "力量英雄多重增幅叠加测试2") // 之前结果: 225 // 减幅相乘: (1 - 0.2) * (1 - 0.1) = 0.8 * 0.9 = 0.72 // 最终计算: 225 * 0.72 = 162 // 测试敏捷英雄的多重增幅叠加
            call s__heroAttr_setBaseStr(UTHeroAttr__attrAgi,100) // 添加多次各类增幅
            call s__heroAttr_addStrRateUp(UTHeroAttr__attrAgi,0.25) // +25% // +35%
            call s__heroAttr_addStrRateUp(UTHeroAttr__attrAgi,0.35) // +20%
            call s__heroAttr_addSubAttrRateUp(UTHeroAttr__attrAgi,0.2) // +30%
            call s__heroAttr_addSubAttrRateUp(UTHeroAttr__attrAgi,0.3) // +40% (不影响力量)
            call s__heroAttr_addMainAttrRateUp(UTHeroAttr__attrAgi,0.4) // 计算期望值：
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrAgi) , 210.0 , "敏捷英雄多重增幅叠加测试1") // 基础值: 100 // 力量增幅总和: 0.25 + 0.35 = 0.6 // 次属性增幅总和: 0.2 + 0.3 = 0.5 // 所有增幅相加: (1 + 0.6 + 0.5) = 2.1 // 最终计算: 100 * 2.1 = 210 // 添加减幅
            call s__heroAttr_addStrRateDown(UTHeroAttr__attrAgi,0.15) // -15% // -25%
            call s__heroAttr_addSubAttrRateDown(UTHeroAttr__attrAgi,0.25) // 计算最终期望值：
            call s__assert_Real(s__heroAttr_getCurrentStr(UTHeroAttr__attrAgi) , 133.875 , "敏捷英雄多重增幅叠加测试2") // 之前结果: 210 // 减幅相乘: (1 - 0.15) * (1 - 0.25) = 0.85 * 0.75 = 0.6375 // 最终计算: 210 * 0.6375 = 133.875
        endfunction
    function UTHeroAttr__Init takes nothing returns nothing
        local player p=Player(0)
        call BJDebugMsg("=== HeroAttr测试系统已加载 ===")
        call s__heroAttr_onStrChange(function UTHeroAttr__anon__0)
        call UTHeroAttr__CreateTestHeroes(p)
        call UnitTestAutoTimer(0.1 , 0 , function UTHeroAttr__anon__1 , null)
        call UnitTestAutoTimer(0.6 , 0 , function UTHeroAttr__anon__2 , null)
        call UnitTestAutoTimer(1.1 , 0 , function UTHeroAttr__anon__3 , null)
        call UnitTestAutoTimer(1.6 , 0 , function UTHeroAttr__anon__4 , null)
        call UnitTestAutoTimer(2.1 , 0 , function UTHeroAttr__anon__5 , null)
        call UnitTestAutoTimer(2.6 , 0 , function UTHeroAttr__anon__6 , null)
        call UnitTestAutoTimer(3.1 , 0 , function UTHeroAttr__anon__7 , null)
        call UnitTestAutoTimer(3.6 , 0 , function UTHeroAttr__anon__8 , null)
        call UnitTestAutoTimer(4.1 , 0 , function UTHeroAttr__anon__9 , null)
        call UnitTestAutoTimer(4.6 , 0 , function UTHeroAttr__anon__10 , null)
        call UnitTestAutoTimer(5.1 , 0 , function UTHeroAttr__anon__11 , null)
        set p=null
    endfunction  // 处理测试命令
    function UTHeroAttr__TTestActUTHeroAttr1 takes string str returns nothing
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
        if ( UTHeroAttr__testHeroStr == null ) then
            call UTHeroAttr__CreateTestHeroes(p)
        endif // 新建测试单位命令
        if ( paramS[0] == "new" ) then
            call UTHeroAttr__CreateTestHeroes(p)
            call BJDebugMsg("已重新创建测试英雄")
        elseif ( paramS[0] == "str" ) then // 力量相关命令
            call s__heroAttr_setBaseStr(UTHeroAttr__attrStr,paramR[1])
            call s__heroAttr_setBaseStr(UTHeroAttr__attrAgi,paramR[1])
            call BJDebugMsg("设置力量英雄基础力量为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "addstr" ) then
            call s__heroAttr_addBaseStr(UTHeroAttr__attrStr,paramR[1])
            call s__heroAttr_addBaseStr(UTHeroAttr__attrAgi,paramR[1])
            call BJDebugMsg("增加力量英雄基础力量: " + R2S(paramR[1]))
        elseif ( paramS[0] == "strup" ) then
            call s__heroAttr_addStrRateUp(UTHeroAttr__attrStr,paramR[1])
            call s__heroAttr_addStrRateUp(UTHeroAttr__attrAgi,paramR[1])
            call BJDebugMsg("设置力量英雄力量增幅为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "strdown" ) then
            call s__heroAttr_addStrRateDown(UTHeroAttr__attrStr,paramR[1])
            call s__heroAttr_addStrRateDown(UTHeroAttr__attrAgi,paramR[1])
            call BJDebugMsg("设置力量英雄力量减幅为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "strbonus" ) then
            call s__heroAttr_addStrFixedBonus(UTHeroAttr__attrStr,paramR[1])
            call s__heroAttr_addStrFixedBonus(UTHeroAttr__attrAgi,paramR[1])
            call BJDebugMsg("设置力量英雄力量固定加成为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "addstrbonus" ) then
            call s__heroAttr_addStrFixedBonus(UTHeroAttr__attrStr,paramR[1])
            call s__heroAttr_addStrFixedBonus(UTHeroAttr__attrAgi,paramR[1])
            call BJDebugMsg("增加力量英雄力量固定加成: " + R2S(paramR[1]))
        elseif ( paramS[0] == "mainup" ) then // 主属性相关命令
            call s__heroAttr_addMainAttrRateUp(UTHeroAttr__attrStr,paramR[1])
            call s__heroAttr_addMainAttrRateUp(UTHeroAttr__attrAgi,paramR[1])
            call BJDebugMsg("设置力量英雄主属性增幅为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "maindown" ) then
            call s__heroAttr_addMainAttrRateDown(UTHeroAttr__attrStr,paramR[1])
            call s__heroAttr_addMainAttrRateDown(UTHeroAttr__attrAgi,paramR[1])
            call BJDebugMsg("设置力量英雄主属性减幅为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "mainbonus" ) then
            call s__heroAttr_addMainAttrFixedBonus(UTHeroAttr__attrStr,paramR[1])
            call s__heroAttr_addMainAttrFixedBonus(UTHeroAttr__attrAgi,paramR[1])
            call BJDebugMsg("设置力量英雄主属性固定加成为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "subup" ) then // 次属性相关命令
            call s__heroAttr_addSubAttrRateUp(UTHeroAttr__attrStr,paramR[1])
            call s__heroAttr_addSubAttrRateUp(UTHeroAttr__attrAgi,paramR[1])
            call BJDebugMsg("设置力量英雄次属性增幅为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "subdown" ) then
            call s__heroAttr_addSubAttrRateDown(UTHeroAttr__attrStr,paramR[1])
            call s__heroAttr_addSubAttrRateDown(UTHeroAttr__attrAgi,paramR[1])
            call BJDebugMsg("设置力量英雄次属性减幅为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "subbonus" ) then
            call s__heroAttr_addSubAttrFixedBonus(UTHeroAttr__attrStr,paramR[1])
            call s__heroAttr_addSubAttrFixedBonus(UTHeroAttr__attrAgi,paramR[1])
            call BJDebugMsg("设置力量英雄次属性固定加成为: " + R2S(paramR[1]))
        elseif ( paramS[0] == "mainadd" ) then // 主属性基础值相关命令
            call s__heroAttr_addMainAttrBase(UTHeroAttr__attrStr,paramR[1])
            call s__heroAttr_addMainAttrBase(UTHeroAttr__attrAgi,paramR[1])
            call BJDebugMsg("增加力量英雄主属性基础值: " + R2S(paramR[1]))
        elseif ( paramS[0] == "subadd" ) then // 次属性基础值相关命令
            call s__heroAttr_addSubAttrBase(UTHeroAttr__attrStr,paramR[1])
            call s__heroAttr_addSubAttrBase(UTHeroAttr__attrAgi,paramR[1])
            call BJDebugMsg("增加力量英雄次属性基础值: " + R2S(paramR[1]))
        endif // 显示当前状态
        call BJDebugMsg("力量英雄当前力量: " + R2S(s__heroAttr_getCurrentStr(UTHeroAttr__attrStr)))
        call BJDebugMsg("力量英雄当前力量白字: " + R2S(s__heroAttr_getBaseStr(UTHeroAttr__attrStr)))
        call BJDebugMsg("力量英雄当前力量绿字: " + R2S(s__heroAttr_getExtraStr(UTHeroAttr__attrStr)))
        call BJDebugMsg("敏捷英雄当前力量: " + R2S(s__heroAttr_getCurrentStr(UTHeroAttr__attrAgi)))
        call BJDebugMsg("敏捷英雄当前力量白字: " + R2S(s__heroAttr_getBaseStr(UTHeroAttr__attrAgi)))
        call BJDebugMsg("敏捷英雄当前力量绿字: " + R2S(s__heroAttr_getExtraStr(UTHeroAttr__attrAgi)))
        set p=null
    endfunction
        function UTHeroAttr__anon__12 takes nothing returns nothing
            call UTHeroAttr__Init()
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTHeroAttr__anon__13 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            if ( SubString(str, ( 1 ) - 1, 1) == "-" ) then
                call UTHeroAttr__TTestActUTHeroAttr1(SubString(str, ( 2 ) - 1, StringLength(str)))
                return
            endif
        endfunction
    function UTHeroAttr__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr, 0.5, false)
        call TriggerAddCondition(tr, Condition(function UTHeroAttr__anon__12))
        set tr=null
        call UnitTestRegisterChatEvent(function UTHeroAttr__anon__13)
    endfunction

//library UTHeroAttr ends
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerSelectionEventBJ.h>
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerKeyEventBJ.h>
//#  define TriggerRegisterPlayerUnitEventSimple(trig, p, e)                 TriggerRegisterPlayerUnitEvent(trig, p, e, null)
//#  define TriggerRegisterPlayerEventVictory(trig, player)                  TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_VICTORY)
//#  define TriggerRegisterPlayerEventDefeat(trig, player)                   TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_DEFEAT)
//#  define TriggerRegisterPlayerEventLeave(trig, player)                    TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_LEAVE)
//#  define TriggerRegisterPlayerEventAllianceChanged(trig, player)          TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_ALLIANCE_CHANGED)
//#  define TriggerRegisterPlayerEventEndCinematic(trig, player)             TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_END_CINEMATIC)

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
//这两条是用到YDWE函数就要导入的,没用到就不用导入
// #include <YDTrigger/ImportSaveLoadSystem.h>
// #include <YDTrigger/Hash.h>
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

call ExecuteFunc("jasshelper__initstructs32063828")
call ExecuteFunc("UnitTestFramwork__onInit")
call ExecuteFunc("YDLua__onInit")
call ExecuteFunc("Logger__onInit")
call ExecuteFunc("UTHeroAttr__onInit")

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
function sa__heroAttr_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            if ( HaveSavedInteger(HASH_UNIT, GetHandleId(s__heroAttr_u[this]), 1727) ) then
                call RemoveSavedInteger(HASH_UNIT, GetHandleId(s__heroAttr_u[this]), 1727)
            endif
            set s__heroAttr_u[this]=null
   return true
endfunction
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

function jasshelper__initstructs32063828 takes nothing returns nothing
    set st__heroAttr_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__heroAttr_onDestroy,Condition( function sa__heroAttr_onDestroy))
    set st__unitAttr_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__unitAttr_onDestroy,Condition( function sa__unitAttr_onDestroy))
    set st__unitLifeCycle_onDestroyCB=CreateTrigger()
    call TriggerAddCondition(st__unitLifeCycle_onDestroyCB,Condition( function sa__unitLifeCycle_onDestroyCB))







    call ExecuteFunc("s__mapBounds_onInit")
    call ExecuteFunc("s__unitLifeCycle_onInit")
    call ExecuteFunc("s__unitAttr_onInit")
    call ExecuteFunc("s__heroAttr_onInit")
endfunction

