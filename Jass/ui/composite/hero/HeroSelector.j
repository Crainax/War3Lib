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
#define HEROSEL_BOTTOM_BTN_HEIGHT  0.038
#define HEROSEL_BOTTOM_BTN_GAP_X   0.075
#define HEROSEL_BOTTOM_TEXT_GAP_Y  0.005  // 底部按钮上方文本与按钮的Y轴距离
#define HEROSEL_GROW_BTN_SIZE      0.075 // 底部按钮流光方形边长（方便修改）

// 右侧占位区域
#define HEROSEL_CONTENT_MARGIN_X 0.008
#define HEROSEL_CONTENT_MARGIN_Y 0.008

// 左下角BP图标和文字
#define HEROSEL_BP_ICON_SIZE 0.016
#define HEROSEL_BP_TEXT_GAP_X 0.005
#define HEROSEL_BP_OFFSET_X 0.005
#define HEROSEL_BP_OFFSET_Y 0.005

// 右侧区域
#define HEROSEL_RIGHT_ICON_SIZE 0.03  // 右侧图标大小（复用左侧）
#define HEROSEL_RIGHT_ICON_GAP_X 0.005  // 右侧图标水平间距
#define HEROSEL_RIGHT_ICON_GAP_Y 0.005  // 右侧图标垂直间距
#define HEROSEL_RIGHT_TEXT_GAP_Y 0.003  // 标题文字与图标网格的垂直间距
#define HEROSEL_RIGHT_SECTION_GAP_Y 0.010  // 各个区块之间的垂直间距
#define HEROSEL_RIGHT_START_OFFSET_X 0.010  // 右侧内容起始X偏移
#define HEROSEL_RIGHT_START_OFFSET_Y 0.030  // 右侧内容起始Y偏移（相对于左侧网格）
#define HEROSEL_TALENT_COUNT 5  // 天赋技能图标数量
#define HEROSEL_GIFT_COUNT 5  // 联结赠礼图标数量
#define HEROSEL_SKILL_COUNT 5  // 推荐技能图标数量
#define HEROSEL_EQUIP_COUNT 10  // 推荐装备图标数量
#define HEROSEL_EQUIP_COLS 5  // 推荐装备每行图标数

// 右侧进度条（装备区块下方）
#define HEROSEL_PROGRESS_BAR_WIDTH 0.16
#define HEROSEL_PROGRESS_BAR_HEIGHT 0.007
#define HEROSEL_PROGRESS_BAR_TEXT_GAP_Y 0.004
#define HEROSEL_PROGRESS_TEXT_BAR_GAP_Y 0.015

//# dependency:resource/ui/image/black.blp
//# dependency:resource/ui/image/select_close.blp
//# dependency:resource/ui/image/vertical_divider.blp
//# dependency:resource/ui/image/select_flash.blp
//# dependency:resource/ui/image/museum_01.blp
//# dependency:resource/ui/image/museum_02.blp
//# dependency:resource/ui/image/museum_03.blp
//# dependency:resource/ui/image/museum_04.blp

