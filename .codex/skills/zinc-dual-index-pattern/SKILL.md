---
name: zinc-dual-index-pattern
description: >
  War3Lib/Xlimon 的 Zinc/JASS 紧凑数组、尾部交换删除（swap-remove）与双索引/分组索引模式。
  用于实现或 review 高频 create/destroy 的 Buff、Effect、Queue、中央计时器、按玩家分组列表、物品或召唤物紧凑表；
  当需要 removeAt、O(1) 删除、遍历删除回退、并行数组同步 swap、或全局视图+分组视图索引一致性时使用。
---

# Zinc 双重索引 + 紧凑数组模式（War3Lib/Xlimon）

按需加载参考文档；先根据当前仓库选择对应示例，再实现：

- **紧凑遍历**：数组无空洞，`for` 遍历不需要跳过空位
- **O(1) 删除**：用尾部交换（swap-remove）移除元素
- **双视图索引**：同一实例同时存在于“全局列表”和“分组列表”，并能分别遍历/查询

## 仓库分流

- 当前仓库是 War3Lib 时，优先读取 `references/war3lib-examples.md`。
- 当前仓库是 Xlimon 时，优先读取 `references/xlimon-examples.md`；不要把 War3Lib 文件名、类型名或示例路径机械搬入地图项目。
- 通用算法与检查项使用其余 references；并行数组发生 swap 时必须同步更新所有列与反向索引。

## References（按需打开）

- `references/overview.md`
- `references/swap-remove.md`
- `references/dual-index-template.md`
- `references/war3lib-examples.md`
- `references/xlimon-examples.md`
- `references/checklist.md`
