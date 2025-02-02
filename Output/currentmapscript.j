globals
//globals from ConversionUtils:
constant boolean LIBRARY_ConversionUtils=true
//endglobals from ConversionUtils
//globals from SLKTable:
constant boolean LIBRARY_SLKTable=true
    hashtable HASH_SLK=InitHashtable()
//endglobals from SLKTable
//globals from Spell:
constant boolean LIBRARY_Spell=true
//endglobals from Spell
//globals from SpellData:
constant boolean LIBRARY_SpellData=true
    constant integer SPELL_TYPE_ENTITY=0
    constant integer SPELL_TYPE_MIRROR=1
    constant integer SPELL_TYPE_VIRTUAL=2
    constant integer SPELL_TYPE_SIMPLE=3
//endglobals from SpellData
//globals from SpellTable:
constant boolean LIBRARY_SpellTable=true
    hashtable HASH_SPELL=InitHashtable()
//endglobals from SpellTable
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
//globals from YDWEAbilityState:
constant boolean LIBRARY_YDWEAbilityState=true
		constant integer YDWEAbilityState__ABILITY_STATE_COOLDOWN = 1
		constant integer YDWEAbilityState__ABILITY_DATA_TARGS = 100 // integer
constant integer YDWEAbilityState__ABILITY_DATA_CAST = 101 // real
constant integer YDWEAbilityState__ABILITY_DATA_DUR = 102 // real
constant integer YDWEAbilityState__ABILITY_DATA_HERODUR = 103 // real
constant integer YDWEAbilityState__ABILITY_DATA_COST = 104 // integer
constant integer YDWEAbilityState__ABILITY_DATA_COOL = 105 // real
constant integer YDWEAbilityState__ABILITY_DATA_AREA = 106 // real
constant integer YDWEAbilityState__ABILITY_DATA_RNG = 107 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_A = 108 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_B = 109 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_C = 110 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_D = 111 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_E = 112 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_F = 113 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_G = 114 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_H = 115 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_I = 116 // real
constant integer YDWEAbilityState__ABILITY_DATA_UNITID = 117 // integer
		constant integer YDWEAbilityState__ABILITY_DATA_HOTKET = 200 // integer
constant integer YDWEAbilityState__ABILITY_DATA_UNHOTKET = 201 // integer
constant integer YDWEAbilityState__ABILITY_DATA_RESEARCH_HOTKEY = 202 // integer
constant integer YDWEAbilityState__ABILITY_DATA_NAME = 203 // string
constant integer YDWEAbilityState__ABILITY_DATA_ART = 204 // string
constant integer YDWEAbilityState__ABILITY_DATA_TARGET_ART = 205 // string
constant integer YDWEAbilityState__ABILITY_DATA_CASTER_ART = 206 // string
constant integer YDWEAbilityState__ABILITY_DATA_EFFECT_ART = 207 // string
constant integer YDWEAbilityState__ABILITY_DATA_AREAEFFECT_ART = 208 // string
constant integer YDWEAbilityState__ABILITY_DATA_MISSILE_ART = 209 // string
constant integer YDWEAbilityState__ABILITY_DATA_SPECIAL_ART = 210 // string
constant integer YDWEAbilityState__ABILITY_DATA_LIGHTNING_EFFECT = 211 // string
constant integer YDWEAbilityState__ABILITY_DATA_BUFF_TIP = 212 // string
constant integer YDWEAbilityState__ABILITY_DATA_BUFF_UBERTIP = 213 // string
constant integer YDWEAbilityState__ABILITY_DATA_RESEARCH_TIP = 214 // string
constant integer YDWEAbilityState__ABILITY_DATA_TIP = 215 // string
constant integer YDWEAbilityState__ABILITY_DATA_UNTIP = 216 // string
constant integer YDWEAbilityState__ABILITY_DATA_RESEARCH_UBERTIP = 217 // string
constant integer YDWEAbilityState__ABILITY_DATA_UBERTIP = 218 // string
constant integer YDWEAbilityState__ABILITY_DATA_UNUBERTIP = 219 // string
constant integer YDWEAbilityState__ABILITY_DATA_UNART = 220 // string
//endglobals from YDWEAbilityState
//globals from UnitData:
constant boolean LIBRARY_UnitData=true
//endglobals from UnitData
//globals from UnitSpell:
constant boolean LIBRARY_UnitSpell=true
//endglobals from UnitSpell
//globals from UTUnitSpell:
constant boolean LIBRARY_UTUnitSpell=true
    unit UTUnitSpell__testUnit=null
