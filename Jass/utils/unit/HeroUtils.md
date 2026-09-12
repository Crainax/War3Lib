# 三维属性共享与自身贡献排除

旧 `SetUnitStr/Agi/IntDisabled(u, flag)` 的语义不变：启用时整个属性结果为 0，包括转入部分；原始账本仍能作为其他属性的共享来源。

新增 API 仅对 BigInteger 单位生效，默认关闭，不影响未使用新 API 的地图。

| 属性 | 设置自身贡献排除 | 查询 |
|---|---|---|
| 力量 | `SetUnitStrSelfExcluded(u, flag)` | `IsUnitStrSelfExcluded(u)` |
| 敏捷 | `SetUnitAgiSelfExcluded(u, flag)` | `IsUnitAgiSelfExcluded(u)` |
| 智力 | `SetUnitIntSelfExcluded(u, flag)` | `IsUnitIntSelfExcluded(u)` |

开启后，仅在计算该属性自身结果时排除它的基础数值、基础欠款、对应主/次属性数值与欠款、增幅/减幅及绿字。其他属性转入的这些贡献仍完整计算。自身原始账本不会修改，仍可共享给其他属性；关闭后恢复自身贡献。

旧 Disabled 优先级高于 SelfExcluded，两者互不写入或清除对方的状态。新设置接口在状态变化时通过 `heroAttrObserver` 通知目标属性刷新；查询接口只读，可供本地 UI 使用。

共享只读取各来源的原始贡献，不递归传递，不把已经转入的部分再次转出。倍率保持原有公式：先汇总参与来源的基础值及增幅，再应用减幅和绿字；排除自身倍率时，增幅从 0、减幅乘积从 1 开始。

例如原始力敏智各 300（无其他增益）：

```c
SetUnitAgiShareToStr(u, true);
SetUnitIntShareToStr(u, true);
SetUnitAgiShareToInt(u, true);
SetUnitAgiSelfExcluded(u, true);
SetUnitIntSelfExcluded(u, true);
// GetUnitStr(u) = 900，GetUnitAgi(u) = 0，GetUnitInt(u) = 300。
```

兼容方式：旧地图继续使用原有 Disabled/Share API；需要新规则的地图主动调用 SelfExcluded API。无需用地图构建模式或分支名称改变 API 的默认行为。

测试位于 `HeroUtils_Test.j` 的 `Test_SelfExcludedConversion` 与 `Test_SelfExcludedLayersAndDebt`，覆盖恢复、持续增长、旧禁用优先级、主/次属性切换、倍率、绿字、欠款及双向共享。已接入自动测试及 `s10` 全量测试入口；编译通过不代表已在游戏内执行断言。
