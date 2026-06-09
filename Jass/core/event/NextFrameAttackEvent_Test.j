#ifndef UTNextFrameAttackEventIncluded
#define UTNextFrameAttackEventIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

library UTNextFrameAttackEvent requires NextFrameAttackEvent, UnitTestFramwork {
    private unit sourceA = null;
    private unit sourceB = null;
    private unit targetA = null;
    private trigger globalTrigger = null;
    private trigger sourceTrigger = null;
    private trigger removedTrigger = null;
    private integer globalCount = 0;
    private integer sourceCount = 0;
    private integer removedCount = 0;
    private real globalDamageSum = 0.0;
    private real sourceDamageSum = 0.0;
    private unit lastGlobalSource = null;
    private unit lastGlobalTarget = null;
    private unit lastSourceSource = null;
    private unit lastSourceTarget = null;

    private function CreateTestUnit(player p, integer unitId, real x, real y) -> unit {
        unit u;
        u = CreateUnit(p, unitId, x, y, 270.0);
        SetUnitInvulnerable(u, true);
        return u;
    }

    private function ResetCounters() {
        globalCount = 0;
        sourceCount = 0;
        removedCount = 0;
        globalDamageSum = 0.0;
        sourceDamageSum = 0.0;
        lastGlobalSource = null;
        lastGlobalTarget = null;
        lastSourceSource = null;
        lastSourceTarget = null;
    }

    private function OnGlobal() {
        globalCount += 1;
        globalDamageSum += GetNextFrameAttackDamage();
        lastGlobalSource = GetNextFrameAttackUnit();
        lastGlobalTarget = GetNextFrameAttackTargetUnit();
    }

    private function OnSource() {
        sourceCount += 1;
        sourceDamageSum += GetNextFrameAttackDamage();
        lastSourceSource = GetNextFrameAttackUnit();
        lastSourceTarget = GetNextFrameAttackTargetUnit();
    }

    private function OnRemoved() {
        removedCount += 1;
    }

    private function SetupTriggers() {
        sourceA = CreateTestUnit(Player(0), 'Hpal', 0.0, 0.0);
        sourceB = CreateTestUnit(Player(1), 'Hpal', 400.0, 0.0);
        targetA = CreateTestUnit(Player(10), 'hfoo', 120.0, 0.0);

        globalTrigger = CreateTrigger();
        TriggerAddAction(globalTrigger, function OnGlobal);
        assert.Boolean(RegisterNextFrameAttackEvent(globalTrigger, null), "全局下一帧攻击事件注册应成功");

        sourceTrigger = CreateTrigger();
        TriggerAddAction(sourceTrigger, function OnSource);
        assert.Boolean(RegisterNextFrameAttackEvent(sourceTrigger, sourceA), "单位下一帧攻击事件注册应成功");

        removedTrigger = CreateTrigger();
        TriggerAddAction(removedTrigger, function OnRemoved);
        assert.Boolean(RegisterNextFrameAttackEvent(removedTrigger, sourceA), "待注销下一帧攻击事件注册应成功");
        assert.Boolean(UnregisterNextFrameAttackEvent(removedTrigger), "注销下一帧攻击事件应成功");
        DestroyTrigger(removedTrigger);
        removedTrigger = null;

        assert.Integer(GetNextFrameAttackEventRegisterCount(), 2, "有效下一帧攻击事件注册数应为 2");
    }

    private function CleanupTriggers() {
        if (globalTrigger != null) {
            UnregisterNextFrameAttackEvent(globalTrigger);
            DestroyTrigger(globalTrigger);
            globalTrigger = null;
        }
        if (sourceTrigger != null) {
            UnregisterNextFrameAttackEvent(sourceTrigger);
            DestroyTrigger(sourceTrigger);
            sourceTrigger = null;
        }
        if (sourceA != null) {
            RemoveUnit(sourceA);
            sourceA = null;
        }
        if (sourceB != null) {
            RemoveUnit(sourceB);
            sourceB = null;
        }
        if (targetA != null) {
            RemoveUnit(targetA);
            targetA = null;
        }
    }

    private function Test_Single_Start() {
        ResetCounters();
        SetupTriggers();
        assert.Boolean(QueueNextFrameAttackEvent(sourceA, targetA, 123.0), "入队单条下一帧攻击事件应成功");
        assert.Integer(GetNextFrameAttackEventPendingCount(), 1, "入队后待处理数量应为 1");
        assert.Boolean(IsNextFrameAttackEventTimerAlive(), "入队后中央 timer 应存在");
        assert.Integer(globalCount, 0, "入队后不应同步触发全局回调");
        assert.Integer(sourceCount, 0, "入队后不应同步触发单位回调");
    }

    private function Test_Single_End() {
        assert.Integer(GetNextFrameAttackEventPendingCount(), 0, "下一帧处理后队列应清空");
        assert.Boolean(!IsNextFrameAttackEventTimerAlive(), "队列清空后中央 timer 应销毁");
        assert.Integer(globalCount, 1, "全局回调应触发 1 次");
        assert.Integer(sourceCount, 1, "匹配单位回调应触发 1 次");
        assert.Integer(removedCount, 0, "已注销回调不应触发");
        assert.Real(globalDamageSum, 123.0, "全局回调伤害上下文应正确");
        assert.Real(sourceDamageSum, 123.0, "单位回调伤害上下文应正确");
        assert.Boolean(lastGlobalSource == sourceA, "全局回调攻击者上下文应正确");
        assert.Boolean(lastGlobalTarget == targetA, "全局回调目标上下文应正确");
        assert.Boolean(lastSourceSource == sourceA, "单位回调攻击者上下文应正确");
        assert.Boolean(lastSourceTarget == targetA, "单位回调目标上下文应正确");
    }

    private function Test_Filter_Start() {
        ResetCounters();
        assert.Boolean(QueueNextFrameAttackEvent(sourceA, targetA, 10.0), "入队 sourceA 事件应成功");
        assert.Boolean(QueueNextFrameAttackEvent(sourceB, targetA, 20.0), "入队 sourceB 事件应成功");
        assert.Integer(GetNextFrameAttackEventPendingCount(), 2, "双事件入队后待处理数量应为 2");
        assert.Integer(globalCount, 0, "双事件入队后不应同步触发全局回调");
    }

    private function Test_Filter_End() {
        assert.Integer(globalCount, 2, "全局回调应接收两条事件");
        assert.Integer(sourceCount, 1, "单位回调只应接收 sourceA 事件");
        assert.Real(globalDamageSum, 30.0, "全局回调伤害合计应正确");
        assert.Real(sourceDamageSum, 10.0, "单位过滤后的伤害合计应正确");
        assert.Integer(GetNextFrameAttackEventPendingCount(), 0, "过滤测试后队列应清空");
        CleanupTriggers();
        assert.Integer(GetNextFrameAttackEventRegisterCount(), 0, "清理后注册数应为 0");
    }

    function Init() {
        UnitTestAutoTimer(0.20, 0.10, function() {
            Trace("NextFrameAttackEvent 单条入队测试");
            Test_Single_Start();
        }, null);

        UnitTestAutoTimer(0.40, 0.10, function() {
            Trace("NextFrameAttackEvent 单条分发测试");
            Test_Single_End();
        }, null);

        UnitTestAutoTimer(0.60, 0.10, function() {
            Trace("NextFrameAttackEvent 单位过滤入队测试");
            Test_Filter_Start();
        }, null);

        UnitTestAutoTimer(0.80, 0.10, function() {
            Trace("NextFrameAttackEvent 单位过滤分发测试");
            Test_Filter_End();
        }, null);
    }

    function onInit() {
        trigger tr;

        tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr, 0.5);
        TriggerAddCondition(tr, Condition(function () -> boolean {
            BJDebugMsg("[NextFrameAttackEvent] 单元测试已加载");
            Init();
            DestroyTrigger(GetTriggeringTrigger());
            return false;
        }));
        tr = null;
    }
}

//! endzinc

#endif
