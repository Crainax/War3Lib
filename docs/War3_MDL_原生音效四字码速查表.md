# Warcraft III MDL 原生 Sound Event 四字码速查表

> 适用范围：Warcraft III / The Frozen Throne 经典模型 MDL/MDX 的 **Sound Event Object**。这里整理的是模型里 `SNDxYYYY` 使用的 4 字符声音事件码，不是 World Editor 声音编辑器里所有可播放 WAV/MP3 文件的完整文件路径清单。

## MDL 里怎么写

声音事件的 8 字符对象名格式通常是：

```mdl
EventObject "SNDxAOSH" {
    ObjectId 123,
    EventTrack 1 {
        0,
    }
}
```

- `SND`：表示 Sound Event。
- `x`：占位字符，可用来区分同模型里的多个事件对象。
- `AOSH`：真正的 4 字符声音事件码；例如 `SNDxAOSH` 就是 ShockWave。
- 注意：同一个 4 字符码可能也会出现在脚印/血迹/地基/衍生物表里，**前缀不同含义不同**。例如 `DHLB` 作为声音要写 `SNDxDHLB`，作为 UberSplat 则是另一类事件。

## 快速常用推荐

| 用途 | 推荐代码 | 备注 |
|---|---|---|
| 冲击/地裂 | `AOSH / AHTC / AOWS / AUIM / AUIH / AUIT / AWRS` | 冲击波、雷霆一击、战争践踏、穿刺、粉碎；适合地裂/震荡/近战大招。 |
| 电流/雷法 | `AHMF / AOLB / ACLB / AHTB / AHSL / ALSD / ANMO` | 法力闪耀偏滋滋电流感；闪电打击/电影闪电打击更像直击闪电。 |
| 火焰/爆燃 | `AHFS / AHFT / ACBC / MFRB / MFRL / MFLA / MFLL / DGLM / DGSP` | 烈焰风暴、火焰吐息、火球、灼热箭、地雷/自爆。 |
| 冰霜/水流 | `ACBF / ACCV / ACWD / AUFN / AUFA / MFBL / MFBH / MFAH / MFAL` | 冰霜吐息、粉碎波、霜冻新星、霜甲、霜冻弹/箭。 |
| 暗影/亡灵 | `AUDC / AUDA / AUDT / ASHP / ACRS / ACRI / ANDO / APSL / APSH` | 死亡缠绕、黑暗仪式、死亡凋零、暗影契约、诅咒/残废/末日/占据。 |
| 召唤/出生 | `AINB / ASWB / ASWE / APHX / APXB / AOAG / AHWD / ASTB / AUCB` | 地狱火、水元素、狼魂、凤凰/凤凰蛋、守卫/图腾、圣甲虫生成。 |
| 建筑爆炸 | `DHLB / DHLS / DOLB / DOLS / DULB / DULS / DELB / DELS / DNBL / DCBL` | 不同阵营建筑倒塌/爆炸；大建筑用 *LB，小建筑用 *LS。 |
| 炮弹/远程命中 | `MMTI / MCAT / KCAT / KMT1 / KMT2 / MMEA / MARR / MAXE / MBAL` | 迫击炮、投石车、绞肉车、箭矢、斧头、弩车等。 |

## 全表（532 条）

