//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerSelectionEventBJ.h>
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerKeyEventBJ.h>
//#  define TriggerRegisterPlayerUnitEventSimple(trig, p, e)                 TriggerRegisterPlayerUnitEvent(trig, p, e, null)
//#  define TriggerRegisterPlayerEventVictory(trig, player)                  TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_VICTORY)
//#  define TriggerRegisterPlayerEventDefeat(trig, player)                   TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_DEFEAT)
//#  define TriggerRegisterPlayerEventLeave(trig, player)                    TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_LEAVE)
//#  define TriggerRegisterPlayerEventAllianceChanged(trig, player)          TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_ALLIANCE_CHANGED)
//#  define TriggerRegisterPlayerEventEndCinematic(trig, player)             TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_END_CINEMATIC)
// 原生UI的大小
//! zinc
/*
Unit生命周期管理器
负责管理Unit组件的创建和销毁事件
*/
library UnitLifeCycle {
    public struct unitLifeCycle [] {
        static unit argsUnit = null;
        private {
            static trigger trCreate = null;
            static trigger trDestroy = null;
        }
        // 注册销毁回调
        static method registerDestroy(code func) {
            TriggerAddCondition(trDestroy, Condition(func));
        }
        static method onDestroyCB(unit u) {
            argsUnit = u;
            TriggerEvaluate(trDestroy);
            //然后再清除所有哈希表
            FlushChildHashtable(HASH_UNIT,GetHandleId(u));
            argsUnit = null;
        }
        static method onInit () {
            trCreate = CreateTrigger();
            trDestroy = CreateTrigger();
        }
    }
}
//! endzinc
hook RemoveUnit unitLifeCycle.onDestroyCB
library YDWEAbilityState
	globals
		private constant integer ABILITY_STATE_COOLDOWN = 1
		private constant integer ABILITY_DATA_TARGS = 100 // integer
private constant integer ABILITY_DATA_CAST = 101 // real
private constant integer ABILITY_DATA_DUR = 102 // real
private constant integer ABILITY_DATA_HERODUR = 103 // real
private constant integer ABILITY_DATA_COST = 104 // integer
private constant integer ABILITY_DATA_COOL = 105 // real
private constant integer ABILITY_DATA_AREA = 106 // real
private constant integer ABILITY_DATA_RNG = 107 // real
private constant integer ABILITY_DATA_DATA_A = 108 // real
private constant integer ABILITY_DATA_DATA_B = 109 // real
private constant integer ABILITY_DATA_DATA_C = 110 // real
private constant integer ABILITY_DATA_DATA_D = 111 // real
private constant integer ABILITY_DATA_DATA_E = 112 // real
private constant integer ABILITY_DATA_DATA_F = 113 // real
private constant integer ABILITY_DATA_DATA_G = 114 // real
private constant integer ABILITY_DATA_DATA_H = 115 // real
private constant integer ABILITY_DATA_DATA_I = 116 // real
private constant integer ABILITY_DATA_UNITID = 117 // integer
		private constant integer ABILITY_DATA_HOTKET = 200 // integer
