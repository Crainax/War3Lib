#ifndef UIExtendDragIncluded
#define UIExtendDragIncluded

#include "Crainax/config/SharedMethod.h"
#include "Crainax/core/table/Hash_UIDefine.j"

//! zinc

/*
UI拖拽功能库
实现了UI框架的拖拽功能，可以通过鼠标拖动UI框架改变其位置
子控件会通过父子关系自动跟随移动
*/
library UIExtendDrag requires UIExtendEvent {

    // UI拖拽处理器结构体
    public struct uiDragger {
        static  thistype List [];           //内容列表
        static  integer size = 0;           //现在有几个东西
        static  integer draggingFrame = 0;  //当前正在拖拽的frame
        static  real startX = 0.0;         //开始拖拽时鼠标X坐标
        static  real startY = 0.0;         //开始拖拽时鼠标Y坐标

        integer frame;                      //[成员]已注册的frame
        real xPos;                         //[成员]当前的X位置(锚点中心)
        real yPos;                         //[成员]当前的Y位置(锚点中心)
        integer uID;                       //[成员]绑定的ID

        // 设置位置
        method setPosition(real newX, real newY) -> nothing {
            this.xPos = newX;
            this.yPos = newY;
            DzFrameSetAbsolutePoint(this.frame, FRAMEPOINT_CENTER, newX, newY);
        }

        static method create(integer frame) -> thistype {
            thistype this = allocate();
            this.frame = frame;

            // 设置初始位置在屏幕中间
            this.setPosition(0.4, 0.3);

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
            Hardware.regMoveEvent(function() {
                integer frame = thistype.draggingFrame;
                if (frame != 0) {
                    real dx = Hardware.getMouseX() - thistype.startX;
                    real dy = Hardware.getMouseY() - thistype.startY;

                    // 获取dragger实例
                    thistype this = LoadInteger(HASH_UI, frame, HASH_KEY_UI_EXTEND_DRAGGER);
                    if (this != 0) {
                        this.setPosition(this.xPos + dx, this.yPos + dy);
                    }

                    // 更新鼠标起始位置，避免累积误差
                    thistype.startX = Hardware.getMouseX();
                    thistype.startY = Hardware.getMouseY();
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

    public module extendDrag {
        method enableDrag() -> nothing {
            if (!this.isExist()) { return; }

            uiDragger dragger;
            // 检查是否已存在dragger实例
            if (HaveSavedInteger(HASH_UI, this, HASH_KEY_UI_EXTEND_DRAGGER)) {
                dragger = LoadInteger(HASH_UI, this, HASH_KEY_UI_EXTEND_DRAGGER);
                dragger.frame = this;
            } else {
                dragger = uiDragger.create(this);
                SaveInteger(HASH_UI, this, HASH_KEY_UI_EXTEND_DRAGGER, dragger);
            }

            // 注册鼠标事件
            this.exLeftDown(function(integer frame) {
                uiDragger.draggingFrame = frame;
                uiDragger.startX = Hardware.getMouseX();
                uiDragger.startY = Hardware.getMouseY();
            });

            this.exLeftUp(function(integer frame) {
                if (uiDragger.draggingFrame == frame) {
                    uiDragger.draggingFrame = 0;
                }
            });
        }
    }
}

//! endzinc
#endif
