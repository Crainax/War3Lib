#ifndef CardFlipAnimIncluded
#define CardFlipAnimIncluded

#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j"
#include "Crainax/data/audio/MusicConstant.j"

#define CARD_FLIP_HOLD_SECONDS 3.0 // 正面内容完整显示后的停留时间，单位：秒
#define CARD_FLIP_WIDTH 0.14 // 单张卡牌宽度；高度自动为宽度的 2 倍，不随牌数变化
#define CARD_FLIP_GAP_X 0.005 // 5 张及以上时，相邻卡牌边缘的水平间距；整组居中
#define CARD_FLIP_ROW_WIDTH 0.8 // 4 张及以下时，按此屏幕宽度等分排列（3 张位于 1/4、1/2、3/4）
#define CARD_FLIP_MAX_COUNT 12 // create 允许的牌数上限；实际可见数量还受屏幕宽度限制
#define CARD_FLIP_SYNC_TAG "CardFlip" // 选择消息的 SyncBus 通道名，发送与接收共用
#define CARD_FLIP_LAST_FRAME 23 // 翻牌序列的末帧编号，从 0 开始，共 24 帧
#define CARD_FLIP_FRAME_GAP 1 // 每张序列帧持续的 tick 数，1 tick = 0.02 秒
#define CARD_FLIP_HOVER_SCALE 1.06 // 鼠标悬浮时的尺寸倍率，1.06 表示放大 6%
#define CARD_FLIP_FADE_TICKS 16 // 未选中卡牌缓动淡出的 tick 数，16 tick = 0.32 秒
#define CARD_FLIP_PATH "ui\\cardflip_c_v3\\flip_" // 合并高光后的翻牌贴图前缀，自动追加帧号和 .blp
#define CARD_FLIP_BACK "ui\\cardflip_c_v3\\back.blp" // 等待选择时显示的静态卡背贴图
#define CARD_FLIP_HOVER "ui\\cardflip_c_v3\\hover.blp" // 鼠标悬浮时显示的卡牌外沿高亮贴图

//# sequence: resource/ui/cardflip_c_v3/flip_{0-23}.blp
//# dependency:resource/ui/cardflip_c_v3/back.blp
//# dependency:resource/ui/cardflip_c_v3/hover.blp

//! zinc
/*
 * 播放矩形卡牌序列帧。growdata.max 是最后一帧的编号，首帧为 0。
 * 只创建本地 UI；底层 BaseAnim/UIAnimTimer 的经典句柄在全端初始化。
 */
