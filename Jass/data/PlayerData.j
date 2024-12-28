#ifndef PlayerDataIncluded
#define PlayerDataIncluded

#include "Crainax/config/SharedMethod.h"
//! zinc
/*
玩家的资源
*/
library PlayerData requires ObsBigNumber, ObsReal, ObsInteger {

    public struct playerData [] {

        string name; //玩家名字

        obsBigNumber gold;      //每个地图都有的金币
        obsInteger   goldRate;  //金币获取率,除100
        obsReal      goldNega;  //金币负获取率,实数形式,还是用 * (1 - 减少率)吧,用实数叠加法
        obsInteger   kill;      //每个地图都有的杀怪
        obsInteger   killRate;  //杀怪获取率,除100

        unit   H; //主英雄单位

        optional module allPlayerData; //每个地图专有的资源

        static method onInit () {
            //在游戏开始0.0秒后再调用
            trigger tr = CreateTrigger();
            TriggerRegisterTimerEventSingle(tr,0.0);
            TriggerAddCondition(tr,Condition(function (){
                integer i;
                for (1 <= i <= 12) {
                    playerData[i].name = GetPlayerName(ConvertedPlayer(i));
                }
                DestroyTrigger(GetTriggeringTrigger());
            }));
            tr = null;
        }

    }

}

//! endzinc
#endif
