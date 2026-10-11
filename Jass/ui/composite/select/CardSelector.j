#ifndef CardSelectorIncluded
#define CardSelectorIncluded
#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j"
#include "Crainax/data/audio/MusicConstant.j"

#define CARD_SELECTOR_WIDTH 0.14 // 卡牌宽度
#define CARD_SELECTOR_HEIGHT (CARD_SELECTOR_WIDTH * 948.0 / 350.0) // 卡牌显示比例固定350:948
#define CARD_SELECTOR_HOVER_WIDTH_SCALE 1.19 // 外沿光效横向覆盖比例
#define CARD_SELECTOR_HOVER_HEIGHT_SCALE 1.064 // 外沿光效纵向覆盖比例
#define CARD_SELECTOR_GAP 0.005 // 五张牌时的边缘间距，整组居中
#define CARD_SELECTOR_ROW_WIDTH 0.8 // 一至四张牌在此宽度内均匀排列
#define CARD_SELECTOR_OFFSET_Y 0.075 // 整组相对屏幕中心的纵向偏移
#define CARD_SELECTOR_ENTER_SECONDS 0.24 // 全体同时入场的时长，单位秒
#define CARD_SELECTOR_EXIT_SECONDS 0.32 // 全部卡牌统一离场时长，单位秒
#define CARD_SELECTOR_HOVER_SCALE 1.06 // 悬停放大倍率
#define CARD_SELECTOR_HOVER_EASE 0.35 // 每个动画周期向悬停目标靠近的比例
#define CARD_SELECTOR_ICON_RAISE 0.01 // 图标相对原位置上移距离
#define CARD_SELECTOR_CONTENT_RAISE 0.015 // 图标、标题和正文整体上移距离
#define CARD_SELECTOR_TITLE_HEIGHT 0.014 // 单行标题框高度，避免正文锚在过高的空白框下方
#define CARD_SELECTOR_CONTENT_GAP 0.005 // 图标与标题、标题与正文的垂直间距
#define CARD_SELECTOR_PADDING_X 0.013 // 正文左右相对卡牌边缘的内边距
#define CARD_SELECTOR_PADDING_BOTTOM 0.045 // 正文底部相对卡牌底边的内边距
#define CARD_SELECTOR_BUTTON_GAP 0.01 // 相邻按钮未悬停时的边缘间距（左按钮右边到右按钮左边），整组居中
#define CARD_SELECTOR_BUTTON_WIDTH 0.10 // 按钮未悬停时的宽度，高度按10:3.8同步计算
#define CARD_SELECTOR_BUTTON_HEIGHT (CARD_SELECTOR_BUTTON_WIDTH * 3.8 / 10.0) // 按钮宽高比10:3.8
#define CARD_SELECTOR_BUTTON_OFFSET_Y 0.031 // 按钮中心距卡牌底边的距离，较原位置上移0.024
#define CARD_SELECTOR_BUTTON_HOVER_WIDTH_SCALE 1.12 // 外光画布1120相对底图1000
#define CARD_SELECTOR_BUTTON_HOVER_HEIGHT_SCALE (500.0 / 380.0) // 外光画布500相对底图380
#define CARD_SELECTOR_BUTTON_TEXTURE "ui\\cardselector_button\\button.blp"
#define CARD_SELECTOR_BUTTON_HOVER_TEXTURE "ui\\cardselector_button\\hover.blp"
#define CARD_SELECTOR_FACE_TOP "ui\\cardselector_tall_v2\\face_top.blp" // 正面上半张，256x512
#define CARD_SELECTOR_FACE_BOTTOM "ui\\cardselector_tall_v2\\face_bottom.blp" // 正面下半张，256x512
#define CARD_SELECTOR_HOVER_TOP "ui\\cardselector_tall_v2\\hover_top.blp" // 金黄色外光上半张，256x512
#define CARD_SELECTOR_HOVER_BOTTOM "ui\\cardselector_tall_v2\\hover_bottom.blp" // 金黄色外光下半张，256x512

