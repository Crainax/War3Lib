param([string]$OutputDirectory='D:/War3/tools/LanTest/pool/bin')
$ErrorActionPreference='Stop'
$null=New-Item -ItemType Directory -Force $OutputDirectory
$out=(Resolve-Path $OutputDirectory).Path
$source=Join-Path $PSScriptRoot 'native'
$batch=Join-Path $out 'build.cmd'
@"
@echo off
call "C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/VC/Auxiliary/Build/vcvars32.bat" >nul
if errorlevel 1 exit /b 1
cl /nologo /LD /MT /O2 /EHsc "$source/pool_context.cpp" /Fo"$out/context.obj" /link /OUT:"$out/pool_context.dll" /IMPLIB:"$out/context.lib"
if errorlevel 1 exit /b 1
cl /nologo /MT /O2 /EHsc "$source/pool_spawn.cpp" /Fo"$out/spawn.obj" /link /OUT:"$out/pool_spawn.exe"
if errorlevel 1 exit /b 1
cl /nologo /MT /O2 /EHsc "$source/pool_probe.cpp" /Fo"$out/probe.obj" /link /OUT:"$out/pool_probe.exe"
"@ | Set-Content $batch -Encoding ascii
& cmd.exe /c $batch
if($LASTEXITCODE -ne 0){throw 'Pool native build failed'}