//endglobals from UTUnitSpell
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
//library SLKTable:

//library SLKTable ends
//library Spell:
    function GetHashValue takes integer handleID,integer customId returns integer  // 使用两个大质数
        local integer prime1=131071  // 2^17-1 // 较大的质数
        local integer prime2=179424673
        return (handleID*prime1)+(customId*prime2)
    endfunction
    struct spell   // 技能拥有者
    //! pragma implicitthis
        unit u  // 技能类型(0:结构技能,1:无结构技能,2:虚拟技能,3:简单技能)
        integer spellType  // 技能ID(一致则1类,不一致则2类,为0则是3类)
        integer id  // 技能实例的对应技能数据
        spellData sd  // 技能等级
        integer level
        method isExist takes nothing returns boolean  // 实体技能(有ID)
            return (this!=null and si__spell_V[this]==-1)
        endmethod
        static method entity takes unit u,integer id,integer level returns thistype
            local thistype this
            local integer key=GetHashValue(GetHandleId(u),id)  //单位没有这个技能
            if (key==0)then
                return 0
            endif  //todo:人物拥有技能判定
            if (HaveSavedInteger(HASH_SPELL,key,15))then  // 先检查是否已存在
                return LoadInteger(HASH_SPELL,key,15)
            endif  // 不存在才创建新的
            set this=allocate()
            set this.u=u
            set this.id=id
            set this.sd=spellData.byType(id)
            set this.level=level
            set this.spellType=SPELL_TYPE_ENTITY
            call SaveInteger(HASH_SPELL,key,15,this)
            return this
        endmethod  // 镜像技能(无ID)
        static method mirror takes unit u,integer id,spellData sd,integer level returns thistype
            local thistype this
            local integer key=GetHashValue(GetHandleId(u),id)  // 先检查是否已存在
            if (HaveSavedInteger(HASH_SPELL,key,15))then
                return LoadInteger(HASH_SPELL,key,15)
            endif  // 不存在才创建新的
            set this=allocate()
            set this.u=u
            set this.id=id
            set this.spellType=SPELL_TYPE_MIRROR
            set this.sd=sd
            set this.level=level
            call SaveInteger(HASH_SPELL,key,15,this)
            return this
        endmethod  // 虚拟技能(无ID)
        static method virtual takes unit u,spellData sd,integer level returns thistype
            local thistype this  //使用sd作为哈希值
            local integer key=GetHashValue(GetHandleId(u),sd)  // 先检查是否已存在
            if (HaveSavedInteger(HASH_SPELL,key,15))then
                return LoadInteger(HASH_SPELL,key,15)
            endif  // 不存在才创建新的
            set this=allocate()
            set this.u=u
            set this.id=0
            set this.spellType=SPELL_TYPE_VIRTUAL
            set this.sd=sd
            set this.level=level
            call SaveInteger(HASH_SPELL,key,15,this)
            return this
        endmethod  //销毁
        method onDestroy takes nothing returns nothing
            if (HaveSavedInteger(HASH_SPELL,GetHashValue(GetHandleId(u),sd),15))then
                call RemoveSavedInteger(HASH_SPELL,GetHashValue(GetHandleId(u),sd),15)
            endif
            set this.u=null
            set this.id=0
            set this.sd=0
        endmethod
    endstruct

