# Independent A/B pool (opt-in)

The existing default launcher and its global queue remain unchanged. The pool is
an explicit opt-in; automatic environment selection is not implemented.
The pool uses fixed directories `D:/War3/tools/LanTest/pool/A` and `B`.

## Isolation

- Physical copies of game binaries/MPQs and WE, with private Maps, Save, Replay,
  logs, cloud entry, TEMP and user application-data directories. No links to the
  human game's mutable files. Project cloud handlers are not automatically shared.
- A private registry subtree per environment. A bootstrap DLL redirects Warcraft
  HKCU/HKLM opens in the launcher/game imports to that subtree. Other Windows
  registry keys remain available. Whole-HKCU redirection was removed during
  diagnostics; the prototype does not claim complete process sandboxing.
- The bootstrap refuses a YDWE child game path outside that environment. Its
  CreateProcess hook propagates registry isolation to the owned child before entry.
- A UDP/TCP pair per environment: A 16112/16113; B 16212/16213. Host advertisement
  ports are rewritten, clients bind the private discovery port, foreign room-name
  advertisements are discarded, and foreign TCP room ports are refused.
- The installed YDWE `-auto` remains responsible for entering the room. No desktop
  enumeration, input automation, screenshots or window manipulation is added.
- Each environment has its own FIFO lease. PID/creation/path identity plus OwnerId
  control cleanup; game termination still uses Codex-War3-StopTest. Its worker must
  explicitly allow the two fixed pool game paths. Launch fails before creating a
  game if the installed task does not contain the required path.

## Build and diagnostic commands

Run with PowerShell 7 (ProcessStartInfo.ArgumentList is used):

```powershell
& ./Prepare-Pool.ps1
& ./Build-Pool.ps1
& ./Verify-PoolIsolation.ps1
& ./Start-PoolTest.ps1 -Environment A -OwnerId task-A -MapPath D:/War3/tools/LanTest/probes/parallel/Runtime-Two.w3x -LegacySizeCap -UseScriptSlots
```

Prepare refuses an occupied environment and holds its lock; never rebuild/replace
pool binaries while pool clients are running. Do not use Prepare as a recovery or
cleanup tool. Default/manual game processes and other agents' sessions are not
cleanup candidates. Host-only verification takes the existing global queue as an
extra precaution during development.

`Verify-PoolIsolation.ps1` and the native probe are retained as repeatable
regression checks. Machine-specific host/gameplay acceptance scripts are local
diagnostics under the installed pool's `diagnostics/` directory, not source
dependencies. Generated maps, save probes and session logs are not committed.

## Validation status 2026-11-16

Passed native x86 build, private registry read/write tests, Warcraft HKLM routing,
system Winsock availability, distinct UDP binds, wrong-room rejection and target
room acceptance. Evidence: `pool/isolation-probes.json` in the installed tools.

Two real ydhost processes ran concurrently and advertised the expected room names
and TCP ports on their respective UDP ports. Both owned hosts were cleaned up.
Evidence: `pool/host-probe-20261116-002439/result.json`.

The pool-ab-v1 cleanup task was installed and read back successfully. A clients
were started from A/Game/war3.exe; process-internal logs confirm A/Game/Game.dll,
A/Game/Storm.dll and A/WE/plugin/warcraft3/yd_loader.dll, with -auto and the private
KKWE path. Exact path/time-checked scheduled cleanup succeeded for both clients.
An early discovery bug missed protected clients whose WMI ExecutablePath is null;
it was fixed, and those same owned children were recorded from parent/time plus
bootstrap provenance and cleaned. Startup DLL injection now chains ahead of YDWE's
suspended-thread loader instead of prematurely initializing the child remotely.

The startup blocker was a sound-device warning: the private game copy omitted
the Miles audio providers in `redist`. Prepare now includes that directory.
After copying it, A and B each passed a two-client automatic-entry/gameplay test:
`A/sessions/20261116-020831-A-52cac5` and
`B/sessions/20261116-020938-B-b77012`. Each has fresh per-player logs, completion
markers, nonzero player-count/name assertions, PASS result.json and successful
cleanup.json. These were sequential tests, not proof of concurrent gameplay.

Verify-PoolGameplay creates disposable map copies with different completion
times. It checks four clients alive together, private per-player save files,
both B heartbeats advancing after A cleanup, and both owners' final results.
It takes the legacy queue as an extra development guard and defers when an
unrelated game is running.

Concurrent gameplay acceptance passed on 2026-11-16:
`pool-probe-20261116-021636-19a4a2/result.json`. A
(`20261116-021637-A-3611cb`) and B (`20261116-021637-B-a8e786`) automatically
joined their own rooms with two clients each. All four fresh logs passed
player-count/name/save assertions and their environment-specific completion marker.
Four clients overlapped; each environment wrote only its own two probe files.
A cleanup completed at 02:17:26 +08:00 while both B clients continued heartbeats;
B completed and cleaned up at 02:18:15 +08:00. No owned game or host remained.
The adjacent `foreign-owner-refusal.json` records an A-owner cleanup attempt
against B being rejected while both B clients remained alive.

This validates the test harness on the installed engine, not the unrelated
business tests embedded in its base fixture, all project cloud handlers, or
coexistence with a simultaneously running manual game. That last scenario was
not exercised. Unknown games still cause conservative waiting. Per-environment
FIFO queues and matching OwnerId cleanup remain required; never bypass them.

## Firewall prompts

Hosts and games use fixed executable paths in A and B. Each distinct path can
require its own initial Windows Firewall authorization. During an unanswered
prompt, discovery/joining can time out; game process existence is insufficient.
Read-only inspection on 2026-11-16 found enabled public-profile TCP and UDP allow
rules for both pool hosts and games, matching the current network category.
This is stored-rule evidence, not a guarantee about all effective policy. If a
prompt repeats, record its exact application path and selected network profile.
Do not disable Windows Firewall or add broad all-program rules.

## Source basis

Reviewed upstream YDWE registry path resolution, loader auto-enter and UDP hooks:
https://github.com/actboy168/YDWE/tree/master/Development/Plugin/Warcraft3/yd_loader
https://github.com/actboy168/YDWE/blob/master/Development/Core/ydwar3/warcraft3/directory.cpp
Installed KKWE binaries are a distinct build; upstream behavior is a starting point,
not proof of their runtime behavior. Runtime evidence is required for each gate.
