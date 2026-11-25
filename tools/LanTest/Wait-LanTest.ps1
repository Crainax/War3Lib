param(
    [Parameter(Mandatory=$true)][string]$SessionPath,
    [string]$ClientLogDirectory,
    [string]$CompletionPattern,
    [string]$VictoryPattern,
    [string]$DefeatPattern,
    [int]$TimeoutSeconds=120,
    [int]$SmokeSeconds=0,
    [switch]$ExpectMapExit,
    [ValidateRange(1,60)][int]$ExitObserveSeconds=10
)
$ErrorActionPreference='Stop'
$manifest=Get-Content -LiteralPath (Join-Path $SessionPath 'session.json') -Raw | ConvertFrom-Json
$deadline=[datetime]::UtcNow.AddSeconds($TimeoutSeconds)
$loadedAt=$null
$hostPath=Join-Path $SessionPath 'host-stdout.log'
$result=@{status='FAIL'; message=''; clients=$manifest.clients; logs=@()}
if ($VictoryPattern -and $DefeatPattern) { throw 'Specify only one terminal result.' }
$terminalPattern=if ($DefeatPattern) { $DefeatPattern } else { $VictoryPattern }
$departureAt=$null
try {
    if ($ExpectMapExit -and ($manifest.clients -ne 1 -or !$CompletionPattern -or !$ClientLogDirectory -or $SmokeSeconds -or $terminalPattern)) {
        throw 'Expected map exit requires one client, assertion logs and no conflicting terminal mode.'
    }
    do {
        # Read process state first. A host can flush its final departures and exit
        # while CIM is queried; adjudicate that observation against newer logs.
        $hostExited=!(Get-Process -Id $manifest.hostPid -ErrorAction SilentlyContinue)
        $exitedClients=@(foreach($client in $manifest.clientProcesses) {
            $p=Get-CimInstance Win32_Process -Filter "ProcessId = $($client.pid)"
            if (!$p -or $p.CreationDate.ToUniversalTime().Ticks.ToString() -ne $client.creationUtcTicks) { $client }
        })
        if ($terminalPattern) {
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
        if ($ExpectMapExit) {
            $errors=Join-Path $manifest.gamePath 'Errors'
            if (Test-Path -LiteralPath $errors) {
                $crash=Get-ChildItem -LiteralPath $errors -File -Filter '*Crash.txt' | Where-Object {
                    $_.LastWriteTimeUtc -ge ([datetime]$manifest.startedUtc).ToUniversalTime() -and
                    (Select-String -LiteralPath $_.FullName -SimpleMatch ([IO.Path]::GetFileName($manifest.gameMap)) -Quiet)
                } | Select-Object -First 1
                if ($crash) { throw "Game crash during expected map exit: $($crash.FullName)" }
            }
        }
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
                    if ($terminalPattern) {
                        $done=[regex]::Match($text,$CompletionPattern)
                        if ($text.Substring(0,$done.Index) -notmatch $terminalPattern) { continue }
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
                    if ($file.BaseName -match '-P([1-6])$') { $completedPlayers[[int]$Matches[1]]=if ($terminalPattern) {$cursor} else {$true} }
                }
            }
        }
        $allDone=$loadedAt -and $CompletionPattern -and $completedPlayers.Count -eq $manifest.clients -and @(1..$manifest.clients | Where-Object { !$completedPlayers.ContainsKey($_) }).Count -eq 0
        $left=@{}
        if ($hostLog -match 'deleting player|has left the game|disconnected') {
            if (!$terminalPattern -and !$ExpectMapExit) { throw 'A client disconnected before test completion' }
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
            if (!$terminalPattern -or !$left.ContainsKey($client.expectedName)) { throw 'A test client exited early' }
        }
        if ($hostExited -and $left.Count -ne $manifest.clients) { throw 'Host exited early' }
        if ($loadedAt -and $SmokeSeconds -gt 0 -and ([datetime]::UtcNow-$loadedAt).TotalSeconds -ge $SmokeSeconds) {
            $result.status='SMOKE'; $result.message='All clients reached loading; survived observation without host OOS. Not an assertion pass.'; break
        }
        if ($ExpectMapExit -and $left.Count -eq 1) {
            if (!$allDone) { throw 'Expected map exit before completion marker' }
            if (!$departureAt) { $departureAt=[datetime]::UtcNow }
            $elapsed=([datetime]::UtcNow-$departureAt).TotalSeconds
            if ($elapsed -ge $ExitObserveSeconds) {
                $result.exitObservedSeconds=[math]::Floor($elapsed)
                $result.status='PASS'
                $result.message='Assertions completed; voluntary map exit observed with original client alive.'
                break
            }
        }
        if (!$ExpectMapExit -and $allDone -and (!$terminalPattern -or ($hostExited -and $left.Count -eq $manifest.clients))) {
            if ($terminalPattern) {
                $result.firstDepartureByte=$firstLeave.Index
                $result.completionBytes=@(1..$manifest.clients | ForEach-Object { $completedPlayers[$_] })
            }
            $result.status='PASS'
            $result.message=if ($DefeatPattern) { 'All clients confirmed defeat and completed assertions; host recorded voluntary exits for all players.' }
                elseif ($VictoryPattern) { 'All clients confirmed victory and completed assertions; host recorded voluntary exits for all players.' }
                else { 'Completion markers found in one fresh log per client; no observed failure/OOS.' }
            break
        }
        Start-Sleep -Milliseconds 500
    } while ([datetime]::UtcNow -lt $deadline)
    if ($result.status -eq 'FAIL') { throw 'Timed out waiting for all clients and test completion' }
} catch { $result.message=$_.Exception.Message; throw }
finally {
    $result | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $SessionPath 'result.json') -Encoding UTF8 }
Write-Output "$($result.status): $($result.message)"
