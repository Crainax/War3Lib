# 真双索引模板

当同一实例同时需要全局遍历和按组遍历时，使用真双索引。普通队列和单一分组表不要过度套用这个模板。

```jass
public struct sampleEntry {
    public static thistype allList[];
    public static integer size = 0;

    public static thistype groupList[MAX_PLAYER_COUNT][64];
    public static integer groupSize[MAX_PLAYER_COUNT];

    private integer listIndex;
    private integer groupId;
    private integer groupIndex;

    public static method create(integer gid) -> thistype {
        thistype this;
        integer pos;

        if (!ISVALID_PLAYER_ID(gid)) { return 0; }
        if (thistype.groupSize[gid] >= 63) { return 0; }

        this = allocate();

        thistype.size += 1;
        thistype.allList[thistype.size] = this;
        this.listIndex = thistype.size;

        pos = thistype.groupSize[gid] + 1;
        thistype.groupList[gid][pos] = this;
        thistype.groupSize[gid] = pos;
        this.groupId = gid;
        this.groupIndex = pos;

        return this;
    }

    private method removeFromAll() {
        integer last;

        if (this.listIndex == 0) { return; }

        last = thistype.size;
        if (this.listIndex != last) {
            thistype.allList[this.listIndex] = thistype.allList[last];
            thistype.allList[this.listIndex].listIndex = this.listIndex;
        }

        thistype.allList[last] = 0;
        thistype.size -= 1;
        this.listIndex = 0;
    }

    private method removeFromGroup() {
        integer last;

        if (this.groupIndex == 0) { return; }

        last = thistype.groupSize[this.groupId];
        if (this.groupIndex != last) {
            thistype.groupList[this.groupId][this.groupIndex] = thistype.groupList[this.groupId][last];
            thistype.groupList[this.groupId][this.groupIndex].groupIndex = this.groupIndex;
        }

        thistype.groupList[this.groupId][last] = 0;
        thistype.groupSize[this.groupId] = last - 1;
        this.groupIndex = 0;
        this.groupId = 0;
    }

    method onDestroy() {
        this.removeFromAll();
        this.removeFromGroup();

        // 再释放本实例持有的 timer/trigger/unit/effect 等资源。
    }
}
```

关键点：

- swap 到当前位置的实例必须更新 `listIndex` 或 `groupIndex`。
- 先从索引结构移除，再清实例字段；需要释放句柄时先保存引用，避免 swap 后丢失。
- 如果只有 `groupList[group][pos] + groupSize[group]`，没有全局列表，就不是双索引，只需要维护分组紧凑性。
