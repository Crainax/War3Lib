#ifndef SevenDaySignIncluded
#define SevenDaySignIncluded

#include "Crainax/config/SharedMethod.h"       // 结构体共用方法、I3 等工具
#include "Crainax/ui/constants/UIConstants.j"  // UI 常量
#include "Crainax/data/audio/MusicConstant.j"  // 音效常量
#include "Crainax/ui/constants/GrowConstants.j"  // UI 常量

//! zinc
/*
签到领奖励 UI（支持无限天数分页）
UI 仅负责展示与本地事件，领奖逻辑通过 SyncBus 进入同步层。
*/

#define SIGN7_MAX_DAYS          1300        // 奖励数组容量上限
#define SIGN7_PAGE_SIZE         7           // 每页显示槽位数
#define SIGN7_SYNC_CHANNEL      "SevenDaySign" // 同步通道名
#define SIGN7_LAST_DAYID_KEY    "LastSign" // 存档键：上次领取日期
#define SIGN7_CLAIM_DAY_KEY     "SignCount"  // 存档键：已领取天数
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

// VIP 特权图标（左下角）
#define SIGN7_VIP_ICON_SIZE     0.04        // VIP图标边长
#define SIGN7_VIP_ICON_OFFSET_X 0.02        // 相对面板左下角 X 偏移
#define SIGN7_VIP_ICON_OFFSET_Y 0.02        // 相对面板左下角 Y 偏移
#define SIGN7_VIP_ICON_PATH     "ui\\image\\sign_vip.blp"
#define SIGN7_VIP_MALLITEM_KEY  "Sign7"     // 商城商品 key
#define SIGN7_VIP_BONUS_DAYS    7           // VIP 额外赠送天数
#define SIGN7_REPEAT_START_DAY  8           // 第 3 周起复用第 2 周的起始天
#define SIGN7_REPEAT_END_DAY    14          // 第 3 周起复用第 2 周的结束天

// 翻页按钮
#define SIGN7_PAGE_BTN_W        0.0227      // 翻页按钮宽
#define SIGN7_PAGE_BTN_H        0.029       // 翻页按钮高
#define SIGN7_PAGE_TITLE_Y      0.022       // 标题相对 slot 区上方的 Y 偏移

//# dependency:resource/ui/image/black.blp
//# dependency:resource/ui/image/bg_sevenday_01.blp
//# dependency:resource/ui/image/bg_sevenday_02.blp
//# dependency:resource/ui/image/bg_sevenday_03.blp
//# dependency:resource/ui/image/bg_sevenday_04.blp
//# dependency:resource/ui/image/button_claim.blp
//# dependency:resource/ui/image/button_claim_dark.blp
//# dependency:resource/ui/image/select_left.blp
//# dependency:resource/ui/image/select_right.blp
//# dependency:resource/ui/image/sign_1.blp
//# dependency:resource/ui/image/sign_2.blp
//# dependency:resource/ui/image/sign_3.blp
//# dependency:resource/ui/image/sign_4.blp
//# dependency:resource/ui/image/sign_5.blp
//# dependency:resource/ui/image/sign_6.blp
//# dependency:resource/ui/image/sign_7.blp
//# dependency:resource/ui/image/sign_vip.blp
//# dependency:resource/ui/image/sign_ydd_1.blp
//# dependency:resource/ui/image/sign_ydd_2.blp
//# dependency:resource/ui/image/sign_ydd_3.blp
//# dependency:resource/ui/image/sign_ydd_4.blp


