param([ValidateRange(1,86400)][int]$QueueTimeoutSeconds=3600)
$ErrorActionPreference='Stop'
$root='D:/War3/tools/LanTest'
$map=Join-Path $root 'probes/parallel/Runtime-Two.w3x'
$owner='war3-double-'+[guid]::NewGuid().ToString('N')
& (Join-Path $root 'Start-LanTest.ps1') -Automated -OwnerId $owner -MapPath $map -Clients 2 -ProjectPath (Split-Path $PSScriptRoot -Parent) -LegacySizeCap -UseScriptSlots -CompletionPattern '\[UT_DONE\] ParallelProbe local=P[12]' -TimeoutSeconds 150 -QueueTimeoutSeconds $QueueTimeoutSeconds
$tickets=@(Get-ChildItem (Join-Path $root 'pool/queue') -Filter '*.json' | ForEach-Object {Get-Content $_.FullName -Raw|ConvertFrom-Json} | Where-Object ownerId -eq $owner)
if($tickets.Count -ne 1 -or $tickets[0].state -ne 'FINISHED'){throw 'Missing completed queue ticket'}
$session=$tickets[0].sessionPath
function Read-Record($name){Get-Content -LiteralPath (Join-Path $session $name) -Raw|ConvertFrom-Json}
$manifest=Read-Record 'session.json'
$cleanup=Read-Record 'cleanup.json'
if($manifest.ownerId -ne $owner -or $cleanup.ownerId -ne $owner -or !$cleanup.success -or (Read-Record 'result.json').status -ne 'PASS'){throw 'Session or cleanup failed'}
foreach($player in 1,2){
    $logs=@(Get-ChildItem (Join-Path $session 'client-logs') -Filter "*-P$player.log")
    if($logs.Count -ne 1){throw "Expected one archived P$player log"}
    $log=Get-Content $logs[0].FullName -Raw
    foreach($mark in 'PASS: ParallelProbe humans=2','PASS: ParallelProbe unique LanP1','PASS: ParallelProbe unique LanP2',"[UT_DONE] ParallelProbe local=P$player"){
        if(!$log.Contains($mark)){throw "P$player missing $mark"}
    }
}
if(!(Read-Record 'map-cleanup.json').success -or (Test-Path $manifest.gameMap) -or (Test-Path (Split-Path $manifest.mapSnapshot))){throw 'Session map or queue snapshot remains'}
if((Get-FileHash -LiteralPath $map).Hash -ne $manifest.sha256){throw 'Probe source map changed'}
foreach($identity in @($manifest.clientProcesses)+@{pid=$manifest.hostPid;creationUtcTicks=$manifest.hostCreationUtcTicks}){
    $live=Get-CimInstance Win32_Process -Filter "ProcessId=$($identity.pid)"
    if($live -and $live.CreationDate.ToUniversalTime().Ticks.ToString() -eq $identity.creationUtcTicks){throw 'Owned process still running'}
}
Write-Output "PASS: both clients completed assertions, owned games and temporary maps cleaned. $session"
