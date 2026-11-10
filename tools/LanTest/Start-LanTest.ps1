param(
    [Parameter(Mandatory=$true)][string]$MapPath,
    [ValidateRange(1,6)][int]$Clients = 1,
    [string]$GamePath = 'D:\Program Files (x86)\Warcraft III Frozen Throne',
    [string]$WEPath = 'D:\WE\KKWE_Plugin',
    [string]$LuaRuntime = 'D:\WE\YDWE1.32.13正式版',
    [switch]$PrepareOnly,
    [switch]$ManualJoin,
    [switch]$LegacySizeCap,
    [string]$MapConfigOverride,
    [switch]$UseScriptSlots,
    [switch]$Automated,
    [string]$ClientLogDirectory,
    [string]$CompletionPattern,
    [ValidateRange(10,1800)][int]$TimeoutSeconds = 120,
    [ValidateRange(0,120)][int]$SmokeSeconds = 0
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ($Automated -and $SmokeSeconds -eq 0 -and (!$ClientLogDirectory -or !$CompletionPattern)) { throw 'Automated assertion tests require ClientLogDirectory and CompletionPattern; use SmokeSeconds only for a labelled smoke test.' }
$session = $null
$manifest = $null
$launchSucceeded = $false
$sessionLock = [IO.File]::Open((Join-Path $PSScriptRoot 'session.lock'), 'OpenOrCreate', 'ReadWrite', 'None')
try {
$map = (Resolve-Path -LiteralPath $MapPath).Path
if ([IO.Path]::GetExtension($map) -notin @('.w3x','.w3m')) { throw 'Provide a packaged .w3x/.w3m map.' }
if (!$PrepareOnly -and @(Get-Process -Name war3,'Warcraft III',ydhost -ErrorAction SilentlyContinue).Count) {
    throw 'Existing Warcraft/ydhost process found. Existing unrelated session is not owned by this run; stop it through its session manifest first.'
}
$installed = (Get-ItemProperty 'HKCU:\Software\Blizzard Entertainment\Warcraft III').InstallPath
if ([IO.Path]::GetFullPath($installed).TrimEnd('\') -ine [IO.Path]::GetFullPath($GamePath).TrimEnd('\')) {
    throw 'YDWEConfig uses the registry game directory; GamePath must match InstallPath.'
}
$version = (Get-Item -LiteralPath (Join-Path $GamePath 'Game.dll')).VersionInfo
if ($version.FileMinorPart -ne 27) { throw 'This launcher is currently validated only against Warcraft 1.27.' }
$id = (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [Guid]::NewGuid().ToString('N').Substring(0,6)
$session = Join-Path $PSScriptRoot ('sessions\' + $id)
$null = New-Item -ItemType Directory -Path $session
$mapCfg = Join-Path $session 'map.cfg'
& (Join-Path $LuaRuntime 'bin\lua.exe') (Join-Path $PSScriptRoot 'map_config.lua') $LuaRuntime $WEPath $map $mapCfg $Clients ([int][bool]$UseScriptSlots)
if ($LASTEXITCODE -ne 0) { throw 'Map configuration generation failed.' }
if ($LegacySizeCap -and (Get-Item -LiteralPath $map).Length -gt 8388607) {
    $mapText = [IO.File]::ReadAllText($mapCfg)
    $mapText = [regex]::Replace($mapText, '(?m)^map_size = [^\r\n]+', 'map_size = 255 255 127 0')
    [IO.File]::WriteAllText($mapCfg, $mapText, [Text.UTF8Encoding]::new($false))
    Write-Host 'Compatibility probe: advertise 8388607 bytes to match the legacy yd_size_limit hook.'
}
if ($MapConfigOverride) {
    Copy-Item -LiteralPath $MapConfigOverride -Destination $mapCfg
    Write-Host "Diagnostic map configuration: $MapConfigOverride"
}
$relative = 'Maps\Test\LAN-' + $id + [IO.Path]::GetExtension($map)
$gameMap = Join-Path $GamePath $relative
$gameName = 'LanTest-' + $id
$autoStart = if ($Clients -eq 1) {1} else {2}
$cfg = @"
lan_war3version = 27
bot_defaultgamename = $gameName
bot_autostart = $autoStart
bot_mappath = $relative
bot_mapcfgpath = map.cfg
"@
[IO.File]::WriteAllText((Join-Path $session 'ydhost.cfg'), $cfg, [Text.UTF8Encoding]::new($false))
$manifest = [ordered]@{ session=$session; sourceMap=$map; sha256=(Get-FileHash -LiteralPath $map).Hash; gameMap=$gameMap; clients=$Clients; autoJoin=(!$ManualJoin); legacySizeCap=[bool]$LegacySizeCap; useScriptSlots=[bool]$UseScriptSlots; mapConfigOverride=$MapConfigOverride; startedUtc=[datetime]::UtcNow.ToString("o"); hostPid=$null; hostCreationUtcTicks=$null; clientPids=@(); clientProcesses=@(); gameName=$gameName }
function Save-Manifest { $manifest | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $session 'session.json') -Encoding UTF8 }
Save-Manifest
if ($PrepareOnly) { Write-Host "Prepared: $session"; return }
$hostBin = Join-Path $PSScriptRoot 'bin'
$null = New-Item -ItemType Directory -Path $hostBin -Force
foreach ($file in @('ydhost.exe','vcruntime140.dll','msvcp140.dll')) {
    $src = if ($file -eq 'ydhost.exe') { Join-Path $WEPath 'plugin\ydhost\ydhost.exe' } else { Join-Path $WEPath ('bin\' + $file) }
    $dest = Join-Path $hostBin $file
    if (!(Test-Path -LiteralPath $dest) -or (Get-FileHash -LiteralPath $src).Hash -ne (Get-FileHash -LiteralPath $dest).Hash) {
        Copy-Item -LiteralPath $src -Destination $dest
    }
}
$null = New-Item -ItemType Directory -Path (Split-Path $gameMap) -Force
Copy-Item -LiteralPath $map -Destination $gameMap
$hostProcess = Start-Process -FilePath (Join-Path $hostBin 'ydhost.exe') -WorkingDirectory $session -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $session 'host-stdout.log') -RedirectStandardError (Join-Path $session 'host-stderr.log')
$manifest.hostPid = $hostProcess.Id
$manifest.hostCreationUtcTicks = (Get-CimInstance Win32_Process -Filter "ProcessId = $($hostProcess.Id)").CreationDate.ToUniversalTime().Ticks.ToString()
Save-Manifest
Start-Sleep -Seconds 2
$hostProcess.Refresh()
if ($hostProcess.HasExited) { throw "Host exited; inspect $session" }
$launcher = Join-Path $WEPath 'bin\YDWEConfig.exe'
$configPath = Join-Path $WEPath 'bin\EverConfig.cfg'
$originalConfig = [IO.File]::ReadAllBytes($configPath)
$lastConfig = $originalConfig
$registry = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Software\Blizzard Entertainment\Warcraft III\String', $true)
if (!$registry) { throw 'Missing Warcraft III String registry key.' }
$hadName = $registry.GetValueNames() -contains 'userlocal'
$originalName = $registry.GetValue('userlocal')
$originalKind = if ($hadName) { $registry.GetValueKind('userlocal') } else { $null }
[IO.File]::WriteAllBytes((Join-Path $session 'EverConfig.before.cfg'), $originalConfig)
try {
for ($i=1; $i -le $Clients; $i++) {
    $playerName = 'LanP' + $i
    # YDWEConfig copies this setting into userlocal before spawning the game.
    $configText = [Text.Encoding]::UTF8.GetString($originalConfig)
    if ($configText -notmatch '(?m)^UserName\s*=') { throw 'Missing UserName configuration.' }
    $configText = [regex]::Replace($configText, '(?m)^UserName\s*=[^\r\n]*', ('UserName = ' + $playerName))
    if ([Convert]::ToBase64String([IO.File]::ReadAllBytes($configPath)) -cne [Convert]::ToBase64String($lastConfig)) { throw 'EverConfig changed externally; refusing overwrite.' }
    $lastConfig = [Text.Encoding]::UTF8.GetBytes($configText)
    [IO.File]::WriteAllBytes($configPath, $lastConfig)
    $before = @(Get-Process -Name war3 -ErrorAction SilentlyContinue | ForEach-Object Id)
    $launchArgs = @('-launchwar3', '-window')
    if (!$ManualJoin) { $launchArgs += '-auto' }
    $clientLauncher = Start-Process -FilePath $launcher -ArgumentList $launchArgs -WorkingDirectory $GamePath -WindowStyle Hidden -PassThru
    $new = @()
    for ($attempt=0; $attempt -lt 100; $attempt++) {
        Start-Sleep -Milliseconds 200
        $new = @(Get-CimInstance Win32_Process -Filter "Name = 'war3.exe'" | Where-Object { $_.ProcessId -notin $before -and $_.ParentProcessId -eq $clientLauncher.Id })
        if ($new.Count) { break }
    }
    if (!$new.Count) { throw "Client $i did not appear; existing processes are left running. Session: $session" }
    $manifest.clientPids += @($new | ForEach-Object ProcessId)
    $manifest.clientProcesses += @($new | ForEach-Object { @{pid=[int]$_.ProcessId; creationUtcTicks=$_.CreationDate.ToUniversalTime().Ticks.ToString()} })
    Save-Manifest
    # Name/config stays serialized until host acknowledges this client; loading then overlaps.
    if (!$ManualJoin) {
        $joined = $false
        for ($attempt=0; $attempt -lt 80; $attempt++) {
            $log = Get-Content -LiteralPath (Join-Path $session 'host-stdout.log') -Raw
            $playerLines = @($log -split '\r?\n' | Where-Object { $_.Contains('[' + $playerName + '|') })
            if (@($playerLines | Where-Object { $_ -match 'invalid name' }).Count) { throw "Host rejected $playerName; see host-stdout.log." }
            if (@($playerLines | Where-Object { $_ -match 'joined the game' }).Count) { $joined = $true; break }
            Start-Sleep -Milliseconds 500
        }
        if (!$joined) { throw "No host acknowledgement for $playerName. Session cleanup will run before returning. Logs: $session" }
    }
}
} finally {
    if ([Convert]::ToBase64String([IO.File]::ReadAllBytes($configPath)) -ceq [Convert]::ToBase64String($lastConfig)) {
        [IO.File]::WriteAllBytes($configPath, $originalConfig)
    } else { Write-Warning "EverConfig changed externally; original backup: $session\EverConfig.before.cfg" }
    # Only restore our own temporary name; preserve unrelated concurrent writes.
    $currentName = $registry.GetValue('userlocal')
    $nameText = if ($currentName -is [byte[]]) { [Text.Encoding]::UTF8.GetString($currentName).TrimEnd([char]0) } else { [string]$currentName }
    if ($nameText -match '^LanP\d+$') {
        if ($hadName) { $registry.SetValue('userlocal', $originalName, $originalKind) }
        else { $registry.DeleteValue('userlocal', $false) }
    }
    $registry.Dispose()
}
Write-Host "Started $Clients client(s). Room: $gameName"
Write-Host "Session/logs: $session"
Write-Host 'Process startup is not proof of loading. Check host-stdout.log for player joins and loading completion.'

$launchSucceeded = $true
if ($Automated) {
    & (Join-Path $PSScriptRoot 'Wait-LanTest.ps1') -SessionPath $session -ClientLogDirectory $ClientLogDirectory -CompletionPattern $CompletionPattern -TimeoutSeconds $TimeoutSeconds -SmokeSeconds $SmokeSeconds
}
} catch {
    if ($session -and !(Test-Path -LiteralPath (Join-Path $session 'result.json'))) {
        @{status='FAIL';message=$_.Exception.Message} | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $session 'result.json') -Encoding UTF8
    }
    throw
} finally {
    try {
        if ($session -and $manifest -and !$PrepareOnly -and ($Automated -or !$launchSucceeded)) {
            & (Join-Path $PSScriptRoot 'Stop-LanTest.ps1') -SessionPath $session
        }
    } finally { $sessionLock.Dispose() }
}
