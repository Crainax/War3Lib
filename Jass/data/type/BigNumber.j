#ifndef BigNumberIncluded
#define BigNumberIncluded

//! zinc
/*
资源:金币
处理范围：0 到 21万亿（21,000,000,000,000）
low: 存储-999999999到999999999
high: 存储-2100000000到2100000000
*/
#include "Crainax/config/SharedMethod.h"

#define UNIT_TEN_YI 1000000000  // 10亿，作为进位基数
#define MAX_HIGH    2100000000  // high的最大值：21亿

library BigNumber {

    public struct bigNumber {

        STRUCT_SHARED_METHODS(bigNumber)

        integer low;  // 低位，存储-999999999到999999999
        integer high; // 高位，存储-2100000000到2100000000

        static method create() -> thistype {
            thistype this = thistype.allocate();
            this.low = 0;
            this.high = 0;
            return this;
        }


        //==============================
        // 辅助: 判断自身是否为负数
        //==============================
        private method isNegative() -> boolean {
            if (this.high < 0) {
                return true;
            } else if (this.high == 0 && this.low < 0) {
                return true;
            }
            return false;
        }

        //==============================
        // 辅助: 取自身反号
        //==============================
        private method negate() {
            this.high = -this.high;
            this.low  = -this.low;

            // 当反号后，low、high 不在预期区间时，做一次借位或退位修正
            if (this.low < 0 && this.high > 0) {
                this.low  = this.low + UNIT_TEN_YI;
                this.high = this.high - 1;
            } else if (this.low > 0 && this.high < 0) {
                this.low  = this.low - UNIT_TEN_YI;
                this.high = this.high + 1;
            }

            // 防止溢出
            if (this.high > MAX_HIGH) {
                this.high = MAX_HIGH;
                this.low  = 999999999;
            } else if (this.high < -MAX_HIGH) {
                this.high = -MAX_HIGH;
                this.low  = -999999999;
            }
        }

        //==============================
        // 辅助: 若自身为负，就改为正
        //==============================
        private method makePositive() {
            if (this.isNegative()) {
                this.negate();
            }
        }

        //==============================
        // 加法: (highPart, lowPart) 加到自身
        //==============================
        method add(integer highPart, integer lowPart) {
            // 加到低位
            this.low += lowPart;

            // 处理低位进位/借位
            if (this.low >= UNIT_TEN_YI) {
                this.high += (this.low / UNIT_TEN_YI);
                this.low   = ModuloInteger(this.low, UNIT_TEN_YI);
            } else if (this.low <= -UNIT_TEN_YI) {
                this.high += (this.low / UNIT_TEN_YI);
                this.low   = -ModuloInteger(IAbsBJ(this.low), UNIT_TEN_YI);
            } else if (this.low < 0 && this.high > 0) {
                this.low   = this.low + UNIT_TEN_YI;
                this.high  = this.high - 1;
            } else if (this.low > 0 && this.high < 0) {
                this.low   = this.low - UNIT_TEN_YI;
                this.high  = this.high + 1;
            }

            // 加到高位
            this.high += highPart;

            // 防止溢出
            if (this.high > MAX_HIGH) {
                this.high = MAX_HIGH;
                this.low  = 999999999;
            } else if (this.high < -MAX_HIGH) {
                this.high = -MAX_HIGH;
                this.low  = -999999999;
            }
        }

        //==============================
        // 加实数
        //==============================
        method addReal(real value) {
            integer highValue = 0;
            integer lowValue  = 0;
            real tempHigh = 0.0;

            if (value >= 1000000000.0) {
                // 先计算除以10亿后的值
                tempHigh = value / 1000000000.0;

                // 检查是否会溢出
                if (tempHigh > 2100000000.0) {
                    highValue = 2100000000;
                    lowValue = 999999999;
                } else {
                    highValue = R2I(tempHigh);
                    lowValue = R2I(ModuloReal(value, 1000000000.0));
                }
            } else if (value <= -1000000000.0) {
                // 处理负数，先取绝对值计算
                tempHigh = RAbsBJ(value) / 1000000000.0;

                // 检查是否会溢出
                if (tempHigh > 2100000000.0) {
                    highValue = -2100000000;
                    lowValue = -999999999;
                } else {
                    highValue = -R2I(tempHigh);
                    lowValue = -R2I(ModuloReal(RAbsBJ(value), 1000000000.0));
                }
            } else {
                lowValue  = R2I(value);
            }

            this.add(highValue, lowValue);
        }


        //==============================
        // 克隆自身
        //==============================
        private method clone() -> thistype {
            thistype tmp = thistype.allocate();
            tmp.high = this.high;
            tmp.low  = this.low;
            return tmp;
        }

        //==============================
        // 把另一个 bigNumber 加到自身
        //==============================
        private method addBigNumber(bigNumber other) {
            this.add(other.high, other.low);
        }

        //==============================
        // 翻倍 (×2)
        //==============================
        private method doubleBN() {
            // doubleBN = self + self
            this.add(this.high, this.low);
        }

        //==============================
        // 乘法: 与 32 位整数相乘(无 64 位)
        //==============================
        method multiplyInteger(integer val) {
            integer sign   = 1;
            integer tmpVal = val;
            bigNumber result = thistype.create();
            bigNumber temp   = this.clone();
            real tempValue;

            // 0. 提前检查是否会溢出
            tempValue = (I2R(this.high) * UNIT_TEN_YI) * I2R(tmpVal);
            if (tempValue >= 2.1 * Pow(10.0, 18)) {  // 210京
                // 正向溢出
                this.high = MAX_HIGH;
                this.low = 999999999;
                return;
            } else if (tempValue <= -2.1 * Pow(10.0, 18)) {  // -210京
                // 负向溢出
                this.high = -MAX_HIGH;
                this.low = -999999999;
                return;
            }

            // 1. 符号处理
            if (tmpVal < 0) {
                tmpVal = -tmpVal;
                sign   = -sign;
            }
            if (this.isNegative()) {
                temp.negate();
                sign = -sign;
            }

            // 2. 二进制拆分乘法
            while (tmpVal > 0) {
                // 如果当前位是1，就把temp加到结果中
                if (ModuloInteger(tmpVal, 2) == 1) {
                    result.addBigNumber(temp);
                }
                // temp翻倍（相当于左移一位）
                temp.doubleBN();
                // tmpVal右移一位
                tmpVal = tmpVal / 2;
            }

            // 3. 恢复符号
            if (sign < 0) {
                result.negate();
            }

            // 4. 将 result 写回当前
            this.high = result.high;
            this.low  = result.low;

            // 5. 释放临时对象
            result.destroy();
            temp.destroy();
        }

        //==============================
        // 乘法: 与实数相乘(有精度损失)
        //==============================
        method multiplyReal(real rVal) {
            real highProduct;
            real lowProduct;
            integer newHigh;
            integer newLow;

            // 分别计算高和低位 rVal 的乘积
            highProduct = I2R(this.high) * rVal;
            lowProduct = I2R(this.low) * rVal;

            // 处理高位部分
            newHigh = R2I(highProduct * 1000000000.0);
            newLow = R2I(lowProduct);

            // 清零后重新加入结果
            this.high = 0;
            this.low = 0;
            this.add(newHigh, newLow);
        }

        //==============================
        // 比较: 与另一个 bigNumber
        // 返回 1(大于)/0(等于)/-1(小于)
        //==============================
        method compareBigNumber(bigNumber other) -> integer {
            if (this.high > other.high) {
                return 1;
            } else if (this.high < other.high) {
                return -1;
            } else {
                if (this.low > other.low) {
                    return 1;
                } else if (this.low < other.low) {
                    return -1;
                } else {
                    return 0;
                }
            }
        }

        //==============================
        // 比较: 与 32 位整数
        //==============================
        method compareInteger(integer val) -> integer {
            // 如果 high 不 0，么结果由 high 的符号决定
            if (this.high > 0) {
                return 1;
            } else if (this.high < 0) {
                return -1;
            }

            // high 为 0 时，直接比较 low 与 val
            if (this.low > val) {
                return 1;
            } else if (this.low < val) {
                return -1;
            }
            return 0;
        }

        //==============================
        // 比较: 与实数(浮点会有误差)
        //==============================
        method compareReal(real val) -> integer {
            integer highPart;
            real lowPart,absVal;
            // 处理 val 的范围
            if (val >= 1000000000.0) {
                highPart = R2I(val / 1000000000.0);
                lowPart = ModuloReal(val, 1000000000.0);

                // 先较高位
                if (this.high > highPart) {
                    return 1;
                } else if (this.high < highPart) {
                    return -1;
                }

                // 高位相等，比较低位
                if (I2R(this.low) > lowPart) {
                    return 1;
                } else if (I2R(this.low) < lowPart) {
                    return -1;
                }
                return 0;
            } else if (val <= -1000000000.0) {
                absVal = RAbsBJ(val);
                highPart = -R2I(absVal / 1000000000.0);
                lowPart = -ModuloReal(absVal, 1000000000.0);

                if (this.high > highPart) {
                    return 1;
                } else if (this.high < highPart) {
                    return -1;
                }

                if (I2R(this.low) > lowPart) {
                    return 1;
                } else if (I2R(this.low) < lowPart) {
                    return -1;
                }
                return 0;
            } else {
                // val 在 (-10亿, 10亿) 范围内
                if (this.high > 0) {
                    return 1;
                } else if (this.high < 0) {
                    return -1;
                }

                if (I2R(this.low) > val) {
                    return 1;
                } else if (I2R(this.low) < val) {
                    return -1;
                }
                return 0;
            }
        }

        method onDestroy() {
            this.low = 0;
            this.high = 0;
        }

        //==============================
        // 转字符串: 带号分隔
        // 例如: 123,456,789,012
        //==============================
        method toStringWithCommas() -> string {
            string result = "";
            integer currentLow = this.low;
            integer currentHigh = this.high;
            boolean isNegative = this.isNegative();
            string highStr = "";
            integer tempHigh;
            integer currentDigits;

            // 处理负数
            if (isNegative) {
                if (currentHigh < 0) currentHigh = -currentHigh;
                if (currentLow < 0) currentLow = -currentLow;
            }

            // 处理低位的后3位
            result = I2S(ModuloInteger(currentLow, 1000));
            // 补齐3位
            if (currentLow >= 1000) {
                if (ModuloInteger(currentLow, 1000) < 10) {
                    result = "00" + result;
                } else if (ModuloInteger(currentLow, 1000) < 100) {
                    result = "0" + result;
                }
            }

            // 处理低位的中间3位
            currentLow = currentLow / 1000;
            if (currentLow > 0) {
                result = I2S(ModuloInteger(currentLow, 1000)) + "," + result;
                // 补齐3位
                if (currentLow >= 1000) {
                    if (ModuloInteger(currentLow, 1000) < 10) {
                        result = "00" + result;
                    } else if (ModuloInteger(currentLow, 1000) < 100) {
                        result = "0" + result;
                    }
                }
            }

            // 处理低的前3位
            currentLow = currentLow / 1000;
            if (currentLow > 0) {
                result = I2S(currentLow) + "," + result;
            }

            // 处理高位部分（如果有）
            if (currentHigh > 0) {
                // 补齐低位到9位
                if (result != "") {
                    while (StringLength(result) < 11) { // 9位数字加2位逗号
                        result = "0" + result;
                    }
                    result = "," + result;
                }

                // 处理高位的每3位
                tempHigh = currentHigh;
                highStr = I2S(ModuloInteger(tempHigh, 1000));
                // 补齐末三位
                if (tempHigh >= 1000) {
                    if (ModuloInteger(tempHigh, 1000) < 10) {
                        highStr = "00" + highStr;
                    } else if (ModuloInteger(tempHigh, 1000) < 100) {
                        highStr = "0" + highStr;
                    }
                }
                tempHigh = tempHigh / 1000;

                // 如果还有更高位
                while (tempHigh > 0) {
                    currentDigits = ModuloInteger(tempHigh, 1000);
                    highStr = I2S(currentDigits) + "," + highStr;
                    // 补齐当前3位
                    if (tempHigh >= 1000) {
                        if (currentDigits < 10) {
                            highStr = "00" + highStr;
                        } else if (currentDigits < 100) {
                            highStr = "0" + highStr;
                        }
                    }
                    tempHigh = tempHigh / 1000;
                }

                result = highStr + result;
            }

            // 添加负号
            if (isNegative) {
                result = "-" + result;
            }

            return result;
        }

        //==============================
        // 转字符串: 带单位(万、亿、兆、京)
        // 例如: 123456789、1.2亿、3.4兆
        //==============================
        method toStringWithUnit() -> string {
            string result = "";
            integer currentHigh = this.high;
            integer currentLow = this.low;
            boolean isNegative = this.isNegative();
            real value = 0.0;
            real highPart = 0.0;
            real lowPart = 0.0;
            integer unitLevel = 0;  // 0=无单位, 1=万, 2=亿, 3=兆, 4=京
            string units = "";      // 单位字符串


            if (isNegative) {
                if (currentHigh < 0) currentHigh = -1* currentHigh;
                if (currentLow < 0) currentLow = -1* currentLow;
            }

            // 分别计算高位和低位部分
            highPart = I2R(currentHigh) * UNIT_TEN_YI;
            lowPart = I2R(currentLow);
            value = highPart + lowPart;


            // 1000万以下直接显示
            if (value < 10000000.0) {
                result = I2S(R2I(value));
            } else {
                // 循环除以10000直到小于10000
                while (value >= 10000.0) {
                    value = value / 10000.0;
                    unitLevel = unitLevel + 1;
                }

                // 根据unitLevel确定单位
                if (unitLevel == 1) units = "万";
                else if (unitLevel == 2) units = "亿";
                else if (unitLevel == 3) units = "兆";
                else if (unitLevel >= 4) units = "京";

                // 格式化数值并加上单位
                result = R2SW(value, 0, 1) + units;
            }


            if (isNegative) {
                result = "-" + result;
            }

            return result;
        }
    }
}


#undef UNIT_TEN_YI
#undef MAX_HIGH


//! endzinc
#endif
