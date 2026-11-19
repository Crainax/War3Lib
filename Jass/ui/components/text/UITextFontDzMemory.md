# 纯 vJASS / DzAPI 字号滑块测试

## 当前使用

当前单测是 `UITextFontDzMemory_Test.j`。用普通 KKWE/DzAPI 启动器运行当前单测，
不选 InnerJAPI。地图只创建一个示例 TEXT（`Ag中`）和一个横向滑块。

- 滑块范围 **0.0010～0.1000**，步长 **0.0001**，初始 **0.0400**。
- 样本文字位于 (0.4, 0.40)，滑块位于 (0.4, 0.22)。拖动时原生消息显示请求值/实际 ppem。
- 聊天 `-font 0.04` 也走同一个滑块处理函数，输入按步长取整。
- 开始后约 8 秒自动检查上下端点、99/199 ppem 和恢复状态，随后停在 0.04 供人工调整。
- 手工启动不会自动退图。已删除 EndGame 专项入口；按用户要求不继续研究该独立问题。
- 成品：`Output/dz-font-memory/UITextFontDzSlider.w3x`，仍须在已经注册 DzAPI 的环境运行。

运行态纯 vJASS，不执行 Lua，不新增 DLL，不生成机器码，不改磁盘 DLL。
编译工具使用 Lua 不代表地图运行 Lua。实际 MPQ 脚本检查无 exec-lua、StartCampaignAI、initializeLua。

## 两个 native 为什么可以使用

`MergeUnits(IIII)B` 与 `SetProduce(III)B` 是游戏已有的 AI natives。
本机 1.27.0.52240 已通过 vjassc、地图虚拟机加载以及实际调用；声明不是在创建新 native。
当前 native 注册表对应 Game RVA 0x891F20 / 0x894950。仅语法编译成功不能证明其他
客户端一定注册这些入口，因此测试会再核对运行中的注册表和地址。

## 恢复方式：不跨回调保留补丁

2026-11-16 改为 `ScopedSet(size)`：

1. 核对两处原始 12 字节以及两个 native 的原地址。
2. 临时修改可写 native 分发表，通过 MergeUnits 调用已有 VirtualProtect，
   将两处字体分支 7E 改为 EB，恢复原页权限并刷新指令缓存。
3. 调用 DzFrameSetFont。当前验证版本在该调用中同步生成实际字号，返回即能读到 99/199 ppem。
4. 在同一次 JASS 回调内恢复两处完整指令、页权限，并刷新指令缓存。
5. 检查全部恢复后才返回滑块处理函数。中间没有等待、计时器让出或退出回调注册。

因此恢复不再依赖“等用户退图时执行某个事件”：正常调整结束时原始代码已经恢复，
下一帧仍保留已生成的大字号字体。正常提前退图没有待恢复的常驻字号补丁。
不把进程异常崩溃时仍可执行 JASS 清理作为保证；本测试也不修复 EndGame 的其他问题。

无需 Lua finalizer、离开事件、额外 DLL、退出 hook 或布局 getter 桥接。
曾试验过的布局 getter 桥接已经移除；实测普通 DzFrameSetFont 本身就足够。

## 内部机制和范围

- `DzFrameGetAlpha(address-0xAC)` 读 4 字节；DzSetMemory 写 real 的原始 4 字节。
- 借可写 native 分发表临时调用系统 API，native 地址在每次系统调用后立即恢复。
- Game IAT：VirtualProtect +0x94E0F4，FlushInstructionCache +0x94E274。
- native 表：`[[[Game+0xBE3740]+0x14]+0x20]`；节点 +8 为名称，+12 为函数地址。
- 两处 clamp RVA：0xDA5AD / 0xE125E，原始字节均为：
  `83 F8 20 7E 07 B8 20 00 00 00 EB 1D`。
- 实际 4 字节写入位置是各 RVA+2；0xB8077E20 ↔ 0xB807EB20，相邻三个字节不变。
- 页权限经 API 返回值检查，恢复为原始 PAGE_EXECUTE_READ (0x20)。
- 不缩放父控件，不修改字体文件；字体仍是 `Fonts\dfst-m3u.ttf`。
- ppem 是内部栅格字号，整数阶梯仍然存在；不承诺无限字号或所有版本兼容。
- 字体缓存仍是进程共享的；每次 setter 短暂修改全局管线，不宣称创建了控件私有字体引擎。
- UI 回调只改本地展示状态，不生成同步单位/计时器、不调用随机或存档。
- DzFrameGetHeight(TEXT) 在此返回 0，未用它冒充文字布局/视觉验收。

native 桥接思路参考 [DracoL1ch/WC3Memory](https://github.com/DracoL1ch/WC3Memory/blob/master/war3map.j)。
没有引入该库的数组越界、return bug、额外机器码或 DLL 加载。

## 验收和证据

- 仅 setter 的同步恢复探针：`20261115-235959-3251df`，游戏测试 PASS，清理成功。
- 单 TEXT＋滑块：`20261116-000329-8d7cbe`，游戏断言 PASS，清理成功。
  覆盖 0.04→99、0.08→199、原始 setter 新字号仍封顶32、滑块两端和回调返回前恢复。
- 自动测试通过程序设置滑块值并调用相同处理函数，没有模拟鼠标。
  **用户于 2026-11-16 确认验证完成。人工验收以用户反馈为依据，没有自动截图或鼠标模拟。没有做多人同步验收。**
- 最终源码移除未启用的 AUTO_EXIT 分支和 EndGame 命令后重新编译/打包；
  核心 ScopedSet、Patch、OnUpdate 与上述游戏测试版本完全一致。
- 已入库证据：`docs/tests/uitext-dz-font/verification.json`（80 条 PASS、源码/地图哈希、清理结果和用户确认）、`runtime.txt`（原始运行日志）、`compile.txt`（VERSION_UNITTEST / vjassc 编译日志）。
- `Output/dz-font-memory/research/slider-verification.json`：本地生成的原始结果摘要。
- `research/slider-pass.log`：完整日志；`slider-final-compile.log` / `slider-final-package.log`：构建。
- 实际 MPQ 的脚本导出：`Output/dz-font-memory/war3map.j`。
- EndGame 专项观察已按用户要求停止，临时增加的 LAN 测试器选项已撤回。
  不用该独立退出问题否定字号数值/恢复检查，也不把退出后的进程外读回宣称为已验证。

当前限定 Game.dll SHA-256：
`e04d1716603c075eb0c8e1e21cf1093a664adc5249efab396bfa08d7b09d0c3a`

当前限定 KK 插件 SHA-256：
`346aa2fa320b7919d95e7cd56792858331f6c224c5459652e166f36c832c8ee3`

这是测试专用 helper：它会屏蔽此地图的 Lua 初始化，不应直接当作正式 UI 依赖。
