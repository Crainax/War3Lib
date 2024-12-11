#ifndef UTUISpriteIncluded
#define UTUISpriteIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
* UISprite组件测试文件
*
* 测试功能:
* 1. 创建模型UI (s1) - 创建默认大小 0.001 x 0.001
* 2. 设置模型路径 (s2) - 创建步兵模型 0.2 x 0.2
* 3. 设置位置 (s3)
* 4. 设置大小 (s4) - 创建大尺寸 0.04 x 0.04
* 5. 销毁模型UI (s5)
* 6. 批量创建测试 (s6)
* 7. 参数化测试:
*    - 位置: -x y z
*    - 大小: -size w h (推荐值: 小型0.001~0.01, 中型0.01~0.05, 大型0.05~0.1)
*/

//# dependency: ui/model/ping2.mdx
library UTUISprite requires UISprite {

    // 存储测试用的sprite实例
    private uiSprite testSprite = 0;

    // 测试创建模型UI
    function TTestUTUISprite1(player p) {
        testSprite = uiSprite.create(DzGetGameUI())
            .setPoint(ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0)
            .setSize(0.001,0.001)  //测试过无论设置成什么都不影响ping的大小
            .setModel("ui\\model\\ping2.mdx",0,0);
        BJDebugMsg("创建模型UI成功");

    }

    function TTestUTUISprite2(player p) {
        // 先销毁已存在的测试sprite
        if (testSprite != 0) {
            testSprite.destroy();
        }

        // 创建新的测试sprite，使用步兵模型，调小尺寸
        testSprite = uiSprite.create(DzGetGameUI())
            .setPoint(ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0)
            .setSize(0.2,0.2)  // 调整为更小的尺寸
            .setScale(0.001)
            .setModel("units\\human\\Footman\\Footman.mdx",0,3);
        BJDebugMsg("创建步兵模型UI (0.05 x 0.05)");
    }

    function TTestUTUISprite3(player p) { //创建个模型
        timer t;
        real progress = 0;
        testSprite = uiSprite.create(DzGetGameUI())
            .setPoint(ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0)
            .setSize(0.001,0.001)
            .setModel("UI\\Feedback\\Cooldown\\UI-Cooldown-Indicator.mdx",0,0)
            .setAnimate(0,false);

        t = CreateTimer();
        SaveReal(HASH_TIMER, GetHandleId(t), 0, 0.0); // 保存进度值
        SaveInteger(HASH_TIMER, GetHandleId(t), 1, 0); // 保存计数器

        TimerStart(t, 0.1, true, function() {
            timer t = GetExpiredTimer();
            integer id = GetHandleId(t);
            real progress = LoadReal(HASH_TIMER, id, 0);
            integer counter = LoadInteger(HASH_TIMER, id, 1);

            progress = progress + 0.01;
            if (progress >= 1.0) {
                progress = 0.0;
            }

            counter = counter + 1;
            if (counter >= 10) {
                BJDebugMsg("当前进度: " + R2S(progress));
                counter = 0;
            }

            SaveReal(HASH_TIMER, id, 0, progress);
            SaveInteger(HASH_TIMER, id, 1, counter);
            testSprite.setProgress(progress);
        });
        t = null;
        BJDebugMsg("创建CD的模型成功");
    }

    // 测试设置大小
    function TTestUTUISprite4(player p) {
        // 先销毁已存在的测试sprite
        if (testSprite != 0) {
            testSprite.destroy();
        }

        // 创建新的测试sprite，设置为较大尺寸
        testSprite = uiSprite.create(DzGetGameUI())
            .setPoint(ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0)
            .setSize(0.04,0.04)  // 设置为较大的尺寸
            .setModel("ui\\model\\ping2.mdx",0,0);
        BJDebugMsg("创建大尺寸模型UI (0.04 x 0.04)");
    }

    function TTestUTUISprite5(player p) {
    }

    function TTestUTUISprite6(player p) {
    }

    // 其他测试用例预留
    function TTestUTUISprite7(player p) {}
    function TTestUTUISprite8(player p) {}
    function TTestUTUISprite9(player p) {}
    function TTestUTUISprite10(player p) {}

    // 参数化测试
    function TTestActUTUISprite1(string str) {
        player p = GetTriggerPlayer();
        integer index = GetConvertedPlayerId(p);
        integer i, num = 0, len = StringLength(str);
        string paramS[];
        integer paramI[];
        real paramR[];

        // 解析参数
        for (0 <= i <= len - 1) {
            if (SubString(str,i,i+1) == " ") {
                paramS[num] = SubString(str,0,i);
                paramI[num] = S2I(paramS[num]);
                paramR[num] = S2R(paramS[num]);
                num = num + 1;
                str = SubString(str,i + 1,len);
                len = StringLength(str);
                i = -1;
            }
        }
        paramS[num] = str;
        paramI[num] = S2I(paramS[num]);
        paramR[num] = S2R(paramS[num]);
        num = num + 1;

        // 根据参数执行不同测试
        if (paramS[0] == "x") {
            if (testSprite != 0) {
            }
        } else if (paramS[0] == "size") {
            if (testSprite != 0) {
                if (num >= 3) {
                    testSprite.setSize(paramR[1], paramR[2]);
                    BJDebugMsg("设置模型大小为: " + R2S(paramR[1]) + " x " + R2S(paramR[2]));
                } else {
                    BJDebugMsg("请输入正确的参数格式: -size 宽度 高度");
                }
            } else {
                BJDebugMsg("请先使用s1创建模型UI");
            }
        }

        p = null;
    }

    function onInit() {
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr,0.5);
        TriggerAddCondition(tr,Condition(function() {
            BJDebugMsg("[UISprite] 单元测试已加载");
            BJDebugMsg("测试指令:");
            BJDebugMsg("s1: 创建默认模型UI (0.001 x 0.001)");
            BJDebugMsg("s2: 设置模型");
            BJDebugMsg("s3: 设置位置");
            BJDebugMsg("s4: 创建大尺寸模型UI (0.04 x 0.04)");
            BJDebugMsg("s5: 销毁模型UI");
            BJDebugMsg("s6: 批量创建测试");
            BJDebugMsg("-x y z: 设置位置(y,z为坐标)");
            BJDebugMsg("-size w h: 设置大小(推荐: 小型0.001~0.01, 中型0.01~0.05)");
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;

        UnitTestRegisterChatEvent(function() {
            string str = GetEventPlayerChatString();

            if (SubStringBJ(str,1,1) == "-") {
                TTestActUTUISprite1(SubStringBJ(str,2,StringLength(str)));
                return;
            }
            if (str == "s1") TTestUTUISprite1(GetTriggerPlayer());
            else if(str == "s2") TTestUTUISprite2(GetTriggerPlayer());
            else if(str == "s3") TTestUTUISprite3(GetTriggerPlayer());
            else if(str == "s4") TTestUTUISprite4(GetTriggerPlayer());
            else if(str == "s5") TTestUTUISprite5(GetTriggerPlayer());
            else if(str == "s6") TTestUTUISprite6(GetTriggerPlayer());
            else if(str == "s7") TTestUTUISprite7(GetTriggerPlayer());
            else if(str == "s8") TTestUTUISprite8(GetTriggerPlayer());
            else if(str == "s9") TTestUTUISprite9(GetTriggerPlayer());
            else if(str == "s10") TTestUTUISprite10(GetTriggerPlayer());
        });
    }
}
//! endzinc

#endif
