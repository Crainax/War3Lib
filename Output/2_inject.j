#define USE_BJ_ANTI_LEAK
#define USE_BJ_OPTIMIZATION
#include <YDTrigger/Import.h>
#include <YDTrigger/YDTrigger.h>

#ifndef UnitHashTableIncluded
#define UnitHashTableIncluded


#include "Crainax/core/table/Hash_UnitDefine.j"

//! zinc
/*
单位哈希表
*/
library UnitHashTable {

    public hashtable HASH_UNIT = InitHashtable();  // 单位哈希表

}

//! endzinc
#endif

#ifndef UnitAttrIncluded
#define UnitAttrIncluded

#include "Crainax/config/SharedMethod.h"
#include "Crainax/core/table/Hash_UnitDefine.j"
#include "Crainax/core/constant/JapiConstant.j" //constant可以直接加进去没问题


//! zinc
/*
单位的属性
*/

library UnitAttr requires UnitUtils,MathUtils,UnitLifeCycle {

	public struct unitAttr {

		STRUCT_SHARED_METHODS(unitAttr)

		unit u; //绑定的单位

		static method parse (unit u) -> thistype {
			thistype this;
			integer handleId = GetHandleId(u);

			// 先检查是否已存在
			if (HaveSavedInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITATTR)) {
				return LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITATTR);
			}

			// 不存在才创建新的
			this = allocate();
			//todo: 测试一下用setUnitState设超过21亿的数再get能get到吗
			this.u          = u;
			this.baseHP     = 0;
			this.hpRateUp   = 0;
			this.hpRateDown = 0;
			this.cachedHP   = 0;

			// 初始化攻击力相关属性
			this.baseAtk     = 0.0;
			this.atkRateUp   = 0.0;
			this.atkRateDown = 0.0;
			this.rateBonus   = 0.0;
			this.fixedBonus  = 0.0;
			SaveInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITATTR, this);
			return this;
		}

		public  real baseHP;      // 基础HP值
		public  real hpRateUp;    // HP增幅比例
		private real hpRateDown;  // HP减幅比例 (改为private,因为我们要用方法来控制它的叠加)
		private real cachedHP;    // 缓存的实际HP值

		// 同步并刷新当前单位的HP
		private method syncHPRate() {
			real desiredHP;
			real diff;

			// 计算期望的HP值 - 先计算增幅,再计算减幅
			desiredHP = baseHP * (1.0 + hpRateUp) * (1.0 - hpRateDown);

			// 计算差值
			diff = desiredHP - cachedHP;

			// 只有当差值的绝对值大于等于1时才更新
			if (diff >= 1.0 || diff <= -1.0) {
				// 设置最大生命值
				SetUnitState(u, UNIT_STATE_MAX_LIFE, RMaxBJ(desiredHP, 2.0));
				// 如果是增加生命值，同时增加当前生命值
				if (diff > 0) {
					SetUnitLifeBJ(u, GetUnitState(u, UNIT_STATE_LIFE) + diff);
				}
				cachedHP = desiredHP;
			}
		}

		// 增加或减少基础HP
		public method addHP(real value) {
			if (value != 0) {  // 避免不必要的计算
				baseHP += value;
				syncHPRate();
			}
		}

		// 增加HP增幅比例
		public method addHPRateUp(real value) {
			if (value != 0) {  // 避免不必要的计算
				hpRateUp += value;
				syncHPRate();
			}
		}

		// 增加HP减幅比例
		public method addHPRateDown(real value) {
			if (value != 0) {  // 避免不必要的计算
				hpRateDown = RealAdd(hpRateDown, value);
				syncHPRate();
			}
		}

		// 获取当前的HP倍率
		public method getCurrentHPRate() -> real {
			return (1.0 + hpRateUp) * (1.0 - hpRateDown);
		}

		// 获取当前实际HP值
		public method getCurrentHP() -> real {
			return cachedHP;
		}

		// 攻击力相关属性
		public real baseAtk;      // 基础攻击力
		public real atkRateUp;    // 攻击力增幅比例
		public real atkRateDown;  // 攻击力减幅比例
		public real rateBonus;    // 受增减幅影响的bonus值
		public real fixedBonus;   // 固定加成值(不受增减幅影响)

		// 同步并刷新当前单位的攻击力
		private method syncAtkRate() {
			rateBonus = baseAtk * (1.0 + atkRateUp) * (1.0 - atkRateDown) - baseAtk;
			SetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE), RMaxBJ(baseAtk + rateBonus + fixedBonus, 0.0));
		}

		// 设置基础攻击力
		public method setBaseAtk(real value) {
			if (baseAtk != value) {
				baseAtk = value;
				syncAtkRate();
			}
		}

		// 增加基础攻击力
		public method addBaseAtk(real value) {
			if (value != 0) {
				baseAtk += value;
				syncAtkRate();
			}
		}

		// 增加固定bonus
		public method addFixedBonus(real value) {
			if (value != 0) {
				fixedBonus += value;
				syncAtkRate();
			}
		}

		// 增加攻击力增幅
		public method addAtkRateUp(real value) {
			if (value != 0) {
				atkRateUp += value;
				syncAtkRate();
			}
		}

		// 增加攻击力减幅
		public method addAtkRateDown(real value) {
			if (value != 0) {
				atkRateDown = RealAdd(atkRateDown, value);
				syncAtkRate();
			}
		}

		// 获取当前总攻击力
		public method getCurrentAtk() -> real {
			return baseAtk + rateBonus + fixedBonus;
		}

		// 获取当前攻击力倍率
		public method getCurrentAtkRate() -> real {
			return (1.0 + atkRateUp) * (1.0 - atkRateDown);
		}


		//单位删除会调用
		method onDestroy () {
			if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),HASH_KEY_UNIT_UNITATTR)) {
				RemoveSavedInteger(HASH_UNIT,GetHandleId(u),HASH_KEY_UNIT_UNITATTR);
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

		// 获取当前的HP减幅值
		public method getHPRateDown() -> real {
			return hpRateDown;
		}
	}

}

