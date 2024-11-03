#ifndef RandomUtilsIncluded
#define RandomUtilsIncluded

//! zinc
/*
区域采样工具
*/
library RegionUtils {

    public struct triangleXY [] {

        static real x = 0.0 , y = 0.0;

        // 在给定三角形区域内随机生成一个点
        // 参数说明:
        // @param ax,ay - 三角形顶点A的坐标
        // @param bx,by - 三角形顶点B的坐标
        // @param cx,cy - 三角形顶点C的坐标
        // 返回值:
        // 通过静态变量x,y返回随机生成的点坐标
        static method random (real ax,real ay,real bx,real by,real cx,real cy) {
            real rA  = GetRandomReal(0,1.0);
            real rB  = GetRandomReal(0,1.0);
            real abx = bx-ax, aby = by-ay;
            real acx = cx-ax, acy = cy-ay;

            if (rA + rB > 1.0) {
                rA = 1.0 - rA;
                rB = 1.0 - rB;
            }
            x = ax + rA * abx + rB * acx;
            y = ay + rA * aby + rB * acy;
        }
    }

    // 矩形区域内随机取点[内嵌一定范围]
    public function GetRectRandomInnerX ( rect r,real inner ) -> real {
        return GetRandomReal(GetRectMinX(r)+inner,GetRectMaxX(r)-inner);
    }
    // 矩形区域内随机取点[内嵌一定范围]
    public function GetRectRandomInnerY ( rect r,real inner ) -> real {
        return GetRandomReal(GetRectMinY(r)+inner,GetRectMaxY(r)-inner);
    }
    // 矩形区域内随机取点
    public function GetRectRandomX ( rect r ) -> real {
        return GetRandomReal(GetRectMinX(r),GetRectMaxX(r));
    }
    // 矩形区域内随机取点
    public function GetRectRandomY ( rect r ) -> real {
        return GetRandomReal(GetRectMinY(r),GetRectMaxY(r));
    }

}

//! endzinc
#endif
