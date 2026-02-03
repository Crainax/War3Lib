---
name: zinc-dual-index-pattern
description: Zinc 双重索引数据结构模式 - 高效的实例管理数据结构，支持全局遍历和分组管理
---

# Zinc 双重索引数据结构模式

## 核心设计模式

这是一个高效的实例管理数据结构，适用于需要**全局遍历**和**分组管理**的场景。

参考实现：[Dash.j](mdc:Jass/ability/dash/Dash.j)

### 基础结构模板

```jass
public struct MyStruct {
    // ====== 双重索引系统 ======
    // 全局列表（用于遍历所有实例）
    public static thistype Lists[];
    public static integer size = 0;

    // 分组列表（二维数组，按某个维度分组）
    public static thistype groupLists[MAX_GROUP_COUNT][MAX_ITEMS_PER_GROUP];
    public static integer groupSize[MAX_GROUP_COUNT];

    // ====== 实例索引记录 ======
    private integer listIndex;        // 在全局列表中的位置
    private integer groupId;          // 所属分组 ID
    private integer groupListIndex;   // 在分组列表中的位置

    // ====== 边界检查 ======
    private static method isValidGroup(integer gid) -> boolean {
        return gid >= 1 && gid <= MAX_GROUP_COUNT;
    }

    private static method isValidPos(integer pos) -> boolean {
        return pos >= 1 && pos <= MAX_ITEMS_PER_GROUP;
    }
}
```

### 创建方法模板

```jass
public static method create(integer groupId) -> thistype {
    integer pos; thistype this;

    if (!MyStruct.isValidGroup(groupId)) { return 0; }

    this = allocate();
    // 初始化实例数据...

    // 加入全局列表
    MyStruct.size = MyStruct.size + 1;
    MyStruct.Lists[MyStruct.size] = this;
    this.listIndex = MyStruct.size;

    // 加入分组列表
    this.groupId = groupId;
    pos = MyStruct.groupSize[groupId] + 1;
    if (pos <= MAX_ITEMS_PER_GROUP) {
        MyStruct.groupLists[groupId][pos] = this;
        MyStruct.groupSize[groupId] = pos;
        this.groupListIndex = pos;
    } else {
        // 容量超限回滚
        MyStruct.Lists[this.listIndex] = 0;
        MyStruct.size = MyStruct.size - 1;
        this.listIndex = 0;
        this.destroy();
        return 0;
    }

    return this;
}
```

### 销毁方法模板（关键：紧凑数组维护）

```jass
method onDestroy() {
    integer last; integer groupLast;

    if (!this.isExist()) { return; }

    // 从全局列表移除（紧凑数组）
    if (this.listIndex != 0) {
        last = MyStruct.size;
        if (this.listIndex != last) {
            // 将最后元素移到当前位置
            MyStruct.Lists[this.listIndex] = MyStruct.Lists[last];
            MyStruct.Lists[this.listIndex].listIndex = this.listIndex;
        }
        MyStruct.Lists[last] = 0;
        MyStruct.size = MyStruct.size - 1;
        this.listIndex = 0;
    }

    // 从分组列表移除（紧凑数组）
    if (MyStruct.isValidGroup(this.groupId) && this.groupListIndex != 0) {
        groupLast = MyStruct.groupSize[this.groupId];
        if (this.groupListIndex != groupLast) {
            // 将最后元素移到当前位置
            MyStruct.groupLists[this.groupId][this.groupListIndex] = MyStruct.groupLists[this.groupId][groupLast];
            MyStruct.groupLists[this.groupId][this.groupListIndex].groupListIndex = this.groupListIndex;
        }
        MyStruct.groupLists[this.groupId][groupLast] = 0;
        MyStruct.groupSize[this.groupId] = groupLast - 1;
        this.groupListIndex = 0;
        this.groupId = 0;
    }

    // 清理句柄类成员变量...
}
```

### 遍历方法模板

