#ifndef MuseumIncluded
#define MuseumIncluded

#include "Crainax/config/SharedMethod.h"       // 结构体共用方法、I3 等工具
#include "Crainax/ui/constants/UIConstants.j"  // UI 常量
#include "Crainax/data/audio/MusicConstant.j"  // 音效常量

//! zinc
/*
博物馆 UI（图鉴）
整体为单例 UI，左侧为图鉴分类按钮，右侧由外部回调自行渲染内容。
*/

#define MUSEUM_MAIN_WIDTH      0.64   // 主 UI 宽
#define MUSEUM_MAIN_HEIGHT     0.37   // 主 UI 高

#define MUSEUM_TAB_MAX_COUNT       16       // 左侧最多可显示的图鉴分类数量
#define MUSEUM_TAB_WIDTH           0.077    // 左侧按钮宽度（缩小约 30%）
#define MUSEUM_TAB_HEIGHT          0.018    // 左侧按钮高度（缩小约 30%）
#define MUSEUM_TAB_GAP_Y           0.002    // 左侧按钮纵向间距
#define MUSEUM_TAB_SELECTED_OFFSET_X 0.008  // 选中时整体左移偏移
#define MUSEUM_TAB_START_Y -0.035            // 左侧按钮起始 Y 坐标

// 顶部标题相关常量
#define MUSEUM_TITLE_HEIGHT       0.026   // 标题高度
#define MUSEUM_TITLE_OFFSET_Y     -0.015   // 标题图片离 main 的 Y 偏移
#define MUSEUM_TITLE_WIDTH_RATIO  465.0 / 48.0  // 标题宽高比（465:48）

// 右侧内容区域与整体的边距 / Top 起点（基于标题高度和间距计算得出）
#define MUSEUM_CONTENT_MARGIN_X    0.005
#define MUSEUM_CONTENT_MARGIN_Y    0.005
#define MUSEUM_CONTENT_TOP_Y      -0.041  // 标题底部 (-0.02 - 0.032/2) 再往下 0.005

// 顶部标题与 Tab 文字颜色
#define MUSEUM_TITLE_TEXT          "异度图鉴"
#define MUSEUM_TAB_COLOR_NORMAL    "|cFFFFFFFF"
#define MUSEUM_TAB_COLOR_SELECTED  "|cFFFFCC00"
#define MUSEUM_COLOR_END           "|r"

//# dependency:resource/ui/image/select_flash.blp
//# dependency:resource/ui/image/black.blp
//# dependency:resource/ui/image/select_close.blp
//# dependency:resource/ui/image/vertical_divider.blp
//# dependency:resource/ui/image/museum_title_465x48.blp
//# dependency:resource/ui/image/arrow_right_101x72.blp

