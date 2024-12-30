#ifndef ToastPopIncluded
#define ToastPopIncluded

//! zinc

// 弹框

#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j" // UI常量


//# dependency:resource/ui/image/BG_PopUI.blp
library ToastPop requires UIImage,UIText,UIAnimTimer,Hardware,EasingUtils {

    #define POP_ICON_SIZE          0.03        // 图标大小
    #define POP_UI_L_W_RATIO      0.29032     // 弹出对象的长宽比 931:270
    #define POP_COUNTDOWN_START    40          // 弹出动画时长
    #define POP_COUNTDOWN_LEAST    100         // 最少显示时长
    #define POP_COUNTDOWN_END      40          // 消失动画时长
    #define POP_DISPLAY_TIME       5.0         // 显示时长(秒)
    #define POP_FRAME_LENGTH       0.3         // 框架长度

    public struct toastPop {
        static thistype List[];     // 弹窗列表
        static integer size = 0;    // 当前数量
        static uianim UIA = 0;      // 动画实例

        // 成员变量
        uiImage bg = 0;            // 背景框
        uiImage icon = 0;          // 图标
        uiText title = 0;          // 标题文本
        uiText content = 0;        // 内容文本
        integer cd;                // 剩余时间
        integer totalTime;         // 总时长
        real length;               // 框架长度
        integer id;                // 实例ID

        method onDestroy() {
            // 清理UI
            if (bg != 0) { bg.destroy(); }
            if (icon != 0) { icon.destroy(); }
            if (title != 0) { title.destroy(); }
            if (content != 0) { content.destroy(); }

            bg        = 0;
            icon      = 0;
            title     = 0;
            content   = 0;
            cd        = 0;
            totalTime = 0;
            length    = 0;

            // 从列表移除
            if (id != 0) {
                List[id] = List[size];
                List[id].id = id;
                size -= 1;
                id = 0;
            }

            // 停止动画
            if (size <= 0) {
                UIA.unreg();
                BJDebugMsg("停止ToastPop");
            }
        }

        // 初始化基础UI框架(内部方法)
        private method initBase(player p) -> thistype {
            real resizeX;

            if (GetLocalPlayer() != p) { return 0; }

            this = thistype.allocate();
            resizeX = GetResizeRate();

            // 创建背景框
            this.bg = uiImage.create(DzGetGameUI())
                .setTexture("ui\\image\\BG_PopUI.blp")
                .setSize(POP_FRAME_LENGTH, POP_FRAME_LENGTH / resizeX * POP_UI_L_W_RATIO)
                .setAbsPoint(ANCHOR_BOTTOM, .4, .1375);

            return this;
        }

        // 创建带图标的弹窗
        static method createWithIcon(player p, string iconPath, string contentText) -> thistype {
            thistype this = 0;
            real resizeX = GetResizeRate();

            this = this.initBase(p);
            if (this == 0) { return 0; }

            // 创建图标
            this.icon = uiImage.create(this.bg.ui)
                .setTexture(iconPath)
                .setSize(POP_ICON_SIZE, POP_ICON_SIZE / resizeX)
                .setPoint(ANCHOR_TOP, this.bg.ui, ANCHOR_TOP, 0, -0.012 / resizeX);

            // 创建内容文本
            this.content = uiText.create(this.bg.ui)
                .setPoint(ANCHOR_TOP, this.icon.ui, ANCHOR_BOTTOM, 0, -0.007 / resizeX)
                .setPoint(ANCHOR_BOTTOM, this.bg.ui, ANCHOR_BOTTOM, 0, 0.005)
                .setPoint(ANCHOR_LEFT, this.bg.ui, ANCHOR_LEFT, 0.01, 0)
                .setPoint(ANCHOR_RIGHT, this.bg.ui, ANCHOR_RIGHT, -0.01, 0)
                .setText(contentText);

            return this.initAnimation(POP_FRAME_LENGTH, POP_DISPLAY_TIME);
        }

        // 创建带标题的弹窗
        static method createWithTitle(player p, string titleText, string contentText) -> thistype {
            thistype this = 0;
            real resizeX = GetResizeRate();

            this = this.initBase(p);
            if (this == 0) { return 0; }

            // 创建标题文本
            this.title = uiText.create(this.bg.ui)
                .setText(titleText)
                .setPoint(ANCHOR_TOP, this.bg.ui, ANCHOR_TOP, 0, -0.018 / resizeX);

            // 创建内容文本
            this.content = uiText.create(this.bg.ui)
                .setPoint(ANCHOR_TOP, this.title.ui, ANCHOR_BOTTOM, 0, -0.007 / resizeX)
                .setPoint(ANCHOR_BOTTOM, this.bg.ui, ANCHOR_BOTTOM, 0, 0.005)
                .setPoint(ANCHOR_LEFT, this.bg.ui, ANCHOR_LEFT, 0.01, 0)
                .setPoint(ANCHOR_RIGHT, this.bg.ui, ANCHOR_RIGHT, -0.01, 0)
                .setText(contentText);

            return this.initAnimation(POP_FRAME_LENGTH, POP_DISPLAY_TIME);
        }

        // 初始化动画相关参数(内部方法)
        private method initAnimation(real length, real time) -> thistype {
            // 初始化动画相关参数
            this.totalTime = IMaxBJ(R2I(time * 50), POP_COUNTDOWN_START + POP_COUNTDOWN_LEAST + POP_COUNTDOWN_END);
            this.cd = this.totalTime;
            this.length = length;

            // 设置初始状态
            this.content.setAlpha(0);
            if (this.title != 0) { this.title.setAlpha(0); }
            if (this.icon != 0) { this.icon.setAlpha(0); }
            this.bg.setSize(0, 0);

            // 加入列表并启动动画
            size += 1;
            List[size] = this;
            this.id = size;

            UIA.reg();
            return this;
        }

        static method onInit() {
            UIA = uianim.create(function() {
                real r, l, resizeX = GetResizeRate();
                integer i;
                thistype this;

                for (1 <= i <= size) {
                    this = List[i];
                    this.cd -= 1;

                    // 阶段1: 弹出动画
                    if (this.cd >= (this.totalTime - POP_COUNTDOWN_START)) {
                        r = (I2R(this.totalTime - this.cd)) / POP_COUNTDOWN_START;
                        l = EaseOutBack(r) * this.length;
                        this.bg.setSize(l, l / resizeX * POP_UI_L_W_RATIO);
                        if (this.title != 0) { this.title.setAlpha(R2I(255 * EaseInExpo(r))); }
                        if (this.icon != 0) { this.icon.setAlpha(R2I(255 * EaseInExpo(r))); }
                        if (this.content != 0) { this.content.setAlpha(R2I(255 * EaseInExpo(r))); }
                    }

                    // 阶段3: 消失动画
                    if (this.cd <= POP_COUNTDOWN_END) {
                        l = (1.0 - EaseInBack(1.0 - (I2R(this.cd) / POP_COUNTDOWN_END))) * this.length;
                        this.bg.setSize(l, l / resizeX * POP_UI_L_W_RATIO);
                        if (this.title != 0) { this.title.setAlpha(255 - R2I(255 * EaseOutExpo(1.0 - I2R(this.cd) / POP_COUNTDOWN_END))); }
                        if (this.icon != 0) { this.icon.setAlpha(255 - R2I(255 * EaseOutExpo(1.0 - I2R(this.cd) / POP_COUNTDOWN_END))); }
                        if (this.content != 0) { this.content.setAlpha(255 - R2I(255 * EaseOutExpo(1.0 - I2R(this.cd) / POP_COUNTDOWN_END))); }
                    }

                    // 检查是否结束
                    if (this.cd <= 0) {
                        this.destroy();
                        i -= 1;
                    }
                }
            });
        }
    }
}

//! endzinc
#endif

