#ifndef MouseMenuIncluded
#define MouseMenuIncluded

#define MOUSE_MENU_WIDTH 0.06
#define MOUSE_MENU_HEIGHT 0.03
#define MOUSE_MENU_MAX_ITEMS 20
#include "Crainax/config/SharedMethod.h"

library MouseMenu requires UIButton, UIImage, UIText, UIExtendEvent {

    public type menuEventFunc extends function(integer);

    private struct menuItem {
        private {
            uiText text = 0;
            uiImage background = 0;
            uiImage highlight = 0;
            uiBtn btn = 0;
            integer index = 0;
            mouseMenu parent = 0;
        }

        STRUCT_SHARED_METHODS(menuItem)


        method onDestroy () {
            if (text != 0) {
                text.destroy();
                text = 0;
            }
            if (btn != 0) {
                btn.destroy();
                btn = 0;
            }
            if (highlight != 0) {
                highlight.destroy();
                highlight = 0;
            }
            if (background != 0) {
                background.destroy();
                background = 0;
            }
            parent = 0;
        }

        public method showHighlight(boolean show) {
            if (highlight != 0) {
                highlight.show(show);
            }
        }

        public static method create(mouseMenu parent, string title, integer index, integer parentFrame) -> thistype {
            thistype this = thistype.allocate();
            this.parent = parent;
            this.index = index;

            background = uiImage.create(parentFrame)
                .setSizeFix(MOUSE_MENU_WIDTH, MOUSE_MENU_HEIGHT)
                .setTexture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp");

            highlight = uiImage.create(parentFrame)
                .setSizeFix(MOUSE_MENU_WIDTH, MOUSE_MENU_HEIGHT)
                .setTexture("UI\\Widgets\\EscMenu\\Human\\alliance-background-hover.blp")
                .setAllPoint(background.ui)
                .hide();

            text = uiText.create(parentFrame)
                .setAlign(TEXT_ALIGN_CENTER)
                .setText(title);

            btn = uiBtn.create(parentFrame)
                .setAllPoint(background.ui);

            return this;
        }
    }

    public struct mouseMenu {
        private {
            uiImage menuFrame = 0;
            menuItem items[MOUSE_MENU_MAX_ITEMS];
            integer itemCount = 0;
            boolean isUpward = false;

            menuEventFunc onClickFunc = null;
            menuEventFunc onEnterFunc = null;
            menuEventFunc onLeaveFunc = null;

            static mouseMenu currentMenu = 0;      // 当前显示的菜单实例
        }

        STRUCT_SHARED_METHODS(mouseMenu)

        private method getFirstItem() -> menuItem {
            if (items[1] == 0) {
                items[1] = menuItem.create(this, "", 1, menuFrame.ui);
                itemCount = 1;
            }
            return items[1];
        }

        method onClick(menuEventFunc func) -> thistype {
            if (!this.isExist()) { return this; }
            onClickFunc = func;
            return this;
        }

        method onEnter(menuEventFunc func) -> thistype {
            if (!this.isExist()) { return this; }
            onEnterFunc = func;
            return this;
        }

        method onLeave(menuEventFunc func) -> thistype {
            if (!this.isExist()) { return this; }
            onLeaveFunc = func;
            return this;
        }

        method isInMenu(integer checkUI) -> boolean {
            if (!this.isExist()) { return false; }
            integer i = 1;
            while (i <= itemCount) {
                if (items[i].isExist() && checkUI == items[i].btn.ui) {
                    return true;
                }
                i += 1;
            }
            return false;
        }

        static method isMouseIn() -> boolean {
            return currentMenu.isExist() && currentMenu.isInMenu(uiEventState.uiId);
        }

        method onDestroy() {
            integer i = 1;
            if (!this.isExist()) { return false; }
            if (menuFrame == 0) {
                return;
            }

            if (currentMenu == this) {
                currentMenu = 0;
            }

            while (i <= itemCount) {
                if (items[i] != 0) {
                    items[i].destroy();
                    items[i] = 0;
                }
                i += 1;
            }
            menuFrame.destroy();
            menuFrame   = 0;
            itemCount   = 0;
            onClickFunc = 0;
            onEnterFunc = 0;
            onLeaveFunc = 0;
        }

        public method AddMenuItem(string title, real width) -> thistype {
            if (!this.isExist()) { return this; }
            integer anchorPoint;
            integer relativePoint;
            real offsetY;
            thistype this = this;

            if (itemCount == 0) {
                getFirstItem();
            }

            itemCount += 1;
            if (itemCount >= MOUSE_MENU_MAX_ITEMS) {
                return this;
            }

            if (isUpward) {
                anchorPoint = ANCHOR_BOTTOM;
                relativePoint = ANCHOR_TOP;
                offsetY = 0;
            } else {
                anchorPoint = ANCHOR_TOP;
                relativePoint = ANCHOR_BOTTOM;
                offsetY = 0;
            }

            items[itemCount] = menuItem.create(this, title, itemCount, menuFrame.ui);

            uiHashTable(items[itemCount].btn.ui).eventdata.bind(itemCount);

            items[itemCount].btn.spEnter(function(integer frame) {
                integer index = uiHashTable(frame).eventdata.get();
                if (onEnterFunc != null) {
                    items[index].showHighlight(true);
                    onEnterFunc.evaluate(index);
                }
            })
                .spLeave(function(integer frame) {
                    integer index = uiHashTable(frame).eventdata.get();
                    if (onLeaveFunc != null) {
                        items[index].showHighlight(false);
                        onLeaveFunc.evaluate(index);
                    }
            })
                .spClick(function(integer frame) {
                    integer index = uiHashTable(frame).eventdata.get();
                    if (onClickFunc != null) {
                        onClickFunc.evaluate(index);
                    }
            });

            if (itemCount == 1) {
                // 第一个菜单项的两个anchor是一样的
                items[itemCount].background.setPoint(anchorPoint, menuFrame.ui, anchorPoint, 0, 0);
            } else {
                items[itemCount].background.setPoint(anchorPoint,
                items[itemCount - 1].background.ui,
                relativePoint, 0, offsetY);
            }

            menuFrame.setSizeFix(width, itemCount * MOUSE_MENU_HEIGHT);

            return this;
        }

        public static method create(integer parent, boolean isUpward) -> thistype {
            thistype this = thistype.allocate();
            isUpward = isUpward;

            menuFrame = uiImage.create(parent)
                .setTexture(UI_STRING_PATH_BLANK)
                .setSizeFix(MOUSE_MENU_WIDTH, MOUSE_MENU_HEIGHT)
                .hide();

            return this;
        }

        static method onInit() {
            hardware.regLeftUpEvent(function() {
                mouseMenu menu = DzGetTriggerUIUserData();
                if (menu != 0 && !menu.isInMenu(GetTriggerUI())) {
                    menu.destroy();
                }
            });

            keyboard.regKeyDownEvent(KEY_ESC, function() {
                mouseMenu menu = DzGetTriggerUIUserData();
                if (menu != 0) {
                    menu.destroy();
                }
            });
        }

        /**
         * 显示或隐藏菜单
         *
         * @param flag true显示,false隐藏
         * @return thistype 返回自身以支持链式调用
         *
         * 显示逻辑:
         * 1. 如果要显示且不是当前显示的菜单:
         *    - 会先隐藏当前显示的菜单(如果存在)
         *    - 将自己设置为当前显示的菜单
         *    - 显示自己
         *
         * 2. 如果要显示且已是当前菜单:
         *    - 直接显示自己
         *    - 不改变currentMenu引用
         *
         * 隐藏逻辑:
         * 1. 如果要隐藏且是当前显示的菜单:
         *    - 清除currentMenu引用
         *    - 隐藏自己
         *
         * 2. 如果要隐藏且不是当前菜单:
         *    - 直接隐藏自己
         *    - 不改变currentMenu引用
         *
         * 该实现确保了:
         * 1. 同时只能显示一个菜单
         * 2. 显示新菜单时会自动隐藏旧菜单
         * 3. 正确管理currentMenu引用
         */
        public method show(boolean flag) -> thistype {
            if (!this.isExist()) { return this; }

            // 显示新菜单时,需要处理当前显示的菜单
            if (flag && this != currentMenu) {
                // 如果已有显示的菜单,先隐藏它
                if (currentMenu.isExist()) {
                    currentMenu.show(false);
                }
                // 将自己设为当前显示的菜单
                currentMenu = this;
            }

            // 隐藏当前菜单时,需要清除引用
            if (!flag && this == currentMenu) {
                currentMenu = 0;
            }

            // 设置实际的显示/隐藏状态
            menuFrame.show(flag);
            return this;
        }
    }
}

#endif