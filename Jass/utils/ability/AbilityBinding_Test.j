#ifndef UTAbilityBindingIncluded
#define UTAbilityBindingIncluded
#include "AbilityBinding.j"
//! zinc
library UTAbilityBinding requires AbilityBinding, UnitTestFramwork {
    private function onInit() {
        UnitTestAutoTimer(1.0, 1.0, function () {
            unit u = CreateUnit(Player(0), 'Hpal', 0.0, 0.0, 0.0);
            integer a = CreateAbilityBinding(u, 'AHhb', 'Adef');
            integer b;
            integer c;
            timer t;
            trigger tr;
            assert.Boolean(a > ABILITY_BINDING_NATIVE_PLAYERS, "bound state is independent of player");
            assert.Integer(GetAbilityBindingSource(u, 'Adef'), 'AHhb', "source lookup");
            PushAbilityBinding(u, 'AHhb', 'Adef');
            assert.Integer(ResolveAbilityBinding(u, 'AHhb'), 'Adef', "bound context");
            PushAbilityBinding(u, 'AHhb', 'AHhb');
            assert.Integer(ResolveAbilityBinding(u, 'AHhb'), 'AHhb', "nested default context");
            PopAbilityBinding();
            assert.Integer(ResolveAbilityBinding(u, 'AHhb'), 'Adef', "restore parent context");
            tr = CreateBoundSpellTrigger();
            SaveUnitHandle(HASH_TRIGGER, GetHandleId(tr), 1, u);
            AddBoundSpellCondition(tr, function () -> boolean {
                unit expected = LoadUnitHandle(HASH_TRIGGER, GetHandleId(GetBoundSpellTrigger()), 1);
                assert.Boolean(expected != null, "bound trigger preserves originating trigger handle");
                assert.Integer(ResolveAbilityBinding(expected, 'AHhb'), 'Adef', "trigger callback enters binding context");
                expected = null;
                return true;
            });
            TriggerEvaluate(tr);
            FlushChildHashtable(HASH_TRIGGER, GetHandleId(tr));
            DestroyBoundSpellTrigger(tr);
            tr = null;
            t = CreateBoundSpellTimer();
            PopAbilityBinding();
            DestroyAbilityBinding(u, 'Adef');
            b = CreateAbilityBinding(u, 'AHhb', 'Adef');
            assert.Boolean(a != b, "in-flight timer retains old state");
            DestroyBoundSpellTimer(t);
            c = CreateAbilityBinding(u, 'AHhb', 'Ainv');
            assert.Integer(c, a, "released state is reused only after final reference");
            DestroyAbilityBinding(u, 'Adef');
            DestroyAbilityBinding(u, 'Ainv');
            assert.Integer(ResolveAbilityBinding(u, 'AHhb'), 'AHhb', "context fully restored");
            RemoveUnit(u);
            u = null;
            t = null;
        }, null);
    }
}
//! endzinc
#endif
