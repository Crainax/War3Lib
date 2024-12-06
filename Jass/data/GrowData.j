#ifndef GrowDataIncluded
#define GrowDataIncluded

//! zinc
/*
图标流光的数据
*/
#define ICONGROW_1       1  //蓝光长时等待型
#define ICONGROW_2       2  //双火环绕型
#define ICONGROW_3       3  //闪电流光型
#define ICONGROW_4       4  //紫抛光
#define ICONGROW_5       5  //辰龙流光
#define ICONGROW_6       6  //泛绿光
#define ICONGROW_7       7  //品质-白
#define ICONGROW_8       8  //品质-绿
#define ICONGROW_9       9  //品质-蓝
#define ICONGROW_10      10 //偏折组-1红光
#define ICONGROW_11      11 //品质-紫
#define ICONGROW_12      12 //品质-橙
#define ICONGROW_13      13 //品质-红
#define ICONGROW_14      14 //[IG新2]光彩组-1红
#define ICONGROW_15      15 //[IG新2]偏折组-2黄光
#define ICONGROW_16      16 //[IG新2]偏折组-3紫光
#define ICONGROW_17      17 //[IG新2]偏折组-4蓝光
#define ICONGROW_18      18 //[IG新2]光彩组-2蓝
#define ICONGROW_BTN     19 //[IG新2]光彩按钮
#define ICONGROW_20      20 //[IG新2]光彩组-3绿
#define ICONGROW_21      21 //[IG新2]光彩组-4橙
#define GIF_UPGRADE      22 //异度下的强化成功
#define GIF_SHAKEWAVE1   23 //异度下的小型冲击波
#define GIF_STAR         24 //异度下的星星获得
#define SEQ_LOADING      25 //Loading圖
#define GIF_BUFF         26 //BUFF:提高
#define GIF_ICON_FLASH   27 //最常用的那个刷新动画
#define GIF_ICON_FLASH_2 28 //第二常用的刷新动画
#define GIF_ICON_CLICK   29 //点击动画
#define GIF_ICON_LEVELUP 30 //升级动画

