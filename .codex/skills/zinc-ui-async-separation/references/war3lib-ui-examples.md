# War3Lib UI 分层示例

## HeroSelector.j

- 本地 UI 操作与同步事件分离。
- 底部按钮 `onClick` 只负责发送 `syncBus.DzSyncDataEx("HSelect", ...)`。
- 图标区 `spEnter/spLeave/spClick` 通过 `eventdata` 解码 `eventType/eventIndex`，再写入 `heroData.args*` 给外部触发器读取。
- 通过 `currentPosAsync` 传递异步回调参数，避免闭包依赖。

## Selector.j

- `spClick` 用于携带 `sd + pos`，本地只发总线：`syncBus.DzSyncDataEx("Select", "...")`。
- 同步处理集中在 `syncBus.onDataSync("Select", ...)`，按顺序执行：
1. 解码事件类型与参数。
2. 校验 `sd.isExist()`、`sd.owner == p`。
3. 再触发 `trClick/trClose/trBtn1/trFail`。
- `spEnter/spLeave` 只用于 UI 悬停与提示，不修改同步数据。

## Museum.j

- 纯本地 UI 管理：`onEnter/onLeave/onClick`（无 eventdata 绑定需求）。
- tab 点击使用 `spClick`，原因是需要从 frame 解包 `museumData + tabIndex`。
- `selectTab` 中先触发旧 tab 的 close，再切换新 tab；右侧具体数据渲染由外部回调负责。

## 可复用检查清单

- 是否在 `GetLocalPlayer()` 分支里修改了同步状态？
- 是否误把需要绑定数据的回调写成 `onClick/onEnter`？
- 是否在本地事件里直接修改业务数据而非发同步消息？
- 是否在 `onDataSync` 中做了存在性与 owner 校验？
- 是否提供了统一的 `Get*Async/Get*Pos` 读取接口给外部？
