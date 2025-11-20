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

#define MUSEUM_MAIN_WIDTH      0.40   // 主 UI 宽
#define MUSEUM_MAIN_HEIGHT     0.28   // 主 UI 高

#define MUSEUM_TAB_MAX_COUNT   20     // 左侧最多可显示的图鉴分类数量
#define MUSEUM_TAB_WIDTH       0.11   // 左侧按钮宽度
#define MUSEUM_TAB_HEIGHT      0.026  // 左侧按钮高度
#define MUSEUM_TAB_GAP_Y       0.004  // 左侧按钮纵向间距

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
        private static uiImage uiCloseImage = 0;    // 右上角关闭图标
        private static uiBtn   uiCloseButton = 0;   // 右上角关闭按钮

        // 左侧分类按钮
        private static uiImage tabImage[];
        private static uiBtn   tabButton[];
        private static uiText  tabLabel[];
        private static integer tabCount = 0;

        // 状态
        private static museumData currentAlbum = 0; // 当前激活图鉴
        private static boolean    isOpen       = false;
        private static player     owner        = null;

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

            tabCount = 0;
        }

        // 供外部调用：打开 UI（单例，完全本地状态）
        public static method show(player p) {
            integer i; integer size; real offsetY;
            museumData md;

            // 仅在本地玩家为 p 时处理 UI 状态
            if (GetLocalPlayer() != p) { return; }

            if (isOpen) { return; }

            isOpen = true;
            owner  = p;

            size = museumData.getSize();

            uiMain = uiImage.create(DzGetGameUI())
                .setTexture("ui\\image\\bg_select.blp")
                .exReSize(MUSEUM_MAIN_WIDTH, MUSEUM_MAIN_HEIGHT)
                .exRePoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0);

            // 右上角关闭按钮
            uiCloseImage = uiImage.create(uiMain.ui)
                .exReSize(0.029, 0.029)
                .setTexture("ui\\image\\select_close.blp")
                .exRePoint(ANCHOR_TOPRIGHT, uiMain.ui, ANCHOR_TOPRIGHT, -0.015, -0.015);

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
                            museumData mdLocal;

                            mdLocal = uiHashTable(frame).eventdata.get();
                            if (mdLocal == 0 || !mdLocal.isExist()) {
                                return;
                            }

                            // 先调用当前图鉴 a 的关闭事件
                            if (currentAlbum != 0 && currentAlbum.trClose != null) {
                                museumData.setCallbackData(currentAlbum);
                                TriggerEvaluate(currentAlbum.trClose);
                                museumData.clearCallbackData();
                            }

                            // 再切换为新的图鉴 b，并调用其点击事件
                            currentAlbum = mdLocal;

                            if (currentAlbum.trClick != null) {
                                museumData.setCallbackData(currentAlbum);
                                TriggerEvaluate(currentAlbum.trClick);
                                museumData.clearCallbackData();
                            }
                        });

                    uiHashTable(tabButton[i].ui).eventdata.bind(md);

                    tabLabel[i] = uiText.create(tabImage[i].ui)
                        .setAllPoint(tabImage[i].ui)
                        .setAlign(4)
                        .setFontSize(7)
                        .setText(md.name);
                }
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
