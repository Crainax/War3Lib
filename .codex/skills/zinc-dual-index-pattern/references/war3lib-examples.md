# War3Lib 里的落地例子（用于对照）

本项目中“紧凑数组 + 尾部交换”的典型写法：

- `Jass/utils/buff/UnitBuff.j`
  - `ImmuteQueue[]`：`uList[] + size`，遍历时 `i = removeAt(i)` 回退继续检查
  - `PauseQueue[]`：`removeAt` 在 swap 前统一做“解除暂停 + 清哈希 + 解绑特效”等清理
  - `StunCdQueue[]`：基础版队列移除
  - `TimerBuffQueue[]`：并行数组 `timers[]/units[]/lefts[]` 一起 swap；移除时销毁 timer/trigger 并清 hashtable
- `Jass/utils/effect/EffectUtils.j`
  - `LightningQueue[]` / `EffectQueue[]`：中央 tick timer + 并行数组；`size == 0` 时销毁 timer 做懒加载

共性做法（建议在自己的实现里复用）：

- **容量保护**：以 `8190` 为上限避免数组越界（0-based 最后索引 8190）
- **删除回退**：删除后回退 `i`，保证不会跳过被 swap 进来的元素
- **资源清理前置**：先抓住待删元素引用，再 swap，避免覆盖导致漏清理
- **timer 懒加载**：队列为空就销毁 tick timer，下一次 add 再创建

