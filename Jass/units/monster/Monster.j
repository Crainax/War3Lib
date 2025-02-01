#ifndef MonsterIncluded
#define MonsterIncluded


#include "Crainax/units/attribute/UnitAttr.h"
#include "Crainax/config/SharedMethod.h"
#include "Crainax/core/table/Hash_UnitDefine.j"
#include "Crainax/core/constant/JapiConstant.j" //constant可以直接加进去没问题


//! zinc
/*
怪物结构体
包含怪物的基础属性如金币和经验值
*/
library Monster {

    public struct monster {
        unit u;
        // 基础属性
        monsterData md;
		integer gold;
		integer exp;
		integer kill;

        STRUCT_SHARED_METHODS(monster)

        optional module allHeroAttr; //其他地图的自定义属性

        module monsterDrop; //怪物掉落

        // 构造函数(从单位类型来复制内容创建)
        static method parse(unit u) -> thistype {
			thistype this;
			integer handleId = GetHandleId(u);

			// 先检查是否已存在
			if (HaveSavedInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_MONSTER)) {
				return LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_MONSTER);
			}

			// 不存在才创建新的
			this = allocate();
            this.u = u;
			thistype.md = monsterData.byType(GetUnitTypeId(u));
			this.gold = this.md.gold;
			this.exp = this.md.exp;
			this.kill = this.md.kill;

			this.useDefaultDrop();

			static if (LIBRARY_AllMonster) { //其他地图的自定义属性
				this.initAllMonster(); //使用默认掉落模式
			}

			SaveInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_MONSTER, this);
			return this;
        }

		// 新增：构造自定义怪物(不继承monsterData数据)
		static method parseCustom(unit u) -> thistype {
			thistype this;
			integer handleId = GetHandleId(u);

			// 先检查是否已存在
			if (HaveSavedInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_MONSTER)) {
				return LoadInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_MONSTER);
			}

			// 不存在才创建新的
			this = allocate();
			this.u = u;
			this.md = monsterData.byType(GetUnitTypeId(u));

			// 设置基础属性为0，由调用者自行设置
			this.gold = 0;
			this.exp = 0;
			this.kill = 0;

			// 设置为自定义掉落模式
			this.setCustomDrop();

			static if (LIBRARY_AllMonster) {
				this.initAllMonster();  // 这里应该删除,因为是自定义模式
			}

			SaveInteger(HASH_UNIT, handleId, HASH_KEY_UNIT_MONSTER, this);
			return this;
		}

		static method get (unit u) -> thistype {
			if (HaveSavedInteger(HASH_UNIT, GetHandleId(u), HASH_KEY_UNIT_MONSTER)) {
				return LoadInteger(HASH_UNIT, GetHandleId(u), HASH_KEY_UNIT_MONSTER);
			}
			return 0;
		}

        // 析构函数
        method onDestroy() {
            if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),HASH_KEY_UNIT_MONSTER)) {
				RemoveSavedInteger(HASH_UNIT,GetHandleId(u),HASH_KEY_UNIT_MONSTER);
			}
			u = null;
        }

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
