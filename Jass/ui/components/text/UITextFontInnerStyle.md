# TEXT 字体、描边与阴影：最终使用结论

## 已验证的结果与边界

2026-11-17，用户确认最终合并绘制版本的描边观感、点击文字、改字后的表现正常。此前五字体对照也已人工验证。当前保留的测试精简为游戏原字体，不再依赖 UnitTestMap 内的外部字体。

本实现针对已校验的经典版 Game.dll 1.27.0.52240 / InnerJAPI 1.49-9；初始化沿用 font_size.lua 的文件哈希和指令签名门禁。不匹配时拒绝安装，不能去掉门禁跨版本使用。最多同时登记 64 个描边 TEXT。未验证多人/OOS、其他引擎版本或更多对象；这里只承诺本机已验收场景。

## 字体与阴影结论

- 字体字重控制红/白字形本身；黑色描边控制外缘，不能替代 Bold/Heavy 字重。原始小截图不足以唯一确认字体，微软雅黑 Bold 只是已实际对照过的候选。
- SimHei 比本次思源 Bold/Heavy、微软雅黑 Bold 显得细。根目录 `微软雅黑 Bold.ttf` 来自用户提供地图，文件内部名称为 Microsoft YaHei Bold，格式为 TrueType；不是常规微软雅黑。
- 阴影偏移单位为 UI 坐标，正 X 向右、正 Y 向上；(0.001,-0.001) 为右下。不能把 War3 默认阴影概括为总向左。
- FDF 的 FontShadowColor/FontShadowOffset 或代码均能设置阴影。连续 AddTextShadow 是后一次覆盖前一次：红左→蓝右最终蓝右，反序最终红左。同方向换色也是最后一次生效。
- 因此连续八次 AddTextShadow 不能生成八向描边，最后看到的单向黑影不等于描边。vJASS 的正确方式是先设置 seed 阴影，再 DuplicateTextShadow。
- 以 (radius,0) 为 seed 时半径就是 radius；(r,-r) 的长度为 sqrt(2)*r。0.0005/0.0010/0.0015/0.0020 增大时边缘变粗。copies 是额外方向数，不是像素宽度，16 不等于两倍粗；建议先用 radius=0.0005 或 0.0010、copies=8。
- 字号、分辨率与字形都会影响最终像素效果。font flag=1/2 未证明是可用粗体/描边开关。

vJASS / KKAPI：

```jass
call DzFrameAddTextShadow(frame, 0.0010, 0.0, 0xFF000000)
call DzFrameDuplicateTextShadow(frame, 8)
```

## InnerJAPI 使用方式

依赖链：font_outline → font_outline_kkcache → font_style、font_outline_cache_core → font_size、font_outline_cache_bytes。运行时不加载另行编译的插件 DLL，不进行描边维护轮询，不从原生绘制/析构路径回调 Lua。

先加载本目录的 UITextFontInnerStyle.toc/FDF，创建两个校验用隐藏 TEXT（模板 InnerStyleRight、InnerStyleLeft），初始化一次。right/left 的默认 FDF 阴影用于确认当前结构布局，不是每个目标的叠加文字。

```lua
local outline = require 'script.experiments.innerjapi.font_outline'
outline.init(rightReference, leftReference)
-- target 是有效的 TEXT frame；一个目标只需一个 TEXT。
outline.setStyle(target, {radius=0.0010, copies=8, color=0xFF000000})
-- 后续正常 FrameSetText / 改字体 / 移动 / 点击，无需重新设置描边。
-- 改为单向阴影：
outline.setStyle(target, {radius=0, x=0.001, y=-0.001, color=0xFF000000})
-- 取消可见偏移：
outline.setStyle(target, {radius=0, x=0, y=0})
```

radius 允许 0..0.003；copies 为 1..16 的整数，默认 8；color 为 ARGB，默认不透明黑。radius>0 时 x/y 不参与计算。重复 setStyle 会移除旧登记后重新配置，不应在每次改字时重复调用。

正常 DestroyFrame 自动清理。remove(frame) 只取消额外描边缓存，原生 seed 阴影仍在；完全取消可见阴影请使用上面的零偏移设置。stop() 用于整个模块卸载，释放全部缓存并恢复自己安装的补丁；不是逐 TEXT 销毁的替代品。

根目录字体是独立资源，不默认导入测试图。需要使用时，在项目打包资源中将 `微软雅黑 Bold.ttf` 导入为 `Fonts\YaHeiBold.ttf`，再用 FrameSetFont 或 font_size.set 指向该地图内部路径；不得把本机绝对路径作为发布地图的字体路径。UnitTestMap 不保留本次四款对照字体，原有 zt.ttf 不属于本次清理。

## 原生实现、缓存及性能

cache_core.c 离线编译为 x86 PIC，再由 extract.py 写入 font_outline_cache_bytes.lua。Lua/FFI 只在安装、设置及显式诊断时进入；Windows 系统 API 指系统自带 kernel32 的内存保护、分配、指令缓存刷新等接口，不是额外自制 DLL。

原生 glyph 重建、TEXT 重建和 shadow-only 更新事件恢复缓存。绘制路径仍每帧执行标志检查、已登记对象查找及描边提交，不能说零成本；但不每帧进入 Lua，不重复生成未失效几何。

每个 TEXT 独立持有容量缓存，改字复用，容量不足才扩容；缩短/空串保留高水位直到销毁或移除。逻辑销毁请求立即释放，实际对象可因引擎引用延后析构；raw-string 和最终析构路径作为幂等清理保障。旧版销毁后两秒不归零的问题已在请求路径修复，不靠定时器等最终析构。

