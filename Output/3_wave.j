//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerSelectionEventBJ.h>
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerKeyEventBJ.h>
//#  define TriggerRegisterPlayerUnitEventSimple(trig, p, e)                 TriggerRegisterPlayerUnitEvent(trig, p, e, null)
//#  define TriggerRegisterPlayerEventVictory(trig, player)                  TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_VICTORY)
//#  define TriggerRegisterPlayerEventDefeat(trig, player)                   TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_DEFEAT)
//#  define TriggerRegisterPlayerEventLeave(trig, player)                    TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_LEAVE)
//#  define TriggerRegisterPlayerEventAllianceChanged(trig, player)          TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_ALLIANCE_CHANGED)
//#  define TriggerRegisterPlayerEventEndCinematic(trig, player)             TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_END_CINEMATIC)
/*
单位哈希表定义
*/
//! zinc
/*
单位哈希表
*/
library UnitHashTable {
    public hashtable HASH_UNIT = InitHashtable(); // 单位哈希表

}
//! endzinc
/*
 * 初始化单位属性宏定义
 * 用法:
 * INIT_UNIT_ATTR(HP) 会初始化HP相关的所有属性为0
 */
/*
 * 单位属性系统宏定义
 * 用法:
 * DEFINE_UNIT_ATTR(HP) 会生成HP相关的所有属性和方法
 * DEFINE_UNIT_ATTR(MP) 会生成MP相关的所有属性和方法
 *
 * 参数说明:
 * ATTR: 属性名(大写), 如HP, MP
 */
/*
 * 战斗属性系统宏定义(适用于攻击力、防御力等带固定加成的属性)
 * 用法:
 * DEFINE_COMBAT_ATTR(Atk) 会生成攻击力相关的所有属性和方法
 * DEFINE_COMBAT_ATTR(Def) 会生成防御力相关的所有属性和方法
 */
/*
 * 百分比属性系统宏定义(适用于技能伤害增幅、治疗效果等纯百分比属性)
 * 用法:
 * DEFINE_PERCENTAGE_ATTR(SpellDmg) 会生成技能伤害加成相关的所有属性和方法
 * DEFINE_PERCENTAGE_ATTR(Heal) 会生成治疗效果加成相关的所有属性和方法
 *
 * 参数说明:
 * ATTR: 属性名, 如SpellDmg(技能伤害), Heal(治疗效果)
 * up: 表示提升百分比(例如+20%表示为0.2)
 * down: 表示降低百分比(例如-30%表示为0.3)
 */
/*
 * 初始化百分比属性宏定义
 */
/*
 * 初始化战斗属性宏定义
 */
