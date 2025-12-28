#ifndef BeyondSpeedIncluded
#define BeyondSpeedIncluded

#include "Crainax/core/table/Hash_UnitDefine.j"
/*
超级速度
通过 SetUnitX/Y 补位移模拟更高速度（突破 522 上限）
*/


//! zinc
library BeyondSpeed requires HashTable, UnitHashTable {

    // 超级速度队列：集中管理所有处于超速中的单位
    public struct SuperSpeedQueue [] {
        private static unit  uList[];      // 单位列表
        private static integer size = 0;     // 当前元素数量
        private static timer tickTimer = null; // 驱动超速补位移的定时器

        // 尾部交换移除指定索引的元素（共通方法）
        private static method removeAt(integer index) -> integer {
            integer last;
            if (index < 0 || index >= thistype.size) { return index; }

            last = thistype.size - 1;
            if (index != last) {
                thistype.uList[index] = thistype.uList[last];
            }
            thistype.uList[last] = null;
            thistype.size -= 1;
            // 返回新的索引（因为换入了新元素，需要回退一位继续检查）
            return index - 1;
        }

        // 清理单位的所有超速相关数据
        public static method cleanupUnit(unit u) {
            integer hid;
            if (u == null) { return; }
            hid = GetHandleId(u);
            RemoveSavedInteger(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_BONUS);
            RemoveSavedBoolean(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_DISABLED);
            RemoveSavedString(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_EFX_PATH);
            RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_X0);
            RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_Y0);
            RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_X1);
            RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_Y1);
            RemoveSavedInteger(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_N);
            RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_N2);
            RemoveSavedReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_INTJ);
        }

        // 将单位加入队列（如果不在队列中）
        public static method addUnit(unit u) {
            integer i; integer hid; real intj;
            if (u == null) { return; }

            // 内联查找是否已在队列中
            for (i = 0; i < thistype.size; i += 1) {
                if (thistype.uList[i] == u) {
                    // 已在队列中，不需要重复添加
                    return;
                }
            }

            // 检查队列容量
            if (thistype.size >= 8190) {
                BJDebugMsg("|cFFFF0000[SuperSpeedQueue] 队列已满，无法继续添加超速单位！|r");
                return;
            }

            // 加入队列
            thistype.uList[thistype.size] = u;
            thistype.size += 1;

            // 初始化运行态数据（首次加入时）
            hid = GetHandleId(u);
            if (!HaveSavedReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_X0)) {
                intj = 0.02;
                SaveReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_X0, GetUnitX(u));
                SaveReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_Y0, GetUnitY(u));
                SaveReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_X1, GetUnitX(u));
                SaveReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_Y1, GetUnitY(u));
                SaveInteger(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_N, 0);
                SaveReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_N2, 0.0);
                SaveReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_INTJ, intj);
            }

            // 确保定时器运行
            if (thistype.tickTimer == null) {
                thistype.tickTimer = CreateTimer();
                TimerStart(thistype.tickTimer, 0.01, true, function () {
                    integer i; integer hid; unit u; integer bonus; boolean disabled; string efxPath;
                    real x0; real y0; real x1; real y1; integer n; real n2; real intj;
                    real ms; real ms0; real a; real a2; real d; real cosDiff; real scale; real tempd;

                    // 单次遍历 + 尾部交换，O(n)
                    for (i = 0; i < thistype.size; i += 1) {
                        u = thistype.uList[i];
                        if (u == null) {
                            // 单位已失效，尾部交换移除
                            i = thistype.removeAt(i);
                        } else {
                            hid = GetHandleId(u);

                            // 检查单位是否有效
                            if (GetUnitTypeId(u) == 0) {
                                // 单位已失效，清理并移出队列
                                thistype.cleanupUnit(u);
                                i = thistype.removeAt(i);
                                u = null;
                            } else if (!HaveSavedInteger(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_BONUS)) {
                                // 检查是否还有 bonus 记录
                                // 外部已清理，移出队列
                                thistype.cleanupUnit(u);
                                i = thistype.removeAt(i);
                                u = null;
                            } else {
                                bonus = LoadInteger(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_BONUS);
                                if (bonus <= 0) {
                                    // bonus <= 0，清理并移出队列
                                    thistype.cleanupUnit(u);
                                    i = thistype.removeAt(i);
                                    u = null;
                                } else {
                                    // 正常处理逻辑
                                    // 读取配置和状态
                                    disabled = false;
                                    if (HaveSavedBoolean(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_DISABLED)) {
                                        disabled = LoadBoolean(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_DISABLED);
                                    }

                                    efxPath = "";
                                    if (HaveSavedString(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_EFX_PATH)) {
                                        efxPath = LoadStr(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_EFX_PATH);
                                    }

                                    x0 = LoadReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_X0);
                                    y0 = LoadReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_Y0);
                                    x1 = LoadReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_X1);
                                    y1 = LoadReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_Y1);
                                    n = LoadInteger(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_N);
                                    n2 = LoadReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_N2);
                                    intj = LoadReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_INTJ);

                                    ms0 = GetUnitMoveSpeed(u);
                                    ms = RMinBJ(ms0 + I2R(bonus), MAX_SUPER_SPEED);

                                    n += 1;
                                    n2 += 0.01;

                                    if (disabled) {
                                        // disabled=true：仅刷新 x/y 状态，跳过补位移与特效
                                        if (n2 >= intj) {
                                            n2 = 0.0;
                                            x0 = x1;
                                            y0 = y1;
                                            x1 = GetUnitX(u);
                                            y1 = GetUnitY(u);
                                        }
                                    } else {
                                        // 正常处理：计算补位移
                                        if (n2 >= intj) {
                                            n2 = 0.0;

                                            // 取这一段的真实位移方向（a）与面向（a2）
                                            x0 = x1;
                                            y0 = y1;
                                            x1 = GetUnitX(u);
                                            y1 = GetUnitY(u);

                                            d = SquareRoot(Pow((x0 - x1), 2) + Pow((y0 - y1), 2));
                                            a = Atan2(y1 - y0, x1 - x0);
                                            a2 = Deg2Rad(GetUnitFacing(u));

                                            // 丝滑版本：不再"转向就停"，而是按转向幅度缩放补位移
                                            // scale = clamp(Cos(a-a2), 0..1)
                                            cosDiff = Cos(a - a2);
                                            scale = RMinBJ(RMaxBJ(cosDiff, 0.0), 1.0);

                                            // 只有在确实在走、且不是异常大位移时才补位移
                                            if ((d <= 550.0 * intj) && (d > ms0 * 0.8 * intj)) {
                                                // 只补"差额"，不做负向拉回
                                                tempd = RMaxBJ(ms * intj - d, 0.0) * scale;
                                                if (tempd > 0.0) {
                                                    x1 = x1 + tempd * Cos(a);
                                                    y1 = y1 + tempd * Sin(a);
                                                    if (RectContainsCoords(bj_mapInitialPlayableArea, x1, y1)) {
                                                        SetUnitX(u, x1);
                                                        SetUnitY(u, y1);
                                                        // 按 n 周期播放特效
                                                        if (ModuloInteger(n, 5) == 0 && efxPath != "") {
                                                            n = 0;
                                                            DestroyEffect(AddSpecialEffect(efxPath, x1, y1));
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    // 写回状态
                                    SaveReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_X0, x0);
                                    SaveReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_Y0, y0);
                                    SaveReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_X1, x1);
                                    SaveReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_Y1, y1);
                                    SaveInteger(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_N, n);
                                    SaveReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_N2, n2);
                                    SaveReal(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_INTJ, intj);

                                    u = null;
                                }
                            }
                        }
                    }

                    // 队列为空时，停止并释放计时器，方便下次懒加载
                    if (thistype.size <= 0 && thistype.tickTimer != null) {
                        PauseTimer(thistype.tickTimer);
                        DestroyTimer(thistype.tickTimer);
                        thistype.tickTimer = null;
                        #if (CURRENT_BUILD_VERSION == VERSION_UNITTEST)
                        BJDebugMsg("SuperSpeedQueue: 超级速度队列已销毁");
                        #endif
                    }
                });
            }
        }

        // 从队列移除单位（不清理数据，仅移出队列）
        public static method removeUnit(unit u) {
            integer i;
            if (u == null) { return; }

            for (i = 0; i < thistype.size; i += 1) {
                if (thistype.uList[i] == u) {
                    thistype.removeAt(i);
                    break;
                }
            }
        }
    }

    // 添加单位超级速度（累计加速值）
    public function AddUnitSuperSpeed(unit u, integer delta) {
        integer hid; integer oldBonus; integer newBonus;
        if (u == null) { return; }

        hid = GetHandleId(u);

        // 读取并累计 bonus
        if (HaveSavedInteger(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_BONUS)) {
            oldBonus = LoadInteger(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_BONUS);
        } else {
            oldBonus = 0;
        }
        newBonus = oldBonus + delta;

        if (newBonus > 0) {
            // 保存新的 bonus
            SaveInteger(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_BONUS, newBonus);
            // 确保加入队列
            SuperSpeedQueue.addUnit(u);
        } else {
            // bonus <= 0，清理并移出队列
            SuperSpeedQueue.removeUnit(u);
            SuperSpeedQueue.cleanupUnit(u);
        }
    }

    // 获取单位超级速度累计值
    public function GetUnitSuperSpeed(unit u) -> integer {
        integer hid;
        if (u == null) { return 0; }
        hid = GetHandleId(u);
        if (HaveSavedInteger(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_BONUS)) {
            return LoadInteger(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_BONUS);
        }
        return 0;
    }

    // 设置单位超级速度特效路径
    public function SetUnitSuperSpeedEffect(unit u, string path) {
        integer hid;
        if (u == null) { return; }
        hid = GetHandleId(u);
        if (path == "" || path == null) {
            RemoveSavedString(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_EFX_PATH);
        } else {
            SaveStr(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_EFX_PATH, path);
        }
    }

    // 设置单位超级速度启用状态（enable=false 仅暂停补位移，不清空 bonus）
    public function SetUnitSuperSpeedEnable(unit u, boolean enable) {
        integer hid;
        if (u == null) { return; }
        hid = GetHandleId(u);
        if (enable) {
            RemoveSavedBoolean(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_DISABLED);
        } else {
            SaveBoolean(HASH_UNIT, hid, KEY_UNIT_SUPERSPEED_DISABLED, true);
        }
    }
}
//! endzinc

#endif
