# 单位模板（召唤物/怪物）

```ini
[nlv1]
Name = "|cff0000ff精灵|r" -- 名字
_parent = "nlv1"
Art = "ReplaceableTextures\\CommandButtons\\BTNAMR5.blp" -- 图标 - 游戏界面
HP = 1 -- 生命最大值
Ubertip = "" -- 提示工具 - 扩展
abilList = "" -- 普通
acquire = 900.0000 -- 主动攻击范围
atkType1 = "hero" -- 攻击 1 - 攻击类型
bountydice = 0 -- 黄金奖励 - 骰子数量
bountyplus = 0 -- 黄金奖励 - 基础值
bountysides = 0 -- 黄金奖励 - 骰子面数
collision = 16.0000 -- 碰撞体积
cool1 = 1.0000 -- 攻击 1 - 攻击间隔
def = 0.0000 -- 基础护甲
defType = "hero" -- 护甲类型
dmgplus1 = 1 -- 攻击 1 - 基础伤害
dmgpt1 = 0.4000 -- 攻击 1 - 动画伤害点
fused = 0 -- 占用人口
points = 5 -- 单位附加值
rangeN1 = 600 -- 攻击 1 - 攻击范围
regenHP = 0.0000 -- 生命回复
scale = 1.0000 -- 选择缩放
-- file = "hero\\umr5.mdl" -- 模型文件
-- Missileart_1 = "missile\\aimiliya.mdl" -- 攻击 1 - 投射物图像
-- Missilespeed_1 = 1200 -- 攻击 1 - 射弹速率
-- shadowH = 100.0000 -- 阴影图像 - 高度
-- shadowW = 100.0000 -- 阴影图像 - 宽度
-- shadowX = 50.0000 -- 阴影图像 - X轴偏移
-- shadowY = 50.0000 -- 阴影图像 - Y轴偏移
-- unitSound = "Wisp" -- 单位声音设置
-- weapTp1 = "missile" -- 攻击 1 - 武器类型
-- weapType1 = "" -- 攻击 1 - 武器声音
sides1 = 1 -- 攻击 1 - 伤害骰子面数
targs1 = "ground,structure,debris,air,ward" -- 攻击 1 - 目标允许
weapsOn = 1 -- 允许攻击模式
canFlee = 1 -- 可以逃跑
canSleep = 0 -- 允许睡眠
```

## 单位特效马甲模板

用于需要精确移除显示的模型面板或短期特效单位。若模型本身已经按实际范围建模，`modelScale` 保持 `1.0000`；否则再按目标显示大小调整。

```ini
[uJD0]
Name = "特效-用途名" -- 名字
_parent = "hpea"
Builds = "" -- 可建造建筑
HP = 100 -- 生命最大值
Specialart = "" -- 特殊效果
abilList = "Aloc,Avul" -- 普通
canFlee = 0 -- 可以逃跑
cargoSize = 0 -- 运输尺寸
collision = 0.0000 -- 碰撞体积
death = 2.0000 -- 死亡时间(秒)
file = "effects\\your_effect.mdl" -- 模型文件
fused = 0 -- 占用人口
hideOnMinimap = 1 -- 隐藏小地图显示
maxPitch = 25.0000 -- X轴最大旋转角度(弧度)
maxRoll = 25.0000 -- Y轴最大旋转角度(弧度)
modelScale = 1.0000 -- 模型缩放
movetp = "" -- 类型
nsight = 0 -- 视野范围(夜晚)
points = 0 -- 单位附加值
regenHP = 0.0000 -- 生命回复
scale = 0.1000 -- 选择缩放
shadowH = 0.0000 -- 阴影图像 - 高度
shadowW = 0.0000 -- 阴影图像 - 宽度
shadowX = 0.0000 -- 阴影图像 - X轴偏移
shadowY = 0.0000 -- 阴影图像 - Y轴偏移
sight = 0 -- 视野范围(白天)
spd = 0 -- 基础速度
stockMax = 0 -- 最大库存量
stockRegen = 0 -- 雇佣时间间隔
type = "standon" -- 单位类别
unitShadow = "" -- 阴影图像(单位)
unitSound = "" -- 单位声音设置
upgrades = "" -- 使用科技
weapsOn = 0 -- 允许攻击模式
```
