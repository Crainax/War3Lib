# LAN test runner

## Current validation

2026-11-10: integrated shared launcher and verified single/two-client smoke sessions, plus a six-client in-game assertion run. Six-client evidence: `sessions/20261110-214752-fbc560/result.json` (PASS; six fresh P1..P6 logs) and `cleanup.json`. Assertions in the disposable Runtime-Six map check six playing human slots and timer execution, not business correctness of Xlimon/LH. Source maps and active test selection remain unchanged. Automatic timeout cleanup was also exercised twice when joining failed.

The installed KKWE yd_loader auto-enter loop repeated its L shortcut every 300 ms and entered the multiplayer load-save menu. A controlled 3000 ms delay succeeded for 1, 2 and 6 clients. `Set-AutoJoinDelay.ps1` installs this exact-build compatibility adjustment and `-Restore` restores the original. It refuses unknown bytes/hash and running game sessions. Original backup: `probes/yd_loader-before-delay.dll`; original SHA256 `0F7368DC7367ECB0CBC98468A9F04C5BE92C5778FF56535F3794D1F32A5AA16A`; patched SHA256 `552518BDB908DA90E6C22A2E8F0ACAA14697F620DD8046C600B57F5578D94871`. This modifies only the installed loader's timing, not external keyboard control. After a WE update, revalidate instead of applying offsets to another binary.

OOS failure control also passed: `sessions/20261110-215012-eef794/result.json` reports FAIL with `OOS detected by ydhost`, and cleanup.json reports success. This was deliberately induced in a disposable map; expected nonzero exit is a successful detector test. Parser regressions cover completion, OOS, failed assertions, zero assertions and timeout. War3Lib current InstantAttackFacing UNITTEST compiled with vjassc; Xlimon/LH business gameplay and 11-platform online behavior were not tested by this harness.

## Launch

Shared War3Lib TaskLaunch supports inline selection `network=single|lan,players=1..6` with the existing selection syntax. The GUI always initializes single-player/1; neither is saved to history. Xlimon/LH multiplayer shortcuts now use the shared chooser instead of Python desktop automation. Manual launches leave clients running.

```powershell
& D:/War3/tools/LanTest/Start-LanTest.ps1 -MapPath 'D:/path/test.w3x' -Clients 2 -LegacySizeCap -UseScriptSlots -Automated -ClientLogDirectory 'D:/game/War3Lib/logs' -CompletionPattern '\[UT_DONE\]' -TimeoutSeconds 120
```

Completion logs must be fresh and uniquely identify players with `-P1.log` etc. Each requested player must finish. FAIL:/[UT_FAIL]/desync messages fail the run; tests must actually write assertions to these logs. `-SmokeSeconds 10` replaces assertion completion only for a clearly labelled SMOKE run, observing from host loading, not proving full map initialization.

`-PrepareOnly` writes configuration without launch. Human slots must cover Clients. The Lua adapter rejects unsupported conditional slot setup. LegacySizeCap and UseScriptSlots are compatibility options, not universal defaults for other engines. Only installed Warcraft 1.27 is validated.

## Session and cleanup

Sessions are under `sessions/<timestamp-id>`, with source hash, host/client identities, host logs, result.json and cleanup.json. Start-LanTest holds an exclusive lock through automatic testing and cleanup. Existing unknown games/hosts are refused. Player-name changes remain serialized through host acknowledgement to avoid the shared EverConfig/userlocal race; fixed per-client 3-second sleep was removed. This is not full parallel process launch.

To stop a manually launched owned session:

```powershell
& D:/War3/tools/LanTest/Stop-LanTest.ps1 -SessionPath 'D:/War3/tools/LanTest/sessions/SESSION'
```

The stop helper uses `C:/Users/41399/.codex/tools/war3-test-control/Stop-Test.ps1`, which invokes Codex-War3-StopTest. Do not add `-WindowStyle Hidden` to that scheduled PowerShell action: it returned -1 before script execution on this machine. Keep host executable at the fixed bin/ydhost.exe path to preserve firewall identity.
