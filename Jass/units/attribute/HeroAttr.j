#ifndef HeroAttrIncluded
#define HeroAttrIncluded

#include "Crainax/units/attribute/UnitAttr.h"
#include "Crainax/config/SharedMethod.h"
#include "Crainax/core/table/Hash_UnitDefine.j"
#include "Crainax/core/constant/JapiConstant.j" //constant可以直接加进去没问题

//! zinc
/*
英雄的属性
*/
library HeroAttr requires UnitUtils,MathUtils,UnitLifeCycle {

    public enum HeroMainAttrType {
        MAIN_ATTR_STR = 0,
        MAIN_ATTR_AGI = 1,
        MAIN_ATTR_INT = 2
    }

    public struct heroAttr {
        STRUCT_SHARED_METHODS(heroAttr)
		unit u; //绑定的单位

		integer mainAttrType;  // 主属性类型
		real mainAttrRateUp;   // 主属性增幅
		real mainAttrRateDown; // 主属性减幅
		real mainAttrFixedBonus; // 主属性固定加成

		static method parse (unit u, integer mainAttrType) -> thistype {
			thistype this;
			integer handleId = GetHandleId(u);

			// 先检查是否已存在
			if (HaveSavedInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_HEROATTR)) {
				return LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_HEROATTR);
			}

			// 不存在才创建新的
			this = allocate();
			this.u = u;
			this.mainAttrType = mainAttrType;
			this.mainAttrRateUp = 0.0;
			this.mainAttrRateDown = 0.0;
			this.mainAttrFixedBonus = 0.0;

			INIT_COMBAT_ATTR(Str)
			INIT_COMBAT_ATTR(Agi)
			INIT_COMBAT_ATTR(Int)

			SaveInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_HEROATTR, this);
			return this;
		}

		// 获取主属性基础值
		private method getMainAttrBase() -> real {
			if (mainAttrType == MAIN_ATTR_STR) {
				return baseStr;
			} else if (mainAttrType == MAIN_ATTR_AGI) {
				return baseAgi;
			} else if (mainAttrType == MAIN_ATTR_INT) {
				return baseInt;
			}
			return 0.0;
		}

		// 同步并刷新当前单位的力量
		private method syncStrRate() {
			real mainAttrBonus = mainAttrType == MAIN_ATTR_STR ? getMainAttrBase() : 0.0;
			real totalBase = baseStr + mainAttrBonus;
			real mainAttrRate = (1.0 + mainAttrRateUp) * (1.0 - mainAttrRateDown);
			real totalRate = (1.0 + StrRateUp) * (1.0 - StrRateDown) * mainAttrRate;

			StrRateBonus = totalBase * (totalRate - 1.0);
			SetHeroStr(u, R2I(totalBase + StrRateBonus + StrFixedBonus + mainAttrFixedBonus), true);
		}

		// 同步并刷新当前单位的敏捷
		private method syncAgiRate() {
			real mainAttrBonus = mainAttrType == MAIN_ATTR_AGI ? getMainAttrBase() : 0.0;
			real totalBase = baseAgi + mainAttrBonus;
			real mainAttrRate = (1.0 + mainAttrRateUp) * (1.0 - mainAttrRateDown);
			real totalRate = (1.0 + AgiRateUp) * (1.0 - AgiRateDown) * mainAttrRate;

			AgiRateBonus = totalBase * (totalRate - 1.0);
			SetHeroAgi(u, R2I(totalBase + AgiRateBonus + AgiFixedBonus + mainAttrFixedBonus), true);
		}

		// 同步并刷新当前单位的智力
		private method syncIntRate() {
			real mainAttrBonus = mainAttrType == MAIN_ATTR_INT ? getMainAttrBase() : 0.0;
			real totalBase = baseInt + mainAttrBonus;
			real mainAttrRate = (1.0 + mainAttrRateUp) * (1.0 - mainAttrRateDown);
			real totalRate = (1.0 + IntRateUp) * (1.0 - IntRateDown) * mainAttrRate;

			IntRateBonus = totalBase * (totalRate - 1.0);
			SetHeroInt(u, R2I(totalBase + IntRateBonus + IntFixedBonus + mainAttrFixedBonus), true);
		}

		// 添加主属性相关方法
		public method addMainAttrRateUp(real value) {
			if (value != 0) {
				mainAttrRateUp += value;
				syncStrRate();
				syncAgiRate();
				syncIntRate();
			}
		}

		public method addMainAttrRateDown(real value) {
			if (value != 0) {
				mainAttrRateDown = RealAdd(mainAttrRateDown, value);
				syncStrRate();
				syncAgiRate();
				syncIntRate();
			}
		}

		public method addMainAttrFixedBonus(real value) {
			if (value != 0) {
				mainAttrFixedBonus += value;
				syncStrRate();
				syncAgiRate();
				syncIntRate();
			}
		}

		DEFINE_COMBAT_ATTR(Str)
		DEFINE_COMBAT_ATTR(Agi)
		DEFINE_COMBAT_ATTR(Int)



		//单位删除会调用
		method onDestroy () {
			if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),HASH_KEY_UNIT_HEROATTR)) {
				RemoveSavedInteger(HASH_UNIT,GetHandleId(u),HASH_KEY_UNIT_HEROATTR);
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
