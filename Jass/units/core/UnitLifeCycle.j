#ifndef UnitLifeCycleIncluded
#define UnitLifeCycleIncluded

//! zinc
/*
Unit生命周期管理器
负责管理Unit组件的创建和销毁事件
*/
library UnitLifeCycle {

    public struct unitLifeCycle [] {

        static unit argsUnit = null;
        private {
            static trigger trCreate = null;
            static trigger trDestroy = null;
        }

        // 注册销毁回调
        static method registerDestroy(code func) {
            TriggerAddCondition(trDestroy, Condition(func));
        }

        static method onDestroyCB(unit u) {
            argsUnit = u;
            TriggerEvaluate(trDestroy);
            //然后再清除所有哈希表
            FlushChildHashtable(HASH_UNIT,GetHandleId(u));
            argsUnit = null;
        }

        static method onInit () {
            trCreate = CreateTrigger();
            trDestroy = CreateTrigger();
        }

    }
}
//! endzinc

hook RemoveUnit unitLifeCycle.onDestroyCB

#endif
