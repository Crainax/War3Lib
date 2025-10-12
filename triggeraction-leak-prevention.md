# TriggerAction 防泄露最佳实践规则

## 核心问题

根据 `MemoryLeak_Test.j` 的测试结果，发现以下关键问题：

- **结论2**: `TriggerAddAction` 后立即调用 `DestroyTrigger` **会泄露 1 个触发器动作**
- **结论3**: `TriggerRemoveAction` 可以排泄触发器动作，**不会泄露**

## 错误做法（会导致泄露）

```jass
// ❌ 错误：直接销毁触发器会导致 triggeraction 泄露
function BadExample() {
    trigger t = CreateTrigger();
    TriggerAddAction(t, function () {
        BJDebugMsg("这个动作会泄露！");
    });
    TriggerExecute(t);
    DestroyTrigger(t);  // 泄露：triggeraction 没有被正确清理
    t = null;
}
```

## 正确做法（防止泄露）

### 方法1：保存 triggeraction 引用并手动移除

```jass
// ✅ 正确：先移除动作再销毁触发器
function GoodExample1() {
    trigger t = CreateTrigger();
    triggeraction ta = TriggerAddAction(t, function () {
        BJDebugMsg("这个动作不会泄露");
    });
    TriggerExecute(t);

    // 关键步骤：先移除动作
    TriggerRemoveAction(t, ta);
    DestroyTrigger(t);

    // 清理句柄
    ta = null;
    t = null;
}
```

### 方法2：使用 Condition 代替 Action（推荐）

```jass
// ✅ 推荐：使用 Condition 代替 Action，不会泄露
function GoodExample2() {
    trigger t = CreateTrigger();
    TriggerAddCondition(t, Condition(function () {
        BJDebugMsg("使用 Condition 不会泄露");
        return true;  // Condition 必须返回 boolean
    }));
    TriggerEvaluate(t);  // 注意：Condition 用 Evaluate，Action 用 Execute
    DestroyTrigger(t);   // Condition 可以安全直接销毁
    t = null;
}
```

## 在 Zinc 结构体中的应用

### 结构体中的触发器管理

```jass
public struct MyStruct {
    private trigger myTrigger = null;
    private triggeraction myAction = null;

    // 创建触发器并添加动作
    method createTriggerWithAction() {
        this.myTrigger = CreateTrigger();
        this.myAction = TriggerAddAction(this.myTrigger, function () {
            // 动作逻辑
            BJDebugMsg("结构体触发器动作");
        });
    }

    // 安全销毁触发器
    method destroyTrigger() {
        if (this.myTrigger != null) {
            // 先移除动作
            if (this.myAction != null) {
                TriggerRemoveAction(this.myTrigger, this.myAction);
                this.myAction = null;
            }

            // 再销毁触发器
            DestroyTrigger(this.myTrigger);
            this.myTrigger = null;
        }
    }

    // 析构函数中调用
    method onDestroy() {
        this.destroyTrigger();
    }
}
```

### 使用 Condition 的推荐模式

```jass
public struct MyStruct {
    private trigger myTrigger = null;

    // 使用 Condition 模式（推荐）
    method createTriggerWithCondition() {
        this.myTrigger = CreateTrigger();
        TriggerAddCondition(this.myTrigger, Condition(function () {
            // 条件逻辑
            BJDebugMsg("结构体触发器条件");
            return true;
        }));
    }

    // 安全销毁（Condition 可以直接销毁）
    method destroyTrigger() {
        if (this.myTrigger != null) {
            DestroyTrigger(this.myTrigger);
            this.myTrigger = null;
        }
    }

    method onDestroy() {
        this.destroyTrigger();
    }
}
```

## 其他相关泄露问题

根据测试结论，还需要注意：

### 对话框事件泄露

```jass
// ❌ 错误：TriggerRegisterDialogEvent 会泄露
function BadDialogExample() {
    trigger t = CreateTrigger();
    dialog d = DialogCreate();

    TriggerRegisterDialogEvent(t, d);  // 会泄露！

    DialogDestroy(d);
    DestroyTrigger(t);  // 即使销毁触发器也会泄露
}
```

**解决方案**：对话框最好使用单例模式，避免频繁创建销毁。

### 单位事件正常排泄

```jass
// ✅ 正确：TriggerRegisterUnitEvent 能正常排泄
function GoodUnitEventExample() {
    trigger t = CreateTrigger();
    unit u = CreateUnit(Player(0), 'hfoo', 0, 0, 0);

    TriggerRegisterUnitEvent(t, u, EVENT_UNIT_DAMAGED);

    RemoveUnit(u);      // 删除单位
    DestroyTrigger(t);  // 销毁触发器，不会泄露
    u = null;
    t = null;
}
```

## 最佳实践总结

1. **优先使用 Condition**：`TriggerAddCondition` + `TriggerEvaluate` 不会泄露
2. **Action 必须手动移除**：使用 `TriggerAddAction` 时必须保存引用并用 `TriggerRemoveAction` 移除
3. **避免对话框事件**：`TriggerRegisterDialogEvent` 会泄露，使用单例模式
4. **单位事件安全**：`TriggerRegisterUnitEvent` 可以安全使用
5. **句柄清理**：所有句柄类型变量在函数结束前都要置 `null`

## 测试验证

可以使用以下命令测试泄露情况：

```
s3  // 测试 Action 泄露（会泄露）
s4  // 测试 Action 正确清理（不会泄露）
s5  // 测试对话框事件泄露（会泄露）
s6  // 测试单位事件（不会泄露）
```

## 参考实现

参考 `MemoryLeak_Test.j` 中的测试函数：
- `TTestUTMemoryLeak3`: 演示 Action 泄露
- `TTestUTMemoryLeak4`: 演示 Action 正确清理
- `TTestUTMemoryLeak5`: 演示对话框事件泄露
- `TTestUTMemoryLeak6`: 演示单位事件正常排泄
