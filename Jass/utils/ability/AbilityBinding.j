#ifndef AbilityBindingIncluded
#define AbilityBindingIncluded
#include "Crainax/core/table/Hash_AbilityDefine.j"

#define ABILITY_BINDING_STATE_MAX 1023
#define ABILITY_BINDING_NATIVE_PLAYERS 16

//! zinc
// 逻辑技能和面板按钮分离。默认实例沿用玩家索引，绑定实例使用独立状态索引。
// 句柄元数据不能放 HASH_TIMER/HASH_TRIGGER：业务回调会先 flush 再销毁句柄。
library AbilityBinding requires HashTable {
    public type abilityBindingAction extends function() -> nothing;
    public type abilityBindingCondition extends function() -> boolean;
    private hashtable handles = InitHashtable();
    private integer source[];
    private integer button[];
    private unit owner[];
    private integer refs[];
    private boolean active[];
    private integer freeNext[];
    private integer freeHead = 0;
    private integer allocated = ABILITY_BINDING_NATIVE_PLAYERS;
    private integer contextSize = 0;
    private trigger callbackTrigger = null;
    public function GetBoundSpellTrigger() -> trigger { return callbackTrigger; }
    private integer contextState[];
    private integer contextSource[];
    private integer contextButton[];
    private unit contextUnit[];

    public function GetAbilityBindingHighIndex() -> integer { return allocated; }
    public function GetCurrentAbilityBindingState() -> integer { return contextState[contextSize]; }
    public function GetCurrentAbilityBindingSource() -> integer { return contextSource[contextSize]; }
    public function RetainAbilityBindingState(integer state) {
        if (state > ABILITY_BINDING_NATIVE_PLAYERS) { refs[state] += 1; }
    }

    public function AbilityBindingPlayerIndex(integer state) -> integer {
        if (state <= ABILITY_BINDING_NATIVE_PLAYERS) { return state; }
        if (owner[state] == null) { return 0; }
        return GetPlayerId(GetOwningPlayer(owner[state])) + 1;
    }

    public function GetAbilityBindingState(unit u, integer bindID) -> integer {
        return LoadInteger(HASH_ABILITY, GetAbilityHashKey(u, bindID), HASH_CHILD_SALT_BINDING_STATE);
    }

    public function GetAbilityBindingSource(unit u, integer bindID) -> integer {
        integer state = GetAbilityBindingState(u, bindID);
        if (state > ABILITY_BINDING_NATIVE_PLAYERS && active[state]) { return source[state]; }
        return bindID;
    }

    public function GetAbilityBindingButton(integer state, integer defaultID) -> integer {
        if (state > ABILITY_BINDING_NATIVE_PLAYERS) { return button[state]; }
        return defaultID;
    }

    public function IsAbilityBindingActive(integer state) -> boolean {
        return state <= ABILITY_BINDING_NATIVE_PLAYERS || active[state];
    }

    public function IsAbilityBindingOf(integer state, unit u, integer sourceID) -> boolean {
        return state > ABILITY_BINDING_NATIVE_PLAYERS && active[state] && owner[state] == u && source[state] == sourceID;
    }

    private function Release(integer state) {
        if (state <= ABILITY_BINDING_NATIVE_PLAYERS) { return; }
        refs[state] -= 1;
        if (refs[state] == 0) {
            source[state] = 0;
            button[state] = 0;
            owner[state] = null;
            freeNext[state] = freeHead;
            freeHead = state;
        }
    }

    public function ReleaseAbilityBindingState(integer state) { Release(state); }

    public function CreateAbilityBinding(unit u, integer sourceID, integer bindID) -> integer {
        integer state;
        integer key;
        if (u == null || sourceID == 0 || bindID == 0 || sourceID == bindID) { return 0; }
        key = GetAbilityHashKey(u, bindID);
        state = GetAbilityBindingState(u, bindID);
        if (state != 0) { return state; }
        if (freeHead != 0) {
            state = freeHead;
            freeHead = freeNext[state];
        } else {
            if (allocated >= ABILITY_BINDING_STATE_MAX) { return 0; }
            allocated += 1;
            state = allocated;
        }
        source[state] = sourceID;
        button[state] = bindID;
        owner[state] = u;
        refs[state] = 1;
        active[state] = true;
        SaveInteger(HASH_ABILITY, key, HASH_CHILD_SALT_BINDING_STATE, state);
        return state;
    }

    // 必须先销毁被动效果，再释放绑定；在途回调引用归零前不会复用状态索引。
    public function DestroyAbilityBinding(unit u, integer bindID) {
        integer state = GetAbilityBindingState(u, bindID);
        if (state <= ABILITY_BINDING_NATIVE_PLAYERS) { return; }
        RemoveSavedInteger(HASH_ABILITY, GetAbilityHashKey(u, bindID), HASH_CHILD_SALT_BINDING_STATE);
        active[state] = false;
        Release(state);
    }

    public function PushAbilityBindingState(unit u, integer sourceID, integer state) {
        contextSize += 1;
        contextUnit[contextSize] = u;
        contextSource[contextSize] = sourceID;
        contextState[contextSize] = state;
        contextButton[contextSize] = GetAbilityBindingButton(state, sourceID);
        if (state > ABILITY_BINDING_NATIVE_PLAYERS) { refs[state] += 1; }
    }

    public function PushAbilityBinding(unit u, integer sourceID, integer bindID) {
        integer state = GetAbilityBindingState(u, bindID);
        if (state == 0) { state = GetPlayerId(GetOwningPlayer(u)) + 1; }
        PushAbilityBindingState(u, sourceID, state);
    }

    public function PopAbilityBinding() {
        if (contextSize == 0) { return; }
        Release(contextState[contextSize]);
        contextUnit[contextSize] = null;
        contextSource[contextSize] = 0;
        contextButton[contextSize] = 0;
        contextState[contextSize] = 0;
        contextSize -= 1;
    }

    public function ResolveAbilityBinding(unit u, integer sourceID) -> integer {
        if (contextSize > 0 && contextUnit[contextSize] == u && contextSource[contextSize] == sourceID) {
            if (!IsAbilityBindingActive(contextState[contextSize])) { return 0; }
            return contextButton[contextSize];
        }
        return sourceID;
    }

    public function GetBoundAbilityLevel(unit u, integer sourceID) -> integer {
        if (contextSize > 0 && contextUnit[contextSize] == u && contextSource[contextSize] == sourceID
            && !IsAbilityBindingActive(contextState[contextSize])) { return 0; }
        return GetUnitAbilityLevel(u, ResolveAbilityBinding(u, sourceID));
    }

    public function GetBoundPlayerIndex(player p, integer sourceID) -> integer {
        if (contextSize > 0 && contextSource[contextSize] == sourceID && contextUnit[contextSize] != null
            && GetOwningPlayer(contextUnit[contextSize]) == p) {
            return contextState[contextSize];
        }
        return GetPlayerId(p) + 1;
    }

    private function Capture(integer handleID) {
        integer state;
        if (contextSize == 0) { return; }
        state = contextState[contextSize];
        SaveInteger(handles, handleID, 1, state);
        SaveInteger(handles, handleID, 2, contextSource[contextSize]);
        SaveUnitHandle(handles, handleID, 3, contextUnit[contextSize]);
        if (state > ABILITY_BINDING_NATIVE_PLAYERS) { refs[state] += 1; }
    }

    private function Enter(integer handleID) {
        PushAbilityBindingState(LoadUnitHandle(handles, handleID, 3),
            LoadInteger(handles, handleID, 2), LoadInteger(handles, handleID, 1));
    }

    private function Forget(integer handleID) {
        integer state = LoadInteger(handles, handleID, 1);
        FlushChildHashtable(handles, handleID);
        Release(state);
    }

    public function CreateBoundSpellTimer() -> timer {
        timer t = CreateTimer();
        Capture(GetHandleId(t));
        return t;
    }

    public function DestroyBoundSpellTimer(timer t) {
        if (t == null) { return; }
        Forget(GetHandleId(t));
        DestroyTimer(t);
    }

    private function RunTimer() {
        integer id = GetHandleId(GetExpiredTimer());
        abilityBindingAction action = LoadInteger(handles, id, 4);
        Enter(id);
        action.evaluate();
        PopAbilityBinding();
    }

    // 同时可传给 TimerStart 和 CenterTimerStart，保留原有时停行为。
    public function BoundSpellTimerCallback(timer t, abilityBindingAction action) -> code {
        SaveInteger(handles, GetHandleId(t), 4, action);
        return function RunTimer;
    }

    public function CreateBoundSpellTrigger() -> trigger {
        trigger tr = CreateTrigger();
        Capture(GetHandleId(tr));
        return tr;
    }

    public function DestroyBoundSpellTrigger(trigger tr) {
        if (tr == null) { return; }
        Forget(GetHandleId(tr));
        DestroyTrigger(tr);
    }

    public function AddBoundSpellAction(trigger tr, abilityBindingAction action) {
        SaveInteger(handles, GetHandleId(tr), 4, action);
        TriggerAddAction(tr, function () {
            trigger previous = callbackTrigger;
            integer id = GetHandleId(GetTriggeringTrigger());
            abilityBindingAction fn = LoadInteger(handles, id, 4);
            callbackTrigger = GetTriggeringTrigger();
            Enter(id);
            fn.evaluate();
            PopAbilityBinding();
            callbackTrigger = previous;
            previous = null;
        });
    }

    public function AddBoundSpellCondition(trigger tr, abilityBindingCondition condition) {
        SaveInteger(handles, GetHandleId(tr), 5, condition);
        TriggerAddCondition(tr, Condition(function () -> boolean {
            trigger previous = callbackTrigger;
            integer id = GetHandleId(GetTriggeringTrigger());
            abilityBindingCondition fn = LoadInteger(handles, id, 5);
            boolean result;
            callbackTrigger = GetTriggeringTrigger();
            Enter(id);
            result = fn.evaluate();
            PopAbilityBinding();
            callbackTrigger = previous;
            previous = null;
            return result;
        }));
    }
}
//! endzinc
#endif
