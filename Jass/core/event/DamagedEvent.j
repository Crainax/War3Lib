#ifndef DamagedEventIncluded
#define DamagedEventIncluded

//! zinc
/*
受伤事件系统（Zinc 版本）
提供受伤事件注册和触发功能

本系统用于在单位**受到伤害时**进行监听和响应。

使用示例：
1. 注册受伤事件：
   // 方式1：为指定单位注册（只触发该单位作为受伤单位的事件）
   trigger damagedTrigger = CreateTrigger();
   TriggerAddCondition(damagedTrigger, Condition(function OnDamaged));
   RegisterDamagedEvent(damagedTrigger, myUnit);

   // 方式2：注册全局受伤事件（触发所有单位的受伤事件）
   trigger globalDamagedTrigger = CreateTrigger();
   TriggerAddCondition(globalDamagedTrigger, Condition(function OnGlobalDamaged));
   RegisterDamagedEvent(globalDamagedTrigger, null);

2. 在回调函数中使用：
   function OnDamaged() -> boolean {
       unit source = GetDamageSource();
       unit damaged = GetDamagedUnit();
       real dmg = GetDamageAmount();

       BJDebugMsg(GetUnitName(source) + " 对 " + GetUnitName(damaged) + " 造成了 " + R2S(dmg) + " 伤害");
       return false;
   }

3. 触发受伤事件：
   TriggerDamagedEvent(伤害来源, 受伤单位, 伤害值);
*/

#define MAX_DAMAGEDEVENT_SIZE 8190

library DamagedEvent {
    // ========== 变量声明 ==========
    private integer ISize = 0;             // 注册数量
    private trigger TData [];              // 触发器列表
    private unit UData [];                 // 单位列表（null表示全局，非 null 表示只监听该单位受伤）

    // ========== 回调参数 ==========
    private unit damageSource = null;      // 伤害来源（可能为 null，取决于调用方）
    private unit damagedUnit = null;       // 受伤单位
    private real damageAmount = 0.0;       // 伤害值

    // ========== 回调参数获取函数 ==========
    // 获取伤害来源（如攻击者、施法者等）
    public function GetDamageSource() -> unit {
        return damageSource;
    }

    // 获取受伤单位
    public function GetDamagedUnit() -> unit {
        return damagedUnit;
    }

    // 获取本次伤害量
    public function GetDamageAmount() -> real {
        return damageAmount;
    }

    // ========== 注册受伤事件 ==========
    // 参数：
    //   t - 触发器
    //   u - 单位（null 表示注册全局事件，非 null 表示只监听该单位受伤）
    public function RegisterDamagedEvent(trigger t, unit u) -> boolean {
        integer i;

        // 参数检查
        if (t == null) { return false; }

        // 容量检查
        if (ISize >= MAX_DAMAGEDEVENT_SIZE) { return false; }

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

    // ========== 注销受伤事件 ==========
    public function UnregisterDamagedEvent(trigger t) -> boolean {
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

    // ========== 触发受伤事件 ==========
    // 参数：
    //   source - 伤害来源（攻击者/施法者等，可以为 null）
    //   target - 受伤目标
    //   dmg - 伤害值（>0 有效）
    public function TriggerDamagedEvent(unit source, unit target, real dmg) {
        integer i;
        trigger t;
        unit registeredUnit;

        // 参数检查
        if (target == null || dmg <= 0.0) { return; }


        // 设置回调参数
        damageSource = source;
        damagedUnit = target;
        damageAmount = dmg;

        // 遍历所有注册的触发器
        for (i = 1; i <= ISize; i += 1) {
            t = TData[i];
            registeredUnit = UData[i];

            if (t != null && IsTriggerEnabled(t)) {
                // 检查单位匹配：
                // 1. registeredUnit == null 表示全局事件，总是触发
                // 2. registeredUnit == target 表示指定单位事件，只有受伤单位匹配才触发
                if (registeredUnit == null || registeredUnit == target) {
                    if (TriggerEvaluate(t)) {
                        TriggerExecute(t);
                    }
                }
            }
        }

        // 清理回调参数
        damageSource = null;
        damagedUnit = null;
        damageAmount = 0.0;
    }

}

#undef MAX_DAMAGEDEVENT_SIZE

//! endzinc
#endif
