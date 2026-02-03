## 单元测试/断言测试示例（精简）

### 宏保护

```jass
#if (CURRENT_BUILD_VERSION != VERSION_RELEASE)
// 测试代码放这里
#endif
```

### 聊天指令入口（示例）

```jass
#if (CURRENT_BUILD_VERSION != VERSION_RELEASE)
private function ContRegisterChat() {
    UnitTestRegisterChatEvent(function () {
        string s = GetEventPlayerChatString();
        if (s == "qdt") {
            ContAssertTests(GetTriggerPlayer());
        }
    });
}
#endif
```

### onInit 中注册（示例）

```jass
function onInit() {
    #if (CURRENT_BUILD_VERSION != VERSION_RELEASE)
    ContRegisterChat();
    #endif
}
```

