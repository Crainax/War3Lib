## 函数定义顺序与间接调用

### 1) 基本约束

- 默认按定义顺序可见：下方可直接调上方；上方不可直接调下方。
- 上方必须调下方时，使用以下两种方式之一：
  - `xxxx.execute(...)` / `xxxx.evaluate(...)`
  - 把下方逻辑包进 `struct` 的静态方法，通过静态方法对外暴露

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

### 5) 封装为静态方法（优先）

```jass
public struct RecreateCarBridge []{
    static method run(unit u) {
        CreateDadiCar(u);
    }
}

RecreateCarBridge.run(u);
```

- 非必要时仍建议保持“下方调上方”的设计，避免引入额外 trigger/condition 包装开销。
