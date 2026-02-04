## 单测文件布局（Xxx 模块）

目标：确保单测可被一键切换、可注入依赖、可复现执行。

### 1) `Xxx.j`

- 业务库本体。
- 暴露可测试的函数/方法（供 `cfg` 关键词引用）。

### 2) `Xxx.cfg`

建议结构：

```cfg
PublicFunc1
PublicFunc2
SomeStruct.

[chain]
../../base/Dep1.j
../math/Dep2.j
```

规则：

- `[chain]` 之前写注入关键词（通常是公开函数、公开结构体前缀如 `SomeStruct.`）。
- `[chain]` 之后写本库依赖的更基础库路径（相对路径）。
- 路径保持最短可读，不要重复注入同一库。

### 3) `Xxx_Test.j`

- 文件名固定 `_Test.j` 后缀。
- 由 `TaskCreateUT.lua` 从 `Jass/template/UTTemplate.j` 生成。
- 核心占位替换：
  - `{UnitTest}` -> `UTXxx`
  - `LibraryName` -> `Xxx`
  - 空 `#include` -> `#include "<Xxx.j完整路径>"`

### 4) 可选物编文件

- `Xxx.w3a`：技能对象数据
- `Xxx.w3u`：单位对象数据
- `Xxx.w3i`：物品对象数据

只在测试确实依赖对象编辑器数据时添加，避免无效物编噪声。
