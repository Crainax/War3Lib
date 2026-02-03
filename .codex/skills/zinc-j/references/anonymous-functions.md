## 匿名函数最佳实践（无闭包）

### 基本规则

- 匿名函数体内先声明局部变量（先基础类型，再句柄类型）。
- 不要在匿名函数内访问外层局部变量；需要显式传参。

### 传参方式（推荐）

用 `struct` / `library` 的 `static` 成员变量传参，并在回调结束后立刻清理：

```jass
public struct Example []{
    public static player cbPlayer = null;
    public static integer cbValue = 0;
}
```

### 临时 TriggerEvaluate 模式

```jass
trigger tr;
tr = CreateTrigger();
TriggerAddCondition(tr, Condition(function () -> boolean {
    // 读取 Example.cbPlayer / Example.cbValue
    return false;
}));
TriggerEvaluate(tr);
DestroyTrigger(tr);
tr = null;
```

### TimerStart 模式（句柄资源释放）

- 在回调里：`PauseTimer` ->（如有）`FlushChildHashtable` -> `DestroyTimer` -> `t = null`

