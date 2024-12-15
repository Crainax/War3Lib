#ifndef MouseMenuIncluded
#define MouseMenuIncluded

#define MOUSE_MENU_WIDTH 0.06
#define MOUSE_MENU_HEIGHT 0.03
#define MOUSE_MENU_MAX_ITEMS 20

library MouseMenu requires UIButton, UIImage, UIText,UIExtendEvent {

    // 合并为单个函数类型接口
    public type MenuEventFunc extends function(integer);

    public struct mouseMenu {
        private integer menuFrame = 0;
        private integer uiButton[MOUSE_MENU_MAX_ITEMS];
        private integer uiText[MOUSE_MENU_MAX_ITEMS];
        private integer uiImage[MOUSE_MENU_MAX_ITEMS];
        private integer itemCount = 0;

        private MenuEventFunc onClickCallback = null;
        private MenuEventFunc onEnterCallback = null;
        private MenuEventFunc onLeaveCallback = null;

        // 链式调用方法
        public method setClickCallback(MenuEventFunc callback) -> thistype {
            this.onClickCallback = callback;
            return this;
        }

        public method setEnterCallback(MenuEventFunc callback) -> thistype {
            this.onEnterCallback = callback;
            return this;
        }

        public method setLeaveCallback(MenuEventFunc callback) -> thistype {
            this.onLeaveCallback = callback;
            return this;
        }

        // 检查鼠标是否在菜单内
        public method IsMouseInMenu(integer mouseUI) -> boolean {
            integer i = 1;
            while (i <= this.itemCount) {
                if (mouseUI == this.uiButton[i]) {
                    return true;
                }
                i += 1;
            }
            return false;
        }

        private method onDestroy() {
            integer i = 1;
            if (this.menuFrame == 0) {
                return;
            }

            while (i <= this.itemCount) {
                if (this.uiButton[i] != 0) {
                    DzFrameSetScriptByCode(this.uiButton[i], FRAME_MOUSE_UP, null, false);
                    DzFrameSetScriptByCode(this.uiButton[i], FRAME_MOUSE_ENTER, null, false);
                    DzFrameSetScriptByCode(this.uiButton[i], FRAME_MOUSE_LEAVE, null, false);
                    this.uiButton[i] = 0;
                }
                if (this.uiText[i] != 0) {
                    this.uiText[i] = 0;
                }
                if (this.uiImage[i] != 0) {
                    this.uiImage[i] = 0;
                }
                i += 1;
            }
            DzDestroyFrame(this.menuFrame);
            this.itemCount = 0;
            this.menuFrame = 0;
            this.onClickCallback = null;
            this.onEnterCallback = null;
            this.onLeaveCallback = null;
        }

        // 添加菜单项
        public method AddMenuItem(string title, real width) -> thistype {
            integer divider;
            thistype this = this;
            this.itemCount += 1;

            if (this.itemCount >= MOUSE_MENU_MAX_ITEMS) {
                return this;
            }

            // 创建分割线
            divider = CreateBackDrop(this.menuFrame);
            DzFrameSetTexture(divider, "White.blp", 0);
            DzFrameSetSize(divider, width * GetResizeRate() * 0.9, 0.0005);
            DzFrameSetPoint(divider, FRAME_ANCHOR_TOP, this.uiButton[this.itemCount - 1], FRAME_ANCHOR_BOTTOM, 0, 0);

            // 创建菜单项并设置事件
            this.uiButton[this.itemCount] = CreateTextButton(this.menuFrame)
                .setText(title)
                .setSize(width * GetResizeRate(), MOUSE_MENU_HEIGHT)
                .setPoint(FRAME_ANCHOR_TOP, this.uiButton[this.itemCount - 1], FRAME_ANCHOR_BOTTOM, 0, 0)
                .onMouseUp(function() {
                    thistype menu = DzGetTriggerUIUserData();
                    integer index = GetTriggerUI();
                    if (menu.onClickCallback != null) {
                        menu.onClickCallback.evaluate(index);
                    }
                })
                .onMouseEnter(function() {
                    thistype menu = DzGetTriggerUIUserData();
                    integer index = GetTriggerUI();
                    if (menu.onEnterCallback != null) {
                        menu.onEnterCallback.evaluate(index);
                    }
                })
                .onMouseLeave(function() {
                    thistype menu = DzGetTriggerUIUserData();
                    integer index = GetTriggerUI();
                    if (menu.onLeaveCallback != null) {
                        menu.onLeaveCallback.evaluate(index);
                    }
                });

            DzFrameSetUserData(this.uiButton[this.itemCount], integer(this));

            // 更新菜单大小
            DzFrameSetSize(this.menuFrame, width * GetResizeRate(), this.itemCount * MOUSE_MENU_HEIGHT);

            return this;
        }

        // 创建菜单
        public static method create(integer parent, string title, real width) -> thistype {
            thistype this = thistype.allocate();
            thistype self = this;

            this.itemCount = 1;

            // 创建菜单背景
            this.menuFrame = CreateBackDrop(parent)
                .setTexture("ui\\menu\\rightclickmenu.blp", 0)
                .setSize(width * GetResizeRate(), MOUSE_MENU_HEIGHT);

            // 创建第一个菜单项
            this.uiButton[1] = CreateTextButton(this.menuFrame)
                .setText(title)
                .setSize(width * GetResizeRate(), MOUSE_MENU_HEIGHT)
                .setPoint(FRAME_ANCHOR_CENTER, this.menuFrame, FRAME_ANCHOR_TOP, 0, -0.55 * MOUSE_MENU_HEIGHT)
                .onMouseUp(function() {
                    thistype menu = DzGetTriggerUIUserData();
                    if (menu.onClickCallback != null) {
                        menu.onClickCallback.evaluate(1);
                    }
                })
                .onMouseEnter(function() {
                    thistype menu = DzGetTriggerUIUserData();
                    if (menu.onEnterCallback != null) {
                        menu.onEnterCallback.evaluate(1);
                    }
                })
                .onMouseLeave(function() {
                    thistype menu = DzGetTriggerUIUserData();
                    if (menu.onLeaveCallback != null) {
                        menu.onLeaveCallback.evaluate(1);
                    }
                });

            DzFrameSetUserData(this.uiButton[1], integer(this));

            return this;
        }

        // 初始化
        static method onInit() {
            hardware.regLeftUpEvent(function() {
                mouseMenu menu = DzGetTriggerUIUserData();
                if (menu != 0 && !menu.IsMouseInMenu(GetTriggerUI())) {
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
    }
}

#endif