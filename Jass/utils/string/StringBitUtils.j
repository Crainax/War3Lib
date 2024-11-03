#ifndef StringBitUtilsIncluded
#define StringBitUtilsIncluded

//! zinc
/*
字符串位工具
*/
library StringBitUtils {

    // 根据存档:判断位
    //取相应的整数
    //然后位运算
    //应该知道怎么解决了：
    // 以这个数举例：853
    // 第一位：先对2取余数——1，再除1——1，即第一位是1;
    // 第二位：对4取余数——1，再除2——0，即第二位是0;
    // 第三位：对8取余数5，再除4——1，第三位是1;
    // 第四位：对16取余数5，再除8——0，第四位是0;
    // 第五位：对32取余数21，再除16——1，第五位是1;
    // 第六位：对64取余数21，再除32——0，第六位是0;
    // 第七位：对128取余数85，再除64——1，第七位是1;
    // 第八位：对256取余数85，再除128——0，第八位是0;
    // 第九位：对512取余数341，再除256——1，第九位是1;
    // 第十位：对1024取余数853，再除512——1，第十位是1;
    // 第十一位：对1024取余数853，再除1024——0，第十一位是0;
    // 第三十一位：对1024取余数853，再除1024——0，第十一位是0;
    // 验算：上面这些值加起来也就是853（天才）
    // 可以以这个方法来判断值
    public function IsSuperBit ( string s, integer bit ) -> boolean {
        integer iGroup = (bit - 1)/31 + 1;
        integer iBit = ModuloInteger((bit-1),31) + 1;
        integer resultInt = 0;

        if (bit <= 0 || bit > 186) {return false;}
        resultInt = S2I(SubStringBJ(s,iGroup * 10 - 9,iGroup * 10));
        return I3(iBit == 31,resultInt,ModuloInteger(resultInt,R2I(Pow(2,iBit))))/R2I(Pow(2,iBit-1)) > 0;
    }


    // 设置位
    public function SetSuperBit ( string s,integer bit,boolean b ) -> string {
        integer iGroup = (bit - 1)/31 + 1;
        integer iBit = ModuloInteger((bit-1),31) + 1;
        integer resultInt = 0;
        string result = s;

        if (StringLength(s) < 60) {result = "000000000000000000000000000000000000000000000000000000000000";} //初始化数字

        if (bit <= 0 || bit > 186) {return result;}

        resultInt = S2I(SubStringBJ(result,iGroup * 10 - 9,iGroup * 10));
        if (b) {
            //如果这是要置1
            if (I3(iBit == 31,resultInt,ModuloInteger(resultInt,R2I(Pow(2,iBit))))/R2I(Pow(2,iBit-1)) > 0) {
                //如果这位已经带有，则返还原值
                return result;
            } else {
                resultInt = resultInt + R2I(Pow(2,iBit-1));
            }
        } else {
            //如果这是要置0
            if (I3(iBit == 31,resultInt,ModuloInteger(resultInt,R2I(Pow(2,iBit))))/R2I(Pow(2,iBit-1)) == 0) {
                //如果这位已经是0，则返还原值
                return result;
            } else {
                resultInt = resultInt - R2I(Pow(2,iBit-1));
            }
        }

        //重新拼接字符串
        return SubStringBJ(result,1,iGroup * 10 - 10) + IMendS(resultInt,10) + SubStringBJ(result,iGroup * 10+1,StringLength(result));

    }
}

//! endzinc
#endif
