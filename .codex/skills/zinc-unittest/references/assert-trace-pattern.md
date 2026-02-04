## `assert` + `Trace` 写法模式

以 `Jass/utils/unit/UnitUtils_Test.j` 为参考。

### 断言使用

优先使用 `UnitTestFramwork.assert`：

- `assert.Boolean(condition, "说明")`
- `assert.Integer(actual, expected, "说明")`
- `assert.Real(actual, expected, "说明")`
- `assert.String(actual, expected, "说明")`

建议：

1. 一条断言只验证一个行为。
2. 断言文案写“场景 + 预期结果”。
3. 数值链路测试按“初始化 -> 操作 -> 校验”分段。

### Trace 使用

- 在关键中间值处用 `Trace("actual:" + R2S(actual) + " expected:" + R2S(expected))`。
- 目标是输出到日志，辅助定位而不是替代断言。
- 高频循环中限制 Trace 数量，避免日志噪音。

### 推荐结构

```jass
private function Test_Something() {
    // arrange
    // act
    // assert
}

function Init() {
    UnitTestAutoTimer(0.3, 0.1, function() {
        Trace("[Xxx] Something test")
        Test_Something()
    }, null)
}
```

将复杂断言拆成多个 `Test_*`，并在 `Init` 中分时调度，降低互相干扰。
