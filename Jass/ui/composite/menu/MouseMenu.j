#ifndef MouseMenuIncluded
#define MouseMenuIncluded

#define MOUSE_MENU_HEIGHT        0.03
#define MOUSE_MENU_MAX_ITEMS     20
#define MOUSE_MENU_ITEM_GAP      -0.003
#define MOUSE_MENU_SIMPLE_PARENT uilayer.lv[2]

#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j" // UI常量
#include "Crainax/input/constant/KeyConstants.j"


//! zinc

//# dependency:resource/ui/image/buttongrow.blp

library MouseMenu requires UIButton, UIImage,UIBorder, UIText, UIExtendEvent,EscStack {

    public type menuEventFunc extends function(integer);

    public struct menuItem {
        uiBtn btn;
        uiText text;
        uiBorder background;
        integer index;

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
            if (background != 0) {
                background.destroy();
                background = 0;
            }
        }

        // 非原生菜单项
        public static method create(real width,string title, integer index, integer parentFrame) -> thistype {
            thistype this = thistype.allocate();
            this.index = index;

            background = uiBorder.createType2(parentFrame)
                .exReSize(width, MOUSE_MENU_HEIGHT);

            text = uiText.create(parentFrame)
                .setAlign(4)
                .exRePoint(ANCHOR_LEFT,background.ui,ANCHOR_LEFT,0.015,0)
                .setText(title);

            btn = uiBtn.create(parentFrame)
                .setAllPoint(background.ui);

            return this;
        }

        // 原生菜单项
        public static method createSimple(real width,string title, integer index, integer simpleParent,integer parentFrame) -> thistype {
            thistype this = thistype.allocate();
            this.index = index;

            background = uiBorder.createType2(parentFrame)
                .exReSize(width, MOUSE_MENU_HEIGHT); // 这个不动态

            text = uiText.create(parentFrame)
                .setAlign(4)
                .exRePoint(ANCHOR_LEFT,background.ui,ANCHOR_LEFT,0.015,0)
                .setText(title);

            btn = uiBtn.createSimple(simpleParent)
                .setAllPoint(background.ui);

            return this;
        }

    }

    public struct mouseMenu {
        uiImage menuFrame;
        boolean autoDestroy;
        private {
            menuItem items[MOUSE_MENU_MAX_ITEMS];
            integer itemCount;
            boolean isUpward;
            uiImage highlight;
            real menuWidth;

            menuEventFunc onClickFunc;
            menuEventFunc onEnterFunc;
            menuEventFunc onLeaveFunc;

            static mouseMenu currentMenu = 0;
            static integer escStackId = 0;

            //用于Simple菜单的父级
            integer simpleParent;
        }

        STRUCT_SHARED_METHODS(mouseMenu)

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

            while (i <= MOUSE_MENU_MAX_ITEMS) {
                if (items[i].isExist()) {
                    items[i].destroy();
                    items[i] = 0;
                }
                i += 1;
            }

            if (highlight != 0) {
                highlight.destroy();
                highlight = 0;
            }

            menuFrame.destroy();
            menuFrame    = 0;
            itemCount    = 0;
            onClickFunc  = 0;
            onEnterFunc  = 0;
            onLeaveFunc  = 0;
            simpleParent = 0;
            autoDestroy  = false;
        }

        // 显示高亮UI
        private method showHighlight(integer index) {
            if (highlight.isExist()) {
                if (index > 0 && index <= itemCount) {
                    highlight.clearPoint()
                        .setAllPoint(items[index].background.ui)
                        .show(true);
                } else {
                    highlight.show(false);
                }
            }

        }



        // 清除Simple菜单
        public method clear() -> thistype {
            integer i = 1;
            if (!this.isExist()) { return this; }

            // 将所有已创建的菜单项移到屏幕外
            while (i <= MOUSE_MENU_MAX_ITEMS) {
                if (items[i].isExist()) {
                    items[i].background.clearPoint()
                        .setPoint(ANCHOR_TOPLEFT,DzGetGameUI(),ANCHOR_TOPLEFT, -0.8, -0.6);
                }
                i += 1;
            }

            // 重置计数但不销毁items
            itemCount = 0;
            // 重置菜单框大小
            menuFrame.exReSize(menuWidth, MOUSE_MENU_HEIGHT);
            return this;
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

            // 隐藏当前菜单时的处理
            if (!flag && this == currentMenu) {
                currentMenu = 0;
                if (thistype.escStackId != 0) {
                    escStack.remove(thistype.escStackId);
                    thistype.escStackId = 0;
                }

                // 如果是Simple菜单，则执行clear操作
                if (simpleParent != 0) {
                    this.clear();
                }
                // 如果设置了自动销毁，则销毁菜单
                else if (this.autoDestroy) {
                    this.destroy();
                    return this;
                }
            }

            // 设置实际的显示/隐藏状态
            menuFrame.show(flag);
            return this;
        }

        public method AddMenuItem(string title) -> thistype {
            integer anchorPoint;
            integer relativePoint;
            real offsetY;
            if (!this.isExist()) { return this; }

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

            items[itemCount] = menuItem.create(menuWidth ,title, itemCount, menuFrame.ui);

            if (itemCount == 1) {
                if (isUpward) {
                    items[itemCount].background.setPoint(ANCHOR_BOTTOM, menuFrame.ui, ANCHOR_BOTTOM, 0, 0);
                } else {
                    items[itemCount].background.setPoint(ANCHOR_TOP, menuFrame.ui, ANCHOR_TOP, 0, 0);
                }
            } else {
                if (isUpward) {
                    items[itemCount].background.setPoint(ANCHOR_BOTTOM,
                    items[itemCount - 1].background.ui,
                    ANCHOR_TOP, 0, MOUSE_MENU_ITEM_GAP);
                } else {
                    items[itemCount].background.setPoint(ANCHOR_TOP,
                    items[itemCount - 1].background.ui,
                    ANCHOR_BOTTOM, 0, -MOUSE_MENU_ITEM_GAP);
                }
            }

            items[itemCount].btn.spEnter(function(integer frame) {
                thistype this = uiHashTable(frame).eventdata.get2();
                integer index = uiHashTable(frame).eventdata.get();
                if (onEnterFunc != null) {
                    this.showHighlight(index);
                    onEnterFunc.evaluate(index);
                }
            })
                .spLeave(function(integer frame) {
                    thistype this = uiHashTable(frame).eventdata.get2();
                    integer index = uiHashTable(frame).eventdata.get();
                    if (onLeaveFunc != null) {
                        this.showHighlight(0);
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

            menuFrame.exReSize(menuWidth,
            itemCount * MOUSE_MENU_HEIGHT + (itemCount - 1) * MOUSE_MENU_ITEM_GAP);

            return this;
        }

        public static method create(integer parent, boolean isUpward, real width) -> thistype {
            thistype this = thistype.allocate();
            this.isUpward = isUpward;
            this.menuWidth = width;
            this.autoDestroy = false;
            this.itemCount = 0;
            this.simpleParent = 0;

            menuFrame = uiImage.create(parent)
                .setTexture(UI_STRING_PATH_BLANK)
                .exReSize(width, MOUSE_MENU_HEIGHT)
                .show(false);

            highlight = uiImage.create(parent)
                .setTexture("ui\\image\\buttongrow.blp")
                .show(false);

            return this;
        }

        // 原生菜单
        public static method createSimple(integer simpleParent, boolean isUpward, real width) -> thistype {
            thistype this = thistype.allocate();
            this.isUpward = isUpward;
            this.menuWidth = width;
            this.autoDestroy = false;
            this.simpleParent = simpleParent;
            this.itemCount = 0;
            this.highlight = 0;

            menuFrame = uiImage.create(MOUSE_MENU_SIMPLE_PARENT)
                .setTexture(UI_STRING_PATH_BLANK)
                .exReSize(width, MOUSE_MENU_HEIGHT)
                .show(false);

            highlight = uiImage.create(DzGetGameUI())
                .setTexture("ui\\image\\buttongrow.blp")
                .show(false);

            return this;
        }

        static method onInit() {
            //点击菜单以外的地方就隐藏菜单
            hardware.regLeftUpEvent(function() {
                if (currentMenu.isExist() && !currentMenu.isInMenu(uiEventState.uiId)) {
                    currentMenu.show(false);
                }
            });
        }


        // 设置是否自动销毁
        public method setAutoDestroy(boolean flag) -> thistype {
            this.autoDestroy = flag;
            return this;
        }

        public method AddMenuSimpleItem(string title) -> thistype {
            integer anchorPoint;
            integer relativePoint;
            real offsetY;
            if (!this.isExist()) { return this; }

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

            // 检查是否已存在该索引的菜单项
            if (!items[itemCount].isExist()) {
                // 不存在则创建新的
                items[itemCount] = menuItem.createSimple(menuWidth, title, itemCount, simpleParent,menuFrame.ui);
            } else {
                // 存在则更新文本和位置
                items[itemCount].text.setText(title);
            }

            // 设置位置
            if (itemCount == 1) {
                if (isUpward) {
                    items[itemCount].background.clearPoint()
                        .setPoint(ANCHOR_BOTTOM, menuFrame.ui, ANCHOR_BOTTOM, 0, 0);
                } else {
                    items[itemCount].background.clearPoint()
                        .setPoint(ANCHOR_TOP, menuFrame.ui, ANCHOR_TOP, 0, 0);
                }
            } else {
                if (isUpward) {
                    items[itemCount].background.clearPoint()
                        .setPoint(ANCHOR_BOTTOM, items[itemCount - 1].background.ui, ANCHOR_TOP, 0, MOUSE_MENU_ITEM_GAP);
                } else {
                    items[itemCount].background.clearPoint()
                        .setPoint(ANCHOR_TOP, items[itemCount - 1].background.ui, ANCHOR_BOTTOM, 0, -MOUSE_MENU_ITEM_GAP);
                }
            }

            // 更新事件处理
            if (items[itemCount].btn.ui != 0) {
                items[itemCount].btn.spEnter(function(integer frame) {
                    thistype this = uiHashTable(frame).eventdata.get2();
                    integer index = uiHashTable(frame).eventdata.get();
                    if (onEnterFunc != null) {
                        this.showHighlight(index);
                        onEnterFunc.evaluate(index);
                    }
                })
                    .spLeave(function(integer frame) {
                        thistype this = uiHashTable(frame).eventdata.get2();
                        integer index = uiHashTable(frame).eventdata.get();
                        if (onLeaveFunc != null) {
                            this.showHighlight(0);
                            onLeaveFunc.evaluate(index);
                        }
                })
                    .spClick(function(integer frame) {
                        thistype this = uiHashTable(frame).eventdata.get2();
                        integer index = uiHashTable(frame).eventdata.get();
                        if (onClickFunc != null) {
                            onClickFunc.evaluate(index);
                        }
                    // Simple菜单点击后使用show(false)，会自动调用clear
                    currentMenu.show(false);
                });
                uiHashTable(items[itemCount].btn.ui).eventdata.bind(itemCount);
                uiHashTable(items[itemCount].btn.ui).eventdata.bind2(this);
            }

            menuFrame.exReSize(menuWidth, itemCount * MOUSE_MENU_HEIGHT + (itemCount - 1) * MOUSE_MENU_ITEM_GAP);

            return this;
        }
    }
}

//! endzinc
#endif

