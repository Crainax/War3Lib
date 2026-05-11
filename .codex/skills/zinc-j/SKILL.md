---
name: zinc-j
description: 本项目 .j 文件中的 Zinc（//! zinc ... //! endzinc）语法与约定：库/结构体写法、匿名函数（无闭包）最佳实践、回调参数传递、资源释放/置空、以及 JASS->Zinc 迁移要点。
---

# Zinc（本项目）语法与约定

## 必须遵守

- 用 `//! zinc` / `//! endzinc` 包裹 Zinc 代码块。
- 禁用 `++/--`；用 `+= 1` / `-= 1`。
- 禁用 `break/continue`；用 `if` 分支或布尔开关改写。
- 数组声明一律用 `type name[];`，不要写大小（例如 `integer a[10]` 是错的）。
- Zinc 的数组维度里不要写表达式（例如 `arr[HERO_COUNT + 1][5]`）；需要先把值算成常量再使用，或直接用固定上界。
- 二维数组在底层是线性存储；只要索引映射不冲突（例如 `a[6][5]` 下 `(1,5)` 与 `(2,1)` 映射不同），可以按项目约定安全使用，不必为了“从 1 开始”额外预留整段 `[1]`。
- 返回类型用 `-> type` 写在参数列表后；无返回可省略。
- 局部变量统一在函数/匿名函数开头声明：先基础类型，后句柄类型。
- 函数定义顺序不再作为日常写法的硬性约束：`vjassc` 会处理上方函数直接调用下方函数的场景。
- 仍需兼容 `jasshelper` 时，如果它只因函数顺序报错而 `vjassc` 能过，优先在该调用点改成 `xxxx.evaluate(...)`，少做大范围函数重排。
- 本地场景（例如 UI 本地执行）禁止 `execute`，只能用 `evaluate`，否则有 OOS 风险。

## 匿名函数（无闭包）

- 匿名函数内不能直接访问外层局部变量；需要显式传参。
- 传参优先用结构体/库的 `static` 成员变量，并在回调结束后立刻清理为默认值（`null/0/""`）。
- 临时触发器回调用 `CreateTrigger` + `TriggerAddCondition` + `TriggerEvaluate`，随后 `DestroyTrigger` 并置 `null`。

## 句柄生命周期（资源释放）

- 创建出来的句柄资源（`timer/trigger/group/effect/location/...`）：按对应 `Destroy*` / `Remove*` API 释放，并在作用域末尾 `= null`。
- 结构体析构只写 `method onDestroy()`；不要自定义 `destroy()`。

## 结构体/方法写法

- 静态方法：`static method foo(...) -> type { ... }`
- 实例方法：`method foo(...) -> type { ... }`
- 纯静态“管理器”可用 `struct X [] { ... }`（避免 `create/destroy`）。

## 跨位置调用与性能约束

- `execute`：不带返回值（底层是 `TriggerExecute` 触发 action）。
- `evaluate`：可用于需要返回值或不需要返回值的调用场景。
- `jasshelper` 会把 `evaluate` 降成 trigger/condition 包装，存在额外资源开销；`vjassc` 通常能把这类调用智能降成直接调用。
- 不要为了旧的函数顺序习惯重排大段代码；只有在需要通过 `jasshelper` 或解决循环调用链时才引入 `evaluate` / `execute`。

## JASS -> Zinc 迁移要点

- JASS 默认 `public`；Zinc 默认 `private`：需要对外可见的函数/全局变量要显式 `public`。
- `loop/exitwhen/endloop` 优先改写为 Zinc 的范围 `for (a <= i <= b)` 或常规 for。
- timer/trigger 的一次性逻辑优先改成匿名回调。

## References（按需加载）

- `references/jass-to-zinc.md`
- `references/anonymous-functions.md`
- `references/callback-params.md`
- `references/method-syntax.md`
- `references/function-order-and-indirect-call.md`