library CardFlipAnim requires BaseAnim, GrowData, UIImage, UIButton, UIText, UIHashTable, UIExtendEvent, UIAnimTimer, Music, SyncBus {

    // 全端同步回调，slot 从 0 开始。只能通过延迟收包触发。
    public type cardFlipSelectCallback extends function(player, integer);

    public struct cardFlipAnim [] {
        // parent 是定位参照；实际图片使用同一个 parent 创建。
        // holdTicks 以 0.02 秒为单位，播放完毕后保留末帧。
        static method play(player p, integer parent, growdata gd, real width, real height, real offsetX, real offsetY, integer holdTicks) {
            uiImage img;
            baseanim anim;
            integer lifeTicks;

            if (GetLocalPlayer() != p || parent == 0 || gd == 0 || gd.max <= 0 || gd.gap <= 0 || gd.path == "" || width <= 0.0 || height <= 0.0) {
                return;
            }
            if (holdTicks < 1) {holdTicks = 1;}

            img = uiImage.create(parent);
            img.setSize(width, height);
            img.setPoint(ANCHOR_CENTER, parent, ANCHOR_CENTER, offsetX, offsetY);

            anim = baseanim.create(img.ui);
            anim.addSequ(gd.path, gd.max, gd.gap, false);
            lifeTicks = gd.max * gd.gap + holdTicks + 1;
            anim.addLife(lifeTicks, function(baseanim finished) {
                integer ui = finished.ui;
                uiImage cardImage;
                if (uiHashTable(ui).ui.getType() != uiImage.typeid) {return;}
                cardImage = uiHashTable(ui).ui.get();
                cardImage.destroy();
            });
        }
    }

    // 每个客户端同时展示一组盖牌。选择只影响本地 UI，不直接发放奖励。
    // timer/trigger 在 onInit 全端预建；hover/click 中只更新整数 UI 和播放既有音效。
    public struct cardFlipHand {
        STRUCT_SHARED_METHODS(cardFlipHand)

        private static thistype current = 0;
        private static uianim ticker;
        // 同步会话使用玩家和轮次标识，绝不使用本地 UI 的结构体编号。
        private static integer sessionToken[];
        private static integer sessionCount[];
        private static boolean sessionDone[];
        private static cardFlipSelectCallback callbacks[];
        private integer count;
        private integer ownerId;
        private integer token;
        private boolean pending;
        private static uiImage cards[];
        private static uiImage halos[];
        private static uiBtn buttons[];
        private static real hoverWeight[];
        private static real startScale[];
        private static string titles[];
        private static string descriptions[];
        private uiText title;
        private uiText content;
        private integer parent;
        private integer hovered;
        private integer selected;
        private integer elapsed;
        private integer lastFrame;
        private real width;
        private real height;
        private real step;
        private real offsetX;
        private real offsetY;

        private method layout(integer slot, real scale, real down) {
            real x = this.offsetX + (slot - (this.count - 1) * 0.5) * this.step;
            thistype.cards[slot].setSize(this.width * scale, this.height * scale);
            thistype.cards[slot].setPoint(ANCHOR_CENTER, this.parent, ANCHOR_CENTER, x, this.offsetY - down);
            thistype.halos[slot].setSize(this.width * scale * 128.0 / 110.0, this.height * scale * 128.0 / 110.0);
            thistype.halos[slot].setPoint(ANCHOR_CENTER, thistype.cards[slot].ui, ANCHOR_CENTER, 0.0, 0.0);
        }

        private method clearSlot(integer slot) {
            if (thistype.buttons[slot].isExist()) {thistype.buttons[slot].destroy(); thistype.buttons[slot] = 0;}
            if (thistype.halos[slot].isExist()) {thistype.halos[slot].destroy(); thistype.halos[slot] = 0;}
            if (thistype.cards[slot].isExist()) {thistype.cards[slot].destroy(); thistype.cards[slot] = 0;}
        }

        method setContent(integer slot, string heading, string description) {
            if (!this.isExist() || slot < 0 || slot >= this.count || this.selected != -1) {return;}
            thistype.titles[slot] = heading;
            thistype.descriptions[slot] = description;
        }

        method enter(integer slot) {
            if (!this.isExist() || this.pending || this.selected != -1 || slot < 0 || slot >= this.count || this.hovered == slot) {return;}
            this.hovered = slot;
            music[MUSIC_INDEX_CARD_FLIP_HOVER].play();
        }

        method leave(integer slot) {
            if (this.isExist() && !this.pending && this.selected == -1 && this.hovered == slot) {this.hovered = -1;}
        }

        method select(integer slot) {
            integer i;
            if (!this.isExist() || this.pending || this.selected != -1 || slot < 0 || slot >= this.count) {return;}
            this.pending = true;
            for (0 <= i < this.count) {thistype.buttons[i].show(false);}
            syncBus.DzSyncDataEx(CARD_FLIP_SYNC_TAG, "C," + I2S(this.token) + "," + I2S(slot));
        }

        private method beginReveal(integer slot) {
            integer i;
            if (!this.isExist() || this.selected != -1 || slot < 0 || slot >= this.count) {return;}
            // 先锁定整组，快速连点也只会选中一张。
            this.selected = slot;
            this.elapsed = 0;
            this.lastFrame = 0;
            for (0 <= i < this.count) {
                thistype.startScale[i] = 1.0 + (CARD_FLIP_HOVER_SCALE - 1.0) * thistype.hoverWeight[i];
                thistype.buttons[i].show(false);
                thistype.halos[i].setAlpha(0);
            }
            thistype.cards[slot].setTexture(CARD_FLIP_PATH + "0.blp");
            this.layout(slot, thistype.startScale[slot] * 0.97, 0.0);
            music[MUSIC_INDEX_CARD_FLIP_REVEAL].play();
        }

        private method revealContent() {
            integer frame = thistype.cards[this.selected].ui;
            this.title = uiText.create(frame);
            this.title.setSize(this.width * 0.64, this.height * 0.13);
            this.title.setPoint(ANCHOR_CENTER, frame, ANCHOR_CENTER, 0.0, this.height * 0.18);
            this.title.setFontSize(7).setAlign(4).setText(thistype.titles[this.selected]);
            this.content = uiText.create(frame);
            this.content.setSize(this.width * 0.64, this.height * 0.35);
            this.content.setPoint(ANCHOR_CENTER, frame, ANCHOR_CENTER, 0.0, -this.height * 0.07);
            this.content.setFontSize(4).setAlign(4).setText(thistype.descriptions[this.selected]);
        }

        private method tick() {
            integer i;
            integer frame;
            real target;
            real t;
            real ease;
            real scale;
            if (this.selected == -1) {
                for (0 <= i < this.count) {
                    target = 0.0;
                    if (this.hovered == i) {target = 1.0;}
                    if (thistype.hoverWeight[i] != target) {
                        thistype.hoverWeight[i] += (target - thistype.hoverWeight[i]) * 0.35;
                        if (RAbsBJ(target - thistype.hoverWeight[i]) < 0.002) {thistype.hoverWeight[i] = target;}
                        this.layout(i, 1.0 + (CARD_FLIP_HOVER_SCALE - 1.0) * thistype.hoverWeight[i], 0.0);
                        thistype.halos[i].setAlpha(R2I(255.0 * thistype.hoverWeight[i]));
                    }
                }
                return;
            }

            this.elapsed += 1;
            for (0 <= i < this.count) {
                if (i != this.selected && thistype.cards[i] != 0) {
                    if (this.elapsed >= CARD_FLIP_FADE_TICKS) {
                        this.clearSlot(i);
                    } else {
                        t = I2R(this.elapsed) / CARD_FLIP_FADE_TICKS;
                        ease = 1.0 - (1.0 - t) * (1.0 - t) * (1.0 - t);
                        scale = thistype.startScale[i] + (0.86 - thistype.startScale[i]) * ease;
                        this.layout(i, scale, 0.008 * ease);
                        thistype.cards[i].setAlpha(R2I(255.0 * (1.0 - ease)));
                    }
                }
            }
            if (this.elapsed <= 3) {
                this.layout(this.selected, thistype.startScale[this.selected] * (0.97 + 0.01 * this.elapsed), 0.0);
            }
            frame = this.elapsed / CARD_FLIP_FRAME_GAP;
            if (frame > CARD_FLIP_LAST_FRAME) {frame = CARD_FLIP_LAST_FRAME;}
            if (frame != this.lastFrame) {
                thistype.cards[this.selected].setTexture(CARD_FLIP_PATH + I2S(frame) + ".blp");
                this.lastFrame = frame;
                if (frame == CARD_FLIP_LAST_FRAME) {this.revealContent();}
            }
            if (this.elapsed >= CARD_FLIP_LAST_FRAME * CARD_FLIP_FRAME_GAP + R2I(CARD_FLIP_HOLD_SECONDS / 0.02)) {
                this.destroy();
            }
        }

        // 必须在同步事件中全端调用；只有 p 的客户端创建 UI、返回非零实例。
        // onSelect 也必须全端注册，setContent 只填本地展示文字。
        static method create(player p, integer parent, integer count, real offsetX, real offsetY) -> thistype {
            thistype this;
            integer i;
            integer pid;
            real step;
            real hitWidth = CARD_FLIP_WIDTH;
            if (p == null || count < 1 || count > CARD_FLIP_MAX_COUNT || CARD_FLIP_WIDTH <= 0.0) {return 0;}
            pid = GetPlayerId(p);
            sessionToken[pid] += 1;
            sessionCount[pid] = count;
            sessionDone[pid] = false;
            if (GetLocalPlayer() != p || parent == 0) {return 0;}
            if (count >= 5) {
                step = CARD_FLIP_WIDTH + CARD_FLIP_GAP_X;
            } else {
                step = CARD_FLIP_ROW_WIDTH / (count + 1);
            }
            if (current.isExist()) {current.destroy();}
            this = allocate();
            current = this;
            this.parent = parent;
            this.count = count;
            this.ownerId = pid;
            this.token = sessionToken[pid];
            this.pending = false;
            this.width = CARD_FLIP_WIDTH;
            this.height = CARD_FLIP_WIDTH * 2.0;
            this.step = step;
            this.offsetX = offsetX;
            this.offsetY = offsetY;
            this.hovered = -1;
            this.selected = -1;
            this.elapsed = 0;
            this.lastFrame = 0;
            this.title = 0;
            this.content = 0;
            if (hitWidth > step) {hitWidth = step;}
            for (0 <= i < this.count) {
                thistype.hoverWeight[i] = 0.0;
                thistype.startScale[i] = 1.0;
                thistype.titles[i] = "";
                thistype.descriptions[i] = "";
                thistype.halos[i] = uiImage.create(parent);
                thistype.halos[i].setTexture(CARD_FLIP_HOVER).setAlpha(0);
                thistype.cards[i] = uiImage.create(parent);
                thistype.cards[i].setTexture(CARD_FLIP_BACK);
                this.layout(i, 1.0, 0.0);
                thistype.buttons[i] = uiBtn.createBlank(parent);
                // 固定命中区，避免缩放导致 enter/leave 抖动，相邻卡片不抢点击。
                thistype.buttons[i].setSize(hitWidth, this.height);
                thistype.buttons[i].setPoint(ANCHOR_CENTER, parent, ANCHOR_CENTER, offsetX + (i - (count - 1) * 0.5) * step, offsetY);
                uiHashTable(thistype.buttons[i].ui).eventdata.bind(this);
                uiHashTable(thistype.buttons[i].ui).eventdata.bind2(i);
                thistype.buttons[i].spEnter(uiEvent.CardFlipEnter);
                thistype.buttons[i].spLeave(uiEvent.CardFlipLeave);
                thistype.buttons[i].spClick(uiEvent.CardFlipSelect);
            }
            ticker.reg();
            return this;
        }

        method onDestroy() {
            integer i;
            if (!this.isExist()) {return;}
            this.selected = -2;
            this.hovered = -1;
            if (this.content.isExist()) {this.content.destroy(); this.content = 0;}
            if (this.title.isExist()) {this.title.destroy(); this.title = 0;}
            for (0 <= i < this.count) {
                this.clearSlot(i);
                thistype.titles[i] = null;
                thistype.descriptions[i] = null;
            }
            if (current == this) {current = 0; ticker.unreg();}
        }

        // 全端注册，不得放到 GetLocalPlayer() 分支内；每玩家一个回调。
        static method onSelect(player p, cardFlipSelectCallback callback) {
            if (p != null) {callbacks[GetPlayerId(p)] = callback;}
        }

        // 仅延迟收包调用，拒绝旧轮次、重复包、越界牌位与非规范编码。
        private static method receive(player p, string payload) {
            integer split = 2;
            integer length = StringLength(payload);
            integer requestToken;
            integer slot;
            integer pid;
            cardFlipSelectCallback callback;
            if (p == null || SubString(payload, 0, 2) != "C,") {return;}
            while (split < length && SubString(payload, split, split + 1) != ",") {split += 1;}
            if (split <= 2 || split >= length - 1) {return;}
            requestToken = S2I(SubString(payload, 2, split));
            slot = S2I(SubString(payload, split + 1, length));
            pid = GetPlayerId(p);
            if (requestToken <= 0 || requestToken != sessionToken[pid] || sessionDone[pid]
                || slot < 0 || slot >= sessionCount[pid]
                || payload != "C," + I2S(requestToken) + "," + I2S(slot)) {return;}
            sessionDone[pid] = true;
            callback = callbacks[pid];
            if (GetLocalPlayer() == p && current.isExist()) {
                if (current.ownerId == pid && current.token == requestToken) {current.beginReveal(slot);}
            }
            // 先消费会话，再调用外部逻辑；回调可以安全打开下一轮。
            if (callback != 0) {callback.evaluate(p, slot);}
        }

        static method onInit() {
            ticker = uianim.create(function() {
                if (current.isExist()) {current.tick();}
            });
            syncBus.onDataSyncLater(CARD_FLIP_SYNC_TAG, function() -> boolean {
                thistype.receive(syncBus.getPlayer(), syncBus.getPayload());
                return true;
            });
        }
    }

    public function CardFlipEnter(integer frame) {
        cardFlipHand hand = uiHashTable(frame).eventdata.get();
        if (hand.isExist()) {hand.enter(uiHashTable(frame).eventdata.get2());}
    }

    public function CardFlipLeave(integer frame) {
        cardFlipHand hand = uiHashTable(frame).eventdata.get();
        if (hand.isExist()) {hand.leave(uiHashTable(frame).eventdata.get2());}
    }

    public function CardFlipSelect(integer frame) {
        cardFlipHand hand = uiHashTable(frame).eventdata.get();
        if (hand.isExist()) {hand.select(uiHashTable(frame).eventdata.get2());}
    }
}
//! endzinc

#endif
