$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'PoolQueue.ps1')
$root=Join-Path ([IO.Path]::GetTempPath()) ('war3-pool-queue-'+[guid]::NewGuid().ToString('N'))
$pool=Join-Path $root 'pool';$null=New-Item -ItemType Directory -Force "$pool/A","$pool/B"
[IO.File]::WriteAllText((Join-Path $root 'session.lock'),'')
$leases=@();$jobs=@();$helper=Join-Path $PSScriptRoot 'PoolQueue.ps1'
function Assert($ok,$name){if(!$ok){throw $name};Write-Host "PASS: $name"}
try{
 $a=Enter-PoolQueue -Root $pool -OwnerId first -MapPath dummy -WaitSeconds 2 -BusyProbe {@()};$leases+=$a
 $b=Enter-PoolQueue -Root $pool -OwnerId second -MapPath dummy -WaitSeconds 2 -BusyProbe {@()};$leases+=$b
 Assert ($a.Environment -eq 'A' -and $b.Environment -eq 'B') 'two tasks allocate different idle environments'
 $blocked=$false
 try{$exclusive=[IO.File]::Open((Join-Path $root 'session.lock'),'Open','ReadWrite','None');$exclusive.Dispose()}catch [IO.IOException]{$blocked=$true}
 Assert $blocked 'pool reservations exclude legacy launch through shared guard'
 foreach($owner in 'third','fourth'){
  $job=Start-Job -ArgumentList $helper,$pool,$root,$owner -ScriptBlock {
   param($helper,$pool,$root,$owner)
   . $helper
   $lease=Enter-PoolQueue -Root $pool -OwnerId $owner -MapPath dummy -WaitSeconds 20 -PollMilliseconds 100 -BusyProbe {@()}
   try{
    [IO.File]::WriteAllText((Join-Path $root ($owner+'-entered')),$lease.Environment)
    $deadline=[datetime]::UtcNow.AddSeconds(15)
    while(!(Test-Path (Join-Path $root ($owner+'-release'))) -and [datetime]::UtcNow -lt $deadline){Start-Sleep -Milliseconds 100}
   }finally{Exit-PoolQueue $lease $owner}
  };$jobs+=$job
  $deadline=[datetime]::UtcNow.AddSeconds(8)
  do{Start-Sleep -Milliseconds 100;$tickets=@(Get-ChildItem "$pool/queue" -Filter *.json|ForEach-Object {Get-Content $_.FullName -Raw|ConvertFrom-Json}|Where-Object ownerId -eq $owner)}while(!$tickets.Count -and [datetime]::UtcNow -lt $deadline)
  Assert ($tickets.Count -eq 1) "$owner registered exactly once"
 }
 Assert (!(Test-Path "$root/third-entered") -and !(Test-Path "$root/fourth-entered")) 'both busy tasks wait without duplicate launch'
 Exit-PoolQueue $a first;$leases=@($b)
 $deadline=[datetime]::UtcNow.AddSeconds(8)
 while(!(Test-Path "$root/third-entered") -and [datetime]::UtcNow -lt $deadline){Start-Sleep -Milliseconds 100}
 Assert ((Get-Content "$root/third-entered") -eq 'A' -and !(Test-Path "$root/fourth-entered")) 'oldest waiter receives released A; later task remains queued'
 [IO.File]::WriteAllText("$root/third-release",'go')
 $deadline=[datetime]::UtcNow.AddSeconds(8)
 while(!(Test-Path "$root/fourth-entered") -and [datetime]::UtcNow -lt $deadline){Start-Sleep -Milliseconds 100}
 Assert ((Get-Content "$root/fourth-entered") -eq 'A') 'next waiter automatically follows cleanup release'
 [IO.File]::WriteAllText("$root/fourth-release",'go')
 $null=$jobs|Wait-Job -Timeout 10;$jobs|Receive-Job -ErrorAction Stop
 Exit-PoolQueue $b second;$leases=@()
 $busy={param($pool,$environment) [pscustomobject]@{ProcessId=1;Name='human-game-sentinel'}}
 try{$null=Enter-PoolQueue -Root $pool -OwnerId preserved -MapPath dummy -WaitSeconds 1 -PollMilliseconds 100 -BusyProbe $busy;throw 'Expected deferral'}catch{Assert ($_.Exception.Message -match 'LAN_DEFERRED') 'manual/unknown occupancy defers without termination'}
 @{state='WAITING';requestedEnvironment='Auto';runnerPid=$PID;runnerCreationUtcTicks='1'}|ConvertTo-Json|Set-Content "$pool/queue/000-stale.json"
 $next=Enter-PoolQueue -Root $pool -OwnerId stale-check -MapPath dummy -Environment B -WaitSeconds 2 -BusyProbe {@()}
 Assert ($next.Environment -eq 'B') 'stale identity ignored and explicit environment honored'
 Exit-PoolQueue $next ''
 Write-Host "Synthetic queue evidence: $root; no game launched or terminated."
}finally{
 foreach($lease in $leases){Exit-PoolQueue $lease ''}
 foreach($job in $jobs){if($job.State -eq 'Running'){Stop-Job $job};Remove-Job $job}
}

# Regression for slot and process ID reuse. No process control in this fixture.
& {
$testDir=Join-Path ([IO.Path]::GetTempPath()) ('pool-identity-'+[guid]::NewGuid())
$null=New-Item -ItemType Directory -Path $testDir
$file=Join-Path $testDir 'context-LanP1.log'
try {
 $birth=[datetime]::UtcNow
 $slot=@{name='LanP1';pid=59608;creationUtcTicks=$birth.AddSeconds(-1).Ticks}
 $p=[pscustomobject]@{Name='war3.exe';ProcessId=50792;ParentProcessId=59608;ExecutablePath=$null;CreationDate=$birth}
 $exe='D:\pool\A\Game\war3.exe'
 function Expect([bool]$ok,[string]$label){if((Test-PoolClientIdentity $p $slot $testDir $exe) -ne $ok){throw $label};"PASS $label"}
 Expect $false 'unproven client preserved even with matching parent'
 "50792 100 POOL_IDENTITY_V1 $($birth.Ticks) $exe"|Set-Content $file
 Expect $true 'slot proves exact client with hidden CIM path'
 $p.ProcessId=23444
 Expect $false 'other session using same launcher PID preserved'
 $p.ProcessId=50792;$p.CreationDate=$birth.AddSeconds(1)
 Expect $false 'recycled game PID preserved'
 $p.CreationDate=$birth;$p.ExecutablePath='D:\Manual\war3.exe'
 Expect $false 'manual game path preserved'
 $p.ExecutablePath=$null;$slot.name='LanP2'
 Expect $false 'different slot preserved'
} finally {if(Test-Path $file){Remove-Item -LiteralPath $file};Remove-Item -LiteralPath $testDir}

}
