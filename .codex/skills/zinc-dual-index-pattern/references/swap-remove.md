# 尾部交换（swap-remove / 尾部交换法）

## 0-based removeAt（Queue 常用）

核心点：

- 有效区间是 `[0, size)`
- 删除后要 **回退一格** 继续检查（因为当前位置被换入了新元素）

```jass
// 返回“更新后的 i”（通常是 i - 1）
private static method removeAt(integer index) -> integer {
    integer last;
    if (index < 0 || index >= thistype.size) { return index; }

    last = thistype.size - 1;
    if (index != last) {
        thistype.list[index] = thistype.list[last];
        thistype.remain[index] = thistype.remain[last]; // 并行数组要一起 swap
    }

    thistype.list[last] = null;
    thistype.remain[last] = 0.0;
    thistype.size -= 1;

    return index - 1;
}
```

遍历删除写法（Zinc 禁用 `continue` 时常用的套路）：

```jass
for (i = 0; i < thistype.size; i += 1) {
    if (shouldRemove(thistype.list[i])) {
        i = thistype.removeAt(i);
    }
}
```

## 1-based removeAt（实例表常用）

核心点：

- 有效区间是 `[1, size]`
- 删除后通常写 `i -= 1`（或返回 `index - 1`）

```jass
private static method removeAt(integer index) -> integer {
    integer last;
    if (index < 1 || index > thistype.size) { return index; }

    last = thistype.size;
    if (index != last) {
        thistype.list[index] = thistype.list[last];
        thistype.list[index].listIndex = index; // 双重索引：更新被 swap 的实例索引
    }
    thistype.list[last] = 0;
    thistype.size -= 1;
    return index - 1;
}
```

## “清理在 swap 前做”

如果删除涉及资源释放/清哈希/解绑特效等：

- 先拿到 `ru = list[index]`
- 对 `ru` 做清理
- 再 swap（否则你可能把 `ru` 覆盖丢失，导致无法清理）

## 并行数组（SoA）要保持一致

典型结构：`list[] + remain[] + units[] + timers[] ...`

- swap 时 **所有并行数组都要一起 swap**
- `last` 位置的所有槽都要清掉（`null/0/""/0.0`）

