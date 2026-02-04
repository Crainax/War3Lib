# HeroSelector UI 复刻/新建 Prompt

你是 War3Lib 的 Zinc UI 工程师。请基于 `Jass/ui/composite/hero/HeroSelector.j` 的成熟设计，实现一个“英雄选择类 UI”。

## 目标

- 做一个单例 UI（可 show/hide，支持重复打开关闭）。
- 左侧是分页/滚动的英雄网格。
- 右侧是当前选中英雄的详情区（多区块 icon + 进度条）。
- 底部有主操作按钮、次操作按钮、说明文本、可选流光特效。

## 必须遵守的架构规则

- 严格分离 UI 与数据：UI 本地异步行为不直接修改同步游戏数据。
- 无绑定数据的交互使用 `onClick/onEnter/onLeave`。
- 需要 frame-eventdata 绑定参数的交互使用 `spClick/spEnter/spLeave`。
- 本地事件转同步事件时，先打包 payload 并发送（如 `syncBus.DzSyncDataEx`），再在同步接收端解包处理。
- 异步回调参数通过静态槽传递（如 `currentPosAsync/args*`），并提供 `Get*Async/Get*Pos` 读取接口。

## 拆解实现要求

1. 数据层（仅定义，不写业务）
- 定义 `heroData[]`：基础信息（name/icon/text）、右侧区块图标数据、进度数据。
- 定义回调触发器句柄：条件判断、右侧 enter/leave、底部文案控制、按钮文本映射等。

2. UI层（本地单例）
- 定义 `heroSelectorUI` 静态组件：主面板、背景拼图、左网格、右区块、底部按钮、滑块/滚轮。
- `show(player)`：仅本地创建并展示 UI。
- `hide(player)`：仅本地销毁 UI，释放句柄并置零。

3. 事件层（桥接）
- 左侧格子点击：更新本地选中态 + 刷新右侧显示。
- 底部关键操作点击：只发同步消息，不直接改业务数据。
- 右侧 icon 悬停事件：通过 `eventdata` 解码事件类型与索引，写入 `args*` 后触发外部回调。

4. 生命周期
- 支持重复 show/hide，不残留旧组件。
- 若存在“进入未离开”状态，销毁前补发 leave。

## 输出要求

- 输出 Zinc 代码骨架（library + struct + show/hide + refresh + 事件绑定）。
- 先给“结构体字段清单”，再给核心方法实现。
- 每个事件标注“本地异步”或“同步处理端”。
- 代码风格遵循 War3Lib 约定（`.j` 文件中的 `//! zinc` 语法）。

