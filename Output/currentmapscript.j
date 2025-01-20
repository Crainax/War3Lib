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
    trigger UnitTestFramwork___TUnitTest=null
    hashtable UnitTestFramwork___HASH_UNITTEST=InitHashtable()
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
    unit UTHeroAttr___testHeroStr=null
    unit UTHeroAttr___testHeroAgi=null
    heroAttr UTHeroAttr___attrStr=0
    heroAttr UTHeroAttr___attrAgi=0
//endglobals from UTHeroAttr
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
    function U3 takes boolean b,unit u1,unit u2 returns unit
        if (b)then
            return u1
        else
            return u2
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
//library MapBoundsUtils:
    struct mapBounds 
    //! pragma implicitthis
        static real maxX=0.
        static real minX=0.
        static real maxY=0.
        static real minY=0.  // 限制X坐标在地图范围内
        static method X takes real x returns real
            return RMinBJ(RMaxBJ(x,mapBounds.minX),mapBounds.maxX)
        endmethod  // 限制Y坐标在地图范围内
        static method Y takes real y returns real
            return RMinBJ(RMaxBJ(y,mapBounds.minY),mapBounds.maxY)
        endmethod  // 初始化
        static method onInit takes nothing returns nothing
            set mapBounds.minX=GetCameraBoundMinX()-GetCameraMargin(CAMERA_MARGIN_LEFT)
            set mapBounds.minY=GetCameraBoundMinY()-GetCameraMargin(CAMERA_MARGIN_BOTTOM)
            set mapBounds.maxX=GetCameraBoundMaxX()+GetCameraMargin(CAMERA_MARGIN_RIGHT)
            set mapBounds.maxY=GetCameraBoundMaxY()+GetCameraMargin(CAMERA_MARGIN_TOP)
        endmethod
    endstruct

//library MapBoundsUtils ends
//library MathUtils:
    function R2IRandom takes real value returns integer  // 将实数转换为整数，若小数部分大于随机数则进1
        if (GetRandomReal(0,1.0)<=ModuloReal(value,1.0))then
            return R2I(value)+1
        endif
        return R2I(value)
    endfunction  // 进行整数除法，若能整除则结果减1
    function Divide1 takes integer i1,integer i2 returns integer
        if (ModuloInteger(i1,i2)==0)then
            return i1/i2-1
        endif
        return i1/i2
    endfunction  // 实现特殊的数值叠加计算，主要用于游戏中各种加成效果的叠加
    function RealAdd takes real a1,real a2 returns real  // 该函数可以避免简单线性相加导致的数值溢出，保证叠加后的效果符合递减收益原则 // // 特点： // - 正数叠加时使用概率学公式：1-(1-a1)*(1-a2) // - 负数叠加时使用衰减公式：1-(1-a1)/(1+a2) // - 当第二个参数绝对值>=1.0时，直接返回第一个参数 // // 适用场景： // - 技能冷却缩减叠加（CDR） // - 暴击率、闪避率等概率性属性叠加 // - 移速加成等需要控制上限的属性叠加 // // 参数说明： // a1: 第一个数值，通常表示当前已有的加成效果 // a2: 第二个数值，表示要叠加的新加成效果 // 返回值: 叠加后的最终效果值 // // 使用示例： // real currentCDR = 0.4;    // 当前40%冷却缩减 // real newCDR = 0.5;        // 新装备50%冷却缩减 // real finalCDR = RealAdd(currentCDR, newCDR);  // 结果约为0.7，即70%冷却缩减 // // 注意事项： // 1. 虽然函数支持任意实数输入，但建议输入值在[-1.0, 1.0]范围内 // 2. 当|a2| >= 1.0时，函数会直接返回a1值 // 3. 该函数满足结合律，但不满足交换律，建议将已有效果作为第一个参数 // 4. 已测试过可以在用负数叠加后,使用负数的绝对值进行恢复
        if (RAbsBJ(a2)>=1.0)then
            return a1
        endif
        if (a2>=0)then
            return 1.0-(1.0-a1)*(1.0-a2)
        else
            return 1.0-(1.0-a1)/(1.0+a2)
        endif
    endfunction  // 最小最大值限制
    function ILimit takes integer target,integer min,integer max returns integer  // 限制整数在[min, max]范围内
        if (target<min)then
            return min
        elseif (target>max)then
            return max
        else
            return target
        endif
    endfunction  // 最小最大值限制
    function RLimit takes real target,real min,real max returns real  // 限制实数在[min, max]范围内
        if (target<min)then
            return min
        elseif (target>max)then
            return max
        else
            return target
        endif
    endfunction  // 四舍五入法实数转整数
    function R2IM takes real r returns integer  // 将实数四舍五入为整数
        if (ModuloReal(r,1.0)>=0.5)then
            return R2I(r)+1
        else
            return R2I(r)
        endif
    endfunction  // 计算射线与地图边界的交点
    struct radiationEnd   // 计算从给定点出发的射线与地图边界的交点
    //! pragma implicitthis
        static real x=0  // 一个坐标沿着某个方向的边缘值
        static real y=0
        static method cal takes real x1,real y1,real angle returns nothing  // 计算从点(x1,y1)出发，沿angle角度方向的射线与地图边界的交点 //相交点
            local real x2=0  //相交点
            local real y2=0  //求余数
            local real a=ModuloReal(angle,360)
            local real tan
            set x=0
            set y=0  // 处理特殊角度
            if (a==0)then  // 正右方
                set x=mapBounds.maxX
                set y=y1
                return
            endif  // 正上方
            if (a==90)then
                set x=x1
                set y=mapBounds.maxY
                return
            endif  // 正左方
            if (a==180)then
                set x=mapBounds.minX
                set y=y1
                return
            endif  // 正下方
            if (a==270)then
                set x=x1
                set y=mapBounds.minY
                return
            endif  // 处理一般角度
            if (a<90)then  //第一象限
                set tan=Tan((a)*0.0174538)
                set x2=(mapBounds.maxY-y1)/tan+x1
                set y2=(mapBounds.maxX-x1)*tan+y1  //取这个
                if (x2<=mapBounds.maxX)then
                    set x=x2
                    set y=mapBounds.maxY
                else
                    set x=mapBounds.maxX
                    set y=y2
                endif  //第二象限
            elseif (a<180)then
                set tan=Tan((a)*0.0174538)
                set x2=(mapBounds.maxY-y1)/tan+x1
                set y2=(mapBounds.minX-x1)*tan+y1  //取这个
                if (x2>=mapBounds.minX)then
                    set x=x2
                    set y=mapBounds.maxY
                else
                    set x=mapBounds.minX
                    set y=y2
                endif  //第三象限
            elseif (a<270)then
                set tan=Tan((a)*0.0174538)
                set x2=(mapBounds.minY-y1)/tan+x1
                set y2=(mapBounds.minX-x1)*tan+y1  //取这个
                if (x2>=mapBounds.minX)then
                    set x=x2
                    set y=mapBounds.minY
                else
                    set x=mapBounds.minX
                    set y=y2
                endif  //第四象限
            else
                set tan=Tan((a)*0.0174538)
                set x2=(mapBounds.minY-y1)/tan+x1
                set y2=(mapBounds.maxX-x1)*tan+y1  //取这个
                if (x2<=mapBounds.maxX)then
                    set x=x2
                    set y=mapBounds.minY
                else
                    set x=mapBounds.maxX
                    set y=y2
                endif
            endif
        endmethod
    endstruct  // 实现三个数值的特殊叠加计算
    function RealAdd3 takes real a1,real a2,real a3 returns real  // 效果等同于 RealAdd(RealAdd(a1,a2),a3) // // 参数说明： // a1: 第一个数值，通常表示当前已有的加成效果 // a2: 第二个数值，表示第一次要叠加的新加成效果 // a3: 第三个数值，表示第二次要叠加的新加成效果 // 返回值: 三个数值叠加后的最终效果值 // // 使用示例： // real baseEffect = 0.3;     // 基础30%效果 // real bonus1 = 0.4;         // 第一个40%加成 // real bonus2 = 0.2;         // 第二个20%加成 // real final = RealAdd3(baseEffect, bonus1, bonus2);  // 一次性计算三个效果的叠加
        local real temp  // 如果第二个参数绝对值>=1.0，直接用第一个参数与第三个参数计算
        if (RAbsBJ(a2)>=1.0)then
            return RealAdd(a1,a3)
        endif  // 如果第三个参数绝对值>=1.0，直接返回前两个参数的计算结果
        if (RAbsBJ(a3)>=1.0)then
            return RealAdd(a1,a2)
        endif  // 先计算前两个参数的结果
        if (a2>=0)then
            set temp=1.0-(1.0-a1)*(1.0-a2)
        else
            set temp=1.0-(1.0-a1)/(1.0+a2)
        endif  // 再与第三个参数计算
        if (a3>=0)then
            return 1.0-(1.0-temp)*(1.0-a3)
        else
            return 1.0-(1.0-temp)/(1.0+a3)
        endif
    endfunction

