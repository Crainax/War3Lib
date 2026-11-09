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

入口同时扩展模块搜索路径，原有子目录的 require 不需要迁移。首次启动其他项目时，
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
不会切换真实游戏配置或启动游戏。实际插件读取与跨局落盘仍需游戏实测。
