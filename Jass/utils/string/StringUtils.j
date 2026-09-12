#ifndef StringUtilsIncluded
#define StringUtilsIncluded

//! zinc
/*
字符串工具
*/
library StringUtils {

    string temp;

    // 判断字符串是否非空且非null
    public function IsNotNullString(string s) -> boolean {
        return s != null && s != "";
    }

    // 判断单字符是否为数字
    public function IsDigitChar(string s) -> boolean {
        return s == "0" || s == "1" || s == "2" || s == "3" || s == "4" || s == "5" || s == "6" || s == "7" || s == "8" || s == "9";
    }

    // 将 0..35 的单个 base36 位值编码为字符，越界值按单字符位宽归一化。
    public function Base36DigitToChar(integer value) -> string {
        if (value < 0) { value = 0; }
        if (value >= 36) { value = ModuloInteger(value, 36); }
        if (value < 10) {
            return I2S(value);
        }
        return SubStringBJ("abcdefghijklmnopqrstuvwxyz", value - 9, value - 9);
    }

    // 将单个 base36 字符解码为 0..35；非法字符返回 -1。
    public function Base36CharToDigit(string ch) -> integer {
        integer i;

        for (0 <= i <= 9) {
            if (ch == I2S(i)) {
                return i;
            }
        }
        for (1 <= i <= 26) {
            if (ch == SubStringBJ("abcdefghijklmnopqrstuvwxyz", i, i)) {
                return i + 9;
            }
        }
        return -1;
    }

    // 将整数编码为固定两位 base36 字符串，值域归一化到 0..1295。
    public function Base36Encode2(integer value) -> string {
        if (value < 0) { value = 0; }
        value = ModuloInteger(value, 36 * 36);
        return Base36DigitToChar(value / 36) + Base36DigitToChar(ModuloInteger(value, 36));
    }

    // 解码固定两位 base36 字符串；长度错误或包含非法字符时返回 -1。
    public function Base36Decode2(string value) -> integer {
        integer high;
        integer low;

        if (value == null || StringLength(value) != 2) { return -1; }
        high = Base36CharToDigit(SubStringBJ(value, 1, 1));
        low = Base36CharToDigit(SubStringBJ(value, 2, 2));
        if (high < 0 || low < 0) { return -1; }
        return high * 36 + low;
    }

    // 判断非空字符串是否全部由十进制数字组成。
    public function IsDigitString(string value) -> boolean {
        integer i;

        if (value == null || value == "") { return false; }
        for (1 <= i <= StringLength(value)) {
            if (!IsDigitChar(SubStringBJ(value, i, i))) { return false; }
        }
        return true;
    }

    // 判断非空字符串是否全部由二进制字符组成。
    public function IsBinaryString(string value) -> boolean {
        integer i;
        string ch;

        if (value == null || value == "") { return false; }
        for (1 <= i <= StringLength(value)) {
            ch = SubStringBJ(value, i, i);
            if (ch != "0" && ch != "1") { return false; }
        }
        return true;
    }

    // 判断非空字符串是否全部由小写 base36 字符组成。
    public function IsBase36String(string value) -> boolean {
        integer i;

        if (value == null || value == "") { return false; }
        for (1 <= i <= StringLength(value)) {
            if (Base36CharToDigit(SubStringBJ(value, i, i)) < 0) { return false; }
        }
        return true;
    }

    // 在非负整数左侧补 0 至指定宽度；负数及已经达到宽度的值保持原字符串。
    public function PadIntegerLeftZero(integer value, integer width) -> string {
        integer i;
        integer count;
        string result;

        result = I2S(value);
        if (value < 0) { return result; }
        count = width - StringLength(result);
        for (1 <= i <= count) { result = "0" + result; }
        return result;
    }

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
            if (gap1 > 0) {
                if (ModuloInteger(i,gap1) == 0) temp += " ";
            }
            if (gap2 > 0) {
                if (ModuloInteger(i,gap2) == 0) temp += "\n";
            }
        }
        return temp;
    }

    // 数字转字符串,首位自动填充0
    // 不支持负数
    // 比如12,3   -> 012
    public function I2SM ( integer num,integer bit ) -> string {
        return PadIntegerLeftZero(num, bit);
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
        return PadIntegerLeftZero(IAbsBJ(num), bit);
    }


}

//! endzinc
#endif
