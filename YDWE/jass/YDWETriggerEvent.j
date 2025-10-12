#ifndef YDWETriggerEventIncluded
#define YDWETriggerEventIncluded

//===========================================================================
//===========================================================================
//自定义事件
//===========================================================================
//===========================================================================

//! zinc
library YDWETriggerEvent {

#ifndef YDWE_DamageEventTrigger
#define YDWE_DamageEventTrigger
    trigger yd_DamageEventTrigger = null;
    triggeraction yd_DamageEventTriggerAction = null;
#endif

    constant integer DAMAGE_EVENT_SWAP_TIMEOUT = 20;  // 每隔这个时间(秒), yd_DamageEventTrigger 会被移入销毁队列
    constant boolean DAMAGE_EVENT_SWAP_ENABLE = true;  // 若为 false 则不启用销毁机制
    trigger yd_DamageEventTriggerToDestory = null;
    triggeraction yd_DamageEventTriggerActionToDestory = null;

    trigger DamageEventQueue[];
    integer DamageEventNumber = 0;

    item bj_lastMovedItemInItemSlot = null;

    trigger MoveItemEventTrigger = null;
    triggeraction MoveItemEventTriggerAction = null;
    trigger MoveItemEventQueue[];
    integer MoveItemEventNumber = 0;

//===========================================================================
//任意单位伤害事件
//===========================================================================
    function YDWEAnyUnitDamagedTriggerAction() {
        integer i;

        i = 0;

        while (i < DamageEventNumber) {
            if (DamageEventQueue[i] != null && IsTriggerEnabled(DamageEventQueue[i]) && TriggerEvaluate(DamageEventQueue[i])) {
                TriggerExecute(DamageEventQueue[i]);
            }
            i = i + 1;
        }
    }

    function YDWEAnyUnitDamagedFilter() -> boolean {
        if (GetUnitAbilityLevel(GetFilterUnit(), 'Aloc') <= 0) {
            TriggerRegisterUnitEvent(yd_DamageEventTrigger, GetFilterUnit(), EVENT_UNIT_DAMAGED);
        }
        return false;
    }

    function YDWEAnyUnitDamagedEnumUnit() {
        group g;
        integer i;

        g = CreateGroup();
        i = 0;

        while (i < bj_MAX_PLAYER_SLOTS) {
            GroupEnumUnitsOfPlayer(g, Player(i), Condition(function YDWEAnyUnitDamagedFilter));
            i = i + 1;
        }
        DestroyGroup(g);
        g = null;
    }

    function YDWEAnyUnitDamagedRegistTriggerUnitEnter() {
        trigger t;
        region r;
        rect world;

        t = CreateTrigger();
        r = CreateRegion();
        world = GetWorldBounds();
        RegionAddRect(r, world);
        TriggerRegisterEnterRegion(t, r, Condition(function YDWEAnyUnitDamagedFilter));
        RemoveRect(world);
        t = null;
        r = null;
        world = null;
    }

// 将 yd_DamageEventTrigger 移入销毁队列, 从而排泄触发器事件
    public function YDWESyStemAnyUnitDamagedSwap() {
        DisableTrigger(yd_DamageEventTrigger);
        if (yd_DamageEventTriggerToDestory != null) {
            // 先移除旧的 action 防止泄露
            if (yd_DamageEventTriggerActionToDestory != null) {
                TriggerRemoveAction(yd_DamageEventTriggerToDestory, yd_DamageEventTriggerActionToDestory);
                yd_DamageEventTriggerActionToDestory = null;
            }
            DestroyTrigger(yd_DamageEventTriggerToDestory);
        }

        yd_DamageEventTriggerToDestory = yd_DamageEventTrigger;
        yd_DamageEventTriggerActionToDestory = yd_DamageEventTriggerAction;
        yd_DamageEventTrigger = CreateTrigger();

        // 始终启用新主触发器（不继承禁用状态）
        EnableTrigger(yd_DamageEventTrigger);

        yd_DamageEventTriggerAction = TriggerAddAction(yd_DamageEventTrigger, function YDWEAnyUnitDamagedTriggerAction);
        YDWEAnyUnitDamagedEnumUnit();
    }

    public function YDWESyStemAnyUnitDamagedRegistTrigger(trigger trg) {
        if (trg == null) {
            return;
        }

        if (DamageEventNumber == 0) {
            yd_DamageEventTrigger = CreateTrigger();
            yd_DamageEventTriggerAction = TriggerAddAction(yd_DamageEventTrigger, function YDWEAnyUnitDamagedTriggerAction);
            YDWEAnyUnitDamagedEnumUnit();
            YDWEAnyUnitDamagedRegistTriggerUnitEnter();
            if (DAMAGE_EVENT_SWAP_ENABLE) {
            // 每隔 DAMAGE_EVENT_SWAP_TIMEOUT 秒, 将正在使用的 yd_DamageEventTrigger 移入销毁队列
                TimerStart(CreateTimer(), DAMAGE_EVENT_SWAP_TIMEOUT, true, function YDWESyStemAnyUnitDamagedSwap);
            }
        }

        DamageEventQueue[DamageEventNumber] = trg;
        DamageEventNumber = DamageEventNumber + 1;
    }

//===========================================================================
//移动物品事件
//===========================================================================
    function YDWESyStemItemUnmovableTriggerAction() {
        integer i;

        i = 0;

        if (GetIssuedOrderId() >= 852002 && GetIssuedOrderId() <= 852007) {
            bj_lastMovedItemInItemSlot = GetOrderTargetItem();
            while (i < MoveItemEventNumber) {
                if (MoveItemEventQueue[i] != null && IsTriggerEnabled(MoveItemEventQueue[i]) && TriggerEvaluate(MoveItemEventQueue[i])) {
                    TriggerExecute(MoveItemEventQueue[i]);
                }
                i = i + 1;
            }
        }
    }

    public function YDWESyStemItemUnmovableRegistTrigger(trigger trg) {
        if (trg == null) {
            return;
        }

        if (MoveItemEventNumber == 0) {
            MoveItemEventTrigger = CreateTrigger();
            MoveItemEventTriggerAction = TriggerAddAction(MoveItemEventTrigger, function YDWESyStemItemUnmovableTriggerAction);
            TriggerRegisterAnyUnitEventBJ(MoveItemEventTrigger, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER);
        }

        MoveItemEventQueue[MoveItemEventNumber] = trg;
        MoveItemEventNumber = MoveItemEventNumber + 1;
    }

    public function GetLastMovedItemInItemSlot() -> item {
        return bj_lastMovedItemInItemSlot;
    }

    //===========================================================================
    // 诊断函数：带日志的伤害事件重建
    //===========================================================================
    private integer diagRegCount = 0;
    private integer diagSkipCount = 0;

    private function YDWEAnyUnitDamagedFilterWithLog() -> boolean {
        unit u = GetFilterUnit();
        integer utypeId = GetUnitTypeId(u);
        player owner = GetOwningPlayer(u);
        boolean hasAloc = GetUnitAbilityLevel(u, 'Aloc') > 0;

        if (!hasAloc) {
            TriggerRegisterUnitEvent(yd_DamageEventTrigger, u, EVENT_UNIT_DAMAGED);
            diagRegCount = diagRegCount + 1;
            // 仅打印前 50 个注册以避免日志爆炸
            if (diagRegCount <= 50) {
                DzWriteLog("  [YDWE] Registered unit: handle=" + I2S(GetHandleId(u)) + ", type=" + YDWEId2S(utypeId) + ", player=" + I2S(GetPlayerId(owner)) + ", Aloc=false");
            }
        } else {
            diagSkipCount = diagSkipCount + 1;
            if (diagSkipCount <= 50) {
                DzWriteLog("  [YDWE] Skipped unit (Aloc): handle=" + I2S(GetHandleId(u)) + ", type=" + YDWEId2S(utypeId) + ", player=" + I2S(GetPlayerId(owner)));
            }
        }
        return false;
    }

    private function YDWEAnyUnitDamagedEnumUnitWithLog() {
        group g;
        integer i;

        g = CreateGroup();
        i = 0;
        diagRegCount = 0;
        diagSkipCount = 0;

        DzWriteLog("[YDWE] Enumerating all units for damage event registration...");
        while (i < bj_MAX_PLAYER_SLOTS) {
            GroupEnumUnitsOfPlayer(g, Player(i), Condition(function YDWEAnyUnitDamagedFilterWithLog));
            i = i + 1;
        }
        DzWriteLog("[YDWE] Enumeration complete: registered=" + I2S(diagRegCount) + ", skipped(Aloc)=" + I2S(diagSkipCount));
        DestroyGroup(g);
        g = null;
    }

    // 带日志的 swap，用于诊断时强制重建并输出详细信息
    public function YDWESyStemAnyUnitDamagedSwapWithLog() {
        DzWriteLog("[YDWE] Starting damage event swap with logging...");
        DzWriteLog("[YDWE] Old trigger: handle=" + I2S(GetHandleId(yd_DamageEventTrigger)) + ", enabled=" + S3(IsTriggerEnabled(yd_DamageEventTrigger), "true", "false"));

        DisableTrigger(yd_DamageEventTrigger);
        if (yd_DamageEventTriggerToDestory != null) {
            DzWriteLog("[YDWE] Destroying previous queued trigger: handle=" + I2S(GetHandleId(yd_DamageEventTriggerToDestory)));
            // 先移除旧的 action 防止泄露
            if (yd_DamageEventTriggerActionToDestory != null) {
                TriggerRemoveAction(yd_DamageEventTriggerToDestory, yd_DamageEventTriggerActionToDestory);
                yd_DamageEventTriggerActionToDestory = null;
            }
            DestroyTrigger(yd_DamageEventTriggerToDestory);
        }

        yd_DamageEventTriggerToDestory = yd_DamageEventTrigger;
        yd_DamageEventTriggerActionToDestory = yd_DamageEventTriggerAction;
        yd_DamageEventTrigger = CreateTrigger();
        DzWriteLog("[YDWE] New trigger created: handle=" + I2S(GetHandleId(yd_DamageEventTrigger)));

        // 始终启用新主触发器（不继承禁用状态）
        EnableTrigger(yd_DamageEventTrigger);
        DzWriteLog("[YDWE] New trigger forced enabled");

        // 先移除旧触发器的 action（如果存在）
        if (yd_DamageEventTriggerActionToDestory != null) {
            TriggerRemoveAction(yd_DamageEventTriggerToDestory, yd_DamageEventTriggerActionToDestory);
            DzWriteLog("[YDWE] Removed old trigger action to prevent leak");
        }

        yd_DamageEventTriggerAction = TriggerAddAction(yd_DamageEventTrigger, function YDWEAnyUnitDamagedTriggerAction);
        YDWEAnyUnitDamagedEnumUnitWithLog();
        DzWriteLog("[YDWE] Swap complete");
    }

    // 打印伤害事件队列概览
    public function YDWE_DamageEventQueueDiag() {
        integer i = 0;
        integer active = 0;
        DzWriteLog("[YDWE] Damage event queue diagnostic:");
        DzWriteLog("  Total registered triggers: " + I2S(DamageEventNumber));
        while (i < DamageEventNumber) {
            if (DamageEventQueue[i] != null && IsTriggerEnabled(DamageEventQueue[i])) {
                active = active + 1;
            }
            i = i + 1;
        }
        DzWriteLog("  Active triggers: " + I2S(active));
        DzWriteLog("  Main trigger: handle=" + I2S(GetHandleId(yd_DamageEventTrigger)) + ", enabled=" + S3(IsTriggerEnabled(yd_DamageEventTrigger), "true", "false"));
    }

    #if (CURRENT_BUILD_VERSION != VERSION_RELEASE)
    // 测试辅助：显式禁用/启用 YDWE 主伤害触发器
    public function YDWE_TestDisableDamageMain() {
        if (yd_DamageEventTrigger != null) {
            DisableTrigger(yd_DamageEventTrigger);
            DzWriteLog("[YDWE][TEST] Disabled main damage trigger");
        } else {
            DzWriteLog("[YDWE][TEST] Main damage trigger is null");
        }
    }

    public function YDWE_TestEnableDamageMain() {
        if (yd_DamageEventTrigger != null) {
            EnableTrigger(yd_DamageEventTrigger);
            DzWriteLog("[YDWE][TEST] Enabled main damage trigger");
        } else {
            DzWriteLog("[YDWE][TEST] Main damage trigger is null");
        }
    }

    public function YDWE_TestPrintMainState() {
        DzWriteLog("[YDWE][TEST] Main trigger: handle=" + I2S(GetHandleId(yd_DamageEventTrigger)) + ", enabled=" + S3(IsTriggerEnabled(yd_DamageEventTrigger), "true", "false"));
    }
    #endif

    // 外部 watchdog 调用：检查并自动修复主触发器禁用状态
    public function YDWE_CheckAndFixMainTrigger() -> boolean {
        if (yd_DamageEventTrigger != null && !IsTriggerEnabled(yd_DamageEventTrigger)) {
            EnableTrigger(yd_DamageEventTrigger);
            DzWriteLog("[YDWE][WATCHDOG] Main damage trigger was disabled -> auto-enabled");
            return true; // 表示进行了修复
        }
        return false; // 表示无需修复
    }
}

//! endzinc
#endif /// YDWETriggerEventIncluded
