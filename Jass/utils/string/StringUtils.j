#ifndef StringUtilsIncluded
#define StringUtilsIncluded

//! zinc
/*
字符串工具
*/
library StringUtils {


    // 数字转字符串,首位自动填充0
    // 不支持负数
    // 比如12,3   -> 012
    public function I2SM ( integer num,integer bit ) -> string {
        integer i , count;
        string s;
        if (num < 0) {return I2S(num);}

        s = I2S(num);
        count = bit - StringLength(s);
        for (1 <= i <= count) {s = "0" + s;}
        return s;
    }


    //赞助系统：循环Hash
    public function GetCycleHash ( string s,integer times ) -> integer {
        string result = s;
        integer i;
        for (1 <= i <= times) {
            result = I2S(StringHash(result));
        }
        return S2I(result);
    }

    //------------存档用字符串-----------------

    //拼接式存放数据的API
    //自动将整数补至10位长度的字符串(会自动取绝对值)
    public function IMendS ( integer num,integer bit ) -> string {
        integer abs = IAbsBJ(num);
        string result = I2S(abs);
        integer i , length = StringLength(result);
        for (1 <= i <= bit - length) {result = "0" + result;}
        return result;
    }


}

//! endzinc
#endif
