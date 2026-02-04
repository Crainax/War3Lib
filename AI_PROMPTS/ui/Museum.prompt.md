# Museum UI 复刻/新建 Prompt

你是 War3Lib 的 Zinc UI 工程师。请基于 `Jass/ui/composite/museum/Museum.j` 的成熟设计，创建一个“图鉴/目录类 UI（左侧分类 + 右侧内容区）”。

## 目标

- 单例 UI：一个主框体，左侧分类 Tab，右侧内容容器。
- Tab 数据由 `museumData` 注册，右侧内容由外部回调绘制。
- 支持标题、关闭、Esc 关闭、选中态指示器。

## 必须遵守的架构规则

- UI 结构层只负责本地展示与切页，不处理业务数据写入。
- `tab` 点击如果需要 frame 绑定数据，使用 `spClick`。
- 简单提示音/tooltip 用 `onEnter/onLeave` 即可。
- “切换 Tab”必须先执行旧 Tab 的 close，再执行新 Tab 的 click。
- 回调参数通过 `museumData.setCallbackData/getCallbackData` 传递，避免闭包依赖。

## 拆解实现要求

1. 数据注册层
- `museumData.registerAlbum(name)` 注册分类，维护 `list[] + size + index`。
- `registerClick/registerClose` 支持外部注入逻辑。

2. UI 控制层
- `museumUI.show(player)`：本地创建主框、背景、左栏、右内容区、分隔线。
- `museumUI.selectTab(target, idx, triggerClick)`：
- 防重复点击。
- 先关旧分类，再开新分类。
- 更新选中指示器和标题。
- `museumUI.hide(player)`：本地销毁，清理 tooltip、esc 栈、当前状态。

3. 交互层
- 关闭按钮本地点击触发 hide。
- Tab 点击事件通过 `eventdata` 取 `museumData + index`。
- 右侧内容仅暴露容器接口给外部渲染模块。

## 输出要求

- 输出 Zinc 结构化代码骨架。
- 明确列出“UI职责”和“外部业务职责”的边界。
- 给出一个“新增第 N 个图鉴分类”的调用示例（注册 + click/close 回调）。

