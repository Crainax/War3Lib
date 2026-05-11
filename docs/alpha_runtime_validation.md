# ALPHA Runtime Validation

Phase 14 only makes `vjassc` available for ALPHA validation. It does not make
`vjassc` the default compiler for release builds.

## Manual Checklist

After running `TaskStartMapVjasscAlpha.lua`, fill in
`Output/vjassc_runtime_checklist.md` and `Output/runtime_notes.md`.

```text
[ ] 地图能进入加载界面
[ ] 地图能加载完成进入游戏
[ ] 没有脚本初始化崩溃
[ ] main/config/init 执行正常
[ ] struct onInit 执行正常
[ ] library initializer 执行正常
[ ] function interface / lambda callback 没有明显异常
[ ] UI 初始化正常
[ ] 英雄选择/出生流程正常
[ ] 定时器/周期系统正常
[ ] DzAPI 本地替换/测试环境行为正常
[ ] YDHT / YDWE helper 相关逻辑正常
[ ] JAPI / InitTrig_japi 相关逻辑没有缺失
[ ] 存档/房间展示相关测试逻辑没有报错
[ ] 运行 5 分钟无明显异常
```

## Evidence To Keep

When runtime fails, keep these files before rerunning a compile:

```text
Output/4_luaexecute.j
Output/5_jasshelper.j
Output/5_vjassc.j
Output/output.j
Output/vjassc.validation.json
Output/vjassc.stats.json
Output/vjassc.stdout.txt
Output/vjassc.stderr.txt
Output/compiler_backend_report.json
Output/runtime_notes.md
```

## Expected Reading

`Output/compiler_backend_report.json` is structural, not byte-for-byte. Check:

```text
jasshelper.ok
vjassc.ok
vjassc.pjassOk
diff.hasMainBoth
diff.hasConfigBoth
diff.hasInitCustomTriggersBoth
war3libTimingMs
vjassc.timingMs
```

If `vjassc` fails in non-strict mode, ALPHA tasks can fall back to
`jasshelper`. Check `selectedOutput` before treating a launched map as a
`vjassc` runtime pass.
