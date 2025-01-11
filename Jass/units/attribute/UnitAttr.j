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
