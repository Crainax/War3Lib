#ifndef CardSelectorIncluded
#define CardSelectorIncluded
#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j"
#include "Crainax/data/audio/MusicConstant.j"

#define CARD_SELECTOR_WIDTH 0.14 // 卡牌宽度
#define CARD_SELECTOR_HEIGHT (CARD_SELECTOR_WIDTH * 1619.0 / 971.0) // 五色卡面画布比例
#define CARD_SELECTOR_HOVER_WIDTH_SCALE (1171.0 / 971.0) // 含透明外沿的光效画布
#define CARD_SELECTOR_HOVER_HEIGHT_SCALE (1899.0 / 1619.0) // 含标题栏和外沿的光效画布
#define CARD_SELECTOR_GAP 0.018 // 五张牌时的边缘间距，整组居中
#define CARD_SELECTOR_ROW_WIDTH 0.8 // 一至四张牌在此宽度内均匀排列
#define CARD_SELECTOR_OFFSET_Y 0.075 // 整组相对屏幕中心的纵向偏移
#define CARD_SELECTOR_ENTER_TICKS 5 // 入场时长：5 个 0.02 秒动画周期
#define CARD_SELECTOR_EXIT_TICKS 5 // 离场时长：5 个 0.02 秒动画周期
#define CARD_SELECTOR_HOVER_SCALE 1.06 // 悬停放大倍率
#define CARD_SELECTOR_HOVER_EASE 0.35 // 每个动画周期向悬停目标靠近的比例
#define CARD_SELECTOR_ICON_RAISE 0.01 // 图标相对原位置上移距离
#define CARD_SELECTOR_CONTENT_RAISE 0.015 // 图标、标题和正文整体上移距离
#define CARD_SELECTOR_TITLE_HEIGHT 0.020 // 卡名的单行高度
#define CARD_SCROLL_MARGIN 0.011 // 显示滑条时预留的宽度
#define CARD_TEXT_TOP_INSET 0.004 // 正文首行与裁剪边界之间的留白
#define CARD_TEXT_TOP_RAISE 0.008 // 只向上扩展正文视口
#define CARD_FOOTER_HEIGHT 0.015 // 6号底文的单行高度
#define CARD_FOOTER_BOTTOM_INSET 0.013 // 卡面下沿到文字框底边的距离
#define CARD_SCROLL_INK 0.0025 // 轨道与滑块可见宽度
#define CARD_SELECTOR_CONTENT_GAP 0.005 // 图标与标题、标题与正文的垂直间距
#define CARD_SELECTOR_PADDING_X 0.013 // 正文左右相对卡牌边缘的内边距
#define CARD_SELECTOR_PADDING_BOTTOM 0.018 // 简约边框保留更多正文空间
#define CARD_SELECTOR_BUTTON_GAP 0.01 // 相邻按钮未悬停时的边缘间距（左按钮右边到右按钮左边），整组居中
#define CARD_SELECTOR_BUTTON_WIDTH 0.10 // 按钮未悬停时的宽度，高度按10:3.8同步计算
#define CARD_SELECTOR_BUTTON_HEIGHT (CARD_SELECTOR_BUTTON_WIDTH * 3.8 / 10.0) // 按钮宽高比10:3.8
#define CARD_SELECTOR_BUTTON_OFFSET_Y 0.031 // 按钮中心距卡牌底边的距离，较原位置上移0.024
#define CARD_SELECTOR_BUTTON_HOVER_WIDTH_SCALE 1.12 // 外光画布1120相对底图1000
#define CARD_SELECTOR_BUTTON_HOVER_HEIGHT_SCALE (500.0 / 380.0) // 外光画布500相对底图380
#define CARD_SELECTOR_BUTTON_TEXTURE "ui\\cardselector_button\\button.blp"
#define CARD_SELECTOR_BUTTON_HOVER_TEXTURE "ui\\cardselector_button\\hover.blp"

//# dependency:resource/ui/cardselector_button/button.blp
//# dependency:resource/ui/cardselector_button/hover.blp
//# dependency:resource/ui/cardselector_colors/scroll/track.blp
//# dependency:resource/ui/cardselector_colors/scroll/thumb.blp

