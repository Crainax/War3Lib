# 卡牌选择器

## 五色卡牌（2026-11-17）

- 品质：1绿、2淡蓝、3紫、4橙、5红。`sd.reflectCardQuality(code)` 用 `CallbackSelectContent(I2S(品质))` 返回品质；缺省和非法值回退绿色。
- 顶部装配栏：`sd.reflectCardTitle(code)` 返回任意标题文字；不注册时留空。与其他 reflect 一样在全端同步注册，回调只读取展示数据；上下文仍是 `GetSelectDataAsync/GetSelectPosAsync`。
- 动态修改展示数据后调用 `sd.refreshCards()`。新映射 trigger 在 selectData 销毁时释放；换色不重建卡牌、不重置动画。
- 卡面宽0.14、高按1619/971计算；五张边缘间距0.018。保留 exReSize/exRePoint 的窗口自适应机制。独立栏宽为卡面72%、高15%、中心位于卡面中心上方47.5%高度。
- 外光是包含标题栏轮廓的透明图，画布1171×1899，卡面原坐标(100,180)，中心相对卡面向上40像素。仅悬停权重驱动透明度，保留原 tick、1.06缩放、0.35缓动、0.10秒入场和0.10秒离场；不采用HTML的300ms动画替换游戏动画。
- 15张 BLP 在 `D:/War3Asset/Import/resource/ui/cardselector_colors/{green,blue,purple,orange,red}/`，每色 `body.blp`、`title.blp`、`glow.blp`。body/glow为512×1024，title为512×128，强制Alpha、JPEG质量100、1级mipmap。均已解码检查尺寸及外光中心透明。通过CardSelector.j的dependency导入；不再依赖旧tall_v2卡面。底部按钮继续使用原有素材。
- 无字PNG、转换中间图及浏览器预览位于 `C:/Users/41399/.codex/visualizations/2026/11/16/01a1e633-11ad-7c20-ac85-a8f889412e23/`；红色边框外杂点已重新清理，角落规则网点保留。

新增演示命令：

- `-mixed`：五色同屏。
- `-quality 1`～`-quality 5`：五张同品质；`-quality 6`：非法品质回退绿色并断言。
- `-cycle`：当前组原位轮换品质，检查贴图、标题和外光共同更新。
- `-blank`：切换基础演示的空白卡面/图标文字，检查边框与外光。
- 原有 `-card 1`～`-card 5`、`s1`～`s6`、`-buttons 0`～`-buttons 4` 保留，可结合品质命令验证数量、重选、离场和按钮。

仅通过 UNITTEST/vjassc 编译；未启动游戏，实机纹理、缩放与多人表现待验收。

## 创建与回调

在全端同步事件中创建 `selectData.create(p, count)`，注册映射和回调后调用 `sd.showCards()`。支持 1～5 项，牌位仍为 1-based。`showCards` 仅在 owner 本地创建 UI，其 boolean 返回值不得用于同步业务分支。