//library MathUtils ends
//library UnitHashTable:

//library UnitHashTable ends
//library UnitLifeCycle:
    struct unitLifeCycle extends array
    //! pragma implicitthis
        static unit argsUnit=null
        //private:
            private static trigger trCreate=null
            private static trigger trDestroy=null
        static method registerDestroy takes code func returns nothing  // 注册销毁回调
            call TriggerAddCondition(trDestroy,Condition(func))
        endmethod
        static method onDestroyCB takes unit u returns nothing
            set argsUnit=u
            call TriggerEvaluate(trDestroy)  //然后再清除所有哈希表
            call FlushChildHashtable(HASH_UNIT,GetHandleId(u))
            set argsUnit=null
        endmethod
        static method onInit takes nothing returns nothing
            set trCreate=CreateTrigger()
            set trDestroy=CreateTrigger()
        endmethod
    endstruct

//library UnitLifeCycle ends
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
        call TriggerRegisterTimerEvent(tr,time,false)
        call SaveReal(UnitTestFramwork___HASH_UNITTEST,GetHandleId(tr),1,time)
        call SaveReal(UnitTestFramwork___HASH_UNITTEST,GetHandleId(tr),2,duration)
        call SaveTriggerHandle(UnitTestFramwork___HASH_UNITTEST,GetHandleId(tr),3,t)
        call TriggerAddCondition(tr,Condition(function UnitTestFramwork___anon__0))
        if (end!=null)then
            set t=CreateTrigger()
            set tr=CreateTrigger()
            call TriggerAddCondition(t,Condition(end))
            call TriggerRegisterTimerEvent(tr,time+duration,false)
            call SaveReal(UnitTestFramwork___HASH_UNITTEST,GetHandleId(tr),1,time)
            call SaveReal(UnitTestFramwork___HASH_UNITTEST,GetHandleId(tr),2,duration)
            call SaveTriggerHandle(UnitTestFramwork___HASH_UNITTEST,GetHandleId(tr),3,t)
            call TriggerAddCondition(tr,Condition(function UnitTestFramwork___anon__1))
        endif
        set tr=null
        set t=null
    endfunction
        function UnitTestFramwork___anon__2 takes nothing returns nothing  //在游戏开始0.1秒后再调用
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
    function UnitTestFramwork___onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr,0.1,false)
        call TriggerAddCondition(tr,Condition(function UnitTestFramwork___anon__2))
        set tr=null
        set UnitTestFramwork___TUnitTest=CreateTrigger()
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest,Player(0),"",false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest,Player(1),"",false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest,Player(2),"",false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork___TUnitTest,Player(3),"",false)
    endfunction

//library UnitTestFramwork ends
//library UnitUtils:
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
            call SetUnitState(u,UNIT_STATE_LIFE,RMaxBJ(0,GetUnitState(u,UNIT_STATE_MANA)+mp))
        endif
    endfunction  //回蓝(定值)
    function RegenUnitMP takes unit u,real volume returns nothing
        call SetUnitState(u,UNIT_STATE_LIFE,RMaxBJ(0,GetUnitState(u,UNIT_STATE_MANA)+volume))
    endfunction  //回蓝(百分比)
    function RegenUnitMPPercent takes unit u,real rate returns nothing
        call SetUnitState(u,UNIT_STATE_LIFE,RMaxBJ(0,GetUnitState(u,UNIT_STATE_MANA)+GetUnitMP(u)*rate))
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
    endfunction
    function GetUnitInterval takes unit u returns real
        return GetUnitState(u,ConvertUnitState(0x25))
    endfunction  // 攻击间隔(虽然写着加,但是实际是减)
    function AddAttackInterval takes unit u,real value returns nothing
        call SetUnitState(u,ConvertUnitState(0x25),GetUnitInterval(u)-value)
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
        function YDLua___anon__0 takes nothing returns nothing  //在游戏开始0.0秒后再调用
            call BJDebugMsg("调用了YDLua引擎")
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
    function YDLua___onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr,0.0,false)
        call TriggerAddCondition(tr,Condition(function YDLua___anon__0))
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
    function Logger___onInit takes nothing returns nothing  //日志打印系统初始化
        call Cheat("exec-lua:depends.debug.logger")
    endfunction

