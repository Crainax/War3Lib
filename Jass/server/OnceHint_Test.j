#ifndef UTOnceHintIncluded
#define UTOnceHintIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

// ===========================================================================
// OnceHint 单元测试（精简：仅测 isReady / has / mark）
//
// 注意：库本身不再提供 reset / resetAll，且 DzAPI 存档跨局保留。
// 因此测试用例运行时会"动态挑选当前 has() 仍为 false 的 bit 位"做幂等验证；
// 全部位被填满时会打印告警，提示需要清档（属业务正常行为，非框架缺陷）。
//
// 聊天指令：
//   s1   isReady() 在 0.5s 后应为 true
//   s2   动态找一个空位：mark 第一次 true，再次 mark 返回 false（has 一直为 true）
//   s3   越界 / 非法参数防护
//   -mark <pos>   手动 mark 一位
//   -has <pos>    打印某位状态
// ===========================================================================

library UTOnceHint requires OnceHint {

    private integer TBIT_OUT_LOW  = 0;     // 越界（<=0）
    private integer TBIT_OUT_HIGH = 200;   // 越界（>186）

    // 在 [from, to] 中找一个 has==false 的位，没找到返回 0
    private function FindEmptyBit(player p, integer from, integer to) -> integer {
        integer i;
        for (from <= i <= to) {
            if (!onceHint.has(p, i)) {
                return i;
            }
        }
        return 0;
    }

    // ---------- 测试用例 ----------

    function Test1_IsReady(player p) {
        // 用例1：开局 0.5s 后存档拉取完毕，isReady 应为 true
        BJDebugMsg("[OnceHint][T1] isReady() 应为 true");
        assert.Boolean(onceHint.isReady(), "T1.isReady should be true after 0.5s");
    }

    function Test2_MarkAndHas(player p) {
        // 用例2：mark 首次返回 true，has 转为 true，再 mark 返回 false（幂等）
        integer pos;
        boolean r1;
        boolean r2;
        BJDebugMsg("[OnceHint][T2] mark / has 行为");

        pos = FindEmptyBit(p, 100, ONCE_HINT_MAX_BIT);
        if (pos == 0) {
            BJDebugMsg("[OnceHint][T2] WARN: 测试位池(100..186)已满，请清档后再跑");
            return;
        }
        BJDebugMsg("[OnceHint][T2] 选用空位 pos=" + I2S(pos));

        assert.Boolean(!onceHint.has(p, pos), "T2.has(pos) should be false before mark");

        r1 = onceHint.mark(p, pos);
        assert.Boolean(r1, "T2.mark first call should return true");
        assert.Boolean(onceHint.has(p, pos), "T2.has(pos) should be true after mark");

        r2 = onceHint.mark(p, pos);
        assert.Boolean(!r2, "T2.mark second call should return false");
        assert.Boolean(onceHint.has(p, pos), "T2.has(pos) should remain true");
    }

    function Test3_OutOfRange(player p) {
        // 用例3：越界与非法参数应安全返回 false
        boolean r1;
        boolean r2;
        BJDebugMsg("[OnceHint][T3] 越界与非法参数防护");

        r1 = onceHint.mark(p, TBIT_OUT_LOW);
        r2 = onceHint.mark(p, TBIT_OUT_HIGH);
        assert.Boolean(!r1, "T3.mark(<=0) should return false");
        assert.Boolean(!r2, "T3.mark(>186) should return false");
        assert.Boolean(!onceHint.has(p, TBIT_OUT_LOW),  "T3.has(<=0) should be false");
        assert.Boolean(!onceHint.has(p, TBIT_OUT_HIGH), "T3.has(>186) should be false");
        assert.Boolean(!onceHint.mark(null, 1),         "T3.mark(null,1) should return false");
    }

    function Init () {
        // 等存档就绪后做一次自检：0.6s 时刻已晚于 OnceHint 内部 0.5s ready
        UnitTestAutoTimer(0.6, 0, function() {
            player p0 = Player(0);
            BJDebugMsg("[OnceHint] 全量自检开始");

            Test1_IsReady(p0);
            Test2_MarkAndHas(p0);
            Test3_OutOfRange(p0);

            BJDebugMsg("[OnceHint] 全量自检完成（聊天 s1..s3 可单独复跑）");
            p0 = null;
        }, null);
    }

    // ---------- 聊天单测入口 ----------

    function TTestUTOnceHint1 (player p) { Test1_IsReady(p); }
    function TTestUTOnceHint2 (player p) { Test2_MarkAndHas(p); }
    function TTestUTOnceHint3 (player p) { Test3_OutOfRange(p); }
    function TTestUTOnceHint4 (player p) {}
    function TTestUTOnceHint5 (player p) {}
    function TTestUTOnceHint6 (player p) {}
    function TTestUTOnceHint7 (player p) {}
    function TTestUTOnceHint8 (player p) {}
    function TTestUTOnceHint9 (player p) {}
    function TTestUTOnceHint10 (player p) {}

    function TTestActUTOnceHint1 (string str) {
        player  p     = GetTriggerPlayer();
        integer index = GetConvertedPlayerId(p);
        integer i,    num = 0, len = StringLength(str); //获取范围式数字
        string  paramS [];                              //所有参数S
        integer paramI [];                              //所有参数I
        real    paramR [];                              //所有参数R
        boolean r;

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

        if (paramS[0] == "mark") {
            if (num >= 2) {
                r = onceHint.mark(p, paramI[1]);
                BJDebugMsg("[OnceHint] mark(" + I2S(paramI[1]) + ") -> " + I2S(I3(r,1,0)));
            } else {
                BJDebugMsg("usage: -mark <pos>");
            }
        } else if (paramS[0] == "has") {
            if (num >= 2) {
                BJDebugMsg("[OnceHint] has(" + I2S(paramI[1]) + ") = " + I2S(I3(onceHint.has(p, paramI[1]),1,0)));
            } else {
                BJDebugMsg("usage: -has <pos>");
            }
        } else {
            BJDebugMsg("[OnceHint] cmds: -mark <pos>, -has <pos>");
        }

        p = null;
    }

    function onInit () {
        //在游戏开始 0.5 秒后再调用（OnceHint 在 0.5s 完成存档拉取）
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr, 0.5);
        TriggerAddCondition(tr, Condition(function (){
            BJDebugMsg("[OnceHint] 单元测试已加载");
            Init();
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;

        UnitTestRegisterChatEvent(function () {
            string str = GetEventPlayerChatString();
            integer i = 1;

            if (SubStringBJ(str,1,1) == "-") {
                TTestActUTOnceHint1(SubStringBJ(str,2,StringLength(str)));
                return;
            }
            if (str == "s1") TTestUTOnceHint1(GetTriggerPlayer());
            else if(str == "s2") TTestUTOnceHint2(GetTriggerPlayer());
            else if(str == "s3") TTestUTOnceHint3(GetTriggerPlayer());
            else if(str == "s4") TTestUTOnceHint4(GetTriggerPlayer());
            else if(str == "s5") TTestUTOnceHint5(GetTriggerPlayer());
            else if(str == "s6") TTestUTOnceHint6(GetTriggerPlayer());
            else if(str == "s7") TTestUTOnceHint7(GetTriggerPlayer());
            else if(str == "s8") TTestUTOnceHint8(GetTriggerPlayer());
            else if(str == "s9") TTestUTOnceHint9(GetTriggerPlayer());
            else if(str == "s10") TTestUTOnceHint10(GetTriggerPlayer());
        });

    }

}
//! endzinc

#endif