| 简写 | MDL事件名 | SoundAlias | 类型 | 简单描述/用途 |
|---|---|---|---|---|
| `FBCL` | `SNDxFBCL` | `TestFootstep` | 脚步/移动 | 测试脚步声；通常不作为技能音效使用。 |
| `FBCR` | `SNDxFBCR` | `TestFootstep` | 脚步/移动 | 测试脚步声；通常不作为技能音效使用。 |
| `AAMS` | `SNDxAAMS` | `AntiMagicshell` | 技能/法术 | 反魔法外壳/魔法护盾开启音效。 |
| `AAST` | `SNDxAAST` | `AncestralSpirit` | 技能/法术 | 先祖之魂/复活类巫术音效。 |
| `AAVE` | `SNDxAAVE` | `ObsidianStatueMorph` | 技能/法术 | 黑曜石像变形/切换形态音效。 |
| `ABLO` | `SNDxABLO` | `Bloodlust` | 技能/法术 | 嗜血术施放/加速增益音效。 |
| `ABPD` | `SNDxABPD` | `BothGlueScreenPopDown` | 界面/剧情 | 界面双侧弹窗收起音效。 |
| `ABPU` | `SNDxABPU` | `BothGlueScreenPopUp` | 界面/剧情 | 界面双侧弹窗弹出音效。 |
| `ABRW` | `SNDxABRW` | `Burrow` | 技能/法术 | 钻地/潜入地下音效。 |
| `ABSK` | `SNDxABSK` | `BerserkerRage` | 技能/法术 | 狂战士怒吼/狂暴启动音效。 |
| `ABTR` | `SNDxABTR` | `BattleRoar` | 技能/法术 | 战吼/咆哮类增益音效。 |
| `ACAN` | `SNDxACAN` | `Cannibalize` | 技能/法术 | 食尸/吞食尸体音效。 |
| `ACBC` | `SNDxACBC` | `BreathOfFire` | 技能/法术 | 火焰吐息音效。 |
| `ACBF` | `SNDxACBF` | `BreathOfFrost` | 技能/法术 | 冰霜吐息音效。 |
| `ACCV` | `SNDxACCV` | `CrushingWave` | 技能/法术 | 粉碎波/水浪发出音效。 |
| `ACWD` | `SNDxACWD` | `CrushingWaveDamage` | 技能/法术 | 粉碎波/水浪命中伤害音效。 |
| `ACLB` | `SNDxACLB` | `CinematicLightningBolt` | 技能/法术 | 电影/剧情用闪电打击音效。 |
| `ACRH` | `SNDxACRH` | `CorrosiveBreathMissileHit` | 弹道/远程 | 腐蚀吐息弹道命中音效。 |
| `ACRI` | `SNDxACRI` | `Cripple` | 技能/法术 | 残废/削弱施法音效。 |
| `ACRL` | `SNDxACRL` | `CorrosiveBreathMissileLaunch` | 弹道/远程 | 腐蚀吐息弹道发射音效。 |
| `ACRS` | `SNDxACRS` | `Curse` | 技能/法术 | 诅咒施法音效。 |
| `ACSI` | `SNDxACSI` | `Silence` | 技能/法术 | 沉默施法/范围静默音效。 |
| `ACSL` | `SNDxACSL` | `CreepSleep` | 技能/法术 | 野怪睡眠/入睡音效。 |
| `ACYB` | `SNDxACYB` | `CycloneBirth` | 技能/法术 | 龙卷风生成音效。 |
| `ACYD` | `SNDxACYD` | `CycloneDeath` | 死亡/爆炸 | 龙卷风消失音效。 |
| `ADEF` | `SNDxADEF` | `Defend` | 技能/法术 | 步兵防御姿态切换音效。 |
| `FDFL` | `SNDxFDFL` | `DeepFootstep` | 脚步/移动 | 厚重/大型单位脚步声。 |
| `FDFR` | `SNDxFDFR` | `DeepFootstep` | 脚步/移动 | 厚重/大型单位脚步声。 |
| `FDSL` | `SNDxFDSL` | `FiendStep` | 脚步/移动 | 地穴恶魔/爬行类脚步声。 |
| `FDSR` | `SNDxFDSR` | `FiendStep` | 脚步/移动 | 地穴恶魔/爬行类脚步声。 |
| `FHCL` | `SNDxFHCL` | `HeroCinematicStep` | 脚步/移动 | 英雄电影镜头脚步声。 |
| `FHCR` | `SNDxFHCR` | `HeroCinematicStep` | 脚步/移动 | 英雄电影镜头脚步声。 |
| `ADCM` | `SNDxADCM` | `DruidOfTheClawMorph` | 技能/法术 | 利爪德鲁伊变熊音效。 |
| `ADCA` | `SNDxADCA` | `DruidOfTheClawMorphAlternate` | 技能/法术 | 利爪德鲁伊变回/备用形态音效。 |
| `ADEV` | `SNDxADEV` | `Devour` | 技能/法术 | 吞噬目标音效。 |
| `ADHM` | `SNDxADHM` | `DemonHunterMorph` | 技能/法术 | 恶魔猎手恶魔变身音效。 |
| `ADIS` | `SNDxADIS` | `DispelMagic` | 技能/法术 | 驱散魔法音效。 |
| `ADTM` | `SNDxADTM` | `DruidOfTheTalonMorph` | 技能/法术 | 猛禽德鲁伊变鸟音效。 |
| `ADTA` | `SNDxADTA` | `DruidOfTheTalonMorphAlternate` | 技能/法术 | 猛禽德鲁伊变回/备用形态音效。 |
| `ADVP` | `SNDxADVP` | `DevourPuke` | 技能/法术 | 吞噬后吐出单位/残渣音效。 |
| `AEAT` | `SNDxAEAT` | `EatTreeMunch` | 技能/法术 | 吃树咀嚼音效。 |
| `AEBA` | `SNDxAEBA` | `Barkskin` | 技能/法术 | 树皮术/木质护甲增益音效。 |
| `AEBD` | `SNDxAEBD` | `Earthbind` | 技能/法术 | 地缚/网住目标音效。 |
| `AEBL` | `SNDxAEBL` | `BlinkCaster` | 技能/法术 | 闪烁施法者端音效。 |
| `AEBT` | `SNDxAEBT` | `BlinkTarget` | 技能/法术 | 闪烁落点端音效。 |
| `AHDR` | `SNDxAHDR` | `SiphonManaCaster` | 技能/法术 | 吸魔法/抽魔施法者端音效。 |
| `AHEA` | `SNDxAHEA` | `Heal` | 技能/法术 | 普通治疗音效。 |
| `AHER` | `SNDxAHER` | `LevelUp` | 技能/法术 | 英雄升级音效。 |
| `AHFS` | `SNDxAHFS` | `FlameStrike` | 技能/法术 | 烈焰风暴施放/引燃音效。 |
| `AHFT` | `SNDxAHFT` | `FlameStrikeTarget` | 技能/法术 | 烈焰风暴目标区域燃烧音效。 |
| `AHHB` | `SNDxAHHB` | `HolyBolt` | 技能/法术 | 圣光/神圣弹命中音效。 |
| `AHMC` | `SNDxAHMC` | `MarkOfChaos` | 技能/法术 | 混乱标记/混乱化音效。 |
| `AHMF` | `SNDxAHMF` | `ManaFlareMissile` | 弹道/远程 | 魔力之焰/法力闪耀弹道音效；偏滋滋电流感。 |
| `AHMT` | `SNDxAHMT` | `MassTeleport` | 技能/法术 | 群体传送音效。 |
| `AHRE` | `SNDxAHRE` | `Resurrect` | 技能/法术 | 复活术音效。 |
| `AHRV` | `SNDxAHRV` | `ReviveHuman` | 技能/法术 | 人族英雄复活音效。 |
| `AHTB` | `SNDxAHTB` | `StormBolt` | 技能/法术 | 风暴之锤命中/重击音效。 |
| `AHSL` | `SNDxAHSL` | `StormBoltLaunch` | 技能/法术 | 风暴之锤发射音效。 |
| `AHTC` | `SNDxAHTC` | `ThunderClap` | 技能/法术 | 雷霆一击/地面震荡音效。 |
| `AHWD` | `SNDxAHWD` | `HealingWardBirth` | 技能/法术 | 治疗守卫生成音效。 |
| `AICB` | `SNDxAICB` | `OrbOfCorruptionLaunch` | 技能/法术 | 腐蚀之球发射音效。 |
| `AICH` | `SNDxAICH` | `OrbOfCorruptionHit` | 技能/法术 | 腐蚀之球命中音效。 |
| `AIDC` | `SNDxAIDC` | `NeutralizationWandHit` | 技能/法术 | 中和/驱散类魔杖命中音效。 |
| `AILL` | `SNDxAILL` | `ItemIllusion` | 技能/法术 | 幻象物品/镜像生成音效。 |
| `AIMA` | `SNDxAIMA` | `ManaPotion` | 技能/法术 | 使用魔法药水音效。 |
| `AINB` | `SNDxAINB` | `InfernalBirth` | 技能/法术 | 地狱火陨落/生成音效。 |
| `AINF` | `SNDxAINF` | `InnerFire` | 技能/法术 | 心灵之火增益音效。 |
| `AIRE` | `SNDxAIRE` | `RestorationPotion` | 技能/法术 | 恢复药水使用音效。 |
| `AISO` | `SNDxAISO` | `SoulGem` | 技能/法术 | 灵魂宝石/摄魂类物品音效。 |
| `AITM` | `SNDxAITM` | `Tome` | 技能/法术 | 拾取/阅读书本音效。 |
| `AIVS` | `SNDxAIVS` | `Invisibility` | 技能/法术 | 隐身/进入隐形音效。 |
| `AKDL` | `SNDxAKDL` | `KodoDrumLeft` | 技能/法术 | 科多战鼓左鼓点。 |
| `AKDR` | `SNDxAKDR` | `KodoDrumRight` | 技能/法术 | 科多战鼓右鼓点。 |
| `ALPD` | `SNDxALPD` | `LeftGlueScreenPopDown` | 界面/剧情 | 界面左侧弹窗收起音效。 |
| `ALPU` | `SNDxALPU` | `LeftGlueScreenPopUp` | 界面/剧情 | 界面左侧弹窗弹出音效。 |
| `ALSD` | `SNDxALSD` | `LightningShield` | 技能/法术 | 闪电护盾启动/环绕电流音效。 |
| `ANBA` | `SNDxANBA` | `BlackArrowHit` | 技能/法术 | 黑暗之箭命中音效。 |
| `ANDO` | `SNDxANDO` | `DoomTarget` | 技能/法术 | 末日目标/诅咒降临音效。 |
| `ANDT` | `SNDxANDT` | `RevealMap` | 技能/法术 | 显示地图/侦察揭示音效。 |
| `ANEU` | `SNDxANEU` | `NeutralBuildingActivate` | 技能/法术 | 中立建筑激活/交互音效。 |
| `ANHT` | `SNDxANHT` | `HowlOfTerror` | 技能/法术 | 恐怖嚎叫音效。 |
| `ANMO` | `SNDxANMO` | `MonsoonBolt` | 技能/法术 | 季风闪电/雷雨打击音效。 |
| `ANPA` | `SNDxANPA` | `Parasite` | 技能/法术 | 寄生虫/寄生施法音效。 |
| `ANSA` | `SNDxANSA` | `SacrificeUnit` | 技能/法术 | 牺牲单位音效。 |
| `ANSD` | `SNDxANSD` | `StrongDrink` | 技能/法术 | 熊猫酒/烈酒饮用音效。 |
| `ANSM` | `SNDxANSM` | `StrongDrinkMissile` | 弹道/远程 | 烈酒投掷/酒液弹道音效。 |
| `ANSS` | `SNDxANSS` | `SpellShieldAmulet` | 技能/法术 | 法术护盾护符触发音效。 |
| `AOAG` | `SNDxAOAG` | `WardBirth` | 技能/法术 | 守卫/图腾生成音效。 |
| `AOCR` | `SNDxAOCR` | `CriticalStrike` | 技能/法术 | 致命一击/暴击切砍音效。 |
| `AOHW` | `SNDxAOHW` | `HealingWaveTarget` | 技能/法术 | 治疗波跳跃到目标音效。 |
| `AOLB` | `SNDxAOLB` | `LightningBolt` | 技能/法术 | 闪电链/闪电箭打击音效。 |
| `AOMI` | `SNDxAOMI` | `MirrorImageDeath` | 死亡/爆炸 | 镜像死亡/破碎消失音效。 |
| `AOMC` | `SNDxAOMC` | `MirrorImage` | 技能/法术 | 镜像术生成音效。 |
| `AORE` | `SNDxAORE` | `Reincarnation` | 技能/法术 | 重生/复活触发音效。 |
| `AORV` | `SNDxAORV` | `ReviveOrc` | 技能/法术 | 兽族英雄复活音效。 |
| `AOSD` | `SNDxAOSD` | `FeralSpiritDone` | 技能/法术 | 野性狼魂召唤完成音效。 |
| `AOSF` | `SNDxAOSF` | `FeralSpiritTarget` | 技能/法术 | 野性狼魂目标/生成点音效。 |
| `AOSH` | `SNDxAOSH` | `ShockWave` | 技能/法术 | 冲击波发出/地面推进音效。 |
| `AOVD` | `SNDxAOVD` | `VoodooBirth` | 技能/法术 | 巫毒/大巫毒生成音效。 |
| `AOWS` | `SNDxAOWS` | `Warstomp` | 技能/法术 | 战争践踏/地面重踏音效。 |
| `AOWW` | `SNDxAOWW` | `Whirlwind` | 技能/法术 | 旋风斩/持续旋转切割音效。 |
| `APHS` | `SNDxAPHS` | `PhaseShift` | 技能/法术 | 相位转移/短暂无敌闪避音效。 |
| `APHX` | `SNDxAPHX` | `PhoenixBirth` | 技能/法术 | 凤凰生成音效。 |
| `APLA` | `SNDxAPLA` | `PolymorphAir` | 技能/法术 | 变形术空中/飞行目标音效。 |
| `APLD` | `SNDxAPLD` | `PolymorphDone` | 技能/法术 | 变形完成音效。 |
| `APOL` | `SNDxAPOL` | `Polymorph` | 技能/法术 | 变形术施放音效。 |
| `APRG` | `SNDxAPRG` | `Purge` | 技能/法术 | 净化/驱散减速音效。 |
| `APSH` | `SNDxAPSH` | `PossessionMissileHit` | 弹道/远程 | 占据弹道命中音效。 |
| `APSL` | `SNDxAPSL` | `PossessionMissileLaunch` | 弹道/远程 | 占据弹道发射音效。 |
| `APXB` | `SNDxAPXB` | `PhoenixEggBirth` | 技能/法术 | 凤凰蛋生成音效。 |
| `AREJ` | `SNDxAREJ` | `Rejuvenation` | 技能/法术 | 回春术/持续治疗音效。 |
| `AREP` | `SNDxAREP` | `Repair` | 技能/法术 | 修理敲击/维修音效。 |
| `AROO` | `SNDxAROO` | `Root` | 技能/法术 | 扎根/根须缠绕地面音效。 |
| `ARPD` | `SNDxARPD` | `RightGlueScreenPopDown` | 界面/剧情 | 界面右侧弹窗收起音效。 |
| `ARPU` | `SNDxARPU` | `RightGlueScreenPopUp` | 界面/剧情 | 界面右侧弹窗弹出音效。 |
| `ASHP` | `SNDxASHP` | `ShadowPact` | 技能/法术 | 暗影契约/黑暗能量音效。 |
| `ASKA` | `SNDxASKA` | `RaiseSkeletonArcher` | 技能/法术 | 召唤骷髅弓箭手音效。 |
| `ASKW` | `SNDxASKW` | `RaiseSkeletonWarrior` | 技能/法术 | 召唤骷髅战士音效。 |
| `ASLC` | `SNDxASLC` | `SlowCaster` | 技能/法术 | 减速术施法者端音效。 |
| `ASLO` | `SNDxASLO` | `Slow` | 技能/法术 | 减速术命中/目标端音效。 |
| `ASPL` | `SNDxASPL` | `SpiritLink` | 技能/法术 | 灵魂链接音效。 |
| `ASPM` | `SNDxASPM` | `SpellStealMissileLaunch` | 弹道/远程 | 法术窃取弹道发射音效。 |
| `ASPS` | `SNDxASPS` | `SpellStealTarget` | 技能/法术 | 法术窃取目标端音效。 |
| `ASTO` | `SNDxASTO` | `StoneFormMorph1` | 技能/法术 | 石像鬼石像形态切换音效1。 |
| `AST2` | `SNDxAST2` | `StoneFormMorph2` | 技能/法术 | 石像鬼石像形态切换音效2。 |
| `AST3` | `SNDxAST3` | `StoneFormMorph3` | 技能/法术 | 石像鬼石像形态切换音效3。 |
| `ASTA` | `SNDxASTA` | `StoneFormMorphAlternate` | 技能/法术 | 石像鬼解除石像形态/备用切换音效。 |
| `ASTB` | `SNDxASTB` | `StasisTotemBirth` | 技能/法术 | 静滞陷阱/图腾生成音效。 |
| `ASTH` | `SNDxASTH` | `StampedeHit` | 技能/法术 | 奔袭/群兽冲撞命中音效。 |
| `ASTS` | `SNDxASTS` | `StasisTotemDeath` | 死亡/爆炸 | 静滞陷阱/图腾消失或触发音效。 |
| `ASWB` | `SNDxASWB` | `SpiritWolfBirth` | 技能/法术 | 幽灵狼生成音效。 |
| `ASWE` | `SNDxASWE` | `WaterElementalBirth` | 技能/法术 | 水元素生成音效。 |
| `ATAU` | `SNDxATAU` | `Taunt` | 技能/法术 | 嘲讽音效。 |
| `ATRB` | `SNDxATRB` | `TreeWallBirth` | 技能/法术 | 树墙/树木生成音效。 |
| `AUB1` | `SNDxAUB1` | `UndeadBuildingBirth1` | 技能/法术 | 不死族建筑建造/召唤生成音效1。 |
| `AUB2` | `SNDxAUB2` | `UndeadBuildingBirth2` | 技能/法术 | 不死族建筑建造/召唤生成音效2。 |
| `AUB3` | `SNDxAUB3` | `UndeadBuildingBirth3` | 技能/法术 | 不死族建筑建造/召唤生成音效3。 |
| `AUB4` | `SNDxAUB4` | `UndeadBuildingBirth4` | 技能/法术 | 不死族建筑建造/召唤生成音效4。 |
| `AUCB` | `SNDxAUCB` | `ScarabBirth` | 技能/法术 | 圣甲虫/小虫生成音效。 |
| `AUCD` | `SNDxAUCD` | `CarrionSwarmDamage` | 技能/法术 | 腐臭蜂群/蝠群命中伤害音效。 |
| `AUCH` | `SNDxAUCH` | `Charm` | 技能/法术 | 魅惑/控制目标音效。 |
| `AUCO` | `SNDxAUCO` | `UnstableConcoction` | 技能/法术 | 不稳定化合物/自爆投掷音效。 |
| `AUCS` | `SNDxAUCS` | `CarrionSwarmLaunch` | 技能/法术 | 腐臭蜂群/蝠群发射音效。 |
| `AUDA` | `SNDxAUDA` | `DarkRitual` | 技能/法术 | 黑暗仪式音效。 |
| `AUDC` | `SNDxAUDC` | `DeathCoil` | 死亡/爆炸 | 死亡缠绕音效。 |
| `AUDM` | `SNDxAUDM` | `DarkSummoningMissileLaunch` | 弹道/远程 | 黑暗召唤弹道发射音效。 |
| `AUDP` | `SNDxAUDP` | `DeathPactTarget` | 死亡/爆炸 | 死亡契约目标吞噬音效。 |
| `AUDS` | `SNDxAUDS` | `DarkSummoningTarget` | 技能/法术 | 黑暗召唤目标点音效。 |
| `AUDT` | `SNDxAUDT` | `DeathAndDecayTarget` | 死亡/爆炸 | 死亡凋零目标区域音效。 |
| `AUFA` | `SNDxAUFA` | `FrostArmor` | 技能/法术 | 霜冻护甲增益音效。 |
| `AUFN` | `SNDxAUFN` | `FrostNova` | 技能/法术 | 霜冻新星爆发音效。 |
| `AUGS` | `SNDxAUGS` | `GatherShadowsMorph` | 技能/法术 | 聚影/隐蔽形态切换音效。 |
| `AUGA` | `SNDxAUGA` | `GatherShadowsMorphAlternate` | 技能/法术 | 聚影/隐蔽形态解除音效。 |
| `AUHF` | `SNDxAUHF` | `UnholyFrenzy` | 技能/法术 | 邪恶狂热音效。 |
| `AUIH` | `SNDxAUIH` | `ImpaleLand` | 技能/法术 | 穿刺落地/地刺钻出音效。 |
| `AUIM` | `SNDxAUIM` | `Impale` | 技能/法术 | 穿刺施放/地刺推进音效。 |
| `AUIT` | `SNDxAUIT` | `ImpaleHit` | 技能/法术 | 穿刺命中/击飞音效。 |
| `AUPR` | `SNDxAUPR` | `Uproot` | 技能/法术 | 拔根/古树起身音效。 |
| `AURV` | `SNDxAURV` | `ReviveUndead` | 技能/法术 | 不死族英雄复活音效。 |
| `AWBS` | `SNDxAWBS` | `BigWaterStep` | 脚步/移动 | 大型单位水中脚步/踩水音效。 |
| `AWEB` | `SNDxAWEB` | `Web` | 技能/法术 | 蛛网束缚/发射音效。 |
| `AWRS` | `SNDxAWRS` | `Pulverize` | 技能/法术 | 粉碎/重击溅射音效。 |
| `AWST` | `SNDxAWST` | `WaterStep` | 脚步/移动 | 普通水中脚步/踩水音效。 |
| `DABA` | `SNDxDABA` | `AbominationAlternateDeath` | 死亡/爆炸 | 憎恶备用/变身形态死亡音效。 |
| `DABO` | `SNDxDABO` | `AbominationDeath` | 死亡/爆炸 | 憎恶死亡音效。 |
| `DACO` | `SNDxDACO` | `AcolyteDeath` | 死亡/爆炸 | 侍僧死亡音效。 |
| `DADR` | `SNDxDADR` | `DruidOfTheTalonDeath` | 死亡/爆炸 | 猛禽德鲁伊死亡音效。 |
| `DALB` | `SNDxDALB` | `AlbatrossDeath` | 死亡/爆炸 | 信天翁死亡音效。 |
| `DAMG` | `SNDxDAMG` | `HeroArchMageDeath` | 死亡/爆炸 | 大法师英雄死亡音效。 |
| `DANG` | `SNDxDANG` | `WardDeath` | 死亡/爆炸 | 守卫/图腾死亡音效。 |
| `DANP` | `SNDxDANP` | `TreantDeath` | 死亡/爆炸 | 树人死亡音效。 |
| `DARC` | `SNDxDARC` | `ArachnathidDeath` | 死亡/爆炸 | 蛛魔/蜘蛛怪死亡音效。 |
| `DARG` | `SNDxDARG` | `ArmorGolemDeath` | 死亡/爆炸 | 装甲傀儡死亡音效。 |
| `DART` | `SNDxDART` | `ArtilleryExplodeDeath` | 死亡/爆炸 | 火炮/攻城爆炸死亡音效。 |
| `DASS` | `SNDxDASS` | `AssassinDeath` | 死亡/爆炸 | 刺客死亡音效。 |
| `DWTC` | `SNDxDWTC` | `WatcherDeath` | 死亡/爆炸 | 守望者/看守者死亡音效。 |
| `DBAL` | `SNDxDBAL` | `BallistaDeath` | 死亡/爆炸 | 弩车死亡音效。 |
| `DBAN` | `SNDxDBAN` | `BansheeDeath` | 死亡/爆炸 | 女妖死亡音效。 |
| `DBAT` | `SNDxDBAT` | `BatRiderDeath` | 死亡/爆炸 | 蝙蝠骑士死亡音效。 |
| `DBES` | `SNDxDBES` | `HeroBloodElfDeath` | 死亡/爆炸 | 血法师英雄死亡音效。 |
| `DBLA` | `SNDxDBLA` | `HeroBladeMasterDeath` | 死亡/爆炸 | 剑圣英雄死亡音效。 |
| `DBNT` | `SNDxDBNT` | `BanditDeath` | 死亡/爆炸 | 强盗死亡音效。 |
| `DBRG` | `SNDxDBRG` | `DeathBridge` | 死亡/爆炸 | 桥梁毁灭/倒塌音效。 |
| `DBRI` | `SNDxDBRI` | `BristleBackDeath` | 死亡/爆炸 | 豪猪/刚背兽死亡音效。 |
| `DBSF` | `SNDxDBSF` | `BlackStagFemaleDeath` | 死亡/爆炸 | 黑鹿雌性死亡音效。 |
| `DBSM` | `SNDxDBSM` | `BlackStagMaleDeath` | 死亡/爆炸 | 黑鹿雄性死亡音效。 |
| `DBSP` | `SNDxDBSP` | `BattleShipDeath` | 死亡/爆炸 | 战舰死亡音效。 |
| `DBSX` | `SNDxDBSX` | `ObsidianAvengerDeath` | 死亡/爆炸 | 黑曜石复仇者/毁灭者死亡音效。 |
| `DBTM` | `SNDxDBTM` | `BeastmasterDeath` | 死亡/爆炸 | 兽王英雄死亡音效。 |
| `DCAT` | `SNDxDCAT` | `CatapultDeath` | 死亡/爆炸 | 投石车死亡音效。 |
| `DCBL` | `SNDxDCBL` | `DeathCityBuilding` | 死亡/爆炸 | 城市场景建筑毁灭/倒塌音效。 |
| `DCEN` | `SNDxDCEN` | `CentaurDeath` | 死亡/爆炸 | 半人马死亡音效。 |
| `DCNA` | `SNDxDCNA` | `CentaurArcherDeath` | 死亡/爆炸 | 半人马弓箭手死亡音效。 |
| `DCRL` | `SNDxDCRL` | `HeroCryptLordDeath` | 死亡/爆炸 | 地穴领主英雄死亡音效。 |
| `DDEM` | `SNDxDDEM` | `HeroDemonHunterDeath` | 死亡/爆炸 | 恶魔猎手英雄死亡音效。 |
| `DDHK` | `SNDxDDHK` | `DragonHawkDeath` | 死亡/爆炸 | 龙鹰死亡音效。 |
| `DDKN` | `SNDxDDKN` | `HeroDeathKnightDeath` | 死亡/爆炸 | 死亡骑士英雄死亡音效。 |
| `DDKR` | `SNDxDDKR` | `DarkRangerDeath` | 死亡/爆炸 | 黑暗游侠死亡音效。 |
| `DDMA` | `SNDxDDMA` | `HeroDemonHunterDeathAlternate` | 死亡/爆炸 | 恶魔猎手英雄备用/变身形态死亡音效。 |
| `DDMG` | `SNDxDDMG` | `DoomGuardDeath` | 死亡/爆炸 | 末日守卫死亡音效。 |
| `DDOC` | `SNDxDDOC` | `DruidOfTheClawDeath` | 死亡/爆炸 | 利爪德鲁伊死亡音效。 |
| `DDCA` | `SNDxDDCA` | `DruidOfTheClawDeathAlternate` | 死亡/爆炸 | 利爪德鲁伊备用/变身形态死亡音效。 |
| `DDMN` | `SNDxDDMN` | `DemonessDeath` | 死亡/爆炸 | 恶魔女卫/魅魔死亡音效。 |
| `DDNW` | `SNDxDDNW` | `DuneWormDeath` | 死亡/爆炸 | 沙虫死亡音效。 |
| `DDTA` | `SNDxDDTA` | `DruidOfTheTalonDeathAlternate` | 死亡/爆炸 | 猛禽德鲁伊备用/变身形态死亡音效。 |
| `DDRA` | `SNDxDDRA` | `DragonDeath` | 死亡/爆炸 | 巨龙死亡音效。 |
| `DDRL` | `SNDxDDRL` | `HeroDreadLordDeath` | 死亡/爆炸 | 恐惧魔王英雄死亡音效。 |
| `DDRN` | `SNDxDDRN` | `DraeneiDeath` | 死亡/爆炸 | 德莱尼死亡音效。 |
| `DDRS` | `SNDxDDRS` | `DragonspawnDeath` | 死亡/爆炸 | 龙人死亡音效。 |
| `DDRY` | `SNDxDDRY` | `DryadDeath` | 死亡/爆炸 | 树妖/小鹿死亡音效。 |
| `DDSH` | `SNDxDDSH` | `HumanDissipate` | 死亡/爆炸 | 人族英雄/灵体消散音效。 |
| `DDSN` | `SNDxDDSN` | `NightElfDissipate` | 死亡/爆炸 | 暗夜精灵英雄/灵体消散音效。 |
| `DDSO` | `SNDxDDSO` | `OrcDissipate` | 死亡/爆炸 | 兽族英雄/灵体消散音效。 |
| `DDWF` | `SNDxDDWF` | `DireWolfDeath` | 死亡/爆炸 | 恐狼死亡音效。 |
| `DEBA` | `SNDxDEBA` | `DeathWalkingNightElfBuilding` | 死亡/爆炸 | 行走中的暗夜建筑/古树毁灭/倒塌音效。 |
| `DEBC` | `SNDxDEBC` | `DeathNightElfBuildingCancel` | 死亡/爆炸 | 暗夜建筑取消毁灭/倒塌音效。 |
| `DEGS` | `SNDxDEGS` | `EggSackDeath` | 死亡/爆炸 | 虫卵/蛋囊死亡音效。 |
| `DELB` | `SNDxDELB` | `DeathNightElfLargeBuilding` | 死亡/爆炸 | 暗夜大型建筑毁灭/倒塌音效。 |
| `DELS` | `SNDxDELS` | `DeathNightElfSmallBuilding` | 死亡/爆炸 | 暗夜小型建筑毁灭/倒塌音效。 |
| `DENT` | `SNDxDENT` | `EntDeath` | 死亡/爆炸 | 古树/树人死亡音效。 |
| `DFAR` | `SNDxDFAR` | `HeroFarSeerDeath` | 死亡/爆炸 | 先知英雄死亡音效。 |
| `DFCO` | `SNDxDFCO` | `FacelessOneDeath` | 死亡/爆炸 | 无面者死亡音效。 |
| `DFDR` | `SNDxDFDR` | `FaerieDragonDeath` | 死亡/爆炸 | 精灵龙死亡音效。 |
| `DFLG` | `SNDxDFLG` | `FelguardDeath` | 死亡/爆炸 | 恶魔卫士死亡音效。 |
| `DFEL` | `SNDxDFEL` | `FelhoundDeath` | 死亡/爆炸 | 地狱犬死亡音效。 |
| `DFOO` | `SNDxDFOO` | `FootmanDeath` | 死亡/爆炸 | 步兵死亡音效。 |
| `DFOR` | `SNDxDFOR` | `ForgottenOneDeath` | 死亡/爆炸 | 遗忘者死亡音效。 |
| `DFRG` | `SNDxDFRG` | `FrogDeath` | 死亡/爆炸 | 青蛙死亡音效。 |
| `DFRM` | `SNDxDFRM` | `FrostmourneDeath` | 死亡/爆炸 | 霜之哀伤死亡音效。 |
| `DFRT` | `SNDxDFRT` | `ForestTrollDeath` | 死亡/爆炸 | 森林巨魔死亡音效。 |
| `DFRW` | `SNDxDFRW` | `FrostWyrmDeath` | 死亡/爆炸 | 冰霜巨龙死亡音效。 |
| `DFSP` | `SNDxDFSP` | `ForestTrollShadowPriestDeath` | 死亡/爆炸 | 森林巨魔暗影牧师死亡音效。 |
| `DFTN` | `SNDxDFTN` | `ForgottenOneTentacleDeath` | 死亡/爆炸 | 遗忘者触手死亡音效。 |
| `DFUR` | `SNDxDFUR` | `FurbolgDeath` | 死亡/爆炸 | 熊怪死亡音效。 |
| `DGAR` | `SNDxDGAR` | `GargoyleDeath` | 死亡/爆炸 | 石像鬼死亡音效。 |
| `DGAS` | `SNDxDGAS` | `GargoyleStoneDeath` | 死亡/爆炸 | 石像鬼石化死亡音效。 |
| `DGAT` | `SNDxDGAT` | `GateDeath` | 死亡/爆炸 | 大门死亡音效。 |
| `DGHO` | `SNDxDGHO` | `GhoulDeath` | 死亡/爆炸 | 食尸鬼死亡音效。 |
| `DGLD` | `SNDxDGLD` | `GoldMineDeath` | 死亡/爆炸 | 金矿死亡音效。 |
| `DGLM` | `SNDxDGLM` | `GoblinLandMineDeath` | 死亡/爆炸 | 地精地雷死亡音效。 |
| `DGNA` | `SNDxDGNA` | `GnollArcherDeath` | 死亡/爆炸 | 豺狼人弓箭手死亡音效。 |
| `DGNL` | `SNDxDGNL` | `GnollDeath` | 死亡/爆炸 | 豺狼人死亡音效。 |
| `DGOB` | `SNDxDGOB` | `GemstoneObeliskDeath` | 死亡/爆炸 | 宝石方尖碑死亡音效。 |
| `DGRU` | `SNDxDGRU` | `GruntDeath` | 死亡/爆炸 | 兽人步兵死亡音效。 |
| `DGRY` | `SNDxDGRY` | `GryphonRiderDeath` | 死亡/爆炸 | 狮鹫骑士死亡音效。 |
| `DGRZ` | `SNDxDGRZ` | `GrizzlyBearDeath` | 死亡/爆炸 | 灰熊死亡音效。 |
| `DGRS` | `SNDxDGRS` | `BearSwimDeath` | 死亡/爆炸 | 熊水中死亡音效。 |
| `DGSD` | `SNDxDGSD` | `GoblinSapperDeath` | 死亡/爆炸 | 地精工兵死亡音效。 |
| `DGSP` | `SNDxDGSP` | `GoblinSapperExplode` | 死亡/爆炸 | 地精工兵自爆音效。 |
| `DGST` | `SNDxDGST` | `GiantSeaTurtleDeath` | 死亡/爆炸 | 巨型海龟死亡音效。 |
| `DTDS` | `SNDxDTDS` | `GiantSeaTurtleDeathSwim` | 死亡/爆炸 | 巨型海龟水中死亡音效。 |
| `DGYR` | `SNDxDGYR` | `GyrocopterDeath` | 死亡/爆炸 | 飞行机器死亡音效。 |
| `DGZP` | `SNDxDGZP` | `GoblinZeppelinDeath` | 死亡/爆炸 | 地精飞艇死亡音效。 |
| `DHBC` | `SNDxDHBC` | `DeathHumanBuildingCancel` | 死亡/爆炸 | 人族建筑取消毁灭/倒塌音效。 |
| `DHIP` | `SNDxDHIP` | `HippogryphDeath` | 死亡/爆炸 | 角鹰兽死亡音效。 |
| `DHLB` | `SNDxDHLB` | `DeathHumanLargeBuilding` | 死亡/爆炸 | 人族大型建筑毁灭/倒塌音效。 |
| `DHLS` | `SNDxDHLS` | `DeathHumanSmallBuilding` | 死亡/爆炸 | 人族小型建筑毁灭/倒塌音效。 |
| `DHMC` | `SNDxDHMC` | `HermitCrabDeath` | 死亡/爆炸 | 寄居蟹死亡音效。 |
| `DHOR` | `SNDxDHOR` | `HorseDeath` | 死亡/爆炸 | 马死亡音效。 |
| `DHRP` | `SNDxDHRP` | `HarpyDeath` | 死亡/爆炸 | 鹰身女妖死亡音效。 |
| `DHUN` | `SNDxDHUN` | `HeadHunterDeath` | 死亡/爆炸 | 猎头者死亡音效。 |
| `DHWD` | `SNDxDHWD` | `HealingWardDeath` | 死亡/爆炸 | 治疗守卫死亡音效。 |
| `DHDA` | `SNDxDHDA` | `HydraDeath` | 死亡/爆炸 | 九头蛇死亡音效。 |
| `DHDS` | `SNDxDHDS` | `HydraDeathSwim` | 死亡/爆炸 | 九头蛇水中死亡音效。 |
| `DHYD` | `SNDxDHYD` | `HydraliskDeath` | 死亡/爆炸 | 刺蛇死亡音效。 |
| `DICT` | `SNDxDICT` | `IceTrollDeath` | 死亡/爆炸 | 冰霜巨魔死亡音效。 |
| `DINF` | `SNDxDINF` | `InfernalDeath` | 死亡/爆炸 | 地狱火死亡音效。 |
| `DINM` | `SNDxDINM` | `InfernalMachineDeath` | 死亡/爆炸 | 地狱火机器死亡音效。 |
| `DIPW` | `SNDxDIPW` | `PrisonWagonDeath` | 死亡/爆炸 | 囚车死亡音效。 |
| `DIRG` | `SNDxDIRG` | `IronGolemDeath` | 死亡/爆炸 | 铁傀儡死亡音效。 |
| `DJAN` | `SNDxDJAN` | `JainaDeath` | 死亡/爆炸 | 吉安娜死亡音效。 |
| `DKBS` | `SNDxDKBS` | `KoboldShovelerDeath` | 死亡/爆炸 | 狗头人掘地者死亡音效。 |
| `DKEE` | `SNDxDKEE` | `HeroKeeperOfTheGroveDeath` | 死亡/爆炸 | 丛林守护者英雄死亡音效。 |
| `DKNI` | `SNDxDKNI` | `KnightDeath` | 死亡/爆炸 | 骑士死亡音效。 |
| `DKOB` | `SNDxDKOB` | `KoboldDeath` | 死亡/爆炸 | 狗头人死亡音效。 |
| `DKOD` | `SNDxDKOD` | `KodoBeastDeath` | 死亡/爆炸 | 科多兽死亡音效。 |
| `DLIC` | `SNDxDLIC` | `HeroLichDeath` | 死亡/爆炸 | 巫妖英雄死亡音效。 |
| `DLOC` | `SNDxDLOC` | `LocustDeath` | 死亡/爆炸 | 蝗虫死亡音效。 |
| `DLVR` | `SNDxDLVR` | `LeverDeath` | 死亡/爆炸 | 拉杆/机关死亡音效。 |
| `DMAG` | `SNDxDMAG` | `MagnataurDeath` | 死亡/爆炸 | 猛犸人/马格纳托死亡音效。 |
| `DMAK` | `SNDxDMAK` | `MakruraDeath` | 死亡/爆炸 | 玛库拉死亡音效。 |
| `DMAM` | `SNDxDMAM` | `MammothDeath` | 死亡/爆炸 | 猛犸死亡音效。 |
| `DMGS` | `SNDxDMGS` | `MurgulDeathSwim` | 死亡/爆炸 | 穆戈尔/娜迦小兵水中死亡音效。 |
| `DMGT` | `SNDxDMGT` | `MountainGiantDeath` | 死亡/爆炸 | 山岭巨人死亡音效。 |
| `DMKG` | `SNDxDMKG` | `HeroMountainKingDeath` | 死亡/爆炸 | 山丘之王英雄死亡音效。 |
| `DMLF` | `SNDxDMLF` | `MalfurionDeath` | 死亡/爆炸 | 玛法里奥死亡音效。 |
| `DMOO` | `SNDxDMOO` | `HeroMoonPriestessDeath` | 死亡/爆炸 | 月之女祭司英雄死亡音效。 |
| `DMOR` | `SNDxDMOR` | `MortarTeamDeath` | 死亡/爆炸 | 迫击炮小队死亡音效。 |
| `DMTW` | `SNDxDMTW` | `MeatWagonDeath` | 死亡/爆炸 | 绞肉车死亡音效。 |
| `DMUR` | `SNDxDMUR` | `MurlocDeath` | 死亡/爆炸 | 鱼人死亡音效。 |
| `DNBL` | `SNDxDNBL` | `NagaBuildingDeath` | 死亡/爆炸 | 娜迦建筑死亡音效。 |
| `DNDR` | `SNDxDNDR` | `NetherDragonDeath` | 死亡/爆炸 | 虚空龙死亡音效。 |
| `DNDS` | `SNDxDNDS` | `HumanDissipate` | 死亡/爆炸 | 人族英雄/灵体消散音效。 |
| `DNEC` | `SNDxDNEC` | `NecromancerDeath` | 死亡/爆炸 | 亡灵巫师死亡音效。 |
| `DMYR` | `SNDxDMYR` | `NagaMyrmidonDeath` | 死亡/爆炸 | 娜迦暴徒死亡音效。 |
| `DMYS` | `SNDxDMYS` | `NagaMyrmidonDeathSwim` | 死亡/爆炸 | 娜迦暴徒水中死亡音效。 |
| `DNSR` | `SNDxDNSR` | `NagaSirenDeath` | 死亡/爆炸 | 娜迦海妖死亡音效。 |
| `DNSS` | `SNDxDNSS` | `NagaSirenDeathSwim` | 死亡/爆炸 | 娜迦海妖水中死亡音效。 |
| `DNSW` | `SNDxDNSW` | `NagaSeaWitchDeath` | 死亡/爆炸 | 娜迦海巫死亡音效。 |
| `DNWS` | `SNDxDNWS` | `NagaSeaWitchDeathSwim` | 死亡/爆炸 | 娜迦海巫水中死亡音效。 |
| `DOBS` | `SNDxDOBS` | `ObsidianStatueDeath` | 死亡/爆炸 | 黑曜石像死亡音效。 |
| `DOGR` | `SNDxDOGR` | `OgreDeath` | 死亡/爆炸 | 食人魔死亡音效。 |
| `DOLB` | `SNDxDOLB` | `DeathOrcLargeBuilding` | 死亡/爆炸 | 兽族大型建筑毁灭/倒塌音效。 |
| `DOLS` | `SNDxDOLS` | `DeathOrcSmallBuilding` | 死亡/爆炸 | 兽族小型建筑毁灭/倒塌音效。 |
| `DORW` | `SNDxDORW` | `OrcWarlockDeath` | 死亡/爆炸 | 兽族术士死亡音效。 |
| `DOWB` | `SNDxDOWB` | `OwlbearDeath` | 死亡/爆炸 | 枭兽死亡音效。 |
| `DOWL` | `SNDxDOWL` | `SnowOwlDeath` | 死亡/爆炸 | 雪枭死亡音效。 |
| `DPAL` | `SNDxDPAL` | `HeroPaladinDeath` | 死亡/爆炸 | 圣骑士英雄死亡音效。 |
| `DPMB` | `SNDxDPMB` | `PandarenBrewmasterDeath` | 死亡/爆炸 | 熊猫酒仙英雄死亡音效。 |
| `DPEN` | `SNDxDPEN` | `PenguinDeath` | 死亡/爆炸 | 企鹅死亡音效。 |
| `DPEO` | `SNDxDPEO` | `PeonDeath` | 死亡/爆炸 | 苦工死亡音效。 |
| `DPES` | `SNDxDPES` | `PeasantDeath` | 死亡/爆炸 | 农民死亡音效。 |
| `DPHX` | `SNDxDPHX` | `PhoenixDeath` | 死亡/爆炸 | 凤凰死亡音效。 |
| `DPIG` | `SNDxDPIG` | `PigDeath` | 死亡/爆炸 | 猪死亡音效。 |
| `DPIT` | `SNDxDPIT` | `CryptFiendDeath` | 死亡/爆炸 | 地穴恶魔死亡音效。 |
| `DPLD` | `SNDxDPLD` | `PitlordDeath` | 死亡/爆炸 | 深渊领主死亡音效。 |
| `DPRS` | `SNDxDPRS` | `PriestDeath` | 死亡/爆炸 | 牧师死亡音效。 |
| `DQBS` | `SNDxDQBS` | `QuillBeastDeath` | 死亡/爆炸 | 豪猪野兽死亡音效。 |
| `DRAI` | `SNDxDRAI` | `RaiderDeath` | 死亡/爆炸 | 狼骑兵死亡音效。 |
| `DRAN` | `SNDxDRAN` | `ArcherDeath` | 死亡/爆炸 | 弓箭手死亡音效。 |
| `DRAT` | `SNDxDRAT` | `RatDeath` | 死亡/爆炸 | 老鼠死亡音效。 |
| `DREV` | `SNDxDREV` | `RevenantDeath` | 死亡/爆炸 | 亡魂/复仇者死亡音效。 |
| `DRKG` | `SNDxDRKG` | `RockGolemDeath` | 死亡/爆炸 | 岩石傀儡死亡音效。 |
| `DRKW` | `SNDxDRKW` | `RockWallDeath` | 死亡/爆炸 | 岩石墙死亡音效。 |
| `DRHG` | `SNDxDRHG` | `RiddenHippogryphDeath` | 死亡/爆炸 | 骑乘角鹰兽死亡音效。 |
| `DRIF` | `SNDxDRIF` | `RiflemanDeath` | 死亡/爆炸 | 火枪手死亡音效。 |
| `DSAT` | `SNDxDSAT` | `SatyrDeath` | 死亡/爆炸 | 萨特死亡音效。 |
| `DSCB` | `SNDxDSCB` | `ScarabDeath` | 死亡/爆炸 | 圣甲虫死亡音效。 |
| `DSEL` | `SNDxDSEL` | `SealDeath` | 死亡/爆炸 | 海豹死亡音效。 |
| `DSEN` | `SNDxDSEN` | `SentinelDeath` | 死亡/爆炸 | 哨兵死亡音效。 |
| `DSGT` | `SNDxDSGT` | `SeaGiantDeath` | 死亡/爆炸 | 海巨人死亡音效。 |
| `DSGW` | `SNDxDSGW` | `SeaGiantSwimDeath` | 死亡/爆炸 | 海巨人水中死亡音效。 |
| `DSHD` | `SNDxDSHD` | `ShadeDeath` | 死亡/爆炸 | 阴影死亡音效。 |
| `DSHH` | `SNDxDSHH` | `HeroShadowHunterDeath` | 死亡/爆炸 | 暗影猎手英雄死亡音效。 |
| `DSHM` | `SNDxDSHM` | `ShamanDeath` | 死亡/爆炸 | 萨满死亡音效。 |
| `DSHP` | `SNDxDSHP` | `SheepDeath` | 死亡/爆炸 | 绵羊死亡音效。 |
| `DSHW` | `SNDxDSHW` | `SheepDeathSwim` | 死亡/爆炸 | 绵羊水中死亡音效。 |
| `DSKE` | `SNDxDSKE` | `SkeletonDeath` | 死亡/爆炸 | 骷髅死亡音效。 |
| `DSKK` | `SNDxDSKK` | `SkinkDeath` | 死亡/爆炸 | 石龙子/蜥蜴死亡音效。 |
| `DSLG` | `SNDxDSLG` | `SludgeMonsterDeath` | 死亡/爆炸 | 淤泥怪死亡音效。 |
| `DSND` | `SNDxDSND` | `SnapDragonDeath` | 死亡/爆炸 | 飞蛇/毒蜥死亡音效。 |
| `DSNS` | `SNDxDSNS` | `SnapDragonDeathSwim` | 死亡/爆炸 | 飞蛇/毒蜥水中死亡音效。 |
| `DSOR` | `SNDxDSOR` | `SorceressDeath` | 死亡/爆炸 | 女巫死亡音效。 |
| `DSPB` | `SNDxDSPB` | `SpellBreakerDeath` | 死亡/爆炸 | 破法者死亡音效。 |
| `DSPC` | `SNDxDSPC` | `SpiderCrabDeath` | 死亡/爆炸 | 蜘蛛蟹死亡音效。 |
| `DSPD` | `SNDxDSPD` | `SpiderDeath` | 死亡/爆炸 | 蜘蛛死亡音效。 |
| `DSPL` | `SNDxDSPL` | `SplatDeath` | 死亡/爆炸 | 溅射/肉块死亡音效。 |
| `DSPV` | `SNDxDSPV` | `SpiritOfVengeanceDeath` | 死亡/爆炸 | 复仇之魂死亡音效。 |
| `DSTT` | `SNDxDSTT` | `SteamTankDeath` | 死亡/爆炸 | 蒸汽坦克死亡音效。 |
| `DTAU` | `SNDxDTAU` | `TaurenDeath` | 死亡/爆炸 | 牛头人死亡音效。 |
| `DTCH` | `SNDxDTCH` | `HeroTaurenChieftainDeath` | 死亡/爆炸 | 牛头人酋长英雄死亡音效。 |
| `DTRW` | `SNDxDTRW` | `TreeWallDeath` | 死亡/爆炸 | 树墙死亡音效。 |
| `DTUS` | `SNDxDTUS` | `TuskarrDeath` | 死亡/爆炸 | 海象人死亡音效。 |
| `DUAB` | `SNDxDUAB` | `UndeadAirBargeDeath` | 死亡/爆炸 | 不死族飞艇/空中驳船死亡音效。 |
| `DUBC` | `SNDxDUBC` | `DeathUndeadBuildingCancel` | 死亡/爆炸 | 不死族建筑取消毁灭/倒塌音效。 |
| `DUDS` | `SNDxDUDS` | `UndeadDissipate` | 死亡/爆炸 | 不死族英雄/灵体消散音效。 |
| `DULB` | `SNDxDULB` | `DeathUndeadLargeBuilding` | 死亡/爆炸 | 不死族大型建筑毁灭/倒塌音效。 |
| `DULS` | `SNDxDULS` | `DeathUndeadSmallBuilding` | 死亡/爆炸 | 不死族小型建筑毁灭/倒塌音效。 |
| `DUNB` | `SNDxDUNB` | `UnbrokenDeath` | 死亡/爆炸 | 破碎者/不屈者死亡音效。 |
| `DVLC` | `SNDxDVLC` | `VillagerChildDeath` | 死亡/爆炸 | 村民小孩死亡音效。 |
| `DVLM` | `SNDxDVLM` | `VillagerManDeath` | 死亡/爆炸 | 男村民死亡音效。 |
| `DVLW` | `SNDxDVLW` | `VillagerWomanDeath` | 死亡/爆炸 | 女村民死亡音效。 |
| `DVNG` | `SNDxDVNG` | `VengeanceDeath` | 死亡/爆炸 | 复仇天神死亡音效。 |
| `DVUL` | `SNDxDVUL` | `VultureDeath` | 死亡/爆炸 | 秃鹫死亡音效。 |
| `DWAR` | `SNDxDWAR` | `WarlockDeath` | 死亡/爆炸 | 术士死亡音效。 |
| `DWAT` | `SNDxDWAT` | `WaterElementalDeath` | 死亡/爆炸 | 水元素死亡音效。 |
| `DWCD` | `SNDxDWCD` | `WyvernCageDeath` | 死亡/爆炸 | 双足飞龙笼死亡音效。 |
| `DWDS` | `SNDxDWDS` | `WingedSerpentDeath` | 死亡/爆炸 | 翼蛇死亡音效。 |
| `DWEN` | `SNDxDWEN` | `WendigoDeath` | 死亡/爆炸 | 温迪戈死亡音效。 |
| `DWIT` | `SNDxDWIT` | `WitchDoctorDeath` | 死亡/爆炸 | 巫医死亡音效。 |
| `DWLD` | `SNDxDWLD` | `WarlordDeath` | 死亡/爆炸 | 军阀死亡音效。 |
| `DWLF` | `SNDxDWLF` | `WolfDeath` | 死亡/爆炸 | 狼死亡音效。 |
| `DWRD` | `SNDxDWRD` | `HeroWardenDeath` | 死亡/爆炸 | 守望者英雄死亡音效。 |
| `DWRE` | `SNDxDWRE` | `WarEagleDeath` | 死亡/爆炸 | 战鹰死亡音效。 |
| `DWSP` | `SNDxDWSP` | `WispDeath` | 死亡/爆炸 | 小精灵死亡音效。 |
| `DWYV` | `SNDxDWYV` | `WyvernRiderDeath` | 死亡/爆炸 | 双足飞龙骑士死亡音效。 |
| `DZOM` | `SNDxDZOM` | `ZombieDeath` | 死亡/爆炸 | 僵尸死亡音效。 |
| `KANG` | `SNDxKANG` | `AncestralGuardianAttack1` | 攻击动作 | 先祖守护者攻击出手/挥击音效。 |
| `KAOE` | `SNDxKAOE` | `AncientOfTheEarthAttack1` | 攻击动作 | 大地古树攻击出手/挥击音效。 |
| `KAOM` | `SNDxKAOM` | `AncientOfTheMoonAttack1` | 攻击动作 | 月之古树攻击出手/挥击音效。 |
| `KAW1` | `SNDxKAW1` | `AncientOfTheWildAttack1` | 攻击动作 | 荒野古树攻击出手/挥击音效。 |
| `KAW2` | `SNDxKAW2` | `AncientOfTheWildAttack2` | 攻击动作 | 荒野古树攻击出手/挥击音效。 |
| `KANP` | `SNDxKANP` | `AncientProtectorMissileAttack` | 攻击动作 | 远古守护者远程攻击出手音效。 |
| `KAP1` | `SNDxKAP1` | `AncientProtectorMeleeAttack1` | 攻击动作 | 远古守护者近战攻击出手音效。 |
| `KAP2` | `SNDxKAP2` | `AncientProtectorMeleeAttack2` | 攻击动作 | 远古守护者近战攻击出手音效。 |
| `KBAL` | `SNDxKBAL` | `BalrogAttack1` | 攻击动作 | 炎魔攻击出手/挥击音效。 |
| `KAZB` | `SNDxKAZB` | `AzureDragonAttack1` | 攻击动作 | 蓝龙攻击出手/挥击音效。 |
| `KBLL` | `SNDxKBLL` | `BallistaAttack` | 攻击动作 | 弩车攻击出手/挥击音效。 |
| `KBLB` | `SNDxKBLB` | `BlackDragonAttack1` | 攻击动作 | 黑龙攻击出手/挥击音效。 |
| `KBRB` | `SNDxKBRB` | `BronzeDragonAttack1` | 攻击动作 | 青铜龙攻击出手/挥击音效。 |
| `KBST` | `SNDxKBST` | `BeastmasterAttack` | 攻击动作 | 兽王攻击出手/挥击音效。 |
| `KGRB` | `SNDxKGRB` | `GreenDragonAttack1` | 攻击动作 | 绿龙攻击出手/挥击音效。 |
| `KRDB` | `SNDxKRDB` | `RedDragonAttack1` | 攻击动作 | 红龙攻击出手/挥击音效。 |
| `KBM1` | `SNDxKBM1` | `HeroBladeMasterAttack1` | 攻击动作 | 剑圣攻击出手/挥击音效。 |
| `KBM2` | `SNDxKBM2` | `HeroBladeMasterAttack2` | 攻击动作 | 剑圣攻击出手/挥击音效。 |
| `KCAN` | `SNDxKCAN` | `CannonTowerAttack` | 攻击动作 | 炮塔攻击出手/挥击音效。 |
| `KCAT` | `SNDxKCAT` | `CatapultAttack1` | 攻击动作 | 投石车攻击出手/挥击音效。 |
| `KCL1` | `SNDxKCL1` | `CryptLordAttack1` | 攻击动作 | 地穴领主攻击出手/挥击音效。 |
| `KCL2` | `SNDxKCL2` | `CryptLordAttack2` | 攻击动作 | 地穴领主攻击出手/挥击音效。 |
| `KDH1` | `SNDxKDH1` | `HeroDemonHunterAttack1` | 攻击动作 | 恶魔猎手英雄攻击出手/挥击音效。 |
| `KDH2` | `SNDxKDH2` | `HeroDemonHunterAttack2` | 攻击动作 | 恶魔猎手英雄攻击出手/挥击音效。 |
| `KDK1` | `SNDxKDK1` | `HeroDeathKnightAttack1` | 死亡/爆炸 | 死亡骑士英雄攻击出手/挥击音效。 |
| `KFAR` | `SNDxKFAR` | `HeroFarSeerAttack1` | 攻击动作 | 先知攻击出手/挥击音效。 |
| `KFRB` | `SNDxKFRB` | `FrostWyrmAttack1` | 攻击动作 | 冰霜巨龙攻击出手/挥击音效。 |
| `KGUA` | `SNDxKGUA` | `GuardTowerAttack` | 攻击动作 | 防御塔攻击出手/挥击音效。 |
| `KGYR` | `SNDxKGYR` | `GyrocopterAttack` | 攻击动作 | 飞行机器攻击出手/挥击音效。 |
| `KIN1` | `SNDxKIN1` | `InfernalAttack1` | 攻击动作 | 地狱火攻击出手/挥击音效。 |
| `KIN2` | `SNDxKIN2` | `InfernalAttack2` | 攻击动作 | 地狱火攻击出手/挥击音效。 |
| `KINJ` | `SNDxKINJ` | `InfernalJuggernaughtAttack` | 攻击动作 | 地狱火巨兽攻击出手/挥击音效。 |
| `KINM` | `SNDxKINM` | `InfernalMachineAttack` | 攻击动作 | 地狱火机器攻击出手/挥击音效。 |
| `KIRG` | `SNDxKIRG` | `IronGolemAttack1` | 攻击动作 | 铁傀儡攻击出手/挥击音效。 |
| `KLIC` | `SNDxKLIC` | `HeroLichAttack1` | 攻击动作 | 巫妖攻击出手/挥击音效。 |
| `KMKG` | `SNDxKMKG` | `HeroMountainKingAttack1` | 攻击动作 | 山丘之王攻击出手/挥击音效。 |
| `KMT1` | `SNDxKMT1` | `MortarTeamAttack1` | 攻击动作 | 迫击炮小队攻击出手/挥击音效。 |
| `KMT2` | `SNDxKMT2` | `MortarTeamAttack2` | 攻击动作 | 迫击炮小队攻击出手/挥击音效。 |
| `KMTW` | `SNDxKMTW` | `MeatWagonAttack1` | 攻击动作 | 绞肉车攻击出手/挥击音效。 |
| `KPB1` | `SNDxKPB1` | `BrewmasterAttack1` | 攻击动作 | 熊猫酒仙攻击出手/挥击音效。 |
| `KPB2` | `SNDxKPB2` | `BrewmasterAttack2` | 攻击动作 | 熊猫酒仙攻击出手/挥击音效。 |
| `KPL1` | `SNDxKPL1` | `HeroPaladinAttack1` | 攻击动作 | 圣骑士攻击出手/挥击音效。 |
| `KPL2` | `SNDxKPL2` | `HeroPaladinAttack2` | 攻击动作 | 圣骑士攻击出手/挥击音效。 |
| `KPD1` | `SNDxKPD1` | `PitLordAttack1` | 攻击动作 | 深渊领主攻击出手/挥击音效。 |
| `KPD2` | `SNDxKPD2` | `PitLordAttack2` | 攻击动作 | 深渊领主攻击出手/挥击音效。 |
| `KPD3` | `SNDxKPD3` | `PitLordAttack3` | 攻击动作 | 深渊领主攻击出手/挥击音效。 |
| `KPS1` | `SNDxKPS1` | `PitLordAttackSlam1` | 攻击动作 | 深渊领主重砸/猛击攻击音效。 |
| `KPS2` | `SNDxKPS2` | `PitLordAttackSlam2` | 攻击动作 | 深渊领主重砸/猛击攻击音效。 |
| `KRG1` | `SNDxKRG1` | `RockGolemAttack1` | 攻击动作 | 岩石傀儡攻击出手/挥击音效。 |
| `KRG2` | `SNDxKRG2` | `RockGolemAttack2` | 攻击动作 | 岩石傀儡攻击出手/挥击音效。 |
| `KRIF` | `SNDxKRIF` | `RiflemanAttack1` | 攻击动作 | 火枪手攻击出手/挥击音效。 |
| `KRN1` | `SNDxKRN1` | `HeroRangerAttack1` | 攻击动作 | 游侠英雄攻击出手/挥击音效。 |
| `KRN2` | `SNDxKRN2` | `HeroRangerAttack2` | 攻击动作 | 游侠英雄攻击出手/挥击音效。 |
| `KSTT` | `SNDxKSTT` | `SteamTankAttack` | 攻击动作 | 蒸汽坦克攻击出手/挥击音效。 |
| `KTC1` | `SNDxKTC1` | `HeroTaurenChieftainAttack1` | 攻击动作 | 牛头人酋长攻击出手/挥击音效。 |
| `KTC2` | `SNDxKTC2` | `HeroTaurenChieftainAttack2` | 攻击动作 | 牛头人酋长攻击出手/挥击音效。 |
| `KTOL` | `SNDxKTOL` | `TreeOfLifeAttack1` | 攻击动作 | 生命之树攻击出手/挥击音效。 |
| `KWAR` | `SNDxKWAR` | `WardenAttack` | 攻击动作 | 守望者攻击出手/挥击音效。 |
| `MABS` | `SNDxMABS` | `AbsorbManaLaunch` | 弹道/远程 | 吸收魔法/法力抽取发射/释放音效。 |
| `MANG` | `SNDxMANG` | `AncestralGuardianMissileHit` | 弹道/远程 | 先祖守护者弹道命中音效。 |
| `MANL` | `SNDxMANL` | `AncestralGuardianMissileLaunch` | 弹道/远程 | 先祖守护者弹道发射音效。 |
| `MANP` | `SNDxMANP` | `AncientProtectorMissileHit` | 弹道/远程 | 远古守护者弹道命中音效。 |
| `MAPL` | `SNDxMAPL` | `AncientProtectorMissileLaunch` | 弹道/远程 | 远古守护者弹道发射音效。 |
| `MARL` | `SNDxMARL` | `ArrowLaunch` | 弹道/远程 | 箭矢发射/释放音效。 |
| `MARR` | `SNDxMARR` | `ArrowHit` | 弹道/远程 | 箭矢命中/击中音效。 |
| `MAXE` | `SNDxMAXE` | `AxeMissileHit` | 弹道/远程 | 斧头弹道命中音效。 |
| `MAXL` | `SNDxMAXL` | `AxeMissileLaunch` | 弹道/远程 | 斧头弹道发射音效。 |
| `MBAL` | `SNDxMBAL` | `BallistaMissileHit` | 弹道/远程 | 弩车弹道命中音效。 |
| `MBAN` | `SNDxMBAN` | `BansheeMissileHit` | 弹道/远程 | 女妖弹道命中音效。 |
| `MBHT` | `SNDxMBHT` | `BoatMissileHit` | 弹道/远程 | 船只炮弹弹道命中音效。 |
| `MBHL` | `SNDxMBHL` | `BoatMissileLaunch` | 弹道/远程 | 船只炮弹弹道发射音效。 |
| `MBML` | `SNDxMBML` | `BloodMageMissileLaunch` | 弹道/远程 | 血法师弹道发射音效。 |
| `MBNL` | `SNDxMBNL` | `BansheeMissileLaunch` | 弹道/远程 | 女妖弹道发射音效。 |
| `MBLT` | `SNDxMBLT` | `Bolt` | 弹道/远程 | 能量弹/闪电弹飞行或命中音效。 |
| `MBRH` | `SNDxMBRH` | `BristleBackMissileHit` | 弹道/远程 | 豪猪刺弹弹道命中音效。 |
| `MBRL` | `SNDxMBRL` | `BristleBackMissileLaunch` | 弹道/远程 | 豪猪刺弹弹道发射音效。 |
| `MBSL` | `SNDxMBSL` | `PriestMissileLaunch` | 弹道/远程 | 牧师光弹弹道发射音效。 |
| `MBSH` | `SNDxMBSH` | `PriestMissileHit` | 弹道/远程 | 牧师光弹弹道命中音效。 |
| `MCAH` | `SNDxMCAH` | `ChimaeraAcidHit` | 弹道/远程 | 奇美拉酸液命中/击中音效。 |
| `MCAL` | `SNDxMCAL` | `ChimaeraAcidLaunch` | 弹道/远程 | 奇美拉酸液发射/释放音效。 |
| `MCAN` | `SNDxMCAN` | `CannonTowerMissile` | 弹道/远程 | 炮塔炮弹弹道飞行/命中综合音效。 |
| `MCAT` | `SNDxMCAT` | `Catapult` | 弹道/远程 | 投石车音效。 |
| `MCDA` | `SNDxMCDA` | `ColdArrow` | 弹道/远程 | 冰箭音效。 |
| `MCRH` | `SNDxMCRH` | `CryptFiendMissileHit` | 弹道/远程 | 地穴恶魔蛛网弹弹道命中音效。 |
| `MCRL` | `SNDxMCRL` | `CryptFiendMissileLaunch` | 弹道/远程 | 地穴恶魔蛛网弹弹道发射音效。 |
| `MDCL` | `SNDxMDCL` | `DeathCoilMissile` | 死亡/爆炸 | 死亡缠绕弹道音效。 |
| `MDEM` | `SNDxMDEM` | `DemonHunterMissileHit` | 弹道/远程 | 恶魔猎手飞刃弹道命中音效。 |
| `MDLL` | `SNDxMDLL` | `DestroyerMissileLaunch` | 弹道/远程 | 毁灭者弹道发射音效。 |
| `MDML` | `SNDxMDML` | `DemonHunterMissileLaunch` | 弹道/远程 | 恶魔猎手飞刃弹道发射音效。 |
| `MDOC` | `SNDxMDOC` | `WitchDoctorMissileLaunch` | 弹道/远程 | 巫医弹道发射音效。 |
| `MDOH` | `SNDxMDOH` | `WitchDoctorMissileHit` | 弹道/远程 | 巫医弹道命中音效。 |
| `MDRY` | `SNDxMDRY` | `DryadMissile` | 弹道/远程 | 树妖投矛弹道飞行/命中综合音效。 |
| `MDTL` | `SNDxMDTL` | `DruidOfTheTalonMissileLaunch` | 弹道/远程 | 猛禽德鲁伊弹道发射音效。 |
| `MDTH` | `SNDxMDTH` | `DruidOfTheTalonMissileHit` | 弹道/远程 | 猛禽德鲁伊弹道命中音效。 |
| `MDVM` | `SNDxMDVM` | `DevourMagicLaunch` | 弹道/远程 | 吞噬魔法发射/释放音效。 |
| `MFAH` | `SNDxMFAH` | `FrostArrowHit` | 弹道/远程 | 霜冻箭命中/击中音效。 |
| `MFAL` | `SNDxMFAL` | `FrostArrowLaunch` | 弹道/远程 | 霜冻箭发射/释放音效。 |
| `MFAR` | `SNDxMFAR` | `FarseerMissile` | 弹道/远程 | 先知闪电弹弹道飞行/命中综合音效。 |
| `MFBL` | `SNDxMFBL` | `FrostBoltLaunch` | 弹道/远程 | 霜冻弹发射/释放音效。 |
| `MFBH` | `SNDxMFBH` | `FrostBoltHit` | 弹道/远程 | 霜冻弹命中/击中音效。 |
| `MFDL` | `SNDxMFDL` | `FaerieDragonLaunch` | 弹道/远程 | 精灵龙弹道发射/释放音效。 |
| `MFKH` | `SNDxMFKH` | `FanOfKnivesHit` | 弹道/远程 | 刀扇命中/击中音效。 |
| `MFLA` | `SNDxMFLA` | `SearingArrowHit` | 弹道/远程 | 灼热箭命中/击中音效。 |
| `MFLL` | `SNDxMFLL` | `SearingArrowLaunch` | 弹道/远程 | 灼热箭发射/释放音效。 |
| `MFRB` | `SNDxMFRB` | `Fireball` | 弹道/远程 | 火球飞行/爆裂音效。 |
| `MFRL` | `SNDxMFRL` | `FireballLaunch` | 弹道/远程 | 火球发射/释放音效。 |
| `MGML` | `SNDxMGML` | `GryphonRiderMissileLaunch` | 弹道/远程 | 狮鹫锤弹弹道发射音效。 |
| `MGRH` | `SNDxMGRH` | `GargoyleMissileHit` | 弹道/远程 | 石像鬼弹道命中音效。 |
| `MGRL` | `SNDxMGRL` | `GargoyleMissileLaunch` | 弹道/远程 | 石像鬼弹道发射音效。 |
| `MGUA` | `SNDxMGUA` | `GuardTowerMissileHit` | 弹道/远程 | 箭塔/防御塔弹道命中音效。 |
| `MHAR` | `SNDxMHAR` | `HarpyMissileHit` | 弹道/远程 | 鹰身女妖弹道命中音效。 |
| `MHRL` | `SNDxMHRL` | `HarpyMissileLaunch` | 弹道/远程 | 鹰身女妖弹道发射音效。 |
| `MHNL` | `SNDxMHNL` | `HunterMissileLaunch` | 弹道/远程 | 女猎手月刃弹道发射音效。 |
| `MHUN` | `SNDxMHUN` | `HunterMissileHit` | 弹道/远程 | 女猎手月刃弹道命中音效。 |
| `MKGL` | `SNDxMKGL` | `KeeperOfTheGroveMissileLaunch` | 弹道/远程 | 丛林守护者弹道发射音效。 |
| `MKGH` | `SNDxMKGH` | `KeeperOfTheGroveMissileHit` | 弹道/远程 | 丛林守护者弹道命中音效。 |
| `MKML` | `SNDxMKML` | `NecromancerMissileLaunch` | 弹道/远程 | 亡灵巫师弹道发射音效。 |
| `MKMH` | `SNDxMKMH` | `NecromancerMissileHit` | 弹道/远程 | 亡灵巫师弹道命中音效。 |
| `MLIC` | `SNDxMLIC` | `LichMissile` | 弹道/远程 | 巫妖弹道飞行/命中综合音效。 |
| `MLSL` | `SNDxMLSL` | `BansheeMissileLaunch` | 弹道/远程 | 女妖弹道发射音效。 |
| `MLSH` | `SNDxMLSH` | `BansheeMissileHit` | 弹道/远程 | 女妖弹道命中音效。 |
| `MMEA` | `SNDxMMEA` | `MeatWagonMissileHit` | 弹道/远程 | 绞肉车弹药弹道命中音效。 |
| `MMTI` | `SNDxMMTI` | `Mortar` | 弹道/远程 | 迫击炮弹命中/爆炸音效。 |
| `MNCH` | `SNDxMNCH` | `NecromancerMissileHit` | 弹道/远程 | 亡灵巫师弹道命中音效。 |
| `MNCL` | `SNDxMNCL` | `NecromancerMissileLaunch` | 弹道/远程 | 亡灵巫师弹道发射音效。 |
| `MPAH` | `SNDxMPAH` | `PoisonArrowHit` | 弹道/远程 | 毒箭命中/击中音效。 |
| `MPML` | `SNDxMPML` | `PriestMissileLaunch` | 弹道/远程 | 牧师光弹弹道发射音效。 |
| `MPMH` | `SNDxMPMH` | `PriestMissileHit` | 弹道/远程 | 牧师光弹弹道命中音效。 |
| `MPXL` | `SNDxMPXL` | `PhoenixMissileLaunch` | 弹道/远程 | 凤凰火弹弹道发射音效。 |
| `MRAN` | `SNDxMRAN` | `RangerMissile` | 弹道/远程 | 游侠箭矢弹道飞行/命中综合音效。 |
| `MRIF` | `SNDxMRIF` | `Rifle` | 弹道/远程 | 火枪射击音效。 |
| `MSBL` | `SNDxMSBL` | `PriestMissileLaunch` | 弹道/远程 | 牧师光弹弹道发射音效。 |
| `MSBH` | `SNDxMSBH` | `PriestMissileHit` | 弹道/远程 | 牧师光弹弹道命中音效。 |
| `MSEH` | `SNDxMSEH` | `SentinelMissileHit` | 弹道/远程 | 哨兵飞镖弹道命中音效。 |
| `MSEL` | `SNDxMSEL` | `SentinelMissileLaunch` | 弹道/远程 | 哨兵飞镖弹道发射音效。 |
| `MSHD` | `SNDxMSHD` | `ShadowHunterMissileLaunch` | 弹道/远程 | 暗影猎手弹道发射音效。 |
| `MSHH` | `SNDxMSHH` | `ShadowHunterMissileHit` | 弹道/远程 | 暗影猎手弹道命中音效。 |
| `MSMH` | `SNDxMSMH` | `SorceressMissileHit` | 弹道/远程 | 女巫弹道命中音效。 |
| `MSML` | `SNDxMSML` | `SorceressMissileLaunch` | 弹道/远程 | 女巫弹道发射音效。 |
| `MSNL` | `SNDxMSNL` | `SnapDragonMissileLaunch` | 弹道/远程 | 飞蛇/毒蜥弹道发射音效。 |
| `MSPR` | `SNDxMSPR` | `Spear` | 弹道/远程 | 长矛投掷/命中音效。 |
| `MSVL` | `SNDxMSVL` | `GargoyleMissileLaunch` | 弹道/远程 | 石像鬼弹道发射音效。 |
| `MSVH` | `SNDxMSVH` | `GargoyleMissileHit` | 弹道/远程 | 石像鬼弹道命中音效。 |
| `MTBL` | `SNDxMTBL` | `TrollBatriderMissileLaunch` | 弹道/远程 | 巨魔蝙蝠骑士弹道发射音效。 |
| `MWAT` | `SNDxMWAT` | `WaterElementalMissile` | 弹道/远程 | 水元素弹道飞行/命中综合音效。 |
| `MWEB` | `SNDxMWEB` | `WebMissileLaunch` | 弹道/远程 | 蛛网弹道发射音效。 |
| `MWIN` | `SNDxMWIN` | `DragonHawkMissileHit` | 弹道/远程 | 龙鹰弹道命中音效。 |
| `MWNL` | `SNDxMWNL` | `DragonHawkMissileLaunch` | 弹道/远程 | 龙鹰弹道发射音效。 |
| `MWYV` | `SNDxMWYV` | `WyvernSpearMissile` | 弹道/远程 | 双足飞龙毒矛弹道飞行/命中综合音效。 |
| `MZIG` | `SNDxMZIG` | `ZigguratMissileLaunch` | 弹道/远程 | 通灵塔弹道发射音效。 |
| `MZGH` | `SNDxMZGH` | `ZigguratMissileHit` | 弹道/远程 | 通灵塔弹道命中音效。 |
| `MZFL` | `SNDxMZFL` | `ZigguratFrostMissileLaunch` | 弹道/远程 | 冰塔霜冻弹道发射音效。 |
| `MZFH` | `SNDxMZFH` | `ZigguratFrostMissileHit` | 弹道/远程 | 冰塔霜冻弹道命中音效。 |
| `GSMN` | `SNDxGSMN` | `ExpansionGlueMonster` | 界面/剧情 | 资料片界面怪物/菜单音效。 |
| `AIFT` | `SNDxAIFT` | `FinalCinematic` | 界面/剧情 | 最终电影/剧情音效。 |

