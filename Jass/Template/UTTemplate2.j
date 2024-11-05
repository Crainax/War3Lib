#ifndef UTHeroStructIncluded
#define UTHeroStructIncluded

#include "d:/War3/Maps/PhantomOrbit/edit/Data/HeroStruct.j"
#include "edit/Constant/Variable.j"
#include "edit/Base/UIBase.j"
// #include "edit/Utils/LuaUtils.j"

//! zinc

//一个超级牛逼的可视化测试模块
library UTHeroStruct requires optional HeroStruct,Variable,UIBase,optional LuaUtils {

    #ifdef TestMode

    function TTestUTHeroStruct1 (player p) {
        trigger t = CreateTrigger();
        TriggerRegisterPlayerChatEvent( t, p, "", false );
        TriggerAddCondition(t, Condition(function () {
            string str = GetEventPlayerChatString();
            player p = GetTriggerPlayer();

            p = null;
            str = null;
            DestroyTrigger(GetTriggeringTrigger());
        }));
        t = null;
    }
    function TTestUTHeroStruct2 (player p) {
        BJDebugMsg("TTestUTHeroStruct2");
    }
    function TTestUTHeroStruct3 (player p) {
        BJDebugMsg("TTestUTHeroStruct3");
    }
    function TTestUTHeroStruct4 (player p) {
        BJDebugMsg("TTestUTHeroStruct4");
    }
    function TTestUTHeroStruct5 (player p) {
        BJDebugMsg("TTestUTHeroStruct5");
    }
    function TTestUTHeroStruct6 (player p) {
        BJDebugMsg("TTestUTHeroStruct6");
    }
    function TTestUTHeroStruct7 (player p) {
        BJDebugMsg("TTestUTHeroStruct7");
    }
    function TTestUTHeroStruct8 (player p) {
        BJDebugMsg("TTestUTHeroStruct8");
    }
    function TTestUTHeroStruct9 (player p) {
        BJDebugMsg("TTestUTHeroStruct9");
    }
    function TTestUTHeroStruct10 (player p) {
        BJDebugMsg("TTestUTHeroStruct10");
    }
    function TTestActUTHeroStruct1 (string str) {
        player  p     = GetTriggerPlayer();
        integer index = GetConvertedPlayerId(p);
        integer i,     num = 0, len = StringLength(str); //获取范围式数字
        string  paramS [];                               //所有参数S
        integer paramI [];                               //所有参数I
        real    paramR [];                               //所有参数R
        for (0 <= i <= len - 1) {
            if (SubString(str,i,i+1) == " ") {
                paramS[num]= SubString(str,0,i);
                paramI[num]= S2I(paramS[num]);
                paramR[num]= S2R(paramS[num]);
                num = num + 1;
                str = SubString(str,i + 1,len);
                len = StringLength(str);
                i = -1;
            }
        }
        paramS[num]= str;
        paramI[num]= S2I(paramS[num]);
        paramR[num]= S2R(paramS[num]);
        num = num + 1;

        if (paramS[0] == "a") {

        } else if (paramS[0] == "b") {

        }

        p = null;
    }
    #endif


    //垃圾UI没有索引只能这样寻址
    function indexByUI (integer ui)  -> integer {
        integer i;
        for (1 <= i <= 10) {
            if (UIButton[i] == ui) {return i;}
        }
        return 0;
    }

    string names[];//内容
    integer UITitle = 0 , UIBG = 0; //主UI
    integer UIButton[],UIText[]; //按钮
    function onInit () {
        integer i , UIImg[] ;
        trigger t = CreateTrigger();
		for (1 <= i <= MAX_PLAYER_COUNT) {TriggerRegisterPlayerSelectionEventBJ(t, ConvertedPlayer(i), true);}
        TriggerAddCondition(t, Condition(function () {
            //选择事件
            integer index = GetConvertedPlayerId(GetTriggerPlayer());
            USelected[index] = GetTriggerUnit();
            if (GetLocalPlayer() == GetTriggerPlayer()) { //这里异步修改
                DzFrameSetText(UITitle,"当前修改:"+ GetUnitName(USelected[index]));
            }
        }));
        t = null;

        names[1] = "测试1哈哈1";
        names[2] = "测试22";
        names[3] = "测试1哈哈3";
        names[4] = "测试1哈哈4";
        names[5] = "测试1哈哈5";
        names[6] = "测试1哈哈6";
        names[7] = "测试1哈哈7";
        names[8] = "测试1哈哈8";
        names[9] = "测试1哈哈9";
        names[10] = "测试1哈哈10";

        UIBG = CreateBackDrop(DzGetGameUI()); //背景
        DzFrameSetTexture(UIBG,"UI\\Widgets\\EscMenu\\Human\\editbox-background.blp",0);
        UITitle = NewTextXXL(UIBG); //创建UIUP,

        //核心锚点
        if (i <= 1) {DzFrameSetPoint(UIText[i],ANCHOR_TOPRIGHT,UIBG,ANCHOR_BOTTOMRIGHT,-0.005,-0.005);}
        DzFrameSetText(UITitle,"英雄名字:");
        DzFrameSetPoint(UITitle,ANCHOR_TOPRIGHT,DzGetGameUI(),ANCHOR_TOPRIGHT,-0.01,-0.022);
        DzFrameSetPoint(UIBG,ANCHOR_TOPLEFT,UITitle,ANCHOR_TOPLEFT,-0.01,0.01);
        DzFrameSetPoint(UIBG,ANCHOR_BOTTOMRIGHT,UITitle,ANCHOR_BOTTOMRIGHT,0.01,-0.01);

        //所有按钮
        for (i = 1;names[i] != null;i += 1) {
            UIImg[i] = CreateBackDrop(UIBG);
            DzFrameSetTexture(UIImg[i],"UI\\Widgets\\EscMenu\\Human\\editbox-background.blp",0);
            UIText[i] = NewTextXL(UIImg[i]);
            DzFrameSetText(UIText[i],names[i]);
            DzFrameSetPoint(UIImg[i],ANCHOR_TOPLEFT,UIText[i],ANCHOR_TOPLEFT,-0.005,0.005);
            DzFrameSetPoint(UIImg[i],ANCHOR_BOTTOMRIGHT,UIText[i],ANCHOR_BOTTOMRIGHT,0.005,-0.005);
            UIButton[i] = CreateButton(UIImg[i]);
            DzFrameSetAllPoints(UIButton[i],UIImg[i]);
            DzFrameSetScriptByCode(UIButton[i],FRAME_MOUSE_ENTER,function (){
                integer pos = indexByUI(DzGetTriggerUIEventFrame());
                DzFrameSetText(UIText[pos],"|cff00ff22"+names[pos]+"|r");
            },false);
            DzFrameSetScriptByCode(UIButton[i],FRAME_MOUSE_LEAVE,function (){
                integer pos = indexByUI(DzGetTriggerUIEventFrame());
                DzFrameSetText(UIText[pos],names[pos]);
            },false);
            DzFrameSetScriptByCode(UIButton[i],FRAME_MOUSE_UP,function (){
                integer pos = indexByUI(DzGetTriggerUIEventFrame());
                DzSyncData("HeroT",I2S(pos));
            },false);

            if (i <= 1) {DzFrameSetPoint(UIText[i],ANCHOR_TOPRIGHT,UIBG,ANCHOR_BOTTOMRIGHT,-0.005,-0.005);}
            else {DzFrameSetPoint(UIText[i],ANCHOR_TOPRIGHT,UIImg[i-1],ANCHOR_BOTTOMRIGHT,-0.005,-0.005);}
        }


        //同步事件
        t = CreateTrigger();
        DzTriggerRegisterSyncData(t,"HeroT",false);
        TriggerAddCondition(t, Condition(function () {
            string str = DzGetTriggerSyncData();
            player p = DzGetTriggerSyncPlayer();
            integer index = GetConvertedPlayerId(p);
            if (str == "1") {TTestUTHeroStruct1(p);}
            else if (str == "2") {TTestUTHeroStruct2(p);}
            else if (str == "3") {TTestUTHeroStruct3(p);}
            else if (str == "4") {TTestUTHeroStruct4(p);}
            else if (str == "5") {TTestUTHeroStruct5(p);}
            else if (str == "6") {TTestUTHeroStruct6(p);}
            else if (str == "7") {TTestUTHeroStruct7(p);}
            else if (str == "8") {TTestUTHeroStruct8(p);}
            else if (str == "9") {TTestUTHeroStruct9(p);}
            else if (str == "10") {TTestUTHeroStruct10(p);}
            str = null;
            p = null;
        }));
        t = null;

        #ifdef TestMode
        UnitTestRegisterChatEvent(function () {
            string str = GetEventPlayerChatString();
            integer i = 1;

            if (SubStringBJ(str,1,1) == "-") {
                TTestActUTHeroStruct1(SubStringBJ(str,2,StringLength(str)));
                return;
            }
            if (str == "o") DzFrameShow(UIBG,true);
            else if(str == "c") DzFrameShow(UIBG,false);

        }));
        #endif
    }

}
//! endzinc

#endif
