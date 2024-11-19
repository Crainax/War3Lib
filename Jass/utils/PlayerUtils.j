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
library PlayUtils {

    //玩家数量
    public struct playerCount [] {
        static integer all = 0; //当前玩家总数(包括中途退出的)
        static integer online = 0; //当前活跃玩家总数
    }

    //获取第一个真实玩家
    //遍历所有玩家位置，返回第一个处于游戏中的真实玩家
    //返回值:
    //  player - 第一个真实玩家，如果没有则返回null
    public function FirstPlayer() -> player {
        integer i;
        for (1 <= i <= 12) {
            if ((GetPlayerSlotState(ConvertedPlayer(i)) == PLAYER_SLOT_STATE_PLAYING) &&
            (GetPlayerController(ConvertedPlayer(i)) == MAP_CONTROL_USER)) {
                return ConvertedPlayer(i);
            }
        }
        return null;
    }

    function onInit ()  {
        integer i;
        for (1 <= i <= 12) {
            if ((GetPlayerSlotState(ConvertedPlayer(i)) == PLAYER_SLOT_STATE_PLAYING) && (GetPlayerController(ConvertedPlayer(i)) == MAP_CONTROL_USER)) {
                playerCount.all    += 1;
                playerCount.online += 1;
            }
        }
    }
}

//! endzinc

#endif