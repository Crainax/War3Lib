#ifndef NumberUtilsIncluded
#define NumberUtilsIncluded

//! zinc
/*
数字工具
*/
library NumberUtils  {

    // 老版本叫GetIntegerBit(替换)
    // 获取一个整数中指定范围的数字(按十进制位数)
    // @param value - 要处理的整数,如1483
    // @param bit1 - 起始位置(从右往左,从1开始),如1表示个位
    // @param bit2 - 结束位置,如3表示百位
    // @return - 返回指定范围的数字,如1483取1-3位返回483
    public function GetNumberRange (integer value,integer bit1,integer bit2) -> integer {
        if (bit1 > bit2) {return 0;}
        if (bit1 <= 0 || bit2 <= 0) {return 0;}
        return ModuloInteger(value,R2I(Pow(10,bit2)))/R2I(Pow(10,bit1-1));
    }
    // 老版本叫GetBit(替换)
    // 获取一个整数中指定位置的单个数字(按十进制位数)
    // @param num - 要处理的整数,如1483
    // @param bit - 要获取的位置(从右往左,从1开始),如2表示十位
    // @return - 返回指定位置的数字,如1483取第2位返回8
    // 注意:会自动处理负数(取绝对值),位数超出或不合法返回0
    public function GetDigitAt (integer num,integer bit) -> integer {
        integer bit1 = R2I(Pow(10,bit-1));     //举例,1483取位2 ->这个是10;
        integer bit2 = R2I(Pow(10,bit));       //举例,1483取位2 ->这个是100;
        num = IAbsBJ(num);                     //取绝对值
        if (bit <= 0 || bit >= 32) {return 0;} //超了整数上限
        if (bit1 > num) {return 0;}            //取了不该取的位
        bit1 = IMaxBJ(1,bit1);
        //先取余100,再除10 ->
        return ModuloInteger(num,bit2) / bit1;
    }
}

//! endzinc
#endif
