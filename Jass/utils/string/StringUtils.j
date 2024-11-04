#ifndef StringUtilsIncluded
#define StringUtilsIncluded

//! zinc
/*
字符串工具
*/
library StringUtils {

    string temp;
    //重复某一个字符串N次,并可以按照指定间隔添加空格和换行
    //参数 s: 要重复的字符串
    //参数 times: 重复的次数
    //参数 gap1: 每隔多少个字符串添加一个空格,如gap1=3则每3个字符串后加空格
    //参数 gap2: 每隔多少个字符串添加一个换行,如gap2=5则每5个字符串后换行
    //返回: 处理后的完整字符串
    //示例: RepeatString("A",6,2,3) 会返回 "AA AA A\nA"
    public function RepeatString (string s,integer times,integer gap1,integer gap2)  -> string {
        integer i;
        temp = "";
        for (1 <= i <= times) {
            temp += s;
            if (ModuloInteger(i,gap1) == 0) temp += " ";
            if (ModuloInteger(i,gap2) == 0) temp += "\n";
        }
        return temp;
    }

    //判断一个字符串是否有东西
    public function IsNotEmpty (string s)  -> boolean {return (s != null && s != "");}

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
