//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerSelectionEventBJ.h>
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerKeyEventBJ.h>
//#  define TriggerRegisterPlayerUnitEventSimple(trig, p, e)                 TriggerRegisterPlayerUnitEvent(trig, p, e, null)
//#  define TriggerRegisterPlayerEventVictory(trig, player)                  TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_VICTORY)
//#  define TriggerRegisterPlayerEventDefeat(trig, player)                   TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_DEFEAT)
//#  define TriggerRegisterPlayerEventLeave(trig, player)                    TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_LEAVE)
//#  define TriggerRegisterPlayerEventAllianceChanged(trig, player)          TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_ALLIANCE_CHANGED)
//#  define TriggerRegisterPlayerEventEndCinematic(trig, player)             TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_END_CINEMATIC)
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
单位哈希表定义
*/
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
//! zinc
/*
单位哈希表
*/
library UnitHashTable {
    public hashtable HASH_UNIT = InitHashtable(); // 单位哈希表

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
英雄的属性
*/
library HeroAttr requires UnitUtils,MathUtils,UnitLifeCycle {
    public struct heroAttr {
        method isExist () -> boolean {return (this != null && si__heroAttr_V[this] == -1);}
		unit u; //绑定的单位

		static method parse (unit u) -> thistype {
			thistype this;
			integer handleId = GetHandleId(u);
			// 先检查是否已存在
			if (HaveSavedInteger(HASH_UNIT, handleId, 1727)) {
				return LoadInteger(HASH_UNIT, handleId, 1727);
			}
			// 不存在才创建新的
			this = allocate();
			//todo: 测试一下用setUnitState设超过21亿的数再get能get到吗
			this.u = u;
			this.baseStr = 0.0; <?='\n'?> this.StrRateUp = 0.0; <?='\n'?> this.StrRateDown = 0.0; <?='\n'?> this.StrRateBonus = 0.0; <?='\n'?> this.StrFixedBonus = 0.0; <?='\n'?>
			this.baseAgi = 0.0; <?='\n'?> this.AgiRateUp = 0.0; <?='\n'?> this.AgiRateDown = 0.0; <?='\n'?> this.AgiRateBonus = 0.0; <?='\n'?> this.AgiFixedBonus = 0.0; <?='\n'?>
			this.baseInt = 0.0; <?='\n'?> this.IntRateUp = 0.0; <?='\n'?> this.IntRateDown = 0.0; <?='\n'?> this.IntRateBonus = 0.0; <?='\n'?> this.IntFixedBonus = 0.0; <?='\n'?>
			SaveInteger(HASH_UNIT, handleId, 1727, this);
			return this;
		}
		// 同步并刷新当前单位的力量
		private method syncStrRate() {
			StrRateBonus = baseStr * (1.0 + StrRateUp) * (1.0 - StrRateDown) - baseStr;
			SetUnitState(u, ConvertUnitState(0x20), baseStr + StrRateBonus + StrFixedBonus);
		}
		// 同步并刷新当前单位的敏捷
		private method syncAgiRate() {
			AgiRateBonus = baseAgi * (1.0 + AgiRateUp) * (1.0 - AgiRateDown) - baseAgi;
			SetUnitState(u, ConvertUnitState(0x20), baseAgi + AgiRateBonus + AgiFixedBonus);
		}
		// 同步并刷新当前单位的智力
		private method syncIntRate() {
			IntRateBonus = baseInt * (1.0 + IntRateUp) * (1.0 - IntRateDown) - baseInt;
			SetUnitState(u, ConvertUnitState(0x20), baseInt + IntRateBonus + IntFixedBonus);
		}
		<?='\n'?> public real baseStr; /* 基础ATTR值 */<?='\n'?> public real StrRateUp; /* ATTR增幅比例 */<?='\n'?> public real StrRateDown; /* ATTR减幅比例 */<?='\n'?> public real StrRateBonus; /* 受增减幅影响的bonus值 */<?='\n'?> public real StrFixedBonus;/* 固定加成值(不受增减幅影响) */<?='\n'?> <?='\n'?> /* 设置基础ATTR */<?='\n'?> public method setBaseStr(real value) { <?='\n'?> if (baseStr != value) { <?='\n'?> baseStr = value; <?='\n'?> syncStrRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加基础ATTR */<?='\n'?> public method addBaseStr(real value) { <?='\n'?> if (value != 0) { <?='\n'?> baseStr += value; <?='\n'?> syncStrRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加固定bonus */<?='\n'?> public method addStrFixedBonus(real value) { <?='\n'?> if (value != 0) { <?='\n'?> StrFixedBonus += value; <?='\n'?> syncStrRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加ATTR增幅 */<?='\n'?> public method addStrRateUp(real value) { <?='\n'?> if (value != 0) { <?='\n'?> StrRateUp += value; <?='\n'?> syncStrRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加ATTR减幅 */<?='\n'?> public method addStrRateDown(real value) { <?='\n'?> if (value != 0) { <?='\n'?> StrRateDown = RealAdd(StrRateDown, value); <?='\n'?> syncStrRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 获取当前总ATTR */<?='\n'?> public method getCurrentStr() -> real { <?='\n'?> return baseStr + StrRateBonus + StrFixedBonus; <?='\n'?> } <?='\n'?> <?='\n'?> /* 获取当前ATTR倍率 */<?='\n'?> public method getCurrentStrRate() -> real { <?='\n'?> return (1.0 + StrRateUp) * (1.0 - StrRateDown) - 1.0; <?='\n'?> } <?='\n'?>
		<?='\n'?> public real baseAgi; /* 基础ATTR值 */<?='\n'?> public real AgiRateUp; /* ATTR增幅比例 */<?='\n'?> public real AgiRateDown; /* ATTR减幅比例 */<?='\n'?> public real AgiRateBonus; /* 受增减幅影响的bonus值 */<?='\n'?> public real AgiFixedBonus;/* 固定加成值(不受增减幅影响) */<?='\n'?> <?='\n'?> /* 设置基础ATTR */<?='\n'?> public method setBaseAgi(real value) { <?='\n'?> if (baseAgi != value) { <?='\n'?> baseAgi = value; <?='\n'?> syncAgiRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加基础ATTR */<?='\n'?> public method addBaseAgi(real value) { <?='\n'?> if (value != 0) { <?='\n'?> baseAgi += value; <?='\n'?> syncAgiRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加固定bonus */<?='\n'?> public method addAgiFixedBonus(real value) { <?='\n'?> if (value != 0) { <?='\n'?> AgiFixedBonus += value; <?='\n'?> syncAgiRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加ATTR增幅 */<?='\n'?> public method addAgiRateUp(real value) { <?='\n'?> if (value != 0) { <?='\n'?> AgiRateUp += value; <?='\n'?> syncAgiRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加ATTR减幅 */<?='\n'?> public method addAgiRateDown(real value) { <?='\n'?> if (value != 0) { <?='\n'?> AgiRateDown = RealAdd(AgiRateDown, value); <?='\n'?> syncAgiRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 获取当前总ATTR */<?='\n'?> public method getCurrentAgi() -> real { <?='\n'?> return baseAgi + AgiRateBonus + AgiFixedBonus; <?='\n'?> } <?='\n'?> <?='\n'?> /* 获取当前ATTR倍率 */<?='\n'?> public method getCurrentAgiRate() -> real { <?='\n'?> return (1.0 + AgiRateUp) * (1.0 - AgiRateDown) - 1.0; <?='\n'?> } <?='\n'?>
		<?='\n'?> public real baseInt; /* 基础ATTR值 */<?='\n'?> public real IntRateUp; /* ATTR增幅比例 */<?='\n'?> public real IntRateDown; /* ATTR减幅比例 */<?='\n'?> public real IntRateBonus; /* 受增减幅影响的bonus值 */<?='\n'?> public real IntFixedBonus;/* 固定加成值(不受增减幅影响) */<?='\n'?> <?='\n'?> /* 设置基础ATTR */<?='\n'?> public method setBaseInt(real value) { <?='\n'?> if (baseInt != value) { <?='\n'?> baseInt = value; <?='\n'?> syncIntRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加基础ATTR */<?='\n'?> public method addBaseInt(real value) { <?='\n'?> if (value != 0) { <?='\n'?> baseInt += value; <?='\n'?> syncIntRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加固定bonus */<?='\n'?> public method addIntFixedBonus(real value) { <?='\n'?> if (value != 0) { <?='\n'?> IntFixedBonus += value; <?='\n'?> syncIntRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加ATTR增幅 */<?='\n'?> public method addIntRateUp(real value) { <?='\n'?> if (value != 0) { <?='\n'?> IntRateUp += value; <?='\n'?> syncIntRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 增加ATTR减幅 */<?='\n'?> public method addIntRateDown(real value) { <?='\n'?> if (value != 0) { <?='\n'?> IntRateDown = RealAdd(IntRateDown, value); <?='\n'?> syncIntRate(); <?='\n'?> } <?='\n'?> } <?='\n'?> <?='\n'?> /* 获取当前总ATTR */<?='\n'?> public method getCurrentInt() -> real { <?='\n'?> return baseInt + IntRateBonus + IntFixedBonus; <?='\n'?> } <?='\n'?> <?='\n'?> /* 获取当前ATTR倍率 */<?='\n'?> public method getCurrentIntRate() -> real { <?='\n'?> return (1.0 + IntRateUp) * (1.0 - IntRateDown) - 1.0; <?='\n'?> } <?='\n'?>
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
	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start
			}, function() {
			//end
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
			//heroAttr
		},null);
	}
	function TTestUTHeroAttr1 (player p) {}
	function TTestUTHeroAttr2 (player p) {}
	function TTestUTHeroAttr3 (player p) {}
	function TTestUTHeroAttr4 (player p) {}
	function TTestUTHeroAttr5 (player p) {}
	function TTestUTHeroAttr6 (player p) {}
	function TTestUTHeroAttr7 (player p) {}
	function TTestUTHeroAttr8 (player p) {}
	function TTestUTHeroAttr9 (player p) {}
	function TTestUTHeroAttr10 (player p) {}
	function TTestActUTHeroAttr1 (string str) {
		player p = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i, num = 0, len = StringLength(str); //获取范围式数字
string paramS []; //所有参数S
integer paramI []; //所有参数I
real	paramR []; //所有参数R
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
		if (paramS[0] == "a") {
		} else if (paramS[0] == "b") {
		}
		p = null;
	}
	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEvent(tr, 0.5, false);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[HeroAttr] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;
		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;
			if (SubString(str, (1)-1, 1) == "-") {
				TTestActUTHeroAttr1(SubString(str, (2)-1, StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTHeroAttr1(GetTriggerPlayer());
			else if(str == "s2") TTestUTHeroAttr2(GetTriggerPlayer());
			else if(str == "s3") TTestUTHeroAttr3(GetTriggerPlayer());
			else if(str == "s4") TTestUTHeroAttr4(GetTriggerPlayer());
			else if(str == "s5") TTestUTHeroAttr5(GetTriggerPlayer());
			else if(str == "s6") TTestUTHeroAttr6(GetTriggerPlayer());
			else if(str == "s7") TTestUTHeroAttr7(GetTriggerPlayer());
			else if(str == "s8") TTestUTHeroAttr8(GetTriggerPlayer());
			else if(str == "s9") TTestUTHeroAttr9(GetTriggerPlayer());
			else if(str == "s10") TTestUTHeroAttr10(GetTriggerPlayer());
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
