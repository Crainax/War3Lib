# 被动技能模板

## 最简约（无 CD）

```ini
[Amgr]
Name = "奇美拉之体" -- 名字
_parent = "Amgr"
Art = "ReplaceableTextures\\CommandButtons\\BTNChimaera.blp" -- 图标 - 普通
EditorSuffix = "" -- 编辑器后缀
Tip = "奇美拉之体" -- 提示工具 - 普通
Ubertip = "在自身HP低于50%时，攻击有8%几率封冻对方1s。" -- 提示工具 - 普通 - 扩展
```

## 可在代码层控制 CD（ANbr）

```ini
[AH15]
Name = "天赋技能模板" -- 名字
EditorSuffix = "(玩家1)" -- 编辑器后缀
_parent = "ANbr"
Animnames = "" -- 效果 - 施法动作
Area = 0.0 -- 影响区域
Art = "ReplaceableTextures\\PassiveButtons\\PASBTNEvasion.blp" -- 图标 - 普通
CasterArt = "" -- 效果 - 施法者
Cool = 0.0 -- 魔法施放时间间隔
Cost = 0 -- 魔法消耗
DataA = 0.0 -- 攻击增加
DataG = 1 -- 最大单位数量
Dur = 0.001 -- 持续时间 - 普通
HeroDur = 0.001 -- 持续时间 - 英雄
Tip = "闪避" -- 提示工具 - 普通
Ubertip = "有CD" -- 提示工具 - 普通 - 扩展
hero = 0 -- 英雄技能
levels = 1 -- 等级
race = "orc" -- 种族
targs = "none" -- 目标允许
```