## 按类型分组索引

### 技能/法术（133）

- `AAMS` 反魔法外壳/魔法护盾开启音效；`AAST` 先祖之魂/复活类巫术音效；`AAVE` 黑曜石像变形/切换形态音效；`ABLO` 嗜血术施放/加速增益音效；`ABRW` 钻地/潜入地下音效；`ABSK` 狂战士怒吼/狂暴启动音效；`ABTR` 战吼/咆哮类增益音效；`ACAN` 食尸/吞食尸体音效
- `ACBC` 火焰吐息音效；`ACBF` 冰霜吐息音效；`ACCV` 粉碎波/水浪发出音效；`ACWD` 粉碎波/水浪命中伤害音效；`ACLB` 电影/剧情用闪电打击音效；`ACRI` 残废/削弱施法音效；`ACRS` 诅咒施法音效；`ACSI` 沉默施法/范围静默音效
- `ACSL` 野怪睡眠/入睡音效；`ACYB` 龙卷风生成音效；`ADEF` 步兵防御姿态切换音效；`ADCM` 利爪德鲁伊变熊音效；`ADCA` 利爪德鲁伊变回/备用形态音效；`ADEV` 吞噬目标音效；`ADHM` 恶魔猎手恶魔变身音效；`ADIS` 驱散魔法音效
- `ADTM` 猛禽德鲁伊变鸟音效；`ADTA` 猛禽德鲁伊变回/备用形态音效；`ADVP` 吞噬后吐出单位/残渣音效；`AEAT` 吃树咀嚼音效；`AEBA` 树皮术/木质护甲增益音效；`AEBD` 地缚/网住目标音效；`AEBL` 闪烁施法者端音效；`AEBT` 闪烁落点端音效
- `AHDR` 吸魔法/抽魔施法者端音效；`AHEA` 普通治疗音效；`AHER` 英雄升级音效；`AHFS` 烈焰风暴施放/引燃音效；`AHFT` 烈焰风暴目标区域燃烧音效；`AHHB` 圣光/神圣弹命中音效；`AHMC` 混乱标记/混乱化音效；`AHMT` 群体传送音效
- `AHRE` 复活术音效；`AHRV` 人族英雄复活音效；`AHTB` 风暴之锤命中/重击音效；`AHSL` 风暴之锤发射音效；`AHTC` 雷霆一击/地面震荡音效；`AHWD` 治疗守卫生成音效；`AICB` 腐蚀之球发射音效；`AICH` 腐蚀之球命中音效
- `AIDC` 中和/驱散类魔杖命中音效；`AILL` 幻象物品/镜像生成音效；`AIMA` 使用魔法药水音效；`AINB` 地狱火陨落/生成音效；`AINF` 心灵之火增益音效；`AIRE` 恢复药水使用音效；`AISO` 灵魂宝石/摄魂类物品音效；`AITM` 拾取/阅读书本音效
- `AIVS` 隐身/进入隐形音效；`AKDL` 科多战鼓左鼓点；`AKDR` 科多战鼓右鼓点；`ALSD` 闪电护盾启动/环绕电流音效；`ANBA` 黑暗之箭命中音效；`ANDO` 末日目标/诅咒降临音效；`ANDT` 显示地图/侦察揭示音效；`ANEU` 中立建筑激活/交互音效
- `ANHT` 恐怖嚎叫音效；`ANMO` 季风闪电/雷雨打击音效；`ANPA` 寄生虫/寄生施法音效；`ANSA` 牺牲单位音效；`ANSD` 熊猫酒/烈酒饮用音效；`ANSS` 法术护盾护符触发音效；`AOAG` 守卫/图腾生成音效；`AOCR` 致命一击/暴击切砍音效
- `AOHW` 治疗波跳跃到目标音效；`AOLB` 闪电链/闪电箭打击音效；`AOMC` 镜像术生成音效；`AORE` 重生/复活触发音效；`AORV` 兽族英雄复活音效；`AOSD` 野性狼魂召唤完成音效；`AOSF` 野性狼魂目标/生成点音效；`AOSH` 冲击波发出/地面推进音效
- `AOVD` 巫毒/大巫毒生成音效；`AOWS` 战争践踏/地面重踏音效；`AOWW` 旋风斩/持续旋转切割音效；`APHS` 相位转移/短暂无敌闪避音效；`APHX` 凤凰生成音效；`APLA` 变形术空中/飞行目标音效；`APLD` 变形完成音效；`APOL` 变形术施放音效
- `APRG` 净化/驱散减速音效；`APXB` 凤凰蛋生成音效；`AREJ` 回春术/持续治疗音效；`AREP` 修理敲击/维修音效；`AROO` 扎根/根须缠绕地面音效；`ASHP` 暗影契约/黑暗能量音效；`ASKA` 召唤骷髅弓箭手音效；`ASKW` 召唤骷髅战士音效
- `ASLC` 减速术施法者端音效；`ASLO` 减速术命中/目标端音效；`ASPL` 灵魂链接音效；`ASPS` 法术窃取目标端音效；`ASTO` 石像鬼石像形态切换音效1；`AST2` 石像鬼石像形态切换音效2；`AST3` 石像鬼石像形态切换音效3；`ASTA` 石像鬼解除石像形态/备用切换音效
- `ASTB` 静滞陷阱/图腾生成音效；`ASTH` 奔袭/群兽冲撞命中音效；`ASWB` 幽灵狼生成音效；`ASWE` 水元素生成音效；`ATAU` 嘲讽音效；`ATRB` 树墙/树木生成音效；`AUB1` 不死族建筑建造/召唤生成音效1；`AUB2` 不死族建筑建造/召唤生成音效2
- `AUB3` 不死族建筑建造/召唤生成音效3；`AUB4` 不死族建筑建造/召唤生成音效4；`AUCB` 圣甲虫/小虫生成音效；`AUCD` 腐臭蜂群/蝠群命中伤害音效；`AUCH` 魅惑/控制目标音效；`AUCO` 不稳定化合物/自爆投掷音效；`AUCS` 腐臭蜂群/蝠群发射音效；`AUDA` 黑暗仪式音效
- `AUDS` 黑暗召唤目标点音效；`AUFA` 霜冻护甲增益音效；`AUFN` 霜冻新星爆发音效；`AUGS` 聚影/隐蔽形态切换音效；`AUGA` 聚影/隐蔽形态解除音效；`AUHF` 邪恶狂热音效；`AUIH` 穿刺落地/地刺钻出音效；`AUIM` 穿刺施放/地刺推进音效
- `AUIT` 穿刺命中/击飞音效；`AUPR` 拔根/古树起身音效；`AURV` 不死族英雄复活音效；`AWEB` 蛛网束缚/发射音效；`AWRS` 粉碎/重击溅射音效

