#ifndef UnitLifeCycleIncluded
#define UnitLifeCycleIncluded

//! zinc
/*
Unit生命周期管理器
负责管理Unit组件的创建和销毁事件
*/
library UnitLifeCycle {

    public struct unitLifeCycle [] {

        static unit agrsUnit     = null;
        private {
            static trigger trCreate = null;
            static trigger trDestroy = null;
        }

        // 注册创建回调
        static method registerCreate(code func) {
            TriggerAddCondition(trCreate, Condition(func));
        }

        // 注册销毁回调
        static method registerDestroy(code func) {
            TriggerAddCondition(trDestroy, Condition(func));
        }

        static method onCreateCB(unit u,integer typeID,integer frame) {
            agrsUnit = u;
            TriggerEvaluate(trCreate);
        }

        static method onDestroyCB(unit u,integer typeID,integer frame) {
            agrsUnit = u;
            TriggerEvaluate(trDestroy);
        }

        static method onInit () {
            trCreate = CreateTrigger();
            trDestroy = CreateTrigger();
        }

    }
}
//! endzinc

/*
VJ实现Hook
*/
library UnitLCHook

    function NewCreateUnit takes player id, integer unitid, real x, real y, real face returns unit
        // 在原函数执行前的代码
        call BJDebugMsg("NewCreateUnit") //在创建前
        call BJDebugMsg(R2S(bj_PI))
        return null
    endfunction

    function NewRemoveUnit takes unit u returns nothing
        // 在原函数执行前的代码
        call BJDebugMsg("NewRemoveUnit")

    endfunction

    function NewRemoveUnit2 takes unit u returns nothing
        // 在原函数执行前的代码
        call BJDebugMsg("NewRemoveUnit2")

    endfunction


endlibrary

hook CreateUnit NewCreateUnit
hook RemoveUnit NewRemoveUnit
hook RemoveUnit NewRemoveUnit2

#endif
