globals
//globals from ConversionUtils:
constant boolean LIBRARY_ConversionUtils=true
//endglobals from ConversionUtils
//globals from UnitTestFramwork:
constant boolean LIBRARY_UnitTestFramwork=true
trigger UnitTestFramwork___TUnitTest=null
hashtable UnitTestFramwork___HASH_UNITTEST=InitHashtable()
//endglobals from UnitTestFramwork
//globals from BigNumber:
constant boolean LIBRARY_BigNumber=true
//endglobals from BigNumber
//globals from UTBigNumber:
constant boolean LIBRARY_UTBigNumber=true
//endglobals from UTBigNumber
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
constant integer si__bigNumber=2
integer si__bigNumber_F=0
integer si__bigNumber_I=0
integer array si__bigNumber_V
integer array s__bigNumber_low
integer array s__bigNumber_high
trigger st__bigNumber_onDestroy
trigger st__bigNumber_destroy
integer f__arg_this

endglobals


//Generated method caller for bigNumber.onDestroy
function sc__bigNumber_onDestroy takes integer this returns nothing
            set s__bigNumber_low[this]=0
            set s__bigNumber_high[this]=0
endfunction

//Generated allocator of bigNumber
function s__bigNumber__allocate takes nothing returns integer
 local integer this=si__bigNumber_F
    if (this!=0) then
        set si__bigNumber_F=si__bigNumber_V[this]
    else
        set si__bigNumber_I=si__bigNumber_I+1
        set this=si__bigNumber_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: bigNumber")
        return 0
    endif

    set si__bigNumber_V[this]=-1
 return this
endfunction

//Generated destructor of bigNumber
function sc__bigNumber_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: bigNumber")
        return
    elseif (si__bigNumber_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: bigNumber")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__bigNumber_onDestroy)
    set si__bigNumber_V[this]=si__bigNumber_F
    set si__bigNumber_F=this
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
        call TriggerRegisterTimerEventSingle(tr, time)
        call SaveReal(UnitTestFramwork___HASH_UNITTEST, GetHandleId(tr), 1, time)
        call SaveReal(UnitTestFramwork___HASH_UNITTEST, GetHandleId(tr), 2, duration)
        call SaveTriggerHandle(UnitTestFramwork___HASH_UNITTEST, GetHandleId(tr), 3, t)
        call TriggerAddCondition(tr, Condition(function UnitTestFramwork___anon__0))
        set t=CreateTrigger()
        set tr=CreateTrigger()
        call TriggerAddCondition(t, Condition(end))
        call TriggerRegisterTimerEventSingle(tr, time + duration)
        call SaveReal(UnitTestFramwork___HASH_UNITTEST, GetHandleId(tr), 1, time)
        call SaveReal(UnitTestFramwork___HASH_UNITTEST, GetHandleId(tr), 2, duration)
        call SaveTriggerHandle(UnitTestFramwork___HASH_UNITTEST, GetHandleId(tr), 3, t)
        call TriggerAddCondition(tr, Condition(function UnitTestFramwork___anon__1))
        set tr=null
        set t=null
    endfunction
        function UnitTestFramwork___anon__2 takes nothing returns nothing
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
        call TriggerAddCondition(tr, Condition(function UnitTestFramwork___anon__2))
        set tr=null
        set UnitTestFramwork___TUnitTest=CreateTrigger()
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest, Player(0), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest, Player(1), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest, Player(2), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest, Player(3), "", false)
    endfunction

