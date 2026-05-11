---
name: zinc-ui-async-separation
description: War3Lib UI 组件开发行为规范（Zinc in .j）：约束 UI 本地异步行为与同步数据逻辑分离；规范 onClick/onEnter/onLeave 与 spClick/spEnter/spLeave 的使用边界；规范本地事件转同步事件时的数据打包与触发器接收。用于创建或重构 Jass/ui/composite 下的 UI（如 HeroSelector/Selector/Museum）及相关回调。
---

# War3 UI 异步分层规范

## 强制规则

- 保持 `UI 展示层` 与 `数据/游戏状态层` 分离。
- 把 `GetLocalPlayer()` 分支内的逻辑视为异步本地逻辑；禁止在其中修改同步状态（单位、计时器、全局对局数据等）。
- `show/hide/refresh` 等 UI 生命周期方法禁止做业务数据写入；尤其禁止在 UI 操作链路内执行 `DzAPI_Map_Store*`和其他会导致数据变动的操作。
- 在 UI 回调里只做三类事情：
1. 本地 UI 更新（show/hide/text/texture/位置）
2. 事件参数写入（`currentPosAsync` / `args*` / `eventdata.bind*`）
3. 触发异步到同步桥接（如 `syncBus.DzSyncDataEx`）

## Simple UI 显隐防雷（重要）

- 对 `uiImage.createSimple` / `uiText.createSimple` / `uiBtn.createSimple` 创建的控件，禁止直接调用 `.show(true/false)` 作为显隐手段。
- 原因：`show()` 底层走 `DzFrameShow`，在部分 simple 原生链路会触发本地函数报错。
- 推荐做法：显隐改为 `clearPoint + setPoint`，显示时放回目标锚点，隐藏时移到屏幕外（例如 `DzGetGameUI()` 左下角外）。
- 对 `uiBtn.createSimple` / `SIMPLEBUTTON` 要更严格：不要用两个相对锚点依赖 image/text 去撑开点击区域，显示时优先 `setSize(固定宽高) + setAbsPoint(绝对坐标)`。
- 隐藏 `uiBtn.createSimple` 时不要只 `clearPoint + setAbsPoint`，旧 hit rect 可能残留并截断原生单位面板 hover/click；先 `setSize(0.001, 0.001)` 再移出屏幕。
- 若出现“贴图/文字已经消失，但鼠标仍有点击声或挡住 UnitPanel/Attr 图标”的现象，优先检查 simpleButton 点击矩形是否没有被固定尺寸/缩小尺寸刷新。
- 初始化后必须做句柄保护：若 `obj == 0` 或 `obj.ui == 0`，立刻 `return`，禁止继续 `setTexture/onClick/show` 链式调用。
- 若报错栈含 `DzFrameShow -> s__uimage_show / s__uitext_show / s__uibtn_show`，优先按“simple 调用了 show”定位。

## 事件绑定选择

- 无数据绑定的事件用 `onClick/onEnter/onLeave`。
- 需要携带绑定数据（frame -> eventdata -> 业务参数）时用 `spClick/spEnter/spLeave`。
- 使用 `sp*` 时，先绑定 `uiHashTable(frame).eventdata`，再在回调中解包；禁止直接依赖外层局部变量闭包。

## 异步转同步（本地事件出网）

- 本地点击/交互不直接执行业务数据修改；先编码 payload 并发送（示例：`syncBus.DzSyncDataEx(channel, payload)`）。
- 在 `onDataSync(channel, ...)` 中解码并做权限校验（owner/player/对象存在性），通过后才触发 `trClick/trClose/trBtn1` 等同步逻辑。
- payload 至少包含三段信息：
1. 事件类型（如 `D/C/F/L/R`）
2. 对象标识（如 `sd`、英雄索引）
3. 位置信息（如 `pos`）

## 回调参数传递

- 为匿名回调准备静态参数槽（如 `currentSDAsync/currentPosAsync/argsHeroIndex`）。
- 触发器前写入参数，触发后按需清理或覆盖，避免跨回调污染。
- 提供统一读取函数（`Get*Async` / `Get*Pos`）给外部逻辑层。

## 生命周期与清理

- 销毁 UI 时，补发必要的离开事件（若存在“进入未离开”状态）。
- 销毁顺序保持“子组件 -> 主组件”，并把句柄置零。
- 本地 UI 关闭仅处理本地资源；同步状态变更交给同步事件处理器。

## 创建期 OOS 防线（外观/选择类）

- 在“单位/英雄创建”这类同步流程里，禁止根据 `BLoaded` / 本地缓存是否已读档来走不同同步分支。
- 创建期若需要应用外观、装饰、初始选择结果：
1. 先在全端应用同一份确定参数（通常是默认外观/默认选择）。
2. 再由本地玩家发送同步 payload。
3. 最终只在 `onDataSync` 中按 payload 统一应用真实状态。
- `onDataSync` 若依赖对象存在（如 `H[idx]` 或选择数据实例），必须容忍“消息先到、对象后到”的时序；必要时补一次下一拍重试或在创建后再次触发同步。
- 避免在创建单位的同一帧立即发同步；可延迟一拍（如 `0.03s`）降低竞态概率。
- `DzAPI_Map_GetStored*` / 本地读档只允许在本地分支执行；其结果必须先转成同步消息再驱动全端同步状态变更。

