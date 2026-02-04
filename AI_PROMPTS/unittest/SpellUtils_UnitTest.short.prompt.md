# SpellUtils 单测 Prompt（短精简版）

你是 War3Lib 的 Zinc 单元测试工程师。请参照 `SpellUtils` 的现有方案，为目标 `Jass/.../Xxx.j` 创建/重构单测。

## 输入

- 目标模块：`Jass/.../Xxx.j`

## 必做

1. 先走脚本生成测试壳（不要手写空文件）：
- `bash .codex/skills/zinc-unittest/scripts/create_ut.sh Jass/.../Xxx.j`

2. 产出并完善以下文件：
- `Jass/.../Xxx_Test.j`
- `Jass/.../Xxx.cfg`
- 按需：`Jass/.../Xxx.w3a` / `Jass/.../Xxx.w3u` / `Jass/.../Xxx.w3i`

3. `_Test.j` 保留模板结构：
- `library UTXxx requires Xxx,...`
- `Init()` + `UnitTestAutoTimer`
- `TTestUTXxx1..10`
- `TTestActUTXxx1`
- `onInit()` 注册 `s1..s10` 与 `-参数`

4. 断言/日志规范：
- 可验证行为必须用 `assert.Boolean/Integer/Real/String`
- 中间值与调试信息用 `Trace(...)`
- 失败信息统一带前缀：`[Xxx]`

5. `Xxx.cfg` 规范：
- `[chain]` 前：公开 API 注入关键词（函数/结构体前缀）
- `[chain]` 后：底层依赖链（递归注入）

## 参考基准（SpellUtils）

- `Jass/utils/ability/SpellUtils.j`
- `Jass/utils/ability/SpellUtils_Test.j`
- `Jass/utils/ability/SpellUtils.cfg`
- `Jass/utils/ability/SpellUtils.w3a`
- `Jass/test/UnitTestFramework.j`
- `Lua/tasks/TaskCreateUT.lua`

## 输出格式

1. 直接给出修改后的文件内容（不是只提建议）。
2. 列出新增/修改文件路径。
3. 每个测试函数写一句“测试目标”。
4. 说明是否新增物编以及原因。
