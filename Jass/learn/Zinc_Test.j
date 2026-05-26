#ifndef UTZincIncluded
#define UTZincIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "Zinc.j"

//! zinc

//库名
library UTZinc requires Zinc {

    //不写修饰符的话当private处理
    integer IIII = 0;
    //定义数组不要用array了
    real x[],y [16000];

    #ifdef TestMode
    function TTestUTZinc1 (player p) {
        integer i,index = 1 ;
        //这里测试一下for循环的局部变量问题.只会set i = 0,不会自动变成局部变量
        for (0 <= i < IIII) {
            index *= 3;
        }
    }
    function TTestUTZinc2 (player p) {
        integer i[],j;
        string s = "";
        integer index = GetConvertedPlayerId(p);
        unit u = null;

        //这个编译失败
        // for (0 <= i[1] < 10) {}
        for (0 <= j < 10) {
            i[2] *= 5;
            s += "nimabi";
        }

        //编译后j从9开始
        for (10 > j >= 1) {
            i[1] += 5;
        }

        for (j = 2;j <= 100;j += 2) {BJDebugMsg("hehe");}
        //这种写法编译不给过
        // for (BJDebugMsg("1");j <= 100;BJDebugMsg("2")) {}
    }
    function TTestUTZinc3 (player p) {
        //编译不过
        //SelectUnitSingle(u);
        //一些Bj优化如果不过编译就手动改一下吧


        //AntiBJLeak倒是没问题,因为只是单纯替换文件
        PolledWait(1.0);
    }
    function TTestUTZinc4 (player p) {

        //新建触发:匿名式
        trigger t = CreateTrigger();
        TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_DEATH);
        TriggerAddCondition(t, Condition(function ()  -> boolean {
            return true;
        }));
        TriggerAddAction(t,function () {
            BJDebugMsg("haha");
        });
        t = null;
    }
    struct ceshi  {
        integer x;
    }
    function TTestUTZinc5 (player p) {
        //结构体还是可以当整数用没问题
        ceshi c = ceshi.create();
        integer i = c;
        //结构体的话与library不同,默认public
        c.x = 5;
        BJDebugMsg(I2S(i));
        BJDebugMsg(I2S(c));
        c.destroy();
    }

    //这个目前我的vjassc 不支持,不过也暂时不需要兼容:
    // interface A {
    //     method AFunc ();
    // }

    // struct B extends A {
    //     public method AFunc () {

    //     }
    // }

    public struct C [] {
        integer x,y;
    }

    function TTestUTZinc6 (player p) {
        //break就相当于exitwhen true
        C[2].x = 5;
        C[2].y = 10;
    }

    //以下vjassc暂不兼容:
    // type D extends integer [10];
    function TTestUTZinc7 (player p) {
        //     D d = D.create();
        //     d[1] = 50;
        //     d[2] = 50;
        //     d.destroy();
    }

    //这里测一下函数指针,比自己写Trigger再调用要方便,就是不能递归调用,最好统筹一下队列.
    type funA extends function(player);
    type funC extends function(player);
    type funD extends function(player,integer);
    function TTestUTZinc8 (player p) {
        funA fa = function (player p) { //eavluate调用的缺点好像就是不能递归调用
            BJDebugMsg(GetPlayerName(p));
        };
        funC fc = function (player p) {
            BJDebugMsg(GetPlayerName(p));
        };
        funD fd = function (player p,integer i) {
            BJDebugMsg(GetPlayerName(p)+I2S(i));
        };
        fa.evaluate(p); //这里的p都是相同的,编译成相同东西
        fc.evaluate(p); //这里的p都是相同的,编译成相同东西
        fd.evaluate(p,GetConvertedPlayerId(p)); //这里的p都是相同的,编译成相同东西,后面的i和下面的i也是相同的
    }

    type funB extends function(integer);
    struct E {
        integer x,y;
        static integer z = 0;

        method a () {
            //zinc必须要带this
            // .x += 100;
            // .y += 200;
            this.x += 100;
            this.y += 200;
        }

        method b () {
            funB fn = method () { //本质还是用编译器生成的触发器并eavluate调用,只是不用自己写了
                BJDebugMsg("haha");
            };

            fn.evaluate(this);
        }

        static method onInit () {z += 200;}

    }


    //todo:这个写法目前vjassc不支持(暂时不需要兼容)
    // struct F{
    //     static method A ()  -> integer {
    //         return F.B();
    //     }
    //     static method B ()  -> integer {
    //         return F.A();
    //     }
    // }



    //目前这写写法会自动排序到后面,不会,继续保留这种写法
    function TE (player p,unit u,integer a,real b)  -> nothing {
        TD.execute(p,u,a,b);
    }

    function TC (player p,unit u,integer a,real b)  -> nothing {
        TD.execute(p,u,a,b);
    }

    function TD (player p,unit u,integer a,real b)  -> nothing {
        TC.execute(p,u,a,b);
    }

    function TF (player p,unit u,integer a,real b)  -> nothing {
        TB.evaluate(p,u,a,b);
    }

    function TA (player p,unit u,integer a,real b)  -> nothing {
        TB.evaluate(p,u,a,b);
    }

    function TB (player p,unit u,integer a,real b)  -> nothing {
        TA.evaluate(p,u,a,b);
    }

    function TTestUTZinc9 (player p) {
        //这个vjassc能编译过(无敌!)
        // TTestUTZinc10(p);
    }

    //测试用函数接口
    type II extends function(unit ,real ,real );
    type III extends function(player ,real ,real ) -> integer;
    type IV extends function();
    type IIV extends function(integer);

    public function ImpleII1 (unit caster,real x,real y) {
        BJDebugMsg("1");
    }

    public function ImpleII2 (unit caster,real x,real y) {
        BJDebugMsg("2");
    }

    public function ImpleIII1 (player p,real x,real y) -> integer {
        return 1;
    }

    public function ImpleIII2 (player p,real x,real y) -> integer {
        return 2;
    }

    public function ImpleIV1 () {
        BJDebugMsg("3");
    }

    public function ImpleIV2 () {
        BJDebugMsg("4");
    }

    public function ImpleIIV1 (integer i) {
        BJDebugMsg(I2S(i));
    }

    public function ImpleIIV2 (integer i) {
        BJDebugMsg(I2S(i));
    }

    function TTestUTZinc10 (player p) {
        II a = II.ImpleII1;
        II b = II.ImpleII2;
        III c = III.ImpleIII1;
        III d = III.ImpleIII2;
        IV e = IV.ImpleIV1;
        IV f = IV.ImpleIV2;
        IIV g = IIV.ImpleIIV1;
        IIV h = IIV.ImpleIIV2;
        integer ggg;

        a.execute(null,0,0);
        ggg = c.evaluate(null,0,0);
        e.execute();
        f.evaluate();
    }
    function TTestUTZinc11 (player p) {
        string s = GetEventPlayerChatString();
        integer idx = GetConvertedPlayerId(p);
        integer n; integer k; integer pj; integer df;
        integer cC; integer cB; integer cA; integer cS; integer cSS; integer cSSS;
        string msg;
        if (SubStringBJ(s, 1, 8) == "-pingjia") {
            n = S2I(SubStringBJ(s, 9, StringLength(s)));
            if (n <= 0) { n = 10; }
            for (k = 1; k <= n; k += 1) {
                pj = 7; // SSS
                // FubenGiveChest(idx, pj, GetRandomInt(1, FUBEN_DIFFICULTY_COUNT));
            }
            BJDebugMsg("[TEST] 发放SSS宝箱 x" + I2S(n));
        } else if (SubStringBJ(s, 1, 5) == "-diff") {
            n = S2I(SubStringBJ(s, 7, StringLength(s)));
            if (n < 1) { n = 1; }
            if (n > 15) { n = 15; }
            cC = 0; cB = 0; cA = 0; cS = 0; cSS = 0; cSSS = 0;
            for (k = 1; k <= 6; k += 1) {
                pj = GetRandomInt(2, 7);
                df = n;
                // FubenGiveChest(idx, pj, df);
                if (pj == 2) { cC += 1; }
                else if (pj == 3) { cB += 1; }
                else if (pj == 4) { cA += 1; }
                else if (pj == 5) { cS += 1; }
                else if (pj == 6) { cSS += 1; }
                else if (pj == 7) { cSSS += 1; }
            }
            msg = "[TEST] 发放随机评分宝箱 x6, diff=" + I2S(n)
            + ", 统计: C=" + I2S(cC)
            + ", B=" + I2S(cB)
            + ", A=" + I2S(cA)
            + ", S=" + I2S(cS)
            + ", SS=" + I2S(cSS)
            + ", SSS=" + I2S(cSSS);
            BJDebugMsg(msg);
        }
    }
    function TTestUTZinc12 (player p) {
        // 测试 PingMinimap (所有玩家可见，类似建造完成的蓝色闪烁提示)
        PingMinimap(0.0, 0.0, 5.0); // 在 (0,0) 处发送 5 秒的 PingMinimap
        BJDebugMsg("[TEST] 已在 (0,0) 发送 PingMinimap (持续 5 秒)");
    }
    function TTestUTZinc13 (player p) {
        // 测试 PingMinimapEx (彩色提示)
        // 1. 在 (-500, -500) 处，发送绿色，extraEffects = false (普通波纹)
        PingMinimapEx(-500.0, -500.0, 5.0, 0, 255, 0, false);
        // 2. 在 (500, 500) 处，发送红色，extraEffects = true (带十字线闪烁波纹)
        PingMinimapEx(500.0, 500.0, 5.0, 255, 0, 0, true);
        
        BJDebugMsg("[TEST] 已发送两个 PingMinimapEx：(-500,-500)绿色普通，(500,500)红色附加效果 (持续 5 秒)");
    }
    function TTestUTZinc14 (player p) {
        // 测试 AddIndicator (单位彩色光圈高亮效果)
        // 在地图中央 (0,0) 为玩家创建一个测试单位 'hfoo'（步兵）
        unit u = CreateUnit(p, 'hfoo', 0.0, 0.0, 0.0);
        AddIndicator(u, 255, 0, 0, 255); // 红色高亮光圈，不透明
        BJDebugMsg("[TEST] 已在 (0,0) 创建步兵并为其添加了红色 AddIndicator 指示光圈");
        u = null;
    }
    function TTestUTZinc15 (player p) {
    }
    function TTestUTZinc16 (player p) {
    }
    function TTestUTZinc17 (player p) {
    }
    function TTestUTZinc18 (player p) {
    }
    function TTestUTZinc19 (player p) {
    }
    function TTestUTZinc20 (player p) {
    }
    function TTestActUTZinc1 (string str) {
        player p = GetTriggerPlayer();
        integer index = GetConvertedPlayerId(p),iData1 = S2I(SubStringBJ(str,2,StringLength(str)));
        string s = SubStringBJ(str,1,1);
        real rData1 = S2R(SubStringBJ(str,2,StringLength(str)));
        if (s == "a") { //后面写上注释
        } else if (s == "b") { //后面写上注释
        }
        p = null;
        s = null;
    }
    #endif

    function onInit () {
        integer i2 = 1;
        timer t;
        //这里初始化
        UnitTestRegisterChatEvent(function () { //后面写上注释
            string str = GetEventPlayerChatString();
            integer i = 1;

            if (SubStringBJ(str,1,1 + 1) == "ss") {
                TTestActUTZinc1(SubStringBJ(str,2 + 1,StringLength(str)));
                return;
            }
            if (str == "s1" ) TTestUTZinc1(GetTriggerPlayer());
            if (str == "s2" ) TTestUTZinc2(GetTriggerPlayer());
            if (str == "s3" ) TTestUTZinc3(GetTriggerPlayer());
            if (str == "s4" ) TTestUTZinc4(GetTriggerPlayer());
            if (str == "s5" ) TTestUTZinc5(GetTriggerPlayer());
            if (str == "s6" ) TTestUTZinc6(GetTriggerPlayer());
            if (str == "s7" ) TTestUTZinc7(GetTriggerPlayer());
            if (str == "s8" ) TTestUTZinc8(GetTriggerPlayer());
            if (str == "s10") TTestUTZinc10(GetTriggerPlayer());
            if (str == "sa" ) TTestUTZinc11(GetTriggerPlayer());
            if (str == "sb" ) TTestUTZinc12(GetTriggerPlayer());
            if (str == "sc" ) TTestUTZinc13(GetTriggerPlayer());
            if (str == "sd" ) TTestUTZinc14(GetTriggerPlayer());
            if (str == "se" ) TTestUTZinc15(GetTriggerPlayer());
            if (str == "sf" ) TTestUTZinc16(GetTriggerPlayer());
            if (str == "sg" ) TTestUTZinc17(GetTriggerPlayer());
            if (str == "sh" ) TTestUTZinc18(GetTriggerPlayer());
            if (str == "si" ) TTestUTZinc19(GetTriggerPlayer());
            if (str == "sj" ) TTestUTZinc20(GetTriggerPlayer());

        });

        t = CreateTimer();
        TimerStart(t,1,false,function (){
            timer t = GetExpiredTimer();
            integer id = GetHandleId(t);
            BJDebugMsg("这是Zinc测试");
            PauseTimer(t);
            FlushChildHashtable(HASH_TIMER,id);
            DestroyTimer(t);
            t = null;
        });
        t = null;

        cameraControl.openWheel(); //打开滚轮控制镜头

    }

}
//! endzinc

#endif