//! endzinc
#endif

#ifndef UnitTestFramworkIncluded
#define UnitTestFramworkIncluded

/*
单元测试框架(注入)
*/

//! zinc
library UnitTestFramwork {

	//单元测试总
	trigger TUnitTest = null;
    private hashtable HASH_UNITTEST = InitHashtable();  // 单元测试哈希表

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
            real maxValue = RMaxBJ(RAbsBJ(actual), RAbsBJ(expected));  // 取两个数的绝对值的较大值
            real epsilon = maxValue * 0.00001;  // 相对误差为数值大小的万分之一
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
        TriggerRegisterTimerEventSingle(tr,time);
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
            TriggerRegisterTimerEventSingle(tr,time+duration);
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

    function onInit ()  {
        //在游戏开始0.1秒后再调用
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr,0.1);
        TriggerAddCondition(tr,Condition(function (){
            integer i;
            for (1 <= i <= 12) {
				SetPlayerName(ConvertedPlayer(i),"测试员" + I2S(i)+ "号");
                CreateFogModifierRectBJ( true, ConvertedPlayer(i), FOG_OF_WAR_VISIBLE, GetPlayableMapRect() ); //迷雾全关
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
#endif



#ifndef MathUtilsIncluded
#define MathUtilsIncluded

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
    public function R2IM (real r)  -> integer {
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
            real x2  = 0; //相交点
            real y2  = 0; //相交点
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
                tan = TanBJ(a);
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
                tan = TanBJ(a);
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
                tan = TanBJ(a);
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
                tan = TanBJ(a);
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
#endif

#ifndef MapBoundsUtilsIncluded
#define MapBoundsUtilsIncluded

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

#endif

#ifndef UnitLifeCycleIncluded
#define UnitLifeCycleIncluded

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

#endif

#ifndef UnitUtilsIncluded
#define UnitUtilsIncluded

#include "Crainax/core/constant/UNDefine.j" //constant可以直接加进去没问题
#include "Crainax/core/constant/JapiConstant.j" //constant可以直接加进去没问题

//! zinc
/*
单位有关的增强功能
*/
library UnitUtils {

    //获取单位的攻击力/防御/生命/魔法值
    public function GetUnitAttack(unit u) -> integer {
        return R2I(GetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE)));
    }

    public function GetUnitDefense(unit u) -> integer {
        return R2I(GetUnitState(u,ConvertUnitState(UNIT_STATE_ARMOR)));
    }

    public function GetUnitHP(unit u) -> real {
        return GetUnitState(u,UNIT_STATE_MAX_LIFE);
    }

    public function GetUnitMP(unit u) -> real {
        return GetUnitState(u,UNIT_STATE_MAX_MANA);
    }

    //设置攻击力
    public function SetUnitAttack(unit u, real attack) -> nothing {
        SetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE),attack);
    }
    //增加攻击力
    public function AddUnitAttack(unit u, real attack) -> nothing {
        SetUnitAttack(u,GetUnitAttack(u) + attack);
    }

    //设置防御
    public function SetUnitDefense(unit u, real defense) -> nothing {
        SetUnitState(u,ConvertUnitState(UNIT_STATE_ARMOR),defense);
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
        if (hp > 0) {SetUnitLifeBJ(u,GetUnitState(u,UNIT_STATE_LIFE)+hp);}
    }
    //回血(定值)
    public function RegenUnitHP(unit u, real volume) -> nothing {
        SetUnitLifeBJ(u,GetUnitState(u,UNIT_STATE_LIFE)+volume);
    }
    //回蓝(百分比)
    public function RegenUnitHPPercent(unit u, real rate) -> nothing {
        SetUnitLifeBJ(u,GetUnitState(u,UNIT_STATE_LIFE)+GetUnitHP(u)*rate);
    }

    //设置魔法最大值
    public function SetUnitMP(unit u, real mp) -> nothing {
        SetUnitState(u,UNIT_STATE_MAX_MANA,mp);
    }
    //增加魔法最大值
    public function AddUnitMP(unit u,real mp ) {
        SetUnitMP(u,GetUnitMP(u)+mp);
        if (mp > 0) {SetUnitManaBJ(u,GetUnitState(u,UNIT_STATE_MANA)+mp);}
    }
    //回蓝(定值)
    public function RegenUnitMP(unit u, real volume) -> nothing {
        SetUnitManaBJ(u,GetUnitState(u,UNIT_STATE_MANA)+volume);
    }
    //回蓝(百分比)
    public function RegenUnitMPPercent(unit u, real rate) -> nothing {
        SetUnitManaBJ(u,GetUnitState(u,UNIT_STATE_MANA)+GetUnitMP(u)*rate);
    }

    // 获取移速
    public function GetUnitSpeed (unit u)  -> integer {
        if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED)) { //突破522与0的移速的Hook
            return LoadInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED);
        }
        else {return R2I(GetUnitMoveSpeed(u));}
    }
    //todo: 这个UNTable其他地图需要兼容
    // 增加移速
    public function AddUnitSpeed (unit u,integer speed) {
        integer value;
        if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED)) { //突破522与0的移速的Hook
            value  = LoadInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED);
            value += speed;
            SaveInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED,value);
        } else {value = R2I(GetUnitMoveSpeed(u)) + speed;}
		SetUnitMoveSpeed(u,value);
    }
    // 初始化突破移速
    public function InitUnitSpeed (unit u) {
        SaveInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED,R2I(GetUnitMoveSpeed(u)));
    }

    //射程(还会+警戒范围)
    public function GetUnitAttackRange(unit u) -> real {
        return GetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_RANGE));
    }
    //设置射程(还会设置警戒范围)
    public function SetUnitAttackRange (unit u,real range) {
		SetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_RANGE),range);
		SetUnitAcquireRange(u,RMaxBJ(range,900.0));
    }
    //增加射程(还会+警戒范围)
	public function AddUnitAttackRange (unit u,real range) {
		SetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_RANGE),GetUnitAttackRange(u) + range);
		SetUnitAcquireRange(u,RMaxBJ(GetUnitAcquireRange(u)+range,900.0));
    }

    // 获取攻速
    public function GetUnitAttackSpeed(unit u) -> real {
        return GetUnitState(u,ConvertUnitState(UNIT_STATE_RATE_OF_FIRE));
    }
    // 增加攻速
	public function AddUnitAttackSpeed (unit u,real speed) {
		SetUnitState(u,ConvertUnitState(UNIT_STATE_RATE_OF_FIRE),GetUnitState(u,ConvertUnitState(UNIT_STATE_RATE_OF_FIRE)) + speed);
	}

    public function GetUnitInterval(unit u) -> real {
        return GetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_INTERVAL));
    }
    // 攻击间隔(虽然写着加,但是实际是减)
	public function AddAttackInterval (unit u,real value) {
        SetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_INTERVAL),GetUnitInterval(u) - value);
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
#endif

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
/*
 * 单位属性系统测试文件
 *
 * 测试命令说明：
 *
 * HP相关命令：
 * -addhp [value] : 增加基础HP
 * -hpup [value] : 设置HP增幅比例
 * -hpdown [value] : 设置HP减幅比例
 *
 * 攻击力相关命令：
 * -atk [value] : 设置基础攻击力
 * -addatk [value] : 增加基础攻击力
 * -atkup [value] : 设置攻击力增幅比例
 * -atkdown [value] : 设置攻击力减幅比例
 * -atkbonus [value] : 设置攻击力固定加成
 */
