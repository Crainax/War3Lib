#ifndef UnitPanelIncluded
#define UnitPanelIncluded

//! zinc
/*
单位面板的控制
*/

// https://tieba.baidu.com/p/6580193364?pid=131079515410&cid=0&red_tag=2120364315#131079515410
// https://tieba.baidu.com/p/8067593125?pid=145736219847&cid=145742891494#145742891494
// http://bbs.mvprpg.com/forum.php?mod=viewthread&tid=493042&extra=

/*
4，原生框架及 置父类型
SIMPLEFRAME：框架
单位面板：SimpleInfoPanelUnitDetail  ID：0

英雄属性：SimpleInfoPanelIconHero  ID：6

攻击：SimpleInfoPanelIconDamage  ID：0
防御：SimpleInfoPanelIconArmor   ID：2

经验框：SimpleHeroLevelBar  ID：0
经验条：SimpleProgressIndicator  ID：0

建造页面：SimpleInfoPanelBuildingDetail   ID：1
建造物名称：SimpleBuildingNameValue  ID：1
建造列队条：SimpleBuildTimeIndicator   ID：1


未知：SimpleInfoPanelIconArmor  ID：2

SimpleFontString：
单位名称：SimpleNameValue   ID：0

种类即英雄等级：SimpleClassValue   ID：0

建造行动标签：SimpleBuildingActionLabel   ID：1

SimpleTexture：
建造列队背景：SimpleBuildQueueBackdrop   ID：1
单位图标：InfoPanelIconBackdrop     ID：0为攻击1，1为攻击2，2为防御
面板科技等级：InfoPanelIconLevel    ID：0为攻击1，1为攻击2，2为防御
单位基础数值：InfoPanelIconValue    ID：0为攻击1，1为攻击2，2为防御
基础数值标签：InfoPanelIconLabel    ID：0为攻击1，1为攻击2，2为防御

注意：原版的面板框架并不支持所有的类型置父


能支持的只有
SIMPLEFRAME
SIMPLESTATUSBAR
SIMPLECHECKBOX
SIMPLEBUTTON
TEXTAREA
这些类型。
*/

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

