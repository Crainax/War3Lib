# 结构判断：紧凑数组、分组索引、真双索引

这个模式在 Xlimon 里常见于临时单位、技能冷却、召唤物、物品槽等高频增删结构。先判断当前需求属于哪一种。

## 普通紧凑队列

形态：

- `list[] + size`
- 或 `uList[] + leftTicks[] + size`
- 有效区间通常是 0-based：`0 <= i < size`

Xlimon 例子：

- `edit/Simulate.j` 的 `SimuDeleteQueue`
- `edit/SpellBase.j` 的 `SpellRangeCDQueue`

适合：中央 timer 每 tick 遍历、到期删除、队列项不需要被外部长期持有。

## 分组紧凑表

形态：

- `list[group][pos] + count[group]`
- 常见 group 是玩家 id、英雄 id、单位类型、物品分类。
- 有效区间常用 1-based：`1 <= pos <= count[group]`

Xlimon 例子：

- `edit/unit/Moshou.j` 的 `summoner.summons[pid][idx] + summoner.size[pid]`
- `edit/item/Shengjingshi.j` 的 `sjs.stone[idx][pos] + sjs.stoneCount[idx]`

适合：按玩家/类别遍历和清理，不需要全局遍历所有实例。

## 真双索引

形态：

- 全局视图：`allList[1..size]`
- 分组视图：`groupList[group][1..groupSize[group]]`
- 实例字段：`listIndex`、`groupId`、`groupIndex`

只有同一实例既要“全局遍历所有”，又要“按组快速遍历/删除”时，才需要真双索引。删除时必须同时从两个视图移除，并在 swap 后更新被换入实例的索引字段。

## 不变量

- `size` / `count[group]` 表示元素数量，不要同时当作最后索引和容量使用。
- 有效区间内无空洞。
- swap 时所有并行数组一起换。
- last 槽必须清空。
- 遍历中删除后必须重新检查当前位置：`i -= 1` 或 `i = removeAt(i)`。
