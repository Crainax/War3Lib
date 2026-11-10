## Warcraft 自动测试例外

- 允许通过 War3Lib 启动器及 D:/War3/tools/LanTest 的 CLI 运行测试，允许 YDWE 的 `-auto` 组件内部自动入房。此例外不允许通用桌面控制、截图点击、SendKeys 或旧 Python/war3auto 回退。
- 自动测试完成、失败或超时后，保存日志并使用 Codex-War3-StopTest 计划任务关闭本次记录的游戏 PID/创建时间；只清理本次房主。人工启动保留游戏，不自动结束。
- 同一游戏环境只运行一场自动测试；以日志完成标记和断言/OOS 证据验收，不以进程启动或没有掉线判通过。