复刻的是已追踪的 KKAPI 行为和关键缓存生命周期，并非直接复制整个 DLL。默认八份额外阴影按 2pi/(copies+1) 分布，保留一份原生 seed。现版本将同批额外阴影合并为一次提交，连同 seed 和前景通常共三次；不跨 TEXT、纹理或组混合。合并批上限 4096 顶点，超过分段，原批本身超限则退回逐份提交。原始引擎前景数组不改写，颜色/alpha 使用当前原生值。

合成原生回归覆盖 XYZ/UV/索引顺序、动态 alpha、分段尾批、超限退回、1000 次重建复用、raw 地址变化、扩容/缩短、延迟析构、重入销毁和卸载恢复。

2026-11-16 实机三局功能回归共 719 PASS：完整显示/生命周期 181、64 TEXT 容量复用 268、长文本分段 270；对应会话 20261116-221228-A-658263、20261116-221437-A-5cbd6e、20261116-221542-A-befde2，清理均成功。64 个销毁请求后 active/blocks/bytes 归零。

同场景六局、54 阶段对照：16/64 TEXT、30 字符、半径 0.001、8 份额外阴影；动态每 0.05 游戏秒改字、每段 400 轮。确认绘制计数继续前进，剔除疑似停画及静态发生重建的样本。以下是同局“有描边减无描边”的平均进程 CPU 增量，单位 ms/墙钟秒，1000 代表一个逻辑核心满载，并非 FPS。

| 场景 | 旧版 Inner（已复用） | 当前 Inner | vJASS KKAPI |
| --- | ---: | ---: | ---: |
| 16 TEXT 静态 | 21.3 | 18.1 | 18.5 |
| 64 TEXT 静态 | 41.0 | 30.7 | 35.7 |
| 16 TEXT 改字 | 8.8 | 2.5 | 22.1 |
| 64 TEXT 改字 | 22.7 | 22.9 | 41.9 |

静态开销下降，64 TEXT 动态新旧基本持平，与 KKAPI 同量级；样本波动和跨局基线不同，不能据此宣称稳定快于 KKAPI。同局同 64 TEXT 的八段交替实验，四组均是合并提交较低，均值 121.4→98.5 ms/s（该场景约18.9%），单组差值2.1..47.3，不能泛化成固定提速。该场景缓存由768 KiB增为1.5 MiB，以空间换提交次数；稳态分配/扩容/释放均为零。

最终五字体人工验收地图 SHA256：a33966fc456279fc16377c13f06dfddc0bac914ffe4632a67227565addad49e8。该图保留在本地 Output/font-style/UITextFontInnerStyle.w3x，不纳入 Git。清理后的默认字体测试与这张旧地图区分，不能把原图人工验证冒充为精简图的新一轮人工验证。

## 重建与回归

在仓库根目录运行（需要现有 LLVM、Python、War3 工具链）：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File research/innerjapi-font-outline-core/Build-CacheCore.ps1
& D:/War3/tools/w3x2lni/bin/w3x2lni-lua.exe -e "package.cpath='D:/War3/tools/w3x2lni/bin/?.dll;'..package.cpath; dofile('Lua/tests/inner_font_outline_cache.lua')"
powershell -NoProfile -ExecutionPolicy Bypass -File research/innerjapi-font-outline-core/Build-TestMap.ps1
& D:/War3/tools/w3x2lni/bin/w3x2lni-lua.exe Lua/tests/inner_font_outline_cache_package.lua Output/font-style/UITextFontInnerStyle-clean.w3x
```

先选中 UITextFontInnerStyle_Test.j；Build-TestMap 使用 VERSION_UNITTEST/vjassc，将当前 FDF/TOC 同步进打包目录，不启动游戏，生成 -clean.w3x 并恢复原启动器槽位。保留原验收图不覆盖。测试序列的有限计时器用于制造改字、销毁等场景，不用于描边恢复。进入地图后自动完成测试，可点击文字、观察改字，再输入 `-outline-check` 做一次显式检查；日志完成标记为 INNER_OUTLINE_CACHE_DONE，任何 FAIL 均需排查。

## 本次整理验证（2026-11-17）

- 原生 C 核心重建为 20780 字节 PIC；真实机器码隔离回归通过，包含 1000 次完整重建复用与销毁/卸载零残留。
- 保留的 Lua 文件语法检查通过；InnerJAPI 与 vJASS 两个精简测试入口均 VERSION_UNITTEST/vjassc 编译成功。
- InnerJAPI 精简地图打包检查通过：运行模块与当前源码一致，FDF/TOC 一致，无旧四款字体，无旧 DLL 载荷或本机源码路径依赖。
- 新一轮实机自动回归因 A/B 环境占用，在尚未获准启动、未创建游戏会话时结束排队，记为 DEFERRED；没有结束任何现有游戏。精简图没有新增实机 PASS，最终五字体版本的人工验收仍以用户本次确认为准。
- 本次清理保留了原验收地图和无关工作区修改，并逐项核对哈希。字体 SHA256 为 42c02cfcf0010d5fd00125e6c7a5e99eb2ccccab9187b06755fa02fe5c44bf81。

历史探针、失败产物和性能跑分脚本已移出工作区，仅保留上述结论和可重复执行的实现回归。批量永久删除被自动审批策略拒绝，因此改为可恢复隔离到系统临时目录 War3Lib-outline-cleanup-20261117；该隔离目录不纳入 Git。性能表是已完成研究的摘要，不是现留单元测试自动重跑出的基准。
