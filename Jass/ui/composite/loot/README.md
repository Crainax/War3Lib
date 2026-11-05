# 战利品展示（LootReveal）

War3Lib 本地 UI 组件。`lootPopup` 为半透明弹窗，`lootBanner` 为压暗背景、两条渐变线的半屏庆祝。两种工厂都返回 `lootReveal`，共用最多 10 件奖励、错峰弹出、扩散光环、星芒、品质边框与悬浮回调。本组件不发放奖励、不访问存档、不暂停游戏。

半屏底部为纯文字“点击屏幕任意位置继续 · ESC”，不创建底部按钮；关闭由全屏输入区域与 ESC 处理。弹窗保留关闭按钮。

## 快速调用

使用本仓 `.cfg` 依赖注入。需要宏常量时只显式包含常量头，不要再直接 include 三个业务库，以免与两阶段依赖注入重复。

```jass
#include "Crainax/ui/composite/loot/LootConstants.j"
//! zinc
library LootExample requires LootPopup, LootBanner {
    private function OnEnter(integer view, integer index, integer data, integer frame) {
        // 本地显示 Tooltip；data 是调用方提供的业务快照索引。
    }
    private function OnLeave(integer view, integer index, integer data, integer frame) {
        // 销毁本组件的 Tooltip。
    }
    private function OnClose(integer view) {
        lootReveal result = view;
        // 不需要重播时回收；直接 destroy 触发此回调时 isExist 为 false。
        if (result.isExist()) { result.destroy(); }
    }
    public function ShowReward(player owner) {
        lootReveal result = 0;
        if (owner != GetLocalPlayer()) { return; }
        result = lootPopup.create(DzGetGameUI()); // 半屏改为 lootBanner.create
        result.setTitle("打造成功").setSubtitle("已放入仓库").setCloseText("继续打造");
        result.onEnter(lootItemEvent.OnEnter).onLeave(lootItemEvent.OnLeave);
        result.onClose(lootCloseEvent.OnClose);
        result.addItem("ReplaceableTextures\\CommandButtons\\BTNOrbOfFrost.blp", "圣晶石", 1, LOOT_STYLE_EPIC, 123);
        if (!result.show()) {
            // 创建失败可能已触发 OnClose 并销毁实例，避免重复回收。
            if (result.isExist()) { result.destroy(); }
        }
    }
}
//! endzinc
```

图标路径必须是地图中已存在或由调用方声明 dependency 的资源。名称为不含 Warcraft 颜色控制符的普通 UTF-8 文本，卡片最多显示 7 个字符并追加省略号；`getName(index)` 保留完整名称。数量右下角显示，名称、数量不会被组件自动合并。品质 `COMMON/RARE/EPIC/LEGENDARY` 仅为显示样式，值为 0..3，不代表游戏中的概率、强度或存档规则。

## 接口约定

- `addItem(path,name,quantity,style,userData)`：返回 1..10 的序号；容量已满、无效路径、数量小于 1、无效样式或正在展示/排队时返回 0。调用方必须处理失败，不能把返回 0 当成已展示。
- `setTitle/setSubtitle/setCloseText`：只在未展示/未排队时修改。默认副标题为空，不擅自宣称发奖成功。
- `show()`：返回是否开始展示或成功排队。重复调用不会重复入队；空奖励返回 false。最多 16 个等待实例，满队列返回 false，调用方仍拥有该实例。卡片每帧创建一张，全部创建后开始入场动画；`show()` 返回时不可假定所有图标 frame 已创建，使用 `onReveal` 或 `isReady()` 等待完成。创建过程中也支持 ESC / close / destroy。
- `isShown/isReady/isQueued/getCount/getMode/getName/getUserData/getItemFrame`：查询本地状态。没有创建显示 frame 时 `getItemFrame` 返回 0。
- `close()`：停止展示或取消排队，清理显示资源、ESC 和 hover，保留奖励数据；之后可再次 `show()`。
- `clear()`：仅在已关闭状态允许清空奖励，成功返回 true。
- `destroy()`：完全回收。关闭不默认销毁，持有者负责最终回收，或采用示例的 `onClose` 回调。
- `getActive()/getQueueCount()`：仅本地展示队列查询，不可用于同步玩法判断。

所有回调都是**本地展示回调**：不能在其中发奖、扣资源、存档或创建经典 JASS handle。

立即展示时，若创建失败，`show()` 内部可能先触发 `onClose` 再返回 false。采用上方回调自动销毁的示例时，失败分支必须先检查 `isExist()`，不能无条件再次 destroy。该示例的 `OnClose` 只销毁当前实例；若自定义回调还会创建新实例，应由调用方在销毁时清空自己的持有引用，避免结构体 ID 复用后把新实例当成旧实例。

`onEnter/onLeave/onReveal` 均使用 `lootItemEvent`，参数为 `(view,index,userData,frame)`。`onReveal` 每件每次播放触发一次，适合播放已预创建的本地声音；组件本身不创建 sound。`onClose` 使用 `lootCloseEvent`，参数为 `(view)`，完成展示或取消排队时均通知一次；对已关闭实例重复 close/destroy 不重复通知。

外部回调可在正常通知中 close/destroy，但使用持有引用前必须检查 `isExist()`。清理过程中的 leave、直接析构产生的 close 回调期间，`isExist()` 返回 false，禁止无条件再次 destroy。`onLeave` 参数中的 data/frame 是离开项快照，清理通知时 frame 尚未销毁；此时不要依赖查询 getter 返回已关闭实例的数据。没有“原始 destroy 幂等”保证。

