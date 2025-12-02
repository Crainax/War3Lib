#ifndef UnitAttrShowIncluded
#define UnitAttrShowIncluded

// Dz 原生等常量 / 函数（用于 DzGetSelectedLeaderUnit 等）
#include "Crainax/core/constant/JapiConstant.j"

//! zinc
/*
连接UnitPanel和UnitUtils的库  以显示数据
*/
library UnitAttrShow requires UnitPanel,UnitUtils,Hardware {

    // 用于缓存"当前主单位"的上一次属性值，只在本地 UI 使用
    public struct unitAttrShow []{

        // 上一次显示的数值
        private static real    lastAttack  = 0.0;
        private static integer lastDefense = 0;

        private static real lastStr = 0.0;
        private static real lastAgi = 0.0;
        private static real lastInt = 0.0;

        // 上一次的状态（用于判断是否需要更新显示）
        private static boolean lastIsInvulnerable = false;
        private static boolean lastIsMagicImmune = false;
        private static integer lastMainAttrType = -1; // 上一次的主属性类型（-1表示未初始化）

        // 是否已初始化过（第一次刷新时强制更新）
        private static boolean inited = false;

        // 内部：检查单位是否无敌
        private static method isInvulnerable (unit u) -> boolean {
            return GetUnitAbilityLevel(u, 'Avul') > 0 || GetUnitAbilityLevel(u, 'BHds') > 0;
        }

        // 内部：检查单位是否魔免
        private static method isMagicImmune (unit u) -> boolean {
            return GetUnitAbilityLevel(u, 'Amim') > 0 || GetUnitAbilityLevel(u, MAGIC_IMMUNITY_SPELL_ID) > 0;
        }

        // 内部：格式化数值显示（>100万用FormatNumber，否则用I2S(R2I)）
        private static method formatValue (real val) -> string {
            if (val > 1000000.0) {
                return FormatNumber(val);
            } else {
                return I2S(R2I(val));
            }
        }

        // 内部：更新攻击 / 防御显示
        private static method updateAttackDefense (unit u, real atk, integer def) {
            boolean isInvul; boolean isMagicImm; string armorText;

            // 检查状态
            isInvul = unitAttrShow.isInvulnerable(u);
            isMagicImm = unitAttrShow.isMagicImmune(u);

            // 更新攻击显示
            if (!inited || RAbsBJ(atk - lastAttack) > 0.001) {
                lastAttack = atk;
                unitPanel.textAttackValue.setText(unitAttrShow.formatValue(atk));
            }

            // 更新防御显示（处理无敌和魔免状态）
            if (!inited || def != lastDefense || isInvul != lastIsInvulnerable || isMagicImm != lastIsMagicImmune) {
                lastDefense = def;
                lastIsInvulnerable = isInvul;
                lastIsMagicImmune = isMagicImm;

                if (isInvul) {
                    // 无敌：显示红色"无敌的"
                    armorText = "|cffff0000无敌的|r";
                } else if (isMagicImm) {
                    // 魔免：显示"防御值/魔免"（魔免用绿色）
                    armorText = unitAttrShow.formatValue(I2R(def)) + "/|cff00ff00魔免|r";
                } else {
                    // 正常显示防御值
                    armorText = unitAttrShow.formatValue(I2R(def));
                }
                unitPanel.textArmorValue.setText(armorText);
            }
        }

        // 内部：更新三围显示（只在目标为英雄时调用）
        private static method updatePrimaryAttrs (unit u, real strVal, real agiVal, real intVal) {
            integer mainAttrType;

            // 更新主属性图标
            mainAttrType = GetUnitMainAttrType(u);
            if (!inited || mainAttrType != lastMainAttrType) {
                lastMainAttrType = mainAttrType;
                if (mainAttrType == 0) {
                    // STR - 力量
                    unitPanel.iconHero.setTexture(UNITPANEL_ICON_TEXTURE_STR);
                } else if (mainAttrType == 1) {
                    // AGI - 敏捷
                    unitPanel.iconHero.setTexture(UNITPANEL_ICON_TEXTURE_AGI);
                } else if (mainAttrType == 2) {
                    // INT - 智力
                    unitPanel.iconHero.setTexture(UNITPANEL_ICON_TEXTURE_INT);
                }
            }

            if (!inited || RAbsBJ(strVal - lastStr) > 0.001) {
                lastStr = strVal;
                unitPanel.textStrValue.setText(unitAttrShow.formatValue(strVal));
            }

            if (!inited || RAbsBJ(agiVal - lastAgi) > 0.001) {
                lastAgi = agiVal;
                unitPanel.textAgiValue.setText(unitAttrShow.formatValue(agiVal));
            }

            if (!inited || RAbsBJ(intVal - lastInt) > 0.001) {
                lastInt = intVal;
                unitPanel.textIntValue.setText(unitAttrShow.formatValue(intVal));
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
