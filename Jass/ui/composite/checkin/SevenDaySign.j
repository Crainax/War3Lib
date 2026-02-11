#ifndef SevenDaySignIncluded
#define SevenDaySignIncluded

#include "Crainax/config/SharedMethod.h"       // 结构体共用方法、I3 等工具
#include "Crainax/ui/constants/UIConstants.j"  // UI 常量
#include "Crainax/data/audio/MusicConstant.j"  // 音效常量

//! zinc
/*
七天签到领奖励 UI（一次性7天）
UI 仅负责展示与本地事件，领奖逻辑通过 SyncBus 进入同步层。
*/

#define SIGN7_TOTAL_DAYS        7
#define SIGN7_ALL_MASK          127
#define SIGN7_SYNC_CHANNEL      "SevenDaySign"
#define SIGN7_LAST_DAYID_KEY    "SIGN7_LAST_DAYID"
#define SIGN7_CLAIM_MASK_KEY    "SIGN7_CLAIM_MASK"

#define SIGN7_MAIN_WIDTH        0.62
#define SIGN7_MAIN_HEIGHT       0.36

#define SIGN7_SLOT_SIZE         0.07
#define SIGN7_SLOT_GAP_X        0.01
#define SIGN7_SLOT_OFFSET_Y     0.07

#define SIGN7_ICON_SIZE         0.05
#define SIGN7_NAME_FONT         3

#define SIGN7_BTN_WIDTH         0.16
#define SIGN7_BTN_HEIGHT        0.035
#define SIGN7_BTN_OFFSET_Y      -0.135

#define SIGN7_STATUS_OFFSET_Y   -0.095

#define SIGN7_MASK_ALPHA        160
#define SIGN7_CHECK_SIZE        0.03

//# dependency:resource/ui/image/select_flash.blp
//# dependency:resource/ui/image/black.blp
//# dependency:resource/ui/image/select_close.blp

