---
name: zinc-unittest
description: 本项目 Zinc 单元测试/断言测试约定：命名限制、编译宏保护、聊天指令入口与注册方式（用于 .j 的 //! zinc 代码）。
---

# Zinc 单元测试与断言测试（本项目）

## 必须遵守

- **命名限制**：不要使用 `_` 开头的变量名/函数名。
- **编译宏保护**：所有测试相关代码必须包在 `#if (CURRENT_BUILD_VERSION != VERSION_RELEASE)`（或项目等价宏）内，避免进入正式版。
- **注册入口**：聊天指令注册与 `onInit` 中的测试注册同样需要宏保护。
- **输出与提示**：断言失败/测试完成时输出清晰的模块名与信息，方便定位。

## 推荐约定

- 测试函数命名：`<模块名>AssertTests` 或 `Test<功能名>`。
- 注册函数命名：`<模块名>RegisterChat` / `<模块名>RegisterTest`。
- 测试覆盖（override）只在宏保护内生效，执行完毕要把 override 状态恢复。

## References（按需加载）

- `references/examples.md`

