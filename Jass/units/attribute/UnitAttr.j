#ifndef UnitAttrIncluded
#define UnitAttrIncluded

#include "Crainax/units/attribute/UnitAttr.h"
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
			this.u          = u;

			INIT_UNIT_ATTR(HP)
			INIT_UNIT_ATTR(MP)

			// 初始化攻击力和防御力相关属性
			INIT_COMBAT_ATTR(Atk)
			INIT_COMBAT_ATTR(Def)

			// 初始化技能伤害增幅
			INIT_PERCENTAGE_ATTR(SpellDmg)

			SaveInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_UNITATTR, this);
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
			SetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE), RMaxBJ(baseAtk + AtkRateBonus + AtkFixedBonus, 0.0));
		}

		// 同步并刷新当前单位的防御
		private method syncDefRate() {
			DefRateBonus = baseDef * (1.0 + DefRateUp) * (1.0 - DefRateDown) - baseDef;
			SetUnitState(u, ConvertUnitState(UNIT_STATE_ARMOR), baseDef + DefRateBonus + DefFixedBonus);
		}

		// 使用宏定义生成HP相关属性和方法
		DEFINE_UNIT_ATTR(HP)

		// 使用宏定义生成MP相关属性和方法
		DEFINE_UNIT_ATTR(MP)

		// 使用宏定义生成攻击力相关属性和方法
		DEFINE_COMBAT_ATTR(Atk)

		// 使用宏定义生成防御力相关属性和方法
		DEFINE_COMBAT_ATTR(Def)

		// 使用宏定义生成技能伤害增幅
		DEFINE_PERCENTAGE_ATTR(SpellDmg)

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

	}

}

//! endzinc
#endif
