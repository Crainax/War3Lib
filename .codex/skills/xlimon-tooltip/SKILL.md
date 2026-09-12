---
name: xlimon-tooltip
description: Xlimon 工程内 `tooltip.create()` / `Tooltip` 库的用法与约定（JASS/Zinc UI Tooltip）。用于新增/改造 UI 提示：`layoutTitleDesc`/`layoutFlexible`/`addText`/`addIconLeft`，默认固定位置 `setAbsPoint(ANCHOR_BOTTOMRIGHT, 0.786, 0.1675)`，显示/隐藏配套 `tooltipStack.pushOrigin()` / `tooltipStack.clear()`，以及多 tooltip 场景下“第 2 个锚在第 1 个左边（后续继续向左链）”的布局规则。
---

# Xlimon Tooltip.create 约定

## 结论优先（默认行为）

- 优先用 `tooltip.create()`（来自 `dependency/Jass/ui/tooltip/Tooltip.j`）。
- **单个 tooltip**：默认固定在右下角：`.setAbsPoint(ANCHOR_BOTTOMRIGHT, 0.786, 0.1675)`。
- **多个 tooltip**：从右到左创建并排列：第 2 个锚到第 1 个左边；第 3 个锚到第 2 个左边……偏移常用 `(-0.02, 0)`。
- **副标题**：等级、价格、数量、解锁条件等短行补充信息属于副标题，默认放在标题和正文之间并居中。
- **显示时**：先销毁旧 tooltip；创建完成后调用 `tooltipStack.pushOrigin()`（每个 tooltip 一次）。
- **隐藏时**：destroy 全部 tooltip，并调用 `tooltipStack.clear()`（一次即可）。

需要更多例子或想确认风格时，按需读取：
- `references/tooltip-api.md`
- `references/tooltip-patterns.md`

## 编写步骤（让实现与现有一致）

1. 在 hover/onEnter 逻辑里：如果旧 tooltip 存在则 `destroy()` 并置 `0`。
2. 选择布局：
   - 标题+正文：用 `layoutTitleDesc(title, desc)`（标题字号默认 7，正文用当前 `fontSize`）。
   - 多行/混合图标：用 `layoutFlexible(bottomLine)`，再用 `addText`/`addIconLeft` 逐行往“上方”堆叠。
   - 带副标题：用 `layoutFlexible(desc)` 先放正文，再 `addText(subtitle)`，最后 `setFontSize(7).addText(title)`；副标题和标题一般都 `setAlign(4)` 居中。
3. 放置位置：
   - 默认：`.setAbsPoint(ANCHOR_BOTTOMRIGHT, 0.786, 0.1675)`。
   - 多 tooltip：用 `setPoint` 把新 tooltip 锚到上一个 tooltip 的“底部锚点”左侧。
4. 所有 tooltip 创建并定位后：对每个 tooltip 调一次 `tooltipStack.pushOrigin()`。
5. 在 onLeave / hide 逻辑里：destroy tooltip 并 `tooltipStack.clear()`。

## 副标题约定（等级/价格/数量等短行）

- 副标题指标题下方、正文上方的一行短补充信息；常见例子：
  - 天赋等级或满级说明，如 `edit/ability/intelligent/TalentTab.j` 里的 `该天赋满级X级`。
  - 商品价格或数量说明，如 `edit/AdvancedShop.j` 里的 `价格: X 木材`。
  - 解锁条件、激活状态、限购/库存等不适合塞进正文段落的短句。
- 默认布局顺序：**标题（居中） -> 副标题（居中） -> 正文**。
- 实现时通常用 `layoutFlexible(desc)`，因为 `layoutTitleDesc(title, desc)` 没有中间行：
  - 先 `.setFontSize(4).layoutFlexible(desc)` 创建正文；
  - `tip.getFirstText().setAlign(3)` 让正文按普通段落左对齐；
  - `line = tip.addText(subtitle); line.setAlign(4);` 添加居中的副标题；
  - `line = tip.setFontSize(7).addText(title); line.setAlign(4);` 添加居中的标题；
  - 根据内容宽度补 `tip.setWidth(0.2)` / `tip.setWidth(0.22)`。
