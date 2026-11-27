param([ValidateSet('Auto','A','B')][string]$Environment='Auto',
 [Parameter(Mandatory)][string]$MapPath,[Parameter(Mandatory)][string]$OwnerId,
 [ValidateRange(1,6)][int]$Clients=2,[ValidateRange(1,86400)][int]$QueueTimeoutSeconds=3600,[ValidateRange(10,21660)][int]$TimeoutSeconds=120,
 [string]$CompletionPattern,[string]$VictoryPattern,[string]$DefeatPattern,[switch]$LegacySizeCap,[switch]$UseScriptSlots,
 [string]$ClientLogDirectory,[string]$ProjectPath,[string]$MapConfigOverride,[switch]$ManualJoin,
 [ValidateRange(0,120)][int]$SmokeSeconds=0,[switch]$ExpectMapExit,[ValidateRange(1,60)][int]$ExitObserveSeconds=10,
 [string]$LuaRuntime='D:/WE/YDWE1.32.13正式版',
 [ValidateSet('Direct3D 8','OpenGL')][string]$Renderer='Direct3D 8',
 [string]$RuntimeAdapter,[hashtable]$AdapterOptions=@{})
$ErrorActionPreference='Stop'
if($PSVersionTable.PSVersion.Major -lt 7){throw 'Pool runner requires PowerShell 7 (pwsh). Use the default Start-LanTest entry for automatic bridging.'}
if($SmokeSeconds -eq 0 -and !$CompletionPattern){throw 'Pool assertion tests require CompletionPattern; use SmokeSeconds for an explicitly labelled smoke run.'}
$base='D:/War3/tools/LanTest';$pool=Join-Path $base 'pool'
$map=(Resolve-Path -LiteralPath $MapPath).Path
if([IO.Path]::GetExtension($map) -notin '.w3x','.w3m'){throw 'Provide a packaged .w3x/.w3m map.'}
if($MapConfigOverride){$MapConfigOverride=(Resolve-Path $MapConfigOverride).Path}
if($RuntimeAdapter){$RuntimeAdapter=(Resolve-Path -LiteralPath $RuntimeAdapter).Path}
$waitArgs=@{CompletionPattern=$CompletionPattern;TimeoutSeconds=$TimeoutSeconds;SmokeSeconds=$SmokeSeconds}
if($VictoryPattern){$waitArgs.VictoryPattern=$VictoryPattern}
if($DefeatPattern){$waitArgs.DefeatPattern=$DefeatPattern}
if($ExpectMapExit){
 if($Clients -ne 1 -or $SmokeSeconds -ne 0){throw 'Expected map exit requires a one-client assertion run.'}
 if(!(Get-Command (Join-Path $base 'Wait-LanTest.ps1')).Parameters.ContainsKey('ExpectMapExit')){throw 'Installed Wait-LanTest does not support ExpectMapExit; no game launched.'}
 $waitArgs.ExpectMapExit=$true;$waitArgs.ExitObserveSeconds=$ExitObserveSeconds
}
$service=New-Object -ComObject Schedule.Service;$service.Connect()
$task=$service.GetFolder('\').GetTask('Codex-War3-StopTest')
$encoded=($task.Definition.Actions.Item(1).Arguments -split '-EncodedCommand ')[1]
$worker=[Text.Encoding]::Unicode.GetString([Convert]::FromBase64String($encoded))
$environments=@{}
foreach($name in 'A','B'){
 $root=Join-Path $pool $name;$config=Get-Content (Join-Path $root 'environment.json') -Raw|ConvertFrom-Json
 if([IO.Path]::GetFullPath($root) -ine $config.root -or $config.game -ine (Join-Path $config.root 'Game') -or $config.we -ine (Join-Path $config.root 'WE') -or $config.registryHive -cne ('Software\CodexWar3Pool\'+$name)){throw 'Pool manifest isolation paths mismatch'}
 $port=if($name -eq 'A'){16112}else{16212}
 if($config.udpPort -ne $port -or $config.tcpPort -ne ($port+1)){throw 'Pool manifest port mismatch'}
 if(!$worker.Contains('D:\War3\tools\LanTest\pool\'+$name+'\Game\war3.exe')){throw 'Install the reviewed pool cleanup allowlist before launching a game.'}
 $environments[$name]=$config
}
. (Join-Path $PSScriptRoot 'PoolQueue.ps1')
. (Join-Path $PSScriptRoot 'PoolConfiguration.ps1')
. (Join-Path $PSScriptRoot 'ProjectLogs.ps1')
if (!$ClientLogDirectory) { $ClientLogDirectory = Get-ProjectLogDirectory $ProjectPath }
# Resolve for both candidates before admission; never watch the human game's logs.
$logPaths=@{};$candidates=if($Environment -eq 'Auto'){@('A','B')}else{@($Environment)}
foreach($name in $candidates){$logPaths[$name]=Resolve-PoolLogDirectory $ClientLogDirectory $environments[$name].sourceGame $environments[$name].game}
. (Join-Path $PSScriptRoot 'MapSnapshot.ps1')
$sourceMap=$map
$snapshot=New-PoolMapSnapshot -Source $sourceMap -Root (Join-Path $pool 'snapshots') -OwnerId $OwnerId
$map=$snapshot.path
$lease=$null;$session=$null;$m=$null
try {
$lease=Enter-PoolQueue -Root $pool -OwnerId $OwnerId -MapPath $map -Environment $Environment -WaitSeconds $QueueTimeoutSeconds
$Environment=$lease.Environment;$e=$environments[$Environment]
$session=$null;$m=$null;$launchers=@()
function Save-Manifest {$m|ConvertTo-Json -Depth 6|Set-Content (Join-Path $session 'session.json') -Encoding UTF8}
function Collect-Clients {
 foreach($launcher in $launchers){
  if(@($m.clientProcesses | Where-Object expectedName -ceq $launcher.name).Count){continue}
  foreach($p in Get-CimInstance Win32_Process -Filter "Name = 'war3.exe' AND ParentProcessId = $($launcher.pid)"){
   if(!(Test-PoolClientIdentity $p $launcher $session (Join-Path $e.game 'war3.exe'))){continue}
   if($p.ProcessId -notin $m.clientPids){$m.clientPids+=([int]$p.ProcessId);$m.clientProcesses+=@{pid=[int]$p.ProcessId;creationUtcTicks=$p.CreationDate.ToUniversalTime().Ticks.ToString();expectedName=$launcher.name};Save-Manifest;break}
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
 $id=(Get-Date -Format 'yyyyMMdd-HHmmss')+'-'+$Environment+'-'+[guid]::NewGuid().ToString('N').Substring(0,6)
 $session=Join-Path $e.root ('sessions/'+$id);$null=New-Item -ItemType Directory -Force $session
 $relative='Maps\Test\'+$id+[IO.Path]::GetExtension($map);$target=Join-Path $e.game $relative
 $m=[ordered]@{environment=$Environment;ownerId=$OwnerId;automated=$true;runnerPid=$PID;session=$session;sourceMap=$sourceMap;mapSnapshot=$map;gameMap=$target;sha256=$snapshot.sha256;startedUtc=[datetime]::UtcNow.ToString('o');clients=$Clients;gamePath=$e.game;wePath=$e.we;clientLogDirectory=$logPaths[$Environment];autoJoin=(!$ManualJoin);gameName=('Pool-'+$id);hostPid=$null;hostCreationUtcTicks=$null;clientPids=@();clientProcesses=@();launchers=@();queueTicket=$lease.Ticket}
 Save-Manifest
 $m['projectConfiguration']=Set-PoolProject -ProjectPath $ProjectPath -Environment $e -Session $session -Renderer $Renderer
 $null=New-Item -ItemType Directory -Force $m.clientLogDirectory
 Save-Manifest
 if($RuntimeAdapter){
  if((Get-FileHash -LiteralPath $sourceMap).Hash -ne $snapshot.sha256){throw 'Adapter source changed while queued; frozen map preserved until cleanup'}
  & $RuntimeAdapter -Phase Prepare -SessionPath $session -GamePath $e.game -MapPath $sourceMap -Clients $Clients -Options $AdapterOptions
 }
 foreach($dir in 'User/AppData/Roaming','User/AppData/Local','User/Documents'){$null=New-Item -ItemType Directory -Force (Join-Path $e.root $dir)}
 foreach($file in 'ydhost.exe','vcruntime140.dll','msvcp140.dll'){Copy-Item (Join-Path $base "bin/$file") (Join-Path $e.root "bin/$file")}
 Copy-Item (Join-Path $base 'bin/lan_player_name.dll') (Join-Path $e.we 'plugin/warcraft3/lan_player_name.dll')
 Copy-Item (Join-Path $pool 'bin/pool_context.dll') (Join-Path $e.we 'plugin/warcraft3/zz_pool_context.dll')
 $cfg=Join-Path $e.we 'plugin/warcraft3/config.cfg';$text=Get-Content $cfg -Raw
 foreach($plugin in 'lan_player_name.dll','zz_pool_context.dll'){if($text -notmatch [regex]::Escape($plugin)){$text+="`r`n$plugin = 1"}}
 [IO.File]::WriteAllText($cfg,$text,[Text.UTF8Encoding]::new($false))
 $lua=$LuaRuntime;$mapCfg=Join-Path $session 'map.cfg'
 & (Join-Path $lua 'bin/lua.exe') (Join-Path $base 'map_config.lua') $lua $e.we $map $mapCfg $Clients ([int][bool]$UseScriptSlots)
 if($LASTEXITCODE -ne 0){throw 'Map configuration failed'}
 if($LegacySizeCap -and (Get-Item $map).Length -gt 8388607){$text=Get-Content $mapCfg -Raw;$text=[regex]::Replace($text,'(?m)^map_size = [^\r\n]+','map_size = 255 255 127 0');[IO.File]::WriteAllText($mapCfg,$text)}
 if($MapConfigOverride){Copy-Item -LiteralPath $MapConfigOverride -Destination $mapCfg}
 $auto=if($Clients -eq 1){1}else{2}
 "lan_war3version = 27`nbot_defaultgamename = $($m.gameName)`nbot_autostart = $auto`nbot_mappath = $relative`nbot_mapcfgpath = map.cfg`n"|Set-Content (Join-Path $session 'ydhost.cfg') -Encoding ascii
 Copy-Item $map $target
 $hostRecord=Spawn-Pool (Join-Path $e.root 'bin/ydhost.exe') $session '' host
 $m.hostPid=$hostRecord.pid;$m.hostCreationUtcTicks=$hostRecord.creationUtcTicks;Save-Manifest
 $arguments=if($ManualJoin){'-launchwar3 -window'}else{'-launchwar3 -window -auto'}
 foreach($i in 1..$Clients){$record=Spawn-Pool (Join-Path $e.we 'bin/YDWEConfig.exe') $e.game $arguments "LanP$i";$launchers+=$record;$m.launchers+=$record;Save-Manifest}
 $deadline=[datetime]::UtcNow.AddSeconds(45)
 do {Collect-Clients;if($m.clientPids.Count -eq $Clients){break};Start-Sleep -Milliseconds 200}while([datetime]::UtcNow -lt $deadline)
 if($m.clientPids.Count -ne $Clients){throw 'Pool child discovery failed'}
 Write-Host "Pool $Environment session: $session"
 if($RuntimeAdapter){& $RuntimeAdapter -Phase Ready -SessionPath $session -GamePath $e.game -MapPath $sourceMap -Clients $Clients -Options $AdapterOptions}
 & (Join-Path $base 'Wait-LanTest.ps1') -SessionPath $session -ClientLogDirectory $m.clientLogDirectory @waitArgs
}catch{
 if($session -and !(Test-Path (Join-Path $session 'result.json'))){@{status='FAIL';message=$_.Exception.Message}|ConvertTo-Json|Set-Content (Join-Path $session 'result.json') -Encoding UTF8}
 throw
}finally{
 try{
  if($m){
   try {
    foreach($launcher in $launchers){Stop-PoolRecordedProcess $launcher.pid $launcher.creationUtcTicks (Join-Path $e.we 'bin/YDWEConfig.exe')}
   } finally {
    try {Collect-Clients} finally {& (Join-Path $PSScriptRoot 'Stop-PoolTest.ps1') -SessionPath $session -OwnerId $OwnerId}
   }
  }
 }finally{
  try{if($RuntimeAdapter -and $session){
   try{& $RuntimeAdapter -Phase Finalize -SessionPath $session -GamePath $e.game -MapPath $sourceMap -Clients $Clients -Options $AdapterOptions}
   catch{
    @{status='FAIL';message=('Runtime adapter finalization failed: '+$_.Exception.Message)}|ConvertTo-Json|Set-Content (Join-Path $session 'result.json')
    throw
   }
  }}
  finally{
   try {if($m){$null=Remove-PoolSessionMap $m $session; Publish-PoolLogs $m $e}}
   finally{Exit-PoolQueue $lease $session}
  }
 }
}
} finally {
 $safe=(!$m -or ((Test-Path (Join-Path $session 'cleanup.json')) -and (Get-Content (Join-Path $session 'cleanup.json') -Raw|ConvertFrom-Json).success))
 if($safe){Remove-PoolMapSnapshot $snapshot (Join-Path $pool 'snapshots') $OwnerId}
 else{Write-Warning "Cleanup incomplete; frozen map retained: $($snapshot.path)"}
}
