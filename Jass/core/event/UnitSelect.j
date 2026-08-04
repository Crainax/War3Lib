#ifndef UnitSelectIncluded
#define UnitSelectIncluded

//! zinc
/*
本地单位选择观察器（仅用于 UI 与本地交互）
*/
library UnitSelect requires Hardware ,LBKKAPI{

    public struct unitSelect[] {

            static unit args = null;      //回调传参用(各客户端本地值)

            private {
                static trigger trAsync = null;
                static trigger trAsyncUn = null;
                static unit asyncU = null; //现在的选择单位-异步(每个人的引用不一样)
            }


        // 异步时选中单位调用,在取消选择后面
        // 调用这个函数注册过程要同步,不能注册的时候异步
        static method onAsync (code func) {
            TriggerAddCondition(trAsync, Condition(func));
        }

        // 异步时取消选择单位调用
        // 调用这个函数注册过程要同步,不能注册的时候异步
        static method onAsyncUn (code func) {
            TriggerAddCondition(trAsyncUn, Condition(func));
        }

        //初始化
        static method onInit () {
            trAsync = CreateTrigger();
            trAsyncUn = CreateTrigger();

            hardware.regUpdateEvent(function (){ //注册2个事件:选择单位,与不选择事件
                if (DzGetSelectedLeaderUnit() != unitSelect.asyncU) {
                    unitSelect.args = unitSelect.asyncU;
                    TriggerEvaluate(trAsyncUn); //事件里用unitSelect.args来指代
                    unitSelect.args = DzGetSelectedLeaderUnit();
                    TriggerEvaluate(trAsync); //事件里用unitSelect.args来指代
                    unitSelect.asyncU = DzGetSelectedLeaderUnit();
                    unitSelect.args = null;
                }
            });
        }
    }

}

//! endzinc
#endif
