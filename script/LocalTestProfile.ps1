param([string]$ProjectPath, [string]$GamePath, [string]$WEPath, [string]$MapPath)

# Dot-source for isolated filesystem tests. Production entry always switches AND launches.
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$script:ProfileIniNames = @('dz_w3_plugin', 'kkapi_local_plugin')

function Get-ProfileId([string]$Project) {
    $id = Split-Path -Leaf ([IO.Path]::GetFullPath($Project).TrimEnd('\', '/'))
    if ($id -notmatch '^[A-Za-z0-9_-]+$') { throw "Invalid local profile name: $id" }
    return $id
}
function Get-ProfileBytesHash([byte[]]$Bytes) {
    $sha = [Security.Cryptography.SHA256]::Create()
    try { return [BitConverter]::ToString($sha.ComputeHash($Bytes)).Replace('-', '') }
    finally { $sha.Dispose() }
}
function Read-ProfileSnapshot([string]$File) {
    if (!(Test-Path -LiteralPath $File)) { return @{path=$File; existed=$false; data=''; hash=''} }
    $bytes = [IO.File]::ReadAllBytes($File)
    return @{path=$File; existed=$true; data=[Convert]::ToBase64String($bytes); hash=(Get-ProfileBytesHash $bytes)}
}
function Get-ProfileHash([string]$File) { return (Read-ProfileSnapshot $File).hash }
function Assert-ProfileSnapshot($Snapshot) {
    $now = Read-ProfileSnapshot $Snapshot.path
    if ($now.existed -ne $Snapshot.existed -or $now.data -cne $Snapshot.data) {
        throw "Profile file changed during switching/recovery: $($Snapshot.path)"
    }
}
function Write-ProfileBytes([string]$File, [byte[]]$Bytes) {
    # Same-volume atomic replacement: interrupted writes never truncate the live archive.
    $temp = $File + '.profile-tmp'
    $stream = [IO.File]::Open($temp, 'Create', 'Write', 'None')
    try { $stream.Write($Bytes, 0, $Bytes.Length); $stream.Flush($true) }
    finally { $stream.Dispose() }
    try {
        if (Test-Path -LiteralPath $File) { [IO.File]::Replace($temp, $File, [NullString]::Value) }
        else { [IO.File]::Move($temp, $File) }
    } finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp }
    }
}
function Write-ProfileText([string]$File, [string]$Text) {
    Write-ProfileBytes $File ([Text.Encoding]::UTF8.GetBytes($Text))
}
function Get-RunningProfileGame { Get-Process -Name war3, Warcraft* -ErrorAction SilentlyContinue }
function Assert-GameStopped {
    if (@(Get-RunningProfileGame).Count) {
        throw 'Close Warcraft III before switching local test profiles.'
    }
}
function Assert-NoPendingProfileLaunch([string]$Game) {
    $pending = Join-Path $Game 'local_test_profile.launching.json'
    if (Test-Path -LiteralPath $pending) {
        throw "Previous launch is unresolved. Verify the launcher/game have stopped before removing: $pending"
    }
}
function Wait-ProfileGameLaunch([string]$Pending, [int]$Attempts = 100) {
    for ($i=0; $i -lt $Attempts; $i++) {
        if (@(Get-RunningProfileGame).Count) {
            Remove-Item -LiteralPath $Pending
            return
        }
        Start-Sleep -Milliseconds 100
    }
    # Keep the marker on timeout/interruption. A delayed process may still start.
    throw "Warcraft startup unconfirmed; further switches blocked by $Pending"
}
function Initialize-CloudEntry([string]$Project) {
    $dir = Join-Path $Project 'CloudScripts'
    [IO.Directory]::CreateDirectory($dir) | Out-Null
    $entry = Join-Path $dir 'main.lua'
    if (!(Test-Path -LiteralPath $entry)) {
        Write-ProfileText $entry "-- Empty local MLS entry. Add project handlers here.`r`n"
    }
    return $dir
}
function Set-CloudConfig([string]$Text, [string]$Folder) {
    $lines = [Collections.Generic.List[string]]::new()
    $inside = $false; $found = $false
    foreach ($line in ($Text -split '\r?\n')) {
        if ($line -match '^\s*\[([^\]]+)\]') {
            $inside = $Matches[1] -eq 'MapTest'
            $lines.Add($line)
            if ($inside) {
                if ($found) { throw 'Duplicate MapTest section' }
                $found = $true
                $lines.Add('EnableMlScript = 1')
                $lines.Add('MlScriptFolder = ' + $Folder)
            }
        } elseif (!($inside -and $line -match '^\s*(EnableMlScript|MlScriptFolder)\s*=')) {
            $lines.Add($line)
        }
    }
    if (!$found) { throw 'Missing MapTest section in EverConfig.cfg' }
    return ($lines -join "`r`n")
}
function Restore-ProfileTransaction([string]$Journal) {
    if (!(Test-Path -LiteralPath $Journal)) { return }
    $records = ConvertFrom-Json -InputObject ([IO.File]::ReadAllText($Journal))
    $restore = @()
    # Preflight every record BEFORE restoring any file. Preserve newer/manual writes.
    foreach ($record in $records) {
        $now = Read-ProfileSnapshot $record.path
        if ($now.existed -eq $record.existed -and $now.data -ceq $record.data) { continue }
        if (!$record.PSObject.Properties['afterHash'] -or $now.hash -ne $record.afterHash) {
            throw "Recovery conflict; files and journal preserved: $($record.path)"
        }
        $restore += @{record=$record; snapshot=$now}
    }
    foreach ($item in $restore) {
        Assert-ProfileSnapshot $item.snapshot
        $record = $item.record
        if ($record.existed) {
            Write-ProfileBytes $record.path ([Convert]::FromBase64String($record.data))
        } else {
            Remove-Item -LiteralPath $record.path
        }
    }
    Remove-Item -LiteralPath $Journal
}
function Switch-LocalTestProfile([string]$Project, [string]$Game, [string]$WE) {
    Assert-GameStopped
    Assert-NoPendingProfileLaunch $Game
    $id = Get-ProfileId $Project
    $stateFile = Join-Path $Game 'local_test_profile.json'
    $journal = Join-Path $Game 'local_test_profile.transaction.json'
    Restore-ProfileTransaction $journal
    if (!(Test-Path -LiteralPath $stateFile)) {
        throw "Missing initial INI ownership: $stateFile. Assign existing INIs before the first launch."
    }
    $snapshots = @{}
    $snapshots[$stateFile] = Read-ProfileSnapshot $stateFile
    $state = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($snapshots[$stateFile].data)) | ConvertFrom-Json
    if ($state.version -ne 1) { throw 'Unsupported local profile state' }
    $cfgFile = Join-Path $WE 'bin/EverConfig.cfg'
    $cloud = Initialize-CloudEntry $Project
    $snapshots[$cfgFile] = Read-ProfileSnapshot $cfgFile
    $cfg = Set-CloudConfig ([Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($snapshots[$cfgFile].data))) $cloud
    $writes = @{}
    foreach ($name in $script:ProfileIniNames) {
        $current = Join-Path $Game ($name + '.ini')
        $owner = $state.owners.$name
        if ($owner -notmatch '^[A-Za-z0-9_-]+$') { throw 'Invalid stored profile owner' }
        $saved = Join-Path $Game ($name + '_' + $owner + '.ini')
        $target = Join-Path $Game ($name + '_' + $id + '.ini')
        if (!(Test-Path -LiteralPath $current)) { throw "Active INI missing: $current" }
        foreach ($file in @($current, $saved, $target)) {
            if (!$snapshots.ContainsKey($file)) { $snapshots[$file] = Read-ProfileSnapshot $file }
        }
        $activeHash = $snapshots[$current].hash
        $savedHash = $snapshots[$saved].hash
        $baseline = $state.hashes.$name
        $changed = $activeHash -ne $baseline
        if ($changed -and $savedHash -and $savedHash -ne $baseline -and $savedHash -ne $activeHash) {
            throw "Both active and project INIs changed; reconcile manually: $current / $saved"
        }
        if ($changed -or !$savedHash) { $writes[$saved] = [Convert]::FromBase64String($snapshots[$current].data) }
        if ($writes.ContainsKey($target)) { $bytes = $writes[$target] }
        elseif ($snapshots[$target].existed) { $bytes = [Convert]::FromBase64String($snapshots[$target].data) }
        else {
            $text = "[DzAPI]`r`n"
            if ($name -eq 'kkapi_local_plugin') { $text += "MLS-MsGetEnvType=-1`r`n" }
            $bytes = [Text.Encoding]::UTF8.GetBytes($text)
            $writes[$target] = $bytes
        }
        $writes[$current] = $bytes
        $state.owners.$name = $id
        $state.hashes.$name = Get-ProfileBytesHash $bytes
    }
    $writes[$cfgFile] = [Text.Encoding]::UTF8.GetBytes($cfg)
    $writes[$stateFile] = [Text.Encoding]::UTF8.GetBytes(($state | ConvertTo-Json -Depth 6))
    # Recheck ALL reads, including target profiles that are only read, before committing.
    foreach ($snapshot in $snapshots.Values) { Assert-ProfileSnapshot $snapshot }
    Assert-GameStopped
    $records = @(foreach ($file in $writes.Keys) {
        $snapshot = $snapshots[$file]
        @{path=$file; existed=$snapshot.existed; data=$snapshot.data; afterHash=(Get-ProfileBytesHash $writes[$file])}
    })
    Write-ProfileText $journal (ConvertTo-Json -InputObject $records -Depth 5)
    try {
        foreach ($file in $writes.Keys) {
            Assert-ProfileSnapshot $snapshots[$file]
            Write-ProfileBytes $file $writes[$file]
        }
        # Never launch if a file changed while committing (including read-only targets).
        foreach ($snapshot in $snapshots.Values) {
            if ($writes.ContainsKey($snapshot.path)) {
                if ((Get-ProfileHash $snapshot.path) -ne (Get-ProfileBytesHash $writes[$snapshot.path])) {
                    throw "Profile changed during commit: $($snapshot.path)"
                }
            } else { Assert-ProfileSnapshot $snapshot }
        }
    } catch {
        Restore-ProfileTransaction $journal
        throw
    }
    Remove-Item -LiteralPath $journal
    Write-Host "[Local profile] $id / $cloud"
}

