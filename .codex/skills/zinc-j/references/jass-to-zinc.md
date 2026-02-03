## JASS -> Zinc 迁移要点（示例）

### 可见性（JASS 默认 public，Zinc 默认 private）

在 JASS 里能被外部调用/访问的函数与全局变量，迁移到 Zinc 后要显式加 `public`。

### 数组声明

- JASS：`integer array A`
- Zinc：`integer A[];`

### loop/endloop 改写为 for

把 `loop/exitwhen/endloop` 改写为 `for`，索引变量放在函数顶部声明，并使用 `+= 1`。

### trigger / timer 回调

如果回调只在一处使用，优先直接写匿名回调（避免拆出具名函数）。

