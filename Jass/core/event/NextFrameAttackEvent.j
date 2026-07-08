#ifndef NextFrameAttackEventIncluded
#define NextFrameAttackEventIncluded

//! zinc
/*
下一帧攻击事件系统
用于把攻击结算后的后处理逻辑从当前伤害事件调用栈拆离。
*/

#define NEXT_FRAME_ATTACK_EVENT_TICK 0.01
#define MAX_NEXT_FRAME_ATTACK_EVENT_SIZE 8190
#define MAX_NEXT_FRAME_ATTACK_QUEUE_SIZE 8190

library NextFrameAttackEvent requires Logger {
    private integer registerSize = 0;
    private trigger triggerList[];
    private unit unitList[];

    private unit attackUnit = null;
    private unit targetUnit = null;
    private real damage = 0.0;

    public function GetNextFrameAttackUnit() -> unit {
        return attackUnit;
    }

    public function GetNextFrameAttackTargetUnit() -> unit {
        return targetUnit;
    }

    public function GetNextFrameAttackDamage() -> real {
        return damage;
    }

    private function DispatchNextFrameAttackEvent(unit attacker, unit target, real dmg) {
        integer i;
        trigger t;
        unit registeredUnit;

        if (attacker == null || target == null || dmg <= 0.0) { return; }

        attackUnit = attacker;
        targetUnit = target;
        damage = dmg;

        for (i = 1; i <= registerSize; i += 1) {
            t = triggerList[i];
            registeredUnit = unitList[i];
            if (t != null && IsTriggerEnabled(t)) {
                if (registeredUnit == null || registeredUnit == attacker) {
                    if (TriggerEvaluate(t)) {
                        TriggerExecute(t);
                    }
                }
            }
        }

        attackUnit = null;
        targetUnit = null;
        damage = 0.0;
        t = null;
        registeredUnit = null;
    }

    private struct NextFrameAttackQueue [] {
        private static unit sourceList[];
        private static unit targetList[];
        private static real damageList[];
        private static unit processSourceList[];
        private static unit processTargetList[];
        private static real processDamageList[];
        private static integer size = 0;
        private static timer supervisor = null;

        private static method clearSlot(integer index) {
            thistype.sourceList[index] = null;
            thistype.targetList[index] = null;
            thistype.damageList[index] = 0.0;
        }

        private static method removeAt(integer index) {
            integer last;

            last = thistype.size - 1;
            if (index < 0 || index > last) { return; }

            if (index != last) {
                thistype.sourceList[index] = thistype.sourceList[last];
                thistype.targetList[index] = thistype.targetList[last];
                thistype.damageList[index] = thistype.damageList[last];
            }

            thistype.clearSlot(last);
            thistype.size -= 1;
        }

        private static method stopTimerIfEmpty() {
            if (thistype.size <= 0 && thistype.supervisor != null) {
                PauseTimer(thistype.supervisor);
                DestroyTimer(thistype.supervisor);
                thistype.supervisor = null;
            }
        }

        private static method onTick() {
            integer i;
            integer processSize;
            unit source;
            unit target;
            real dmg;

            processSize = thistype.size;
            i = 0;
            while (i < processSize) {
                thistype.processSourceList[i] = thistype.sourceList[i];
                thistype.processTargetList[i] = thistype.targetList[i];
                thistype.processDamageList[i] = thistype.damageList[i];
                thistype.clearSlot(i);
                i += 1;
            }
            thistype.size = 0;

            i = 0;
            while (i < processSize) {
                source = thistype.processSourceList[i];
                target = thistype.processTargetList[i];
                dmg = thistype.processDamageList[i];
                thistype.processSourceList[i] = null;
                thistype.processTargetList[i] = null;
                thistype.processDamageList[i] = 0.0;

                if (source != null && target != null && dmg > 0.0) {
                    DispatchNextFrameAttackEvent(source, target, dmg);
                }
                i += 1;
            }

            thistype.stopTimerIfEmpty();
            source = null;
            target = null;
        }

        private static method ensureTimer() {
            if (thistype.supervisor == null) {
                thistype.supervisor = CreateTimer();
                TimerStart(thistype.supervisor, NEXT_FRAME_ATTACK_EVENT_TICK, true, function thistype.onTick);
            }
        }

        static method push(unit source, unit target, real dmg) -> boolean {
            integer index;

            if (source == null || target == null || dmg <= 0.0) { return false; }
            if (thistype.size >= MAX_NEXT_FRAME_ATTACK_QUEUE_SIZE) {
                BJDebugMsg("|cFFFF0000[NextFrameAttackEvent]|r queue is full: " + I2S(thistype.size));
                return false;
            }

            index = thistype.size;
            thistype.sourceList[index] = source;
            thistype.targetList[index] = target;
            thistype.damageList[index] = dmg;
            thistype.size += 1;
            thistype.ensureTimer();
            return true;
        }

        static method pendingCount() -> integer {
            return thistype.size;
        }

        static method timerAlive() -> boolean {
            return thistype.supervisor != null;
        }
    }

    public function RegisterNextFrameAttackEvent(trigger t, unit u) -> boolean {
        integer i;

        if (t == null) { return false; }
        if (registerSize >= MAX_NEXT_FRAME_ATTACK_EVENT_SIZE) { return false; }

        for (i = 1; i <= registerSize; i += 1) {
            if (triggerList[i] == t) { return false; }
        }

        registerSize += 1;
        triggerList[registerSize] = t;
        unitList[registerSize] = u;
        return true;
    }

    public function UnregisterNextFrameAttackEvent(trigger t) -> boolean {
        integer i;

        if (t == null) { return false; }

        for (i = 1; i <= registerSize; i += 1) {
            if (triggerList[i] == t) {
                triggerList[i] = triggerList[registerSize];
                unitList[i] = unitList[registerSize];
                triggerList[registerSize] = null;
                unitList[registerSize] = null;
                registerSize -= 1;
                return true;
            }
        }
        return false;
    }

    public function QueueNextFrameAttackEvent(unit attacker, unit target, real dmg) -> boolean {
        return NextFrameAttackQueue.push(attacker, target, dmg);
    }

    public function DiagNextFrameAttackEvent() {
        DzWriteLog("[NextFrameAttackEvent] diag: registerSize=" + I2S(registerSize) + ", pending=" + I2S(NextFrameAttackQueue.pendingCount()));
    }

    #if (CURRENT_BUILD_VERSION != VERSION_RELEASE)
    public function GetNextFrameAttackEventRegisterCount() -> integer {
        return registerSize;
    }

    public function GetNextFrameAttackEventPendingCount() -> integer {
        return NextFrameAttackQueue.pendingCount();
    }

    public function IsNextFrameAttackEventTimerAlive() -> boolean {
        return NextFrameAttackQueue.timerAlive();
    }
    #endif
}

#undef NEXT_FRAME_ATTACK_EVENT_TICK
#undef MAX_NEXT_FRAME_ATTACK_EVENT_SIZE
#undef MAX_NEXT_FRAME_ATTACK_QUEUE_SIZE

//! endzinc

#endif
