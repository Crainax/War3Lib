#ifndef SpellEventIncluded
#define SpellEventIncluded

//! zinc
/*
施法事件系统（Zinc 版本）
基于 SpellSystem.j 改写，使用 Zinc 语法
*/

#define MAX_SPELLEVENT_SIZE 8190

library SpellEvent {
    // ========== 变量声明 ==========
    private integer ISize = 0;
    private trigger TData [];
    private unit UData [];

    // ========== 回调参数（移植自 SpellSystem）==========
    private unit spellUnit = null;
    private integer spellId = 0;
    private integer contextSize = 0;
    private unit contextUnit [];
    private integer contextId [];
    private boolean contextIsMultiSpell [];
    private boolean contextIsFake [];
    private integer contextManaCost [];

    // ========== 回调参数获取函数 ==========
    public function GetSpellAbilityIdEx() -> integer {
        return spellId;
    }

    public function GetSpellAbilityUnitEx() -> unit {
        return spellUnit;
    }

    public function PushSpellEventContext(unit u, integer id, boolean isMultiSpell, boolean isFake, integer manaCost) -> boolean {
        if (contextSize >= MAX_SPELLEVENT_SIZE) {
            return false;
        }

        contextSize += 1;
        contextUnit[contextSize] = u;
        contextId[contextSize] = id;
        contextIsMultiSpell[contextSize] = isMultiSpell;
        contextIsFake[contextSize] = isFake;
        contextManaCost[contextSize] = manaCost;
        return true;
    }

    public function PopSpellEventContext() -> boolean {
        if (contextSize <= 0) {
            return false;
        }

        contextUnit[contextSize] = null;
        contextId[contextSize] = 0;
        contextIsMultiSpell[contextSize] = false;
        contextIsFake[contextSize] = false;
        contextManaCost[contextSize] = 0;
        contextSize -= 1;
        return true;
    }

    public function GetSpellEventCaster() -> unit {
        if (contextSize > 0) {
            return contextUnit[contextSize];
        }
        return spellUnit;
    }

    public function GetSpellEventAbilityId() -> integer {
        if (contextSize > 0) {
            return contextId[contextSize];
        }
        return spellId;
    }

    public function GetSpellEventIsMultiSpell() -> boolean {
        if (contextSize > 0) {
            return contextIsMultiSpell[contextSize];
        }
        return false;
    }

    public function GetSpellEventIsFake() -> boolean {
        if (contextSize > 0) {
            return contextIsFake[contextSize];
        }
        return false;
    }

    public function GetSpellEventManaCost() -> integer {
        if (contextSize > 0) {
            return contextManaCost[contextSize];
        }
        return 0;
    }

    // ========== 添加触发器（防重复） ==========
    public function RegisterSpellEvent(trigger t, unit u) -> boolean {
        integer i;

        // 参数检查
        if (t == null) { return false; }

        // 容量检查
        if (ISize >= MAX_SPELLEVENT_SIZE) { return false; }

        // 防重复检查
        for (i = 1; i <= ISize; i += 1) {
            if (TData[i] == t) { return false; }
        }

        // 添加触发器
        ISize += 1;
        TData[ISize] = t;
        UData[ISize] = u;
        return true;
    }

    // ========== 删除触发器 ==========
    public function UnregisterSpellEvent(trigger t) -> boolean {
        integer i;

        // 参数检查
        if (t == null) { return false; }

        // 查找并删除
        for (i = 1; i <= ISize; i += 1) {
            if (TData[i] == t) {
                // 尾部交换法删除
                TData[i] = TData[ISize];
                UData[i] = UData[ISize];
                TData[ISize] = null;
                UData[ISize] = null;
                ISize -= 1;
                return true;
            }
        }
        return false;
    }

    public function TriggerCurrentSpellEvent() {
        integer i;
        trigger t;
        unit targetUnit;
        unit oldSpellUnit = spellUnit;
        integer oldSpellId = spellId;

        if (contextSize <= 0) {
            oldSpellUnit = null;
            return;
        }

        // 设置回调参数
        spellUnit = contextUnit[contextSize];
        spellId = contextId[contextSize];

        // 遍历触发所有注册的触发器
        for (i = 1; i <= ISize; i += 1) {
            t = TData[i];
            targetUnit = UData[i];

            // 检查触发器有效性和单位匹配
            if (t != null && IsTriggerEnabled(t) && targetUnit == spellUnit) {
                if (TriggerEvaluate(t)) {
                    TriggerExecute(t);
                }
            }
        }

        // 恢复外层回调参数，支持事件内递归触发施法事件。
        spellUnit = oldSpellUnit;
        spellId = oldSpellId;
        t = null;
        targetUnit = null;
        oldSpellUnit = null;
    }

    // ========== 触发施法事件（移植自 TSpellSystemActIndirect）==========
    public function TriggerSpellEventEx(unit u, integer id, boolean isFake, integer manaCost) {
        if (PushSpellEventContext(u, id, false, isFake, manaCost)) {
            TriggerCurrentSpellEvent();
            PopSpellEventContext();
        }
    }

    public function TriggerSpellEvent(unit u, integer id) {
        TriggerSpellEventEx(u, id, false, 0);
    }

}

#undef MAX_SPELLEVENT_SIZE

//! endzinc
#endif
