#ifndef ObsRealIncluded
#define ObsRealIncluded

//! zinc
/*
观察者模式下的浮点数容器
*/

#include "Crainax/config/SharedMethod.h" // 结构体共用方法

library ObsReal {

    // 主要数据结构
    public struct obsReal {

        static thistype ethis = 0; // 当前正在运行的实例引用
        private {
            real        value;    // 存储的数值
            trigger     callback; // 回调函数
        }

        STRUCT_SHARED_METHODS(obsReal)
        module innerHT; // 内部哈希表

        // 构造函数
        public static method create() -> thistype {
            thistype this = thistype.allocate();
            this.value = 0.0;
            this.callback = CreateTrigger();
            return this;
        }

        private method notify() {
            integer i = 0;
            thistype.ethis = this;
            TriggerEvaluate(this.callback);
        }

        public method get() -> real {
            return this.value;
        }

        public method add(real val) {
            if (!this.isExist()) {return;}
            this.value += val;
            notify();
        }

        public method setValue(real val) {
            if (!this.isExist()) {return;}
            this.value = val;
            notify();
        }

        // 添加回调函数
        public method addCallback(code func) -> triggercondition {
            if (!this.isExist()) {return null;}
            return TriggerAddCondition(this.callback, Condition(func));
        }

        method onDestroy () {
            if (!this.isExist()) {return;}
            if (this.callback != null) { DestroyTrigger(this.callback); }
            this.value = 0.0;
            this.callback = null;
        }

    }

}

#undef MAX_CALLBACKS

//! endzinc
#endif