- `reflectIcon`：图标，沿用 `CallbackSelectContent`。
- `reflectName`：标题。
- `reflectDescription`：新增正文映射。
- 正文由 `uiText` 显示，固定2号字、左上排版，自动换行。每张卡只创建一个正文 TEXT，放在启用裁剪的视口内。按完整正文宽度排版后延迟读取实际高度，溢出才显示共用的灰轨白块，收窄正文并重新测量。滚轮移动本地正文；滑条仅显示阅读位置，点击该处照常选卡。图标原有上移0.01，图标、标题和正文再整体上移0.015，正文框尺寸保持不变；标题与图标、正文与标题的间距均为0.005。卡名与顶部铭牌均使用原生7号字和品质色。标题框使用单行高度0.020，正文锚在其底部下方0.005；标题高度、左右与底部内边距在 CardSelector.j 宏中调整。
- 正文不拦截鼠标输入，点击正文、图标、标题或卡牌边缘均通过整张卡按钮发送标准Select包；鼠标在正文上仍保持卡牌悬停高亮。
- `reflectShadow/reflectGrow`：沿用图标阴影与 growdata。
- 映射通过 `GetSelectDataAsync()/GetSelectPosAsync()` 读取上下文。卡牌仅保留本地悬停高亮和音效，不调用 `registerEnter/registerLeave`；底部按钮不注册悬停tooltip。
- `registerClick` 在 `Select` 通道延迟收包并通过 owner/token/位置校验后执行，使用 `GetSelectData()/GetSelectPos()` 读取上下文。
- 点击回调执行 `sd.destroy()` 表示完成选择；本地 UI 解绑数据后继续离场，动画结束不再执行任何业务回调。
- 回调保留本轮数据表示拒绝或需要继续选择，刷新展示并解锁。不要在本地动画回调中发放奖励。
- 标题数据仍保留，但卡牌选择器的标题控件始终隐藏。
- 底部按注册情况显示 `btn1Text/btn2Text/btn3Text` 与“取消选择”，从左到右顺序为btn1、btn2、btn3、取消；缺失项不占位置。`registerClose`决定取消按钮，`registerBtn1/2/3`决定相应功能按钮。文字绘制在共用的无字按钮贴图内。
- `registerClose/registerBtn1/registerFail` 保持原有 `C/F/Z` 收包协议；新增btn2/btn3分别使用 `G/H,id,token`，沿用Select延迟派发、owner、生命周期token和规范编码校验，并要求对应回调已注册。回调内用 `GetSelectData()` 读取数据；保留数据则刷新并解锁，销毁数据则结束会话。
- 所有注册及 `destroyBtn1/2/3` 必须全端同步调用。`destroyBtn2/3`移除后会刷新卡牌布局。旧Selector仍只展示原有关闭和btn1，不新增按钮或改变其标题、hover行为。
- 超过 5 项或未注册点击回调会发送原有 `Z` 创建失败消息；调用方应注册 `registerFail` 清理数据。

不要把 `uiCards` 当成 `uiSelector` 使用。旧代码直接访问 `sd.uiSelector` 的显示操作需要改用 `sd.refreshCards()` 等卡牌接口。数据、`HASH_SELECT` 和业务回调不需要更换。展示期间不应改变 `count`；更换数量请销毁旧数据后新建。

## 动画与资源

`CardSelector.j` 头部宏控制宽度（高度按1619/971推导）、间距、纵向位置、入场与离场时长，均有尾部注释。1～4 张均匀平铺，5 张使用固定间距。卡面、文字、图标和点击区域使用 exReSize/exRePoint 自适应窗口比例。

使用 `cardselector_colors` 五色卡面、独立标题栏和组合外发光贴图，复用 `MUSIC_INDEX_CARD_FLIP_HOVER/REVEAL`。仅保留悬停高亮，入场使用上浮渐入；离场统一为 0.10 秒，选中牌上浮放大淡出，其他牌缩小下沉淡出，无额外停留和离场光效。

底部按钮经 `//# dependency:resource/ui/cardselector_button/button.blp` 和 `hover.blp` 导入，两张贴图均为512×256并保留渐变透明通道。底图显示宽高比10:3.8（当前宽0.10、高0.038），中心距卡牌底边0.031（较原位置上移0.024）；BLP存储尺寸与显示比例分别处理。新底图和配套金色外光由imagegen生成，源图、处理结果和解码预览保存在 `D:/War3Asset/Asset/Xlimon/Icon/20261011/cardselector_button_v2`。

2026-10-12重新生成更粗、更亮的金色外光，源图、BLP和解码叠加预览位于 `D:/War3Asset/Asset/Xlimon/Icon/20261012/cardselector_button_glow`。