//library UnitTestFramwork ends
//library BigNumber:
        function s__bigNumber_isExist takes integer this returns boolean
            return ( this != null and si__bigNumber_V[this] == - 1 )
        endfunction
        function s__bigNumber_create takes nothing returns integer
            local integer this=s__bigNumber__allocate()
            set s__bigNumber_low[this]=0
            set s__bigNumber_high[this]=0
            return this
        endfunction  //==============================
        function s__bigNumber_isNegative takes integer this returns boolean
            if ( s__bigNumber_high[this] < 0 ) then
                return true
            elseif ( s__bigNumber_high[this] == 0 and s__bigNumber_low[this] < 0 ) then
                return true
            endif
            return false
        endfunction  //==============================
        function s__bigNumber_negate takes integer this returns nothing
            set s__bigNumber_high[this]=- s__bigNumber_high[this]
            set s__bigNumber_low[this]=- s__bigNumber_low[this] // 当反号后，low、high 不在预期区间时，做一次借位或退位修正
            if ( s__bigNumber_low[this] < 0 and s__bigNumber_high[this] > 0 ) then
                set s__bigNumber_low[this]=s__bigNumber_low[this] + 1000000000
                set s__bigNumber_high[this]=s__bigNumber_high[this] - 1
            elseif ( s__bigNumber_low[this] > 0 and s__bigNumber_high[this] < 0 ) then
                set s__bigNumber_low[this]=s__bigNumber_low[this] - 1000000000
                set s__bigNumber_high[this]=s__bigNumber_high[this] + 1
            endif // 防止溢出
            if ( s__bigNumber_high[this] > 2100000000 ) then
                set s__bigNumber_high[this]=2100000000
                set s__bigNumber_low[this]=999999999
            elseif ( s__bigNumber_high[this] < - 2100000000 ) then
                set s__bigNumber_high[this]=- 2100000000
                set s__bigNumber_low[this]=- 999999999
            endif
        endfunction  //==============================
        function s__bigNumber_makePositive takes integer this returns nothing
            if ( s__bigNumber_isNegative(this) ) then
                call s__bigNumber_negate(this)
            endif
        endfunction  //==============================
        function s__bigNumber_add takes integer this,integer highPart,integer lowPart returns nothing
            set s__bigNumber_low[this]=s__bigNumber_low[this] + lowPart // 处理低位进位/借位
            if ( s__bigNumber_low[this] >= 1000000000 ) then
                set s__bigNumber_high[this]=s__bigNumber_high[this] + ( s__bigNumber_low[this] / 1000000000 )
                set s__bigNumber_low[this]=ModuloInteger(s__bigNumber_low[this], 1000000000)
            elseif ( s__bigNumber_low[this] <= - 1000000000 ) then
                set s__bigNumber_high[this]=s__bigNumber_high[this] + ( s__bigNumber_low[this] / 1000000000 )
                set s__bigNumber_low[this]=- ModuloInteger(IAbsBJ(s__bigNumber_low[this]), 1000000000)
            elseif ( s__bigNumber_low[this] < 0 and s__bigNumber_high[this] > 0 ) then
                set s__bigNumber_low[this]=s__bigNumber_low[this] + 1000000000
                set s__bigNumber_high[this]=s__bigNumber_high[this] - 1
            elseif ( s__bigNumber_low[this] > 0 and s__bigNumber_high[this] < 0 ) then
                set s__bigNumber_low[this]=s__bigNumber_low[this] - 1000000000
                set s__bigNumber_high[this]=s__bigNumber_high[this] + 1
            endif // 加到高位
            set s__bigNumber_high[this]=s__bigNumber_high[this] + highPart // 防止溢出
            if ( s__bigNumber_high[this] > 2100000000 ) then
                set s__bigNumber_high[this]=2100000000
                set s__bigNumber_low[this]=999999999
            elseif ( s__bigNumber_high[this] < - 2100000000 ) then
                set s__bigNumber_high[this]=- 2100000000
                set s__bigNumber_low[this]=- 999999999
            endif
        endfunction  //==============================
        function s__bigNumber_addReal takes integer this,real value returns nothing
            local integer highValue=0
            local integer lowValue=0
            local real tempHigh=0.0
            if ( value >= 1000000000.0 ) then // 先计算除以10亿后的值
                set tempHigh=value / 1000000000.0 // 检查是否会溢出
                if ( tempHigh > 2100000000.0 ) then
                    set highValue=2100000000
                    set lowValue=999999999
                else
                    set highValue=R2I(tempHigh)
                    set lowValue=R2I(ModuloReal(value, 1000000000.0))
                endif
            elseif ( value <= - 1000000000.0 ) then // 处理负数，先取绝对值计算
                set tempHigh=RAbsBJ(value) / 1000000000.0 // 检查是否会溢出
                if ( tempHigh > 2100000000.0 ) then
                    set highValue=- 2100000000
                    set lowValue=- 999999999
                else
                    set highValue=- R2I(tempHigh)
                    set lowValue=- R2I(ModuloReal(RAbsBJ(value), 1000000000.0))
                endif
            else
                set lowValue=R2I(value)
            endif
            call s__bigNumber_add(this,highValue , lowValue)
        endfunction  //==============================
        function s__bigNumber_clone takes integer this returns integer
            local integer tmp=s__bigNumber__allocate()
            set s__bigNumber_high[tmp]=s__bigNumber_high[this]
            set s__bigNumber_low[tmp]=s__bigNumber_low[this]
            return tmp
        endfunction  //==============================
        function s__bigNumber_addBigNumber takes integer this,integer other returns nothing
            call s__bigNumber_add(this,s__bigNumber_high[other] , s__bigNumber_low[other])
        endfunction  //==============================
        function s__bigNumber_doubleBN takes integer this returns nothing
            call s__bigNumber_add(this,s__bigNumber_high[this] , s__bigNumber_low[this])
        endfunction  //==============================
        function s__bigNumber_multiplyInteger takes integer this,integer val returns nothing
            local integer sign=1
            local integer tmpVal=val
            local integer result=s__bigNumber_create()
            local integer temp=s__bigNumber_clone(this)
            local real tempValue
            set tempValue=( I2R(s__bigNumber_high[this]) * 1000000000 ) * I2R(tmpVal) // 210京
            if ( tempValue >= 2.1 * Pow(10.0, 18) ) then // 正向溢出
                set s__bigNumber_high[this]=2100000000
                set s__bigNumber_low[this]=999999999
                return // -210京
            elseif ( tempValue <= - 2.1 * Pow(10.0, 18) ) then // 负向溢出
                set s__bigNumber_high[this]=- 2100000000
                set s__bigNumber_low[this]=- 999999999
                return
            endif // 1. 符号处理
            if ( tmpVal < 0 ) then
                set tmpVal=- tmpVal
                set sign=- sign
            endif
            if ( s__bigNumber_isNegative(this) ) then
                call s__bigNumber_negate(temp)
                set sign=- sign
            endif // 2. 二进制拆分乘法
            loop // 如果当前位是1，就把temp加到结果中
            exitwhen ( tmpVal <= 0 )
                if ( ModuloInteger(tmpVal, 2) == 1 ) then
                    call s__bigNumber_addBigNumber(result,temp)
                endif // temp翻倍（相当于左移一位）
                call s__bigNumber_doubleBN(temp) // tmpVal右移一位
                set tmpVal=tmpVal / 2
            endloop // 3. 恢复符号
            if ( sign < 0 ) then
                call s__bigNumber_negate(result)
            endif // 4. 将 result 写回当前
            set s__bigNumber_high[this]=s__bigNumber_high[result]
            set s__bigNumber_low[this]=s__bigNumber_low[result] // 5. 释放临时对象
            call sc__bigNumber_deallocate(result)
            call sc__bigNumber_deallocate(temp)
        endfunction  //==============================
        function s__bigNumber_multiplyReal takes integer this,real rVal returns nothing
            local real highProduct
            local real lowProduct
            local integer newHigh
            local integer newLow
            set highProduct=I2R(s__bigNumber_high[this]) * rVal
            set lowProduct=I2R(s__bigNumber_low[this]) * rVal // 处理高位部分
            set newHigh=R2I(highProduct * 1000000000.0)
            set newLow=R2I(lowProduct) // 清零后重新加入结果
            set s__bigNumber_high[this]=0
            set s__bigNumber_low[this]=0
            call s__bigNumber_add(this,newHigh , newLow)
        endfunction  //==============================
        function s__bigNumber_compareBigNumber takes integer this,integer other returns integer
            if ( s__bigNumber_high[this] > s__bigNumber_high[other] ) then
                return 1
            elseif ( s__bigNumber_high[this] < s__bigNumber_high[other] ) then
                return - 1
            elseif ( s__bigNumber_low[this] > s__bigNumber_low[other] ) then
                return 1
            elseif ( s__bigNumber_low[this] < s__bigNumber_low[other] ) then
                return - 1
            else
                return 0
            endif
        endfunction  //==============================
        function s__bigNumber_compareInteger takes integer this,integer val returns integer
            if ( s__bigNumber_high[this] > 0 ) then
                return 1
            elseif ( s__bigNumber_high[this] < 0 ) then
                return - 1
            endif // high 为 0 时，直接比较 low 与 val
            if ( s__bigNumber_low[this] > val ) then
                return 1
            elseif ( s__bigNumber_low[this] < val ) then
                return - 1
            endif
            return 0
        endfunction  //==============================
        function s__bigNumber_compareReal takes integer this,real val returns integer
            local integer highPart
            local real lowPart
            local real absVal
            if ( val >= 1000000000.0 ) then
                set highPart=R2I(val / 1000000000.0)
                set lowPart=ModuloReal(val, 1000000000.0) // 先较高位
                if ( s__bigNumber_high[this] > highPart ) then
                    return 1
                elseif ( s__bigNumber_high[this] < highPart ) then
                    return - 1
                endif // 高位相等，比较低位
                if ( I2R(s__bigNumber_low[this]) > lowPart ) then
                    return 1
                elseif ( I2R(s__bigNumber_low[this]) < lowPart ) then
                    return - 1
                endif
                return 0
            elseif ( val <= - 1000000000.0 ) then
                set absVal=RAbsBJ(val)
                set highPart=- R2I(absVal / 1000000000.0)
                set lowPart=- ModuloReal(absVal, 1000000000.0)
                if ( s__bigNumber_high[this] > highPart ) then
                    return 1
                elseif ( s__bigNumber_high[this] < highPart ) then
                    return - 1
                endif
                if ( I2R(s__bigNumber_low[this]) > lowPart ) then
                    return 1
                elseif ( I2R(s__bigNumber_low[this]) < lowPart ) then
                    return - 1
                endif
                return 0
            else // val 在 (-10亿, 10亿) 范围内
                if ( s__bigNumber_high[this] > 0 ) then
                    return 1
                elseif ( s__bigNumber_high[this] < 0 ) then
                    return - 1
                endif
                if ( I2R(s__bigNumber_low[this]) > val ) then
                    return 1
                elseif ( I2R(s__bigNumber_low[this]) < val ) then
                    return - 1
                endif
                return 0
            endif
        endfunction
        function s__bigNumber_onDestroy takes integer this returns nothing
            set s__bigNumber_low[this]=0
            set s__bigNumber_high[this]=0
        endfunction  //==============================

