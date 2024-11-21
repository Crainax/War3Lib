#ifndef UIConstantsIncluded
#define UIConstantsIncluded

// 锚点常量
#define ANCHOR_TOPLEFT 0
#define ANCHOR_TOP 1
#define ANCHOR_TOPRIGHT 2
#define ANCHOR_LEFT 3
#define ANCHOR_CENTER 4
#define ANCHOR_RIGHT 5
#define ANCHOR_BOTTOMLEFT 6
#define ANCHOR_BOTTOM 7
#define ANCHOR_BOTTOMRIGHT 8

// 事件常量
#define FRAME_EVENT_NONE  0
#define FRAME_MOUSE_ENTER  2
#define FRAME_MOUSE_LEAVE  3
#define FRAME_MOUSE_DOWN  1
#define FRAME_MOUSE_UP  4
#define FRAME_MOUSE_WHEEL  6
#define FRAME_MOUSE_DOUBLECLICK  12

#define FRAME_FOCUS_ENTER  2
#define FRAME_FOCUS_LEAVE  3
#define FRAME_CHECKBOX_CHECKED  7
#define FRAME_CHECKBOX_UNCHECKED  8
#define FRAME_EDITBOX_TEXT_CHANGED  9
#define FRAME_POPUPMENU_ITEM_CHANGE_START  10
#define FRAME_POPUPMENU_ITEM_CHANGED  11
#define FRAME_SPRITE_ANIM_UPDATE  13

//鼠标点击事件
#define FRAME_EVENT_KEY_PRESSED 1
#define FRAME_EVENT_KEY_UP 0
#define FRAME_MOUSE_LEFT 1
#define FRAME_MOUSE_RIGHT 2


//Index名:
#define STRING_BUTTON         "Btn"
#define STRING_IMAGE          "Img"
#define STRING_IMAGE_TOOLTIPS "ToolTips"
#define STRING_SPRITE         "Sprite"
#define STRING_TEXT           "Text"
#define STRING_SLIDER_NORMAL  "NormalSlider"

//默认原生图片路径
#define UI_STRING_PATH_BLANK "UI\\Widgets\\EscMenu\\Human\\blank-background.blp"

//模板名
#define TEMPLATE_BLANK_BUTTON       "BlankButtonTemplate"
#define TEMPLATE_NORMAL_BUTTON      "ButtonTemplate" //无声
#define TEMPLATE_TEXT_BUTTON        "TextButtonTemplate"
#define TEMPLATE_IMAGE              "ImageTemplate"
#define TEMPLATE_IMAGE_TOOLTIPS     "ToolTipsTemplate"
#define TEMPLATE_IMAGE_TOOLTIPS_2   "ToolTipsTemplate2"
#define TEMPLATE_IMAGE_TOOLTIPS_1_2 "ToolTipsTemplate3"
#define TEMPLATE_SPRITE             "SpriteTemplate"
#define TEMPLATE_TEXT               "T1"      // 标准文字模板(无事件)
#define TEMPLATE_TEXT_EVENT         "T2"      // 标准文字模板(有事件)
#define TEMPLATE_SLIDER_NORMAL      "NormalSlider"


//TEXT对齐常量:(uiText.setAlign)
#define TEXT_ALIGN_TOPLEFT      9  // TOP + LEFT
#define TEXT_ALIGN_TOPCENTER    17 // TOP + CENTER
#define TEXT_ALIGN_TOPRIGHT     33 // TOP + RIGHT
#define TEXT_ALIGN_MIDDLELEFT   10 // MIDDLE + LEFT
#define TEXT_ALIGN_MIDDLECENTER 18 // MIDDLE + CENTER
#define TEXT_ALIGN_MIDDLERIGHT  34 // MIDDLE + RIGHT
#define TEXT_ALIGN_BOTTOMLEFT   12 // BOTTOM + LEFT
#define TEXT_ALIGN_BOTTOMCENTER 20 // BOTTOM + CENTER
#define TEXT_ALIGN_BOTTOMRIGHT  36 // BOTTOM + RIGHT

#endif
