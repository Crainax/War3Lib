#ifndef UTCardFlipAnimIncluded
#define UTCardFlipAnimIncluded

// 用空地图测试
#undef OriginMapUnitTestMode

//! zinc
library UTCardFlipAnim requires CardFlipAnim {

    function onInit() {
        UnitTestRegisterChatEvent(function() {
            string command = GetEventPlayerChatString();
            player p;
            growdata gd;

            if (command != "s1") {return;}
            p = GetTriggerPlayer();
            gd = growdata[SEQ_CARD_FLIP_C];
            assert.Integer(gd.max, 23, "CardFlipAnim 末帧编号");
            assert.Integer(gd.gap, 1, "CardFlipAnim 播放间隔");
            cardFlipAnim.play(p, DzGetGameUI(), gd, 0.09, 0.18, 0.0, 0.0, 75);
            if (GetLocalPlayer() == p) {
                BJDebugMsg("[CardFlipAnim] s1: 中央播放翻卡，末帧停留 1.5 秒");
            }
            p = null;
        });
    }
}
//! endzinc

#endif