library Museum requires Music,Icon,Tooltip,EscStack {

    //==========================================================================
    // 图鉴数据：永久存在，仅负责“哪几类图鉴、各自名称和回调”
    //==========================================================================
    public struct museumData {
        string  name;        // 左侧按钮显示名称
        trigger trClick;     // 打开 / 选中时的回调
        trigger trClose;     // 关闭 / 取消选中时的回调
        integer index;       // 在全局列表中的索引（1-based）

        STRUCT_SHARED_INNER_UI(museumData)

        // 全局列表
        private static thistype list[];
        private static integer size = 0;

        // 回调参数传递：当前触发的 museumData
        private static thistype callbackData = 0;

        // 注册一个新的图鉴分类
        public static method registerAlbum(string n) -> thistype {
            thistype this;

            this = allocate();
            if (this <= 0) {
                return 0;
            }

            this.name    = n;
            this.trClick = null;
            this.trClose = null;

            thistype.size += 1;
            this.index = thistype.size;
            thistype.list[thistype.size] = this;

            return this;
        }

        // 注册：点击 / 打开时的回调
        method registerClick(code func) {
            if (!this.isExist()) { return; }

            if (this.trClick != null) {
                DestroyTrigger(this.trClick);
                this.trClick = null;
            }

            if (func != null) {
                this.trClick = CreateTrigger();
                TriggerAddCondition(this.trClick, Condition(func));
            }
        }

        // 注册：关闭 / 取消选中时的回调
        method registerClose(code func) {
            if (!this.isExist()) { return; }

            if (this.trClose != null) {
                DestroyTrigger(this.trClose);
                this.trClose = null;
            }

            if (func != null) {
                this.trClose = CreateTrigger();
                TriggerAddCondition(this.trClose, Condition(func));
            }
        }

        // 迭代辅助：获取当前总数
        public static method getSize() -> integer {
            return thistype.size;
        }

        // 迭代辅助：按索引获取
        public static method getByIndex(integer idx) -> thistype {
            if (idx < 1 || idx > thistype.size) { return 0; }
            return thistype.list[idx];
        }

        // 回调参数：设置 / 获取 / 清理
        public static method setCallbackData(thistype md) {
            thistype.callbackData = md;
        }

        public static method getCallbackData() -> thistype {
            return thistype.callbackData;
        }

        public static method clearCallbackData() {
            thistype.callbackData = 0;
        }
    }

    //==========================================================================
    // UI 单例控制器：只负责 UI 框架和左侧按钮，右侧内容交给外部回调
    //==========================================================================
    public struct museumUI []{
        // 单例 UI 组件
        private static uiImage uiMain = 0;          // 主背景
        private static uiBtn   uiMainButton = 0;    // 主背景拖拽按钮
        private static uiImage uiCloseImage = 0;    // 右上角关闭图标
        private static uiBtn   uiCloseButton = 0;   // 右上角关闭按钮

        // 左侧分类按钮
        private static uiImage tabImage[];
        private static uiBtn   tabButton[];
        private static uiText  tabLabel[];
        private static uiImage tabIndicator = 0;    // 左侧选中标记（只创建一个，跟随当前选中 Tab）
        private static integer tabCount = 0;

        // 右侧内容区域与分隔线
        private static uiImage uiContentArea = 0;   // 供外部内容布局使用的区域
        private static uiImage uiDivider    = 0;    // 左侧 Tab 与右侧内容之间的竖线

        // 状态
        private static museumData currentAlbum   = 0; // 当前激活图鉴
        private static museumData lastAlbum      = 0; // 上一次激活图鉴（用于记忆）
        private static integer    currentTabIndex = 0; // 当前选中的 Tab 索引
        private static boolean    isOpen          = false;
        private static player     owner           = null;

        // 标题
        private static uiImage uiTitleBg   = 0;
        private static uiText  uiTitleText = 0;

        // Tooltip
        private static tooltip uiTooltipTemp = 0;

        // Esc 栈 ID
        private static integer escStackId = 0;

        // 内部工具：销毁所有左侧按钮
        private static method destroyTabs() {
            integer i;

            for (1 <= i <= tabCount) {
                if (tabLabel[i] != 0) {
                    tabLabel[i].destroy();
                    tabLabel[i] = 0;
                }

                if (tabButton[i] != 0) {
                    tabButton[i].destroy();
                    tabButton[i] = 0;
                }

                if (tabImage[i] != 0) {
                    tabImage[i].destroy();
                    tabImage[i] = 0;
                }
            }

            if (tabIndicator != 0) {
                tabIndicator.destroy();
                tabIndicator = 0;
            }

            tabCount = 0;
            currentTabIndex = 0;
        }

        // 内部工具：选中指定 Tab（带可选点击回调）
        private static method selectTab(museumData target, integer idx, boolean triggerClick) {
            integer i; real offsetY; real offsetX;
            museumData md;

            if (target == 0 || !target.isExist()) { return; }
            if (idx < 1 || idx > tabCount) { idx = 1; }

            // 如果点击的是当前已选中的 Tab，则不做任何处理，避免重复关闭/打开
            if (currentAlbum == target && currentTabIndex == idx) {
                return;
            }

            // 先调用当前图鉴 a 的关闭事件
            if (currentAlbum != 0 && currentAlbum.trClose != null) {
                museumData.setCallbackData(currentAlbum);
                TriggerEvaluate(currentAlbum.trClose);
                museumData.clearCallbackData();
            }

            currentAlbum    = target;
            lastAlbum       = target;
            currentTabIndex = idx;

            // 更新标题显示为当前选中的 Tab 名称
            if (uiTitleText != 0) {
                uiTitleText.setText(target.name);
            }

            // 更新左侧 Tab 高亮与位置
            for (1 <= i <= tabCount) {
                md = museumData.getByIndex(i);
                if (md != 0 && tabImage[i] != 0) {
                    // 计算纵向偏移：从主框架左上角往下排
                    offsetY = MUSEUM_TAB_START_Y - (i - 1) * (MUSEUM_TAB_HEIGHT + MUSEUM_TAB_GAP_Y);
                    offsetX = 0.015;
                    if (i == currentTabIndex) {
                        offsetX -= MUSEUM_TAB_SELECTED_OFFSET_X;
                    }

                    tabImage[i].exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, offsetX, offsetY);

                    // 文字颜色
                    if (tabLabel[i] != 0) {
                        if (i == currentTabIndex) {
                            tabLabel[i].setText(MUSEUM_TAB_COLOR_SELECTED + md.name + MUSEUM_COLOR_END);
                        } else {
                            tabLabel[i].setText(MUSEUM_TAB_COLOR_NORMAL + md.name + MUSEUM_COLOR_END);
                        }
                    }
                }
            }

            // 将单个选中标记移动到当前选中的 Tab 左侧
            if (tabIndicator != 0 && currentTabIndex >= 1 && currentTabIndex <= tabCount && tabImage[currentTabIndex] != 0) {
                tabIndicator.exRePoint(ANCHOR_RIGHT, tabImage[currentTabIndex].ui, ANCHOR_LEFT, -0.004, 0.0);
                tabIndicator.show(true);
            } else if (tabIndicator != 0) {
                tabIndicator.show(false);
            }

            // 触发点击回调，初始化右侧内容
            if (triggerClick && currentAlbum.trClick != null) {
                museumData.setCallbackData(currentAlbum);
                TriggerEvaluate(currentAlbum.trClick);
                museumData.clearCallbackData();
            }
        }

        // 供外部调用：打开 UI（单例，完全本地状态）
        public static method show(player p) {
            integer i; integer size; real offsetY;
            museumData md; museumData startAlbum;
            integer startIndex;

            // 仅在本地玩家为 p 时处理 UI 状态
            if (GetLocalPlayer() != p) { return; }

            if (isOpen) { return; }

            isOpen = true;
            owner  = p;

            size = museumData.getSize();

            // 计算初始选中图鉴（记忆上次，否则默认第一个）
            startAlbum = 0;
            startIndex = 0;

            if (lastAlbum != 0 && lastAlbum.isExist()) {
                startAlbum = lastAlbum;
                startIndex = lastAlbum.index;
            }

            if (startAlbum == 0) {
                if (size > 0) {
                    startAlbum = museumData.getByIndex(1);
                    startIndex = 1;
                }
            }

            uiMain = uiImage.create(DzGetGameUI())
                .setTexture("ui\\image\\black.blp")
                .exReSize(MUSEUM_MAIN_WIDTH, MUSEUM_MAIN_HEIGHT)
                .exRePoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0);

            // 主背景拖拽按钮
            uiMainButton = uiBtn.createBlank(uiMain.ui)
                .setAllPoint(uiMain.ui)
                .enableDrag(uiMain.ui, 0.25, 0.55, 0.32, 0.5)
                .setDragPosition(0.4, 0.25);

            // 中部标题（保持比例 465:48，基于高度宏常量计算宽度）
            uiTitleBg = uiImage.create(uiMain.ui)
                .exReSize(MUSEUM_TITLE_HEIGHT * MUSEUM_TITLE_WIDTH_RATIO, MUSEUM_TITLE_HEIGHT)
                .setTexture("ui\\image\\museum_title_465x48.blp")
                .exRePoint(ANCHOR_CENTER, uiMain.ui, ANCHOR_TOP, 0.0, MUSEUM_TITLE_OFFSET_Y);

            uiTitleText = uiText.create(uiTitleBg.ui)
                .setAllPoint(uiTitleBg.ui)
                .setAlign(4)
                .setFontSize(7)
                .setText(MUSEUM_TITLE_TEXT);

            // 右上角关闭按钮
            uiCloseImage = uiImage.create(uiMain.ui)
                .exReSize(0.026, 0.026)
                .setTexture("ui\\image\\select_close.blp")
                .exRePoint(ANCHOR_TOPRIGHT, uiMain.ui, ANCHOR_TOPRIGHT, -0.003, -0.003);

            uiCloseButton = uiBtn.create(uiCloseImage.ui)
                .setAllPoint(uiCloseImage.ui)
                .spEnter(function(integer frame) {
                    if (uiTooltipTemp != 0) {
                        uiTooltipTemp.destroy();
                        uiTooltipTemp = 0;
                    }
                    uiTooltipTemp = tooltip.create().layoutTitle("关闭界面|cffff9900(快捷键:Esc)|r");
                    uiTooltipTemp.setPoint(ANCHOR_BOTTOM, uiCloseImage.ui, ANCHOR_TOP, 0, 0.01);
                    music[MUSIC_INDEX_BTN_OVER_1].play();
                })
                .spLeave(function(integer frame) {
                    if (uiTooltipTemp != 0) {
                        uiTooltipTemp.destroy();
                        uiTooltipTemp = 0;
                    }
                })
                .spClick(function(integer frame) {
                    if (!isOpen) {
                        return;
                    }

                    music[MUSIC_INDEX_BTN_CLICK].play();

                    if (owner != null) {
                        museumUI.hide(owner);
                    } else {
                        museumUI.hide(GetLocalPlayer());
                    }
                });

            // 左侧按钮数量：受限于 MUSEUM_TAB_MAX_COUNT
            if (size > MUSEUM_TAB_MAX_COUNT) {
                tabCount = MUSEUM_TAB_MAX_COUNT;
            } else {
                tabCount = size;
            }

            // 左侧按钮从上到下排列
            for (1 <= i <= tabCount) {
                md = museumData.getByIndex(i);

                if (md != 0) {
                    // 计算纵向偏移：从主框架左上角往下排
                    offsetY = MUSEUM_TAB_START_Y - (i - 1) * (MUSEUM_TAB_HEIGHT + MUSEUM_TAB_GAP_Y);

                    tabImage[i] = uiImage.create(uiMain.ui)
                        .exReSize(MUSEUM_TAB_WIDTH, MUSEUM_TAB_HEIGHT)
                        .setTexture("ui\\image\\select_flash.blp")
                        .exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, 0.015, offsetY);

                    tabButton[i] = uiBtn.create(tabImage[i].ui)
                        .setAllPoint(tabImage[i].ui)
                        .spEnter(function(integer frame) {
                            music[MUSIC_INDEX_BTN_OVER_1].play();
                        })
                        .spClick(function(integer frame) {
                            museumData mdLocal; integer idx;

                            mdLocal = uiHashTable(frame).eventdata.get();
                            idx     = uiHashTable(frame).eventdata.get2();
                            if (mdLocal == 0 || !mdLocal.isExist()) {
                                return;
                            }

                            music[MUSIC_INDEX_BTN_CLICK].play();
                            museumUI.selectTab(mdLocal, idx, true);
                        });

                    uiHashTable(tabButton[i].ui).eventdata.bind(md);
                    uiHashTable(tabButton[i].ui).eventdata.bind2(i);

                    tabLabel[i] = uiText.create(tabImage[i].ui)
                        .setAllPoint(tabImage[i].ui)
                        .setAlign(4)
                        .setFontSize(6)
                        .setText(md.name);
                }
            }

            // 创建单个选中标记（初始隐藏，保持比例 101:72，高度 MUSEUM_TAB_HEIGHT 不变，计算宽度）
            if (tabCount > 0) {
                tabIndicator = uiImage.create(uiMain.ui)
                    .exReSize(MUSEUM_TAB_HEIGHT * 101.0 / 72.0, MUSEUM_TAB_HEIGHT)
                    .setTexture("ui\\image\\arrow_right_101x72.blp")
                    .exRePoint(ANCHOR_RIGHT, uiMain.ui, ANCHOR_TOPLEFT, 0.015 - 0.004, MUSEUM_TAB_START_Y);
                tabIndicator.show(false);
            }

            // 右侧内容区域：以 Tab 右侧 + 标题下方为左上起点，以整体右下角留出 0.005 边距为右下终点
            if (tabCount > 0) {
                uiContentArea = uiImage.create(uiMain.ui)
                    .setTexture(UI_STRING_PATH_BLANK)
                    .setPoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, 0.015 + MUSEUM_TAB_WIDTH + MUSEUM_CONTENT_MARGIN_X, MUSEUM_CONTENT_TOP_Y)
                    .setPoint(ANCHOR_BOTTOMRIGHT, uiMain.ui, ANCHOR_BOTTOMRIGHT, -MUSEUM_CONTENT_MARGIN_X, MUSEUM_CONTENT_MARGIN_Y);
            }

            // Tab 右侧的竖线分隔（位于 Tab 和 uiContentArea 之间的间隙内，高度基本和外框UI一样）
            if (tabCount > 0) {
                uiDivider = uiImage.create(uiMain.ui)
                    .exReSize(0.003, MUSEUM_MAIN_HEIGHT - 0.01 + MUSEUM_TAB_START_Y)
                    .setTexture("ui\\image\\vertical_divider.blp")
                    .exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, 0.015 + MUSEUM_TAB_WIDTH + MUSEUM_CONTENT_MARGIN_X / 2.0, MUSEUM_CONTENT_TOP_Y);
            }

            // 初次进入或重新打开时，自动选中一个 Tab
            if (tabCount > 0 && startAlbum != 0) {
                museumUI.selectTab(startAlbum, startIndex, true);
            }

            // 注册 ESC 关闭
            if (escStackId == 0) {
                escStackId = escStack.push(function(player p) {
                    museumUI.hide(p);
                });
            }
        }

        // 供外部调用：关闭 UI（会先触发当前图鉴的关闭回调，完全本地状态）
        public static method hide(player p) {
            // 仅在本地玩家为 p 时处理 UI 状态
            if (GetLocalPlayer() != p) { return; }

            if (!isOpen) { return; }

            // 先调用当前图鉴的关闭事件
            if (currentAlbum != 0 && currentAlbum.trClose != null) {
                museumData.setCallbackData(currentAlbum);
                TriggerEvaluate(currentAlbum.trClose);
                museumData.clearCallbackData();
            }

            currentAlbum = 0;

            // 销毁 UI
            destroyTabs();

            if (uiContentArea != 0) {
                uiContentArea.destroy();
                uiContentArea = 0;
            }

            if (uiDivider != 0) {
                uiDivider.destroy();
                uiDivider = 0;
            }

            if (uiCloseButton != 0) {
                uiCloseButton.destroy();
                uiCloseButton = 0;
            }

            if (uiCloseImage != 0) {
                uiCloseImage.destroy();
                uiCloseImage = 0;
            }

            if (uiMainButton != 0) {
                uiMainButton.destroy();
                uiMainButton = 0;
            }

            if (uiTitleText != 0) {
                uiTitleText.destroy();
                uiTitleText = 0;
            }

            if (uiTitleBg != 0) {
                uiTitleBg.destroy();
                uiTitleBg = 0;
            }

            if (uiTooltipTemp != 0) {
                uiTooltipTemp.destroy();
                uiTooltipTemp = 0;
            }

            if (uiMain != 0) {
                uiMain.destroy();
                uiMain = 0;
            }

            // 移除 ESC 栈
            if (escStackId != 0) {
                escStack.remove(escStackId);
                escStackId = 0;
            }

            owner = null;
            isOpen = false;
        }

        public static method getContentArea() -> uiImage {
            return uiContentArea;
        }

    }

    //==========================================================================
    // 对外接口
    //==========================================================================

    // 回调中获取当前触发的 museumData
    public function GetMuseumEventData() -> museumData {
        return museumData.getCallbackData();
    }
}

//! endzinc

#undef MUSEUM_MAIN_WIDTH
#undef MUSEUM_MAIN_HEIGHT
#undef MUSEUM_TAB_MAX_COUNT
#undef MUSEUM_TAB_WIDTH
#undef MUSEUM_TAB_HEIGHT
#undef MUSEUM_TAB_GAP_Y

#endif
