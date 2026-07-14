# Tooltip 库速查（Xlimon）

来源：`dependency/Jass/ui/tooltip/Tooltip.j`（与 `D:/War3/Library/War3Lib/Jass/ui/tooltip/Tooltip.j` 同步/相似）。

## 结构与核心行为

- `tooltip.create()`：创建 tooltip（内部创建 `uiBorder`），默认 `fontSize = 4`。
- `layoutTitle(title)`：仅 1 行文本；`relative = text[1].ui`。
- `layoutTitleDesc(title, desc)`：2 行文本（title 在上，desc 在下）；`relative = text[2].ui`；默认 `setWidth(0.2)`。
- `layoutFlexible(initialText)`：以 1 行文本初始化（作为底部行）；后续用 `addText`/`addIconLeft` 往“上方”堆叠；`relative = text[1].ui`。
- `addText(content)`：新增一行文本并放在上一行上方（堆叠向上）；返回创建出的 `uiText`，可继续 `.setAlign(...)` 等。
- `addIconLeft(content, iconPath, sizeX, sizeY)`：新增一行文本并在其左侧附加图标；同样堆叠向上；返回 `uiText`。
- `setFontSize(size)`：只会影响后续创建的新文本（以及 `layout*` 时创建的文本）。
- `setWidth(width)` / `exWidth(width)`：对齐宽度的行会统一设置宽度；常用于把 `layoutFlexible` 做成“固定宽度”的面板。
- `setAbsPoint(anchor, x, y)`：对 `relative` 执行 `DzFrameSetAbsolutePoint`。
- `setPoint(anchor, targetUI, targetAnchor, offsetX, offsetY)`：对 `relative` 执行 `DzFrameSetPoint`。
- `getFirstText()`：返回 `text[1]`（`layoutTitleDesc` 时这是 title；`layoutFlexible` 时这是底部行）。

## 常见坑（按工程习惯避免）

- `layoutFlexible` 的堆叠方向是“从下往上”：如果需要顶部标题，把标题最后 `addText`（并先 `setFontSize(7)`）。
- 多 tooltip 对齐时，要锚到“底部锚点”对应的 `.ui`：`layoutTitleDesc` 用 `text[2].ui`，`layoutFlexible` 用 `getFirstText().ui`。
