#ifndef AttackEventIncluded
#define AttackEventIncluded

//! zinc
/*
攻击事件系统（Zinc 版本）
提供攻击事件注册和触发功能

使用示例：
1. 注册攻击事件：
   // 方式1：为指定单位注册（只触发该单位作为攻击者的事件）
   trigger attackTrigger = CreateTrigger();
   TriggerAddCondition(attackTrigger, Condition(function OnAttack));
   RegisterAttackEvent(attackTrigger, myUnit);

   // 方式2：注册全局攻击事件（触发所有单位的攻击事件）
   trigger globalAttackTrigger = CreateTrigger();
   TriggerAddCondition(globalAttackTrigger, Condition(function OnGlobalAttack));
   RegisterAttackEvent(globalAttackTrigger, null);

2. 在回调函数中使用：
   function OnAttack() -> boolean {
       unit attacker = GetAttackUnit();
       unit target = GetAttackTargetUnit();
       real damage = GetAttackDamage();

       BJDebugMsg(GetUnitName(attacker) + " 攻击了 " + GetUnitName(target) + " 造成 " + R2S(damage) + " 伤害");
       return false;
   }

3. 触发攻击事件：
   TriggerAttackEvent(攻击者, 目标, 伤害值);
*/

#define MAX_ATTACKEVENT_SIZE 8190

library AttackEvent {
    // ========== 变量声明 ==========
    private integer ISize = 0;             // 注册数量
    private trigger TData [];              // 触发器列表
    private unit UData [];                 // 单位列表（null表示全局）

    // ========== 回调参数 ==========
    private unit attackUnit = null;        // 攻击单位
    private unit targetUnit = null;        // 被攻击单位
    private real damage = 0.0;             // 伤害值

    // ========== 回调参数获取函数 ==========
    public function GetAttackUnit() -> unit {
        return attackUnit;
    }

    public function GetAttackTargetUnit() -> unit {
        return targetUnit;
    }

    public function GetAttackDamage() -> real {
        return damage;
    }

    // ========== 注册攻击事件 ==========
    // 参数：
    //   t - 触发器
    //   u - 单位（null表示注册全局事件，非null表示只监听该单位的攻击）
    public function RegisterAttackEvent(trigger t, unit u) -> boolean {
        integer i;

        // 参数检查
        if (t == null) { return false; }

        // 容量检查
        if (ISize >= MAX_ATTACKEVENT_SIZE) { return false; }

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

    // ========== 注销攻击事件 ==========
    public function UnregisterAttackEvent(trigger t) -> boolean {
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

    // ========== 触发攻击事件 ==========
    // 参数：
    //   attacker - 攻击者
    //   target - 被攻击目标
    //   dmg - 伤害值
    public function TriggerAttackEvent(unit attacker, unit target, real dmg) {
        integer i;
        trigger t;
        unit registeredUnit;

        // 参数检查
        if (attacker == null || target == null || dmg <= 0.0) { return; }


        // 设置回调参数
        attackUnit = attacker;
        targetUnit = target;
        damage = dmg;

        // 遍历所有注册的触发器
        for (i = 1; i <= ISize; i += 1) {
            t = TData[i];
            registeredUnit = UData[i];

            if (t != null && IsTriggerEnabled(t)) {
                // 检查单位匹配：
                // 1. registeredUnit == null 表示全局事件，总是触发
                // 2. registeredUnit == attacker 表示指定单位事件，只有攻击者匹配才触发
                if (registeredUnit == null || registeredUnit == attacker) {
                    if (TriggerEvaluate(t)) {
                        TriggerExecute(t);
                    }
                }
            }
        }

        // 清理回调参数
        attackUnit = null;
        targetUnit = null;
        damage = 0.0;
    }

    // ========== 统计诊断函数 ==========
    public function DiagAttackEvent() {
        integer i;
        integer nonNull;
        integer enabled;
        integer globalCount;
        integer unitCount;

        // 统计触发器状态
        nonNull = 0;
        enabled = 0;
        globalCount = 0;
        unitCount = 0;

        for (i = 1; i <= ISize; i += 1) {
            if (TData[i] != null) {
                nonNull = nonNull + 1;
                if (IsTriggerEnabled(TData[i])) {
                    enabled = enabled + 1;
                }
                // 统计全局事件和单位事件数量
                if (UData[i] == null) {
                    globalCount = globalCount + 1;
                } else {
                    unitCount = unitCount + 1;
                }
            }
        }

        // 输出诊断信息
        BJDebugMsg("[AttackEvent] diag: ISize=" + I2S(ISize) + ", nonNull=" + I2S(nonNull) + ", enabled=" + I2S(enabled));
        BJDebugMsg("[AttackEvent] diag: globalEvents=" + I2S(globalCount) + ", unitEvents=" + I2S(unitCount));
    }

}

#undef MAX_ATTACKEVENT_SIZE

//! endzinc
#endif
