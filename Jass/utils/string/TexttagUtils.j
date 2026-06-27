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
#define TEXTTAG_HINT_FOLLOW_TICK 0.05
#define TEXTTAG_HINT_FOLLOW_MAX_SIZE 8190

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

    private struct UnitHintFollowQueue [] {
        private static unit uList[];
        private static texttag tagList[];
        private static real leftList[];
        private static real offsetList[];
        private static integer size = 0;
        private static timer tickTimer = null;

        private static method clearSaved(unit u) {
            integer uid;

            if (u == null) { return; }
            uid = GetHandleId(u);
            RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_HINT_TIME);
            RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_HINT_OFFSET);
            RemoveSavedHandle(HASH_UNIT, uid, KEY_UNIT_HINT_TEXTTAG);
        }

        private static method stopTimerIfEmpty() {
            if (thistype.size <= 0 && thistype.tickTimer != null) {
                PauseTimer(thistype.tickTimer);
                DestroyTimer(thistype.tickTimer);
                thistype.tickTimer = null;
            }
        }

        private static method removeAt(integer index) -> integer {
            integer last;
            unit removed;
            texttag removedTag;

            if (index < 0 || index >= thistype.size) { return index; }

            last = thistype.size - 1;
            removed = thistype.uList[index];
            removedTag = thistype.tagList[index];

            if (removedTag != null) {
                DestroyTextTag(removedTag);
            }
            thistype.clearSaved(removed);

            if (index != last) {
                thistype.uList[index] = thistype.uList[last];
                thistype.tagList[index] = thistype.tagList[last];
                thistype.leftList[index] = thistype.leftList[last];
                thistype.offsetList[index] = thistype.offsetList[last];
            }

            thistype.uList[last] = null;
            thistype.tagList[last] = null;
            thistype.leftList[last] = 0.0;
            thistype.offsetList[last] = 0.0;
            thistype.size -= 1;

            removed = null;
            removedTag = null;
            return index - 1;
        }

        private static method indexOf(unit u) -> integer {
            integer i;

            if (u == null) { return -1; }
            for (i = 0; i < thistype.size; i += 1) {
                if (thistype.uList[i] == u) { return i; }
            }
            return -1;
        }

        private static method ensureTimer() {
            if (thistype.tickTimer == null) {
                thistype.tickTimer = CreateTimer();
                TimerStart(thistype.tickTimer, TEXTTAG_HINT_FOLLOW_TICK, true, function () {
                    integer i;
                    integer uid;
                    unit u;
                    texttag tag;
                    real left;
                    real off;

                    uid = 0;
                    u = null;
                    tag = null;
                    left = 0.0;
                    off = 0.0;

                    for (i = 0; i < thistype.size; i += 1) {
                        u = thistype.uList[i];
                        if (u == null || GetUnitTypeId(u) == 0) {
                            i = thistype.removeAt(i);
                        } else {
                            uid = GetHandleId(u);
                            if (!HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_HINT_TIME)) {
                                i = thistype.removeAt(i);
                            } else {
                                left = thistype.leftList[i];
                                if (left > 0.0) {
                                    left -= TEXTTAG_HINT_FOLLOW_TICK;
                                    if (left < 0.0) { left = 0.0; }

                                    thistype.leftList[i] = left;
                                    SaveReal(HASH_UNIT, uid, KEY_UNIT_HINT_TIME, left);

                                    tag = thistype.tagList[i];
                                    off = thistype.offsetList[i];
                                    if (tag != null) {
                                        SetTextTagPos(tag, YDWECoordinateX(GetUnitX(u) - off), GetUnitY(u), 20);
                                    }
                                } else {
                                    i = thistype.removeAt(i);
                                }
                            }
                        }

                        tag = null;
                        u = null;
                    }

                    thistype.stopTimerIfEmpty();
                });
            }
        }

        public static method show(string s, unit whichUnit, real textSize, real red, real green, real blue, real off, real time) {
            integer index;
            integer uid;
            real left;
            texttag oldTag;

            index = 0;
            uid = 0;
            left = 0.0;
            oldTag = null;

            if (whichUnit == null || GetUnitTypeId(whichUnit) == 0) {
                return;
            }

            time = RMaxBJ(0.01, time);
            uid = GetHandleId(whichUnit);
            index = thistype.indexOf(whichUnit);
            if (index >= 0) {
                left = RMaxBJ(time, thistype.leftList[index]);
                thistype.leftList[index] = left;
                thistype.offsetList[index] = off;

                oldTag = thistype.tagList[index];
                if (oldTag != null) {
                    DestroyTextTag(oldTag);
                }
                thistype.tagList[index] = CreateTextTagOnUnitOffsetX(s, whichUnit, 20, textSize, red, green, blue, 0, off);

                SaveReal(HASH_UNIT, uid, KEY_UNIT_HINT_TIME, left);
                SaveReal(HASH_UNIT, uid, KEY_UNIT_HINT_OFFSET, off);
                SaveTextTagHandle(HASH_UNIT, uid, KEY_UNIT_HINT_TEXTTAG, thistype.tagList[index]);
                thistype.ensureTimer();

                oldTag = null;
                return;
            }

            if (thistype.size >= TEXTTAG_HINT_FOLLOW_MAX_SIZE) {
                BJDebugMsg("|cFFFF0000[UnitHintFollowQueue] 队列已满，无法继续添加跟随文字！|r");
                return;
            }

            index = thistype.size;
            thistype.uList[index] = whichUnit;
            thistype.leftList[index] = time;
            thistype.offsetList[index] = off;
            thistype.tagList[index] = CreateTextTagOnUnitOffsetX(s, whichUnit, 20, textSize, red, green, blue, 0, off);
            thistype.size += 1;

            SaveReal(HASH_UNIT, uid, KEY_UNIT_HINT_TIME, time);
            SaveReal(HASH_UNIT, uid, KEY_UNIT_HINT_OFFSET, off);
            SaveTextTagHandle(HASH_UNIT, uid, KEY_UNIT_HINT_TEXTTAG, thistype.tagList[index]);
            thistype.ensureTimer();

            oldTag = null;
        }
    }

    // 限时跟随漂浮文字（不向上漂浮，而是跟随单位移动）
    //
    // 行为说明：
    // - 第一次调用：创建 texttag，并懒加载一个共享 0.05s 中央计时器
    // - 重复调用：刷新文本并延长剩余时间（取 max(旧剩余时间, 新 time)）
    // - 队列为空：销毁中央计时器，下一次调用再创建
    //
    // 数据存储（父键：GetHandleId(whichUnit)，表：HASH_UNIT）：
    // - KEY_UNIT_HINT_TIME：剩余时间（real）
    // - KEY_UNIT_HINT_OFFSET：X 偏移（real）
    // - KEY_UNIT_HINT_TEXTTAG：texttag 句柄
    public function ShowUnitHintFollowTag(string s, unit whichUnit, real size, real red, real green, real blue, real off, real time) {
        UnitHintFollowQueue.show(s, whichUnit, size, red, green, blue, off, time);
    }



}
//! endzinc

#endif
