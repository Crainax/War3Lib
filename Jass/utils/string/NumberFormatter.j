#ifndef NumberFormatterIncluded
#define NumberFormatterIncluded

//! zinc
/*
数字格式化工具
*/
library NumberFormatter {

    #define UNIT_WAN  10000.0             //万
    #define UNIT_YI   100000000.0         //亿

    //旧函数名:FormatReal
    //将实数转换为带单位的字符串(万、亿、兆、京)
    //最完整的数字格式化，支持到京为止
    //示例: 12345 -> "1.2万", 123456789 -> "1.23亿"
    public function FormatNumber (real r) -> string {
        string result = "";
        real value = r;
        integer unitLevel = 0;  // 0=无单位, 1=万, 2=亿, 3=兆, 4=京
        string units = "";      // 单位字符串

        // 处理负数
        boolean isNegative = (value < 0);
        if (isNegative) {
            value = -value;
        }

        if (value < 10000.0) {
            result = I2S(R2I(value));
            // 对于小于10000的数也需要处理负号
        } else {
            // 循环除以10000直到小于10000
            // 注意：单位最多到“京”，超过“京”不再继续缩小数值，避免出现
            // 10000京 -> 1京、30000京 -> 3京 这类明显缩放错误
            while (value >= 10000.0 && unitLevel < 4) {
                value = value / 10000.0;
                unitLevel = unitLevel + 1;
            }

            // 根据unitLevel确定单位
            if (unitLevel == 1) units = "万";
            else if (unitLevel == 2) units = "亿";
            else if (unitLevel == 3) units = "兆";
            else if (unitLevel >= 4) units = "京";

            // 根据数值范围决定小数位数
            if (value < 10.0) {
                result = R2SW(value, 0, 2) + units;  // 小于10显示2位小数
            } else if (value < 100.0) {
                result = R2SW(value, 0, 1) + units;  // 小于100显示1位小数
            } else {
                result = I2S(R2I(value)) + units;    // 大于等于100显示整数
            }
        }
        // 添加负号
        if (isNegative) {
            result = "-" + result;
        }

        return result;
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