//library Logger ends
//library UnitAttr:
    struct unitAttr 
    //! pragma implicitthis
        method isExist takes nothing returns boolean
            return (this!=null and si__unitAttr_V[this]==-1)
        endmethod
        static thistype ethis=0  //绑定的单位
        unit u
        static method parse takes unit u returns thistype
            local thistype this
            local integer handleId=GetHandleId(u)  // 先检查是否已存在
            if (HaveSavedInteger(HASH_UNIT,handleId,1726))then
                return LoadInteger(HASH_UNIT,handleId,1726)
            endif  // 不存在才创建新的
            set this=allocate()
            set this.u=u
            set this.baseHP=0
            set this.HPRateUp=0
            set this.HPRateDown=0
            set this.cachedHP=0
            set this.baseMP=0
            set this.MPRateUp=0
            set this.MPRateDown=0
            set this.cachedMP=0
            set this.baseAtk=0.0  // 初始化攻击力和防御力相关属性
            set this.AtkRateUp=0.0
            set this.AtkRateDown=0.0
            set this.AtkRateBonus=0.0
            set this.AtkFixedBonus=0.0
            set this.baseDef=0.0
            set this.DefRateUp=0.0
            set this.DefRateDown=0.0
            set this.DefRateBonus=0.0
            set this.DefFixedBonus=0.0
            set this.SpellDmgRateUp=0.0  // 初始化技能伤害增幅
            set this.SpellDmgRateDown=0.0
            call SaveInteger(HASH_UNIT,handleId,1726,this)
            return this
        endmethod  //仅获取已创建的,不创建新的
        static method get takes unit u returns thistype
            if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),1726))then
                return LoadInteger(HASH_UNIT,GetHandleId(u),1726)
            endif
            return 0
        endmethod  //同步并刷新当前单位的HP
        private method syncHPRate takes nothing returns nothing
            local real desiredHP
            local real diff  //计算期望的HP值 - 先计算增幅,再计算减幅
            set desiredHP=baseHP*(1.0+HPRateUp)*(1.0-HPRateDown)  //计算差值
            set diff=desiredHP-cachedHP  //只有当差值的绝对值大于等于1时才更新
            if (diff>=1.0 or diff<=-1.0)then  //设置最大值
                call SetUnitState(u,UNIT_STATE_MAX_LIFE,RMaxBJ(desiredHP,2.0))  //如果是增加值，同时增加当前值
                if (diff>0)then
                    call SetUnitState(u,UNIT_STATE_LIFE,GetUnitState(u,UNIT_STATE_LIFE)+diff)
                endif
                set cachedHP=desiredHP
            endif
        endmethod  //同步并刷新当前单位的MP
        private method syncMPRate takes nothing returns nothing
            local real desiredMP
            local real diff  //计算期望的MP值 - 先计算增幅,再计算减幅
            set desiredMP=baseMP*(1.0+MPRateUp)*(1.0-MPRateDown)  //计算差值
            set diff=desiredMP-cachedMP  //只有当差值的绝对值大于等于1时才更新
            if (diff>=1.0 or diff<=-1.0)then  //设置最大值
                call SetUnitState(u,UNIT_STATE_MAX_MANA,RMaxBJ(desiredMP,2.0))  //如果是增加值，同时增加当前值
                if (diff>0)then
                    call SetUnitState(u,UNIT_STATE_MANA,GetUnitState(u,UNIT_STATE_MANA)+diff)
                endif
                set cachedMP=desiredMP
            endif
        endmethod  // 同步并刷新当前单位的攻击
        private method syncAtkRate takes nothing returns nothing
            set AtkRateBonus=baseAtk*(1.0+AtkRateUp)*(1.0-AtkRateDown)-baseAtk
            call SetUnitState(u,ConvertUnitState(0x12),RMaxBJ(baseAtk+AtkRateBonus+AtkFixedBonus,0.0))
            if (trAtkChange!=null)then
                set ethis=this
                call TriggerEvaluate(trAtkChange)
            endif
        endmethod  // 同步并刷新当前单位的防御
        private method syncDefRate takes nothing returns nothing
            set DefRateBonus=baseDef*(1.0+DefRateUp)*(1.0-DefRateDown)-baseDef
            call SetUnitState(u,ConvertUnitState(0x20),baseDef+DefRateBonus+DefFixedBonus)
            if (trDefChange!=null)then
                set ethis=this
                call TriggerEvaluate(trDefChange)
            endif
        endmethod  // 使用宏定义生成HP相关属性和方法
        real baseHP
        real HPRateUp
        real HPRateDown
        private real cachedHP
        method addHP takes real value returns nothing
            if (value!=0)then
                set baseHP=baseHP+value
                call syncHPRate()
            endif
        endmethod
        method addHPRateUp takes real value returns nothing
            if (value!=0)then
                set HPRateUp=HPRateUp+value
                call syncHPRate()
            endif
        endmethod
        method addHPRateDown takes real value returns nothing
            if (value!=0)then
                set HPRateDown=RealAdd(HPRateDown,value)
                call syncHPRate()
            endif
        endmethod
        method getCurrentHPRate takes nothing returns real
            return (1.0+HPRateUp)*(1.0-HPRateDown)-1.0
        endmethod
        method getCurrentHP takes nothing returns real
            return cachedHP
        endmethod
        real baseMP  // 使用宏定义生成MP相关属性和方法
        real MPRateUp
        real MPRateDown
        private real cachedMP
        method addMP takes real value returns nothing
            if (value!=0)then
                set baseMP=baseMP+value
                call syncMPRate()
            endif
        endmethod
        method addMPRateUp takes real value returns nothing
            if (value!=0)then
                set MPRateUp=MPRateUp+value
                call syncMPRate()
            endif
        endmethod
        method addMPRateDown takes real value returns nothing
            if (value!=0)then
                set MPRateDown=RealAdd(MPRateDown,value)
                call syncMPRate()
            endif
        endmethod
        method getCurrentMPRate takes nothing returns real
            return (1.0+MPRateUp)*(1.0-MPRateDown)-1.0
        endmethod
        method getCurrentMP takes nothing returns real
            return cachedMP
        endmethod
        real baseAtk  // 使用宏定义生成攻击力相关属性和方法
        real AtkRateUp
        real AtkRateDown
        real AtkRateBonus
        real AtkFixedBonus
        static trigger trAtkChange=null
        method setBaseAtk takes real value returns nothing
            if (baseAtk!=value)then
                set baseAtk=value
                call syncAtkRate()
            endif
        endmethod
        method addBaseAtk takes real value returns nothing
            if (value!=0)then
                set baseAtk=baseAtk+value
                call syncAtkRate()
            endif
        endmethod
        method addAtkFixedBonus takes real value returns nothing
            if (value!=0)then
                set AtkFixedBonus=AtkFixedBonus+value
                call syncAtkRate()
            endif
        endmethod
        method addAtkRateUp takes real value returns nothing
            if (value!=0)then
                set AtkRateUp=AtkRateUp+value
                call syncAtkRate()
            endif
        endmethod
        method addAtkRateDown takes real value returns nothing
            if (value!=0)then
                set AtkRateDown=RealAdd(AtkRateDown,value)
                call syncAtkRate()
            endif
        endmethod
        method getCurrentAtk takes nothing returns real
            return baseAtk+AtkRateBonus+AtkFixedBonus
        endmethod
        method getCurrentAtkRate takes nothing returns real
            return (1.0+AtkRateUp)*(1.0-AtkRateDown)-1.0
        endmethod
        static method onAtkChange takes code func returns nothing
            if (trAtkChange==null)then
                set trAtkChange=CreateTrigger()
            endif
            call TriggerAddCondition(trAtkChange,Condition(func))
        endmethod
        real baseDef  // 使用宏定义生成防御力相关属性和方法
        real DefRateUp
        real DefRateDown
        real DefRateBonus
        real DefFixedBonus
        static trigger trDefChange=null
        method setBaseDef takes real value returns nothing
            if (baseDef!=value)then
                set baseDef=value
                call syncDefRate()
            endif
        endmethod
        method addBaseDef takes real value returns nothing
            if (value!=0)then
                set baseDef=baseDef+value
                call syncDefRate()
            endif
        endmethod
        method addDefFixedBonus takes real value returns nothing
            if (value!=0)then
                set DefFixedBonus=DefFixedBonus+value
                call syncDefRate()
            endif
        endmethod
        method addDefRateUp takes real value returns nothing
            if (value!=0)then
                set DefRateUp=DefRateUp+value
                call syncDefRate()
            endif
        endmethod
        method addDefRateDown takes real value returns nothing
            if (value!=0)then
                set DefRateDown=RealAdd(DefRateDown,value)
                call syncDefRate()
            endif
        endmethod
        method getCurrentDef takes nothing returns real
            return baseDef+DefRateBonus+DefFixedBonus
        endmethod
        method getCurrentDefRate takes nothing returns real
            return (1.0+DefRateUp)*(1.0-DefRateDown)-1.0
        endmethod
        static method onDefChange takes code func returns nothing
            if (trDefChange==null)then
                set trDefChange=CreateTrigger()
            endif
            call TriggerAddCondition(trDefChange,Condition(func))
        endmethod
        real SpellDmgRateUp  // 使用宏定义生成技能伤害增幅
        real SpellDmgRateDown
        method addSpellDmgRateUp takes real value returns nothing
            if (value!=0)then
                set SpellDmgRateUp=SpellDmgRateUp+value
            endif
        endmethod
        method addSpellDmgRateDown takes real value returns nothing
            if (value!=0)then
                set SpellDmgRateDown=RealAdd(SpellDmgRateDown,value)
            endif
        endmethod
        method getSpellDmgMultiplier takes nothing returns real
            return (1.0+SpellDmgRateUp)*(1.0-SpellDmgRateDown)-1.0
        endmethod
        method onDestroy takes nothing returns nothing  //单位删除会调用
            if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),1726))then
                call RemoveSavedInteger(HASH_UNIT,GetHandleId(u),1726)
            endif
            set u=null
        endmethod  //注册到周期结束中
            private static method anon__0 takes nothing returns nothing
                local unit u=unitLifeCycle.argsUnit
                local thistype this=unitAttr.parse(u)
                if (this.isExist())then
                    call this.destroy()
                endif
                set u=null
            endmethod
        static method onInit takes nothing returns nothing
            call unitLifeCycle.registerDestroy(function thistype.anon__0)
        endmethod
    endstruct

