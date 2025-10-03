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

    // ========== 回调参数获取函数 ==========
    public function GetSpellAbilityIdEx() -> integer {
        return spellId;
    }

    public function GetSpellAbilityUnitEx() -> unit {
        return spellUnit;
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

    // ========== 触发施法事件（移植自 TSpellSystemActIndirect）==========
    public function TriggerSpellEvent(unit u, integer id) {
        integer i;
        trigger t;
        unit targetUnit;

        // 设置回调参数
        spellUnit = u;
        spellId = id;

        // 遍历触发所有注册的触发器
        for (i = 1; i <= ISize; i += 1) {
            t = TData[i];
            targetUnit = UData[i];

            // 检查触发器有效性和单位匹配
            if (t != null && IsTriggerEnabled(t) && targetUnit == u) {
                if (TriggerEvaluate(t)) {
                    TriggerExecute(t);
                }
            }
        }

        // 清理回调参数
        spellUnit = null;
        spellId = 0;
        targetUnit = null;
    }

}

#undef MAX_SPELLEVENT_SIZE

//! endzinc
#endif