library GrowData {

    public struct growdata [] {

        public {
            integer max;//帧数周期
            integer gap;//播放间隔
            real scale; //UI放大的倍数
            string path;//文件路径
        }
        static method onInit () {

            #define GROWDATA_DEFINE(index, maxValue, gapValue, scaleValue, pathValue) \
                thistype[index].max = maxValue; \
                thistype[index].gap = gapValue; \
                thistype[index].scale = scaleValue; \
                thistype[index].path = pathValue;

            //# check: growdata[1]
            //# sequence: ui/icongrow/ig1_{0-63}.blp
            GROWDATA_DEFINE(ICONGROW_1, 63, 2, 2.65, "ui\\icongrow\\ig1_")
            //# endcheck

            //# check: growdata[2]
            //# sequence: ui/icongrow/ig2_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_2, 11, 3, 1.4, "ui\\icongrow\\ig2_")
            //# endcheck

            //# check: growdata[3]
            //# sequence: ui/icongrow/ig3_{0-13}.blp
            GROWDATA_DEFINE(ICONGROW_3, 13, 3, 1.48, "ui\\icongrow\\ig3_")
            //# endcheck

            //# check: growdata[4]
            //# sequence: ui/icongrow/ig4_{0-14}.blp
            GROWDATA_DEFINE(ICONGROW_4, 14, 3, 1.25, "ui\\icongrow\\ig4_")
            //# endcheck

            //# check: growdata[5]
            //# sequence: ui/icongrow/ig5_{0-15}.blp
            GROWDATA_DEFINE(ICONGROW_5, 15, 4, 1.66, "ui\\icongrow\\ig5_")
            //# endcheck

            //# check: growdata[6]
            //# sequence: ui/icongrow/ig6_{0-23}.blp
            GROWDATA_DEFINE(ICONGROW_6, 23, 3, 1.8, "ui\\icongrow\\ig6_")
            //# endcheck

            //# check: growdata[7]
            //# sequence: ui/icongrow/ig7_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_7, 11, 4, 2.0, "ui\\icongrow\\ig7_")
            //# endcheck

            //# check: growdata[8]
            //# sequence: ui/icongrow/ig8_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_8, 11, 4, 2.0, "ui\\icongrow\\ig8_")
            //# endcheck

            //# check: growdata[9]
            //# sequence: ui/icongrow/ig9_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_9, 11, 4, 2.0, "ui\\icongrow\\ig9_")
            //# endcheck

            //# check: growdata[10]
            //# sequence: ui/icongrow/ig10_{0-15}.blp
            GROWDATA_DEFINE(ICONGROW_10, 15, 3, 1.22, "ui\\icongrow\\ig10_")
            //# endcheck

            //# check: growdata[11]
            //# sequence: ui/icongrow/ig11_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_11, 11, 4, 2.0, "ui\\icongrow\\ig11_")
            //# endcheck

            //# check: growdata[12]
            //# sequence: ui/icongrow/ig12_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_12, 11, 4, 2.0, "ui\\icongrow\\ig12_")
            //# endcheck

            //# check: growdata[13]
            //# sequence: ui/icongrow/ig13_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_13, 11, 4, 2.0, "ui\\icongrow\\ig13_")
            //# endcheck

            //# check: growdata[15]
            //# sequence: ui/efx/ig104_{0-15}.blp
            GROWDATA_DEFINE(ICONGROW_15, 15, 3, 1.22, "ui\\efx\\ig104_")
            //# endcheck

            //# check: growdata[16]
            //# sequence: ui/efx/ig107_{0-15}.blp
            GROWDATA_DEFINE(ICONGROW_16, 15, 3, 1.22, "ui\\efx\\ig107_")
            //# endcheck

            //# check: growdata[17]
            //# sequence: ui/efx/ig103_{0-15}.blp
            GROWDATA_DEFINE(ICONGROW_17, 15, 3, 1.22, "ui\\efx\\ig103_")
            //# endcheck

            //# check: growdata[19]
            //# sequence: ui/efx/ig102_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_BTN, 11, 3, 1.3, "ui\\efx\\ig102_")
            //# endcheck

            //# check: growdata[14]
            //# sequence: ui/efx/ig101_{0-9}.blp
            GROWDATA_DEFINE(ICONGROW_14, 9, 3, 1.49, "ui\\efx\\ig101_")
            //# endcheck

            //# check: growdata[18]
            //# sequence: ui/efx/ig100_{0-9}.blp
            GROWDATA_DEFINE(ICONGROW_18, 9, 3, 1.38, "ui\\efx\\ig100_")
            //# endcheck

            //# check: growdata[20]
            //# sequence: ui/efx/ig105_{0-9}.blp
            GROWDATA_DEFINE(ICONGROW_20, 9, 3, 1.49, "ui\\efx\\ig105_")
            //# endcheck

            //# check: growdata[21]
            //# sequence: ui/efx/ig106_{0-9}.blp
            GROWDATA_DEFINE(ICONGROW_21, 9, 3, 1.49, "ui\\efx\\ig106_")
            //# endcheck

            //# check: growdata[22]
            //# sequence: ui/gif/gif1_{0-16}.blp
            GROWDATA_DEFINE(GIF_UPGRADE, 16, 3, 3.5, "ui\\gif\\gif1_")
            //# endcheck

            //# check: growdata[23]
            //# sequence: ui/gif/gif2_{0-14}.blp
            GROWDATA_DEFINE(GIF_SHAKEWAVE1, 14, 2, 2.5, "ui\\gif\\gif2_")
            //# endcheck

            //# check: growdata[24]
            //# sequence: ui/gif/gif3_{0-17}.blp
            GROWDATA_DEFINE(GIF_STAR, 17, 2, 3.5, "ui\\gif\\gif3_")
            //# endcheck

            //# check: growdata[25]
            //# sequence: ui/efx/ig109_{0-23}.blp
            GROWDATA_DEFINE(SEQ_LOADING, 23, 3, 3.5, "ui\\efx\\ig109_")
            //# endcheck

            //# check: growdata[26]
            //# sequence: ui/efx/ig108_{0-41}.blp
            GROWDATA_DEFINE(GIF_BUFF, 41, 1, 3.0, "ui\\efx\\ig108_")
            //# endcheck

            //# check: growdata[27]
            //# sequence: ui/efx/ig110_{0-15}.blp
            GROWDATA_DEFINE(GIF_ICON_FLASH, 15, 3, 1.38, "ui\\efx\\ig110_")
            //# endcheck

            //# check: growdata[28]
            //# sequence: ui/efx/ig111_{0-10}.blp
            GROWDATA_DEFINE(GIF_ICON_FLASH_2, 10, 3, 1.8, "ui\\efx\\ig111_")
            //# endcheck

            //# check: growdata[29]
            //# sequence: ui/efx/ig112_{0-13}.blp
            GROWDATA_DEFINE(GIF_ICON_CLICK, 13, 1, 1.7, "ui\\efx\\ig112_")
            //# endcheck

            //# check: growdata[30]
            //# sequence: ui/efx/ig113_{0-16}.blp
            GROWDATA_DEFINE(GIF_ICON_LEVELUP, 16, 3, 2.1, "ui\\efx\\ig113_")
            //# endcheck
        }
    }
}

//! endzinc
#endif