//library UnitAttr ends
//library HeroAttr:
    struct heroAttr 
    //! pragma implicitthis
        method isExist takes nothing returns boolean
            return (this!=null and si__heroAttr_V[this]==-1)
        endmethod
        static thistype ethis=0  //绑定的单位
        unit u  // 主属性类型
        integer mainAttrType  // 基础主属性
        real mainAttrBase  // 主属性增幅
        real mainAttrRateUp  // 主属性减幅
        real mainAttrRateDown  // 主属性固定加成
        real mainAttrFixedBonus  // 基础次属性
        real subAttrBase  // 次属性增幅
        real subAttrRateUp  // 次属性减幅
        real subAttrRateDown  // 次属性固定加成
        real subAttrFixedBonus  // 展开的Str属性相关代码
        real baseStr
        real StrRateUp
        real StrRateDown
        real StrRateBonus
        real StrFixedBonus
        static trigger trStrChange=null
        method getBaseStr takes nothing returns real
            if (mainAttrType==MAIN_ATTR_STR)then
                return baseStr+mainAttrBase
            else
                return baseStr+subAttrBase
            endif
        endmethod
        method getExtraStr takes nothing returns real
            if (mainAttrType==MAIN_ATTR_STR)then
                return StrRateBonus+StrFixedBonus+mainAttrFixedBonus
            else
                return StrRateBonus+StrFixedBonus+subAttrFixedBonus
            endif
        endmethod
        method getCurrentStr takes nothing returns real
            if (mainAttrType==MAIN_ATTR_STR)then
                return baseStr+mainAttrBase+StrRateBonus+StrFixedBonus+mainAttrFixedBonus
            else
                return baseStr+subAttrBase+StrRateBonus+StrFixedBonus+subAttrFixedBonus
            endif
        endmethod
        method getCurrentStrRate takes nothing returns real
            if (mainAttrType==MAIN_ATTR_STR)then
                return (1.0+StrRateUp+mainAttrRateUp)*(1.0-StrRateDown)*(1.0-mainAttrRateDown)-1.0
            else
                return (1.0+StrRateUp+subAttrRateUp)*(1.0-StrRateDown)*(1.0-subAttrRateDown)-1.0
            endif
        endmethod
        private method syncStrRate takes nothing returns nothing
            set StrRateBonus=getBaseStr()*getCurrentStrRate()
            call SetHeroStr(u,R2I(RMaxBJ(getCurrentStr(),0.0)),true)
            if (trStrChange!=null)then
                set ethis=this
                call TriggerEvaluate(trStrChange)
            endif
        endmethod
        method setBaseStr takes real value returns nothing
            if (baseStr!=value)then
                set baseStr=value
                call syncStrRate()
            endif
        endmethod
        method addBaseStr takes real value returns nothing
            if (value!=0)then
                set baseStr=baseStr+value
                call syncStrRate()
            endif
        endmethod
        method addStrFixedBonus takes real value returns nothing
            if (value!=0)then
                set StrFixedBonus=StrFixedBonus+value
                call syncStrRate()
            endif
        endmethod
        method addStrRateUp takes real value returns nothing
            if (value!=0)then
                set StrRateUp=StrRateUp+value
                call syncStrRate()
            endif
        endmethod
        method addStrRateDown takes real value returns nothing
            if (value!=0)then
                set StrRateDown=RealAdd(StrRateDown,value)
                call syncStrRate()
            endif
        endmethod
        static method onStrChange takes code func returns nothing
            if (trStrChange==null)then
                set trStrChange=CreateTrigger()
            endif
            call TriggerAddCondition(trStrChange,Condition(func))
        endmethod
        real baseAgi
        real AgiRateUp
        real AgiRateDown
        real AgiRateBonus
        real AgiFixedBonus
        static trigger trAgiChange=null
        method getBaseAgi takes nothing returns real
            if (mainAttrType==MAIN_ATTR_AGI)then
                return baseAgi+mainAttrBase
            else
                return baseAgi+subAttrBase
            endif
        endmethod
        method getExtraAgi takes nothing returns real
            if (mainAttrType==MAIN_ATTR_AGI)then
                return AgiRateBonus+AgiFixedBonus+mainAttrFixedBonus
            else
                return AgiRateBonus+AgiFixedBonus+subAttrFixedBonus
            endif
        endmethod
        method getCurrentAgi takes nothing returns real
            if (mainAttrType==MAIN_ATTR_AGI)then
                return baseAgi+mainAttrBase+AgiRateBonus+AgiFixedBonus+mainAttrFixedBonus
            else
                return baseAgi+subAttrBase+AgiRateBonus+AgiFixedBonus+subAttrFixedBonus
            endif
        endmethod
        method getCurrentAgiRate takes nothing returns real
            if (mainAttrType==MAIN_ATTR_AGI)then
                return (1.0+AgiRateUp+mainAttrRateUp)*(1.0-AgiRateDown)*(1.0-mainAttrRateDown)-1.0
            else
                return (1.0+AgiRateUp+subAttrRateUp)*(1.0-AgiRateDown)*(1.0-subAttrRateDown)-1.0
            endif
        endmethod
        private method syncAgiRate takes nothing returns nothing
            set AgiRateBonus=getBaseAgi()*getCurrentAgiRate()
            call SetHeroAgi(u,R2I(RMaxBJ(getCurrentAgi(),0.0)),true)
            if (trAgiChange!=null)then
                set ethis=this
                call TriggerEvaluate(trAgiChange)
            endif
        endmethod
        method setBaseAgi takes real value returns nothing
            if (baseAgi!=value)then
                set baseAgi=value
                call syncAgiRate()
            endif
        endmethod
        method addBaseAgi takes real value returns nothing
            if (value!=0)then
                set baseAgi=baseAgi+value
                call syncAgiRate()
            endif
        endmethod
        method addAgiFixedBonus takes real value returns nothing
            if (value!=0)then
                set AgiFixedBonus=AgiFixedBonus+value
                call syncAgiRate()
            endif
        endmethod
        method addAgiRateUp takes real value returns nothing
            if (value!=0)then
                set AgiRateUp=AgiRateUp+value
                call syncAgiRate()
            endif
        endmethod
        method addAgiRateDown takes real value returns nothing
            if (value!=0)then
                set AgiRateDown=RealAdd(AgiRateDown,value)
                call syncAgiRate()
            endif
        endmethod
        static method onAgiChange takes code func returns nothing
            if (trAgiChange==null)then
                set trAgiChange=CreateTrigger()
            endif
            call TriggerAddCondition(trAgiChange,Condition(func))
        endmethod
        real baseInt
        real IntRateUp
        real IntRateDown
        real IntRateBonus
        real IntFixedBonus
        static trigger trIntChange=null
        method getBaseInt takes nothing returns real
            if (mainAttrType==MAIN_ATTR_INT)then
                return baseInt+mainAttrBase
            else
                return baseInt+subAttrBase
            endif
        endmethod
        method getExtraInt takes nothing returns real
            if (mainAttrType==MAIN_ATTR_INT)then
                return IntRateBonus+IntFixedBonus+mainAttrFixedBonus
            else
                return IntRateBonus+IntFixedBonus+subAttrFixedBonus
            endif
        endmethod
        method getCurrentInt takes nothing returns real
            if (mainAttrType==MAIN_ATTR_INT)then
                return baseInt+mainAttrBase+IntRateBonus+IntFixedBonus+mainAttrFixedBonus
            else
                return baseInt+subAttrBase+IntRateBonus+IntFixedBonus+subAttrFixedBonus
            endif
        endmethod
        method getCurrentIntRate takes nothing returns real
            if (mainAttrType==MAIN_ATTR_INT)then
                return (1.0+IntRateUp+mainAttrRateUp)*(1.0-IntRateDown)*(1.0-mainAttrRateDown)-1.0
            else
                return (1.0+IntRateUp+subAttrRateUp)*(1.0-IntRateDown)*(1.0-subAttrRateDown)-1.0
            endif
        endmethod
        private method syncIntRate takes nothing returns nothing
            set IntRateBonus=getBaseInt()*getCurrentIntRate()
            call SetHeroInt(u,R2I(RMaxBJ(getCurrentInt(),0.0)),true)
            if (trIntChange!=null)then
                set ethis=this
                call TriggerEvaluate(trIntChange)
            endif
        endmethod
        method setBaseInt takes real value returns nothing
            if (baseInt!=value)then
                set baseInt=value
                call syncIntRate()
            endif
        endmethod
        method addBaseInt takes real value returns nothing
            if (value!=0)then
                set baseInt=baseInt+value
                call syncIntRate()
            endif
        endmethod
        method addIntFixedBonus takes real value returns nothing
            if (value!=0)then
                set IntFixedBonus=IntFixedBonus+value
                call syncIntRate()
            endif
        endmethod
        method addIntRateUp takes real value returns nothing
            if (value!=0)then
                set IntRateUp=IntRateUp+value
                call syncIntRate()
            endif
        endmethod
        method addIntRateDown takes real value returns nothing
            if (value!=0)then
                set IntRateDown=RealAdd(IntRateDown,value)
                call syncIntRate()
            endif
        endmethod
        static method onIntChange takes code func returns nothing
            if (trIntChange==null)then
                set trIntChange=CreateTrigger()
            endif
            call TriggerAddCondition(trIntChange,Condition(func))
        endmethod
        static method parse takes unit u,integer mainAttrType returns thistype
            local thistype this
            local integer handleId=GetHandleId(u)  // 先检查是否已存在
            if (HaveSavedInteger(HASH_UNIT,handleId,1727))then
                return LoadInteger(HASH_UNIT,handleId,1727)
            elseif (not (IsHeroUnitId(GetUnitTypeId(u))))then  // 如果不是英雄单位就不给创建
                return 0
            endif  // 不存在才创建新的
            set this=allocate()
            set this.u=u
            set this.mainAttrType=mainAttrType
            set this.mainAttrBase=0.0
            set this.mainAttrRateUp=0.0
            set this.mainAttrRateDown=0.0
            set this.mainAttrFixedBonus=0.0
            set this.subAttrBase=0.0
            set this.subAttrRateUp=0.0
            set this.subAttrRateDown=0.0
            set this.subAttrFixedBonus=0.0
            set this.baseStr=0.0
            set this.StrRateUp=0.0
            set this.StrRateDown=0.0
            set this.StrRateBonus=0.0
            set this.StrFixedBonus=0.0
            set this.baseAgi=0.0
            set this.AgiRateUp=0.0
            set this.AgiRateDown=0.0
            set this.AgiRateBonus=0.0
            set this.AgiFixedBonus=0.0
            set this.baseInt=0.0
            set this.IntRateUp=0.0
            set this.IntRateDown=0.0
            set this.IntRateBonus=0.0
            set this.IntFixedBonus=0.0
            call SaveInteger(HASH_UNIT,handleId,1727,this)
            return this
        endmethod  //仅获取已创建的,不创建新的
        static method get takes unit u returns thistype
            if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),1727))then
                return LoadInteger(HASH_UNIT,GetHandleId(u),1727)
            endif
            return 0
        endmethod
        method addMainAttrBase takes real value returns nothing
            if (value!=0)then
                set mainAttrBase=mainAttrBase+value  // 根据主属性类型同步相应属性
                if (mainAttrType==MAIN_ATTR_STR)then
                    call syncStrRate()
                elseif (mainAttrType==MAIN_ATTR_AGI)then
                    call syncAgiRate()
                elseif (mainAttrType==MAIN_ATTR_INT)then
                    call syncIntRate()
                endif
            endif
        endmethod
        method addSubAttrBase takes real value returns nothing
            if (value!=0)then
                set subAttrBase=subAttrBase+value  // 根据主属性类型同步次属性
                if (mainAttrType==MAIN_ATTR_STR)then
                    call syncAgiRate()
                    call syncIntRate()
                elseif (mainAttrType==MAIN_ATTR_AGI)then
                    call syncStrRate()
                    call syncIntRate()
                elseif (mainAttrType==MAIN_ATTR_INT)then
                    call syncStrRate()
                    call syncAgiRate()
                endif
            endif
        endmethod
        method switchMainAttr takes integer newMainAttrType returns nothing
            local boolean isStr=mainAttrType==MAIN_ATTR_STR or newMainAttrType==MAIN_ATTR_STR
            local boolean isAgi=mainAttrType==MAIN_ATTR_AGI or newMainAttrType==MAIN_ATTR_AGI
            local boolean isInt=mainAttrType==MAIN_ATTR_INT or newMainAttrType==MAIN_ATTR_INT
            if (mainAttrType!=newMainAttrType)then  // 切换主属性类型
                set mainAttrType=newMainAttrType  // 同步三种属性
                if (isStr)then
                    call syncStrRate()
                endif
                if (isAgi)then
                    call syncAgiRate()
                endif
                if (isInt)then
                    call syncIntRate()
                endif
            endif
        endmethod  // 添加主属性相关方法
        method addMainAttrRateUp takes real value returns nothing
            if (value!=0)then
                set mainAttrRateUp=mainAttrRateUp+value
                if (mainAttrType==MAIN_ATTR_STR)then
                    call syncStrRate()
                elseif (mainAttrType==MAIN_ATTR_AGI)then
                    call syncAgiRate()
                elseif (mainAttrType==MAIN_ATTR_INT)then
                    call syncIntRate()
                endif
            endif
        endmethod
        method addMainAttrRateDown takes real value returns nothing
            if (value!=0)then
                set mainAttrRateDown=RealAdd(mainAttrRateDown,value)
                if (mainAttrType==MAIN_ATTR_STR)then
                    call syncStrRate()
                elseif (mainAttrType==MAIN_ATTR_AGI)then
                    call syncAgiRate()
                elseif (mainAttrType==MAIN_ATTR_INT)then
                    call syncIntRate()
                endif
            endif
        endmethod
        method addMainAttrFixedBonus takes real value returns nothing
            if (value!=0)then
                set mainAttrFixedBonus=mainAttrFixedBonus+value
                if (mainAttrType==MAIN_ATTR_STR)then
                    call syncStrRate()
                elseif (mainAttrType==MAIN_ATTR_AGI)then
                    call syncAgiRate()
                elseif (mainAttrType==MAIN_ATTR_INT)then
                    call syncIntRate()
                endif
            endif
        endmethod  // 添加次属性相关方法
        method addSubAttrRateUp takes real value returns nothing
            if (value!=0)then
                set subAttrRateUp=subAttrRateUp+value
                if (mainAttrType==MAIN_ATTR_STR)then
                    call syncAgiRate()
                    call syncIntRate()
                elseif (mainAttrType==MAIN_ATTR_AGI)then
                    call syncStrRate()
                    call syncIntRate()
                elseif (mainAttrType==MAIN_ATTR_INT)then
                    call syncStrRate()
                    call syncAgiRate()
                endif
            endif
        endmethod
        method addSubAttrRateDown takes real value returns nothing
            if (value!=0)then
                set subAttrRateDown=RealAdd(subAttrRateDown,value)
                if (mainAttrType==MAIN_ATTR_STR)then
                    call syncAgiRate()
                    call syncIntRate()
                elseif (mainAttrType==MAIN_ATTR_AGI)then
                    call syncStrRate()
                    call syncIntRate()
                elseif (mainAttrType==MAIN_ATTR_INT)then
                    call syncStrRate()
                    call syncAgiRate()
                endif
            endif
        endmethod
        method addSubAttrFixedBonus takes real value returns nothing
            if (value!=0)then
                set subAttrFixedBonus=subAttrFixedBonus+value
                if (mainAttrType==MAIN_ATTR_STR)then
                    call syncAgiRate()
                    call syncIntRate()
                elseif (mainAttrType==MAIN_ATTR_AGI)then
                    call syncStrRate()
                    call syncIntRate()
                elseif (mainAttrType==MAIN_ATTR_INT)then
                    call syncStrRate()
                    call syncAgiRate()
                endif
            endif
        endmethod  //单位删除会调用
        method onDestroy takes nothing returns nothing
            if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),1727))then
                call RemoveSavedInteger(HASH_UNIT,GetHandleId(u),1727)
            endif
            set u=null
        endmethod  //注册到周期结束中
            private static method anon__0 takes nothing returns nothing
                local unit u=unitLifeCycle.argsUnit
                local thistype this=unitAttr.parse(u)
                if (this.isExist())then
                    call this.destroy()
                endif
                set u=null
            endmethod
        static method onInit takes nothing returns nothing
            call unitLifeCycle.registerDestroy(function thistype.anon__0)
        endmethod
    endstruct

