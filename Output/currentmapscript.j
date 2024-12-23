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
//library ConversionUtils:
    function B2S takes boolean b returns string
        if (b)then
            return "true"
        else
            return "false"
        endif
    endfunction  //三目运算符
    function S3 takes boolean b,string s1,string s2 returns string
        if (b)then
            return s1
        else
            return s2
        endif
    endfunction  //三目运算符
    function I3 takes boolean b,integer i1,integer i2 returns integer
        if (b)then
            return i1
        else
            return i2
        endif
    endfunction  //三目运算符
    function R3 takes boolean b,real r1,real r2 returns real
        if (b)then
            return r1
        else
            return r2
        endif
    endfunction  // 将数字转换为魔兽的四字符ID,使用256进制但限制36个数一进位
    function GetIDSymbol takes integer pos returns integer  // pos为输入数字,每36个数字进一位,每位用0-9和a-z表示(共36个字符) // 示例:0->'0000', 35->'000z', 36->'0010'(进位), 37->'0011'
        local integer bit=pos/36
        set pos=ModuloInteger(pos,36)
        if (pos<10)then
            return pos+bit*256
        else
            return '000a'-'0000'+pos-10+bit*256
        endif
    endfunction  // 将魔兽的四字符ID转换回对应数字
    function GetSymbolID takes integer s returns integer  // s为输入的四字符ID,将其还原为原始数字 // 示例:'0000'->0, '000z'->35, '0010'->36, '0011'->37
        local integer i1=s/256
        local integer i2=ModuloInteger(s,256)
        if (i2<10)then
            return i1*36+i2
        else
            return i2-'000a'+'0000'+10+i1*36
        endif
    endfunction

//library ConversionUtils ends
//library UnitTestFramwork:

    struct assert extends array  //断言布尔值
    //! pragma implicitthis
        static method Boolean takes boolean condition,string name returns nothing
            if (not condition)then
                call BJDebugMsg("FAIL: "+name)
            else
                call BJDebugMsg("PASS: "+name)
            endif
        endmethod
    endstruct  //注册单元测试事件(聊天内容),自动注入
    function UnitTestRegisterChatEvent takes code func returns nothing
        call TriggerAddAction(UnitTestFramwork___TUnitTest,func)
    endfunction  //指定开始时间与持续时间的定时器
        function UnitTestFramwork___anon__0 takes nothing returns nothing
            local real time=LoadReal(UnitTestFramwork___HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),1)
            local real d=LoadReal(UnitTestFramwork___HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),2)
            local trigger tr=LoadTriggerHandle(UnitTestFramwork___HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),3)
            call BJDebugMsg("-----[单测 "+R2SW(time,0,1)+" - "+R2SW(time+d,0,1)+" 秒]开始------")
            call TriggerEvaluate(tr)
            call DestroyTrigger(tr)
            call FlushChildHashtable(UnitTestFramwork___HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()))
            call DestroyTrigger(GetTriggeringTrigger())
            set tr=null
        endfunction
        function UnitTestFramwork___anon__1 takes nothing returns nothing
            local real time=LoadReal(UnitTestFramwork___HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),1)
            local real d=LoadReal(UnitTestFramwork___HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),2)
            local trigger tr=LoadTriggerHandle(UnitTestFramwork___HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),3)
            call TriggerEvaluate(tr)
            call BJDebugMsg("-----[单测 "+R2SW(time,0,1)+" - "+R2SW(time+d,0,1)+" 秒]结束------")
            call DestroyTrigger(tr)
            call FlushChildHashtable(UnitTestFramwork___HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()))
            call DestroyTrigger(GetTriggeringTrigger())
            set tr=null
        endfunction
    function UnitTestAutoTimer takes real time,real duration,code start,code end returns nothing
        local trigger t=CreateTrigger()
        local trigger tr=CreateTrigger()
        call TriggerAddCondition(t,Condition(start))
        call TriggerRegisterTimerEventSingle(tr,time)
        call SaveReal(UnitTestFramwork___HASH_UNITTEST,GetHandleId(tr),1,time)
        call SaveReal(UnitTestFramwork___HASH_UNITTEST,GetHandleId(tr),2,duration)
        call SaveTriggerHandle(UnitTestFramwork___HASH_UNITTEST,GetHandleId(tr),3,t)
        call TriggerAddCondition(tr,Condition(function UnitTestFramwork___anon__0))
        set t=CreateTrigger()
        set tr=CreateTrigger()
        call TriggerAddCondition(t,Condition(end))
        call TriggerRegisterTimerEventSingle(tr,time+duration)
        call SaveReal(UnitTestFramwork___HASH_UNITTEST,GetHandleId(tr),1,time)
        call SaveReal(UnitTestFramwork___HASH_UNITTEST,GetHandleId(tr),2,duration)
        call SaveTriggerHandle(UnitTestFramwork___HASH_UNITTEST,GetHandleId(tr),3,t)
        call TriggerAddCondition(tr,Condition(function UnitTestFramwork___anon__1))
        set tr=null
        set t=null
    endfunction
        function UnitTestFramwork___anon__2 takes nothing returns nothing  //在游戏开始0.1秒后再调用
            local integer i
            set i=1
            loop
            exitwhen (i>12)
                call SetPlayerName(ConvertedPlayer(i),"测试员"+I2S(i)+"号")  //迷雾全关
                call CreateFogModifierRectBJ(true,ConvertedPlayer(i),FOG_OF_WAR_VISIBLE,GetPlayableMapRect())
            set i = i+1
            endloop
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
    function UnitTestFramwork___onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEventSingle(tr,0.1)
        call TriggerAddCondition(tr,Condition(function UnitTestFramwork___anon__2))
        set tr=null
        set UnitTestFramwork___TUnitTest=CreateTrigger()
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest,Player(0),"",false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest,Player(1),"",false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest,Player(2),"",false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest,Player(3),"",false)
    endfunction

