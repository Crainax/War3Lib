#ifndef SevenDaySignIncluded
#define SevenDaySignIncluded

#include "Crainax/config/SharedMethod.h"       // 结构体共用方法、I3 等工具
#include "Crainax/ui/constants/UIConstants.j"  // UI 常量
#include "Crainax/data/audio/MusicConstant.j"  // 音效常量
#include "Crainax/ui/constants/GrowConstants.j"  // UI 常量

//! zinc
/*
七天签到领奖励 UI（一次性7天）
UI 仅负责展示与本地事件，领奖逻辑通过 SyncBus 进入同步层。
*/

#define SIGN7_TOTAL_DAYS        7
#define SIGN7_SYNC_CHANNEL      "SevenDaySign"
#define SIGN7_LAST_DAYID_KEY    "SIGN7_LAST_DAYID"
#define SIGN7_CLAIM_DAY_KEY     "SIGN7_CLAIM_DAY"
#define SIGN7_CLAIM_MASK_KEY    "SIGN7_CLAIM_MASK" // 兼容旧位图存档（迁移读）
// 后端限制提醒：SIGN7_CLAIM_DAY_KEY 仅允许单次请求 +1，禁止跳跃写入/回退写入。
// 运行时判定提醒：UI/领奖判定统一依赖内存缓存，不依赖局中 DzAPI 再读取。

#define SIGN7_MAIN_WIDTH        0.62
#define SIGN7_MAIN_HEIGHT       0.36

#define SIGN7_SLOT_SIZE         0.07
#define SIGN7_SLOT_GAP_X        0.01
#define SIGN7_SLOT_OFFSET_Y     0.07

#define SIGN7_ICON_SIZE         0.05
#define SIGN7_NAME_FONT         3

#define SIGN7_BTN_WIDTH         0.10
#define SIGN7_BTN_HEIGHT        0.038
#define SIGN7_BTN_OFFSET_Y      -0.135

#define SIGN7_STATUS_OFFSET_Y   -0.095

#define SIGN7_MASK_ALPHA        160
#define SIGN7_CHECK_SIZE        0.03
#define SIGN7_CLAIM_TEXT_GAP_Y  -0.003
#define SIGN7_CLOSE_SIZE        0.032
#define SIGN7_GROW_BTN_SIZE     0.075
#define SIGN7_TOOLTIP_BR_X      0.786
#define SIGN7_TOOLTIP_BR_Y      0.1675

//# dependency:resource/ui/image/select_flash.blp
//# dependency:resource/ui/image/black.blp
//# dependency:resource/ui/image/select_close.blp

