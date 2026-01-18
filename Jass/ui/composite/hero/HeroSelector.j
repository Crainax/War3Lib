#ifndef HeroSelectorIncluded
#define HeroSelectorIncluded

#include "Crainax/config/SharedMethod.h"       // 结构体共用方法、I3 等工具
#include "Crainax/ui/constants/UIConstants.j"  // UI 常量

//! zinc
/*
英雄选择 UI（新框架）
左侧 6x4 网格 + 滑块，右侧留空，由外部扩展。
*/

#define HEROSEL_MAIN_WIDTH      0.68
#define HEROSEL_MAIN_HEIGHT     0.36

// 大图总宽高（4 张 512x512 图片拼成 2416x1220，保持比例，宽固定 0.75）
#define HEROSEL_BG_FULL_WIDTH     0.75
#define HEROSEL_BG_FULL_HEIGHT    (HEROSEL_BG_FULL_WIDTH * 828.0 / 1528.0)

// 左侧网格
#define HEROSEL_GRID_COLS 6
#define HEROSEL_GRID_ROWS 4
#define HEROSEL_CELL_SIZE 0.0650
#define HEROSEL_CELL_GAP_X 0.008
#define HEROSEL_CELL_GAP_Y 0.008
#define HEROSEL_GRID_OFFSET_X 0.020
#define HEROSEL_GRID_OFFSET_Y -0.045

// 滑块
#define HEROSEL_SLIDER_WIDTH      0.0074*2
#define HEROSEL_SLIDER_HEIGHT     0.29
#define HEROSEL_SLIDER_GAP_X      0.008
#define HEROSEL_SLIDER_BTN_SCALE  2.5

// 右侧占位区域
#define HEROSEL_CONTENT_MARGIN_X 0.008
#define HEROSEL_CONTENT_MARGIN_Y 0.008

//# dependency:resource/ui/image/black.blp
//# dependency:resource/ui/image/select_close.blp
//# dependency:resource/ui/image/vertical_divider.blp
//# dependency:resource/ui/image/select_flash.blp
//# dependency:resource/ui/image/museum_01.blp
//# dependency:resource/ui/image/museum_02.blp
//# dependency:resource/ui/image/museum_03.blp
//# dependency:resource/ui/image/museum_04.blp