//! zinc
library UTUnitAttr requires UnitAttr {
	private unit testUnit = null;
	private unitAttr testAttr = 0;
	// 创建测试单位
	private function CreateTestUnit(player p) {
		if (testUnit != null) {
			RemoveUnit(testUnit);
		}
		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0); // 使用步兵作为测试单位
testAttr = unitAttr.parse(testUnit);
		testAttr.addHP(100);
		SelectUnit(testUnit,true);
	}
	// 测试基础HP的增减
	function TTestUTUnitAttr1(player p) {
	}
	// 测试HP增幅比例
	function TTestUTUnitAttr2(player p) {
	}
	// 测试HP减幅比例
	function TTestUTUnitAttr3(player p) {
	}
	// 测试HP增减幅组合效果
	function TTestUTUnitAttr4(player p) {
	}
	// 参数化测试处理函数
	function TTestActUTUnitAttr1(string str) {
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
		if (testUnit == null) {
			CreateTestUnit(p);
		}
		// HP相关命令
		if (paramS[0] == "addhp") {
			// 增加基础HP
			testAttr.addHP(paramR[1]);
			BJDebugMsg("增加基础HP: " + R2S(paramR[1]));
		} else if (paramS[0] == "hpup") {
			// 设置HP增幅
			testAttr.addHPRateUp(paramR[1]);
			BJDebugMsg("设置HP增幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "hpdown") {
			// 设置HP减幅
			testAttr.addHPRateDown(paramR[1]);
			BJDebugMsg("设置HP减幅为: " + R2S(paramR[1]));
		}
		// 攻击力相关命令
		else if (paramS[0] == "atk") {
			// 设置基础攻击力
			testAttr.setBaseAtk(paramR[1]);
			BJDebugMsg("设置基础攻击力为: " + R2S(paramR[1]));
		} else if (paramS[0] == "addatk") {
			// 增加基础攻击力
			testAttr.addBaseAtk(paramR[1]);
			BJDebugMsg("增加基础攻击力: " + R2S(paramR[1]));
		} else if (paramS[0] == "atkup") {
			// 设置攻击力增幅
			testAttr.addAtkRateUp(paramR[1]);
			BJDebugMsg("设置攻击力增幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "atkdown") {
			// 设置攻击力减幅
			testAttr.addAtkRateDown(paramR[1]);
			BJDebugMsg("设置攻击力减幅为: " + R2S(paramR[1]));
		} else if (paramS[0] == "atkbonus") {
			// 设置固定加成
			testAttr.addFixedBonus(paramR[1]);
			BJDebugMsg("设置固定加成为: " + R2S(paramR[1]));
		}
		// 显示当前状态
		if (paramS[0] == "hp" || paramS[0] == "addhp" || paramS[0] == "hpup" || paramS[0] == "hpdown") {
			BJDebugMsg("当前HP: " + R2S(testAttr.getCurrentHP()));
			BJDebugMsg("当前HP倍率: " + R2S(testAttr.getCurrentHPRate()));
		} else {
			BJDebugMsg("攻击力: " + R2S(testAttr.baseAtk) + " + " + R2S(testAttr.rateBonus + testAttr.fixedBonus));
		}
		p = null;
	}
	function Init() {
		player p = Player(0);
		BJDebugMsg("=== UnitAttr测试系统已加载 ===");
		// 创建测试单位
		CreateTestUnit(p);
		// 测试1.1：测试初始HP
		UnitTestAutoTimer(0.1, 0, function() {
			assert.Real(testAttr.getCurrentHP(), 100.0, "初始HP应为100");
		}, null);
		// 测试1.2：测试增加HP
		UnitTestAutoTimer(0.6, 0, function() {
			testAttr.addHP(50);
			assert.Real(testAttr.getCurrentHP(), 150.0, "增加50点HP后应为150");
		}, null);
		// 测试1.3：测试减少HP
		UnitTestAutoTimer(1.1, 0, function() {
			testAttr.addHP(-30);
			assert.Real(testAttr.getCurrentHP(), 120.0, "减少30点HP后应为120");
		}, null);
		// 测试2：HP增幅比例测试
		UnitTestAutoTimer(1.6, 0, function() {
			CreateTestUnit(Player(0));
			testAttr.addHPRateUp(0.5);
			assert.Real(testAttr.getCurrentHP(), 150.0, "增加50%增幅后应为150");
			assert.Real(testAttr.getCurrentHPRate(), 1.5, "当前HP倍率应为1.5");
		}, null);
		// 测试3：HP减幅比例测试
		UnitTestAutoTimer(2.1, 0, function() {
			CreateTestUnit(Player(0));
			testAttr.addHPRateDown(0.3);
			assert.Real(testAttr.getCurrentHP(), 70.0, "增加30%减幅后应为70");
			assert.Real(testAttr.getCurrentHPRate(), 0.7, "当前HP倍率应为0.7");
		}, null);
		// 测试4：HP增减幅组合效果测试
		UnitTestAutoTimer(2.6, 0, function() {
			CreateTestUnit(Player(0));
			testAttr.addHPRateUp(0.5);
			testAttr.addHPRateDown(0.2);
			assert.Real(testAttr.getCurrentHP(), 120.0, "增加50%增幅,20%减幅后应为120");
			assert.Real(testAttr.getCurrentHPRate(), 1.2, "当前HP倍率应为1.2");
		}, null);
		// 测试5：HP减幅的递减收益测试
		UnitTestAutoTimer(3.1, 0, function() {
			CreateTestUnit(Player(0));
			// 测试两个30%减幅的叠加
			testAttr.addHPRateDown(0.3);
			testAttr.addHPRateDown(0.3);
			// 期望值：1 - (1-0.3)*(1-0.3) = 0.51，所以最终HP应该是100*(1-0.51)=49
			assert.Real(testAttr.getCurrentHP(), 49.0, "两个30%减幅叠加后应为49");
			assert.Real(testAttr.getHPRateDown(), 0.51, "两个30%减幅叠加后减幅值应为0.51");
			// 测试第三个30%减幅的叠加
			testAttr.addHPRateDown(0.3);
			// 期望值：1 - (1-0.51)*(1-0.3) ≈ 0.657，所以最终HP应该是100*(1-0.657)=34.3
			assert.Real(testAttr.getCurrentHP(), 34.3, "三个30%减幅叠加后应为34.3");
			assert.Real(testAttr.getHPRateDown(), 0.657, "三个30%减幅叠加后减幅值应为0.657");
		}, null);
		// 测试6：HP减幅的反向恢复测试
		UnitTestAutoTimer(3.6, 0, function() {
			CreateTestUnit(Player(0));
			// 先加一个减幅
			testAttr.addHPRateDown(0.3);
			assert.Real(testAttr.getCurrentHP(), 70.0, "30%减幅后应为70");
			// 加入反向值测试恢复
			testAttr.addHPRateDown(-0.3);
			assert.Real(testAttr.getCurrentHP(), 100.0, "加入反向值后应恢复到100");
			assert.Real(testAttr.getHPRateDown(), 0.0, "加入反向值后减幅应为0");
		}, null);
		// 测试7：HP减幅的复杂叠加测试
		UnitTestAutoTimer(4.1, 0, function() {
			CreateTestUnit(Player(0));
			// 测试多个不同数值的减幅叠加
			testAttr.addHPRateDown(0.2); // 20%减幅
testAttr.addHPRateDown(0.3); // 30%减幅
testAttr.addHPRateDown(0.1); // 10%减幅

			// 计算期望值：
			// 第一次：0.2
			// 第二次：1-(1-0.2)*(1-0.3) = 0.44
			// 第三次：1-(1-0.44)*(1-0.1) ≈ 0.496
			assert.Real(testAttr.getCurrentHP(), 50.4, "20%,30%,10%减幅叠加后应为50.4");
			assert.Real(testAttr.getHPRateDown(), 0.496, "20%,30%,10%减幅叠加后减幅值应为0.496");
		}, null);
		// 测试8：基础攻击力测试
		UnitTestAutoTimer(4.6, 0, function() {
			CreateTestUnit(Player(0));
			// 测试设置基础攻击力
			testAttr.setBaseAtk(100.0);
			assert.Real(testAttr.baseAtk, 100.0, "设置基础攻击力应为100");
			assert.Real(testAttr.getCurrentAtk(), 100.0, "当前攻击力应为100");
			// 测试增加基础攻击力
			testAttr.addBaseAtk(50.0);
			assert.Real(testAttr.baseAtk, 150.0, "增加50点后基础攻击力应为150");
			assert.Real(testAttr.getCurrentAtk(), 150.0, "当前攻击力应为150");
		}, null);
		// 测试9：攻击力增幅测试
		UnitTestAutoTimer(5.1, 0, function() {
			CreateTestUnit(Player(0));
			testAttr.setBaseAtk(100.0);
			// 测试增幅效果
			testAttr.addAtkRateUp(0.5); // 增加50%
assert.Real(testAttr.getCurrentAtk(), 150.0, "50%增幅后攻击力应为150");
			assert.Real(testAttr.getCurrentAtkRate(), 1.5, "当前攻击力倍率应为1.5");
			// 测试固定加成
			testAttr.addFixedBonus(30.0);
			assert.Real(testAttr.getCurrentAtk(), 180.0, "加30点固定加成后应为180");
			assert.Real(testAttr.fixedBonus, 30.0, "固定加成应为30");
		}, null);
		// 测试10：攻击力减幅的递减收益测试
		UnitTestAutoTimer(5.6, 0, function() {
			CreateTestUnit(Player(0));
			testAttr.setBaseAtk(100.0);
			// 测试两个30%减幅的叠加
			testAttr.addAtkRateDown(0.3);
			testAttr.addAtkRateDown(0.3);
			// 期望值：1 - (1-0.3)*(1-0.3) = 0.51
			assert.Real(testAttr.getCurrentAtk(), 49.0, "两个30%减幅叠加后攻击力应为49");
			assert.Real(testAttr.atkRateDown, 0.51, "两个30%减幅叠加后减幅值应为0.51");
			// 测试第三个30%减幅的叠加
			testAttr.addAtkRateDown(0.3);
			// 期望值：1 - (1-0.51)*(1-0.3) ≈ 0.657
			assert.Real(testAttr.getCurrentAtk(), 34.3, "三个30%减幅叠加后攻击力应为34.3");
			assert.Real(testAttr.atkRateDown, 0.657, "三个30%减幅叠加后减幅值应为0.657");
			// 测试恢复减幅效果
			testAttr.addAtkRateDown(-0.3);
			testAttr.addAtkRateDown(-0.3);
			testAttr.addAtkRateDown(-0.3);
			assert.Real(testAttr.getCurrentAtk(), 100.0, "三个-30%减幅叠加后攻击力应恢复为100");
			assert.Real(testAttr.atkRateDown, 0.0, "三个-30%减幅叠加后减幅值应恢复为0");
		}, null);
		// 测试11：攻击力增减幅组合效果测试
		UnitTestAutoTimer(6.1, 0, function() {
			CreateTestUnit(Player(0));
			testAttr.setBaseAtk(100.0);
			// 测试增幅和减幅的组合效果
			testAttr.addAtkRateUp(0.5); // 增加50%
testAttr.addAtkRateDown(0.2); // 减少20%
// 计算：100 * (1 + 0.5) * (1 - 0.2) = 120
assert.Real(testAttr.getCurrentAtk(), 120.0, "50%增幅20%减幅后攻击力应为120");
			assert.Real(testAttr.getCurrentAtkRate(), 1.2, "当前攻击力倍率应为1.2");
			// 添加固定加成测试
			testAttr.addFixedBonus(30.0);
			assert.Real(testAttr.getCurrentAtk(), 150.0, "加30点固定加成后应为150");
		}, null);
		p = null;
	}
	function onInit() {
		//在游戏开始0.5秒后初始化
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function() {
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;
		// 注册聊天事件
		UnitTestRegisterChatEvent(function() {
			string str = GetEventPlayerChatString();
			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitAttr1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "hp1") TTestUTUnitAttr1(GetTriggerPlayer());
			else if(str == "hp2") TTestUTUnitAttr2(GetTriggerPlayer());
			else if(str == "hp3") TTestUTUnitAttr3(GetTriggerPlayer());
			else if(str == "hp4") TTestUTUnitAttr4(GetTriggerPlayer());
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
