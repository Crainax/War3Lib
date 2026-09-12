//===========================================================================
//
// War3Lib 玩家核心库
//
// Crainax
// 日期：2024-11-19
//
// 该库提供了玩家操作的基础功能
// 包括玩家获取、玩家状态检查等核心功能
//
//===========================================================================

#ifndef PlayerCoreIncluded
#define PlayerCoreIncluded

//! zinc
library PlayerUtils {

    private boolean playerCounted[];

    //玩家数量
    public struct playerCount [] {
        static integer all = 0; //当前玩家总数(包括中途退出的)
        static integer online = 0; //当前活跃玩家总数
    }

    // 是否为地图配置范围内的有效玩家
    public function IsValidPlayer(player p) -> boolean {
        integer index;
        if (p == null) {
            return false;
        }
        index = GetConvertedPlayerId(p);
        return index >= 1 && index <= MAX_PLAYER_COUNT;
    }

    // 是否为当前仍在游戏中的用户玩家
    public function IsOnlineUser(player p) -> boolean {
        return IsValidPlayer(p)
        && GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING
        && GetPlayerController(p) == MAP_CONTROL_USER;
    }

    //获取第一个真实玩家
    //遍历所有玩家位置，返回第一个处于游戏中的真实玩家
    //返回值:
    //  player - 第一个真实玩家，如果没有则返回null
    public function GetFirstPlayer() -> player {
        integer i;
        for (1 <= i <= 12) {
            if (IsOnlineUser(ConvertedPlayer(i))) {
                return ConvertedPlayer(i);
            }
        }
        return null;
    }

    function onInit ()  {
        trigger tr;
        integer i;
        for (1 <= i <= 12) {
            if (IsOnlineUser(ConvertedPlayer(i))) {
                playerCount.all    += 1;
                playerCount.online += 1;
                playerCounted[i] = true;
            }
        }

        tr = CreateTrigger();
        for (1 <= i <= 12) {
            TriggerRegisterPlayerEventLeave(tr, ConvertedPlayer(i));
        }
        TriggerAddCondition(tr, Condition(function () -> boolean {
            integer index = GetConvertedPlayerId(GetTriggerPlayer());
            if (index >= 1 && index <= 12 && playerCounted[index]) {
                playerCounted[index] = false;
                playerCount.online = IMaxBJ(playerCount.online - 1, 1);
            }
            return false;
        }));
        tr = null;
    }
}

//! endzinc

#endif