## 播放与输入

- 1 件放大居中；2..5 件单排；6..10 件双排，末排单独居中。
- 0.2 秒开场，单件约 0.4 秒回弹，奖励间隔 0.08 秒，10 件约 1.42 秒进入静止可悬浮状态。
- 弹窗关闭按钮/ESC 退出；半屏显示完成后左键点击展示覆盖区域任意位置退出（包括图标），ESC 可提前退出。其它位于奖励上方的独立 UI 保留自己的输入，不误关闭底下奖励。
- 左键按下时捕获展示会话，释放后再延迟两个动画 tick 关闭；下一批至少间隔 0.1 秒且等鼠标释放，避免同一点击穿透到下一批。底层原生地图/UI 点击穿透仍需实机验证。
- ESC 使用已有 EscStack，只移除自己的条目，不清空其他弹窗。
- `parent` 建议传 `DzGetGameUI()`，保证奖励与常规 Tooltip 的层级兼容；调用方不得在实例存活期间销毁 parent。全屏输入区域覆盖游戏 UI，奖励内容保持居中。
- 不使用手动高 priority；Tooltip 由外部 onEnter/onLeave 创建，测试中使用标准 Tooltip 和 TooltipStack。
- 动画驱动和硬件监听在同步 onInit 创建一次。运行时只创建普通 DzFrame 与本地整数结构，不创建 timer/trigger/effect/unit、不调用随机数。公共驱动常驻、空闲快速返回，避免在共享动画列表中删除当前回调。

## 测试

综合入口：`Jass/ui/composite/loot/LootReveal_Test.j`。用项目“创建/选择单测”任务选中该文件后启动测试地图，或手动将 `Jass/config/UnitTest.h` 的测试 include 指向它。

| 命令 | 内容 |
| --- | --- |
| s1 / s2 / s3 | 弹窗 1 / 5 / 10 件 |
| s4 / s5 / s6 | 半屏 1 / 5 / 10 件 |
| -p N / -b N | 指定 1..10 件弹窗 / 半屏 |
| s7 | 三批依次展示，关闭后自动销毁 |
| s8 | 开始完整分帧回归，需先结束演示队列 |
| s9 | 销毁当前普通样例；回归中则中止并清理测试实例 |
| s10 | 重播当前普通样例 |

开局只打印命令，可直接输入 s1..s6。输入 s8 后，在发令玩家本地运行约 30 秒的分帧回归：空数据/容量/冻结、两种形式 1..10 件创建关闭、FIFO 与取消、ESC、成对悬浮与迟到 leave、回调重入、构建未完成时取消、frame/resize/anchor 回收。额外断言关闭通知次数：正常关闭、取消排队、直接销毁各通知一次，重复 close、close 后 destroy、未展示即 destroy 不额外通知。回归期间请勿移动鼠标到奖励区域或按 ESC，以免干扰悬浮/关闭断言。

用例编号 0..9 为弹窗 1..10 件，10..19 为半屏 1..10 件，20..28 为边界与回调用例。创建、等待真实动画、断言、关闭、销毁分别在不同帧执行，不再在一个测试函数中手动循环 tick 或快进。失败后清理并停止，不把残留实例带进下一个用例；回调若未返回，下一帧输出 case/phase，清理阶段发生中断则要求重启，避免重复回收。结尾输出检查数、失败数、停止位置（完整运行应为 28）。每次 s1..s6 还会输出请求模式、数量、实例、active 与 queue，便于区分命令未收到和正在排队。

编译验证（只编译，不打包、不启动游戏；临时测试入口与版本配置由脚本恢复）：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File D:/War3/Maps/Xlimon/script/agent_compile.ps1 -ProjectPath D:/War3/Library/War3Lib -Mode UNITTEST -UnitTestFile Jass/ui/composite/loot/LootReveal_Test.j
```

实机重点：1/5/6/10 件布局、中文长名称、数量、Tooltip 遮挡、入场时 ESC、半屏图标与空白点击、右键不关闭、关闭后的底层按钮不误触发、排队时关闭/重播、不同宽高比和窗口变化、双端仅一端播放时句柄对等。编译通过不等于这些项目已经通过。

生成代码回归：编译后运行 `python Jass/ui/composite/loot/verify_codegen.py Output/output.j`。该检查要求每个 UI 销毁分支在生成的 JASS 中确实清零字段；曾因字段名 `button` 与原生类型同名，导致编译产物漏掉 `button = 0`，close 后再次 destroy 破坏按钮实例池。现改用 `iconBtn`，游戏内计数回归也会在清理引用未归零时停止，避免继续重复销毁。

## 素材

13 张自制透明 BLP 及其 PNG 源图：`D:/War3Asset/Import/resource/ui/image/loot_*`，通过 `LootReveal.j` 内 `//# dependency:` 导入。渐变线/柔光/边框/光环均由同目录 `build_assets.py` 生成，不使用 AI 生图。还复用已有 `black.blp`。

需要 Python + Pillow 及 BLP.NET；运行 `python Jass/ui/composite/loot/build_assets.py` 可重建。脚本只替换明确命名的 loot_* 资源，可用 `--output` 和 `--converter` 指定路径。PNG/BLP 位于共享资源库，不随 War3Lib Git 提交；脚本是可复现来源。