//library UnitTestFramwork ends
//library BigNumber:
    struct bigNumber 
    //! pragma implicitthis
        method isExist takes nothing returns boolean  // 低位，存储-999999999到999999999
            return (this!=null and si__bigNumber_V[this]==-1)
        endmethod
        integer low  // 高位，存储-2100000000到2100000000
        integer high
        static method create takes nothing returns thistype
            local thistype this=thistype.allocate()
            set this.low=0
            set this.high=0
            return this
        endmethod  //==============================
        private method isNegative takes nothing returns boolean  // 辅助: 判断自身是否为负数 //==============================
            if (this.high<0)then
                return true
            elseif (this.high==0 and this.low<0)then
                return true
            endif
            return false
        endmethod  //==============================
        private method negate takes nothing returns nothing  // 辅助: 取自身反号 //==============================
            set this.high=-this.high
            set this.low=-this.low  // 当反号后，low、high 不在预期区间时，做一次借位或退位修正
            if (this.low<0 and this.high>0)then
                set this.low=this.low+1000000000
                set this.high=this.high-1
            elseif (this.low>0 and this.high<0)then
                set this.low=this.low-1000000000
                set this.high=this.high+1
            endif  // 防止溢出
            if (this.high>2100000000)then
                set this.high=2100000000
                set this.low=999999999
            elseif (this.high<-2100000000)then
                set this.high=-2100000000
                set this.low=-999999999
            endif
        endmethod  //==============================
        private method makePositive takes nothing returns nothing  // 辅助: 若自身为负，就改为正 //==============================
            if (this.isNegative())then
                call this.negate()
            endif
        endmethod  //==============================
        method add takes integer highPart,integer lowPart returns nothing  // 加法: (highPart, lowPart) 加到自身 //============================== // 加到低位
            set this.low=this.low+lowPart  // 处理低位进位/借位
            if (this.low>=1000000000)then
                set this.high=this.high+(this.low/1000000000)
                set this.low=ModuloInteger(this.low,1000000000)
            elseif (this.low<=-1000000000)then
                set this.high=this.high+(this.low/1000000000)
                set this.low=-ModuloInteger(IAbsBJ(this.low),1000000000)
            elseif (this.low<0 and this.high>0)then
                set this.low=this.low+1000000000
                set this.high=this.high-1
            elseif (this.low>0 and this.high<0)then
                set this.low=this.low-1000000000
                set this.high=this.high+1
            endif  // 加到高位
            set this.high=this.high+highPart  // 防止溢出
            if (this.high>2100000000)then
                set this.high=2100000000
                set this.low=999999999
            elseif (this.high<-2100000000)then
                set this.high=-2100000000
                set this.low=-999999999
            endif
        endmethod  //==============================
        method addReal takes real value returns nothing  // 加实数 //==============================
            local integer highValue=0
            local integer lowValue=0
            if (value>=1000000000.0)then
                set highValue=R2I(value/1000000000.0)
                set lowValue=R2I(ModuloReal(value,1000000000.0))
            elseif (value<=-1000000000.0)then
                set highValue=-R2I(RAbsBJ(value)/1000000000.0)
                set lowValue=-R2I(ModuloReal(RAbsBJ(value),1000000000.0))
            else
                set lowValue=R2I(value)
            endif
            call this.add(highValue,lowValue)
        endmethod  //==============================
        private method clone takes nothing returns thistype  // 克隆自身 //==============================
            local thistype tmp=thistype.allocate()
            set tmp.high=this.high
            set tmp.low=this.low
            return tmp
        endmethod  //==============================
        private method addBigNumber takes bigNumber other returns nothing  // 把另一个 bigNumber 加到自身 //==============================
            call this.add(other.high,other.low)
        endmethod  //==============================
        private method doubleBN takes nothing returns nothing  // 翻倍 (×2) //============================== // doubleBN = self + self
            call this.add(this.high,this.low)
        endmethod  //==============================
        method multiplyInteger takes integer val returns nothing  // 乘法: 与 32 位整数相乘(无 64 位) //==============================
            local integer sign=1
            local integer tmpVal=val
            local bigNumber result=thistype.create()
            local bigNumber temp=this.clone()  // 1. 符号处理
            if (tmpVal<0)then
                set tmpVal=-tmpVal
                set sign=-sign
            endif
            if (this.isNegative())then
                call this.negate()
                set sign=-sign
            endif  // 2. 二进制拆分乘法
            loop  // 如果当前位是1，就把temp加到结果中
            exitwhen (tmpVal<=0)
                if (ModuloInteger(tmpVal,2)==1)then
                    call result.addBigNumber(temp)
                endif  // temp翻倍（相当于左移一位）
                call temp.doubleBN()  // tmpVal右移一位
                set tmpVal=tmpVal/2
            endloop  // 3. 恢复符号
            if (sign<0)then
                call result.negate()
            endif  // 4. 将 result 写回当
            set this.high=result.high
            set this.low=result.low  // 5. 释放临时对象
            call result.destroy()
            call temp.destroy()
        endmethod  //==============================
        method multiplyReal takes real rVal returns nothing  // 乘法: 与实数相乘(有精度损失) //==============================
            local real highProduct
            local real lowProduct
            local integer newHigh
            local integer newLow  // 分别计算高位和低位与 rVal 的乘积
            set highProduct=I2R(this.high)*rVal
            set lowProduct=I2R(this.low)*rVal  // 处理高位部分
            set newHigh=R2I(highProduct*1000000000.0)
            set newLow=R2I(lowProduct)  // 清零后重新加入结果
            set this.high=0
            set this.low=0
            call this.add(newHigh,newLow)
        endmethod  //==============================
        method compareBigNumber takes bigNumber other returns integer  // 比较: 与另一个 bigNumber // 返回 1(大于)/0(等于)/-1(小于) //==============================
            if (this.high>other.high)then
                return 1
            elseif (this.high<other.high)then
                return -1
            elseif (this.low>other.low)then
                return 1
            elseif (this.low<other.low)then
                return -1
            else
                return 0
            endif
        endmethod  //==============================
        method compareInteger takes integer val returns integer  // 比较: 与 32 位整数 //============================== // 如果 high 不为 0，那么结果由 high 的符号决定
            if (this.high>0)then
                return 1
            elseif (this.high<0)then
                return -1
            endif  // high 为 0 时，直接比较 low 与 val
            if (this.low>val)then
                return 1
            elseif (this.low<val)then
                return -1
            endif
            return 0
        endmethod  //==============================
        method compareReal takes real val returns integer  // 比较: 与实数(浮点会有误差) //==============================
            local integer highPart
            local real lowPart  // 处理 val 的范围
            local real absVal
            if (val>=1000000000.0)then
                set highPart=R2I(val/1000000000.0)
                set lowPart=ModuloReal(val,1000000000.0)  // 先较高位
                if (this.high>highPart)then
                    return 1
                elseif (this.high<highPart)then
                    return -1
                endif  // 高位相等，比较低位
                if (I2R(this.low)>lowPart)then
                    return 1
                elseif (I2R(this.low)<lowPart)then
                    return -1
                endif
                return 0
            elseif (val<=-1000000000.0)then
                set absVal=RAbsBJ(val)
                set highPart=-R2I(absVal/1000000000.0)
                set lowPart=-ModuloReal(absVal,1000000000.0)
                if (this.high>highPart)then
                    return 1
                elseif (this.high<highPart)then
                    return -1
                endif
                if (I2R(this.low)>lowPart)then
                    return 1
                elseif (I2R(this.low)<lowPart)then
                    return -1
                endif
                return 0
            else  // val 在 (-10亿, 10亿) 范围内
                if (this.high>0)then
                    return 1
                elseif (this.high<0)then
                    return -1
                endif
                if (I2R(this.low)>val)then
                    return 1
                elseif (I2R(this.low)<val)then
                    return -1
                endif
                return 0
            endif
        endmethod
        method onDestroy takes nothing returns nothing
            set this.low=0
            set this.high=0
        endmethod  //==============================
        method toStringWithCommas takes nothing returns string  // 转字符串: 带逗号分隔 // 例如: 123,456,789,012 //==============================
            local string result=""
            local integer currentLow=this.low
            local integer currentHigh=this.high
            local boolean isNegative=this.isNegative()  // 处理负数
            if (isNegative)then
                if (currentHigh<0)then
                    set currentHigh=-currentHigh
                endif
                if (currentLow<0)then
                    set currentLow=-currentLow
                endif
            endif  // 处理低位的后3位
            set result=I2S(ModuloInteger(currentLow,1000))  // 补齐3位
            if (currentLow>=1000)then
                if (ModuloInteger(currentLow,1000)<10)then
                    set result="00"+result
                elseif (ModuloInteger(currentLow,1000)<100)then
                    set result="0"+result
                endif
            endif  // 处理低位的中间3位
            set currentLow=currentLow/1000
            if (currentLow>0)then
                set result=I2S(ModuloInteger(currentLow,1000))+","+result  // 补齐3位
                if (currentLow>=1000)then
                    if (ModuloInteger(currentLow,1000)<10)then
                        set result="00"+result
                    elseif (ModuloInteger(currentLow,1000)<100)then
                        set result="0"+result
                    endif
                endif
            endif  // 处理低位的前3位
            set currentLow=currentLow/1000
            if (currentLow>0)then
                set result=I2S(currentLow)+","+result
            endif  // 处理高位部分（如果有）
            if (currentHigh>0)then
                if (result!="")then  // 补齐9位
                    loop  // 9位数字加2位逗号
                    exitwhen (StringLength(result)>=11)
                        set result="0"+result
                    endloop
                    set result=","+result
                endif
                set result=I2S(currentHigh)+result
            endif  // 添加负号
            if (isNegative)then
                set result="-"+result
            endif
            return result
        endmethod  //==============================
        method toStringWithUnit takes nothing returns string  // 转字符串: 带单位(万、亿、兆、京) // ���如: 123456789、1.2亿、3.4兆 //==============================
            local string result=""
            local integer currentHigh=this.high
            local integer currentLow=this.low
            local boolean isNegative=this.isNegative()
            local real value=0.0
            local real highPart=0.0
            local real lowPart=0.0  // 0=无单位, 1=万, 2=亿, 3=兆, 4=京
            local integer unitLevel=0  // 单位字符串
            local string units=""
            if (isNegative)then
                if (currentHigh<0)then
                    set currentHigh=-1*currentHigh
                endif
                if (currentLow<0)then
                    set currentLow=-1*currentLow
                endif
            endif  // 分别计算高位和低位部分
            set highPart=I2R(currentHigh)*1000000000
            set lowPart=I2R(currentLow)
            set value=highPart+lowPart  // 1000万以下直接显示
            if (value<10000000.0)then
                set result=I2S(R2I(value))
            else  // 循环除以10000直到小于10000
                loop
                exitwhen (value<10000.0)
                    set value=value/10000.0
                    set unitLevel=unitLevel+1
                endloop  // 根据unitLevel确定单位
                if (unitLevel==1)then
                    set units="万"
                elseif (unitLevel==2)then
                    set units="亿"
                elseif (unitLevel==3)then
                    set units="兆"
                elseif (unitLevel>=4)then  // 格式化数值并加上单位
                    set units="京"
                endif
                set result=R2SW(value,0,1)+units
            endif
            if (isNegative)then
                set result="-"+result
            endif
            return result
        endmethod
    endstruct

