#ifndef UISliderIncluded
#define UISliderIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
滑块组件
*/

//import: ui/slider/slider_background.blp
//import: ui/slider/slider_handle.blp

library UISlider requires UIId,UITocInit,UIBaseModule {

    // 滑块的功能回调(异步)
    public type funSlider extends function(uiSlider);

    public struct uiSlider {
        static thistype List [];  //内容列表
        static integer size = 0;  //现在有几个东西
        integer uID;               //[成员]池子ID,遍历用
        integer ui;                //frameID
        integer id;                //可以回收的ID名(为了销毁时ID不重复)
        funSlider fun;            //回调函数
        real oldValue;            //旧值(和现有值对比不相等才调用回调函数)

        STRUCT_SHARED_METHODS(uiSlider)

        module uiBaseModule; // UI控件的共用方法

        // 创建模型
        // parent: 父级框架
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("SLIDER",STRING_SLIDER + I2S(id),parent,TEMPLATE_SLIDER_NORMAL,0);

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
            if (!this.isExist()) {return this;}
            DzFrameSetSize(getThumbButton(),0.0055*scale,0.0145*scale);
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
        method onDestroy () {
            if (!this.isExist()) {return;}
            DzDestroyFrame(ui);
            uiId.recycle(id);

            if (uID != 0) {
                //这个其实就是将List的[2]设成5  假设2是删  5是最长
                //然后实例5的trID设成了2(之后再新建的话又是5了  这个基本也是独立)
                //但是实例[2]本身的内容已经被清除. 循环读的是List不受影响(虽然List[5]还是5但是无影响)
                List[uID]      = List[size];
                List[uID].uID  = uID;
                size          -= 1;
                uID            = 0;
            }
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
