param([string]$LLVM='C:/Program Files/LLVM/bin')
$ErrorActionPreference='Stop'
Set-Location (Resolve-Path (Join-Path $PSScriptRoot '../..'))
New-Item -ItemType Directory -Path 'Output/font-style' -Force | Out-Null
& "$LLVM/clang.exe" -target i386-unknown-linux-gnu -O2 -ffreestanding -fno-builtin -fPIC -fvisibility=hidden -fno-stack-protector -mstackrealign -c research/innerjapi-font-outline-core/cache_core.c -o Output/font-style/outline-cache-core.o
if($LASTEXITCODE){throw 'Cache core compile failed'}
& "$LLVM/ld.lld.exe" -m elf_i386 -shared -Bsymbolic --no-undefined -o Output/font-style/outline-cache-core.elf Output/font-style/outline-cache-core.o
if($LASTEXITCODE){throw 'Cache core link failed'}
& python research/innerjapi-font-outline-core/extract.py --input Output/font-style/outline-cache-core.elf --output script/experiments/innerjapi/font_outline_cache_bytes.lua --manifest Output/font-style/outline-cache-core.json
if($LASTEXITCODE){throw 'Cache extraction failed'}
