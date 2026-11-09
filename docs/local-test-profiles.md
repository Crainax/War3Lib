# 本地测试项目隔离

公共地图启动入口 `Lua/compile/Launcher.lua` 在包检查通过后调用
`script/LocalTestProfile.ps1`，切换成功后才调用 YDWEConfig。全量、增量、老地图及
TaskStartMap 的启动都经过此入口；取消选择、仅编译、仅打包不会切换。
直接在编辑器外双击地图或运行 YDWEConfig 不经过本入口。

## 云脚本

KKWE `bin/EverConfig.cfg` 的 `[MapTest]` 设置为
`EnableMlScript = 1` 和 `MlScriptFolder = <当前项目>/CloudScripts`。
保留其他配置。根入口默认如下：

| 项目 | 根入口加载 |
| --- | --- |
| War3Lib | MlsProbe/main.lua |
| Xlimon | Shengjingshi/main.lua |
| LH | 空入口 |

KKWE 的 scriptrunner 提供 require，但没有全局 package 表；入口不得修改 package.path。
根入口使用 require("MlsProbe.main") 等完整模块名，子模块由接收的模块名推导目录前缀。
直接以原子目录 main.lua 作为入口时前缀为空，保留旧加载方式。首次启动其他项目时，
不存在的 CloudScripts/main.lua 自动创建为空入口；已有入口不会覆盖。

## 两份 INI

文件均保留在配置的魔兽目录，以项目文件夹名作为标识：

- `dz_w3_plugin_<项目>.ini`
- `kkapi_local_plugin_<项目>.ini`

插件仍使用原名文件。`local_test_profile.json` 分别记录两份原名文件的归属和
上次装入时的 SHA256。切换前回存游戏产生的修改，然后装入目标项目。
原名未修改时保留项目文件的手工修改；两边都修改且内容不同时报错，避免覆盖。
此时需人工合并对应两个文件到相同内容，再启动即可。

新项目使用最小 `[DzAPI]` 配置，KK INI 另含 `MLS-MsGetEnvType=-1`，
不复制其他项目的数据。编译器直接读取项目专属 dz INI；编译时间仅在生成的
mock 中更新，不改写 INI。未初始化项目的编译使用默认配置。

2026-11-09 初始化：原 dz INI 完整归入 Xlimon；War3Lib/LH 的 dz INI 为最小配置。
KK INI 沿用已分离的圣晶石、War3Lib 探针数据；LH 为空。初始化没有切换原名文件。
已有的 `kkapi_local_plugin.pre-project-split.bak` 是一次性迁移原件，不会追加备份。

## 保护与恢复

游戏运行期间禁止切换。启动器持有独占 `local_test_profile.lock`，直到观察到魔兽进程。
YDWEConfig 提前退出不再释放启动保护。启动前写入唯一的
`local_test_profile.launching.json`，观察到游戏后删除；10 秒内未观察到游戏、启动异常
或启动器被中断则保留，后续启动停止切换。此时先确认 YDWEConfig 和魔兽均已结束，
再删除这一标记后重试；不要在仍有延迟启动的进程时删除它。

INI、状态和事务记录均通过同目录临时文件原子替换，避免直接截断存档。
切换前复核所有读入文件，提交时复核写入目标，发现并发修改即停止。
切换事务使用唯一的 `local_test_profile.transaction.json`；成功即删除。
恢复前先检查全部记录，只自动恢复内容等于事务写入结果的文件；已经恢复的文件跳过。
若任何文件包含事务之外的新内容，则不进行任何恢复写入，保留文件和事务记录供人工核对。
旧格式事务缺少写后校验值时，也不会擅自覆盖未知内容。

事务冲突时不要直接删除事务记录：其中保存了切换前的完整数据，需先核对并保留各项目
最新存档，再统一状态归属。没有按时间生成的备份文件。不要在游戏运行时手动修改
原名 INI 或 KKWE 云脚本路径；绕过本启动器的外部程序不受启动锁约束。

迁移到其他魔兽目录时，不应猜测已有原名 INI 的归属。须先保存对应项目文件并建立
version=1 的 ownership 状态（owners 和 hashes 均以两个无扩展名 INI 名为键）；
缺少状态时启动器会报错，不覆盖未知存档。当前机器已完成此初始化。

## 验证

`powershell -NoProfile -ExecutionPolicy Bypass -File script/LocalTestProfile.Tests.ps1`
在临时目录验证切换、回存、手工修改、冲突、空项目、中文路径和长内容，
以及写入失败回滚、重复恢复、新内容保护和待启动/运行中拦截。
不会切换真实游戏配置或启动游戏。已完成的游戏实测范围见下节。

