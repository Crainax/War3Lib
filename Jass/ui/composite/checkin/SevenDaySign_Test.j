#ifndef UTSevenDaySignIncluded
#define UTSevenDaySignIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
 * SevenDaySign UI 测试清单
 * s1  打开UI（本地玩家）
 * s2  关闭UI（本地玩家）
 * s3  刷新UI（本地玩家）
 * s4  写入占位奖励配置（7天）
 * s5  时间推进一天（+86400）
 * s6  输出当前 dayId
 * -t <timestamp>  设置测试时间（秒）
 * -d <dayId>      设置测试 dayId（按北京时间换算）
 * -open / -close / -refresh  快捷操作
 */
library UTSevenDaySign requires SevenDaySign {

    private static integer testNow = 1700000000;

    private static method applyTestNow(integer t) {
        testNow = t;
        sevenDaySignData.setTestNow(t);
        BJDebugMsg("[UTSevenDaySign] setTime=" + I2S(t) + ", dayId=" + I2S(sevenDaySignData.getBeijingDayId()));
    }

    function TTestUTSevenDaySign1 (player p) {
        if (GetLocalPlayer() == p) {
            sevenDaySignUI.show(p);
            BJDebugMsg("[UTSevenDaySign] UI opened");
        }
    }

    function TTestUTSevenDaySign2 (player p) {
        if (GetLocalPlayer() == p) {
            sevenDaySignUI.hide(p);
            BJDebugMsg("[UTSevenDaySign] UI closed");
        }
    }

    function TTestUTSevenDaySign3 (player p) {
        if (GetLocalPlayer() == p) {
            sevenDaySignUI.refreshForPlayer(p);
            BJDebugMsg("[UTSevenDaySign] UI refreshed");
        }
    }

    function TTestUTSevenDaySign4 (player p) {
        integer i;
        for (1 <= i <= 7) {
            sevenDaySignData.setReward(i,
                "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
                "第" + I2S(i) + "天奖励",
                "奖励说明",
                "这是占位奖励内容");
        }
        BJDebugMsg("[UTSevenDaySign] reward config updated");
    }

    function TTestUTSevenDaySign5 (player p) {
        testNow = testNow + 86400;
        applyTestNow(testNow);
    }

    function TTestUTSevenDaySign6 (player p) {
        BJDebugMsg("[UTSevenDaySign] dayId=" + I2S(sevenDaySignData.getBeijingDayId()));
    }

    function TTestUTSevenDaySign7 (player p) {}
    function TTestUTSevenDaySign8 (player p) {}
    function TTestUTSevenDaySign9 (player p) {}
    function TTestUTSevenDaySign10 (player p) {}

    function TTestActUTSevenDaySign1 (string str) {
        player  p     = GetTriggerPlayer();
        integer index = GetConvertedPlayerId(p);
        integer i,    num = 0, len = StringLength(str);
        string  paramS[];
        integer paramI[];
        real    paramR[];

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

        if (paramS[0] == "t") {
            applyTestNow(paramI[1]);
        } else if (paramS[0] == "d") {
            applyTestNow(paramI[1] * 86400 - 28800);
        } else if (paramS[0] == "open") {
            TTestUTSevenDaySign1(p);
        } else if (paramS[0] == "close") {
            TTestUTSevenDaySign2(p);
        } else if (paramS[0] == "refresh") {
            TTestUTSevenDaySign3(p);
        }

        p = null;
    }

    function Init () {
        UnitTestAutoTimer(0.1, 1.0, function() {
            applyTestNow(testNow);
        }, null);
    }

    function onInit () {
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr,0.5);
        TriggerAddCondition(tr,Condition(function (){
            BJDebugMsg("[SevenDaySign] 单元测试已加载");
            Init();
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;

        UnitTestRegisterChatEvent(function () {
            string str = GetEventPlayerChatString();

            if (SubStringBJ(str,1,1) == "-") {
                TTestActUTSevenDaySign1(SubStringBJ(str,2,StringLength(str)));
                return;
            }
            if (str == "s1") TTestUTSevenDaySign1(GetTriggerPlayer());
            else if(str == "s2") TTestUTSevenDaySign2(GetTriggerPlayer());
            else if(str == "s3") TTestUTSevenDaySign3(GetTriggerPlayer());
            else if(str == "s4") TTestUTSevenDaySign4(GetTriggerPlayer());
            else if(str == "s5") TTestUTSevenDaySign5(GetTriggerPlayer());
            else if(str == "s6") TTestUTSevenDaySign6(GetTriggerPlayer());
            else if(str == "s7") TTestUTSevenDaySign7(GetTriggerPlayer());
            else if(str == "s8") TTestUTSevenDaySign8(GetTriggerPlayer());
            else if(str == "s9") TTestUTSevenDaySign9(GetTriggerPlayer());
            else if(str == "s10") TTestUTSevenDaySign10(GetTriggerPlayer());
        });
    }
}

//! endzinc
#endif