按钮复用卡牌的0.02秒动画周期、1.06倍悬停缩放和0.35缓动系数，外光在底图后方随权重渐亮/渐隐，文字保持居中。鼠标每次进入按钮时播放与卡牌相同的 `MUSIC_INDEX_CARD_FLIP_HOVER` 音效，停留不重复播放；移出后再次进入可重新播放。点击区域固定，刷新布局、等待收包与关闭时清除按钮高亮，不触发selectData的hover回调或tooltip。`CARD_SELECTOR_HOVER_SCALE/EASE`共同控制卡牌与按钮动效。

`CARD_SELECTOR_BUTTON_GAP = 0.01` 是相邻按钮未悬停时的边缘间距，即左按钮右边到右按钮左边的距离，不包含外光。位置按 `(序号 - (数量 - 1)/2) * (按钮宽度 + 边缘间距)` 计算，整组始终居中。当前宽度0.10，边缘间距0.01，对应中心距0.11；若希望空隙为0.02，直接将该宏改成0.02即可。悬停仅放大外观，不重新排列按钮。宽高、外光覆盖比例和距卡牌底边距离也由头部宏控制。

旧特效素材与生成脚本仍备份在 `D:/War3Asset/Asset/Xlimon/Icon/20261011/cardselector`。`D:/War3Asset/Import/resource/ui/cardselector` 中的三组特效已移除，代码不再声明或播放这些资源。未复制到 Xlimon。

## 测试

`CardSelector_Test.j`：

- `s1`：5 张卡牌。
- `-card X`：创建 1～5 张，重复执行可替换当前组。
- `s2`：3 张，首次选择被业务拒绝，第二次正常完成。
- `s3`：非法数量 6，验证创建失败回调。
- `s4`：旧 token、越界、非规范编码、重复包测试；正常仅结算一次。
- `s5`：三张短文、长文、超长文卡牌，检查左上对齐、自动换行、窗口缩放与正文点击选牌；长正文支持视口内滚动阅读。
- `-buttons 0`至`-buttons 4`：0无按钮；1仅取消；2为btn1+取消；3为btn1+btn2+取消；4全部按钮。btn1/btn2点击后更新文字，btn3点击后移除自身并重新居中。检查整组标题始终隐藏、卡牌hover不触发测试中的失败断言，按钮无tooltip；按钮移入平滑放大并发出金色外光，移出恢复，边缘不抖动，点击/移除/关闭后无残留光效。缩放窗口后检查外光和文字仍居中。
- `s7` 或 `-scroll`：按本地实测行高构造满屏、多一行、长正文，检查滚轮能读到末行，点击轨道位置可以选卡。
- `s6`：新按钮协议测试，覆盖旧token、非owner、非规范编码、额外字段、未注册回调和合法G/H包；btn3销毁后重复H包不得再次执行。

每位玩家各自创建与点击以检查本地展示和全端回调次数。编译通过不代表已经完成实机视觉、多人或 OOS 验证。

## 历史窄长卡牌素材（2026-10-11，已停止 dependency 导入）

卡牌比例350:948，宽度宏0.14，高度由宽度推导；整组中心Y偏移0.075，以红框示意的纵向区域为参照。边框中段为细直线，正文左右内边距0.013；顶部图标、标题与正文跟随新高度重新定位。

通过dependency导入`ui/cardselector_tall_v2/face_top.blp`、`face_bottom.blp`、`hover_top.blp`、`hover_bottom.blp`，每张均为256×512。两个uiImage拼成卡面，另外两个uiImage拼成纯金黄色悬停外光；各上下半张共用中央接缝锚点，显示比例仍为350:948。卡面从原始大图重新裁切，BLP质量95，保留透明通道。拆分后的总像素数仍为256×1024，不代表总分辨率提升。

源图、裁切PNG、BLP及解码拼接预览位于`D:/War3Asset/Asset/Xlimon/Icon/20261011/cardselector_tall_v2`；导入副本位于`D:/War3Asset/Import/resource/ui/cardselector_tall_v2`。v1保留备份，不再由CardSelector导入。