### 弹道/远程（102）

- `ACRH` 腐蚀吐息弹道命中音效；`ACRL` 腐蚀吐息弹道发射音效；`AHMF` 魔力之焰/法力闪耀弹道音效，偏滋滋电流感；`ANSM` 烈酒投掷/酒液弹道音效；`APSH` 占据弹道命中音效；`APSL` 占据弹道发射音效；`ASPM` 法术窃取弹道发射音效；`AUDM` 黑暗召唤弹道发射音效
- `MABS` 吸收魔法/法力抽取发射/释放音效；`MANG` 先祖守护者弹道命中音效；`MANL` 先祖守护者弹道发射音效；`MANP` 远古守护者弹道命中音效；`MAPL` 远古守护者弹道发射音效；`MARL` 箭矢发射/释放音效；`MARR` 箭矢命中/击中音效；`MAXE` 斧头弹道命中音效
- `MAXL` 斧头弹道发射音效；`MBAL` 弩车弹道命中音效；`MBAN` 女妖弹道命中音效；`MBHT` 船只炮弹弹道命中音效；`MBHL` 船只炮弹弹道发射音效；`MBML` 血法师弹道发射音效；`MBNL` 女妖弹道发射音效；`MBLT` 能量弹/闪电弹飞行或命中音效
- `MBRH` 豪猪刺弹弹道命中音效；`MBRL` 豪猪刺弹弹道发射音效；`MBSL` 牧师光弹弹道发射音效；`MBSH` 牧师光弹弹道命中音效；`MCAH` 奇美拉酸液命中/击中音效；`MCAL` 奇美拉酸液发射/释放音效；`MCAN` 炮塔炮弹弹道飞行/命中综合音效；`MCAT` 投石车音效
- `MCDA` 冰箭音效；`MCRH` 地穴恶魔蛛网弹弹道命中音效；`MCRL` 地穴恶魔蛛网弹弹道发射音效；`MDEM` 恶魔猎手飞刃弹道命中音效；`MDLL` 毁灭者弹道发射音效；`MDML` 恶魔猎手飞刃弹道发射音效；`MDOC` 巫医弹道发射音效；`MDOH` 巫医弹道命中音效
- `MDRY` 树妖投矛弹道飞行/命中综合音效；`MDTL` 猛禽德鲁伊弹道发射音效；`MDTH` 猛禽德鲁伊弹道命中音效；`MDVM` 吞噬魔法发射/释放音效；`MFAH` 霜冻箭命中/击中音效；`MFAL` 霜冻箭发射/释放音效；`MFAR` 先知闪电弹弹道飞行/命中综合音效；`MFBL` 霜冻弹发射/释放音效
- `MFBH` 霜冻弹命中/击中音效；`MFDL` 精灵龙弹道发射/释放音效；`MFKH` 刀扇命中/击中音效；`MFLA` 灼热箭命中/击中音效；`MFLL` 灼热箭发射/释放音效；`MFRB` 火球飞行/爆裂音效；`MFRL` 火球发射/释放音效；`MGML` 狮鹫锤弹弹道发射音效
- `MGRH` 石像鬼弹道命中音效；`MGRL` 石像鬼弹道发射音效；`MGUA` 箭塔/防御塔弹道命中音效；`MHAR` 鹰身女妖弹道命中音效；`MHRL` 鹰身女妖弹道发射音效；`MHNL` 女猎手月刃弹道发射音效；`MHUN` 女猎手月刃弹道命中音效；`MKGL` 丛林守护者弹道发射音效
- `MKGH` 丛林守护者弹道命中音效；`MKML` 亡灵巫师弹道发射音效；`MKMH` 亡灵巫师弹道命中音效；`MLIC` 巫妖弹道飞行/命中综合音效；`MLSL` 女妖弹道发射音效；`MLSH` 女妖弹道命中音效；`MMEA` 绞肉车弹药弹道命中音效；`MMTI` 迫击炮弹命中/爆炸音效
- `MNCH` 亡灵巫师弹道命中音效；`MNCL` 亡灵巫师弹道发射音效；`MPAH` 毒箭命中/击中音效；`MPML` 牧师光弹弹道发射音效；`MPMH` 牧师光弹弹道命中音效；`MPXL` 凤凰火弹弹道发射音效；`MRAN` 游侠箭矢弹道飞行/命中综合音效；`MRIF` 火枪射击音效
- `MSBL` 牧师光弹弹道发射音效；`MSBH` 牧师光弹弹道命中音效；`MSEH` 哨兵飞镖弹道命中音效；`MSEL` 哨兵飞镖弹道发射音效；`MSHD` 暗影猎手弹道发射音效；`MSHH` 暗影猎手弹道命中音效；`MSMH` 女巫弹道命中音效；`MSML` 女巫弹道发射音效
- `MSNL` 飞蛇/毒蜥弹道发射音效；`MSPR` 长矛投掷/命中音效；`MSVL` 石像鬼弹道发射音效；`MSVH` 石像鬼弹道命中音效；`MTBL` 巨魔蝙蝠骑士弹道发射音效；`MWAT` 水元素弹道飞行/命中综合音效；`MWEB` 蛛网弹道发射音效；`MWIN` 龙鹰弹道命中音效
- `MWNL` 龙鹰弹道发射音效；`MWYV` 双足飞龙毒矛弹道飞行/命中综合音效；`MZIG` 通灵塔弹道发射音效；`MZGH` 通灵塔弹道命中音效；`MZFL` 冰塔霜冻弹道发射音效；`MZFH` 冰塔霜冻弹道命中音效

