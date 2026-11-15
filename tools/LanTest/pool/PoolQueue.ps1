# Allocation decisions are serialized briefly; environment leases live through cleanup.
. (Join-Path $PSScriptRoot 'ProcessIdentity.ps1')
function Write-PoolTicket([string]$Path,$Record){
 $temp=$Path+'.tmp'
 [IO.File]::WriteAllText($temp,($Record|ConvertTo-Json),[Text.UTF8Encoding]::new($false))
 # Move-Item -Force deletes the destination first on Windows. Use atomic
 # same-volume replacement so concurrent FIFO readers never miss a waiter.
 for($attempt=0;$attempt -lt 30;$attempt++){
  try{
   if([IO.File]::Exists($Path)){[IO.File]::Replace($temp,$Path,[NullString]::Value)}else{[IO.File]::Move($temp,$Path)}
   return
  }catch [IO.IOException]{if($attempt -eq 29){throw};Start-Sleep -Milliseconds 10}
 }
}
function Enter-PoolQueue {
 param([string]$Root,[string]$OwnerId,[string]$MapPath,
  [ValidateSet('Auto','A','B')][string]$Environment='Auto',[int]$WaitSeconds=3600,
  [int]$PollMilliseconds=500,
  [scriptblock]$BusyProbe={param($pool,$envRoot) Get-PoolBusyProcesses -PoolRoot $pool -EnvironmentRoot $envRoot})
 $Root=[IO.Path]::GetFullPath($Root)
 $dir=Join-Path $Root 'queue';$null=New-Item -ItemType Directory -Force $dir
 $self=Get-CimInstance Win32_Process -Filter "ProcessId = $PID"
 $id=[datetime]::UtcNow.Ticks.ToString('D19')+'-'+[guid]::NewGuid().ToString('N')
 $file=Join-Path $dir ($id+'.json')
 $record=[ordered]@{id=$id;ownerId=$OwnerId;runnerPid=$PID;runnerCreationUtcTicks=$self.CreationDate.ToUniversalTime().Ticks.ToString();map=$MapPath;requestedEnvironment=$Environment;environment=$null;state='WAITING';reason='';heartbeatUtc='';sessionPath=$null}
 function Save-PoolTicket {
  $record.heartbeatUtc=[datetime]::UtcNow.ToString('o');Write-PoolTicket $file $record
 }
 Save-PoolTicket
 $deadline=[datetime]::UtcNow.AddSeconds($WaitSeconds);$lastReason='';$envLock=$null;$legacyLock=$null
 try {
  do {
   $gate=$null;$reason='another allocator is deciding'
   try {
    try {$gate=[IO.File]::Open((Join-Path $Root 'allocation.lock'),'OpenOrCreate','ReadWrite','None')}catch [IO.IOException]{}
    if($gate){
     # Shared read leases let A/B overlap, while the legacy exclusive lock
     # prevents an old/manual launcher racing the pool's pre-spawn interval.
     try {$legacyLock=[IO.File]::Open((Join-Path (Split-Path $Root) 'session.lock'),'OpenOrCreate','Read','Read')}catch [IO.IOException]{}
     if(!$legacyLock){$reason='legacy environment owns session.lock'}
     $ahead=@()
     foreach($ticket in Get-ChildItem $dir -Filter '*.json'|Sort-Object Name){
      if($ticket.Name -ge ($id+'.json')){break}
      try {$r=Get-Content $ticket.FullName -Raw|ConvertFrom-Json}catch {$ahead+=@{requestedEnvironment='Auto'};continue}
      if($r.state -ne 'WAITING'){continue}
      $p=Get-CimInstance Win32_Process -Filter "ProcessId = $($r.runnerPid)"
      if($p -and $p.CreationDate.ToUniversalTime().Ticks.ToString() -eq $r.runnerCreationUtcTicks){$ahead+=$r}
     }
     $candidates=if($Environment -eq 'Auto'){@('A','B')}else{@($Environment)}
     $reason='requested environments occupied; existing processes preserved'
     foreach($name in $candidates){
      if(!$legacyLock){break}
      if(@($ahead|Where-Object {$_.requestedEnvironment -eq 'Auto' -or $_.requestedEnvironment -eq $name}).Count){$reason='earlier compatible task waiting';continue}
      $envRoot=Join-Path $Root $name
      try {$envLock=[IO.File]::Open((Join-Path $envRoot 'session.lock'),'OpenOrCreate','ReadWrite','None')}catch [IO.IOException]{continue}
      if(@(& $BusyProbe $Root $envRoot).Count){$envLock.Dispose();$envLock=$null;continue}
      $record.state='RUNNING';$record.environment=$name;$record.reason='admitted';Save-PoolTicket
      Write-Host "[LAN pool] allocated $name; owner=$OwnerId; ticket=$id"
      return @{Lock=$envLock;LegacyLock=$legacyLock;Ticket=$file;Id=$id;OwnerId=$OwnerId;Environment=$name}
     }
    }
    if($legacyLock){$legacyLock.Dispose();$legacyLock=$null}
   }finally{if($gate){$gate.Dispose()}}
   $record.reason=$reason;Save-PoolTicket
   if($reason -ne $lastReason){Write-Host "[LAN pool] waiting: $reason; ticket=$id";$lastReason=$reason}
   if([datetime]::UtcNow -ge $deadline){break}
   Start-Sleep -Milliseconds $PollMilliseconds
  }while($true)
  $record.state='DEFERRED';$record.reason='Queue deadline reached; no existing game was stopped';Save-PoolTicket
  throw "LAN_DEFERRED: pool queue deadline reached. Existing games preserved. Ticket: $file"
 }catch{
  if($envLock){$envLock.Dispose()}
  if($legacyLock){$legacyLock.Dispose()}
  if($record.state -in 'WAITING','RUNNING'){$record.state='CANCELLED';Save-PoolTicket}
  throw
 }
}
function Exit-PoolQueue($Lease,[string]$SessionPath){
 if(!$Lease){return}
 try {
  $r=Get-Content $Lease.Ticket -Raw|ConvertFrom-Json
  $r.state='FINISHED';$r.sessionPath=$SessionPath;$r.heartbeatUtc=[datetime]::UtcNow.ToString('o')
  Write-PoolTicket $Lease.Ticket $r
 }finally{$Lease.Lock.Dispose();$Lease.LegacyLock.Dispose()}
}