- 不要把价格、等级这类短信息混进正文段落里；它们应该作为独立副标题行，方便玩家扫一眼看到关键限制。

## 悬停刷新约定（避免点击后 tooltip 闪没）

- 当鼠标仍停留在同一个可交互控件上时，如果点击导致了 UI 状态变化（如“使用中/未装备/未解锁”文案切换），**必须立即重绘 tooltip**，不要只销毁不重建。
- 推荐做法：
  - 先记录当前 hovered 目标 id；
  - 执行 UI 刷新（图标状态/文本/阴影等）；
  - 若 hovered 目标仍然有效，则按新状态 `showTooltip(hoveredId)`；
  - 仅当 hovered 目标失效（被翻页隐藏、被销毁）时才清空 tooltip。
- 目标体验：点击后 tooltip 内容无缝更新，避免“鼠标还在图标上但提示突然消失”。

## “底部锚点”选择规则（多 tooltip 关键）

`tooltip.setPoint(...)` 实际会移动 tooltip 的 **relative（底部锚点）**。但工程里通常直接取某一行的 `.ui` 来当 target：

- 若上一个 tooltip 用的是 `layoutTitleDesc`：底部行是 `tip.text[2].ui`（desc）。
- 若上一个 tooltip 用的是 `layoutFlexible` 或 `layoutTitle`：底部行是 `tip.getFirstText().ui`（text[1]）。

## 代码模板（拷贝即用）

### 单个（固定右下角）

```jass
// enter:
if (tip != 0 && tip.isExist()) { tip.destroy(); tip = 0; }
tip = tooltip.create()
  .layoutTitleDesc(title, desc)
  .setAbsPoint(ANCHOR_BOTTOMRIGHT, 0.786, 0.1675);
tooltipStack.pushOrigin();

// leave:
if (tip != 0 && tip.isExist()) { tip.destroy(); tip = 0; }
tooltipStack.clear();
```

### 带副标题（标题/副标题居中，正文在底部）

```jass
if (tip != 0 && tip.isExist()) { tip.destroy(); tip = 0; }

tip = tooltip.create()
  .setFontSize(4)
  .layoutFlexible(desc)
  .setAbsPoint(ANCHOR_BOTTOMRIGHT, 0.786, 0.1675);

tip.getFirstText().setAlign(3);
line = tip.addText(subtitle);
line.setAlign(4);
line = tip.setFontSize(7).addText(title);
line.setAlign(4);
tip.setWidth(0.22);
tooltipStack.pushOrigin();
```

### 两个（第二个在第一个左边）

```jass
if (tipA != 0 && tipA.isExist()) { tipA.destroy(); tipA = 0; }
if (tipB != 0 && tipB.isExist()) { tipB.destroy(); tipB = 0; }

tipA = tooltip.create()
  .layoutTitleDesc(titleA, descA)
  .setAbsPoint(ANCHOR_BOTTOMRIGHT, 0.786, 0.1675);
tooltipStack.pushOrigin();

// tipA 是 layoutTitleDesc：用 tipA.text[2].ui 作为“底部锚点”
tipB = tooltip.create()
  .layoutTitleDesc(titleB, descB)
  .setPoint(ANCHOR_BOTTOMRIGHT, tipA.text[2].ui, ANCHOR_BOTTOMLEFT, -0.02, 0.0);
tooltipStack.pushOrigin();
```

### 链式更多（继续向左）

```jass
tip3 = tooltip.create()
  .layoutTitleDesc(title3, desc3)
  .setPoint(ANCHOR_BOTTOMRIGHT, tipB.text[2].ui, ANCHOR_BOTTOMLEFT, -0.02, 0.0);
tooltipStack.pushOrigin();
```

## 兼容：依附原生 Tooltip（不是固定右下角时）

当需要依附系统 tooltip（比如按钮自带提示）时，按工程常用写法：

```jass
tip.setPoint(ANCHOR_BOTTOMRIGHT, DzFrameGetTooltip(), ANCHOR_BOTTOMLEFT, -0.012, 0.008);
```
