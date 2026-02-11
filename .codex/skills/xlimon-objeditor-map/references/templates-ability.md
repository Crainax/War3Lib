# 主动技能模板

## 无目标（通魔）

```ini
[A000]
Name = "切换背包" -- 名字
_parent = "ANcl"
Animnames = "spell,slam" -- 效果 - 施法动作
Art = "ReplaceableTextures\\CommandButtons\\BTNAJB3.blp" -- 图标 - 普通
Buttonpos_1 = 1 -- 按钮位置 - 普通 (X)
Buttonpos_2 = 1 -- 按钮位置 - 普通 (Y)
Requires = "R008" -- 需求
CasterArt = "" -- 效果 - 施法者
Casterattach = "" -- 效果 - 施法者附加点1
Cool = 10 -- 魔法施放时间间隔
Cost = 10 -- 魔法消耗
DataA = 0.0000 -- 施法持续时间
DataC = 1 -- 选项
DataD = 0.0000 -- 动作持续时间
DataE = 0 -- 使其他技能无效
DataF = "rainofchaos" -- 基础命令ID
Hotkey = "D" -- 热键 - 普通
Order = "rainofchaos" -- 命令串 - 使用/打开
Rng = 0.0000 -- 施法距离
Tip = "切换背包(|cffffcc00D|r)" -- 提示工具 - 普通
Ubertip = "当前为背包1,点击切换为背包2." -- 提示工具 - 普通 - 扩展
hero = 0 -- 英雄技能
levels = 1 -- 等级
```

## 点目标（通魔）

说明：`DataC = 3` 时预选位置显示范围圈；`DataC = 1` 为普通点目标。

```ini
[A000]
Name = "切换背包" -- 名字
_parent = "ANcl"
Animnames = "spell,throw" -- 效果 - 施法动作
Art = "ReplaceableTextures\\CommandButtons\\BTNAJB3.blp" -- 图标 - 普通
Buttonpos_1 = 1 -- 按钮位置 - 普通 (X)
Buttonpos_2 = 1 -- 按钮位置 - 普通 (Y)
CasterArt = "" -- 效果 - 施法者
Casterattach = "" -- 效果 - 施法者附加点1
Cool = 10 -- 魔法施放时间间隔
Cost = 10 -- 魔法消耗
DataA = 0.0000 -- 施法持续时间
DataB = 1 -- 目标类型
DataC = 1 -- 选项
DataD = 0.0000 -- 动作持续时间
DataE = 0 -- 使其他技能无效
DataF = "rainofchaos" -- 基础命令ID
EffectArt = "" -- 效果 - 目标点
Rng = 600.0000 -- 施法距离
Hotkey = "D" -- 热键 - 普通
TargetArt = "" -- 效果 - 目标
Order = "rainofchaos" -- 命令串 - 使用/打开
Tip = "切换背包(|cffffcc00D|r)" -- 提示工具 - 普通
Ubertip = "当前为背包1,点击切换为背包2." -- 提示工具 - 普通 - 扩展
levels = 1 -- 等级
hero = 0 -- 英雄技能
targs = "ground,mechanical,structure,vulnerable,air,friend,organic,self" -- 目标允许
```
