# Tooltip 使用模式

## 1) 固定右下角

特点：
- 大多数 UI tooltip 固定在 `(ANCHOR_BOTTOMRIGHT, 0.786, 0.1675)`。
- onEnter/show 先销毁旧 tooltip；onLeave/hide destroy + `tooltipStack.clear()`。

可参考的 War3Lib 调用点：
- `Jass/units/UnitAttrUpdate.j`：单位面板属性提示，使用 `layoutFlexible`。
- `Jass/ui/composite/checkin/SevenDaySign.j`：签到界面提示，使用 `layoutFlexible` / `layoutTitleDesc`。
- `Jass/ui/tooltip/Tooltip_Test.j`：独立单测用例，覆盖标题、描述、多行和图标行。

## 2) 多 tooltip 向左链式展开

约定：
- 第 1 个 tooltip 固定右下角。
- 第 2 个 tooltip 锚在第 1 个左边：`ANCHOR_BOTTOMRIGHT -> ANCHOR_BOTTOMLEFT`，偏移 `-0.02, 0`。
- 第 3 个 tooltip 锚在第 2 个左边，依次类推。

底部锚点选择：
- `layoutTitleDesc`：用 `.text[2].ui`。
- `layoutFlexible`：用 `.getFirstText().ui`。

## 3) 独立单测用例

用 `Jass/ui/tooltip/Tooltip_Test.j` 扩展场景：
- `s1/s2`：创建标题或标题+描述。
- `s3/s4`：创建 `layoutFlexible` 并追加文本。
- `s5/s6`：创建/销毁带图标的资源提示。
- `-width number`：调整当前 tooltip 宽度。
