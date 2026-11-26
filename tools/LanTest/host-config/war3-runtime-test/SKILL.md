---
name: war3-runtime-test
description: Warcraft III 游戏内单测、后台 LAN 与 OOS 验证，以及 UI 外观任务的实机截图、看图调整和复验。普通业务走日志断言；仅编译任务无需启动游戏。
---

# Warcraft runtime tests

Read `D:/War3/tools/LanTest/README.md` for the actual validated status and parameters before launch. The installed exact-build loader timing fix was tested with 1/2/6 clients. The original 300 ms `-auto` loop reproduced a wrong-menu failure (multiplayer load-save screen); the compatibility helper sets 3000 ms with a verified backup. After WE upgrades, revalidate the loader rather than patch unknown binaries. In-game timeouts must fail and clean up owned processes; admission timeouts are DEFERRED. Never silently switch to screenshot/click automation or claim success.

- Preserve unrelated changes. Select the intended test target and compile/package through the active checkout's workflow. Keep compile locks/worktree isolation. One game environment supports one session at a time; client count 1..6 is within that session. Automated runs enter the FIFO queue; do not bypass it or request that the user close a game to unblock a task.
- Human launcher defaults to single-player and does not remember LAN/count. For requested unattended runtime tests, explicitly choose LAN with one client, or at least two for synchronization coverage. A one-client LAN test is not OOS validation.
- Use `Start-LanTest.ps1 -Automated` with an explicit packaged map, client count and completion regex. It selects a free A/B environment or queues if both are busy. ClientLogDirectory defaults to the project log_directory in project.json or package.log_dir in script/init.lua, with War3Lib/日志 as fallback; relative paths or paths beneath the original game directory are remapped to that environment. Current log adapter requires fresh `-P1.log` … `-P6.log` files, one completed player per requested client. Only use compatible static JASS slot metadata with `-UseScriptSlots`. `-LegacySizeCap` applies to the installed legacy size-limit hook, not arbitrary Warcraft installations.
- Tests need an automatic entry, nonzero assertions and a unique completion marker in each client log. Confirm BJDebugMsg/Trace actually reaches that engine's log. A marker without exercised assertions is insufficient. A smoke observation is labelled SMOKE, never PASS.
- Host `desync detected` fails the run even without a disconnect. Client exits, missing logs/markers, runtime errors and deadlines fail. Preserve original host/client evidence and report coverage; starting/loading is not proof of successful tests.
- Cleanup is automatic in the launcher finally block. The manifest records each client PID and CIM creation ticks. Pool sessions use `pool/Stop-PoolTest.ps1`; legacy sessions use `Stop-LanTest.ps1`. Both delegate game termination to Codex-War3-StopTest and stop only the owned host. Confirm cleanup.json and process exit. Never kill by wildcard/name or terminate an unrelated session.
- YDWE component-internal `-auto` is the only native input exception. No desktop capture/activation, SendKeys, pyautogui or Python/war3auto fallback. Manual launch leaves the game running; automated launch cleans up on success/failure. Installed task does not require an open admin terminal. Only task installation/updates require administrator input.

## UI 实机视觉验收

按验收目标分配。涉及玩家实际看到的布局、贴图、文字、遮挡或状态外观时，主动跑视觉验收。数据、存档、同步、点击回调等纯行为改动沿用日志断言，即使代码位于 UI 目录。遵守用户限定的验证范围。

1. 给测试地图设置可重复的自动入口，调用真实组件显示目标页面或状态，固定影响外观的数据、尺寸和动画阶段。布局与资源稳定后向本局 P1 日志写入场景专属标记。已有入口和标记可直接复用。悬停样式可由测试夹具展示；真实鼠标命中行为须按实际覆盖范围报告。
2. 编译本轮地图，用 PowerShell 7 运行技能目录下的 `scripts/Start-VisualTest.ps1`，传 `-ProjectPath`、`-MapPath`、`-Scene` 和 `-ReadyPattern`。后者是就绪日志正则；若全部断言在之后完成，另传 `-CompletionPattern`。按地图实际需要传 `-UseScriptSlots`、`-LegacySizeCap` 或 `-ClientLogDirectory`。入口使用同一 A/B 分配队列和归属清理，在本次单客户端 OpenGL 交换帧前读取游戏后缓冲区。多人同步要求另走原有测试。
   视觉入口为本轮生成临时地图副本。对提供 Trace 的 JASS 地图，将已识别的单测断言和计时器屏显调用转到原客户端日志，保留玩家可见提示。核对日志中的断言及就绪标记，并打开图确认没有测试文字。其他运行时如有诊断遮挡，在对应测试输出入口实现视觉场次专用日志分流。
