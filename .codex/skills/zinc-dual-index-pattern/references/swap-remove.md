# 尾部交换删除

尾部交换用于 O(1) 删除并保持数组紧凑：删除 `index` 时把 `last` 元素搬到 `index`，清空 `last`，再缩小 `size`。

## 0-based 队列

适合 `SimuDeleteQueue` / `SpellRangeCDQueue` 这种中央 tick 队列。

```jass
private static method removeAt(integer index) -> integer {
    integer last;
    unit u;

    if (index < 0 || index >= thistype.size) {
        return index;
    }

    last = thistype.size - 1;

    // 如需释放资源，先拿到待删元素再 swap。
    u = thistype.uList[index];
    if (u != null) {
        DeleteUnit(u);
        u = null;
    }

    if (index != last) {
        thistype.uList[index] = thistype.uList[last];
        thistype.leftTicks[index] = thistype.leftTicks[last];
    }

    thistype.uList[last] = null;
    thistype.leftTicks[last] = 0;
    thistype.size -= 1;

    return index - 1;
}
```

遍历中删除：

```jass
for (i = 0; i < thistype.size; i += 1) {
    if (shouldRemove(thistype.uList[i])) {
        i = thistype.removeAt(i);
    }
}
```

## 1-based 分组表

适合 `summons[pid][idx] + size[pid]`、`stone[idx][pos] + stoneCount[idx]`。

```jass
private static method removeAt(integer group, integer pos) -> integer {
    integer last;

    if (pos < 1 || pos > thistype.count[group]) {
        return pos;
    }

    last = thistype.count[group];
    if (pos != last) {
        thistype.list[group][pos] = thistype.list[group][last];
    }

    thistype.list[group][last] = null;
    thistype.count[group] -= 1;

    return pos - 1;
}
```

## Xlimon 注意点

- 句柄槽清空用 `null`，整数/real/string 槽分别清成 `0` / `0.0` / `""`。
- `SpellRangeCDQueue` 这类哈希驱动队列，先清哈希或确认哈希状态，再移除数组项。
- 队列为空后可销毁 tick timer：`PauseTimer`、`DestroyTimer`、`tickTimer = null`。
- add 时保留容量保护，常见上限是 `8190`。
