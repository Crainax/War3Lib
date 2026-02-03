## 结构体与方法语法（速查）

### struct 与方法

```jass
public struct Foo {
    static method create() -> Foo { return Foo.allocate(); }
    method onDestroy() { }

    static method bar(integer x) -> integer { return x; }
    method baz(integer x) -> integer { return x; }
}
```

### 纯静态管理器：struct X []

适用于只放静态字段/静态方法、不需要实例化的“管理器”：

```jass
public struct MallItem []{
    public static integer count = 0;
    static method init() { }
}
```

### onDestroy 规则

- 只实现 `method onDestroy()` 做清理。
- 不要自定义 `method destroy()`（避免覆盖内置销毁流程）。

