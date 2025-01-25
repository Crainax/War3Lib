#ifndef UnitAttrAttackModuleIncluded
#define UnitAttrAttackModuleIncluded


#include "Crainax/units/attribute/UnitAttr.h"
#include "Crainax/config/SharedMethod.h"
#include "Crainax/core/constant/JapiConstant.j" //constant可以直接加进去没问题


//! zinc
library UnitAttrAttackModule {

    public module UnitAttrAttackModule {

        /* 获取当前的攻击范围倍率 */
        public method getCurrentAtkRange() -> real {
            return baseAtkRange * (1.0 + AtkRangeRateUp) * (1.0 - AtkRangeRateDown);
        }

		// 同步并刷新当前单位的攻击范围
		private method syncAtkRange() {
			real desiredRange = getCurrentAtkRange();

            // 设置攻击范围
            SetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_RANGE), desiredRange);
            // 同时更新单位的主动攻击范围，但不超过900
            SetUnitAcquireRange(u, RMaxBJ(desiredRange, 900.0));
		}

        // 攻击范围相关属性和方法
        public  real baseAtkRange;      /* 基础攻击范围值 */
        public  real AtkRangeRateUp;    /* 攻击范围增幅比例 */
        public  real AtkRangeRateDown;  /* 攻击范围减幅比例 */

        /* 增加或减少基础攻击范围 */
        public method addAtkRange(real value) {
            if (value != 0) {
                baseAtkRange += value;
                syncAtkRange();
            }
        }

        /* 增加攻击范围增幅比例 */
        public method addAtkRangeRateUp(real value) {
            if (value != 0) {
                AtkRangeRateUp += value;
                syncAtkRange();
            }
        }

        /* 增加攻击范围减幅比例 */
        public method addAtkRangeRateDown(real value) {
            if (value != 0) {
                AtkRangeRateDown = RealAdd(AtkRangeRateDown, value);
                syncAtkRange();
            }
        }


        // 攻击速度相关属性和方法
        public  real baseAtkSpeed;      /* 基础攻击速度值 */
        public  real AtkSpeedRateDown;  /* 攻击速度减速比例 */

        public method getCurrentAtkSpeed() -> real {
            return baseAtkSpeed * (1.0 - AtkSpeedRateDown);
        }

		// 同步并刷新当前单位的攻击速度
		private method syncAtkSpeed() {
			SetUnitState(u, ConvertUnitState(UNIT_STATE_RATE_OF_FIRE), getCurrentAtkSpeed());
		}

        /* 增加或减少基础攻击速度 */
        public method addAtkSpeed(real value) {
            if (value != 0) {
                baseAtkSpeed += value;
                syncAtkSpeed();
            }
        }

        /* 增加攻击速度减速比例 */
        public method addAtkSpdDown(real value) {
            if (value != 0) {
                AtkSpeedRateDown = RealAdd(AtkSpeedRateDown, value);
                syncAtkSpeed();
            }
        }

        // 攻击间隔相关属性和方法
        public  real baseAtkInterval;      /* 基础攻击间隔值 */
        public  real AtkIntervalRateDown;  /* 攻击间隔减速比例 */

        public method getCurrentAtkInterval() -> real {
            return baseAtkInterval * (1.0 - AtkIntervalRateDown);
        }

		// 同步并刷新当前单位的攻击间隔
		private method syncAtkInterval() {
			SetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_INTERVAL), getCurrentAtkInterval());
		}

        // 设置基础的攻击间隔(这个一般不需要改)
        public method setAtkInterval(real value) {
            if (value != 0) {
                baseAtkInterval += value;
                syncAtkInterval();
            }
        }

        // 按比例减少攻击间隔
        public method addAtkItvDown(real value) {
            if (value != 0) {
                AtkIntervalRateDown = RealAdd(AtkIntervalRateDown, value);
                syncAtkInterval();
            }
        }

        // 初始化攻击相关属性
        public method initAttackAttributes() {
            // 初始化攻击范围
            this.baseAtkRange     = 128;
            this.AtkRangeRateUp   = 0;
            this.AtkRangeRateDown = 0;
            this.syncAtkRange();

            // 初始化攻击速度
            this.baseAtkSpeed = 1.0;
            this.AtkSpeedRateDown = 0.0;
            this.syncAtkSpeed();

            // 初始化攻击间隔
            this.baseAtkInterval = 1.0;
            this.AtkIntervalRateDown = 0.0;
            this.syncAtkInterval();
        }
    }
}
//! endzinc

#endif