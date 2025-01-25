#ifndef UnitRegenIncluded
#define UnitRegenIncluded


#include "Crainax/config/SharedMethod.h"
#include "Crainax/core/table/Hash_UnitDefine.j"
#include "Crainax/core/constant/JapiConstant.j" //constant可以直接加进去没问题

//! zinc
/*
单位属性-生命值恢复
*/
library UnitRegen {

	public struct unitRegen {
		private static group regenGroup = CreateGroup();

		private unit u; // 单位

		// 定量回复值
		private real HPRegenFixed = 0.0;     // 每秒定量回血
		private real MPRegenFixed = 0.0;     // 每秒定量回魔

		// 百分比回复值 (基于最大值的百分比)
		private real HPRegenPercent = 0.0;   // 每秒百分比回血
		private real MPRegenPercent = 0.0;   // 每秒百分比回魔

		// 回复效益
		private real RegenEffectUp = 0.0;    // 回复效益增幅
		private real RegenEffectDown = 0.0;  // 回复效益减幅

		STRUCT_SHARED_METHODS(unitRegen)


		// 获取当前回复效益系数
		private method getCurrentRegenEffect() -> real {
			return (1.0 + RegenEffectUp) * (1.0 - RegenEffectDown);
		}

		// 增加定量回血
		public method addHPFixedRegen(real value) {
			HPRegenFixed +=  value;
		}

		// 增加定量回魔
		public method addMPFixedRegen(real value) {
			MPRegenFixed +=  value;
		}

		// 增加百分比回血
		public method addHPPercentRegen(real value) {
			HPRegenPercent +=  value;
		}

		// 增加百分比回魔
		public method addMPPercentRegen(real value) {
			MPRegenPercent +=  value;
		}

		// 增加回复效益增幅
		public method addRegenEffectUp(real up) {
			RegenEffectUp +=  up;
		}
		// 增加回复效益减幅
		public method addRegenEffectDown(real down) {
			RegenEffectDown = RealAdd(RegenEffectDown, down);
		}

		static method parse (unit u) -> thistype {
			thistype this;
			integer handleId = GetHandleId(u);

			// 先检查是否已存在
			if (HaveSavedInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITREGEN)) {
				return LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITREGEN);
			}

			// 不存在才创建新的
			this = allocate();
			this.u = u;
			SaveInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITREGEN, this);

			// 初始化所有回复相关的属性
			this.HPRegenFixed    = 0.0;
			this.MPRegenFixed    = 0.0;
			this.HPRegenPercent  = 0.0;
			this.MPRegenPercent  = 0.0;
			this.RegenEffectUp   = 0.0;
			this.RegenEffectDown = 0.0;
			// 将单位添加到回复组
			GroupAddUnit(regenGroup, u);
			return this;
		}

		static method get (unit u) -> thistype {
			if (HaveSavedInteger(HASH_UNIT, GetHandleId(u),HASH_KEY_UNIT_UNITREGEN )) {
				return LoadInteger(HASH_UNIT, GetHandleId(u), HASH_KEY_UNIT_UNITREGEN);
			}
			return 0;
		}

		method onDestroy () {
			GroupRemoveUnit(regenGroup, u);
			if (HaveSavedInteger(HASH_UNIT, GetHandleId(u),HASH_KEY_UNIT_UNITREGEN )) {
				RemoveSavedInteger(HASH_UNIT, GetHandleId(u), HASH_KEY_UNIT_UNITREGEN);
			}
		}

		// 初始化计时器
		static method onInit() {
			TimerStart(CreateTimer(), 0.25, true, function() {
				ForGroup(regenGroup, function() {
					real hpRegen;
					real mpRegen;
					real eft;
					thistype this = thistype.get(GetEnumUnit());
					if (this.isExist()) {
						eft = this.getCurrentRegenEffect();

						// 计算总回血量
						hpRegen = (this.HPRegenFixed + GetUnitState(GetEnumUnit(), UNIT_STATE_MAX_LIFE) * this.HPRegenPercent) * eft * 0.25;
						if (hpRegen > 0 && GetUnitState(GetEnumUnit(), UNIT_STATE_LIFE) > 0) {
							SetUnitState(GetEnumUnit(), UNIT_STATE_LIFE, GetUnitState(GetEnumUnit(), UNIT_STATE_LIFE) + hpRegen);
						}

						// 计算总回魔量
						mpRegen = (this.MPRegenFixed + GetUnitState(GetEnumUnit(), UNIT_STATE_MAX_MANA) * this.MPRegenPercent) * eft * 0.25;
						if (mpRegen > 0) {
							SetUnitState(GetEnumUnit(), UNIT_STATE_MANA, GetUnitState(GetEnumUnit(), UNIT_STATE_MANA) + mpRegen);
						}
					}
				});
			});
			unitLifeCycle.registerDestroy(function () { // 单位销毁时销毁回复属性
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
#endif
