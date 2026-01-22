#ifndef HeroSelectorIncluded
#define HeroSelectorIncluded

#include "Crainax/config/SharedMethod.h"       // 结构体共用方法、I3 等工具
#include "Crainax/ui/constants/UIConstants.j"  // UI 常量
#include "Crainax/ui/constants/GrowConstants.j"  // UI 常量

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
#define HEROSEL_ICON_BORDER_SIZE (HEROSEL_CELL_SIZE + 0.006)
#define HEROSEL_CELL_GAP_X 0.008
#define HEROSEL_CELL_GAP_Y 0.015
#define HEROSEL_GRID_OFFSET_X 0.020
#define HEROSEL_GRID_OFFSET_Y -0.045
#define HEROSEL_TEXT_GAP_Y 0.003
#define HEROSEL_TEXT_LINE_GAP_Y 0.002
#define HEROSEL_TEXT_BG_HEIGHT 0.014

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
#define HEROSEL_BOTTOM_TEXT_GAP_Y  0.005  // 底部按钮上方文本与按钮的Y轴距离

// 右侧占位区域
#define HEROSEL_CONTENT_MARGIN_X 0.008
#define HEROSEL_CONTENT_MARGIN_Y 0.008

// 左下角BP图标和文字
#define HEROSEL_BP_ICON_SIZE 0.016
#define HEROSEL_BP_TEXT_GAP_X 0.005
#define HEROSEL_BP_OFFSET_X 0.005
#define HEROSEL_BP_OFFSET_Y 0.005

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

        public static trigger trHeroCondition = null; //位置的解锁条件

        public integer talentCount;   //天赋数量
        public static string  talentIcon  [500][5];  //天赋的图标

        public integer giftCount;     //赠礼Count
        public static string  giftIcon  [500][5];  //赠礼的图标

        public integer skillCount;     //建议的技能Count
        public static string  skillIcon  [500][5];  //建议的技能

        public integer equitCount; //装备Count
        public static string  equitIcon  [500][10]; //装备的图标

        public static real progresss [MAX_PLAYER_COUNT][500];   //进度条(熟练度)

        public static trigger trRightEnter = null;   //介绍鼠标进入触发事件(异步)
        public static trigger trRightLeave = null;   //介绍鼠标进入触发事件(异步)
        public static integer argsHeroIndex = 0; //英雄索引(回调参数)
        public static integer argsEventType = 0; //事件类型(回调参数) 1:天赋技能 2:赠礼 3:建议的技能 4:装备
        public static integer argsEventIndex = 0; //事件类型(回调参数)  1-10事件的位置

        public static trigger trHeroBtn1String = null;  //根据位置返回字符串的触发器
        public static trigger trBpEnter        = null;  //左下角BP鼠标进入触发事件
        public static trigger trBpLeave        = null;  //左下角BP鼠标离开触发事件

        public static trigger trBtn1Click      = null;  //按钮1点击(数据已同步的回调)
        public static trigger trBtn2Click      = null;  //按钮2点击(数据已同步的回调)

    }

    //==========================================================================
    // 传参
    //==========================================================================
    private integer currentPos     = 0;                //点击位置
    private player currentP        = null;                //点击位置
    // 回调参数传递（避免哈希表冲突）
    private integer currentPosAsync = 0;        //异步调用时的位置参数
    private string currentBtn1StringResult = ""; //字符串回调的返回值

    //当前触发的UI的对应位置
    public function GetHeroSelectorPos () -> integer {
        return currentPos;
    }

    //当前触发的UI的对应位置
    public function GetHeroSelectorPlayer () -> player {
        return currentP;
    }

    //获取异步调用时的位置参数
    public function GetHeroConditionPosAsync () -> integer {
        return currentPosAsync;
    }

    //写入字符串返回值（用于字符串回调）
    public function CallbackHeroBtn1String (string s) {
        currentBtn1StringResult = s;
    }

    //获取字符串返回值
    public function GetHeroBtn1StringResult () -> string {
        return currentBtn1StringResult;
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
        private static uiImage slotIconBorder[HEROSEL_GRID_ROWS][HEROSEL_GRID_COLS];
        private static uiImage slotTxt1Bg[HEROSEL_GRID_ROWS][HEROSEL_GRID_COLS];
        private static uiText slotTxt1[HEROSEL_GRID_ROWS][HEROSEL_GRID_COLS];
        private static uiText slotTxt2[HEROSEL_GRID_ROWS][HEROSEL_GRID_COLS];

        private static uiSlider leftSlider = 0;

        private static uiText uiTitleText = 0;
        public static uiText uiBottomText = 0;  // 底部按钮上方的文本（public，方便外部修改）
        private static uiImage uiBtn1Image = 0;
        private static uiText uiBtn1Text = 0;
        private static uiBtn uiBtn1Button = 0;
        private static uiImage uiBtn2Image = 0;
        private static uiText uiBtn2Text = 0;
        private static uiBtn uiBtn2Button = 0;

        private static uiImage uiDivider = 0;
        private static uiImage uiRightArea = 0;

        // 左下角BP图标和文字（public，方便外部修改）
        public static uiImage uiBpIcon = 0;
        public static uiText uiBpText = 0;
        private static uiBtn uiBpButton = 0;

        private static boolean isOpen = false;
        private static player owner = null;
        private static integer currentPage = 1;
        private static integer totalPage = 1;
        private static integer selectedPos = 0; // 当前选中的位置

        private static method refreshLeftGrid() {
            integer r; integer c; integer idx;
            integer pos; heroData hd;
            integer globalRowIndex; integer totalRows; integer rowIconCount;
            real baseOffsetX; real offsetX; real offsetY;
            boolean showBg = true; // 默认显示背景

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

                            // 显示并定位边框
                            if (slotIconBorder[r][c] != 0) {
                                slotIconBorder[r][c].exRePoint(ANCHOR_CENTER, slotIcon[r][c].mainImage.ui, ANCHOR_CENTER, 0, 0);
                                slotIconBorder[r][c].show(true);
                            }
                            uiHashTable(slotIcon[r][c].getClickBtn().ui).eventdata.bind(pos);

                            // 选中高亮：如果当前位置是选中的位置，则高亮
                            if (selectedPos == pos) {
                                slotIcon[r][c].grow(growdata[ICONGROW_15]);
                            } else {
                                slotIcon[r][c].unGrow();
                            }

                            // 判断位置解锁条件，动态调整 slotTxt1Bg 的位置
                            if (heroData.trHeroCondition != null) {
                                currentPosAsync = pos;
                                if (slotTxt1Bg[r][c] != 0) {
                                    if (!TriggerEvaluate(heroData.trHeroCondition)) {
                                        // 未解锁：背景覆盖整个 icon（TOP 对齐 icon 的 TOP）
                                        slotTxt1Bg[r][c].setPoint(ANCHOR_TOP, slotIcon[r][c].mainImage.ui, ANCHOR_TOP, 0, 0);
                                    } else {
                                        // 已解锁：背景只在底部显示（TOP 在 icon 底部上方）
                                        slotTxt1Bg[r][c].setPoint(ANCHOR_TOP, slotIcon[r][c].mainImage.ui, ANCHOR_BOTTOM, 0, HEROSEL_TEXT_BG_HEIGHT);
                                    }
                                }
                            }
                        }
                        // slotTxt1Bg 始终显示，通过位置变化实现遮挡效果
                        if (slotTxt1Bg[r][c] != 0) {
                            slotTxt1Bg[r][c].show(true);
                        }
                        if (slotTxt1[r][c] != 0) {
                            slotTxt1[r][c].setText("1字:+" + I2S(pos));
                            slotTxt1[r][c].show(true); // 文字始终显示
                        }
                        if (slotTxt2[r][c] != 0) {
                            slotTxt2[r][c].setText(S3(hd.text2 != null, hd.text2, "文本2"));
                            slotTxt2[r][c].show(true);
                        }
                    } else {
                        if (slotIcon[r][c] != 0) { slotIcon[r][c].show(false); }
                        if (slotIconBorder[r][c] != 0) { slotIconBorder[r][c].show(false); }
                        if (slotTxt1Bg[r][c] != 0) { slotTxt1Bg[r][c].show(false); }
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
                .exRePoint(ANCHOR_TOP, uiMain.ui, ANCHOR_TOPLEFT, HEROSEL_GRID_OFFSET_X + 3 * (HEROSEL_CELL_SIZE + HEROSEL_CELL_GAP_X) + HEROSEL_CELL_SIZE * 0.5, HEROSEL_TITLE_OFFSET_Y)
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

                    // 创建图标边框（在slotIcon之前）
                    slotIconBorder[r][c] = uiImage.create(uiMain.ui)
                        .setTexture("ui\\image\\select_flash.blp")
                        .exReSize(HEROSEL_ICON_BORDER_SIZE, HEROSEL_ICON_BORDER_SIZE)
                        .show(false);

                    slotIcon[r][c] = icon.create(uiMain.ui)
                        .enableResize()
                        .setTexture("ui\\image\\select_flash.blp")
                        .setSize(HEROSEL_CELL_SIZE, HEROSEL_CELL_SIZE)
                        .exRePoint(ANCHOR_TOPLEFT, uiMain.ui, ANCHOR_TOPLEFT, offsetX, offsetY);
                    slotIcon[r][c].show(false);

                    slotIcon[r][c].getClickBtn()
                        .onMouseWheel(function heroSelectorUI.onMouseWheel)
                        .spClick(function(integer frame) {
                            integer pos;
                            pos = uiHashTable(frame).eventdata.get();
                            // 更新选中位置并刷新显示
                            selectedPos = pos;
                            // 调用字符串回调并设置uiBtn2Text
                            if (heroData.trHeroBtn1String != null) {
                                currentPosAsync = pos;
                                currentBtn1StringResult = "";
                                TriggerEvaluate(heroData.trHeroBtn1String);
                                if (uiBtn2Text != 0 && currentBtn1StringResult != null) {
                                    uiBtn2Text.setText(currentBtn1StringResult);
                                }
                        }
                        refreshLeftGrid();
                    });
                    uiHashTable(slotIcon[r][c].getClickBtn().ui).eventdata.bind(idx);

                    // 创建 slotTxt1 的背景 uiImage，放在 icon 内部
                    // 注意：icon.mainImage 默认 clip=true，背景必须放在 icon 内部，否则会被裁剪
                    // 同时必须绑定左右点，否则宽度可能为 0 导致不渲染
                    slotTxt1Bg[r][c] = uiImage.create(slotIcon[r][c].mainImage.ui)
                        .setTexture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp")
                        .setPoint(ANCHOR_BOTTOM, slotIcon[r][c].mainImage.ui, ANCHOR_BOTTOM, 0, 0)
                        .setPoint(ANCHOR_TOP, slotIcon[r][c].mainImage.ui, ANCHOR_BOTTOM, 0, HEROSEL_TEXT_BG_HEIGHT)
                        .setPoint(ANCHOR_LEFT, slotIcon[r][c].mainImage.ui, ANCHOR_LEFT, 0, 0)
                        .setPoint(ANCHOR_RIGHT, slotIcon[r][c].mainImage.ui, ANCHOR_RIGHT, 0, 0)
                        .show(false);

                    // slotTxt1 放在 icon 内部，位置与 slotTxt1Bg 顶部对齐
                    // 注意：父级设为 icon 而不是 slotTxt1Bg，这样即使背景隐藏，文字也能显示
                    slotTxt1[r][c] = uiText.create(slotIcon[r][c].mainImage.ui)
                        .setAlign(4)
                        .setFontSize(2)
                        .setPoint(ANCHOR_CENTER, slotTxt1Bg[r][c].ui, ANCHOR_CENTER, 0, 0)
                        .show(false);

                    // slotTxt2 移到旧的 slotTxt1 的位置（相对于 icon 底部）
                    slotTxt2[r][c] = uiText.create(uiMain.ui)
                        .setAlign(4)
                        .setFontSize(2)
                        .setPoint(ANCHOR_TOP, slotIcon[r][c].mainImage.ui, ANCHOR_BOTTOM, 0, -HEROSEL_TEXT_GAP_Y)
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

            // 底部按钮上方的文本（x轴位置与第4列图标对齐）
            uiBottomText = uiText.create(uiMain.ui)
                .exRePoint(ANCHOR_BOTTOM, uiMain.ui, ANCHOR_BOTTOMLEFT, HEROSEL_GRID_OFFSET_X + 3 * (HEROSEL_CELL_SIZE + HEROSEL_CELL_GAP_X) + HEROSEL_CELL_SIZE * 0.5, HEROSEL_BOTTOM_BTN_HEIGHT * 0.5 + HEROSEL_BOTTOM_TEXT_GAP_Y)
                .setAlign(4)
                .setFontSize(7)
                .setText("底部文本");

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
                .setAllPoint(uiBtn1Image.ui)
                .onClick(function() {
                    syncBus.DzSyncDataEx("HSelect","L");
                });

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
                .setAllPoint(uiBtn2Image.ui)
                .onClick(function() {
                    syncBus.DzSyncDataEx("HSelect","R"+I2S(selectedPos));
                });

            // 左下角BP图标和文字
            uiBpIcon = uiImage.create(uiMain.ui)
                .setTexture(HEROSEL_CURRENCY_ICON)
                .exReSize(HEROSEL_BP_ICON_SIZE, HEROSEL_BP_ICON_SIZE)
                .exRePoint(ANCHOR_BOTTOMLEFT, uiMain.ui, ANCHOR_BOTTOMLEFT, HEROSEL_BP_OFFSET_X, HEROSEL_BP_OFFSET_Y);

            uiBpText = uiText.create(uiMain.ui)
                .setFontSize(4)
                .setAlign(1)  // 左对齐
                .exRePoint(ANCHOR_LEFT, uiBpIcon.ui, ANCHOR_RIGHT, HEROSEL_BP_TEXT_GAP_X, 0)
                .setText("BP文字");

            // 创建按钮用于处理鼠标进入和离开事件
            uiBpButton = uiBtn.createBlank(uiMain.ui)
                .setPoint(ANCHOR_BOTTOMLEFT, uiBpIcon.ui, ANCHOR_BOTTOMLEFT, 0, 0)
                .setPoint(ANCHOR_TOPRIGHT, uiBpText.ui, ANCHOR_TOPRIGHT, 0, 0)
                .onEnter(function() {
                    if (heroData.trBpEnter != null) {
                        TriggerEvaluate(heroData.trBpEnter);
                    }
            })
                .onLeave(function() {
                    if (heroData.trBpLeave != null) {
                        TriggerEvaluate(heroData.trBpLeave);
                    }
            });
        }

        public static method hide(player p) {
            integer r; integer c;
            if (GetLocalPlayer() != p) { return; }
            if (!isOpen) { return; }

            for (1 <= r <= HEROSEL_GRID_ROWS) {
                for (1 <= c <= HEROSEL_GRID_COLS) {
                    if (slotTxt2[r][c] != 0) { slotTxt2[r][c].destroy(); slotTxt2[r][c] = 0; }
                    if (slotTxt1[r][c] != 0) { slotTxt1[r][c].destroy(); slotTxt1[r][c] = 0; }
                    if (slotTxt1Bg[r][c] != 0) { slotTxt1Bg[r][c].destroy(); slotTxt1Bg[r][c] = 0; }
                    if (slotIcon[r][c] != 0) { slotIcon[r][c].destroy(); slotIcon[r][c] = 0; }
                    if (slotIconBorder[r][c] != 0) { slotIconBorder[r][c].destroy(); slotIconBorder[r][c] = 0; }
                }
            }

            if (leftSlider != 0) { leftSlider.destroy(); leftSlider = 0; }
            if (uiBpButton != 0) { uiBpButton.destroy(); uiBpButton = 0; }
            if (uiBtn2Button != 0) { uiBtn2Button.destroy(); uiBtn2Button = 0; }
            if (uiBtn2Text != 0) { uiBtn2Text.destroy(); uiBtn2Text = 0; }
            if (uiBtn2Image != 0) { uiBtn2Image.destroy(); uiBtn2Image = 0; }
            if (uiBtn1Button != 0) { uiBtn1Button.destroy(); uiBtn1Button = 0; }
            if (uiBtn1Text != 0) { uiBtn1Text.destroy(); uiBtn1Text = 0; }
            if (uiBtn1Image != 0) { uiBtn1Image.destroy(); uiBtn1Image = 0; }
            if (uiBpButton != 0) { uiBpButton.destroy(); uiBpButton = 0; }
            if (uiBpText != 0) { uiBpText.destroy(); uiBpText = 0; }
            if (uiBpIcon != 0) { uiBpIcon.destroy(); uiBpIcon = 0; }
            if (uiBottomText != 0) { uiBottomText.destroy(); uiBottomText = 0; }
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
            selectedPos = 0;
        }

        // 判断 UI 是否正在显示
        public static method isShow() -> boolean {
            return isOpen;
        }

        // 设置按钮1的文本（仅对指定玩家）
        public static method setBtn1Text(player p, string text) {
            if (GetLocalPlayer() != p) { return; }
            if (uiBtn1Text != 0) {
                uiBtn1Text.setText(text);
            }
        }

    }

    function onInit () {
        // 使用单通道总线
        syncBus.onDataSync("HSelect", function () -> boolean {
            string str; player p; integer pos;
            str = syncBus.getPayload();
            p = syncBus.getPlayer();
            if (SubStringBJ(str, 1, 1) == "L") { // button1 点击（随机）
                if (heroData.trBtn1Click != null) {
                    currentP = p;
                    TriggerEvaluate(heroData.trBtn1Click);
                }
            } else if (SubStringBJ(str, 1, 1) == "R") { // button2 点击（确认选择）
                pos = S2I(SubStringBJ(str, 2, StringLength(str)));
                if (heroData.trBtn2Click != null) {
                    currentP = p;
                    currentPos = pos;
                    TriggerEvaluate(heroData.trBtn2Click);
                }
            }

            str = null; p = null;
            return true;
        });
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
#undef HEROSEL_ICON_BORDER_SIZE
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
#undef HEROSEL_BOTTOM_TEXT_GAP_Y
#undef HEROSEL_CONTENT_MARGIN_X
#undef HEROSEL_CONTENT_MARGIN_Y
#undef HEROSEL_BP_ICON_SIZE
#undef HEROSEL_BP_TEXT_GAP_X
#undef HEROSEL_BP_OFFSET_X
#undef HEROSEL_BP_OFFSET_Y

#endif
