param(
    [Parameter(Mandatory=$true)][string]$SessionPath,
    [string]$ClientLogDirectory,
    [string]$CompletionPattern,
    [string]$VictoryPattern,
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
        # Read process state first. A host can flush its final departures and exit
        # while CIM is queried; adjudicate that observation against newer logs.
        $hostExited=!(Get-Process -Id $manifest.hostPid -ErrorAction SilentlyContinue)
        $exitedClients=@(foreach($client in $manifest.clientProcesses) {
            $p=Get-CimInstance Win32_Process -Filter "ProcessId = $($client.pid)"
            if (!$p -or $p.CreationDate.ToUniversalTime().Ticks.ToString() -ne $client.creationUtcTicks) { $client }
        })
        $hostLog=Get-Content -LiteralPath (Join-Path $SessionPath 'host-stdout.log') -Raw
        if ($hostLog -match '(?i)desync detected') { throw 'OOS detected by ydhost' }
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
                    if ($VictoryPattern) {
                        $done=[regex]::Match($text,$CompletionPattern)
                        if ($text.Substring(0,$done.Index) -notmatch $VictoryPattern) { continue }
                    }
                    if ($file.BaseName -match '-P([1-6])$') { $completedPlayers[[int]$Matches[1]]=$true }
                }
            }
        }
        $allDone=$loadedAt -and $CompletionPattern -and $completedPlayers.Count -eq $manifest.clients -and @(1..$manifest.clients | Where-Object { !$completedPlayers.ContainsKey($_) }).Count -eq 0
        $left=@{}
        if ($hostLog -match 'deleting player|has left the game|disconnected') {
            if (!$VictoryPattern -or !$allDone) { throw 'A client disconnected before test completion' }
            foreach ($line in ($hostLog -split '\r?\n')) {
                if ($line -notmatch 'deleting player|has left the game|disconnected') { continue }
                if ($line -match '^\[GAME: [^\]]+\] deleting player \[([^\]]+)\]: has left the game voluntarily\s*$') {
                    $name=$Matches[1]
                    if ($name -in $manifest.clientProcesses.expectedName) { $left[$name]=$true; continue }
                } elseif ($line -match '^\[GAME: [^\]]+\] \[Local\] (\S+) has left the game voluntarily\.\s*$' -and $Matches[1] -in $manifest.clientProcesses.expectedName) {
                    continue
                }
                throw "Unexpected host disconnect: $line"
            }
        }
        foreach($client in $exitedClients) {
            if (!$VictoryPattern -or !$left.ContainsKey($client.expectedName)) { throw 'A test client exited early' }
        }
        if ($hostExited -and $left.Count -ne $manifest.clients) { throw 'Host exited early' }
        if ($loadedAt -and $SmokeSeconds -gt 0 -and ([datetime]::UtcNow-$loadedAt).TotalSeconds -ge $SmokeSeconds) {
            $result.status='SMOKE'; $result.message='All clients reached loading; survived observation without host OOS. Not an assertion pass.'; break
        }
        if ($allDone -and (!$VictoryPattern -or $left.Count -eq $manifest.clients)) {
            $result.status='PASS'
            $result.message=if ($VictoryPattern) { 'All clients confirmed victory and completed assertions; host recorded voluntary exits for all players.' }
                else { 'Completion markers found in one fresh log per client; no observed failure/OOS.' }
            break
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
