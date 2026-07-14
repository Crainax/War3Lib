# Xlimon 例子

## `edit/Simulate.j`：`SimuDeleteQueue`

这是 0-based 普通紧凑队列，不是真双索引。

结构：

- `uList[]`
- `leftTicks[]`
- `size`
- `tickTimer`

关键行为：

- 每 0.10 秒遍历一次。
- `leftTicks[i] -= 1`。
- 到期后先取 `u = uList[i]` 并 `DeleteUnit(u)`。
- 用 `last = size - 1` 做尾部交换。
- 清空尾部 `uList[last] = null`、`leftTicks[last] = 0`。
- `size -= 1`。
- `i -= 1`，重新检查被换入当前位置的元素。

适合照抄的场景：延迟删除单位、延迟释放轻量资源、中央 timer 管理一批简单任务。

## `edit/SpellBase.j`：`SpellRangeCDQueue`

这是带逻辑 key 的 0-based 紧凑队列。

结构：

- `uList[]`
- `abilList[]`
- `size`
- `tickTimer`
- `HASH_ABILITY` 中保存真实剩余冷却

关键行为：

- `u + abilityID` 组成队列项身份。
- `indexOf(unit u, integer abilityID)` 用于外部更新/删除。
- 删除时 `uList` 与 `abilList` 必须一起 swap。
- 冷却结束时先 `RemoveSavedReal`，再从队列移除。
- `size <= 0` 时销毁 timer，下一次 setValue 再懒加载。

适合照抄的场景：同一类业务有外部 set/update/remove 入口，且 tick 时需要遍历推进状态。

## `edit/unit/Moshou.j`：召唤物分组表

这是按玩家分组的 1-based 紧凑表。

结构：

- `summoner.summons[pid][idx]`
- `summoner.size[pid]`

关键行为：

- 每个玩家独立一组。
- 删除失效单位时用 `last = size[pid]`，把尾部召唤物换到当前位置。
- 删除后不递增 `idx`，继续处理换入的召唤物。
- 这个结构没有全局列表，因此不是“双视图”，只要维护该玩家组内紧凑性。

## `edit/item/Shengjingshi.j`：石头/装备分组表

这是按玩家/分类维护的 1-based 尾部交换。

结构：

- `sjs.stone[idx][pos] + sjs.stoneCount[idx]`
- `sjs.equit[idx][pos] + sjs.equitCount[idx]`

关键行为：

- `removeStoneAt(idx, pos)` 不负责 `RemoveItem`，只维护数组结构。
- `removeEquipAt(idx, pos)` 同样只做尾部交换和计数收缩。
- 这种拆分能让调用点先处理业务资源，再复用结构删除。

适合照抄的场景：同一个玩家/分类下的小型物品列表，外部已知道要删除的位置。
