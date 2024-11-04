#ifndef NumberFormatterIncluded
#define NumberFormatterIncluded

//! zinc
/*
数字格式化工具
*/
library NumberFormatter {

    #define UNIT_WAN  10000.0             //万
    #define UNIT_YI   100000000.0         //亿
    #define UNIT_ZHAO 1000000000000.0     //兆
    #define UNIT_JING 10000000000000000.0 //京

    //旧函数名:FormatReal
    //将实数转换为带单位的字符串(万、亿、兆、京)
    //最完整的数字格式化，支持到京为止
    //示例: 12345 -> "1.2万", 123456789 -> "1.23亿"
    public function FormatNumber (real r) -> string {
        real wan = r / UNIT_WAN;
        real yi = r / UNIT_YI;
        real zhao = r / UNIT_ZHAO;
        real jing = r / UNIT_JING;

        if (r < UNIT_WAN) return I2S(R2I(r));
        if (yi < 0.1) return R2SW(wan,0,1) + "万";  //千万以下都有小数点
        if (yi < 1.0) return I2S(R2I(wan)) + "万";  //千万没有小数点
        if (yi < 10.0) return R2SW(yi,0,2) + "亿";
        if (zhao < 1.0) return R2SW(yi,0,1) + "亿";
        if (zhao < 10.0) return I2S(R2I(yi)) + "亿";
        if (zhao < 100.0) return R2SW(zhao,0,2) + "兆";
        if (jing < 1.0) return R2SW(zhao,0,1) + "兆";
        return R2SW(jing,0,1) + "京";
    }

    //旧函数名:FormatReal2
    //将实数转换为简化的带单位字符串(仅支持到亿)
    //适用于装备描述等简单场景
    //示例: 12345 -> "1.2万", 1234567890 -> "12.3亿"
    public function FormatSimple (real r) -> string {
        real wan = r / UNIT_WAN;
        real yi = r / UNIT_YI;

        if (r < UNIT_WAN) return I2S(R2I(r));
        if (yi < 1.0) return R2SW(wan,0,1) + "万";
        if (yi < 10.0) return R2SW(yi,0,2) + "亿";
        return R2SW(yi,0,1) + "亿";
    }

    //旧函数名:FormatRealBW
    //将实数转换为带单位字符串(百万以下保持原值)
    //适用于需要保留较大精度的场景
    //示例: 123456 -> "123456", 12345678 -> "1.2万"
    public function FormatLarge (real r) -> string {
        real wan = r / UNIT_WAN;
        real yi = r / UNIT_YI;

        if (r < 1000000.) return I2S(R2I(r));
        if (yi < 1.0) return R2SW(wan,0,1) + "万";
        if (yi < 10.0) return R2SW(yi,0,2) + "亿";
        if (yi < 10000.0) return R2SW(yi,0,1) + "亿";
        return I2S(R2I(yi)) + "亿";
    }

    //将整数转换为带单位的字符串(万、亿)
    //示例: 12345 -> "1.2万", 1234567890 -> "12.3亿"
    public function FormatInt (integer i) -> string {
        real wan = i / UNIT_WAN;
        real yi = i / UNIT_YI;

        if (yi > 10.0) return R2SW(yi,0,1) + "亿";
        if (yi > 1.0) return R2SW(yi,0,2) + "亿";
        if (wan > 1.0) return R2SW(wan,0,1) + "万";
        return I2S(i);
    }

    #undef UNIT_WAN
    #undef UNIT_YI
    #undef UNIT_ZHAO
    #undef UNIT_JING

    string temp = null;
    //原函数名:FormatNumber
    //格式化成带逗号的格式如123,456,789
    public function FormatWithCommas (integer num)  -> string {
        integer i;
        string  result = I2S(IAbsBJ(num));
        temp     = "";
        for (i = StringLength(result);i > 0;i -= 3) {
            temp = SubStringBJ(result,IMaxBJ(1,i-2),i) + temp;
            if (i > 3) {temp = "," + temp;}
        }
        temp = S3(num < 0,"-","") + temp;
        result = null;
        return temp;
    }

    //测试用:将输入的值转成值返回
    public function ParseReal (string s)  -> real {
        integer len = StringLength(s);
        string lastWord;
        if (len <= 1) {return S2R(s);}
        lastWord = SubStringBJ(s,len,len);
        if (lastWord == "w" || lastWord == "W") {return S2R(SubStringBJ(s,1,len-1)) * 10000.;} //万
        else if (lastWord == "k" || lastWord == "K") {return S2R(SubStringBJ(s,1,len-1)) * 1000.;} //千
        else if (lastWord == "e" || lastWord == "E") {return S2R(SubStringBJ(s,1,len-1)) * 100000000.;} //亿

        return S2R(s);
    }
    //测试用:将输入的值转成值返回
    public function ParseInt (string s)  -> integer {return R2I(ParseReal(s));}

}

//! endzinc
#endif
