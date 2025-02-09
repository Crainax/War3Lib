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
SLK数据的表(所有物编都在一起)
*/
library SLKTable {
    public hashtable HASH_SLK = InitHashtable(); // SLK数据哈希表
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
//! zinc
/*
单位哈希表
*/
library UnitHashTable {
    public hashtable HASH_UNIT = InitHashtable(); // 单位哈希表

}
//! endzinc
// 结构体共用方法定义
//共享打印方法
// UI组件内部共享方法及成员
// UI组件依赖库
// UI组件创建时共享调用
// UI组件销毁时共享调用
/*
技能哈希表定义
*/
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
        static thistype ethis = 0;
        unit u; // 技能拥有者
integer spellType; // 技能类型(0:结构技能,1:无结构技能,2:虚拟技能,3:简单技能)
integer id; // 技能ID(一致则1类,不一致则2类,为0则是3类)
spellData sd; // 技能实例的对应技能数据
integer level; // 技能等级
trigger trDestroy; // 当销毁时调用

        method isExist () -> boolean {return (this != null && si__spell_V[this] == -1);}
        // 创建实体技能(有ID)
        public static method entity (unit u, integer id, integer level) -> thistype {
            thistype this;
			integer key = GetHashValue(GetHandleId(u), id);
            if (key == 0 ) { //单位没有这个技能
return 0;
            }
			// 先检查是否已存在
			if (HaveSavedInteger(HASH_SPELL, key, 15)) {
				return LoadInteger(HASH_SPELL, key, 15);
			}
            if (GetUnitAbilityLevel(u,id) == 0) { //没技能就添加技能
UnitAddAbility(u,id);
            }
			// 不存在才创建新的
			this = allocate();
            this.u = u;
            this.id = id;
            this.sd = spellData.byType(id);
            this.level = level;
            this.spellType = SPELL_TYPE_ENTITY;
            SetUnitAbilityLevel(u,id,level); //实体技能要设置等级

			SaveInteger(HASH_SPELL, key, 15, this);
			return this;
        }
        // 创建镜像技能(无ID)
        public static method mirror (unit u ,integer id, spellData sd, integer level) -> thistype {
            thistype this;
			integer key = GetHashValue(GetHandleId(u), id);
			// 先检查是否已存在
			if (HaveSavedInteger(HASH_SPELL, key, 15)) {
				return LoadInteger(HASH_SPELL, key, 15);
			}
            if (GetUnitAbilityLevel(u,id) == 0) { //没技能就添加技能
UnitAddAbility(u,id);
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
        // 创建虚拟技能(无ID)
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
        // 获取技能结构体
        public static method get (unit u, integer id) -> thistype {
            if (HaveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(u), id), 15)) {
				return LoadInteger(HASH_SPELL, GetHashValue(GetHandleId(u), id), 15);
			}
			return 0;
        }
        // 注册销毁时的回调
        public method registerDestroy (code func) {
            if (!this.isExist()) {return;}
            if (trDestroy == null) {
                trDestroy = CreateTrigger();
            }
            TriggerAddCondition(trDestroy, Condition(func));
        }
        //销毁时调用
        method onDestroy () {
            if (!this.isExist()) {return;}
            if (trDestroy != null) {
                thistype.ethis = this;
                TriggerEvaluate(trDestroy);
                DestroyTrigger(trDestroy);
                trDestroy = null;
            }
            if (spellType == SPELL_TYPE_VIRTUAL) { //虚拟技能
if (HaveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(u), sd), 15)) {
                    RemoveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(u), sd), 15);
                }
            } else { //有ID的技能
if (HaveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(u), id), 15)) {
                    RemoveSavedInteger(HASH_SPELL, GetHashValue(GetHandleId(u), id), 15);
                }
            }
            if (id != 0) {
                UnitRemoveAbility(u,id);
            }
            this.u = null;
            this.id = 0;
            this.sd = 0;
        }
        // HOOK:这里的id仅是物编ID没有virtual
        // public static method RemoveHook (unit u, integer id)  -> nothing {
		// 	integer key = GetHashValue(GetHandleId(u), id); //使用sd作为哈希值
        //     thistype this;
        //     if (HaveSavedInteger(HASH_SPELL,key,HASH_KEY_SPELL_SPELL)) {
        //         this = LoadInteger(HASH_SPELL,key,HASH_KEY_SPELL_SPELL);
        //         this.destroy();
        //     }
        // }
    }
}
//! endzinc
// hook UnitRemoveAbility spell.RemoveHook
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
/*
物编哈希表键值定义
*/
// 物品掉落相关键值 (预留20个空间 1800-1819/1820-1839)  MonsterData
// 技能相关键值 (预留200个空间 2000-2199) UnitData
// 2400开始可继续添加新的键值定义...
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
单位选择事件(异步和同步均有)
*/
library UnitSelect requires Hardware ,LBKKAPI{
    public struct unitSelect[] {
            static unit args = null; //回调传参用(异步)
static unit argsSync = null; //回调传参用(同步)
static unit currentU []; //每个人当前选择的单位(同步)

            private {
                static trigger trAsync;
                static trigger trAsyncUn;
                static trigger trSync;
                static trigger trSyncUn;
                static unit asyncU = null; //现在的选择单位-异步(每个人的引用不一样)
}
        // 异步时选中单位调用,在取消选择后面
        // 调用这个函数注册过程要同步,不能注册的时候异步
        static method onAsync (code func) {
            TriggerAddCondition(trAsync, Condition(func));
        }
        // 异步时取消选择单位调用
        // 调用这个函数注册过程要同步,不能注册的时候异步
        static method onAsyncUn (code func) {
            TriggerAddCondition(trAsyncUn, Condition(func));
        }
        // 同步时选中单位调用
        static method onSync (code func) {
            TriggerAddCondition(trSync, Condition(func));
        }
        // 同步时取消选择单位调用
        static method onSyncUn (code func) {
            TriggerAddCondition(trSyncUn, Condition(func));
        }
        //初始化
        static method onInit () {
            integer i;
            trigger tr = CreateTrigger(); //一次性用的选择事件

            trAsync = CreateTrigger();
            trAsyncUn = CreateTrigger();
            trSync = CreateTrigger();
            trSyncUn = CreateTrigger();
            //选单位的事件[同步]
            for (1 <= i <= 12) {TriggerRegisterPlayerSelectionEventBJ(tr, ConvertedPlayer(i), true);}
            TriggerAddCondition(tr, Condition(function (){
                //单位选择事件[同步]
                integer index = GetConvertedPlayerId(GetTriggerPlayer());
                if (GetTriggerUnit() != unitSelect.currentU[index]) {
                    unitSelect.argsSync = unitSelect.currentU[index];
                    TriggerEvaluate(trSyncUn); //事件里用unitSelect.argsSync来指代
unitSelect.argsSync = GetTriggerUnit();
                    TriggerEvaluate(trSync); //事件里用unitSelect.argsSync来指代
unitSelect.currentU[index] = GetTriggerUnit();
                    unitSelect.argsSync = null;
                }
            }));
            hardware.regUpdateEvent(function (){ //注册2个事件:选择单位,与不选择事件
if (DzGetSelectedLeaderUnit() != unitSelect.asyncU) {
                    unitSelect.args = unitSelect.asyncU;
                    TriggerEvaluate(trAsyncUn); //事件里用unitSelect.args来指代
unitSelect.args = DzGetSelectedLeaderUnit();
                    TriggerEvaluate(trAsync); //事件里用unitSelect.args来指代
unitSelect.asyncU = DzGetSelectedLeaderUnit();
                    unitSelect.args = null;
                }
            });
        }
    }
}
//! endzinc
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

        // 检查技能是否已存在
        private method hasSpell(spell sp) -> boolean {
            integer i = 0;
            integer handleId = GetHandleId(this.u);
            spell existingSpell;
            for (0 <= i < this.spellCount) {
                existingSpell = LoadInteger(HASH_UNIT, handleId, 1800 + i);
                if (existingSpell == sp) {
                    return true;
                }
            }
            return false;
        }
        // 通过spellData添加技能
        method addSpellData(spellData sd, integer level) -> boolean {
            spell sp = 0;
            if (this.spellCount >= 200) {
                return false;
            }
            // 创建技能实例
            if (sd.spellType == SPELL_TYPE_ENTITY) {
                sp = spell.entity(this.u, sd.id, IMinBJ(level, IMaxBJ(sd.maxLevel, 1)));
            // } else if (sd.spellType == SPELL_TYPE_MIRROR) {
            //     sp = spell.mirror(this.u, sd.id, IMinBJ(level, IMaxBJ(sd.maxLevel, 1)));
            } else if (sd.spellType == SPELL_TYPE_VIRTUAL) {
                sp = spell.virtual(this.u, sd.id, IMinBJ(level, IMaxBJ(sd.maxLevel, 1)));
            } else if (sd.spellType == SPELL_TYPE_SIMPLE) {
                // sp = spell.virtual(this.u, sd.id, IMinBJ(level, IMaxBJ(sd.maxLevel, 1)));
            }
            if (sp == 0) {
                return false;
            }
            // 检查是否已存在相同的技能实例
            if (this.hasSpell(sp)) {
                return false;
            }
            SaveInteger(HASH_UNIT, GetHandleId(this.u),
                1800 + this.spellCount, sp);
            this.spellCount += 1;
            return true;
        }
        // 直接添加技能实例
        method addSpell(spell sp) -> spell {
            if (this.spellCount >= 200) {
                return 0;
            }
            if (!sp.isExist()) {
                return 0;
            }
            // 检查是否已存在相同的技能实例
            if (this.hasSpell(sp)) {
                return 0;
            }
            SaveInteger(HASH_UNIT, GetHandleId(this.u),
                1800 + this.spellCount, sp);
            this.spellCount += 1;
            return sp;
        }
        // 获取技能数量
        method getSpellCount() -> integer {
            return this.spellCount;
        }
        // 获取指定索引的技能
        method getSpell(integer index) -> spell {
            integer handleId = GetHandleId(this.u);
            spell sp;
            if (index >= 0 && index < this.spellCount) {
                sp = LoadInteger(HASH_UNIT, handleId, 1800 + index);
                return sp;
            }
            return 0;
        }
        // 移除指定技能
        method removeSpell(spell sp) -> boolean {
            integer i = 0;
            integer handleId = GetHandleId(this.u);
            spell lastSpell = 0;
            spell targetSpell = 0;
            if (!sp.isExist()) {
                return false;
            }
            // 遍历查找技能
            for (0 <= i < this.spellCount) {
                targetSpell = LoadInteger(HASH_UNIT, handleId, 1800 + i);
                if (targetSpell == sp) {
                    // 如果不是最后一个技能,则把最后一个技能移到当前位置
                    if (i < this.spellCount - 1) {
                        lastSpell = LoadInteger(HASH_UNIT, handleId,
                            1800 + this.spellCount - 1);
                        SaveInteger(HASH_UNIT, handleId,
                            1800 + i, lastSpell);
                    }
                    // 清理最后一个位置
                    RemoveSavedInteger(HASH_UNIT, handleId,
                        1800 + this.spellCount - 1);
                    this.spellCount -= 1;
                    // 销毁技能对象
                    targetSpell.destroy();
                    return true;
                }
            }
            return false;
        }
        // 通过spellData移除技能
        method removeSpellData(spellData sd) -> boolean {
            spell sp = spell.get(this.u, sd.id);
            if (sp != 0) {
                return this.removeSpell(sp);
            }
            return false;
        }
        // 初始化默认技能(从unitData继承)
        private method initDefaultSpell() {
            integer i = 0;
            unitData ud = unitData.byType(GetUnitTypeId(this.u));
            this.spellCount = 0; // 初始化技能数量

            // 从unitData创建所有技能
            for (0 <= i < ud.getSpellCount()) {
                this.addSpellData(ud.getSpellId(i), ud.getSpellLevel(i));
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
            BJDebugMsg("unitSpell销毁了:"+I2S(this));
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
//! zinc
//==================================
// 日志打印系统
// version: 1.0
// author: 系统自动生成
// date: 2024/3/21
//
// 功能：提供五个日志级别输出
// - TRACE(灰)：追踪调试用
// - DEBUG(绿)：调试信息用
// - INFO(白)：普通信息用
// - WARN(黄)：警告信息用
// - ERROR(红)：错误信息用
//
// 示例：
// call Info("普通信息")
// call Error(Player(0), "玩家1的错误")
//==================================
library Logger requires YDLua {
    public integer logger_level = 0;
    public string logger_msg = null;
    public player logger_p = null;
    public trigger logger_tr = null;
    // 追踪级别日志(灰色),用于程序执行追踪
    public function Trace(string msg) {
        logger_msg = msg;
        logger_level = 0;
        logger_p = GetLocalPlayer();
		TriggerEvaluate(logger_tr);
    }
    // 调试级别日志(绿色),用于输出变量值等调试信息
    public function Debug(string msg) {
        logger_msg = msg;
        logger_level = 1;
        logger_p = GetLocalPlayer();
		TriggerEvaluate(logger_tr);
    }
    // 信息级别日志(白色),用于输出普通提示信息
    public function Info(string msg) {
        logger_msg = msg;
        logger_level = 2;
        logger_p = GetLocalPlayer();
		TriggerEvaluate(logger_tr);
    }
    // 警告级别日志(黄色),用于输出警告信息
    public function Warn(string msg) {
        logger_msg = msg;
        logger_level = 3;
        logger_p = GetLocalPlayer();
		TriggerEvaluate(logger_tr);
    }
    // 错误级别日志(红色),用于输出错误信息
    public function Error(string msg) {
        logger_msg = msg;
        logger_level = 4;
        logger_p = GetLocalPlayer();
		TriggerEvaluate(logger_tr);
    }
    // 向指定玩家输出追踪日志(灰色)
    public function TraceToPlayer(player p, string msg) {
        logger_msg = msg;
        logger_level = 0;
        logger_p = p;
		TriggerEvaluate(logger_tr);
    }
    // 向指定玩家输出调试日志(绿色)
    public function DebugToPlayer(player p, string msg) {
        logger_msg = msg;
        logger_level = 1;
        logger_p = p;
		TriggerEvaluate(logger_tr);
    }
    // 向指定玩家输出信息日志(白色)
    public function InfoToPlayer(player p, string msg) {
        logger_msg = msg;
        logger_level = 2;
        logger_p = p;
		TriggerEvaluate(logger_tr);
    }
    // 向指定玩家输出警告日志(黄色)
    public function WarnToPlayer(player p, string msg) {
        logger_msg = msg;
        logger_level = 3;
        logger_p = p;
		TriggerEvaluate(logger_tr);
    }
    // 向指定玩家输出错误日志(红色)
    public function ErrorToPlayer(player p, string msg) {
        logger_msg = msg;
        logger_level = 4;
        logger_p = p;
		TriggerEvaluate(logger_tr);
    }
    function onInit() {
        Cheat("exec-lua:depends.debug.logger"); //日志打印系统初始化
}
}
//! endzinc
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
/*
UI哈希表定义
*/
// 0 - 1亿这里用
// 锚点常量
// 事件常量
//鼠标点击事件
//Index名:
//默认原生图片路径
//模板名
//TEXT对齐常量:(uiText.setAlign)
//! zinc
/*
结构体
硬件事件(按/滑/帧事件)
*/
library Hardware requires BzAPI {
	public struct hardware []{
		// 注册一个左键抬起事件
		static method regLeftUpEvent (code func) {
			DzTriggerRegisterMouseEventByCode(null,1,0,false,func);
		}
		// 注册一个左键按下事件
		static method regLeftDownEvent (code func) {
			DzTriggerRegisterMouseEventByCode(null,1,1,false,func);
		}
		// 注册一个右键按下事件
		static method regRightDownEvent (code func) {
			DzTriggerRegisterMouseEventByCode(null,2,1,false,func);
		}
		// 注册一个右键抬起事件
		static method regRightUpEvent (code func) {
			DzTriggerRegisterMouseEventByCode(null,2,0,false,func);
		}
		// 注册一个滚轮事件,不能异步注册
		static method regWheelEvent (code func) {
			if (trWheel == null) {trWheel = CreateTrigger();}
			TriggerAddCondition(trWheel, Condition(func));
		}
		// 注册一个绘制事件,不能异步注册
		static method regUpdateEvent (code func) {
			if (trUpdate == null) {trUpdate = CreateTrigger();}
			TriggerAddCondition(trUpdate, Condition(func));
		}
		// 注册一个窗口变化事件,不能异步注册
		static method regResizeEvent (code func) {
			if (trResize == null) {trResize = CreateTrigger();}
			TriggerAddCondition(trResize, Condition(func));
		}
		// 注册一个鼠标移动事件,不能异步注册
		static method regMoveEvent (code func) {
			BJDebugMsg("注册鼠标移动事件");
			if (trMove == null) {trMove = CreateTrigger();}
			TriggerAddCondition(trMove, Condition(func));
		}
		// 获取鼠标的实数坐标X(0-0.8)
		static method getMouseX () -> real {
			integer width = DzGetClientWidth();
			if (width > 0) return DzGetMouseXRelative()* 0.8 / width;
			else return 0.1;
		}
		// 获取鼠标的实数坐标Y(0-0.6)
		static method getMouseY () -> real {
			integer height = DzGetClientHeight();
			if (height > 0) return 0.6 - DzGetMouseYRelative()* 0.6 / height;
			else return 0.1; // 防止除以0
}
		private {
			static trigger trWheel = null;
			static trigger trUpdate = null;
			static trigger trResize = null;
			static trigger trMove = null;
		}
		static method onInit () {
			// 滚轮事件
			DzTriggerRegisterMouseWheelEventByCode(null,false,function (){
				TriggerEvaluate(trWheel);
			});
			// 帧绘制事件
			DzFrameSetUpdateCallbackByCode(function (){
				TriggerEvaluate(trUpdate);
			});
			// 窗口大小变化事件
			DzTriggerRegisterWindowResizeEventByCode(null, false, function (){
				 TriggerEvaluate(trResize);
			});
			// 鼠标移动事件
			DzTriggerRegisterMouseMoveEventByCode(null, false, function (){
				 TriggerEvaluate(trMove);
			});
		}
	}
}
//! endzinc
//! zinc
/*
原生Lua引擎非内置
*/
// https://create.reckfeng.com/kkapidoc/#/menu_kkapi_japi kkapi的japi文档
library YDLua {
    // main 函数就初始化的
    public function initializeLua () -> integer {
        Cheat("exec-lua:plugin_main");
        return 0;
    }
    function onInit () {
        //在游戏开始0.0秒后再调用
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEvent(tr, 0.0, false);
        TriggerAddCondition(tr,Condition(function (){
            BJDebugMsg("调用了YDLua引擎");
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;
    }
}
//! endzinc
library BzAPI
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
    
endlibrary
library LBKKAPI 
        globals 
                string MOVE_TYPE_NONE = "none" //没有（无视碰撞）  
string MOVE_TYPE_FOOT = "foot" //步行  
string MOVE_TYPE_HORSE = "horse" //骑马  
string MOVE_TYPE_FLY = "fly" //飞行（还具有空中视野，也可以设置飞行高度）  
string MOVE_TYPE_HOVER = "hover" //浮空（不会踩中地雷）  
string MOVE_TYPE_FLOAT = "float" //漂浮（只能在深水里活动）  
string MOVE_TYPE_AMPH = "amph" //两栖  
string MOVE_TYPE_UNBUILD = "unbuild" //不可建造  
constant integer DEFENSE_TYPE_LIGHT = 0 
		constant integer DEFENSE_TYPE_MEDIUM = 1 
		constant integer DEFENSE_TYPE_LARGE = 2 
		constant integer DEFENSE_TYPE_FORT = 3 
		constant integer DEFENSE_TYPE_NORMAL = 4 
		constant integer DEFENSE_TYPE_HERO = 5 
		constant integer DEFENSE_TYPE_DIVINE = 6 
		constant integer DEFENSE_TYPE_NONE = 7 
        endglobals 
        native DzGetSelectedLeaderUnit takes nothing returns unit 
        native DzIsChatBoxOpen takes nothing returns boolean 
        native DzSetUnitPreselectUIVisible takes unit whichUnit, boolean visible returns nothing 
        native DzSetEffectAnimation takes effect whichEffect, integer index, integer flag returns nothing 
        native DzSetEffectPos takes effect whichEffect, real x, real y, real z returns nothing 
        native DzSetEffectVertexColor takes effect whichEffect, integer color returns nothing 
        native DzSetEffectVertexAlpha takes effect whichEffect, integer alpha returns nothing 
        native DzSetEffectModel takes effect whichEffect, string model returns nothing
        native DzSetEffectTeamColor takes effect whichHandle, integer playerId returns nothing
        native DzFrameSetClip takes integer whichframe, boolean enable returns nothing 
        native DzChangeWindowSize takes integer width, integer height returns boolean 
        native DzPlayEffectAnimation takes effect whichEffect, string anim, string link returns nothing 
        native DzBindEffect takes widget parent, string attachPoint, effect whichEffect returns nothing 
        native DzUnbindEffect takes effect whichEffect returns nothing 
        native DzSetWidgetSpriteScale takes widget whichUnit, real scale returns nothing 
        native DzSetEffectScale takes effect whichHandle, real scale returns nothing 
        native DzGetEffectVertexColor takes effect whichEffect returns integer 
        native DzGetEffectVertexAlpha takes effect whichEffect returns integer 
        native DzGetItemAbility takes item whichEffect, integer index returns ability 
        native DzFrameGetChildrenCount takes integer whichframe returns integer 
        native DzFrameGetChild takes integer whichframe, integer index returns integer 
        native DzUnlockBlpSizeLimit takes boolean enable returns nothing 
        native DzGetActivePatron takes unit store, player p returns unit 
        native DzGetLocalSelectUnitCount takes nothing returns integer 
        native DzGetLocalSelectUnit takes integer index returns unit 
        native DzGetJassStringTableCount takes nothing returns integer 
        native DzModelRemoveFromCache takes string path returns nothing 
        native DzModelRemoveAllFromCache takes nothing returns nothing 
        native DzFrameGetInfoPanelSelectButton takes integer index returns integer 
        native DzFrameGetInfoPanelBuffButton takes integer index returns integer 
        native DzFrameGetPeonBar takes nothing returns integer 
        native DzFrameGetCommandBarButtonNumberText takes integer whichframe returns integer 
        native DzFrameGetCommandBarButtonNumberOverlay takes integer whichframe returns integer 
        native DzFrameGetCommandBarButtonCooldownIndicator takes integer whichframe returns integer 
        native DzFrameGetCommandBarButtonAutoCastIndicator takes integer whichframe returns integer 
        native DzToggleFPS takes boolean show returns nothing 
        native DzGetFPS takes nothing returns integer 
        native DzFrameWorldToMinimapPosX takes real x, real y returns real 
        native DzFrameWorldToMinimapPosY takes real x, real y returns real 
        native DzWidgetSetMinimapIcon takes unit whichunit, string path returns nothing 
        native DzWidgetSetMinimapIconEnable takes unit whichunit, boolean enable returns nothing 
        native DzFrameGetWorldFrameMessage takes nothing returns integer 
        native DzSimpleMessageFrameAddMessage takes integer whichframe, string text, integer color, real duration, boolean permanent returns nothing 
        native DzSimpleMessageFrameClear takes integer whichframe returns nothing 
        //转换屏幕坐标到世界坐标  
        native DzConvertScreenPositionX takes real x, real y returns real 
        native DzConvertScreenPositionY takes real x, real y returns real 
        //监听建筑选位置  
        native DzRegisterOnBuildLocal takes code func returns nothing 
        //等于0时是结束事件  
        native DzGetOnBuildOrderId takes nothing returns integer 
        native DzGetOnBuildOrderType takes nothing returns integer 
        native DzGetOnBuildAgent takes nothing returns widget 
        //监听技能选目标  
        native DzRegisterOnTargetLocal takes code func returns nothing 
        //等于0时是结束事件  
        native DzGetOnTargetAbilId takes nothing returns integer 
        native DzGetOnTargetOrderId takes nothing returns integer 
        native DzGetOnTargetOrderType takes nothing returns integer 
        native DzGetOnTargetAgent takes nothing returns widget 
        native DzGetOnTargetInstantTarget takes nothing returns widget 
        // 打开QQ群链接  
        native DzOpenQQGroupUrl takes string url returns boolean 
        native DzFrameEnableClipRect takes boolean enable returns nothing 
        native DzSetUnitName takes unit whichUnit, string name returns nothing 
        native DzSetUnitPortrait takes unit whichUnit, string modelFile returns nothing 
        native DzSetUnitDescription takes unit whichUnit, string value returns nothing 
        native DzSetUnitMissileArc takes unit whichUnit, real arc returns nothing 
        native DzSetUnitMissileModel takes unit whichUnit, string modelFile returns nothing 
        native DzSetUnitProperName takes unit whichUnit, string name returns nothing 
        native DzSetUnitMissileHoming takes unit whichUnit, boolean enable returns nothing 
        native DzSetUnitMissileSpeed takes unit whichUnit, real speed returns nothing 
        native DzSetEffectVisible takes effect whichHandle, boolean enable returns nothing 
        native DzReviveUnit takes unit whichUnit, player whichPlayer, real hp, real mp, real x, real y returns nothing 
        native DzGetAttackAbility takes unit whichUnit returns ability 
        native DzAttackAbilityEndCooldown takes ability whichHandle returns nothing 
        native EXSetUnitArrayString takes integer uid, integer id, integer n, string name returns boolean 
        native EXSetUnitInteger takes integer uid, integer id, integer n returns boolean 
        function DzSetHeroTypeProperName takes integer uid, string name returns nothing 
                call EXSetUnitArrayString(uid, 61, 0, name) 
                call EXSetUnitInteger(uid, 61, 1) 
        endfunction 
        function DzSetUnitTypeName takes integer uid, string name returns nothing 
                call EXSetUnitArrayString(uid, 10, 0, name) 
                call EXSetUnitInteger(uid, 10, 1) 
        endfunction 
        function DzIsUnitAttackType takes unit whichUnit, integer index, attacktype attackType returns boolean 
                return ConvertAttackType(R2I(GetUnitState(whichUnit, ConvertUnitState(16 + 19 * index)))) == attackType 
        endfunction 
        function DzSetUnitAttackType takes unit whichUnit, integer index, attacktype attackType returns nothing 
                call SetUnitState(whichUnit, ConvertUnitState(16 + 19 * index), GetHandleId(attackType)) 
        endfunction 
        function DzIsUnitDefenseType takes unit whichUnit, integer defenseType returns boolean 
                return R2I(GetUnitState(whichUnit, ConvertUnitState(0x50))) == defenseType 
        endfunction 
        function DzSetUnitDefenseType takes unit whichUnit, integer defenseType returns nothing 
                call SetUnitState(whichUnit, ConvertUnitState(0x50), defenseType) 
        endfunction 
        // 地形装饰物
        native DzDoodadCreate takes integer id, integer var, real x, real y, real z, real rotate, real scale returns integer 
        native DzDoodadGetTypeId takes integer doodad returns integer 
        native DzDoodadSetModel takes integer doodad, string modelFile returns nothing 
        native DzDoodadSetTeamColor takes integer doodad, integer color returns nothing 
        native DzDoodadSetColor takes integer doodad, integer color returns nothing 
        native DzDoodadGetX takes integer doodad returns real 
        native DzDoodadGetY takes integer doodad returns real 
        native DzDoodadGetZ takes integer doodad returns real 
        native DzDoodadSetPosition takes integer doodad, real x, real y, real z returns nothing 
        native DzDoodadSetOrientMatrixRotate takes integer doodad, real angle, real axisX, real axisY, real axisZ returns nothing 
        native DzDoodadSetOrientMatrixScale takes integer doodad, real x, real y, real z returns nothing 
        native DzDoodadSetOrientMatrixResize takes integer doodad returns nothing 
        native DzDoodadSetVisible takes integer doodad, boolean enable returns nothing 
        native DzDoodadSetAnimation takes integer doodad, string animName, boolean animRandom returns nothing 
        native DzDoodadSetTimeScale takes integer doodad, real scale returns nothing 
        native DzDoodadGetTimeScale takes integer doodad returns real 
        native DzDoodadGetCurrentAnimationIndex takes integer doodad returns integer 
        native DzDoodadGetAnimationCount takes integer doodad returns integer 
        native DzDoodadGetAnimationName takes integer doodad, integer index returns string 
        native DzDoodadGetAnimationTime takes integer doodad, integer index returns integer 
        // 解锁JASS字节码限制
        native DzUnlockOpCodeLimit takes boolean enable returns nothing
        // 设置剪切板内容
        native DzSetClipboard takes string content returns boolean
        //删除装饰物
        native DzDoodadRemove takes integer doodad returns nothing
        //移除科技等级
        native DzRemovePlayerTechResearched takes player whichPlayer, integer techid, integer removelevels returns nothing
        
        // 查找单位技能
        native DzUnitFindAbility takes unit whichUnit, integer abilcode returns ability
        // 修改技能数据-字符串
        native DzAbilitySetStringData takes ability whichAbility, string key, string value returns nothing
                
        // 启用/禁用技能
        native DzAbilitySetEnable takes ability whichAbility, boolean enable, boolean hideUI returns nothing
        // 设置单位移动类型
        native DzUnitSetMoveType takes unit whichUnit, string moveType returns nothing
        // 获取控件宽度
        native DzFrameGetWidth takes integer frame returns real
        native DzFrameSetAnimateByIndex takes integer frame, integer index, integer flag returns nothing
        native DzSetUnitDataCacheInteger takes integer uid, integer id,integer index,integer v returns nothing
        native DzUnitUIAddLevelArrayInteger takes integer uid, integer id,integer lv,integer v returns nothing
        function KKWESetUnitDataCacheInteger takes integer uid,integer id,integer v returns nothing
                call DzSetUnitDataCacheInteger( uid, id, 0, v)
        endfunction
        function KKWEUnitUIAddUpgradesIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 94, id, v)
        endfunction
        function KKWEUnitUIAddBuildsIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 100, id, v)
        endfunction
        function KKWEUnitUIAddResearchesIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 112, id, v)
        endfunction
        function KKWEUnitUIAddTrainsIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 106, id, v)
        endfunction
        function KKWEUnitUIAddSellsUnitIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 118, id, v)
        endfunction
        function KKWEUnitUIAddSellsItemIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 124, id, v)
        endfunction
        function KKWEUnitUIAddMakesItemIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 130, id, v)
        endfunction
        function KKWEUnitUIAddRequiresUnitCode takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 166, id, v)
        endfunction
        function KKWEUnitUIAddRequiresTechcode takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 166, id, v)
        endfunction
        function KKWEUnitUIAddRequiresAmounts takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 172, id, v)
        endfunction
         // 设置道具模型
        native DzItemSetModel takes item whichItem, string file returns nothing
        // 设置道具颜色
        native DzItemSetVertexColor takes item whichItem, integer color returns nothing
        // 设置道具透明度
        native DzItemSetAlpha takes item whichItem, integer color returns nothing
        // 设置道具头像
        native DzItemSetPortrait takes item whichItem, string modelPath returns nothing
