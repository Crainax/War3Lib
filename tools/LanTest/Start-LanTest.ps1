param(
    [Parameter(Mandatory=$true)][string]$MapPath,
    [ValidateRange(1,6)][int]$Clients = 1,
    [string]$GamePath = 'D:\Program Files (x86)\Warcraft III Frozen Throne',
    [string]$WEPath = 'D:/WE/KKWE_Plugin',
    [string]$ProjectPath,
    [string]$ProfileScript = 'D:/War3/Library/War3Lib/script/LocalTestProfile.ps1',
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
$launchers = @()
$found = @{}
$profileLock = $null
function Collect-Clients {
    foreach ($parent in $launchers) {
        foreach ($child in @(Get-CimInstance Win32_Process -Filter "Name = 'war3.exe'" | Where-Object { $_.ParentProcessId -eq $parent.pid -and $_.CreationDate.ToUniversalTime() -ge $parent.startedUtc })) {
            if (!$found.ContainsKey([int]$child.ProcessId)) {
                $found[[int]$child.ProcessId]=$true
                $manifest.clientPids += [int]$child.ProcessId
                $manifest.clientProcesses += @{pid=[int]$child.ProcessId;creationUtcTicks=$child.CreationDate.ToUniversalTime().Ticks.ToString();expectedName=$parent.player}
                Save-Manifest
            }
        }
    }
}
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
$profileLock = [IO.File]::Open((Join-Path $GamePath 'local_test_profile.lock'), 'OpenOrCreate', 'ReadWrite', 'None')
if ($ProjectPath) {
    . $ProfileScript -ProjectPath $ProjectPath -GamePath $GamePath -WEPath $WEPath -MapPath $MapPath
    Switch-LocalTestProfile $ProjectPath $GamePath $WEPath
}
$runtimeWE = & (Join-Path $PSScriptRoot 'Prepare-ParallelRuntime.ps1') -WEPath $WEPath
$manifest['runtimeWE']=$runtimeWE
$manifest['launchMode']='parallel'
$manifest['launchers']=@()
Save-Manifest

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

$launcher = Join-Path $runtimeWE 'bin\YDWEConfig.exe'
$launchers = @()
for ($i=1; $i -le $Clients; $i++) {
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $launcher
    $psi.Arguments = if ($ManualJoin) { '-launchwar3 -window' } else { '-launchwar3 -window -auto' }
    $psi.WorkingDirectory = $GamePath
    $psi.UseShellExecute = $false
    $psi.WindowStyle = [Diagnostics.ProcessWindowStyle]::Hidden
    $psi.EnvironmentVariables['WAR3_LAN_PLAYER'] = "LanP$i"
    $psi.EnvironmentVariables['WAR3_LAN_EVIDENCE'] = Join-Path $session "name-P$i.log"
    $p = [Diagnostics.Process]::Start($psi)
    $launchers += @{pid=$p.Id; player="LanP$i"; process=$p; startedUtc=$p.StartTime.ToUniversalTime()}
    $manifest.launchers += @{pid=$p.Id; creationUtcTicks=$p.StartTime.ToUniversalTime().Ticks.ToString();player="LanP$i"}
    Save-Manifest
}
$collectDeadline = [datetime]::UtcNow.AddSeconds(30)
do {
    Collect-Clients
    if ($found.Count -eq $Clients) { break }
    Start-Sleep -Milliseconds 200
} while ([datetime]::UtcNow -lt $collectDeadline)
if ($found.Count -ne $Clients) { throw 'Parallel client discovery timed out' }
$joinDeadline=[datetime]::UtcNow.AddSeconds(60)
do {
    $ready=0
    $hostLog=Get-Content -LiteralPath (Join-Path $session 'host-stdout.log') -Raw
    if ($hostLog -match 'invalid name|desync detected') { throw 'Host rejected client identity or detected OOS' }
    foreach ($i in 1..$Clients) {
        $file=Join-Path $session "name-P$i.log"
        $nameReady=(Test-Path $file) -and ((Get-Content $file -Raw) -match "NAME_READ LanP$i")
        if ($nameReady -and ($ManualJoin -or $hostLog -match "\[LanP$i\|[^\]]+\] joined the game")) { $ready++ }
    }
    if ($ready -eq $Clients) { break }
    Start-Sleep -Milliseconds 250
} while ([datetime]::UtcNow -lt $joinDeadline)
if ($ready -ne $Clients) { throw 'Timed out validating isolated names and lobby joins' }
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
            # Close owned launchers first; no late child may escape collection.
            $launcherErrors=@()
            foreach ($parent in $launchers) {
                try {
                    $parent.process.Refresh()
                    if (!$parent.process.HasExited) { $parent.process.Kill(); $parent.process.WaitForExit() }
                } catch { $launcherErrors += $_.Exception.Message }
            }
            try { Collect-Clients }
            finally { & (Join-Path $PSScriptRoot 'Stop-LanTest.ps1') -SessionPath $session }
            if ($launcherErrors.Count) { throw ('Launcher cleanup failed: '+($launcherErrors -join '; ')) }
        }
    } finally { if ($profileLock) { $profileLock.Dispose() }; $sessionLock.Dispose() }
}
