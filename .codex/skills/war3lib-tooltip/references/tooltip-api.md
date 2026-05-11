# Tooltip 库速查（War3Lib）

来源：`Jass/ui/tooltip/Tooltip.j`。

## 结构与核心行为

- `tooltip.create()`：创建 tooltip（内部创建 `uiBorder`），默认 `fontSize = 4`。
- `layoutTitle(title)`：仅 1 行文本；`relative = text[1].ui`。
- `layoutTitleDesc(title, desc)`：2 行文本（title 在上，desc 在下）；`relative = text[2].ui`；默认 `setWidth(0.2)`。
- `layoutFlexible(initialText)`：以 1 行文本初始化（作为底部行）；后续用 `addText` / `addIconLeft` 往上堆叠；`relative = text[1].ui`。
- `addText(content)`：新增一行文本并放在上一行上方；返回创建出的 `uiText`。
- `addIconLeft(content, iconPath, sizeX, sizeY)`：新增一行文本并在其左侧附加图标；返回 `uiText`。
- `setFontSize(size)`：只影响后续创建的新文本，以及 `layout*` 时创建的文本。
- `setWidth(width)` / `exWidth(width)`：对齐宽度的行会统一设置宽度。
- `setAbsPoint(anchor, x, y)`：对 `relative` 执行 `DzFrameSetAbsolutePoint`。
- `setPoint(anchor, targetUI, targetAnchor, offsetX, offsetY)`：对 `relative` 执行 `DzFrameSetPoint`。
- `getFirstText()`：返回 `text[1]`。

## 常见坑

- `layoutFlexible` 的堆叠方向是从下往上：如果需要顶部标题，把标题最后 `addText`。
- 多 tooltip 对齐时，要锚到“底部锚点”对应的 `.ui`：`layoutTitleDesc` 用 `text[2].ui`，`layoutFlexible` 用 `getFirstText().ui`。
