#ifndef RandSetIncluded
#define RandSetIncluded

//! zinc
/*
randSet - 生成不重复随机数的静态工具
主要用于:
- 随机抽取不重复的物品/单位
- 生成随机但不重复的位置
- 需要按随机顺序遍历1-N的场景

用法示例:
randSet.sequence(5)     // 生成1-5的序列
randSet.next()          // 随机取出一个数字
randSet.clear()         // 用完记得清理
*/

library RandSet {

    public struct randSet [] {
        private static integer values [];
        private static integer length = 0;

        // 清理数据
        static method clear() {
            integer i = 0;
            for (0 <= i < length) {
                values[i] = 0;
            }
            length = 0;
        }

        // 添加一个数字
        static method add(integer value) {
            values[length] = value;
            length += 1;
        }

        // 生成1到n的序列
        static method sequence(integer n) {
            integer i = 0;
            if (n <= 0) {
                BJDebugMsg("error: randSet.sequence - n must be positive");
                return;
            }
            for (0 <= i < n) {
                values[i] = i + 1;
            }
            length = n;
        }

        // 随机取出一个数字(会从集合中移除)
        static method next() -> integer {
            integer rand;
            integer result;

            if (length <= 0) {
                return 0;
            }

            rand = GetRandomInt(0, length - 1);
            result = values[rand];

            // 用最后一个元素填补空缺
            values[rand] = values[length - 1];
            values[length - 1] = 0;
            length -= 1;

            return result;
        }

        // 随机返回一个数字(不会移除)
        static method peek() -> integer {
            if (length <= 0) {
                return 0;
            }
            return values[GetRandomInt(0, length - 1)];
        }

        // 打乱序列
        static method shuffle() {
            integer i = 0;
            integer j;
            integer temp;

            for (0 <= i < length) {
                j = GetRandomInt(0, length - 1);
                temp = values[i];
                values[i] = values[j];
                values[j] = temp;
            }
        }

        // 是否为空
        static method isEmpty() -> boolean {
            return length == 0;
        }

        // 当前长度
        static method size() -> integer {
            return length;
        }

        // 调试用:显示当前所有数字
        static method toString() -> string {
            string s = "";
            integer i = 0;
            for (0 <= i < length) {
                s += I2S(values[i]) + " ";
            }
            return s;
        }
    }

}

//! endzinc
#endif
