param([string]$OutputDirectory=(Join-Path $PSScriptRoot '../bin'), [string]$VcVars='C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/VC/Auxiliary/Build/vcvars32.bat')
$ErrorActionPreference='Stop'
$null=New-Item -ItemType Directory -Force $OutputDirectory
$output=(Resolve-Path $OutputDirectory).Path
$source=Join-Path $PSScriptRoot 'player_name.cpp'
$batch=Join-Path $output 'build-name.cmd'
@"
@echo off
call "$VcVars" >nul
if errorlevel 1 exit /b 1
cl /nologo /LD /MT /O2 /EHsc "$source" /Fo"$output/player_name.obj" /link advapi32.lib /OUT:"$output/lan_player_name.dll" /IMPLIB:"$output/player_name.lib"
"@ | Set-Content $batch -Encoding ascii
& cmd.exe /c $batch
if ($LASTEXITCODE -ne 0) { throw 'Native name plugin build failed' }
