#ifndef UnitAttrShowIncluded
#define UnitAttrShowIncluded

// Dz 原生等常量 / 函数（用于 DzGetSelectedLeaderUnit 等）
#include "Crainax/core/constant/JapiConstant.j"

//! zinc
/*
连接UnitPanel和UnitUtils的库  以显示数据
*/
library UnitAttrShow requires UnitPanel,UnitUtils,Hardware {

    // 用于缓存“当前主单位”的上一次属性值，只在本地 UI 使用
    public struct unitAttrShow []{

        // 上一次显示的数值
        private static real    lastAttack  = 0.0;
        private static integer lastDefense = 0;

        private static real lastStr = 0.0;
        private static real lastAgi = 0.0;
        private static real lastInt = 0.0;

        // 是否已初始化过（第一次刷新时强制更新）
        private static boolean inited = false;

        // 内部：更新攻击 / 防御显示
        private static method updateAttackDefense (unit u, real atk, integer def) {
            // 攻击
            if (!inited || RAbsBJ(atk - lastAttack) > 0.001) {
                lastAttack = atk;
                unitPanel.textAttackValue.setText(FormatNumber(atk));
            }

            // 防御
            if (!inited || def != lastDefense) {
                lastDefense = def;
                unitPanel.textArmorValue.setText(FormatNumber(def));
            }
        }

        // 内部：更新三围显示（只在目标为英雄时调用）
        private static method updatePrimaryAttrs (unit u, real strVal, real agiVal, real intVal) {
            if (!inited || RAbsBJ(strVal - lastStr) > 0.001) {
                lastStr = strVal;
                unitPanel.textStrValue.setText(FormatNumber(strVal));
            }

            if (!inited || RAbsBJ(agiVal - lastAgi) > 0.001) {
                lastAgi = agiVal;
                unitPanel.textAgiValue.setText(FormatNumber(agiVal));
            }

            if (!inited || RAbsBJ(intVal - lastInt) > 0.001) {
                lastInt = intVal;
                unitPanel.textIntValue.setText(FormatNumber(intVal));
            }
        }

        // 每帧监控当前主单位的属性变化（攻击 / 防御 / 力敏智）
        private static method setupWatcher () {
            hardware.regUpdateEvent(function () {
                unit    u;
                real    atk;
                integer def;
                real    strVal;
                real    agiVal;
                real    intVal;
                boolean isHero;

                // 当前选择的主单位（英雄 / 领袖）
                u = DzGetSelectedLeaderUnit();

                if (u != null) {
                    // 基础攻击 / 防御（使用 UnitUtils 提供的封装）
                    atk = GetUnitAttack(u);
                    def = GetUnitDefense(u);

                    unitAttrShow.updateAttackDefense(u, atk, def);

                    // 力敏智：只对英雄单位有效
                    isHero = IsHeroUnitId(GetUnitTypeId(u));
                    if (isHero) {
                        strVal = GetHeroStr(u, true);
                        agiVal = GetHeroAgi(u, true);
                        intVal = GetHeroInt(u, true);

                        unitAttrShow.updatePrimaryAttrs(u, strVal, agiVal, intVal);
                    }

                    inited = true;
                }

                // 句柄清理
                u = null;
            });
        }

        // 初始化：注册每帧事件
        static method onInit () {
            unitAttrShow.setupWatcher();
        }

    }
}

//! endzinc
#endif
