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
        static icon iconHero    = 0;
        #ifdef UnitPanelShowBuilding
        static icon iconBuilding = 0;
        #endif
        #ifdef UnitPanelShowMonster
        static icon iconMonster = 0;
        #endif

        static uiText textAttack   = 0; static uiText  textAttackValue   = 0;static uiText  textAttackExtra   = 0;  //攻击相关
        static uiText textArmor    = 0; static uiText  textArmorValue    = 0;static uiText  textArmorExtra    = 0;  //防御相关
        static uiText textStr      = 0; static uiText  textStrValue      = 0;static uiText  textStrExtra      = 0;  //力量
        static uiText textAgi      = 0; static uiText  textAgiValue      = 0;static uiText  textAgiExtra      = 0;  //敏捷
        static uiText textInt      = 0; static uiText  textIntValue      = 0;static uiText  textIntExtra      = 0;  //智力
        // 头像下方生命 / 魔法数值文本
        static uiText textHP       = 0;
        static uiText textMP       = 0;

        #ifdef UnitPanelShowBuilding
        static uiText textBuilding = 0; static uiText  textBuildingValue = 0;
        #endif
        #ifdef UnitPanelShowMonster
        static uiText textGold     = 0; static uiText  textGoldValue     = 0;
        static uiText textExp      = 0; static uiText  textExpValue      = 0;
        #endif

        // 事件触发器
        private {
            static trigger trAttackEnter   = null; static trigger trAttackLeave        = null;
            static trigger trAttackClick   = null; static trigger trAttackRightClick   = null;
            static trigger trArmorEnter    = null; static trigger trArmorLeave         = null;
            static trigger trArmorClick    = null; static trigger trArmorRightClick    = null;
            static trigger trHeroEnter     = null; static trigger trHeroLeave          = null;
            static trigger trHeroClick     = null; static trigger trHeroRightClick     = null;
            #ifdef UnitPanelShowBuilding
            static trigger trBuildingEnter = null; static trigger trBuildingLeave      = null;
            static trigger trBuildingClick = null; static trigger trBuildingRightClick = null;
            #endif
            #ifdef UnitPanelShowMonster
            static trigger trMonsterEnter  = null; static trigger trMonsterLeave       = null;
            static trigger trMonsterClick  = null; static trigger trMonsterRightClick  = null;
            #endif
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
        #ifdef UnitPanelShowBuilding
        onUnitPanelAllEvents(Building)
        #endif
        #ifdef UnitPanelShowMonster
        onUnitPanelAllEvents(Monster)
        #endif

        #undef onUnitPanelTrigger
        #undef onUnitPanelAllEvents

        // 地图初始化
        private static method mapInit () {
            integer parent,child;
            uiBtn btn;

            //攻击小框架相关
            //todo:config.h
            parent = DzSimpleFrameFindByName("SimpleInfoPanelIconDamage", 0); //防御的父框架
            child = DzCreateFrameByTagName("SIMPLEFRAME", "upAttack", parent, "单位面板框架", 0);
            DzFrameClearAllPoints( child ); //这条必不可少,不然会杂糅在一起
            iconAttack = icon.fromExistingUI(uiImage.bindSimple("单位面板图标", 0), parent)
                .setSize(0.027, 0.027)
                .setPoint(ANCHOR_CENTER, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.0295, -0.006)
                .setTexture(UNITPANEL_ICON_TEXTURE_ATTACK);
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
            textAttackExtra = uiText.createSimple(parent)
                .setPoint(ANCHOR_LEFT, textAttackValue.ui, ANCHOR_RIGHT, 0.002, 0.0);

            //防御小框架相关
            parent = DzSimpleFrameFindByName("SimpleInfoPanelIconArmor", 2); //防御的父框架
            child = DzCreateFrameByTagName("SIMPLEFRAME", "upArmor", parent, "单位面板框架", 1);
            DzFrameClearAllPoints( child ); //这条必不可少,不然会杂糅在一起
            iconArmor = icon.fromExistingUI(uiImage.bindSimple("单位面板图标", 1), parent)
                .setSize(0.027, 0.027)
                .setPoint(ANCHOR_CENTER, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.0295, -0.037)
                .setTexture(UNITPANEL_ICON_TEXTURE_ARMOR);
            btn = iconArmor.getClickBtn()
                .spEnter(function(integer frame) {if (trArmorEnter != null) TriggerEvaluate(trArmorEnter);})
                .spLeave(function(integer frame) {if (trArmorLeave != null) TriggerEvaluate(trArmorLeave);})
                .spClick(function(integer frame) {if (trArmorClick != null) TriggerEvaluate(trArmorClick);})
                .spRightClick(function(integer frame) {if (trArmorRightClick != null) TriggerEvaluate(trArmorRightClick);});
            textArmor = uiText.bindSimple("单位面板属性名", 1)
                .setPoint(ANCHOR_TOPLEFT, iconArmor.mainImage.ui, ANCHOR_TOPRIGHT, 0.003, -0.003)
                .setText("护甲:");
            textArmorValue = uiText.bindSimple("单位面板数值", 1)
                .setPoint(ANCHOR_BOTTOMLEFT, iconArmor.mainImage.ui, ANCHOR_BOTTOMRIGHT, 0.008, 0.003)
                .setText("20");
            textArmorExtra = uiText.createSimple(parent)
                .setPoint(ANCHOR_LEFT, textArmorValue.ui, ANCHOR_RIGHT, 0.002, 0.0);

            //英雄属性三围
            parent = DzSimpleFrameFindByName("SimpleInfoPanelIconHero", 6); //英雄属性的父框架
            child = DzCreateFrameByTagName("SIMPLEFRAME", "upHero", parent, "英雄三围框架", 0);
            DzFrameClearAllPoints( child ); //这条必不可少,不然会杂糅在一起
            iconHero = icon.fromExistingUI(uiImage.bindSimple("英雄三围图标", 0), parent)
                .setSize(0.027, 0.027)
                .setPoint(ANCHOR_CENTER, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.1235, -0.02)
                .setTexture(UNITPANEL_ICON_TEXTURE_STR);
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
            textStrExtra = uiText.createSimple(parent)
                .setPoint(ANCHOR_LEFT, textStrValue.ui, ANCHOR_RIGHT, 0.002, 0.0);

            //敏捷
            textAgi = uiText.bindSimple("英雄敏捷名", 0)
                .setPoint(ANCHOR_TOPLEFT, iconHero.mainImage.ui, ANCHOR_CENTER, 0.017, 0.006)
                .setText("敏捷:");
            textAgiValue = uiText.bindSimple("英雄敏捷值", 0)
                .setPoint(ANCHOR_TOPLEFT, textAgi.ui, ANCHOR_BOTTOMLEFT, 0.005, -0.001)
                .setText("20");
            textAgiExtra = uiText.createSimple(parent)
                .setPoint(ANCHOR_LEFT, textAgiValue.ui, ANCHOR_RIGHT, 0.002, 0.0);

            //智力
            textInt = uiText.bindSimple("英雄智力名", 0)
                .setPoint(ANCHOR_TOPLEFT, iconHero.mainImage.ui, ANCHOR_CENTER, 0.017, -0.015)
                .setText("智力:");
            textIntValue = uiText.bindSimple("英雄智力值", 0)
                .setPoint(ANCHOR_TOPLEFT, textInt.ui, ANCHOR_BOTTOMLEFT, 0.005, -0.001)
                .setText("30");
            textIntExtra = uiText.createSimple(parent)
                .setPoint(ANCHOR_LEFT, textIntValue.ui, ANCHOR_RIGHT, 0.002, 0.0);

            #ifdef UnitPanelShowBuilding
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
            #endif

            #ifdef UnitPanelShowMonster
            //怪物属性框架
            iconMonster = icon.createSimple(DzSimpleFrameFindByName("SimpleInfoPanelIconArmor", 2))
                .setSize(0.027, 0.027)
                .setPoint(ANCHOR_CENTER, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.1235, -0.02)
                .setTexture("ReplaceableTextures\\CommandButtons\\BTNSkeletonArcher.blp")
                .show(false);
            btn = iconMonster.getClickBtn()
                .spEnter(function(integer frame) {if (trMonsterEnter != null) TriggerEvaluate(trMonsterEnter);})
                .spLeave(function(integer frame) {if (trMonsterLeave != null) TriggerEvaluate(trMonsterLeave);})
                .spClick(function(integer frame) {if (trMonsterClick != null) TriggerEvaluate(trMonsterClick);})
                .spRightClick(function(integer frame) {if (trMonsterRightClick != null) TriggerEvaluate(trMonsterRightClick);});

            //金币
            textGold = uiText.createSimple(DzSimpleFrameFindByName("SimpleInfoPanelIconArmor", 2))
                .setPoint(ANCHOR_TOPLEFT, iconMonster.mainImage.ui, ANCHOR_CENTER, 0.017, 0.021)
                .setText("|cfff2b721怪物金币:|r");
            textGoldValue = uiText.createSimple(DzSimpleFrameFindByName("SimpleInfoPanelIconArmor", 2))
                .setPoint(ANCHOR_TOPLEFT, textGold.ui, ANCHOR_BOTTOMLEFT, 0.005, -0.001)
                .setText("|cffffffff10|r");            //金币
            textExp = uiText.createSimple(DzSimpleFrameFindByName("SimpleInfoPanelIconArmor", 2))
                .setPoint(ANCHOR_TOPLEFT, iconMonster.mainImage.ui, ANCHOR_CENTER, 0.017, -0.006)
                .setText("|cfff2b721怪物经验:|r");
            textExpValue = uiText.createSimple(DzSimpleFrameFindByName("SimpleInfoPanelIconArmor", 2))
                .setPoint(ANCHOR_TOPLEFT, textExp.ui, ANCHOR_BOTTOMLEFT, 0.005, -0.001)
                .setText("|cffffffff20|r");
            #endif
        }

        #ifdef UnitPanelShowBuilding
        // 友方建筑单位的金币之类的东西(会频繁重置,需要在选择单位时就重新处理)
        static method moveOutBuilding (){
            integer ui = DzSimpleFrameFindByName("SimpleInfoPanelIconAlly", 7);
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
        #endif

        #ifdef UnitPanelShowMonster
        // 怪物的科技原生面板(会频繁重置,需要在选择单位时就重新处理)
        static method moveOutMonster () {
            integer ui = DzSimpleFrameFindByName("SimpleInfoPanelIconRank", 3);
            DzFrameSetSize( ui, 0.02, 0.02 );
            DzFrameClearAllPoints( ui );
            DzFrameSetPoint( ui, 4, DzGetGameUI(), 4, 0.80, -0.60 );
        }
        #endif

        //隐藏/显示额外数值显示
        #define SHOW_EXTRA_VALUE(name) \
        static method show##name##Extra (boolean flag) { \
        if (flag) text##name##Extra.setPoint(ANCHOR_LEFT, text##name##Value.ui, ANCHOR_RIGHT, 0.002, 0.0); \
        else text##name##Extra.setPoint(ANCHOR_LEFT, text##name##Value.ui, ANCHOR_RIGHT, -2.0, 0.0); \
    }

    //隐藏/显示额外数值显示
    SHOW_EXTRA_VALUE(Attack)
    SHOW_EXTRA_VALUE(Armor)
    SHOW_EXTRA_VALUE(Str)
    SHOW_EXTRA_VALUE(Agi)
    SHOW_EXTRA_VALUE(Int)

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

    static boolean hpmpTextInited = false; // 自定义HP/MP文本是否已创建
    static boolean hpmpNativeMoved = false; // 原生HP/MP条是否已成功移走
    // 更新头像下方生命 / 魔法文本（基于当前玩家的主选中单位）
    static method updateHPMPText () {
        unit u;
        real curHP; real maxHP; real hp; real curMP; real maxMP;
        real rReal; real gReal;
        integer r; integer g;
        string hpText; string mpText;

        if (!hpmpTextInited) return;

        u = DzGetSelectedLeaderUnit();

        if (u != null) {
            maxHP = GetUnitState(u, UNIT_STATE_MAX_LIFE);
            curHP = GetUnitState(u, UNIT_STATE_LIFE);
            maxMP = GetUnitState(u, UNIT_STATE_MAX_MANA);
            curMP = GetUnitState(u, UNIT_STATE_MANA);

            // ===== 生命值文本与颜色 =====
            if (maxHP > 0.00) {
                hp = curHP / maxHP;

                if (hp > 0.6) {
                    // 高血量：从绿到黄
                    rReal = 255.0 - (255.0 * (hp - 0.5) / 0.5);
                    gReal = 255.0;
                } else if (hp > 0.3) {
                    // 中等血量：从黄到绿
                    rReal = 255.0;
                    gReal = 255.0 * (hp / 0.8);
                } else {
                    // 低血量：从红到暗
                    rReal = 255.0;
                    gReal = 255.0 * (hp / 0.6);
                }

                if (rReal < 0.0) rReal = 0.0;
                if (rReal > 255.0) rReal = 255.0;
                if (gReal < 0.0) gReal = 0.0;
                if (gReal > 255.0) gReal = 255.0;

                r = R2I(rReal);
                g = R2I(gReal);

                hpText = FormatNumber(curHP) + " / " + FormatNumber(maxHP);
                DzFrameSetText(textHP.ui, hpText);
                DzFrameSetTextColor(textHP.ui, DzGetColor(255,r, g, 0));
            } else {
                DzFrameSetText(textHP.ui, "");
            }

            // ===== 魔法值文本与颜色 =====
            if (maxMP > 0.00) {
                mpText = FormatNumber(curMP) + " / " + FormatNumber(maxMP);
                DzFrameSetText(textMP.ui, mpText);
            } else {
                DzFrameSetText(textMP.ui, "");
            }

            // 固定魔法值颜色：ARGB(255,195,219,255)
            DzFrameSetTextColor(textMP.ui, DzGetColor(255,195, 219, 255));
        } else {
            // 没有选中单位时清空显示
            DzFrameSetText(textHP.ui, "");
            DzFrameSetText(textMP.ui, "");
        }

        u = null;
    }

    // 创建自定义生命 / 魔法文本（可重复调用，幂等）
    static method ensureHPMPTextUI () {
        integer console;

        if (hpmpTextInited) return;

        // 在 ConsoleUI 上创建两个文本，占用原生命 / 魔法条矩形区域
        console = DzSimpleFrameFindByName("ConsoleUI", 0);
        if (console == 0) return;

        // 生命值文本：宽高 0.078125 x 0.011875，中心锚点
        // 从 TOPLEFT 改为 CENTER：X偏移 + 宽度/2，Y偏移 - 高度/2
        // 原偏移 (0.214375, 0.0276) -> 新偏移 (0.214375 + 0.0390625, 0.0276 - 0.0059375) = (0.2534375, 0.0216625)
        if (textHP == 0 || !textHP.isExist()) {
            textHP = uiText.create(DzGetGameUI())
                .setPoint(ANCHOR_CENTER, console, ANCHOR_BOTTOMLEFT, 0.2534375, 0.0216625)
                .setFontSize(6)      // 0.011 字号
                .setAlign(4);        // 居中
        }

        // 魔法值文本：宽高同生命条，中心锚点
        // 从 TOPLEFT 改为 CENTER：X偏移 + 宽度/2，Y偏移 - 高度/2
        // 原偏移 (0.214375, 0.01375) -> 新偏移 (0.214375 + 0.0390625, 0.01375 - 0.0059375) = (0.2534375, 0.0078125)
        if (textMP == 0 || !textMP.isExist()) {
            textMP = uiText.create(DzGetGameUI())
                .setPoint(ANCHOR_CENTER, console, ANCHOR_BOTTOMLEFT, 0.2534375, 0.0078125)
                .setFontSize(6)
                .setAlign(4);
        }

        hpmpTextInited = true;
    }

    // 尝试移走原生生命 / 魔法条。需先存在本地选中单位才稳定生效
    static method tryMoveNativeHPMPUI () {
        integer portrait; integer hpUI; integer mpUI;

        if (hpmpNativeMoved) return;
        if (DzGetSelectedLeaderUnit() == null) return;

        portrait = DzFrameGetPortrait();
        if (portrait == 0) return;

        // 通过内存偏移获取原生生命 / 魔法条 UI，并移出屏幕外
        hpUI = DzFrameGetAlpha(portrait + 0x194);
        mpUI = DzFrameGetAlpha(portrait + 0x198);
        if (hpUI == 0 || mpUI == 0) return;

		DzFrameSetSize(hpUI, 0.02, 0.02);
        DzFrameClearAllPoints(hpUI);
        DzFrameSetPoint(hpUI, 4, DzGetGameUI(), 4, 0.80, -0.60);
		DzFrameSetSize(mpUI, 0.02, 0.02);
        DzFrameClearAllPoints(mpUI);
        DzFrameSetPoint(mpUI, 4, DzGetGameUI(), 4, 0.80, -0.60);

        hpmpNativeMoved = true;
    }

    // HP/MP UI初始化（可重试）
    static method initHPMPUI () {
        unitPanel.ensureHPMPTextUI();
        unitPanel.tryMoveNativeHPMPUI();
    }

    //初始化单位按钮面板
    private static method onInit () {
        //在游戏开始0.0秒后再调用
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr,0.0);
        TriggerAddCondition(tr,Condition(function (){
            moveOutAll(); // 把所有原生UI移走
            mapInit(); // 初始化单位按钮面板
            unitPanel.initHPMPUI();

            // 单位选择变化时立即尝试初始化并刷新，减少显示延迟
            unitSelect.onAsync(function () {
                unitPanel.initHPMPUI();
                unitPanel.updateHPMPText();
            });

            // 定时重试初始化，并刷新当前选中单位的生命 / 魔法
            TimerStart(CreateTimer(), 0.25, true, function () {
                unitPanel.initHPMPUI();
                unitPanel.updateHPMPText();
            });

            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;
    }


}


}

//! endzinc
#endif