if ($MyInvocation.InvocationName -ne '.') {
    $lock = $null
    try {
        if (!(Test-Path -LiteralPath $MapPath -PathType Leaf)) { throw "Map missing: $MapPath" }
        $exe = Join-Path $WEPath 'bin/YDWEConfig.exe'
        if (!(Test-Path -LiteralPath $exe)) { throw "Launcher missing: $exe" }
        $lock = [IO.File]::Open((Join-Path $GamePath 'local_test_profile.lock'), 'OpenOrCreate', 'ReadWrite', 'None')
        Switch-LocalTestProfile $ProjectPath $GamePath $WEPath
        $pending = Join-Path $GamePath 'local_test_profile.launching.json'
        Write-ProfileText $pending (@{project=$ProjectPath; startedUtc=[DateTime]::UtcNow.ToString('o')} | ConvertTo-Json)
        $process = Start-Process -FilePath $exe -ArgumentList @('-launchwar3', '-loadfile', ('"' + $MapPath + '"')) -PassThru -WindowStyle Hidden
        # YDWEConfig can exit BEFORE its child game appears. Hold the lock through that gap.
        Wait-ProfileGameLaunch $pending
    } catch {
        Write-Error $_ -ErrorAction Continue
        exit 1
    } finally {
        if ($null -ne $lock) { $lock.Dispose() }
    }
}
