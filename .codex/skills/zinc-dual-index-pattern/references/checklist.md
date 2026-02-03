# 实现/Review Checklist

## 结构与索引

- 明确使用 `0-based` 还是 `1-based`，并在整个结构内保持一致
- `size` 表示“元素数量”还是“最后索引”，不要混用
- 双视图时：实例记录 `listIndex/groupIndex/groupId`，并在 swap 时更新被换入实例的索引

## 删除（swap-remove）

- `last` 计算正确（0-based: `size-1`；1-based: `size`）
- swap 时并行数组全部一起 swap
- `last` 槽全部清空（`null/0/""/0.0`）
- 删除发生在遍历中：回退 `i`（`i -= 1` 或 `i = removeAt(i)`）

## 资源与一致性

- 清理逻辑在 swap 前执行（先拿到待删元素引用）
- timer/trigger/group/effect/location 等句柄按需 `Destroy*` 并置 `null`
- HashTable 映射：删除时同步清理（`RemoveSaved*` / `FlushChildHashtable`）

## 边界与健壮性

- add 时做容量检查（War3 数组上限附近）
- 处理失效句柄（`null` / `GetUnitTypeId(u)==0` 等）
- 避免 re-entrancy：tick 回调里不要触发会再次修改同一列表的逻辑（必要时用“待删除标记 + 二次清理”）

