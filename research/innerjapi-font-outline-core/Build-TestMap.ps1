param([string]$OutputName='UITextFontInnerStyle-clean.w3x')
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
Set-Location $root
if ($OutputName -notmatch '^[\w.-]+\.w3x$') { throw 'Use a plain .w3x filename' }
if ((Get-Content 'Jass/config/UnitTest.h' -Raw) -notmatch 'UITextFontInnerStyle_Test.j') { throw 'Select UITextFontInnerStyle_Test.j first' }
$slot=Join-Path $root 'Output/launcher/engines/innerjapi-1.49-9/tests/current-056643a2/UnitTestMap_slk.w3x'
$saved=if(Test-Path -LiteralPath $slot){[IO.File]::ReadAllBytes($slot)}else{$null}
New-Item -ItemType Directory -Path 'Output/font-style','UnitTestMap/map/ui' -Force | Out-Null
foreach($name in @('UITextFontInnerStyle.fdf','UITextFontInnerStyle.toc')) {
    Copy-Item -LiteralPath "Jass/ui/components/text/$name" -Destination "UnitTestMap/map/ui/$name" -Force
}
try {
    & powershell -NoProfile -ExecutionPolicy Bypass -File D:/War3/Maps/Xlimon/script/agent_compile.ps1 -ProjectPath $root -Mode UNITTEST
    if($LASTEXITCODE){throw 'Compile failed'}
    & lua Lua/tasks/TaskLaunch.lua D:/War3 $root D:/WE/KKWE_Plugin --selection action=start,version=VERSION_UNITTEST,compiler=vjassc,engine=innerjapi,scenario=current --no-launch
    if($LASTEXITCODE){throw 'Package failed'}
    Copy-Item -LiteralPath $slot -Destination (Join-Path 'Output/font-style' $OutputName) -Force
} finally {
    if($null -ne $saved){[IO.File]::WriteAllBytes($slot,$saved)}
}
