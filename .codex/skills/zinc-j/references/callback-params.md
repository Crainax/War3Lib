## 回调参数传递（避免哈希表冲突）

### 推荐做法：static 成员变量

- 不要用固定 key 存到全局 hashtable 再在回调里读取（容易冲突、难排查）。
- 用结构体/库的 `public static` 成员变量传参，回调完成后立刻清理。

```jass
public struct MyCb []{
    public static unit cbUnit = null;
    public static integer cbInt = 0;
}
```

### 清理要求

- 回调执行完成后必须把静态传参变量恢复为默认值（`null/0/""`），避免串参与隐式依赖。

