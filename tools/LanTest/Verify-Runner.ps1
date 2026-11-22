$ErrorActionPreference='Stop'
Set-StrictMode -Version Latest
foreach($file in Get-ChildItem -LiteralPath $PSScriptRoot -Filter '*.ps1') {
    $tokens=$null; $errors=$null
    $null=[Management.Automation.Language.Parser]::ParseFile($file.FullName,[ref]$tokens,[ref]$errors)
    if($errors){throw ($errors | Out-String)}
}
$root=Join-Path $PSScriptRoot ('sessions/parser-test-'+[guid]::NewGuid().ToString('N'))
$null=New-Item -ItemType Directory -Path $root
$logs=Join-Path $root 'logs'
$null=New-Item -ItemType Directory -Path $logs
$self=Get-CimInstance Win32_Process -Filter "ProcessId = $PID"
@{clients=1;startedUtc=[datetime]::UtcNow.AddSeconds(-10).ToString('o');hostPid=$PID;clientProcesses=@(@{pid=$PID;creationUtcTicks=$self.CreationDate.ToUniversalTime().Ticks.ToString()})} | ConvertTo-Json -Depth 4 | Set-Content (Join-Path $root 'session.json')
function Check([string]$name,[string]$hostText,[string]$clientText,[string]$expected) {
    Set-Content -LiteralPath (Join-Path $root 'host-stdout.log') -Value $hostText
    Set-Content -LiteralPath (Join-Path $logs 'test-P1.log') -Value $clientText
    try { & (Join-Path $PSScriptRoot 'Wait-LanTest.ps1') -SessionPath $root -ClientLogDirectory $logs -CompletionPattern '\[UT_DONE\]' -TimeoutSeconds 1 | Out-Null } catch {}
    $result=Get-Content (Join-Path $root 'result.json') -Raw | ConvertFrom-Json
    if($result.status -ne $expected){throw "$name expected $expected got $($result.status)"}
    Write-Output "PASS: $name"
}
Check 'all-client completion' 'started loading with 1 players' 'PASS: test; [UT_DONE]' 'PASS'
Check 'OOS overrides completion' 'started loading with 1 players; desync detected' 'PASS: test; [UT_DONE]' 'FAIL'
Check 'assertion failure overrides completion' 'started loading with 1 players' 'FAIL: test; [UT_DONE]' 'FAIL'
Check 'zero assertions rejected' 'started loading with 1 players' '[UT_DONE]' 'FAIL'
Check 'missing completion times out' 'started loading with 1 players' 'PASS: test' 'FAIL'
Write-Output "Evidence: $root (synthetic parser tests, not gameplay evidence)"

# Three real slots contribute independent completion and victory evidence.
$players=@(1..3 | ForEach-Object {
    @{expectedName="LanP$_";pid=$PID;creationUtcTicks=$self.CreationDate.ToUniversalTime().Ticks.ToString()}
})
@{clients=3;gameName='fixture';startedUtc=[datetime]::UtcNow.AddSeconds(-10);hostPid=2147483647;clientProcesses=$players} |
    ConvertTo-Json -Depth 4 | Set-Content (Join-Path $root 'session.json')
