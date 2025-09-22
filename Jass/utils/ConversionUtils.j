#ifndef ConversionUtilsIncluded
#define ConversionUtilsIncluded

//! zinc
/*
转换工具
*/
library ConversionUtils {

    //补充函数
    public function B2S(boolean b) -> string {
        if (b) {return "true";}
        else {return "false";}
    }

    //三目运算符
    public function S3 (boolean b,string s1,string s2)  -> string {
        if (b) {return s1;}
        else {return s2;}
    }
    //三目运算符
    public function U3 (boolean b,unit u1,unit u2)  -> unit {
        if (b) {return u1;}
        else {return u2;}
    }
    //三目运算符
    public function I3 (boolean b,integer i1,integer i2)  -> integer  {
        if (b) {return i1;}
        else {return i2;}
    }
    //三目运算符
    public function R3 (boolean b,real r1,real r2)  -> real  {
        if (b) {return r1;}
        else {return r2;}
    }

    // 三目选择器(整数版) - 旧名S4
    // @param b1 - 第一个条件
    // @param b2 - 第二个条件
    // @param i1 - 当b1为真时返回的值
    // @param i2 - 当b1为假且b2为真时返回的值
    // @param i3 - 当b1和b2都为假时返回的值
    // @return - 根据条件返回对应的整数值
    public function SelectInteger (boolean b1,boolean b2,integer i1,integer i2,integer i3) -> integer {
        if (b1) {
            return i1;
        } else if (b2) {
            return i2;
        } else {
            return i3;
        }
    }

    // 三目选择器(实数版) - 旧名R4
    // @param b1 - 第一个条件
    // @param b2 - 第二个条件
    // @param r1 - 当b1为真时返回的值
    // @param r2 - 当b1为假且b2为真时返回的值
    // @param r3 - 当b1和b2都为假时返回的值
    // @return - 根据条件返回对应的实数值
    public function SelectReal (boolean b1,boolean b2,real r1,real r2,real r3) -> real {
        if (b1) {
            return r1;
        } else if (b2) {
            return r2;
        } else {
            return r3;
        }
    }

    // 带权重的随机选择 - 旧名RandomI4
    // @param prob1 - 第一个选项的概率权重
    // @param prob2 - 第二个选项的概率权重
    // @param prob3 - 第三个选项的概率权重
    // @param value1 - 第一个选项的返回值
    // @param value2 - 第二个选项的返回值
    // @param value3 - 第三个选项的返回值
    // @param defaultValue - 默认返回值(当随机数超出所有权重范围时)
    // @return - 根据权重随机返回对应的值
    public function RandomWeightedChoice (real prob1, real prob2, real prob3, integer value1, integer value2, integer value3, integer defaultValue) -> integer {
        real random = GetRandomReal(0, 1.0);
        real threshold2 = prob1 + prob2;
        real threshold3 = threshold2 + prob3;

        if (random < prob1) {
            return value1;
        } else if (random < threshold2) {
            return value2;
        } else if (random < threshold3) {
            return value3;
        }

        return defaultValue;
    }

    // 将数字转换为魔兽的四字符ID,使用256进制但限制36个数一进位
    // pos为输入数字,每36个数字进一位,每位用0-9和a-z表示(共36个字符)
    // 示例:0->'0000', 35->'000z', 36->'0010'(进位), 37->'0011'
    public function GetIDSymbol ( integer pos ) -> integer {
        integer bit = pos/36;
        pos = ModuloInteger(pos,36);
        if (pos < 10) {return pos + bit * 256;}
        else {return '000a' - '0000' + pos - 10 + bit * 256;}
    }
    // 将魔兽的四字符ID转换回对应数字
    // s为输入的四字符ID,将其还原为原始数字
    // 示例:'0000'->0, '000z'->35, '0010'->36, '0011'->37
    public function GetSymbolID ( integer s ) -> integer {
        integer i1 = s/256;
        integer i2 = ModuloInteger(s,256);
        if (i2 < 10) {return i1 * 36 + i2;}
        else {return i2 - '000a' + '0000' + 10 + i1 * 36;}
    }

}

//! endzinc
#endif