library UnitPanel requires UIButton,UIText,UIImage,UIExtendEvent,Icon,UnitSelect {


    public struct unitPanel []{

        static icon iconAttack  = 0; static icon iconArmor    = 0;
        static icon iconHero    = 0; static icon iconBuilding = 0;
        static icon iconMonster = 0;

        static uiText textAttack   = 0; static uiText  textAttackValue  = 0;  //攻击相关
        static uiText textArmor    = 0; static uiText textArmorValue    = 0;  //防御相关
        static uiText textStr      = 0; static uiText  textStrValue     = 0;  //力量
        static uiText textAgi      = 0; static uiText  textAgiValue     = 0;  //敏捷
        static uiText textInt      = 0; static uiText  textIntValue     = 0;  //智力
        static uiText textBuilding = 0; static uiText textBuildingValue = 0;

        // 事件触发器
        private {
            static trigger trAttackEnter   = null; static trigger trAttackLeave        = null;
            static trigger trAttackClick   = null; static trigger trAttackRightClick   = null;
            static trigger trArmorEnter    = null; static trigger trArmorLeave         = null;
            static trigger trArmorClick    = null; static trigger trArmorRightClick    = null;
            static trigger trHeroEnter     = null; static trigger trHeroLeave          = null;
            static trigger trHeroClick     = null; static trigger trHeroRightClick     = null;
            static trigger trBuildingEnter = null; static trigger trBuildingLeave      = null;
            static trigger trBuildingClick = null; static trigger trBuildingRightClick = null;
            static trigger trMonsterEnter  = null; static trigger trMonsterLeave       = null;
            static trigger trMonsterClick  = null; static trigger trMonsterRightClick  = null;
        }

        #define onUnitPanelTrigger(name,evt) \
        static method on##name##evt (code func) { \
        if (tr##name##evt == null) tr##name##evt = CreateTrigger(); \
        TriggerAddCondition(tr##name##evt, Condition(func)); }

        #define onUnitPanelAllEvents(name) \
        onUnitPanelTrigger(name,Enter) CRNL \
        onUnitPanelTrigger(name,Leave) CRNL \
        onUnitPanelTrigger(name,Click) CRNL \
        onUnitPanelTrigger(name,RightClick) CRNL

        // 使用新的宏一次性生成每个部分的所有事件
        onUnitPanelAllEvents(Attack)
        onUnitPanelAllEvents(Armor)
        onUnitPanelAllEvents(Hero)
        onUnitPanelAllEvents(Building)
        onUnitPanelAllEvents(Monster)

        #undef onUnitPanelTrigger
        #undef onUnitPanelAllEvents

        // 地图初始化
        private static method mapInit () {
            integer parent,child;
            uiBtn btn;

            //攻击小框架相关
            parent = DzSimpleFrameFindByName("SimpleInfoPanelIconArmor", 2); //防御的父框架
            child = DzCreateFrameByTagName("SIMPLEFRAME", "upAttack", parent, "单位面板框架", 0);
            DzFrameClearAllPoints( child ); //这条必不可少,不然会杂糅在一起
            iconAttack = icon.fromExistingUI(uiImage.bindSimple("单位面板图标", 0), parent)
                .setSize(0.027, 0.027)
                .setPoint(ANCHOR_CENTER, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.0295, -0.006)
                .setTexture("ReplaceableTextures\\CommandButtons\\BTNFrostArmor.blp");
            btn = iconAttack.getClickBtn()
                .spEnter(function(integer frame) {if (trAttackEnter != null) TriggerEvaluate(trAttackEnter);})
                .spLeave(function(integer frame) {if (trAttackLeave != null) TriggerEvaluate(trAttackLeave);})
                .spClick(function(integer frame) {if (trAttackClick != null) TriggerEvaluate(trAttackClick);})
                .spRightClick(function(integer frame) {if (trAttackRightClick != null) TriggerEvaluate(trAttackRightClick);});
            textAttack = uiText.bindSimple("单位面板属性名", 0)
                .setPoint(ANCHOR_TOPLEFT, iconAttack.mainImage.ui, ANCHOR_TOPRIGHT, 0.003, -0.003)
                .setText("攻击:");
            textAttackValue = uiText.bindSimple("单位面板数值", 0)
                .setPoint(ANCHOR_BOTTOMLEFT, iconAttack.mainImage.ui, ANCHOR_BOTTOMRIGHT, 0.008, 0.003)
                .setText("0");

            //防御小框架相关
            child = DzCreateFrameByTagName("SIMPLEFRAME", "upArmor", parent, "单位面板框架", 1);
            DzFrameClearAllPoints( child ); //这条必不可少,不然会杂糅在一起
            iconArmor = icon.fromExistingUI(uiImage.bindSimple("单位面板图标", 1), parent)
                .setSize(0.027, 0.027)
                .setPoint(ANCHOR_CENTER, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.0295, -0.037)
                .setTexture("ReplaceableTextures\\CommandButtons\\BTNDarkSummoning.blp");
            btn = iconArmor.getClickBtn()
                .spEnter(function(integer frame) {if (trArmorEnter != null) TriggerEvaluate(trArmorEnter);})
                .spLeave(function(integer frame) {if (trArmorLeave != null) TriggerEvaluate(trArmorLeave);})
                .spClick(function(integer frame) {if (trArmorClick != null) TriggerEvaluate(trArmorClick);})
                .spRightClick(function(integer frame) {if (trArmorRightClick != null) TriggerEvaluate(trArmorRightClick);});
            textArmor = uiText.bindSimple("单位面板属性名", 1)
                .setPoint(ANCHOR_TOPLEFT, iconArmor.mainImage.ui, ANCHOR_TOPRIGHT, 0.003, -0.003)
                .setText("防御:");
            textArmorValue = uiText.bindSimple("单位面板数值", 1)
                .setPoint(ANCHOR_BOTTOMLEFT, iconArmor.mainImage.ui, ANCHOR_BOTTOMRIGHT, 0.008, 0.003)
                .setText("20");

            //英雄属性三围
            parent = DzSimpleFrameFindByName("SimpleInfoPanelIconHero", 6); //英雄属性的父框架
            child = DzCreateFrameByTagName("SIMPLEFRAME", "upHero", parent, "英雄三围框架", 0);
            DzFrameClearAllPoints( child ); //这条必不可少,不然会杂糅在一起
            iconHero = icon.fromExistingUI(uiImage.bindSimple("英雄三围图标", 0), parent)
                .setSize(0.027, 0.027)
                .setPoint(ANCHOR_CENTER, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.1235, -0.02)
                .setTexture("ReplaceableTextures\\CommandButtons\\BTNJanggo.blp");
            btn = iconHero.getClickBtn()
                .spEnter(function(integer frame) {if (trHeroEnter != null) TriggerEvaluate(trHeroEnter);})
                .spLeave(function(integer frame) {if (trHeroLeave != null) TriggerEvaluate(trHeroLeave);})
                .spClick(function(integer frame) {if (trHeroClick != null) TriggerEvaluate(trHeroClick);})
                .spRightClick(function(integer frame) {if (trHeroRightClick != null) TriggerEvaluate(trHeroRightClick);});

            //力量
            textStr = uiText.bindSimple("英雄力量名", 0)
                .setPoint(ANCHOR_TOPLEFT, iconHero.mainImage.ui, ANCHOR_CENTER, 0.017, 0.027)
                .setText("力量:");
            textStrValue = uiText.bindSimple("英雄力量值", 0)
                .setPoint(ANCHOR_TOPLEFT, textStr.ui, ANCHOR_BOTTOMLEFT, 0.005, -0.001)
                .setText("10");

            //敏捷
            textAgi = uiText.bindSimple("英雄敏捷名", 0)
                .setPoint(ANCHOR_TOPLEFT, iconHero.mainImage.ui, ANCHOR_CENTER, 0.017, 0.006)
                .setText("敏捷:");
            textAgiValue = uiText.bindSimple("英雄敏捷值", 0)
                .setPoint(ANCHOR_TOPLEFT, textAgi.ui, ANCHOR_BOTTOMLEFT, 0.005, -0.001)
                .setText("20");

            //智力
            textInt = uiText.bindSimple("英雄智力名", 0)
                .setPoint(ANCHOR_TOPLEFT, iconHero.mainImage.ui, ANCHOR_CENTER, 0.017, -0.015)
                .setText("智力:");
            textIntValue = uiText.bindSimple("英雄智力值", 0)
                .setPoint(ANCHOR_TOPLEFT, textInt.ui, ANCHOR_BOTTOMLEFT, 0.005, -0.001)
                .setText("30");

            //建筑小框架相关
            parent = DzSimpleFrameFindByName("SimpleInfoPanelIconAlly", 7); //建筑的父框架(放弃了因为频繁拉回来的原因)
            child = DzCreateFrameByTagName("SIMPLEFRAME", "upBuilding", parent, "单位面板框架", 2);
            DzFrameClearAllPoints(child);
            iconBuilding = icon.fromExistingUI(uiImage.bindSimple("单位面板图标", 2), parent)
                .setSize(0.027, 0.027)
                .setPoint(ANCHOR_CENTER, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.1235, -0.02)
                .setTexture("ReplaceableTextures\\CommandButtons\\BTNTownHall.blp");
            btn = iconBuilding.getClickBtn()
                .spEnter(function(integer frame) {if (trBuildingEnter != null) TriggerEvaluate(trBuildingEnter);})
                .spLeave(function(integer frame) {if (trBuildingLeave != null) TriggerEvaluate(trBuildingLeave);})
                .spClick(function(integer frame) {if (trBuildingClick != null) TriggerEvaluate(trBuildingClick);})
                .spRightClick(function(integer frame) {if (trBuildingRightClick != null) TriggerEvaluate(trBuildingRightClick);});
            textBuilding = uiText.bindSimple("单位面板属性名", 2)
                .setPoint(ANCHOR_TOPLEFT, iconBuilding.mainImage.ui, ANCHOR_TOPRIGHT, 0.003, -0.003)
                .setText("防护罩:");
            textBuildingValue = uiText.bindSimple("单位面板数值", 2)
                .setPoint(ANCHOR_BOTTOMLEFT, iconBuilding.mainImage.ui, ANCHOR_BOTTOMRIGHT, 0.008, 0.003)
                .setText("1");

            //怪物属性框架
            iconMonster = icon.createSimple(DzSimpleFrameFindByName("SimpleInfoPanelIconArmor", 2))
                .setSize(0.027, 0.027)
            // .setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0,0)
                .setPoint(ANCHOR_CENTER, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.1235, -0.02)
                .setTexture("ReplaceableTextures\\CommandButtons\\BTNSkeletonArcher.blp")
                .show(false);
            btn = iconMonster.getClickBtn()
                .spEnter(function(integer frame) {if (trMonsterEnter != null) TriggerEvaluate(trMonsterEnter);})
                .spLeave(function(integer frame) {if (trMonsterLeave != null) TriggerEvaluate(trMonsterLeave);})
                .spClick(function(integer frame) {if (trMonsterClick != null) TriggerEvaluate(trMonsterClick);})
                .spRightClick(function(integer frame) {if (trMonsterRightClick != null) TriggerEvaluate(trMonsterRightClick);});
        }

        // 友方建筑单位的金币之类的东西(会频繁重置,需要在选择单位时就重新处理)
        static method moveOutBuilding (){
            integer ui = DzSimpleFrameFindByName("SimpleInfoPanelIconAlly", 7);
            DzFrameSetSize( ui, 0.02, 0.02 );
            DzFrameClearAllPoints( ui );
            DzFrameSetPoint( ui, 4, DzGetGameUI(), 4, 0.80, -0.60 );
        }

        // 怪物的科技原生面板(会频繁重置,需要在选择单位时就重新处理)
        static method moveOutMonster () {
            integer ui = DzSimpleFrameFindByName("SimpleInfoPanelIconRank", 3);
            DzFrameSetSize( ui, 0.02, 0.02 );
            DzFrameClearAllPoints( ui );
            DzFrameSetPoint( ui, 4, DzGetGameUI(), 4, 0.80, -0.60 );
        }

        private static boolean isBuildingSelected = false;
        // 注册建筑单位的单位面板刷新机制
        static method registerBuilding () {
            hardware.regUpdateEvent(function () {
                if (isBuildingSelected) {
                    unitPanel.moveOutBuilding();
                }
            });
            unitSelect.onAsync(function () {
                if (IsUnitAlly(unitSelect.args, GetLocalPlayer()) && GetOwningPlayer(unitSelect.args) != GetLocalPlayer() && IsUnitType(unitSelect.args, UNIT_TYPE_STRUCTURE)) {
                    isBuildingSelected = true;
                }
            });
            unitSelect.onAsyncUn(function () {
                if (IsUnitAlly(unitSelect.args, GetLocalPlayer()) && GetOwningPlayer(unitSelect.args) != GetLocalPlayer() && IsUnitType(unitSelect.args, UNIT_TYPE_STRUCTURE)) {
                    isBuildingSelected = false;
                }
            });
        }

        //把所有原生UI移走
        static method moveOutAll () {
            integer ui;
            // 攻击1
            ui = DzSimpleTextureFindByName("InfoPanelIconBackdrop", 0);
            DzFrameSetSize( ui, 0.03, 0.03 );
            DzFrameClearAllPoints( ui );
            DzFrameSetAbsolutePoint( ui, 4, 0.80, -0.60 );
            // 攻击2
            ui = DzSimpleTextureFindByName("InfoPanelIconBackdrop", 1);
            DzFrameSetSize( ui, 0.03, 0.03 );
            DzFrameClearAllPoints( ui );
            DzFrameSetAbsolutePoint( ui, 4, 0.80, -0.60 );
            // 护甲
            ui = DzSimpleTextureFindByName("InfoPanelIconBackdrop", 2);
            DzFrameSetSize( ui, 0.001, 0.001 );
            DzFrameClearAllPoints( ui );
            DzFrameSetAbsolutePoint( ui, 4, 0.80, -0.60 );
            // 食物
            ui = DzSimpleTextureFindByName("InfoPanelIconBackdrop", 4);
            DzFrameSetSize( ui, 0.001, 0.001 );
            DzFrameClearAllPoints( ui );
            DzFrameSetAbsolutePoint( ui, 4, 0.80, -0.60 );
            // 英雄三围面板
            ui = DzSimpleFrameFindByName("SimpleInfoPanelIconHero", 6);
            DzFrameSetSize( ui, 0.02, 0.02 );
            DzFrameClearAllPoints( ui );
            DzFrameSetPoint( ui, 4, DzGetGameUI(), 4, 0.80, -0.60 );
        }

        //初始化单位按钮面板
        private static method onInit () {
            //在游戏开始0.0秒后再调用
            trigger tr = CreateTrigger();
            TriggerRegisterTimerEventSingle(tr,0.0);
            TriggerAddCondition(tr,Condition(function (){
                moveOutAll(); // 把所有原生UI移走
                mapInit(); // 初始化单位按钮面板
                DestroyTrigger(GetTriggeringTrigger());
            }));
            tr = null;
        }


    }


}

//! endzinc
#endif