3. 用本地图片查看工具打开输出的 JPEG，核对目标状态确已出现，按任务要求检查视觉效果。找出具体问题后调整实现，重新构建，用相同的场景、状态和视口再跑一轮，打开新图对照。若首次已满足要求，记录看图结论即可。空白、错页、遮挡导致无法判断或缺图时，修正场景再取图；日志 PASS 单独记录。字号、描边等细节可在该会话的原帧 `render.ppm` 上按原像素裁切查看。
4. 默认报告目录为 `D:/War3/Reports/<项目目录名>/UI截图/<场景名>/`，每轮 JPEG 用唯一会话 ID 命名，自动控制在 500 KiB 以内。最终回复附实际截图链接、看图结论；有调整时给出修改前和复验图。核对该会话的 result.json、cleanup.json 和客户端退出。

## Queue and ownership

- Start unattended runs with `-Automated -OwnerId <chat-or-task-id>` (defaults to CODEX_THREAD_ID, otherwise runner PID). `-QueueTimeoutSeconds` defaults to 3600; waiting is separate from the in-game timeout. Keep the runner alive while queued, and continue independent work when possible. Do not launch duplicate retries while the original waiter lives.
- Another agent can use the other free environment. When both are occupied, wait automatically in `pool/queue`; explicit A/B requests join the same allocator. Manual/unknown/legacy games and orphaned game processes are preserved: wait for their normal exit. A queue deadline records `DEFERRED`; report runtime validation as deferred, not PASS or a gameplay FAIL, and do not ask the user to close Warcraft.
- The owning runner records ownerId, automatic/manual mode, queue ticket, runner PID and client PID/creation identities in session.json. It performs finally cleanup with the matching OwnerId. Never clean another task's session merely because it blocks the queue. Dead waiter tickets are skipped by PID/creation identity; that does not authorize killing orphaned clients.
- Cleanup requests use the existing scheduled-task channel and wait for its lock. If cleanup fails, report the cleanup evidence and preserve unrelated games. Queue status FINISHED means the runner released its reservation, not that assertions or cleanup passed; inspect result.json and cleanup.json.
- A request to run tests does not grant permission to end a manually started game. Do not use Start-ParallelProbe.ps1 as a queue bypass; use Start-LanTest.ps1.

## A/B environment pool

- Read `D:/War3/tools/LanTest/pool/README.md`. Default Start-LanTest automatic routing selects A/B; `-PoolEnvironment A|B` pins a requested environment. Windows PowerShell callers bridge to PowerShell 7 automatically. The direct `pool/Start-PoolTest.ps1 -Environment Auto|A|B -OwnerId <task-id> -MapPath <map> -CompletionPattern <regex>` is always automated and uses the same allocator; it does not take an `-Automated` switch. Same-environment sessions serialize, different environments may overlap.
- The installed A/B paths, registry roots and ports are fixed. Do not rebuild, prepare or replace pool binaries while occupied. Pass ProjectPath when the map needs project CloudScripts: each session receives a physical snapshot and a fresh copy of that project's local INI baseline. Test writes never propagate back to the human game or checkout. Cross-session persistence must use deliberate fixtures, not whichever pool happened to be free. Omitting ProjectPath uses an empty cloud entry and copies the current local INI baseline.
- On 2026-11-16, two simultaneous two-client rooms passed automatic joining, per-client assertions, private Save files, and independent cleanup. A cleanup left B advancing, and a foreign OwnerId was refused. Evidence is linked from the pool README. No simultaneous human game was present; do not describe that coexistence as validated. Preserve manual/unknown games, honor queue deferral, and never expand cleanup beyond owned identities.
- The default-entry three-task acceptance also passed: two tasks selected A/B, the third waited then reused A after cleanup while B continued. All six clients completed assertions and ownership cleanup; the Windows PowerShell bridge and unchanged human configuration hashes were verified. Use the result/timeline linked in the pool README, not process startup, as evidence.
- Pool cleanup uses `pool/Stop-PoolTest.ps1` with the matching OwnerId and the existing scheduled task. Inspect each session's result.json and cleanup.json. Native input remains limited to YDWE internal `-auto`; the pool grants no desktop-control exception.

Read result.json logs for the final project log paths. Pool sessions monitor private client logs until owned cleanup, then publish them under the normal game project log directory. Failed runs include host diagnostics under LanTest故障/<session>. Preserve the private originals when publication or cleanup fails.