//library Spell ends
//library SpellData:
    struct spellData extends array  // 当前有几个技能数据
    //! pragma implicitthis
        static integer counter=0  // 技能ID(从那边直接获取数据)
        integer id  // 技能类型(1:结构技能,2:无结构技能,3:虚拟技能,4:简单技能)
        integer spellType  // 技能初始化事件
        trigger trInit  // 技能销毁事件
        trigger trDestroy  // 技能升级事件
        trigger trUpgrade  // 技能等级(最大等级)
        integer maxLevel  // 技能描述
        string description  // 技能图标
        string icon  //根据技能类型
        static method byType takes integer at returns thistype
            local thistype this
            if (HaveSavedInteger(HASH_SLK,at,1727))then
                set this=LoadInteger(HASH_SLK,at,1727)
            else
                set counter=counter+1
                set this=thistype[counter]
                call SaveInteger(HASH_SLK,at,1727,this)
                set id=at  //默认最大等级1级
                set maxLevel=1
            endif
            return this
        endmethod
    endstruct

//library SpellData ends
//library SpellTable:

//library SpellTable ends
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
//library YDWEAbilityState:
	native EXGetUnitAbility takes unit u, integer abilcode returns ability
	native EXGetUnitAbilityByIndex takes unit u, integer index returns ability
	native EXGetAbilityId takes ability abil returns integer
	native EXGetAbilityState takes ability abil, integer state_type returns real
	native EXSetAbilityState takes ability abil, integer state_type, real value returns boolean
	native EXGetAbilityDataReal takes ability abil, integer level, integer data_type returns real
	native EXSetAbilityDataReal takes ability abil, integer level, integer data_type, real value returns boolean
	native EXGetAbilityDataInteger takes ability abil, integer level, integer data_type returns integer
	native EXSetAbilityDataInteger takes ability abil, integer level, integer data_type, integer value returns boolean
	native EXGetAbilityDataString takes ability abil, integer level, integer data_type returns string
	native EXSetAbilityDataString takes ability abil, integer level, integer data_type, string value returns boolean
	function YDWEGetUnitAbilityState takes unit u, integer abilcode, integer state_type returns real
		return EXGetAbilityState(EXGetUnitAbility(u, abilcode), state_type)
	endfunction
	function YDWEGetUnitAbilityDataInteger takes unit u, integer abilcode, integer level, integer data_type returns integer
		return EXGetAbilityDataInteger(EXGetUnitAbility(u, abilcode), level, data_type)
	endfunction
	function YDWEGetUnitAbilityDataReal takes unit u, integer abilcode, integer level, integer data_type returns real
		return EXGetAbilityDataReal(EXGetUnitAbility(u, abilcode), level, data_type)
	endfunction
	function YDWEGetUnitAbilityDataString takes unit u, integer abilcode, integer level, integer data_type returns string
		return EXGetAbilityDataString(EXGetUnitAbility(u, abilcode), level, data_type)
	endfunction
	function YDWESetUnitAbilityState takes unit u, integer abilcode, integer state_type, real value returns boolean
		return EXSetAbilityState(EXGetUnitAbility(u, abilcode), state_type, value)
	endfunction
	function YDWESetUnitAbilityDataInteger takes unit u, integer abilcode, integer level, integer data_type, integer value returns boolean
		return EXSetAbilityDataInteger(EXGetUnitAbility(u, abilcode), level, data_type, value)
	endfunction
	function YDWESetUnitAbilityDataReal takes unit u, integer abilcode, integer level, integer data_type, real value returns boolean
		return EXSetAbilityDataReal(EXGetUnitAbility(u, abilcode), level, data_type, value)
	endfunction
	function YDWESetUnitAbilityDataString takes unit u, integer abilcode, integer level, integer data_type, string value returns boolean
		return EXSetAbilityDataString(EXGetUnitAbility(u, abilcode), level, data_type, value)
	endfunction
	native EXSetAbilityAEmeDataA takes ability abil, integer unitid returns boolean
	function YDWEUnitTransform takes unit u, integer abilcode, integer targetid returns nothing
		call UnitAddAbility(u, abilcode)
		call EXSetAbilityDataInteger(EXGetUnitAbility(u, abilcode), 1, YDWEAbilityState__ABILITY_DATA_UNITID, GetUnitTypeId(u))
		call EXSetAbilityAEmeDataA(EXGetUnitAbility(u, abilcode), GetUnitTypeId(u))
		call UnitRemoveAbility(u, abilcode)
		call UnitAddAbility(u, abilcode)
		call EXSetAbilityAEmeDataA(EXGetUnitAbility(u, abilcode), targetid)
		call UnitRemoveAbility(u, abilcode)
	endfunction
	native EXGetItemDataString takes integer itemcode, integer data_type returns string
	native EXSetItemDataString takes integer itemcode, integer data_type, string value returns boolean
	function YDWEGetItemDataString takes integer itemcode, integer data_type returns string
		return EXGetItemDataString(itemcode, data_type)
	endfunction
	function YDWESetItemDataString takes integer itemcode, integer data_type, string value returns boolean
		return EXSetItemDataString(itemcode, data_type, value)
	endfunction

