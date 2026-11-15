$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'SessionQueue.ps1')
$root=Join-Path $PSScriptRoot ('sessions/queue-test-'+[guid]::NewGuid().ToString('N'))
$null=New-Item -ItemType Directory -Path $root
$helper=Join-Path $PSScriptRoot 'SessionQueue.ps1'
function Assert($ok,$name) { if(!$ok){throw $name}; Write-Host "PASS: $name" }
$first=Enter-LanQueue -Root $root -OwnerId 'first' -MapPath test -WaitSeconds 5 -BusyProbe { @() }
$job=Start-Job -ArgumentList $helper,$root -ScriptBlock {
    param($helper,$root)
    . $helper
    $lease=Enter-LanQueue -Root $root -OwnerId second -MapPath test -WaitSeconds 20 -PollMilliseconds 100 -BusyProbe { @() }
    try { Set-Content (Join-Path $root 'second-entered') 'yes' } finally { Exit-LanQueue $lease 'second-session' }
}
try {
    $deadline=[datetime]::UtcNow.AddSeconds(10)
    do { Start-Sleep -Milliseconds 100; $tickets=@(Get-ChildItem (Join-Path $root 'queue') -Filter '*.json') } while($tickets.Count -lt 2 -and [datetime]::UtcNow -lt $deadline)
    Assert ($tickets.Count -eq 2) 'second runner registered'
    Assert (!(Test-Path (Join-Path $root 'second-entered'))) 'active owner blocks next runner'
    Exit-LanQueue $first 'first-session'; $first=$null
    $null=Wait-Job $job -Timeout 20
    Receive-Job $job -ErrorAction Stop
    Assert (Test-Path (Join-Path $root 'second-entered')) 'waiting runner starts after owner releases'
} finally { if($first){Exit-LanQueue $first ''}; if($job.State -eq 'Running'){Stop-Job $job}; Remove-Job $job }
$busy={ [pscustomobject]@{Id=123;ProcessName='human-game-sentinel'} }
try { $null=Enter-LanQueue -Root $root -OwnerId blocked -MapPath test -WaitSeconds 1 -PollMilliseconds 100 -BusyProbe $busy; throw 'Expected timeout' }
catch { Assert ($_.Exception.Message -match 'LAN_DEFERRED') 'manual/unknown game defers without cleanup' }
$last=Get-ChildItem (Join-Path $root 'queue') -Filter '*.json' | Sort-Object Name | Select-Object -Last 1
Assert ((Get-Content $last.FullName -Raw | ConvertFrom-Json).state -eq 'DEFERRED') 'queue timeout recorded separately from test failure'
# Stale waiter cannot block queue forever; it also cannot authorize killing a game.
$stale=Join-Path $root 'queue/000-stale.json'
@{state='WAITING';runnerPid=$PID;runnerCreationUtcTicks='1'} | ConvertTo-Json | Set-Content $stale
$lease=Enter-LanQueue -Root $root -OwnerId after-stale -MapPath test -WaitSeconds 2 -BusyProbe { @() }
Exit-LanQueue $lease ''
Assert $true 'PID reuse/creation mismatch skips dead waiter metadata'
$session=Join-Path $root 'foreign-session';$null=New-Item -ItemType Directory $session
@{ownerId='other';clientProcesses=@();hostPid=$null} | ConvertTo-Json | Set-Content (Join-Path $session 'session.json')
try { & (Join-Path $PSScriptRoot 'Stop-LanTest.ps1') -SessionPath $session -OwnerId mine; throw 'Expected refusal' }
catch { Assert ($_.Exception.Message -match 'owner mismatch') 'foreign ownership refuses cleanup before process operations' }
Write-Host "Queue evidence: $root (synthetic concurrency tests; no game launched or terminated)"
