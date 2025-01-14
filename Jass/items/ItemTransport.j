#ifndef ItemTransportIncluded
#define ItemTransportIncluded

//! zinc
/*
物品右键双击单位传送
*/
library ItemTransport {

    function onInit ()  {
        trigger TrDbClick = CreateTrigger();
        TriggerAddCondition(TrDbClick, Condition(function () { //双击装备后  宠物<->英雄间移动
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
                        integer index = GetConvertedPlayerId(GetOwningPlayer(u));
                        if (UnitItemInSlotBJ(u,pos) == it) {
                            if (u == UPet[index]) { //宠物里双击
                                TranPet(u,it,UIOrigin[pos]);
                            } else if (u == H[index]) { //英雄里双击
                                if (UnitAddItem(UPet[index],it)) NewHintUI(GetOwningPlayer(u),UIOrigin[pos],"|cff00ff77成功转移到宠物!|r",0.03);
                                else NewHintUI(GetOwningPlayer(u),UIOrigin[pos],"|cffff0000转移失败,宠物背包已满.|r",0.03);
                            }
                        }
                        FlashIcon(u); //刷新一下当前流光
                        mainhero.uiBagFlash();  //刷新一下当前背包容量
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
}

//! endzinc
#endif
