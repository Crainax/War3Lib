# 实现与 Review Checklist

## 结构选择

- 明确是普通紧凑队列、分组紧凑表，还是全局+分组的真双索引。
- 不需要全局遍历时，不要引入全局列表。
- 不需要外部 O(1) 删除时，不要强塞 `listIndex`；简单队列可只在遍历中删除。

## 索引规则

- 0-based：有效区间 `0 <= i < size`，`last = size - 1`。
- 1-based：有效区间 `1 <= pos <= count[group]`，`last = count[group]`。
- `size` / `count` 只表示元素数量。

## 删除规则

- swap 前先保存待释放资源引用。
- 所有并行数组一起 swap。
- last 槽全部清空。
- 删除后收缩 `size` / `count`。
- 遍历中删除必须回退或不递增当前位置。

## 资源与映射

- timer/trigger/group/effect/location 等句柄按需 `Destroy*` / `Remove*` 并置 `null`。
- hashtable 映射要和数组结构同步清理。
- 队列为空时可以销毁中央 timer，下一次 add/set 再创建。

## Xlimon 风险点

- 本地 UI 回调里不要直接改同步业务列表；需要同步入口时走已有 syncBus/DzSyncDataEx 路线。
- 玩家分组索引用 `GetConvertedPlayerId` 后要确认范围。
- 容量接近 War3 数组上限时保留保护分支和日志。
- review 时优先检查是否漏 swap 某个并行数组，以及删除后是否跳过换入元素。
