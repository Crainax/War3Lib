#ifndef UIDialogIncluded
#define UIDialogIncluded

#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j"

//! zinc

#define UIDIALOG_PAGE_ITEM_MAX      9           // 每页最多显示的选项数量
#define UIDIALOG_SYNC_TAG           "UIDialog"  // 网络同步消息的标识Tag

#define UIDIALOG_WIDTH              0.268       // 对话框总宽度
#define UIDIALOG_PADDING_TOP        0.024       // 顶部内边距（标题距上边框）
#define UIDIALOG_PADDING_BOTTOM     0.025       // 底部内边距（翻页按钮距下边框）
#define UIDIALOG_PADDING_X          0.025       // 左右内边距
#define UIDIALOG_TITLE_HEIGHT       0.024       // 标题栏高度
#define UIDIALOG_GAP_TITLE_ITEMS    0.008       // 标题与第一个选项之间的间距
#define UIDIALOG_ITEM_HEIGHT        0.033       // 每个选项行的高度
#define UIDIALOG_ITEM_GAP           0.003       // 相邻选项行之间的间距
#define UIDIALOG_GAP_ITEMS_PAGER    0.008       // 最后一个选项与翻页按钮之间的间距
#define UIDIALOG_PAGER_HEIGHT       0.033       // 翻页按钮（上一页/下一页）的高度（同选项行高）
#define UIDIALOG_CENTER_OFFSET_Y    0.080       // 对话框相对屏幕中心的垂直偏移（正值=偏上）
#define UIDIALOG_ITEM_TEXT_OFFSET_Y  0.002       // 按钮内文字向下偏移量

#define UIDIALOG_HASH_KEY_PAGE      1