//library BigNumber ends
//library UTBigNumber:

    function UTBigNumber___Test_Create takes nothing returns nothing  // 1. 测试 create //==============================
        local bigNumber bn=bigNumber.create()
        call assert.Boolean(bn.high==0 and bn.low==0,"Test_Create: 新建 BigNumber 应当为 (0, 0)")
    endfunction  //==============================
    function UTBigNumber___Test_Add takes nothing returns nothing  // 2. 测试加法 //==============================
        local bigNumber bn=bigNumber.create()  // 2.1 初始值(0,0) + (0,0)
        call bn.add(0,0)
        call assert.Boolean(bn.high==0 and bn.low==0,"Test_Add(0, 0)")  // 2.2 正常范围 + 正常范围
        call bn.add(1,2)  // => (1,2)
        call assert.Boolean(bn.high==1 and bn.low==2,"Test_Add(1, 2)")  // 2.3 再加一个负数 => (1,2) + (-1,-2) => (0,0)
        call bn.add(-1,-2)
        call assert.Boolean(bn.high==0 and bn.low==0,"Test_Add(-1, -2)")  // 2.4 测试进位：低位超过 10亿
        set bn=bigNumber.create()  //     先重置为(0,0)，再加(0, 999999999)，再加(0, 10)
        call bn.add(0,999999999)  // => 999999999 + 10 = 1000000009，需要向 high 进位
        call bn.add(0,10)  // 进位后：bn.low 应该是 9，bn.high = 1
        call assert.Boolean(bn.high==1 and bn.low==9,"Test_Add 进位检查")  // 2.5 测试溢出: 连续叠加到超过 high 正上限
        set bn=bigNumber.create()  //     BigNumber 中 high 上限为 2100000000 //     这里模拟一下极大值加法，引发溢出 // 先加到极限
        call bn.add(2100000000,999999999)  // 再加一点，应该被截断到 (2100000000, 999999999)
        call bn.add(0,1)
        call assert.Boolean(bn.high==2100000000 and bn.low==999999999,"Test_Add 溢出正上限检查")  // 2.6 测试溢出: 负方向
        set bn=bigNumber.create()
        call bn.add(-2100000000,-999999999)  // 再继续减一点以测试负方向溢出
        call bn.add(0,-1)
        call assert.Boolean(bn.high==-2100000000 and bn.low==-999999999,"Test_Add 溢出负上限检查")
    endfunction  //==============================
    function UTBigNumber___Test_AddReal takes nothing returns nothing  // 3. 测试加实数 //==============================
        local bigNumber bn=bigNumber.create()  // 3.1 加一个小实数
        call bn.addReal(123.0)  // => (0, 123)
        call assert.Boolean(bn.high==0 and bn.low==123,"Test_AddReal(123.0)")  // 3.2 再加大实数 => 超过 10亿，会拆分到 high
        call bn.addReal(2000000000.0)  // => 2000000000 = 2 * 10^9 => high=2, low=0 // 现在累计 BN => high=2, low=123
        call assert.Boolean(bn.high==2 and bn.low==123,"Test_AddReal(2000000000.0)")  // 3.3 加负实数
        call bn.addReal(-2000000000.0)  //这里得拆着写 //这里得拆着写
        call bn.addReal(-50.0)  // => 原本 (2, 123) + (-2, -50)
        call assert.Boolean(bn.high==0 and bn.low==73,"Test_AddReal(-2000000000.0再-50.0)")  // => (0, 73) // 3.4 超过上限(-∞或+∞)截断测试
        set bn=bigNumber.create()  // 超大正数测试
        call bn.addReal(Pow(10.0,20))
        call assert.Boolean(bn.high==2100000000 and bn.low==999999999,"Test_AddReal 超大正数溢出测试")
        set bn=bigNumber.create()  // 超大负数测试
        call bn.addReal(-1*Pow(10.0,20))
        call assert.Boolean(bn.high==-2100000000 and bn.low==-999999999,"Test_AddReal 超大负数溢出测试")
    endfunction  //==============================
    function UTBigNumber___Test_MultiplyInteger takes nothing returns nothing  // 4. 测试乘法 //==============================
        local bigNumber bn=bigNumber.create()  // 4.1 基础乘以正数
        call bn.add(0,10)  // 先令 bn = (0, 10) // => (0, 20)
        call bn.multiplyInteger(2)
        call assert.Boolean(bn.high==0 and bn.low==20,"Test_MultiplyInteger(10×2)")  // 4.2 乘以负数 & 检查符号
        set bn=bigNumber.create()  // => (0,10)
        call bn.add(0,10)  // => (0, -30)
        call bn.multiplyInteger(-3)
        call assert.Boolean(bn.high==0 and bn.low==-30,"Test_MultiplyInteger 符号检查")  // 4.3 较大数相乘是否正常截断(如超越2,100,000,000)
        set bn=bigNumber.create()  // => (1000000000, 0)
        call bn.add(1000000000,0)  // => 5,000,000,000 => 应该溢出到 (2100000000, 999999999)
        call bn.multiplyInteger(5)
        call assert.Boolean(bn.high==2100000000 and bn.low==999999999,"Test_MultiplyInteger 溢出正上限检查")  // 4.4 负方向溢出
        set bn=bigNumber.create()  // => (-1000000000, 0)
        call bn.add(-1000000000,0)  // => -5,000,000,000 => 应该溢出到 (-2100000000, -999999999)
        call bn.multiplyInteger(5)
        call assert.Boolean(bn.high==-2100000000 and bn.low==-999999999,"Test_MultiplyInteger 溢出负上限检查")
    endfunction  //==============================
    function UTBigNumber___Test_ToString takes nothing returns nothing  // 5. 测试输出 //==============================
        local bigNumber bn=bigNumber.create()  // 测试个位数
        call bn.add(0,5)
        call assert.Boolean(bn.toStringWithUnit()=="5","Test_ToString: 个位数显示")  // 测试万位数 (12345 = 1.2万)
        set bn=bigNumber.create()
        call bn.add(0,12345)
        call assert.Boolean(bn.toStringWithUnit()=="12345","Test_ToString: 万位数显示")  // 测试百万 (1234567 = 123.5万)
        set bn=bigNumber.create()
        call bn.add(0,1234567)
        call assert.Boolean(bn.toStringWithUnit()=="1234567","Test_ToString: 百万显示")  // 测试亿位 (123456789 = 1.2亿)
        set bn=bigNumber.create()
        call bn.add(0,123456789)
        call assert.Boolean(bn.toStringWithUnit()=="1.2亿","Test_ToString: 亿位显示")  // 测试百亿 (12345678901 = 123.5亿)
        set bn=bigNumber.create()
        call bn.add(12,345678901)
        call assert.Boolean(bn.toStringWithUnit()=="123.5亿","Test_ToString: 百亿显示")  // 测试兆位 (1234567890123 = 1.2兆)
        set bn=bigNumber.create()
        call bn.add(1234,567890123)
        call assert.Boolean(bn.toStringWithUnit()=="1.2兆","Test_ToString: 兆位显示")  // 测试千兆 (1234567890123456 = 1234.6兆)
        set bn=bigNumber.create()
        call bn.add(1234567,890123456)
        call assert.Boolean(bn.toStringWithUnit()=="1234.6兆","Test_ToString: 千兆显示")  // 测试京位 (123456789123456789 = 12.3京)
        set bn=bigNumber.create()
        call bn.add(123456789,123456789)
        call assert.Boolean(bn.toStringWithUnit()=="12.3京","Test_ToString: 京位显示")  // 测试最大值 (21000000000999999999 = 21.0京)
        set bn=bigNumber.create()
        call bn.add(2100000000,999999999)
        call assert.Boolean(bn.toStringWithUnit()=="210.0京","Test_ToString: 最大值显示")  // 测试负数显示 (-123456789 = -1.2亿)
        set bn=bigNumber.create()
        call bn.add(0,-123456789)
        call assert.Boolean(bn.toStringWithUnit()=="-1.2亿","Test_ToString: 负数显示")
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
    function UTBigNumber___Init takes nothing returns nothing
        call UnitTestAutoTimer(1.0,1.0,function UTBigNumber___anon__0,null)
        call UnitTestAutoTimer(2.0,1.0,function UTBigNumber___anon__1,null)
        call UnitTestAutoTimer(3.0,1.0,function UTBigNumber___anon__2,null)
        call UnitTestAutoTimer(4.0,1.0,function UTBigNumber___anon__3,null)
        call UnitTestAutoTimer(5.0,1.0,function UTBigNumber___anon__4,null)
    endfunction  // 测试基本创建和销毁
    function UTBigNumber___TTestUTBigNumber1 takes player p returns nothing
        set bn=bigNumber.create()  // 超大正数测试
        call bn.addReal(Pow(10.0,20))
        call BJDebugMsg("正无穷: "+bn.toStringWithCommas())
        call BJDebugMsg("正无穷: "+bn.toStringWithUnit())
        set bn=bigNumber.create()  // 超大负数测试
        call bn.addReal(-1*Pow(10.0,20))
        call BJDebugMsg("负无穷: "+bn.toStringWithCommas())
        call BJDebugMsg("负无穷: "+bn.toStringWithUnit())
        set bn=bigNumber.create()  // => (1000000000, 0)
        call bn.add(1000000000,0)  // => 5,000,000,000 => 应该溢出到 (2100000000, 999999999)
        call bn.multiplyInteger(5)
        call BJDebugMsg("正溢出: "+bn.toStringWithCommas())
        call BJDebugMsg("正溢出: "+bn.toStringWithUnit())
        set bn=bigNumber.create()  // => (-1000000000, 0)
        call bn.add(-1000000000,0)  // => -5,000,000,000 => 应该溢出到 (-2100000000, -999999999)
        call bn.multiplyInteger(5)
        call BJDebugMsg("负溢出: "+bn.toStringWithCommas())
        call BJDebugMsg("负溢出: "+bn.toStringWithUnit())
        call bn.destroy()
        call BJDebugMsg("BigNumber已销毁")
    endfunction  // 测试加法运算
    function UTBigNumber___TTestUTBigNumber2 takes player p returns nothing
        local bigNumber bn=bigNumber.create()  // 添加15亿
        call bn.add(1,500000000)
        call BJDebugMsg("加法测试1: "+bn.toStringWithCommas())  // 添加20亿
        call bn.addReal(2000000000.0)
        call BJDebugMsg("加法测试2: "+bn.toStringWithCommas())
        call bn.destroy()
    endfunction  // 测试乘法运算
    function UTBigNumber___TTestUTBigNumber3 takes player p returns nothing
        local bigNumber bn=bigNumber.create()  // 设置初始值为1.23亿
        call bn.add(0,123456789)
        call BJDebugMsg("初始值: "+bn.toStringWithCommas()+" ("+bn.toStringWithUnit()+")")  // 乘以2
        call bn.multiplyInteger(2)
        call BJDebugMsg("乘以2后: "+bn.toStringWithCommas()+" ("+bn.toStringWithUnit()+")")
        call BJDebugMsg("high="+I2S(bn.high)+", low="+I2S(bn.low))  // 再乘以1.5
        call bn.multiplyReal(1.5)
        call BJDebugMsg("乘以1.5后: "+bn.toStringWithCommas()+" ("+bn.toStringWithUnit()+")")
        call BJDebugMsg("high="+I2S(bn.high)+", low="+I2S(bn.low))
        call bn.destroy()
    endfunction  // 测试比较运算
    function UTBigNumber___TTestUTBigNumber4 takes player p returns nothing
        local bigNumber bn1=bigNumber.create()
        local bigNumber bn2=bigNumber.create()  // 10亿
        call bn1.add(1,0)  // 5亿
        call bn2.add(0,500000000)
        call BJDebugMsg("比较测试: "+I2S(bn1.compareBigNumber(bn2)))
        call bn1.destroy()
        call bn2.destroy()
    endfunction  // 测试字符串转换
    function UTBigNumber___TTestUTBigNumber5 takes player p returns nothing
        local bigNumber bn=bigNumber.create()
        call bn.add(2,123456789)
        call BJDebugMsg("数字显示测试1(带逗号): "+bn.toStringWithCommas())
        call BJDebugMsg("数字显示测试2(带单位): "+bn.toStringWithUnit())
        call bn.destroy()
    endfunction  // 处理带参数的测试命令
    function UTBigNumber___TTestActUTBigNumber1 takes string str returns nothing
        local player p=GetTriggerPlayer()
        local integer index=GetConvertedPlayerId(p)
        local integer i
        local integer num=0
        local integer len=StringLength(str)
        local string  array paramS
        local integer  array paramI
        local real  array paramR
        local bigNumber bn
        local bigNumber bn1
        local bigNumber bn2  // 解析参数
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
        set num=num+1  // 加法测试
        if (paramS[0]=="a")then
            set bn=bigNumber.create()
            call bn.addReal(paramR[1])
            call bn.addReal(paramR[2])
            call BJDebugMsg("加法结果: "+bn.toStringWithCommas())
            call bn.destroy()  // 乘法测试
        elseif (paramS[0]=="m")then
            set bn=bigNumber.create()
            call bn.addReal(paramR[1])
            call bn.multiplyReal(paramR[2])
            call BJDebugMsg("乘法结果: "+bn.toStringWithCommas())
            call bn.destroy()  // 比较测试
        elseif (paramS[0]=="c")then
            set bn1=bigNumber.create()
            set bn2=bigNumber.create()
            call bn1.addReal(paramR[1])
            call bn2.addReal(paramR[2])
            call BJDebugMsg("比较结果: "+I2S(bn1.compareBigNumber(bn2)))
            call bn1.destroy()
            call bn2.destroy()
        endif
        set p=null
    endfunction
        function UTBigNumber___anon__5 takes nothing returns nothing
            call BJDebugMsg("[BigNumber] 单元测试已加载")
            call BJDebugMsg("使用s1-s5测试基本功能")
            call BJDebugMsg("使用-a/-m/-c [参数]测试具体数值")
            call UTBigNumber___Init()
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTBigNumber___anon__6 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            if (SubStringBJ(str,1,1)=="-")then
                call UTBigNumber___TTestActUTBigNumber1(SubStringBJ(str,2,StringLength(str)))
                return
            endif
            if (str=="s1")then
                call UTBigNumber___TTestUTBigNumber1(GetTriggerPlayer())
            elseif (str=="s2")then
                call UTBigNumber___TTestUTBigNumber2(GetTriggerPlayer())
            elseif (str=="s3")then
                call UTBigNumber___TTestUTBigNumber3(GetTriggerPlayer())
            elseif (str=="s4")then
                call UTBigNumber___TTestUTBigNumber4(GetTriggerPlayer())
            elseif (str=="s5")then
                call UTBigNumber___TTestUTBigNumber5(GetTriggerPlayer())
            endif
        endfunction
    function UTBigNumber___onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEventSingle(tr,0.5)
        call TriggerAddCondition(tr,Condition(function UTBigNumber___anon__5))
        set tr=null
        call UnitTestRegisterChatEvent(function UTBigNumber___anon__6)
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
call ExecuteFunc("UnitTestFramwork___onInit")
call ExecuteFunc("UTBigNumber___onInit")

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



