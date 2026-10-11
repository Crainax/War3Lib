# 卡牌选择器

## 创建与回调

在全端同步事件中创建 `selectData.create(p, count)`，注册映射和回调后调用 `sd.showCards()`。支持 1～5 项，牌位仍为 1-based。`showCards` 仅在 owner 本地创建 UI，其 boolean 返回值不得用于同步业务分支。

- `reflectIcon`：图标，沿用 `CallbackSelectContent`。
- `reflectName`：标题。
- `reflectDescription`：新增正文映射。
- 正文由 `uiText` 显示，固定2号字、左上排版，自动换行，不支持滚轮。图标上移0.01；标题与图标、正文与标题的间距均为0.005。标题框使用单行高度0.014，正文锚在其底部下方0.005；标题高度、左右与底部内边距在 CardSelector.j 宏中调整。
- 正文不拦截鼠标输入，点击正文、图标、标题或卡牌边缘均通过整张卡按钮发送标准Select包；鼠标在正文上仍保持卡牌悬停高亮。
- `reflectShadow/reflectGrow`：沿用图标阴影与 growdata。
- 映射和悬停通过 `GetSelectDataAsync()/GetSelectPosAsync()` 读取上下文。
- `registerClick` 在 `Select` 通道延迟收包并通过 owner/token/位置校验后执行，使用 `GetSelectData()/GetSelectPos()` 读取上下文。
- 点击回调执行 `sd.destroy()` 表示完成选择；本地 UI 解绑数据后继续离场，动画结束不再执行任何业务回调。
- 回调保留本轮数据表示拒绝或需要继续选择，刷新展示并解锁。不要在本地动画回调中发放奖励。
- `registerClose/registerBtn1/registerFail` 保持原有收包协议；关闭和刷新按钮由注册情况决定。
- 超过 5 项或未注册点击回调会发送原有 `Z` 创建失败消息；调用方应注册 `registerFail` 清理数据。

不要把 `uiCards` 当成 `uiSelector` 使用。旧代码直接访问 `sd.uiSelector` 的显示操作需要改用 `sd.refreshCards()` 等卡牌接口。数据、`HASH_SELECT` 和业务回调不需要更换。展示期间不应改变 `count`；更换数量请销毁旧数据后新建。

## 动画与资源

`CardSelector.j` 头部宏控制宽度（高度自动两倍）、间距、纵向位置、入场与离场时长，均有尾部注释。1～4 张均匀平铺，5 张使用固定间距。卡面、文字、图标和点击区域使用 exReSize/exRePoint 自适应窗口比例。

复用 `cardflip_c_v3/flip_23.blp`、`hover.blp` 以及 `MUSIC_INDEX_CARD_FLIP_HOVER/REVEAL`。仅保留悬停高亮，入场使用上浮渐入；离场统一为 0.32 秒，选中牌上浮放大淡出，其他牌缩小下沉淡出，无额外停留和离场光效。

旧特效素材与生成脚本仍备份在 `D:/War3Asset/Asset/Xlimon/Icon/20261011/cardselector`。`D:/War3Asset/Import/resource/ui/cardselector` 中的三组特效已移除，代码不再声明或播放这些资源。未复制到 Xlimon。

## 测试

`CardSelector_Test.j`：

- `s1`：5 张卡牌。
- `-card X`：创建 1～5 张，重复执行可替换当前组。
- `s2`：3 张，首次选择被业务拒绝，第二次正常完成。
- `s3`：非法数量 6，验证创建失败回调。
- `s4`：旧 token、越界、非规范编码、重复包测试；正常仅结算一次。
- `s5`：三张短文、长文、超长文卡牌，检查左上对齐、自动换行、窗口缩放与正文点击选牌；超长内容不提供滚动阅读，应由调用方控制正文长度。

每位玩家各自创建与点击以检查本地展示和全端回调次数。编译通过不代表已经完成实机视觉、多人或 OOS 验证。

## 窄长卡牌素材（2026-10-11）

卡牌比例350:948，宽度宏0.14，高度由宽度推导；整组中心Y偏移0.075，以红框示意的纵向区域为参照。边框中段为细直线，正文左右内边距0.011；顶部图标、标题与正文跟随新高度重新定位。

通过dependency导入`ui/cardselector_tall_v2/face_top.blp`、`face_bottom.blp`、`hover_top.blp`、`hover_bottom.blp`，每张均为256×512。两个uiImage拼成卡面，另外两个uiImage拼成纯金黄色悬停外光；各上下半张共用中央接缝锚点，显示比例仍为350:948。卡面从原始大图重新裁切，BLP质量95，保留透明通道。拆分后的总像素数仍为256×1024，不代表总分辨率提升。

源图、裁切PNG、BLP及解码拼接预览位于`D:/War3Asset/Asset/Xlimon/Icon/20261011/cardselector_tall_v2`；导入副本位于`D:/War3Asset/Import/resource/ui/cardselector_tall_v2`。v1保留备份，不再由CardSelector导入。
