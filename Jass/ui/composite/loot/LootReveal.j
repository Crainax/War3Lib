#ifndef LootRevealIncluded
#define LootRevealIncluded
#include "Crainax/ui/constants/UIConstants.j"
#include "Crainax/ui/composite/loot/LootConstants.j"
//# dependency:resource/ui/image/loot_panel.blp
//# dependency:resource/ui/image/loot_band.blp
//# dependency:resource/ui/image/loot_line.blp
//# dependency:resource/ui/image/loot_ring.blp
//# dependency:resource/ui/image/loot_spark.blp
//# dependency:resource/ui/image/loot_glow_0.blp
//# dependency:resource/ui/image/loot_glow_1.blp
//# dependency:resource/ui/image/loot_glow_2.blp
//# dependency:resource/ui/image/loot_glow_3.blp
//# dependency:resource/ui/image/loot_border_0.blp
//# dependency:resource/ui/image/loot_border_1.blp
//# dependency:resource/ui/image/loot_border_2.blp
//# dependency:resource/ui/image/loot_border_3.blp
//# dependency:resource/ui/image/black.blp
//! zinc
// LOCAL PRESENTATION ONLY: create/add/show/callbacks must never mutate gameplay.
// Register one driver at synchronized initialization. No runtime classic handles.
library LootReveal requires UIButton, UIImage, UIText, UIExtendEvent, UIExtendResize, UIAnimTimer, EscStack {
    public type lootItemEvent extends function(integer, integer, integer, integer);
    public type lootCloseEvent extends function(integer);

    private struct nameBytes [] {
        static integer hashes[];
        static string bytes[];
        static method isTail(string byte) -> boolean {
            integer lo = 1;
            integer hi = 64;
            integer mid = 0;
            integer hash = StringHash(byte);
            while (lo <= hi) {
                mid = (lo + hi) / 2;
                if (hash < hashes[mid]) { hi = mid - 1; }
                else if (hash > hashes[mid]) { lo = mid + 1; }
                else {
                    while (mid > 1 && hashes[mid-1] == hash) { mid -= 1; }
                    while (mid <= 64 && hashes[mid] == hash) {
                        if (bytes[mid] == byte) { return true; }
                        mid += 1;
                    }
                    return false;
                }
            }
            return false;
        }
        static method onInit() {
            // U+0100..U+013F: valid source characters with tail bytes 0x80..0xBF.
            string sample = "ĀāĂăĄąĆćĈĉĊċČčĎďĐđĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħĨĩĪīĬĭĮįİıĲĳĴĵĶķĸĹĺĻļĽľĿ";
            string byte = "";
            integer hash = 0;
            integer i = 0;
            integer j = 0;
            for (1 <= i <= 64) {
                byte = SubString(sample,(i-1)*2+1,i*2);
                hash = StringHash(byte);
                j = i - 1;
                while (j > 0 && hashes[j] > hash) {
                    hashes[j+1] = hashes[j];
                    bytes[j+1] = bytes[j];
                    j -= 1;
                }
                hashes[j+1] = hash;
                bytes[j+1] = byte;
            }
        }
    }
    // Names are plain text, not Warcraft color strings. Count UTF-8 codepoints,
    // not bytes, so truncation cannot split a Chinese character.
    private function ShortName(string value) -> string {
        integer pos = 0;
        integer letters = 0;
        integer size = StringLength(value);
        while (pos < size && letters < 7) {
            pos += 1;
            while (pos < size && nameBytes.isTail(SubString(value, pos, pos + 1))) { pos += 1; }
            letters += 1;
        }
        if (pos < size) { return SubString(value, 0, pos) + "…"; }
        return value;
    }

    private struct lootEntry {
        thistype next;
        string path;
        string name;
        integer quantity;
        integer style;
        integer data;
        integer index;
        boolean revealed;
        real x;
        real y;
        real side;
        uiImage anchor;
        uiImage glow;
        uiImage ring;
        uiImage icon;
        uiImage border;
        uiImage spark;
        // Avoid the native JASS type name "button": this compiler drops an
        // unqualified `button = 0`, breaking repeated frame cleanup.
        uiBtn iconBtn;
        uiText label;
        uiText amount;

        method releaseFrames() {
            // Clear owned extended-input state before lifecycle's automatic leave.
            if (iconBtn != 0 && uiEventState.uiId == iconBtn.ui) { uiEventState.uiId = 0; uiEventState.rcStart = false; }
            if (amount != 0) { amount.destroy(); amount = 0; }
            if (label != 0) { label.destroy(); label = 0; }
            if (iconBtn != 0) { iconBtn.destroy(); iconBtn = 0; }
            if (spark != 0) { spark.destroy(); spark = 0; }
            if (border != 0) { border.destroy(); border = 0; }
            if (icon != 0) { icon.destroy(); icon = 0; }
            if (ring != 0) { ring.destroy(); ring = 0; }
            if (glow != 0) { glow.destroy(); glow = 0; }
            if (anchor != 0) { anchor.destroy(); anchor = 0; }
        }
        method onDestroy() { releaseFrames(); path = null; name = null; next = 0; }
    }

    public struct lootReveal {
        private static thistype active = 0;
        private static thistype head = 0;
        private static thistype tail = 0;
        private static integer queued = 0;
        private static integer serial = 0;
        private static integer clockTick = 0;
        private static integer nextStart = 0;
        private static boolean leftHeld = false;
        private static thistype clickOwner = 0;
        private static integer clickRevision = 0;
        private static integer closeAt = 0;
        private thistype next;
        private integer revision;
        private integer session;
        private integer parent;
        private integer mode;
        private integer state; // 0 editable/closed, 1 queued, 2 entering, 3 ready.
        private integer count;
        private integer elapsed;
        private integer escId;
        private boolean busy;
        private lootEntry first;
        private lootEntry last;
        private lootEntry hovered;
        private lootEntry buildNext;
        private string title;
        private string subtitle;
        private string closeText;
        private lootItemEvent enterCB;
        private lootItemEvent leaveCB;
        private lootItemEvent revealCB;
        private lootCloseEvent closeCB;
        private uiImage root;
        private uiBtn blocker;
        private uiImage shade;
        private uiImage panel;
        private uiImage topLine;
        private uiImage bottomLine;
        private uiText titleFrame;
        private uiText subtitleFrame;
        private uiImage closeSkin;
        private uiBtn closeButton;
        private uiText closeLabel;
        private real panelWidth;

        // During close/destroy callbacks from leave, the object is unavailable.
        // Always check isExist before destroying a retained callback reference.
        method isExist() -> boolean { return this != 0 && si__lootReveal_V[this] == -1 && !busy; }
        private method touch() { serial += 1; revision = serial; }
        method isShown() -> boolean { return this.isExist() && active == this && state >= 2; }
        method isReady() -> boolean { return this.isShown() && state == 3; }
        method isQueued() -> boolean { return this.isExist() && state == 1; }
        method getCount() -> integer { if (!this.isExist()) { return 0; } return count; }
        method getMode() -> integer { if (!this.isExist()) { return -1; } return mode; }
        static method getActive() -> thistype { return active; }
        static method getQueueCount() -> integer { return queued; }

        private method entryAt(integer index) -> lootEntry {
            lootEntry entry = first;
            if (index < 1 || index > count) { return 0; }
            while (entry != 0 && entry.index != index) { entry = entry.next; }
            return entry;
        }
        method getName(integer index) -> string {
            lootEntry entry = 0;
            if (this.isExist()) { entry = entryAt(index); }
            if (entry == 0) { return ""; } return entry.name;
        }
        method getUserData(integer index) -> integer {
            lootEntry entry = 0;
            if (this.isExist()) { entry = entryAt(index); }
            if (entry == 0) { return 0; } return entry.data;
        }
        method getItemFrame(integer index) -> integer {
            lootEntry entry = 0;
            if (this.isExist()) { entry = entryAt(index); }
            if (entry == 0 || entry.iconBtn == 0) { return 0; } return entry.iconBtn.ui;
        }
        method setTitle(string value) -> thistype { if (this.isExist() && state == 0) { title = value; } return this; }
        method setSubtitle(string value) -> thistype { if (this.isExist() && state == 0) { subtitle = value; } return this; }
        method setCloseText(string value) -> thistype { if (this.isExist() && state == 0) { closeText = value; } return this; }
        method onEnter(lootItemEvent cb) -> thistype { if (this.isExist()) { enterCB = cb; } return this; }
        method onLeave(lootItemEvent cb) -> thistype { if (this.isExist()) { leaveCB = cb; } return this; }
        method onReveal(lootItemEvent cb) -> thistype { if (this.isExist()) { revealCB = cb; } return this; }
        method onClose(lootCloseEvent cb) -> thistype { if (this.isExist()) { closeCB = cb; } return this; }

        // Returns new 1-based index, or 0 for invalid/full/frozen presentation.
        method addItem(string iconPath, string name, integer quantity, integer style, integer userData) -> integer {
            lootEntry entry = 0;
            if (!this.isExist() || state != 0 || count >= LOOT_MAX_ITEMS || iconPath == "" || iconPath == null || quantity < 1 || style < 0 || style > 3) { return 0; }
            entry = lootEntry.create();
            entry.path = iconPath; entry.name = name; entry.quantity = quantity; entry.style = style; entry.data = userData;
            entry.next = 0; count += 1; entry.index = count;
            if (last != 0) { last.next = entry; } else { first = entry; }
            last = entry;
            return count;
        }

        private method leaveHover() -> boolean {
            lootEntry old = hovered;
            integer expected = 0;
            hovered = 0;
            if (old != 0) {
                touch(); expected = revision;
                if (old.glow != 0) { old.glow.setAlpha(100); }
                if (leaveCB != 0) { leaveCB.evaluate(this, old.index, old.data, old.iconBtn.ui); }
                return this.isExist() && revision == expected;
            }
            return this.isExist();
        }
        private method enterItem(integer index) {
            lootEntry entry = 0;
            if (!this.isReady()) { return; }
            entry = entryAt(index);
            if (entry == 0 || hovered == entry) { return; }
            if (!leaveHover()) { return; }
            // A leave callback may close/destroy/reopen or enter another entry.
            if (!this.isReady() || hovered != 0) { return; }
            hovered = entry; touch();
            entry.glow.setAlpha(190);
            if (enterCB != 0) { enterCB.evaluate(this, index, entry.data, entry.iconBtn.ui); }
        }

        private method releaseFrames() {
            lootEntry entry = first;
            buildNext = 0;
            while (entry != 0) { entry.releaseFrames(); entry = entry.next; }
            if (closeButton != 0 && uiEventState.uiId == closeButton.ui) { uiEventState.uiId = 0; uiEventState.rcStart = false; }
            if (blocker != 0 && uiEventState.uiId == blocker.ui) { uiEventState.uiId = 0; uiEventState.rcStart = false; }
            if (closeLabel != 0) { closeLabel.destroy(); closeLabel = 0; }
            if (closeButton != 0) { closeButton.destroy(); closeButton = 0; }
            if (closeSkin != 0) { closeSkin.destroy(); closeSkin = 0; }
            if (subtitleFrame != 0) { subtitleFrame.destroy(); subtitleFrame = 0; }
            if (titleFrame != 0) { titleFrame.destroy(); titleFrame = 0; }
            if (bottomLine != 0) { bottomLine.destroy(); bottomLine = 0; }
            if (topLine != 0) { topLine.destroy(); topLine = 0; }
            if (panel != 0) { panel.destroy(); panel = 0; }
            if (shade != 0) { shade.destroy(); shade = 0; }
            if (blocker != 0) { blocker.destroy(); blocker = 0; }
            if (root != 0) { root.destroy(); root = 0; }
        }
        private method detach() {
            thistype cursor = head;
            thistype previous = 0;
            if (active == this) { active = 0; nextStart = clockTick + 5; }
            if (state == 1) {
                while (cursor != 0 && cursor != this) { previous = cursor; cursor = cursor.next; }
                if (cursor != 0) {
                    if (previous == 0) { head = next; } else { previous.next = next; }
                    if (tail == this) { tail = previous; }
                    queued -= 1;
                }
            }
            next = 0;
            if (escId != 0) { escStack.remove(escId); escId = 0; }
            if (clickOwner == this) { clickOwner = 0; closeAt = 0; }
        }
        method close() {
            lootCloseEvent cb = closeCB;
            if (!this.isExist() || state == 0) { return; }
            busy = true; touch(); detach();
            if (root != 0) { root.show(false); }
            leaveHover(); releaseFrames(); state = 0; busy = false;
            // No member access after callback: caller may destroy/reuse this ID.
            if (cb != 0) { cb.evaluate(this); }
        }
        method clear() -> boolean {
            lootEntry entry = 0;
            lootEntry following = 0;
            if (!this.isExist() || state != 0) { return false; }
            entry = first;
            while (entry != 0) { following = entry.next; entry.destroy(); entry = following; }
            first = 0; last = 0; count = 0; touch(); return true;
        }
        method onDestroy() {
            lootCloseEvent cb = closeCB;
            boolean notify = state != 0;
            lootEntry entry = first;
            lootEntry following = 0;
            busy = true; touch(); detach();
            if (root != 0) { root.show(false); }
            leaveHover(); releaseFrames(); state = 0;
            while (entry != 0) { following = entry.next; entry.destroy(); entry = following; }
            first = 0; last = 0; count = 0;
            title = null; subtitle = null; closeText = null;
            enterCB = 0; leaveCB = 0; revealCB = 0; closeCB = 0;
            if (notify && cb != 0) { cb.evaluate(this); }
        }

        private method ownsFrame(integer frame) -> boolean {
            integer depth = 0;
            if (root == 0) { return false; }
            while (frame != 0 && depth < 20) {
                if (frame == root.ui) { return true; }
                frame = DzFrameGetParent(frame); depth += 1;
            }
            return false;
        }
        // Header and one reward card per driver tick: a 10-card Chinese-name
        // presentation must not exhaust one JASS execution before showing root.
        private method build() {
            string skin = "ui\\image\\loot_panel.blp";
            real panelHeight = 0.245;
            panelWidth = 0.46;
            if (count > 5) { panelHeight = 0.335; }
            if (mode == LOOT_MODE_BANNER) { panelWidth = 0.72; skin = "ui\\image\\loot_band.blp"; }
            root = uiImage.create(parent);
            if (root == 0 || root.ui == 0) { return; }
            root.setTexture(UI_STRING_PATH_BLANK).setAllPoint(DzGetGameUI()).show(false);
            blocker = uiBtn.createBlank(root.ui);
            if (blocker == 0 || blocker.ui == 0) { return; }
            blocker.setAllPoint(DzGetGameUI());
            shade = uiImage.create(blocker.ui).setTexture("ui\\image\\black.blp").setAllPoint(DzGetGameUI()).setAlpha(0);
            panel = uiImage.create(blocker.ui).setTexture(skin).setAlpha(0).exReSize(panelWidth, panelHeight)
                .setAbsPoint(ANCHOR_CENTER, 0.4, 0.33);
            topLine = uiImage.create(panel.ui).setTexture("ui\\image\\loot_line.blp")
                .exReSize(0.001, 0.004).setPoint(ANCHOR_TOP, panel.ui, ANCHOR_TOP, 0, -0.065);
            bottomLine = uiImage.create(panel.ui).setTexture("ui\\image\\loot_line.blp")
                .exReSize(0.001, 0.004).setPoint(ANCHOR_BOTTOM, panel.ui, ANCHOR_BOTTOM, 0, 0.056);
            titleFrame = uiText.create(panel.ui).exReSize(panelWidth - 0.04, 0.025).setAlign(4).setFontSize(8)
                .setText("|cFFFFD477" + title + "|r").setPoint(ANCHOR_TOP, panel.ui, ANCHOR_TOP, 0, -0.016);
            subtitleFrame = uiText.create(panel.ui).exReSize(panelWidth - 0.04, 0.018).setAlign(4).setFontSize(3)
                .setText(subtitle).setPoint(ANCHOR_TOP, panel.ui, ANCHOR_TOP, 0, -0.043);
            if (mode == LOOT_MODE_POPUP) {
                closeSkin = uiImage.create(panel.ui).setTexture("ui\\image\\loot_panel.blp").exReSize(0.21, 0.032)
                    .setPoint(ANCHOR_BOTTOM, panel.ui, ANCHOR_BOTTOM, 0, 0.010);
                closeButton = uiBtn.create(panel.ui).exReSize(0.21, 0.032)
                    .setPoint(ANCHOR_BOTTOM, panel.ui, ANCHOR_BOTTOM, 0, 0.010);
                closeLabel = uiText.create(closeButton.ui).setAllPoint(closeButton.ui);
            } else {
                // Banner dismissal belongs to the full-screen input region.
                // Its footer is plain text, with no button frame or hover skin.
                closeLabel = uiText.create(panel.ui).exReSize(panelWidth - 0.04, 0.032)
                    .setPoint(ANCHOR_BOTTOM, panel.ui, ANCHOR_BOTTOM, 0, 0.010);
            }
            closeLabel.setAlign(4).setFontSize(4).setText(closeText);
            buildNext = first;
        }
        private method buildItem() {
            lootEntry entry = buildNext;
            string color = "|cFFDADAE2";
            integer row = 0;
            integer col = 0;
            integer columns = 0;
            real iconSize = 0.052;
            real offsetY = 0.012;
            if (count == 1) { iconSize = 0.072; }
            if (count > 5) { offsetY = 0.060; }
            row = (entry.index - 1) / 5; col = ModuloInteger(entry.index - 1, 5);
            columns = IMinBJ(5, count - row * 5);
            entry.x = (I2R(col) - I2R(columns - 1) * 0.5) * 0.080;
            entry.y = offsetY - row * 0.092; entry.side = iconSize; entry.revealed = false;
            entry.anchor = uiImage.create(panel.ui).setTexture(UI_STRING_PATH_BLANK).exReSize(iconSize, iconSize)
                .exRePoint(ANCHOR_CENTER, panel.ui, ANCHOR_CENTER, entry.x, entry.y);
            entry.glow = uiImage.create(entry.anchor.ui).setTexture("ui\\image\\loot_glow_" + I2S(entry.style) + ".blp")
                .exReSize(iconSize * 1.65, iconSize * 1.65).setPoint(ANCHOR_CENTER, entry.anchor.ui, ANCHOR_CENTER, 0, 0);
            entry.ring = uiImage.create(entry.anchor.ui).setTexture("ui\\image\\loot_ring.blp")
                .exReSize(iconSize, iconSize).setPoint(ANCHOR_CENTER, entry.anchor.ui, ANCHOR_CENTER, 0, 0);
            entry.icon = uiImage.create(entry.anchor.ui).setTexture(entry.path).setAllPoint(entry.anchor.ui);
            entry.border = uiImage.create(entry.anchor.ui).setTexture("ui\\image\\loot_border_" + I2S(entry.style) + ".blp")
                .exReSize(iconSize + 0.006, iconSize + 0.006).setPoint(ANCHOR_CENTER, entry.anchor.ui, ANCHOR_CENTER, 0, 0);
            entry.spark = uiImage.create(entry.anchor.ui).setTexture("ui\\image\\loot_spark.blp")
                .exReSize(0.025, 0.025).setPoint(ANCHOR_CENTER, entry.anchor.ui, ANCHOR_TOPRIGHT, 0, 0);
            entry.iconBtn = uiBtn.create(entry.anchor.ui).setAllPoint(entry.anchor.ui);
            uiHashTable(entry.iconBtn.ui).eventdata.bind(entry.index);
            uiHashTable(entry.iconBtn.ui).eventdata.bind2(this);
            entry.iconBtn.spEnter(uiEvent.LootEnter).spLeave(uiEvent.LootLeave);
            if (entry.style == LOOT_STYLE_RARE) { color = "|cFF70BCFF"; }
            else if (entry.style == LOOT_STYLE_EPIC) { color = "|cFFCE96F0"; }
            else if (entry.style == LOOT_STYLE_LEGENDARY) { color = "|cFFFFD477"; }
            entry.label = uiText.create(entry.anchor.ui).exReSize(0.078, 0.022).setAlign(1).setFontSize(3)
                .setText(color + ShortName(entry.name) + "|r")
                .setPoint(ANCHOR_TOP, entry.anchor.ui, ANCHOR_BOTTOM, 0, -0.006);
            entry.amount = uiText.create(entry.anchor.ui).exReSize(iconSize - 0.004, 0.014).setAlign(8).setFontSize(3)
                .setText("|cFFFFFFFF×" + I2S(entry.quantity) + "|r")
                .setPoint(ANCHOR_BOTTOMRIGHT, entry.anchor.ui, ANCHOR_BOTTOMRIGHT, -0.002, 0.001);
            if (entry.quantity == 1) { entry.amount.setText(""); }
            entry.anchor.show(false); buildNext = entry.next;
            if (buildNext == 0) { root.show(true); }
        }
        private method start() {
            state = 2; elapsed = 0; hovered = 0; touch(); session = revision; active = this;
            build();
            if (root == 0 || root.ui == 0 || closeLabel == 0 || closeLabel.ui == 0) { close(); return; }
            if (mode == LOOT_MODE_POPUP && (closeButton == 0 || closeButton.ui == 0)) { close(); return; }
            escId = escStack.push(escStackFunc.LootEscape);
        }
        // Queue ownership stays with the caller. close/destroy also cancel queued work.
        method show() -> boolean {
            if (!this.isExist() || count == 0) { return false; }
            if (state != 0) { return true; }
            if (active == 0 && head == 0 && !leftHeld && clockTick >= nextStart) { start(); return this.isShown(); }
            if (queued >= 16) { return false; }
            state = 1; next = 0; touch();
            if (tail != 0) { tail.next = this; } else { head = this; }
            tail = this; queued += 1; return true;
        }
        static method create(integer parent, integer mode) -> thistype {
            thistype this = 0;
            if (parent == 0 || (mode != LOOT_MODE_POPUP && mode != LOOT_MODE_BANNER)) { return 0; }
            this = allocate(); busy = false; this.parent = parent; this.mode = mode; touch();
            state = 0; count = 0; first = 0; last = 0; next = 0; hovered = 0; buildNext = 0; escId = 0;
            root = 0; blocker = 0; shade = 0; panel = 0; topLine = 0; bottomLine = 0;
            titleFrame = 0; subtitleFrame = 0; closeSkin = 0; closeButton = 0; closeLabel = 0;
            enterCB = 0; leaveCB = 0; revealCB = 0; closeCB = 0;
            title = "获得战利品"; subtitle = ""; closeText = "关闭";
            if (mode == LOOT_MODE_BANNER) { closeText = "点击屏幕任意位置继续 · ESC"; }
            return this;
        }

        private method animate() {
            lootEntry entry = first;
            integer age = 0;
            integer expected = revision;
            real t = RMinBJ(1.0, elapsed / 12.0);
            real scale = 1.0;
            real rise = 0.0;
            real fade = 0.0;
            panel.setAlpha(R2I(255 * t));
            topLine.exReSize((panelWidth - 0.03) * RMaxBJ(0.01, t), 0.004);
            bottomLine.exReSize((panelWidth - 0.03) * RMaxBJ(0.01, t), 0.004);
            if (mode == LOOT_MODE_BANNER) { shade.setAlpha(R2I(170 * t)); }
            while (entry != 0) {
                age = elapsed - 10 - (entry.index - 1) * 4;
                if (age >= 0) {
                    entry.anchor.show(true);
                    t = RMinBJ(1.0, age / 20.0);
                    // Piecewise overshoot; no random numbers or frame-count dependent rewards.
                    if (t < 0.65) { scale = 0.75 + 0.33 * (1.0 - Pow(1.0 - t / 0.65, 3)); }
                    else { scale = 1.08 - 0.08 * (t - 0.65) / 0.35; }
                    rise = -0.014 * (1.0 - t) * (1.0 - t);
                    entry.anchor.exReSize(entry.side * scale, entry.side * scale)
                        .exRePoint(ANCHOR_CENTER, panel.ui, ANCHOR_CENTER, entry.x, entry.y + rise)
                        .setAlpha(R2I(255 * RMinBJ(1.0, t * 3)));
                    entry.border.exReSize(entry.side * scale + 0.006, entry.side * scale + 0.006);
                    entry.glow.setAlpha(100);
                    fade = RMaxBJ(0.0, 1.0 - age / 25.0);
                    entry.ring.exReSize(entry.side * (0.7 + 1.2 * (1.0 - fade)), entry.side * (0.7 + 1.2 * (1.0 - fade)))
                        .setAlpha(R2I(210 * fade));
                    entry.spark.setAlpha(R2I(255 * fade));
                    entry.label.setAlpha(R2I(255 * RMinBJ(1.0, RMaxBJ(0.0, (age - 7) / 10.0))));
                    if (!entry.revealed && age >= 20) {
                        entry.revealed = true;
                        if (revealCB != 0) {
                            revealCB.evaluate(this, entry.index, entry.data, entry.iconBtn.ui);
                            if (!this.isShown() || revision != expected) { return; }
                        }
                    }
                }
                entry = entry.next;
            }
            if (elapsed >= 35 + (count - 1) * 4) {
                state = 3;
                // Mouse may already rest over an icon when reveal finishes.
                entry = first;
                while (entry != 0) {
                    if (DzGetMouseFocus() == entry.iconBtn.ui) { enterItem(entry.index); return; }
                    entry = entry.next;
                }
            }
        }
        static method tick() {
            thistype this = active;
            clockTick += 1;
            if (closeAt != 0 && clockTick >= closeAt && !leftHeld) {
                closeAt = 0;
                if (this != 0 && this == clickOwner && session == clickRevision) { close(); }
                clickOwner = 0;
                return;
            }
            if (this == 0) {
                if (head != 0 && !leftHeld && clockTick >= nextStart) {
                    this = head; head = next; next = 0; queued -= 1;
                    if (head == 0) { tail = 0; }
                    start();
                }
                return;
            }
            if (state == 2) {
                if (buildNext != 0) { buildItem(); return; }
                elapsed += 1; animate();
            }
        }
        static method mouseDown() {
            thistype this = active;
            integer focus = DzGetMouseFocus();
            leftHeld = true; clickOwner = 0; closeAt = 0;
            if (this == 0 || !this.isReady() || !ownsFrame(focus)) { return; }
            if (mode == LOOT_MODE_BANNER || focus == closeButton.ui || focus == closeLabel.ui) {
                clickOwner = this; clickRevision = session;
            }
        }
        static method mouseUp() { leftHeld = false; if (clickOwner != 0) { closeAt = clockTick + 2; } }
        static method frameEnter(integer frame) {
            thistype this = uiHashTable(frame).eventdata.get2();
            if (this.isExist()) { enterItem(uiHashTable(frame).eventdata.get()); }
        }
        static method frameLeave(integer frame) {
            thistype this = uiHashTable(frame).eventdata.get2();
            if (this.isExist() && hovered != 0 && hovered.iconBtn.ui == frame) { leaveHover(); }
        }
        static method escape() {
            thistype this = active;
            if (this != 0) { escId = 0; close(); }
        }
        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
        static method testShortName(string value) -> string { return ShortName(value); }
        method testFramesReleased() -> boolean {
            lootEntry entry = first;
            if (!this.isExist() || state != 0) { return false; }
            while (entry != 0) {
                if (entry.anchor != 0 || entry.glow != 0 || entry.ring != 0 || entry.icon != 0 || entry.border != 0
                    || entry.spark != 0 || entry.iconBtn != 0 || entry.label != 0 || entry.amount != 0) { return false; }
                entry = entry.next;
            }
            return buildNext == 0 && root == 0 && blocker == 0 && shade == 0 && panel == 0 && topLine == 0 && bottomLine == 0
                && titleFrame == 0 && subtitleFrame == 0 && closeSkin == 0 && closeButton == 0 && closeLabel == 0;
        }
        #endif
        static method onInit() {
            uianim.create(function thistype.tick).reg();
            hardware.regLeftDownEvent(function thistype.mouseDown);
            hardware.regLeftUpEvent(function thistype.mouseUp);
        }
    }
    public function LootEnter(integer frame) { lootReveal.frameEnter(frame); }
    public function LootLeave(integer frame) { lootReveal.frameLeave(frame); }
    public function LootEscape(player p) { lootReveal.escape(); }
}
//! endzinc
#endif
