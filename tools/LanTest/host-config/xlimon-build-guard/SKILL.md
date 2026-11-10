---
name: xlimon-build-guard
description: Enforce post-edit compile discipline for Xlimon and War3Lib work. Use when editing JASS/Zinc/config in D:/War3/Maps/Xlimon or D:/War3/Library/War3Lib; default Xlimon validation is VERSION_ALPHA vjassc, Xlimon VERSION_UNITTEST runs only on explicit request or _Test.j edits, and War3Lib validation remains VERSION_UNITTEST because War3Lib is validated through unit tests.
---

# Xlimon / War3Lib Build Guard

## Core Rule

Run compile after every code edit batch.
Do not finish with uncompiled changes unless the user explicitly asks to skip compile.

## Scope and Mode Policy

- Xlimon source scope: `D:/War3/Maps/Xlimon`.
- War3Lib source scope: `D:/War3/Library/War3Lib`.
- Mode routing source of truth: `config/rewave.h` in the active checkout. Main-repository paths in this skill identify the project, not a required working directory.
- `CURRENT_BUILD_VERSION VERSION_ALPHA` routes to `edit/config/Main.h` through `edit/AllJass.h`.
- `CURRENT_BUILD_VERSION VERSION_UNITTEST` routes to `edit/config/UnitTest.h` through `edit/AllJass.h`.

Default by change scope:

1. Routine Xlimon-only edits: compile `VERSION_ALPHA` only.
2. Xlimon unit-test validation is opt-in except when changed files include `_Test.j` content.
3. Routine War3Lib-only edits: force `VERSION_UNITTEST` for validation because War3Lib has only the unit-test validation path.
4. Cross-repo edits (Xlimon + War3Lib): validate Xlimon in `VERSION_ALPHA`; validate War3Lib in `VERSION_UNITTEST`. Do not add an Xlimon `VERSION_UNITTEST` pass unless the user asks or changed Xlimon files include `_Test.j`.
5. Xlimon routing-file edits: compile `VERSION_ALPHA` only by default unless the user asks for matrix validation or changed files include `_Test.j`.

Run Xlimon `VERSION_UNITTEST` only when one of these is true:

- The user explicitly asks to run unit tests, unit-test mode, or `VERSION_UNITTEST`.
- The changed Xlimon file set includes one or more files whose names end with `_Test.j`.

When `_Test.j` was changed, treat the touched `_Test.j` file as the intended unit-test target unless the user names a different target.

## Build Mode Facts

- `edit/AllJass.h` is the routing gate for mode-specific include trees.
- War3Lib unit-test target file is `Jass/config/UnitTest.h` in its active checkout.
- The compile task does not guarantee auto-switching the test include target in `UnitTest.h`; switch it manually before any `VERSION_UNITTEST` compile.
- Never leave `config/rewave.h` in temporary mode after validation.

## Compiler Backend Policy

- Use `vjassc` for routine task validation.
- Treat the `vjassc` result as the source of truth for pass/fail.
- Do not use `both` or `jasshelper` as the default validation backend.
- If backend behavior is relevant to the task, verify the live `Lua/compile/Compiler.lua` and `Lua/tasks/TaskCompile.lua` control flow before relying on memory.

## Compile Command

Resolve the active checkout with `git rev-parse --show-toplevel`. Paths below are relative to that checkout, not necessarily the main checkout at `D:/War3/Maps/Xlimon`.

