---
name: xlimon-objeditor-map
description: War3Lib/Xlimon 物编生成与改造规范。用于在 War3Lib 的 `UnitTestMap/table`、`Jass/**/*.w3a|w3u|w3i`、项目内 `db`，或 Xlimon 的 `OriginMap/table` 中安全新增/修改对象；按当前仓库选择脚本与落点，重点处理 4 位 ID 去重（含大小写冲突）、主动技能通魔模板与唯一 OrderID、隐藏按钮位点写法，以及紧凑行尾注释风格。
---

# War3Lib/Xlimon 物编 Skill

按需读取：
- `references/workflow.md`
- `references/xlimon-workflow.md`
- `references/snippets.md`
- `references/templates-unit.md`
- `references/templates-unit-xlimon.md`
- `references/templates-ability.md`
- `references/templates-passive.md`
- `references/templates-spellbook.md`
- `scripts/check_obj_ids.py`
- `scripts/check_xlimon_obj_ids.py`

## 仓库分流（先判断再执行）

- 在 War3Lib 中：使用 `references/workflow.md`、`references/templates-unit.md` 与 `scripts/check_obj_ids.py`；落点为 `UnitTestMap/table`、`Jass/**/*.w3*` 或 `db`。
- 在 Xlimon 中：使用 `references/xlimon-workflow.md`、`references/templates-unit-xlimon.md` 与 `scripts/check_xlimon_obj_ids.py`；日常改动只落到 `OriginMap/table`，除非用户明确要求修改或诊断 `UnitTestMap/table`。
- 其余模板和 snippets 两边共用。不要用一边的默认路径或 Order 清单覆盖另一边。

## 执行流程

1. 先确认当前仓库，再从对应模板选择最接近的类型并定位目标对象文件。
2. 先分配 ID，再基于模板最小改动。新增前必须执行：
   - War3Lib：`python3 .codex/skills/xlimon-objeditor-map/scripts/check_obj_ids.py --id <ID>`
   - Xlimon：`python3 .codex/skills/xlimon-objeditor-map/scripts/check_xlimon_obj_ids.py --id <ID>`
3. 若是主动技能，优先使用“通魔”模板（通常 `_parent = "ANcl"`），并确保 `Order` / `DataF` 不与既有技能冲突。
4. War3Lib 从 `db/list/List_Order.ini`、Xlimon 从 `Other/List_Order.ini` 查可用命令字；把已使用项按现有习惯标记 `//`。
5. 需要隐藏图标时，允许使用按钮位点 bug（见 snippets）。
6. 生成时优先写紧凑格式：值后追加行尾注释 `-- 注释`，便于查阅。
7. 输出前再次运行检查脚本，确认无冲突后再提交修改。

## 路径约定

- 单测地图物编：`UnitTestMap/table/`
- 库内对象文件：`Jass/**/*.w3a`、`Jass/**/*.w3u`、`Jass/**/*.w3i`（以及同类 `.w3*`）
- 常用命令字清单：`db/list/List_Order.ini`
- 原生数据库参照：`db/`（项目内相对路径）
- Xlimon 主地图物编：`D:/War3/Maps/Xlimon/OriginMap/table/`
- Xlimon 单测地图物编：`D:/War3/Maps/Xlimon/UnitTestMap/table/`（默认只读，不随日常物编改动同步写入）
- Xlimon 命令字清单：`D:/War3/Maps/Xlimon/Other/List_Order.ini`

## 强约束

- 把 4 位对象 ID 视为大小写不敏感唯一键：`[A01a]` 与 `[A01A]` 视为冲突。
- 典型坑：`[AFBK]` 与原生技能 `[Afbk]` 大小写不敏感冲突；新增或重命名任何 4 位 ID 前必须运行对应仓库的检查脚本。
- 同时检查两类冲突：
  - 项目对象文件冲突（`UnitTestMap/table` + `Jass/**/*.w3*`）
  - 与项目 `db` 冲突（对应 ini 文件）
- 主动技能避免重复 `Order`，否则可能出现按键/命令冲突。
- 修改 `db/list/List_Order.ini` 时保留现有格式，不改动无关条目。
- Xlimon 对象的 `_parent` 必须能从原生模板链解析，禁止把项目自定义对象作为父对象；若出现 `w3x2lni ... frontend_merge.lua:155: assertion failed!`，优先检查最近新增对象的 `_parent`。

## 生成行为

- 默认先做“最小变更”：只新增/修改必要段落。
- 保持原有字段顺序与风格，不擅自大规模重排。
- 若检测环境缺少某路径，显式说明并继续处理可落地部分。
