#ifndef AttenuationBarrierIncluded
#define AttenuationBarrierIncluded

#include "Crainax/core/table/Hash_UnitDefine.j"

//! zinc
// p=0.5, F(S)=S (S<=T), sqrt(T)*sqrt(S) (S>T).
// 每单位累计所有来源；全局对齐的0.5秒固定窗口，非滑动窗口。
// 所有写接口必须同步调用；纯查询可供本地UI读取。
// 永久移除单位前必须 RemoveAttenuationBarrier，且在清空HASH_UNIT之前调用。
library AttenuationBarrier requires UnitHashTable {
    private unit subjects[];
    private real thresholds[];
    private real thresholdRoots[];
    private real rawSums[];
    private real rawRoots[];
    private real sumErrors[];
    private integer windows[];
    private integer size = 0;
    private integer window = 1;
    private timer clockTimer = null;
    private boolean debugEnabled = false;

    public function GetAttenuationBarrierWindow() -> integer { return window; }
    public function GetAttenuationBarrierCount() -> integer { return size; }
    public function GetAttenuationBarrierInterval() -> real { return 0.5; }

    // 槽位只用于诊断，不得跨删除操作缓存。HandleId仅用作本机查表键。
    public function GetAttenuationBarrierSlot(unit u) -> integer {
        integer slot;
        if (u == null) { return 0; }
        slot = LoadInteger(HASH_UNIT, GetHandleId(u), KEY_UNIT_ATTENUATION_BARRIER);
        if (slot < 1 || slot > size) { return 0; }
        if (subjects[slot] != u) { return 0; }
        return slot;
    }

    public function GetAttenuationBarrierThreshold(unit u) -> real {
        integer slot = GetAttenuationBarrierSlot(u);
        if (slot == 0) { return 0.0; }
        return thresholds[slot];
    }

    // 过期快照在查询时视为0，查询本身不写同步状态。
    public function GetAttenuationBarrierRaw(unit u) -> real {
        integer slot = GetAttenuationBarrierSlot(u);
        if (slot == 0 || windows[slot] != window) { return 0.0; }
        return rawSums[slot];
    }

    public function SetAttenuationBarrierDebug(boolean enabled) {
        debugEnabled = enabled;
    }

    public function LogAttenuationBarrier(unit u) {
        integer slot = GetAttenuationBarrierSlot(u);
        DzWriteLog("[AttenuationBarrier] snapshot slot=" + I2S(slot) + " count=" + I2S(size)
            + " window=" + I2S(window) + " threshold=" + R2S(GetAttenuationBarrierThreshold(u))
            + " raw=" + R2S(GetAttenuationBarrierRaw(u)));
    }

    private function ResetSlot(integer slot) {
        windows[slot] = window;
        rawSums[slot] = 0.0;
        rawRoots[slot] = 0.0;
        sumErrors[slot] = 0.0;
    }

    // 新一条命/显式重置调用；重复登记或UI刷新不得调用本接口。
    public function ResetAttenuationBarrier(unit u) {
        integer slot = GetAttenuationBarrierSlot(u);
        if (slot == 0) { return; }
        ResetSlot(slot);
        if (debugEnabled) {
            DzWriteLog("[AttenuationBarrier] reset slot=" + I2S(slot) + " window=" + I2S(window));
        }
    }

    // 重复设置不会补充窗口额度。改阈值保留raw，后续增量按新阈值计算。
    // 只接受有效单位和正有限阈值；失败不改变已有实例。
    public function SetAttenuationBarrier(unit u, real threshold) -> boolean {
        integer slot;
        if (u == null || GetUnitTypeId(u) == 0 || !(threshold > 0.0) || threshold - threshold != 0.0) { return false; }
        slot = GetAttenuationBarrierSlot(u);
        if (slot == 0) {
            if (size >= 8190) { return false; }
            size += 1;
            slot = size;
            subjects[slot] = u;
            SaveInteger(HASH_UNIT, GetHandleId(u), KEY_UNIT_ATTENUATION_BARRIER, slot);
            ResetSlot(slot);
        }
        thresholds[slot] = threshold;
        thresholdRoots[slot] = SquareRoot(threshold);
        if (debugEnabled) {
            DzWriteLog("[AttenuationBarrier] set slot=" + I2S(slot) + " threshold=" + R2S(threshold));
        }
        return true;
    }

    public function RemoveAttenuationBarrier(unit u) {
        integer slot = GetAttenuationBarrierSlot(u);
        if (slot == 0) { return; }
        RemoveSavedInteger(HASH_UNIT, GetHandleId(u), KEY_UNIT_ATTENUATION_BARRIER);
        if (slot != size) {
            subjects[slot] = subjects[size];
            thresholds[slot] = thresholds[size];
            thresholdRoots[slot] = thresholdRoots[size];
            rawSums[slot] = rawSums[size];
            rawRoots[slot] = rawRoots[size];
            sumErrors[slot] = sumErrors[size];
            windows[slot] = windows[size];
            SaveInteger(HASH_UNIT, GetHandleId(subjects[slot]), KEY_UNIT_ATTENUATION_BARRIER, slot);
        }
        subjects[size] = null;
        thresholds[size] = 0.0;
        thresholdRoots[size] = 0.0;
        rawSums[size] = 0.0;
        rawRoots[size] = 0.0;
        sumErrors[size] = 0.0;
        windows[size] = 0;
        size -= 1;
        if (debugEnabled) {
            DzWriteLog("[AttenuationBarrier] remove slot=" + I2S(slot) + " count=" + I2S(size));
        }
    }

    // 返回本次增量并立即提交累计状态，后续嵌套伤害可见新状态。
    // 输入须为有限伤害，窗口内累计须在JASS real可表示范围内。
    public function ResolveAttenuationBarrier(unit u, real damage) -> real {
        integer slot;
        real oldSum;
        real nextSum;
        real adjusted;
        real nextRoot;
        real remaining;
        real result;
        if (!(damage > 0.0)) { return damage; }
        slot = GetAttenuationBarrierSlot(u);
        if (slot == 0) { return damage; }
        if (windows[slot] != window) { ResetSlot(slot); }
        oldSum = rawSums[slot];
        // Kahan累计：小段伤害不会一直因大累计值而丢失。
        adjusted = damage - sumErrors[slot];
        nextSum = oldSum + adjusted;
        sumErrors[slot] = (nextSum - oldSum) - adjusted;
        if (nextSum <= thresholds[slot]) {
            result = damage;
            nextRoot = 0.0; // 线性区不算平方根；首次跨阈值直接使用sqrt(T)。
        } else {
            nextRoot = SquareRoot(nextSum);
            if (oldSum < thresholds[slot]) {
                remaining = thresholds[slot] - oldSum;
                // 跨阈值：剩余额度 + 超出部分的有理化平方根差。
                result = remaining + ((damage - remaining) / (nextRoot + thresholdRoots[slot])) * thresholdRoots[slot];
            } else {
                if (rawRoots[slot] == 0.0) { rawRoots[slot] = SquareRoot(oldSum); }
                // sqrt(T)*(sqrt(S+d)-sqrt(S))，避免两个大数直接相减。
                result = (damage / (nextRoot + rawRoots[slot])) * thresholdRoots[slot];
            }
        }
        rawSums[slot] = nextSum;
        rawRoots[slot] = nextRoot;
        result = RMaxBJ(0.0, RMinBJ(damage, result)); // 不添加每段最小伤害。
        if (debugEnabled) {
            DzWriteLog("[AttenuationBarrier] hit slot=" + I2S(slot) + " window=" + I2S(window)
                + " threshold=" + R2S(thresholds[slot]) + " before=" + R2S(oldSum)
                + " input=" + R2S(damage) + " after=" + R2S(nextSum) + " output=" + R2S(result));
        }
        return result;
    }

    function onInit() {
        trigger deaths = CreateTrigger();
        clockTimer = CreateTimer();
        TimerStart(clockTimer, 0.5, true, function() { window += 1; });
        TriggerRegisterAnyUnitEventBJ(deaths, EVENT_PLAYER_UNIT_DEATH);
        TriggerAddAction(deaths, function() { ResetAttenuationBarrier(GetDyingUnit()); });
        deaths = null;
    }
}
//! endzinc
#endif