private constant integer ABILITY_DATA_UNHOTKET = 201 // integer
private constant integer ABILITY_DATA_RESEARCH_HOTKEY = 202 // integer
private constant integer ABILITY_DATA_NAME = 203 // string
private constant integer ABILITY_DATA_ART = 204 // string
private constant integer ABILITY_DATA_TARGET_ART = 205 // string
private constant integer ABILITY_DATA_CASTER_ART = 206 // string
private constant integer ABILITY_DATA_EFFECT_ART = 207 // string
private constant integer ABILITY_DATA_AREAEFFECT_ART = 208 // string
private constant integer ABILITY_DATA_MISSILE_ART = 209 // string
private constant integer ABILITY_DATA_SPECIAL_ART = 210 // string
private constant integer ABILITY_DATA_LIGHTNING_EFFECT = 211 // string
private constant integer ABILITY_DATA_BUFF_TIP = 212 // string
private constant integer ABILITY_DATA_BUFF_UBERTIP = 213 // string
private constant integer ABILITY_DATA_RESEARCH_TIP = 214 // string
private constant integer ABILITY_DATA_TIP = 215 // string
private constant integer ABILITY_DATA_UNTIP = 216 // string
private constant integer ABILITY_DATA_RESEARCH_UBERTIP = 217 // string
private constant integer ABILITY_DATA_UBERTIP = 218 // string
private constant integer ABILITY_DATA_UNUBERTIP = 219 // string
private constant integer ABILITY_DATA_UNART = 220 // string
endglobals
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
		call EXSetAbilityDataInteger(EXGetUnitAbility(u, abilcode), 1, ABILITY_DATA_UNITID, GetUnitTypeId(u))
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
endlibrary
// 结构体共用方法定义
//共享打印方法
// UI组件内部共享方法及成员
// UI组件依赖库
// UI组件创建时共享调用
// UI组件销毁时共享调用
/*
物编哈希表键值定义
*/
// 物品掉落相关键值 (预留20个空间 1800-1819/1820-1839)  MonsterData
// 技能相关键值 (预留200个空间 2000-2199) UnitData
// 2400开始可继续添加新的键值定义...
// 定义技能最大数量
//! zinc
/*
单位类型的数据
包含单位类型的技能等通用属性
todo: 加一下技能的删改查(现在只有增)
*/
library UnitData requires SpellData {
    public struct unitData [] {
        static integer counter = 0;
        // 添加技能
        public method addSpell(spellData sd, integer level) {
            integer count = 0;
            if (HaveSavedInteger(HASH_SLK, this, 1900)) {
                count = LoadInteger(HASH_SLK, this, 1900);
            }
            if (count >= 200) {
                return; // 超出最大数量限制
}
            // 保存技能ID
            SaveInteger(HASH_SLK, this, 2000 + count, sd);
            // 保存技能等级
            SaveInteger(HASH_SLK, this, 2200 + count, level);
            // 更新技能总数
            SaveInteger(HASH_SLK, this, 1900, count + 1);
        }
        // 获取技能数量
        public method getSpellCount() -> integer {
            if (HaveSavedInteger(HASH_SLK, this, 1900)) {
                return LoadInteger(HASH_SLK, this, 1900);
            }
            return 0;
        }
        // 获取指定索引的技能ID
        public method getSpellId(integer index) -> spellData {
            if (index >= 0 && index < this.getSpellCount()) {
                return LoadInteger(HASH_SLK, this, 2000 + index);
            }
            return 0;
        }
        // 获取指定索引的技能等级
        public method getSpellLevel(integer index) -> integer {
            if (index >= 0 && index < this.getSpellCount()) {
                return LoadInteger(HASH_SLK, this, 2200 + index);
            }
            return 0;
        }
        //根据单位类型
        public static method byType(integer ut) -> thistype {
            thistype this;
            if (HaveSavedInteger(HASH_SLK, ut, 1725)) {
                this = LoadInteger(HASH_SLK, ut, 1725);
            } else {
                counter += 1;
                this = thistype[counter];
                SaveInteger(HASH_SLK, ut, 1725, this);
                //初始化
                SaveInteger(HASH_SLK, this, 1900, 0);
            }
            return this;
        }
    }
}
//! endzinc
/*
单位哈希表定义
*/
// 怪物掉落相关键值 (预留20个空间 1800-1819)
// 怪物掉落概率相关键值 (预留20个空间 1820-1839)
// 怪物掉落数量键值
// 单位技能相关键值 (预留200个空间 1800-1999)
// 2000开始可继续添加新的键值定义...
// 定义单位最大技能数量
//! zinc
/*
每个单位拥有的技能
*/
library UnitSpell requires Spell {
    public struct unitSpell {
        method isExist () -> boolean {return (this != null && si__unitSpell_V[this] == -1);}
        unit u; // 所属单位
integer spellCount = 0; // 当前技能数量
        // 添加技能
        method addSpell(spell sp) {
            if (sp == 0) { return; } // 无效的技能
if (this.spellCount >= 200) { return; }
            SaveInteger(HASH_UNIT, GetHandleId(this.u),
            1800 + this.spellCount, sp);
            this.spellCount += 1;
        }
        // 获取技能数量
        method getSpellCount() -> integer {
            return this.spellCount;
        }
        // 获取指定索引的技能
        method getSpell(integer index) -> spell {
            if (index >= 0 && index < this.spellCount) {
                return LoadInteger(HASH_UNIT, GetHandleId(this.u),
                1800 + index);
            }
            return 0;
        }
        // 初始化默认技能(从unitData继承)
        private method initDefaultSpell() {
            integer i = 0;
            spellData sd = 0;
            integer level = 0;
            integer maxLevel = 0;
            spell sp = 0;
            unitData ud = unitData.byType(GetUnitTypeId(this.u));
            this.spellCount = 0; // 初始化技能数量
            // 从unitData创建所有技能
            for (0 <= i < ud.getSpellCount()) {
                sd = ud.getSpellId(i);
                level = ud.getSpellLevel(i);
                maxLevel = sd.maxLevel;
                sp = spell.entity(this.u, sd, IMinBJ(level, IMaxBJ(maxLevel, 1)));
                if (sp != 0) {
                    SaveInteger(HASH_UNIT, GetHandleId(this.u),
                    1800 + this.spellCount, sp);
                    this.spellCount += 1;
                }
            }
        }
        // 构造函数
        static method parse(unit u) -> thistype {
            thistype this;
            integer handleId = GetHandleId(u);
            // 先检查是否已存在
            if (HaveSavedInteger(HASH_UNIT, handleId, 1730)) {
                return LoadInteger(HASH_UNIT, handleId, 1730);
            }
            // 不存在才创建新的
            this = thistype.allocate();
            this.u = u;
            this.initDefaultSpell(); // 默认初始化技能
            SaveInteger(HASH_UNIT, handleId, 1730, this);
            return this;
        }
        // 获取已存在的实例
        static method get(unit u) -> thistype {
            if (HaveSavedInteger(HASH_UNIT, GetHandleId(u), 1730)) {
                return LoadInteger(HASH_UNIT, GetHandleId(u), 1730);
            }
            return 0;
        }
        method onDestroy() {
            integer i = 0;
            // 清理所有技能引用
            for (0 <= i < this.spellCount) {
                RemoveSavedInteger(HASH_UNIT, GetHandleId(this.u),
                1800 + i);
            }
            if (HaveSavedInteger(HASH_UNIT, GetHandleId(this.u), 1730)) {
                RemoveSavedInteger(HASH_UNIT, GetHandleId(this.u), 1730);
            }
            this.u = null;
        }
        static method onInit () {
            unitLifeCycle.registerDestroy(function () {
				unit u = unitLifeCycle.argsUnit;
				thistype this = thistype.get(u);
				if (this.isExist()) {
					this.destroy();
				}
				u = null;
			});
        }
    }
}
//! endzinc
/*
技能哈希表定义
*/
//! zinc
/*
技能哈希表
*/
library SpellTable {
    public hashtable HASH_SPELL = InitHashtable(); // 技能哈希表(键是通过GetHashValue计算的)
}
//! endzinc
//! zinc
/*
SLK数据的表(所有物编都在一起)
*/
library SLKTable {
    public hashtable HASH_SLK = InitHashtable(); // SLK数据哈希表
}
//! endzinc
//! zinc
/*
技能数据
*/
library SpellData {
    public constant integer SPELL_TYPE_ENTITY = 0; //固定技能(默认)
public constant integer SPELL_TYPE_MIRROR = 1; //镜像技能(英雄的模板技能)
public constant integer SPELL_TYPE_VIRTUAL = 2; //虚拟技能(物品技能)
public constant integer SPELL_TYPE_SIMPLE = 3; //简单技能(无结构体,固定发挥)
    public struct spellData [] {
        static integer counter = 0; // 当前有几个技能数据
        integer id; // 技能ID(从那边直接获取数据)
integer spellType; // 技能类型(1:结构技能,2:无结构技能,3:虚拟技能,4:简单技能)
        trigger trInit; // 技能初始化事件
trigger trDestroy; // 技能销毁事件
trigger trUpgrade; // 技能升级事件
        integer maxLevel; // 技能等级(最大等级)
string description; // 技能描述
string icon; // 技能图标
        //根据技能类型
        public static method byType(integer at) -> thistype {
            thistype this;
            if (HaveSavedInteger(HASH_SLK, at, 1727)) {
                this = LoadInteger(HASH_SLK, at, 1727);
            } else {
                counter += 1;
                this = thistype[counter];
                SaveInteger(HASH_SLK, at, 1727, this);
                id = at;
                maxLevel = 1; //默认最大等级1级
}
            return this;
        }
    }
}
//! endzinc
//! zinc
/*
法术(技能)结构体
三种:
1)id 与 sd里面的id是一样的,且不是0. -> 固定技能(entity)
2)id 与 sd里面的id不一样,使用镜像技能 -> 镜像技能(mirror) -> 带模板的英雄技能
3)id 是 0,CD什么都是自己模拟的技能 -> 虚拟技能(virtual) -> 物品技能
4)不创建结构体 -> 简单技能(simple) -> 无结构体,固定发挥
*/
library Spell {
    // 技能哈希值计算
    public function GetHashValue ( integer handleID, integer customId ) -> integer {
        // 使用两个大质数
        integer prime1 = 131071; // 2^17-1
integer prime2 = 179424673; // 较大的质数
        return (handleID * prime1) + (customId * prime2);
    }
    public struct spell {
        unit u; // 技能拥有者
integer spellType; // 技能类型(0:结构技能,1:无结构技能,2:虚拟技能,3:简单技能)
integer id; // 技能ID(一致则1类,不一致则2类,为0则是3类)
spellData sd; // 技能实例的对应技能数据
integer level; // 技能等级
        method isExist () -> boolean {return (this != null && si__spell_V[this] == -1);}
        // 实体技能(有ID)
        public static method entity (unit u, integer id, integer level) -> thistype {
            thistype this;
			integer key = GetHashValue(GetHandleId(u), id);
            if (key == 0 ) { //单位没有这个技能
return 0;
            }
            //todo:人物拥有技能判定
			// 先检查是否已存在
			if (HaveSavedInteger(HASH_SPELL, key, 15)) {
				return LoadInteger(HASH_SPELL, key, 15);
			}
			// 不存在才创建新的
			this = allocate();
            this.u = u;
            this.id = id;
            this.sd = spellData.byType(id);
            this.level = level;
            this.spellType = SPELL_TYPE_ENTITY;
			SaveInteger(HASH_SPELL, key, 15, this);
			return this;
        }
        // 镜像技能(无ID)
        public static method mirror (unit u ,integer id, spellData sd, integer level) -> thistype {
            thistype this;
			integer key = GetHashValue(GetHandleId(u), id);
			// 先检查是否已存在
			if (HaveSavedInteger(HASH_SPELL, key, 15)) {
				return LoadInteger(HASH_SPELL, key, 15);
			}
            // 不存在才创建新的
            this = allocate();
            this.u = u;
            this.id = id;
            this.spellType = SPELL_TYPE_MIRROR;
            this.sd = sd;
            this.level = level;
			SaveInteger(HASH_SPELL, key, 15, this);
            return this;
        }
        // 虚拟技能(无ID)
        public static method virtual (unit u ,spellData sd, integer level) -> thistype {
            thistype this;
			integer key = GetHashValue(GetHandleId(u), sd); //使用sd作为哈希值
			// 先检查是否已存在
			if (HaveSavedInteger(HASH_SPELL, key, 15)) {
				return LoadInteger(HASH_SPELL, key, 15);
			}
            // 不存在才创建新的
            this = allocate();
            this.u = u;
            this.id = 0;
            this.spellType = SPELL_TYPE_VIRTUAL;
            this.sd = sd;
            this.level = level;
			SaveInteger(HASH_SPELL, key, 15, this);
            return this;
        }
        //销毁
        method onDestroy () {
            if (HaveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(u), sd), 15)) {
                RemoveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(u), sd), 15);
			}
            this.u = null;
            this.id = 0;
            this.sd = 0;
        }
    }
}
//! endzinc
//! zinc
/*
单位哈希表
*/
library UnitHashTable {
    public hashtable HASH_UNIT = InitHashtable(); // 单位哈希表
}
//! endzinc
/*
单元测试框架(注入)
*/
//! zinc
library UnitTestFramwork {
	//单元测试总
	trigger TUnitTest = null;
    private hashtable HASH_UNITTEST = InitHashtable(); // 单元测试哈希表
    //断言
    public struct assert []{
        //断言布尔值
        static method Boolean (boolean condition,string name) {
            if (!condition) {
                BJDebugMsg("FAIL: " + name);
            } else {
                BJDebugMsg("PASS: " + name);
            }
        }
        //断言字符串相等
        static method String(string actual, string expected, string name) {
            if (actual != expected) {
                BJDebugMsg("FAIL: " + name);
                BJDebugMsg("  Expected: " + expected);
                BJDebugMsg("  Actual: " + actual);
            } else {
                BJDebugMsg("PASS: " + name);
            }
        }
        //断言整数相等
        static method Integer(integer actual, integer expected, string name) {
            if (actual != expected) {
                BJDebugMsg("FAIL: " + name);
                BJDebugMsg("  Expected: " + I2S(expected));
                BJDebugMsg("  Actual: " + I2S(actual));
            } else {
                BJDebugMsg("PASS: " + name);
            }
        }
        //断言浮点数相等
        static method Real(real actual, real expected, string name) {
            real maxValue = RMaxBJ(RAbsBJ(actual), RAbsBJ(expected)); // 取两个数的绝对值的较大值
real epsilon = maxValue * 0.00001; // 相对误差为数值大小的万分之一
// 处理接近0的特殊情况
if (maxValue < 0.00001) {
                epsilon = 0.00001;
            }
            if (RAbsBJ(actual - expected) > epsilon) {
                BJDebugMsg("FAIL: " + name);
                BJDebugMsg("  Expected: " + R2SW(expected,0,1));
                BJDebugMsg("  Actual: " + R2SW(actual,0,1));
            } else {
                BJDebugMsg("PASS: " + name);
            }
        }
    }
    //注册单元测试事件(聊天内容),自动注入
    public function UnitTestRegisterChatEvent (code func) {
        TriggerAddAction(TUnitTest, func);
    }
    //指定开始时间与持续时间的定时器
    public function UnitTestAutoTimer (real time, real duration,code start, code end) {
        trigger t = CreateTrigger();
        trigger tr = CreateTrigger();
        TriggerAddCondition(t, Condition(start));
        TriggerRegisterTimerEvent(tr, time, false);
        SaveReal(HASH_UNITTEST,GetHandleId(tr),1,time);
        SaveReal(HASH_UNITTEST,GetHandleId(tr),2,duration);
        SaveTriggerHandle(HASH_UNITTEST,GetHandleId(tr),3,t);
        TriggerAddCondition(tr,Condition(function (){
            real time = LoadReal(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),1);
            real d = LoadReal(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),2);
            trigger tr = LoadTriggerHandle(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),3);
            BJDebugMsg("-----[单测 " + R2SW(time,0,1) + " - " + R2SW(time+d,0,1) + " 秒]开始------");
            TriggerEvaluate(tr);
            DestroyTrigger(tr);
            FlushChildHashtable(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()));
            DestroyTrigger(GetTriggeringTrigger());
            tr = null;
        }));
        if (end != null) {
            t = CreateTrigger();
            tr = CreateTrigger();
            TriggerAddCondition(t, Condition(end));
            TriggerRegisterTimerEvent(tr, time+duration, false);
            SaveReal(HASH_UNITTEST,GetHandleId(tr),1,time);
            SaveReal(HASH_UNITTEST,GetHandleId(tr),2,duration);
            SaveTriggerHandle(HASH_UNITTEST,GetHandleId(tr),3,t);
            TriggerAddCondition(tr,Condition(function (){
                real time = LoadReal(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),1);
                real d = LoadReal(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),2);
                trigger tr = LoadTriggerHandle(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),3);
                TriggerEvaluate(tr);
                BJDebugMsg("-----[单测 " + R2SW(time,0,1) + " - " + R2SW(time+d,0,1) + " 秒]结束------");
                DestroyTrigger(tr);
                FlushChildHashtable(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()));
                DestroyTrigger(GetTriggeringTrigger());
                tr = null;
            }));
        }
        tr = null;
        t = null;
    }
    function onInit () {
        //在游戏开始0.1秒后再调用
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEvent(tr, 0.1, false);
        TriggerAddCondition(tr,Condition(function (){
            integer i;
            for (1 <= i <= 12) {
				SetPlayerName(ConvertedPlayer(i),"测试员" + I2S(i)+ "号");
                CreateFogModifierRectBJ( true, ConvertedPlayer(i), FOG_OF_WAR_VISIBLE, bj_mapInitialPlayableArea ); //迷雾全关
}
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;
		TUnitTest = CreateTrigger();
		TriggerRegisterPlayerChatEvent(TUnitTest, Player(0), "", false );
		TriggerRegisterPlayerChatEvent(TUnitTest, Player(1), "", false );
		TriggerRegisterPlayerChatEvent(TUnitTest, Player(2), "", false );
		TriggerRegisterPlayerChatEvent(TUnitTest, Player(3), "", false );
    }
}
//! endzinc
//! zinc
/*
转换工具
*/
library ConversionUtils {
    //补充函数
    public function B2S(boolean b) -> string {
        if (b) {return "true";}
        else {return "false";}
    }
    //三目运算符
    public function S3 (boolean b,string s1,string s2) -> string {
        if (b) {return s1;}
        else {return s2;}
    }
    //三目运算符
    public function U3 (boolean b,unit u1,unit u2) -> unit {
        if (b) {return u1;}
        else {return u2;}
    }
    //三目运算符
    public function I3 (boolean b,integer i1,integer i2) -> integer {
        if (b) {return i1;}
        else {return i2;}
    }
    //三目运算符
    public function R3 (boolean b,real r1,real r2) -> real {
        if (b) {return r1;}
        else {return r2;}
    }
    // 将数字转换为魔兽的四字符ID,使用256进制但限制36个数一进位
    // pos为输入数字,每36个数字进一位,每位用0-9和a-z表示(共36个字符)
    // 示例:0->'0000', 35->'000z', 36->'0010'(进位), 37->'0011'
    public function GetIDSymbol ( integer pos ) -> integer {
        integer bit = pos/36;
        pos = ModuloInteger(pos,36);
        if (pos < 10) {return pos + bit * 256;}
        else {return '000a' - '0000' + pos - 10 + bit * 256;}
    }
    // 将魔兽的四字符ID转换回对应数字
    // s为输入的四字符ID,将其还原为原始数字
    // 示例:'0000'->0, '000z'->35, '0010'->36, '0011'->37
    public function GetSymbolID ( integer s ) -> integer {
        integer i1 = s/256;
        integer i2 = ModuloInteger(s,256);
        if (i2 < 10) {return i1 * 36 + i2;}
        else {return i2 - '000a' + '0000' + 10 + i1 * 36;}
    }
}
//! endzinc
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
globals
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
endglobals
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
//! zinc
/*
 * UnitSpell测试文件
 * 测试UnitSpell库的所有功能
 *
 * 测试命令:
 * s1 - 测试unitSpell.parse创建和基本属性
 * s2 - 测试unitSpell.get获取实例
 * s3 - 测试addSpell和getSpell
 * s4 - 测试getSpellCount
 * s5 - 测试默认技能初始化
 * s6 - 测试单位销毁时的清理
 *
 * -a [unitId] - 创建指定ID的测试单位
 * -b [spellId] - 为当前选中单位添加指定技能
 */
library UTUnitSpell requires UnitSpell {
	private unit testUnit = null;
	function Init() {
		UnitTestAutoTimer(0.1, 2.0, function() {
			// 初始化测试环境
			testUnit = null;
		}, function() {
			// 清理测试环境
			if (testUnit != null) {
				RemoveUnit(testUnit);
				testUnit = null;
			}
		});
	}
	// 测试unitSpell.parse创建和基本属性
	function TTestUTUnitSpell1(player p) {
		unitSpell us = unitSpell.parse(testUnit);
		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		BJDebugMsg("测试1: unitSpell.parse创建");
		BJDebugMsg("单位是否有效: " + B2S(us != 0));
		BJDebugMsg("绑定单位是否正确: " + B2S(us.u == testUnit));
	}
	// 测试unitSpell.get获取实例
	function TTestUTUnitSpell2(player p) {
		unitSpell us1 = unitSpell.parse(testUnit);
		unitSpell us2 = unitSpell.get(testUnit);
		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		BJDebugMsg("测试2: unitSpell.get获取");
		BJDebugMsg("获取实例是否相同: " + B2S(us1 == us2));
	}
	// 测试addSpell和getSpell
	function TTestUTUnitSpell3(player p) {
		unitSpell us = unitSpell.parse(testUnit);
		spell sp = spell.create(testUnit, 'AHbz', 1); // 创建一个测试技能
testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		us.addSpell(sp);
		BJDebugMsg("测试3: addSpell和getSpell");
		BJDebugMsg("获取技能是否正确: " + B2S(us.getSpell(0) == sp));
	}
	// 测试getSpellCount
	function TTestUTUnitSpell4(player p) {
		unitSpell us;
		spell sp;
		integer countBefore;
		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		us = unitSpell.parse(testUnit);
		sp = spell.create(testUnit, 'AHbz', 1);
		countBefore = us.getSpellCount();
		us.addSpell(sp);
		BJDebugMsg("测试4: getSpellCount");
		BJDebugMsg("技能数量是否正确: " + B2S(us.getSpellCount() == countBefore + 1));
	}
	// 测试默认技能初始化
	function TTestUTUnitSpell5(player p) {
		unitSpell us = unitSpell.parse(testUnit);
		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		BJDebugMsg("测试5: 默认技能初始化");
		BJDebugMsg("默认技能数量: " + I2S(us.getSpellCount()));
	}
	// 测试单位销毁时的清理
	function TTestUTUnitSpell6(player p) {
		unitSpell us = unitSpell.parse(testUnit);
		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		BJDebugMsg("测试6: 单位销毁清理");
		BJDebugMsg("销毁前unitSpell存在: " + B2S(us.isExist()));
		RemoveUnit(testUnit);
		BJDebugMsg("销毁后unitSpell存在: " + B2S(us.isExist()));
	}
	// 以下测试用例预留
	function TTestUTUnitSpell7(player p) {}
	function TTestUTUnitSpell8(player p) {}
	function TTestUTUnitSpell9(player p) {}
	function TTestUTUnitSpell10(player p) {}
	// 处理带参数的测试命令
	function TTestActUTUnitSpell1(string str) {
		player p;
		integer index;
		integer i;
		integer num;
		integer len;
		string paramS[];
		integer paramI[];
		real paramR[];
		unit selectedUnit;
		unitSpell us;
		spell sp;
		p = GetTriggerPlayer();
		index = GetConvertedPlayerId(p);
		num = 0;
		len = StringLength(str);
		// 解析参数
		for (0 <= i <= len - 1) {
			if (SubString(str,i,i+1) == " ") {
				paramS[num] = SubString(str,0,i);
				paramI[num] = S2I(paramS[num]);
				paramR[num] = S2R(paramS[num]);
				num = num + 1;
				str = SubString(str,i + 1,len);
				len = StringLength(str);
				i = -1;
			}
		}
		paramS[num] = str;
		paramI[num] = S2I(paramS[num]);
		paramR[num] = S2R(paramS[num]);
		num = num + 1;
		if (paramS[0] == "a") {
			// 创建测试单位
			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(p, paramI[1], 0, 0, 0);
			BJDebugMsg("创建测试单位: " + I2S(paramI[1]));
		} else if (paramS[0] == "b") {
			// 为当前选中单位添加技能
			selectedUnit = GetSelectedUnit(p);
			if (selectedUnit != null) {
				us = unitSpell.get(selectedUnit);
				if (us != 0) {
					sp = spell.create(selectedUnit, paramI[1], 1);
					us.addSpell(sp);
					BJDebugMsg("添加技能: " + I2S(paramI[1]));
				}
			}
		}
		p = null;
	}
	function onInit() {
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEvent(tr, 0.5, false);
		TriggerAddCondition(tr, Condition(function() {
			BJDebugMsg("[UnitSpell] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;
		UnitTestRegisterChatEvent(function() {
			string str = GetEventPlayerChatString();
			integer i = 1;
			if (SubString(str, (1)-1, 1) == "-") {
				TTestActUTUnitSpell1(SubString(str, (2)-1, StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitSpell1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitSpell2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitSpell3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitSpell4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitSpell5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitSpell6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitSpell7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitSpell8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitSpell9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitSpell10(GetTriggerPlayer());
		});
	}
}
//! endzinc
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
/**/