library UIDialog requires SyncBus,UIButton,UIBorder,UIImage,UIText,UIHashTable,HashTable {

    private dialogData currentData      = 0;
    private dialogData currentDataAsync = 0;
    private integer currentPos          = 0;
    private integer currentPosAsync     = 0;
    private integer currentFrameAsync   = 0;
    private string currentContent       = "";

    public function GetUIDialogData() -> dialogData {
        return currentData;
    }

    public function GetUIDialogDataAsync() -> dialogData {
        return currentDataAsync;
    }

    public function GetUIDialogPos() -> integer {
        return currentPos;
    }

    public function GetUIDialogPosAsync() -> integer {
        return currentPosAsync;
    }

    public function GetUIDialogFrameAsync() -> integer {
        return currentFrameAsync;
    }

    public function CallbackUIDialogContent(string s) {
        currentContent = s;
    }

    private function UIDialogFindComma(string s, integer startPos) -> integer {
        integer i = startPos;
        integer len = StringLength(s);
        while (i < len) {
            if (SubString(s, i, i + 1) == ",") {
                return i;
            }
            i += 1;
        }
        return -1;
    }

    public struct uidialog {
        private dialogData dd;
        private uiBorder uiMain;
        private uiBtn uiBlocker;
        private uiText uiTitle;

        private uiImage itemImage[UIDIALOG_PAGE_ITEM_MAX];
        private uiBtn itemButton[UIDIALOG_PAGE_ITEM_MAX];
        private uiText itemText[UIDIALOG_PAGE_ITEM_MAX];

        private uiImage pagePrevImage;
        private uiBtn pagePrevButton;
        private uiText pagePrevText;
        private uiImage pageNextImage;
        private uiBtn pageNextButton;
        private uiText pageNextText;

        private boolean enteredFlag;
        private integer enteredPos;

        STRUCT_SHARED_METHODS(uidialog)

        private method getPageCount() -> integer {
            if (!this.isExist() || dd.count <= 0) { return 1; }
            return (dd.count + UIDIALOG_PAGE_ITEM_MAX - 1) / UIDIALOG_PAGE_ITEM_MAX;
        }

        private method getCurrentPage() -> integer {
            integer page;
            integer maxPage;
            if (!this.isExist()) { return 1; }

            page = LoadInteger(HASH_DIALOG, dd, UIDIALOG_HASH_KEY_PAGE);
            maxPage = this.getPageCount();

            if (page < 1) { page = 1; }
            if (page > maxPage) { page = maxPage; }
            return page;
        }

        private method setCurrentPage(integer page) {
            integer maxPage;
            if (!this.isExist()) { return; }

            maxPage = this.getPageCount();
            if (page < 1) { page = 1; }
            if (page > maxPage) { page = maxPage; }
            SaveInteger(HASH_DIALOG, dd, UIDIALOG_HASH_KEY_PAGE, page);
        }

        private method getGlobalPosBySlot(integer slot) -> integer {
            integer page;
            if (!this.isExist()) { return 0; }
            page = this.getCurrentPage();
            return (page - 1) * UIDIALOG_PAGE_ITEM_MAX + slot;
        }


        private method pageTurn(integer delta) {
            integer page;
            integer maxPage;
            if (!this.isExist()) { return; }

            maxPage = this.getPageCount();
            if (maxPage <= 1) { return; }

            page = this.getCurrentPage();
            page += delta;
            if (page < 1) {
                page = maxPage;
            }
            if (page > maxPage) {
                page = 1;
            }

            this.setCurrentPage(page);
            this.refresh();
        }

        private method showPager(boolean showFlag) {
            if (!this.isExist()) { return; }
            pagePrevImage.show(showFlag);
            pagePrevButton.show(showFlag);
            pagePrevText.show(showFlag);
            pageNextImage.show(showFlag);
            pageNextButton.show(showFlag);
            pageNextText.show(showFlag);
        }

        method refresh() {
            integer i;
            integer pos;
            integer visibleCount;
            integer currentPage;
            integer maxPage;
            boolean needPager;
            real dialogWidth;
            real itemWidth;
            real firstRowOffsetY;
            real rowOffsetY;
            real mainHeight;

            if (!this.isExist()) { return; }
            if (!dd.isExist()) { return; }
            if (GetLocalPlayer() != dd.owner) { return; }

            maxPage = this.getPageCount();
            currentPage = this.getCurrentPage();
            this.setCurrentPage(currentPage);

            // 内联 getVisibleCount
            visibleCount = dd.count - (currentPage - 1) * UIDIALOG_PAGE_ITEM_MAX;
            if (visibleCount < 0) { visibleCount = 0; }
            if (visibleCount > UIDIALOG_PAGE_ITEM_MAX) { visibleCount = UIDIALOG_PAGE_ITEM_MAX; }

            needPager = (maxPage > 1);

            dialogWidth = dd.width;
            if (dialogWidth <= 0.0) {
                dialogWidth = UIDIALOG_WIDTH;
            } else if (dialogWidth < UIDIALOG_PADDING_X * 2.0 + 0.04) {
                dialogWidth = UIDIALOG_PADDING_X * 2.0 + 0.04;
            }

            // 内联 getMainHeight
            mainHeight = UIDIALOG_PADDING_TOP + UIDIALOG_TITLE_HEIGHT + UIDIALOG_GAP_TITLE_ITEMS + UIDIALOG_PADDING_BOTTOM;
            if (visibleCount > 0) {
                mainHeight += visibleCount * UIDIALOG_ITEM_HEIGHT + (visibleCount - 1) * UIDIALOG_ITEM_GAP;
            }
            if (needPager) {
                mainHeight += UIDIALOG_GAP_ITEMS_PAGER + UIDIALOG_PAGER_HEIGHT;
            }

            itemWidth = dialogWidth - UIDIALOG_PADDING_X * 2.0;

            uiMain.clearPoint().setSize(dialogWidth, mainHeight);
            if (dd.useAbsPoint) {
                uiMain.setAbsPoint(dd.absAnchor, dd.absX, dd.absY);
            } else {
                uiMain.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, UIDIALOG_CENTER_OFFSET_Y);
            }

            uiTitle.clearPoint()
                .setPoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, UIDIALOG_PADDING_X, -UIDIALOG_PADDING_TOP)
                .setPoint(ANCHOR_BOTTOMRIGHT, uiMain.ui, ANCHOR_TOPRIGHT, -UIDIALOG_PADDING_X, -UIDIALOG_PADDING_TOP - UIDIALOG_TITLE_HEIGHT);

            // 内联 updateTitle
            if (maxPage > 1) {
                uiTitle.setText(dd.title + "(" + I2S(currentPage) + "/" + I2S(maxPage) + ")");
            } else {
                uiTitle.setText(dd.title);
            }

            firstRowOffsetY = -UIDIALOG_PADDING_TOP - UIDIALOG_TITLE_HEIGHT - UIDIALOG_GAP_TITLE_ITEMS;

            i = 1;
            while (i <= UIDIALOG_PAGE_ITEM_MAX) {
                rowOffsetY = firstRowOffsetY - (i - 1) * (UIDIALOG_ITEM_HEIGHT + UIDIALOG_ITEM_GAP);
                itemImage[i].clearPoint()
                    .setSize(itemWidth, UIDIALOG_ITEM_HEIGHT)
                    .setPoint(ANCHOR_TOP, uiMain.ui, ANCHOR_TOP, 0.0, rowOffsetY);

                if (i <= visibleCount) {
                    pos = this.getGlobalPosBySlot(i);

                    currentContent = "";
                    if (dd.trContentTrigger != null) {
                        currentDataAsync = dd;
                        currentPosAsync = pos;
                        TriggerEvaluate(dd.trContentTrigger);
                    }

                    itemText[i].setText(currentContent);
                    itemImage[i].show(true);
                    itemButton[i].show(true);
                    itemText[i].show(true);
                } else {
                    itemImage[i].show(false);
                    itemButton[i].show(false);
                    itemText[i].show(false);
                }

                i += 1;
            }

            pagePrevImage.clearPoint()
                .setSize(itemWidth * 0.48, UIDIALOG_PAGER_HEIGHT)
                .setPoint(ANCHOR_BOTTOMLEFT, uiMain.ui, ANCHOR_BOTTOMLEFT, UIDIALOG_PADDING_X, UIDIALOG_PADDING_BOTTOM);
            pageNextImage.clearPoint()
                .setSize(itemWidth * 0.48, UIDIALOG_PAGER_HEIGHT)
                .setPoint(ANCHOR_BOTTOMRIGHT, uiMain.ui, ANCHOR_BOTTOMRIGHT, -UIDIALOG_PADDING_X, UIDIALOG_PADDING_BOTTOM);

            this.showPager(needPager);
        }

        static method create(player p, dialogData data) -> thistype {
            thistype this;
            integer i;

            if (GetLocalPlayer() != p) { return 0; }
            if (!data.isExist()) { return 0; }

            this = allocate();
            if (!this.isExist()) { return 0; }

            this.dd = data;
            this.enteredFlag = false;
            this.enteredPos = 0;

            this.uiMain = uiBorder.createType5(DzGetGameUI());
            this.uiBlocker = uiBtn.createBlank(this.uiMain.ui)
                .setAllPoint(this.uiMain.ui);
            this.uiTitle = uiText.create(this.uiMain.ui)
                .setAlign(4)
                .setFontSize(8)
                .setText("");

            i = 1;
            while (i <= UIDIALOG_PAGE_ITEM_MAX) {
                this.itemImage[i] = uiImage.create(this.uiMain.ui)
                    .setTexture(UI_STRING_PATH_BLANK);

                this.itemButton[i] = uiBtn.createWar3Dialog(this.itemImage[i].ui)
                    .setAllPoint(this.itemImage[i].ui)
                    .spEnter(function(integer frame) {
                        thistype this = uiHashTable(frame).eventdata.get();
                        integer slot = uiHashTable(frame).eventdata.get2();
                        integer pos;
                        dialogData data;

                        if (!this.isExist()) { return; }
                        data = this.dd;
                        if (!data.isExist()) { return; }

                        pos = this.getGlobalPosBySlot(slot);
                        if (pos < 1 || pos > data.count) { return; }

                        this.enteredFlag = true;
                        this.enteredPos = pos;

                        if (data.trEnterTrigger != null) {
                            currentDataAsync = data;
                            currentPosAsync = pos;
                            currentFrameAsync = frame;
                            TriggerEvaluate(data.trEnterTrigger);
                        }
                })
                    .spLeave(function(integer frame) {
                        thistype this = uiHashTable(frame).eventdata.get();
                        integer slot = uiHashTable(frame).eventdata.get2();
                        integer pos;
                        dialogData data;

                        if (!this.isExist()) { return; }
                        data = this.dd;
                        if (!data.isExist()) { return; }

                        pos = this.getGlobalPosBySlot(slot);
                        if (pos < 1 || pos > data.count) { return; }

                        this.enteredFlag = false;
                        this.enteredPos = 0;

                        if (data.trLeaveTrigger != null) {
                            currentDataAsync = data;
                            currentPosAsync = pos;
                            currentFrameAsync = frame;
                            TriggerEvaluate(data.trLeaveTrigger);
                            currentFrameAsync = 0;
                        }
                })
                    .spClick(function(integer frame) {
                        thistype this = uiHashTable(frame).eventdata.get();
                        integer slot = uiHashTable(frame).eventdata.get2();
                        integer pos;
                        dialogData data;

                        if (!this.isExist()) { return; }
                        data = this.dd;
                        if (!data.isExist()) { return; }

                        pos = this.getGlobalPosBySlot(slot);
                        if (pos < 1 || pos > data.count) { return; }

                        syncBus.DzSyncDataEx(UIDIALOG_SYNC_TAG, "C," + I2S(data) + "," + I2S(pos));
                    });

                uiHashTable(this.itemButton[i].ui).eventdata.bind(this);
                uiHashTable(this.itemButton[i].ui).eventdata.bind2(i);

                this.itemText[i] = uiText.create(this.itemButton[i].ui)
                    .setPoint(ANCHOR_TOPLEFT, this.itemButton[i].ui, ANCHOR_TOPLEFT, 0.0, -UIDIALOG_ITEM_TEXT_OFFSET_Y)
                    .setPoint(ANCHOR_BOTTOMRIGHT, this.itemButton[i].ui, ANCHOR_BOTTOMRIGHT, 0.0, -UIDIALOG_ITEM_TEXT_OFFSET_Y)
                    .setAlign(4)
                    .setFontSize(7)
                    .setText("");

                i += 1;
            }

            this.pagePrevImage = uiImage.create(this.uiMain.ui)
                .setTexture(UI_STRING_PATH_BLANK);
            this.pagePrevButton = uiBtn.createWar3Dialog(this.pagePrevImage.ui)
                .setAllPoint(this.pagePrevImage.ui)
                .spClick(function(integer frame) {
                    thistype this = uiHashTable(frame).eventdata.get();
                    if (!this.isExist()) { return; }
                    this.pageTurn(-1);
                });
            uiHashTable(this.pagePrevButton.ui).eventdata.bind(this);
            this.pagePrevText = uiText.create(this.pagePrevButton.ui)
                .setPoint(ANCHOR_TOPLEFT, this.pagePrevButton.ui, ANCHOR_TOPLEFT, 0.0, -UIDIALOG_ITEM_TEXT_OFFSET_Y)
                .setPoint(ANCHOR_BOTTOMRIGHT, this.pagePrevButton.ui, ANCHOR_BOTTOMRIGHT, 0.0, -UIDIALOG_ITEM_TEXT_OFFSET_Y)
                .setAlign(4)
                .setFontSize(7)
                .setText("上一页");

            this.pageNextImage = uiImage.create(this.uiMain.ui)
                .setTexture(UI_STRING_PATH_BLANK);
            this.pageNextButton = uiBtn.createWar3Dialog(this.pageNextImage.ui)
                .setAllPoint(this.pageNextImage.ui)
                .spClick(function(integer frame) {
                    thistype this = uiHashTable(frame).eventdata.get();
                    if (!this.isExist()) { return; }
                    this.pageTurn(1);
                });
            uiHashTable(this.pageNextButton.ui).eventdata.bind(this);
            this.pageNextText = uiText.create(this.pageNextButton.ui)
                .setPoint(ANCHOR_TOPLEFT, this.pageNextButton.ui, ANCHOR_TOPLEFT, 0.0, -UIDIALOG_ITEM_TEXT_OFFSET_Y)
                .setPoint(ANCHOR_BOTTOMRIGHT, this.pageNextButton.ui, ANCHOR_BOTTOMRIGHT, 0.0, -UIDIALOG_ITEM_TEXT_OFFSET_Y)
                .setAlign(4)
                .setFontSize(7)
                .setText("下一页");

            this.refresh();
            return this;
        }

        method onDestroy() {
            integer i;
            dialogData data;

            if (!this.isExist()) { return; }
            data = dd;

            if (enteredFlag && enteredPos > 0 && data.isExist() && data.trLeaveTrigger != null) {
                currentDataAsync = data;
                currentPosAsync = enteredPos;
                TriggerEvaluate(data.trLeaveTrigger);
            }
            enteredFlag = false;
            enteredPos = 0;

            if (data.isExist() && data.uiDialog == this) {
                data.uiDialog = 0;
            }

            i = UIDIALOG_PAGE_ITEM_MAX;
            while (i >= 1) {
                if (itemText[i] != 0) {
                    itemText[i].destroy();
                    itemText[i] = 0;
                }
                if (itemButton[i] != 0) {
                    itemButton[i].destroy();
                    itemButton[i] = 0;
                }
                if (itemImage[i] != 0) {
                    itemImage[i].destroy();
                    itemImage[i] = 0;
                }
                i -= 1;
            }

            if (pagePrevText != 0) { pagePrevText.destroy(); pagePrevText = 0; }
            if (pagePrevButton != 0) { pagePrevButton.destroy(); pagePrevButton = 0; }
            if (pagePrevImage != 0) { pagePrevImage.destroy(); pagePrevImage = 0; }

            if (pageNextText != 0) { pageNextText.destroy(); pageNextText = 0; }
            if (pageNextButton != 0) { pageNextButton.destroy(); pageNextButton = 0; }
            if (pageNextImage != 0) { pageNextImage.destroy(); pageNextImage = 0; }

            if (uiTitle != 0) { uiTitle.destroy(); uiTitle = 0; }
            if (uiBlocker != 0) { uiBlocker.destroy(); uiBlocker = 0; }
            if (uiMain != 0) { uiMain.destroy(); uiMain = 0; }

            dd = 0;
        }
    }

    public struct dialogData {
        integer count;
        string title;
        player owner;
        real width;
        boolean useAbsPoint;
        integer absAnchor;
        real absX;
        real absY;

        // [ASYNC-SAFE] 以下触发器在本地 UI 异步链路中触发，禁止修改同步状态
        trigger trContentTrigger;
        trigger trEnterTrigger;
        trigger trLeaveTrigger;
        trigger trClickTrigger;
        boolean autoHideOnClick;

        uidialog uiDialog;

        STRUCT_SHARED_METHODS(dialogData)

        static method create(player p, integer c) -> thistype {
            thistype this = allocate();
            if (this <= 0) { return 0; }

            this.count = c;
            if (this.count < 0) { this.count = 0; }

            this.title = "";
            this.owner = p;
            this.width = UIDIALOG_WIDTH;
            this.useAbsPoint = false;
            this.absAnchor = ANCHOR_CENTER;
            this.absX = 0.0;
            this.absY = UIDIALOG_CENTER_OFFSET_Y;
            this.trContentTrigger = null;
            this.trEnterTrigger = null;
            this.trLeaveTrigger = null;
            this.trClickTrigger = null;
            this.autoHideOnClick = true;
            this.uiDialog = 0;

            SaveInteger(HASH_DIALOG, this, UIDIALOG_HASH_KEY_PAGE, 1);
            return this;
        }

        method trContent(code func) {
            if (!this.isExist()) { return; }
            if (trContentTrigger != null) { DestroyTrigger(trContentTrigger); trContentTrigger = null; }
            if (func != null) {
                trContentTrigger = CreateTrigger();
                TriggerAddCondition(trContentTrigger, Condition(func));
            }
        }

        method setWidth(real w) {
            if (!this.isExist()) { return; }
            if (w > 0.0) {
                width = w;
            } else {
                width = UIDIALOG_WIDTH;
            }
        }

        method setAbsPoint(integer anchor, real x, real y) {
            if (!this.isExist()) { return; }
            useAbsPoint = true;
            absAnchor = anchor;
            absX = x;
            absY = y;
        }

        method clearAbsPoint() {
            if (!this.isExist()) { return; }
            useAbsPoint = false;
            absAnchor = ANCHOR_CENTER;
            absX = 0.0;
            absY = UIDIALOG_CENTER_OFFSET_Y;
        }

        method onEnter(code func) {
            if (!this.isExist()) { return; }
            if (trEnterTrigger != null) { DestroyTrigger(trEnterTrigger); trEnterTrigger = null; }
            if (func != null) {
                trEnterTrigger = CreateTrigger();
                TriggerAddCondition(trEnterTrigger, Condition(func));
            }
        }

        method onLeave(code func) {
            if (!this.isExist()) { return; }
            if (trLeaveTrigger != null) { DestroyTrigger(trLeaveTrigger); trLeaveTrigger = null; }
            if (func != null) {
                trLeaveTrigger = CreateTrigger();
                TriggerAddCondition(trLeaveTrigger, Condition(func));
            }
        }

        method onClick(code func) {
            if (!this.isExist()) { return; }
            if (trClickTrigger != null) { DestroyTrigger(trClickTrigger); trClickTrigger = null; }
            if (func != null) {
                trClickTrigger = CreateTrigger();
                TriggerAddCondition(trClickTrigger, Condition(func));
            }
        }

        method setAutoHideOnClick(boolean hideFlag) {
            if (!this.isExist()) { return; }
            autoHideOnClick = hideFlag;
        }

        method show() {
            if (!this.isExist()) { return; }
            if (GetLocalPlayer() != owner) { return; }

            if (uiDialog.isExist()) {
                uiDialog.refresh();
            } else {
                uiDialog = uidialog.create(owner, this);
            }
        }

        method hide() {
            if (!this.isExist()) { return; }
            if (GetLocalPlayer() != owner) { return; }

            if (uiDialog.isExist()) {
                uiDialog.destroy();
                uiDialog = 0;
            }
        }

        method refresh() {
            if (!this.isExist()) { return; }
            if (GetLocalPlayer() != owner) { return; }

            if (uiDialog.isExist()) {
                uiDialog.refresh();
            }
        }

        method onDestroy() {
            if (!this.isExist()) { return; }

            if (GetLocalPlayer() == owner && uiDialog.isExist()) {
                uiDialog.destroy();
                uiDialog = 0;
            }

            if (trContentTrigger != null) { DestroyTrigger(trContentTrigger); trContentTrigger = null; }
            if (trEnterTrigger != null) { DestroyTrigger(trEnterTrigger); trEnterTrigger = null; }
            if (trLeaveTrigger != null) { DestroyTrigger(trLeaveTrigger); trLeaveTrigger = null; }
            if (trClickTrigger != null) { DestroyTrigger(trClickTrigger); trClickTrigger = null; }

            FlushChildHashtable(HASH_DIALOG, this);

            count = 0;
            title = null;
            owner = null;
            width = 0.0;
            useAbsPoint = false;
            absAnchor = 0;
            absX = 0.0;
            absY = 0.0;
            autoHideOnClick = true;
        }
    }

    function onInit() {
        syncBus.onDataSync(UIDIALOG_SYNC_TAG, function () -> boolean {
            string payload;
            player p;
            integer splitPos;
            dialogData data;
            integer pos;

            payload = syncBus.getPayload();
            p = syncBus.getPlayer();

            if (StringLength(payload) >= 4 && SubString(payload, 0, 2) == "C,") {
                splitPos = UIDialogFindComma(payload, 2);
                if (splitPos > 1) {
                    data = S2I(SubString(payload, 2, splitPos));
                    pos = S2I(SubString(payload, splitPos + 1, StringLength(payload)));

                    if (data.isExist() && data.owner == p && pos >= 1 && pos <= data.count) {
                        if (data.trClickTrigger != null) {
                            currentData = data;
                            currentPos = pos;
                            TriggerEvaluate(data.trClickTrigger);
                            currentData = 0;
                            currentPos = 0;
                        }

                        if (data.autoHideOnClick) {
                            data.hide();
                        }
                    }
                }
            }

            payload = null;
            p = null;
            data = 0;
            return true;
        });
    }
}

#undef UIDIALOG_PAGE_ITEM_MAX
#undef UIDIALOG_SYNC_TAG

#undef UIDIALOG_WIDTH
#undef UIDIALOG_PADDING_TOP
#undef UIDIALOG_PADDING_BOTTOM
#undef UIDIALOG_PADDING_X
#undef UIDIALOG_TITLE_HEIGHT
#undef UIDIALOG_GAP_TITLE_ITEMS
#undef UIDIALOG_ITEM_HEIGHT
#undef UIDIALOG_ITEM_GAP
#undef UIDIALOG_GAP_ITEMS_PAGER
#undef UIDIALOG_PAGER_HEIGHT
#undef UIDIALOG_CENTER_OFFSET_Y
#undef UIDIALOG_ITEM_TEXT_OFFSET_Y

#undef UIDIALOG_HASH_KEY_PAGE

//! endzinc

#endif
