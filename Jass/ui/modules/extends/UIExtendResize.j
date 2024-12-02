#ifndef UIExtendResizeIncluded
#define UIExtendResizeIncluded

//! zinc
/*
扩展自适应大小方法
*/
library UIExtendResize requires Hardware ,UIUtils,UILifeCycle{

    public module extendResize {

        real exWidth;
        real exHeight;

        method setSizeResize (integer width,integer height)  -> nothing {
            real resizeX = GetResizeRate();

            SetUIWidth(this,width);
            SetUIHeight(this,height);
        }
    }

    public struct resizer {
        static thistype List []; //内容列表
        static integer size = 0; //现在有几个东西
        unit u;                  //[成员]绑定的内容
        integer uID;             //[成员]绑定的ID

        method reg (unit u) {　//也可以放在create里
            this.u = u; //数据设置都放这

            if (uID == 0) { //这里是初始化时的设置内容,不需要改
                size       += 1;
                List[size]  = this;
                uID         = size;
            }
        }

        method unreg () { //也可以放在onDestroy里
            u = null; //数据解除都放这里

            if (uID != 0) {
                List[uID]      = List[size];
                List[uID].uID  = uID;
                size          -= 1;
                uID            = 0;
            }
        }

    }

    function onInit ()  {
        hardware.regResizeEvent(function () { //注册窗口大小变化事件
            real resizeX = GetResizeRate();
            integer i , this;
            if (size > 0) {
                for (1 <= i <= size) {
                    //for (i = size; i >= 1; i -= 1) { //反向遍历可以删除下面的　i-= 1
                    this = List[i]; //从结论来说i就是.uID
                    //todo   //干的活在这 .u

                    if (true) {  //删除的条件
                        unreg();
                        i -= 1;　//正向遍历必须要保留这条,往前遍历一次
                    }
                }
            }

            if (size <= 0) {} //这里就删计时器吧
        });
    }


}

//! endzinc
#endif
