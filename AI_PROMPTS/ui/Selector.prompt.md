# Selector UI 复刻/新建 Prompt

你是 War3Lib 的 Zinc UI 工程师。请基于 `Jass/ui/composite/select/Selector.j` 的成熟实现，构建一个“通用选择器 UI（分页+图标网格）”。

## 目标

- UI 绑定一个 `selectData` 数据对象。
- 支持最多 12 个图标/页，自动分页。
- 支持图标悬停、点击、关闭、功能按钮、翻页。
- 点击类行为通过总线发送到同步层处理。

## 必须遵守的架构规则

- UI 层不直接修改同步业务数据。
- `sp*` 仅用于需要读取绑定数据的事件（如 `sd`、`pos`）。
- `on*` 用于无参数绑定的简单本地事件。
- 所有点击类业务入口统一走 `syncBus.DzSyncDataEx("Select", payload)`。
- 在 `syncBus.onDataSync("Select", ...)` 中解码 payload，并校验：
- 对象存在性（`sd.isExist()`）
- 所属玩家一致性（`sd.owner == p`）
- 事件参数合法性（位置范围等）

## 拆解实现要求

1. 数据结构
- `selectData`：count/title/btn1Text/映射触发器/事件触发器/owner/uiSelector。
- `selector`：UI 句柄集合、分页状态、悬停状态（enteredFlag/enteredPos）。

2. 映射机制
- icon、name、shadow、grow 映射通过触发器回调获取。
- 通过 `currentSDAsync/currentPosAsync` 传参给映射触发器。

3. 事件机制
- 图标 `spEnter/spLeave/spClick`：读取 bind 的 `this + pos`。
- 关闭按钮、功能按钮、翻页按钮按需绑定事件与提示。
- 销毁时如果“进入未离开”，补发 leave。

4. 总线接收端
- 解析 payload 事件前缀（如 `C/F/D/Z`）。
- 分发到 `trClose/trBtn1/trClick/trFail`。
- 明确区分“本地发消息”与“同步处理”。

## 输出要求

- 输出可直接落地的 Zinc 代码骨架。
- 附带 payload 编码/解码约定说明。
- 附带 CR 自检清单（至少 8 条），确保不破坏 UI/数据分层。

