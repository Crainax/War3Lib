# 字体、描边与阴影研究结论

## 结论与适用范围

2026-11-16，用户在本机 KKWE/DzAPI 环境测试并提供截图。结论限定当前经典版游戏、TEXT 控件和当前 API 实现；没有多人 OOS 或 InnerJAPI Lua 路径验收。

- 字体字重决定红/白笔画本身的粗细；黑色描边只改变外缘，不能替代粗字体。
- `DzFrameAddTextShadow(frame,x,y,color)` 设置阴影偏移和颜色。连续调用在本次 TEXT 上表现为后一次覆盖前一次，不是累加。
- 实用描边方式是先 AddTextShadow 设置一份黑影，再 `DzFrameDuplicateTextShadow(frame,count)` 沿圆周复制。半径控制粗细，count 控制额外复制数量/覆盖密度，不是像素宽度。
- 本次固定 count=8 时，半径 0.0005、0.0010、0.0015、0.0020 的黑边逐渐变粗；固定半径 0.0010，count=3/8/16 的主要差别是覆盖密度，不能把 16 理解成两倍粗。
- 偏移单位是 UI 坐标，不是固定像素。使用 `(radius,0)` 时向量长度就是半径；`(r,-r)` 的长度为 sqrt(2)*r，不应混为同一半径。
- FDF 的 FontShadowColor/FontShadowOffset 也可以设置阴影。X 正向右、Y 正向上，所以 `(0.001,-0.001)` 是右下。原生 FDF 中已有右下偏移，不能概括为默认全向左。
- `DzFrameSetFont` 的 flag=1/2 在早期截图中没有明显效果，不把它们当作已验证的粗体/描边开关。

```jass
call DzFrameSetFont(frame, "Fonts\\FontStyle-YaHeiBold.ttf", 0.012, 0)
call DzFrameAddTextShadow(frame, 0.0010, 0.0, 0xFF000000)
call DzFrameDuplicateTextShadow(frame, 8)
```

## 如何证明覆盖而非累加

V2 的 6.A/6.B 分别是红左影 (-0.003,0) 和蓝右影 (0.003,0)。6.C 先红左后蓝右，截图仅蓝右；6.D 先蓝右后红左，截图仅红左，因此支持后一次覆盖。6.E/6.F 同方向交换颜色，作为辅助；同方向最后颜色本身不能排除不透明层遮挡，必须结合 C/D。

6.0—6.2 曾尝试在半径 0.0005/0.0010/0.0015 上连续八次 AddTextShadow，角度为 j*pi/4，j=0..7。这一方案不能形成八向描边：最后 j=7 恰好是右下，覆盖后只剩右下阴影。此前“连续八次可叠加”的假设已撤回。

接口原始说明见本机 `D:/WE/KKWE_Plugin/share/mpq/kkapi/action.txt`：Duplicate 在原有阴影基础上复制额外阴影，并均匀分布在圆周。声明见 `YDWE/jass/KKAPI.j`。

## 字体识别与比较

| 字体 | 来源/处理 | 观察 |
|---|---|---|
| 原字体 | Fonts/dfst-m3u.ttf | 保留基准，不仅凭外观推断家族 |
| SimHei | 本机 Windows simhei.ttf | 彩色笔画较细 |
| 思源黑体 Bold | 官方 CN 可变 TrueType 固定 wght=700 | 比 SimHei 粗 |
| 思源黑体 Heavy | 同源，固定 wght=900 | 比 Bold 更粗 |
| 微软雅黑 Bold | 用户指定地图 fonts/YLfonts.ttf | 内部名称 Microsoft YaHei Bold，weight=700，Version 0.75 |

最初小截图只能判断黑体风格，不能唯一辨认具体字体。随后只读提取 `D:/yinglingchuanshuo.w3x`，其 war3mapSkin.txt 中 ChatFont、EscMenuTextFont、InfoPanelTextFont、MasterFont、MessageFont、TextTagFont 都指向 fonts/YLfonts.ttf，内部元数据确定为微软雅黑 Bold。未修改原地图，也不据此断言所有自定义 UI 没有其他字体覆盖。