//library YDWEAbilityState ends
//library UnitData:
    struct unitData extends array
    //! pragma implicitthis
        static integer counter=0  // 添加技能
        method addSpell takes spellData sd,integer level returns nothing
            local integer count=0
            if (HaveSavedInteger(HASH_SLK,this,1900))then
                set count=LoadInteger(HASH_SLK,this,1900)
            endif
            if (count>=200)then  // 超出最大数量限制
                return
            endif  // 保存技能ID
            call SaveInteger(HASH_SLK,this,2000+count,sd)  // 保存技能等级
            call SaveInteger(HASH_SLK,this,2200+count,level)  // 更新技能总数
            call SaveInteger(HASH_SLK,this,1900,count+1)
        endmethod  // 获取技能数量
        method getSpellCount takes nothing returns integer
            if (HaveSavedInteger(HASH_SLK,this,1900))then
                return LoadInteger(HASH_SLK,this,1900)
            endif
            return 0
        endmethod  // 获取指定索引的技能ID
        method getSpellId takes integer index returns spellData
            if (index>=0 and index<this.getSpellCount())then
                return LoadInteger(HASH_SLK,this,2000+index)
            endif
            return 0
        endmethod  // 获取指定索引的技能等级
        method getSpellLevel takes integer index returns integer
            if (index>=0 and index<this.getSpellCount())then
                return LoadInteger(HASH_SLK,this,2200+index)
            endif
            return 0
        endmethod  //根据单位类型
        static method byType takes integer ut returns thistype
            local thistype this
            if (HaveSavedInteger(HASH_SLK,ut,1725))then
                set this=LoadInteger(HASH_SLK,ut,1725)
            else
                set counter=counter+1
                set this=thistype[counter]
                call SaveInteger(HASH_SLK,ut,1725,this)  //初始化
                call SaveInteger(HASH_SLK,this,1900,0)
            endif
            return this
        endmethod
    endstruct

