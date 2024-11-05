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

    interface A {
        method AFunc ();
    }

    struct B extends A {
        public method AFunc () {

        }
    }

    public struct C [] {
        integer x,y;
    }

    function TTestUTZinc6 (player p) {
        //break就相当于exitwhen true
        C[2].x = 5;
        C[2].y = 10;
    }
    //要加个分号 你妈的
    type D extends integer [10];
    function TTestUTZinc7 (player p) {
        D d = D.create();
        d[1] = 50;
        d[2] = 50;
        d.destroy();
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
    function TTestUTZinc9 (player p) {
    }
    function TTestUTZinc10 (player p) {
    }
    function TTestUTZinc11 (player p) {
    }
    function TTestUTZinc12 (player p) {
    }
    function TTestUTZinc13 (player p) {
    }
    function TTestUTZinc14 (player p) {
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
            if (str == "s1"     ) TTestUTZinc1(GetTriggerPlayer());
            else if(str == "s2" ) TTestUTZinc2(GetTriggerPlayer());
            else if(str == "s3" ) TTestUTZinc3(GetTriggerPlayer());
            else if(str == "s4" ) TTestUTZinc4(GetTriggerPlayer());
            else if(str == "s5" ) TTestUTZinc5(GetTriggerPlayer());
            else if(str == "s6" ) TTestUTZinc6(GetTriggerPlayer());
            else if(str == "s7" ) TTestUTZinc7(GetTriggerPlayer());
            else if(str == "s8" ) TTestUTZinc8(GetTriggerPlayer());
            else if(str == "s9" ) TTestUTZinc9(GetTriggerPlayer());
            else if(str == "s10") TTestUTZinc10(GetTriggerPlayer());
            else if(str == "sa" ) TTestUTZinc11(GetTriggerPlayer());
            else if(str == "sb" ) TTestUTZinc12(GetTriggerPlayer());
            else if(str == "sc" ) TTestUTZinc13(GetTriggerPlayer());
            else if(str == "sd" ) TTestUTZinc14(GetTriggerPlayer());
            else if(str == "se" ) TTestUTZinc15(GetTriggerPlayer());
            else if(str == "sf" ) TTestUTZinc16(GetTriggerPlayer());
            else if(str == "sg" ) TTestUTZinc17(GetTriggerPlayer());
            else if(str == "sh" ) TTestUTZinc18(GetTriggerPlayer());
            else if(str == "si" ) TTestUTZinc19(GetTriggerPlayer());
            else if(str == "sj" ) TTestUTZinc20(GetTriggerPlayer());

        });

        t = CreateTimer();
        TimerStart(t,1,false,function (){
            timer t = GetExpiredTimer();
            integer id = GetHandleId(t);
            BJDebugMsg("这是Zinc测试");
            PauseTimer(t);
            FlushChildHashtable(TITable,id);
            DestroyTimer(t);
            t = null;
        });
        t = null;

        cameraControl.openWheel(); //打开滚轮控制镜头

    }

}
//! endzinc

#endif
