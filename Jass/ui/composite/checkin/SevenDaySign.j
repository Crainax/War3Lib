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

#define SIGN7_TOTAL_DAYS        7           // 签到总天数
#define SIGN7_SYNC_CHANNEL      "SevenDaySign" // 同步通道名
#define SIGN7_LAST_DAYID_KEY    "SIGN7_LAST_DAYID" // 存档键：上次领取日期
#define SIGN7_CLAIM_DAY_KEY     "SIGN7_CLAIM_DAY"  // 存档键：已领取天数
// 后端限制提醒：SIGN7_CLAIM_DAY_KEY 仅允许单次请求 +1，禁止跳跃写入/回退写入。
// 运行时判定提醒：UI/领奖判定统一依赖内存缓存，不依赖局中 DzAPI 再读取。

#define SIGN7_MAIN_WIDTH        0.62        // 主面板宽度
#define SIGN7_MAIN_HEIGHT       (SIGN7_MAIN_WIDTH * 1324.0 / 2328.0) // 主面板高度（按背景图比例）

// 背景大图（4 张 1164x662 拼接为 2328x1324，保持比例，略大于主面板以形成边缘延伸）
#define SIGN7_BG_FULL_WIDTH     0.68        // 背景拼接总宽
#define SIGN7_BG_FULL_HEIGHT    (SIGN7_BG_FULL_WIDTH * 1324.0 / 2328.0) // 背景拼接总高

#define SIGN7_SLOT_SIZE         0.07        // 奖励槽位尺寸（正方形）
#define SIGN7_SLOT_GAP_X        0.01        // 槽位之间水平间距
#define SIGN7_SLOT_OFFSET_Y     0.03        // 槽位行相对中心的 Y 偏移

#define SIGN7_ICON_SIZE         0.05        // 奖励图标尺寸
#define SIGN7_NAME_FONT         4           // 奖励名称字号

#define SIGN7_BTN_WIDTH         0.10        // 领取按钮宽度
#define SIGN7_BTN_HEIGHT        (SIGN7_BTN_WIDTH * 575.0 / 1500.0) // 领取按钮高度（按原图比例）
#define SIGN7_BTN_OFFSET_Y      -0.135      // 领取按钮相对中心的 Y 偏移

#define SIGN7_STATUS_OFFSET_Y   -0.095      // 状态文字相对中心的 Y 偏移

#define SIGN7_MASK_ALPHA        160         // 已领取遮罩透明度
#define SIGN7_CHECK_SIZE        0.03        // 已领取勾选图标尺寸
#define SIGN7_CLAIM_TEXT_GAP_Y  -0.003      // "(已领取)"文字与名称的间距
#define SIGN7_CLOSE_SIZE        0.032       // 关闭按钮尺寸（正方形）
#define SIGN7_CLOSE_OFFSET_X    0.018      // 关闭按钮相对右上角的 X 偏移（负=向左）
#define SIGN7_CLOSE_OFFSET_Y    0.003      // 关闭按钮相对右上角的 Y 偏移（负=向下）
#define SIGN7_GROW_BTN_SIZE     0.075       // 领取按钮发光动画尺寸
#define SIGN7_TOOLTIP_BR_X      0.786       // Tooltip 右下角绝对 X 坐标
#define SIGN7_TOOLTIP_BR_Y      0.1675      // Tooltip 右下角绝对 Y 坐标