思源来源：https://github.com/adobe-fonts/source-han-sans/tree/release/Variable/TTF/Subset ，文件 SourceHanSansCN-VF.ttf。使用 fontTools 4.68.0 的 instantiateVariableFont(font, {'wght':700或900}, inplace=True, updateFontNames=True)，保存为静态 TTF，验证无 fvar、有 glyf。保留 CN 完整字形集 31072 glyphs；不是改扩展名或伪加粗。

## 当前测试与重建

入口 `UITextFontStyle_Test.j`，配套 `.j/.cfg/.fdf/.toc`。五组，每组无描边、0.0005、0.0010，共15行；字号0.012、行距0.020，Y=0.550..0.270，描边复制8份。四位小数使用 R2SW(value,1,4)。使用普通 KKWE/DzAPI，手动启动留在图中供观察。

测试辅助模块仅关闭 Lua 引导，不读写内存或安装字号补丁，独立于之前的 UITextFontDzMemory 研究。该 helper 是测试专用，不直接作为正式 UI 依赖。

重建前准备以下文件（字体、地图输出和临时文件不入库）：

- 同目录 FDF/TOC → UnitTestMap/map/ui/。
- Windows simhei.ttf → UnitTestMap/map/Fonts/FontStyle-SimHei.ttf。
- 官方思源字体静态化 → 同目录 FontStyle-SourceHanSansCN-Bold.ttf / FontStyle-SourceHanSansCN-Heavy.ttf，并放入 SourceHanSans-LICENSE.txt。
- 用户提供地图提取的 YLfonts.ttf → 同目录 FontStyle-YaHeiBold.ttf；哈希见验证记录。不把字体提取等同于正式分发授权。

不能只把 FDF/TOC 放 resource/ui：本次早期打包实测漏入最终 MPQ，改到 map/ui 后逐字节检查通过。

选择 Jass/config/UnitTest.h 中本测试；以 VERSION_UNITTEST / vjassc 编译，再用 TaskLaunch 的 action=start,version=VERSION_UNITTEST,compiler=vjassc,engine=ydlua,scenario=current --no-launch 打包。用 w3x2lni-lua.exe 执行 Lua/tests/font_style_package.lua [地图路径] 验证模板、四种导入字体、许可证和纯 JASS 入口。默认输出 Output/font-style/UITextFontStyle.w3x。

## 验证记录

入库证据在 `docs/tests/uitext-font-style/`：

- `shadow-comparison.png`：用户提供 V2 截图，支持覆盖结论和描边半径对照。
- `font-comparison.png`：用户最终提供 V4 五字体截图，并明确“测试完了”。
- `verification.json`：版本、哈希、人工验收与自动验证范围。
- `compile.txt`：最后解除旧辅助模块依赖后的编译通过。
- `runtime-v1.txt`：早期 V1 39条断言通过，只验证创建/API 返回值，不能当作 V4 自动运行。
- `font-identification.json`：目标地图字体元数据。

早期会话 20261116-025830-A-2eaf40 虽 API 通过但缺模板，不作为完整包验收；20261116-030038-A-1af36b 因覆盖旧日志保留 CreationTime，被测试器拒绝并超时，清理成功；20261116-030238-A-903c09 的正确包39条断言通过、清理成功。自动日志重复运行要归档本任务旧日志或使用唯一文件名，不修改时间戳冒充新证据。

V2/V3/V4 均有用户截图反馈。最终提交前仅把关闭 Lua 引导的设置移入本模块、移除旧 DzMemory 依赖；显示布局、字体及阴影调用未改变。修改后重新编译和打包检查通过，没有对这个最后重打包版本重新宣称人工/自动游戏验收。
