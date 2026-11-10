---
name: war3-runtime-test
description: 在用户要求 Warcraft III 游戏内单测、后台 LAN 测试或 OOS 验证时，编排 War3Lib/Xlimon/LH 的局域网会话、日志判定及进程清理。不用于仅编译验证，不使用通用桌面自动化。
---

# Warcraft runtime tests

Read `D:/War3/tools/LanTest/README.md` for the actual validated status and parameters before launch. The installed exact-build loader timing fix was tested with 1/2/6 clients. The original 300 ms `-auto` loop reproduced a wrong-menu failure (multiplayer load-save screen); the compatibility helper sets 3000 ms with a verified backup. After WE upgrades, revalidate the loader rather than patch unknown binaries. Timeouts must fail and clean up, never silently switch to screenshot/click automation or claim success.

- Preserve unrelated changes. Select the intended test target and compile/package through the active checkout's workflow. Keep compile locks/worktree isolation. One game environment supports one session at a time; client count 1..6 is within that session, not multiple simultaneous builds.
- Human launcher defaults to single-player and does not remember LAN/count. For requested unattended runtime tests, explicitly choose LAN with one client, or at least two for synchronization coverage. A one-client LAN test is not OOS validation.
- Use `Start-LanTest.ps1 -Automated` with an explicit packaged map, client count, client log directory and completion regex. Current log adapter requires fresh `-P1.log` … `-P6.log` files, one completed player per requested client. Only use compatible static JASS slot metadata with `-UseScriptSlots`; the game path must match the launcher registry path. `-LegacySizeCap` applies to the installed legacy size-limit hook, not arbitrary Warcraft installations.
- Tests need an automatic entry, nonzero assertions and a unique completion marker in each client log. Confirm BJDebugMsg/Trace actually reaches that engine's log. A marker without exercised assertions is insufficient. A smoke observation is labelled SMOKE, never PASS.
- Host `desync detected` fails the run even without a disconnect. Client exits, missing logs/markers, runtime errors and deadlines fail. Preserve original host/client evidence and report coverage; starting/loading is not proof of successful tests.
- Cleanup is automatic in the launcher finally block. The manifest records each client PID and CIM creation ticks. `Stop-LanTest.ps1` calls the existing Codex-War3-StopTest task serially and stops only the owned host. Confirm cleanup.json and process exit. Never kill by wildcard/name or terminate an unrelated session.
- YDWE component-internal `-auto` is the only native input exception. No desktop capture/activation, SendKeys, pyautogui or Python/war3auto fallback. Manual launch leaves the game running; automated launch cleans up on success/failure. Installed task does not require an open admin terminal. Only task installation/updates require administrator input.
