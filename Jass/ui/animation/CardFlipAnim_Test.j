#ifndef UTCardFlipAnimIncluded
#define UTCardFlipAnimIncluded

// 用空地图测试
#undef OriginMapUnitTestMode

// 整组保持当前纵向位置。宽度统一在 CardFlipAnim.j 修改。
#define CARD_FLIP_TEST_OFFSET_Y 0.1

//! zinc
library UTCardFlipAnim requires CardFlipAnim {

    private integer callbackCount[];

    function CreateFlipTest(player p, integer count) {
        integer i;
        cardFlipHand hand;
        // 注册和 create 都必须全端调用，不能放在下面的本地分支里。
        // 经 SyncBus 延迟收包后在所有客户端执行，可在这里接同步奖励逻辑。
        cardFlipHand.onSelect(p, function() -> boolean {
            integer slot = cardFlipHand.getSelectSlot();
            integer pid = GetPlayerId(cardFlipHand.getSelectPlayer());
            callbackCount[pid] += 1;
            BJDebugMsg("[CardFlipAnim 收包回调] 玩家 " + I2S(pid + 1) + " 选中第 " + I2S(slot + 1) + " 张；累计回调 " + I2S(callbackCount[pid]) + " 次");
            return true;
        });
        hand = cardFlipHand.create(p, DzGetGameUI(), count, 0.0, CARD_FLIP_TEST_OFFSET_Y);
        if (GetLocalPlayer() == p && hand.isExist()) {
            for (0 <= i < count) {
                hand.setContent(i, "|cffffd84a祝福 " + I2S(i + 1) + "|r", "第 " + I2S(i + 1) + " 张牌|n|n抽卡展示测试");
            }
            hand.setContent(0, "|cffffd84a力量祝福|r", "力量 +100|n|n勇气化为力量|n|cff999999抽卡展示测试|r");
            hand.setContent(1, "|cffffd84a迅捷祝福|r", "敏捷 +100|n|n轻盈而迅捷|n|cff999999抽卡展示测试|r");
            hand.setContent(2, "|cffffd84a智慧祝福|r", "智力 +100|n|n灵感照亮前路|n|cff999999抽卡展示测试|r");
            hand.setContent(3, "|cffffd84a生命祝福|r", "生命 +1000|n|n生命充满活力|n|cff999999抽卡展示测试|r");
            hand.setContent(4, "|cffffd84a幸运祝福|r", "幸运 +10|n|n愿好运常伴|n|cff999999抽卡展示测试|r");
            BJDebugMsg("[CardFlipAnim] 已创建 " + I2S(count) + " 张牌；点击后同步收包触发回调。s1 / -flip X 可重置。");
        }
    }

    function onInit() {
        UnitTestRegisterChatEvent(function() {
            string command = GetEventPlayerChatString();
            integer count = 0;
            player p;
            if (command == "s1") {
                count = 5;
            } else if (SubString(command, 0, 6) == "-flip ") {
                count = S2I(SubString(command, 6, StringLength(command)));
                if (command != "-flip " + I2S(count)) {count = 0;}
            } else {return;}
            p = GetTriggerPlayer();
            if (count >= 1 && count <= CARD_FLIP_MAX_COUNT) {
                CreateFlipTest(p, count);
            } else if (GetLocalPlayer() == p) {
                BJDebugMsg("[CardFlipAnim] 用法：-flip X，X 为 1～" + I2S(CARD_FLIP_MAX_COUNT) + " 的整数");
            }
            p = null;
        });
    }
}
//! endzinc

#endif