### 攻击动作（57）

- `KANG` 先祖守护者攻击出手/挥击音效；`KAOE` 大地古树攻击出手/挥击音效；`KAOM` 月之古树攻击出手/挥击音效；`KAW1` 荒野古树攻击出手/挥击音效；`KAW2` 荒野古树攻击出手/挥击音效；`KANP` 远古守护者远程攻击出手音效；`KAP1` 远古守护者近战攻击出手音效；`KAP2` 远古守护者近战攻击出手音效
- `KBAL` 炎魔攻击出手/挥击音效；`KAZB` 蓝龙攻击出手/挥击音效；`KBLL` 弩车攻击出手/挥击音效；`KBLB` 黑龙攻击出手/挥击音效；`KBRB` 青铜龙攻击出手/挥击音效；`KBST` 兽王攻击出手/挥击音效；`KGRB` 绿龙攻击出手/挥击音效；`KRDB` 红龙攻击出手/挥击音效
- `KBM1` 剑圣攻击出手/挥击音效；`KBM2` 剑圣攻击出手/挥击音效；`KCAN` 炮塔攻击出手/挥击音效；`KCAT` 投石车攻击出手/挥击音效；`KCL1` 地穴领主攻击出手/挥击音效；`KCL2` 地穴领主攻击出手/挥击音效；`KDH1` 恶魔猎手英雄攻击出手/挥击音效；`KDH2` 恶魔猎手英雄攻击出手/挥击音效
- `KFAR` 先知攻击出手/挥击音效；`KFRB` 冰霜巨龙攻击出手/挥击音效；`KGUA` 防御塔攻击出手/挥击音效；`KGYR` 飞行机器攻击出手/挥击音效；`KIN1` 地狱火攻击出手/挥击音效；`KIN2` 地狱火攻击出手/挥击音效；`KINJ` 地狱火巨兽攻击出手/挥击音效；`KINM` 地狱火机器攻击出手/挥击音效
- `KIRG` 铁傀儡攻击出手/挥击音效；`KLIC` 巫妖攻击出手/挥击音效；`KMKG` 山丘之王攻击出手/挥击音效；`KMT1` 迫击炮小队攻击出手/挥击音效；`KMT2` 迫击炮小队攻击出手/挥击音效；`KMTW` 绞肉车攻击出手/挥击音效；`KPB1` 熊猫酒仙攻击出手/挥击音效；`KPB2` 熊猫酒仙攻击出手/挥击音效
- `KPL1` 圣骑士攻击出手/挥击音效；`KPL2` 圣骑士攻击出手/挥击音效；`KPD1` 深渊领主攻击出手/挥击音效；`KPD2` 深渊领主攻击出手/挥击音效；`KPD3` 深渊领主攻击出手/挥击音效；`KPS1` 深渊领主重砸/猛击攻击音效；`KPS2` 深渊领主重砸/猛击攻击音效；`KRG1` 岩石傀儡攻击出手/挥击音效
- `KRG2` 岩石傀儡攻击出手/挥击音效；`KRIF` 火枪手攻击出手/挥击音效；`KRN1` 游侠英雄攻击出手/挥击音效；`KRN2` 游侠英雄攻击出手/挥击音效；`KSTT` 蒸汽坦克攻击出手/挥击音效；`KTC1` 牛头人酋长攻击出手/挥击音效；`KTC2` 牛头人酋长攻击出手/挥击音效；`KTOL` 生命之树攻击出手/挥击音效
- `KWAR` 守望者攻击出手/挥击音效

