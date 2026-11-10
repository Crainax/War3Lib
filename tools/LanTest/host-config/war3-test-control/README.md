# Warcraft test process control

Task: `\Codex-War3-StopTest`. On demand only, current user's interactive logon, highest privileges. No recurring trigger and no password stored.

Status (2026-11-10): installed and end-to-end validated. From an unelevated agent shell (`Elevated=False`), launched `YDWEConfig.exe -launchwar3`, recorded the new game PID 15636 and CIM creation ticks 639299089146675170, then invoked Stop-Test.ps1. Elevated task returned success and the client independently confirmed that instance exited. No manual close was needed. This validates process cleanup, not in-game unit-test assertions.

Resolved startup issue: initial task returned -1 before worker execution. Controlled temporary Task Scheduler tests isolated `-WindowStyle Hidden`: same short PowerShell payload succeeded without this flag (exit 0), failed with it (exit -1). Installer omits the flag and performs a non-game rejection self-test. Diagnostic tasks were removed. Syntax, non-game rejection and expired-request checks passed.

## Install once

Run in an elevated Windows PowerShell as the original user (SID ending 1001):

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Users\41399\.codex\tools\war3-test-control\Install.ps1"
```

The installer embeds the worker code in the task definition. Editing Stop-TestWorker.ps1 later has no effect until the administrator reruns installation. Task owner is Administrators; SYSTEM and elevated Administrators have full access, original user's unelevated token has read/execute access only. No app, UAC or WindowsApps permission changes.

## Use from an ordinary agent shell

Record the real game process ID and CIM CreationDate immediately after launching the test. Do not select all game processes or substitute an unrelated existing instance. Store these values with that test's run record:

```powershell
$game = Get-CimInstance Win32_Process -Filter 'ProcessId = ACTUAL_TEST_PID'
$testProcessId = [int]$game.ProcessId
$testCreationUtcTicks = $game.CreationDate.ToUniversalTime().Ticks
```

After the test completion log has been flushed, or on an authorized timeout cleanup:

```powershell
& 'C:\Users\41399\.codex\tools\war3-test-control\Stop-Test.ps1' -TestProcessId $testProcessId -CreationUtcTicks $testCreationUtcTicks
```

The elevated worker validates fixed executable path `D:\Program Files (x86)\Warcraft III Frozen Throne\war3.exe`, original user SID, session, PID, creation time and request freshness (60 seconds). It terminates only that instance, without a process-tree kill. Client waits up to 30 seconds and independently verifies exit. Request/result JSON lives in `%LOCALAPPDATA%\CodexWar3TestControl`. Requests are untrusted data, never executable code. Forced termination is not proof of a passed test.

## Check / remove

Inspect via Task Scheduler COM or `Get-ScheduledTask -TaskName Codex-War3-StopTest`. To remove, use an administrator PowerShell:

```powershell
Unregister-ScheduledTask -TaskName 'Codex-War3-StopTest' -Confirm:$false
```

`Verify-Scripts.ps1` checks Windows PowerShell syntax and rejection of a real non-game PID and an expired request. It never launches Warcraft or installs the task.