library HeroSelector requires UISlider,UIImage,UIButton,UIText,UIHashTable,Icon,UIImageBar,BaseAnim,GrowData {

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
        public static integer talentValue [500][5];  //天赋的值

        public integer giftCount;     //赠礼Count
        public static string  giftIcon  [500][5];  //赠礼的图标
        public static integer giftValue [500][5];  //赠礼的值

        public integer skillCount;     //建议的技能Count
        public static string  skillIcon  [500][5];  //建议的技能
        public static integer skillValue [500][5];  //建议的技能的值

        public integer equitCount; //装备Count
        public static string  equitIcon  [500][10]; //装备的图标
        public static integer equitValue [500][10]; //装备的值

        public static integer progressHero [MAX_PLAYER_COUNT][500];     //进度条(英雄熟练度-当前)
        public static integer progressHeroMax [MAX_PLAYER_COUNT][500];  //进度条(英雄熟练度-最大)
        public static integer progressAll [];     //进度条(全英雄熟练度-当前),所有英雄共通,只取玩家索引
        public static integer progressAllMax [];  //进度条(全英雄熟练度-最大),所有英雄共通,只取玩家索引

        public static trigger trRightEnter = null;   //介绍鼠标进入触发事件(异步)
        public static trigger trRightLeave = null;   //介绍鼠标进入触发事件(异步)
        public static integer argsHeroIndex = 0; //英雄索引(回调参数)
        public static integer argsEventType = 0; //事件类型(回调参数) 1:天赋技能 2:赠礼 3:建议的技能 4:装备
        public static integer argsEventIndex = 0; //事件类型(回调参数)  1-10事件的位置

        public static trigger trHeroBtn1String = null;  //根据位置返回字符串的触发器
        public static trigger trBpEnter        = null;  //左下角BP鼠标进入触发事件
        public static trigger trBpLeave        = null;  //左下角BP鼠标离开触发事件
        public static trigger trBottomTextControl = null;    //底部文本显示控制触发器（return true显示，false隐藏）

    }

    //==========================================================================
    // 传参
    //==========================================================================
    private integer currentPos     = 0;                //点击位置
    private player currentP        = null;                //点击位置
    // 回调参数传递（避免哈希表冲突）
    private integer currentPosAsync = 0;        //异步调用时的位置参数
    private string currentBtn1StringResult = ""; //字符串回调的返回值
    private boolean currentBottomTextShow = false; //底部文本显示控制返回值

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

        // 底部按钮流光（单例，在 uiBtn1/uiBtn2 处，由 setGrowBtnPos 移动、enableGrowBtn 创建/删除）
        private static uiImage growBtnImage = 0;
        private static baseanim growBtnAnim = 0;
        private static integer growBtnPos = 1;  // 1=uiBtn1Image, 2=uiBtn2Image

        private static uiImage uiDivider = 0;
        private static uiImage uiRightArea = 0;

        // 左下角BP图标和文字（public，方便外部修改）
        public static uiImage uiBpIcon = 0;
        public static uiText uiBpText = 0;
        private static uiBtn uiBpButton = 0;

        // 右侧内容
        private static uiText rightTalentText = 0;  // "天赋技能" 文字
        private static icon rightTalentIcon[HEROSEL_TALENT_COUNT];  // 天赋技能图标数组
        private static uiText rightTalentEmptyText = 0;  // 天赋技能区块 "暂无"
        private static real rightTalentGridY = 0;
        private static uiText rightGiftText = 0;  // "联结赠礼" 文字
        private static icon rightGiftIcon[HEROSEL_GIFT_COUNT];  // 联结赠礼图标数组
        private static uiText rightGiftEmptyText = 0;  // 联结赠礼区块 "暂无"
        private static real rightGiftGridY = 0;
        private static uiText rightSkillText = 0;  // "推荐技能" 文字
        private static icon rightSkillIcon[HEROSEL_SKILL_COUNT];  // 推荐技能图标数组
        private static uiText rightSkillEmptyText = 0;  // 推荐技能区块 "暂无"
        private static real rightSkillGridY = 0;
        private static uiText rightEquipText = 0;  // "推荐装备" 文字
        private static icon rightEquipIcon[HEROSEL_EQUIP_COUNT];  // 推荐装备图标数组
        private static uiText rightEquipEmptyText = 0;  // 推荐装备区块 "暂无"
        private static real rightEquipGridY = 0;

        // 装备区块下方进度条与文字
        private static uiImageBar rightProgBar1 = 0;
        private static uiText rightProgText1 = 0;
        private static uiImageBar rightProgBar2 = 0;
        private static uiText rightProgText2 = 0;

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
            boolean unlocked = true;

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

                            // 判断位置解锁条件，动态调整 slotTxt1Bg 的位置和 slotTxt1 的文本
                            if (heroData.trHeroCondition != null) {
                                currentPosAsync = pos;
                                unlocked = TriggerEvaluate(heroData.trHeroCondition);
                                if (slotTxt1Bg[r][c] != 0) {
                                    if (!unlocked) {
                                        // 未解锁：背景覆盖整个 icon（TOP 对齐 icon 的 TOP）
                                        slotTxt1Bg[r][c].setPoint(ANCHOR_TOP, slotIcon[r][c].mainImage.ui, ANCHOR_TOP, 0, 0);
                                    } else {
                                        // 已解锁：背景只在底部显示（TOP 在 icon 底部上方）
                                        slotTxt1Bg[r][c].setPoint(ANCHOR_TOP, slotIcon[r][c].mainImage.ui, ANCHOR_BOTTOM, 0, HEROSEL_TEXT_BG_HEIGHT);
                                    }
                                }
                            }
                            // slotTxt1Bg 始终显示，通过位置变化实现遮挡效果
                            if (slotTxt1Bg[r][c] != 0) {
                                slotTxt1Bg[r][c].show(true);
                            }
                            if (slotTxt1[r][c] != 0) {
                                if (unlocked) {
                                    // 已解锁：显示英雄名称
                                    slotTxt1[r][c].setText(S3(hd.name != null, hd.name, ""));
                                } else {
                                    // 未解锁：显示红色两行文本
                                    slotTxt1[r][c].setText("|cffff0000未解锁|r\n|cffff0000" + S3(hd.name != null, hd.name, "") + "|r");
                                }
                                slotTxt1[r][c].show(true); // 文字始终显示
                            }
                            if (slotTxt2[r][c] != 0) {
                                slotTxt2[r][c].setText(S3(hd.text2 != null, hd.text2, "文本2"));
                                slotTxt2[r][c].show(true);
                            }
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

        // 创建右侧图标网格（支持居中布局，第3个图标在中心）
        // arrayType: 0=天赋技能, 1=联结赠礼, 2=推荐技能, 3=推荐装备
        private static method createRightIconGrid(integer parentUI, real startX, real startY, integer iconCount, integer colsPerRow, integer arrayType) -> real {
            integer i; integer r; integer c;
            integer totalRows; integer rowIconCount;
            real centerCol; real offsetX; real offsetY;
            real nextY;
            integer eventType; integer encoded; uiBtn btn;

            // 事件类型映射：0=天赋(1), 1=赠礼(2), 2=建议技能(3), 3=装备(4)
            eventType = arrayType + 1;

            // 计算总行数
            totalRows = (iconCount + colsPerRow - 1) / colsPerRow;

            for (1 <= i <= iconCount) {
                // 计算当前图标所在的行和列（从1开始）
                r = (i - 1) / colsPerRow + 1;
                c = ModuloInteger(i - 1, colsPerRow) + 1;

                // 计算当前行有多少个图标
                if (r == totalRows) {
                    // 最后一行
                    rowIconCount = iconCount - (r - 1) * colsPerRow;
                } else {
                    rowIconCount = colsPerRow;
                }

                // 计算当前行的中心列（第3个图标在中心）
                centerCol = (rowIconCount + 1) / 2.0;

                // 计算相对于中心的X偏移（第3个图标在中心，左边2个负x轴，右边2个正x轴）
                offsetX = (c - centerCol) * (HEROSEL_RIGHT_ICON_SIZE + HEROSEL_RIGHT_ICON_GAP_X);
                offsetY = startY - (r - 1) * (HEROSEL_RIGHT_ICON_SIZE + HEROSEL_RIGHT_ICON_GAP_Y);

                // 编码 eventdata：eventType * 10 + eventIndex（当 eventIndex 为 1-9）
                // 或 eventType * 100 + 10（当 eventIndex 为 10）
                if (i == 10) {
                    encoded = eventType * 100 + 10;
                } else {
                    encoded = eventType * 10 + i;
                }

                // 创建图标（使用 ANCHOR_TOP 和 ANCHOR_CENTER 实现居中布局）
                if (arrayType == 0) {
                    rightTalentIcon[i] = icon.create(parentUI)
                        .enableResize()
                        .setTexture(HEROSEL_CURRENCY_ICON)
                        .setSize(HEROSEL_RIGHT_ICON_SIZE, HEROSEL_RIGHT_ICON_SIZE)
                        .exRePoint(ANCHOR_TOP, parentUI, ANCHOR_TOP, offsetX, offsetY);
                    rightTalentIcon[i].show(false);
                    btn = rightTalentIcon[i].getClickBtn();
                } else if (arrayType == 1) {
                    rightGiftIcon[i] = icon.create(parentUI)
                        .enableResize()
                        .setTexture(HEROSEL_CURRENCY_ICON)
                        .setSize(HEROSEL_RIGHT_ICON_SIZE, HEROSEL_RIGHT_ICON_SIZE)
                        .exRePoint(ANCHOR_TOP, parentUI, ANCHOR_TOP, offsetX, offsetY);
                    rightGiftIcon[i].show(false);
                    btn = rightGiftIcon[i].getClickBtn();
                } else if (arrayType == 2) {
                    rightSkillIcon[i] = icon.create(parentUI)
                        .enableResize()
                        .setTexture(HEROSEL_CURRENCY_ICON)
                        .setSize(HEROSEL_RIGHT_ICON_SIZE, HEROSEL_RIGHT_ICON_SIZE)
                        .exRePoint(ANCHOR_TOP, parentUI, ANCHOR_TOP, offsetX, offsetY);
                    rightSkillIcon[i].show(false);
                    btn = rightSkillIcon[i].getClickBtn();
                } else {
                    rightEquipIcon[i] = icon.create(parentUI)
                        .enableResize()
                        .setTexture(HEROSEL_CURRENCY_ICON)
                        .setSize(HEROSEL_RIGHT_ICON_SIZE, HEROSEL_RIGHT_ICON_SIZE)
                        .exRePoint(ANCHOR_TOP, parentUI, ANCHOR_TOP, offsetX, offsetY);
                    rightEquipIcon[i].show(false);
                    btn = rightEquipIcon[i].getClickBtn();
                }

                // 绑定 eventdata 并注册事件回调
                uiHashTable(btn.ui).eventdata.bind(encoded);
                btn.spEnter(function(integer frame) {
                    integer encodedData; integer eventTypeDecoded; integer eventIndexDecoded;
                    encodedData = uiHashTable(frame).eventdata.get();
                    // 解码
                    if (encodedData >= 100) {
                        eventTypeDecoded = encodedData / 100;
                        eventIndexDecoded = ModuloInteger(encodedData, 100);
                    } else {
                        eventTypeDecoded = encodedData / 10;
                        eventIndexDecoded = ModuloInteger(encodedData, 10);
                    }
                    // 写入回调参数
                    heroData.argsHeroIndex = selectedPos;
                    heroData.argsEventType = eventTypeDecoded;
                    heroData.argsEventIndex = eventIndexDecoded;
                    // 触发回调
                    if (heroData.trRightEnter != null) {
                        TriggerEvaluate(heroData.trRightEnter);
                    }
                })
                    .spLeave(function(integer frame) {
                        integer encodedData; integer eventTypeDecoded; integer eventIndexDecoded;
                        encodedData = uiHashTable(frame).eventdata.get();
                        // 解码
                        if (encodedData >= 100) {
                            eventTypeDecoded = encodedData / 100;
                            eventIndexDecoded = ModuloInteger(encodedData, 100);
                        } else {
                            eventTypeDecoded = encodedData / 10;
                            eventIndexDecoded = ModuloInteger(encodedData, 10);
                        }
                    // 写入回调参数
                    heroData.argsHeroIndex = selectedPos;
                    heroData.argsEventType = eventTypeDecoded;
                    heroData.argsEventIndex = eventIndexDecoded;
                    // 触发回调
                    if (heroData.trRightLeave != null) {
                        TriggerEvaluate(heroData.trRightLeave);
                    }
                })
                    .spClick(function(integer frame) {
                        integer encodedData; integer eventTypeDecoded; integer eventIndexDecoded;
                        encodedData = uiHashTable(frame).eventdata.get();
                        // 解码
                        if (encodedData >= 100) {
                            eventTypeDecoded = encodedData / 100;
                            eventIndexDecoded = ModuloInteger(encodedData, 100);
                        } else {
                            eventTypeDecoded = encodedData / 10;
                            eventIndexDecoded = ModuloInteger(encodedData, 10);
                        }
                    // 写入回调参数（预留扩展）
                    heroData.argsHeroIndex = selectedPos;
                    heroData.argsEventType = eventTypeDecoded;
                    heroData.argsEventIndex = eventIndexDecoded;
                });
                btn = 0;
            }

            // 返回下一个区块的起始Y坐标
            nextY = startY - totalRows * HEROSEL_RIGHT_ICON_SIZE - (totalRows - 1) * HEROSEL_RIGHT_ICON_GAP_Y;
            return nextY;
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

        // 刷新右侧内容（根据选中的英雄索引）
        private static method refreshRightContent(integer heroIndex) {
            heroData hd;
            integer i;
            string iconPath;
            integer totalRows; integer r; integer c; integer rowIconCount;
            real centerCol; real offsetX; real offsetY;
            integer pid;
            integer heroCur; integer heroMax;
            integer allCur; integer allMax;
            real ratio;

            if (heroIndex <= 0 || heroIndex > heroData.size) {
                // 无效索引，隐藏所有图标，显示各区块"暂无"
                for (1 <= i <= HEROSEL_TALENT_COUNT) {
                    if (rightTalentIcon[i] != 0) { rightTalentIcon[i].show(false); }
                }
                for (1 <= i <= HEROSEL_GIFT_COUNT) {
                    if (rightGiftIcon[i] != 0) { rightGiftIcon[i].show(false); }
                }
                for (1 <= i <= HEROSEL_SKILL_COUNT) {
                    if (rightSkillIcon[i] != 0) { rightSkillIcon[i].show(false); }
                }
                for (1 <= i <= HEROSEL_EQUIP_COUNT) {
                    if (rightEquipIcon[i] != 0) { rightEquipIcon[i].show(false); }
                }
                if (rightTalentEmptyText != 0) { rightTalentEmptyText.show(true); }
                if (rightGiftEmptyText != 0) { rightGiftEmptyText.show(true); }
                if (rightSkillEmptyText != 0) { rightSkillEmptyText.show(true); }
                if (rightEquipEmptyText != 0) { rightEquipEmptyText.show(true); }

                // 隐藏进度条与文字
                if (rightProgBar1 != 0) { rightProgBar1.uiBackground.show(false); rightProgBar1.uiFill.show(false); }
                if (rightProgText1 != 0) { rightProgText1.show(false); }
                if (rightProgBar2 != 0) { rightProgBar2.uiBackground.show(false); rightProgBar2.uiFill.show(false); }
                if (rightProgText2 != 0) { rightProgText2.show(false); }
                return;
            }

            hd = heroData[heroIndex];
            if (hd == 0) {
                if (rightTalentEmptyText != 0) { rightTalentEmptyText.show(true); }
                if (rightGiftEmptyText != 0) { rightGiftEmptyText.show(true); }
                if (rightSkillEmptyText != 0) { rightSkillEmptyText.show(true); }
                if (rightEquipEmptyText != 0) { rightEquipEmptyText.show(true); }

                if (rightProgBar1 != 0) { rightProgBar1.uiBackground.show(false); rightProgBar1.uiFill.show(false); }
                if (rightProgText1 != 0) { rightProgText1.show(false); }
                if (rightProgBar2 != 0) { rightProgBar2.uiBackground.show(false); rightProgBar2.uiFill.show(false); }
                if (rightProgText2 != 0) { rightProgText2.show(false); }
                return;
            }

            // 更新天赋技能图标
            for (1 <= i <= HEROSEL_TALENT_COUNT) {
                if (rightTalentIcon[i] != 0) {
                    if (i <= hd.talentCount && heroData.talentIcon[heroIndex][i] != null) {
                        iconPath = heroData.talentIcon[heroIndex][i];
                        rightTalentIcon[i].setTexture(S3(iconPath != null, iconPath, UI_STRING_PATH_BLANK));
                        // 不满 5 个时按中心重新排布
                        totalRows = (hd.talentCount + HEROSEL_TALENT_COUNT - 1) / HEROSEL_TALENT_COUNT; // 单行
                        r = 1;
                        rowIconCount = hd.talentCount;
                        centerCol = (rowIconCount + 1) / 2.0;
                        c = i;
                        offsetX = (c - centerCol) * (HEROSEL_RIGHT_ICON_SIZE + HEROSEL_RIGHT_ICON_GAP_X);
                        offsetY = rightTalentGridY;
                        rightTalentIcon[i].exRePoint(ANCHOR_TOP, uiRightArea.ui, ANCHOR_TOP, offsetX, offsetY);
                        rightTalentIcon[i].show(true);
                    } else {
                        rightTalentIcon[i].show(false);
                    }
                }
            }
            if (rightTalentEmptyText != 0) { rightTalentEmptyText.show(hd.talentCount <= 0); }

            // 更新联结赠礼图标
            for (1 <= i <= HEROSEL_GIFT_COUNT) {
                if (rightGiftIcon[i] != 0) {
                    if (i <= hd.giftCount && heroData.giftIcon[heroIndex][i] != null) {
                        iconPath = heroData.giftIcon[heroIndex][i];
                        rightGiftIcon[i].setTexture(S3(iconPath != null, iconPath, UI_STRING_PATH_BLANK));
                        rowIconCount = hd.giftCount;
                        centerCol = (rowIconCount + 1) / 2.0;
                        c = i;
                        offsetX = (c - centerCol) * (HEROSEL_RIGHT_ICON_SIZE + HEROSEL_RIGHT_ICON_GAP_X);
                        offsetY = rightGiftGridY;
                        rightGiftIcon[i].exRePoint(ANCHOR_TOP, uiRightArea.ui, ANCHOR_TOP, offsetX, offsetY);
                        rightGiftIcon[i].show(true);
                    } else {
                        rightGiftIcon[i].show(false);
                    }
                }
            }
            if (rightGiftEmptyText != 0) { rightGiftEmptyText.show(hd.giftCount <= 0); }

            // 更新推荐技能图标
            for (1 <= i <= HEROSEL_SKILL_COUNT) {
                if (rightSkillIcon[i] != 0) {
                    if (i <= hd.skillCount && heroData.skillIcon[heroIndex][i] != null) {
                        iconPath = heroData.skillIcon[heroIndex][i];
                        rightSkillIcon[i].setTexture(S3(iconPath != null, iconPath, UI_STRING_PATH_BLANK));
                        rowIconCount = hd.skillCount;
                        centerCol = (rowIconCount + 1) / 2.0;
                        c = i;
                        offsetX = (c - centerCol) * (HEROSEL_RIGHT_ICON_SIZE + HEROSEL_RIGHT_ICON_GAP_X);
                        offsetY = rightSkillGridY;
                        rightSkillIcon[i].exRePoint(ANCHOR_TOP, uiRightArea.ui, ANCHOR_TOP, offsetX, offsetY);
                        rightSkillIcon[i].show(true);
                    } else {
                        rightSkillIcon[i].show(false);
                    }
                }
            }
            if (rightSkillEmptyText != 0) { rightSkillEmptyText.show(hd.skillCount <= 0); }

            // 更新推荐装备图标
            for (1 <= i <= HEROSEL_EQUIP_COUNT) {
                if (rightEquipIcon[i] != 0) {
                    if (i <= hd.equitCount && heroData.equitIcon[heroIndex][i] != null) {
                        iconPath = heroData.equitIcon[heroIndex][i];
                        rightEquipIcon[i].setTexture(S3(iconPath != null, iconPath, UI_STRING_PATH_BLANK));
                        // 2 行 5 列，最后一行不足时也按中心排布
                        totalRows = (hd.equitCount + HEROSEL_EQUIP_COLS - 1) / HEROSEL_EQUIP_COLS;
                        r = (i - 1) / HEROSEL_EQUIP_COLS + 1;
                        c = ModuloInteger(i - 1, HEROSEL_EQUIP_COLS) + 1;
                        if (r == totalRows) {
                            rowIconCount = hd.equitCount - (r - 1) * HEROSEL_EQUIP_COLS;
                        } else {
                            rowIconCount = HEROSEL_EQUIP_COLS;
                        }
                        centerCol = (rowIconCount + 1) / 2.0;
                        offsetX = (c - centerCol) * (HEROSEL_RIGHT_ICON_SIZE + HEROSEL_RIGHT_ICON_GAP_X);
                        offsetY = rightEquipGridY - (r - 1) * (HEROSEL_RIGHT_ICON_SIZE + HEROSEL_RIGHT_ICON_GAP_Y);
                        rightEquipIcon[i].exRePoint(ANCHOR_TOP, uiRightArea.ui, ANCHOR_TOP, offsetX, offsetY);
                        rightEquipIcon[i].show(true);
                    } else {
                        rightEquipIcon[i].show(false);
                    }
                }
            }
            if (rightEquipEmptyText != 0) { rightEquipEmptyText.show(hd.equitCount <= 0); }

            // 更新装备区块下方进度条（按玩家索引与当前选中 pos）
            pid = GetConvertedPlayerId(GetLocalPlayer());
            if (pid < 1 || pid > MAX_PLAYER_COUNT) {
                if (rightProgBar1 != 0) { rightProgBar1.uiBackground.show(false); rightProgBar1.uiFill.show(false); }
                if (rightProgText1 != 0) { rightProgText1.show(false); }
                if (rightProgBar2 != 0) { rightProgBar2.uiBackground.show(false); rightProgBar2.uiFill.show(false); }
                if (rightProgText2 != 0) { rightProgText2.show(false); }
                return;
            }

            heroCur = heroData.progressHero[pid][heroIndex];
            heroMax = heroData.progressHeroMax[pid][heroIndex];
            allCur = heroData.progressAll[pid];
            allMax = heroData.progressAllMax[pid];

            // 两个 Max 都为 0 时隐藏这 4 个 UI
            if (heroMax <= 0 && allMax <= 0) {
                if (rightProgBar1 != 0) { rightProgBar1.uiBackground.show(false); rightProgBar1.uiFill.show(false); }
                if (rightProgText1 != 0) { rightProgText1.show(false); }
                if (rightProgBar2 != 0) { rightProgBar2.uiBackground.show(false); rightProgBar2.uiFill.show(false); }
                if (rightProgText2 != 0) { rightProgText2.show(false); }
                return;
            }

            // 1) 英雄亲密度
            if (heroMax > 0 && rightProgBar1 != 0 && rightProgText1 != 0) {
                ratio = I2R(heroCur) / I2R(heroMax);
                if (ratio < 0.0) { ratio = 0.0; }
                if (ratio > 1.0) { ratio = 1.0; }
                rightProgBar1.setProgress(ratio);
                rightProgBar1.uiBackground.show(true);
                rightProgBar1.uiFill.show(true);
                rightProgText1.setText("英雄亲密度(" + I2S(heroCur) + "/" + I2S(heroMax) + ")").setFontSize(3).show(true);
            } else {
                if (rightProgBar1 != 0) { rightProgBar1.uiBackground.show(false); rightProgBar1.uiFill.show(false); }
                if (rightProgText1 != 0) { rightProgText1.show(false); }
            }

            // 2) 全英雄亲密度
            if (allMax > 0 && rightProgBar2 != 0 && rightProgText2 != 0) {
                ratio = I2R(allCur) / I2R(allMax);
                if (ratio < 0.0) { ratio = 0.0; }
                if (ratio > 1.0) { ratio = 1.0; }
                rightProgBar2.setProgress(ratio);
                rightProgBar2.uiBackground.show(true);
                rightProgBar2.uiFill.show(true);
                rightProgText2.setText("全英雄亲密度(" + I2S(allCur) + "/" + I2S(allMax) + ")").setFontSize(3).show(true);
            } else {
                if (rightProgBar2 != 0) { rightProgBar2.uiBackground.show(false); rightProgBar2.uiFill.show(false); }
                if (rightProgText2 != 0) { rightProgText2.show(false); }
            }
        }

        public static method show(player p) {
            integer r; integer c; integer idx;
            integer totalRows;
            real offsetX; real offsetY;
            real leftGridWidth; real sliderX;
            real contentLeftX;
            real rightStartX; real rightCurrentY; real rightNextY;
            real progY; real textY;

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
                .setDragPosition(0.4, 0.35)
                .onMouseWheel(function heroSelectorUI.onMouseWheel);

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
                            integer pos; boolean showText;
                            pos = uiHashTable(frame).eventdata.get();
                            // 更新选中位置并刷新显示
                            selectedPos = pos;
                            // 刷新右侧内容
                            refreshRightContent(pos);
                            // 调用字符串回调并设置uiBtn2Text
                            if (heroData.trHeroBtn1String != null) {
                                currentPosAsync = pos;
                                currentBtn1StringResult = "";
                                TriggerEvaluate(heroData.trHeroBtn1String);
                                if (uiBtn2Text != 0 && currentBtn1StringResult != null) {
                                    uiBtn2Text.setText(currentBtn1StringResult);
                                }
                        }
                        // 调用底部文本控制回调
                        if (heroData.trBottomTextControl != null) {
                            currentPosAsync = pos;
                            currentBtn1StringResult = "";
                            currentBottomTextShow = false;
                            showText = TriggerEvaluate(heroData.trBottomTextControl);
                            if (uiBottomText != 0) {
                                if (showText) {
                                    if (currentBtn1StringResult != null) {
                                        uiBottomText.setText(currentBtn1StringResult);
                                    }
                                    uiBottomText.show(true);
                                } else {
                                    uiBottomText.show(false);
                                }
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

            // 右侧内容（相对于 uiRightArea）
            rightStartX = HEROSEL_RIGHT_START_OFFSET_X;
            rightCurrentY = HEROSEL_RIGHT_START_OFFSET_Y;

            // 创建 "天赋技能" 文字
            rightTalentText = uiText.create(uiRightArea.ui)
                .exRePoint(ANCHOR_TOP, uiRightArea.ui, ANCHOR_TOP, 0, rightCurrentY)
                .setAlign(4)  // 居中对齐
                .setFontSize(7)
                .setText("|cffff9900天赋技能|r");
            rightCurrentY = rightCurrentY - HEROSEL_TITLE_HEIGHT - HEROSEL_RIGHT_TEXT_GAP_Y;

            // 创建天赋技能图标（5个，单行）
            rightTalentGridY = rightCurrentY;
            rightNextY = createRightIconGrid(uiRightArea.ui, rightStartX, rightCurrentY, HEROSEL_TALENT_COUNT, HEROSEL_TALENT_COUNT, 0);
            rightTalentEmptyText = uiText.create(uiRightArea.ui)
                .exRePoint(ANCHOR_CENTER, uiRightArea.ui, ANCHOR_TOP, 0, rightTalentGridY - HEROSEL_RIGHT_ICON_SIZE * 0.5)
                .setAlign(4)
                .setFontSize(7)
                .setText("|cff808080暂无|r")
                .show(true);
            rightCurrentY = rightNextY - HEROSEL_RIGHT_SECTION_GAP_Y;

            // 创建 "联结赠礼" 文字
            rightGiftText = uiText.create(uiRightArea.ui)
                .exRePoint(ANCHOR_TOP, uiRightArea.ui, ANCHOR_TOP, 0, rightCurrentY)
                .setAlign(4)  // 居中对齐
                .setFontSize(7)
                .setText("|cffff9900联结赠礼|r");
            rightCurrentY = rightCurrentY - HEROSEL_TITLE_HEIGHT - HEROSEL_RIGHT_TEXT_GAP_Y;

            // 创建联结赠礼图标（5个，单行）
            rightGiftGridY = rightCurrentY;
            rightNextY = createRightIconGrid(uiRightArea.ui, rightStartX, rightCurrentY, HEROSEL_GIFT_COUNT, HEROSEL_GIFT_COUNT, 1);
            rightGiftEmptyText = uiText.create(uiRightArea.ui)
                .exRePoint(ANCHOR_CENTER, uiRightArea.ui, ANCHOR_TOP, 0, rightGiftGridY - HEROSEL_RIGHT_ICON_SIZE * 0.5)
                .setAlign(4)
                .setFontSize(7)
                .setText("|cff808080暂无|r")
                .show(true);
            rightCurrentY = rightNextY - HEROSEL_RIGHT_SECTION_GAP_Y;

            // 创建 "推荐技能" 文字
            rightSkillText = uiText.create(uiRightArea.ui)
                .exRePoint(ANCHOR_TOP, uiRightArea.ui, ANCHOR_TOP, 0, rightCurrentY)
                .setAlign(4)  // 居中对齐
                .setFontSize(7)
                .setText("|cffff9900推荐技能|r");
            rightCurrentY = rightCurrentY - HEROSEL_TITLE_HEIGHT - HEROSEL_RIGHT_TEXT_GAP_Y;

            // 创建推荐技能图标（5个，单行）
            rightSkillGridY = rightCurrentY;
            rightNextY = createRightIconGrid(uiRightArea.ui, rightStartX, rightCurrentY, HEROSEL_SKILL_COUNT, HEROSEL_SKILL_COUNT, 2);
            rightSkillEmptyText = uiText.create(uiRightArea.ui)
                .exRePoint(ANCHOR_CENTER, uiRightArea.ui, ANCHOR_TOP, 0, rightSkillGridY - HEROSEL_RIGHT_ICON_SIZE * 0.5)
                .setAlign(4)
                .setFontSize(7)
                .setText("|cff808080暂无|r")
                .show(true);
            rightCurrentY = rightNextY - HEROSEL_RIGHT_SECTION_GAP_Y;

            // 创建 "推荐装备" 文字
            rightEquipText = uiText.create(uiRightArea.ui)
                .exRePoint(ANCHOR_TOP, uiRightArea.ui, ANCHOR_TOP, 0, rightCurrentY)
                .setAlign(4)  // 居中对齐
                .setFontSize(7)
                .setText("|cffff9900推荐装备|r");
            rightCurrentY = rightCurrentY - HEROSEL_TITLE_HEIGHT - HEROSEL_RIGHT_TEXT_GAP_Y;

            // 创建推荐装备图标（10个，2行5列）
            rightEquipGridY = rightCurrentY;
            rightNextY = createRightIconGrid(uiRightArea.ui, rightStartX, rightCurrentY, HEROSEL_EQUIP_COUNT, HEROSEL_EQUIP_COLS, 3);
            // 推荐装备区块的"暂无"（两行区域居中）
            rightEquipEmptyText = uiText.create(uiRightArea.ui)
                .exRePoint(ANCHOR_CENTER, uiRightArea.ui, ANCHOR_TOP, 0, rightEquipGridY - (HEROSEL_RIGHT_ICON_SIZE * 2.0 + HEROSEL_RIGHT_ICON_GAP_Y) * 0.5)
                .setAlign(4)
                .setFontSize(7)
                .setText("|cff808080暂无|r")
                .show(true);

            // 装备区块下方：2 个进度条 + 2 个文本（居中，从上到下：bar1/text1/bar2/text2）
            progY = rightNextY - HEROSEL_RIGHT_SECTION_GAP_Y;
            rightProgBar1 = uiImageBar.create(uiRightArea.ui)
                .exReSize(HEROSEL_PROGRESS_BAR_WIDTH, HEROSEL_PROGRESS_BAR_HEIGHT)
                .setFillColor(0)
                .setPoint(ANCHOR_TOP, uiRightArea.ui, ANCHOR_TOP, 0, progY)
                .setProgress(0.0);
            rightProgBar1.uiBackground.show(false);
            rightProgBar1.uiFill.show(false);

            textY = progY - HEROSEL_PROGRESS_BAR_HEIGHT - HEROSEL_PROGRESS_BAR_TEXT_GAP_Y;
            rightProgText1 = uiText.create(uiRightArea.ui)
                .setAlign(4)
                .setFontSize(7)
                .exRePoint(ANCHOR_TOP, uiRightArea.ui, ANCHOR_TOP, 0, textY)
                .setText("")
                .show(false);

            progY = textY - HEROSEL_PROGRESS_TEXT_BAR_GAP_Y;
            rightProgBar2 = uiImageBar.create(uiRightArea.ui)
                .exReSize(HEROSEL_PROGRESS_BAR_WIDTH, HEROSEL_PROGRESS_BAR_HEIGHT)
                .setFillColor(2)
                .setPoint(ANCHOR_TOP, uiRightArea.ui, ANCHOR_TOP, 0, progY)
                .setProgress(0.0);
            rightProgBar2.uiBackground.show(false);
            rightProgBar2.uiFill.show(false);

            textY = progY - HEROSEL_PROGRESS_BAR_HEIGHT - HEROSEL_PROGRESS_BAR_TEXT_GAP_Y;
            rightProgText2 = uiText.create(uiRightArea.ui)
                .setAlign(4)
                .setFontSize(7)
                .exRePoint(ANCHOR_TOP, uiRightArea.ui, ANCHOR_TOP, 0, textY)
                .setText("")
                .show(false);

            // 底部按钮上方的文本（x轴位置与第4列图标对齐，默认隐藏）
            uiBottomText = uiText.create(uiMain.ui)
                .exRePoint(ANCHOR_BOTTOM, uiMain.ui, ANCHOR_BOTTOMLEFT, HEROSEL_GRID_OFFSET_X + 3 * (HEROSEL_CELL_SIZE + HEROSEL_CELL_GAP_X) + HEROSEL_CELL_SIZE * 0.5, HEROSEL_BOTTOM_BTN_HEIGHT * 0.5 + HEROSEL_BOTTOM_TEXT_GAP_Y)
                .setAlign(4)
                .setFontSize(7)
                .show(false);  // 默认隐藏

            uiBtn1Image = uiImage.create(uiMain.ui)
                .exReSize(HEROSEL_BOTTOM_BTN_WIDTH, HEROSEL_BOTTOM_BTN_HEIGHT)
                .setTexture("ui\\image\\select_flash.blp")
                .exRePoint(ANCHOR_CENTER, uiMain.ui, ANCHOR_BOTTOM, -HEROSEL_BOTTOM_BTN_GAP_X * 0.5 - HEROSEL_BOTTOM_BTN_WIDTH * 0.5, 0);
            uiBtn1Text = uiText.create(uiBtn1Image.ui)
                .setAllPoint(uiBtn1Image.ui)
                .setFontSize(7)
                .setAlign(4)
                .setText(HEROSEL_BTN1_TEXT_DEFAULT);
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
                .setText(HEROSEL_BTN2_TEXT_DEFAULT);
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
                .setText("0");

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
            // 销毁右侧内容
            integer i;
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

            // 销毁推荐装备图标
            for (1 <= i <= HEROSEL_EQUIP_COUNT) {
                if (rightEquipIcon[i] != 0) { rightEquipIcon[i].destroy(); rightEquipIcon[i] = 0; }
            }
            if (rightEquipText != 0) { rightEquipText.destroy(); rightEquipText = 0; }
            // 销毁推荐技能图标
            for (1 <= i <= HEROSEL_SKILL_COUNT) {
                if (rightSkillIcon[i] != 0) { rightSkillIcon[i].destroy(); rightSkillIcon[i] = 0; }
            }
            if (rightSkillText != 0) { rightSkillText.destroy(); rightSkillText = 0; }
            // 销毁联结赠礼图标
            for (1 <= i <= HEROSEL_GIFT_COUNT) {
                if (rightGiftIcon[i] != 0) { rightGiftIcon[i].destroy(); rightGiftIcon[i] = 0; }
            }
            if (rightGiftText != 0) { rightGiftText.destroy(); rightGiftText = 0; }
            // 销毁天赋技能图标
            for (1 <= i <= HEROSEL_TALENT_COUNT) {
                if (rightTalentIcon[i] != 0) { rightTalentIcon[i].destroy(); rightTalentIcon[i] = 0; }
            }
            if (rightTalentText != 0) { rightTalentText.destroy(); rightTalentText = 0; }
            if (rightTalentEmptyText != 0) { rightTalentEmptyText.destroy(); rightTalentEmptyText = 0; }
            if (rightGiftEmptyText != 0) { rightGiftEmptyText.destroy(); rightGiftEmptyText = 0; }
            if (rightSkillEmptyText != 0) { rightSkillEmptyText.destroy(); rightSkillEmptyText = 0; }
            if (rightEquipEmptyText != 0) { rightEquipEmptyText.destroy(); rightEquipEmptyText = 0; }

            if (rightProgText2 != 0) { rightProgText2.destroy(); rightProgText2 = 0; }
            if (rightProgBar2 != 0) { rightProgBar2.destroy(); rightProgBar2 = 0; }
            if (rightProgText1 != 0) { rightProgText1.destroy(); rightProgText1 = 0; }
            if (rightProgBar1 != 0) { rightProgBar1.destroy(); rightProgBar1 = 0; }

            if (growBtnAnim != 0) { growBtnAnim.destroy(); growBtnAnim = 0; }
            if (growBtnImage != 0) { growBtnImage.destroy(); growBtnImage = 0; }
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

        // 移动底部流光到按钮1(1)或按钮2(2)
        public static method setGrowBtnPos(integer pos) {
            if (!isOpen) { return; }
            growBtnPos = pos;
            if (growBtnImage == 0) { return; }
            if (pos == 1 && uiBtn1Image != 0) {
                growBtnImage.setPoint(ANCHOR_CENTER, uiBtn1Image.ui, ANCHOR_CENTER, growdata[ICONGROW_BTN].offsetX* growdata[ICONGROW_BTN].scale, growdata[ICONGROW_BTN].offsetY* growdata[ICONGROW_BTN].scale);
            } else if (pos == 2 && uiBtn2Image != 0) {
                growBtnImage.setPoint(ANCHOR_CENTER, uiBtn2Image.ui, ANCHOR_CENTER, growdata[ICONGROW_BTN].offsetX* growdata[ICONGROW_BTN].scale, growdata[ICONGROW_BTN].offsetY* growdata[ICONGROW_BTN].scale);
            }
        }

        // 通过创建/删除控制底部流光显示，默认不创建
        public static method enableGrowBtn(boolean enable) {
            growdata gd;
            if (!isOpen) { return; }
            if (enable) {
                if (growBtnImage != 0) { return; }  // 已创建则不重复
                gd = growdata[ICONGROW_BTN];
                growBtnImage = uiImage.create(uiMain.ui);
                if (growBtnPos == 1 && uiBtn1Image != 0) {
                    growBtnImage.setPoint(ANCHOR_CENTER, uiBtn1Image.ui, ANCHOR_CENTER, gd.offsetX* gd.scale, gd.offsetY* gd.scale);
                } else if (uiBtn2Image != 0) {
                    growBtnImage.setPoint(ANCHOR_CENTER, uiBtn2Image.ui, ANCHOR_CENTER, gd.offsetX* gd.scale, gd.offsetY* gd.scale);
                }
                growBtnImage.exReSize(HEROSEL_GROW_BTN_SIZE* gd.scale, HEROSEL_GROW_BTN_SIZE* gd.scale);
                growBtnAnim = baseanim.create(growBtnImage.ui);
                growBtnAnim.addSequ(gd.path, gd.max, gd.gap, true);
            } else {
                if (growBtnAnim != 0) { growBtnAnim.destroy(); growBtnAnim = 0; }
                if (growBtnImage != 0) { growBtnImage.destroy(); growBtnImage = 0; }
            }
        }

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
#undef HEROSEL_GROW_BTN_SIZE
#undef HEROSEL_CONTENT_MARGIN_X
#undef HEROSEL_CONTENT_MARGIN_Y
#undef HEROSEL_BP_ICON_SIZE
#undef HEROSEL_BP_TEXT_GAP_X
#undef HEROSEL_BP_OFFSET_X
#undef HEROSEL_BP_OFFSET_Y
#undef HEROSEL_RIGHT_ICON_SIZE
#undef HEROSEL_RIGHT_ICON_GAP_X
#undef HEROSEL_RIGHT_ICON_GAP_Y
#undef HEROSEL_RIGHT_TEXT_GAP_Y
#undef HEROSEL_RIGHT_SECTION_GAP_Y
#undef HEROSEL_RIGHT_START_OFFSET_X
#undef HEROSEL_RIGHT_START_OFFSET_Y
#undef HEROSEL_TALENT_COUNT
#undef HEROSEL_GIFT_COUNT
#undef HEROSEL_SKILL_COUNT
#undef HEROSEL_EQUIP_COUNT
#undef HEROSEL_EQUIP_COLS

#endif
