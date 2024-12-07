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

library UnitPanel requires UITocInit {


    public struct unitPanel []{

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
            // 友方建筑单位的金币之类的东西(会频繁重置,需要在选择单位时就重新处理)
            ui = DzSimpleFrameFindByName("SimpleInfoPanelIconAlly", 7);
            DzFrameSetSize( ui, 0.02, 0.02 );
            DzFrameClearAllPoints( ui );
            DzFrameSetPoint( ui, 4, DzGetGameUI(), 4, 0.80, -0.60 );
        }

        // 属性按钮进入事件
        static method onAttrBtnEnter () {

        }

    }


}

//! endzinc
#endif
