param(
    [Parameter(Mandatory=$true)][string]$SessionPath,
    [string]$ClientLogDirectory,
    [string]$CompletionPattern,
    [int]$TimeoutSeconds=120,
    [int]$SmokeSeconds=0
)
$ErrorActionPreference='Stop'
$manifest=Get-Content -LiteralPath (Join-Path $SessionPath 'session.json') -Raw | ConvertFrom-Json
$deadline=[datetime]::UtcNow.AddSeconds($TimeoutSeconds)
$loadedAt=$null
$result=@{status='FAIL'; message=''; clients=$manifest.clients; logs=@()}
try {
    do {
        $hostLog=Get-Content -LiteralPath (Join-Path $SessionPath 'host-stdout.log') -Raw
        if ($hostLog -match '(?i)desync detected') { throw 'OOS detected by ydhost' }
        if ($hostLog -match 'deleting player|has left the game|disconnected') { throw 'A client disconnected before test completion' }
        foreach($client in $manifest.clientProcesses) {
            $p=Get-CimInstance Win32_Process -Filter "ProcessId = $($client.pid)"
            if (!$p -or $p.CreationDate.ToUniversalTime().Ticks.ToString() -ne $client.creationUtcTicks) { throw 'A test client exited early' }
        }
        if (!(Get-Process -Id $manifest.hostPid -ErrorAction SilentlyContinue)) { throw 'Host exited early' }
        if ($hostLog -match "started loading with $($manifest.clients) players" -and !$loadedAt) { $loadedAt=[datetime]::UtcNow }
        $completedPlayers=@{}
        if ($ClientLogDirectory) {
            $logs=@(Get-ChildItem -LiteralPath $ClientLogDirectory -File -Filter *.log -Recurse | Where-Object { $_.CreationTimeUtc -ge ([datetime]$manifest.startedUtc).ToUniversalTime() })
            $result.logs=@($logs | ForEach-Object FullName)
            foreach($file in $logs) {
                $text=Get-Content -LiteralPath $file.FullName -Raw
                if ($text -match '(?im)FAIL:|\[UT_FAIL\]|desync detected|RUNTIME_ERROR|stack traceback|\[error\]') { throw "Failure in $($file.FullName)" }
                if ($CompletionPattern -and $text -match $CompletionPattern -and $text -match '(?m)PASS:|\[UT_PASS\]') {
                    # Existing project log names end in -P1.log, -P2.log etc.
                    # Never count multiple files for one client as multiple successes.
                    if ($file.BaseName -match '-P([1-6])$') { $completedPlayers[[int]$Matches[1]]=$true }
                }
            }
        }
        if ($loadedAt -and $SmokeSeconds -gt 0 -and ([datetime]::UtcNow-$loadedAt).TotalSeconds -ge $SmokeSeconds) {
            $result.status='SMOKE'; $result.message='All clients reached loading; survived observation without host OOS. Not an assertion pass.'; break
        }
        if ($loadedAt -and $CompletionPattern -and $completedPlayers.Count -eq $manifest.clients -and @(1..$manifest.clients | Where-Object { !$completedPlayers.ContainsKey($_) }).Count -eq 0) {
            $result.status='PASS'; $result.message='Completion markers found in one fresh log per client; no observed failure/OOS.'; break
        }
        Start-Sleep -Milliseconds 500
    } while ([datetime]::UtcNow -lt $deadline)
    if ($result.status -eq 'FAIL') { throw 'Timed out waiting for all clients and test completion' }
} catch { $result.message=$_.Exception.Message; throw }
finally {
    if ($result.logs.Count) {
        $evidence=Join-Path $SessionPath 'client-logs'
        $null=New-Item -ItemType Directory -Path $evidence -Force
        foreach($log in $result.logs) { Copy-Item -LiteralPath $log -Destination $evidence -ErrorAction Continue }
    }
    $result | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $SessionPath 'result.json') -Encoding UTF8 }
Write-Output "$($result.status): $($result.message)"
