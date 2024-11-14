#ifndef UTRandSetIncluded
#define UTRandSetIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "D:/War3/Library/War3Lib/Jass/core/structs/RandSet.j"

//! zinc

/*
RandSet单元测试库
作者: Crainax
日期: 2024-11-14

测试命令:
s1 - 测试sequence()方法生成1-5的序列
s2 - 测试add()方法添加自定义数字
s3 - 测试next()方法随机取数
s4 - 测试peek()方法随机查看
s5 - 测试shuffle()方法打乱序列
s6 - 测试clear()方法清理
s7 - 测试isEmpty()和size()方法
s8 - 测试toString()方法
s9 - 测试边界情况(空集合、负数等)
s10 - 综合测试

自定义命令:
-a n    : 添加数字n到集合
-b n    : 生成1到n的序列
*/

library UTRandSet requires RandSet {

    // 测试sequence()方法
    function TTestUTRandSet1(player p) {
        Trace("测试1: 生成1-5的序列");
        randSet.sequence(5);
        Trace("当前序列: " + randSet.toString());
        randSet.clear();
    }

    // 测试add()方法
    function TTestUTRandSet2(player p) {
        Trace("测试2: 添加自定义数字");
        randSet.add(10);
        randSet.add(20);
        randSet.add(30);
        Trace("当前序列: " + randSet.toString());
        randSet.clear();
    }

    // 测试next()方法
    function TTestUTRandSet3(player p) {
        integer result;
        Trace("测试3: 随机取数测试");
        randSet.sequence(5);
        Trace("初始序列: " + randSet.toString());
        result = randSet.next();
        Trace("取出数字: " + I2S(result));
        Trace("剩余序列: " + randSet.toString());
        randSet.clear();
    }

    // 测试peek()方法
    function TTestUTRandSet4(player p) {
        integer result;
        Trace("测试4: 随机查看测试");
        randSet.sequence(5);
        Trace("当前序列: " + randSet.toString());
        result = randSet.peek();
        Trace("查看数字: " + I2S(result));
        Trace("序列不变: " + randSet.toString());
        randSet.clear();
    }

    // 测试shuffle()方法
    function TTestUTRandSet5(player p) {
        Trace("测试5: 打乱序列测试");
        randSet.sequence(10);
        Trace("原始序列: " + randSet.toString());
        randSet.shuffle();
        Trace("打乱后: " + randSet.toString());
        randSet.clear();
    }

    // 测试clear()方法
    function TTestUTRandSet6(player p) {
        Trace("测试6: 清理测试");
        randSet.sequence(5);
        Trace("清理前: " + randSet.toString());
        randSet.clear();
        Trace("清理后: " + randSet.toString());
    }

    // 测试isEmpty()和size()方法
    function TTestUTRandSet7(player p) {
        Trace("测试7: 空和大小测试");
        Trace("空集合判断: " + B2S(randSet.isEmpty()));
        randSet.sequence(3);
        Trace("添加3个数后:");
        Trace("是否为空: " + B2S(randSet.isEmpty()));
        Trace("集合大小: " + I2S(randSet.size()));
        randSet.clear();
    }

    // 测试toString()方法
    function TTestUTRandSet8(player p) {
        Trace("测试8: 字符串显示测试");
        randSet.sequence(5);
        Trace("序列内容: " + randSet.toString());
        randSet.clear();
    }

    // 测试边界情况
    function TTestUTRandSet9(player p) {
        Trace("测试9: 边界情况测试");
        Trace("空集合next(): " + I2S(randSet.next()));
        Trace("空集合peek(): " + I2S(randSet.peek()));
        randSet.sequence(0);
        randSet.sequence(-1);
        randSet.clear();
    }

    // 综合测试
    function TTestUTRandSet10(player p) {
        integer i = 0;
        integer result;
        Trace("测试10: 综合测试");

        // 初始化序列
        randSet.sequence(5);
        Trace("初始序列: " + randSet.toString());

        // 打乱序列
        randSet.shuffle();
        Trace("打乱后: " + randSet.toString());

        // 连续取出3个数字
        Trace("开始随机取数:");
        for (0 <= i < 3) {
            result = randSet.next();
            Trace("取出: " + I2S(result) + ", 剩余序列: " + randSet.toString());
        }

        // 显示最终状态
        Trace("最终状态:");
        Trace("剩余序列: " + randSet.toString());
        Trace("剩余大小: " + I2S(randSet.size()));

        randSet.clear();
    }

    // 处理自定义命令
    function TTestActUTRandSet1(string str) {
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

        if (paramS[0] == "a") {
            // 添加指定数字
            randSet.add(paramI[1]);
            Trace("添加数字 " + I2S(paramI[1]));
            Trace("当前序列: " + randSet.toString());
        } else if (paramS[0] == "b") {
            // 生成指定范围序列
            randSet.sequence(paramI[1]);
            Trace("生成1到" + I2S(paramI[1]) + "的序列");
            Trace("当前序列: " + randSet.toString());
        }

        p = null;
    }

    function onInit() {
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr,0.5);
        TriggerAddCondition(tr,Condition(function() {
            Trace("[RandSet] 单元测试已加载");
            Trace("输入s1-s10测试不同功能");
            Trace("输入-a n添加数字, -b n生成序列");
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;

        UnitTestRegisterChatEvent(function() {
            string str = GetEventPlayerChatString();
            integer i = 1;

            if (SubStringBJ(str,1,1) == "-") {
                TTestActUTRandSet1(SubStringBJ(str,2,StringLength(str)));
                return;
            }
            if (str == "s1") TTestUTRandSet1(GetTriggerPlayer());
            else if(str == "s2") TTestUTRandSet2(GetTriggerPlayer());
            else if(str == "s3") TTestUTRandSet3(GetTriggerPlayer());
            else if(str == "s4") TTestUTRandSet4(GetTriggerPlayer());
            else if(str == "s5") TTestUTRandSet5(GetTriggerPlayer());
            else if(str == "s6") TTestUTRandSet6(GetTriggerPlayer());
            else if(str == "s7") TTestUTRandSet7(GetTriggerPlayer());
            else if(str == "s8") TTestUTRandSet8(GetTriggerPlayer());
            else if(str == "s9") TTestUTRandSet9(GetTriggerPlayer());
            else if(str == "s10") TTestUTRandSet10(GetTriggerPlayer());
        });
    }
}

//! endzinc
#endif