// 结构体共用方法定义
//共享打印方法
// UI组件内部共享方法及成员
// UI组件依赖库
// UI组件创建时共享调用
// UI组件销毁时共享调用
/*

japi引用的常量库 由于wave宏定义 只对以下的代码有效

请将常量库里所有内容复制到  自定义脚本代码区
*/
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
//! zinc
/*
单位的属性
*/
library UnitAttr requires UnitUtils,MathUtils,UnitLifeCycle {
	public struct unitAttr {
		method isExist () -> boolean {return (this != null && si__unitAttr_V[this] == -1);}
		unit u; //绑定的单位

		static method parse (unit u) -> thistype {
			thistype this;
			integer handleId = GetHandleId(u);
			// 先检查是否已存在
			if (HaveSavedInteger(HASH_UNIT, handleId, 1726)) {
				return LoadInteger(HASH_UNIT, handleId, 1726);
			}
			// 不存在才创建新的
			this = allocate();
			this.u = u;
			this.baseHP = 0; <?='\n'?> this.HPRateUp = 0; <?='\n'?> this.HPRateDown = 0; <?='\n'?> this.cachedHP = 0; <?='\n'?>
			this.baseMP = 0; <?='\n'?> this.MPRateUp = 0; <?='\n'?> this.MPRateDown = 0; <?='\n'?> this.cachedMP = 0; <?='\n'?>
			// 初始化攻击力和防御力相关属性
			this.baseAtk = 0.0; <?='\n'?> this.AtkRateUp = 0.0; <?='\n'?> this.AtkRateDown = 0.0; <?='\n'?> this.AtkRateBonus = 0.0; <?='\n'?> this.AtkFixedBonus = 0.0; <?='\n'?>
			this.baseDef = 0.0; <?='\n'?> this.DefRateUp = 0.0; <?='\n'?> this.DefRateDown = 0.0; <?='\n'?> this.DefRateBonus = 0.0; <?='\n'?> this.DefFixedBonus = 0.0; <?='\n'?>
			// 初始化技能伤害增幅
			this.SpellDmgRateUp = 0.0; <?='\n'?> this.SpellDmgRateDown = 0.0; <?='\n'?>
			SaveInteger(HASH_UNIT, handleId, 1726, this);
			return this;
		}
		//同步并刷新当前单位的HP
		private method syncHPRate() {
			real desiredHP;
			real diff;
			//计算期望的HP值 - 先计算增幅,再计算减幅
			desiredHP = baseHP * (1.0 + HPRateUp) * (1.0 - HPRateDown);
			//计算差值
			diff = desiredHP - cachedHP;
			//只有当差值的绝对值大于等于1时才更新
			if (diff >= 1.0 || diff <= -1.0) {
				//设置最大值
				SetUnitState(u, UNIT_STATE_MAX_LIFE, RMaxBJ(desiredHP, 2.0));
				//如果是增加值，同时增加当前值
				if (diff > 0) {
					SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_LIFE) + diff);
				}
				cachedHP = desiredHP;
			}
		}
		//同步并刷新当前单位的MP
		private method syncMPRate() {
			real desiredMP;
			real diff;
			//计算期望的MP值 - 先计算增幅,再计算减幅
			desiredMP = baseMP * (1.0 + MPRateUp) * (1.0 - MPRateDown);
			//计算差值
			diff = desiredMP - cachedMP;
			//只有当差值的绝对值大于等于1时才更新
			if (diff >= 1.0 || diff <= -1.0) {
				//设置最大值
				SetUnitState(u, UNIT_STATE_MAX_MANA, RMaxBJ(desiredMP, 2.0));
				//如果是增加值，同时增加当前值
				if (diff > 0) {
					SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MANA) + diff);
				}
				cachedMP = desiredMP;
			}
		}
		// 同步并刷新当前单位的攻击
		private method syncAtkRate() {
			AtkRateBonus = baseAtk * (1.0 + AtkRateUp) * (1.0 - AtkRateDown) - baseAtk;
			SetUnitState(u, ConvertUnitState(0x12), RMaxBJ(baseAtk + AtkRateBonus + AtkFixedBonus, 0.0));
		}
		// 同步并刷新当前单位的防御
		private method syncDefRate() {
			DefRateBonus = baseDef * (1.0 + DefRateUp) * (1.0 - DefRateDown) - baseDef;
			SetUnitState(u, ConvertUnitState(0x20), baseDef + DefRateBonus + DefFixedBonus);
		}
		// 使用宏定义生成HP相关属性和方法
		public real baseHP; /* 基础ATTR值 */<?='\n'?> public real HPRateUp; /* ATTR增幅比例 */<?='\n'?> public real HPRateDown; /* ATTR减幅比例 */<?='\n'?> private real cachedHP; /* 缓存的实际ATTR值 */<?='\n'?> <?='\n'?> /* 增加或减少基础ATTR */<?='\n'?> public method addHP(real value) { <?='\n'?> if (value != 0) { <?='\n'?> baseHP += value; <?='\n'?> syncHPRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加ATTR增幅比例 */<?='\n'?> public method addHPRateUp(real value) { <?='\n'?> if (value != 0) { <?='\n'?> HPRateUp += value; <?='\n'?> syncHPRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加ATTR减幅比例 */<?='\n'?> public method addHPRateDown(real value) { <?='\n'?> if (value != 0) { <?='\n'?> HPRateDown = RealAdd(HPRateDown, value); <?='\n'?> syncHPRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 获取当前的ATTR倍率 */<?='\n'?> public method getCurrentHPRate() -> real { <?='\n'?> return (1.0 + HPRateUp) * (1.0 - HPRateDown) - 1.0; <?='\n'?> } <?='\n'?> <?='\n'?> /* 获取当前实际ATTR值 */<?='\n'?> public method getCurrentHP() -> real { <?='\n'?> return cachedHP; <?='\n'?> } <?='\n'?>
		// 使用宏定义生成MP相关属性和方法
		public real baseMP; /* 基础ATTR值 */<?='\n'?> public real MPRateUp; /* ATTR增幅比例 */<?='\n'?> public real MPRateDown; /* ATTR减幅比例 */<?='\n'?> private real cachedMP; /* 缓存的实际ATTR值 */<?='\n'?> <?='\n'?> /* 增加或减少基础ATTR */<?='\n'?> public method addMP(real value) { <?='\n'?> if (value != 0) { <?='\n'?> baseMP += value; <?='\n'?> syncMPRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加ATTR增幅比例 */<?='\n'?> public method addMPRateUp(real value) { <?='\n'?> if (value != 0) { <?='\n'?> MPRateUp += value; <?='\n'?> syncMPRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加ATTR减幅比例 */<?='\n'?> public method addMPRateDown(real value) { <?='\n'?> if (value != 0) { <?='\n'?> MPRateDown = RealAdd(MPRateDown, value); <?='\n'?> syncMPRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 获取当前的ATTR倍率 */<?='\n'?> public method getCurrentMPRate() -> real { <?='\n'?> return (1.0 + MPRateUp) * (1.0 - MPRateDown) - 1.0; <?='\n'?> } <?='\n'?> <?='\n'?> /* 获取当前实际ATTR值 */<?='\n'?> public method getCurrentMP() -> real { <?='\n'?> return cachedMP; <?='\n'?> } <?='\n'?>
		// 使用宏定义生成攻击力相关属性和方法
		<?='\n'?> public real baseAtk; /* 基础ATTR值 */<?='\n'?> public real AtkRateUp; /* ATTR增幅比例 */<?='\n'?> public real AtkRateDown; /* ATTR减幅比例 */<?='\n'?> public real AtkRateBonus; /* 受增减幅影响的bonus值 */<?='\n'?> public real AtkFixedBonus;/* 固定加成值(不受增减幅影响) */<?='\n'?> <?='\n'?> /* 设置基础ATTR */<?='\n'?> public method setBaseAtk(real value) { <?='\n'?> if (baseAtk != value) { <?='\n'?> baseAtk = value; <?='\n'?> syncAtkRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加基础ATTR */<?='\n'?> public method addBaseAtk(real value) { <?='\n'?> if (value != 0) { <?='\n'?> baseAtk += value; <?='\n'?> syncAtkRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加固定bonus */<?='\n'?> public method addAtkFixedBonus(real value) { <?='\n'?> if (value != 0) { <?='\n'?> AtkFixedBonus += value; <?='\n'?> syncAtkRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加ATTR增幅 */<?='\n'?> public method addAtkRateUp(real value) { <?='\n'?> if (value != 0) { <?='\n'?> AtkRateUp += value; <?='\n'?> syncAtkRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加ATTR减幅 */<?='\n'?> public method addAtkRateDown(real value) { <?='\n'?> if (value != 0) { <?='\n'?> AtkRateDown = RealAdd(AtkRateDown, value); <?='\n'?> syncAtkRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 获取当前总ATTR */<?='\n'?> public method getCurrentAtk() -> real { <?='\n'?> return baseAtk + AtkRateBonus + AtkFixedBonus; <?='\n'?> } <?='\n'?> <?='\n'?> /* 获取当前ATTR倍率 */<?='\n'?> public method getCurrentAtkRate() -> real { <?='\n'?> return (1.0 + AtkRateUp) * (1.0 - AtkRateDown) - 1.0; <?='\n'?> } <?='\n'?>
		// 使用宏定义生成防御力相关属性和方法
		<?='\n'?> public real baseDef; /* 基础ATTR值 */<?='\n'?> public real DefRateUp; /* ATTR增幅比例 */<?='\n'?> public real DefRateDown; /* ATTR减幅比例 */<?='\n'?> public real DefRateBonus; /* 受增减幅影响的bonus值 */<?='\n'?> public real DefFixedBonus;/* 固定加成值(不受增减幅影响) */<?='\n'?> <?='\n'?> /* 设置基础ATTR */<?='\n'?> public method setBaseDef(real value) { <?='\n'?> if (baseDef != value) { <?='\n'?> baseDef = value; <?='\n'?> syncDefRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加基础ATTR */<?='\n'?> public method addBaseDef(real value) { <?='\n'?> if (value != 0) { <?='\n'?> baseDef += value; <?='\n'?> syncDefRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加固定bonus */<?='\n'?> public method addDefFixedBonus(real value) { <?='\n'?> if (value != 0) { <?='\n'?> DefFixedBonus += value; <?='\n'?> syncDefRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加ATTR增幅 */<?='\n'?> public method addDefRateUp(real value) { <?='\n'?> if (value != 0) { <?='\n'?> DefRateUp += value; <?='\n'?> syncDefRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加ATTR减幅 */<?='\n'?> public method addDefRateDown(real value) { <?='\n'?> if (value != 0) { <?='\n'?> DefRateDown = RealAdd(DefRateDown, value); <?='\n'?> syncDefRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 获取当前总ATTR */<?='\n'?> public method getCurrentDef() -> real { <?='\n'?> return baseDef + DefRateBonus + DefFixedBonus; <?='\n'?> } <?='\n'?> <?='\n'?> /* 获取当前ATTR倍率 */<?='\n'?> public method getCurrentDefRate() -> real { <?='\n'?> return (1.0 + DefRateUp) * (1.0 - DefRateDown) - 1.0; <?='\n'?> } <?='\n'?>
		// 使用宏定义生成技能伤害增幅
		public real SpellDmgRateUp; /* ATTR增幅比例 */<?='\n'?> public real SpellDmgRateDown; /* ATTR减幅比例 */<?='\n'?> <?='\n'?> /* 增加ATTR增幅比例 */<?='\n'?> public method addSpellDmgRateUp(real value) { <?='\n'?> if (value != 0) { <?='\n'?> SpellDmgRateUp += value; <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加ATTR减幅比例 */<?='\n'?> public method addSpellDmgRateDown(real value) { <?='\n'?> if (value != 0) { <?='\n'?> SpellDmgRateDown = RealAdd(SpellDmgRateDown, value); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 获取当前的ATTR最终倍率 */<?='\n'?> public method getSpellDmgMultiplier() -> real { <?='\n'?> return (1.0 + SpellDmgRateUp) * (1.0 - SpellDmgRateDown) - 1.0; <?='\n'?> } <?='\n'?>
		//单位删除会调用
		method onDestroy () {
			if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),1726)) {
				RemoveSavedInteger(HASH_UNIT,GetHandleId(u),1726);
			}
			u = null;
		}
		//注册到周期结束中
		static method onInit () {
			unitLifeCycle.registerDestroy(function () {
				unit u = unitLifeCycle.argsUnit;
				thistype this = unitAttr.parse(u);
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
/*
* 数学工具库
* 作者：AI Assistant
*
* 提供了一些常用的数学函数，包括实数到整数的转换、除法、实数相加、值限制、四舍五入以及射线与地图边界的交点计算。
*/
library MathUtils {
    // 实转整 带概率进1的
    // 将实数转换为整数，若小数部分大于随机数则进1
    public function R2IRandom (real value) -> integer {
        if (GetRandomReal(0,1.0) <= ModuloReal(value,1.0)) {
            return R2I(value) + 1;
        }
        return R2I(value);
    }
    // 进行整数除法，若能整除则结果减1
    public function Divide1 (integer i1,integer i2) -> integer {
        if (ModuloInteger(i1,i2) == 0) {
            return i1/i2 - 1;
        }
        return i1/i2;
    }
    // 实现特殊的数值叠加计算，主要用于游戏中各种加成效果的叠加
    // 该函数可以避免简单线性相加导致的数值溢出，保证叠加后的效果符合递减收益原则
    //
    // 特点：
    // - 正数叠加时使用概率学公式：1-(1-a1)*(1-a2)
    // - 负数叠加时使用衰减公式：1-(1-a1)/(1+a2)
    // - 当第二个参数绝对值>=1.0时，直接返回第一个参数
    //
    // 适用场景：
    // - 技能冷却缩减叠加（CDR）
    // - 暴击率、闪避率等概率性属性叠加
    // - 移速加成等需要控制上限的属性叠加
    //
    // 参数说明：
    // a1: 第一个数值，通常表示当前已有的加成效果
    // a2: 第二个数值，表示要叠加的新加成效果
    // 返回值: 叠加后的最终效果值
    //
    // 使用示例：
    // real currentCDR = 0.4;    // 当前40%冷却缩减
    // real newCDR = 0.5;        // 新装备50%冷却缩减
    // real finalCDR = RealAdd(currentCDR, newCDR);  // 结果约为0.7，即70%冷却缩减
    //
    // 注意事项：
    // 1. 虽然函数支持任意实数输入，但建议输入值在[-1.0, 1.0]范围内
    // 2. 当|a2| >= 1.0时，函数会直接返回a1值
    // 3. 该函数满足结合律，但不满足交换律，建议将已有效果作为第一个参数
    // 4. 已测试过可以在用负数叠加后,使用负数的绝对值进行恢复
    public function RealAdd ( real a1,real a2 ) -> real {
        if (RAbsBJ(a2) >= 1.0) {return a1;}
        if (a2 >= 0) {return 1.0-(1.0-a1)*(1.0-a2);}
        else {return 1.0-(1.0-a1)/(1.0+a2);}
    }
    // 最小最大值限制
    // 限制整数在[min, max]范围内
    public function ILimit ( integer target,integer min,integer max ) -> integer {
        if (target < min) {return min;}
        else if (target > max) {return max;}
        else {return target;}
    }
    // 最小最大值限制
    // 限制实数在[min, max]范围内
    public function RLimit ( real target,real min,real max ) -> real {
        if (target < min) {return min;}
        else if (target > max) {return max;}
        else {return target;}
    }
    // 四舍五入法实数转整数
    // 将实数四舍五入为整数
    public function R2IM (real r) -> integer {
        if (ModuloReal(r,1.0) >= 0.5) return R2I(r)+1;
        else return R2I(r);
    }
    // 计算射线与地图边界的交点
    // 计算从给定点出发的射线与地图边界的交点
    public struct radiationEnd {
        static real x = 0,y = 0;
        // 一个坐标沿着某个方向的边缘值
        // 计算从点(x1,y1)出发，沿angle角度方向的射线与地图边界的交点
        static method cal (real x1,real y1,real angle) {
            real x2 = 0; //相交点
real y2 = 0; //相交点
real a = ModuloReal(angle,360); //求余数
real tan;
            x = 0;
            y = 0;
            // 处理特殊角度
            if (a == 0) { // 正右方
x = mapBounds.maxX;
                y = y1;
                return;
            }
            if (a == 90) { // 正上方
x = x1;
                y = mapBounds.maxY;
                return;
            }
            if (a == 180) { // 正左方
x = mapBounds.minX;
                y = y1;
                return;
            }
            if (a == 270) { // 正下方
x = x1;
                y = mapBounds.minY;
                return;
            }
            // 处理一般角度
            if (a < 90) { //第一象限
tan = Tan((a)*0.0174538);
                x2 = (mapBounds.maxY - y1) / tan + x1;
                y2 = (mapBounds.maxX - x1) * tan + y1;
                if (x2 <= mapBounds.maxX) { //取这个
x = x2;
                    y = mapBounds.maxY;
                } else {
                    x = mapBounds.maxX;
                    y = y2;
                }
            } else if(a < 180) { //第二象限
tan = Tan((a)*0.0174538);
                x2 = (mapBounds.maxY - y1) / tan + x1;
                y2 = (mapBounds.minX - x1) * tan + y1;
                if (x2 >= mapBounds.minX) { //取这个
x = x2;
                    y = mapBounds.maxY;
                } else {
                    x = mapBounds.minX;
                    y = y2;
                }
            } else if(a < 270) { //第三象限
tan = Tan((a)*0.0174538);
                x2 = (mapBounds.minY - y1) / tan + x1;
                y2 = (mapBounds.minX - x1) * tan + y1;
                if (x2 >= mapBounds.minX) { //取这个
x = x2;
                    y = mapBounds.minY;
                } else {
                    x = mapBounds.minX;
                    y = y2;
                }
            } else { //第四象限
tan = Tan((a)*0.0174538);
                x2 = (mapBounds.minY - y1) / tan + x1;
                y2 = (mapBounds.maxX - x1) * tan + y1;
                if (x2 <= mapBounds.maxX) { //取这个
x = x2;
                    y = mapBounds.minY;
                } else {
                    x = mapBounds.maxX;
                    y = y2;
                }
            }
        }
    }
    // 实现三个数值的特殊叠加计算
    // 效果等同于 RealAdd(RealAdd(a1,a2),a3)
    //
    // 参数说明：
    // a1: 第一个数值，通常表示当前已有的加成效果
    // a2: 第二个数值，表示第一次要叠加的新加成效果
    // a3: 第三个数值，表示第二次要叠加的新加成效果
    // 返回值: 三个数值叠加后的最终效果值
    //
    // 使用示例：
    // real baseEffect = 0.3;     // 基础30%效果
    // real bonus1 = 0.4;         // 第一个40%加成
    // real bonus2 = 0.2;         // 第二个20%加成
    // real final = RealAdd3(baseEffect, bonus1, bonus2);  // 一次性计算三个效果的叠加
    public function RealAdd3 ( real a1, real a2, real a3 ) -> real {
        real temp;
        // 如果第二个参数绝对值>=1.0，直接用第一个参数与第三个参数计算
        if (RAbsBJ(a2) >= 1.0) {
            return RealAdd(a1, a3);
        }
        // 如果第三个参数绝对值>=1.0，直接返回前两个参数的计算结果
        if (RAbsBJ(a3) >= 1.0) {
            return RealAdd(a1, a2);
        }
        // 先计算前两个参数的结果
        if (a2 >= 0) {
            temp = 1.0-(1.0-a1)*(1.0-a2);
        } else {
            temp = 1.0-(1.0-a1)/(1.0+a2);
        }
        // 再与第三个参数计算
        if (a3 >= 0) {
            return 1.0-(1.0-temp)*(1.0-a3);
        } else {
            return 1.0-(1.0-temp)/(1.0+a3);
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

japi引用的常量库 由于wave宏定义 只对以下的代码有效

请将常量库里所有内容复制到  自定义脚本代码区
*/
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
//! zinc
/*
单位有关的增强功能
*/
library UnitUtils {
    //获取单位的攻击力/防御/生命/魔法值
    public function GetUnitAttack(unit u) -> integer {
        return R2I(GetUnitState(u,ConvertUnitState(0x12)));
    }
    public function GetUnitDefense(unit u) -> integer {
        return R2I(GetUnitState(u,ConvertUnitState(0x20)));
    }
    public function GetUnitHP(unit u) -> real {
        return GetUnitState(u,UNIT_STATE_MAX_LIFE);
    }
    public function GetUnitMP(unit u) -> real {
        return GetUnitState(u,UNIT_STATE_MAX_MANA);
    }
    //设置攻击力
    public function SetUnitAttack(unit u, real attack) -> nothing {
        SetUnitState(u,ConvertUnitState(0x12),attack);
    }
    //增加攻击力
    public function AddUnitAttack(unit u, real attack) -> nothing {
        SetUnitAttack(u,GetUnitAttack(u) + attack);
    }
    //设置防御
    public function SetUnitDefense(unit u, real defense) -> nothing {
        SetUnitState(u,ConvertUnitState(0x20),defense);
    }
    //增加防御
    public function AddUnitDefense(unit u, real defense) -> nothing {
        SetUnitDefense(u,GetUnitDefense(u)+defense);
    }
    //修改生命最大值
    public function SetUnitHP(unit u, real hp) -> nothing {
        SetUnitState(u,UNIT_STATE_MAX_LIFE,RMaxBJ(hp,2.0));
    }
    //增加生命最大值
    public function AddUnitHP(unit u,real hp ) {
        SetUnitHP(u,RMaxBJ(GetUnitHP(u)+hp,10.0));
        if (hp > 0) {SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState(u,UNIT_STATE_LIFE)+hp));}
    }
    //回血(定值)
    public function RegenUnitHP(unit u, real volume) -> nothing {
        SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState(u,UNIT_STATE_LIFE)+volume));
    }
    //回蓝(百分比)
    public function RegenUnitHPPercent(unit u, real rate) -> nothing {
        SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState(u,UNIT_STATE_LIFE)+GetUnitHP(u)*rate));
    }
    //设置魔法最大值
    public function SetUnitMP(unit u, real mp) -> nothing {
        SetUnitState(u,UNIT_STATE_MAX_MANA,mp);
    }
    //增加魔法最大值
    public function AddUnitMP(unit u,real mp ) {
        SetUnitMP(u,GetUnitMP(u)+mp);
        if (mp > 0) {SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState(u,UNIT_STATE_MANA)+mp));}
    }
    //回蓝(定值)
    public function RegenUnitMP(unit u, real volume) -> nothing {
        SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState(u,UNIT_STATE_MANA)+volume));
    }
    //回蓝(百分比)
    public function RegenUnitMPPercent(unit u, real rate) -> nothing {
        SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState(u,UNIT_STATE_MANA)+GetUnitMP(u)*rate));
    }
    // 获取移速
    public function GetUnitSpeed (unit u) -> integer {
        if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),237960560)) { //突破522与0的移速的Hook
return LoadInteger(HASH_UNIT,GetHandleId(u),237960560);
        }
        else {return R2I(GetUnitMoveSpeed(u));}
    }
    //todo: 这个UNTable其他地图需要兼容
    // 增加移速
    public function AddUnitSpeed (unit u,integer speed) {
        integer value;
        if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),237960560)) { //突破522与0的移速的Hook
value = LoadInteger(HASH_UNIT,GetHandleId(u),237960560);
            value += speed;
            SaveInteger(HASH_UNIT,GetHandleId(u),237960560,value);
        } else {value = R2I(GetUnitMoveSpeed(u)) + speed;}
		SetUnitMoveSpeed(u,value);
    }
    // 初始化突破移速
    public function InitUnitSpeed (unit u) {
        SaveInteger(HASH_UNIT,GetHandleId(u),237960560,R2I(GetUnitMoveSpeed(u)));
    }
    //射程(还会+警戒范围)
    public function GetUnitAttackRange(unit u) -> real {
        return GetUnitState(u,ConvertUnitState(0x16));
    }
    //设置射程(还会设置警戒范围)
    public function SetUnitAttackRange (unit u,real range) {
		SetUnitState(u,ConvertUnitState(0x16),range);
		SetUnitAcquireRange(u,RMaxBJ(range,900.0));
    }
    //增加射程(还会+警戒范围)
	public function AddUnitAttackRange (unit u,real range) {
		SetUnitState(u,ConvertUnitState(0x16),GetUnitAttackRange(u) + range);
		SetUnitAcquireRange(u,RMaxBJ(GetUnitAcquireRange(u)+range,900.0));
    }
    // 获取攻速
    public function GetUnitAttackSpeed(unit u) -> real {
        return GetUnitState(u,ConvertUnitState(0x51));
    }
    // 增加攻速
	public function AddUnitAttackSpeed (unit u,real speed) {
		SetUnitState(u,ConvertUnitState(0x51),GetUnitState(u,ConvertUnitState(0x51)) + speed);
	}
    public function GetUnitInterval(unit u) -> real {
        return GetUnitState(u,ConvertUnitState(0x25));
    }
    // 攻击间隔(虽然写着加,但是实际是减)
	public function AddAttackInterval (unit u,real value) {
        SetUnitState(u,ConvertUnitState(0x25),GetUnitInterval(u) - value);
	}
    //传送单位(带特效与镜头转换)
    public function TransportUnit (unit u,real x,real y,boolean camera) {
        if (camera) PanCameraToTimedForPlayer(GetOwningPlayer(u),x,y,0.2);
        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", GetUnitX(u), GetUnitY(u)));
        SetUnitPosition(u,x,y);
        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", GetUnitX(u), GetUnitY(u)));
    }
    //删除单位
    public function DeleteUnit (unit u) {
        FlushChildHashtable(HASH_UNIT,GetHandleId(u));
        RemoveUnit(u);
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
/*

japi引用的常量库 由于wave宏定义 只对以下的代码有效

请将常量库里所有内容复制到  自定义脚本代码区
*/
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
//! zinc
/*
英雄的属性
*/
library HeroAttr requires ConversionUtils,UnitAttr {
	public constant integer MAIN_ATTR_STR = 0; //主属性:力量
public constant integer MAIN_ATTR_AGI = 1; //主属性:敏捷
public constant integer MAIN_ATTR_INT = 2; //主属性:智力

	public struct heroAttr {
		method isExist () -> boolean {return (this != null && si__heroAttr_V[this] == -1);}
		static thistype ethis = 0;
		unit u; //绑定的单位

		integer mainAttrType; // 主属性类型

		real mainAttrBase; // 基础主属性
real mainAttrRateUp; // 主属性增幅
real mainAttrRateDown; // 主属性减幅
real mainAttrFixedBonus; // 主属性固定加成

		real subAttrBase; // 基础次属性
real subAttrRateUp; // 次属性增幅
real subAttrRateDown; // 次属性减幅
real subAttrFixedBonus; // 次属性固定加成

		// 展开的Str属性相关代码
		/* 基础属性值及加成系数 */
		public real baseStr; /* 基础Str值 */
		public real StrRateUp; /* Str增幅比例 */
		public real StrRateDown; /* Str减幅比例 */
		public real StrRateBonus; /* 受增减幅影响的bonus值 */
		public real StrFixedBonus; /* 固定加成值(不受增减幅影响) */
		public static trigger trStrChange = null; /* Str变化触发器 */
        // 获取基础Str(白字)
        public method getBaseStr () -> real {
            if (mainAttrType == MAIN_ATTR_STR) {
                return baseStr + mainAttrBase;
            } else {
                return baseStr + subAttrBase;
            }
        }
        // 获取额外Str(绿字)
        public method getExtraStr () -> real {
            if (mainAttrType == MAIN_ATTR_STR) {
                return StrRateBonus + StrFixedBonus + mainAttrFixedBonus;
            } else {
                return StrRateBonus + StrFixedBonus + subAttrFixedBonus;
            }
        }
		/* 获取当前总Str */
		public method getCurrentStr() -> real {
            if (mainAttrType == MAIN_ATTR_STR) { //主属性是力量
return baseStr + mainAttrBase + StrRateBonus + StrFixedBonus + mainAttrFixedBonus;
			} else {
				return baseStr + subAttrBase + StrRateBonus + StrFixedBonus + subAttrFixedBonus;
			}
		}
		/* 获取当前Str倍率 */
		public method getCurrentStrRate() -> real {
			if (mainAttrType == MAIN_ATTR_STR) { //主属性是力量
return (1.0 + StrRateUp + mainAttrRateUp) * (1.0-StrRateDown) * (1.0-mainAttrRateDown) - 1.0;
			} else {
				return (1.0 + StrRateUp + subAttrRateUp) * (1.0-StrRateDown) * (1.0-subAttrRateDown) - 1.0;
			}
		}
		// 同步并刷新当前单位的力量
		private method syncStrRate() {
			StrRateBonus = baseStr * getCurrentStrRate();
			SetHeroStr(u, R2I(RMaxBJ(getCurrentStr(), 0.0)), true);
			if (trStrChange != null) {
				ethis = this;
				TriggerEvaluate(trStrChange);
			}
		}
		/* 设置基础Str */
		public method setBaseStr(real value) {
			if (baseStr != value) {
				baseStr = value;
				syncStrRate();
			}
		}
		/* 增加基础Str */
		public method addBaseStr(real value) {
			if (value != 0) {
				baseStr += value;
				syncStrRate();
			}
		}
		/* 增加固定bonus */
		public method addStrFixedBonus(real value) {
			if (value != 0) {
				StrFixedBonus += value;
				syncStrRate();
			}
		}
		/* 增加Str增幅 */
		public method addStrRateUp(real value) {
			if (value != 0) {
				StrRateUp += value;
				syncStrRate();
			}
		}
		/* 增加Str减幅 */
		public method addStrRateDown(real value) {
			if (value != 0) {
				StrRateDown = RealAdd(StrRateDown, value);
				syncStrRate();
			}
		}
		/* 回调Str变化 */
		public static method onStrChange(code func) {
			if (trStrChange == null) {
				trStrChange = CreateTrigger();
			}
			TriggerAddCondition(trStrChange, Condition(func));
		}
		// 同步并刷新当前单位的敏捷
		private method syncAgiRate() {
		}
		// 同步并刷新当前单位的智力
		private method syncIntRate() {
		}
		static method parse (unit u, integer mainAttrType) -> thistype {
			thistype this;
			integer handleId = GetHandleId(u);
			// 先检查是否已存在
			if (HaveSavedInteger(HASH_UNIT, handleId, 1727)) {
				return LoadInteger(HASH_UNIT, handleId, 1727);
			} else if (!IsHeroUnitId(GetUnitTypeId(u))) {
				// 如果不是英雄单位就不给创建
				return 0;
			}
			// 不存在才创建新的
			this = allocate();
			this.u = u;
			this.mainAttrType = mainAttrType;
			this.mainAttrBase = 0.0;
			this.mainAttrRateUp = 0.0;
			this.mainAttrRateDown = 0.0;
			this.mainAttrFixedBonus = 0.0;
			this.subAttrBase = 0.0;
			this.subAttrRateUp = 0.0;
			this.subAttrRateDown = 0.0;
			this.subAttrFixedBonus = 0.0;
			this.baseStr = 0.0; <?='\n'?> this.StrRateUp = 0.0; <?='\n'?> this.StrRateDown = 0.0; <?='\n'?> this.StrRateBonus = 0.0; <?='\n'?> this.StrFixedBonus = 0.0; <?='\n'?>
			// INIT_COMBAT_ATTR(Agi)
			// INIT_COMBAT_ATTR(Int)
			SaveInteger(HASH_UNIT, handleId, 1727, this);
			return this;
		}
		/* 增加主属性基础值 */
		public method addMainAttrBase(real value) {
			if (value != 0) {
				mainAttrBase += value;
				// 根据主属性类型同步相应属性
				if (mainAttrType == MAIN_ATTR_STR) {
					syncStrRate();
				} else if (mainAttrType == MAIN_ATTR_AGI) {
					syncAgiRate();
				} else if (mainAttrType == MAIN_ATTR_INT) {
					syncIntRate();
				}
			}
		}
		/* 增加次属性基础值 */
		public method addSubAttrBase(real value) {
			if (value != 0) {
				subAttrBase += value;
				// 根据主属性类型同步次属性
				if (mainAttrType == MAIN_ATTR_STR) {
					syncAgiRate();
					syncIntRate();
				} else if (mainAttrType == MAIN_ATTR_AGI) {
					syncStrRate();
					syncIntRate();
				} else if (mainAttrType == MAIN_ATTR_INT) {
					syncStrRate();
					syncAgiRate();
				}
			}
		}
		// 添加主属性相关方法
		public method addMainAttrRateUp(real value) {
			if (value != 0) {
				mainAttrRateUp += value;
				if (mainAttrType == MAIN_ATTR_STR) {
					syncStrRate();
				} else if (mainAttrType == MAIN_ATTR_AGI) {
					syncAgiRate();
				} else if (mainAttrType == MAIN_ATTR_INT) {
					syncIntRate();
				}
			}
		}
		public method addMainAttrRateDown(real value) {
			if (value != 0) {
				mainAttrRateDown = RealAdd(mainAttrRateDown, value);
				if (mainAttrType == MAIN_ATTR_STR) {
					syncStrRate();
				} else if (mainAttrType == MAIN_ATTR_AGI) {
					syncAgiRate();
				} else if (mainAttrType == MAIN_ATTR_INT) {
					syncIntRate();
				}
			}
		}
		public method addMainAttrFixedBonus(real value) {
			if (value != 0) {
				mainAttrFixedBonus += value;
				if (mainAttrType == MAIN_ATTR_STR) {
					syncStrRate();
				} else if (mainAttrType == MAIN_ATTR_AGI) {
					syncAgiRate();
				} else if (mainAttrType == MAIN_ATTR_INT) {
					syncIntRate();
				}
			}
		}
		// 添加次属性相关方法
		public method addSubAttrRateUp(real value) {
			if (value != 0) {
				subAttrRateUp += value;
				if (mainAttrType == MAIN_ATTR_STR) {
					syncAgiRate();
					syncIntRate();
				} else if (mainAttrType == MAIN_ATTR_AGI) {
					syncStrRate();
					syncIntRate();
				} else if (mainAttrType == MAIN_ATTR_INT) {
					syncStrRate();
					syncAgiRate();
				}
			}
		}
		public method addSubAttrRateDown(real value) {
			if (value != 0) {
				subAttrRateDown = RealAdd(subAttrRateDown, value);
				if (mainAttrType == MAIN_ATTR_STR) {
					syncAgiRate();
					syncIntRate();
				} else if (mainAttrType == MAIN_ATTR_AGI) {
					syncStrRate();
					syncIntRate();
				} else if (mainAttrType == MAIN_ATTR_INT) {
					syncStrRate();
					syncAgiRate();
				}
			}
		}
		public method addSubAttrFixedBonus(real value) {
			if (value != 0) {
				subAttrFixedBonus += value;
				if (mainAttrType == MAIN_ATTR_STR) {
					syncAgiRate();
					syncIntRate();
				} else if (mainAttrType == MAIN_ATTR_AGI) {
					syncStrRate();
					syncIntRate();
				} else if (mainAttrType == MAIN_ATTR_INT) {
					syncStrRate();
					syncAgiRate();
				}
			}
		}
		//单位删除会调用
		method onDestroy () {
			if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),1727)) {
				RemoveSavedInteger(HASH_UNIT,GetHandleId(u),1727);
			}
			u = null;
		}
		//注册到周期结束中
		static method onInit () {
			unitLifeCycle.registerDestroy(function () {
				unit u = unitLifeCycle.argsUnit;
				thistype this = unitAttr.parse(u);
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
// 地图边界工具库
library MapBoundsUtils {
    public struct mapBounds {
        static real maxX = 0.;
        static real minX = 0.;
        static real maxY = 0.;
        static real minY = 0.;
        // 限制X坐标在地图范围内
        static method X (real x) -> real {
            return RMinBJ(RMaxBJ(x, mapBounds.minX), mapBounds.maxX);
        }
        // 限制Y坐标在地图范围内
        static method Y (real y) -> real {
            return RMinBJ(RMaxBJ(y, mapBounds.minY), mapBounds.maxY);
        }
        // 初始化
        static method onInit () {
            mapBounds.minX = GetCameraBoundMinX() - GetCameraMargin(CAMERA_MARGIN_LEFT);
            mapBounds.minY = GetCameraBoundMinY() - GetCameraMargin(CAMERA_MARGIN_BOTTOM);
            mapBounds.maxX = GetCameraBoundMaxX() + GetCameraMargin(CAMERA_MARGIN_RIGHT);
            mapBounds.maxY = GetCameraBoundMaxY() + GetCameraMargin(CAMERA_MARGIN_TOP);
        }
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
// #include <YDTrigger/ImportSaveLoadSystem.h>
// #include <YDTrigger/Hash.h>
// 原生UI的大小
//函数入口
// 用原始地图测试
// 用空地图测试
// 用原始地图测试
//! zinc
//自动生成的文件
library UTHeroAttr requires HeroAttr {
	private unit testHeroStr = null; // 力量型英雄
private unit testHeroAgi = null; // 敏捷型英雄
private heroAttr attrStr = 0; // 力量英雄属性
private heroAttr attrAgi = 0; // 敏捷英雄属性

	// 创建测试英雄
	private function CreateTestHeroes(player p) {
		if (testHeroStr != null) {
			RemoveUnit(testHeroStr);
		}
		if (testHeroAgi != null) {
			RemoveUnit(testHeroAgi);
		}
		// 创建一个力量型英雄和一个敏捷型英雄
		testHeroStr = CreateUnit(p, 'Hmkg', 0, 0, 0); // 山丘之王
testHeroAgi = CreateUnit(p, 'Edem', 200, 0, 0); // 恶魔猎手

		// 初始化属性系统
		attrStr = heroAttr.parse(testHeroStr, MAIN_ATTR_STR);
		attrAgi = heroAttr.parse(testHeroAgi, MAIN_ATTR_AGI);
		// 设置基础属性值方便测试
		attrStr.setBaseStr(100);
		attrAgi.setBaseStr(80);
		SelectUnit(testHeroStr, true);
	}
	function Init() {
		player p = Player(0);
		BJDebugMsg("=== HeroAttr测试系统已加载 ===");
		heroAttr.onStrChange(function() { // 监听Str变化
heroAttr ha = heroAttr.ethis;
			// BJDebugMsg("[单位]: " + GetUnitName(ha.u) + " [Str]: " + R2S(ha.getCurrentStr()));
		});
		// 创建测试英雄
		//Trace
		CreateTestHeroes(p);
		// 测试1：基础力量属性测试
		UnitTestAutoTimer(0.1, 0, function() {
			assert.Real(attrStr.getCurrentStr(), 100.0, "力量英雄初始Str应为100");
			assert.Real(attrAgi.getCurrentStr(), 80.0, "敏捷英雄初始Str应为80");
		}, null);
		// 测试2：主属性增幅测试
		UnitTestAutoTimer(0.6, 0, function() {
			// 给力量英雄加50%主属性增幅
			attrStr.addMainAttrRateUp(0.5);
			assert.Real(attrStr.getCurrentStr(), 150.0, "力量英雄50%主属性增幅后Str应为150");
			// 给敏捷英雄加50%主属性增幅(不应影响力量)
			attrAgi.addMainAttrRateUp(0.5);
			assert.Real(attrAgi.getCurrentStr(), 80.0, "敏捷英雄主属性增幅不应影响Str");
		}, null);
		// 测试3：次属性增幅测试
		UnitTestAutoTimer(1.1, 0, function() {
			// 重置测试英雄
			CreateTestHeroes(Player(0));
			// 给力量英雄加30%次属性增幅
			attrStr.addSubAttrRateUp(0.3);
			assert.Real(attrStr.getCurrentStr(), 100.0, "力量英雄次属性增幅不应影响Str");
			// 给敏捷英雄加30%次属性增幅(应影响力量)
			attrAgi.addSubAttrRateUp(0.3);
			assert.Real(attrAgi.getCurrentStr(), 104.0, "敏捷英雄30%次属性增幅后Str应为104");
		}, null);
		// 测试4：属性固定加成测试
		UnitTestAutoTimer(1.6, 0, function() {
			CreateTestHeroes(Player(0));
			// 测试主属性固定加成
			attrStr.addMainAttrFixedBonus(50.0);
			assert.Real(attrStr.getCurrentStr(), 150.0, "力量英雄加50点主属性固定加成后Str应为150");
			// 测试次属性固定加成
			attrAgi.addSubAttrFixedBonus(30.0);
			assert.Real(attrAgi.getCurrentStr(), 110.0, "敏捷英雄加30点次属性固定加成后Str应为110");
		}, null);
		// 测试5：力量属性各种增减幅组合测试
		UnitTestAutoTimer(2.1, 0, function() {
			CreateTestHeroes(Player(0));
			// 设置基础力量为100
			attrStr.setBaseStr(100);
			// 添加力量增减幅
			attrStr.addStrRateUp(0.3); // +30%
attrStr.addStrRateDown(0.1); // -10%

			// 添加主属性增减幅
			attrStr.addMainAttrRateUp(0.2); // +20%
attrStr.addMainAttrRateDown(0.05); // -5%

			// 计算期望值：
			// 基础值: 100
			// 所有增幅相加: (1 + 0.3 + 0.2) = 1.5
			// 所有减幅相乘: (1 - 0.1) * (1 - 0.05) = 0.9 * 0.95 = 0.855
			// 最终计算: 100 * 1.5 * 0.855 = 128.25
			assert.Real(attrStr.getCurrentStr(), 128.25, "力量英雄复杂增减幅组合测试1");
			// 添加固定加成
			attrStr.addStrFixedBonus(50);
			attrStr.addMainAttrFixedBonus(30);
			// 最终结果应为: 128.25 + 50 + 30 = 208.25
			assert.Real(attrStr.getCurrentStr(), 208.25, "力量英雄复杂增减幅组合测试2");
		}, null);
		// 测试6：次属性对力量的影响组合测试
		UnitTestAutoTimer(2.6, 0, function() {
			CreateTestHeroes(Player(0));
			// 设置基础属性
			attrAgi.setBaseStr(100);
			// 添加力量相关增减幅
			attrAgi.addStrRateUp(0.2); // +20%
attrAgi.addStrRateDown(0.1); // -10%

			// 添加次属性增减幅
			attrAgi.addSubAttrRateUp(0.3); // +30%
attrAgi.addSubAttrRateDown(0.15); // -15%

			// 计算期望值：
			// 基础值: 100
			// 所有增幅相加: (1 + 0.2 + 0.3) = 1.5
			// 所有减幅相乘: (1 - 0.1) * (1 - 0.15) = 0.9 * 0.85 = 0.765
			// 最终计算: 100 * 1.5 * 0.765 = 114.75
			assert.Real(attrAgi.getCurrentStr(), 114.75, "敏捷英雄力量复杂增减幅组合测试1");
			// 添加固定加成
			attrAgi.addStrFixedBonus(40);
			attrAgi.addSubAttrFixedBonus(20);
			// 最终结果应为: 114.75 + 40 + 20 = 174.75
			assert.Real(attrAgi.getCurrentStr(), 174.75, "敏捷英雄力量复杂增减幅组合测试2");
		}, null);
		// 测试7：极限值测试
		UnitTestAutoTimer(3.1, 0, function() {
			CreateTestHeroes(Player(0));
			// 设置一个较大的基础值
			attrStr.setBaseStr(1000);
			// 添加多个大幅度的增减幅
			attrStr.addStrRateUp(2.0); // +200%
attrStr.addMainAttrRateUp(1.5); // +150%
attrStr.addStrRateDown(0.4); // -40%
attrStr.addMainAttrRateDown(0.3); // -30%

			// 添加大量固定加成
			attrStr.addStrFixedBonus(500);
			attrStr.addMainAttrFixedBonus(300);
			// 计算期望值：
			// 基础值: 1000
			// 所有增幅相加: (1 + 2.0 + 1.5) = 4.5
			// 所有减幅相乘: (1 - 0.4) * (1 - 0.3) = 0.6 * 0.7 = 0.42
			// 属性计算: 1000 * 4.5 * 0.42 = 1890
			// 加上固定加成: 1890 + 500 + 300 = 2690
			assert.Real(attrStr.getCurrentStr(), 2690.0, "力量英雄极限值测试");
		}, null);
		// 测试8：主属性基础值测试
		UnitTestAutoTimer(3.6, 0, function() {
			CreateTestHeroes(Player(0));
			// 测试力量英雄的主属性基础值
			attrStr.addMainAttrBase(50);
			assert.Real(attrStr.getBaseStr(), 150.0, "力量英雄加50主属性基础值后白字应为150");
			assert.Real(attrStr.getCurrentStr(), 150.0, "力量英雄加50主属性基础值后总值应为150");
			// 测试敏捷英雄的主属性基础值(不应影响力量)
			attrAgi.addMainAttrBase(50);
			assert.Real(attrAgi.getBaseStr(), 80.0, "敏捷英雄加50主属性基础值后力量白字应为80");
			assert.Real(attrAgi.getCurrentStr(), 80.0, "敏捷英雄加50主属性基础值后力量总值应为80");
		}, null);
		// 测试9：次属性基础值测试
		UnitTestAutoTimer(4.1, 0, function() {
			CreateTestHeroes(Player(0));
			// 测试力量英雄的次属性基础值(不应影响力量)
			attrStr.addSubAttrBase(30);
			assert.Real(attrStr.getBaseStr(), 100.0, "力量英雄加30次属性基础值后力量白字应为100");
			assert.Real(attrStr.getCurrentStr(), 100.0, "力量英雄加30次属性基础值后力量总值应为100");
			// 测试敏捷英雄的次属性基础值(应影响力量)
			attrAgi.addSubAttrBase(30);
			assert.Real(attrAgi.getBaseStr(), 110.0, "敏捷英雄加30次属性基础值后力量白字应为110");
			assert.Real(attrAgi.getCurrentStr(), 110.0, "敏捷英雄加30次属性基础值后力量总值应为110");
		}, null);
		// 测试10：主属性和次属性基础值组合测试
		UnitTestAutoTimer(4.6, 0, function() {
			CreateTestHeroes(Player(0));
			// 设置基础属性和增减幅
			attrAgi.setBaseStr(100);
			attrAgi.addStrRateUp(0.5); // +50%
attrAgi.addSubAttrRateUp(0.3); // +30%

			// 添加主属性和次属性基础值
			attrAgi.addMainAttrBase(20); // 不影响力量
attrAgi.addSubAttrBase(50); // 影响力量

			// 计算期望值：
			// 增幅: 100 * (1 + 0.5 + 0.3) + 50 = 230
			assert.Real(attrAgi.getBaseStr(), 150.0, "敏捷英雄复杂组合后力量白字应为150");
			assert.Real(attrAgi.getCurrentStr(), 230.0, "敏捷英雄复杂组合后力量总值应为230");
		}, null);
		// 测试11：多重增幅叠加测试
		UnitTestAutoTimer(5.1, 0, function() {
			CreateTestHeroes(Player(0));
			// 设置基础属性
			attrStr.setBaseStr(100);
			// 添加多次力量增幅
			attrStr.addStrRateUp(0.2); // +20%
attrStr.addStrRateUp(0.3); // +30%
attrStr.addStrRateUp(0.15); // +15%

			// 添加多次主属性增幅
			attrStr.addMainAttrRateUp(0.25); // +25%
attrStr.addMainAttrRateUp(0.35); // +35%

			// 添加多次次属性增幅
			attrStr.addSubAttrRateUp(0.1); // +10%
attrStr.addSubAttrRateUp(0.2); // +20%

			// 计算期望值：
			// 基础值: 100
			// 力量增幅总和: 0.2 + 0.3 + 0.15 = 0.65
			// 主属性增幅总和: 0.25 + 0.35 = 0.6
			// 次属性增幅总和: 0.1 + 0.2 = 0.3
			// 所有增幅相加: (1 + 0.65 + 0.6) = 2.25
			// 最终计算: 100 * 2.25 = 225
			assert.Real(attrStr.getCurrentStr(), 225.0, "力量英雄多重增幅叠加测试1");
			// 再添加一些减幅测试
			attrStr.addStrRateDown(0.2); // -20%
attrStr.addMainAttrRateDown(0.1); // -10%

			// 计算最终期望值：
			// 之前结果: 225
			// 减幅相乘: (1 - 0.2) * (1 - 0.1) = 0.8 * 0.9 = 0.72
			// 最终计算: 225 * 0.72 = 162
			assert.Real(attrStr.getCurrentStr(), 162, "力量英雄多重增幅叠加测试2");
			// 测试敏捷英雄的多重增幅叠加
			attrAgi.setBaseStr(100);
			// 添加多次各类增幅
			attrAgi.addStrRateUp(0.25); // +25%
attrAgi.addStrRateUp(0.35); // +35%
attrAgi.addSubAttrRateUp(0.2); // +20%
attrAgi.addSubAttrRateUp(0.3); // +30%
attrAgi.addMainAttrRateUp(0.4); // +40% (不影响力量)

			// 计算期望值：
			// 基础值: 100
			// 力量增幅总和: 0.25 + 0.35 = 0.6
			// 次属性增幅总和: 0.2 + 0.3 = 0.5
			// 所有增幅相加: (1 + 0.6 + 0.5) = 2.1
			// 最终计算: 100 * 2.1 = 210
			assert.Real(attrAgi.getCurrentStr(), 210.0, "敏捷英雄多重增幅叠加测试1");
			// 添加减幅
			attrAgi.addStrRateDown(0.15); // -15%
attrAgi.addSubAttrRateDown(0.25); // -25%

			// 计算最终期望值：
			// 之前结果: 210
			// 减幅相乘: (1 - 0.15) * (1 - 0.25) = 0.85 * 0.75 = 0.6375
			// 最终计算: 210 * 0.6375 = 133.875
			assert.Real(attrAgi.getCurrentStr(), 133.875, "敏捷英雄多重增幅叠加测试2");
		}, null);
		p = null;
	}
	// 处理测试命令
	function TTestActUTHeroAttr1(string str) {
		player p = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i, num = 0, len = StringLength(str);
		string paramS[];
		integer paramI[];
		real paramR[];
		// 解析参数
		for (0 <= i <= len - 1) {
			if (SubString(str,i,i+1) == " ") {
				paramS[num]= SubString(str,0,i);
				paramI[num]= S2I(paramS[num]);
				paramR[num]= S2R(paramS[num]);
				num = num + 1;
				str = SubString(str,i + 1,len);
				len = StringLength(str);
				i = -1;
			}
		}
		paramS[num]= str;
		paramI[num]= S2I(paramS[num]);
		paramR[num]= S2R(paramS[num]);
		num = num + 1;
		if (testHeroStr == null) {
			CreateTestHeroes(p);
		}
		// 新建测试单位命令
		if (paramS[0] == "new") {
			CreateTestHeroes(p);
			BJDebugMsg("已重新创建测试英雄");
		}
		// 力量相关命令
		else if (paramS[0] == "str") {
			attrStr.setBaseStr(paramR[1]);
			attrAgi.setBaseStr(paramR[1]);
			BJDebugMsg("设置力量英雄基础力量为: " + R2S(paramR[1]));
		} else if (paramS[0] == "addstr") {
			attrStr.addBaseStr(paramR[1]);
			attrAgi.addBaseStr(paramR[1]);
			BJDebugMsg("增加力量英雄基础力量: " + R2S(paramR[1]));
		} else if (paramS[0] == "strup") {
			attrStr.addStrRateUp(paramR[1]);
			attrAgi.addStrRateUp(paramR[1]);
			BJDebugMsg("设置力量英雄力量增幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "strdown") {
			attrStr.addStrRateDown(paramR[1]);
			attrAgi.addStrRateDown(paramR[1]);
			BJDebugMsg("设置力量英雄力量减幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "strbonus") {
			attrStr.addStrFixedBonus(paramR[1]);
			attrAgi.addStrFixedBonus(paramR[1]);
			BJDebugMsg("设置力量英雄力量固定加成为: " + R2S(paramR[1]));
		} else if (paramS[0] == "addstrbonus") {
			attrStr.addStrFixedBonus(paramR[1]);
			attrAgi.addStrFixedBonus(paramR[1]);
			BJDebugMsg("增加力量英雄力量固定加成: " + R2S(paramR[1]));
		}
		// 主属性相关命令
		else if (paramS[0] == "mainup") {
			attrStr.addMainAttrRateUp(paramR[1]);
			attrAgi.addMainAttrRateUp(paramR[1]);
			BJDebugMsg("设置力量英雄主属性增幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "maindown") {
			attrStr.addMainAttrRateDown(paramR[1]);
			attrAgi.addMainAttrRateDown(paramR[1]);
			BJDebugMsg("设置力量英雄主属性减幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "mainbonus") {
			attrStr.addMainAttrFixedBonus(paramR[1]);
			attrAgi.addMainAttrFixedBonus(paramR[1]);
			BJDebugMsg("设置力量英雄主属性固定加成为: " + R2S(paramR[1]));
		}
		// 次属性相关命令
		else if (paramS[0] == "subup") {
			attrStr.addSubAttrRateUp(paramR[1]);
			attrAgi.addSubAttrRateUp(paramR[1]);
			BJDebugMsg("设置力量英雄次属性增幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "subdown") {
			attrStr.addSubAttrRateDown(paramR[1]);
			attrAgi.addSubAttrRateDown(paramR[1]);
			BJDebugMsg("设置力量英雄次属性减幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "subbonus") {
			attrStr.addSubAttrFixedBonus(paramR[1]);
			attrAgi.addSubAttrFixedBonus(paramR[1]);
			BJDebugMsg("设置力量英雄次属性固定加成为: " + R2S(paramR[1]));
		}
		// 主属性基础值相关命令
		else if (paramS[0] == "mainadd") {
			attrStr.addMainAttrBase(paramR[1]);
			attrAgi.addMainAttrBase(paramR[1]);
			BJDebugMsg("增加力量英雄主属性基础值: " + R2S(paramR[1]));
		}
		// 次属性基础值相关命令
		else if (paramS[0] == "subadd") {
			attrStr.addSubAttrBase(paramR[1]);
			attrAgi.addSubAttrBase(paramR[1]);
			BJDebugMsg("增加力量英雄次属性基础值: " + R2S(paramR[1]));
		}
		// 显示当前状态
		BJDebugMsg("力量英雄当前力量: " + R2S(attrStr.getCurrentStr()));
		BJDebugMsg("力量英雄当前力量白字: " + R2S(attrStr.getBaseStr()));
		BJDebugMsg("力量英雄当前力量绿字: " + R2S(attrStr.getExtraStr()));
		BJDebugMsg("敏捷英雄当前力量: " + R2S(attrAgi.getCurrentStr()));
		BJDebugMsg("敏捷英雄当前力量白字: " + R2S(attrAgi.getBaseStr()));
		BJDebugMsg("敏捷英雄当前力量绿字: " + R2S(attrAgi.getExtraStr()));
		p = null;
	}
	function onInit() {
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEvent(tr, 0.5, false);
		TriggerAddCondition(tr,Condition(function() {
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;
		// 注册聊天事件
		UnitTestRegisterChatEvent(function() {
			string str = GetEventPlayerChatString();
			if (SubString(str, (1)-1, 1) == "-") {
				TTestActUTHeroAttr1(SubString(str, (2)-1, StringLength(str)));
				return;
			}
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
