#ifndef UnitAttrIncluded
#define UnitAttrIncluded

#include "Crainax/config/SharedMethod.h"
#include "Crainax/core/table/Hash_UnitDefine.h"


//! zinc
/*
单位的属性
*/

library UnitAttr requires UnitUtils {

	struct unitAttr [] {

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
			SaveInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITATTR, this);
			return this;
		}

		public  real baseHP;      // 基础HP值
		public  real hpRateUp;    // HP增幅比例
		public  real hpRateDown;  // HP减幅比例
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
				hpRateDown += value;
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

		//单位删除会调用
		method onDestroy () {
			if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),HASH_KEY_UNIT_UNITATTR)) {
				RemoveSavedInteger(HASH_UNIT,GetHandleId(u),HASH_KEY_UNIT_UNITATTR);
			}
			u = null;
		}

		//注册到周期结束中
		static method onInit () {

		}
	}

}

//! endzinc
#endif
