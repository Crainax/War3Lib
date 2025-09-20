#ifndef UnitAttrUpdateIncluded
#define UnitAttrUpdateIncluded

#include "Crainax/core/constant/JapiConstant.j" //constant可以直接加进去没问题


//! zinc
/*
单位的属性更新UI
*/
library UnitAttrUpdate requires UnitPanel,HeroAttr,YDWEYDWEJapiScript{

    private tooltip tt = 0;

    // 新增：抽取的通用更新函数
    private function updateAttack(unitAttr ua) {
        real extra = ua.AtkRateBonus + ua.AtkFixedBonus;
        unitPanel.textAttackValue.setText(FormatNumber(ua.baseAtk));
        if (extra > 0.9) {
            unitPanel.textAttackExtra.setText("|cff00ff00+" + FormatNumber(extra) + "|r");
            unitPanel.showAttackExtra(true);
        } else if (extra < -0.9) {
            unitPanel.textAttackExtra.setText("|cffff0000" + FormatNumber(extra) + "|r");
            unitPanel.showAttackExtra(true);
        } else {
            unitPanel.showAttackExtra(false);
        }
    }

    private function updateDefense(unitAttr ua) {
        real extra = ua.DefRateBonus + ua.DefFixedBonus;
        unitPanel.textArmorValue.setText(FormatNumber(ua.baseDef));
        if (extra > 0.9) {
            unitPanel.textArmorExtra.setText("|cff00ff00+" + FormatNumber(extra) + "|r");
            unitPanel.showArmorExtra(true);
        } else if (extra < -0.9) {
            unitPanel.textArmorExtra.setText("|cffff0000" + FormatNumber(extra) + "|r");
            unitPanel.showArmorExtra(true);
        } else {
            unitPanel.showArmorExtra(false);
        }
    }

    private function updateStr(heroAttr ha) {
        real extra = ha.getExtraStr();
        unitPanel.textStrValue.setText(FormatNumber(ha.getBaseStr()));
        if (extra > 0.9) {
            unitPanel.textStrExtra.setText("|cff00ff00+" + FormatNumber(extra) + "|r");
            unitPanel.showStrExtra(true);
        } else if (extra < -0.9) {
            unitPanel.textStrExtra.setText("|cffff0000" + FormatNumber(extra) + "|r");
            unitPanel.showStrExtra(true);
        } else {
            unitPanel.showStrExtra(false);
        }
    }

    private function updateAgi(heroAttr ha) {
        real extra = ha.getExtraAgi();
        unitPanel.textAgiValue.setText(FormatNumber(ha.getBaseAgi()));
        if (extra > 0.9) {
            unitPanel.textAgiExtra.setText("|cff00ff00+" + FormatNumber(extra) + "|r");
            unitPanel.showAgiExtra(true);
        } else if (extra < -0.9) {
            unitPanel.textAgiExtra.setText("|cffff0000" + FormatNumber(extra) + "|r");
            unitPanel.showAgiExtra(true);
        } else {
            unitPanel.showAgiExtra(false);
        }
    }

    private function updateInt(heroAttr ha) {
        real extra = ha.getExtraInt();
        unitPanel.textIntValue.setText(FormatNumber(ha.getBaseInt()));
        if (extra > 0.9) {
            unitPanel.textIntExtra.setText("|cff00ff00+" + FormatNumber(extra) + "|r");
            unitPanel.showIntExtra(true);
        } else if (extra < -0.9) {
            unitPanel.textIntExtra.setText("|cffff0000" + FormatNumber(extra) + "|r");
            unitPanel.showIntExtra(true);
        } else {
            unitPanel.showIntExtra(false);
        }
    }

    // 引用
    public function InitUnitAttrUpdate (){
        DoNothing();
    }

    function onInit ()  {
        unitAttr.onAtkChange(function () {
            unitAttr ua = unitAttr.ethis;
            if (ua.u != null && ua.u == DzGetSelectedLeaderUnit()) {
                updateAttack(ua);
            }
        });
        unitAttr.onDefChange(function () {
            unitAttr ua = unitAttr.ethis;
            if (ua.u != null && ua.u == DzGetSelectedLeaderUnit()) {
                updateDefense(ua);
            }
        });
        heroAttr.onStrChange(function () {
            heroAttr ha = heroAttr.ethis;
            if (ha.u != null && ha.u == DzGetSelectedLeaderUnit()) {
                updateStr(ha);
            }
        });

        heroAttr.onAgiChange(function () {
            heroAttr ha = heroAttr.ethis;
            if (ha.u != null && ha.u == DzGetSelectedLeaderUnit()) {
                updateAgi(ha);
            }
        });
        heroAttr.onIntChange(function () {
            heroAttr ha = heroAttr.ethis;
            if (ha.u != null && ha.u == DzGetSelectedLeaderUnit()) {
                updateInt(ha);
            }
        });
        unitSelect.onAsync(function () {
            unit u = unitSelect.args;
            unitAttr ua = unitAttr.get(u);
            heroAttr ha = heroAttr.get(u);
            integer mainAttr;
            //todo:无法攻击与无敌
            if (ua.isExist()){ //如果单位属性存在
                updateAttack(ua);
                updateDefense(ua);
            } else { //用默认的单位JAPI来显示
                unitPanel.showAttackExtra(false);
                unitPanel.showArmorExtra(false);
                unitPanel.textAttackValue.setText(FormatNumber(GetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE))));
                unitPanel.textArmorValue.setText(FormatNumber(GetUnitState(u,ConvertUnitState(UNIT_STATE_ARMOR))));
            }

            if (IsHeroUnitId(GetUnitTypeId(u))) {
                mainAttr = heroAttr.getMainAttr(u);
                if (mainAttr ==MAIN_ATTR_STR) {
                    unitPanel.iconHero.setTexture(UNITPANEL_ICON_TEXTURE_STR);
                } else if (mainAttr ==MAIN_ATTR_AGI) {
                    unitPanel.iconHero.setTexture(UNITPANEL_ICON_TEXTURE_AGI);
                } else if (mainAttr ==MAIN_ATTR_INT) {
                    unitPanel.iconHero.setTexture(UNITPANEL_ICON_TEXTURE_INT);
                }
                if (ha.isExist()){
                    updateStr(ha);
                    updateAgi(ha);
                    updateInt(ha);
                } else {
                    unitPanel.showStrExtra(false);
                    unitPanel.showAgiExtra(false);
                    unitPanel.showIntExtra(false);
                    unitPanel.textStrValue.setText(FormatNumber(GetHeroStr(u,true)));
                    unitPanel.textAgiValue.setText(FormatNumber(GetHeroAgi(u,true)));
                    unitPanel.textIntValue.setText(FormatNumber(GetHeroInt(u,true)));
                }
            }

            u = null;
        });
        unitPanel.onAttackEnter(function () {
            unitAttr ua = unitAttr.get(DzGetSelectedLeaderUnit());
            real attack; //攻击力
            real range; //攻击范围
            real attackSpeed; //攻击速度
            real attackInterval; //攻击间隔
            if (ua.isExist()) { //如果有ua
                attack = ua.getCurrentAtk();
                range = ua.getCurrentAtkRange();
                attackSpeed = ua.getCurrentAtkSpeed();
                attackInterval = ua.getCurrentAtkInterval();
            } else { //无,用japi获取属性
                attack = GetUnitState(DzGetSelectedLeaderUnit(),ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE));
                range = GetUnitState(DzGetSelectedLeaderUnit(),ConvertUnitState(UNIT_STATE_ATTACK1_RANGE));
                attackSpeed = GetUnitState(DzGetSelectedLeaderUnit(),ConvertUnitState(UNIT_STATE_RATE_OF_FIRE));
                attackInterval = GetUnitState(DzGetSelectedLeaderUnit(),ConvertUnitState(UNIT_STATE_ATTACK1_INTERVAL));
            }
			tooltipStack.pushOrigin();
			if (tt.isExist()) {
				tt.destroy();
			}

            tt = tooltip.create()
                .layoutFlexible("|cfffc9c42攻击间隔:|r " + R2SW(attackInterval,0,2) + "s")
                .setAbsPoint(ANCHOR_BOTTOMRIGHT,TOOLTIP_DEFAULT_X,TOOLTIP_DEFAULT_Y);

            tt.text[1].setFontSize(4);

            if (ua.isExist()) {
                tt.addText("|cfffc9c42最终伤害:|r " + I2S(R2I(ua.getCurrentFinalDmg() * 100)) + "%").setFontSize(4);
                tt.addText("|cfffc9c42法术伤害:|r " + I2S(R2I(ua.getCurrentSpellDmg() * 100)) + "%").setFontSize(4);
            }

            tt.addText("|cfffc9c42攻击范围:|r " + I2S(R2I(range)) + "m").setFontSize(4);
            tt.addText("|cfffc9c42攻击力:|r " + FormatNumber(attack)).setFontSize(4);

            tt.setWidth(0.1);

            tooltipStack.push(function (player p) { //压栈
				if (tt.isExist()) {
					tt.destroy();
				}
				tt = 0;
			});
        });
        unitPanel.onArmorEnter(function () {
            unitAttr ua = unitAttr.get(DzGetSelectedLeaderUnit());
            unitRegen ur = unitRegen.get(DzGetSelectedLeaderUnit());
            real armor;        //护甲
            real armorEffect;  //护甲减伤效果
            real resist;       //魔法抗性
            real hpRegen;      //生命恢复(定值)
            real hpRegenRate;  //生命恢复(百分比)
            real mpRegen;      //魔法恢复(定值)
            real mpRegenRate;  //魔法恢复(百分比)
            real moveSpeed;    //移动速度
            string temp;
            if (ua.isExist()) { //如果有ua
                armor = ua.getCurrentDef();
                resist = ua.getCurrentResist();
                moveSpeed = ua.getCurrentMoveSpeed();
            } else { //无,用japi获取属性
                armor = GetUnitState(DzGetSelectedLeaderUnit(),ConvertUnitState(UNIT_STATE_ARMOR));
                resist = 0.0;
                moveSpeed = GetUnitMoveSpeed(DzGetSelectedLeaderUnit());
            }

            armorEffect = (armor * DEFENSE_ARMOR) / (1 + DEFENSE_ARMOR * armor);

			tooltipStack.pushOrigin();
			if (tt.isExist()) {
				tt.destroy();
			}

            tt = tooltip.create()
                .layoutFlexible("|cfffc9c42移动速度:|r " + I2S(R2I(moveSpeed)))
                .setAbsPoint(ANCHOR_BOTTOMRIGHT,TOOLTIP_DEFAULT_X,TOOLTIP_DEFAULT_Y);

            tt.text[1].setFontSize(4);

            if (ur.isExist()) {
                hpRegen     = ur.HPRegenFixed;
                hpRegenRate = ur.HPRegenPercent;
                mpRegen     = ur.MPRegenFixed;
                mpRegenRate = ur.MPRegenPercent;
                temp        = "";

                // MP回复文本
                if (mpRegen > 0 || mpRegenRate > 0) {
                    temp = "|cfffc9c42MP回复:|r ";
                    if (mpRegen > 0) {
                        temp = temp + FormatNumber(mpRegen);
                    }
                    if (mpRegenRate > 0) {
                        if (mpRegen > 0) {
                            temp = temp + "+";
                        }
                        temp = temp + I2S(R2I(mpRegenRate * 100)) + "%";
                    }
                } else {
                    temp = "|cfffc9c42MP回复:|r 0";
                }
                tt.addText(temp).setFontSize(4);

                // HP回复文本
                temp = "";
                if (hpRegen > 0 || hpRegenRate > 0) {
                    temp = "|cfffc9c42HP回复:|r ";
                    if (hpRegen > 0) {
                        temp = temp + FormatNumber(hpRegen);
                    }
                    if (hpRegenRate > 0) {
                        if (hpRegen > 0) {
                            temp = temp + "+";
                        }
                        temp = temp + I2S(R2I(hpRegenRate * 100)) + "%";
                    }
                } else {
                    temp = "|cfffc9c42HP回复:|r 0";
                }
                temp = null;
                tt.addText(temp).setFontSize(4);
            }

            tt.addText("|cfffc9c42魔法抗性:|r " + R2SW(resist*100.0,0,2) + "%").setFontSize(4);
            tt.addText("|cfffc9c42物理抗性:|r " + R2SW(armorEffect*100.0,0,2) + "%").setFontSize(4);
            tt.addText("|cfffc9c42防御力:|r " + FormatNumber(armorEffect)).setFontSize(4);

            tt.setWidth(0.1);

            tooltipStack.push(function (player p) { //压栈
				if (tt.isExist()) {
					tt.destroy();
				}
				tt = 0;
			});
        });
		unitPanel.onAttackLeave(function tooltipStack.clear); //离开事件,销毁tooltip
		unitPanel.onArmorLeave(function tooltipStack.clear); //离开事件,销毁tooltip
		unitSelect.onAsync(function () { //显示怪物的金币和经验
            // monster m = monster.get(unitSelect.args);
            // if (m.isExist() && !IsHeroUnitId(GetUnitTypeId(unitSelect.args))) {
			// 	unitPanel.iconMonster.show(true);
            //     unitPanel.textGoldValue.setText("|cffffffff" + FormatNumber(m.gold));
            //     unitPanel.textExpValue.setText("|cffffffff" + FormatNumber(m.exp));
            // }
		});
		unitSelect.onAsyncUn(function () { //隐藏怪物的金币和经验
            // monster m = monster.get(unitSelect.args);
            // if (m.isExist()) {
            //     unitPanel.iconMonster.show(false);
            // }
		});
        unitPanel.onMonsterEnter(function () { //怪物的图标事件
            // monster m = monster.get(DzGetSelectedLeaderUnit());
            // unitSpell us = unitSpell.get(DzGetSelectedLeaderUnit());

			// tooltipStack.pushOrigin();
			// if (monsterTip1.isExist()) {
			// 	monsterTip1.destroy();
			// }

            // if (m.isExist()) {

            // } else {
            //     monsterTip1 = tooltip.create()
            //         .layoutTitle("该怪物没有战利品.")
            //         .setAbsPoint(ANCHOR_BOTTOMRIGHT,TOOLTIP_DEFAULT_X,TOOLTIP_DEFAULT_Y);
            // }

            // tooltipStack.push(function (player p) { //压栈
			// 	if (monsterTip1.isExist()) {
			// 		monsterTip1.destroy();
			// 	}
			// 	monsterTip1 = 0;
			// });


            // // 怪物的技能
			// if (monsterTip2.isExist()) {
			// 	monsterTip2.destroy();
			// }

            // if (us.isExist()) {

            // } else {
            //     monsterTip2 = tooltip.create()
            //         .layoutTitle("该怪物没有技能.")
            //         .setPoint(ANCHOR_BOTTOMRIGHT,monsterTip1.relativeTop,ANCHOR_TOPRIGHT,0,0.008);
            // }

            // tooltipStack.push(function (player p) { //压栈
			// 	if (monsterTip2.isExist()) {
			// 		monsterTip2.destroy();
			// 	}
			// 	monsterTip2 = 0;
			// });



        });
        unitPanel.onMonsterLeave(function tooltipStack.clear);
    }
}

//! endzinc
#endif