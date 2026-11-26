param(
    [Parameter(Mandatory)][string]$MapPath,
    [Parameter(Mandatory)][string]$ProjectPath,
    [Parameter(Mandatory)][string]$Scene,
    [Parameter(Mandatory)][string]$ReadyPattern,
    [string]$CompletionPattern = $ReadyPattern,
    [string]$OwnerId = $env:CODEX_THREAD_ID,
    [string]$ClientLogDirectory,
    [ValidateRange(10,1800)][int]$TimeoutSeconds = 120,
    [switch]$UseScriptSlots,
    [switch]$LegacySizeCap
)
#requires -Version 7.0
$ErrorActionPreference = 'Stop'
if (!$OwnerId) { $OwnerId = "ui-capture-$PID" }
if ($Scene -notmatch '^[\p{L}\p{N}_-]+$') { throw 'Use letters, numbers, underscores or hyphens for Scene.' }
$project = Get-Item -LiteralPath $ProjectPath
$options = @{
    Scene = $Scene
    Project = $project.Name
    ReadyPattern = [regex]::new($ReadyPattern)
    TimeoutSeconds = $TimeoutSeconds
}
$run = @{
    Environment = 'Auto'
    Clients = 1
    OwnerId = $OwnerId
    MapPath = $MapPath
    ProjectPath = $project.FullName
    ClientLogDirectory = $ClientLogDirectory
    CompletionPattern = $CompletionPattern
    TimeoutSeconds = $TimeoutSeconds
    UseScriptSlots = $UseScriptSlots
    LegacySizeCap = $LegacySizeCap
    RuntimeAdapter = Join-Path $PSScriptRoot 'Capture-Frame.ps1'
    AdapterOptions = $options
}
$visualMap = Join-Path ([IO.Path]::GetTempPath()) ("war3-visual-" + [guid]::NewGuid() + [IO.Path]::GetExtension($MapPath))
$previous = $env:WAR3_FRAME_DIRECTORY
try {
    [IO.File]::Copy((Resolve-Path -LiteralPath $MapPath).Path, $visualMap, $false)
    & 'D:/War3/tools/w3x2lni/bin/w3x2lni-lua.exe' (Join-Path $PSScriptRoot 'quiet_test_output.lua') $visualMap
    if ($LASTEXITCODE -ne 0) { throw 'Visual test map preparation failed.' }
    $run.MapPath = $visualMap
    & 'D:/War3/tools/LanTest/pool/Start-PoolTest.ps1' @run
} finally {
    $env:WAR3_FRAME_DIRECTORY = $previous
    if (Test-Path -LiteralPath $visualMap) { Remove-Item -LiteralPath $visualMap }
}
