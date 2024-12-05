#ifndef UnitSelectIncluded
#define UnitSelectIncluded

//! zinc
/*
单位选择事件(异步和同步均有)
*/
library UnitSelect requires hardware ,LBKKAPI{

    public struct unitSelect[] {

        static {
            unit args = null; //回调传参用(异步)
            unit argsSync = null; //回调传参用(同步)
            unit currentU []; //每个人当前选择的单位(同步)

            private {
                trigger trAsync;
                trigger trAsyncUn;
                trigger trSync;
                trigger trSyncUn;
                unit asyncU = null; //现在的选择单位-异步(每个人的引用不一样)
            }

        }

        // 异步时选中单位调用,在取消选择后面
        // 调用这个函数注册过程要同步,不能注册的时候异步
        method onAsync (code func) {
            TriggerAddCondition(trAsync, Condition(func));
        }

        // 异步时取消选择单位调用
        // 调用这个函数注册过程要同步,不能注册的时候异步
        method onAsyncUn (code func) {
            TriggerAddCondition(trAsyncUn, Condition(func));
        }

        // 同步时选中单位调用
        method onSync (code func) {
            TriggerAddCondition(trSync, Condition(func));
        }

        // 同步时取消选择单位调用
        method onSyncUn (code func) {
            TriggerAddCondition(trSyncUn, Condition(func));
        }

        //初始化
        static method onInit () {
            integer i;
            trigger tr = CreateTrigger(); //一次性用的选择事件

            trAsync = CreateTrigger();
            trAsyncUn = CreateTrigger();
            trSync  = CreateTrigger();
            trSyncUn  = CreateTrigger();

            //选单位的事件[同步]
            for (1 <= i <= MAX_PLAYER_COUNT) {TriggerRegisterPlayerSelectionEventBJ(tr, ConvertedPlayer(i), true);}
            TriggerAddCondition(tr, Condition(function (){
                //单位选择事件[同步]
                integer index = GetConvertedPlayerId(GetTriggerPlayer());
                if (GetTriggerUnit() != unitSelect.currentU[index]) {
                    unitSelect.argsSync = unitSelect.currentU[index];
                    TriggerEvaluate(trSyncUn); //事件里用unitSelect.argsSync来指代
                    unitSelect.argsSync = GetTriggerUnit();
                    TriggerEvaluate(trSync); //事件里用unitSelect.argsSync来指代
                    unitSelect.currentU[index] = GetTriggerUnit();
                    unitSelect.argsSync = null;
                }
            }));

            hardware.regUpdateEvent(function (){ //注册2个事件:选择单位,与不选择事件
                if (DzGetSelectedLeaderUnit() != unitSelect.asyncU) {
                    unitSelect.args = unitSelect.asyncU;
                    TriggerEvaluate(trAsyncUn); //事件里用unitSelect.args来指代
                    unitSelect.args = DzGetSelectedLeaderUnit();
                    TriggerEvaluate(trAsync); //事件里用unitSelect.args来指代
                    unitSelect.asyncU = DzGetSelectedLeaderUnit();
                    unitSelect.args = null;
                }
            });¸
        }
    }

}

//! endzinc
#endif