## 2026-11-10 根入口兼容性修复

旧入口访问 package.path，在本机 scriptrunner.dll 的 Lua 初始化方式下复现
`main.lua:2: attempt to index a nil value (global 'package')`，导致事件未注册。
普通 Lua CLI 默认公开 package，因此此前测试没有覆盖这一限制。

`lua script/TestCloudRoot.lua D:/War3/Library/War3Lib/CloudScripts MlsProbe`
在隐藏 package/io/debug 的环境中验证模块加载、事件注册、Ping 和只读回包。
本机 DLL 独立加载验证也已通过；平台接口使用模拟实现，不代表游戏内传输或持久化通过。

## 2026-11-10 KKWE 单机实测结果

使用公共 Launcher / LocalTestProfile 启动，游戏内操作由测试者完成。War3Lib 使用
`Output/MlsProbe.w3x`；Xlimon 使用圣晶石分支的隔离目录
`D:/War3/Worktrees/profile-live-test/Xlimon` 和已核验协议为 2 的圣晶石测试地图。
没有切换或修改 `D:/War3/Maps/Xlimon` 当前开发分支。

每次切换均核对两份生效 INI、归属状态、项目专属文件哈希及 KKWE 配置。
War3Lib 云脚本目录为 `D:/War3/Library/War3Lib/CloudScripts`；Xlimon 为上述隔离目录下的
`CloudScripts`。存档仍使用魔兽目录中相同的 `_War3Lib.ini` / `_Xlimon.ini` 项目文件。

日志根目录为 `D:/Program Files (x86)/Warcraft III Frozen Throne/`，时间均为北京时间。

| 阶段 | 日志（相对日志根目录） | 关键结果 |
| --- | --- | --- |
| 根入口修复后首次 War3Lib | `War3Lib/日志/log-2026-11-10-01-39-42-P1.log` | 01:39:46 Ping 往返 PASS，读到 count=2、score=10 |
| 首次切到 Xlimon | `异度幻世篇/日志/log-2026-11-10-01-42-51-P1.log` | 读到 seq=13、balance=189、count=2、activeId=2；s3 确认 pending=13 |
| 返回 War3Lib 并新增写入 | `War3Lib/日志/log-2026-11-10-01-43-50-P1.log` | 先读到 2/10；01:45:53 s2 保存确认，01:45:54 读到 count=3、score=20 |
| 写入后再切到 Xlimon | `异度幻世篇/日志/log-2026-11-10-01-46-44-P1.log` | 01:47:07 仍读到 seq=13、balance=189、count=2、activeId=2 |
| 再次返回 War3Lib，新进程读档 | `War3Lib/日志/log-2026-11-10-01-47-54-P1.log` | 01:47:58 Ping 往返 PASS；Player JSON={"score":20,"count":3} |

文件核对结果：

- 写入前 War3Lib KK INI SHA256：
  `165da0fd9b8b893abc1c73508095278862e1f70691277cc74576dd2cde5090d5`。
- s2 后生效 KK INI SHA256：
  `5dae2f5b25710b360e26d9da6aae3482811052b29f36cabbeb779d65f193bb1a`。
  下一次切到 Xlimon 时，该文件逐字节回存到 `kkapi_local_plugin_War3Lib.ini`；
  返回 War3Lib 后生效文件与该项目文件完全一致。
- 除计数从 2 到 3、积分从 10 到 20 外，War3Lib 脚本存档其他字段保持不变。
- Xlimon 两份专属 INI 全程与初始基线逐字节一致；KK INI SHA256 始终为
  `bbce6fe916e73b896c2a43919d4e4b8e1a183480e5af05160a3065c03867b424`。
  189 矿、两颗石头、已装备 ID 2 和待确认洗炼 ID 13 均保留。
- 每次切换完成后，两份生效 INI 均与目标项目文件一致；未遗留待恢复事务或启动标记。

已验证本地单机的“War3Lib 新增写入 → Xlimon → War3Lib 新局读回”，以及切换期间
Xlimon 既有存档不被覆盖。没有测试 Xlimon 新增业务写入、旧 dz INI 的游戏内新增写入、
线上平台或多人同步，不将以上结果扩展为这些场景的保证。最后环境停留在 War3Lib。

原始日志、真实 INI 和临时 DLL 诊断工具保留在本机，不纳入源码提交。
