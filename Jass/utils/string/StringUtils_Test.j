#ifndef UTStringUtilsIncluded
#define UTStringUtilsIncluded

// 用空地图测试
#define EmptyMapUnitTestMode

//! zinc
library UTStringUtils requires StringUtils {

    private function AssertString(string actual, string expected, string name) {
        if (actual == expected) {
            BJDebugMsg("PASS: " + name);
        } else {
            BJDebugMsg("FAIL: " + name);
            BJDebugMsg("  Expected: " + expected);
            BJDebugMsg("  Actual: " + actual);
        }
    }

    private function AssertInteger(integer actual, integer expected, string name) {
        if (actual == expected) {
            BJDebugMsg("PASS: " + name);
        } else {
            BJDebugMsg("FAIL: " + name);
            BJDebugMsg("  Expected: " + I2S(expected));
            BJDebugMsg("  Actual: " + I2S(actual));
        }
    }

    private function RunBase36Tests() {
        AssertString(Base36DigitToChar(0), "0", "Base36DigitToChar 0");
        AssertString(Base36DigitToChar(9), "9", "Base36DigitToChar 9");
        AssertString(Base36DigitToChar(10), "a", "Base36DigitToChar 10");
        AssertString(Base36DigitToChar(35), "z", "Base36DigitToChar 35");
        AssertString(Base36DigitToChar(36), "0", "Base36DigitToChar wraps 36");
        AssertString(Base36DigitToChar(-1), "0", "Base36DigitToChar clamps negative");

        AssertInteger(Base36CharToDigit("0"), 0, "Base36CharToDigit 0");
        AssertInteger(Base36CharToDigit("9"), 9, "Base36CharToDigit 9");
        AssertInteger(Base36CharToDigit("a"), 10, "Base36CharToDigit a");
        AssertInteger(Base36CharToDigit("z"), 35, "Base36CharToDigit z");
        AssertInteger(Base36CharToDigit("A"), -1, "Base36CharToDigit rejects uppercase");
        AssertInteger(Base36CharToDigit("?"), -1, "Base36CharToDigit rejects invalid");
    }

    function onInit() {
        trigger tr;
        tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr, 0.5);
        TriggerAddCondition(tr, Condition(function() {
            BJDebugMsg("[StringUtils] 单元测试已加载");
            RunBase36Tests();
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;
    }
}
//! endzinc

#endif