//Generated destructor of bigNumber
function s__bigNumber_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: bigNumber")
        return
    elseif (si__bigNumber_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: bigNumber")
        return
    endif
    call s__bigNumber_onDestroy(this)
    set si__bigNumber_V[this]=si__bigNumber_F
    set si__bigNumber_F=this
endfunction
        function s__bigNumber_toStringWithCommas takes integer this returns string
            local string result=""
            local integer currentLow=s__bigNumber_low[this]
            local integer currentHigh=s__bigNumber_high[this]
            local boolean isNegative=s__bigNumber_isNegative(this)
            local string highStr=""
            local integer tempHigh
            local integer currentDigits
            if ( isNegative ) then
                if ( currentHigh < 0 ) then
                    set currentHigh=- currentHigh
                endif
                if ( currentLow < 0 ) then
                    set currentLow=- currentLow
                endif
            endif // 处理低位的后3位
            set result=I2S(ModuloInteger(currentLow, 1000)) // 补齐3位
            if ( currentLow >= 1000 ) then
                if ( ModuloInteger(currentLow, 1000) < 10 ) then
                    set result="00" + result
                elseif ( ModuloInteger(currentLow, 1000) < 100 ) then
                    set result="0" + result
                endif
            endif // 处理低位的中间3位
            set currentLow=currentLow / 1000
            if ( currentLow > 0 ) then
                set result=I2S(ModuloInteger(currentLow, 1000)) + "," + result // 补齐3位
                if ( currentLow >= 1000 ) then
                    if ( ModuloInteger(currentLow, 1000) < 10 ) then
                        set result="00" + result
                    elseif ( ModuloInteger(currentLow, 1000) < 100 ) then
                        set result="0" + result
                    endif
                endif
            endif // 处理低的前3位
            set currentLow=currentLow / 1000
            if ( currentLow > 0 ) then
                set result=I2S(currentLow) + "," + result
            endif // 处理高位部分（如果有）
            if ( currentHigh > 0 ) then // 补齐低位到9位
                if ( result != "" ) then // 9位数字加2位逗号
                    loop
                    exitwhen ( StringLength(result) >= 11 )
                        set result="0" + result
                    endloop
                    set result="," + result
                endif // 处理高位的每3位
                set tempHigh=currentHigh
                set highStr=I2S(ModuloInteger(tempHigh, 1000)) // 补齐末三位
                if ( tempHigh >= 1000 ) then
                    if ( ModuloInteger(tempHigh, 1000) < 10 ) then
                        set highStr="00" + highStr
                    elseif ( ModuloInteger(tempHigh, 1000) < 100 ) then
                        set highStr="0" + highStr
                    endif
                endif
                set tempHigh=tempHigh / 1000 // 如果还有更高位
                loop
                exitwhen ( tempHigh <= 0 )
                    set currentDigits=ModuloInteger(tempHigh, 1000)
                    set highStr=I2S(currentDigits) + "," + highStr // 补齐当前3位
                    if ( tempHigh >= 1000 ) then
                        if ( currentDigits < 10 ) then
                            set highStr="00" + highStr
                        elseif ( currentDigits < 100 ) then
                            set highStr="0" + highStr
                        endif
                    endif
                    set tempHigh=tempHigh / 1000
                endloop
                set result=highStr + result
            endif // 添加负号
            if ( isNegative ) then
                set result="-" + result
            endif
            return result
        endfunction  //==============================
        function s__bigNumber_toStringWithUnit takes integer this returns string
            local string result=""
            local integer currentHigh=s__bigNumber_high[this]
            local integer currentLow=s__bigNumber_low[this]
            local boolean isNegative=s__bigNumber_isNegative(this)
            local real value=0.0
            local real highPart=0.0
            local real lowPart=0.0
            local integer unitLevel=0
            local string units=""
            if ( isNegative ) then
                if ( currentHigh < 0 ) then
                    set currentHigh=- 1 * currentHigh
                endif
                if ( currentLow < 0 ) then
                    set currentLow=- 1 * currentLow
                endif
            endif // 分别计算高位和低位部分
            set highPart=I2R(currentHigh) * 1000000000
            set lowPart=I2R(currentLow)
            set value=highPart + lowPart // 1000万以下直接显示
            if ( value < 10000000.0 ) then
                set result=I2S(R2I(value))
            else // 循环除以10000直到小于10000
                loop
                exitwhen ( value < 10000.0 )
                    set value=value / 10000.0
                    set unitLevel=unitLevel + 1
                endloop // 根据unitLevel确定单位
                if ( unitLevel == 1 ) then
                    set units="万"
                elseif ( unitLevel == 2 ) then
                    set units="亿"
                elseif ( unitLevel == 3 ) then
                    set units="兆"
                elseif ( unitLevel >= 4 ) then // 格式化数值并加上单位
                    set units="京"
                endif
                set result=R2SW(value, 0, 1) + units
            endif
            if ( isNegative ) then
                set result="-" + result
            endif
            return result
        endfunction

//library BigNumber ends
//library UTBigNumber:

    function UTBigNumber___Test_Create takes nothing returns nothing
        local integer bn=s__bigNumber_create()
        call s__assert_Boolean(s__bigNumber_high[bn] == 0 and s__bigNumber_low[bn] == 0 , "Test_Create: 新建 BigNumber 应当为 (0, 0)")
    endfunction  //==============================
    function UTBigNumber___Test_Add takes nothing returns nothing
        local integer bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 0)
        call s__assert_Boolean(s__bigNumber_high[bn] == 0 and s__bigNumber_low[bn] == 0 , "Test_Add(0, 0)") // 2.2 正常范围 + 正常范围
        call s__bigNumber_add(bn,1 , 2) // => (1,2)
        call s__assert_Boolean(s__bigNumber_high[bn] == 1 and s__bigNumber_low[bn] == 2 , "Test_Add(1, 2)") // 2.3 再加一个负数 => (1,2) + (-1,-2) => (0,0)
        call s__bigNumber_add(bn,- 1 , - 2)
        call s__assert_Boolean(s__bigNumber_high[bn] == 0 and s__bigNumber_low[bn] == 0 , "Test_Add(-1, -2)") // 2.4 测试进位：低位超过 10亿
        set bn=s__bigNumber_create() //     先重置为(0,0)，再加(0, 999999999)，再加(0, 10)
        call s__bigNumber_add(bn,0 , 999999999) // => 999999999 + 10 = 1000000009，需要向 high 进位
        call s__bigNumber_add(bn,0 , 10) // 进位后：bn.low 应该是 9，bn.high = 1
        call s__assert_Boolean(s__bigNumber_high[bn] == 1 and s__bigNumber_low[bn] == 9 , "Test_Add 进位检查") // 2.5 测试溢出: 连续叠加到超过 high 正上限
        set bn=s__bigNumber_create() //     BigNumber 中 high 上限为 2100000000 //     这里模拟一下极大值加法，引发溢出 // 先加到极限
        call s__bigNumber_add(bn,2100000000 , 999999999) // 再加一点，应该被截断到 (2100000000, 999999999)
        call s__bigNumber_add(bn,0 , 1)
        call s__assert_Boolean(s__bigNumber_high[bn] == 2100000000 and s__bigNumber_low[bn] == 999999999 , "Test_Add 溢出正上限检查") // 2.6 测试溢出: 负方向
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,- 2100000000 , - 999999999) // 再继续减一点以测试负方向溢出
        call s__bigNumber_add(bn,0 , - 1)
        call s__assert_Boolean(s__bigNumber_high[bn] == - 2100000000 and s__bigNumber_low[bn] == - 999999999 , "Test_Add 溢出负上限检查")
    endfunction  //==============================
    function UTBigNumber___Test_AddReal takes nothing returns nothing
        local integer bn=s__bigNumber_create()
        call s__bigNumber_addReal(bn,123.0) // => (0, 123)
        call s__assert_Boolean(s__bigNumber_high[bn] == 0 and s__bigNumber_low[bn] == 123 , "Test_AddReal(123.0)") // 3.2 再加大实数 => 超过 10亿，会拆分到 high
        call s__bigNumber_addReal(bn,2000000000.0) // => 2000000000 = 2 * 10^9 => high=2, low=0 // 现在累计 BN => high=2, low=123
        call s__assert_Boolean(s__bigNumber_high[bn] == 2 and s__bigNumber_low[bn] == 123 , "Test_AddReal(2000000000.0)") // 3.3 加负实数
        call s__bigNumber_addReal(bn,- 2000000000.0) //这里得拆着写 //这里得拆着写
        call s__bigNumber_addReal(bn,- 50.0) // => 原本 (2, 123) + (-2, -50)
        call s__assert_Boolean(s__bigNumber_high[bn] == 0 and s__bigNumber_low[bn] == 73 , "Test_AddReal(-2000000000.0再-50.0)") // => (0, 73) // 3.4 超过上限(-∞或+∞)截断测试
        set bn=s__bigNumber_create() // 超大正数测试
        call s__bigNumber_addReal(bn,Pow(10.0, 20))
        call s__assert_Boolean(s__bigNumber_high[bn] == 2100000000 and s__bigNumber_low[bn] == 999999999 , "Test_AddReal 超大正数溢出测试")
        set bn=s__bigNumber_create() // 超大负数测试
        call s__bigNumber_addReal(bn,- 1 * Pow(10.0, 20))
        call s__assert_Boolean(s__bigNumber_high[bn] == - 2100000000 and s__bigNumber_low[bn] == - 999999999 , "Test_AddReal 超大负数溢出测试")
    endfunction  //==============================
    function UTBigNumber___Test_MultiplyInteger takes nothing returns nothing
        local integer bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 10) // 先令 bn = (0, 10) // => (0, 20)
        call s__bigNumber_multiplyInteger(bn,2)
        call s__assert_Boolean(s__bigNumber_high[bn] == 0 and s__bigNumber_low[bn] == 20 , "Test_MultiplyInteger(10×2)") // 4.2 乘以负数 & 检查符号
        set bn=s__bigNumber_create() // => (0,10)
        call s__bigNumber_add(bn,0 , 10) // => (0, -30)
        call s__bigNumber_multiplyInteger(bn,- 3)
        call s__assert_Boolean(s__bigNumber_high[bn] == 0 and s__bigNumber_low[bn] == - 30 , "Test_MultiplyInteger 符号检查") // 4.3 测试进位: 9.9亿 × 2 = 19.8亿
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 990000000)
        call s__bigNumber_multiplyInteger(bn,2)
        call s__assert_Boolean(s__bigNumber_high[bn] == 1 and s__bigNumber_low[bn] == 980000000 , "Test_MultiplyInteger 进位测试1") // 4.4 测试进位: 5亿 × 20 = 100亿
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 500000000)
        call s__bigNumber_multiplyInteger(bn,20)
        call s__assert_Boolean(s__bigNumber_high[bn] == 10 and s__bigNumber_low[bn] == 0 , "Test_MultiplyInteger 进位测试2") // 4.5 测试大数乘法: 210亿 × 10 = 2100亿(溢出到最大值)
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,7652 , 8236578)
        call s__bigNumber_multiplyInteger(bn,15)
        call s__assert_Boolean(s__bigNumber_high[bn] == 114780 and s__bigNumber_low[bn] == 123548670 , "Test_MultiplyInteger 大数乘法测试") // 4.6 测试负数大数乘法: -210亿 × 10 = -2100亿(溢出到最小值)
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,- 210 , - 846726348)
        call s__bigNumber_multiplyInteger(bn,18)
        call s__assert_Boolean(s__bigNumber_high[bn] == - 3795 and s__bigNumber_low[bn] == - 241074264 , "Test_MultiplyInteger 负数大数乘法测试") // 4.7 较大数相乘是否正常截断(如超越2,100,000,000)
        set bn=s__bigNumber_create() // => (1000000000, 0)
        call s__bigNumber_add(bn,1000000000 , 0) // => 5,000,000,000 => 应该溢出到 (2100000000, 999999999)
        call s__bigNumber_multiplyInteger(bn,5)
        call s__assert_Boolean(s__bigNumber_high[bn] == 2100000000 and s__bigNumber_low[bn] == 999999999 , "Test_MultiplyInteger 溢出正上限检查") // 4.8 负方向溢出
        set bn=s__bigNumber_create() // => (-1000000000, 0)
        call s__bigNumber_add(bn,- 1000000000 , 0) // => -5,000,000,000 => 应该溢出到 (-2100000000, -999999999)
        call s__bigNumber_multiplyInteger(bn,5)
        call s__assert_Boolean(s__bigNumber_high[bn] == - 2100000000 and s__bigNumber_low[bn] == - 999999999 , "Test_MultiplyInteger 溢出负上限检查") // 4.9 接近210京时
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,111111111 , 111111111) //结果应该为 1,999,999,999,999,999,998
        call s__bigNumber_multiplyInteger(bn,18)
        call s__assert_Boolean(s__bigNumber_high[bn] == 1999999999 and s__bigNumber_low[bn] == 999999998 , "Test_MultiplyInteger 精确数值200京检查")
    endfunction  //==============================
    function UTBigNumber___Test_ToString takes nothing returns nothing
        local integer bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 5)
        call s__assert_Boolean(s__bigNumber_toStringWithUnit(bn) == "5" , "Test_ToString: 个位数显示") // 测试万位数 (12345 = 1.2万)
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 12345)
        call s__assert_Boolean(s__bigNumber_toStringWithUnit(bn) == "12345" , "Test_ToString: 万位数显示") // 测试百万 (1234567 = 123.5万)
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 1234567)
        call s__assert_Boolean(s__bigNumber_toStringWithUnit(bn) == "1234567" , "Test_ToString: 百万显示") // 测试亿位 (123456789 = 1.2亿)
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 123456789)
        call s__assert_Boolean(s__bigNumber_toStringWithUnit(bn) == "1.2亿" , "Test_ToString: 亿位显示") // 测试百亿 (12345678901 = 123.5亿)
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,12 , 345678901)
        call s__assert_Boolean(s__bigNumber_toStringWithUnit(bn) == "123.5亿" , "Test_ToString: 百亿显示") // 测试兆位 (1234567890123 = 1.2兆)
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,1234 , 567890123)
        call s__assert_Boolean(s__bigNumber_toStringWithUnit(bn) == "1.2兆" , "Test_ToString: 兆位显示") // 测试千兆 (1234567890123456 = 1234.6兆)
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,1234567 , 890123456)
        call s__assert_Boolean(s__bigNumber_toStringWithUnit(bn) == "1234.6兆" , "Test_ToString: 千兆显示") // 测试京位 (123456789123456789 = 12.3京)
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,123456789 , 123456789)
        call s__assert_Boolean(s__bigNumber_toStringWithUnit(bn) == "12.3京" , "Test_ToString: 京位显示") // 测试最大值 (21000000000999999999 = 21.0京)
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,2100000000 , 999999999)
        call s__assert_Boolean(s__bigNumber_toStringWithUnit(bn) == "210.0京" , "Test_ToString: 最大值显示") // 测试负数显示 (-123456789 = -1.2亿)
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , - 123456789)
        call s__assert_Boolean(s__bigNumber_toStringWithUnit(bn) == "-1.2亿" , "Test_ToString: 负数显示")
    endfunction  //==============================
    function UTBigNumber___Test_ToStringWithCommas takes nothing returns nothing
        local integer bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 5)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "5" , "Test_ToStringWithCommas: 1位数") // 2位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 42)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "42" , "Test_ToStringWithCommas: 2位数") // 3位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 123)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "123" , "Test_ToStringWithCommas: 3位数") // 4位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 1234)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "1,234" , "Test_ToStringWithCommas: 4位数") // 5位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 12345)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "12,345" , "Test_ToStringWithCommas: 5位数") // 6位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 123456)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "123,456" , "Test_ToStringWithCommas: 6位数") // 7位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 1234567)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "1,234,567" , "Test_ToStringWithCommas: 7位数") // 8位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 12345678)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "12,345,678" , "Test_ToStringWithCommas: 8位数") // 9位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 123456789)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "123,456,789" , "Test_ToStringWithCommas: 9位数") // 10位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,1 , 234567890)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "1,234,567,890" , "Test_ToStringWithCommas: 10位数") // 11位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,12 , 345678901)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "12,345,678,901" , "Test_ToStringWithCommas: 11位数") // 12位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,123 , 456789012)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "123,456,789,012" , "Test_ToStringWithCommas: 12位数") // 13位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,1234 , 567890123)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "1,234,567,890,123" , "Test_ToStringWithCommas: 13位数") // 14位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,12345 , 678901234)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "12,345,678,901,234" , "Test_ToStringWithCommas: 14位数") // 15位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,123456 , 789012345)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "123,456,789,012,345" , "Test_ToStringWithCommas: 15位数") // 16位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,1234567 , 890123456)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "1,234,567,890,123,456" , "Test_ToStringWithCommas: 16位数") // 17位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,12300000 , 901234567)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "12,300,000,901,234,567" , "Test_ToStringWithCommas: 17位数") // 18位数
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,123456789 , 12345678)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "123,456,789,012,345,678" , "Test_ToStringWithCommas: 18位数") // 负数测试
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,- 123 , 456789012)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "-123,456,789,012" , "Test_ToStringWithCommas: 负数") // 最大值测试
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,2100000000 , 999999999)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "2,100,000,000,999,999,999" , "Test_ToStringWithCommas: 最大值") // 最小值测试
        set bn=s__bigNumber_create()
        call s__bigNumber_add(bn,- 2100000000 , - 999999999)
        call s__assert_String(s__bigNumber_toStringWithCommas(bn) , "-2,100,000,000,999,999,999" , "Test_ToStringWithCommas: 最小值")
    endfunction
        function UTBigNumber___anon__0 takes nothing returns nothing
            call BJDebugMsg("测试")
            call UTBigNumber___Test_Create()
        endfunction
        function UTBigNumber___anon__1 takes nothing returns nothing
            call BJDebugMsg("测试加法")
            call UTBigNumber___Test_Add()
        endfunction
        function UTBigNumber___anon__2 takes nothing returns nothing
            call BJDebugMsg("测试加实数")
            call UTBigNumber___Test_AddReal()
        endfunction
        function UTBigNumber___anon__3 takes nothing returns nothing
            call BJDebugMsg("测试乘法")
            call UTBigNumber___Test_MultiplyInteger()
        endfunction
        function UTBigNumber___anon__4 takes nothing returns nothing
            call BJDebugMsg("测试输出")
            call UTBigNumber___Test_ToString()
        endfunction
        function UTBigNumber___anon__5 takes nothing returns nothing
            call BJDebugMsg("测试带逗号显示")
            call UTBigNumber___Test_ToStringWithCommas()
        endfunction
    function UTBigNumber___Init takes nothing returns nothing
        call UnitTestAutoTimer(1.0 , 1.0 , function UTBigNumber___anon__0 , null)
        call UnitTestAutoTimer(2.0 , 1.0 , function UTBigNumber___anon__1 , null)
        call UnitTestAutoTimer(3.0 , 1.0 , function UTBigNumber___anon__2 , null)
        call UnitTestAutoTimer(4.0 , 1.0 , function UTBigNumber___anon__3 , null)
        call UnitTestAutoTimer(5.0 , 1.0 , function UTBigNumber___anon__4 , null)
        call UnitTestAutoTimer(6.0 , 1.0 , function UTBigNumber___anon__5 , null)
    endfunction  // 测试基本创建和销毁
    function UTBigNumber___TTestUTBigNumber1 takes player p returns nothing
        local integer bn=s__bigNumber_create()
        call s__bigNumber_add(bn,- 210 , - 846726348)
        call s__bigNumber_multiplyInteger(bn,18)
        call BJDebugMsg("乘法结果: " + s__bigNumber_toStringWithCommas(bn))
        call BJDebugMsg("high=" + I2S(s__bigNumber_high[bn]) + ", low=" + I2S(s__bigNumber_low[bn]))
        set bn=s__bigNumber_create() // => (-1000000000, 0)
        call s__bigNumber_add(bn,- 1000000000 , 0) // => -5,000,000,000 => 应该��出到 (-2100000000, -999999999)
        call s__bigNumber_multiplyInteger(bn,5)
        call BJDebugMsg("乘法结果: " + s__bigNumber_toStringWithCommas(bn))
        call BJDebugMsg("high=" + I2S(s__bigNumber_high[bn]) + ", low=" + I2S(s__bigNumber_low[bn]))
        call s__bigNumber_deallocate(bn)
        call BJDebugMsg("BigNumber已销毁")
    endfunction  // 测试加法运算
    function UTBigNumber___TTestUTBigNumber2 takes player p returns nothing
        local integer bn=s__bigNumber_create()
        call s__bigNumber_add(bn,1 , 500000000)
        call BJDebugMsg("加法测试1: " + s__bigNumber_toStringWithCommas(bn)) // 添加20亿
        call s__bigNumber_addReal(bn,2000000000.0)
        call BJDebugMsg("加法测试2: " + s__bigNumber_toStringWithCommas(bn))
        call s__bigNumber_deallocate(bn)
    endfunction  // 测试乘法运算
    function UTBigNumber___TTestUTBigNumber3 takes player p returns nothing
        local integer bn=s__bigNumber_create()
        call s__bigNumber_add(bn,0 , 123456789)
        call BJDebugMsg("初始值: " + s__bigNumber_toStringWithCommas(bn) + " (" + s__bigNumber_toStringWithUnit(bn) + ")") // 乘以2
        call s__bigNumber_multiplyInteger(bn,2)
        call BJDebugMsg("乘以2后: " + s__bigNumber_toStringWithCommas(bn) + " (" + s__bigNumber_toStringWithUnit(bn) + ")")
        call BJDebugMsg("high=" + I2S(s__bigNumber_high[bn]) + ", low=" + I2S(s__bigNumber_low[bn])) // 再乘以1.5
        call s__bigNumber_multiplyReal(bn,1.5)
        call BJDebugMsg("乘以1.5后: " + s__bigNumber_toStringWithCommas(bn) + " (" + s__bigNumber_toStringWithUnit(bn) + ")")
        call BJDebugMsg("high=" + I2S(s__bigNumber_high[bn]) + ", low=" + I2S(s__bigNumber_low[bn]))
        call s__bigNumber_deallocate(bn)
    endfunction  // 测试比较运算
    function UTBigNumber___TTestUTBigNumber4 takes player p returns nothing
        local integer bn1=s__bigNumber_create()
        local integer bn2=s__bigNumber_create()
        call s__bigNumber_add(bn1,1 , 0) // 5亿
        call s__bigNumber_add(bn2,0 , 500000000)
        call BJDebugMsg("比较测试: " + I2S(s__bigNumber_compareBigNumber(bn1,bn2)))
        call s__bigNumber_deallocate(bn1)
        call s__bigNumber_deallocate(bn2)
    endfunction  // 测试字符串转换
    function UTBigNumber___TTestUTBigNumber5 takes player p returns nothing
        local integer bn=s__bigNumber_create()
        call s__bigNumber_add(bn,2 , 123456789)
        call BJDebugMsg("数字显示测试1(带逗号): " + s__bigNumber_toStringWithCommas(bn))
        call BJDebugMsg("数字显示测试2(带单位): " + s__bigNumber_toStringWithUnit(bn))
        call s__bigNumber_deallocate(bn)
    endfunction  // 处理带参数的测试命令
    function UTBigNumber___TTestActUTBigNumber1 takes string str returns nothing
        local player p=GetTriggerPlayer()
        local integer index=GetConvertedPlayerId(p)
        local integer i
        local integer num=0
        local integer len=StringLength(str)
        local string array paramS
        local integer array paramI
        local real array paramR
        local integer bn
        local integer bn1
        local integer bn2
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
        set num=num + 1 // 加法测试
        if ( paramS[0] == "a" ) then
            set bn=s__bigNumber_create()
            call s__bigNumber_addReal(bn,paramR[1])
            call s__bigNumber_addReal(bn,paramR[2])
            call BJDebugMsg("加法结果: " + s__bigNumber_toStringWithCommas(bn))
            call s__bigNumber_deallocate(bn) // 乘法测试
        elseif ( paramS[0] == "m" ) then
            set bn=s__bigNumber_create()
            call s__bigNumber_addReal(bn,paramR[1])
            call s__bigNumber_multiplyReal(bn,paramR[2])
            call BJDebugMsg("乘法结果: " + s__bigNumber_toStringWithCommas(bn))
            call s__bigNumber_deallocate(bn) // 比较测试
        elseif ( paramS[0] == "c" ) then
            set bn1=s__bigNumber_create()
            set bn2=s__bigNumber_create()
            call s__bigNumber_addReal(bn1,paramR[1])
            call s__bigNumber_addReal(bn2,paramR[2])
            call BJDebugMsg("比较结果: " + I2S(s__bigNumber_compareBigNumber(bn1,bn2)))
            call s__bigNumber_deallocate(bn1)
            call s__bigNumber_deallocate(bn2)
        endif
        set p=null
    endfunction
        function UTBigNumber___anon__6 takes nothing returns nothing
            call BJDebugMsg("[BigNumber] 单元测试已加载")
            call BJDebugMsg("使用s1-s5测试基本功能")
            call BJDebugMsg("使用-a/-m/-c [参数]测试具体数值")
            call UTBigNumber___Init()
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTBigNumber___anon__7 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            if ( SubStringBJ(str, 1, 1) == "-" ) then
                call UTBigNumber___TTestActUTBigNumber1(SubStringBJ(str, 2, StringLength(str)))
                return
            endif
            if ( str == "s1" ) then
                call UTBigNumber___TTestUTBigNumber1(GetTriggerPlayer())
            elseif ( str == "s2" ) then
                call UTBigNumber___TTestUTBigNumber2(GetTriggerPlayer())
            elseif ( str == "s3" ) then
                call UTBigNumber___TTestUTBigNumber3(GetTriggerPlayer())
            elseif ( str == "s4" ) then
                call UTBigNumber___TTestUTBigNumber4(GetTriggerPlayer())
            elseif ( str == "s5" ) then
                call UTBigNumber___TTestUTBigNumber5(GetTriggerPlayer())
            endif
        endfunction
    function UTBigNumber___onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEventSingle(tr, 0.5)
        call TriggerAddCondition(tr, Condition(function UTBigNumber___anon__6))
        set tr=null
        call UnitTestRegisterChatEvent(function UTBigNumber___anon__7)
    endfunction

//library UTBigNumber ends

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

call ExecuteFunc("jasshelper__initstructs35925640")
call ExecuteFunc("UnitTestFramwork___onInit")
call ExecuteFunc("UTBigNumber___onInit")

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
function sa__bigNumber_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            set s__bigNumber_low[this]=0
            set s__bigNumber_high[this]=0
   return true
endfunction

function jasshelper__initstructs35925640 takes nothing returns nothing
    set st__bigNumber_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__bigNumber_onDestroy,Condition( function sa__bigNumber_onDestroy))



endfunction

