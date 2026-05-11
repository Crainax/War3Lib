## 函数定义顺序与间接调用

### 1) 基本约束

- 日常写 Zinc/JASS 时，不再强制要求“下方函数只能调用上方函数”。`vjassc` 会处理上方函数直接调用下方函数的场景。
- `jasshelper` 仍可能按旧的函数顺序规则失败：上方函数直接调用下方函数时，可能报未声明/不可见。
- 如果遇到“`jasshelper` 因函数顺序失败，但 `vjassc` 能通过”的情况，优先在这条调用上改成 `xxxx.evaluate(...)`，不要为了兼容旧编译器大范围搬动函数。
- 只有需要结构化封装、复用边界更清晰，或已经在 `struct` 内组织逻辑时，才把下方逻辑包进 `struct` 静态方法。

独立判例：`Init` 调用定义在下方的 `RefreshPanel` 时，`vjassc` 可以自动整理输出顺序；若同时要求 `jasshelper` 通过，可把调用点改成 `RefreshPanel.evaluate(owner)`，而不是把整段 UI 初始化函数整体搬动。

### 2) `execute` 示例（无返回）

```jass
static if (LIBRARY_Yuzaoqian) {
    if (IsYuzaoqian(H[index])) {
        UpgradeYuzaoqian.execute(p);
    }
}
```

- `execute` 不带返回值，适合纯过程调用。

### 3) `evaluate` 示例（本地场景推荐）

```jass
if (BDadiHoldPosition[index]) {
    cdOk = IsAbilityCDOK(u, 'AMRi');
    if (cdOk) {
        CreateDadiCar.evaluate(u);
        SetAbilityCD(u, 'AMRi', 10.0);
    }
}
```

- 本地场景（例如 UI 本地逻辑）只能用 `evaluate`，不要用 `execute`，否则可能 OOS。

### 4) `evaluate` 返回与无返回

```jass
function NeedRefresh(unit u) -> boolean {
    if (u == null) {
        return false;
    }
    return GetUnitState(u, UNIT_STATE_LIFE) < 200.0;
}

function RefreshNow(unit u) {
    if (u == null) {
        return;
    }
    // do something
    return;
}

if (NeedRefresh.evaluate(u)) {
    RefreshNow.evaluate(u);
}
```

### 5) 封装为静态方法（可选）

```jass
public struct RecreateCarBridge []{
    static method run(unit u) {
        CreateDadiCar(u);
    }
}

RecreateCarBridge.run(u);
```

- `jasshelper` 侧的 `evaluate` 会引入额外 trigger/condition 包装开销；如果只走 `vjassc`，通常不需要为了函数顺序添加间接调用。