library SevenDaySign requires Tooltip,ToastHint,Music,SyncBus,UIExtendEvent,UIExtendDrag,EscStack,BaseAnim,GrowData {

    //==========================================================================
    // 数据层：存档 + 配置
    //==========================================================================
    public struct sevenDaySignData [] {
        private static integer claimedDay[];   // 已累计签到天数
        private static integer lastDayId[];    // 上次领取日期（按北京时间 dayId）

        private static string rewardIcon[];
        private static string rewardTipDesc[];
        private static integer rewardCount = 0; // 已注册的奖励总天数

        private static boolean vipActive[];     // VIP 特权调试/外部覆盖状态（按玩家）
        private static boolean vipActiveOverride[]; // true 时优先使用 vipActive，否则自动读取商城拥有权
        private static boolean vipInheritedActive[]; // 上阙继承激活状态（按玩家）

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

        public static method getRewardCount() -> integer {
            if (rewardCount >= SIGN7_REPEAT_END_DAY) { return SIGN7_MAX_DAYS; }
            return rewardCount;
        }

        public static method getNextClaimDay(integer claimedDay) -> integer {
            if (claimedDay >= thistype.getRewardCount()) { return 0; }
            return claimedDay + 1;
        }

        public static method isAllClaimed(integer claimedDay) -> boolean {
            return claimedDay >= thistype.getRewardCount();
        }

        public static method getLastDayId(player p) -> integer {
            integer pid;
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return 0; }
            return lastDayId[pid];
        }

        public static method getClaimPlayer() -> player {
            return claimPlayer;
        }

        public static method getClaimDay() -> integer {
            return cbClaimDay;
        }

        public static method isVipActive(player p) -> boolean {
            integer pid;
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return false; }
            if (vipActiveOverride[pid]) { return vipActive[pid]; }
            return thistype.isVipMallActive(p) || thistype.isVipInheritedActive(p);
        }

        public static method setVipActive(player p, boolean flag) {
            integer pid;
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return; }
            vipActive[pid] = flag;
            vipActiveOverride[pid] = true;
        }

        public static method isVipMallActive(player p) -> boolean {
            return mallItem.hasByPlayer(p, SIGN7_VIP_MALLITEM_KEY);
        }

        public static method isVipInheritedActive(player p) -> boolean {
            integer pid;
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return false; }
            return vipInheritedActive[pid];
        }

        public static method setVipInheritedActive(player p, boolean flag) {
            integer pid;
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return; }
            vipInheritedActive[pid] = flag;
        }

        public static method getStoredClaimedDay(player p) -> integer {
            integer pid;
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return 0; }
            return claimedDay[pid];
        }

        private static method getVipBonusDays(player p) -> integer {
            if (thistype.isVipActive(p)) { return SIGN7_VIP_BONUS_DAYS; }
            return 0;
        }

        public static method getClaimedDay(player p) -> integer {
            integer day;
            integer rc;
            day = thistype.getStoredClaimedDay(p) + thistype.getVipBonusDays(p);
            rc = thistype.getRewardCount();
            if (rc > 0 && day > rc) { return rc; }
            return day;
        }

        public static method refreshPlayer(player p) {
            integer pid;
            integer d;
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return; }
            d = DzAPI_Map_GetStoredInteger(p, SIGN7_CLAIM_DAY_KEY);
            if (d < 0) { d = 0; }

            claimedDay[pid] = d;
            lastDayId[pid] = DzAPI_Map_GetStoredInteger(p, SIGN7_LAST_DAYID_KEY);
        }

        public static method registerClaimCallback(code func) {
            if (claimTr == null) {
                claimTr = CreateTrigger();
            }
            TriggerAddCondition(claimTr, Condition(func));
        }

        public static method setReward(integer day, string iconPath, string tipDesc) {
            if (day < 1 || day > SIGN7_MAX_DAYS) { return; }
            rewardIcon[day] = iconPath;
            rewardTipDesc[day] = tipDesc;
            if (day > rewardCount) { rewardCount = day; }
        }

        public static method getRewardTemplateDay(integer day) -> integer {
            integer repeatSize;
            if (day > SIGN7_REPEAT_END_DAY && rewardCount >= SIGN7_REPEAT_END_DAY) {
                repeatSize = SIGN7_REPEAT_END_DAY - SIGN7_REPEAT_START_DAY + 1;
                return SIGN7_REPEAT_START_DAY + ModuloInteger(day - SIGN7_REPEAT_START_DAY, repeatSize);
            }
            return day;
        }

        public static method getRewardIcon(integer day) -> string {
            if (day < 1 || day > thistype.getRewardCount()) { return ""; }
            day = thistype.getRewardTemplateDay(day);
            return rewardIcon[day];
        }

        public static method getRewardTitle(integer day) -> string {
            if (day < 1 || day > thistype.getRewardCount()) { return ""; }
            return "第" + I2S(day) + "天奖励";
        }

        public static method getRewardTipDesc(integer day) -> string {
            if (day < 1 || day > thistype.getRewardCount()) { return ""; }
            day = thistype.getRewardTemplateDay(day);
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

        // 同步层：处理领取（存档单日 +1，VIP 仅作为展示/判定的隐性偏移）
        public static method handleClaim(player p) -> boolean {
            integer pid;
            integer storedDay;
            integer viewDay;
            integer lastId;
            integer nowId;
            integer nextDay;

            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return false; }

            storedDay = claimedDay[pid];
            viewDay = thistype.getClaimedDay(p);
            lastId = lastDayId[pid];
            nowId = thistype.getBeijingDayId();

            if (thistype.isAllClaimed(viewDay)) { return false; }
            if (nowId <= lastId) { return false; }

            nextDay = thistype.getNextClaimDay(viewDay);
            if (nextDay <= 0) { return false; }

            storedDay = storedDay + 1;
            claimedDay[pid] = storedDay;
            lastDayId[pid] = nowId;

            DzAPI_Map_StoreInteger(p, SIGN7_CLAIM_DAY_KEY, storedDay);
            DzAPI_Map_StoreInteger(p, SIGN7_LAST_DAYID_KEY, nowId);

            // 回调传参
            claimPlayer = p;
            cbClaimDay = thistype.getRewardTemplateDay(nextDay);
            if (claimTr != null) {
                TriggerEvaluate(claimTr);
            }
            claimPlayer = null;
            cbClaimDay = 0;
            return true;
        }

        static method onInit() {
            trigger tr = CreateTrigger();

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
        private static uiImage bgImage1 = 0;
        private static uiImage bgImage2 = 0;
        private static uiImage bgImage3 = 0;
        private static uiImage bgImage4 = 0;

        // 7 个槽位（每页固定 7 个，翻页时刷新内容）
        private static uiImage slotIcon[SIGN7_PAGE_SIZE];
        private static uiBtn   slotBtn[SIGN7_PAGE_SIZE];
        private static uiText  slotName[SIGN7_PAGE_SIZE];
        private static uiText  slotClaimed[SIGN7_PAGE_SIZE];
        private static uiImage slotMask[SIGN7_PAGE_SIZE];
        private static uiImage slotCheck[SIGN7_PAGE_SIZE];

        private static uiText  statusText = 0;
        private static uiImage btnImage = 0;
        private static uiImage btnGrowImage = 0;
        private static uiBtn   btnClaim = 0;
        private static baseanim btnGrowAnim = 0;

        // 翻页
        private static integer currentPage = 1;
        private static integer totalPage = 1;
        private static uiText  pageTitle = 0;
        private static uiImage pageLeftImage = 0;
        private static uiBtn   pageLeftBtn = 0;
        private static uiImage pageRightImage = 0;
        private static uiBtn   pageRightBtn = 0;

        // VIP 特权图标
        private static icon    vipIcon = 0;
        private static uiImage vipGrowImage = 0;
        private static baseanim vipGrowAnim = 0;

        private static tooltip uiTooltipTemp = 0;
        private static integer escStackId = 0;
        private static boolean isOpen = false;

        private static method destroyTooltip() {
            if (uiTooltipTemp != 0 && uiTooltipTemp.isExist()) {
                uiTooltipTemp.destroy();
            }
            uiTooltipTemp = 0;
        }

        private static method getUnlockedPage(player p) -> integer {
            integer day;
            integer maxPage;
            if (totalPage <= 1) { return 1; }
            day = sevenDaySignData.getClaimedDay(p);
            maxPage = day / SIGN7_PAGE_SIZE + 1;
            if (maxPage < 1) { maxPage = 1; }
            if (maxPage > totalPage) { maxPage = totalPage; }
            return maxPage;
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

        private static method setVipGrow(boolean enable) {
            growdata gd;
            if (enable) {
                if (vipGrowImage != 0 || vipIcon == 0) { return; }
                gd = growdata[ICONGROW_15];
                vipGrowImage = uiImage.create(uiMain.ui)
                    .setPoint(ANCHOR_CENTER, vipIcon.mainImage.ui, ANCHOR_CENTER, gd.offsetX * gd.scale, gd.offsetY * gd.scale)
                    .exReSize(SIGN7_VIP_ICON_SIZE * gd.scale, SIGN7_VIP_ICON_SIZE * gd.scale);
                vipGrowAnim = baseanim.create(vipGrowImage.ui);
                vipGrowAnim.addSequ(gd.path, gd.max, gd.gap, true);
            } else {
                if (vipGrowAnim != 0) { vipGrowAnim.destroy(); vipGrowAnim = 0; }
                if (vipGrowImage != 0) { vipGrowImage.destroy(); vipGrowImage = 0; }
            }
        }

        private static method activeTitlePrefix(boolean active) -> string {
            if (active) { return "|cff00ff00[已激活]|r"; }
            return "|cff888888[未激活]|r";
        }

        private static method rewardSubtitle(boolean claimed) -> string {
            if (claimed) { return "|cff00ff00已永久获得以下奖励:|r"; }
            return "|cff888888签到以领取以下奖励:|r";
        }

        private static method sourceLine(boolean active, string text) -> string {
            if (active) { return "|cff00ff00" + text + "|r"; }
            return "|cff888888" + text + "|r";
        }

        private static method vipTooltipTitle(player p) -> string {
            return thistype.activeTitlePrefix(sevenDaySignData.isVipActive(p)) + "|cFFFFFF337|r|cFFFFE949天|r|cFFFFD35F签|r|cFFFFBD75到|r|cFFFFA88A特|r|cFFFF92A0权|r";
        }

        private static method vipTooltipDesc(player p) -> string {
            return "拥有该特权后能直接完成7天签到|cff1aff00(在现有签到天数基础上+7天获得更多奖励)|r."
            + "\n\n|cffeeff00[激活来源]|r\n"
            + thistype.sourceLine(sevenDaySignData.isVipMallActive(p), "1.商城道具:获得该商城道具后激活(成为VIP3会员后领取)")
            + "\n"
            + thistype.sourceLine(sevenDaySignData.isVipInheritedActive(p), "2.上阙继承:通过上阙的典藏赞助功能继承该特权");
        }

        private static method showRewardTooltip(player p, integer day) {
            string title;
            string desc;
            boolean claimed;
            uiText line;
            title = sevenDaySignData.getRewardTitle(day);
            desc = sevenDaySignData.getRewardTipDesc(day);
            claimed = sevenDaySignData.isClaimed(sevenDaySignData.getClaimedDay(p), day);
            uiTooltipTemp = tooltip.create()
                .setFontSize(4)
                .layoutFlexible(desc)
                .setAbsPoint(ANCHOR_BOTTOMRIGHT, SIGN7_TOOLTIP_BR_X, SIGN7_TOOLTIP_BR_Y);
            uiTooltipTemp.getFirstText().setAlign(3);
            line = uiTooltipTemp.addText(thistype.rewardSubtitle(claimed));
            line.setAlign(4);
            line = uiTooltipTemp.setFontSize(7).addText(thistype.activeTitlePrefix(claimed) + title);
            line.setAlign(4);
            uiTooltipTemp.setWidth(0.22);
            line = 0;
            title = null;
            desc = null;
        }

        // 刷新当前页的 7 个槽位内容（不重建 UI 组件）
        private static method refreshSlotContent(player p) {
            integer i;
            integer day;
            integer slotDay;
            integer claimedDayVal;
            integer rc;
            boolean claimed;
            string iconPath;
            string title;

            if (!isOpen) { return; }

            claimedDayVal = sevenDaySignData.getClaimedDay(p);
            rc = sevenDaySignData.getRewardCount();

            for (1 <= i <= SIGN7_PAGE_SIZE) {
                slotDay = (currentPage - 1) * SIGN7_PAGE_SIZE + i;
                if (slotDay <= rc) {
                    iconPath = sevenDaySignData.getRewardIcon(slotDay);
                    title = sevenDaySignData.getRewardTitle(slotDay);
                    claimed = sevenDaySignData.isClaimed(claimedDayVal, slotDay);

                    if (slotIcon[i] != 0) { slotIcon[i].setTexture(iconPath).show(true); }
                    if (slotMask[i] != 0) { slotMask[i].show(claimed); }
                    if (slotCheck[i] != 0) { slotCheck[i].show(claimed); }
                    if (slotClaimed[i] != 0) { slotClaimed[i].show(claimed); }
                    if (slotName[i] != 0) {
                        if (claimed) { slotName[i].setText("|cff888888" + title + "|r").show(true); }
                        else { slotName[i].setText(title).show(true); }
                    }
                    if (slotBtn[i] != 0) {
                        uiHashTable(slotBtn[i].ui).eventdata.bind(slotDay);
                    }
                } else {
                    if (slotIcon[i] != 0) { slotIcon[i].show(false); }
                    if (slotMask[i] != 0) { slotMask[i].show(false); }
                    if (slotCheck[i] != 0) { slotCheck[i].show(false); }
                    if (slotClaimed[i] != 0) { slotClaimed[i].show(false); }
                    if (slotName[i] != 0) { slotName[i].show(false); }
                }
            }
        }

        // 刷新翻页标题和按钮可见性
        private static method refreshPageUI(player p) {
            integer rc;
            integer unlockedPage;
            rc = sevenDaySignData.getRewardCount();
            totalPage = (rc + SIGN7_PAGE_SIZE - 1) / SIGN7_PAGE_SIZE;
            if (totalPage < 1) { totalPage = 1; }
            unlockedPage = thistype.getUnlockedPage(p);
            if (currentPage > unlockedPage) { currentPage = unlockedPage; }
            if (currentPage < 1) { currentPage = 1; }

            if (unlockedPage > 1 && totalPage > 1 && rc > SIGN7_PAGE_SIZE) {
                if (pageTitle != 0) {
                    pageTitle.setText("第 " + I2S(currentPage) + " 周签到").show(true);
                }
                if (pageLeftImage != 0) { pageLeftImage.show(currentPage > 1); }
                if (pageLeftBtn != 0) { pageLeftBtn.show(currentPage > 1); }
                if (pageRightImage != 0) { pageRightImage.show(currentPage < unlockedPage); }
                if (pageRightBtn != 0) { pageRightBtn.show(currentPage < unlockedPage); }
            } else {
                if (pageTitle != 0) { pageTitle.show(false); }
                if (pageLeftImage != 0) { pageLeftImage.show(false); }
                if (pageLeftBtn != 0) { pageLeftBtn.show(false); }
                if (pageRightImage != 0) { pageRightImage.show(false); }
                if (pageRightBtn != 0) { pageRightBtn.show(false); }
            }
        }

        // 滚轮翻页
        private static method onMouseWheel() {
            integer targetPage;
            integer unlockedPage;
            real delta;
            if (!isOpen || totalPage <= 1) { return; }
            unlockedPage = thistype.getUnlockedPage(GetLocalPlayer());
            if (unlockedPage <= 1) { return; }
            delta = DzGetWheelDelta();
            if (delta < 0) {
                targetPage = IMinBJ(currentPage + 1, unlockedPage);
            } else {
                targetPage = IMaxBJ(currentPage - 1, 1);
            }
            if (targetPage == currentPage) { return; }
            currentPage = targetPage;
            refreshPageUI(GetLocalPlayer());
            refreshSlotContent(GetLocalPlayer());
        }

        public static method refreshForPlayer(player p) {
            integer day;
            integer lastId;
            integer nowId;
            boolean canClaim;
            boolean vipOn;

            if (!isOpen) { return; }
            if (GetLocalPlayer() != p) { return; }

            day = sevenDaySignData.getClaimedDay(p);

            // 刷新槽位内容
            refreshPageUI(p);
            refreshSlotContent(p);

            // 状态文字
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

            // VIP 图标状态
            vipOn = sevenDaySignData.isVipActive(p);
            if (vipIcon != 0) {
                vipIcon.setShadow(!vipOn);
            }
            thistype.setVipGrow(vipOn);
        }

        public static method show(player p) {
            integer i;
            real startX;
            real offsetX;
            real offsetY;
            real slotRowTopY;

            if (GetLocalPlayer() != p) { return; }
            if (isOpen) { return; }

            isOpen = true;
            currentPage = 1;

            uiMain = uiImage.create(DzGetGameUI())
                .setTexture(UI_STRING_PATH_BLANK)
                .exReSize(SIGN7_MAIN_WIDTH, SIGN7_MAIN_HEIGHT)
                .exRePoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0);

            uiMainButton = uiBtn.createBlank(uiMain.ui)
                .setAllPoint(uiMain.ui)
                .enableDrag(uiMain.ui, 0.2, 0.8, 0.2, 0.8)
                .setDragPosition(0.4, 0.35)
                .onMouseWheel(function sevenDaySignUI.onMouseWheel);

            // 拼接 4 张背景图
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

            // 关闭按钮
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

            // 7 个奖励槽位（无边框，图标直接显示）
            startX = 0.0 - (SIGN7_PAGE_SIZE - 1) * (SIGN7_SLOT_SIZE + SIGN7_SLOT_GAP_X) / 2.0;
            offsetY = SIGN7_SLOT_OFFSET_Y;

            for (1 <= i <= SIGN7_PAGE_SIZE) {
                offsetX = startX + (i - 1) * (SIGN7_SLOT_SIZE + SIGN7_SLOT_GAP_X);

                slotIcon[i] = uiImage.create(uiMain.ui)
                    .exReSize(SIGN7_SLOT_SIZE, SIGN7_SLOT_SIZE)
                    .setTexture(UI_STRING_PATH_BLANK)
                    .exRePoint(ANCHOR_CENTER, uiMain.ui, ANCHOR_CENTER, offsetX, offsetY);

                slotName[i] = uiText.create(uiMain.ui)
                    .setFontSize(SIGN7_NAME_FONT)
                    .setAlign(4)
                    .setText("")
                    .exRePoint(ANCHOR_TOP, slotIcon[i].ui, ANCHOR_BOTTOM, 0.0, -0.004);

                slotClaimed[i] = uiText.create(uiMain.ui)
                    .setFontSize(2)
                    .setAlign(4)
                    .setText("|cff888888(已领取)|r")
                    .exRePoint(ANCHOR_TOP, slotName[i].ui, ANCHOR_BOTTOM, 0.0, SIGN7_CLAIM_TEXT_GAP_Y)
                    .show(false);

                slotMask[i] = uiImage.create(slotIcon[i].ui)
                    .setTexture("ui\\image\\black.blp")
                    .setAllPoint(slotIcon[i].ui)
                    .setAlpha(SIGN7_MASK_ALPHA)
                    .show(false);

                slotCheck[i] = uiImage.create(slotIcon[i].ui)
                    .exReSize(SIGN7_CHECK_SIZE, SIGN7_CHECK_SIZE)
                    .setTexture("UI\\Widgets\\Glues\\GlueScreen-Checkbox-Check.blp")
                    .exRePoint(ANCHOR_CENTER, slotIcon[i].ui, ANCHOR_CENTER, 0.0, 0.0)
                    .show(false);

                // Tooltip events
                slotBtn[i] = uiBtn.createBlank(slotIcon[i].ui)
                    .setAllPoint(slotIcon[i].ui)
                    .onMouseWheel(function sevenDaySignUI.onMouseWheel)
                    .spEnter(function(integer frame) {
                        integer day;
                        day = uiHashTable(frame).eventdata.get();
                        destroyTooltip();
                        thistype.showRewardTooltip(GetLocalPlayer(), day);
                    })
                    .onLeave(function thistype.destroyTooltip);

                uiHashTable(slotBtn[i].ui).eventdata.bind(i);
            }

            // 记录槽位行顶部 Y 坐标，用于定位翻页标题
            slotRowTopY = offsetY + SIGN7_SLOT_SIZE * 0.5;

            // 翻页标题（位于槽位行上方）
            pageTitle = uiText.create(uiMain.ui)
                .setFontSize(7)
                .setAlign(4)
                .setText("")
                .exRePoint(ANCHOR_BOTTOM, uiMain.ui, ANCHOR_CENTER, 0.0, slotRowTopY + SIGN7_PAGE_TITLE_Y);

            // 翻页按钮（标题左右两侧）
            pageLeftImage = uiImage.create(uiMain.ui)
                .exReSize(SIGN7_PAGE_BTN_W, SIGN7_PAGE_BTN_H)
                .setTexture("ui\\image\\select_left.blp")
                .exRePoint(ANCHOR_RIGHT, pageTitle.ui, ANCHOR_LEFT, -0.005, 0.0);
            pageLeftBtn = uiBtn.create(pageLeftImage.ui)
                .setAllPoint(pageLeftImage.ui)
                .onMouseWheel(function sevenDaySignUI.onMouseWheel)
                .onClick(function() {
                    if (currentPage > 1) {
                        currentPage = currentPage - 1;
                        refreshPageUI(GetLocalPlayer());
                        refreshSlotContent(GetLocalPlayer());
                        music[MUSIC_INDEX_BTN_CLICK].play();
                    }
            });

            pageRightImage = uiImage.create(uiMain.ui)
                .exReSize(SIGN7_PAGE_BTN_W, SIGN7_PAGE_BTN_H)
                .setTexture("ui\\image\\select_right.blp")
                .exRePoint(ANCHOR_LEFT, pageTitle.ui, ANCHOR_RIGHT, 0.005, 0.0);
            pageRightBtn = uiBtn.create(pageRightImage.ui)
                .setAllPoint(pageRightImage.ui)
                .onMouseWheel(function sevenDaySignUI.onMouseWheel)
                .onClick(function() {
                    if (currentPage < thistype.getUnlockedPage(GetLocalPlayer())) {
                        currentPage = currentPage + 1;
                        refreshPageUI(GetLocalPlayer());
                        refreshSlotContent(GetLocalPlayer());
                        music[MUSIC_INDEX_BTN_CLICK].play();
                    }
            });

            // 状态文字
            statusText = uiText.create(uiMain.ui)
                .setFontSize(5)
                .setAlign(4)
                .setText("")
                .exRePoint(ANCHOR_CENTER, uiMain.ui, ANCHOR_CENTER, 0.0, SIGN7_STATUS_OFFSET_Y);

            // 领取按钮
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

            // VIP 特权图标（左下角）
            vipIcon = icon.create(uiMain.ui)
                .enableResize()
                .setTexture(SIGN7_VIP_ICON_PATH)
                .setSize(SIGN7_VIP_ICON_SIZE, SIGN7_VIP_ICON_SIZE)
                .exRePoint(ANCHOR_BOTTOMLEFT, uiMain.ui, ANCHOR_BOTTOMLEFT, SIGN7_VIP_ICON_OFFSET_X, SIGN7_VIP_ICON_OFFSET_Y);
            vipIcon.show(true);
            vipIcon.getClickBtn()
                .onMouseWheel(function sevenDaySignUI.onMouseWheel)
                .onEnter(function() {
                    player lp;
                    lp = GetLocalPlayer();
                    destroyTooltip();
                    uiTooltipTemp = tooltip.create().layoutTitleDesc(
                    thistype.vipTooltipTitle(lp),
                    thistype.vipTooltipDesc(lp));
                    uiTooltipTemp.setAbsPoint(ANCHOR_BOTTOMRIGHT, SIGN7_TOOLTIP_BR_X, SIGN7_TOOLTIP_BR_Y);
                    music[MUSIC_INDEX_BTN_OVER_1].play();
                    lp = null;
                })
                .onLeave(function thistype.destroyTooltip);

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
            currentPage = 1;

            destroyTooltip();

            if (escStackId != 0) {
                escStack.remove(escStackId);
                escStackId = 0;
            }

            thistype.setClaimGrow(false);
            thistype.setVipGrow(false);

            if (btnClaim != 0) { btnClaim.destroy(); btnClaim = 0; }
            if (btnImage != 0) { btnImage.destroy(); btnImage = 0; }
            if (statusText != 0) { statusText.destroy(); statusText = 0; }

            for (1 <= i <= SIGN7_PAGE_SIZE) {
                if (slotCheck[i] != 0) { slotCheck[i].destroy(); slotCheck[i] = 0; }
                if (slotMask[i] != 0) { slotMask[i].destroy(); slotMask[i] = 0; }
                if (slotClaimed[i] != 0) { slotClaimed[i].destroy(); slotClaimed[i] = 0; }
                if (slotName[i] != 0) { slotName[i].destroy(); slotName[i] = 0; }
                if (slotIcon[i] != 0) { slotIcon[i].destroy(); slotIcon[i] = 0; }
                if (slotBtn[i] != 0) { slotBtn[i].destroy(); slotBtn[i] = 0; }
            }

            if (pageLeftBtn != 0) { pageLeftBtn.destroy(); pageLeftBtn = 0; }
            if (pageLeftImage != 0) { pageLeftImage.destroy(); pageLeftImage = 0; }
            if (pageRightBtn != 0) { pageRightBtn.destroy(); pageRightBtn = 0; }
            if (pageRightImage != 0) { pageRightImage.destroy(); pageRightImage = 0; }
            if (pageTitle != 0) { pageTitle.destroy(); pageTitle = 0; }

            if (vipIcon != 0) { vipIcon.destroy(); vipIcon = 0; }

            if (uiCloseButton != 0) { uiCloseButton.destroy(); uiCloseButton = 0; }
            if (uiCloseImage != 0) { uiCloseImage.destroy(); uiCloseImage = 0; }
            if (uiMainButton != 0) { uiMainButton.destroy(); uiMainButton = 0; }
            if (bgImage1 != 0) { bgImage1.destroy(); bgImage1 = 0; }
            if (bgImage2 != 0) { bgImage2.destroy(); bgImage2 = 0; }
            if (bgImage3 != 0) { bgImage3.destroy(); bgImage3 = 0; }
            if (bgImage4 != 0) { bgImage4.destroy(); bgImage4 = 0; }
            if (uiMain != 0) { uiMain.destroy(); uiMain = 0; }
        }

        public static method isShow() -> boolean {
            return isOpen;
        }
    }

    //==========================================================================
    // SyncBus：从本地事件进入同步层
    //==========================================================================
    private function onInit() {
        // mallItem.init(SIGN7_VIP_MALLITEM_KEY); //初始化道具
        syncBus.onDataSync(SIGN7_SYNC_CHANNEL, function () {
            string payload;
            player p;
            boolean ok;
            integer day;

            payload = syncBus.cbPayload;
            p = syncBus.cbPlayer;
            if (p == null) { return; }

            if (payload == "C") {
                day = sevenDaySignData.getNextClaimDay(sevenDaySignData.getClaimedDay(p));
                ok = sevenDaySignData.handleClaim(p);
                if (GetLocalPlayer() == p) {
                    if (ok) {
                        sevenDaySignUI.refreshForPlayer(p);
                        toastHint.createAtMouse(p, "领取成功:第" + I2S(day) + "天的奖励!\n|cff6f6f6f(注:部分奖励需要重启游戏后生效)|r");
                        music[MUSIC_INDEX_SHOP_BUY].playFor(p);
                    } else {
                        toastHint.createAtMouse(p, "今日已领取,请明日再来!");
                    }
                }
            }
            p = null;
        });
    }
}
//! endzinc
#endif
