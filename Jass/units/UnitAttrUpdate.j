#ifndef UnitAttrUpdateIncluded
#define UnitAttrUpdateIncluded

//! zinc
/*
单位的属性更新UI
*/
library UnitAttrUpdate requires UnitPanel,HeroAttr{


    public function InitUnitAttrUpdate (){
        DoNothing();
    }

    function onInit ()  {
        unitAttr.onAtkChange(function () { // 攻击力变化事件
            unitAttr ua = unitAttr.ethis;
            real extra;
            if (ua.u != null && ua.u == DzGetSelectedLeaderUnit()) { // 如果当前单位是选中的单位
                unitPanel.textAttackValue.setText(FormatNumber(ua.baseAtk));
                extra = ua.AtkRateBonus + ua.AtkFixedBonus;
                if (extra > 0.9) {
                    unitPanel.textAttackExtra.setText("|cff00ff00+" + FormatNumber(extra) + "|r");
                    unitPanel.showAttackExtra(true);
                } else if (extra < -0.9) {
                    unitPanel.textAttackExtra.setText("|cffff0000-" + FormatNumber(extra) + "|r");
                    unitPanel.showAttackExtra(true);
                } else {
                    unitPanel.showAttackExtra(false);
                }
            }
        });
        unitAttr.onDefChange(function () { // 防御力变化事件
            unitAttr ua = unitAttr.ethis;
            real extra;
            if (ua.u != null && ua.u == DzGetSelectedLeaderUnit()) { // 如果当前单位是选中的单位
                unitPanel.textArmorValue.setText(FormatNumber(ua.baseDef));
                extra = ua.DefRateBonus + ua.DefFixedBonus;
                if (extra > 0.9) {
                    unitPanel.textArmorExtra.setText("|cff00ff00+" + FormatNumber(extra) + "|r");
                    unitPanel.showArmorExtra(true);
                } else if (extra < -0.9) {
                    unitPanel.textArmorExtra.setText("|cffff0000-" + FormatNumber(extra) + "|r");
                    unitPanel.showArmorExtra(true);
                } else {
                    unitPanel.showArmorExtra(false);
                }
            }
        });
        heroAttr.onStrChange(function () { // 力量变化事件
            heroAttr ha = heroAttr.ethis;
            real extra;
            if (ha.u != null && ha.u == DzGetSelectedLeaderUnit()) { // 如果当前单位是选中的单位
                unitPanel.textStrValue.setText(FormatNumber(ha.getBaseStr()));
                extra = ha.getExtraStr();
                if (extra > 0.9) {
                    unitPanel.textStrExtra.setText("|cff00ff00+" + FormatNumber(extra) + "|r");
                    unitPanel.showStrExtra(true);
                } else if (extra < -0.9) {
                    unitPanel.textStrExtra.setText("|cffff0000-" + FormatNumber(extra) + "|r");
                    unitPanel.showStrExtra(true);
                } else {
                    unitPanel.showStrExtra(false);
                }
            }
        });
        heroAttr.onAgiChange(function () { // 敏捷变化事件
            heroAttr ha = heroAttr.ethis;
            real extra;
            if (ha.u != null && ha.u == DzGetSelectedLeaderUnit()) { // 如果当前单位是选中的单位
                unitPanel.textAgiValue.setText(FormatNumber(ha.getBaseAgi()));
                extra = ha.getExtraAgi();
                if (extra > 0.9) {
                    unitPanel.textAgiExtra.setText("|cff00ff00+" + FormatNumber(extra) + "|r");
                    unitPanel.showAgiExtra(true);
                } else if (extra < -0.9) {
                    unitPanel.textAgiExtra.setText("|cffff0000-" + FormatNumber(extra) + "|r");
                    unitPanel.showAgiExtra(true);
                } else {
                    unitPanel.showAgiExtra(false);
                }
            }
        });
        heroAttr.onIntChange(function () { // 智力变化事件
            heroAttr ha = heroAttr.ethis;
            real extra;
            if (ha.u != null && ha.u == DzGetSelectedLeaderUnit()) { // 如果当前单位是选中的单位
                unitPanel.textIntValue.setText(FormatNumber(ha.getBaseInt()));
                extra = ha.getExtraInt();
                if (extra > 0.9) {
                    unitPanel.textIntExtra.setText("|cff00ff00+" + FormatNumber(extra) + "|r");
                    unitPanel.showIntExtra(true);
                } else if (extra < -0.9) {
                    unitPanel.textIntExtra.setText("|cffff0000-" + FormatNumber(extra) + "|r");
                    unitPanel.showIntExtra(true);
                } else {
                    unitPanel.showIntExtra(false);
                }
            }
        });
        unitSelect.onAsync(function () { // 选择单位时更新攻击力等内容
            unit u = unitSelect.asyncU;
        });
    }
}

//! endzinc
#endif