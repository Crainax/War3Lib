#ifndef UTUIIdIncluded
#define UTUIIdIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
UIId单元测试库
测试内容：
1. ID获取和回收的基本功能
2. ID复用功能
3. 计数器功能
4. 边界情况测试
*/
library UTUIId requires UIId {

    // 测试基本的ID获取功能
    function TTestUTUIId1 (player p) {
        integer id1 = uiId.get();
        integer id2 = uiId.get();
        Trace("测试1 - 基本ID获取：");
        Trace("获取的第一个ID: " + I2S(id1));
        Trace("获取的第二个ID: " + I2S(id2));
        Trace("当前活跃ID数量: " + I2S(uiId.getActiveCount()));
    }

    // 测试ID回收功能
    function TTestUTUIId2 (player p) {
        integer id = uiId.get();
        Trace("测试2 - ID回收：");
        Trace("获取新ID: " + I2S(id));
        uiId.recycle(id);
        Trace("回收后的回收池数量: " + I2S(uiId.getRecycledCount()));
    }

    // 测试ID复用功能
    function TTestUTUIId3 (player p) {
        integer id1 = uiId.get(),id2;
        Trace("测试3 - ID复用：");
        Trace("获取新ID: " + I2S(id1));
        uiId.recycle(id1);
        Trace("回收ID: " + I2S(id1));
        id2 = uiId.get();
        Trace("复用的ID: " + I2S(id2));
    }

    // 测试多个ID的回收和复用
    function TTestUTUIId4 (player p) {
        integer id1 = uiId.get(),newId1,newId2;
        integer id2 = uiId.get();
        integer id3 = uiId.get();
        Trace("测试4 - 多ID回收复用：");
        Trace("获取三个ID: " + I2S(id1) + ", " + I2S(id2) + ", " + I2S(id3));
        uiId.recycle(id2);
        uiId.recycle(id3);
        Trace("回收后的回收池数量: " + I2S(uiId.getRecycledCount()));
        newId1 = uiId.get();
        newId2 = uiId.get();
        Trace("复用的两个ID: " + I2S(newId1) + ", " + I2S(newId2));
    }

    // 测试重复回收同一ID
    function TTestUTUIId5 (player p) {
        integer id = uiId.get();
        Trace("测试5 - 重复回收：");
        Trace("获取新ID: " + I2S(id));
        uiId.recycle(id);
        Trace("第一次回收后数量: " + I2S(uiId.getRecycledCount()));
        uiId.recycle(id);
        Trace("重复回收后数量: " + I2S(uiId.getRecycledCount()));
    }

    // 测试计数器功能
    function TTestUTUIId6 (player p) {
        integer id1 = uiId.get();
        integer id2 = uiId.get();
        Trace("测试6 - 计数器：");
        Trace("活跃ID数量: " + I2S(uiId.getActiveCount()));
        Trace("回收池数量: " + I2S(uiId.getRecycledCount()));
        uiId.recycle(id1);
        Trace("回收一个后活跃数量: " + I2S(uiId.getActiveCount()));
    }

    // 保留原有的其他测试函数框架
    function TTestUTUIId7 (player p) {}
    function TTestUTUIId8 (player p) {}
    function TTestUTUIId9 (player p) {}
    function TTestUTUIId10 (player p) {}

    // 命令行参数处理函数
    function TTestActUTUIId1 (string str) {
        player  p     = GetTriggerPlayer();
        integer index = GetConvertedPlayerId(p);
        integer i, id,   num = 0, len = StringLength(str);
        string  paramS [];
        integer paramI [];
        real    paramR [];

        // 解析参数
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

        // 处理特定命令
        if (paramS[0] == "get") {
            id = uiId.get();
            Trace("获取新ID: " + I2S(id));
        } else if (paramS[0] == "recycle") {
            if (num > 1) {
                uiId.recycle(paramI[1]);
                Trace("回收ID: " + I2S(paramI[1]));
            }
        }

        p = null;
    }

    function onInit () {
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr,0.5);
        TriggerAddCondition(tr,Condition(function (){
            Trace("[UIId] 单元测试已加载");
            Trace("使用说明：");
            Trace("s1: 测试基本ID获取");
            Trace("s2: 测试ID回收");
            Trace("s3: 测试ID复用");
            Trace("s4: 测试多ID操作");
            Trace("s5: 测试重复回收");
            Trace("s6: 测试计数器");
            Trace("-get: 获取新ID");
            Trace("-recycle <id>: 回收指定ID");
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;

        UnitTestRegisterChatEvent(function () {
            string str = GetEventPlayerChatString();
            integer i = 1;

            if (SubStringBJ(str,1,1) == "-") {
                TTestActUTUIId1(SubStringBJ(str,2,StringLength(str)));
                return;
            }
            if (str == "s1") TTestUTUIId1(GetTriggerPlayer());
            else if(str == "s2") TTestUTUIId2(GetTriggerPlayer());
            else if(str == "s3") TTestUTUIId3(GetTriggerPlayer());
            else if(str == "s4") TTestUTUIId4(GetTriggerPlayer());
            else if(str == "s5") TTestUTUIId5(GetTriggerPlayer());
            else if(str == "s6") TTestUTUIId6(GetTriggerPlayer());
            else if(str == "s7") TTestUTUIId7(GetTriggerPlayer());
            else if(str == "s8") TTestUTUIId8(GetTriggerPlayer());
            else if(str == "s9") TTestUTUIId9(GetTriggerPlayer());
            else if(str == "s10") TTestUTUIId10(GetTriggerPlayer());
        });
    }
}
//! endzinc

#endif
