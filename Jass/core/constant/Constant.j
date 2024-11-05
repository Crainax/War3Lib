#ifndef ConstantIncluded
#define ConstantIncluded

/*
常用常量
*/

#define GetVersion() "0.0.1"

//玩家总数
#define MAX_PLAYER_COUNT 4

//! zinc
library Constant  {

    public integer playerCount = 0; //从游戏开始的玩家人数
    public integer renshu = 0; //动态游戏人数

    function onInit ()  {
        integer i;
        for (1 <= i <= MAX_PLAYER_COUNT) {
            if ((GetPlayerSlotState(ConvertedPlayer(i)) == PLAYER_SLOT_STATE_PLAYING) && (GetPlayerController(ConvertedPlayer(i)) == MAP_CONTROL_USER)) {
                playerCount += 1;
                renshu      += 1;
            }
        }
    }
}

//! endzinc
#endif

