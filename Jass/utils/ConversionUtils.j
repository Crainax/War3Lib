#ifndef ConversionUtilsIncluded
#define ConversionUtilsIncluded

//! zinc
/*
转换工具
*/
library ConversionUtils {

    //三目运算符
    public function S3 (boolean b,string s1,string s2)  -> string {
        if (b) {return s1;}
        else {return s2;}
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
