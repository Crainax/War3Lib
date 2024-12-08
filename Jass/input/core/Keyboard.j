#ifndef KeyboardIncluded
#define KeyboardIncluded

#include "Crainax/input/constant/KeyConstants.j"

//! zinc
/*
键盘的输入事件监听
*/
library Keyboard requires BzAPI{

    public struct keyboard[] {
        private {
            static trigger trsDown[]; // 按下事件
            static trigger trsUp[]; // 抬起事件
            static boolean isDown[]; // 是否按下
        }

        // 注册一个键盘事件
        static method regKeyDownEvent (integer keyCode, code func) {
            if (trsDown[keyCode] == null) {
                trsDown[keyCode] = CreateTrigger();
                DzTriggerRegisterKeyEventByCode(null,keyCode,KEYBORAD_PRESSED,false,function () {
                    if (!isDown[keyCode]) isDown[keyCode] = true;
                    TriggerEvaluate(trsDown[keyCode]);
                });
            }
            TriggerAddCondition(trsDown[keyCode], Condition(func));
        }
        // 注册一个键盘事件
        static method regKeyUpEvent (integer keyCode, code func) {
            if (trsUp[keyCode] == null) {
                trsUp[keyCode] = CreateTrigger();
                DzTriggerRegisterKeyEventByCode(null,keyCode,KEYBORAD_UP,false,function () {
                    isDown[keyCode] = false;
                    TriggerEvaluate(trsUp[keyCode]);
                });
            }
            TriggerAddCondition(trsUp[keyCode], Condition(func));
        }

    }
}

//! endzinc
#endif