//# dependency:resource/ui/cardselector_tall_v2/face_top.blp
//# dependency:resource/ui/cardselector_tall_v2/face_bottom.blp
//# dependency:resource/ui/cardselector_tall_v2/hover_top.blp
//# dependency:resource/ui/cardselector_tall_v2/hover_bottom.blp
//# dependency:resource/ui/cardselector_button/button.blp
//# dependency:resource/ui/cardselector_button/hover.blp

//! zinc
library CardSelector requires UIImage, UIText, UIButton, Icon, UIHashTable, UIExtendEvent, UIAnimTimer, Music, SyncBus, UIExtendResize {
    // 底部按钮仅持有本地展示数据；pos 为 -1/-2/-3，取消为0。
    private struct cardSelectorAction {
        thistype next;
        integer pos;
        boolean enabled;
        boolean hovered;
        real weight;
        uiImage halo;
        uiImage image;
        uiText label;
        uiBtn button;
        method layoutHover(real value) {
            real scale = 1.0 + (CARD_SELECTOR_HOVER_SCALE - 1.0) * value;
            if (weight == value) {return;}
            weight = value;
            image.exReSize(CARD_SELECTOR_BUTTON_WIDTH * scale, CARD_SELECTOR_BUTTON_HEIGHT * scale);
            halo.exReSize(CARD_SELECTOR_BUTTON_WIDTH * CARD_SELECTOR_BUTTON_HOVER_WIDTH_SCALE * scale,
                CARD_SELECTOR_BUTTON_HEIGHT * CARD_SELECTOR_BUTTON_HOVER_HEIGHT_SCALE * scale).setAlpha(R2I(255.0 * value));
            label.exReSize(CARD_SELECTOR_BUTTON_WIDTH * 0.72 * scale, CARD_SELECTOR_BUTTON_HEIGHT * 0.7 * scale);
        }
        method onDestroy() {
            button.destroy(); label.destroy(); image.destroy(); halo.destroy();
        }
    }

    // 每张卡独立分配；离场中的旧组与新组不会共用静态槽位。
    public struct cardSelectorItem {
        STRUCT_SHARED_METHODS(cardSelectorItem)
        thistype next;
        integer pos;
        real x;
        real weight;
        uiImage faceTop;
        uiImage faceBottom;
        uiImage haloTop;
        uiImage haloBottom;
        uiBtn button;
        icon artwork;
        uiText heading;
        uiText description;
        private real lastScale;
        private real lastY;
        private integer lastAlpha;
        private integer lastLight;

        static method create() -> thistype {
            thistype this = allocate();
            lastScale = -1.0; lastY = -1.0; lastAlpha = -1; lastLight = -1;
            return this;
        }

        method layout(real scale, real y, integer alpha, integer light) {
            real w = CARD_SELECTOR_WIDTH * scale;
            real h = CARD_SELECTOR_HEIGHT * scale;
            real gap = CARD_SELECTOR_CONTENT_GAP * scale;
            real iconY = h * 0.5 - w * 0.65 + CARD_SELECTOR_ICON_RAISE * scale;
            real titleHeight = CARD_SELECTOR_TITLE_HEIGHT * scale;
            real bodyTop = iconY - w * 0.135 - gap - titleHeight - gap;
            real bodyHeight = bodyTop + h * 0.5 - CARD_SELECTOR_PADDING_BOTTOM * scale;
            // 缩放仅更新几何尺寸，不清空重写正文，避免重置阅读位置。
            if (scale == lastScale && y == lastY && alpha == lastAlpha && light == lastLight) {return;}
            lastScale = scale; lastY = y; lastAlpha = alpha; lastLight = light;
            // 上半张的底边就是整张卡中心，下半张直接锚同一条接缝。
            faceTop.exReSize(w, h * 0.5).exRePoint(ANCHOR_BOTTOM, DzGetGameUI(), ANCHOR_CENTER, x, y).setAlpha(alpha);
            faceBottom.exReSize(w, h * 0.5).exRePoint(ANCHOR_TOP, faceTop.ui, ANCHOR_BOTTOM, 0, 0).setAlpha(alpha);
            haloTop.exReSize(w * CARD_SELECTOR_HOVER_WIDTH_SCALE, h * CARD_SELECTOR_HOVER_HEIGHT_SCALE * 0.5)
                .exRePoint(ANCHOR_BOTTOM, faceTop.ui, ANCHOR_BOTTOM, 0, 0).setAlpha(light);
            haloBottom.exReSize(w * CARD_SELECTOR_HOVER_WIDTH_SCALE, h * CARD_SELECTOR_HOVER_HEIGHT_SCALE * 0.5)
                .exRePoint(ANCHOR_TOP, haloTop.ui, ANCHOR_BOTTOM, 0, 0).setAlpha(light);
            artwork.setSize(w * 0.27, w * 0.27);
            artwork.mainImage.exRePoint(ANCHOR_CENTER, faceTop.ui, ANCHOR_BOTTOM, 0, iconY + CARD_SELECTOR_CONTENT_RAISE * scale).setAlpha(alpha);
            if (artwork.glowImage.isExist()) {artwork.glowImage.setAlpha(alpha);}
            heading.exReSize(w * 0.66, titleHeight).exRePoint(ANCHOR_TOP, artwork.mainImage.ui, ANCHOR_BOTTOM, 0, -gap).setAlpha(alpha);
            // 单锚点加计算尺寸：避免 exRePoint 清除先前锚点，底边仍保持内边距。
            if (description.isExist()) {
                description.exReSize(RMaxBJ(0.04, w - 2.0 * CARD_SELECTOR_PADDING_X * scale), RMaxBJ(0.04, bodyHeight))
                    .exRePoint(ANCHOR_TOP, heading.ui, ANCHOR_BOTTOM, 0, -gap).setAlpha(alpha);
            }
        }
        method onDestroy() {
            button.destroy(); artwork.destroy(); heading.destroy();
            if (description.isExist()) {description.destroy();}
            haloTop.destroy(); haloBottom.destroy(); faceTop.destroy(); faceBottom.destroy();
            next = 0;
        }
    }

    public struct cardSelector {
        STRUCT_SHARED_METHODS(cardSelector)
        private static thistype first = 0;
        private static uianim ticker;
        private thistype next;
        private thistype prev;
        private cardSelectorItem items;
        private integer data;
        private integer token;
        private integer state; // 0=入场，1=等待，2=等待收包，3=离场
        private integer elapsed;
        private integer hovered;
        private integer chosen;
        private uiText title;
        private cardSelectorAction actions;

        method getItem(integer pos) -> cardSelectorItem {
            cardSelectorItem card = items;
            while (card != 0) {
                if (card.pos == pos) {return card;}
                card = card.next;
            }
            return 0;
        }
        method leave() {
            hovered = 0;
        }
        method enter(integer pos) {
            if (state != 1 || pos == hovered) {return;}
            hovered = pos;
            music[MUSIC_INDEX_CARD_FLIP_HOVER].play();
        }
        private method enableButtons(boolean enabled) {
            cardSelectorItem card = items;
            cardSelectorAction action = actions;
            while (card != 0) {
                card.button.show(enabled);
                card = card.next;
            }
            while (action != 0) {
                action.button.show(enabled && action.enabled);
                if (!enabled) {action.hovered = false; action.layoutHover(0.0);}
                action = action.next;
            }
        }
        // 仅展示层发送标准 Select 包；不在本地写入数据或执行奖励。
        method click(integer pos) {
            string payload;
            if (state != 1 || pos < -3) {return;}
            state = 2;
            elapsed = 0;
            chosen = pos;
            leave();
            enableButtons(false);
            if (pos > 0) {payload = "D," + I2S(data) + "," + I2S(token) + "," + I2S(pos);}
            else if (pos == 0) {payload = "C," + I2S(data) + "," + I2S(token);}
            else if (pos == -1) {payload = "F," + I2S(data) + "," + I2S(token);}
            else if (pos == -2) {payload = "G," + I2S(data) + "," + I2S(token);}
            else {payload = "H," + I2S(data) + "," + I2S(token);}
            syncBus.DzSyncDataEx("Select", payload);
            music[MUSIC_INDEX_CARD_FLIP_REVEAL].play();
        }
        // 业务回调未销毁数据：恢复选择。只由合法收包后的数据层调用。
        method resume() {
            if (state == 3) {return;}
            state = 1; chosen = 0; elapsed = 0;
            enableButtons(true);
        }
        // 与 selectData 解绑后，只持有 UI 快照，动画不再访问同步数据。
        method finish(integer pos) {
            cardSelectorAction action = actions;
            leave();
            data = 0; token = 0;
            state = 3; chosen = pos; elapsed = 0;
            enableButtons(false);
            title.show(false);
            while (action != 0) {action.image.show(false); action.halo.show(false); action = action.next;}
        }
        // 仅更新本地展示；按已注册按钮压紧排列，顺序为1、2、3、取消。
        method setHeader(string value, boolean canClose, boolean can1, string name1, boolean can2, string name2, boolean can3, string name3) {
            cardSelectorAction action = actions;
            integer count = 0;
            integer index = 0;
            real x;
            title.setText(value).show(false);
            while (action != 0) {
                if (action.pos == -1) {action.enabled = can1; action.label.setText(name1);}
                else if (action.pos == -2) {action.enabled = can2; action.label.setText(name2);}
                else if (action.pos == -3) {action.enabled = can3; action.label.setText(name3);}
                else {action.enabled = canClose; action.label.setText("取消选择");}
                if (action.enabled) {count += 1;}
                action = action.next;
            }
            action = actions;
            while (action != 0) {
                if (action.enabled) {
                    x = (index - (count - 1) * 0.5) * (CARD_SELECTOR_BUTTON_WIDTH + CARD_SELECTOR_BUTTON_GAP);
                    action.image.exRePoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, x,
                        CARD_SELECTOR_OFFSET_Y - CARD_SELECTOR_HEIGHT * 0.5 - CARD_SELECTOR_BUTTON_OFFSET_Y);
                    index += 1;
                }
                action.image.show(action.enabled && state != 3);
                action.halo.show(action.enabled && state != 3);
                action.layoutHover(0.0);
                if (!action.enabled) {action.hovered = false;}
                action.button.show(action.enabled && state == 1);
                action = action.next;
            }
        }
        private method tick() {
            real t; real e; real scale; real y; real a; real light; real target;
            integer focus = 0;
            integer focusPos = 0;
            cardSelectorItem card = items;
            cardSelectorAction action = actions;
            // 正文仅显示，鼠标输入交给整张卡的选牌按钮。
            // 不以子组件 enter/leave 切换触发音效，避免牌内移动时高亮闪烁。
            if (state == 1) {
                focus = DzGetMouseFocus();
                while (card != 0) {
                    if (focus == card.button.ui) {focusPos = card.pos;}
                    card = card.next;
                }
                if (focusPos > 0) {enter(focusPos);} else {leave();}
            }
            card = items;
            elapsed += 1;
            while (card != 0) {
                scale = 1.0; y = CARD_SELECTOR_OFFSET_Y; a = 255.0; light = 0.0;
                if (state == 0) {
                    t = RMinBJ(1.0, elapsed * 0.02 / CARD_SELECTOR_ENTER_SECONDS);
                    e = 1.0 - Pow(1.0 - t, 3.0);
                    scale = 0.92 + 0.08 * e; y -= 0.025 * (1.0 - e); a = 255.0 * e;
                } else if (state == 1 || state == 2) {
                    target = 0.0;
                    if (hovered == card.pos || (state == 2 && chosen == card.pos)) {target = 1.0;}
                    card.weight += (target - card.weight) * CARD_SELECTOR_HOVER_EASE;
                    if (RAbsBJ(target - card.weight) < 0.002) {card.weight = target;}
                    scale = 1.0 + (CARD_SELECTOR_HOVER_SCALE - 1.0) * card.weight;
                    if (state == 1) {light = 255.0 * card.weight;}
                    if (state == 2 && chosen == card.pos) {scale = scale * (0.97 + 0.03 * RMinBJ(1.0, elapsed / 3.0));}
                } else {
                    t = RMinBJ(1.0, elapsed * 0.02 / CARD_SELECTOR_EXIT_SECONDS);
                    if (card.pos == chosen) {
                        scale = 1.0 + (CARD_SELECTOR_HOVER_SCALE - 1.0) * card.weight + 0.07 * t;
                        y += 0.035 * t;
                        a = 255.0 * (1.0 - t);
                    } else {
                        e = 1.0 - Pow(1.0 - t, 3.0);
                        scale = 1.0 + (CARD_SELECTOR_HOVER_SCALE - 1.0) * card.weight * (1.0 - e) - 0.14 * e;
                        y -= 0.025 * e; a = 255.0 * (1.0 - t);
                    }
                }
                card.layout(scale, y, R2I(a), R2I(light));
                card = card.next;
            }
            // 与卡牌共用本地动画周期和缓动；不触发业务hover，也不改变点击区域。
            while (action != 0) {
                target = 0.0;
                if (state == 1 && action.enabled && focus == action.button.ui) {
                    target = 1.0;
                    if (!action.hovered) {music[MUSIC_INDEX_CARD_FLIP_HOVER].play();}
                }
                action.hovered = target == 1.0;
                e = action.weight + (target - action.weight) * CARD_SELECTOR_HOVER_EASE;
                if (RAbsBJ(target - e) < 0.002) {e = target;}
                action.layoutHover(e);
                action = action.next;
            }
            if (state == 0 && elapsed * 0.02 >= CARD_SELECTOR_ENTER_SECONDS) {resume();}
            if (state == 3 && elapsed * 0.02 >= CARD_SELECTOR_EXIT_SECONDS) {destroy();}
        }
        static method create(integer data, integer token, integer count) -> thistype {
            integer i;
            real step;
            thistype this;
            cardSelectorItem card;
            cardSelectorAction action;
            if (count < 1 || count > 5 || CARD_SELECTOR_WIDTH <= 0.0) {return 0;}
            this = allocate();
            if (this == 0) {return 0;}
            this.data = data; this.token = token;
            state = 0; elapsed = 0; hovered = 0; chosen = 0; items = 0;
            title = 0; actions = 0;
            prev = 0; next = first;
            if (first != 0) {first.prev = this;}
            first = this;
            step = CARD_SELECTOR_ROW_WIDTH / (count + 1);
            if (count == 5) {step = CARD_SELECTOR_WIDTH + CARD_SELECTOR_GAP;}
            for (1 <= i <= count) {
                card = cardSelectorItem.create();
                card.next = items; items = card; card.pos = i; card.weight = 0.0;
                card.x = (i - (count + 1) * 0.5) * step;
                // 光效先创建，始终位于两张卡面贴图后方。
                card.haloTop = uiImage.create(DzGetGameUI()).setTexture(CARD_SELECTOR_HOVER_TOP).setAlpha(0);
                card.haloBottom = uiImage.create(DzGetGameUI()).setTexture(CARD_SELECTOR_HOVER_BOTTOM).setAlpha(0);
                card.faceTop = uiImage.create(DzGetGameUI()).setTexture(CARD_SELECTOR_FACE_TOP);
                card.faceBottom = uiImage.create(DzGetGameUI()).setTexture(CARD_SELECTOR_FACE_BOTTOM);
                card.artwork = icon.create(DzGetGameUI()).enableResize();
                card.heading = uiText.create(DzGetGameUI()).setFontSize(6).setAlign(1);
                card.button = uiBtn.createBlank(DzGetGameUI()).exReSize(RMinBJ(CARD_SELECTOR_WIDTH, step), CARD_SELECTOR_HEIGHT)
                    .exRePoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, card.x, CARD_SELECTOR_OFFSET_Y).show(false);
                uiHashTable(card.button.ui).eventdata.bind(this);
                uiHashTable(card.button.ui).eventdata.bind2(i);
                card.button.spClick(uiEvent.CardSelectorClick);
                // 普通TEXT只负责显示；禁用命中，点击正文仍由整张卡按钮发包。
                card.description = uiText.create(DzGetGameUI()).setFontSize(2).setAlign(0);
                if (!card.description.isExist()) {this.destroy(); return 0;}
                DzFrameSetEnable(card.description.ui, false);
                card.layout(0.92, CARD_SELECTOR_OFFSET_Y - 0.025, 0, 0);
            }
            title = uiText.create(DzGetGameUI()).setFontSize(8).setAlign(4).exReSize(0.5, 0.03)
                .exRePoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0, CARD_SELECTOR_OFFSET_Y + CARD_SELECTOR_HEIGHT * 0.5 + 0.020).show(false);
            for (0 <= i <= 3) {
                action = cardSelectorAction.create();
                action.next = actions; actions = action; action.enabled = false; action.hovered = false;
                action.pos = i - 4;
                if (i == 0) {action.pos = 0;}
                action.weight = -1.0;
                action.halo = uiImage.create(DzGetGameUI()).setTexture(CARD_SELECTOR_BUTTON_HOVER_TEXTURE).setAlpha(0).show(false);
                action.image = uiImage.create(DzGetGameUI()).setTexture(CARD_SELECTOR_BUTTON_TEXTURE)
                    .show(false);
                action.halo.exRePoint(ANCHOR_CENTER, action.image.ui, ANCHOR_CENTER, 0, 0);
                action.label = uiText.create(action.image.ui).setFontSize(4).setAlign(4)
                    .exRePoint(ANCHOR_CENTER, action.image.ui, ANCHOR_CENTER, 0, 0);
                DzFrameSetEnable(action.label.ui, false);
                action.button = uiBtn.createBlank(DzGetGameUI()).exReSize(CARD_SELECTOR_BUTTON_WIDTH, CARD_SELECTOR_BUTTON_HEIGHT)
                    .exRePoint(ANCHOR_CENTER, action.image.ui, ANCHOR_CENTER, 0, 0).show(false);
                uiHashTable(action.button.ui).eventdata.bind(this); uiHashTable(action.button.ui).eventdata.bind2(action.pos);
                action.button.spClick(uiEvent.CardSelectorClick);
                action.layoutHover(0.0);
            }
            ticker.reg();
            return this;
        }
        method onDestroy() {
            cardSelectorItem card = items;
            cardSelectorItem after;
            cardSelectorAction action = actions;
            cardSelectorAction nextAction;
            leave();
            while (card != 0) {after = card.next; card.destroy(); card = after;}
            if (title.isExist()) {title.destroy();}
            while (action != 0) {nextAction = action.next; action.destroy(); action = nextAction;}
            if (prev == 0) {first = next;} else {prev.next = next;}
            if (next != 0) {next.prev = prev;}
            if (first == 0) {ticker.unreg();}
            data = 0; token = 0;
        }
        static method onInit() {
            ticker = uianim.create(function() {
                thistype current = first;
                thistype after;
                while (current != 0) {after = current.next; current.tick(); current = after;}
            });
        }
    }
    public function CardSelectorClick(integer frame) {
        cardSelector view = uiHashTable(frame).eventdata.get();
        if (view.isExist()) {view.click(uiHashTable(frame).eventdata.get2());}
    }
}
//! endzinc
#endif
