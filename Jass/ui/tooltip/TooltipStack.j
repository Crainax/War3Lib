#ifndef ToolTipStackIncluded
#define ToolTipStackIncluded

#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
Tooltip栈,保证每次进出都删除所有Tooltip,防止那些没读取到onLeave键的Tooltip残留
*/
library ToolTipStack {

#ifndef ESC_STACK_FUNC_DEFINED
#define ESC_STACK_FUNC_DEFINED
    public type escStackFunc extends function(player);
#endif

    private struct TipData {
        escStackFunc func;
        TipData prev;
        integer id;
    }

    public struct tooltipStack []{
        private static TipData top = 0;
        private static integer size = 0;
        private static integer nextId = 1;

        // 将函数压入栈中，返回唯一标识符
        static method push(escStackFunc func) -> integer {
            TipData data = TipData.create();
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
            TipData data;
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

        //压入原生的处理
        static method pushOrigin () {
            DzFrameSetAbsolutePoint(DzFrameGetTooltip(),ANCHOR_BOTTOMRIGHT,0,0); //移走
            push(function(player p) {
                DzFrameSetAbsolutePoint(DzFrameGetTooltip(),ANCHOR_BOTTOMRIGHT,.8,.1625); //移回
            });
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

    }
}

//! endzinc
#endif
