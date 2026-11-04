#ifndef MouseMenuIncluded
#define MouseMenuIncluded
#define MOUSE_MENU_HEIGHT 0.026
#define MOUSE_MENU_MAX_ITEMS 20
#define MOUSE_MENU_ITEM_GAP 0.002
#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j"
//! zinc
//# dependency:resource/ui/image/buttongrow.blp
// Ordinary-frame menu only. Simple-frame legacy API lives in SimpleMouseMenu.j.
// Local presentation callbacks: no gameplay mutation or classic handle creation here.
library MouseMenu requires UIButton, UIImage, UIBorder, UIText, UIExtendEvent, UIExtendResize, EscStack {
    public type menuEventFunc extends function(integer);
    public struct menuItem {
        uiBtn btn;
        uiText text;
        uiBorder background;
        integer index;
        STRUCT_SHARED_METHODS(menuItem)
        method onDestroy() {
            if (btn != 0) { btn.destroy(); btn = 0; }
            if (text != 0) { text.destroy(); text = 0; }
            if (background != 0) { background.destroy(); background = 0; }
        }
        static method create(real width, string title, integer index, integer parentFrame) -> thistype {
            thistype this = thistype.allocate();
            this.index = index;
            background = uiBorder.createType2(parentFrame).exReSize(width, MOUSE_MENU_HEIGHT);
            text = uiText.create(parentFrame).setAlign(4)
                .setAllPoint(background.ui).setText(title);
            btn = uiBtn.create(parentFrame).setAllPoint(background.ui);
            return this;
        }
    }
    public struct mouseMenu {
        uiImage menuFrame;
        boolean autoDestroy;
        private menuItem items[21]; // 1..20; index zero is unused.
        private integer itemCount;
        private boolean isUpward;
        private boolean disposing;
        private uiImage highlight;
        private real menuWidth;
        private menuEventFunc onClickFunc;
        private menuEventFunc onEnterFunc;
        private menuEventFunc onLeaveFunc;
        private menuEventFunc onDestroyFunc;
        private integer escId;
        private static thistype currentMenu = 0;
        STRUCT_SHARED_METHODS(mouseMenu)

        method onClick(menuEventFunc func) -> thistype { if (this.isExist()) { onClickFunc = func; } return this; }
        method onEnter(menuEventFunc func) -> thistype { if (this.isExist()) { onEnterFunc = func; } return this; }
        method onLeave(menuEventFunc func) -> thistype { if (this.isExist()) { onLeaveFunc = func; } return this; }
        method listenDestroy(menuEventFunc func) -> thistype { if (this.isExist()) { onDestroyFunc = func; } return this; }
        method setAutoDestroy(boolean flag) -> thistype { if (this.isExist()) { autoDestroy = flag; } return this; }
        method getItemCount() -> integer { if (!this.isExist()) { return 0; } return itemCount; }
        method isShown() -> boolean { return this.isExist() && currentMenu == this && !disposing; }
        method getHeight() -> real {
            if (!this.isExist() || itemCount == 0) { return MOUSE_MENU_HEIGHT; }
            return itemCount * MOUSE_MENU_HEIGHT + (itemCount - 1) * MOUSE_MENU_ITEM_GAP;
        }
        method isInMenu(integer checkUI) -> boolean {
            integer i = 1;
            if (!this.isExist() || disposing) { return false; }
            // Include the panel and decorative children so a border click is not an outside click.
            if (checkUI == menuFrame.ui || checkUI == highlight.ui) { return true; }
            while (i <= itemCount) {
                if (items[i].isExist() && (checkUI == items[i].btn.ui || checkUI == items[i].text.ui || checkUI == items[i].background.ui)) { return true; }
                i += 1;
            }
            return false;
        }
        static method isMouseIn() -> boolean { return currentMenu.isExist() && currentMenu.isInMenu(DzGetMouseFocus()); }
        private method detach() {
            if (currentMenu == this) { currentMenu = 0; }
            if (escId != 0) { escStack.remove(escId); escId = 0; }
            if (highlight != 0) { highlight.show(false); }
            if (menuFrame != 0) { menuFrame.show(false); }
        }
        method onDestroy() {
            integer i = 1;
            menuEventFunc callback = onDestroyFunc;
            if (disposing) { return; }
            disposing = true;
            onDestroyFunc = 0;
            onClickFunc = 0;
            onEnterFunc = 0;
            onLeaveFunc = 0;
            this.detach();
            // Destruction may synthesize leave events. The disposing guard suppresses reentry.
            while (i <= itemCount) {
                if (items[i] != 0) { items[i].destroy(); items[i] = 0; }
                i += 1;
            }
            itemCount = 0;
            if (highlight != 0) { highlight.destroy(); highlight = 0; }
            if (menuFrame != 0) { menuFrame.destroy(); menuFrame = 0; }
            autoDestroy = false;
            if (callback != 0) { callback.evaluate(0); }
        }
        method clear() -> thistype {
            integer i = 1;
            if (!this.isExist() || disposing) { return this; }
            this.detach();
            // Guard callbacks while removing children; clear retains the menu itself.
            disposing = true;
            while (i <= itemCount) { items[i].destroy(); items[i] = 0; i += 1; }
            itemCount = 0;
            disposing = false;
            menuFrame.exReSize(menuWidth, MOUSE_MENU_HEIGHT);
            return this;
        }
        method show(boolean flag) -> thistype {
            thistype old;
            if (!this.isExist() || disposing) { return this; }
            if (!flag) {
                this.detach();
                if (autoDestroy) { this.destroy(); }
                return this;
            }
            if (itemCount == 0) { return this; }
            if (currentMenu != this) {
                old = currentMenu;
                if (old.isExist()) { old.show(false); }
                // A destroy callback may have opened another menu. Detach that menu without
                // firing another destroy callback, then let the explicit show win.
                if (currentMenu.isExist() && currentMenu != this) { currentMenu.detach(); }
                if (!this.isExist() || disposing) { return this; }
                currentMenu = this;
                escId = escStack.push(function(player p) {
                    thistype target = currentMenu;
                    if (target.isExist()) {
                        target.escId = 0; // pop already removed this entry.
                        target.show(false);
                    }
                });
            }
            menuFrame.show(true);
            return this;
        }
        // x/y are actual UI coordinates. Upward menus use a bottom-left origin;
        // downward menus use a top-left origin. Translate at screen edges, never flip direction.
        method showAt(real x, real y) -> thistype {
            real width = menuWidth * GetResizeRate();
            real height = this.getHeight();
            if (!this.isExist() || disposing) { return this; }
            if (x + width > 0.795) { x = 0.795 - width; }
            if (x < 0.005) { x = 0.005; }
            if (isUpward) {
                if (y + height > 0.595) { y = 0.595 - height; }
                if (y < 0.005) { y = 0.005; }
                menuFrame.clearPoint().setAbsPoint(ANCHOR_BOTTOMLEFT, x, y);
            } else {
                if (y - height < 0.005) { y = 0.005 + height; }
                if (y > 0.595) { y = 0.595; }
                menuFrame.clearPoint().setAbsPoint(ANCHOR_TOPLEFT, x, y);
            }
            return this.show(true);
        }
        private method highlightItem(integer index) {
            if (index > 0 && index <= itemCount) { highlight.clearPoint().setAllPoint(items[index].background.ui).show(true); }
            else { highlight.show(false); }
        }
        static method enter(integer frame) {
            thistype this = uiHashTable(frame).eventdata.get2();
            integer index = uiHashTable(frame).eventdata.get();
            if (!this.isShown()) { return; }
            this.highlightItem(index);
            if (onEnterFunc != 0) { onEnterFunc.evaluate(index); }
        }
        static method leave(integer frame) {
            thistype this = uiHashTable(frame).eventdata.get2();
            integer index = uiHashTable(frame).eventdata.get();
            if (!this.isShown()) { return; }
            this.highlightItem(0);
            if (onLeaveFunc != 0) { onLeaveFunc.evaluate(index); }
        }
        static method click(integer frame) {
            thistype this = uiHashTable(frame).eventdata.get2();
            integer index = uiHashTable(frame).eventdata.get();
            menuEventFunc callback = 0;
            if (!this.isShown() || index < 1 || index > itemCount) { return; }
            callback = onClickFunc;
            this.show(false); // Close this menu BEFORE a callback can open its successor.
            if (callback != 0) { callback.evaluate(index); }
        }
        method AddMenuItem(string title) -> thistype {
            integer index;
            if (!this.isExist() || disposing || itemCount >= MOUSE_MENU_MAX_ITEMS) { return this; }
            itemCount += 1;
            index = itemCount;
            items[index] = menuItem.create(menuWidth, title, index, menuFrame.ui);
            if (isUpward) {
                items[index].background.setPoint(ANCHOR_BOTTOM, menuFrame.ui, ANCHOR_BOTTOM, 0,
                    (index - 1) * (MOUSE_MENU_HEIGHT + MOUSE_MENU_ITEM_GAP));
            } else {
                items[index].background.setPoint(ANCHOR_TOP, menuFrame.ui, ANCHOR_TOP, 0,
                    -(index - 1) * (MOUSE_MENU_HEIGHT + MOUSE_MENU_ITEM_GAP));
            }
            uiHashTable(items[index].btn.ui).eventdata.bind(index);
            uiHashTable(items[index].btn.ui).eventdata.bind2(this);
            items[index].btn.spEnter(uiEvent.MouseMenuEnter).spLeave(uiEvent.MouseMenuLeave).spClick(uiEvent.MouseMenuClick);
            menuFrame.exReSize(menuWidth, this.getHeight());
            return this;
        }
        static method create(integer parent, boolean upward, real width) -> thistype {
            thistype this = thistype.allocate();
            integer i = 1;
            if (width < 0.03) { width = 0.03; }
            if (width > 0.7) { width = 0.7; }
            isUpward = upward;
            menuWidth = width;
            autoDestroy = false;
            disposing = false;
            itemCount = 0;
            escId = 0;
            onClickFunc = 0; onEnterFunc = 0; onLeaveFunc = 0; onDestroyFunc = 0;
            while (i <= MOUSE_MENU_MAX_ITEMS) { items[i] = 0; i += 1; }
            menuFrame = uiImage.create(parent).setTexture(UI_STRING_PATH_BLANK).exReSize(width, MOUSE_MENU_HEIGHT).show(false);
            highlight = uiImage.create(menuFrame.ui).setTexture("ui\\image\\buttongrow.blp").show(false);
            return this;
        }
        static method onInit() {
            hardware.regLeftUpEvent(function() {
                if (currentMenu.isExist() && !currentMenu.isInMenu(DzGetMouseFocus())) { currentMenu.show(false); }
            });
        }
    }
    public function MouseMenuEnter(integer frame) { mouseMenu.enter(frame); }
    public function MouseMenuLeave(integer frame) { mouseMenu.leave(frame); }
    public function MouseMenuClick(integer frame) { mouseMenu.click(frame); }
}
//! endzinc
#endif
