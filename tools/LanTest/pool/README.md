# Automatic A/B test pool

`Start-LanTest.ps1 -Automated` automatically chooses a free environment; if both
are occupied it queues. `-PoolEnvironment A|B` pins an environment. Manual and
PrepareOnly calls retain the original entry behavior. Windows PowerShell callers
are bridged to PowerShell 7 through a serialized request, without shell string
interpolation. The direct pool entry accepts `-Environment Auto|A|B`.
The pool uses fixed directories `D:/War3/tools/LanTest/pool/A` and `B`.

Maps are frozen in `pool/snapshots/<id>` before queue admission. Overwriting the
original build while waiting cannot change that task's map. After successful
owned-process cleanup, the per-game map and frozen copy are deleted; logs and
results remain. Admission timeout also removes the frozen copy. Cleanup failure
or changed map identity preserves the diagnostic files. `map-cleanup.json`
records deletion of the owned game map. Runtime adapters use the original project
map path and must keep their project build lease; its hash is checked against the
snapshot before Prepare.

Project-specific bootstrap adapters may use the direct pool entry's
`-RuntimeAdapter <ps1> -AdapterOptions <hashtable>`. The runner calls `Prepare`
after allocation, `Ready` after client discovery, and `Finalize` after owned
cleanup, before releasing the lease. Each call receives the actual private
GamePath and SessionPath. An adapter must restore its own temporary files and
must never clean another session or mutate the human game directory. LHLua uses
this for immutable source snapshots, digest acknowledgements and j2b restoration.

Ordinary automated sessions select Direct3D 8 in the assigned pool's private WE configuration. The visual capture entry explicitly selects OpenGL. The session manifest records the choice under projectConfiguration.renderer. Each admitted session sets its own renderer before launch. This avoids the observed OpenGL startup path through MSCTF on ordinary runs. Frame capture still exercises that path and checks owned client dumps while waiting for a frame.

## Isolation

- Physical copies of game binaries/MPQs and WE, with private Maps, Save, Replay,
  logs, cloud entry, TEMP and user application-data directories. No links to the
  human game's mutable files. With ProjectPath, CloudScripts is physically copied
  to the session and private WE points at that snapshot. Project INI seeds are
  read under the human profile lock and copied to the pool before each test.
  Test writes are never copied back. Without ProjectPath, cloud entry is empty
  and INIs use a copy of the current local profile. Tests requiring cross-session
  archive persistence must explicitly manage fixtures; random A/B selection must
  not implicitly select a previous task's data.
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
- One pool FIFO allocator reserves either environment's exclusive lease. An older
  compatible waiter has priority; a waiter pinned to busy A does not block free B.
  A shared legacy guard prevents old/manual CLI launches racing pool admission.
  Queue JSON updates use atomic replacement so readers cannot miss a waiter.
  PID/creation/path identity plus OwnerId
  control cleanup; game termination still uses Codex-War3-StopTest. Its worker must
  explicitly allow the two fixed pool game paths. Launch fails before creating a
  game if the installed task does not contain the required path.

## Build and diagnostic commands

Run with PowerShell 7 (ProcessStartInfo.ArgumentList is used):

```powershell
& ./Prepare-Pool.ps1
& ./Build-Pool.ps1
& ./Verify-PoolIsolation.ps1
& ./Verify-PoolQueue.ps1
& ./Verify-PoolConfiguration.ps1
& ../Start-LanTest.ps1 -Automated -OwnerId task-A -MapPath D:/path/test.w3x -Clients 2 -ProjectPath D:/War3/Library/War3Lib -CompletionPattern '\[UT_DONE\]' -LegacySizeCap -UseScriptSlots
```

Prepare refuses an occupied environment and holds its lock; never rebuild/replace
pool binaries while pool clients are running. Do not use Prepare as a recovery or
cleanup tool. Default/manual game processes and other agents' sessions are not
cleanup candidates. Host-only verification takes the existing global queue as an
extra precaution during development.

`Verify-PoolIsolation.ps1`, `Verify-PoolQueue.ps1`, `Verify-PoolConfiguration.ps1`
and the native probe are retained as repeatable
regression checks. Machine-specific host/gameplay acceptance scripts are local
diagnostics under the installed pool's `diagnostics/` directory, not source
dependencies. Generated maps, save probes and session logs are not committed.

ClientLogDirectory defaults to `War3Lib/日志` in the assigned game directory.
Relative paths and paths under the original game directory are remapped into the
selected game; unrelated absolute paths and escaping `..` paths are refused.
Custom game/WE paths or profile scripts are not silently ignored: use separately
prepared/validated environments for those. ExpectMapExit is forwarded only when
the installed waiter supports it; otherwise the request fails before launch.
The current waiter does not support that option.

New queue tickets are under `pool/queue`; sessions remain under
`pool/A/sessions` and `pool/B/sessions`. A queue deadline is DEFERRED. FINISHED
only means reservation release; inspect result.json and cleanup.json as before.
Manual/unknown/legacy games block automatic allocation and are never terminated.

## Validation status 2026-11-16

Default-entry pool allocation passed with three independent tasks:
`default-pool-20261116-023619-53e9c4/result.json` and `timeline.jsonl`.
Tasks One/Two automatically selected A/B. Three waited about 46 seconds while
both were reserved, then acquired A about half a second after One's cleanup.
Two remained live while Three ran. All three sessions passed fresh assertions
on both clients and successful cleanup; no owned game/host remained. Three used
Windows PowerShell's automatic PowerShell 7 bridge. Original human game INIs and
WE config hashes were unchanged; cloud sources and log paths were private.
Synthetic regressions also cover FIFO ordering, both-busy wait, legacy lock
exclusion, stale identities, occupancy deferral, profile reset and log-path escape.

Early acceptance collectors failed on a missing initial queue directory and a
non-atomic ticket replacement gap. The first was diagnostic-only; the allocator
now uses same-volume atomic replacement. The complete run above passed after
that fix. Raw-offset loader-state debug reads were removed from the runtime DLL.

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
