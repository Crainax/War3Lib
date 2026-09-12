## 单测文件布局（Xlimon / Xxx 模块）

目标：确保单测可被一键切换、可注入依赖、可复现执行。

### 1) `Xxx.j`

- 业务库本体。
- 暴露可测试的函数/方法（供 `cfg` 关键词引用）。

### 2) `Xxx_Test.j`

- 文件名固定 `_Test.j` 后缀。
- 可由 `.codex/skills/zinc-unittest/scripts/create_ut.sh` 生成。
- 典型结构：
  - `#ifndef UTXxxIncluded` 头保护
  - `#include "D:/War3/Maps/Xlimon/edit/.../Xxx.j"`
  - `library UTXxx requires Xxx { ... }`
  - `TTestUTXxx1..10` + `TTestActUTXxx1` + `onInit` 注册

### 3) `edit/config/UnitTest.h`

- 运行入口切换文件。
- `#include` 只保留一个当前测试文件，例如：

```jass
#include "D:/War3/Maps/Xlimon/edit/unit/Attr_Test.j"
```

### 4) `Xxx.cfg`（可选，通常不需要）

- 仅在你明确需要做“库依赖注入”时再创建。
- 大部分 Xlimon 业务模块单测可直接跳过。

### 5) 可选物编文件

- `Xxx.w3a`：技能对象数据
- `Xxx.w3u`：单位对象数据
- `Xxx.w3i`：物品对象数据

只在测试确实依赖对象编辑器数据时添加，避免无效物编噪声。
