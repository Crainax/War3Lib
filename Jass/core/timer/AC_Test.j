#ifndef UTACIncluded
#define UTACIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
 * AC (Action Controller) 单元测试
 *
 * 测试指令:
 * s1 - 测试一次性定时任务
 * s2 - 测试循环定时任务
 * s3 - 测试数据绑定
 * s4 - 测试任务注销
 * s5 - 打印当前任务列表
 * -unreg [id] - 注销指定ID的任务
 * -unregAll - 注销所有任务
 *
 * @author Crainax
 * @version 1.0
*/
library UTAC requires AC {

    // 测试一次性定时任务
    function TTestUTAC1 (player p) {
        ac.reg(2.0, false, function() {
			ac this = ac.ethis;
            Trace("[线程:" + I2S(this) + "] 一次性定时任务测试: 2秒后触发一次");
        });
    }

    // 测试循环定时任务
    function TTestUTAC2 (player p) {
        ac task = ac.reg(1.0, true, function() {
			ac this = ac.ethis;
            Trace("[线程:" + I2S(this) + "] 循环定时任务测试: 每1秒触发一次");
        });
        Trace("已创建循环任务,ID:" + I2S(task));
    }

    // 测试数据绑定
    function TTestUTAC3 (player p) {
        ac task = ac.reg(1.0, true, function() {
            ac this = ac.ethis;
            integer count = this.getInt(1) + 1;
            this.saveInt(1, count);
            Trace("[线程:" + I2S(this) + "] 数据绑定测试: 当前计数 " + I2S(count));
        });
        task.saveInt(1, 0); // 初始化计数器
        Trace("已创建带数据绑定的任务,ID:" + I2S(task));
    }

    // 测试任务注销
    function TTestUTAC4 (player p) {
        ac task = ac.reg(1.0, true, function() {
			ac this = ac.ethis;
            Trace("[线程:" + I2S(this) + "] 该消息只会显示一次,然后任务自动注销");
            this.unreg();
        });
    }

    // 打印当前任务列表
    function TTestUTAC5 (player p) {
        Trace(ac.toString());
    }

    // 其他测试函数保持空实现
    function TTestUTAC6 (player p) {}
    function TTestUTAC7 (player p) {}
    function TTestUTAC8 (player p) {}
    function TTestUTAC9 (player p) {}
    function TTestUTAC10 (player p) {}

    // 处理带参数的命令
    function TTestActUTAC1 (string str) {
        player  p     = GetTriggerPlayer();
        integer index = GetConvertedPlayerId(p);
        integer i,     num = 0, len = StringLength(str);
        integer count = 0;
		ac task;
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

        // 处理命令
        if (paramS[0] == "unreg") {
            task = paramI[1];
            if (task.isExist()) {
                task.unreg();
                Trace("已注销任务 " + I2S(task));
            } else {
                Trace("任务不存在");
            }
        } else if (paramS[0] == "unregAll") {
            // 从后往前遍历,避免数组重排带来的问题
            for (i = ac.size; i >= 1; i -= 1) {
                task = ac.List[i];
                if (task.isExist()) {
                    task.unreg();
                    count += 1;
                }
            }
            Trace("已注销所有任务,共" + I2S(count) + "个");
        }

        p = null;
    }

    function onInit () {
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr,0.5);
        TriggerAddCondition(tr,Condition(function (){
            Trace("[AC] 单元测试已加载");
            Trace("输入s1-s5测试不同功能");
            Trace("-unreg [id] 可注销指定任务");
            Trace("-unregAll 可注销所有任务");
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;

        UnitTestRegisterChatEvent(function () {
            string str = GetEventPlayerChatString();
            integer i = 1;

            if (SubStringBJ(str,1,1) == "-") {
                TTestActUTAC1(SubStringBJ(str,2,StringLength(str)));
                return;
            }
            if (str == "s1") TTestUTAC1(GetTriggerPlayer());
            else if(str == "s2") TTestUTAC2(GetTriggerPlayer());
            else if(str == "s3") TTestUTAC3(GetTriggerPlayer());
            else if(str == "s4") TTestUTAC4(GetTriggerPlayer());
            else if(str == "s5") TTestUTAC5(GetTriggerPlayer());
        });
    }
}
//! endzinc

#endif
