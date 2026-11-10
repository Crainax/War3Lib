# Local deployment

These are versioned sources for the installed runner at `D:/War3/tools/LanTest`. Copy the .ps1 files and map_config.lua there after review; keep its sessions, bin and original DLL backup intact. The launcher uses War3RootPath/tools/LanTest. No binary, map, session logs or DLL backups are committed.

Machine prerequisites: installed KKWE/YDWE runtime, tested loader timing patch and Codex-War3-StopTest scheduled task. See README.md for validated scope and rollback. The task installer and worker sources are in host-config/war3-test-control; installation still requires an administrator. Host rules/skills in host-config are snapshots to merge, not wholesale replacements of another machine configuration.
