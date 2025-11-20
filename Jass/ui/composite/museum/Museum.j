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
#define MUSEUM_MAIN_HEIGHT     0.36   // 主 UI 高

#define MUSEUM_TAB_MAX_COUNT       20     // 左侧最多可显示的图鉴分类数量
#define MUSEUM_TAB_WIDTH           0.077  // 左侧按钮宽度（缩小约 30%）
#define MUSEUM_TAB_HEIGHT          0.018  // 左侧按钮高度（缩小约 30%）
#define MUSEUM_TAB_GAP_Y           0.004  // 左侧按钮纵向间距
#define MUSEUM_TAB_SELECTED_OFFSET_X 0.008 // 选中时整体左移偏移

#define MUSEUM_TITLE_TEXT          "异度图鉴"
#define MUSEUM_TAB_COLOR_NORMAL    "|cFFFFFFFF"
#define MUSEUM_TAB_COLOR_SELECTED  "|cFFFFCC00"
#define MUSEUM_COLOR_END           "|r"

//# dependency:resource/ui/image/select_flash.blp
//# dependency:resource/ui/image/black.blp
//# dependency:resource/ui/image/select_close.blp
//# dependency:resource/ui/image/select_right.blp


library Museum requires Music,Icon {

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
        private static uiImage tabIndicator[];      // 左侧选中标记
        private static integer tabCount = 0;

        // 状态
        private static museumData currentAlbum   = 0; // 当前激活图鉴
        private static museumData lastAlbum      = 0; // 上一次激活图鉴（用于记忆）
        private static integer    currentTabIndex = 0; // 当前选中的 Tab 索引
        private static boolean    isOpen          = false;
        private static player     owner           = null;

        // 标题
        private static uiImage uiTitleBg = 0;
        private static uiText  uiTitleText = 0;

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

                if (tabIndicator[i] != 0) {
                    tabIndicator[i].destroy();
                    tabIndicator[i] = 0;
                }
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

            // 更新左侧 Tab 高亮与位置
            for (1 <= i <= tabCount) {
                md = museumData.getByIndex(i);
                if (md != 0 && tabImage[i] != 0) {
                    // 计算纵向偏移：从主框架左上角往下排
                    offsetY = -0.045 - (i - 1) * (MUSEUM_TAB_HEIGHT + MUSEUM_TAB_GAP_Y);
                    offsetX = 0.015;
                    if (i == currentTabIndex) {
                        offsetX -= MUSEUM_TAB_SELECTED_OFFSET_X;
                    }

                    tabImage[i].exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, offsetX, offsetY);

                    // 选中标记显示/隐藏
                    if (tabIndicator[i] != 0) {
                        tabIndicator[i].show(i == currentTabIndex);
                    }

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
                .enableDrag(uiMain.ui, 0.25, 0.55, 0.3, 0.5)
                .setDragPosition(0.4, 0.25);

            // 中部标题
            uiTitleBg = uiImage.create(uiMain.ui)
                .exReSize(0.22, 0.032)
                .setTexture("ui\\image\\black11.blp")
                .exRePoint(ANCHOR_CENTER, uiMain.ui, ANCHOR_TOP, 0.0, -0.02);

            uiTitleText = uiText.create(uiTitleBg.ui)
                .setAllPoint(uiTitleBg.ui)
                .setAlign(4)
                .setFontSize(7)
                .setText(MUSEUM_TITLE_TEXT);

            // 右上角关闭按钮
            uiCloseImage = uiImage.create(uiMain.ui)
                .exReSize(0.029, 0.029)
                .setTexture("ui\\image\\select_close.blp")
                .exRePoint(ANCHOR_TOPRIGHT, uiMain.ui, ANCHOR_TOPRIGHT, -0.005, -0.005);

            uiCloseButton = uiBtn.create(uiCloseImage.ui)
                .setAllPoint(uiCloseImage.ui)
                .spClick(function(integer frame) {
                    if (!isOpen) {
                        return;
                    }

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
                    offsetY = -0.045 - (i - 1) * (MUSEUM_TAB_HEIGHT + MUSEUM_TAB_GAP_Y);

                    tabImage[i] = uiImage.create(uiMain.ui)
                        .exReSize(MUSEUM_TAB_WIDTH, MUSEUM_TAB_HEIGHT)
                        .setTexture("ui\\image\\select_flash.blp")
                        .exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, 0.015, offsetY);

                    tabButton[i] = uiBtn.create(tabImage[i].ui)
                        .setAllPoint(tabImage[i].ui)
                        .spClick(function(integer frame) {
                            museumData mdLocal; integer idx;

                            mdLocal = uiHashTable(frame).eventdata.get();
                            idx     = uiHashTable(frame).eventdata.get2();
                            if (mdLocal == 0 || !mdLocal.isExist()) {
                                return;
                            }

                            museumUI.selectTab(mdLocal, idx, true);
                        });

                    uiHashTable(tabButton[i].ui).eventdata.bind(md);
                    uiHashTable(tabButton[i].ui).eventdata.bind2(i);

                    tabLabel[i] = uiText.create(tabImage[i].ui)
                        .setAllPoint(tabImage[i].ui)
                        .setAlign(4)
                        .setFontSize(6)
                        .setText(md.name);

                    // 左侧选中标记（初始隐藏）
                    tabIndicator[i] = uiImage.create(uiMain.ui)
                        .exReSize(MUSEUM_TAB_WIDTH * 0.4, MUSEUM_TAB_HEIGHT)
                        .setTexture("ui\\image\\select_right.blp")
                        .exRePoint(ANCHOR_RIGHT, tabImage[i].ui, ANCHOR_LEFT, -0.004, 0.0);
                    tabIndicator[i].show(false);
                }
            }

            // 初次进入或重新打开时，自动选中一个 Tab
            if (tabCount > 0 && startAlbum != 0) {
                museumUI.selectTab(startAlbum, startIndex, true);
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

            if (uiMain != 0) {
                uiMain.destroy();
                uiMain = 0;
            }

            owner = null;
            isOpen = false;
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