//library UnitData ends
//library UnitSpell:
    struct unitSpell 
    //! pragma implicitthis
        method isExist takes nothing returns boolean  // 所属单位
            return (this!=null and si__unitSpell_V[this]==-1)
        endmethod
        unit u  // 当前技能数量
        integer spellCount=0  // 添加技能
        method addSpell takes spell sp returns nothing  // 无效的技能
            if (sp==0)then
                return
            endif
            if (this.spellCount>=200)then
                return
            endif
            call SaveInteger(HASH_UNIT,GetHandleId(this.u),1800+this.spellCount,sp)
            set this.spellCount=this.spellCount+1
        endmethod  // 获取技能数量
        method getSpellCount takes nothing returns integer
            return this.spellCount
        endmethod  // 获取指定索引的技能
        method getSpell takes integer index returns spell
            if (index>=0 and index<this.spellCount)then
                return LoadInteger(HASH_UNIT,GetHandleId(this.u),1800+index)
            endif
            return 0
        endmethod  // 初始化默认技能(从unitData继承)
        private method initDefaultSpell takes nothing returns nothing
            local integer i=0
            local spellData sd=0
            local integer level=0
            local integer maxLevel=0
            local spell sp=0
            local unitData ud=unitData.byType(GetUnitTypeId(this.u))  // 初始化技能数量
            set this.spellCount=0  // 从unitData创建所有技能
            set i=0
            loop
            exitwhen (i>=ud.getSpellCount())
                set sd=ud.getSpellId(i)
                set level=ud.getSpellLevel(i)
                set maxLevel=sd.maxLevel
                set sp=spell.entity(this.u,sd,IMinBJ(level,IMaxBJ(maxLevel,1)))
                if (sp!=0)then
                    call SaveInteger(HASH_UNIT,GetHandleId(this.u),1800+this.spellCount,sp)
                    set this.spellCount=this.spellCount+1
                endif
            set i = i+1
            endloop
        endmethod  // 构造函数
        static method parse takes unit u returns thistype
            local thistype this
            local integer handleId=GetHandleId(u)  // 先检查是否已存在
            if (HaveSavedInteger(HASH_UNIT,handleId,1730))then
                return LoadInteger(HASH_UNIT,handleId,1730)
            endif  // 不存在才创建新的
            set this=thistype.allocate()
            set this.u=u  // 默认初始化技能
            call this.initDefaultSpell()
            call SaveInteger(HASH_UNIT,handleId,1730,this)
            return this
        endmethod  // 获取已存在的实例
        static method get takes unit u returns thistype
            if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),1730))then
                return LoadInteger(HASH_UNIT,GetHandleId(u),1730)
            endif
            return 0
        endmethod
        method onDestroy takes nothing returns nothing
            local integer i=0  // 清理所有技能引用
            set i=0
            loop
            exitwhen (i>=this.spellCount)
                call RemoveSavedInteger(HASH_UNIT,GetHandleId(this.u),1800+i)
            set i = i+1
            endloop
            if (HaveSavedInteger(HASH_UNIT,GetHandleId(this.u),1730))then
                call RemoveSavedInteger(HASH_UNIT,GetHandleId(this.u),1730)
            endif
            set this.u=null
        endmethod
            private static method anon__0 takes nothing returns nothing
                local unit u=unitLifeCycle.argsUnit
                local thistype this=thistype.get(u)
                if (this.isExist())then
                    call this.destroy()
                endif
                set u=null
            endmethod
        static method onInit takes nothing returns nothing
            call unitLifeCycle.registerDestroy(function thistype.anon__0)
        endmethod
    endstruct