library SevenDaySign requires Tooltip,ToastHint,Music,SyncBus,UIExtendEvent,UIExtendDrag,EscStack,BaseAnim,GrowData {

    //==========================================================================
    // 数据层：存档 + 配置
    //==========================================================================
    public struct sevenDaySignData [] {
        private static integer claimedDay[];   // 已累计签到天数（0..7）
        private static integer lastDayId[];    // 上次领取日期（按北京时间 dayId）

        private static string rewardIcon[];
        private static string rewardName[];
        private static string rewardTipTitle[];
        private static string rewardTipDesc[];

        private static trigger claimTr = null;
        private static player  claimPlayer = null;
        private static integer cbClaimDay = 0;

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

        public static method isClaimed(integer claimedDay, integer day) -> boolean {
            return day <= claimedDay;
        }

        // 旧位图数据迁移：0,1,3,7,15,31,63,127 -> 0..7
        private static method legacyMaskToDay(integer mask) -> integer {
            if (mask <= 0) { return 0; }
            if (mask == 1) { return 1; }
            if (mask == 3) { return 2; }
            if (mask == 7) { return 3; }
            if (mask == 15) { return 4; }
            if (mask == 31) { return 5; }
            if (mask == 63) { return 6; }
            if (mask == 127) { return 7; }
            return 0;
        }

        public static method getNextClaimDay(integer claimedDay) -> integer {
            if (claimedDay >= SIGN7_TOTAL_DAYS) { return 0; }
            return claimedDay + 1;
        }

        public static method isAllClaimed(integer claimedDay) -> boolean {
            return claimedDay >= SIGN7_TOTAL_DAYS;
        }

        public static method getClaimedDay(player p) -> integer {
            integer pid;
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return 0; }
            return claimedDay[pid];
        }

        public static method getLastDayId(player p) -> integer {
            integer pid;
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return 0; }
            return lastDayId[pid];
        }

        public static method refreshPlayer(player p) {
            integer pid;
            integer d;
            integer legacyMask;
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return; }
            d = DzAPI_Map_GetStoredInteger(p, SIGN7_CLAIM_DAY_KEY);
            if (d < 0) { d = 0; }
            if (d > SIGN7_TOTAL_DAYS) { d = SIGN7_TOTAL_DAYS; }

            // 若新键还没有值，尝试从旧位图键迁移一次
            if (d == 0) {
                legacyMask = DzAPI_Map_GetStoredInteger(p, SIGN7_CLAIM_MASK_KEY);
                d = thistype.legacyMaskToDay(legacyMask);
                if (d > 0) {
                    DzAPI_Map_StoreInteger(p, SIGN7_CLAIM_DAY_KEY, d);
                }
            }

            claimedDay[pid] = d;
            lastDayId[pid] = DzAPI_Map_GetStoredInteger(p, SIGN7_LAST_DAYID_KEY);
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
            return cbClaimDay;
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
            integer day;
            integer lastId;
            integer nowId;
            day = thistype.getClaimedDay(p);
            if (thistype.isAllClaimed(day)) { return false; }
            lastId = thistype.getLastDayId(p);
            nowId = thistype.getBeijingDayId();
            return nowId > lastId;
        }

        // 同步层：处理领取
        public static method handleClaim(player p) -> boolean {
            integer pid;
            integer day;
            integer lastId;
            integer nowId;
            integer nextDay;

            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return false; }

            day = claimedDay[pid];
            lastId = lastDayId[pid];
            nowId = thistype.getBeijingDayId();

            if (thistype.isAllClaimed(day)) { return false; }
            if (nowId <= lastId) { return false; }

            nextDay = thistype.getNextClaimDay(day);
            if (nextDay <= 0) { return false; }

            day = day + 1;
            claimedDay[pid] = day;
            lastDayId[pid] = nowId;

            DzAPI_Map_StoreInteger(p, SIGN7_CLAIM_DAY_KEY, day);
            DzAPI_Map_StoreInteger(p, SIGN7_LAST_DAYID_KEY, nowId);

            // 回调传参
            claimPlayer = p;
            cbClaimDay = nextDay;
            if (claimTr != null) {
                TriggerEvaluate(claimTr);
            }
            claimPlayer = null;
            cbClaimDay = 0;
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
            timer t;
            thistype.initDefaultRewards();

            // 延时一次性初始化本地缓存，避免和其他系统启动时序冲突
            t = CreateTimer();
            TimerStart(t, 0.30, false, function() {
                integer j;
                for (1 <= j <= MAX_PLAYER_COUNT) {
                    thistype.refreshPlayer(ConvertedPlayer(j));
                }
                DestroyTimer(GetExpiredTimer());
            });
            t = null;
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
        private static uiText  slotClaimed[SIGN7_TOTAL_DAYS];
        private static uiImage slotMask[SIGN7_TOTAL_DAYS];
        private static uiImage slotCheck[SIGN7_TOTAL_DAYS];

        private static uiText  statusText = 0;
        private static uiImage btnImage = 0;
        private static uiImage btnGrowImage = 0;
        private static uiBtn   btnClaim = 0;
        private static uiText  btnText = 0;
        private static baseanim btnGrowAnim = 0;

        private static tooltip uiTooltipTemp = 0;
        private static integer escStackId = 0;

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
            integer claimedDay;
            boolean claimed;
            string name;
            claimedDay = sevenDaySignData.getClaimedDay(p);

            for (1 <= i <= SIGN7_TOTAL_DAYS) {
                claimed = sevenDaySignData.isClaimed(claimedDay, i);
                name = sevenDaySignData.getRewardName(i);
                if (slotMask[i] != 0) { slotMask[i].show(claimed); }
                if (slotCheck[i] != 0) { slotCheck[i].show(claimed); }
                if (slotClaimed[i] != 0) { slotClaimed[i].show(claimed); }
                if (slotName[i] != 0) {
                    if (claimed) {
                        slotName[i].setText("|cff888888" + name + "|r");
                    } else {
                        slotName[i].setText(name);
                    }
                }
            }
        }

        private static method setClaimGrow(boolean enable) {
            growdata gd;
            if (enable) {
                if (btnGrowImage != 0 || btnImage == 0) { return; }
                gd = growdata[ICONGROW_BTN];
                btnGrowImage = uiImage.create(uiMain.ui)
                    .setPoint(ANCHOR_CENTER, btnImage.ui, ANCHOR_CENTER, gd.offsetX * gd.scale, gd.offsetY * gd.scale)
                    .exReSize(SIGN7_GROW_BTN_SIZE * gd.scale, SIGN7_GROW_BTN_SIZE * gd.scale);
                btnGrowAnim = baseanim.create(btnGrowImage.ui);
                btnGrowAnim.addSequ(gd.path, gd.max, gd.gap, true);
            } else {
                if (btnGrowAnim != 0) { btnGrowAnim.destroy(); btnGrowAnim = 0; }
                if (btnGrowImage != 0) { btnGrowImage.destroy(); btnGrowImage = 0; }
            }
        }

        private static method refreshStatus(player p) {
            integer day;
            integer lastId;
            integer nowId;

            if (statusText == 0) { return; }

            day = sevenDaySignData.getClaimedDay(p);
            if (sevenDaySignData.isAllClaimed(day)) {
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
            thistype.setClaimGrow(canClaim);

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
            // 仅在打开时做一次后端->缓存同步，后续逻辑全部使用缓存避免局中 DzAPI 旧值覆盖。
            sevenDaySignData.refreshPlayer(p);

            uiMain = uiImage.create(DzGetGameUI())
                .setTexture("ui\\image\\black.blp")
                .exReSize(SIGN7_MAIN_WIDTH, SIGN7_MAIN_HEIGHT)
                .exRePoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0);

            uiMainButton = uiBtn.createBlank(uiMain.ui)
                .setAllPoint(uiMain.ui)
                .enableDrag(uiMain.ui, 0.2, 0.8, 0.2, 0.8)
                .setDragPosition(0.4, 0.35);

            uiCloseImage = uiImage.create(uiMain.ui)
                .exReSize(SIGN7_CLOSE_SIZE, SIGN7_CLOSE_SIZE)
                .setTexture("ui\\image\\select_close.blp")
                .exRePoint(ANCHOR_TOPRIGHT, uiMain.ui, ANCHOR_TOPRIGHT, -0.003, -0.003);

            uiCloseButton = uiBtn.create(uiCloseImage.ui)
                .setAllPoint(uiCloseImage.ui)
                .onEnter(function() {
                    destroyTooltip();
                    uiTooltipTemp = tooltip.create().layoutTitle("关闭界面|cffff9900(快捷键:Esc)|r");
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

                slotClaimed[i] = uiText.create(uiMain.ui)
                    .setFontSize(2)
                    .setAlign(4)
                    .setText("|cff888888(已领取)|r")
                    .exRePoint(ANCHOR_TOP, slotName[i].ui, ANCHOR_BOTTOM, 0.0, SIGN7_CLAIM_TEXT_GAP_Y)
                    .show(false);

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
                        desc = "第" + I2S(day) + "份奖励";
                        uiTooltipTemp = tooltip.create().layoutTitleDesc(title, desc);
                        uiTooltipTemp.setAbsPoint(ANCHOR_BOTTOMRIGHT, SIGN7_TOOLTIP_BR_X, SIGN7_TOOLTIP_BR_Y);
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
                .setFontSize(7)
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
                        toastHint.createAtMouse(lp, "今日已领取,请明日再来!");
                    }
                lp = null;
            });

            sevenDaySignUI.refreshForPlayer(p);

            if (escStackId == 0) {
                escStackId = escStack.push(function(player lp) {
                    sevenDaySignUI.hide(lp);
                });
            }
        }

        public static method hide(player p) {
            integer i;

            if (GetLocalPlayer() != p) { return; }
            if (!isOpen) { return; }

            isOpen = false;
            owner = null;

            destroyTooltip();

            if (escStackId != 0) {
                escStack.remove(escStackId);
                escStackId = 0;
            }

            thistype.setClaimGrow(false);
            if (btnClaim != 0) { btnClaim.destroy(); btnClaim = 0; }
            if (btnText != 0) { btnText.destroy(); btnText = 0; }
            if (btnImage != 0) { btnImage.destroy(); btnImage = 0; }

            if (statusText != 0) { statusText.destroy(); statusText = 0; }

            for (1 <= i <= SIGN7_TOTAL_DAYS) {
                if (slotCheck[i] != 0) { slotCheck[i].destroy(); slotCheck[i] = 0; }
                if (slotMask[i] != 0) { slotMask[i].destroy(); slotMask[i] = 0; }
                if (slotClaimed[i] != 0) { slotClaimed[i].destroy(); slotClaimed[i] = 0; }
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

        // 判断 UI 是否正在显示
        public static method isShow() -> boolean {
            return isOpen;
        }
    }

    //==========================================================================
    // SyncBus：从本地事件进入同步层
    //==========================================================================
    private function onInit() {
        syncBus.onDataSync(SIGN7_SYNC_CHANNEL, function () {
            string payload;
            player p;
            boolean ok;
            integer day;

            payload = syncBus.cbPayload;
            if (payload != "C") { return; }

            p = syncBus.cbPlayer;
            if (p == null) { return; }

            day = sevenDaySignData.getNextClaimDay(sevenDaySignData.getClaimedDay(p));
            ok = sevenDaySignData.handleClaim(p);
            if (GetLocalPlayer() == p) {
                if (ok) {
                    sevenDaySignUI.refreshForPlayer(p);
                    toastHint.createAtMouse(p, "领取成功:第" + I2S(day) + "的奖励!");
                } else {
                    toastHint.createAtMouse(p, "今日已领取,请明日再来!");
                }
            }
            p = null;
        });

        //在游戏开始0.2秒后再调用
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr,0.2);
        TriggerAddCondition(tr,Condition(function (){
            //todo:DzAPI_Map_GetStoredInteger应该放在这个阶段(因为 DzAPI_Map_GetStoredInteger  返回的值永远是本局最初从服务器获取的数值,所以不能通过StoreInteger再更新这个新值.目前实时更新的结果就是签到后再次关闭打开UI后还是不会显示签到成功,)
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;
    }
}

//! endzinc
#endif
