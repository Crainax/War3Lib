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

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/core/table/Hash_UnitDefine.j"

//! zinc
library TexttagUtils requires HashTable {


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

    // 限时跟随漂浮文字（不向上漂浮，而是跟随单位移动）
    //
    // 行为说明：
    // - 第一次调用：创建 texttag，并启动一个 0.05s 周期定时器，每 tick 更新位置与倒计时
    // - 重复调用：不再创建定时器，只会刷新文本并延长剩余时间（取 max(旧剩余时间, 新 time)）
    //
    // 数据存储（父键：GetHandleId(whichUnit)，表：HASH_UNIT）：
    // - KEY_UNIT_HINT_TIME：剩余时间（real）
    // - KEY_UNIT_HINT_OFFSET：X 偏移（real）
    // - KEY_UNIT_HINT_TEXTTAG：texttag 句柄
    //
    // 注意：
    // - 如果单位被移除导致句柄为 null，定时器会安全自清理
    // - time <= 0 会被归一为 0.01，避免出现负值倒计时
    public function ShowUnitHintFollowTag(string s, unit whichUnit, real size, real red, real green, real blue, real off, real time) {
        integer uid;
        real oldTime;
        texttag oldTag;
        timer t;

        // 局部变量声明在前；句柄在尾部置空
        uid = 0;
        oldTime = 0.0;
        oldTag = null;
        t = null;

        if (whichUnit == null) {
            return;
        }

        time = RMaxBJ(0.01, time);
        uid = GetHandleId(whichUnit);

        // 已存在：刷新文本并延长时间（不重复创建 timer）
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_HINT_TIME)) {
            oldTime = LoadReal(HASH_UNIT, uid, KEY_UNIT_HINT_TIME);
            SaveReal(HASH_UNIT, uid, KEY_UNIT_HINT_TIME, RMaxBJ(time, oldTime));

            oldTag = LoadTextTagHandle(HASH_UNIT, uid, KEY_UNIT_HINT_TEXTTAG);
            if (oldTag != null) {
                DestroyTextTag(oldTag);
            }

            SaveTextTagHandle(HASH_UNIT, uid, KEY_UNIT_HINT_TEXTTAG, CreateTextTagOnUnitOffsetX(s, whichUnit, 20, size, red, green, blue, 0, off));
            SaveReal(HASH_UNIT, uid, KEY_UNIT_HINT_OFFSET, off);
        } else {
            // 首次：创建并启动跟随计时器
            SaveReal(HASH_UNIT, uid, KEY_UNIT_HINT_TIME, time);
            SaveTextTagHandle(HASH_UNIT, uid, KEY_UNIT_HINT_TEXTTAG, CreateTextTagOnUnitOffsetX(s, whichUnit, 20, size, red, green, blue, 100, off));
            SaveReal(HASH_UNIT, uid, KEY_UNIT_HINT_OFFSET, off);

            t = CreateTimer();
            SaveUnitHandle(HASH_TIMER, GetHandleId(t), 1, whichUnit);

            TimerStart(t, 0.05, true, function () {
                timer ttimer;
                integer tid;
                unit u;
                integer uid;
                real left;
                real off;
                texttag tag;

                ttimer = null;
                tid = 0;
                u = null;
                uid = 0;
                left = 0.0;
                off = 0.0;
                tag = null;

                ttimer = GetExpiredTimer();
                tid = GetHandleId(ttimer);
                u = LoadUnitHandle(HASH_TIMER, tid, 1);

                // 单位句柄已失效：仅清理 timer 的存储与自身
                if (u == null) {
                    PauseTimer(ttimer);
                    FlushChildHashtable(HASH_TIMER, tid);
                    DestroyTimer(ttimer);
                    ttimer = null;
                    return;
                }

                uid = GetHandleId(u);
                if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_HINT_TIME)) {
                    left = LoadReal(HASH_UNIT, uid, KEY_UNIT_HINT_TIME);
                } else {
                    left = 0.0;
                }

                if (left > 0.0) {
                    left -= 0.05;
                    if (left < 0.0) { left = 0.0; }
                    SaveReal(HASH_UNIT, uid, KEY_UNIT_HINT_TIME, left);

                    tag = LoadTextTagHandle(HASH_UNIT, uid, KEY_UNIT_HINT_TEXTTAG);
                    off = LoadReal(HASH_UNIT, uid, KEY_UNIT_HINT_OFFSET);
                    if (tag != null) {
                        SetTextTagPos(tag, YDWECoordinateX(GetUnitX(u) - off), GetUnitY(u), 20);
                    }
                } else {
                    tag = LoadTextTagHandle(HASH_UNIT, uid, KEY_UNIT_HINT_TEXTTAG);
                    if (tag != null) {
                        DestroyTextTag(tag);
                    }

                    RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_HINT_TIME);
                    RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_HINT_OFFSET);
                    RemoveSavedHandle(HASH_UNIT, uid, KEY_UNIT_HINT_TEXTTAG);

                    PauseTimer(ttimer);
                    FlushChildHashtable(HASH_TIMER, tid);
                    DestroyTimer(ttimer);
                }

                // handler 置空，防泄漏
                tag = null;
                u = null;
                ttimer = null;
            });
        }

        oldTag = null;
        t = null;
    }



}
//! endzinc

#endif