//library UnitSpell ends
//library UTUnitSpell:

        function UTUnitSpell__anon__0 takes nothing returns nothing  // 初始化测试环境
            set UTUnitSpell__testUnit=null
        endfunction  // 清理测试环境
        function UTUnitSpell__anon__1 takes nothing returns nothing
            if (UTUnitSpell__testUnit!=null)then
                call RemoveUnit(UTUnitSpell__testUnit)
                set UTUnitSpell__testUnit=null
            endif
        endfunction
    function UTUnitSpell__Init takes nothing returns nothing
        call UnitTestAutoTimer(0.1,2.0,function UTUnitSpell__anon__0,function UTUnitSpell__anon__1)
    endfunction  // 测试unitSpell.parse创建和基本属性
    function UTUnitSpell__TTestUTUnitSpell1 takes player p returns nothing
        local unitSpell us=unitSpell.parse(UTUnitSpell__testUnit)
        set UTUnitSpell__testUnit=CreateUnit(p,'hfoo',0,0,0)
        call BJDebugMsg("测试1: unitSpell.parse创建")
        call BJDebugMsg("单位是否有效: "+B2S(us!=0))
        call BJDebugMsg("绑定单位是否正确: "+B2S(us.u==UTUnitSpell__testUnit))
    endfunction  // 测试unitSpell.get获取实例
    function UTUnitSpell__TTestUTUnitSpell2 takes player p returns nothing
        local unitSpell us1=unitSpell.parse(UTUnitSpell__testUnit)
        local unitSpell us2=unitSpell.get(UTUnitSpell__testUnit)
        set UTUnitSpell__testUnit=CreateUnit(p,'hfoo',0,0,0)
        call BJDebugMsg("测试2: unitSpell.get获取")
        call BJDebugMsg("获取实例是否相同: "+B2S(us1==us2))
    endfunction  // 测试addSpell和getSpell
    function UTUnitSpell__TTestUTUnitSpell3 takes player p returns nothing
        local unitSpell us=unitSpell.parse(UTUnitSpell__testUnit)  // 创建一个测试技能
        local spell sp=spell.create(UTUnitSpell__testUnit,'AHbz',1)
        set UTUnitSpell__testUnit=CreateUnit(p,'hfoo',0,0,0)
        call us.addSpell(sp)
        call BJDebugMsg("测试3: addSpell和getSpell")
        call BJDebugMsg("获取技能是否正确: "+B2S(us.getSpell(0)==sp))
    endfunction  // 测试getSpellCount
    function UTUnitSpell__TTestUTUnitSpell4 takes player p returns nothing
        local unitSpell us
        local spell sp
        local integer countBefore
        set UTUnitSpell__testUnit=CreateUnit(p,'hfoo',0,0,0)
        set us=unitSpell.parse(UTUnitSpell__testUnit)
        set sp=spell.create(UTUnitSpell__testUnit,'AHbz',1)
        set countBefore=us.getSpellCount()
        call us.addSpell(sp)
        call BJDebugMsg("测试4: getSpellCount")
        call BJDebugMsg("技能数量是否正确: "+B2S(us.getSpellCount()==countBefore+1))
    endfunction  // 测试默认技能初始化
    function UTUnitSpell__TTestUTUnitSpell5 takes player p returns nothing
        local unitSpell us=unitSpell.parse(UTUnitSpell__testUnit)
        set UTUnitSpell__testUnit=CreateUnit(p,'hfoo',0,0,0)
        call BJDebugMsg("测试5: 默认技能初始化")
        call BJDebugMsg("默认技能数量: "+I2S(us.getSpellCount()))
    endfunction  // 测试单位销毁时的清理
    function UTUnitSpell__TTestUTUnitSpell6 takes player p returns nothing
        local unitSpell us=unitSpell.parse(UTUnitSpell__testUnit)
        set UTUnitSpell__testUnit=CreateUnit(p,'hfoo',0,0,0)
        call BJDebugMsg("测试6: 单位销毁清理")
        call BJDebugMsg("销毁前unitSpell存在: "+B2S(us.isExist()))
        call RemoveUnit(UTUnitSpell__testUnit)
        call BJDebugMsg("销毁后unitSpell存在: "+B2S(us.isExist()))
    endfunction  // 以下测试用例预留
    function UTUnitSpell__TTestUTUnitSpell7 takes player p returns nothing
    endfunction
    function UTUnitSpell__TTestUTUnitSpell8 takes player p returns nothing
    endfunction
    function UTUnitSpell__TTestUTUnitSpell9 takes player p returns nothing
    endfunction
    function UTUnitSpell__TTestUTUnitSpell10 takes player p returns nothing  // 处理带参数的测试命令
    endfunction
    function UTUnitSpell__TTestActUTUnitSpell1 takes string str returns nothing
        local player p
        local integer index
        local integer i
        local integer num
        local integer len
        local string  array paramS
        local integer  array paramI
        local real  array paramR
        local unit selectedUnit
        local unitSpell us
        local spell sp
        set p=GetTriggerPlayer()
        set index=GetConvertedPlayerId(p)
        set num=0
        set len=StringLength(str)  // 解析参数
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
        if (paramS[0]=="a")then  // 创建测试单位
            if (UTUnitSpell__testUnit!=null)then
                call RemoveUnit(UTUnitSpell__testUnit)
            endif
            set UTUnitSpell__testUnit=CreateUnit(p,paramI[1],0,0,0)
            call BJDebugMsg("创建测试单位: "+I2S(paramI[1]))
        elseif (paramS[0]=="b")then  // 为当前选中单位添加技能
            set selectedUnit=GetSelectedUnit(p)
            if (selectedUnit!=null)then
                set us=unitSpell.get(selectedUnit)
                if (us!=0)then
                    set sp=spell.create(selectedUnit,paramI[1],1)
                    call us.addSpell(sp)
                    call BJDebugMsg("添加技能: "+I2S(paramI[1]))
                endif
            endif
        endif
        set p=null
    endfunction
        function UTUnitSpell__anon__2 takes nothing returns nothing
            call BJDebugMsg("[UnitSpell] 单元测试已加载")
            call UTUnitSpell__Init()
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTUnitSpell__anon__3 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            local integer i=1
            if (SubString(str,(1)-1,1)=="-")then
                call UTUnitSpell__TTestActUTUnitSpell1(SubString(str,(2)-1,StringLength(str)))
                return
            endif
            if (str=="s1")then
                call UTUnitSpell__TTestUTUnitSpell1(GetTriggerPlayer())
            elseif (str=="s2")then
                call UTUnitSpell__TTestUTUnitSpell2(GetTriggerPlayer())
            elseif (str=="s3")then
                call UTUnitSpell__TTestUTUnitSpell3(GetTriggerPlayer())
            elseif (str=="s4")then
                call UTUnitSpell__TTestUTUnitSpell4(GetTriggerPlayer())
            elseif (str=="s5")then
                call UTUnitSpell__TTestUTUnitSpell5(GetTriggerPlayer())
            elseif (str=="s6")then
                call UTUnitSpell__TTestUTUnitSpell6(GetTriggerPlayer())
            elseif (str=="s7")then
                call UTUnitSpell__TTestUTUnitSpell7(GetTriggerPlayer())
            elseif (str=="s8")then
                call UTUnitSpell__TTestUTUnitSpell8(GetTriggerPlayer())
            elseif (str=="s9")then
                call UTUnitSpell__TTestUTUnitSpell9(GetTriggerPlayer())
            elseif (str=="s10")then
                call UTUnitSpell__TTestUTUnitSpell10(GetTriggerPlayer())
            endif
        endfunction
    function UTUnitSpell__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr,0.5,false)
        call TriggerAddCondition(tr,Condition(function UTUnitSpell__anon__2))
        set tr=null
        call UnitTestRegisterChatEvent(function UTUnitSpell__anon__3)
    endfunction

