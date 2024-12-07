
#ifndef IconIncluded
#define IconIncluded

//===========================================================================
// Icon.j
//===========================================================================
//
// 模块描述：
//   实现了魔兽争霸3中通用的图标UI组件，支持图标显示、数字标记、
//   按钮功能、流光特效等特性。
//
// 作者：[你的名字]
// 创建日期：[创建日期]
// 最后修改：[最后修改日期]
//
// 依赖项：
//   - UIBase
//   - UIAnim
//   - growdatastruct
//
// 使用示例：
//   icon myIcon = icon.create(parentFrame, true, true);
//   myIcon.size(0.04, 0.04);
//
//===========================================================================


//! zinc
/*
[按钮]整合到了一起
*/
library Icon requires UIBase,UIAnim,growdatastruct {

    public struct icon {

        integer ui;     //图片
        integer text;   //右下角的数字
        integer shade;  //数字的背景
        integer btn;    //按钮
        integer shadow; //覆盖的阴暗
        integer uiBA;   //动画UI
        baseanim ba;    //动画本身
        real sizeX;      //格子的大小
        real sizeY;      //格子的大小
        growdata gd;

        //加入流光
        method grow (integer parent,growdata gd)  { //todo:频繁调用好像会打断现在所有的位置,从0开始循环序列帧
            if (uiBA == 0) { //无流光情况下,新建流光
                uiBA = CreateBackDrop(parent);
                ba = baseanim.create(uiBA);
                DzFrameSetSize(uiBA,sizeX  * gd.scale,sizeY * gd.scale);
                DzFrameSetPoint(uiBA,ANCHOR_CENTER,ui,ANCHOR_CENTER,0,0);
                ba.addSequ(gd.path,gd.max,gd.gap,true);
                this.gd = gd;
            } else { //有流光的情况下,修改里面的数据
                if (gd != this.gd) {
                    ba.addSequ(gd.path,gd.max,gd.gap,true);
                    DzFrameSetSize(uiBA,sizeX  * gd.scale,sizeY * gd.scale);
                    this.gd = gd;
                }
            }
        }
        //取消流光
        method unGrow () {
            if (uiBA != 0) { //删除所有没有流光物品的流光
                DzDestroyFrame(uiBA);
                uiBA = 0;
                ba.destroy();
                ba = 0;
            }
        }
        //设置大小(也可用于resize)
        method size (real x,real y) {
            DzFrameSetSize(ui,x,y);
            if (uiBA != 0) { //动画也调一下
                DzFrameSetSize(uiBA,x  * gd.scale,y * gd.scale);
            }
            sizeX = x;
            sizeY = y;
        }

        //创建新基础的类型,装饰既有的魔兽UI
        //拆分:[UI+BTN]一组,[SHADE+TEXT]一组,[SHADOW]一组,[特效]一组
        //第二个参数是true代表独立的文字右下小框,false耦合到icon中
        static method create (integer parent,boolean dispersion,boolean newBtn) -> thistype {
            thistype this = allocate();
            ui = CreateBackDrop(parent);
            if (dispersion) {
                shade = CreateToolTips1_2(parent);
                shadow = CreateBackDrop(parent);
                DzFrameShow(shade,false);
                DzFrameShow(shadow,false);
            } else {
                shade = CreateToolTips1_2(ui);
                shadow = CreateBackDrop(ui);
            }
            text = NewTextM(shade);
            DzFrameSetPoint(shade,ANCHOR_TOPLEFT,text,ANCHOR_TOPLEFT,-0.003,0.003);
            DzFrameSetPoint(shade,ANCHOR_BOTTOMRIGHT,text,ANCHOR_BOTTOMRIGHT,0.003,-0.003);
            if (newBtn) { //按钮不是必备的
                btn = CreateButton(ui);
                DzFrameSetAllPoints(btn,ui);
            }
            DzFrameSetAllPoints(shadow,ui);
            DzFrameSetTexture(shadow,"ui\\image\\black.blp",0);
            DzFrameSetAlpha(shadow,160);
            DzFrameSetPoint(text,ANCHOR_BOTTOMRIGHT,ui,ANCHOR_BOTTOMRIGHT,-0.003,0.003); //shade的位置固定
            DzFrameShow(ui,false);

            return this;
        }


        //析构[暂时不需要]
        // method onDestroy () {

        // }

    }

}

//! endzinc
#endif
