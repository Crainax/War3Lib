## 常用片段

### 1) 宏保护（写在业务库时）

```jass
#if (CURRENT_BUILD_VERSION != VERSION_RELEASE)
private function RegisterUnitTestHooks() {
    UnitTestRegisterChatEvent(function () {
        if (GetEventPlayerChatString() == "qdt") {
            Trace("[Xxx] run qdt")
        }
    })
}
#endif
```

### 2) `Init` 中分时执行

```jass
function Init() {
    UnitTestAutoTimer(0.3, 0.1, function() {
        Trace("[Xxx] smoke")
        assert.Boolean(true, "Xxx smoke should pass")
    }, null)
}
```

### 3) `_Test.j` 入口模式

```jass
function TTestUTXxx1(player p) {
    Test_Smoke()
}

function onInit() {
    trigger tr = CreateTrigger()
    TriggerRegisterTimerEventSingle(tr, 0.5)
    TriggerAddCondition(tr, Condition(function () {
        Init()
        DestroyTrigger(GetTriggeringTrigger())
    }))
    tr = null

    UnitTestRegisterChatEvent(function () {
        string str = GetEventPlayerChatString()
        if (str == "s1") TTestUTXxx1(GetTriggerPlayer())
    })
}
```
