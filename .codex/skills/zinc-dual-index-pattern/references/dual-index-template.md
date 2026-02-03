# 双重索引模板（全局 + 分组）

目标：同一实例同时支持：

- 全局遍历：`Lists[1..size]`
- 分组遍历：`groupLists[groupId][1..groupSize[groupId]]`

最关键点：实例记录 **自己在两个列表中的位置**，并在 swap 时更新被换入实例的索引。

```jass
public struct MyStruct {
    // 全局列表
    public static thistype Lists[];
    public static integer size = 0;

    // 分组列表（按需决定维度）
    public static thistype groupLists[MAX_GROUP+1][MAX_PER_GROUP+1];
    public static integer groupSize[MAX_GROUP+1];

    // 实例索引（0 表示“不在列表中”）
    private integer listIndex;
    private integer groupId;
    private integer groupIndex;

    public static method create(integer gid) -> thistype {
        thistype this;
        integer pos;

        if (gid < 1 || gid > MAX_GROUP) { return 0; }
        if (thistype.groupSize[gid] >= MAX_PER_GROUP) { return 0; }

        this = allocate();

        // 加入全局列表（1-based）
        thistype.size += 1;
        thistype.Lists[thistype.size] = this;
        this.listIndex = thistype.size;

        // 加入分组列表（1-based）
        this.groupId = gid;
        pos = thistype.groupSize[gid] + 1;
        thistype.groupLists[gid][pos] = this;
        thistype.groupSize[gid] = pos;
        this.groupIndex = pos;

        return this;
    }

    private method removeFromGlobal() {
        integer last;
        if (this.listIndex == 0) { return; }
        last = thistype.size;
        if (this.listIndex != last) {
            thistype.Lists[this.listIndex] = thistype.Lists[last];
            thistype.Lists[this.listIndex].listIndex = this.listIndex;
        }
        thistype.Lists[last] = 0;
        thistype.size -= 1;
        this.listIndex = 0;
    }

    private method removeFromGroup() {
        integer last;
        if (this.groupIndex == 0) { return; }
        last = thistype.groupSize[this.groupId];
        if (this.groupIndex != last) {
            thistype.groupLists[this.groupId][this.groupIndex] = thistype.groupLists[this.groupId][last];
            thistype.groupLists[this.groupId][this.groupIndex].groupIndex = this.groupIndex;
        }
        thistype.groupLists[this.groupId][last] = 0;
        thistype.groupSize[this.groupId] = last - 1;
        this.groupIndex = 0;
        this.groupId = 0;
    }

    method onDestroy() {
        // 先从两个视图移除（swap-remove）
        this.removeFromGlobal();
        this.removeFromGroup();

        // 再做资源释放/解绑/置空（按实际字段）
    }
}
```

可选增强（常见需求）：

- **外部按 key 查找**：`unit -> this` / `timer -> this` 用 HashTable（HandleId）做映射
- **多维分组**：二维/三维索引（例如 `playerId + spellId`），需要把 group key 设计成可计算的整数或多张表