```jass
// 遍历所有实例
static method forEachAll(code callback) {
    integer i; thistype inst;
    for (1 <= i <= MyStruct.size) {
        inst = MyStruct.Lists[i];
        if (inst != 0 && inst.isExist()) {
            // 设置回调参数
            MyStruct.callbackInstance = inst;
            TriggerEvaluate(callbackTrigger);
        }
    }
}

// 遍历指定分组
static method forEachGroup(integer groupId, code callback) {
    integer i; thistype inst;
    if (!MyStruct.isValidGroup(groupId)) { return; }

    for (1 <= i <= MyStruct.groupSize[groupId]) {
        inst = MyStruct.groupLists[groupId][i];
        if (inst != 0 && inst.isExist()) {
            MyStruct.callbackInstance = inst;
            TriggerEvaluate(callbackTrigger);
        }
    }
}
```

### 查询方法模板

```jass
// 按索引获取实例
static method getByIndex(integer index) -> thistype {
    if (index < 1 || index > MyStruct.size) { return 0; }
    return MyStruct.Lists[index];
}

// 按分组和位置获取实例
static method getByGroupPos(integer groupId, integer pos) -> thistype {
    if (!MyStruct.isValidGroup(groupId) || !MyStruct.isValidPos(pos)) { return 0; }
    if (pos > MyStruct.groupSize[groupId]) { return 0; }
    return MyStruct.groupLists[groupId][pos];
}

// 获取分组大小
static method getGroupSize(integer groupId) -> integer {
    if (!MyStruct.isValidGroup(groupId)) { return 0; }
    return MyStruct.groupSize[groupId];
}

// 获取总数
static method getTotalSize() -> integer {
    return MyStruct.size;
}
```

## 设计优势

1. **高效遍历**：O(n) 遍历，无需跳过空位
2. **O(1) 操作**：添加/删除都是常数时间
3. **内存紧凑**：数组无空洞，内存利用率高
4. **双重索引**：支持全局和分组两种遍历方式
5. **安全可靠**：完善的边界检查和回滚机制

## 适用场景

- 需要按不同维度管理和遍历实例的系统
- 频繁创建/销毁且需要高效遍历的结构
- 玩家相关的技能、物品、状态管理
- 任何需要"全局 + 分组"双重视图的数据结构

## 关键原则

- **1-based 索引**：与 War3 API 保持一致
- **紧凑数组**：删除时移动最后元素到删除位置
- **索引一致性**：每个实例始终知道自己在列表中的位置
- **失败回滚**：创建失败时撤销已执行的操作
- **边界检查**：所有数组访问都要验证索引有效性

## 常见变体

### 玩家分组变体
```jass
// 按玩家分组的经典模式
public static thistype playerLists[MAX_PLAYER_COUNT][MAX_ITEMS_PER_PLAYER];
public static integer playerSize[MAX_PLAYER_COUNT];

// 使用 GetConvertedPlayerId(player) 作为分组 ID
static method createForPlayer(player p) -> thistype {
    return MyStruct.create(GetConvertedPlayerId(p));
}
```

### 单一列表变体
```jass
// 如果只需要全局遍历，可简化为单一列表
public struct SimpleStruct {
    public static thistype Lists[];
    public static integer size = 0;
    private integer listIndex;

    // 只保留全局列表的创建/销毁逻辑
}
```

### 回调机制变体
```jass
// 添加变更回调支持
private static trigger changeCallback = null;
static thistype callbackInstance = 0;

static method registerChangeCallback(code func) {
    if (changeCallback == null) {
        changeCallback = CreateTrigger();
    }
    TriggerAddCondition(changeCallback, Condition(func));
}

static method getCallbackInstance() -> thistype {
    return callbackInstance;
}
```

## 性能考虑

- **容量规划**：合理设置 `MAX_GROUP_COUNT` 和 `MAX_ITEMS_PER_GROUP`
- **遍历频率**：如果遍历频繁，优先考虑紧凑数组设计
- **创建销毁频率**：频繁操作时，O(1) 的优势明显
- **内存使用**：固定大小数组 vs 动态增长需要权衡
