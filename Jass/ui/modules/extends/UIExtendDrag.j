#ifndef UIExtendDragIncluded
#define UIExtendDragIncluded

#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j" // UI常量


//! zinc

/*
UI拖拽功能库
实现了UI框架的拖拽功能，可以通过鼠标拖动UI框架改变其位置
子控件会通过父子关系自动跟随移动
*/
library UIExtendDrag requires UIExtendEvent {

    // UI拖拽处理器结构体
    public struct uiDragger {
        static thistype List [];
        static integer size          = 0;
        static integer draggingFrame = 0;
        static real startX           = 0.0;
        static real startY           = 0.0;

        integer frame;
        integer mover;
        real xPos;
        real yPos;
        // 改用四边界限制
        real leftLimit;
        real rightLimit;
        real topLimit;
        real bottomLimit;
        integer uID;

        // 修改位置限制逻辑
        method setPosition(real newX, real newY) -> nothing {
            // 使用四边界进行限制
            newX = RLimit(newX, this.leftLimit, this.rightLimit);
            newY = RLimit(newY, this.bottomLimit, this.topLimit);

            this.xPos = newX;
            this.yPos = newY;
            DzFrameSetAbsolutePoint(this.mover, ANCHOR_CENTER, newX, newY);
        }

        static method create(integer frame, integer mover, real left, real right, real top, real bottom) -> thistype {
            thistype this = allocate();
            this.frame = frame;
            this.mover = mover;
            // 存储四边界限制
            this.leftLimit = left;
            this.rightLimit = right;
            this.topLimit = top;
            this.bottomLimit = bottom;

            // 设置初始位置（使用中心点）
            this.setPosition((left + right) * 0.5, (top + bottom) * 0.5);

            if (this.uID == 0) {
                this.size += 1;
                this.List[this.size] = this;
                this.uID = this.size;
            }

            return this;
        }

        method onDestroy() {
            // 如果正在拖拽此frame，停止拖拽
            if (thistype.draggingFrame == this.frame) {
                thistype.draggingFrame = 0;
            }

            // 从哈希表移除
            RemoveSavedInteger(HASH_UI, this.frame, HASH_KEY_UI_EXTEND_DRAGGER);

            this.frame = 0;
            if (this.uID != 0) {
                this.List[this.uID] = this.List[this.size];
                this.List[this.uID].uID = this.uID;
                this.size -= 1;
                this.uID = 0;
            }
        }

        static method onInit() {
            // 注册鼠标移动事件
            hardware.regMoveEvent(function() {
                thistype this;
                real dx,dy;
                integer frame = thistype.draggingFrame;
                integer currentFocus;
                if (frame != 0) {
                    currentFocus = DzGetMouseFocus();

                    // 检查frame是否还存在（当焦点不是当前拖拽frame时才停止）
                    if (currentFocus != frame) {
                        thistype.draggingFrame = 0;
                        return;
                    }

                    dx = hardware.getMouseX() - thistype.startX;
                    dy = hardware.getMouseY() - thistype.startY;

                    // 获取dragger实例
                    this = LoadInteger(HASH_UI, frame, HASH_KEY_UI_EXTEND_DRAGGER);
                    if (this != 0) {
                        this.setPosition(this.xPos + dx, this.yPos + dy);
                    } else {
                        thistype.draggingFrame = 0;
                    }

                    thistype.startX = hardware.getMouseX();
                    thistype.startY = hardware.getMouseY();
                }
            });

            // 注册UI销毁时的清理回调
            uiLifeCycle.registerDestroy(function() {
                integer frame = uiLifeCycle.agrsFrame;
                uiDragger dragger;

                // 检查并清理dragger实例
                if (HaveSavedInteger(HASH_UI, frame, HASH_KEY_UI_EXTEND_DRAGGER)) {
                    dragger = LoadInteger(HASH_UI, frame, HASH_KEY_UI_EXTEND_DRAGGER);
                    if (dragger != 0) {
                        dragger.destroy();
                    }
                }
            });
        }
    }

    //放到 uiBtn里面的模块
    public module extendDrag {
        // 修改方法签名，使用四边界参数
        method enableDrag(integer mover, real left, real right, real bottom, real top) -> thistype {
            uiDragger dragger;
            if (!this.isExist()) { return this; }

            // 检查是否已存在dragger实例
            if (HaveSavedInteger(HASH_UI, ui, HASH_KEY_UI_EXTEND_DRAGGER)) {
                dragger = LoadInteger(HASH_UI, ui, HASH_KEY_UI_EXTEND_DRAGGER);
                dragger.frame = ui;
                dragger.mover = mover;
                // 更新四边界限制
                dragger.leftLimit = left;
                dragger.rightLimit = right;
                dragger.topLimit = top;
                dragger.bottomLimit = bottom;
            } else {
                dragger = uiDragger.create(ui, mover, left, right, top, bottom);
                SaveInteger(HASH_UI, ui, HASH_KEY_UI_EXTEND_DRAGGER, dragger);
            }

            // 注册鼠标事件
            this.exLeftDown(function(integer frame) {
                uiDragger.draggingFrame = frame;
                uiDragger.startX = hardware.getMouseX();
                uiDragger.startY = hardware.getMouseY();
            });

            this.exLeftUp(function(integer frame) {
                if (uiDragger.draggingFrame == frame) {
                    uiDragger.draggingFrame = 0;
                }
            });

            return this;
        }
    }
}

//! endzinc
#endif