library HeroSelector requires UISlider,UIImage,UIButton,UIText,UIHashTable {

    //==========================================================================
    // 英雄数据（集中放置）
    //==========================================================================
    public struct heroData {
        integer heroId;
        string  name;
        string  icon;
        integer index;

        STRUCT_SHARED_INNER_UI(heroData)

        private static thistype list[];
        private static integer size = 0;
        private static thistype callbackData = 0;

        public static method registerHero(integer id, string n, string iconPath) -> thistype {
            thistype this = allocate();
            if (this <= 0) {
                return 0;
            }

            this.heroId = id;
            this.name   = n;
            this.icon   = iconPath;

            thistype.size += 1;
            this.index = thistype.size;
            thistype.list[thistype.size] = this;
            return this;
        }

        public static method getSize() -> integer {
            return thistype.size;
        }

        public static method getByIndex(integer idx) -> thistype {
            if (idx < 1 || idx > thistype.size) {
                return 0;
            }
            return thistype.list[idx];
        }

        public static method setCallbackData(thistype hd) {
            thistype.callbackData = hd;
        }

        public static method getCallbackData() -> thistype {
            return thistype.callbackData;
        }

        public static method clearCallbackData() {
            thistype.callbackData = 0;
        }
    }

    //==========================================================================
    // UI 单例控制器
    //==========================================================================
    public struct heroSelectorUI [] {
        private static uiImage uiMain = 0;
        private static uiBtn   uiMainButton = 0;

        private static uiImage bgImage1 = 0; // 右下
        private static uiImage bgImage2 = 0; // 左下
        private static uiImage bgImage3 = 0; // 右上
        private static uiImage bgImage4 = 0; // 左上

        private static uiImage slotBg[HEROSEL_GRID_ROWS][HEROSEL_GRID_COLS];
        private static uiBtn   slotBtn[HEROSEL_GRID_ROWS][HEROSEL_GRID_COLS];

        private static uiSlider leftSlider = 0;

        private static uiImage uiDivider = 0;
        private static uiImage uiRightArea = 0;

        private static boolean isOpen = false;
        private static player owner = null;

        public static method show(player p) {
            integer r; integer c; integer idx;
            real offsetX; real offsetY;
            real leftGridWidth; real sliderX;
            real contentLeftX;

            if (GetLocalPlayer() != p) { return; }
            if (isOpen) { return; }

            isOpen = true;
            owner = p;

            uiMain = uiImage.create(DzGetGameUI())
                .setTexture("ui\\image\\black.blp")
                .exReSize(HEROSEL_MAIN_WIDTH, HEROSEL_MAIN_HEIGHT)
                .exRePoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0);

            uiMainButton = uiBtn.createBlank(uiMain.ui)
                .setAllPoint(uiMain.ui)
                .enableDrag(uiMain.ui, 0.25, 0.55, 0.34, 0.5)
                .setDragPosition(0.4, 0.25);

            // 背景拼图
            bgImage1 = uiImage.create(uiMain.ui)
                .exReSize(HEROSEL_BG_FULL_WIDTH * 0.5, HEROSEL_BG_FULL_HEIGHT * 0.5)
                .setTexture("ui\\image\\museum_01.blp")
                .exRePoint(ANCHOR_BOTTOMRIGHT, uiMain.ui, ANCHOR_CENTER, 0.001, -0.001);

            bgImage2 = uiImage.create(uiMain.ui)
                .exReSize(HEROSEL_BG_FULL_WIDTH * 0.5, HEROSEL_BG_FULL_HEIGHT * 0.5)
                .setTexture("ui\\image\\museum_02.blp")
                .exRePoint(ANCHOR_BOTTOMLEFT, uiMain.ui, ANCHOR_CENTER, -0.001, -0.001);

            bgImage3 = uiImage.create(uiMain.ui)
                .exReSize(HEROSEL_BG_FULL_WIDTH * 0.5, HEROSEL_BG_FULL_HEIGHT * 0.5)
                .setTexture("ui\\image\\museum_03.blp")
                .exRePoint(ANCHOR_TOPRIGHT, uiMain.ui, ANCHOR_CENTER, 0.001, 0.001);

            bgImage4 = uiImage.create(uiMain.ui)
                .exReSize(HEROSEL_BG_FULL_WIDTH * 0.5, HEROSEL_BG_FULL_HEIGHT * 0.5)
                .setTexture("ui\\image\\museum_04.blp")
                .exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_CENTER, -0.001, 0.001);

            // 左侧网格
            idx = 0;
            for (1 <= r <= HEROSEL_GRID_ROWS) {
                for (1 <= c <= HEROSEL_GRID_COLS) {
                    idx += 1;
                    offsetX = HEROSEL_GRID_OFFSET_X + (c - 1) * (HEROSEL_CELL_SIZE + HEROSEL_CELL_GAP_X);
                    offsetY = HEROSEL_GRID_OFFSET_Y - (r - 1) * (HEROSEL_CELL_SIZE + HEROSEL_CELL_GAP_Y);

                    slotBg[r][c] = uiImage.create(uiMain.ui)
                        .exReSize(HEROSEL_CELL_SIZE, HEROSEL_CELL_SIZE)
                        .setTexture("ui\\image\\select_flash.blp")
                        .exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, offsetX, offsetY);

                    slotBtn[r][c] = uiBtn.create(slotBg[r][c].ui)
                        .setAllPoint(slotBg[r][c].ui)
                        .spClick(function(integer frame) {
                            integer pos = uiHashTable(frame).eventdata.get();
                            pos = pos; // 预留：后续接入 heroData 映射
                        });

                    uiHashTable(slotBtn[r][c].ui).eventdata.bind(idx);
                }
            }

            leftGridWidth = HEROSEL_GRID_COLS * HEROSEL_CELL_SIZE + (HEROSEL_GRID_COLS - 1) * HEROSEL_CELL_GAP_X;
            sliderX = HEROSEL_GRID_OFFSET_X + leftGridWidth + HEROSEL_SLIDER_GAP_X;

            leftSlider = uiSlider.create(uiMain.ui)
                .setSize(HEROSEL_SLIDER_WIDTH, HEROSEL_SLIDER_HEIGHT)
                .setMinMaxValue(1.0, 1.0)
                .setStep(1.0)
                .setValue(1.0)
                .setThumbScale(HEROSEL_SLIDER_BTN_SCALE)
                .setPoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, sliderX, HEROSEL_GRID_OFFSET_Y)
                .onChange(function(uiSlider s) {});

            // 右侧空白区域占位
            contentLeftX = sliderX + HEROSEL_SLIDER_WIDTH + HEROSEL_CONTENT_MARGIN_X;
            uiRightArea = uiImage.create(uiMain.ui)
                .setTexture(UI_STRING_PATH_BLANK)
                .setPoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, contentLeftX, HEROSEL_GRID_OFFSET_Y)
                .setPoint(ANCHOR_BOTTOMRIGHT, uiMain.ui, ANCHOR_BOTTOMRIGHT, -HEROSEL_CONTENT_MARGIN_X, HEROSEL_CONTENT_MARGIN_Y);

            uiDivider = uiImage.create(uiMain.ui)
                .exReSize(0.003, HEROSEL_MAIN_HEIGHT - 0.01 + HEROSEL_GRID_OFFSET_Y)
                .setTexture("ui\\image\\vertical_divider.blp")
                .exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, contentLeftX - HEROSEL_CONTENT_MARGIN_X * 0.5, HEROSEL_GRID_OFFSET_Y);
        }

        public static method hide(player p) {
            integer r; integer c;
            if (GetLocalPlayer() != p) { return; }
            if (!isOpen) { return; }

            for (1 <= r <= HEROSEL_GRID_ROWS) {
                for (1 <= c <= HEROSEL_GRID_COLS) {
                    if (slotBtn[r][c] != 0) { slotBtn[r][c].destroy(); slotBtn[r][c] = 0; }
                    if (slotBg[r][c] != 0) { slotBg[r][c].destroy(); slotBg[r][c] = 0; }
                }
            }

            if (leftSlider != 0) { leftSlider.destroy(); leftSlider = 0; }
            if (uiDivider != 0) { uiDivider.destroy(); uiDivider = 0; }
            if (uiRightArea != 0) { uiRightArea.destroy(); uiRightArea = 0; }
            if (uiMainButton != 0) { uiMainButton.destroy(); uiMainButton = 0; }
            if (bgImage1 != 0) { bgImage1.destroy(); bgImage1 = 0; }
            if (bgImage2 != 0) { bgImage2.destroy(); bgImage2 = 0; }
            if (bgImage3 != 0) { bgImage3.destroy(); bgImage3 = 0; }
            if (bgImage4 != 0) { bgImage4.destroy(); bgImage4 = 0; }
            if (uiMain != 0) { uiMain.destroy(); uiMain = 0; }

            owner = null;
            isOpen = false;
        }

        // 判断 UI 是否正在显示
        public static method isShow() -> boolean {
            return isOpen;
        }

    }

    public function GetHeroSelectorEventData() -> heroData {
        return heroData.getCallbackData();
    }
}

//! endzinc

#undef HEROSEL_MAIN_WIDTH
#undef HEROSEL_MAIN_HEIGHT
#undef HEROSEL_BG_FULL_WIDTH
#undef HEROSEL_BG_FULL_HEIGHT
#undef HEROSEL_GRID_COLS
#undef HEROSEL_GRID_ROWS
#undef HEROSEL_CELL_SIZE
#undef HEROSEL_CELL_GAP_X
#undef HEROSEL_CELL_GAP_Y
#undef HEROSEL_GRID_OFFSET_X
#undef HEROSEL_GRID_OFFSET_Y
#undef HEROSEL_SLIDER_WIDTH
#undef HEROSEL_SLIDER_HEIGHT
#undef HEROSEL_SLIDER_GAP_X
#undef HEROSEL_CONTENT_MARGIN_X
#undef HEROSEL_CONTENT_MARGIN_Y

#endif
