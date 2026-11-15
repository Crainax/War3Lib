param([Parameter(Mandatory)][ValidateSet('A','B')][string]$Environment,
 [Parameter(Mandatory)][string]$MapPath,[Parameter(Mandatory)][string]$OwnerId,
 [ValidateRange(1,6)][int]$Clients=2,[int]$QueueTimeoutSeconds=600,[int]$TimeoutSeconds=120,
 [string]$CompletionPattern='\[UT_DONE\] ParallelProbe',[switch]$LegacySizeCap,[switch]$UseScriptSlots)
$ErrorActionPreference='Stop'
$base='D:/War3/tools/LanTest';$pool=Join-Path $base 'pool';$envRoot=Join-Path $pool $Environment
$e=Get-Content (Join-Path $envRoot 'environment.json') -Raw|ConvertFrom-Json
if([IO.Path]::GetFullPath($envRoot) -ine $e.root){throw 'Pool manifest root mismatch'}
if($e.game -ine (Join-Path $e.root 'Game') -or $e.we -ine (Join-Path $e.root 'WE') -or $e.registryHive -cne ('Software\CodexWar3Pool\'+$Environment)){throw 'Pool manifest isolation paths mismatch'}
$expectedUdp=if($Environment -eq 'A'){16112}else{16212}
if($e.udpPort -ne $expectedUdp -or $e.tcpPort -ne ($expectedUdp+1)){throw 'Pool manifest port mismatch'}
$service=New-Object -ComObject Schedule.Service;$service.Connect()
$task=$service.GetFolder('\').GetTask('Codex-War3-StopTest')
$encoded=($task.Definition.Actions.Item(1).Arguments -split '-EncodedCommand ')[1]
$worker=[Text.Encoding]::Unicode.GetString([Convert]::FromBase64String($encoded))
if(!$worker.Contains('D:\War3\tools\LanTest\pool\'+$Environment+'\Game\war3.exe')){throw 'Install the reviewed pool cleanup allowlist before launching a game.'}
. (Join-Path $base 'SessionQueue.ps1')
. (Join-Path $PSScriptRoot 'ProcessIdentity.ps1')
$busy={Get-PoolBusyProcesses -PoolRoot $pool -EnvironmentRoot $e.root}
$lease=Enter-LanQueue -Root $envRoot -OwnerId $OwnerId -MapPath $MapPath -WaitSeconds $QueueTimeoutSeconds -BusyProbe $busy
$session=$null;$m=$null;$launchers=@()
function Save-Manifest {$m|ConvertTo-Json -Depth 6|Set-Content (Join-Path $session 'session.json') -Encoding UTF8}
function Collect-Clients {
 foreach($launcher in $launchers){
  foreach($p in Get-CimInstance Win32_Process -Filter "Name = 'war3.exe'" | Where-Object {$_.ParentProcessId -eq $launcher.pid -and (!$_.ExecutablePath -or $_.ExecutablePath -ieq (Join-Path $e.game 'war3.exe')) -and $_.CreationDate.ToUniversalTime().Ticks -ge [long]$launcher.creationUtcTicks}){
   if($p.ProcessId -notin $m.clientPids){$m.clientPids+=([int]$p.ProcessId);$m.clientProcesses+=@{pid=[int]$p.ProcessId;creationUtcTicks=$p.CreationDate.ToUniversalTime().Ticks.ToString();expectedName=$launcher.name};Save-Manifest}
  }
 }
}
function Spawn-Pool([string]$Executable,[string]$Directory,[string]$Arguments,[string]$Player){
 $psi=[Diagnostics.ProcessStartInfo]::new((Join-Path $pool 'bin/pool_spawn.exe'))
 foreach($arg in @($Executable,$Directory,$Arguments)){$psi.ArgumentList.Add($arg)}
 $psi.UseShellExecute=$false;$psi.CreateNoWindow=$true;$psi.RedirectStandardOutput=$true;$psi.RedirectStandardError=$true
 $psi.Environment['WAR3_POOL_HIVE']=$e.registryHive;$psi.Environment['WAR3_POOL_GAME']=$e.game;$psi.Environment['WAR3_POOL_UDP']=[string]$e.udpPort
 $psi.Environment['WAR3_POOL_DLL']=Join-Path $pool 'bin/pool_context.dll';$psi.Environment['WAR3_POOL_EVIDENCE']=Join-Path $session ("context-$Player.log")
 $psi.Environment['WAR3_POOL_HOST_LOG']=Join-Path $session 'host-stdout.log'
 $psi.Environment['WAR3_POOL_ROOM']=$m.gameName
 $psi.Environment['WAR3_LAN_PLAYER']=$Player;$psi.Environment['WAR3_LAN_EVIDENCE']=Join-Path $session ("name-$Player.log")
 foreach($var in 'TEMP','TMP'){$psi.Environment[$var]=Join-Path $e.root 'Temp'}
 $psi.Environment['USERPROFILE']=Join-Path $e.root 'User';$psi.Environment['APPDATA']=Join-Path $e.root 'User/AppData/Roaming';$psi.Environment['LOCALAPPDATA']=Join-Path $e.root 'User/AppData/Local'
 $p=[Diagnostics.Process]::Start($psi);$output=$p.StandardOutput.ReadToEnd();$err=$p.StandardError.ReadToEnd();$p.WaitForExit()
 if($p.ExitCode -ne 0){throw "Pool bootstrap failed: $err"}
 $child=$output|ConvertFrom-Json
 return @{pid=[int]$child.pid;creationUtcTicks=$child.creationUtcTicks;name=$Player}
}
try {
 $map=(Resolve-Path -LiteralPath $MapPath).Path
 $id=(Get-Date -Format 'yyyyMMdd-HHmmss')+'-'+$Environment+'-'+[guid]::NewGuid().ToString('N').Substring(0,6)
 $session=Join-Path $e.root ('sessions/'+$id);$null=New-Item -ItemType Directory -Force $session
 $relative='Maps\Test\'+$id+'.w3x';$target=Join-Path $e.game $relative
 $m=[ordered]@{environment=$Environment;ownerId=$OwnerId;session=$session;sourceMap=$map;sha256=(Get-FileHash $map).Hash;startedUtc=[datetime]::UtcNow.ToString('o');clients=$Clients;gamePath=$e.game;wePath=$e.we;autoJoin=$true;gameName=('Pool-'+$id);hostPid=$null;hostCreationUtcTicks=$null;clientPids=@();clientProcesses=@();launchers=@();queueTicket=$lease.Ticket}
 Save-Manifest
 foreach($dir in 'User/AppData/Roaming','User/AppData/Local','User/Documents'){$null=New-Item -ItemType Directory -Force (Join-Path $e.root $dir)}
 foreach($file in 'ydhost.exe','vcruntime140.dll','msvcp140.dll'){Copy-Item (Join-Path $base "bin/$file") (Join-Path $e.root "bin/$file")}
 Copy-Item (Join-Path $base 'bin/lan_player_name.dll') (Join-Path $e.we 'plugin/warcraft3/lan_player_name.dll')
 Copy-Item (Join-Path $pool 'bin/pool_context.dll') (Join-Path $e.we 'plugin/warcraft3/zz_pool_context.dll')
 $cfg=Join-Path $e.we 'plugin/warcraft3/config.cfg';$text=Get-Content $cfg -Raw
 foreach($plugin in 'lan_player_name.dll','zz_pool_context.dll'){if($text -notmatch [regex]::Escape($plugin)){$text+="`r`n$plugin = 1"}}
 [IO.File]::WriteAllText($cfg,$text,[Text.UTF8Encoding]::new($false))
 $lua='D:/WE/YDWE1.32.13正式版';$mapCfg=Join-Path $session 'map.cfg'
 & (Join-Path $lua 'bin/lua.exe') (Join-Path $base 'map_config.lua') $lua $e.we $map $mapCfg $Clients ([int][bool]$UseScriptSlots)
 if($LASTEXITCODE -ne 0){throw 'Map configuration failed'}
 if($LegacySizeCap -and (Get-Item $map).Length -gt 8388607){$text=Get-Content $mapCfg -Raw;$text=[regex]::Replace($text,'(?m)^map_size = [^\r\n]+','map_size = 255 255 127 0');[IO.File]::WriteAllText($mapCfg,$text)}
 $auto=if($Clients -eq 1){1}else{2}
 "lan_war3version = 27`nbot_defaultgamename = $($m.gameName)`nbot_autostart = $auto`nbot_mappath = $relative`nbot_mapcfgpath = map.cfg`n"|Set-Content (Join-Path $session 'ydhost.cfg') -Encoding ascii
 Copy-Item $map $target
 $hostRecord=Spawn-Pool (Join-Path $e.root 'bin/ydhost.exe') $session '' host
 $m.hostPid=$hostRecord.pid;$m.hostCreationUtcTicks=$hostRecord.creationUtcTicks;Save-Manifest
 foreach($i in 1..$Clients){$record=Spawn-Pool (Join-Path $e.we 'bin/YDWEConfig.exe') $e.game '-launchwar3 -window -auto' "LanP$i";$launchers+=$record;$m.launchers+=$record;Save-Manifest}
 $deadline=[datetime]::UtcNow.AddSeconds(45)
 do {Collect-Clients;if($m.clientPids.Count -eq $Clients){break};Start-Sleep -Milliseconds 200}while([datetime]::UtcNow -lt $deadline)
 if($m.clientPids.Count -ne $Clients){throw 'Pool child discovery failed'}
 Write-Host "Pool $Environment session: $session"
 & (Join-Path $base 'Wait-LanTest.ps1') -SessionPath $session -ClientLogDirectory (Join-Path $e.game 'War3Lib/日志') -CompletionPattern $CompletionPattern -TimeoutSeconds $TimeoutSeconds
}catch{
 if($session -and !(Test-Path (Join-Path $session 'result.json'))){@{status='FAIL';message=$_.Exception.Message}|ConvertTo-Json|Set-Content (Join-Path $session 'result.json') -Encoding UTF8}
 throw
}finally{
 try{
  if($m){
   foreach($launcher in $launchers){$p=Get-CimInstance Win32_Process -Filter "ProcessId = $($launcher.pid)";if($p -and $p.CreationDate.ToUniversalTime().Ticks.ToString() -eq $launcher.creationUtcTicks){Stop-Process -Id $launcher.pid -Force -ErrorAction Continue}}
   try {Collect-Clients} finally {& (Join-Path $PSScriptRoot 'Stop-PoolTest.ps1') -SessionPath $session -OwnerId $OwnerId}
  }
 }finally{Exit-LanQueue $lease $session}
}
