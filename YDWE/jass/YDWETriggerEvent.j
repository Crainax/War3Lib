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
    #endif

    constant integer DAMAGE_EVENT_SWAP_TIMEOUT = 20;  // 每隔这个时间(秒), yd_DamageEventTrigger 会被移入销毁队列
    constant boolean DAMAGE_EVENT_SWAP_ENABLE = true;  // 若为 false 则不启用销毁机制
    trigger yd_DamageEventTriggerToDestory = null;

    trigger DamageEventQueue[];
    integer DamageEventNumber = 0;

    item bj_lastMovedItemInItemSlot = null;

    trigger MoveItemEventTrigger = null;
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
        boolean isEnabled;

        isEnabled = IsTriggerEnabled(yd_DamageEventTrigger);

        DisableTrigger(yd_DamageEventTrigger);
        if (yd_DamageEventTriggerToDestory != null) {
            DestroyTrigger(yd_DamageEventTriggerToDestory);
        }

        yd_DamageEventTriggerToDestory = yd_DamageEventTrigger;
        yd_DamageEventTrigger = CreateTrigger();
        if (!isEnabled) {
            DisableTrigger(yd_DamageEventTrigger);
        }

        TriggerAddAction(yd_DamageEventTrigger, function YDWEAnyUnitDamagedTriggerAction);
        YDWEAnyUnitDamagedEnumUnit();
    }

    public function YDWESyStemAnyUnitDamagedRegistTrigger(trigger trg) {
        if (trg == null) {
            return;
        }

        if (DamageEventNumber == 0) {
            yd_DamageEventTrigger = CreateTrigger();
            TriggerAddAction(yd_DamageEventTrigger, function YDWEAnyUnitDamagedTriggerAction);
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
            TriggerAddAction(MoveItemEventTrigger, function YDWESyStemItemUnmovableTriggerAction);
            TriggerRegisterAnyUnitEventBJ(MoveItemEventTrigger, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER);
        }

        MoveItemEventQueue[MoveItemEventNumber] = trg;
        MoveItemEventNumber = MoveItemEventNumber + 1;
    }

    public function GetLastMovedItemInItemSlot() -> item {
        return bj_lastMovedItemInItemSlot;
    }
}

//! endzinc
#endif /// YDWETriggerEventIncluded
