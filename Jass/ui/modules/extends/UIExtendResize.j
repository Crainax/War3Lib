#ifndef UIExtendResizeIncluded
#define UIExtendResizeIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/core/table/Hash_UIDefine.j" // UI哈希表定义
//! zinc
/*
扩展自适应大小方法
*/
library UIExtendResize requires Hardware ,UIUtils,UILifeCycle{

    public module extendResize {

        //注册一个大小重组器
        method exReSize (real width,real height)  -> thistype {
            resizer ser;
            if (!this.isExist()) {return this;}
            if (HaveSavedInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_RESIZER)) {
                ser        = LoadInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_RESIZER);
                ser.frame  = ui;
                ser.width  = width;
                ser.height = height;
            } else {
                ser = resizer.create(ui,width,height);
                SaveInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_RESIZER,ser);
            }
            DzFrameSetSize(ui,width*GetResizeRate(),height);
            return this;
        }

        method exRePoint (integer anchor, integer relative, integer relativeAnchor, real offsetX, real offsetY)  -> thistype {
            rePointer ptr;
            if (!this.isExist()) {return this;}
            if (HaveSavedInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_REPOINTER)) {
                ptr                = LoadInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_REPOINTER);
                ptr.frame          = ui;
                ptr.anchor         = anchor;
                ptr.relative       = relative;
                ptr.relativeAnchor = relativeAnchor;
                ptr.offsetX        = offsetX;
                ptr.offsetY        = offsetY;
            } else {
                ptr = rePointer.create(ui,anchor,relative,relativeAnchor,offsetX,offsetY);
                SaveInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_REPOINTER,ptr);
            }
            DzFrameSetPoint(frame,anchor,relative,relativeAnchor,offsetX*GetResizeRate(),offsetY);
            return this;
        }
    }

    //大小重组器
    private struct resizer {
        static  thistype List [];  //内容列表
        static  integer size = 0;  //现在有几个东西
        integer frame;             //[成员]绑定的内容
        real width;                 //[成员]注册宽度
        real height;                //[成员]注册高度
        integer uID;               //[成员]绑定的ID

        STRUCT_SHARED_METHODS(resizer)

        //注册一个对象进池里
        static method create (integer frame,real width,real height) -> thistype {
            thistype this = allocate();
            this.frame = frame;
            this.width = width;
            this.height = height;

            if (uID == 0) { //这里是初始化时的设置内容,不需要改
                size       += 1;
                List[size]  = this;
                uID         = size;
            }
            return this;
        }

        STRUCT_SHARED_PRINT(size,List)

        method onDestroy () {
            frame = 0; //数据解除都放这里

            if (uID != 0) {
                List[uID]      = List[size];
                List[uID].uID  = uID;
                size          -= 1;
                uID            = 0;
            }
        }

    }

    //位置重组器
    private struct rePointer {
        static  thistype List [];  //内容列表
        static  integer size = 0;  //现在有几个东西
        integer frame;             //[成员]绑定的内容
        integer anchor;            //[成员]锚点
        integer relative;          //[成员]相对锚点
        integer relativeAnchor;    //[成员]相对锚点
        real    offsetX;           //[成员]偏移X
        real    offsetY;           //[成员]偏移Y
        integer uID;               //[成员]绑定的ID

        STRUCT_SHARED_METHODS(rePointer)


        //注册一个对象进池里
        static method create (integer frame,integer anchor, integer relative, integer relativeAnchor, real offsetX, real offsetY) -> thistype {
            thistype this = allocate();
            this.frame = frame;
            this.anchor = anchor;
            this.relative = relative;
            this.relativeAnchor = relativeAnchor;
            this.offsetX = offsetX;
            this.offsetY = offsetY;

            if (uID == 0) { //这里是初始化时的设置内容,不需要改
                size       += 1;
                List[size]  = this;
                uID         = size;
            }
            return this;
        }

        STRUCT_SHARED_PRINT(size,List)

        method onDestroy () {
            frame = 0; //数据解除都放这里

            if (uID != 0) {
                List[uID]      = List[size];
                List[uID].uID  = uID;
                size          -= 1;
                uID            = 0;
            }
        }

    }

    function onInit () {
        hardware.regResizeEvent(function () { //注册窗口大小变化事件
            real resizeX = GetResizeRate();
            integer i ;
            resizer ser;
            if (resizer.size > 0) {
                for (i = resizer.size; i >= 1; i -= 1) { //反向遍历可以删除下面的　i-= 1
                    ser = resizer.List[i]; //从结论来说i就是.uID
                    DzFrameSetSize(ser.frame,ser.width*resizeX,ser.height);
                }
            }
        });

        hardware.regResizeEvent(function () { //注册窗口大小变化事件
            real resizeX = GetResizeRate();
            integer i;
            rePointer ptr;
            if (rePointer.size > 0) {
                for (i = rePointer.size; i >= 1; i -= 1) { //反向遍历可以删除下面的　i-= 1
                    ptr = rePointer.List[i]; //从结论来说i就是.uID
                    DzFrameSetPoint(ptr.frame,ptr.anchor,ptr.relative,ptr.relativeAnchor,ptr.offsetX*resizeX,ptr.offsetY);
                }
            }
        });

        uiLifeCycle.registerDestroy(function () { //UI的销毁回调事件
            integer frame = uiLifeCycle.agrsFrame;
            resizer ser;
            rePointer ptr;
            if (HaveSavedInteger(HASH_UI,frame,HASH_KEY_UI_EXTEND_RESIZER)) {
                ser = LoadInteger(HASH_UI,frame,HASH_KEY_UI_EXTEND_RESIZER);
                if (ser.isExist()) {
                    ser.destroy();
                }
            }
            if (HaveSavedInteger(HASH_UI,frame,HASH_KEY_UI_EXTEND_REPOINTER)) {
                ptr = LoadInteger(HASH_UI,frame,HASH_KEY_UI_EXTEND_REPOINTER);
                if (ptr.isExist()) {
                    ptr.destroy();
                }
            }
        });
    }

}

//! endzinc
#endif
