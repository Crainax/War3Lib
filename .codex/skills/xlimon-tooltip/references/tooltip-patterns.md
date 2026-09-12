# Tooltip 使用模式（从工程归纳）

## 1) 固定右下角（最常见）

特点：
- 绝大多数 UI tooltip 都固定在：`(ANCHOR_BOTTOMRIGHT, 0.786, 0.1675)`。
- onEnter/show 先销毁旧 tooltip；onLeave/hide destroy + `tooltipStack.clear()`。

可参考的调用点（按需打开文件看实现细节）：
- `edit/ability/ui/AbilityMuseum.j`（单 tooltip，反复刷新内容）
- `edit/item/ui/ItemMuseum.j`（单 tooltip）
- `edit/ItemShop.j`（单 tooltip）
- `edit/unit/Attr.j`（用 `layoutFlexible` 堆叠多行）

## 2) 多 tooltip：向左链式展开（你最常用的场景）

约定：
- 第 1 个 tooltip 固定右下角。
- 第 2 个 tooltip 锚在第 1 个左边（`ANCHOR_BOTTOMRIGHT -> ANCHOR_BOTTOMLEFT`，偏移 `-0.02, 0`）。
- 第 3 个 tooltip 锚在第 2 个左边……依次类推。

典型实现：
- `edit/item/ui/MythChances.j`：`mythTipDetail`（右下角） + `mythTipMain`（左侧依附）。
- `edit/item/Equitment.j`：`currentTip`（右下角） + `upTip`（左侧依附） + `nextTip`（继续向左）。

底部锚点选择：
- `layoutTitleDesc`：用 `.text[2].ui`（desc 行）。
- `layoutFlexible`：用 `.getFirstText().ui`（底部行）。

## 3) 依附系统 Tooltip（跟随鼠标/按钮）

当需要依附原生 tooltip（例如 `DzFrameGetTooltip()`）时常见偏移：
- `(-0.012, 0.008)` 或 `(-0.01, 0.008)`

可参考：
- `edit/item/Equitment.j`（无 upTip 时 nextTip 退化为依附系统 tooltip）
- `edit/PortalShop.j`
- `edit/ability/intelligent/Intelligent.j`