endlibrary
// [DzSetUnitMoveType]  
// title = "设置单位移动类型[NEW]"  
// description = "设置 ${单位} 的移动类型：${movetype} "  
// comment = ""  
// category = TC_KKPRE  
// [[.args]]  
// type = unit  
// [[.args]]  
// type = MoveTypeName  
// default = MoveTypeName01  
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
* s5 - 测试随机创建和删除
* s6 - 测试单位销毁时的清理
*
* -a [unitId] - 创建指定ID的测试单位
* -b [spellId] - 为当前选中单位添加指定技能
*/
library UTUnitSpell requires UnitSpell {
	private unit testUnit = null;
	private unitSpell us = 0;
	private boolean toggle5 = false;
	function Init() {
		// 测试1: parse创建
		spellData sd = spellData.byType('AHbz');
		sd = spellData.byType('AHtb');
		sd = spellData.byType('AHtc');
		sd = spellData.byType('AHmt');
		sd = spellData.byType('AHfs');
		UnitTestAutoTimer(0.1, 0, function() {
			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			us = unitSpell.parse(testUnit);
			Trace("测试1: unitSpell.parse创建");
			assert.Boolean(us != 0, "单位是否有效");
			assert.Boolean(us.u == testUnit, "绑定单位是否正确");
		}, null);
		// 测试2: get获取
		UnitTestAutoTimer(0.6 ,0, function() {
			unitSpell us2;
			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			us = unitSpell.parse(testUnit);
			us2 = unitSpell.get(testUnit);
			Trace("测试2: unitSpell.get获取");
			assert.Boolean(us == us2, "获取实例是否相同");
		}, null);
		// 测试3: addSpell和getSpell
		UnitTestAutoTimer(1.1 ,0, function() {
			spell sp;
			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			us = unitSpell.parse(testUnit);
			sp = spell.entity(testUnit, 'AHbz', 1);
			us.addSpell(sp);
			Trace("测试3: addSpell和getSpell");
			assert.Boolean(us.getSpell(0) == sp, "获取技能是否正确");
		}, null);
		// 测试4: getSpellCount
		UnitTestAutoTimer(1.6 ,0, function() {
			spell sp;
			integer countBefore;
			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			us = unitSpell.parse(testUnit);
			sp = spell.entity(testUnit, 'AHbz', 1);
			countBefore = us.getSpellCount();
			us.addSpell(sp);
			Trace("测试4: getSpellCount");
			assert.Boolean(us.getSpellCount() == countBefore + 1, "技能数量是否正确");
		}, null);
		// 测试6: 单位销毁清理
		UnitTestAutoTimer(2.1 ,0, function() {
			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			us = unitSpell.parse(testUnit);
			Trace("测试6: 单位销毁清理");
			assert.Boolean(us.isExist(), "销毁前unitSpell存在");
			RemoveUnit(testUnit);
			assert.Boolean(!us.isExist(), "销毁后unitSpell不存在");
			testUnit = null;
		}, null);
		// 测试7: 技能添加删除测试
		UnitTestAutoTimer(2.6, 0, function() {
			integer spellIds[]; // 不同的技能ID
integer i = 0;
			boolean removeResult = false;
			spell invalidSpell = 0;
			spellData sd = 0;
			spellIds[0] = 'AHbz';
			spellIds[1] = 'AHtb';
			spellIds[2] = 'AHtc';
			spellIds[3] = 'AHmt';
			spellIds[4] = 'AHfs';
			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			us = unitSpell.parse(testUnit);
			// 添加5个不同的技能
			for (0 <= i < 5) {
				sd = spellData.byType(spellIds[i]);
				us.addSpellData(sd, 1);
			}
			// 测试技能数量
			assert.Integer(us.getSpellCount(), 5, "添加5个技能后数量是否为5");
			// 测试删除不存在的技能
			removeResult = us.removeSpell(invalidSpell);
			assert.Boolean(!removeResult, "删除不存在的技能应该返回false");
			// 逐个删除技能并检查数量
			for (0 <= i < 5) {
				sd = spellData.byType(spellIds[i]);
				removeResult = us.removeSpellData(sd);
				assert.Boolean(removeResult, "删除第" + I2S(i + 1) + "个技能应该成功");
				assert.Integer(us.getSpellCount(), 4 - i, "删除后技能数量应该为" + I2S(4 - i));
			}
			// 最终检查
			assert.Integer(us.getSpellCount(), 0, "删除所有技能后数量应该为0");
		}, null);
		// 测试8: 重复添加技能测试
		UnitTestAutoTimer(3.1, 0, function() {
			spell sp1, sp2;
			spellData sd;
			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			us = unitSpell.parse(testUnit);
			// 测试重复添加相同的spell实例
			sp1 = spell.entity(testUnit, 'AHbz', 1);
			assert.Boolean(us.addSpell(sp1) == sp1, "首次添加技能实例应该成功");
			assert.Boolean(us.addSpell(sp1) == 0, "重复添加相同技能实例应该失败");
			assert.Integer(us.getSpellCount(), 1, "重复添加后技能数量应该为1");
			// 测试重复添加相同的spellData
			sd = spellData.byType('AHtb');
			assert.Boolean(us.addSpellData(sd, 1), "首次通过spellData添加技能应该成功");
			assert.Boolean(us.addSpellData(sd, 1), "重复添加相同spellData应该失败");
			assert.Integer(us.getSpellCount(), 2, "重复添加后技能数量应该为2");
		}, null);
	}
	// 测试用例函数保持空实现
	function TTestUTUnitSpell1(player p) {}
	function TTestUTUnitSpell2(player p) {}
	function TTestUTUnitSpell3(player p) {}
	function TTestUTUnitSpell4(player p) {}
	// 只保留测试5的实现，因为它是交互式的随机创建删除测试
	function TTestUTUnitSpell5(player p) {
		integer i;
		integer count;
		unit u;
		group g;
		unitSpell tempUs;
		if (toggle5) {
			// 删除模式：遍历所有单位并删除技能实例
			g = CreateGroup();
			GroupEnumUnitsInRect(g, bj_mapInitialPlayableArea, null);
			ForGroup(g, function() {
				unit u = GetEnumUnit();
				unitSpell tempUs = unitSpell.get(u);
				if (tempUs != 0) {
					tempUs.destroy();
					Trace("删除了单位 " + GetUnitName(u) + " 的技能实例");
				}
				u = null;
			});
			DestroyGroup(g);
			g = null;
			Trace("已清理所有技能实例");
		} else {
			// 创建模式：随机创建10-20个带技能的单位
			count = GetRandomInt(10, 20);
			Trace("准备创建 " + I2S(count) + " 个测试单位");
			for (0 <= i < count) {
				u = CreateUnit(p, 'hfoo',
				GetRandomReal(-1000, 1000),
				GetRandomReal(-1000, 1000),
				GetRandomReal(0, 360));
				tempUs = unitSpell.parse(u);
				if (tempUs != 0) {
					Trace("创建第 " + I2S(i + 1) + " 个单位的技能实例成功");
				}
				u = null;
			}
			Trace("完成创建测试单位");
		}
		toggle5 = !toggle5;
	}
	function TTestUTUnitSpell6(player p) {}
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
			if (testUnit != null) {
				RemoveUnit(testUnit);
			}
			testUnit = CreateUnit(p, paramI[1], 0, 0, 0);
			us = unitSpell.parse(testUnit);
			Trace("创建测试单位: " + I2S(paramI[1]));
		} else if (paramS[0] == "b") {
			selectedUnit = unitSelect.currentU[index];
			if (selectedUnit != null) {
				us = unitSpell.get(selectedUnit);
				if (us != 0) {
					us.addSpell(spell.entity(selectedUnit, paramI[1], 1));
					Trace("添加技能: " + I2S(paramI[1]));
				}
			}
		}
		p = null;
	}
	function onInit() {
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEvent(tr, 0.5, false);
		TriggerAddCondition(tr, Condition(function() {
			Trace("[UnitSpell] 单元测试已加载");
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
    call initializeLua() <?='\n'?> call SetCameraBounds( -13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM) )
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