library SevenDaySign requires Tooltip,Music,SyncBus,UIExtendEvent,UIExtendDrag,Server {

    //==========================================================================
    // 数据层：存档 + 配置
    //==========================================================================
    public struct sevenDaySignData [] {
        private static integer claimMask[];    // 领取位图（1..7）
        private static integer lastDayId[];    // 上次领取日期（按北京时间 dayId）

        private static string rewardIcon[];
        private static string rewardName[];
        private static string rewardTipTitle[];
        private static string rewardTipDesc[];

        private static trigger claimTr = null;
        private static player  claimPlayer = null;
        private static integer claimDay = 0;

        // 获取北京时间 dayId（UTC+8）
        public static method getBeijingDayId() -> integer {
            integer t;
            t = thistype.getTimeNow();
            return (t + 28800) / 86400;
        }

        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
            private static integer testNow = 0;
            public static method setTestNow(integer t) { testNow = t; }
            public static method getTimeNow() -> integer { return testNow; }
        #else
            public static method getTimeNow() -> integer { return DzAPI_Map_GetGameStartTime(); }
        #endif

        private static method getBit(integer day) -> integer {
            return R2I(Pow(2, day - 1));
        }

        public static method isClaimed(integer mask, integer day) -> boolean {
            integer bit;
            bit = thistype.getBit(day);
            return ModuloInteger(mask, bit * 2) >= bit;
        }

        public static method getNextClaimDay(integer mask) -> integer {
            integer i;
            for (1 <= i <= SIGN7_TOTAL_DAYS) {
                if (!thistype.isClaimed(mask, i)) {
                    return i;
                }
            }
            return 0;
        }

        public static method isAllClaimed(integer mask) -> boolean {
            return thistype.getNextClaimDay(mask) == 0;
        }

        public static method getMask(player p) -> integer {
            integer pid;
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return 0; }
            return claimMask[pid];
        }

        public static method getLastDayId(player p) -> integer {
            integer pid;
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return 0; }
            return lastDayId[pid];
        }

        public static method refreshPlayer(player p) {
            integer pid;
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return; }
            claimMask[pid] = server.loadInteger(p, SIGN7_CLAIM_MASK_KEY);
            lastDayId[pid] = server.loadInteger(p, SIGN7_LAST_DAYID_KEY);
        }

        public static method registerClaimCallback(code func) {
            if (claimTr == null) {
                claimTr = CreateTrigger();
            }
            TriggerAddCondition(claimTr, Condition(func));
        }

        public static method getClaimPlayer() -> player {
            return claimPlayer;
        }

        public static method getClaimDay() -> integer {
            return claimDay;
        }

        public static method setReward(integer day, string iconPath, string name, string tipTitle, string tipDesc) {
            if (day < 1 || day > SIGN7_TOTAL_DAYS) { return; }
            rewardIcon[day] = iconPath;
            rewardName[day] = name;
            rewardTipTitle[day] = tipTitle;
            rewardTipDesc[day] = tipDesc;
        }

        public static method getRewardIcon(integer day) -> string {
            if (day < 1 || day > SIGN7_TOTAL_DAYS) { return ""; }
            return rewardIcon[day];
        }

        public static method getRewardName(integer day) -> string {
            if (day < 1 || day > SIGN7_TOTAL_DAYS) { return ""; }
            return rewardName[day];
        }

        public static method getRewardTipTitle(integer day) -> string {
            if (day < 1 || day > SIGN7_TOTAL_DAYS) { return ""; }
            return rewardTipTitle[day];
        }

        public static method getRewardTipDesc(integer day) -> string {
            if (day < 1 || day > SIGN7_TOTAL_DAYS) { return ""; }
            return rewardTipDesc[day];
        }

        // 可否领取（每日一次）
        public static method canClaim(player p) -> boolean {
            integer mask;
            integer lastId;
            integer nowId;
            mask = thistype.getMask(p);
            if (thistype.isAllClaimed(mask)) { return false; }
            lastId = thistype.getLastDayId(p);
            nowId = thistype.getBeijingDayId();
            return nowId > lastId;
        }

        // 同步层：处理领取
        public static method handleClaim(player p) -> boolean {
            integer pid;
            integer mask;
            integer lastId;
            integer nowId;
            integer nextDay;
            integer bit;

            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return false; }

            mask = claimMask[pid];
            lastId = lastDayId[pid];
            nowId = thistype.getBeijingDayId();

            if (thistype.isAllClaimed(mask)) { return false; }
            if (nowId <= lastId) { return false; }

            nextDay = thistype.getNextClaimDay(mask);
            if (nextDay <= 0) { return false; }

            bit = thistype.getBit(nextDay);
            mask = mask + bit;
            claimMask[pid] = mask;
            lastDayId[pid] = nowId;

            server.saveInteger(p, SIGN7_CLAIM_MASK_KEY, mask);
            server.saveInteger(p, SIGN7_LAST_DAYID_KEY, nowId);

            // 回调传参
            claimPlayer = p;
            claimDay = nextDay;
            if (claimTr != null) {
                TriggerEvaluate(claimTr);
            }
            claimPlayer = null;
            claimDay = 0;
            return true;
        }

        private static method initDefaultRewards() {
            integer i;
            for (1 <= i <= SIGN7_TOTAL_DAYS) {
                rewardIcon[i] = "ui\\image\\select_flash.blp";
                rewardName[i] = "第" + I2S(i) + "天奖励";
                rewardTipTitle[i] = "奖励说明";
                rewardTipDesc[i] = "这是占位奖励内容";
            }
        }

        static method onInit() {
            integer i;

            server.init(SERVER_TYPE_INTEGER, SIGN7_LAST_DAYID_KEY);
            server.init(SERVER_TYPE_INTEGER, SIGN7_CLAIM_MASK_KEY);

            thistype.initDefaultRewards();

            // 初始化缓存（server ready 前读取一次）
            for (1 <= i <= MAX_PLAYER_COUNT) {
                thistype.refreshPlayer(ConvertedPlayer(i));
            }

            server.onReady(function() {
                integer j;
                for (1 <= j <= MAX_PLAYER_COUNT) {
                    thistype.refreshPlayer(ConvertedPlayer(j));
                }
            });
        }
    }

    //==========================================================================
    // UI 层：展示 + 本地事件
    //==========================================================================
    public struct sevenDaySignUI [] {
        private static uiImage uiMain = 0;
        private static uiBtn   uiMainButton = 0;
        private static uiImage uiCloseImage = 0;
        private static uiBtn   uiCloseButton = 0;

        private static uiImage slotFrame[SIGN7_TOTAL_DAYS];
        private static uiBtn   slotBtn[SIGN7_TOTAL_DAYS];
        private static uiImage slotIcon[SIGN7_TOTAL_DAYS];
        private static uiText  slotName[SIGN7_TOTAL_DAYS];
        private static uiImage slotMask[SIGN7_TOTAL_DAYS];
        private static uiImage slotCheck[SIGN7_TOTAL_DAYS];

        private static uiText  statusText = 0;
        private static uiImage btnImage = 0;
        private static uiBtn   btnClaim = 0;
        private static uiText  btnText = 0;

        private static tooltip uiTooltipTemp = 0;

        private static player owner = null;
        private static boolean isOpen = false;

        private static method destroyTooltip() {
            if (uiTooltipTemp != 0 && uiTooltipTemp.isExist()) {
                uiTooltipTemp.destroy();
            }
            uiTooltipTemp = 0;
        }

        private static method refreshSlots(player p) {
            integer i;
            integer mask;
            boolean claimed;
            mask = sevenDaySignData.getMask(p);

            for (1 <= i <= SIGN7_TOTAL_DAYS) {
                claimed = sevenDaySignData.isClaimed(mask, i);
                if (slotMask[i] != 0) { slotMask[i].show(claimed); }
                if (slotCheck[i] != 0) { slotCheck[i].show(claimed); }
            }
        }

        private static method refreshStatus(player p) {
            integer mask;
            integer lastId;
            integer nowId;

            if (statusText == 0) { return; }

            mask = sevenDaySignData.getMask(p);
            if (sevenDaySignData.isAllClaimed(mask)) {
                statusText.setText("|cffffcc00已完成|r");
                return;
            }

            lastId = sevenDaySignData.getLastDayId(p);
            nowId = sevenDaySignData.getBeijingDayId();

            if (nowId <= lastId) {
                statusText.setText("|cffaaaaaa今日已领取|r");
            } else {
                statusText.setText("|cff00ff00今日可领取|r");
            }
        }

        private static method refreshButton(player p) {
            boolean canClaim;
            canClaim = sevenDaySignData.canClaim(p);

            if (btnImage != 0) {
                btnImage.setAlpha(I3(canClaim, 255, 160));
            }
            if (btnText != 0) {
                if (canClaim) {
                    btnText.setText("|cffffcc00领取奖励|r");
                } else {
                    btnText.setText("|cff999999领取奖励|r");
                }
            }
        }

        public static method refreshForPlayer(player p) {
            if (!isOpen) { return; }
            if (GetLocalPlayer() != p) { return; }
            sevenDaySignData.refreshPlayer(p);
            refreshSlots(p);
            refreshStatus(p);
            refreshButton(p);
        }

        public static method show(player p) {
            integer i;
            real startX;
            real offsetX;
            real offsetY;
            string iconPath;
            string name;

            if (GetLocalPlayer() != p) { return; }
            if (isOpen) { return; }

            isOpen = true;
            owner = p;

            uiMain = uiImage.create(DzGetGameUI())
                .setTexture("ui\\image\\black.blp")
                .exReSize(SIGN7_MAIN_WIDTH, SIGN7_MAIN_HEIGHT)
                .exRePoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0);

            uiMainButton = uiBtn.createBlank(uiMain.ui)
                .setAllPoint(uiMain.ui)
                .enableDrag(uiMain.ui, 0.2, 0.8, 0.2, 0.8)
                .setDragPosition(0.4, 0.25);

            uiCloseImage = uiImage.create(uiMain.ui)
                .exReSize(0.026, 0.026)
                .setTexture("ui\\image\\select_close.blp")
                .exRePoint(ANCHOR_TOPRIGHT, uiMain.ui, ANCHOR_TOPRIGHT, -0.003, -0.003);

            uiCloseButton = uiBtn.create(uiCloseImage.ui)
                .setAllPoint(uiCloseImage.ui)
                .onEnter(function() {
                    destroyTooltip();
                    uiTooltipTemp = tooltip.create().layoutTitle("关闭界面");
                    uiTooltipTemp.setPoint(ANCHOR_BOTTOM, uiCloseImage.ui, ANCHOR_TOP, 0, 0.01);
                    music[MUSIC_INDEX_BTN_OVER_1].play();
                })
                .onLeave(function() {
                    destroyTooltip();
                })
                .onClick(function() {
                    music[MUSIC_INDEX_BTN_CLICK].play();
                    if (owner != null) {
                        sevenDaySignUI.hide(owner);
                    } else {
                        sevenDaySignUI.hide(GetLocalPlayer());
                    }
                });

            // slots
            startX = 0.0 - (SIGN7_TOTAL_DAYS - 1) * (SIGN7_SLOT_SIZE + SIGN7_SLOT_GAP_X) / 2.0;
            offsetY = SIGN7_SLOT_OFFSET_Y;

            for (1 <= i <= SIGN7_TOTAL_DAYS) {
                offsetX = startX + (i - 1) * (SIGN7_SLOT_SIZE + SIGN7_SLOT_GAP_X);

                slotFrame[i] = uiImage.create(uiMain.ui)
                    .exReSize(SIGN7_SLOT_SIZE, SIGN7_SLOT_SIZE)
                    .setTexture("ui\\image\\select_flash.blp")
                    .exRePoint(ANCHOR_CENTER, uiMain.ui, ANCHOR_CENTER, offsetX, offsetY);

                iconPath = sevenDaySignData.getRewardIcon(i);
                name = sevenDaySignData.getRewardName(i);

                slotIcon[i] = uiImage.create(slotFrame[i].ui)
                    .exReSize(SIGN7_ICON_SIZE, SIGN7_ICON_SIZE)
                    .setTexture(iconPath)
                    .exRePoint(ANCHOR_CENTER, slotFrame[i].ui, ANCHOR_CENTER, 0.0, 0.0);

                slotName[i] = uiText.create(uiMain.ui)
                    .setFontSize(SIGN7_NAME_FONT)
                    .setAlign(4)
                    .setText(name)
                    .exRePoint(ANCHOR_TOP, slotFrame[i].ui, ANCHOR_BOTTOM, 0.0, -0.004);

                slotMask[i] = uiImage.create(slotFrame[i].ui)
                    .setTexture("ui\\image\\black.blp")
                    .setAllPoint(slotFrame[i].ui)
                    .setAlpha(SIGN7_MASK_ALPHA)
                    .show(false);

                slotCheck[i] = uiImage.create(slotFrame[i].ui)
                    .exReSize(SIGN7_CHECK_SIZE, SIGN7_CHECK_SIZE)
                    .setTexture("ui\\image\\select_flash.blp")
                    .exRePoint(ANCHOR_CENTER, slotFrame[i].ui, ANCHOR_CENTER, 0.0, 0.0)
                    .show(false);

                // Tooltip events
                slotBtn[i] = uiBtn.createBlank(slotFrame[i].ui)
                    .setAllPoint(slotFrame[i].ui)
                    .spEnter(function(integer frame) {
                        integer day;
                        string title;
                        string desc;
                        day = uiHashTable(frame).eventdata.get();
                        destroyTooltip();
                        title = sevenDaySignData.getRewardTipTitle(day);
                        desc = sevenDaySignData.getRewardTipDesc(day);
                        uiTooltipTemp = tooltip.create().layoutTitleDesc(title, desc);
                        uiTooltipTemp.setPoint(ANCHOR_BOTTOM, frame, ANCHOR_TOP, 0, 0.01);
                        music[MUSIC_INDEX_BTN_OVER_1].play();
                    })
                    .spLeave(function(integer frame) {
                        destroyTooltip();
                    });

                uiHashTable(slotBtn[i].ui).eventdata.bind(i);
            }

            statusText = uiText.create(uiMain.ui)
                .setFontSize(5)
                .setAlign(4)
                .setText("")
                .exRePoint(ANCHOR_CENTER, uiMain.ui, ANCHOR_CENTER, 0.0, SIGN7_STATUS_OFFSET_Y);

            btnImage = uiImage.create(uiMain.ui)
                .exReSize(SIGN7_BTN_WIDTH, SIGN7_BTN_HEIGHT)
                .setTexture("ui\\image\\select_flash.blp")
                .exRePoint(ANCHOR_CENTER, uiMain.ui, ANCHOR_CENTER, 0.0, SIGN7_BTN_OFFSET_Y);

            btnText = uiText.create(btnImage.ui)
                .setFontSize(5)
                .setAlign(4)
                .setText("|cffffcc00领取奖励|r")
                .setAllPoint(btnImage.ui);

            btnClaim = uiBtn.create(btnImage.ui)
                .setAllPoint(btnImage.ui)
                .onClick(function() {
                    player lp;
                    lp = GetLocalPlayer();
                    if (sevenDaySignData.canClaim(lp)) {
                        syncBus.DzSyncDataEx(SIGN7_SYNC_CHANNEL, "C");
                        music[MUSIC_INDEX_BTN_CLICK].play();
                    } else {
                        music[MUSIC_INDEX_ERROR].play();
                    }
                    lp = null;
                });

            sevenDaySignUI.refreshForPlayer(p);
        }

        public static method hide(player p) {
            integer i;

            if (GetLocalPlayer() != p) { return; }
            if (!isOpen) { return; }

            isOpen = false;
            owner = null;

            destroyTooltip();

            if (btnClaim != 0) { btnClaim.destroy(); btnClaim = 0; }
            if (btnText != 0) { btnText.destroy(); btnText = 0; }
            if (btnImage != 0) { btnImage.destroy(); btnImage = 0; }

            if (statusText != 0) { statusText.destroy(); statusText = 0; }

            for (1 <= i <= SIGN7_TOTAL_DAYS) {
                if (slotCheck[i] != 0) { slotCheck[i].destroy(); slotCheck[i] = 0; }
                if (slotMask[i] != 0) { slotMask[i].destroy(); slotMask[i] = 0; }
                if (slotName[i] != 0) { slotName[i].destroy(); slotName[i] = 0; }
                if (slotIcon[i] != 0) { slotIcon[i].destroy(); slotIcon[i] = 0; }
                if (slotBtn[i] != 0) { slotBtn[i].destroy(); slotBtn[i] = 0; }
                if (slotFrame[i] != 0) { slotFrame[i].destroy(); slotFrame[i] = 0; }
            }

            if (uiCloseButton != 0) { uiCloseButton.destroy(); uiCloseButton = 0; }
            if (uiCloseImage != 0) { uiCloseImage.destroy(); uiCloseImage = 0; }
            if (uiMainButton != 0) { uiMainButton.destroy(); uiMainButton = 0; }
            if (uiMain != 0) { uiMain.destroy(); uiMain = 0; }
        }
    }

    //==========================================================================
    // SyncBus：从本地事件进入同步层
    //==========================================================================
    private function onSyncClaim() {
        string payload;
        player p;
        boolean ok;

        payload = syncBus.cbPayload;
        if (payload != "C") { return; }

        p = syncBus.cbPlayer;
        if (p == null) { return; }

        ok = sevenDaySignData.handleClaim(p);
        if (ok && GetLocalPlayer() == p) {
            sevenDaySignUI.refreshForPlayer(p);
        }
        p = null;
    }

    private function onInit() {
        syncBus.onDataSync(SIGN7_SYNC_CHANNEL, function onSyncClaim);
    }
}

//! endzinc
#endif
