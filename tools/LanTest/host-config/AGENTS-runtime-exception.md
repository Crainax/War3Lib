## Warcraft 自动测试例外

- 允许通过 War3Lib 启动器及 D:/War3/tools/LanTest 的 CLI 运行测试，允许 YDWE 的 `-auto` 组件内部自动入房。此例外不允许通用桌面控制、截图点击、SendKeys 或旧 Python/war3auto 回退。
- 自动测试完成、失败或超时后，保存日志并使用 Codex-War3-StopTest 计划任务关闭本次记录的游戏 PID/创建时间；只清理本次房主。人工启动保留游戏，不自动结束。
- 同一游戏环境只运行一场自动测试；以日志完成标记和断言/OOS 证据验收，不以进程启动或没有掉线判通过。

- 默认自动 Warcraft 测试通过 `Start-LanTest.ps1 -Automated -OwnerId <任务标识>` 排队；明确使用独立 A/B 环境时，通过 PowerShell 7 的 `pool/Start-PoolTest.ps1 -Environment A|B -OwnerId <任务标识>` 进入对应环境队列（该入口始终自动清理）。不同环境允许并行，同一环境禁止绕过队列。等待时继续不依赖游戏的工作，不重复启动同一测试。
- 遇到其他 agent 的测试或人工/未知归属游戏，只等待，不再要求用户关闭魔兽，也不代替其他任务清理。队列超时记为 DEFERRED，明确运行验证尚未完成。
- 清理由本次自动测试的拥有者在 finally 中执行，传入匹配 OwnerId 并核对 PID/创建时间；死队列记录可跳过，但不能据此清理孤儿游戏。FINISHED 队列状态不代表测试或清理成功，须检查 result.json / cleanup.json。
- A/B 池使用固定目录、配置与端口；占用期间不重建或覆盖运行文件。默认入口尚不自动分配环境。双场自动入房与归属清理已验收，人工游戏同时运行尚未验收，不得声称已证明互不影响；不得结束人工或未知归属进程。
