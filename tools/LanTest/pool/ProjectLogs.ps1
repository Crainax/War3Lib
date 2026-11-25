function Get-ProjectLogDirectory([string]$ProjectPath) {
    if ($ProjectPath) {
        $config = Join-Path $ProjectPath 'project.json'
        if (Test-Path -LiteralPath $config) {
            $relative = (Get-Content -LiteralPath $config -Raw | ConvertFrom-Json -AsHashtable)['log_directory']
            if ($relative) { return $relative }
        }
        $init = Join-Path $ProjectPath 'script/init.lua'
        if (Test-Path -LiteralPath $init) {
            $match = [regex]::Match([IO.File]::ReadAllText($init), '(?m)^\s*package\.log_dir\s*=\s*[''"]([^''"]+)[''"]')
            if ($match.Success) { return $match.Groups[1].Value.Replace('\\','\') }
        }
    }
    return 'War3Lib/日志'
}

function Publish-PoolLogs($Manifest, $Environment) {
    $session = $Manifest.session
    $cleanup = Join-Path $session 'cleanup.json'
    if (!(Test-Path -LiteralPath $cleanup) -or !(Get-Content -LiteralPath $cleanup -Raw | ConvertFrom-Json).success) {
        Write-Warning "Cleanup incomplete; session preserved: $session"
        return
    }
    $resultFile = Join-Path $session 'result.json'
    $result = Get-Content -LiteralPath $resultFile -Raw | ConvertFrom-Json -AsHashtable
    if ($result.Contains('logDirectory')) { return }
    $relative = [IO.Path]::GetRelativePath($Environment.game, $Manifest.clientLogDirectory)
    $destination = Resolve-PoolLogDirectory $relative $Environment.sourceGame $Environment.sourceGame
    $id = Split-Path $session -Leaf
    $success = $result.status -in 'PASS','SMOKE'
    if (!$success) { $destination = Join-Path $destination "LanTest故障/$id" }
    $null = [IO.Directory]::CreateDirectory($destination)
    $closedAt = ([datetime](Get-Content -LiteralPath $cleanup -Raw | ConvertFrom-Json).utc).ToUniversalTime()
    $paths = @()
    $originals = @()
    # Rescan after process exit to include late flushes and early startup failures.
    try {
        if (Test-Path -LiteralPath $Manifest.clientLogDirectory) {
            foreach ($file in Get-ChildItem -LiteralPath $Manifest.clientLogDirectory -File -Recurse -Filter '*.log') {
                if ($file.CreationTimeUtc -gt $closedAt -or $file.CreationTimeUtc -lt ([datetime]$Manifest.startedUtc).ToUniversalTime()) { continue }
                $target = Join-Path $destination $file.Name
                $staged = Join-Path $destination ('.'+[guid]::NewGuid().ToString('N')+'.tmp')
                try {
                    [IO.File]::Copy($file.FullName, $staged)
                    try { [IO.File]::Move($staged, $target) }
                    catch [IO.IOException] {
                        if (!(Test-Path -LiteralPath $target)) { throw }
                        $target = Join-Path $destination ($id+'-'+[guid]::NewGuid().ToString('N').Substring(0,6)+'-'+$file.Name)
                        [IO.File]::Move($staged, $target)
                    }
                } finally { if ([IO.File]::Exists($staged)) { [IO.File]::Delete($staged) } }
                $originals += $file.FullName
                $paths += $target
            }
        }
        $result.logs = $paths
        $result.logDirectory = $destination
        $tmp = "$resultFile.tmp"
        $result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $tmp -Encoding utf8
        [IO.File]::Move($tmp,$resultFile,$true)
    } catch {
        # Until the final path list is committed the private originals are authoritative.
        foreach ($path in $paths) { [IO.File]::Delete($path) }
        throw
    }
    if (!$success) {
        foreach ($file in Get-ChildItem -LiteralPath $session -File | Where-Object { $_.Name -like 'host-*.log' -or $_.Name -like '*Crash*' -or $_.Name -in 'result.json','cleanup.json' }) {
            Copy-Item -LiteralPath $file.FullName -Destination $destination
        }
        $errorsDirectory = Join-Path $Environment.game 'Errors'
        if (Test-Path -LiteralPath $errorsDirectory) {
            $started = ([datetime]$Manifest.startedUtc).ToUniversalTime()
            foreach ($crash in Get-ChildItem -LiteralPath $errorsDirectory -File -Filter '*Crash.*') {
                if ($crash.CreationTimeUtc -ge $started -and $crash.CreationTimeUtc -le $closedAt) {
                    Copy-Item -LiteralPath $crash.FullName -Destination $destination
                }
            }
        }
    }
    # Preserve ownership records and adapter-specific evidence for existing callers.
    $root = [IO.Path]::GetFullPath((Join-Path $Environment.root 'sessions'))
    if ((Split-Path $session -Parent) -ine $root -or $id -notmatch '^\d{8}-\d{6}-[AB]-[a-f0-9]{6}$') { throw 'Invalid session cleanup path' }
    if ($success) {
        foreach ($file in Get-ChildItem -LiteralPath $session -File | Where-Object { $_.Name -match '^(context-|name-|host-).*\.log$|^(map|ydhost)\.cfg$' }) {
            Remove-Item -LiteralPath $file.FullName
        }
        $cloud = Join-Path $session 'CloudScripts'
        if (Test-Path -LiteralPath $cloud) {
            $item = Get-Item -LiteralPath $cloud
            if (!$item.LinkType -and !(Get-ChildItem -LiteralPath $cloud -Recurse -Force | Where-Object LinkType)) {
                Remove-Item -LiteralPath $item.FullName -Recurse -Force
            }
        }
    }
    foreach ($original in $originals) { Remove-Item -LiteralPath $original }
    Write-Host "Project logs: $destination"
}
