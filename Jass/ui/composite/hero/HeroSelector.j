#ifndef HeroSelectorIncluded
#define HeroSelectorIncluded

#include "Crainax/config/SharedMethod.h"       // 结构体共用方法、I3 等工具
#include "Crainax/ui/constants/UIConstants.j"  // UI 常量

//! zinc
/*
英雄选择 UI（新框架）
左侧 6x4 网格 + 滑块，右侧留空，由外部扩展。
*/

#define HEROSEL_MAIN_WIDTH      0.72
#define HEROSEL_MAIN_HEIGHT     0.3812

// 大图总宽高（4 张 512x512 图片拼成 2416x1220，保持比例，宽固定 0.75）
#define HEROSEL_BG_FULL_WIDTH     0.7941
#define HEROSEL_BG_FULL_HEIGHT    (HEROSEL_BG_FULL_WIDTH * 828.0 / 1528.0)

// 左侧网格
#define HEROSEL_GRID_COLS 7
#define HEROSEL_GRID_ROWS 4
#define HEROSEL_CELL_SIZE 0.0580
#define HEROSEL_CELL_GAP_X 0.008
#define HEROSEL_CELL_GAP_Y 0.020
#define HEROSEL_GRID_OFFSET_X 0.020
#define HEROSEL_GRID_OFFSET_Y -0.045
#define HEROSEL_TEXT_GAP_Y 0.004
#define HEROSEL_TEXT_LINE_GAP_Y 0.002

// 滑块
#define HEROSEL_SLIDER_WIDTH      0.0074*2
#define HEROSEL_SLIDER_HEIGHT     0.29
#define HEROSEL_SLIDER_GAP_X      0.008
#define HEROSEL_SLIDER_BTN_SCALE  2.5

// 标题
#define HEROSEL_TITLE_HEIGHT      0.022
#define HEROSEL_TITLE_OFFSET_Y    -0.018

// 底部按钮
#define HEROSEL_BOTTOM_BTN_WIDTH   0.1
#define HEROSEL_BOTTOM_BTN_HEIGHT  (0.1 * 0.029 / 0.0724)
#define HEROSEL_BOTTOM_BTN_GAP_X   0.075

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

