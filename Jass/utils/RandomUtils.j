#ifndef RandomUtilsIncluded
#define RandomUtilsIncluded

//! zinc
/*
随机数工具
*/
library RandomUtils {

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