### 死亡/爆炸（222）

- `ACYD` 龙卷风消失音效；`AOMI` 镜像死亡/破碎消失音效；`ASTS` 静滞陷阱/图腾消失或触发音效；`AUDC` 死亡缠绕音效；`AUDP` 死亡契约目标吞噬音效；`AUDT` 死亡凋零目标区域音效；`DABA` 憎恶备用/变身形态死亡音效；`DABO` 憎恶死亡音效
- `DACO` 侍僧死亡音效；`DADR` 猛禽德鲁伊死亡音效；`DALB` 信天翁死亡音效；`DAMG` 大法师英雄死亡音效；`DANG` 守卫/图腾死亡音效；`DANP` 树人死亡音效；`DARC` 蛛魔/蜘蛛怪死亡音效；`DARG` 装甲傀儡死亡音效
- `DART` 火炮/攻城爆炸死亡音效；`DASS` 刺客死亡音效；`DWTC` 守望者/看守者死亡音效；`DBAL` 弩车死亡音效；`DBAN` 女妖死亡音效；`DBAT` 蝙蝠骑士死亡音效；`DBES` 血法师英雄死亡音效；`DBLA` 剑圣英雄死亡音效
- `DBNT` 强盗死亡音效；`DBRG` 桥梁毁灭/倒塌音效；`DBRI` 豪猪/刚背兽死亡音效；`DBSF` 黑鹿雌性死亡音效；`DBSM` 黑鹿雄性死亡音效；`DBSP` 战舰死亡音效；`DBSX` 黑曜石复仇者/毁灭者死亡音效；`DBTM` 兽王英雄死亡音效
- `DCAT` 投石车死亡音效；`DCBL` 城市场景建筑毁灭/倒塌音效；`DCEN` 半人马死亡音效；`DCNA` 半人马弓箭手死亡音效；`DCRL` 地穴领主英雄死亡音效；`DDEM` 恶魔猎手英雄死亡音效；`DDHK` 龙鹰死亡音效；`DDKN` 死亡骑士英雄死亡音效
- `DDKR` 黑暗游侠死亡音效；`DDMA` 恶魔猎手英雄备用/变身形态死亡音效；`DDMG` 末日守卫死亡音效；`DDOC` 利爪德鲁伊死亡音效；`DDCA` 利爪德鲁伊备用/变身形态死亡音效；`DDMN` 恶魔女卫/魅魔死亡音效；`DDNW` 沙虫死亡音效；`DDTA` 猛禽德鲁伊备用/变身形态死亡音效
- `DDRA` 巨龙死亡音效；`DDRL` 恐惧魔王英雄死亡音效；`DDRN` 德莱尼死亡音效；`DDRS` 龙人死亡音效；`DDRY` 树妖/小鹿死亡音效；`DDSH` 人族英雄/灵体消散音效；`DDSN` 暗夜精灵英雄/灵体消散音效；`DDSO` 兽族英雄/灵体消散音效
- `DDWF` 恐狼死亡音效；`DEBA` 行走中的暗夜建筑/古树毁灭/倒塌音效；`DEBC` 暗夜建筑取消毁灭/倒塌音效；`DEGS` 虫卵/蛋囊死亡音效；`DELB` 暗夜大型建筑毁灭/倒塌音效；`DELS` 暗夜小型建筑毁灭/倒塌音效；`DENT` 古树/树人死亡音效；`DFAR` 先知英雄死亡音效
- `DFCO` 无面者死亡音效；`DFDR` 精灵龙死亡音效；`DFLG` 恶魔卫士死亡音效；`DFEL` 地狱犬死亡音效；`DFOO` 步兵死亡音效；`DFOR` 遗忘者死亡音效；`DFRG` 青蛙死亡音效；`DFRM` 霜之哀伤死亡音效
- `DFRT` 森林巨魔死亡音效；`DFRW` 冰霜巨龙死亡音效；`DFSP` 森林巨魔暗影牧师死亡音效；`DFTN` 遗忘者触手死亡音效；`DFUR` 熊怪死亡音效；`DGAR` 石像鬼死亡音效；`DGAS` 石像鬼石化死亡音效；`DGAT` 大门死亡音效
- `DGHO` 食尸鬼死亡音效；`DGLD` 金矿死亡音效；`DGLM` 地精地雷死亡音效；`DGNA` 豺狼人弓箭手死亡音效；`DGNL` 豺狼人死亡音效；`DGOB` 宝石方尖碑死亡音效；`DGRU` 兽人步兵死亡音效；`DGRY` 狮鹫骑士死亡音效
- `DGRZ` 灰熊死亡音效；`DGRS` 熊水中死亡音效；`DGSD` 地精工兵死亡音效；`DGSP` 地精工兵自爆音效；`DGST` 巨型海龟死亡音效；`DTDS` 巨型海龟水中死亡音效；`DGYR` 飞行机器死亡音效；`DGZP` 地精飞艇死亡音效
- `DHBC` 人族建筑取消毁灭/倒塌音效；`DHIP` 角鹰兽死亡音效；`DHLB` 人族大型建筑毁灭/倒塌音效；`DHLS` 人族小型建筑毁灭/倒塌音效；`DHMC` 寄居蟹死亡音效；`DHOR` 马死亡音效；`DHRP` 鹰身女妖死亡音效；`DHUN` 猎头者死亡音效
- `DHWD` 治疗守卫死亡音效；`DHDA` 九头蛇死亡音效；`DHDS` 九头蛇水中死亡音效；`DHYD` 刺蛇死亡音效；`DICT` 冰霜巨魔死亡音效；`DINF` 地狱火死亡音效；`DINM` 地狱火机器死亡音效；`DIPW` 囚车死亡音效
- `DIRG` 铁傀儡死亡音效；`DJAN` 吉安娜死亡音效；`DKBS` 狗头人掘地者死亡音效；`DKEE` 丛林守护者英雄死亡音效；`DKNI` 骑士死亡音效；`DKOB` 狗头人死亡音效；`DKOD` 科多兽死亡音效；`DLIC` 巫妖英雄死亡音效
- `DLOC` 蝗虫死亡音效；`DLVR` 拉杆/机关死亡音效；`DMAG` 猛犸人/马格纳托死亡音效；`DMAK` 玛库拉死亡音效；`DMAM` 猛犸死亡音效；`DMGS` 穆戈尔/娜迦小兵水中死亡音效；`DMGT` 山岭巨人死亡音效；`DMKG` 山丘之王英雄死亡音效
- `DMLF` 玛法里奥死亡音效；`DMOO` 月之女祭司英雄死亡音效；`DMOR` 迫击炮小队死亡音效；`DMTW` 绞肉车死亡音效；`DMUR` 鱼人死亡音效；`DNBL` 娜迦建筑死亡音效；`DNDR` 虚空龙死亡音效；`DNDS` 人族英雄/灵体消散音效
- `DNEC` 亡灵巫师死亡音效；`DMYR` 娜迦暴徒死亡音效；`DMYS` 娜迦暴徒水中死亡音效；`DNSR` 娜迦海妖死亡音效；`DNSS` 娜迦海妖水中死亡音效；`DNSW` 娜迦海巫死亡音效；`DNWS` 娜迦海巫水中死亡音效；`DOBS` 黑曜石像死亡音效
- `DOGR` 食人魔死亡音效；`DOLB` 兽族大型建筑毁灭/倒塌音效；`DOLS` 兽族小型建筑毁灭/倒塌音效；`DORW` 兽族术士死亡音效；`DOWB` 枭兽死亡音效；`DOWL` 雪枭死亡音效；`DPAL` 圣骑士英雄死亡音效；`DPMB` 熊猫酒仙英雄死亡音效
- `DPEN` 企鹅死亡音效；`DPEO` 苦工死亡音效；`DPES` 农民死亡音效；`DPHX` 凤凰死亡音效；`DPIG` 猪死亡音效；`DPIT` 地穴恶魔死亡音效；`DPLD` 深渊领主死亡音效；`DPRS` 牧师死亡音效
- `DQBS` 豪猪野兽死亡音效；`DRAI` 狼骑兵死亡音效；`DRAN` 弓箭手死亡音效；`DRAT` 老鼠死亡音效；`DREV` 亡魂/复仇者死亡音效；`DRKG` 岩石傀儡死亡音效；`DRKW` 岩石墙死亡音效；`DRHG` 骑乘角鹰兽死亡音效
- `DRIF` 火枪手死亡音效；`DSAT` 萨特死亡音效；`DSCB` 圣甲虫死亡音效；`DSEL` 海豹死亡音效；`DSEN` 哨兵死亡音效；`DSGT` 海巨人死亡音效；`DSGW` 海巨人水中死亡音效；`DSHD` 阴影死亡音效
- `DSHH` 暗影猎手英雄死亡音效；`DSHM` 萨满死亡音效；`DSHP` 绵羊死亡音效；`DSHW` 绵羊水中死亡音效；`DSKE` 骷髅死亡音效；`DSKK` 石龙子/蜥蜴死亡音效；`DSLG` 淤泥怪死亡音效；`DSND` 飞蛇/毒蜥死亡音效
- `DSNS` 飞蛇/毒蜥水中死亡音效；`DSOR` 女巫死亡音效；`DSPB` 破法者死亡音效；`DSPC` 蜘蛛蟹死亡音效；`DSPD` 蜘蛛死亡音效；`DSPL` 溅射/肉块死亡音效；`DSPV` 复仇之魂死亡音效；`DSTT` 蒸汽坦克死亡音效
- `DTAU` 牛头人死亡音效；`DTCH` 牛头人酋长英雄死亡音效；`DTRW` 树墙死亡音效；`DTUS` 海象人死亡音效；`DUAB` 不死族飞艇/空中驳船死亡音效；`DUBC` 不死族建筑取消毁灭/倒塌音效；`DUDS` 不死族英雄/灵体消散音效；`DULB` 不死族大型建筑毁灭/倒塌音效
- `DULS` 不死族小型建筑毁灭/倒塌音效；`DUNB` 破碎者/不屈者死亡音效；`DVLC` 村民小孩死亡音效；`DVLM` 男村民死亡音效；`DVLW` 女村民死亡音效；`DVNG` 复仇天神死亡音效；`DVUL` 秃鹫死亡音效；`DWAR` 术士死亡音效
- `DWAT` 水元素死亡音效；`DWCD` 双足飞龙笼死亡音效；`DWDS` 翼蛇死亡音效；`DWEN` 温迪戈死亡音效；`DWIT` 巫医死亡音效；`DWLD` 军阀死亡音效；`DWLF` 狼死亡音效；`DWRD` 守望者英雄死亡音效
- `DWRE` 战鹰死亡音效；`DWSP` 小精灵死亡音效；`DWYV` 双足飞龙骑士死亡音效；`DZOM` 僵尸死亡音效；`KDK1` 死亡骑士英雄攻击出手/挥击音效；`MDCL` 死亡缠绕弹道音效

