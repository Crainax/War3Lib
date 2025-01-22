#ifndef UnitAttrUpdateIncluded
#define UnitAttrUpdateIncluded

#include "Crainax/core/constant/JapiConstant.j" //constant可以直接加进去没问题


//! zinc
/*
单位的属性更新UI
*/
library UnitAttrUpdate requires UnitPanel,HeroAttr,YDWEYDWEJapiScript{

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
    }
}

//! endzinc
#endif