#ifndef TexttagUtilsIncluded
#define TexttagUtilsIncluded

/*
漂浮文字工具类（Zinc）
- 统一更语义化命名，并保留旧名包装（兼容原调用）
- 使用 BJ 版本 API（SetTextTagTextBJ/SetTextTagColorBJ/SetTextTagVelocityBJ）
  注意：颜色与透明度为 0~100 的百分比刻度；size 为 BJ 字号（常用 10~24）
- 所有“定时消失”的函数都会设置：
  Permanent = false, Lifespan = time, Fadepoint = time
- 局部句柄在函数尾部置 null（兼容旧版习惯）

CreateTextTagUnitOffX → CreateTextTagOnUnitOffsetX
ShowTextTagUnitOffX → ShowTextTagOnUnitOffsetX
CreateTextTagA → CreateTimedTextTagOnUnit
CreateTextTagBA → CreateTimedTextTagOnUnitAngle
*/

// 常量：速度与角度（度数）
#define TEXTTAG_VELOCITY_SLOW 64.00
#define TEXTTAG_VELOCITY_FAST 128.00
#define TEXTTAG_ANGLE_UP      90.00

//! zinc
library TexttagUtils {


    // 创建：在单位处创建一个文本，允许 X 方向偏移与 Z 高度偏移，不设置寿命（交由调用方处理）
    // 旧名：CreateTextTagUnitOffX
    // param text         文本内容
    // param whichUnit    目标单位
    // param zOffset      Z 方向高度偏移
    // param size         字号（BJ 尺度，常见 10~24）
    // param red          红色百分比(0~100)
    // param green        绿色百分比(0~100)
    // param blue         蓝色百分比(0~100)
    // param transparency 透明度百分比(0~100，0=不透明，100=全透明)
    // param offsetX      X 方向偏移（世界坐标）
    // return             创建的 texttag 句柄（需调用方设置寿命或销毁）
    public function CreateTextTagOnUnitOffsetX(string text, unit whichUnit, real zOffset, real size, real red, real green, real blue, real transparency, real offsetX) -> texttag {
        texttag t = CreateTextTag();
        real x = GetUnitX(whichUnit) - offsetX;
        real y = GetUnitY(whichUnit);

        SetTextTagTextBJ(t, text, size);
        SetTextTagPos(t, x, y, zOffset);
        SetTextTagColorBJ(t, red, green, blue, transparency);
        return t;
    }

    // 便捷：在单位处创建文本，向上漂浮并在 time 秒后消失（快速速度）
    // 旧名：ShowTextTagUnitOffX
    // param text      文本内容
    // param whichUnit 目标单位
    // param red       红色百分比(0~100)
    // param green     绿色百分比(0~100)
    // param blue      蓝色百分比(0~100)
    // param time      寿命（秒），<=0 将被归一为 0.01
    // param size      字号（BJ 尺度）
    // param offsetX   X 方向偏移
    public function ShowTextTagOnUnitOffsetX(string text, unit whichUnit, real red, real green, real blue, real time, real size, real offsetX) {
        texttag t = CreateTextTagOnUnitOffsetX(text, whichUnit, 0, size, red, green, blue, 0, offsetX);
        time = RMaxBJ(0.01,time);

        SetTextTagVelocityBJ(t, TEXTTAG_VELOCITY_FAST, TEXTTAG_ANGLE_UP);
        SetTextTagPermanent(t, false);
        SetTextTagLifespan(t, time);
        SetTextTagFadepoint(t, time);

        t = null;
    }

    // 便捷：创建“向上缓慢漂浮并消失”的文本（慢速）
    // 旧名：CreateTextTagA
    // param text      文本内容
    // param whichUnit 目标单位
    // param red       红色百分比(0~100)
    // param green     绿色百分比(0~100)
    // param blue      蓝色百分比(0~100)
    // param time      寿命（秒），<=0 将被归一为 0.01
    // param size      字号（BJ 尺度）
    public function CreateTimedTextTagOnUnit(string text, unit whichUnit, real red, real green, real blue, real time, real size) {
        texttag t = CreateTextTagOnUnitOffsetX(text, whichUnit, 0, size, red, green, blue, 0, 0);
        time = RMaxBJ(0.01,time);

        SetTextTagVelocityBJ(t, TEXTTAG_VELOCITY_SLOW, TEXTTAG_ANGLE_UP);
        SetTextTagPermanent(t, false);
        SetTextTagLifespan(t, time);
        SetTextTagFadepoint(t, time);

        t = null;
    }

    // 便捷：创建“按给定角度漂浮并消失”的文本（快速）
    // 旧名：CreateTextTagBA
    // param text      文本内容
    // param whichUnit 目标单位
    // param red       红色百分比(0~100)
    // param green     绿色百分比(0~100)
    // param blue      蓝色百分比(0~100)
    // param time      寿命（秒），<=0 将被归一为 0.01
    // param size      字号（BJ 尺度）
    // param angleDeg  漂浮方向角度（度），0=向右，90=向上
    public function CreateTimedTextTagOnUnitAngle(string text, unit whichUnit, real red, real green, real blue, real time, real size, real angleDeg) {
        texttag t = CreateTextTagOnUnitOffsetX(text, whichUnit, 0, size, red, green, blue, 0, 0);
        time = RMaxBJ(0.01,time);

        SetTextTagVelocityBJ(t, TEXTTAG_VELOCITY_FAST, angleDeg);
        SetTextTagPermanent(t, false);
        SetTextTagLifespan(t, time);
        SetTextTagFadepoint(t, time);

        t = null;
    }

    // 技能快捷：使用固定字号创建技能文字（向上慢速漂浮）
    // 保持原函数名
    // param text      文本内容
    // param whichUnit 目标单位
    // param red       红色百分比(0~100)
    // param green     绿色百分比(0~100)
    // param blue      蓝色百分比(0~100)
    // param time      寿命（秒），<=0 将被归一为 0.01
    public function CreateSpellTextTag(string text, unit whichUnit, real red, real green, real blue, real time) {
        // 约定字号 16，慢速向上
        CreateTimedTextTagOnUnit(text, whichUnit, red, green, blue, time, 16);
    }

    // 技能快捷：任意方向（快速）
    // 保持原函数名
    // param text      文本内容
    // param whichUnit 目标单位
    // param red       红色百分比(0~100)
    // param green     绿色百分比(0~100)
    // param blue      蓝色百分比(0~100)
    // param time      寿命（秒），<=0 将被归一为 0.01
    // param angleDeg  漂浮方向角度（度）
    public function CreateSpellTextTagB(string text, unit whichUnit, real red, real green, real blue, real time, real angleDeg) {
        // 约定字号 13，快速按角度漂浮
        CreateTimedTextTagOnUnitAngle(text, whichUnit, red, green, blue, time, 13, angleDeg);
    }

}
//! endzinc

#endif