## Dz 同步与随机数

- `DzSyncData` / `DzSyncDataImmediately` 的接收回调里不要直接消耗 `GetRandom*`，也不要立刻串起会消耗随机数的业务链路；需要时先落同步状态，再用短计时器延后到稳定帧处理。
- 普通伤害事件、周期战斗事件等原生同步事件里的 `GetRandom*` 不属于 Dz 收包风险；不要为了 OOS 排查把这些热路径全局队列化。
- `SyncBus` 的 OOS 探针如果会定时调用 `GetRandom*`，必须有条件编译模式：关闭模式不注册探针且不消耗随机数，低频模式用于常规验证，高频模式只用于短时间定位。
- 排查 OOS 时优先比较双端 Trace / 日志样本；确认不是探针自身放大随机序列差异后，再扩大探测频率。

## 确定性伪随机

- 需要替代 `GetRandom*` 时，优先使用纯整数确定性种子 + 16807 LCG（Schrage 法）+ Fisher-Yates 洗牌；这样概率分布接近原洗牌，同时不消耗魔兽原生随机序列。
- 不要在热路径构造动态长字符串后 `StringHash("A|" + I2S(x) + "|" + name)`；War3 字符串拼接有额外开销，也更难审查输入稳定性。
- 可接受的输入方式：对已有稳定字符串单独 `StringHash`，例如 `GetVersion()`、`GetPlayerName(p)`；再把开局时间、玩家序号、刷新次数等整数通过整数混合函数并入种子。
- 种子混合要保留原本参与随机的稳定信息，例如开局时间、版本、玩家名 hash、玩家序号；只改变混合方式，不随意删掉影响分布/区分度的输入。
- 对候选池选择多个结果时，用确定性 Fisher-Yates 后取前 N 个，避免连续 `ModuloInteger(seed, count)` 造成明显线性相关。

## 硬性检查清单（CR Gate）

在提交 UI 代码前，逐条检查。任意 `FAIL` 均禁止合并。

1. `GetLocalPlayer()` 分支内不修改同步状态
PASS: 仅做 UI 显示、本地参数写入、发送同步消息。
FAIL: 创建/销毁单位、改全局业务数据、改计时器/组等对局同步状态。

2. 本地 UI 回调不直改业务数据
PASS: `onClick/spClick` 只编码 payload 或写 `current*Async/args*`。
FAIL: 在 UI 点击回调里直接执行奖励发放、状态切换、背包改动等。

3. 正确选择 `on*` vs `sp*`
PASS: 无绑定数据用 `onClick/onEnter/onLeave`；有 frame 数据解包需求用 `spClick/spEnter/spLeave`。
FAIL: 需要 `eventdata` 却使用 `on*`，或无数据需求滥用 `sp*`。

4. `sp*` 回调前完成 eventdata 绑定
PASS: 对应按钮存在 `uiHashTable(btn.ui).eventdata.bind*`。
FAIL: 回调中读取 `eventdata` 但未绑定或绑定不完整（缺少 bind2/bind3）。

5. 本地事件统一走“发送 -> 接收 -> 处理”链路
PASS: `DzSyncDataEx(channel, payload)` 发出后，在 `onDataSync(channel, ...)` 解码并处理。
FAIL: 本地事件绕过总线直接触发同步业务逻辑。

6. `onDataSync` 完成安全校验
PASS: 校验对象存在性、`owner/player` 一致性、索引范围合法性后再触发业务触发器。
FAIL: 未校验即执行 `trClick/trClose/...`。

7. payload 结构可逆且稳定
PASS: payload 至少含 `事件类型 + 对象标识 + 位置信息`，解码规则与编码规则一一对应。
FAIL: 拼接格式歧义、长度位错误、解码位置错位。

8. 异步参数槽完整可读
PASS: 提供 `Get*Async/Get*Pos` 读取接口，并在触发前写入对应参数。
FAIL: 回调依赖外层局部变量或隐式状态，导致异步读取不稳定。

9. UI 销毁流程完整
PASS: 销毁前补发必要 leave，按子到父销毁并置零，避免悬空句柄。
FAIL: 直接销毁主框导致子组件泄漏，或 leave 状态丢失。

10. 外部回调职责清晰
PASS: UI 层只发事件与展示；数据层在外部触发器/总线接收端处理。
FAIL: UI 文件内混入业务数据写入分支。

11. `createSimple` 控件显隐方式正确
PASS: `uiImage/uiText` 使用“改锚点/移出屏幕”的 simple-safe 显隐方案；`uiBtn.createSimple` 显示时固定尺寸定位，隐藏时缩到 `0.001` 后移出屏幕；都有 `ui!=0` 保护。
FAIL: 对 `createSimple` 组件直接 `.show()`；或 `uiBtn.createSimple` 只改锚点、依赖相对锚点撑点击区、无句柄保护就调用 UI 原生函数。

## 快速判定

- 全部 11 项 `PASS`：允许合并。
- 任意 1 项 `FAIL`：先修复再提审。
- 若无法判定：默认按 `FAIL` 处理并补充注释说明边界。

## 参考实现（按需阅读）

- `references/war3lib-ui-examples.md`
