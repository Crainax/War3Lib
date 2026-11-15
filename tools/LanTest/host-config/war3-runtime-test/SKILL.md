---
name: war3-runtime-test
description: 在用户要求 Warcraft III 游戏内单测、后台 LAN 测试或 OOS 验证时，编排 War3Lib/Xlimon/LH 的局域网会话、日志判定及进程清理。不用于仅编译验证，不使用通用桌面自动化。
---

# Warcraft runtime tests

Read `D:/War3/tools/LanTest/README.md` for the actual validated status and parameters before launch. The installed exact-build loader timing fix was tested with 1/2/6 clients. The original 300 ms `-auto` loop reproduced a wrong-menu failure (multiplayer load-save screen); the compatibility helper sets 3000 ms with a verified backup. After WE upgrades, revalidate the loader rather than patch unknown binaries. In-game timeouts must fail and clean up owned processes; admission timeouts are DEFERRED. Never silently switch to screenshot/click automation or claim success.

- Preserve unrelated changes. Select the intended test target and compile/package through the active checkout's workflow. Keep compile locks/worktree isolation. One game environment supports one session at a time; client count 1..6 is within that session. Automated runs enter the FIFO queue; do not bypass it or request that the user close a game to unblock a task.
- Human launcher defaults to single-player and does not remember LAN/count. For requested unattended runtime tests, explicitly choose LAN with one client, or at least two for synchronization coverage. A one-client LAN test is not OOS validation.
- Use `Start-LanTest.ps1 -Automated` with an explicit packaged map, client count, client log directory and completion regex. Current log adapter requires fresh `-P1.log` … `-P6.log` files, one completed player per requested client. Only use compatible static JASS slot metadata with `-UseScriptSlots`; the game path must match the launcher registry path. `-LegacySizeCap` applies to the installed legacy size-limit hook, not arbitrary Warcraft installations.
- Tests need an automatic entry, nonzero assertions and a unique completion marker in each client log. Confirm BJDebugMsg/Trace actually reaches that engine's log. A marker without exercised assertions is insufficient. A smoke observation is labelled SMOKE, never PASS.
- Host `desync detected` fails the run even without a disconnect. Client exits, missing logs/markers, runtime errors and deadlines fail. Preserve original host/client evidence and report coverage; starting/loading is not proof of successful tests.
- Cleanup is automatic in the launcher finally block. The manifest records each client PID and CIM creation ticks. `Stop-LanTest.ps1` calls the existing Codex-War3-StopTest task serially and stops only the owned host. Confirm cleanup.json and process exit. Never kill by wildcard/name or terminate an unrelated session.
- YDWE component-internal `-auto` is the only native input exception. No desktop capture/activation, SendKeys, pyautogui or Python/war3auto fallback. Manual launch leaves the game running; automated launch cleans up on success/failure. Installed task does not require an open admin terminal. Only task installation/updates require administrator input.

## Queue and ownership

- Start unattended runs with `-Automated -OwnerId <chat-or-task-id>` (defaults to CODEX_THREAD_ID, otherwise runner PID). `-QueueTimeoutSeconds` defaults to 3600; waiting is separate from the in-game timeout. Keep the runner alive while queued, and continue independent work when possible. Do not launch duplicate retries while the original waiter lives.
- Another agent's active test is awaited automatically. Manual/unknown games and orphaned game processes are preserved: wait for their normal exit. A queue deadline writes `queue/<ticket>.json` state `DEFERRED`; report runtime validation as deferred, not PASS or a gameplay FAIL, and do not ask the user to close Warcraft.
- The owning runner records ownerId, automatic/manual mode, queue ticket, runner PID and client PID/creation identities in session.json. It performs finally cleanup with the matching OwnerId. Never clean another task's session merely because it blocks the queue. Dead waiter tickets are skipped by PID/creation identity; that does not authorize killing orphaned clients.
- Cleanup requests use the existing scheduled-task channel and wait for its lock. If cleanup fails, report the cleanup evidence and preserve unrelated games. Queue status FINISHED means the runner released its reservation, not that assertions or cleanup passed; inspect result.json and cleanup.json.
- A request to run tests does not grant permission to end a manually started game. Do not use Start-ParallelProbe.ps1 as a queue bypass; use Start-LanTest.ps1.
