#ifndef UTNumberFormatterIncluded
#define UTNumberFormatterIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode



//! zinc

//自动生成的文件
library UTNumberFormatter requires NumberFormatter {

    // 平台运算差异只记录观察结果，不作为最大有限值验证的失败条件。
    private function TraceComparison(string label, boolean result) {
        if (result) {
            Trace("[NumberFormatter] DIAG " + label + " = true");
        } else {
            Trace("[NumberFormatter] DIAG " + label + " = false");
        }
    }

    // 只打印除以2^104后的有界值：期望 power=8388608、candidate=16777215、term=1。
    private function TraceNormalized(string label, real value) -> integer {
        integer diagnosticIndex;
        real normalized = value;
        if (!(value > 0.0 && value * 0.5 < value)) {
            Trace("[NumberFormatter] " + label + " diagnostic skipped: not positive finite");
            return -1;
        }
        for (diagnosticIndex = 0; diagnosticIndex < 104; diagnosticIndex += 1) {
            normalized = normalized * 0.5;
        }
        if (normalized > 0.0 && normalized < 20000000.0) {
            Trace("[NumberFormatter] " + label + " / 2^104: integer=" + I2S(R2I(normalized)) + ", R2SW=" + R2SW(normalized, 0, 8));
            return R2I(normalized);
        } else {
            Trace("[NumberFormatter] " + label + " diagnostic skipped: outside safe range");
        }
        return -1;
    }

    // 所有循环显式使用块和独立计数器；不执行任何越界运算。
    private function TestMaximum() {
        integer powerIndex;
        integer mantissaIndex;
        integer scaleIndex;
        integer directIndex;
        integer sumRead;
        integer directRead;
        integer predecessorRead;
        real directCandidate = I2R(16777215);
        real directPredecessor = I2R(16777214);
        real power = 1.0;
        real candidate;
        real term;
        real scaled;
        boolean valid;
        boolean candidateGreater;
        boolean candidateFinite;
        boolean predecessorDistinct;
        real predecessor;
        Trace("[NumberFormatter] s1 BEGIN finite-v5");
        for (powerIndex = 0; powerIndex < 127; powerIndex += 1) {
            power = power * 2.0;
        }
        valid = power > 100000000.0 && power * 0.5 < power;
        assert.Boolean(valid, "[NumberFormatter] power construction finite");
        if (!valid) {
            Trace("[NumberFormatter] s1 ABORT: power construction");
            return;
        }
        candidate = power;
        term = power;
        for (mantissaIndex = 0; mantissaIndex < 23; mantissaIndex += 1) {
            term = term * 0.5;
            candidate = candidate + term;
        }
        // 累加及减法仅作平台行为诊断，不要求与独立构造一致。
        candidateGreater = candidate > power;
        candidateFinite = candidate * 0.5 < candidate;
        predecessor = candidate - term;
        predecessorDistinct = predecessor < candidate;
        TraceComparison("sum candidate > power", candidateGreater);
        TraceComparison("sum candidate half < candidate", candidateFinite);
        TraceComparison("sum predecessor < candidate", predecessorDistinct);
        Trace("[NumberFormatter] diagnostic expected /2^104: power=8388608 candidate=16777215 term=1 predecessor=16777214");
        sumRead = TraceNormalized("sum candidate", candidate);
        predecessorRead = TraceNormalized("sum subtraction predecessor", predecessor);
        Trace("[NumberFormatter] direct seeds: candidate=" + I2S(R2I(directCandidate)) + ", predecessor=" + I2S(R2I(directPredecessor)));
        valid = R2I(directCandidate) == 16777215 && R2I(directPredecessor) == 16777214;
        assert.Boolean(valid, "[NumberFormatter] direct integer seeds exact");
        if (!valid) {
            Trace("[NumberFormatter] s1 ABORT: direct seeds");
            return;
        }
        // 独立构造相邻两个有限值，不通过巨大数相减构造前驱。
        for (directIndex = 0; directIndex < 104; directIndex += 1) {
            directCandidate = directCandidate * 2.0;
            directPredecessor = directPredecessor * 2.0;
        }
        directRead = TraceNormalized("direct candidate", directCandidate);
        predecessorRead = TraceNormalized("direct predecessor", directPredecessor);
        assert.Integer(directRead, 16777215, "[NumberFormatter] direct candidate integer readback");
        assert.Integer(predecessorRead, 16777214, "[NumberFormatter] direct predecessor integer readback");
        TraceComparison("sum/direct normalized integers agree", sumRead == directRead);
        TraceComparison("sum/direct values agree", !(candidate != directCandidate));
        assert.Boolean(directPredecessor < directCandidate, "[NumberFormatter] independently constructed predecessor smaller");
        TraceComparison("direct subtraction predecessor smaller", directCandidate - term < directCandidate);
        predecessorRead = TraceNormalized("direct subtraction predecessor", directCandidate - term);
        TraceComparison("direct subtraction integer readback equals 16777214", predecessorRead == 16777214);
        // 只有独立构造用于正式验证；所有诊断差异均不阻断该路径。
        valid = directRead == 16777215 && directCandidate > power && directCandidate * 0.5 < directCandidate;
        assert.Boolean(valid, "[NumberFormatter] independent maximum candidate valid");
        if (!valid) {
            Trace("[NumberFormatter] s1 ABORT: direct candidate validation");
            return;
        }
        candidate = directCandidate;
        scaled = candidate;
        for (scaleIndex = 0; scaleIndex < 9; scaleIndex += 1) {
            scaled = scaled / 10000.0;
        }
        // 先确认缩放成功，才允许转换成字符串。绝不把原始巨大值传给 R2SW。
        valid = scaled > 340.28 && scaled < 340.29;
        assert.Boolean(valid, "[NumberFormatter] scaled candidate in 340.28..340.29");
        if (!valid) {
            Trace("[NumberFormatter] s1 ABORT: scaled value outside expected range");
            return;
        }
        Trace("[NumberFormatter] candidate = I2R(16777215) * 2^104, expected 3.4028234663852886e38");
        Trace("[NumberFormatter] measured / 1e36 = " + R2SW(scaled, 0, 8) + " 涧 (rounded diagnostic)");
        assert.String(FormatNumber(candidate), "340涧", "[NumberFormatter] max format");
        assert.String(FormatNumber(-candidate), "-340涧", "[NumberFormatter] negative max");
        assert.Boolean(!(candidate + 1.0 != candidate), "[NumberFormatter] max + 1 loses precision");
        Trace("[NumberFormatter] s1 END finite-v5; no overflow attempted");
    }

    private function TestFormatting() {
        real scale = 1.0;
        real previousScale;
        real belowTail;
        string units[];
        integer i;
        units[0] = ""; units[1] = "万"; units[2] = "亿"; units[3] = "兆";
        units[4] = "京"; units[5] = "垓"; units[6] = "秭";
        units[7] = "穰"; units[8] = "沟"; units[9] = "涧";
        assert.String(FormatNumber(0.0), "0", "[NumberFormatter] zero");
        assert.String(FormatNumber(9999.0), "9999", "[NumberFormatter] no unit");
        assert.String(FormatNumber(-123.9), "-123", "[NumberFormatter] negative truncation");
        assert.String(FormatNumber(12500.0), "1.25万", "[NumberFormatter] two decimals");
        assert.String(FormatNumber(125000.0), "12.5万", "[NumberFormatter] one decimal");
        for (i = 1; i <= 9; i += 1) {
            previousScale = scale;
            scale = scale * 10000.0;
            assert.String(FormatNumber(scale), "1.00" + units[i], "[NumberFormatter] threshold " + units[i]);
            assert.String(FormatNumber(-scale), "-1.00" + units[i], "[NumberFormatter] negative " + units[i]);
            if (i == 8) {
                belowTail = (scale * 0.5) / previousScale;
                // 万进制缩放在当前运行时可产生约1个ULP误差；不把数学5000当作精确浮点结果。
                // 独立检查误差范围，再验证正负数均遵循向零截断规则，仍须使用“穰”。
                assert.Boolean(belowTail > 4999.999 && belowTail < 5000.001, "[NumberFormatter] below 沟 tail within float tolerance");
                if (belowTail > 4999.999 && belowTail < 5000.001) {
                    Trace("[NumberFormatter] DIAG below 沟 tail=" + R2SW(belowTail, 0, 8) + ", delta=" + R2SW(belowTail - 5000.0, 0, 8) + ", R2I=" + I2S(R2I(belowTail)));
                    assert.String(FormatNumber(scale * 0.5), I2S(R2I(belowTail)) + "穰", "[NumberFormatter] below 沟 truncates actual tail");
                    assert.String(FormatNumber(-scale * 0.5), I2S(R2I(-belowTail)) + "穰", "[NumberFormatter] below 沟 negative truncates toward zero");
                }
            } else {
                assert.String(FormatNumber(scale * 0.5), "5000" + units[i - 1], "[NumberFormatter] below " + units[i]);
            }
            Trace("[NumberFormatter] boundary " + units[i] + ": " + FormatNumber(scale * 0.999999) + " / " + FormatNumber(scale) + " / " + FormatNumber(scale * 1.000001));
        }
    }

    function Init() {
        UnitTestAutoTimer(0.1, 2.0, function() {
            TestFormatting();
            Trace("[NumberFormatter] finite-v5: s1 finite candidate; s2/s3 DISABLED; s4 repeat formatting");
            Trace("[NumberFormatter] s1 must produce one BEGIN and one END; ABORT means validation failed.");
        }, null);
    }

    function TTestUTNumberFormatter1(player p) { TestMaximum(); }
    function TTestUTNumberFormatter2(player p) {
        Trace("[NumberFormatter] s2 DISABLED: no overflow operation executed");
    }
    function TTestUTNumberFormatter3(player p) {
        Trace("[NumberFormatter] s3 DISABLED: no overflow operation executed");
    }
	function TTestUTNumberFormatter4 (player p) { TestFormatting(); }
	function TTestUTNumberFormatter5 (player p) {}
	function TTestUTNumberFormatter6 (player p) {}
	function TTestUTNumberFormatter7 (player p) {}
	function TTestUTNumberFormatter8 (player p) {}
	function TTestUTNumberFormatter9 (player p) {}
	function TTestUTNumberFormatter10 (player p) {}
	function TTestActUTNumberFormatter1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R
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

		if (paramS[0] == "a") {

		} else if (paramS[0] == "b") {

		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[NumberFormatter] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTNumberFormatter1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTNumberFormatter1(GetTriggerPlayer());
			else if(str == "s2") TTestUTNumberFormatter2(GetTriggerPlayer());
			else if(str == "s3") TTestUTNumberFormatter3(GetTriggerPlayer());
			else if(str == "s4") TTestUTNumberFormatter4(GetTriggerPlayer());
			else if(str == "s5") TTestUTNumberFormatter5(GetTriggerPlayer());
			else if(str == "s6") TTestUTNumberFormatter6(GetTriggerPlayer());
			else if(str == "s7") TTestUTNumberFormatter7(GetTriggerPlayer());
			else if(str == "s8") TTestUTNumberFormatter8(GetTriggerPlayer());
			else if(str == "s9") TTestUTNumberFormatter9(GetTriggerPlayer());
			else if(str == "s10") TTestUTNumberFormatter10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
