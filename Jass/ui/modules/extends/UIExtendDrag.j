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
library UIExtendDrag requires UIExtendEvent, UIExtendResize {

    // UI拖拽处理器结构体
    public struct uiDragger {
        static thistype List [];
        static integer size          = 0;
        static integer draggingFrame = 0;
        static real grabOffsetX = 0.0;
        static real grabOffsetY = 0.0;

        integer frame;
        integer mover;
        real xPos;
        real yPos;
        real leftLimit;
        real rightLimit;
        real topLimit;
        real bottomLimit;
        integer uID;

        static method detachAnchor(integer mover) {
            rePointer ptr = LoadInteger(HASH_UI,mover,HASH_KEY_UI_EXTEND_REPOINTER);
            if (ptr != 0) {
                RemoveSavedInteger(HASH_UI,mover,HASH_KEY_UI_EXTEND_REPOINTER);
                ptr.destroy();
            }
        }

        method setPosition(real newX, real newY) -> nothing {
            thistype.detachAnchor(this.mover);
            this.xPos = RLimit(newX,this.leftLimit,this.rightLimit);
            this.yPos = RLimit(newY,this.bottomLimit,this.topLimit);
            DzFrameClearAllPoints(this.mover);
            DzFrameSetAbsolutePoint(this.mover,ANCHOR_CENTER,this.xPos,this.yPos);
        }

        method configure(integer mover, real left, real right, real bottom, real top) {
            this.mover = mover;
            this.leftLimit = left;
            this.rightLimit = right;
            this.bottomLimit = bottom;
            this.topLimit = top;
        }

        static method create(integer frame, integer mover, real left, real right, real bottom, real top) -> thistype {
            thistype this = allocate();
            this.frame = frame;
            this.configure(mover,left,right,bottom,top);

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

            if (LoadInteger(HASH_UI,this.frame,HASH_KEY_UI_EXTEND_EVENT_LEFT_DOWN) == uiEvent.dragDown) {
                RemoveSavedInteger(HASH_UI,this.frame,HASH_KEY_UI_EXTEND_EVENT_LEFT_DOWN);
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

        static method moveMouse(real mouseX, real mouseY) {
            thistype this = LoadInteger(HASH_UI,draggingFrame,HASH_KEY_UI_EXTEND_DRAGGER);
            if (this == 0 || !DzFrameIsVisible(this.frame) || !DzFrameGetEnable(this.frame) || !DzFrameIsVisible(this.mover)) {
                draggingFrame = 0;
                return;
            }
            this.setPosition(mouseX - grabOffsetX,mouseY - grabOffsetY);
        }

        static method begin(integer frame) {
            thistype this = LoadInteger(HASH_UI,frame,HASH_KEY_UI_EXTEND_DRAGGER);
            if (this == 0) { return; }
            draggingFrame = frame;
            grabOffsetX = hardware.getMouseX() - this.xPos;
            grabOffsetY = hardware.getMouseY() - this.yPos;
        }

        static method releaseMouse() { draggingFrame = 0; }

        static method onInit() {
            hardware.regLeftUpEvent(function thistype.releaseMouse);
            hardware.regMoveEvent(function () {
                if (thistype.draggingFrame != 0) {
                    thistype.moveMouse(hardware.getMouseX(),hardware.getMouseY());
                }
            });

            // 注册UI销毁时的清理回调
            uiLifeCycle.registerDestroy(function() {
                integer frame = uiLifeCycle.agrsFrame;
                uiDragger dragger;
                dragger = LoadInteger(HASH_UI,frame,HASH_KEY_UI_EXTEND_DRAGGER);
                if (dragger != 0) { dragger.destroy(); }
                if (draggingFrame != 0) {
                    dragger = LoadInteger(HASH_UI,draggingFrame,HASH_KEY_UI_EXTEND_DRAGGER);
                    if (dragger != 0 && dragger.mover == frame) { dragger.destroy(); }
                }
            });
        }
    }

    private function dragDown(integer frame) { uiDragger.begin(frame); }

    //放到 uiBtn里面的模块
    public module extendDrag {
        method enableDragAt(integer mover, real x, real y, real left, real right, real bottom, real top) -> thistype {
            uiDragger dragger;
            if (!this.isExist()) { return this; }
            dragger = LoadInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_DRAGGER);
            if (dragger == 0) {
                dragger = uiDragger.create(ui,mover,left,right,bottom,top);
                SaveInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_DRAGGER,dragger);
            } else {
                dragger.configure(mover,left,right,bottom,top);
            }
            this.exLeftDown(uiEvent.dragDown);
            dragger.setPosition(x,y);
            return this;
        }

        method enableDrag(integer mover, real left, real right, real bottom, real top) -> thistype {
            uiDragger dragger;
            if (!this.isExist()) { return this; }
            dragger = LoadInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_DRAGGER);
            if (dragger != 0) {
                // 旧入口再次启用只更新目标及边界，沿用已记录的位置。
                dragger.configure(mover,left,right,bottom,top);
                uiDragger.detachAnchor(mover);
                return this.exLeftDown(uiEvent.dragDown);
            }
            return this.enableDragAt(mover,(left + right)*0.5,(bottom + top)*0.5,left,right,bottom,top);
        }

        method stopDrag() -> thistype {
            if (this.isExist() && uiDragger.draggingFrame == ui) { uiDragger.draggingFrame = 0; }
            return this;
        }

        method disableDrag() -> thistype {
            uiDragger dragger;
            if (!this.isExist()) { return this; }
            dragger = LoadInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_DRAGGER);
            if (dragger != 0) { dragger.destroy(); }
            return this;
        }

        // 手动设置拖拽位置（中心点坐标），会按当前边界自动限制
        method setDragPosition(real x, real y) -> thistype {
            uiDragger dragger;
            if (!this.isExist()) { return this; }

            if (HaveSavedInteger(HASH_UI, ui, HASH_KEY_UI_EXTEND_DRAGGER)) {
                dragger = LoadInteger(HASH_UI, ui, HASH_KEY_UI_EXTEND_DRAGGER);
                if (dragger != 0) {
                    dragger.setPosition(x, y);
                }
            }
            return this;
        }

        // 更新拖拽可移动边界（left/right/bottom/top），并对当前坐标进行一次校正
        method setDragBounds(real left, real right, real bottom, real top) -> thistype {
            uiDragger dragger;
            if (!this.isExist()) { return this; }

            if (HaveSavedInteger(HASH_UI, ui, HASH_KEY_UI_EXTEND_DRAGGER)) {
                dragger = LoadInteger(HASH_UI, ui, HASH_KEY_UI_EXTEND_DRAGGER);
                if (dragger != 0) {
                    dragger.configure(dragger.mover,left,right,bottom,top);
                    // 用当前坐标做一次位置校正，确保落在新边界内
                    dragger.setPosition(dragger.xPos, dragger.yPos);
                }
            }
            return this;
        }

        // 读取当前拖拽中心点 X 坐标（未启用拖拽则返回 0.0）
        method getDragX() -> real {
            uiDragger dragger;
            real rx;
            if (!this.isExist()) { return 0.0; }
            rx = 0.0;
            if (HaveSavedInteger(HASH_UI, ui, HASH_KEY_UI_EXTEND_DRAGGER)) {
                dragger = LoadInteger(HASH_UI, ui, HASH_KEY_UI_EXTEND_DRAGGER);
                if (dragger != 0) { rx = dragger.xPos; }
            }
            return rx;
        }

        // 读取当前拖拽中心点 Y 坐标（未启用拖拽则返回 0.0）
        method getDragY() -> real {
            uiDragger dragger;
            real ry;
            if (!this.isExist()) { return 0.0; }
            ry = 0.0;
            if (HaveSavedInteger(HASH_UI, ui, HASH_KEY_UI_EXTEND_DRAGGER)) {
                dragger = LoadInteger(HASH_UI, ui, HASH_KEY_UI_EXTEND_DRAGGER);
                if (dragger != 0) { ry = dragger.yPos; }
            }
            return ry;
        }
    }
}

//! endzinc
#endif
