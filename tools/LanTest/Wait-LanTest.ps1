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
$hostPath=Join-Path $SessionPath 'host-stdout.log'
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
        if ($VictoryPattern) {
            # One character per byte, including non-ASCII host messages. Client
            # cursors are byte offsets in this same append-only session log.
            $stream=[IO.File]::Open($hostPath,'Open','Read','ReadWrite')
            try {
                $reader=[IO.StreamReader]::new($stream,[Text.Encoding]::GetEncoding(28591),$false)
                try { $hostLog=$reader.ReadToEnd() } finally { $reader.Dispose() }
            } finally { $stream.Dispose() }
            if (!$hostExited) { $hostLog=$hostLog.Substring(0,$hostLog.LastIndexOf("`n")+1) }
            $firstLeave=[regex]::Match($hostLog,'(?im)^.*(?:deleting player|has left the game|disconnected)')
            $loading=[regex]::Match($hostLog,"started loading with $($manifest.clients) players")
        } else {
            $hostLog=Get-Content -LiteralPath $hostPath -Raw
        }
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
                        $tail=$text.Substring($done.Index+$done.Length)
                        if ($tail -notmatch '^ host_room=(\S+) host_bytes=([0-9]+)\r?\n') { continue }
                        $cursor=[long]$Matches[2]
                        if ($Matches[1] -cne $manifest.gameName) { throw 'Completion belongs to a different room' }
                        if (!$loading.Success -or $cursor -gt $hostLog.Length) { continue }
                        if ($cursor -lt $loading.Index+$loading.Length) { throw 'Completion before room loaded' }
                        if ($firstLeave.Success -and $cursor -gt $firstLeave.Index) {
                            throw "Departure before all assertions completed: $($file.Name)"
                        }
                    }
                    if ($file.BaseName -match '-P([1-6])$') { $completedPlayers[[int]$Matches[1]]=if ($VictoryPattern) {$cursor} else {$true} }
                }
            }
        }
        $allDone=$loadedAt -and $CompletionPattern -and $completedPlayers.Count -eq $manifest.clients -and @(1..$manifest.clients | Where-Object { !$completedPlayers.ContainsKey($_) }).Count -eq 0
        $left=@{}
        if ($hostLog -match 'deleting player|has left the game|disconnected') {
            if (!$VictoryPattern) { throw 'A client disconnected before test completion' }
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
        if ($allDone -and (!$VictoryPattern -or ($hostExited -and $left.Count -eq $manifest.clients))) {
            if ($VictoryPattern) {
                $result.firstDepartureByte=$firstLeave.Index
                $result.completionBytes=@(1..$manifest.clients | ForEach-Object { $completedPlayers[$_] })
            }
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
