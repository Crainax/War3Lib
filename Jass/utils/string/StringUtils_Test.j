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

    private function AssertBoolean(boolean actual, boolean expected, string name) {
        if (actual == expected) {
            BJDebugMsg("PASS: " + name);
        } else {
            BJDebugMsg("FAIL: " + name);
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

        AssertString(Base36Encode2(0), "00", "Base36Encode2 0");
        AssertString(Base36Encode2(1295), "zz", "Base36Encode2 1295");
        AssertInteger(Base36Decode2("zz"), 1295, "Base36Decode2 zz");
        AssertInteger(Base36Decode2("A0"), -1, "Base36Decode2 rejects invalid");
        AssertInteger(Base36Decode2("0"), -1, "Base36Decode2 rejects wrong length");

        AssertBoolean(IsDigitString("0129"), true, "IsDigitString digits");
        AssertBoolean(IsDigitString("01a"), false, "IsDigitString rejects letter");
        AssertBoolean(IsBinaryString("0101"), true, "IsBinaryString bits");
        AssertBoolean(IsBinaryString("012"), false, "IsBinaryString rejects 2");
        AssertBoolean(IsBase36String("09az"), true, "IsBase36String lowercase");
        AssertBoolean(IsBase36String("09AZ"), false, "IsBase36String rejects uppercase");

        AssertString(PadIntegerLeftZero(12, 3), "012", "PadIntegerLeftZero pads");
        AssertString(PadIntegerLeftZero(1234, 3), "1234", "PadIntegerLeftZero keeps overflow");
        AssertString(PadIntegerLeftZero(-1, 3), "-1", "PadIntegerLeftZero keeps negative");
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
