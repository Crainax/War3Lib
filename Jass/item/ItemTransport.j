#ifndef ItemTransportIncluded
#define ItemTransportIncluded

//! zinc
/*
====================================
物品双击传送功能模块 (ItemTransport)
====================================

功能描述：
监听单位的物品栏双击事件，当玩家双击装备物品时触发自定义回调处理

核心机制：
- 监听 EVENT_UNIT_ISSUED_TARGET_ORDER 事件
- 检测订单 ID 范围 852002-852007（对应物品栏位置 1-6）
- 使用定时器延迟处理，避免事件冲突
- 提供回调机制，允许外部注册处理逻辑

====================================
API 接口文档
====================================

1. 注册单位事件
itemTransport.registerEvent(unit u)
描述：为指定单位注册物品双击监听事件
参数：u - 需要监听的单位
用法：itemTransport.registerEvent(GetTriggerUnit());

2. 注册回调处理
itemTransport.registerCallBack(code func)
描述：注册物品双击时的回调处理函数
参数：func - 回调函数代码
用法：itemTransport.registerCallBack(function YourCallbackFunction);

3. 获取回调参数（仅在回调函数内使用）
itemTransport.getCallbackUnit() -> unit
描述：获取触发双击事件的单位
返回：触发事件的单位

itemTransport.getCallbackPosition() -> integer
描述：获取被双击物品在物品栏中的位置
返回：位置索引（1-6）

itemTransport.getCallbackItem() -> item
描述：获取被双击的物品
返回：物品句柄

====================================
使用示例
====================================

// 1. 为英雄注册双击事件
itemTransport.registerEvent(hero);

// 2. 注册回调处理
itemTransport.registerCallBack(function (){
    unit u = itemTransport.getCallbackUnit();
    integer pos = itemTransport.getCallbackPosition();
    item it = itemTransport.getCallbackItem();

    BJDebugMsg("单位 " + GetUnitName(u) + " 双击了位置 " + I2S(pos) + " 的物品");

    // 你的处理逻辑...

    u = null;
    it = null;

});

====================================
技术实现细节
====================================

- 使用静态成员变量传递回调参数，避免哈希表键冲突
- 回调参数在执行完毕后自动清理（置 null/0）
- 定时器资源管理：创建->使用->暂停->销毁->置null
- 句柄泄漏防护：所有句柄类型变量在使用完毕后置 null

*/
library ItemTransport {

    public struct itemTransport [] {

        private static trigger trMain   = null;  //右键事件
        private static trigger callback = null;  //回调触发器
        private static unit    uArgs    = null;  //回调参数
        private static integer posArgs  = 0;     //回调参数
        private static item    itArgs   = null;  //回调参数

        //操作物品的接口
        public static method registerEvent (unit u) {
            if (trMain == null) {
                trMain = CreateTrigger();
                TriggerAddCondition(trMain, Condition(function () { //双击装备后  宠物<->英雄间移动
                    integer i;
                    integer pos = 0;
                    timer t;
                    if (GetIssuedOrderId() >= 852002 && GetIssuedOrderId() <= 852007) {
                        for (1 <= i <= 6) {
                            if (UnitItemInSlotBJ(GetTriggerUnit(),i) == GetOrderTargetItem()) {
                                pos = i;
                                break;
                            }
                        }
                        if (pos > 0) {
                            t = CreateTimer();
                            SaveInteger(HASH_TIMER,GetHandleId(t),1,pos);
                            SaveItemHandle(HASH_TIMER,GetHandleId(t),2,GetOrderTargetItem());
                            SaveUnitHandle(HASH_TIMER,GetHandleId(t),3,GetTriggerUnit());
                            TimerStart(t,0.0,false,function (){
                                timer t = GetExpiredTimer();
                                integer id = GetHandleId(t);
                                integer pos = LoadInteger(HASH_TIMER,id,1);
                                item it = LoadItemHandle(HASH_TIMER,id,2);
                                unit u = LoadUnitHandle(HASH_TIMER,id,3);

                                if (UnitItemInSlotBJ(u,pos) == it) {
                                    //触发回调
                                    if (callback != null) {
                                        uArgs = u; //回调参数
                                        posArgs = pos; //回调参数
                                        itArgs = it; //回调参数
                                        TriggerEvaluate(callback);
                                        uArgs = null;
                                        posArgs = 0;
                                        itArgs = null;
                                    }
                                }

                                PauseTimer(t);
                                FlushChildHashtable(HASH_TIMER,id);
                                DestroyTimer(t);
                                u = null;
                                it = null;
                                t = null;
                            });
                            t = null;
                        }
                    }
                }));
            }

            TriggerRegisterUnitEvent(trMain,u,EVENT_UNIT_ISSUED_TARGET_ORDER);
        }

        //触发右键双击事件
        static method registerCallBack(code func) {
            if (callback == null) {
                callback = CreateTrigger();
            }
            TriggerAddCondition(callback, Condition(func));
        }
        //触发的单位
        static method getCallbackUnit () -> unit { return uArgs;}
        //触发的位置
        static method getCallbackPosition () -> integer { return posArgs;}
        //触发的物品
        static method getCallbackItem () -> item { return itArgs;}

    }
}

//! endzinc
#endif
