# 单个 TEXT 字号解锁：现有 InnerJAPI + 运行态 Lua

测试入口：`UITextFontUnlock_Test.j`。核心实现：
`script/experiments/innerjapi/font_size.lua`；UI：
`script/experiments/innerjapi/cases/ui_font_unlock.lua`。

不需要自编译 DLL、额外原生插件、PowerShell 启动准备或专用 Launcher 分支。
只使用地图原有 InnerJAPI 1.49-9 的 `ffi` 和 Windows 自带系统接口。
没有改动磁盘 Game.dll；没有改动 LHLua。

## 打包与使用

普通构建工具选择 InnerJAPI，将当前 `_Test.j` 打包即可。
`// lua-runtime: packaged` 标记使这个单测把所需 Lua 放进 MPQ，
不再依赖本地工程路径。这个改动只负责打包，不负责注入或加载额外插件。

最终地图也可复制到 Warcraft 的 Maps 目录，从游戏中打开。
自动验证使用原始 `war3.exe -window -loadfile Maps\Test\War3LibFontLua.w3x`，
未经过 KKWE、YDWE 或额外 DLL 加载器。它验证了直接加载地图的路径；
没有用桌面自动化点击游戏选图菜单。

已有引导仍是 `StartCampaignAI(...,"callback")` → `exec-lua:plugin_main`，
复用随地图打包的 `callback`、`(key)`、`wenhao_plugin.tga`。
本功能没有新增 return bug 代码，也不把经典版本的不同漏洞加载机制混称为同一种技术。

进入后自动对照同一个 TEXT：32 → 50 → 99 → 209 → 恢复 32 → 214。
请求值按当前分辨率下的基准尺寸计算，不能把某台机器上的 0.00951 当成所有环境的固定边界。
扫描结束后可拖动滑块；步长 0.00001，上限随扫描范围调整。
聊天 `-font 0.04` 精确输入，`-lua-reload` 重建测试，`-font-exit` 退图。
正常人工启动不会自动退图；自动验收的退出行为由临时测试环境变量启用。

## 原理与生命周期

仅支持当前已验证的 x86 Warcraft III 1.27.0.52240。
运行时核对 Game.dll SHA-256：
`e04d1716603c075eb0c8e1e21cf1093a664adc5249efab396bfa08d7b09d0c3a`，
并检查两个 clamp 块和字体函数入口，未知版本拒绝修改。

Game RVA `0xDA5AD` 与 `0xE125E` 的原始块都是：
`83 F8 20 7E 07 B8 20 00 00 00 EB 1D`。
Lua 经 FFI 调用 VirtualProtect，将两处第 4 字节 `7E` 改为 `EB`，
跳过内部整数 ppem 的 32 上限。写入后恢复页权限并刷新指令缓存。
恢复操作核对自身拥有的字节，再改回原始值，避免覆盖其他修改。

`font_size.set(frame,path,size)` 按 Game 的真实签名传递字号和 flags=0。
当前 InnerJAPI 字体封装漏传第三个栈参数，不能直接用它代替此包装。
内置 luaffi 的函数指针转换也不同于常见 LuaJIT 写法，本实现使用 uintptr_t 标量 cdata。

模块持有一个带 `__gc` 的生命周期对象。热重载先显式恢复；实际退图导致 Lua VM
销毁时，最终回调再次恢复并检查两块完整原始指令。没有安装跨 VM 存活的回调 hook。
强制终止整个进程时不依赖最终回调：被修改的内存随该进程销毁。

补丁影响本进程的字体管线，不只某个控件；测试用单个 TEXT 验证真实字号与布局增大。
整数栅格化依然存在，解除 32 不表示任意大字号都不受纹理、屏幕边界和内存限制。

## 验证与已知边界

直接 War3 的完整测试包含热重载前后两轮扫描；每轮保持同一 TEXT，验证
实际 ppem、布局尺寸、恢复 32 和再次解锁。退图前两处保持解锁，恢复由 VM 最终回调完成。
验证器在退图后等待 10 秒，从进程外读回完整原始指令，并确认游戏上下文为 0。
当前引擎限制外部 OpenProcess，因此测试模式由游戏给本轮验证器复制只读句柄；
正常使用没有观察器，也不创建外部进程。所有自动实例按 PID/创建时间清理。

直接启动中确认未加载 `inner_font_size.dll`、`ydbase.dll`、`kkapi_local_plugin.dll`。
真实 MPQ 检查同时确认 Lua 已打包、无工程绝对路径、无自定义 InnerFont natives/DLL。
2026-11-15 用户已完成人工验收，确认纯 Lua 版效果正常。

**普通启动器自动退图异常尚未归因。** 22:26 的字体测试崩溃于
`kkapi_local_plugin.dll+0x60AF9`；22:28 完全不启用字号补丁、不创建测试 TEXT、
无自定义字体 DLL 的对照崩溃于 `scriptrunner.dll+0x1E682`，两次并非同一位置。
对照说明无字号补丁也发生过启动器环境异常，但不能证明这两次属于同一根因，
也不能断言日常退出必现。保留独立 War3 路径的通过结论，两次自动启动器测试记录失败；
未改全局 KK 配置。用户后续人工验收通过，并反馈 UTRandSet 测试也会报错；
按用户要求暂不继续检查退出异常原因，不能据此断定这些报错具有相同根因。

接近 22:26 自动测试的人工复现步骤：普通启动器选择 InnerJAPI 和本单测，
等待扫描结束，输入 `-lua-reload` 并等待第二轮结束，再输入 `-font-exit`，观察 10 秒。
该命令调用 `EndGame(false)`。直接打开地图、菜单退出或关闭整个客户端不等同于
这套测试步骤；同样步骤未出现异常时应记录“未复现”，不要据旧报告判为必现。

本轮原始证据、只用于自动验收的脚本及旧 DLL 方案归档均在 Git 忽略目录
`Output/inner-font/`，不属于地图运行依赖。
首个完整进程外验证通过记录：`lua-runs/20261115-222457`；
移除旧方案后的最终包通过记录：`lua-runs/20261115-223103`；
KK 无补丁对照：`lua-runs/20261115-222814`。

包检查命令：

```powershell
& D:/War3/tools/w3x2lni/bin/w3x2lni-lua.exe Lua/tests/inner_font_package.lua D:/War3/tools/w3x2lni <地图路径>
```
