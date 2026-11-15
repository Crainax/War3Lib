param([int]$QueueTimeoutSeconds=600)
$ErrorActionPreference='Stop'
$root=$PSScriptRoot
$run=Join-Path $root ('sessions/queue-live-'+(Get-Date -Format 'yyyyMMdd-HHmmss'))
$null=New-Item -ItemType Directory -Path $run
$prefix='queue-live-'+[guid]::NewGuid().ToString('N').Substring(0,8)
$owners=@(($prefix+'-A'),($prefix+'-B'))
$wrapper=Join-Path $run 'runner.ps1'
@'
param([string]$Owner,[string]$Evidence,[int]$QueueSeconds)
$ErrorActionPreference='Stop'
$code=0
try {
 & D:/War3/Tools/LanTest/Start-LanTest.ps1 -MapPath D:/War3/Tools/LanTest/probes/parallel/Runtime-Two.w3x -Clients 2 -ProjectPath D:/War3/Library/War3Lib -LegacySizeCap -UseScriptSlots -Automated -OwnerId $Owner -QueueTimeoutSeconds $QueueSeconds -ClientLogDirectory 'D:/Program Files (x86)/Warcraft III Frozen Throne/War3Lib/日志' -CompletionPattern '\[UT_DONE\] ParallelProbe' -TimeoutSeconds 120
} catch { $code=1; Write-Output $_.Exception.ToString() }
finally { @{owner=$Owner;exitCode=$code;utc=[datetime]::UtcNow.ToString('o')} | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $Evidence ($Owner+'.exit.json')) -Encoding UTF8 }
exit $code
'@ | Set-Content -LiteralPath $wrapper -Encoding UTF8
$baseline=@(Get-CimInstance Win32_Process -Filter "Name = 'war3.exe' OR Name = 'ydhost.exe'" | Select-Object ProcessId,Name,CreationDate)
@{owners=$owners;baseline=$baseline;map='probes/parallel/Runtime-Two.w3x'} | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $run 'setup.json') -Encoding UTF8
Write-Host "Live evidence: $run"
$runners=@()
$shell=(Get-Process -Id $PID).Path
foreach($owner in $owners) {
 $args=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$wrapper+'"'),'-Owner',$owner,'-Evidence',('"'+$run+'"'),'-QueueSeconds',$QueueTimeoutSeconds)
 $runners+=Start-Process $shell -ArgumentList $args -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $run ($owner+'.stdout.log')) -RedirectStandardError (Join-Path $run ($owner+'.stderr.log'))
 # Establish A's queue registration before starting B; do not wait for admission.
 $registrationDeadline=[datetime]::UtcNow.AddSeconds(15)
 do {
  $registered=@(Get-ChildItem (Join-Path $root 'queue') -Filter '*.json' | ForEach-Object { try {Get-Content $_.FullName -Raw | ConvertFrom-Json} catch {} } | Where-Object ownerId -eq $owner)
  if($registered.Count){break}
  Start-Sleep -Milliseconds 100
 } while([datetime]::UtcNow -lt $registrationDeadline)
}
$last=''
do {
 $tickets=@(Get-ChildItem (Join-Path $root 'queue') -Filter '*.json' | ForEach-Object {try {Get-Content $_.FullName -Raw | ConvertFrom-Json} catch {}} | Where-Object ownerId -in $owners | Sort-Object id)
 $games=@(Get-CimInstance Win32_Process -Filter "Name = 'war3.exe' OR Name = 'ydhost.exe'" | Select-Object ProcessId,Name,CreationDate)
 $snapshot=@{utc=[datetime]::UtcNow.ToString('o');tickets=$tickets;games=$games}
 $snapshot | ConvertTo-Json -Depth 6 -Compress | Add-Content (Join-Path $run 'timeline.jsonl') -Encoding UTF8
 $state=($tickets | ForEach-Object {"$($_.ownerId)=$($_.state)"}) -join '; '
 if($state -ne $last){Write-Host $state;$last=$state}
 $exits=@(Get-ChildItem $run -Filter '*.exit.json')
 if($exits.Count -eq 2){break}
 Start-Sleep -Seconds 1
} while($true)
foreach($ticket in $tickets) {
 if($ticket.sessionPath) {
  Write-Host "Session $($ticket.ownerId): $($ticket.sessionPath)"
  Get-Content (Join-Path $ticket.sessionPath 'result.json') -Raw
  Get-Content (Join-Path $ticket.sessionPath 'cleanup.json') -Raw
 }
}
Get-Content (Join-Path $run '*.exit.json')
Write-Host "Completed evidence: $run"
$failed=@(Get-ChildItem $run -Filter '*.exit.json' | ForEach-Object {Get-Content $_.FullName -Raw | ConvertFrom-Json} | Where-Object exitCode -ne 0)
if($failed.Count){throw "Live runners failed; inspect $run"}
