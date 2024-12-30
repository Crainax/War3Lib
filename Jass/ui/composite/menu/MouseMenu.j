#ifndef MouseMenuIncluded
#define MouseMenuIncluded

#define MOUSE_MENU_WIDTH 0.06
#define MOUSE_MENU_HEIGHT 0.03
#define MOUSE_MENU_MAX_ITEMS 20

#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j" // UI常量
#include "Crainax/input/constant/KeyConstants.j"


//! zinc


library MouseMenu requires UIButton, UIImage,UIBorder, UIText, UIExtendEvent,EscStack {

    public type menuEventFunc extends function(integer);

    public struct menuItem {
        uiBtn btn;
        uiText text;
        uiBorder background;
        uiImage highlight;
        integer index;
        mouseMenu parent;

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

            background = uiBorder.createType2(parentFrame);

            text = uiText.create(parentFrame)
                .setSizeFix(MOUSE_MENU_WIDTH, MOUSE_MENU_HEIGHT)
                .setAlign(3)
                .setText(title);

            background.setAllPoint(text.ui);

            highlight = uiImage.create(parentFrame)
                .setTexture("UI\\Widgets\\BattleNet\\bnet-button01-highlight-mouse.blp")
                .setAllPoint(background.ui)
                .show(false);


            btn = uiBtn.create(parentFrame)
                .setAllPoint(background.ui);

            return this;
        }
    }

    public struct mouseMenu {
        uiImage menuFrame;
        private {
            menuItem items[MOUSE_MENU_MAX_ITEMS];
            integer itemCount;
            boolean isUpward;
            real menuWidth;

            menuEventFunc onClickFunc;
            menuEventFunc onEnterFunc;
            menuEventFunc onLeaveFunc;

            static mouseMenu currentMenu = 0;
            static integer escStackId = 0;
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
            integer i = 1;
            if (!this.isExist()) { return false; }
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
            if (!this.isExist()) { return; }
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

        public method AddMenuItem(string title) -> thistype {
            integer anchorPoint;
            integer relativePoint;
            real offsetY;
            if (!this.isExist()) { return this; }

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


            items[itemCount].btn.spEnter(function(integer frame) {
                thistype this = uiHashTable(frame).eventdata.get2();
                integer index = uiHashTable(frame).eventdata.get();
                if (onEnterFunc != null) {
                    items[index].showHighlight(true);
                    onEnterFunc.evaluate(index);
                }
            })
                .spLeave(function(integer frame) {
                    thistype this = uiHashTable(frame).eventdata.get2();
                    integer index = uiHashTable(frame).eventdata.get();
                    if (onLeaveFunc != null) {
                        items[index].showHighlight(false);
                        onLeaveFunc.evaluate(index);
                    }
            })
                .spClick(function(integer frame) {
                    thistype this = uiHashTable(frame).eventdata.get2();
                    integer index = uiHashTable(frame).eventdata.get();
                    if (onClickFunc != null) {
                        onClickFunc.evaluate(index);
                    }
                currentMenu.show(false);
            });
            uiHashTable(items[itemCount].btn.ui).eventdata.bind(itemCount);
            uiHashTable(items[itemCount].btn.ui).eventdata.bind2(this);


            if (itemCount == 1) {
                // 同一个菜单项的两个anchor是一样的
                items[itemCount].background.setPoint(anchorPoint, menuFrame.ui, anchorPoint, 0, 0);
            } else {
                items[itemCount].background.setPoint(anchorPoint,
                items[itemCount - 1].background.ui,
                relativePoint, 0, offsetY);
            }

            menuFrame.setSizeFix(menuWidth, itemCount * MOUSE_MENU_HEIGHT);

            return this;
        }

        public static method create(integer parent, boolean isUpward, real width) -> thistype {
            thistype this = thistype.allocate();
            this.isUpward = isUpward;
            this.menuWidth = width;

            menuFrame = uiImage.create(parent)
                .setTexture(UI_STRING_PATH_BLANK)
                .setSizeFix(width, MOUSE_MENU_HEIGHT)
                .show(false);

            return this;
        }

        static method onInit() {
            hardware.regLeftUpEvent(function() {
                if (currentMenu.isExist() && !currentMenu.isInMenu(uiEventState.uiId)) {
                    currentMenu.show(false);
                }
            });

            keyboard.regKeyDownEvent(KEY_ESC, function() {
                if (currentMenu.isExist()) {
                    currentMenu.show(false);
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
                thistype.escStackId = escStack.push(function(player p) {
                    currentMenu.show(false);
                });
            }

            // 隐藏当前菜单时,需要清除引用
            if (!flag && this == currentMenu) {
                currentMenu = 0;
                if (thistype.escStackId != 0) {
                    escStack.remove(thistype.escStackId);
                    thistype.escStackId = 0;
                }
            }

            // 设置实际的显示/隐藏状态
            menuFrame.show(flag);
            return this;
        }
    }
}

//! endzinc
#endif