//# dependency:resource/ui/image/black.blp
//# dependency:resource/ui/image/bg_sevenday_01.blp
//# dependency:resource/ui/image/bg_sevenday_02.blp
//# dependency:resource/ui/image/bg_sevenday_03.blp
//# dependency:resource/ui/image/bg_sevenday_04.blp
//# dependency:resource/ui/image/border_sevenday_common.blp
//# dependency:resource/ui/image/border_sevenday_rare.blp
//# dependency:resource/ui/image/border_sevenday_epic.blp
//# dependency:resource/ui/image/border_sevenday_legendary.blp
//# dependency:resource/ui/image/button_claim.blp
//# dependency:resource/ui/image/button_claim_dark.blp


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
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return; }
            d = DzAPI_Map_GetStoredInteger(p, SIGN7_CLAIM_DAY_KEY);
            if (d < 0) { d = 0; }
            if (d > SIGN7_TOTAL_DAYS) { d = SIGN7_TOTAL_DAYS; }

            claimedDay[pid] = d;
            lastDayId[pid] = DzAPI_Map_GetStoredInteger(p, SIGN7_LAST_DAYID_KEY);
        }

        public static method registerClaimCallback(code func) {
            if (claimTr == null) {
                claimTr = CreateTrigger();
            }
            TriggerAddCondition(claimTr, Condition(func));
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

        static method onInit() {
            integer i;
            trigger tr = CreateTrigger();
            rewardIcon[1] = "ReplaceableTextures\\CommandButtons\\BTNReturnGoods.blp";
            rewardIcon[2] = "ReplaceableTextures\\CommandButtons\\BTNAnimateDead.blp";
            rewardIcon[3] = "ReplaceableTextures\\CommandButtons\\BTNBloodLustOn.blp";
            rewardIcon[4] = "ReplaceableTextures\\CommandButtons\\BTNBlizzard.blp";
            rewardIcon[5] = "ReplaceableTextures\\CommandButtons\\BTNBreathOfFrost.blp";
            rewardIcon[6] = "ReplaceableTextures\\CommandButtons\\BTNFireForTheCannon.blp";
            rewardIcon[7] = "ReplaceableTextures\\CommandButtons\\BTNBanish.blp";
            for (1 <= i <= SIGN7_TOTAL_DAYS) {
                rewardName[i] = "第" + I2S(i) + "天奖励";
                rewardTipTitle[i] = "奖励说明";
                rewardTipDesc[i] = "这是占位奖励内容";
            }

            // 在游戏开始 0.3 秒后初始化缓存：UI 操作期间不再触发 DzAPI 读写。
            TriggerRegisterTimerEventSingle(tr,0.3);
            TriggerAddCondition(tr,Condition(function (){
                integer j;
                for (1 <= j <= MAX_PLAYER_COUNT) {
                    thistype.refreshPlayer(ConvertedPlayer(j));
                }
                DestroyTrigger(GetTriggeringTrigger());
            }));
            tr = null;

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

        // 背景大图（拆成 4 份拼接）
        private static uiImage bgImage1 = 0; // 右下
        private static uiImage bgImage2 = 0; // 左下
        private static uiImage bgImage3 = 0; // 右上
        private static uiImage bgImage4 = 0; // 左上

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
        private static baseanim btnGrowAnim = 0;

        private static tooltip uiTooltipTemp = 0;
        private static integer escStackId = 0;

        private static boolean isOpen = false;

        // 根据天数返回品质边框纹理：common/rare/epic/common/rare/epic/legendary
        private static method getBorderTexture(integer day) -> string {
            if (day == 1 || day == 4) { return "ui\\image\\border_sevenday_common.blp"; }
            if (day == 2 || day == 5) { return "ui\\image\\border_sevenday_rare.blp"; }
            if (day == 3 || day == 6) { return "ui\\image\\border_sevenday_epic.blp"; }
            if (day == 7) { return "ui\\image\\border_sevenday_legendary.blp"; }
            return "ui\\image\\border_sevenday_common.blp";
        }

        private static method destroyTooltip() {
            if (uiTooltipTemp != 0 && uiTooltipTemp.isExist()) {
                uiTooltipTemp.destroy();
            }
            uiTooltipTemp = 0;
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

        public static method refreshForPlayer(player p) {
            integer i;
            integer day;
            integer lastId;
            integer nowId;
            boolean canClaim;
            boolean claimed;
            string name;

            if (!isOpen) { return; }
            if (GetLocalPlayer() != p) { return; }

            day = sevenDaySignData.getClaimedDay(p);
            for (1 <= i <= SIGN7_TOTAL_DAYS) {
                claimed = sevenDaySignData.isClaimed(day, i);
                name = sevenDaySignData.getRewardName(i);
                if (slotMask[i] != 0) { slotMask[i].show(claimed); }
                if (slotCheck[i] != 0) { slotCheck[i].show(claimed); }
                if (slotClaimed[i] != 0) { slotClaimed[i].show(claimed); }
                if (slotName[i] != 0) {
                    if (claimed) { slotName[i].setText("|cff888888" + name + "|r"); }
                    else { slotName[i].setText(name); }
                }
            }

            if (statusText != 0) {
                if (sevenDaySignData.isAllClaimed(day)) {
                    statusText.setText("|cffffcc00已完成|r");
                } else {
                    lastId = sevenDaySignData.getLastDayId(p);
                    nowId = sevenDaySignData.getBeijingDayId();
                    if (nowId <= lastId) { statusText.setText("|cffaaaaaa今日已领取|r"); }
                    else { statusText.setText("|cff00ff00今日可领取|r"); }
                }
            }

            canClaim = sevenDaySignData.canClaim(p);
            thistype.setClaimGrow(canClaim);
            if (btnImage != 0) {
                if (canClaim) { btnImage.setTexture("ui\\image\\button_claim.blp"); }
                else { btnImage.setTexture("ui\\image\\button_claim_dark.blp"); }
            }
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

            uiMain = uiImage.create(DzGetGameUI())
                .setTexture(UI_STRING_PATH_BLANK)
                .exReSize(SIGN7_MAIN_WIDTH, SIGN7_MAIN_HEIGHT)
                .exRePoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0);

            uiMainButton = uiBtn.createBlank(uiMain.ui)
                .setAllPoint(uiMain.ui)
                .enableDrag(uiMain.ui, 0.2, 0.8, 0.2, 0.8)
                .setDragPosition(0.4, 0.35);

            // 拼接 4 张背景图（总宽高略大于主面板），锚点对齐到 uiMain 中心，留 0.001 重叠避免缝隙
            bgImage1 = uiImage.create(uiMain.ui)
                .exReSize(SIGN7_BG_FULL_WIDTH * 0.5, SIGN7_BG_FULL_HEIGHT * 0.5)
                .setTexture("ui\\image\\bg_sevenday_01.blp")
                .exRePoint(ANCHOR_BOTTOMRIGHT, uiMain.ui, ANCHOR_CENTER, 0, 0);

            bgImage2 = uiImage.create(uiMain.ui)
                .exReSize(SIGN7_BG_FULL_WIDTH * 0.5, SIGN7_BG_FULL_HEIGHT * 0.5)
                .setTexture("ui\\image\\bg_sevenday_02.blp")
                .exRePoint(ANCHOR_BOTTOMLEFT, uiMain.ui, ANCHOR_CENTER, 0, 0);

            bgImage3 = uiImage.create(uiMain.ui)
                .exReSize(SIGN7_BG_FULL_WIDTH * 0.5, SIGN7_BG_FULL_HEIGHT * 0.5)
                .setTexture("ui\\image\\bg_sevenday_03.blp")
                .exRePoint(ANCHOR_TOPRIGHT, uiMain.ui, ANCHOR_CENTER, 0, 0);

            bgImage4 = uiImage.create(uiMain.ui)
                .exReSize(SIGN7_BG_FULL_WIDTH * 0.5, SIGN7_BG_FULL_HEIGHT * 0.5)
                .setTexture("ui\\image\\bg_sevenday_04.blp")
                .exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_CENTER, 0, 0);

            uiCloseImage = uiImage.create(uiMain.ui)
                .exReSize(SIGN7_CLOSE_SIZE, SIGN7_CLOSE_SIZE)
                .setTexture(UI_STRING_PATH_BLANK)
                .exRePoint(ANCHOR_TOPRIGHT, uiMain.ui, ANCHOR_TOPRIGHT, SIGN7_CLOSE_OFFSET_X, SIGN7_CLOSE_OFFSET_Y);

            uiCloseButton = uiBtn.create(uiCloseImage.ui)
                .setAllPoint(uiCloseImage.ui)
                .onEnter(function() {
                    destroyTooltip();
                    uiTooltipTemp = tooltip.create().layoutTitle("关闭界面|cffff9900(快捷键:Esc)|r");
                    uiTooltipTemp.setPoint(ANCHOR_BOTTOM, uiCloseImage.ui, ANCHOR_TOP, 0, 0.01);
                    music[MUSIC_INDEX_BTN_OVER_1].play();
                })
                .onLeave(function thistype.destroyTooltip)
                .onClick(function() {
                    music[MUSIC_INDEX_BTN_CLICK].play();
                    sevenDaySignUI.hide(GetLocalPlayer());
                });

            // slots
            startX = 0.0 - (SIGN7_TOTAL_DAYS - 1) * (SIGN7_SLOT_SIZE + SIGN7_SLOT_GAP_X) / 2.0;
            offsetY = SIGN7_SLOT_OFFSET_Y;

            for (1 <= i <= SIGN7_TOTAL_DAYS) {
                offsetX = startX + (i - 1) * (SIGN7_SLOT_SIZE + SIGN7_SLOT_GAP_X);

                slotFrame[i] = uiImage.create(uiMain.ui)
                    .exReSize(SIGN7_SLOT_SIZE, SIGN7_SLOT_SIZE)
                    .setTexture(thistype.getBorderTexture(i))
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
                    .setTexture("UI\\Widgets\\Glues\\GlueScreen-Checkbox-Check.blp")
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
                    })
                    .onLeave(function thistype.destroyTooltip);

                uiHashTable(slotBtn[i].ui).eventdata.bind(i);
            }

            statusText = uiText.create(uiMain.ui)
                .setFontSize(5)
                .setAlign(4)
                .setText("")
                .exRePoint(ANCHOR_CENTER, uiMain.ui, ANCHOR_CENTER, 0.0, SIGN7_STATUS_OFFSET_Y);

            btnImage = uiImage.create(uiMain.ui)
                .exReSize(SIGN7_BTN_WIDTH, SIGN7_BTN_HEIGHT)
                .setTexture("ui\\image\\button_claim.blp")
                .exRePoint(ANCHOR_CENTER, uiMain.ui, ANCHOR_CENTER, 0.0, SIGN7_BTN_OFFSET_Y);


            btnClaim = uiBtn.create(btnImage.ui)
                .setAllPoint(btnImage.ui)
                .onEnter(function music.onHoverCommon)
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

            destroyTooltip();

            if (escStackId != 0) {
                escStack.remove(escStackId);
                escStackId = 0;
            }

            thistype.setClaimGrow(false);
            if (btnClaim != 0) { btnClaim.destroy(); btnClaim = 0; }

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
            if (bgImage1 != 0) { bgImage1.destroy(); bgImage1 = 0; }
            if (bgImage2 != 0) { bgImage2.destroy(); bgImage2 = 0; }
            if (bgImage3 != 0) { bgImage3.destroy(); bgImage3 = 0; }
            if (bgImage4 != 0) { bgImage4.destroy(); bgImage4 = 0; }
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
    }
}
//! endzinc
#endif
