#ifndef UISliderIncluded
#define UISliderIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
滑块组件
*/

//# dependency:resource/ui/slider/slider_background.blp
//# dependency:resource/ui/slider/slider_handle.blp
//# dependency:resource/ui/slider/nandu_slider_bg.blp
//# dependency:resource/ui/slider/nandu_slider_button.blp

//todo: 那个按钮看下要不要onResize

library UISlider requires STRUCT_SHARED_REQUIRE_UI {

    // 滑块的功能回调(异步)
    public type funSlider extends function(uiSlider);

    public struct uiSlider {
        static thistype List [];  //内容列表
        static integer size = 0;  //现在有几个东西
        integer uID;               //[成员]池子ID,遍历用
        funSlider fun;            //回调函数
        real oldValue;            //旧值(和现有值对比不相等才调用回调函数)

        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(uiSlider)

        // 创建竖滑条
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("SLIDER",STRING_SLIDER + I2S(id),parent,TEMPLATE_SLIDER,0);
            STRUCT_SHARED_UI_ONCREATE(uiSlider)

            if (uID == 0) { //这里是初始化时的设置内容,不需要改
                size       += 1;
                List[size]  = this;
                uID         = size;
            }
            return this;
        }

        // 创建横滑条
        static method createH1 (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("SLIDER",STRING_SLIDER + I2S(id),parent,TEMPLATE_SLIDER_HORIZONTAL,0);
            STRUCT_SHARED_UI_ONCREATE(uiSlider)

            if (uID == 0) { //这里是初始化时的设置内容,不需要改
                size       += 1;
                List[size]  = this;
                uID         = size;
            }
            return this;
        }

        // 创建竖滑条(魔兽风格)
        static method createW (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("SLIDER",STRING_SLIDER + I2S(id),parent,TEMPLATE_SLIDER_WAR3,0);
            STRUCT_SHARED_UI_ONCREATE(uiSlider)

            if (uID == 0) { //这里是初始化时的设置内容,不需要改
                size       += 1;
                List[size]  = this;
                uID         = size;
            }
            return this;
        }

        // 创建横滑条
        static method createWH1 (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("SLIDER",STRING_SLIDER + I2S(id),parent,TEMPLATE_SLIDER_WAR3_H,0);
            STRUCT_SHARED_UI_ONCREATE(uiSlider)

            if (uID == 0) { //这里是初始化时的设置内容,不需要改
                size       += 1;
                List[size]  = this;
                uID         = size;
            }
            return this;
        }

        // 获取滑块的滑块按钮UI
        method getThumbButton () -> integer {
            return DzFrameGetChild(ui,1);
        }

        // 设置滑块的滑块按钮大小
        method setThumbScale (real scale) -> thistype {
            integer btnUI;
            if (!this.isExist()) {return this;}
            btnUI = getThumbButton();
            DzFrameSetSize(btnUI,DzFrameGetWidth(btnUI)*scale,DzFrameGetHeight(btnUI)*scale);
            return this;
        }

        // 设置滑块的数值变化回调
        // @param func: function(uiSlider)
        method onChange (funSlider func) -> thistype {
            if (!this.isExist()) {return this;}
            fun = func;
            return this;
        }

        // 设置滑块的步长
        method setStep (real step) -> thistype{
            if (!this.isExist()) {return this;}
            DzFrameSetStepValue(ui,step);
            return this;
        }

        // 设置滑块的最小值和最大值
        method setMinMaxValue (real min,real max) -> thistype{
            if (!this.isExist()) {return this;}
            DzFrameSetMinMaxValue(ui,min,max);
            return this;
        }

        // 获取滑块的当前值
        method getValue () -> real {
            if (!this.isExist()) {return 0.;}
            return DzFrameGetValue(ui);
        }

        // 回调函数(外部也可直接调用,比如滚轮事件setValue后)
        private method callBack ()  -> nothing {
            if (this.isExist() && fun != 0) {
                fun.evaluate(this);
                oldValue = this.getValue(); //更新旧值
            }
        }

        // 设置滑块的当前值,并调用回调函数
        method setValue (real value) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetValue(ui,value);
            this.callBack(); //调用回调函数
            return this;
        }

        // 销毁
        // 改进后的 onDestroy
        method onDestroy () {
            if (!this.isExist()) {return;}

            // 清理回调函数
            fun = 0;
            oldValue = 0.;

            // 共享销毁逻辑
            STRUCT_SHARED_UI_ONDESTROY(uiSlider)

            // 销毁UI资源
            DzDestroyFrame(ui);
            ui = 0;  // 显式清空

            // 回收ID
            uiId.recycle(id);
            id = 0;  // 显式清空

            // 从列表中移除
            if (uID != 0) {
                List[uID]      = List[size];
                List[uID].uID  = uID;
                size          -= 1;
                uID            = 0;
            }

            // 释放结构体内存（如果需要）
            // deallocate();  // 根据你的框架决定是否需要
        }

        static method onInit () { //初始化就同步创建,不要异步删除计时器
            TimerStart(CreateTimer(),0.1,true,function (){
                thistype this;
                integer i;
                if (size > 0) {
                    for (1 <= i <= size) {
                        this = List[i]; //从结论来说i就是.uID
                        if (this.getValue() != this.oldValue) { //和旧值不相等才调用回调
                            this.callBack();
                        }
                    }
                }
            });
        }

    }
}

//! endzinc
#endif
