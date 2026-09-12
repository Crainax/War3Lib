---
name: war3lib-tooltip
description: War3Lib `tooltip.create()` / `Tooltip` 库的用法与约定（JASS/Zinc UI Tooltip）。用于新增或改造 UI 提示：`layoutTitleDesc`、`layoutFlexible`、`addText`、`addIconLeft`、固定位置 `setAbsPoint`、显示/隐藏配套 `tooltipStack.pushOrigin()` / `tooltipStack.clear()`，以及多 tooltip 从右向左链式排列。
---

# War3Lib Tooltip.create 约定

## 默认行为

- 优先用 `tooltip.create()`（`Jass/ui/tooltip/Tooltip.j`）。
- 单个 tooltip 默认固定在右下角：`.setAbsPoint(ANCHOR_BOTTOMRIGHT, 0.786, 0.1675)`；若是单测或独立用例，可按场景改为中心点。
- 多个 tooltip 从右到左创建并排列：第 2 个锚到第 1 个左边，第 3 个锚到第 2 个左边，常用偏移 `(-0.02, 0)`。
- 显示时先销毁旧 tooltip；创建完成后每个 tooltip 调一次 `tooltipStack.pushOrigin()`。
- 隐藏时 destroy 全部 tooltip，并调用一次 `tooltipStack.clear()`。

需要更多 API 或用例时，按需读取：
- `references/tooltip-api.md`
- `references/tooltip-patterns.md`

## 编写步骤

1. 在 hover/onEnter 逻辑里：如果旧 tooltip 存在则 `destroy()` 并置 `0`。
2. 选择布局：
   - 标题+正文：用 `layoutTitleDesc(title, desc)`。
   - 多行/混合图标：用 `layoutFlexible(bottomLine)`，再用 `addText` / `addIconLeft` 逐行往上堆叠。
3. 放置位置：
   - 默认：`.setAbsPoint(ANCHOR_BOTTOMRIGHT, 0.786, 0.1675)`。
   - 多 tooltip：用 `setPoint` 把新 tooltip 锚到上一个 tooltip 的底部锚点左侧。
4. 所有 tooltip 创建并定位后，对每个 tooltip 调一次 `tooltipStack.pushOrigin()`。
5. 在 onLeave / hide 逻辑里 destroy tooltip，并 `tooltipStack.clear()`。

## 悬停刷新约定

- 当鼠标仍停留在同一个可交互控件上时，如果点击导致 UI 状态变化，必须立即重绘 tooltip，不要只销毁不重建。
- 推荐做法：
  - 记录当前 hovered 目标 id。
  - 执行 UI 刷新。
  - 若 hovered 目标仍有效，则按新状态 `showTooltip(hoveredId)`。
  - 仅当 hovered 目标失效时才清空 tooltip。

## 底部锚点选择规则

`tooltip.setPoint(...)` 实际移动 tooltip 的 `relative`（底部锚点）。

- `layoutTitleDesc`：底部行是 `tip.text[2].ui`（desc）。
- `layoutFlexible` / `layoutTitle`：底部行是 `tip.getFirstText().ui`（text[1]）。

## 代码模板

### 单个固定右下角

```jass
if (tip != 0 && tip.isExist()) { tip.destroy(); tip = 0; }
tip = tooltip.create()
  .layoutTitleDesc(title, desc)
  .setAbsPoint(ANCHOR_BOTTOMRIGHT, 0.786, 0.1675);
tooltipStack.pushOrigin();

// leave:
if (tip != 0 && tip.isExist()) { tip.destroy(); tip = 0; }
tooltipStack.clear();
```

### 两个向左链式展开

```jass
if (tipA != 0 && tipA.isExist()) { tipA.destroy(); tipA = 0; }
if (tipB != 0 && tipB.isExist()) { tipB.destroy(); tipB = 0; }

tipA = tooltip.create()
  .layoutTitleDesc(titleA, descA)
  .setAbsPoint(ANCHOR_BOTTOMRIGHT, 0.786, 0.1675);
tooltipStack.pushOrigin();

tipB = tooltip.create()
  .layoutTitleDesc(titleB, descB)
  .setPoint(ANCHOR_BOTTOMRIGHT, tipA.text[2].ui, ANCHOR_BOTTOMLEFT, -0.02, 0.0);
tooltipStack.pushOrigin();
```

## 兼容原生 Tooltip

当需要依附系统 tooltip（比如按钮自带提示）时：

```jass
tip.setPoint(ANCHOR_BOTTOMRIGHT, DzFrameGetTooltip(), ANCHOR_BOTTOMLEFT, -0.012, 0.008);
```