### 脚步/移动（10）

- `FBCL` 测试脚步声，通常不作为技能音效使用；`FBCR` 测试脚步声，通常不作为技能音效使用；`FDFL` 厚重/大型单位脚步声；`FDFR` 厚重/大型单位脚步声；`FDSL` 地穴恶魔/爬行类脚步声；`FDSR` 地穴恶魔/爬行类脚步声；`FHCL` 英雄电影镜头脚步声；`FHCR` 英雄电影镜头脚步声
- `AWBS` 大型单位水中脚步/踩水音效；`AWST` 普通水中脚步/踩水音效

### 界面/剧情（8）

- `ABPD` 界面双侧弹窗收起音效；`ABPU` 界面双侧弹窗弹出音效；`ALPD` 界面左侧弹窗收起音效；`ALPU` 界面左侧弹窗弹出音效；`ARPD` 界面右侧弹窗收起音效；`ARPU` 界面右侧弹窗弹出音效；`GSMN` 资料片界面怪物/菜单音效；`AIFT` 最终电影/剧情音效

## 来源与校验说明

- 数据基于《魔兽争霸 III 美术工具文档》的“事件对象”说明与“附录 E：声音数据”。
- 原始资料只给出“声音事件代码”与 `SoundAlias`；本文件的“类型/简单描述”是按 `SoundAlias` 语义、魔兽争霸 III 常用技能/单位名和 MDL 用途整理的中文说明。
- 如果你要精确听感，建议在世界编辑器声音编辑器，或 CascView/MPQ 工具中按 `SoundAlias`/相关单位名试听后再定稿。