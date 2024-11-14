#ifndef UTLuaUtilsIncluded
#define UTLuaUtilsIncluded

#include "d:/War3/Maps/PhantomOrbit/edit/Utils/LuaUtils.j"
#include "edit/core/constant/Variable.j"

//! zinc

//在CRTest.lua里对应测试用例


//自动生成的文件
library UTLuaUtils requires optional LuaUtils,Variable {

    #ifdef TestMode
    function TTestUTLuaUtils1 (player p) {BJDebugMsg(EXExecuteScript("CRTest.CCC(100)")); }
    //显示所有全局变量
    function TTestUTLuaUtils2 (player p) {EXExecuteScript("CRTest.ShowAllGB()");}
    //显示所有JAPI
    function TTestUTLuaUtils3 (player p) {EXExecuteScript("CRTest.ShowAllJapi()");}
    //测试
    function TTestUTLuaUtils4 (player p) {}
    //可以在LUA里操作全局变量
    public integer ITest = 0;
    function TTestUTLuaUtils5 (player p) {Trace("[JASS]ITest:" + I2S(ITest));}
    function TTestUTLuaUtils6 (player p) {EXExecuteScript("CRTest.IncGB()");}
    //测试一下调用计时器
    public code fun = null; //不能在这里这样定义然后
    function TTestUTLuaUtils7 (player p) { //这里会闪退
        TimerStart(CreateTimer(),0.5,true,fun);
        if (fun == null) {
            Trace("notSetCode");
        }
    }
    function TTestUTLuaUtils8 (player p) {EXExecuteScript("CRTest.InitCode()");}
    //显示所有大数库(4个结果,shal,bin,hex看不懂)
    function TTestUTLuaUtils9 (player p) {EXExecuteScript("CRTest.ShowAllBN()");}
    //显示所有废弃库storm的内容(save与load)
    //     save:function: 15D35F48
    // encode_base64:function: 59DDA8E0
    // rebuild:function: 59DDA3A0
    // load:function: 15D35C28
    // decode_base64:function: 59DDAA20
    function TTestUTLuaUtils10 (player p) {EXExecuteScript("CRTest.ShowAllStorm()");}
    //测试HOOK
    function TTestUTLuaUtils11 (player p) {CreateUnit(Player(0),'Hblm',GetRandomReal(0,100),GetRandomReal(0,100),GetRandomReal(0,360));}
    //测试一下文件读(没问题)
    function TTestUTLuaUtils12 (player p) {EXExecuteScript("iou.Read()");}
    //测试一下SLK在LUA的直接调用
    function TTestUTLuaUtils13 (player p) {EXExecuteScript("CRTest.SLKTest1()");}
    //测试一下Plaer(-1)的调用与除0之类的
    function TTestUTLuaUtils14 (player p) {EXExecuteScript("CRTest.JassError()");}
    public integer ITest2; //不初始化就调用试试看
    function TTestUTLuaUtils15 (player p) {EXExecuteScript("CRTest.JassError2()");}
    function TTestUTLuaUtils16 (player p) {BJDebugMsg("ITest2"+":"+I2S(ITest2));}
    function TTestUTLuaUtils17 (player p) {ITest2 = 1;} //未初始化前,在JASS里还是不可用,但是在lua里可用
    //测试一下无限循环(游戏会卡住,这是一个单线程的操作)
    function TTestUTLuaUtils18 (player p) {EXExecuteScript("CRTest.JassError3()");}
    //显示所有message库的东西
    function TTestUTLuaUtils19 (player p) {EXExecuteScript("CRTest.ShowAllMsg()");}
    //LOG库的测试()
    function TTestUTLuaUtils20 (player p) {EXExecuteScript("CRTest.LogTest()");} //写点东西
    function TTestUTLuaUtils21 (player p) {EXExecuteScript("CRTest.ShowAllLog()");} //显示所有函数
    //测试一下控制台的输入
    function TTestUTLuaUtils22 (player p) {EXExecuteScript("CRTest.InputTest()");}
    //测试一下内置的LUA增强
    function TTestUTLuaUtils23 (player p) {EXExecuteScript("CRTest.BJTest()");}
    public function TestLua (integer a,integer b) -> integer {
        GetTriggeringTrigger(); // 给LUA里捕获用
        return 0;
    }
    public function TestLuaShow () {
        BJDebugMsg("TestLua的结果"+":"+I2S(TestLua(20,33)));
    }
    function TTestUTLuaUtils24 (player p) {TestLuaShow();}
    function TTestUTLuaUtils25 (player p) {}
    function TTestUTLuaUtils26 (player p) {}
    function TTestUTLuaUtils27 (player p) {}
    function TTestUTLuaUtils28 (player p) {}
    function TTestUTLuaUtils29 (player p) {}
    function TTestUTLuaUtils30 (player p) {}

    function TTestActUTLuaUtils1 (string str) {
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

        if (paramS[0] == "a") { //测试一下写入本地文件,内置JAPI牛逼
            EXExecuteScript("iou.WriteOver(\""+paramS[1]+"\")");
            Trace("写入了:"+paramS[1]);
        } else if (paramS[0] == "b") {

        }

        p = null;
    }
    #endif

    function onInit () {

        EXExecuteScript("require \"CRTest\""); //引入测试库: CRTest.lua
        // EXExecuteScript("require \"IOUtils\""); //引入测试库: CRTest.lua

        #ifdef TestMode
        UnitTestRegisterChatEvent(function () {
            string str = GetEventPlayerChatString();
            integer i = 1;

            if (SubStringBJ(str,1,1) == "-") {
                TTestActUTLuaUtils1(SubStringBJ(str,2,StringLength(str)));
                return;
            }
            if (str == "s1") TTestUTLuaUtils1(GetTriggerPlayer());
            else if(str == "s2") TTestUTLuaUtils2(GetTriggerPlayer());
            else if(str == "s3") TTestUTLuaUtils3(GetTriggerPlayer());
            else if(str == "s4") TTestUTLuaUtils4(GetTriggerPlayer());
            else if(str == "s5") TTestUTLuaUtils5(GetTriggerPlayer());
            else if(str == "s6") TTestUTLuaUtils6(GetTriggerPlayer());
            else if(str == "s7") TTestUTLuaUtils7(GetTriggerPlayer());
            else if(str == "s8") TTestUTLuaUtils8(GetTriggerPlayer());
            else if(str == "s9") TTestUTLuaUtils9(GetTriggerPlayer());
            else if(str == "s10") TTestUTLuaUtils10(GetTriggerPlayer());
            else if(str == "s11") TTestUTLuaUtils11(GetTriggerPlayer());
            else if(str == "s12") TTestUTLuaUtils12(GetTriggerPlayer());
            else if(str == "s13") TTestUTLuaUtils13(GetTriggerPlayer());
            else if(str == "s14") TTestUTLuaUtils14(GetTriggerPlayer());
            else if(str == "s15") TTestUTLuaUtils15(GetTriggerPlayer());
            else if(str == "s16") TTestUTLuaUtils16(GetTriggerPlayer());
            else if(str == "s17") TTestUTLuaUtils17(GetTriggerPlayer());
            else if(str == "s18") TTestUTLuaUtils18(GetTriggerPlayer());
            else if(str == "s19") TTestUTLuaUtils19(GetTriggerPlayer());
            else if(str == "s20") TTestUTLuaUtils20(GetTriggerPlayer());
            else if(str == "s21") TTestUTLuaUtils21(GetTriggerPlayer());
            else if(str == "s22") TTestUTLuaUtils22(GetTriggerPlayer());
            else if(str == "s23") TTestUTLuaUtils23(GetTriggerPlayer());
            else if(str == "s24") TTestUTLuaUtils24(GetTriggerPlayer());
            else if(str == "s25") TTestUTLuaUtils25(GetTriggerPlayer());
            else if(str == "s26") TTestUTLuaUtils26(GetTriggerPlayer());
            else if(str == "s27") TTestUTLuaUtils27(GetTriggerPlayer());
            else if(str == "s28") TTestUTLuaUtils28(GetTriggerPlayer());
            else if(str == "s29") TTestUTLuaUtils29(GetTriggerPlayer());
            else if(str == "s30") TTestUTLuaUtils30(GetTriggerPlayer());

        }));
        #endif
    }

}
//! endzinc

#endif
