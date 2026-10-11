# UITextArea

透明背景、左上排版、鼠标滚轮阅读。只有一个 `War3LibTextArea` FDF 模板，固定使用与 uiText 3号字一致的 `Fonts\dfst-m3u.ttf / 0.009`。只提供 `uiTextArea.create(parent)`；多实例使用独立创建 context。

## 正文写入

```cpp
area = uiTextArea.create(DzGetGameUI());
area.exReSize(0.24, 0.20)
    .exRePoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0, 0.05);
area.setText("第一段");
area.appendText("第二段，每段独立生成");
area.appendText("|cffffd84a最后一段|r");
```

- **不要先拼接完整长正文再调用组件**：当前客户端实测6000字符在测试字符串生成阶段就闪退，尚未调用原生写入；精确引擎上限未确定。
- `UI_TEXTAREA_TEXT_LIMIT = 2048` 为单段保守字节上限；setText/appendText 超限拒绝写入并打印提示。每段应保留完整中文字符与颜色标记；组件不截断字符串。
- 长正文通过多次 `appendText` 写入；组件按段保存，不无限拼接全文缓存。段落间按原生追加行为换行。
- `getText()`：总缓存长度不超过2048时返回全文；超过时返回null，避免读取操作再次构造大字符串。使用 `getPartCount()`、`getTextPart(index)`（从1开始）读取长正文，越界返回null。不要把返回的各段重新拼成大字符串。
- `getTextLength()`：源正文按段间 `|n` 计算的长度，不是屏幕可见字符数。
- `setText` 替换正文；初始滚动位置由原生控件决定，相同全文跳过刷新。`clear` 清空正文和段落缓存，销毁时回收所有段落。
- 仅保留原生鼠标滚轮。移除不兼容的scrollLines/scrollToTop/scrollToBottom及reflow接口：当前KK客户端拒绝对SCROLLBAR调用DzFrameSetValue，模拟箭头点击也会产生持续滚动。写入/追加可能由原生控件定位到末尾；不承诺初始顶部。卡牌悬停缩放不清空重写正文。
- `setEnabled` 控制正文及子控件；`containsFrame` 供卡牌悬停检测。

## 模板与布局

滚动条保留原生结构、箭头和滑块，但没有任何贴图，完全透明；不隐藏或禁用滚动机制。右侧仅保留0.0001的极小正宽度，接近用满正文区域；滚轮与换行效果需实机验证。移除了轨道、箭头和滑块的全部BACKDROP及资源依赖。

FDF默认尺寸0.16×0.16。使用时建议宽高不小于0.04。支持exReSize/exRePoint。字体大小固定，不再提供createSized。

源模板位于同目录 `UITextArea.fdf`；实际测试包使用 `UnitTestMap/map/ui/BaseUI.fdf` 中 `BEGIN/END War3Lib UITextArea` 区块，经 `ui/Crainax.toc` 加载。修改FDF必须重新打包并重新进图。Import目录中的独立FDF仅同步作参考，不单独加载。

原生最多保留1024个显示行，超出可能丢弃最早显示行；源段落缓存不代表所有行仍可见。

## 测试

- `f1`：直接创建两个3号字体实例，左侧30段长文、右侧短文；检查滚轮和透明滚动条。
- `t6`：替换为120段长文，验证逐段缓存与末段完整性。
- `t2/t3`：手动滚轮检查；`t4`：追加；`t5`：短文替换；`t7`：销毁并检查UI ID和适配器回收；`t8`：缩小。
- `s0`：查看原生分步诊断说明。`s1~s11`按顺序执行；s6已改为逐段追加。`s12`执行完整组件测试。
- 完成`s1~s5`后，`d1`写40行短ASCII，`d2`写单段彩色中文，`d3`分60次追加共6000个ASCII字符，`d4`重置短文，`d5`单行追加。

编译通过不代表客户端运行通过；重进图后检查【开头】和【正文结束】、中文、颜色和滚轮。
