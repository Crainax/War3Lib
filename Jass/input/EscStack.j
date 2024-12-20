#ifndef EscStackIncluded
#define EscStackIncluded

#include "Crainax/input/constant/KeyConstants.j"

//! zinc
/*
Esc栈
*/
library EscStack requires Keyboard {

    public type escStackFunc extends function(player);

    private struct EscStackData {
        escStackFunc func;
        EscStackData prev;
        integer id;
    }


    public struct escStack {
        private static EscStackData top = 0;
        private static integer size = 0;
        private static integer nextId = 1;

        // 将函数压入栈中，返回唯一标识符
        static method push(escStackFunc func) -> integer {
            EscStackData data = EscStackData.create();
            data.func = func;
            data.prev = thistype.top;
            data.id = thistype.nextId;
            thistype.nextId += 1;
            thistype.top = data;
            thistype.size += 1;
            return data.id;
        }

        // 弹出并执行栈顶的函数
        static method pop() -> boolean {
            EscStackData data;
            if (thistype.size == 0) {
                return false;
            }

            data = thistype.top;
            thistype.top = data.prev;
            thistype.size -= 1;

            // 执行函数
            data.func.evaluate(GetLocalPlayer());
            data.destroy();

            return true;
        }

        // 根据ID移除特定的函数（不执行）
        static method remove(integer id) -> boolean {
            EscStackData curr = thistype.top;
            EscStackData prev = 0;

            while (curr != 0) {
                if (curr.id == id) {
                    // 如果是栈顶元素
                    if (prev == 0) {
                        thistype.top = curr.prev;
                    } else {
                        prev.prev = curr.prev;
                    }
                    thistype.size -= 1;
                    curr.destroy();
                    return true;
                }
                prev = curr;
                curr = curr.prev;
            }
            return false;
        }

        // 获取当前栈大小
        static method getSize() -> integer {
            return thistype.size;
        }

        // 清空栈
        static method clear() {
            while (thistype.pop()) {
            }
        }


        static method onInit () {
            // 注册ESC按键事件
            keyboard.regKeyDownEvent(KEY_ESC, function() {
                thistype.pop();
            });
            keyboard.regKeyUpEvent(KEY_ESC, null);
        }

    }

}

//! endzinc
#endif
