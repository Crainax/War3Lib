#ifndef MouseMenuIncluded
#define MouseMenuIncluded
#define MOUSE_MENU_HEIGHT 0.026
#define MOUSE_MENU_MAX_ITEMS 20
#define MOUSE_MENU_PADDING 0.004
#define MOUSE_MENU_CORNER 0.008
#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j"
//! zinc
//# dependency:resource/ui/menu/mouse-menu-0.blp
//# dependency:resource/ui/menu/mouse-menu-1.blp
//# dependency:resource/ui/menu/mouse-menu-2.blp
//# dependency:resource/ui/menu/mouse-menu-3.blp
//# dependency:resource/ui/menu/mouse-menu-4.blp
//# dependency:resource/ui/menu/mouse-menu-5.blp
//# dependency:resource/ui/menu/mouse-menu-6.blp
//# dependency:resource/ui/menu/mouse-menu-7.blp
//# dependency:resource/ui/menu/mouse-menu-8.blp
//# dependency:resource/ui/menu/mouse-menu-hover.blp
//# dependency:resource/ui/menu/mouse-menu-separator.blp
// Ordinary-frame menu only. Simple-frame legacy API lives in SimpleMouseMenu.j.
// Local presentation callbacks: no gameplay mutation or classic handle creation here.
library MouseMenu requires UIButton, UIImage, UIText, UIExtendEvent, UIExtendResize, EscStack {
    public type menuEventFunc extends function(integer);
    public struct menuItem {
        uiBtn btn;
        uiText text;
        uiImage background;
        uiImage separator;
        STRUCT_SHARED_METHODS(menuItem)
        method onDestroy() {
            if (text != 0) { text.destroy(); text = 0; }
            if (btn != 0) { btn.destroy(); btn = 0; }
            if (separator != 0) { separator.destroy(); separator = 0; }
            if (background != 0) { background.destroy(); background = 0; }
        }
        static method create(real width, string title, integer parentFrame) -> thistype {
            thistype this = thistype.allocate();
            // Layout anchor only; keep it transparent so it cannot cover the shared hover image.
            background = uiImage.create(parentFrame).setTexture(UI_STRING_PATH_BLANK).setAlpha(0).exReSize(width, MOUSE_MENU_HEIGHT);
            separator = uiImage.create(parentFrame).setTexture("ui\\menu\\mouse-menu-separator.blp")
                .exReSize(width, 0.0006).setPoint(ANCHOR_TOP, background.ui, ANCHOR_TOP, 0, 0).show(false);
            // Preserve the original default ordering; forcing BACKDROP priority can cover TEXT.
            text = uiText.create(parentFrame).setAlign(4).setAllPoint(background.ui).setText(title);
            btn = uiBtn.createBlank(parentFrame).setAllPoint(background.ui);
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
        private integer hoveredIndex;
        private integer hoverRevision; // Retained across allocation reuse; invalidates callback continuations.
        private uiImage skin[9]; // row-major nine-slice; corners never stretch.
        private real menuWidth;
        private menuEventFunc onClickFunc;
        private menuEventFunc onEnterFunc;
        private menuEventFunc onLeaveFunc;
        private menuEventFunc onDestroyFunc;
        private integer escId;
        private static thistype currentMenu = 0;
        // Closing/clearing instances are unavailable to callbacks. Callers must check
        // isExist() before destroying a retained reference; raw destroy is not idempotent.
        method isExist() -> boolean { return this != 0 && si__mouseMenu_V[this] == -1 && !disposing; }

        method onClick(menuEventFunc func) -> thistype { if (this.isExist()) { onClickFunc = func; } return this; }
        method onEnter(menuEventFunc func) -> thistype { if (this.isExist()) { onEnterFunc = func; } return this; }
        method onLeave(menuEventFunc func) -> thistype { if (this.isExist()) { onLeaveFunc = func; } return this; }
        method listenDestroy(menuEventFunc func) -> thistype { if (this.isExist()) { onDestroyFunc = func; } return this; }
        method setAutoDestroy(boolean flag) -> thistype { if (this.isExist()) { autoDestroy = flag; } return this; }
        method getItemCount() -> integer { if (!this.isExist()) { return 0; } return itemCount; }
        method isShown() -> boolean { return this.isExist() && currentMenu == this && !disposing; }
        method getHeight() -> real {
            if (!this.isExist() || itemCount == 0) { return MOUSE_MENU_HEIGHT + 2 * MOUSE_MENU_PADDING; }
            return itemCount * MOUSE_MENU_HEIGHT + 2 * MOUSE_MENU_PADDING;
        }
        // Size and position all nine pieces in UI units; horizontal values follow resize rate.
        private method layoutSkin() {
            integer row;
            integer col;
            real w;
            real h;
            real x;
            real y;
            real height = this.getHeight();
            menuFrame.exReSize(menuWidth, height);
            for (0 <= row <= 2) {
                h = MOUSE_MENU_CORNER;
                y = 0;
                if (row == 1) { h = height - 2 * MOUSE_MENU_CORNER; y = -MOUSE_MENU_CORNER; }
                if (row == 2) { y = -(height - MOUSE_MENU_CORNER); }
                for (0 <= col <= 2) {
                    w = MOUSE_MENU_CORNER;
                    x = 0;
                    if (col == 1) { w = menuWidth - 2 * MOUSE_MENU_CORNER; x = MOUSE_MENU_CORNER; }
                    if (col == 2) { x = menuWidth - MOUSE_MENU_CORNER; }
                    skin[row * 3 + col].exReSize(w, h)
                        .exRePoint(ANCHOR_TOPLEFT, menuFrame.ui, ANCHOR_TOPLEFT, x, y);
                }
            }
        }
        method isInMenu(integer checkUI) -> boolean {
            integer i;
            if (!this.isExist() || disposing) { return false; }
            // Include the panel and decorative children so a border click is not an outside click.
            if (checkUI == menuFrame.ui || checkUI == highlight.ui) { return true; }
            for (0 <= i <= 8) { if (checkUI == skin[i].ui) { return true; } }
            i = 1;
            while (i <= itemCount) {
                if (items[i].isExist() && (checkUI == items[i].btn.ui || checkUI == items[i].text.ui || checkUI == items[i].background.ui || checkUI == items[i].separator.ui)) { return true; }
                i += 1;
            }
            return false;
        }
        static method isMouseIn() -> boolean { return currentMenu.isExist() && currentMenu.isInMenu(DzGetMouseFocus()); }
        private method detach() {
            integer i;
            // Hiding need not generate a native leave event; clear the input owner's stale frame.
            for (1 <= i <= itemCount) {
                if (uiEventState.uiId == items[i].btn.ui) {
                    uiEventState.uiId = 0;
                    uiEventState.rcStart = false;
                }
            }
            hoveredIndex = 0;
            hoverRevision += 1;
            if (currentMenu == this) { currentMenu = 0; }
            if (escId != 0) { escStack.remove(escId); escId = 0; }
            if (highlight != 0) { highlight.show(false).clearPoint(); }
            if (menuFrame != 0) { menuFrame.show(false); }
        }
        method onDestroy() {
            integer i = 1;
            menuEventFunc callback = onDestroyFunc;
            menuEventFunc leaveCallback = onLeaveFunc;
            integer leaveIndex = hoveredIndex;
            if (disposing) { return; }
            disposing = true;
            onDestroyFunc = 0;
            onClickFunc = 0;
            onEnterFunc = 0;
            onLeaveFunc = 0;
            this.detach();
            // Destruction may synthesize leave events; callbacks see this instance as unavailable.
            while (i <= itemCount) {
                if (items[i] != 0) { items[i].destroy(); items[i] = 0; }
                i += 1;
            }
            itemCount = 0;
            if (highlight != 0) { highlight.destroy(); highlight = 0; }
            for (0 <= i <= 8) { if (skin[i] != 0) { skin[i].destroy(); skin[i] = 0; } }
            if (menuFrame != 0) { menuFrame.destroy(); menuFrame = 0; }
            autoDestroy = false;
            // Native destruction leave is suppressed; balance the presentation callback once.
            if (leaveIndex > 0 && leaveCallback != 0) { leaveCallback.evaluate(leaveIndex); }
            if (callback != 0) { callback.evaluate(0); }
        }
        method clear() -> thistype {
            integer i = 1;
            integer leaveIndex = hoveredIndex;
            menuEventFunc leaveCallback = onLeaveFunc;
            if (!this.isExist() || disposing) { return this; }
            this.detach();
            // Guard callbacks while removing children; clear retains the menu itself.
            disposing = true;
            while (i <= itemCount) { items[i].destroy(); items[i] = 0; i += 1; }
            itemCount = 0;
            disposing = false;
            this.layoutSkin();
            // Invoke after cleanup so callbacks can safely build/show a replacement.
            if (leaveIndex > 0 && leaveCallback != 0) { leaveCallback.evaluate(leaveIndex); }
            return this;
        }
        method show(boolean flag) -> thistype {
            thistype old;
            integer leaveIndex;
            menuEventFunc leaveCallback;
            if (!this.isExist() || disposing) { return this; }
            if (!flag) {
                if (autoDestroy) { this.destroy(); }
                else {
                    leaveIndex = hoveredIndex;
                    leaveCallback = onLeaveFunc;
                    this.detach();
                    // No access to this after the external callback: it may destroy/reuse it.
                    if (leaveIndex > 0 && leaveCallback != 0) { leaveCallback.evaluate(leaveIndex); }
                }
                return this;
            }
            if (itemCount == 0) { return this; }
            if (currentMenu != this) {
                old = currentMenu;
                if (old.isExist()) { old.show(false); }
                // A callback's newer show owns the menu and its Esc entry, even when it
                // showed this same target. Do not hide an auto-destroy successor or push twice.
                // If a different successor won, this target remains owned by its caller.
                if (currentMenu.isExist()) { return this; }
                if (!this.isExist() || disposing || itemCount == 0) { return this; }
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
        static method enter(integer frame) {
            thistype this = uiHashTable(frame).eventdata.get2();
            integer index = uiHashTable(frame).eventdata.get();
            integer previous;
            integer revision;
            if (!this.isShown() || index < 1 || index > itemCount || hoveredIndex == index) { return; }
            previous = hoveredIndex;
            hoveredIndex = 0;
            hoverRevision += 1;
            revision = hoverRevision;
            highlight.show(false).clearPoint();
            // Balance the old row before entering the new one, even if native leave is late.
            if (previous > 0 && onLeaveFunc != 0) { onLeaveFunc.evaluate(previous); }
            // The callback can hide, clear, destroy/reallocate, or enter another row.
            if (!this.isShown() || hoverRevision != revision) { return; }
            hoveredIndex = index;
            highlight.clearPoint().setAllPoint(items[index].background.ui).show(true);
            if (onEnterFunc != 0) { onEnterFunc.evaluate(index); }
        }
        static method leave(integer frame) {
            thistype this = uiHashTable(frame).eventdata.get2();
            integer index = uiHashTable(frame).eventdata.get();
            // An old row may deliver leave after another row has already received enter.
            if (!this.isShown() || index < 1 || hoveredIndex != index) { return; }
            hoverRevision += 1;
            hoveredIndex = 0;
            highlight.show(false).clearPoint();
            if (onLeaveFunc != 0) { onLeaveFunc.evaluate(index); }
        }
        static method click(integer frame) {
            thistype this = uiHashTable(frame).eventdata.get2();
            integer index = uiHashTable(frame).eventdata.get();
            menuEventFunc callback;
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
            items[index] = menuItem.create(menuWidth - 2 * MOUSE_MENU_PADDING, title, menuFrame.ui);
            if (isUpward) {
                items[index].background.setPoint(ANCHOR_BOTTOM, menuFrame.ui, ANCHOR_BOTTOM, 0,
                    MOUSE_MENU_PADDING + (index - 1) * MOUSE_MENU_HEIGHT);
            } else {
                items[index].background.setPoint(ANCHOR_TOP, menuFrame.ui, ANCHOR_TOP, 0,
                    -MOUSE_MENU_PADDING - (index - 1) * MOUSE_MENU_HEIGHT);
            }
            // Each boundary belongs to the visually lower row, in either direction.
            if (index > 1) {
                if (isUpward) { items[index - 1].separator.show(true); }
                else { items[index].separator.show(true); }
            }
            uiHashTable(items[index].btn.ui).eventdata.bind(index);
            uiHashTable(items[index].btn.ui).eventdata.bind2(this);
            items[index].btn.spEnter(uiEvent.MouseMenuEnter).spLeave(uiEvent.MouseMenuLeave).spClick(uiEvent.MouseMenuClick);
            this.layoutSkin();
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
            hoveredIndex = 0;
            hoverRevision += 1;
            escId = 0;
            onClickFunc = 0; onEnterFunc = 0; onLeaveFunc = 0; onDestroyFunc = 0;
            while (i <= MOUSE_MENU_MAX_ITEMS) { items[i] = 0; i += 1; }
            menuFrame = uiImage.create(parent).setTexture(UI_STRING_PATH_BLANK).show(false);
            for (0 <= i <= 8) {
                skin[i] = uiImage.create(menuFrame.ui).setTexture("ui\\menu\\mouse-menu-" + I2S(i) + ".blp");
            }
            this.layoutSkin();
            highlight = uiImage.create(menuFrame.ui).setTexture("ui\\menu\\mouse-menu-hover.blp").show(false);
            return this;
        }
        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
        // Read-only test access; production callers cannot retain private child frames.
        method testItem(integer index) -> menuItem {
            if (!this.isExist() || index < 1 || index > itemCount) { return 0; }
            return items[index];
        }
        method testHighlight() -> integer { return highlight.ui; }
        method testHoveredIndex() -> integer { return hoveredIndex; }
        #endif
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