//# dependency:resource/ui/cardselector_colors/green/body_10.blp
//# dependency:resource/ui/cardselector_colors/green/title.blp
//# dependency:resource/ui/cardselector_colors/green/glow.blp
//# dependency:resource/ui/cardselector_colors/blue/body_10.blp
//# dependency:resource/ui/cardselector_colors/blue/title.blp
//# dependency:resource/ui/cardselector_colors/blue/glow.blp
//# dependency:resource/ui/cardselector_colors/purple/body_10.blp
//# dependency:resource/ui/cardselector_colors/purple/title.blp
//# dependency:resource/ui/cardselector_colors/purple/glow.blp
//# dependency:resource/ui/cardselector_colors/orange/body_10.blp
//# dependency:resource/ui/cardselector_colors/orange/title.blp
//# dependency:resource/ui/cardselector_colors/orange/glow.blp
//# dependency:resource/ui/cardselector_colors/red/body_10.blp
//# dependency:resource/ui/cardselector_colors/red/title.blp
//# dependency:resource/ui/cardselector_colors/red/glow.blp

//! zinc
library CardSelector requires UIImage, UIText, UIButton, Icon, UIHashTable, UIExtendEvent, UIAnimTimer, Music, SyncBus, UIExtendResize {
    // 面板显隐只在当前玩家的本地界面执行。
    public type cardPanelEvent extends function(boolean);
    public type cardPanelClaim extends function() -> boolean;
    private constant integer ACTION_PANEL = -5;
    private constant integer ACTION_FOLD = -4;
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
            real scale;
            if (weight == value) {return;}
            scale = 1.0 + (CARD_SELECTOR_HOVER_SCALE - 1.0) * value;
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
        uiImage plaque;
        uiText badge;
        private string badgeColor;
        integer quality;
        uiImage haloTop;
        uiBtn button;
        icon artwork;
        uiText heading;
        uiText description;
        uiText footer;
        uiImage viewport;
        uiImage rail;
        uiImage thumb;
        real viewHeight;
        real textHeight;
        real offset;
        private real thumbHeight;
        private boolean narrow;
        private integer measureAfter;
        private string content;
        private real lastScale;
        private real lastY;
        private integer lastAlpha;
        private integer lastLight;

        static method create() -> thistype {
            thistype this = allocate();
            quality = 0;
            viewport = 0; description = 0; footer = 0; rail = 0; thumb = 0;
            viewHeight = 0; textHeight = 0; offset = 0; thumbHeight = 0;
            narrow = false; measureAfter = 0; content = null;
            lastScale = -1.0; lastY = -1.0; lastAlpha = -1; lastLight = -1;
            return this;
        }

        method setBadgeText(string value) {
            if (value == null || value == "") {badge.setText(""); return;}
            badge.setText(badgeColor + value + "|r");
        }

        // 非法品质回退绿色。1绿、2淡蓝、3紫、4橙、5红。
        method setQuality(integer value) {
            string color = "green";
            integer tint = 0xFF9BEF47;
            string base;
            if (value < 1 || value > 5) {value = 1;}
            if (quality == value) {return;}
            quality = value;
            badgeColor = "|cff9bef47";
            if (value == 2) {color = "blue"; tint = 0xFF81D9FF; badgeColor = "|cff81d9ff";}
            else if (value == 3) {color = "purple"; tint = 0xFFC17BFF; badgeColor = "|cffc17bff";}
            else if (value == 4) {color = "orange"; tint = 0xFFFFA343; badgeColor = "|cffffa343";}
            else if (value == 5) {color = "red"; tint = 0xFFFF525C; badgeColor = "|cffff525c";}
            DzFrameSetTextColor(heading.ui, tint);
            base = "ui\\cardselector_colors\\" + color + "\\";
            faceTop.setTexture(base + "body_10.blp");
            plaque.setTexture(base + "title.blp");
            haloTop.setTexture(base + "glow.blp");
        }

        method measured() -> boolean {return measureAfter == 0;}
        method hasScroll() -> boolean {return narrow && measured();}
        method scrollTo(real value) {
            real limit = RMaxBJ(0.0, textHeight - viewHeight);
            real travel = viewHeight - thumbHeight;
            offset = RMaxBJ(0.0, RMinBJ(value, limit));
            description.exRePoint(ANCHOR_TOPLEFT, viewport.ui, ANCHOR_TOPLEFT, 0, offset - CARD_TEXT_TOP_INSET);
            if (narrow && limit > 0.0) {
                thumb.exRePoint(ANCHOR_TOP, rail.ui, ANCHOR_TOP, 0, -travel * offset / limit);
            }
        }

        // 先用完整正文宽度测量。高度0交给原生TEXT自动排版。
        method remeasure() {
            real width = CARD_SELECTOR_WIDTH - 2.0 * CARD_SELECTOR_PADDING_X;
            narrow = false;
            rail.show(false); thumb.show(false);
            description.exReSize(width, 0);
            measureAfter = 2;
        }
        method setDescription(string value) {
            if (value == content) {return;}
            content = value;
            description.setText(value);
            remeasure();
            scrollTo(0);
        }
        // KK 要求改变自适应TEXT后至少过一个渲染帧才能读取实际高度。
        method measureFrame() {
            real width = CARD_SELECTOR_WIDTH - 2.0 * CARD_SELECTOR_PADDING_X;
            if (measureAfter <= 0) {return;}
            measureAfter -= 1;
            if (measureAfter > 0) {return;}
            textHeight = DzFrameGetRealHeight(description.ui);
            if (!narrow && textHeight > viewHeight + 0.0001) {
                narrow = true;
                description.exReSize(width - CARD_SCROLL_MARGIN, 0);
                measureAfter = 2;
                return;
            }
            if (narrow) {
                thumbHeight = RMinBJ(viewHeight, RMaxBJ(0.012, viewHeight * viewHeight / RMaxBJ(viewHeight, textHeight)));
                thumb.exReSize(CARD_SCROLL_INK, thumbHeight);
            }
            rail.show(narrow); thumb.show(narrow);
            scrollTo(offset);
        }
        method layout(real scale, real y, integer alpha, integer light) {
            real w = CARD_SELECTOR_WIDTH * scale;
            real h = CARD_SELECTOR_HEIGHT * scale;
            real gap = CARD_SELECTOR_CONTENT_GAP * scale;
            real iconY = h * 0.5 - w * 0.48 + CARD_SELECTOR_ICON_RAISE * scale;
            real titleHeight = CARD_SELECTOR_TITLE_HEIGHT * scale;
            real bodyTop = iconY - w * 0.135 - gap - titleHeight - gap;
            real bodyHeight = (bodyTop + h * 0.5) / scale - CARD_SELECTOR_PADDING_BOTTOM;
            real bottomSpace = h * 0.5 + bodyTop + CARD_SELECTOR_CONTENT_RAISE * scale - bodyHeight;
            // 缩放仅更新几何尺寸，不清空重写正文，避免重置阅读位置。
            if (scale == lastScale && y == lastY && alpha == lastAlpha && light == lastLight) {return;}
            lastScale = scale; lastY = y; lastAlpha = alpha; lastLight = light;
            faceTop.exReSize(w, h).exRePoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, x, y).setAlpha(alpha);
            plaque.exReSize(w * 0.72, h * 0.15)
                .exRePoint(ANCHOR_CENTER, faceTop.ui, ANCHOR_CENTER, 0, h * 0.475).setAlpha(alpha);
            badge.exReSize(w * 0.55, h * 0.09)
                .exRePoint(ANCHOR_CENTER, plaque.ui, ANCHOR_CENTER, 0, 0).setAlpha(alpha);
            // 画布向上扩180、向下扩100；中心偏移40像素，匹配组合外轮廓。
            haloTop.exReSize(w * CARD_SELECTOR_HOVER_WIDTH_SCALE, h * CARD_SELECTOR_HOVER_HEIGHT_SCALE)
                .exRePoint(ANCHOR_CENTER, faceTop.ui, ANCHOR_CENTER, 0, h * 40.0 / 1619.0).setAlpha(light);
            artwork.setSize(w * 0.27, w * 0.27);
            artwork.mainImage.exRePoint(ANCHOR_CENTER, faceTop.ui, ANCHOR_CENTER, 0, iconY + CARD_SELECTOR_CONTENT_RAISE * scale).setAlpha(alpha);
            if (artwork.glowImage.isExist()) {artwork.glowImage.setAlpha(alpha);}
            heading.exReSize(w * 0.88, titleHeight).exRePoint(ANCHOR_TOP, artwork.mainImage.ui, ANCHOR_BOTTOM, 0, -gap).setAlpha(alpha);
            // 单锚点加计算尺寸：避免 exRePoint 清除先前锚点，底边仍保持内边距。
            if (description.isExist()) {
                // 阅读宽高固定，悬停放大时不换行、不改变滑块行程。
                viewHeight = bodyHeight + CARD_TEXT_TOP_RAISE - CARD_TEXT_TOP_INSET;
                viewport.exReSize(CARD_SELECTOR_WIDTH - 2.0 * CARD_SELECTOR_PADDING_X, bodyHeight + CARD_TEXT_TOP_RAISE)
                    .exRePoint(ANCHOR_TOP, faceTop.ui, ANCHOR_CENTER, 0, bodyTop + CARD_SELECTOR_CONTENT_RAISE * scale + CARD_TEXT_TOP_RAISE);
                description.setAlpha(alpha);
                rail.exReSize(CARD_SCROLL_INK, viewHeight).setAlpha(alpha);
                thumb.setAlpha(alpha);
                // 离场时卡面缩小，底文随下沿移动，最高只到正文视口的底边。
                footer.exReSize(w - 2.0 * CARD_SELECTOR_PADDING_X * scale, CARD_FOOTER_HEIGHT * scale)
                    .exRePoint(ANCHOR_BOTTOM, faceTop.ui, ANCHOR_BOTTOM, 0, RMinBJ(CARD_FOOTER_BOTTOM_INSET * scale, bottomSpace - CARD_FOOTER_HEIGHT * scale))
                    .setAlpha(alpha);
            }
        }
        method onDestroy() {
            button.destroy(); artwork.destroy(); heading.destroy();
            if (footer.isExist()) {footer.destroy();}
            if (thumb.isExist()) {thumb.destroy();}
            if (rail.isExist()) {rail.destroy();}
            if (description.isExist()) {description.destroy();}
            viewport.destroy(); content = null;
            badge.destroy(); plaque.destroy(); haloTop.destroy(); faceTop.destroy();
            next = 0;
        }
    }

    public struct cardSelector {
        STRUCT_SHARED_METHODS(cardSelector)
        private static thistype first = 0;
        private static uianim ticker;
        private static uiImage sharedPanelCardLayer = 0;
        private thistype next;
        private thistype prev;
        private cardSelectorItem items;
        private string session; // Select 包共用的“数据 ID,生命周期 token”
        private integer state; // 0=入场，1=等待，2=等待收包，3=离场
        private integer elapsed;
        private integer hovered;
        private integer chosen;
        private cardSelectorAction actions;
        private uiImage cardRoot;
        boolean canFold;
        private boolean folded;
        private boolean refreshPending;
        private boolean panelOpen;
        cardPanelEvent onPanel;
        string panelText;
        string closeText;

        private method dismissPanel() {
            if (panelOpen && !folded && onPanel != 0) {onPanel.evaluate(false);}
            panelOpen = false;
        }

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
                card.button.show(enabled && !folded);
                if (folded && card.weight != 0.0) {
                    card.weight = 0.0;
                    card.layout(1.0, CARD_SELECTOR_OFFSET_Y, 255, 0);
                }
                card = card.next;
            }
            while (action != 0) {
                action.button.show(enabled && action.enabled && (!folded || action.pos == ACTION_FOLD));
                if (!enabled) {action.hovered = false; action.layoutHover(0.0);}
                action = action.next;
            }
        }
        private method updateAction(cardSelectorAction action) {
            boolean visible = action.enabled && state != 3 && (!folded || action.pos == ACTION_FOLD);
            if (action.pos == ACTION_FOLD) {
                if (folded) {action.label.setText("显示");} else {action.label.setText("收起");}
            }
            action.image.show(visible);
            action.halo.show(visible);
            action.button.show(visible && state == 1);
            action.hovered = false;
            action.layoutHover(0.0);
        }

        private method toggleFold() {
            cardSelectorAction action = actions;
            boolean expanded = folded;
            folded = !folded;
            leave();
            cardRoot.show(!folded);
            enableButtons(true);
            while (action != 0) {updateAction(action); action = action.next;}
            if (panelOpen && onPanel != 0) {onPanel.evaluate(expanded);}
        }

        // 仅展示层发送标准 Select 包；不在本地写入数据或执行奖励。
        method click(integer pos) {
            string payload;
            if (state != 1) {return;}
            if (pos == ACTION_FOLD && canFold) {
                music[MUSIC_INDEX_BTN_CLICK].play();
                toggleFold();
                return;
            }
            if (folded) {return;}
            if (pos == ACTION_PANEL && onPanel != 0) {
                music[MUSIC_INDEX_BTN_CLICK].play();
                panelOpen = !panelOpen;
                onPanel.evaluate(panelOpen);
                return;
            }
            if (pos < -3) {return;}
            state = 2;
            elapsed = 0;
            chosen = pos;
            leave();
            enableButtons(false);
            if (pos > 0) {payload = "D," + session + "," + I2S(pos);}
            else if (pos == 0) {payload = "C," + session;}
            else if (pos == -1) {payload = "F," + session;}
            else if (pos == -2) {payload = "G," + session;}
            else {payload = "H," + session;}
            syncBus.DzSyncDataEx("Select", payload);
            music[MUSIC_INDEX_BTN_CLICK].play();
        }
        // 业务回调未销毁数据：恢复选择。只由合法收包后的数据层调用。
        method resume() {
            if (refreshPending || state == 3) {return;}
            state = 1; chosen = 0; elapsed = 0;
            enableButtons(true);
        }
        // 换批期间保持输入锁，避免按旧画面提交新候选的槽位。
        method waitForRefresh(boolean waiting) {
            if (state == 3) {return;}
            refreshPending = waiting;
            if (waiting) {
                state = 2; chosen = 0;
                leave();
                enableButtons(false);
            } else {resume();}
        }

        // 与 selectData 解绑后，只持有 UI 快照，动画不再访问同步数据。
        method finish(integer pos) {
            cardSelectorAction action = actions;
            leave();
            dismissPanel();
            state = 3; chosen = pos; elapsed = 0;
            enableButtons(false);
            while (action != 0) {action.image.show(false); action.halo.show(false); action = action.next;}
        }
        // 保留旧接口的标题参数；卡牌只展示各自的铭牌，此处仅排列底部按钮。
        method setHeader(string value, boolean canClose, boolean can1, string name1, boolean can2, string name2, boolean can3, string name3) {
            cardSelectorAction action = actions;
            integer count = 0;
            integer index = 0;
            real x;
            while (action != 0) {
                if (action.pos == -1) {action.enabled = can1; action.label.setText(name1);}
                else if (action.pos == -2) {action.enabled = can2; action.label.setText(name2);}
                else if (action.pos == -3) {action.enabled = can3; action.label.setText(name3);}
                else if (action.pos == ACTION_PANEL) {action.enabled = onPanel != 0; action.label.setText(panelText);}
                else if (action.pos == ACTION_FOLD) {action.enabled = canFold;}
                else {action.enabled = canClose; action.label.setText(closeText);}
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
                updateAction(action);
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
                while (!folded && card != 0) {
                    if (focus == card.button.ui) {focusPos = card.pos;}
                    card = card.next;
                }
                if (focusPos > 0) {enter(focusPos);} else {leave();}
            }
            card = items;
            elapsed += 1;
            while (!folded && card != 0) {
                scale = 1.0; y = CARD_SELECTOR_OFFSET_Y; a = 255.0; light = 0.0;
                if (state == 0) {
                    t = RMinBJ(1.0, I2R(elapsed) / CARD_SELECTOR_ENTER_TICKS);
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
                    t = RMinBJ(1.0, I2R(elapsed) / CARD_SELECTOR_EXIT_TICKS);
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
                if (state == 1 && action.enabled && (!folded || action.pos == ACTION_FOLD) && focus == action.button.ui) {
                    target = 1.0;
                    if (!action.hovered) {music[MUSIC_INDEX_CARD_FLIP_HOVER].play();}
                }
                action.hovered = target == 1.0;
                e = action.weight + (target - action.weight) * CARD_SELECTOR_HOVER_EASE;
                if (RAbsBJ(target - e) < 0.002) {e = target;}
                action.layoutHover(e);
                action = action.next;
            }
            if (state == 0 && elapsed >= CARD_SELECTOR_ENTER_TICKS) {resume();}
            if (state == 3 && elapsed >= CARD_SELECTOR_EXIT_TICKS) {destroy();}
        }
        static method createWithPanelClaim(integer data, integer token, integer count, cardPanelClaim claim) -> thistype {
            integer i;
            real step;
            thistype this;
            cardSelectorItem card;
            cardSelectorAction action;
            integer parent = DzGetGameUI();
            if (count < 1 || count > 5 || CARD_SELECTOR_WIDTH <= 0.0) {return 0;}
            if (claim != 0) {
                // 连续轮次共用同一个本地父框，后创建的卡牌不会盖住玩家正在操作的独立面板。
                if (sharedPanelCardLayer == 0) {
                    sharedPanelCardLayer = uiImage.create(parent);
                    if (sharedPanelCardLayer.ui == 0) {
                        if (sharedPanelCardLayer.isExist()) {sharedPanelCardLayer.destroy();}
                        sharedPanelCardLayer = 0;
                        return 0;
                    }
                    sharedPanelCardLayer.setTexture(UI_STRING_PATH_BLANK).setSize(0.001, 0.001).setAbsPoint(ANCHOR_CENTER, 0.4, 0.3);
                }
                parent = sharedPanelCardLayer.ui;
            }
            this = allocate();
            if (this == 0) {return 0;}
            session = I2S(data) + "," + I2S(token);
            state = 0; elapsed = 0; hovered = 0; chosen = 0; items = 0;
            actions = 0;
            canFold = false; folded = false; refreshPending = false; panelOpen = false; onPanel = 0;
            panelText = ""; closeText = "取消选择";
            cardRoot = uiImage.create(parent).setTexture(UI_STRING_PATH_BLANK)
                .setSize(0.001, 0.001).setAbsPoint(ANCHOR_CENTER, 0.4, 0.3);
            prev = 0; next = first;
            if (first != 0) {first.prev = this;}
            first = this;
            step = CARD_SELECTOR_ROW_WIDTH / (count + 1);
            if (count == 5) {step = CARD_SELECTOR_WIDTH + CARD_SELECTOR_GAP;}
            for (1 <= i <= count) {
                card = cardSelectorItem.create();
                card.next = items; items = card; card.pos = i; card.weight = 0.0;
                card.x = (i - (count + 1) * 0.5) * step;
                // 外光先创建，卡面和独立标题栏遮住内部，光效不截获鼠标。
                card.haloTop = uiImage.create(cardRoot.ui).setAlpha(0);
                card.faceTop = uiImage.create(cardRoot.ui);
                card.plaque = uiImage.create(cardRoot.ui);
                card.badge = uiText.create(cardRoot.ui).setFontSize(7).setAlign(4);
                DzFrameSetEnable(card.badge.ui, false);
                card.artwork = icon.create(cardRoot.ui).enableResize();
                card.heading = uiText.create(cardRoot.ui).setFontSize(7).setAlign(1);
                card.setQuality(1);
                card.button = uiBtn.createBlank(cardRoot.ui).exReSize(RMinBJ(CARD_SELECTOR_WIDTH, step), CARD_SELECTOR_HEIGHT * 1.1)
                    .exRePoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, card.x, CARD_SELECTOR_OFFSET_Y + CARD_SELECTOR_HEIGHT * 0.025).show(false);
                uiHashTable(card.button.ui).eventdata.bind(this);
                uiHashTable(card.button.ui).eventdata.bind2(i);
                card.button.spClick(uiEvent.CardSelectorClick);
                // 普通TEXT只负责显示；禁用命中，点击正文仍由整张卡按钮发包。
                card.viewport = uiImage.create(cardRoot.ui);
                if (card.viewport.ui == 0) {this.destroy(); return 0;}
                card.viewport.setTexture(UI_STRING_PATH_BLANK).setClip(true);
                card.description = uiText.create(card.viewport.ui);
                if (card.description.ui == 0) {this.destroy(); return 0;}
                card.description.setFontSize(2).setAlign(0);
                card.footer = uiText.create(cardRoot.ui);
                if (card.footer.ui == 0) {this.destroy(); return 0;}
                card.footer.setFontSize(6).setAlign(TEXT_ALIGN_BOTTOMCENTER).show(false);
                DzFrameSetEnable(card.footer.ui, false);
                card.rail = uiImage.create(card.viewport.ui);
                card.thumb = uiImage.create(card.viewport.ui);
                if (card.rail.ui == 0 || card.thumb.ui == 0) {this.destroy(); return 0;}
                card.rail.setTexture("ui\\cardselector_colors\\scroll\\track.blp")
                    .exRePoint(ANCHOR_TOPRIGHT, card.viewport.ui, ANCHOR_TOPRIGHT, -0.002, -CARD_TEXT_TOP_INSET).show(false);
                card.thumb.setTexture("ui\\cardselector_colors\\scroll\\thumb.blp").show(false);
                // viewport 是 BACKDROP；仅禁用正文 TEXT 的鼠标命中。
                DzFrameSetEnable(card.description.ui, false);
                card.layout(0.92, CARD_SELECTOR_OFFSET_Y - 0.025, 0, 0);
            }
            for (0 <= i <= 5) {
                action = cardSelectorAction.create();
                action.next = actions; actions = action; action.enabled = false; action.hovered = false;
                action.pos = i - 4;
                if (i == 0) {action.pos = 0;}
                else if (i == 4) {action.pos = ACTION_FOLD;}
                else if (i == 5) {action.pos = ACTION_PANEL;}
                action.weight = -1.0;
                action.halo = uiImage.create(parent).setTexture(CARD_SELECTOR_BUTTON_HOVER_TEXTURE).setAlpha(0).show(false);
                action.image = uiImage.create(parent).setTexture(CARD_SELECTOR_BUTTON_TEXTURE)
                    .show(false);
                action.halo.exRePoint(ANCHOR_CENTER, action.image.ui, ANCHOR_CENTER, 0, 0);
                action.label = uiText.create(action.image.ui).setFontSize(4).setAlign(4)
                    .exRePoint(ANCHOR_CENTER, action.image.ui, ANCHOR_CENTER, 0, 0);
                DzFrameSetEnable(action.label.ui, false);
                action.button = uiBtn.createBlank(parent).exReSize(CARD_SELECTOR_BUTTON_WIDTH, CARD_SELECTOR_BUTTON_HEIGHT)
                    .exRePoint(ANCHOR_CENTER, action.image.ui, ANCHOR_CENTER, 0, 0).show(false);
                uiHashTable(action.button.ui).eventdata.bind(this); uiHashTable(action.button.ui).eventdata.bind2(action.pos);
                action.button.spClick(uiEvent.CardSelectorClick);
                action.layoutHover(0.0);
            }
            ticker.reg();
            if (claim != 0) {panelOpen = claim.evaluate();}
            return this;
        }
        static method create(integer data, integer token, integer count) -> thistype {
            return thistype.createWithPanelClaim(data, token, count, 0);
        }
        method onDestroy() {
            cardSelectorItem card = items;
            cardSelectorItem after;
            cardSelectorAction action = actions;
            cardSelectorAction nextAction;
            dismissPanel();
            while (card != 0) {after = card.next; card.destroy(); card = after;}
            cardRoot.destroy(); cardRoot = 0;
            while (action != 0) {nextAction = action.next; action.destroy(); action = nextAction;}
            if (prev == 0) {first = next;} else {prev.next = next;}
            if (next != 0) {next.prev = prev;}
            if (first == 0) {ticker.unreg();}
            session = null;
        }
        static method onInit() {
            hardware.regUpdateEvent(function() {
                thistype view = first;
                cardSelectorItem card;
                while (view != 0) {
                    card = view.items;
                    if (!view.folded) {
                        while (card != 0) {card.measureFrame(); card = card.next;}
                    }
                    view = view.next;
                }
            });
            hardware.regResizeEvent(function() {
                thistype view = first;
                cardSelectorItem card;
                while (view != 0) {
                    card = view.items;
                    while (card != 0) {card.remeasure(); card = card.next;}
                    view = view.next;
                }
            });
            hardware.regWheelEvent(function() {
                thistype view = first;
                cardSelectorItem card;
                integer focus;
                if (view == 0) {return;}
                focus = DzGetMouseFocus();
                while (view != 0) {
                    if (view.state == 1 && !view.folded) {
                        card = view.items;
                        while (card != 0) {
                            if (focus == card.button.ui && card.hasScroll()) {
                                if (DzGetWheelDelta() < 0) {card.scrollTo(card.offset + 0.018);}
                                else if (DzGetWheelDelta() > 0) {card.scrollTo(card.offset - 0.018);}
                                return;
                            }
                            card = card.next;
                        }
                    }
                    view = view.next;
                }
            });
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
