#ifndef ObsBigNumberIncluded
#define ObsBigNumberIncluded

//! zinc
/*
观察者模式下的大数容器
*/

#define MAX_CALLBACKS 10
library ObsBigNumber requires BigNumber{
    // 定义回调函数类型
    type observerBN extends function(bigNumber);

    // 主要数据结构
    public struct obsBigNumber {
        private {
            bigNumber     value;    // 存储的数值
            observerBN    cbs[MAX_CALLBACKS];    // 回调函数数组,最多20个
            integer       cbCount;  // 回调函数计数
        }

        // 构造函数
        public static method create() -> thistype {
            thistype this = thistype.allocate();
            this.value = bigNumber.create();
            this.cbCount = 0;
            return this;
        }

        private method notify() -> nothing {
            integer i = 0;
            while (i < this.cbCount) {
                this.cbs[i].evaluate(this.value);
                i += 1;
            }
        }

        public method get() -> bigNumber {
            return this.value;
        }

        public method add(integer highPart, integer lowPart) {
            value.add(highPart, lowPart);
            notify();
        }

        public method addReal (real r)  {
            value.addReal(r);
            notify();
        }

        public method multiplyInteger (integer val) {
            value.multiplyInteger(val);
            notify();
        }

        public method multiplyReal (real val) {
            value.multiplyReal(val);
            notify();
        }

        // 添加回调函数
        public method addCallback(observerBN callback) -> boolean {
            // 检查是否达到上限
            if (this.cbCount >= MAX_CALLBACKS) {
                return false;
            }
            this.cbs[this.cbCount] = callback;
            this.cbCount += 1;
            return true;
        }

        // 可选：移除回调函数
        public method removeCallback(observerBN callback) {
            integer i = 0;
            integer j = 0;

            while (i < this.cbCount) {
                if (this.cbs[i] != callback) {
                    this.cbs[j] = this.cbs[i];
                    j += 1;
                }
                i += 1;
            }
            this.cbCount = j;
        }

        method onDestroy () {
            integer i = 0;
            // 清理回调数组
            while (i < this.cbCount) {
                this.cbs[i] = 0;
                i += 1;
            }
            if (this.value.isExist()) {
                this.value.destroy();
            }
            this.value = 0;
            this.cbCount = 0;
        }
    }

}

#undef MAX_CALLBACKS

//! endzinc
#endif
