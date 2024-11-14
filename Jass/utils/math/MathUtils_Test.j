#ifndef UTMathUtilsIncluded
#define UTMathUtilsIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
 * MathUtils测试库
 * 作者：Crainax
 *
 * 测试命令：
 * s1 - 测试R2IRandom函数
 * s2 - 测试Divide1函数
 * s3 - 测试RealAdd函数
 * s4 - 测试ILimit函数
 * s5 - 测试RLimit函数
 * s6 - 测试R2IM函数
 * s7 - 测试radiationEnd(第一象限)
 *
 * 参数测试命令：
 * -a [数值] - 测试单个数值的转换
 * -b [数值1] [数值2] - 测试两个数值的运算
 */
library UTMathUtils requires MathUtils {

    // 测试R2IRandom函数
    function TTestUTMathUtils1 (player p) {
        real testValue = 3.7;
        integer result = R2IRandom(testValue);
        BJDebugMsg("R2IRandom测试：输入=" + R2S(testValue) + ", 输出=" + I2S(result));
    }

    // 测试Divide1函数
    function TTestUTMathUtils2 (player p) {
        integer i1 = 10;
        integer i2 = 3;
        integer result = Divide1(i1, i2);
        BJDebugMsg("Divide1测试：" + I2S(i1) + "/" + I2S(i2) + "=" + I2S(result));
    }

    // 测试RealAdd函数
    function TTestUTMathUtils3 (player p) {
        real a1 = 0.5;
        real a2 = 0.3;
        real result = RealAdd(a1, a2);
        BJDebugMsg("RealAdd测试：" + R2S(a1) + "+" + R2S(a2) + "=" + R2S(result));
    }

    // 测试ILimit函数
    function TTestUTMathUtils4 (player p) {
        integer target = 15;
        integer min = 0;
        integer max = 10;
        integer result = ILimit(target, min, max);
        BJDebugMsg("ILimit测试：限制" + I2S(target) + "在[" + I2S(min) + "," + I2S(max) + "]范围内=" + I2S(result));
    }

    // 测试RLimit函数
    function TTestUTMathUtils5 (player p) {
        real target = 15.5;
        real min = 0.0;
        real max = 10.0;
        real result = RLimit(target, min, max);
        BJDebugMsg("RLimit测试：限制" + R2S(target) + "在[" + R2S(min) + "," + R2S(max) + "]范围内=" + R2S(result));
    }

    // 测试R2IM函数
    function TTestUTMathUtils6 (player p) {
        real testValue = 3.7;
        integer result = R2IM(testValue);
        BJDebugMsg("R2IM测试：" + R2S(testValue) + "四舍五入=" + I2S(result));
    }

    // radiationEnd测试函数 - 测试边界角度附近的多个点
    function TTestUTMathUtils7 (player p) {
        // 在地图中心区域随机选择一个基准点
        real centerX = (mapBounds.maxX + mapBounds.minX) / 2;
        real centerY = (mapBounds.maxY + mapBounds.minY) / 2;
        real range = 2000; // 在中心2000范围内随机
        real baseX = GetRandomReal(centerX - range/2, centerX + range/2);
        real baseY = GetRandomReal(centerY - range/2, centerY + range/2);

        Trace("radiationEnd测试：基准点=(" + R2S(baseX) + "," + R2S(baseY) + ")");
        Trace("地图边界：minX=" + R2S(mapBounds.minX) + ", maxX=" + R2S(mapBounds.maxX) +
              ", minY=" + R2S(mapBounds.minY) + ", maxY=" + R2S(mapBounds.maxY));

        // 测试0度附近(右方向)
        Trace("\n测试0度附近(右方向)：");
        radiationEnd.cal(baseX, baseY, 359);
        Trace("359度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");
        radiationEnd.cal(baseX, baseY, 0);
        Trace("0度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");
        radiationEnd.cal(baseX, baseY, 1);
        Trace("1度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");

        // 测试90度附近(上方向)
        Trace("\n测试90度附近(上方向)：");
        radiationEnd.cal(baseX, baseY, 89);
        Trace("89度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");
        radiationEnd.cal(baseX, baseY, 90);
        Trace("90度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");
        radiationEnd.cal(baseX, baseY, 91);
        Trace("91度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");

        // 测试180度附近(左方向)
        Trace("\n测试180度附近(左方向)：");
        radiationEnd.cal(baseX, baseY, 179);
        Trace("179度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");
        radiationEnd.cal(baseX, baseY, 180);
        Trace("180度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");
        radiationEnd.cal(baseX, baseY, 181);
        Trace("181度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");

        // 测试270度附近(下方向)
        Trace("\n测试270度附近(下方向)：");
        radiationEnd.cal(baseX, baseY, 269);
        Trace("269度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");
        radiationEnd.cal(baseX, baseY, 270);
        Trace("270度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");
        radiationEnd.cal(baseX, baseY, 271);
        Trace("271度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");

        // 测试45度附近(第一象限)
        Trace("\n测试45度附近(第一象限)：");
        radiationEnd.cal(baseX, baseY, 44);
        Trace("44度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");
        radiationEnd.cal(baseX, baseY, 45);
        Trace("45度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");
        radiationEnd.cal(baseX, baseY, 46);
        Trace("46度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");

        // 测试135度附近(第二象限)
        Trace("\n测试135度附近(第二象限)：");
        radiationEnd.cal(baseX, baseY, 134);
        Trace("134度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");
        radiationEnd.cal(baseX, baseY, 135);
        Trace("135度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");
        radiationEnd.cal(baseX, baseY, 136);
        Trace("136度：终点=(" + R2S(radiationEnd.x) + "," + R2S(radiationEnd.y) + ")");
    }

    // 处理带参数的测试命令
    function TTestActUTMathUtils1 (string str) {
        player  p     = GetTriggerPlayer();
        integer index = GetConvertedPlayerId(p);
        integer i,    num = 0, len = StringLength(str);
        string  paramS[]; // 所有参数S
        integer paramI[]; // 所有参数I
        real    paramR[]; // 所有参数R

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

        // 处理不同的测试命令
        if (paramS[0] == "a") {
            // 测试单个数值
            BJDebugMsg("测试数值：" + R2S(paramR[1]));
            BJDebugMsg("R2IRandom结果：" + I2S(R2IRandom(paramR[1])));
            BJDebugMsg("R2IM结果：" + I2S(R2IM(paramR[1])));
        } else if (paramS[0] == "b") {
            // 测试两个数值的运算
            BJDebugMsg("试数值：" + R2S(paramR[1]) + ", " + R2S(paramR[2]));
            BJDebugMsg("Divide1结果：" + I2S(Divide1(R2I(paramR[1]), R2I(paramR[2]))));
            BJDebugMsg("RealAdd结果：" + R2S(RealAdd(paramR[1], paramR[2])));
        }

        p = null;
    }

    function onInit () {
        //在游戏开始0.5秒后显示测试信息
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr,0.5);
        TriggerAddCondition(tr,Condition(function (){
            BJDebugMsg("[MathUtils] 单元测试已加载");
            BJDebugMsg("使用s1-s7测试各项功能");  // 更新提示信息
            BJDebugMsg("使用-a [数值] 或 -b [数值1] [数值2] 测试具体数值");
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;

        // 注册聊天事件
        UnitTestRegisterChatEvent(function () {
            string str = GetEventPlayerChatString();
            integer i = 1;

            if (SubStringBJ(str,1,1) == "-") {
                TTestActUTMathUtils1(SubStringBJ(str,2,StringLength(str)));
                return;
            }
            if (str == "s1") TTestUTMathUtils1(GetTriggerPlayer());
            else if(str == "s2") TTestUTMathUtils2(GetTriggerPlayer());
            else if(str == "s3") TTestUTMathUtils3(GetTriggerPlayer());
            else if(str == "s4") TTestUTMathUtils4(GetTriggerPlayer());
            else if(str == "s5") TTestUTMathUtils5(GetTriggerPlayer());
            else if(str == "s6") TTestUTMathUtils6(GetTriggerPlayer());
            else if(str == "s7") TTestUTMathUtils7(GetTriggerPlayer());
        });
    }
}
//! endzinc

#endif
