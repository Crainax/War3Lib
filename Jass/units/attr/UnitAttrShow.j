#ifndef UnitAttrShowIncluded
#define UnitAttrShowIncluded

// Dz 原生等常量 / 函数（用于 DzGetSelectedLeaderUnit 等）
#include "Crainax/core/constant/JapiConstant.j"

//! zinc
/*
连接UnitPanel和UnitUtils的库  以显示数据
*/
library UnitAttrShow requires UnitPanel,UnitUtils,Hardware,UnitBuff,UnitFilter {

    // 用于缓存"当前主单位"的上一次属性值，只在本地 UI 使用
    public struct unitAttrShow []{

        // 上一次显示的数值
        private static real    lastAttack  = 0.0;
        private static integer lastDefense = 0;

        // 力敏智缓存（白字和额外值仅用于本地 UI 去重）
        private static real lastStr = 0.0;
        private static real lastAgi = 0.0;
        private static real lastInt = 0.0;
        private static real lastStrExtra = 0.0;
        private static real lastAgiExtra = 0.0;
        private static real lastIntExtra = 0.0;
        private static boolean lastShowStrExtra = false;
        private static boolean lastShowAgiExtra = false;
        private static boolean lastShowIntExtra = false;
        private static boolean lastSplitPrimaryAttrs = false;

        // 攻击扩展显示缓存
        private static real    lastAttackRate       = 1.0;   // 上一次的总倍率
        private static real    lastAttackExtra      = 0.0;   // 上一次的额外攻击（绿/红字）
        private static boolean lastShowAttackExtra  = false; // 上一次是否显示额外攻击
        private static boolean lastShowAttackRate   = false; // 上一次是否显示攻击百分比
        // 攻击数值自定义显示缓存
        private static string  lastAttackValueStr   = null;  // 上一次的自定义攻击显示文本
        private static boolean lastShowAttackValueStr = false; // 上一次是否使用自定义攻击显示
        private static boolean lastIsDisarmed       = false; // 上一次是否显示缴械状态

        // 防御扩展显示缓存
        private static integer lastDefenseExtra      = 0;     // 上一次的额外防御（绿/红字）
        private static boolean lastShowDefenseExtra  = false; // 上一次是否显示额外防御

        // 魔抗显示缓存
        private static real    lastResistValue       = 0.0;   // 上一次的魔抗值（1.0 - final）
        private static boolean lastShowResist        = false; // 上一次是否显示魔抗

        // 攻击图标自定义显示缓存
        private static string  lastAtkCornerText     = null;  // 上一次的角标文本
        private static string  lastAtkTexture        = null;  // 上一次的贴图路径
        private static boolean lastShowAtkCornerText = false; // 上一次是否显示角标
        private static boolean lastShowAtkTexture   = false; // 上一次是否使用自定义贴图

        // 上一次的状态（用于判断是否需要更新显示）
        private static boolean lastIsInvulnerable = false;
        private static boolean lastIsMagicImmune = false;
        private static integer lastMainAttrType = -1; // 上一次的主属性类型（-1表示未初始化）

        // 是否已初始化过（第一次刷新时强制更新）
        private static boolean inited = false;

        // 内部：检查单位是否无敌
        private static method isInvulnerable (unit u) -> boolean {
            return IsUnitInvulnerableEx(u);
        }

        // 内部：检查单位是否魔免
        private static method isMagicImmune (unit u) -> boolean {
            return GetUnitAbilityLevel(u, 'Amim') > 0 || GetUnitAbilityLevel(u, MAGIC_IMMUNITY_SPELL_ID) > 0;
        }

        // 内部：格式化数值显示（>100万用FormatNumber，否则用I2S(R2I)）
        private static method formatValue (real val) -> string {
            if (val > 10000.0) {
                return FormatNumber(val);
            } else {
                return I2S(R2I(val));
            }
        }

        // 内部：更新攻击 / 防御显示
        private static method updateAttackDefense (unit u, real atk, integer def) {
            boolean isInvul; boolean isMagicImm; string armorText;
            real baseAtk; real extraAtk; boolean showExtra;
            string extraText;
            string atkValueStr; boolean showAtkValueStr;
            boolean isDisarmed; boolean forceAttackValueRefresh;
            real rate; real deltaRate; boolean showRate;
            string atkLabel; real percentAbs; string percentStr;
            integer baseDef; integer extraDef; boolean showDefExtra;
            string defLabel; string defExtraText; string defValueText;
            real resistFinal; real resistValue; integer resistPercent; string resistText; boolean showResist;

            // === 攻击倍率显示（在“攻击:”后显示 (+xx.x%) / (-xx.x%)） ===
            rate = GetUnitAttackFinalPercent(u);
            deltaRate = rate - 1.0;
            showRate = RAbsBJ(deltaRate) > 0.01;

            if (showRate) {
                percentAbs = RAbsBJ(deltaRate * 100.0);
                percentStr = I2S(R2I(percentAbs + 0.5));
                if (deltaRate > 0.0) {
                    atkLabel = "攻击:|cff00ff00(+" + percentStr + "%)";
                } else {
                    atkLabel = "攻击:|cffff0000(-" + percentStr + "%)";
                }
            } else {
                atkLabel = "攻击:";
            }

            if (!inited || RAbsBJ(rate - lastAttackRate) > 0.001 || showRate != lastShowAttackRate) {
                unitPanel.textAttack.setText(atkLabel);
                lastAttackRate = rate;
                lastShowAttackRate = showRate;
            }

            // === 攻击数值拆分：基础攻击 + 额外攻击（绿/红字） ===
            // 仅当额外值的绝对值大于基础值的千分之一时才认为有“额外攻击”，避免实数精度造成的小数误差
            baseAtk = GetUnitBaseAttack(u);
            extraAtk = atk - baseAtk;
            showExtra = RAbsBJ(extraAtk) >= RMaxBJ(1.0,RAbsBJ(baseAtk) * 0.001);

            // 攻击数值：缴械优先于自定义字符串和普通数值显示
            atkValueStr = GetUnitAtkValueStr(u);
            showAtkValueStr = (atkValueStr != null);
            isDisarmed = IsUnitDisarmed(u);
            forceAttackValueRefresh = lastIsDisarmed && !isDisarmed;

            if (isDisarmed) {
                if (!inited || !lastIsDisarmed) {
                    unitPanel.textAttackValue.setText("|cffff0000被缴械|r");
                }
                lastIsDisarmed = true;
                lastAttackValueStr = null;
                lastShowAttackValueStr = false;

                if (!inited || lastShowAttackExtra) {
                    unitPanel.showAttackExtra(false);
                    lastShowAttackExtra = false;
                    lastAttackExtra = 0.0;
                }
            } else {
                if (forceAttackValueRefresh) {
                    lastIsDisarmed = false;
                    lastAttackValueStr = null;
                    lastShowAttackValueStr = false;
                }

                if (showAtkValueStr) {
                    if (!inited || forceAttackValueRefresh || !lastShowAttackValueStr || atkValueStr != lastAttackValueStr) {
                        unitPanel.textAttackValue.setText(atkValueStr);
                        lastAttackValueStr = atkValueStr;
                        lastShowAttackValueStr = true;
                    }
                    // 强制隐藏额外攻击显示
                    if (!inited || forceAttackValueRefresh || lastShowAttackExtra) {
                        unitPanel.showAttackExtra(false);
                        lastShowAttackExtra = false;
                        lastAttackExtra = 0.0;
                    }
                } else {
                    // 从“自定义显示”或“缴械显示”切回“数值显示”时，强制刷新一次
                    if (!inited || forceAttackValueRefresh || lastShowAttackValueStr) {
                        lastAttackValueStr = null;
                        lastShowAttackValueStr = false;
                        lastAttack = baseAtk;
                        unitPanel.textAttackValue.setText(unitAttrShow.formatValue(baseAtk));
                    } else {
                        // 正常数值显示：只在变化时刷新
                        if (RAbsBJ(baseAtk - lastAttack) > 0.001) {
                            lastAttack = baseAtk;
                            unitPanel.textAttackValue.setText(unitAttrShow.formatValue(baseAtk));
                        }
                    }
                }

                // 更新额外攻击显示
                if (!showAtkValueStr && showExtra) {
                    percentAbs = RAbsBJ(extraAtk);
                    percentStr = unitAttrShow.formatValue(percentAbs);
                    if (extraAtk > 0.0) {
                        extraText = "|cff00ff00+" + percentStr;
                    } else {
                        extraText = "|cffff0000-" + percentStr;
                    }

                    if (!inited || forceAttackValueRefresh || !lastShowAttackExtra || RAbsBJ(extraAtk - lastAttackExtra) > 0.001) {
                        unitPanel.showAttackExtra(true);
                        unitPanel.textAttackExtra.setText(extraText);
                        lastAttackExtra = extraAtk;
                        lastShowAttackExtra = true;
                    }
                } else {
                    if (!inited || forceAttackValueRefresh || lastShowAttackExtra) {
                        unitPanel.showAttackExtra(false);
                        lastShowAttackExtra = false;
                        lastAttackExtra = 0.0;
                    }
                }
            }

            // 检查状态（无敌 / 魔免，用于防御显示）
            isInvul = unitAttrShow.isInvulnerable(u);
            isMagicImm = unitAttrShow.isMagicImmune(u);

            // === 防御数值拆分：基础防御 + 额外防御（绿/红字） ===
            baseDef = GetUnitBaseDefense(u);
            extraDef = def - baseDef;
            showDefExtra = extraDef != 0;

            // 计算魔抗值（仅在非魔免时计算）
            if (isMagicImm) {
                showResist = false;
                resistValue = 0.0;
            } else {
                resistFinal = GetUnitResistFinal(u);
                resistValue = 1.0 - resistFinal;
                showResist = RAbsBJ(resistValue) >= 0.01;
            }

            // 更新防御标签显示（包含魔免和魔抗状态，顺序：魔免 > 魔抗）
            if (!inited || isMagicImm != lastIsMagicImmune || showResist != lastShowResist || (showResist && RAbsBJ(resistValue - lastResistValue) > 0.001)) {
                if (isMagicImm) {
                    // 魔免：显示"护甲:|cff00ff00(魔免)|r"
                    unitPanel.textArmor.setText("护甲:|cff00ff00(魔免)|r");
                } else if (showResist) {
                    // 魔抗：根据正负值显示不同颜色
                    resistPercent = R2I((RAbsBJ(resistValue) * 100.0) + 0.05);
                    if (resistValue >= 0.01) {
                        // 正数：绿色显示 (15%魔抗)
                        resistText = "护甲:|cff00ff00(" + I2S(resistPercent) + "%魔抗)|r";
                    } else {
                        // 负数：红色显示，用正数 (50%魔易)
                        resistText = "护甲:|cffff0000(" + I2S(resistPercent) + "%魔易)|r";
                    }
                    unitPanel.textArmor.setText(resistText);
                } else {
                    // 正常显示
                    unitPanel.textArmor.setText("护甲:");
                }
                lastIsMagicImmune = isMagicImm;
                lastResistValue = resistValue;
                lastShowResist = showResist;
            }

            // 更新防御显示（处理无敌和魔免状态）
            if (!inited || def != lastDefense || isInvul != lastIsInvulnerable) {

                lastDefense = def;
                lastIsInvulnerable = isInvul;

                if (isInvul) {
                    // 无敌：显示红色"无敌的"
                    armorText = "|cffff0000无敌的|r";
                    unitPanel.textArmorValue.setText(armorText);
                    unitPanel.showArmorExtra(false);
                    lastShowDefenseExtra = false;
                    lastDefenseExtra = 0;
                } else {
                    // 正常显示：基础防御
                    defValueText = unitAttrShow.formatValue(I2R(baseDef));
                    unitPanel.textArmorValue.setText(defValueText);

                    // 额外防御通过 textArmorExtra 显示
                    if (showDefExtra) {
                        if (extraDef > 0) {
                            defExtraText = "|cff00ff00+" + unitAttrShow.formatValue(I2R(extraDef)) + "|r";
                        } else {
                            defExtraText = "|cffff0000-" + unitAttrShow.formatValue(I2R(-extraDef)) + "|r";
                        }

                        // 参考攻击逻辑：只有在第一次或数值变化时才刷新额外文本
                        if (!inited || !lastShowDefenseExtra || extraDef != lastDefenseExtra) {
                            unitPanel.showArmorExtra(true);
                            unitPanel.textArmorExtra.setText(defExtraText);
                            lastDefenseExtra = extraDef;
                            lastShowDefenseExtra = true;
                        }
                    } else {
                        if (!inited || lastShowDefenseExtra) {
                            unitPanel.showArmorExtra(false);
                            lastShowDefenseExtra = false;
                            lastDefenseExtra = 0;
                        }
                    }
                }
            }
        }

        // 内部：更新三围显示（只在目标为英雄时调用）
        private static method updatePrimaryAttrs (unit u, real strVal, real agiVal, real intVal) {
            integer mainAttrType;
            boolean isBig; boolean split; boolean modeChanged;
            real baseStr; real totalStr; real extraStr; boolean showStrExtra;
            real baseAgi; real totalAgi; real extraAgi; boolean showAgiExtra;
            real baseInt; real totalInt; real extraInt; boolean showIntExtra;
            string extraText; string extraValue;

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

            // 仅 BigInteger 英雄沿用旧版基础值 + 额外值规则。
            isBig = IsUnitBigInteger(u);
            split = unitPanel.isSplitPrimaryAttrs() && isBig;
            modeChanged = split != lastSplitPrimaryAttrs;
            lastSplitPrimaryAttrs = split;

            // ========= 力量 =========
            if (isBig) {
                totalStr = GetUnitStr(u);
            } else {
                totalStr = strVal;
            }
            baseStr = totalStr;
            if (split) {
                baseStr = RMaxBJ(0, GetUnitBaseStr(u));
            }
            extraStr = totalStr - baseStr;
            showStrExtra = split && RAbsBJ(extraStr) > 0.01;
            if (!inited || modeChanged || RAbsBJ(baseStr - lastStr) > 0.001) {
                lastStr = baseStr;
                unitPanel.textStrValue.setText(unitAttrShow.formatValue(baseStr));
            }
            if (showStrExtra) {
                if (!inited || modeChanged || !lastShowStrExtra || RAbsBJ(extraStr - lastStrExtra) > 0.001) {
                    extraValue = unitAttrShow.formatValue(RAbsBJ(extraStr));
                    if (extraStr > 0.0) extraText = "|cff00ff00+" + extraValue;
                    else extraText = "|cffff0000-" + extraValue;
                    unitPanel.showStrExtra(true);
                    unitPanel.textStrExtra.setText(extraText);
                    lastStrExtra = extraStr;
                    lastShowStrExtra = true;
                }
            } else if (!inited || modeChanged || lastShowStrExtra) {
                unitPanel.showStrExtra(false);
                lastStrExtra = 0.0;
                lastShowStrExtra = false;
            }

            // ========= 敏捷 =========
            if (isBig) {
                totalAgi = GetUnitAgi(u);
            } else {
                totalAgi = agiVal;
            }
            baseAgi = totalAgi;
            if (split) {
                baseAgi = RMaxBJ(0, GetUnitBaseAgi(u));
            }
            extraAgi = totalAgi - baseAgi;
            showAgiExtra = split && RAbsBJ(extraAgi) > 0.01;
            if (!inited || modeChanged || RAbsBJ(baseAgi - lastAgi) > 0.001) {
                lastAgi = baseAgi;
                unitPanel.textAgiValue.setText(unitAttrShow.formatValue(baseAgi));
            }
            if (showAgiExtra) {
                if (!inited || modeChanged || !lastShowAgiExtra || RAbsBJ(extraAgi - lastAgiExtra) > 0.001) {
                    extraValue = unitAttrShow.formatValue(RAbsBJ(extraAgi));
                    if (extraAgi > 0.0) extraText = "|cff00ff00+" + extraValue;
                    else extraText = "|cffff0000-" + extraValue;
                    unitPanel.showAgiExtra(true);
                    unitPanel.textAgiExtra.setText(extraText);
                    lastAgiExtra = extraAgi;
                    lastShowAgiExtra = true;
                }
            } else if (!inited || modeChanged || lastShowAgiExtra) {
                unitPanel.showAgiExtra(false);
                lastAgiExtra = 0.0;
                lastShowAgiExtra = false;
            }

            // ========= 智力 =========
            if (isBig) {
                totalInt = GetUnitInt(u);
            } else {
                totalInt = intVal;
            }
            baseInt = totalInt;
            if (split) {
                baseInt = RMaxBJ(0, GetUnitBaseInt(u));
            }
            extraInt = totalInt - baseInt;
            showIntExtra = split && RAbsBJ(extraInt) > 0.01;
            if (!inited || modeChanged || RAbsBJ(baseInt - lastInt) > 0.001) {
                lastInt = baseInt;
                unitPanel.textIntValue.setText(unitAttrShow.formatValue(baseInt));
            }
            if (showIntExtra) {
                if (!inited || modeChanged || !lastShowIntExtra || RAbsBJ(extraInt - lastIntExtra) > 0.001) {
                    extraValue = unitAttrShow.formatValue(RAbsBJ(extraInt));
                    if (extraInt > 0.0) extraText = "|cff00ff00+" + extraValue;
                    else extraText = "|cffff0000-" + extraValue;
                    unitPanel.showIntExtra(true);
                    unitPanel.textIntExtra.setText(extraText);
                    lastIntExtra = extraInt;
                    lastShowIntExtra = true;
                }
            } else if (!inited || modeChanged || lastShowIntExtra) {
                unitPanel.showIntExtra(false);
                lastIntExtra = 0.0;
                lastShowIntExtra = false;
            }
        }

        // 内部：更新攻击图标自定义显示（角标与贴图）
        private static method updateAttackIcon (unit u) {
            string cornerText; string texture; boolean showCorner; boolean showTexture;
            boolean cornerChanged; boolean textureChanged;

            // 读取角标文本
            cornerText = GetUnitAtkCornerText(u);
            showCorner = (cornerText != null);
            cornerChanged = (!inited || showCorner != lastShowAtkCornerText || (showCorner && cornerText != lastAtkCornerText));

            // 读取贴图路径
            texture = GetUnitAtkTexture(u);
            showTexture = (texture != null);
            textureChanged = (!inited || showTexture != lastShowAtkTexture || (showTexture && texture != lastAtkTexture));

            // 更新角标
            if (cornerChanged) {
                if (showCorner) {
                    unitPanel.iconAttack.setCornerText(cornerText);
                    lastAtkCornerText = cornerText;
                    lastShowAtkCornerText = true;
                } else {
                    unitPanel.iconAttack.setCornerText(null);
                    lastAtkCornerText = null;
                    lastShowAtkCornerText = false;
                }
            }

            // 更新贴图
            if (textureChanged) {
                if (showTexture) {
                    unitPanel.iconAttack.setTexture(texture);
                    lastAtkTexture = texture;
                    lastShowAtkTexture = true;
                } else {
                    unitPanel.iconAttack.setTexture(UNITPANEL_ICON_TEXTURE_ATTACK);
                    lastAtkTexture = null;
                    lastShowAtkTexture = false;
                }
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

                    // 更新攻击图标自定义显示（角标与贴图）
                    unitAttrShow.updateAttackIcon(u);

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