$room="[GAME: fixture] started loading with 3 players"
$departures=@(1..3 | ForEach-Object {"[GAME: fixture] deleting player [LanP$_]: has left the game voluntarily"})
$victory='PASS: all native player results are victory'
$cursor=[Text.Encoding]::UTF8.GetByteCount($room+[Environment]::NewLine)
$complete="$victory`n[UT_DONE] fixture assertions=26 clients=3 host_room=fixture host_bytes=$cursor"
function CheckVictory($name,$lines,$thirdLog,$expected,$timeout=1,$reason=$null) {
    foreach($slot in 1..3) {
        Set-Content (Join-Path $logs "test-P$slot.log") -Value $(if($slot -eq 3){$thirdLog}else{$complete})
    }
    Set-Content (Join-Path $root 'host-stdout.log') -Value (@($room)+$lines)
    $resultFile=Join-Path $root 'result.json'
    if(Test-Path $resultFile){Remove-Item -LiteralPath $resultFile}
    try {
        & (Join-Path $PSScriptRoot 'Wait-LanTest.ps1') -SessionPath $root -ClientLogDirectory $logs -TimeoutSeconds $timeout -VictoryPattern $victory -CompletionPattern '\[UT_DONE\] fixture assertions=[1-9][0-9]* clients=3' | Out-Null
    } catch {}
    $result=Get-Content (Join-Path $root 'result.json') -Raw | ConvertFrom-Json
    if($result.status -ne $expected){throw "$name expected $expected got $($result.status): $($result.message)"}
    if ($reason -and $result.message -notlike $reason) { throw "$name unexpected reason: $($result.message)" }
    Write-Output "PASS: $name"
}
CheckVictory 'three confirmed wins and three voluntary departures' $departures $complete 'PASS'
CheckVictory 'voluntary departure before completion' $departures $victory 'FAIL'
CheckVictory 'one client missing victory' $departures "PASS: other assertion`n[UT_DONE] fixture assertions=26 clients=3" 'FAIL'
CheckVictory 'one client reports zero assertions' $departures ($complete.Replace('=26','=0')) 'FAIL'
CheckVictory 'disconnect despite completed logs' ($departures + '[GAME: fixture] LanP2 disconnected') $complete 'FAIL'
CheckVictory 'partial departures cannot pass' $departures[0..1] $complete 'FAIL'
CheckVictory 'OOS overrides all victory evidence' ($departures + 'desync detected') $complete 'FAIL'
CheckVictory 'client error overrides victory' $departures ($complete + "`n[UT_FAIL]") 'FAIL'
$ended=Get-Content (Join-Path $root 'session.json') -Raw | ConvertFrom-Json
$ended.hostPid=2147483647
foreach ($client in $ended.clientProcesses){$client.pid=2147483647}
$ended | ConvertTo-Json -Depth 4 | Set-Content (Join-Path $root 'session.json')
CheckVictory 'host and clients already exited with complete evidence' $departures $complete 'PASS'
CheckVictory 'exited host with missing departure evidence' $departures[0..1] $complete 'FAIL'

# Freeze the third reader's first sample while the underlying log flushes.
# The original waiter rejects this snapshot before it can take a second one.
function Test-SplitVictorySample {
    param([switch]$LateOos)
    $fixture=@{firstSample=$true}
    function Get-Content([string]$LiteralPath,[switch]$Raw) {
        $text=Microsoft.PowerShell.Management\Get-Content -LiteralPath $LiteralPath -Raw
        if ($fixture.firstSample -and $LiteralPath -like '*test-P3.log') {
            $fixture.firstSample=$false
            Set-Content -LiteralPath $LiteralPath -Value $complete
            if ($LateOos) { Add-Content -LiteralPath (Join-Path $root 'host-stdout.log') -Value 'desync detected' }
        }
        return $text
    }
    if ($LateOos) {
        CheckVictory 'late OOS between samples overrides victory' $departures $victory 'FAIL' 5 'OOS detected by ydhost'
    } else {
        CheckVictory 'complete client record flushed across host departure sample' $departures $victory 'PASS' 5
    }
}
Test-SplitVictorySample
Test-SplitVictorySample -LateOos

CheckVictory 'one client finished after the first voluntary departure' $departures ($complete.Replace("host_bytes=$cursor","host_bytes=$($cursor+20)")) 'FAIL' 1 'Departure before all assertions completed:*'
CheckVictory 'cursor from another room' $departures ($complete.Replace('host_room=fixture','host_room=other')) 'FAIL'
CheckVictory 'missing host cursor' $departures ($complete.Substring(0,$complete.IndexOf(' host_room='))) 'FAIL'
