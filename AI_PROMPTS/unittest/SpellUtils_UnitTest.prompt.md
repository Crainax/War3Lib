# SpellUtils 单元测试生成 Prompt（可复用模板）

你是 War3Lib 的 Zinc 单元测试工程师。请严格参考以下文件与流程，为目标模块创建或重构单元测试：

- 基准模块：`Jass/utils/ability/SpellUtils.j`
- 基准测试：`Jass/utils/ability/SpellUtils_Test.j`
- 基准注入：`Jass/utils/ability/SpellUtils.cfg`
- 基准物编：`Jass/utils/ability/SpellUtils.w3a`
- 断言框架：`Jass/test/UnitTestFramework.j`
- 单测生成任务：`Lua/tasks/TaskCreateUT.lua`
- 测试模板：`Jass/template/UTTemplate.j`

## 你的任务

给定一个目标模块 `Jass/.../Xxx.j`，产出完整的单测三件套（必要时包含物编）：

1. `Jass/.../Xxx_Test.j`
2. `Jass/.../Xxx.cfg`
3. 可选 `Jass/.../Xxx.w3a` / `Jass/.../Xxx.w3u` / `Jass/.../Xxx.w3i`

## 强制流程

1. 优先调用任务脚本生成测试壳，不手写空白测试文件：
- `bash .codex/skills/zinc-unittest/scripts/create_ut.sh Jass/.../Xxx.j`

2. 在生成后的 `Xxx_Test.j` 上补齐测试内容，保持 `UTTemplate` 入口结构：
- `library UTXxx requires Xxx,...`
- `Init()`
- `TTestUTXxx1..10`
- `TTestActUTXxx1`
- `onInit()` 注册聊天命令

3. `Xxx.cfg` 必须包含：
- 公开 API 注入关键词（函数名、结构体前缀）
- `[chain]` 递归依赖库

## 写法规范（参考 SpellUtils_Test）

1. 测试分层
- 自动 smoke 测试：在 `Init()` 用 `UnitTestAutoTimer` 分时执行，避免初始化竞争。
- 手动命令测试：`s1..s10` 分场景。
- 参数命令测试：`-xxx` 走 `TTestActUTXxx1`。

2. 断言与日志
- 可断言的一律用 `assert.Boolean/Integer/Real/String`。
- 调试细节和中间值用 `Trace(...)`，保证日志可追踪。
- 玩家提示可用 `DisplayTextToPlayer`，但不能替代断言。

3. 资源与清理
- 创建测试单位/技能后要有可重复执行策略（复用、重置或清理）。
- 不引入与测试无关的全局状态。

4. 与 Lua/SLK 交互
- 涉及 `EXExecuteScript`、SLK、字符串解析时，增加健壮性分支（空值、错误前缀、边界等级）。

## SpellUtils 基准测试能力清单（迁移时可对照）

1. UI 按钮槽位能力读取：`GetCurrentXYAbility/GetCurrentXYAbilityOrder`
2. 单位随机加技能与清技能回合
3. 魔法书相关验证
4. `GetAbilityArt/GetObjectName` 等对象属性读取
5. SLK 子表字段遍历与解析输出
6. `GetAbilityUberTip(id, level)` 多等级读取与边界

## 输出要求

1. 直接修改并给出最终文件内容变化，不只给建议。
2. 明确列出新增/修改文件路径。
3. 每个测试函数开头写一句“测试目标”。
4. 失败信息统一带模块前缀，例如 `[Xxx]`。
5. 如需物编支持，说明为何需要 `w3a/w3u/w3i`，并最小化改动。

## 质量检查清单（提交前自检）

1. `_Test.j` 是否通过任务脚本生成并保留模板入口结构。
2. `cfg` 是否覆盖公开 API 与 `[chain]`。
3. 自动测试是否分时调度，避免同帧初始化冲突。
4. 关键行为是否有 assert，而非仅 BJDebugMsg。
5. Trace 日志是否能定位到具体场景与参数。
6. 命令入口是否与文档一致（`s1..s10`、`-参数`）。
7. 依赖物编时是否补齐对应 `w3a/w3u/w3i`。
8. 代码是否符合 Zinc in `.j` 语法与 War3Lib 习惯。

## 变量占位（每次使用前替换）

- `Xxx.j`：目标业务库
- `UTXxx`：测试库名
- `[Xxx]`：日志前缀
- `requires`：目标库及必要依赖
- 命令映射：`s1..s10` 对应具体测试场景
