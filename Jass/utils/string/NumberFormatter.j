#ifndef NumberFormatterIncluded
#define NumberFormatterIncluded

//! zinc
/*
数字格式化工具
*/

#define UNIT_WAN  10000.0             //万
#define UNIT_YI   100000000.0         //亿

library NumberFormatter {


    // 固定表仅初始化一次；无按输入增长的缓存。热路径最多4次单位比较、1次除法。
    private real numberScale[];
    private string numberUnit[];

    // 万进制，覆盖所有有限 real；保留原有截断/小数位规则。
    public function FormatNumber(real r) -> string {
        real value = r;
        integer unitLevel;
        string digits;
        boolean negative = value < 0.0;
        // 最常见的小数值先返回，不查表、不拼接。
        if (value < 10000.0 && value > -10000.0) return I2S(R2I(r));
        // 同时拒绝 NaN 与无穷；不用除零或依赖巨型字面量。
        if (!(value <= 0.0 || value > 0.0)) return "NaN";
        if (negative) value = -value;
        if (value > 0.0 && !(value * 0.5 < value)) {
            if (negative) return "-溢出";
            return "溢出";
        }
        if (value < numberScale[5]) {
            if (value < numberScale[3]) {
                if (value < numberScale[2]) {
                    unitLevel = 1;
                } else {
                    unitLevel = 2;
                }
            } else {
                if (value < numberScale[4]) {
                    unitLevel = 3;
                } else {
                    unitLevel = 4;
                }
            }
        } else {
            if (value < numberScale[7]) {
                if (value < numberScale[6]) {
                    unitLevel = 5;
                } else {
                    unitLevel = 6;
                }
            } else {
                if (value < numberScale[8]) {
                    unitLevel = 7;
                } else {
                    if (value < numberScale[9]) {
                        unitLevel = 8;
                    } else {
                        unitLevel = 9;
                    }
                }
            }
        }
        value = value / numberScale[unitLevel];
        // 先恢复符号，省掉负号与结果字符串的额外拼接。
        if (value < 10.0) {
            if (negative) value = -value;
            digits = R2SW(value, 0, 2);
        } else if (value < 100.0) {
            if (negative) value = -value;
            digits = R2SW(value, 0, 1);
        } else {
            if (negative) value = -value;
            digits = I2S(R2I(value));
        }
        return digits + numberUnit[unitLevel];
    }

    private function onInit() {
        integer i;
        numberScale[0] = 1.0;
        for (i = 1; i <= 9; i += 1) {
            numberScale[i] = numberScale[i - 1] * 10000.0;
        }
        numberUnit[0] = "";
        numberUnit[1] = "万";
        numberUnit[2] = "亿";
        numberUnit[3] = "兆";
        numberUnit[4] = "京";
        numberUnit[5] = "垓";
        numberUnit[6] = "秭";
        numberUnit[7] = "穰";
        numberUnit[8] = "沟";
        numberUnit[9] = "涧";
    }

    //旧函数名:FormatReal2
    //将实数转换为简化的带单位字符串(仅支持到亿)
    //适用于装备描述等简单场景
    //示例: 12345 -> "1.2万", 1234567890 -> "12.3亿"
    //# check: FormatSimple
    public function FormatSimple (real r) -> string {
        real wan = r / UNIT_WAN;
        real yi = r / UNIT_YI;

        if (r < UNIT_WAN) return I2S(R2I(r));
        if (yi < 1.0) return R2SW(wan,0,1) + "万";
        if (yi < 10.0) return R2SW(yi,0,2) + "亿";
        return R2SW(yi,0,1) + "亿";
    }
    //# endcheck

    //旧函数名:FormatRealBW
    //将实数转换为带单位字符串(百万以下保持原值)
    //适用于需要保留较大精度的场景
    //示例: 123456 -> "123456", 12345678 -> "1.2万"
    //# check: FormatLarge
    public function FormatLarge (real r) -> string {
        real wan = r / UNIT_WAN;
        real yi = r / UNIT_YI;

        if (r < 1000000.) return I2S(R2I(r));
        if (yi < 1.0) return R2SW(wan,0,1) + "万";
        if (yi < 10.0) return R2SW(yi,0,2) + "亿";
        if (yi < 10000.0) return R2SW(yi,0,1) + "亿";
        return I2S(R2I(yi)) + "亿";
    }
    //# endcheck

    //将整数转换为带单位的字符串(万、亿)
    //示例: 12345 -> "1.2万", 1234567890 -> "12.3亿"
    //# check: FormatInt
    public function FormatInt (integer i) -> string {
        real wan = i / UNIT_WAN;
        real yi = i / UNIT_YI;

        if (yi > 10.0) return R2SW(yi,0,1) + "亿";
        if (yi > 1.0) return R2SW(yi,0,2) + "亿";
        if (wan > 1.0) return R2SW(wan,0,1) + "万";
        return I2S(i);
    }
    //# endcheck

    #undef UNIT_WAN
    #undef UNIT_YI

    //原函数名:FormatNumber
    //格式化成带逗号的格式如123,456,789
    //# check: FormatInt
    public function FormatWithCommas (integer num)  -> string {
        integer i;
        string  result = I2S(IAbsBJ(num));
        string  formatted = "";
        for (i = StringLength(result);i > 0;i -= 3) {
            formatted = SubStringBJ(result,IMaxBJ(1,i-2),i) + formatted;
            if (i > 3) {formatted = "," + formatted;}
        }
        if (num <0 ) {
            formatted = "-" + formatted;
        }
        return formatted;
    }
    //# endcheck

    //将实数格式化为字符串，自动去掉末尾的零
    //示例: 123.0 -> "123", 12.3 -> "12.3"
    public function FormatRealTrim (real r) -> string {
        string result = "";
        string formatted = "";
        integer len = 0;

        formatted = R2SW(r, 0, 1);
        len = StringLength(formatted);

        if (len > 2) {
            result = SubStringBJ(formatted, 1, len - 2);
        } else {
            result = formatted;
        }

        return result;
    }

    //测试用:将输入的值转成值返回
    public function ParseReal (string s)  -> real {
        integer len = StringLength(s);
        string lastWord;
        real value;
        if (len <= 1) {return S2R(s);}
        lastWord = SubStringBJ(s,len,len);
        if (lastWord == "w" || lastWord == "W") {return S2R(SubStringBJ(s,1,len-1)) * 10000.;} //万
        else if (lastWord == "k" || lastWord == "K") {return S2R(SubStringBJ(s,1,len-1)) * 1000.;} //千
        else if (lastWord == "e" || lastWord == "E") {return S2R(SubStringBJ(s,1,len-1)) * 100000000.;} //亿
        else if (lastWord == "z" || lastWord == "Z") {
            value = S2R(SubStringBJ(s,1,len-1));
            return value * 100000000. * 10000.; //兆
        }
        else if (lastWord == "j" || lastWord == "J") {
            value = S2R(SubStringBJ(s,1,len-1));
            return value * 100000000. * 100000000.; //京
        }

        return S2R(s);
    }
    //测试用:将输入的值转成值返回
    public function ParseInt (string s)  -> integer {return R2I(ParseReal(s));}

}

//! endzinc
#endif
