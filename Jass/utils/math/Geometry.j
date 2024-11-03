#ifndef GeometryIncluded
#define GeometryIncluded

//! zinc
/*
几何工具
todo:直接用宏定义修改试试
*/
library Geometry {

    // 4个坐标的距离
    public function GetDistance (real x1,real y1,real x2,real y2) -> real {
        real dx = x2 - x1 , dy = y2 - y1;
        return SquareRoot(dx*dx+dy*dy);
    }
    // 6个坐标的距离
    public function GetDistanceZ (real x1,real y1,real z1,real x2,real y2,real z2) -> real {
        real dx = x2 - x1 , dy = y2 - y1, dz = z2 - z1;
        return SquareRoot(dx*dx+dy*dy+dz*dz);
    }
    // 4个坐标的角度,前面是人的位置，后面是点的位置
    public function GetFacing (real x1,real y1,real x2,real y2) -> real {
        return Atan2BJ(y2-y1,x2-x1);
    }

}

//! endzinc
#endif