library HeroSelector requires UISlider,UIImage,UIButton,UIText,UIHashTable,Icon {

    //==========================================================================
    // 英雄数据（集中放置）
    //==========================================================================
    // 结构体数组：不需要 allocate/register，不涉及销毁
    // 使用方式：heroData[1].name / heroData[1].icon / heroData[1].text2
    public struct heroData []{
        public string  name;
        public string  icon;
        public string  text2;
        public static integer size = 0;
        private static thistype callbackData = 0;

        // 设置某个位置的数据（会自动更新 size）
        public static method set(integer idx, string n, string iconPath, string t2) {
            if (idx < 1) { return; }
            heroData[idx].name  = n;
            heroData[idx].icon  = iconPath;
            heroData[idx].text2 = t2;
            thistype.size = IMaxBJ(thistype.size, idx);
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

        private static icon   slotIcon[HEROSEL_GRID_ROWS][HEROSEL_GRID_COLS];
        private static uiText slotTxt1[HEROSEL_GRID_ROWS][HEROSEL_GRID_COLS];
        private static uiText slotTxt2[HEROSEL_GRID_ROWS][HEROSEL_GRID_COLS];

        private static uiSlider leftSlider = 0;

        private static uiText uiTitleText = 0;
        private static uiImage uiBtn1Image = 0;
        private static uiText uiBtn1Text = 0;
        private static uiBtn uiBtn1Button = 0;
        private static uiImage uiBtn2Image = 0;
        private static uiText uiBtn2Text = 0;
        private static uiBtn uiBtn2Button = 0;

        private static uiImage uiDivider = 0;
        private static uiImage uiRightArea = 0;

        private static boolean isOpen = false;
        private static player owner = null;
        private static integer currentPage = 1;
        private static integer totalPage = 1;

        private static method refreshLeftGrid() {
            integer r; integer c; integer idx;
            integer pos; heroData hd;
            integer globalRowIndex; integer totalRows; integer rowIconCount;
            real baseOffsetX; real offsetX; real offsetY;

            // 计算总行数
            totalRows = (heroData.size + HEROSEL_GRID_COLS - 1) / HEROSEL_GRID_COLS;

            idx = 0;
            for (1 <= r <= HEROSEL_GRID_ROWS) {
                // 计算当前显示行对应的全局行号（从1开始）
                globalRowIndex = currentPage + r - 1;

                // 计算当前行有多少个图标（基于全局行号）
                if (globalRowIndex <= totalRows) {
                    // 如果是最后一行，计算实际icon数量
                    if (globalRowIndex == totalRows) {
                        rowIconCount = heroData.size - (globalRowIndex - 1) * HEROSEL_GRID_COLS;
                    } else {
                        rowIconCount = HEROSEL_GRID_COLS;
                    }
                } else {
                    rowIconCount = 0;
                }

                // 计算当前行的起始X偏移（使该行居中）
                if (rowIconCount > 0 && rowIconCount < HEROSEL_GRID_COLS) {
                    // 最后一行不满时居中
                    baseOffsetX = HEROSEL_GRID_OFFSET_X + ((HEROSEL_GRID_COLS - rowIconCount) * (HEROSEL_CELL_SIZE + HEROSEL_CELL_GAP_X)) / 2.0;
                } else {
                    baseOffsetX = HEROSEL_GRID_OFFSET_X;
                }

                for (1 <= c <= HEROSEL_GRID_COLS) {
                    idx += 1;
                    pos = (currentPage - 1) * HEROSEL_GRID_COLS + idx;

                    offsetX = baseOffsetX + (c - 1) * (HEROSEL_CELL_SIZE + HEROSEL_CELL_GAP_X);
                    offsetY = HEROSEL_GRID_OFFSET_Y - (r - 1) * (HEROSEL_CELL_SIZE + HEROSEL_CELL_GAP_Y);

                    if (pos <= heroData.size && c <= rowIconCount) {
                        hd = heroData[pos];
                        if (hd != 0 && slotIcon[r][c] != 0) {
                            slotIcon[r][c].setTexture(S3(hd.icon != null, hd.icon, UI_STRING_PATH_BLANK));
                            slotIcon[r][c].exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, offsetX, offsetY);
                            slotIcon[r][c].show(true);
                            uiHashTable(slotIcon[r][c].getClickBtn().ui).eventdata.bind(pos);
                        }
                        if (slotTxt1[r][c] != 0) {
                            slotTxt1[r][c].setText("1字:+" + I2S(pos));
                            slotTxt1[r][c].show(true);
                        }
                        if (slotTxt2[r][c] != 0) {
                            slotTxt2[r][c].setText(S3(hd.text2 != null, hd.text2, "文本2"));
                            slotTxt2[r][c].show(true);
                        }
                    } else {
                        if (slotIcon[r][c] != 0) { slotIcon[r][c].show(false); }
                        if (slotTxt1[r][c] != 0) { slotTxt1[r][c].show(false); }
                        if (slotTxt2[r][c] != 0) { slotTxt2[r][c].show(false); }
                    }
                }
            }
        }

        private static method onSliderChange(uiSlider s) {
            integer v;
            if (!isOpen || s == 0) { return; }
            v = R2I(s.getValue());
            currentPage = totalPage - v + 1;
            if (currentPage < 1) { currentPage = 1; }
            if (currentPage > totalPage) { currentPage = totalPage; }
            refreshLeftGrid();
        }

        private static method onMouseWheel() {
            real delta;
            integer targetPage;
            integer sliderValue;

            if (!isOpen || totalPage <= 1) { return; }
            delta = DzGetWheelDelta();
            if (delta < 0) {
                targetPage = IMinBJ(currentPage + 1, totalPage);
            } else {
                targetPage = IMaxBJ(currentPage - 1, 1);
            }
            if (targetPage == currentPage) { return; }
            currentPage = targetPage;
            sliderValue = totalPage - currentPage + 1;
            if (leftSlider != 0) {
                leftSlider.setValue(sliderValue);
            } else {
                refreshLeftGrid();
            }
        }

        public static method show(player p) {
            integer r; integer c; integer idx;
            integer totalRows;
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
                .setDragPosition(0.4, 0.3)
                .onMouseWheel(function heroSelectorUI.onMouseWheel);

            // 背景拼图
            // bgImage1 = uiImage.create(uiMain.ui)
            //     .exReSize(HEROSEL_BG_FULL_WIDTH * 0.5, HEROSEL_BG_FULL_HEIGHT * 0.5)
            //     .setTexture("ui\\image\\museum_01.blp")
            //     .exRePoint(ANCHOR_BOTTOMRIGHT, uiMain.ui, ANCHOR_CENTER, 0.001, -0.001);

            // bgImage2 = uiImage.create(uiMain.ui)
            //     .exReSize(HEROSEL_BG_FULL_WIDTH * 0.5, HEROSEL_BG_FULL_HEIGHT * 0.5)
            //     .setTexture("ui\\image\\museum_02.blp")
            //     .exRePoint(ANCHOR_BOTTOMLEFT, uiMain.ui, ANCHOR_CENTER, -0.001, -0.001);

            // bgImage3 = uiImage.create(uiMain.ui)
            //     .exReSize(HEROSEL_BG_FULL_WIDTH * 0.5, HEROSEL_BG_FULL_HEIGHT * 0.5)
            //     .setTexture("ui\\image\\museum_03.blp")
            //     .exRePoint(ANCHOR_TOPRIGHT, uiMain.ui, ANCHOR_CENTER, 0.001, 0.001);

            // bgImage4 = uiImage.create(uiMain.ui)
            //     .exReSize(HEROSEL_BG_FULL_WIDTH * 0.5, HEROSEL_BG_FULL_HEIGHT * 0.5)
            //     .setTexture("ui\\image\\museum_04.blp")
            //     .exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_CENTER, -0.001, 0.001);

            // 左侧网格标题
            uiTitleText = uiText.create(uiMain.ui)
                .exReSize(HEROSEL_GRID_COLS * HEROSEL_CELL_SIZE, HEROSEL_TITLE_HEIGHT)
                .exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, HEROSEL_GRID_OFFSET_X, HEROSEL_TITLE_OFFSET_Y)
                .setAlign(4)
                .setFontSize(7)
                .setText("|cffff9900选择英雄|r");

            // 左侧网格
            idx = 0;
            for (1 <= r <= HEROSEL_GRID_ROWS) {
                for (1 <= c <= HEROSEL_GRID_COLS) {
                    idx += 1;
                    offsetX = HEROSEL_GRID_OFFSET_X + (c - 1) * (HEROSEL_CELL_SIZE + HEROSEL_CELL_GAP_X);
                    offsetY = HEROSEL_GRID_OFFSET_Y - (r - 1) * (HEROSEL_CELL_SIZE + HEROSEL_CELL_GAP_Y);

                    slotIcon[r][c] = icon.create(uiMain.ui)
                        .enableResize()
                        .setTexture("ui\\image\\select_flash.blp")
                        .setSize(HEROSEL_CELL_SIZE, HEROSEL_CELL_SIZE)
                        .exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, offsetX, offsetY);
                    slotIcon[r][c].show(false);

                    slotIcon[r][c].getClickBtn()
                        .onMouseWheel(function heroSelectorUI.onMouseWheel)
                        .spClick(function(integer frame) {
                            integer pos = uiHashTable(frame).eventdata.get();
                            pos = pos; // 预留：后续接入 heroData 映射
                        });
                    uiHashTable(slotIcon[r][c].getClickBtn().ui).eventdata.bind(idx);

                    slotTxt1[r][c] = uiText.create(uiMain.ui)
                        .setAlign(4)
                        .setFontSize(2)
                        .setPoint(ANCHOR_TOP, slotIcon[r][c].mainImage.ui, ANCHOR_BOTTOM, 0, -HEROSEL_TEXT_GAP_Y)
                        .show(false);

                    slotTxt2[r][c] = uiText.create(uiMain.ui)
                        .setAlign(4)
                        .setFontSize(2)
                        .setPoint(ANCHOR_TOP, slotTxt1[r][c].ui, ANCHOR_BOTTOM, 0, -HEROSEL_TEXT_LINE_GAP_Y)
                        .show(false);
                }
            }

            leftGridWidth = HEROSEL_GRID_COLS * HEROSEL_CELL_SIZE + (HEROSEL_GRID_COLS - 1) * HEROSEL_CELL_GAP_X;
            sliderX = HEROSEL_GRID_OFFSET_X + leftGridWidth + HEROSEL_SLIDER_GAP_X;

            totalRows = (heroData.size + HEROSEL_GRID_COLS - 1) / HEROSEL_GRID_COLS;
            totalPage = IMaxBJ(1, totalRows - HEROSEL_GRID_ROWS + 1);
            currentPage = 1;

            leftSlider = uiSlider.create(uiMain.ui)
                .exReSize(HEROSEL_SLIDER_WIDTH, HEROSEL_SLIDER_HEIGHT)
                .setMinMaxValue(1.0, totalPage)
                .setStep(1.0)
                .setValue(totalPage)
                .setThumbScale(HEROSEL_SLIDER_BTN_SCALE)
                .exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, sliderX, HEROSEL_GRID_OFFSET_Y)
                .onChange(function(uiSlider s) {
                    heroSelectorUI.onSliderChange(s);
                });

            // 如果不需要翻页则隐藏slider
            if (totalPage <= 1) {
                leftSlider.show(false);
            }

            refreshLeftGrid();

            // 右侧空白区域占位
            contentLeftX = sliderX + HEROSEL_SLIDER_WIDTH + HEROSEL_CONTENT_MARGIN_X;
            uiRightArea = uiImage.create(uiMain.ui)
                // .setTexture("")
                .setTexture(UI_STRING_PATH_BLANK)
                .setPointFix(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, contentLeftX, HEROSEL_GRID_OFFSET_Y)
                .setPointFix(ANCHOR_BOTTOMRIGHT, uiMain.ui, ANCHOR_BOTTOMRIGHT, -HEROSEL_CONTENT_MARGIN_X, HEROSEL_CONTENT_MARGIN_Y);

            uiDivider = uiImage.create(uiMain.ui)
                .exReSize(0.003, HEROSEL_MAIN_HEIGHT - 0.01 + HEROSEL_GRID_OFFSET_Y)
                .setTexture("ui\\image\\vertical_divider.blp")
                .exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, contentLeftX - HEROSEL_CONTENT_MARGIN_X * 0.5, HEROSEL_GRID_OFFSET_Y);

            uiBtn1Image = uiImage.create(uiMain.ui)
                .exReSize(HEROSEL_BOTTOM_BTN_WIDTH, HEROSEL_BOTTOM_BTN_HEIGHT)
                .setTexture("ui\\image\\select_flash.blp")
                .exRePoint(ANCHOR_CENTER, uiMain.ui, ANCHOR_BOTTOM, -HEROSEL_BOTTOM_BTN_GAP_X * 0.5 - HEROSEL_BOTTOM_BTN_WIDTH * 0.5, 0);
            uiBtn1Text = uiText.create(uiBtn1Image.ui)
                .setAllPoint(uiBtn1Image.ui)
                .setFontSize(7)
                .setAlign(4)
                .setText("按钮1");
            uiBtn1Button = uiBtn.create(uiBtn1Image.ui)
                .setAllPoint(uiBtn1Image.ui);

            uiBtn2Image = uiImage.create(uiMain.ui)
                .exReSize(HEROSEL_BOTTOM_BTN_WIDTH, HEROSEL_BOTTOM_BTN_HEIGHT)
                .setTexture("ui\\image\\select_flash.blp")
                .exRePoint(ANCHOR_CENTER, uiMain.ui, ANCHOR_BOTTOM, HEROSEL_BOTTOM_BTN_GAP_X * 0.5 + HEROSEL_BOTTOM_BTN_WIDTH * 0.5, 0);
            uiBtn2Text = uiText.create(uiBtn2Image.ui)
                .setAllPoint(uiBtn2Image.ui)
                .setFontSize(7)
                .setAlign(4)
                .setText("按钮2");
            uiBtn2Button = uiBtn.create(uiBtn2Image.ui)
                .setAllPoint(uiBtn2Image.ui);
        }

        public static method hide(player p) {
            integer r; integer c;
            if (GetLocalPlayer() != p) { return; }
            if (!isOpen) { return; }

            for (1 <= r <= HEROSEL_GRID_ROWS) {
                for (1 <= c <= HEROSEL_GRID_COLS) {
                    if (slotTxt2[r][c] != 0) { slotTxt2[r][c].destroy(); slotTxt2[r][c] = 0; }
                    if (slotTxt1[r][c] != 0) { slotTxt1[r][c].destroy(); slotTxt1[r][c] = 0; }
                    if (slotIcon[r][c] != 0) { slotIcon[r][c].destroy(); slotIcon[r][c] = 0; }
                }
            }

            if (leftSlider != 0) { leftSlider.destroy(); leftSlider = 0; }
            if (uiBtn2Button != 0) { uiBtn2Button.destroy(); uiBtn2Button = 0; }
            if (uiBtn2Text != 0) { uiBtn2Text.destroy(); uiBtn2Text = 0; }
            if (uiBtn2Image != 0) { uiBtn2Image.destroy(); uiBtn2Image = 0; }
            if (uiBtn1Button != 0) { uiBtn1Button.destroy(); uiBtn1Button = 0; }
            if (uiBtn1Text != 0) { uiBtn1Text.destroy(); uiBtn1Text = 0; }
            if (uiBtn1Image != 0) { uiBtn1Image.destroy(); uiBtn1Image = 0; }
            if (uiTitleText != 0) { uiTitleText.destroy(); uiTitleText = 0; }
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
            currentPage = 1;
            totalPage = 1;
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
#undef HEROSEL_TEXT_GAP_Y
#undef HEROSEL_TEXT_LINE_GAP_Y
#undef HEROSEL_SLIDER_WIDTH
#undef HEROSEL_SLIDER_HEIGHT
#undef HEROSEL_SLIDER_GAP_X
#undef HEROSEL_TITLE_HEIGHT
#undef HEROSEL_TITLE_OFFSET_Y
#undef HEROSEL_BOTTOM_BTN_WIDTH
#undef HEROSEL_BOTTOM_BTN_HEIGHT
#undef HEROSEL_BOTTOM_BTN_GAP_X
#undef HEROSEL_CONTENT_MARGIN_X
#undef HEROSEL_CONTENT_MARGIN_Y

#endif