//library HeroAttr ends
//library UTHeroAttr:

    function UTHeroAttr___CreateTestHeroes takes player p returns nothing
        if (UTHeroAttr___testHeroStr!=null)then
            call RemoveUnit(UTHeroAttr___testHeroStr)
        endif
        if (UTHeroAttr___testHeroAgi!=null)then
            call RemoveUnit(UTHeroAttr___testHeroAgi)
        endif  // 创建一个力量型英雄和一个敏捷型英雄
        set UTHeroAttr___testHeroStr=CreateUnit(p,'Hmkg',0,0,0)  // 山丘之王 // 恶魔猎手
        set UTHeroAttr___testHeroAgi=CreateUnit(p,'Edem',200,0,0)  // 初始化属性系统
        set UTHeroAttr___attrStr=heroAttr.parse(UTHeroAttr___testHeroStr,MAIN_ATTR_STR)
        set UTHeroAttr___attrAgi=heroAttr.parse(UTHeroAttr___testHeroAgi,MAIN_ATTR_AGI)  // 设置基础属性值方便测试
        call UTHeroAttr___attrStr.setBaseStr(100)
        call UTHeroAttr___attrAgi.setBaseStr(80)
        call SelectUnit(UTHeroAttr___testHeroStr,true)
    endfunction
        function UTHeroAttr___anon__0 takes nothing returns nothing  // 监听Str变化
            local heroAttr ha=heroAttr.ethis  // BJDebugMsg("[单位]: " + GetUnitName(ha.u) + " [Str]: " + R2S(ha.getCurrentStr()));
        endfunction  // 创建测试英雄
        function UTHeroAttr___anon__1 takes nothing returns nothing  //Trace // 测试1：基础力量属性测试
            call assert.Real(UTHeroAttr___attrStr.getCurrentStr(),100.0,"力量英雄初始Str应为100")
            call assert.Real(UTHeroAttr___attrAgi.getCurrentStr(),80.0,"敏捷英雄初始Str应为80")
        endfunction  // 测试2：主属性增幅测试
        function UTHeroAttr___anon__2 takes nothing returns nothing  // 给力量英雄加50%主属性增幅
            call UTHeroAttr___attrStr.addMainAttrRateUp(0.5)
            call assert.Real(UTHeroAttr___attrStr.getCurrentStr(),150.0,"力量英雄50%主属性增幅后Str应为150")  // 给敏捷英雄加50%主属性增幅(不应影响力量)
            call UTHeroAttr___attrAgi.addMainAttrRateUp(0.5)
            call assert.Real(UTHeroAttr___attrAgi.getCurrentStr(),80.0,"敏捷英雄主属性增幅不应影响Str")
        endfunction  // 测试3：次属性增幅测试
        function UTHeroAttr___anon__3 takes nothing returns nothing  // 重置测试英雄
            call UTHeroAttr___CreateTestHeroes(Player(0))  // 给力量英雄加30%次属性增幅
            call UTHeroAttr___attrStr.addSubAttrRateUp(0.3)
            call assert.Real(UTHeroAttr___attrStr.getCurrentStr(),100.0,"力量英雄次属性增幅不应影响Str")  // 给敏捷英雄加30%次属性增幅(应影响力量)
            call UTHeroAttr___attrAgi.addSubAttrRateUp(0.3)
            call assert.Real(UTHeroAttr___attrAgi.getCurrentStr(),104.0,"敏捷英雄30%次属性增幅后Str应为104")
        endfunction  // 测试4：属性固定加成测试
        function UTHeroAttr___anon__4 takes nothing returns nothing
            call UTHeroAttr___CreateTestHeroes(Player(0))  // 测试主属性固定加成
            call UTHeroAttr___attrStr.addMainAttrFixedBonus(50.0)
            call assert.Real(UTHeroAttr___attrStr.getCurrentStr(),150.0,"力量英雄加50点主属性固定加成后Str应为150")  // 测试次属性固定加成
            call UTHeroAttr___attrAgi.addSubAttrFixedBonus(30.0)
            call assert.Real(UTHeroAttr___attrAgi.getCurrentStr(),110.0,"敏捷英雄加30点次属性固定加成后Str应为110")
        endfunction  // 测试5：力量属性各种增减幅组合测试
        function UTHeroAttr___anon__5 takes nothing returns nothing
            call UTHeroAttr___CreateTestHeroes(Player(0))  // 设置基础力量为100
            call UTHeroAttr___attrStr.setBaseStr(100)  // 添加力量增减幅
            call UTHeroAttr___attrStr.addStrRateUp(0.3)  // +30% // -10%
            call UTHeroAttr___attrStr.addStrRateDown(0.1)  // 添加主属性增减幅
            call UTHeroAttr___attrStr.addMainAttrRateUp(0.2)  // +20% // -5%
            call UTHeroAttr___attrStr.addMainAttrRateDown(0.05)  // 计算期望值：
            call assert.Real(UTHeroAttr___attrStr.getCurrentStr(),128.25,"力量英雄复杂增减幅组合测试1")  // 基础值: 100 // 所有增幅相加: (1 + 0.3 + 0.2) = 1.5 // 所有减幅相乘: (1 - 0.1) * (1 - 0.05) = 0.9 * 0.95 = 0.855 // 最终计算: 100 * 1.5 * 0.855 = 128.25 // 添加固定加成
            call UTHeroAttr___attrStr.addStrFixedBonus(50)
            call UTHeroAttr___attrStr.addMainAttrFixedBonus(30)  // 最终结果应为: 128.25 + 50 + 30 = 208.25
            call assert.Real(UTHeroAttr___attrStr.getCurrentStr(),208.25,"力量英雄复杂增减幅组合测试2")
        endfunction  // 测试6：次属性对力量的影响组合测试
        function UTHeroAttr___anon__6 takes nothing returns nothing
            call UTHeroAttr___CreateTestHeroes(Player(0))  // 设置基础属性
            call UTHeroAttr___attrAgi.setBaseStr(100)  // 添加力量相关增减幅
            call UTHeroAttr___attrAgi.addStrRateUp(0.2)  // +20% // -10%
            call UTHeroAttr___attrAgi.addStrRateDown(0.1)  // 添加次属性增减幅
            call UTHeroAttr___attrAgi.addSubAttrRateUp(0.3)  // +30% // -15%
            call UTHeroAttr___attrAgi.addSubAttrRateDown(0.15)  // 计算期望值：
            call assert.Real(UTHeroAttr___attrAgi.getCurrentStr(),114.75,"敏捷英雄力量复杂增减幅组合测试1")  // 基础值: 100 // 所有增幅相加: (1 + 0.2 + 0.3) = 1.5 // 所有减幅相乘: (1 - 0.1) * (1 - 0.15) = 0.9 * 0.85 = 0.765 // 最终计算: 100 * 1.5 * 0.765 = 114.75 // 添加固定加成
            call UTHeroAttr___attrAgi.addStrFixedBonus(40)
            call UTHeroAttr___attrAgi.addSubAttrFixedBonus(20)  // 最终结果应为: 114.75 + 40 + 20 = 174.75
            call assert.Real(UTHeroAttr___attrAgi.getCurrentStr(),174.75,"敏捷英雄力量复杂增减幅组合测试2")
        endfunction  // 测试7：极限值测试
        function UTHeroAttr___anon__7 takes nothing returns nothing
            call UTHeroAttr___CreateTestHeroes(Player(0))  // 设置一个较大的基础值
            call UTHeroAttr___attrStr.setBaseStr(1000)  // 添加多个大幅度的增减幅
            call UTHeroAttr___attrStr.addStrRateUp(2.0)  // +200% // +150%
            call UTHeroAttr___attrStr.addMainAttrRateUp(1.5)  // -40%
            call UTHeroAttr___attrStr.addStrRateDown(0.4)  // -30%
            call UTHeroAttr___attrStr.addMainAttrRateDown(0.3)  // 添加大量固定加成
            call UTHeroAttr___attrStr.addStrFixedBonus(500)
            call UTHeroAttr___attrStr.addMainAttrFixedBonus(300)  // 计算期望值：
            call assert.Real(UTHeroAttr___attrStr.getCurrentStr(),2690.0,"力量英雄极限值测试")  // 基础值: 1000 // 所有增幅相加: (1 + 2.0 + 1.5) = 4.5 // 所有减幅相乘: (1 - 0.4) * (1 - 0.3) = 0.6 * 0.7 = 0.42 // 属性计算: 1000 * 4.5 * 0.42 = 1890 // 加上固定加成: 1890 + 500 + 300 = 2690
        endfunction  // 测试8：主属性基础值测试
        function UTHeroAttr___anon__8 takes nothing returns nothing
            call UTHeroAttr___CreateTestHeroes(Player(0))  // 测试力量英雄的主属性基础值
            call UTHeroAttr___attrStr.addMainAttrBase(50)
            call assert.Real(UTHeroAttr___attrStr.getBaseStr(),150.0,"力量英雄加50主属性基础值后白字应为150")
            call assert.Real(UTHeroAttr___attrStr.getCurrentStr(),150.0,"力量英雄加50主属性基础值后总值应为150")  // 测试敏捷英雄的主属性基础值(不应影响力量)
            call UTHeroAttr___attrAgi.addMainAttrBase(50)
            call assert.Real(UTHeroAttr___attrAgi.getBaseStr(),80.0,"敏捷英雄加50主属性基础值后力量白字应为80")
            call assert.Real(UTHeroAttr___attrAgi.getCurrentStr(),80.0,"敏捷英雄加50主属性基础值后力量总值应为80")
        endfunction  // 测试9：次属性基础值测试
        function UTHeroAttr___anon__9 takes nothing returns nothing
            call UTHeroAttr___CreateTestHeroes(Player(0))  // 测试力量英雄的次属性基础值(不应影响力量)
            call UTHeroAttr___attrStr.addSubAttrBase(30)
            call assert.Real(UTHeroAttr___attrStr.getBaseStr(),100.0,"力量英雄加30次属性基础值后力量白字应为100")
            call assert.Real(UTHeroAttr___attrStr.getCurrentStr(),100.0,"力量英雄加30次属性基础值后力量总值应为100")  // 测试敏捷英雄的次属性基础值(应影响力量)
            call UTHeroAttr___attrAgi.addSubAttrBase(30)
            call assert.Real(UTHeroAttr___attrAgi.getBaseStr(),110.0,"敏捷英雄加30次属性基础值后力量白字应为110")
            call assert.Real(UTHeroAttr___attrAgi.getCurrentStr(),110.0,"敏捷英雄加30次属性基础值后力量总值应为110")
        endfunction  // 测试10：主属性和次属性基础值组合测试
        function UTHeroAttr___anon__10 takes nothing returns nothing
            call UTHeroAttr___CreateTestHeroes(Player(0))  // 设置基础属性和增减幅
            call UTHeroAttr___attrAgi.setBaseStr(100)  // +50%
            call UTHeroAttr___attrAgi.addStrRateUp(0.5)  // +30%
            call UTHeroAttr___attrAgi.addSubAttrRateUp(0.3)  // 添加主属性和次属性基础值
            call UTHeroAttr___attrAgi.addMainAttrBase(20)  // 不影响力量 // 影响力量
            call UTHeroAttr___attrAgi.addSubAttrBase(50)  //固定影响
            call UTHeroAttr___attrAgi.addSubAttrBouns(25)  // 计算期望值：
            call assert.Real(UTHeroAttr___attrAgi.getBaseStr(),150.0,"敏捷英雄复杂组合后力量白字应为150")  // 增幅: (100+50) * (1 + 0.5 + 0.3) + 25 = 295
            call assert.Real(UTHeroAttr___attrAgi.getCurrentStr(),295.0,"敏捷英雄复杂组合后力量总值应为295")
        endfunction  // 测试11：多重增幅叠加测试
        function UTHeroAttr___anon__11 takes nothing returns nothing
            call UTHeroAttr___CreateTestHeroes(Player(0))  // 设置基础属性
            call UTHeroAttr___attrStr.setBaseStr(100)  // 添加多次力量增幅
            call UTHeroAttr___attrStr.addStrRateUp(0.2)  // +20% // +30%
            call UTHeroAttr___attrStr.addStrRateUp(0.3)  // +15%
            call UTHeroAttr___attrStr.addStrRateUp(0.15)  // 添加多次主属性增幅
            call UTHeroAttr___attrStr.addMainAttrRateUp(0.25)  // +25% // +35%
            call UTHeroAttr___attrStr.addMainAttrRateUp(0.35)  // 添加多次次属性增幅
            call UTHeroAttr___attrStr.addSubAttrRateUp(0.1)  // +10% // +20%
            call UTHeroAttr___attrStr.addSubAttrRateUp(0.2)  // 计算期望值：
            call assert.Real(UTHeroAttr___attrStr.getCurrentStr(),225.0,"力量英雄多重增幅叠加测试1")  // 基础值: 100 // 力量增幅总和: 0.2 + 0.3 + 0.15 = 0.65 // 主属性增幅总和: 0.25 + 0.35 = 0.6 // 次属性增幅总和: 0.1 + 0.2 = 0.3 // 所有增幅相加: (1 + 0.65 + 0.6) = 2.25 // 最终计算: 100 * 2.25 = 225 // 再添加一些减幅测试
            call UTHeroAttr___attrStr.addStrRateDown(0.2)  // -20% // -10%
            call UTHeroAttr___attrStr.addMainAttrRateDown(0.1)  // 计算最终期望值：
            call assert.Real(UTHeroAttr___attrStr.getCurrentStr(),162,"力量英雄多重增幅叠加测试2")  // 之前结果: 225 // 减幅相乘: (1 - 0.2) * (1 - 0.1) = 0.8 * 0.9 = 0.72 // 最终计算: 225 * 0.72 = 162 // 测试敏捷英雄的多重增幅叠加
            call UTHeroAttr___attrAgi.setBaseStr(100)  // 添加多次各类增幅
            call UTHeroAttr___attrAgi.addStrRateUp(0.25)  // +25% // +35%
            call UTHeroAttr___attrAgi.addStrRateUp(0.35)  // +20%
            call UTHeroAttr___attrAgi.addSubAttrRateUp(0.2)  // +30%
            call UTHeroAttr___attrAgi.addSubAttrRateUp(0.3)  // +40% (不影响力量)
            call UTHeroAttr___attrAgi.addMainAttrRateUp(0.4)  // 计算期望值：
            call assert.Real(UTHeroAttr___attrAgi.getCurrentStr(),210.0,"敏捷英雄多重增幅叠加测试1")  // 基础值: 100 // 力量增幅总和: 0.25 + 0.35 = 0.6 // 次属性增幅总和: 0.2 + 0.3 = 0.5 // 所有增幅相加: (1 + 0.6 + 0.5) = 2.1 // 最终计算: 100 * 2.1 = 210 // 添加减幅
            call UTHeroAttr___attrAgi.addStrRateDown(0.15)  // -15% // -25%
            call UTHeroAttr___attrAgi.addSubAttrRateDown(0.25)  // 计算最终期望值：
            call assert.Real(UTHeroAttr___attrAgi.getCurrentStr(),133.875,"敏捷英雄多重增幅叠加测试2")  // 之前结果: 210 // 减幅相乘: (1 - 0.15) * (1 - 0.25) = 0.85 * 0.75 = 0.6375 // 最终计算: 210 * 0.6375 = 133.875
        endfunction  // 测试12：主属性切换测试
        function UTHeroAttr___anon__12 takes nothing returns nothing
            call UTHeroAttr___CreateTestHeroes(Player(0))  // 设置初始状态
            call UTHeroAttr___attrStr.setBaseStr(100)  // 主属性基础值+50
            call UTHeroAttr___attrStr.addMainAttrBase(50)  // 次属性基础值+30
            call UTHeroAttr___attrStr.addSubAttrBase(30)  // 主属性增幅+50%
            call UTHeroAttr___attrStr.addMainAttrRateUp(0.5)  // 次属性增幅+30%
            call UTHeroAttr___attrStr.addSubAttrRateUp(0.3)  // 验证初始状态
            call assert.Real(UTHeroAttr___attrStr.getBaseStr(),150.0,"力量英雄切换前力量白字应为150")  // 150 * (1 + 0.5) = 225
            call assert.Real(UTHeroAttr___attrStr.getCurrentStr(),225.0,"力量英雄切换前力量总值应为225")  // 切换到敏捷主属性
            call UTHeroAttr___attrStr.switchMainAttr(MAIN_ATTR_AGI)  // 验证切换后状态
            call assert.Real(UTHeroAttr___attrStr.getBaseStr(),130.0,"力量英雄切换后力量白字应为130")  // 原主属性值变为次属性值,原次属性值变为主属性值 // 100 + 30(原次属性基础值) // 130 * (1 + 0.3) = 169
            call assert.Real(UTHeroAttr___attrStr.getCurrentStr(),169.0,"力量英雄切换后力量总值应为169")  // 切换回力量主属性
            call UTHeroAttr___attrStr.switchMainAttr(MAIN_ATTR_STR)  // 验证恢复状态
            call assert.Real(UTHeroAttr___attrStr.getBaseStr(),150.0,"力量英雄恢复后力量白字应为150")
            call assert.Real(UTHeroAttr___attrStr.getCurrentStr(),225.0,"力量英雄恢复后力量总值应为225")
        endfunction  // 测试13：主属性或次属性能否吃到%加成
        function UTHeroAttr___anon__13 takes nothing returns nothing
            call UTHeroAttr___CreateTestHeroes(Player(0))  // 设置初始状态
            call UTHeroAttr___attrStr.setBaseStr(100)  // 主属性基础值+50
            call UTHeroAttr___attrStr.addMainAttrBase(200)  // 主属性增幅+50%
            call UTHeroAttr___attrStr.addMainAttrRateUp(0.5)
            call UTHeroAttr___attrStr.addStrRateUp(0.5)  // 验证初始状态
            call assert.Real(UTHeroAttr___attrStr.getBaseStr(),300.0,"力量英雄双重白字应为300")  // 300 * (1 + 0.5 + 0.5) = 600
            call assert.Real(UTHeroAttr___attrStr.getCurrentStr(),600.0,"力量英雄双重总值应为600")
        endfunction
    function UTHeroAttr___Init takes nothing returns nothing
        local player p=Player(0)
        call BJDebugMsg("=== HeroAttr测试系统已加载 ===")
        call heroAttr.onStrChange(function UTHeroAttr___anon__0)
        call UTHeroAttr___CreateTestHeroes(p)
        call UnitTestAutoTimer(0.1,0,function UTHeroAttr___anon__1,null)
        call UnitTestAutoTimer(0.6,0,function UTHeroAttr___anon__2,null)
        call UnitTestAutoTimer(1.1,0,function UTHeroAttr___anon__3,null)
        call UnitTestAutoTimer(1.6,0,function UTHeroAttr___anon__4,null)
        call UnitTestAutoTimer(2.1,0,function UTHeroAttr___anon__5,null)
        call UnitTestAutoTimer(2.6,0,function UTHeroAttr___anon__6,null)
        call UnitTestAutoTimer(3.1,0,function UTHeroAttr___anon__7,null)
        call UnitTestAutoTimer(3.6,0,function UTHeroAttr___anon__8,null)
        call UnitTestAutoTimer(4.1,0,function UTHeroAttr___anon__9,null)
        call UnitTestAutoTimer(4.6,0,function UTHeroAttr___anon__10,null)
        call UnitTestAutoTimer(5.1,0,function UTHeroAttr___anon__11,null)
        call UnitTestAutoTimer(5.6,0,function UTHeroAttr___anon__12,null)
        call UnitTestAutoTimer(5.6,0,function UTHeroAttr___anon__13,null)
        set p=null
    endfunction  // 处理测试命令
    function UTHeroAttr___TTestActUTHeroAttr1 takes string str returns nothing
        local player p=GetTriggerPlayer()
        local integer index=GetConvertedPlayerId(p)
        local integer i
        local integer num=0
        local integer len=StringLength(str)
        local string  array paramS
        local integer  array paramI
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
        set num=num+1
        if (UTHeroAttr___testHeroStr==null)then
            call UTHeroAttr___CreateTestHeroes(p)
        endif  // 新建测试单位命令
        if (paramS[0]=="new")then
            call UTHeroAttr___CreateTestHeroes(p)
            call BJDebugMsg("已重新创建测试英雄")
        elseif (paramS[0]=="str")then  // 力量相关命令
            call UTHeroAttr___attrStr.setBaseStr(paramR[1])
            call UTHeroAttr___attrAgi.setBaseStr(paramR[1])
            call BJDebugMsg("设置力量英雄基础力量为: "+R2S(paramR[1]))
        elseif (paramS[0]=="addstr")then
            call UTHeroAttr___attrStr.addBaseStr(paramR[1])
            call UTHeroAttr___attrAgi.addBaseStr(paramR[1])
            call BJDebugMsg("增加力量英雄基础力量: "+R2S(paramR[1]))
        elseif (paramS[0]=="strup")then
            call UTHeroAttr___attrStr.addStrRateUp(paramR[1])
            call UTHeroAttr___attrAgi.addStrRateUp(paramR[1])
            call BJDebugMsg("设置力量英雄力量增幅为: "+R2S(paramR[1]))
        elseif (paramS[0]=="strdown")then
            call UTHeroAttr___attrStr.addStrRateDown(paramR[1])
            call UTHeroAttr___attrAgi.addStrRateDown(paramR[1])
            call BJDebugMsg("设置力量英雄力量减幅为: "+R2S(paramR[1]))
        elseif (paramS[0]=="strbonus")then
            call UTHeroAttr___attrStr.addStrFixedBonus(paramR[1])
            call UTHeroAttr___attrAgi.addStrFixedBonus(paramR[1])
            call BJDebugMsg("设置力量英雄力量固定加成为: "+R2S(paramR[1]))
        elseif (paramS[0]=="addstrbonus")then
            call UTHeroAttr___attrStr.addStrFixedBonus(paramR[1])
            call UTHeroAttr___attrAgi.addStrFixedBonus(paramR[1])
            call BJDebugMsg("增加力量英雄力量固定加成: "+R2S(paramR[1]))
        elseif (paramS[0]=="mainup")then  // 主属性相关命令
            call UTHeroAttr___attrStr.addMainAttrRateUp(paramR[1])
            call UTHeroAttr___attrAgi.addMainAttrRateUp(paramR[1])
            call BJDebugMsg("设置力量英雄主属性增幅为: "+R2S(paramR[1]))
        elseif (paramS[0]=="maindown")then
            call UTHeroAttr___attrStr.addMainAttrRateDown(paramR[1])
            call UTHeroAttr___attrAgi.addMainAttrRateDown(paramR[1])
            call BJDebugMsg("设置力量英雄主属性减幅为: "+R2S(paramR[1]))
        elseif (paramS[0]=="mainbonus")then
            call UTHeroAttr___attrStr.addMainAttrFixedBonus(paramR[1])
            call UTHeroAttr___attrAgi.addMainAttrFixedBonus(paramR[1])
            call BJDebugMsg("设置力量英雄主属性固定加成为: "+R2S(paramR[1]))
        elseif (paramS[0]=="subup")then  // 次属性相关命令
            call UTHeroAttr___attrStr.addSubAttrRateUp(paramR[1])
            call UTHeroAttr___attrAgi.addSubAttrRateUp(paramR[1])
            call BJDebugMsg("设置力量英雄次属性增幅为: "+R2S(paramR[1]))
        elseif (paramS[0]=="subdown")then
            call UTHeroAttr___attrStr.addSubAttrRateDown(paramR[1])
            call UTHeroAttr___attrAgi.addSubAttrRateDown(paramR[1])
            call BJDebugMsg("设置力量英雄次属性减幅为: "+R2S(paramR[1]))
        elseif (paramS[0]=="subbonus")then
            call UTHeroAttr___attrStr.addSubAttrFixedBonus(paramR[1])
            call UTHeroAttr___attrAgi.addSubAttrFixedBonus(paramR[1])
            call BJDebugMsg("设置力量英雄次属性固定加成为: "+R2S(paramR[1]))
        elseif (paramS[0]=="mainadd")then  // 主属性基础值相关命令
            call UTHeroAttr___attrStr.addMainAttrBase(paramR[1])
            call UTHeroAttr___attrAgi.addMainAttrBase(paramR[1])
            call BJDebugMsg("增加力量英雄主属性基础值: "+R2S(paramR[1]))
        elseif (paramS[0]=="subadd")then  // 次属性基础值相关命令
            call UTHeroAttr___attrStr.addSubAttrBase(paramR[1])
            call UTHeroAttr___attrAgi.addSubAttrBase(paramR[1])
            call BJDebugMsg("增加力量英雄次属性基础值: "+R2S(paramR[1]))
        elseif (paramS[0]=="switch")then  // 切换主属性命令
            if (paramI[1]>=0 and paramI[1]<=2)then
                call UTHeroAttr___attrStr.switchMainAttr(paramI[1])
                call UTHeroAttr___attrAgi.switchMainAttr(paramI[1])
                call BJDebugMsg("切换主属性类型为: "+I2S(paramI[1]))
            else
                call BJDebugMsg("无效的主属性类型,请使用0(力量),1(敏捷),2(智力)")
            endif
        endif  // 显示当前状态
        call BJDebugMsg("力量英雄当前力量: "+R2S(UTHeroAttr___attrStr.getCurrentStr()))
        call BJDebugMsg("力量英雄当前力量白字: "+R2S(UTHeroAttr___attrStr.getBaseStr()))
        call BJDebugMsg("力量英雄当前力量绿字: "+R2S(UTHeroAttr___attrStr.getExtraStr()))
        call BJDebugMsg("敏捷英雄当前力量: "+R2S(UTHeroAttr___attrAgi.getCurrentStr()))
        call BJDebugMsg("敏捷英雄当前力量白字: "+R2S(UTHeroAttr___attrAgi.getBaseStr()))
        call BJDebugMsg("敏捷英雄当前力量绿字: "+R2S(UTHeroAttr___attrAgi.getExtraStr()))
        set p=null
    endfunction
        function UTHeroAttr___anon__14 takes nothing returns nothing
            call UTHeroAttr___Init()
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTHeroAttr___anon__15 takes nothing returns nothing  // 注册聊天事件
            local string str=GetEventPlayerChatString()
            if (SubString(str,(1)-1,1)=="-")then
                call UTHeroAttr___TTestActUTHeroAttr1(SubString(str,(2)-1,StringLength(str)))
                return
            endif
        endfunction
    function UTHeroAttr___onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr,0.5,false)
        call TriggerAddCondition(tr,Condition(function UTHeroAttr___anon__14))
        set tr=null
        call UnitTestRegisterChatEvent(function UTHeroAttr___anon__15)
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
// 原生UI的大小








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

hook RemoveUnit unitLifeCycle.onDestroyCB

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
call ExecuteFunc("UnitTestFramwork___onInit")
call ExecuteFunc("YDLua___onInit")
call ExecuteFunc("Logger___onInit")
call ExecuteFunc("UTHeroAttr___onInit")

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