//library UTUnitSpell ends
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerSelectionEventBJ.h>
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerKeyEventBJ.h>
//#  define TriggerRegisterPlayerUnitEventSimple(trig, p, e)                 TriggerRegisterPlayerUnitEvent(trig, p, e, null)
//#  define TriggerRegisterPlayerEventVictory(trig, player)                  TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_VICTORY)
//#  define TriggerRegisterPlayerEventDefeat(trig, player)                   TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_DEFEAT)
//#  define TriggerRegisterPlayerEventLeave(trig, player)                    TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_LEAVE)
//#  define TriggerRegisterPlayerEventAllianceChanged(trig, player)          TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_ALLIANCE_CHANGED)
//#  define TriggerRegisterPlayerEventEndCinematic(trig, player)             TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_END_CINEMATIC)
// 原生UI的大小
hook RemoveUnit unitLifeCycle.onDestroyCB
// 结构体共用方法定义
//共享打印方法
// UI组件内部共享方法及成员
// UI组件依赖库
// UI组件创建时共享调用
// UI组件销毁时共享调用

// 物品掉落相关键值 (预留20个空间 1800-1819/1820-1839)  MonsterData
// 技能相关键值 (预留200个空间 2000-2199) UnitData
// 2400开始可继续添加新的键值定义...
// 定义技能最大数量

// 怪物掉落相关键值 (预留20个空间 1800-1819)
// 怪物掉落概率相关键值 (预留20个空间 1820-1839)
// 怪物掉落数量键值
// 单位技能相关键值 (预留200个空间 1800-1999)
// 2000开始可继续添加新的键值定义...
// 定义单位最大技能数量


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
call ExecuteFunc("UTUnitSpell__onInit")

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



