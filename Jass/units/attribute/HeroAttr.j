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
library HeroAttr requires ConversionUtils,UnitAttr {

	public constant integer MAIN_ATTR_STR = 0; //主属性:力量
	public constant integer MAIN_ATTR_AGI = 1; //主属性:敏捷
	public constant integer MAIN_ATTR_INT = 2; //主属性:智力

	public struct heroAttr {
		STRUCT_SHARED_METHODS(heroAttr)
		static thistype ethis = 0;
		unit u; //绑定的单位

		integer mainAttrType;  // 主属性类型

		real mainAttrBase;        // 基础主属性
		real mainAttrRateUp;      // 主属性增幅
		real mainAttrRateDown;    // 主属性减幅
		real mainAttrFixedBonus;  // 主属性固定加成

		real subAttrBase;        // 基础次属性
		real subAttrRateUp;      // 次属性增幅
		real subAttrRateDown;    // 次属性减幅
		real subAttrFixedBonus;  // 次属性固定加成

		// 展开的Str属性相关代码
		/* 基础属性值及加成系数 */

		DEFINE_HERO_ATTR(Str,STR)
		DEFINE_HERO_ATTR(Agi,AGI)
		DEFINE_HERO_ATTR(Int,INT)

		static method parse (unit u, integer mainAttrType) -> thistype {
			thistype this;
			integer handleId = GetHandleId(u);

			// 先检查是否已存在
			if (HaveSavedInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_HEROATTR)) {
				return LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_HEROATTR);
			} else if (!IsHeroUnitId(GetUnitTypeId(u))) {
				// 如果不是英雄单位就不给创建
				return 0;
			}


			// 不存在才创建新的
			this = allocate();
			this.u = u;

			this.mainAttrType       = mainAttrType;

			this.mainAttrBase       = 0.0;
			this.mainAttrRateUp     = 0.0;
			this.mainAttrRateDown   = 0.0;
			this.mainAttrFixedBonus = 0.0;

			this.subAttrBase       = 0.0;
			this.subAttrRateUp     = 0.0;
			this.subAttrRateDown   = 0.0;
			this.subAttrFixedBonus = 0.0;

			INIT_COMBAT_ATTR(Str)
			INIT_COMBAT_ATTR(Agi)
			INIT_COMBAT_ATTR(Int)

			SaveInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_HEROATTR, this);
			return this;
		}

        //仅获取已创建的,不创建新的
		static method get (unit u) -> thistype {
			if (HaveSavedInteger(HASH_UNIT, GetHandleId(u), HASH_KEY_UNIT_HEROATTR)) {
				return LoadInteger(HASH_UNIT, GetHandleId(u), HASH_KEY_UNIT_HEROATTR);
			}
			return 0;
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

		/* 切换主属性类型 */
		public method switchMainAttr(integer newMainAttrType) {
            boolean isStr = mainAttrType == MAIN_ATTR_STR || newMainAttrType == MAIN_ATTR_STR;
            boolean isAgi = mainAttrType == MAIN_ATTR_AGI || newMainAttrType == MAIN_ATTR_AGI;
            boolean isInt = mainAttrType == MAIN_ATTR_INT || newMainAttrType == MAIN_ATTR_INT;

			if (mainAttrType != newMainAttrType) {
				// 切换主属性类型
				mainAttrType = newMainAttrType;

				// 同步三种属性
				if (isStr) syncStrRate();
				if (isAgi) syncAgiRate();
				if (isInt) syncIntRate();
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
