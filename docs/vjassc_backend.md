# vjassc Backend

War3Lib still uses `jasshelper` by default. `vjassc` is opt-in and only affects
the final JASS compiler step after Wave, InjectCodeBlock, Lua traversal, and
LocalDzApi map config replacement have already produced `Output/4_luaexecute.j`.

## Backends

Use `WAR3_JASS_COMPILER` or a dedicated task script:

```text
jasshelper  default; writes Output/5_jasshelper.j and selects it
vjassc      writes Output/5_vjassc.j and selects it only in ALPHA
both        writes both outputs; selects jasshelper unless explicitly changed
```

`vjassc` output is allowed to become `Output/output.j` only when
`path.buildVersion == "内测版本"` or `WAR3_ALLOW_VJASSC_NON_ALPHA=1`.
If this guard is not satisfied, non-strict mode falls back to `jasshelper`;
strict mode fails the compile.

## Environment

```text
WAR3_JASS_COMPILER=jasshelper|vjassc|both
WAR3_JASS_COMPILER_SELECT=jasshelper|vjassc
WAR3_VJASSC_EXE=D:/War3/plugins/vjassc/vjassc.exe
WAR3_VJASSC_VALIDATE=0|1
WAR3_VJASSC_STRICT=0|1
WAR3_ALLOW_VJASSC_NON_ALPHA=0|1
```

Defaults:

```text
WAR3_JASS_COMPILER=jasshelper
WAR3_JASS_COMPILER_SELECT=jasshelper
WAR3_VJASSC_VALIDATE=1
WAR3_VJASSC_STRICT=0
```

## Outputs

```text
Output/5_jasshelper.j
Output/5_vjassc.j
Output/output.j
Output/vjassc.stats.json
Output/vjassc.validation.json
Output/vjassc.stdout.txt
Output/vjassc.stderr.txt
Output/compiler_backend_report.json
Output/vjassc_runtime_checklist.md
Output/runtime_notes.md
```

`InitTrig_japi` is passed to PJASS as a validation-only external through
`--pjass-allow-external InitTrig_japi`. It is not written into
`Output/5_vjassc.j` or `Output/output.j`.

## Commands

Compile ALPHA with vjassc selected:

```bat
lua lua/tasks/TaskCompileAlphaWithVjassc.lua D:/War3 D:/War3/Maps/Xlimon D:/WE/KKWE_Plugin "D:/Program Files (x86)/Warcraft III Frozen Throne"
```

Compile ALPHA in compare mode, selecting jasshelper:

```bat
lua lua/tasks/TaskCompileCompareAlpha.lua D:/War3 D:/War3/Maps/Xlimon D:/WE/KKWE_Plugin "D:/Program Files (x86)/Warcraft III Frozen Throne"
```

Start ALPHA with vjassc selected:

```bat
lua lua/tasks/TaskStartMapVjasscAlpha.lua D:/War3 D:/War3/Maps/Xlimon D:/WE/KKWE_Plugin "D:/Program Files (x86)/Warcraft III Frozen Throne"
```

Start ALPHA in compare mode:

```bat
lua lua/tasks/TaskStartMapCompareAlpha.lua D:/War3 D:/War3/Maps/Xlimon D:/WE/KKWE_Plugin "D:/Program Files (x86)/Warcraft III Frozen Throne"
```
