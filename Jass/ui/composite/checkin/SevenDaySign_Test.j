#ifndef UTSevenDaySignIncluded
#define UTSevenDaySignIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
* SevenDaySign UI 测试清单
* F2  切换 UI 显示/隐藏（本地玩家）
* s1  打开UI（本地玩家，兼容保留）
* s2  关闭UI（本地玩家，兼容保留）
* s3  刷新UI（本地玩家）
* s4  写入占位奖励配置（14天）
* s5  时间推进一天（+86400）
* s6  输出当前 dayId
* s7  切换 VIP 激活状态
* s8  输出当前存档天数、展示天数和总天数
* -t <timestamp>  设置测试时间（秒）
* -d <dayId>      设置测试 dayId（按北京时间换算）
* -open / -close / -refresh  快捷操作
*/

library UTSevenDaySign requires SevenDaySign,Keyboard {

    private integer testNow = 1700000000;

    private function applyTestNow(integer t) {
        testNow = t;
        sevenDaySignData.setTestNow(t);
        BJDebugMsg("[UTSevenDaySign] setTime=" + I2S(t) + ", dayId=" + I2S(sevenDaySignData.getBeijingDayId()));
    }

    // 初始化奖励配置（不同地图可以有不同的配置）
    private function initRewardData() {
        // 第 1-7 天：原始签到奖励
        sevenDaySignData.setReward(1,
        "ui\\image\\sign_1.blp",
        "副本评分+5%\n开局复活次数+25");
        sevenDaySignData.setReward(2,
        "ui\\image\\sign_2.blp",
        "圣晶石<小>\n无尽复活次数奖励+1");
        sevenDaySignData.setReward(3,
        "ui\\image\\sign_3.blp",
        "天赋技能选项+1\n学习技能选项+1\n开局复活次数+40");
        sevenDaySignData.setReward(4,
        "ui\\image\\sign_4.blp",
        "圣晶石<中>\n副本评分+10%\n无尽复活次数奖励+2");
        sevenDaySignData.setReward(5,
        "ui\\image\\sign_5.blp",
        "合成装备选项+1\n开局复活次数+60");
        sevenDaySignData.setReward(6,
        "ui\\image\\sign_6.blp",
        "天赋技能选项+2\n学习技能选项+2\n副本评分+15%\n无尽复活次数奖励+3");
        sevenDaySignData.setReward(7,
        "ui\\image\\sign_7.blp",
        "圣晶石<大>\n解锁英雄玉藻前");

        // 第 8 天后：异度点奖励（图标循环使用 sign_ydd_1~4）
        sevenDaySignData.setReward(8,
        "ui\\image\\sign_ydd_1.blp",
        "完成每日签到,领取异度点奖励!");
        sevenDaySignData.setReward(9,
        "ui\\image\\sign_ydd_2.blp",
        "完成每日签到,领取异度点奖励!");
        sevenDaySignData.setReward(10,
        "ui\\image\\sign_ydd_3.blp",
        "完成每日签到,领取异度点奖励!");
        sevenDaySignData.setReward(11,
        "ui\\image\\sign_ydd_1.blp",
        "完成每日签到,领取异度点奖励!");
        sevenDaySignData.setReward(12,
        "ui\\image\\sign_ydd_2.blp",
        "完成每日签到,领取异度点奖励!");
        sevenDaySignData.setReward(13,
        "ui\\image\\sign_ydd_3.blp",
        "完成每日签到,领取异度点奖励!");
        sevenDaySignData.setReward(14,
        "ui\\image\\sign_ydd_4.blp",
        "完成每日签到,领取异度点奖励!");

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
        initRewardData();
        BJDebugMsg("[UTSevenDaySign] reward config updated (14 days)");
    }

    function TTestUTSevenDaySign5 (player p) {
        testNow = testNow + 86400;
        applyTestNow(testNow);
    }

    function TTestUTSevenDaySign6 (player p) {
        BJDebugMsg("[UTSevenDaySign] dayId=" + I2S(sevenDaySignData.getBeijingDayId()));
    }

    function TTestUTSevenDaySign7 (player p) {
        // 切换 VIP 激活状态
        boolean cur;
        cur = sevenDaySignData.isVipActive(p);
        sevenDaySignData.setVipActive(p, !cur);
        BJDebugMsg("[UTSevenDaySign] VIP active=" + S3(!cur, "true", "false"));
        if (GetLocalPlayer() == p) {
            sevenDaySignUI.refreshForPlayer(p);
        }
    }

    function TTestUTSevenDaySign8 (player p) {
        BJDebugMsg("[UTSevenDaySign] storedDay=" + I2S(sevenDaySignData.getStoredClaimedDay(p))
        + " viewDay=" + I2S(sevenDaySignData.getClaimedDay(p))
        + " rewardCount=" + I2S(sevenDaySignData.getRewardCount()));
    }

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
        initRewardData();
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

        // 注册 F2：切换签到 UI 显示/隐藏
        keyboard.regKeyDownEvent(KEY_F2, function (){
            player lp;
            lp = GetLocalPlayer();

            if (!sevenDaySignUI.isShow()) {
                sevenDaySignUI.show(lp);
            } else {
                sevenDaySignUI.hide(lp);
            }

            lp = null;
        });
        keyboard.regKeyUpEvent(KEY_F2, null);
    }

    //I3
}

//! endzinc
#endif
