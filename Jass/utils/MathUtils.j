#ifndef MathUtilsIncluded
#define MathUtilsIncluded

//! zinc
/*
数学工具
*/
library MathUtils {

    real RTriangleX = 0.0; //三角形随机取点X
    real RTriangleY = 0.0; //三角形随机取点Y
    //三角形随机取点[RTriangleX/RTriangleY]来取
    public function InitTriangleRandomXY (real ax,real ay,real bx,real by,real cx,real cy) {
        real rA  = GetRandomReal(0,1.0);
        real rB  = GetRandomReal(0,1.0);
        real abx = bx-ax , aby = by-ay;
        real acx = cx-ax , acy = cy-ay;

        if (rA + rB > 1.0) {
            rA = 1.0 - rA;
            rB = 1.0 - rB;
        }
        RTriangleX = ax + rA * abx + rB * acx;
        RTriangleY = ay + rA * aby + rB * acy;
    }

    public struct triangleRandom [] {


        static method function_name ()  -> nothing {}
    }

    // 计算射线与地图边界的交点
    public struct radiationEnd [] {
        static real x = 0,y = 0;

        //修正一下Tan这个函数的问题(精确到1度)
        private static method tan (real angle)  -> real {
            real a = ModuloReal(angle,180); //求余数
            if (a < 1.0) { //接近0度
                return 0.0001;
            } else if (a > 179.0) { //接近180度
                return -0.0001;
            } else if (a > 89 && a <= 90) { //89-90
                return 55555.0;
            } else if (a > 90 && a < 91) { //90-91
                return -55555.0;
            } else { //正常角度
                return TanBJ(angle);
            }
        }

        //一个坐标沿着某个方向的边缘值
        // 输入参数:
        // x1, y1: 起始点坐标
        // angle: 射线的角度（0-360度）

        // 功能说明：
        // 1. 计算从点(x1,y1)出发，沿angle角度方向的射线与地图边界的交点
        // 2. 将计算结果存储在结构体的静态变量x和y中
        // 3. 根据角度不同分为四个象限处理：
        //    - 0-90度：第一象限，可能与上边界或右边界相交
        //    - 90-180度：第二象限，可能与上边界或左边界相交
        //    - 180-270度：第三象限，可能与下边界或左边界相交
        //    - 270-360度：第四象限，可能与下边界或右边界相交
        // 这个函数在游戏中经常用于：
        // 限制单位移动范围
        // 计算技能射程终点
        // 确定视线或投射物的最远点
        static method cal (real x1,real y1,real angle) {
            real x2  = 0; //相交点
            real y2  = 0; //相交点
            real a = ModuloReal(angle,360); //求余数
            real tan;
            x = 0;
            y = 0;
            if (a <= 90) { //第一象限
                tan = tan(a);
                x2 = (yd_MapMaxY - y1) / tan + x1;
                y2 = (yd_MapMaxX - x1) * tan + y1;
                if (x2 <= yd_MapMaxX) { //取这个
                    x = x2;
                    y = yd_MapMaxY;
                } else {
                    x = yd_MapMaxX;
                    y = y2;
                }
            } else if( a <= 180) { //第二象限
                tan = tan(a);
                x2 = (yd_MapMaxY - y1) / tan + x1;
                y2 = (yd_MapMinX - x1) * tan + y1;
                if (x2 >= yd_MapMinX) { //取这个
                    x = x2;
                    y = yd_MapMaxY;
                } else {
                    x = yd_MapMinX;
                    y = y2;
                }
            } else if( a <= 270) { //第三象限
                tan = tan(a);
                x2 = (yd_MapMinY - y1) / tan + x1;
                y2 = (yd_MapMinX - x1) * tan + y1;
                if (x2 >= yd_MapMinX) { //取这个
                    x = x2;
                    y = yd_MapMinY;
                } else {
                    x = yd_MapMinX;
                    y = y2;
                }
            } else { //第四象限
                tan = tan(a);
                x2 = (yd_MapMinY - y1) / tan + x1;
                y2 = (yd_MapMaxX - x1) * tan + y1;
                if (x2 <= yd_MapMaxX) { //取这个
                    x = x2;
                    y = yd_MapMinY;
                } else {
                    x = yd_MapMaxX;
                    y = y2;
                }
            }
        }
    }


}

//! endzinc
#endif
