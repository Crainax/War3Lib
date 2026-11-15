param([Parameter(Mandatory)][string]$SessionPath,[Parameter(Mandatory)][string]$OwnerId)
$ErrorActionPreference='Stop'
$m=Get-Content (Join-Path $SessionPath 'session.json') -Raw|ConvertFrom-Json
if($m.ownerId -cne $OwnerId){throw 'Session owner mismatch; no process was stopped.'}
if($m.environment -notin @('A','B')){throw 'Unknown pool environment'}
$root='D:\War3\tools\LanTest\pool\'+$m.environment
$errors=@()
foreach($c in $m.clientProcesses){
 try {
  $p=Get-CimInstance Win32_Process -Filter "ProcessId = $($c.pid)"
  if(!$p){continue}
  if(($p.ExecutablePath -and $p.ExecutablePath -ine (Join-Path $root 'Game/war3.exe')) -or $p.CreationDate.ToUniversalTime().Ticks.ToString() -ne $c.creationUtcTicks){throw 'Client identity changed; preserved.'}
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:/Users/41399/.codex/tools/war3-test-control/Stop-Test.ps1 -TestProcessId $c.pid -CreationUtcTicks $c.creationUtcTicks
  if($LASTEXITCODE -ne 0){throw "Client $($c.pid) cleanup failed"}
 }catch{$errors+=$_.Exception.Message}
}
if($m.hostPid){try{
 $p=Get-CimInstance Win32_Process -Filter "ProcessId = $($m.hostPid)"
 if($p){
  if($p.ExecutablePath -ine (Join-Path $root 'bin/ydhost.exe') -or $p.CreationDate.ToUniversalTime().Ticks.ToString() -ne $m.hostCreationUtcTicks){throw 'Host identity changed; preserved.'}
  Stop-Process -Id $m.hostPid -Force -ErrorAction Stop
 }
}catch{$errors+=$_.Exception.Message}}
@{utc=[datetime]::UtcNow.ToString('o');ownerId=$OwnerId;success=($errors.Count -eq 0);errors=$errors}|ConvertTo-Json|Set-Content (Join-Path $SessionPath 'cleanup.json') -Encoding UTF8
if($errors.Count){throw ($errors -join '; ')}
