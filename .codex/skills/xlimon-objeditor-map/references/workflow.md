# War3Lib 物编工作流

## 1) 先选模板，再选文件

- 优先读取 skill 内置模板，按需求选择：
  - 召唤物/怪物（单位模板）
  - 主动技能-无目标
  - 主动技能-点目标
  - 被动技能-最简约（无 CD）
  - 被动技能-可代码控 CD（`ANbr`）
  - 魔法书模板（`Aspb`）

模板位置：
- `references/templates-unit.md`
- `references/templates-ability.md`
- `references/templates-passive.md`
- `references/templates-spellbook.md`

War3Lib 中优先落到对象源文件：

- 技能：`Jass/**/*.w3a`
- 单位：`Jass/**/*.w3u`
- 地图信息/测试注入：`Jass/**/*.w3i` 或 `UnitTestMap/table/w3i.ini`

如需单测地图注入，再落到 `UnitTestMap/table`：

- 技能：`ability.ini`
- 单位：`unit.ini`
- 物品：`item.ini`
- Buff：`buff.ini`
- 升级：`upgrade.ini`
- 其他对象按现有目录对应文件落地

## 2) 先查 ID 再写段落

执行：

```bash
python3 .codex/skills/xlimon-objeditor-map/scripts/check_obj_ids.py --id A01a
```

必要时批量检查：

```bash
python3 .codex/skills/xlimon-objeditor-map/scripts/check_obj_ids.py --id A01a --id A01b --id A01c
```

规则：
- 4 位字母数字
- 大小写不敏感唯一（`A01a` 与 `A01A` 冲突）

## 3) 主动技能模板与 OrderID

- 主动技能默认从“通魔”模板起步（通常 `_parent = "ANcl"`）。
- 无目标主动：保留 `DataC = 1`，按模板改 `Order/DataF/Tip/Ubertip`。
- 点目标主动：注意 `DataB/DataC/Rng/targs`；`DataC = 3` 可显示范围圈。
- `Order` 与 `DataF` 统一使用同一个命令字，并保持唯一。
- 可先查并校验 Order：

```bash
python3 .codex/skills/xlimon-objeditor-map/scripts/check_obj_ids.py --order rainofchaos
```

从 `db/list/List_Order.ini` 维护使用状态：
- 行尾有 `//` 视为“已使用”
- 新占用后按你的习惯补 `//`

## 4) 原生数据冲突检查

脚本默认使用项目内相对路径 `db/` 作为 db 根目录。

也可手动覆盖：

```bash
python3 .codex/skills/xlimon-objeditor-map/scripts/check_obj_ids.py \
  --db-root ./db \
  --id A01a
```

## 5) 注释风格

- 优先紧凑行尾注释：`字段 = 值 -- 注释`
- 保持与现有文件一致，不做无关格式化