From an Xlimon checkout:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ./script/agent_compile.ps1
```

This defaults to ALPHA + vjassc. Add `-RequireWorktree` for parallel tasks; it rejects the main checkout. Use `-Mode UNITTEST`, `BETA`, or `RELEASE` only when the task requires that mode. The wrapper restores `config/rewave.h` byte-for-byte after normal success/failure and holds an exclusive per-checkout compilation lock. Do not manually switch the mode before calling it. Select and restore the intended UnitTest.h include separately when needed.

Success requires exit code 0, `[vjassc]编译成功`, and `[最终输出]成功`. A forced process termination may prevent finally cleanup; inspect the route before retrying. Do not run manual compile tasks concurrently in the same checkout: they do not participate in the wrapper lock.

For War3Lib validation, invoke the same Xlimon wrapper by its resolved absolute path with `-ProjectPath <active-War3Lib-checkout> -Mode UNITTEST`. Shared-library work must run separately from parallel Xlimon builds unless its dependencies and tools are isolated. The current compiler resolves War3Lib from `War3RootPath/Library/War3Lib`; changing a VS Code path alone does not isolate that dependency.

`--agent-validation` is passed to TaskCompile by the wrapper. It preserves Mock generation but skips shared game INI and WorldEdit registry writes, forces the vjassc validation backend, and keeps incremental caches local. Manual compilation/launch behavior remains unchanged when that flag is absent.

Parallel agents use separate linked worktrees, each with its own config, Output, generated headers, and dependency mirror. They must keep shared War3Lib/tool installations read-only. Run multiple build modes sequentially per worktree. Packaging and game launch remain outside default compile-only validation. When the user requests runtime tests, use the war3-runtime-test skill for LAN execution, evidence and cleanup; do not hand off routine process termination to the user.

## Standard Workflow

1. Read current mode from `config/rewave.h`.
2. Implement code changes.
3. Select validation mode using the scope policy above.
4. For Xlimon, run the current checkout wrapper with its default ALPHA mode.
5. For War3Lib, select the intended active-checkout test include and invoke the wrapper with `-Mode UNITTEST` and the explicit project path.
6. If Xlimon unit-test validation is triggered, select the intended `_Test.j` in `edit/config/UnitTest.h` and invoke the wrapper with `-Mode UNITTEST`.
7. If compile fails, fix and repeat until pass.
8. Restore any temporary mode/include changes unless they are part of the requested edit.
9. Report mode + compile status.

## Routing-Sensitive Edits

Changed files in this set affect include routing:

- `D:/War3/Maps/Xlimon/edit/AllJass.h`
- `D:/War3/Maps/Xlimon/config/rewave.h`
- `D:/War3/Maps/Xlimon/edit/config/UnitTest.h`
- `D:/War3/Maps/Xlimon/edit/config/Main.h`

Default behavior:

- For Xlimon routing-sensitive edits, compile `VERSION_ALPHA` only.
- Do not run an automatic Xlimon `ALPHA` + `UNITTEST` matrix unless the user explicitly asks for matrix validation or changed Xlimon files include `_Test.j`.
- If temporary mode edits are needed for validation, save and restore the original `CURRENT_BUILD_VERSION`.

If the user explicitly asks for matrix validation, run each requested mode sequentially through the wrapper. Do not infer an extra UNITTEST pass from an ALPHA/BETA/RELEASE request. Restore temporary test includes; the wrapper restores the mode after each invocation. No extra restored-mode compile is required.

## Unit-Test Specific Checks

Before any `VERSION_UNITTEST` compile:

1. Verify `edit/config/UnitTest.h` includes the intended `_Test.j`.
2. If the compile was triggered by a changed `_Test.j`, switch `edit/config/UnitTest.h` to that touched test file before compiling.
3. Compile after switching the unit-test include.
4. Report which test target was set in `edit/config/UnitTest.h`.

## War3Lib Unit-Test Target Switching

When validating War3Lib unit tests:

1. Open `Jass/config/UnitTest.h` in the active War3Lib checkout.
2. Manually point it to the intended test file before compile.
3. If you switch the target test file, recompile immediately after each switch.
4. Report which test target was set in `War3Lib/Jass/config/UnitTest.h`.

## Reporting Template

- `Build mode: VERSION_ALPHA|VERSION_UNITTEST|...`
- `Compile: PASS|FAIL`
- `Compiler backend: vjassc`
- `If FAIL: first error file/line + fix status`
- `If matrix run: ALPHA PASS/FAIL, UNITTEST PASS/FAIL, RESTORE: done (no recompile)`
