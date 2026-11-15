$ErrorActionPreference='Stop'
$root='D:\War3\tools\LanTest\pool'
$realKey='HKCU:\Software\Blizzard Entertainment\Warcraft III'
$before=Get-ItemProperty $realKey|Select-Object InstallPath,PoolIsolationProbe|ConvertTo-Json -Compress
$checks=@()
foreach($name in 'A','B'){
 $e=Get-Content (Join-Path $root "$name/environment.json") -Raw|ConvertFrom-Json
 $psi=[Diagnostics.ProcessStartInfo]::new((Join-Path $root 'bin/pool_spawn.exe'))
 $psi.UseShellExecute=$false;$psi.CreateNoWindow=$true;$psi.RedirectStandardOutput=$true;$psi.RedirectStandardError=$true
 foreach($arg in @((Join-Path $root 'bin/pool_probe.exe'),$e.game,'probe')){$psi.ArgumentList.Add($arg)}
 $output=Join-Path $e.root ('probe-'+[guid]::NewGuid().ToString('N')+'.json')
 $psi.Environment['WAR3_POOL_HIVE']=$e.registryHive;$psi.Environment['WAR3_POOL_GAME']=$e.game;$psi.Environment['WAR3_POOL_UDP']=[string]$e.udpPort
 $psi.Environment['WAR3_POOL_DLL']=Join-Path $root 'bin/pool_context.dll';$psi.Environment['WAR3_POOL_EVIDENCE']=Join-Path $e.root 'probe-context.log';$psi.Environment['WAR3_POOL_PROBE_OUTPUT']=$output
 $psi.Environment['WAR3_POOL_ROOM']='expected-room'
 $p=[Diagnostics.Process]::Start($psi);$stdout=$p.StandardOutput.ReadToEnd();$stderr=$p.StandardError.ReadToEnd();$p.WaitForExit()
 if($p.ExitCode -ne 0){throw "Probe bootstrap failed: $stderr"}
 $deadline=[datetime]::UtcNow.AddSeconds(10)
 while(!(Test-Path $output) -and [datetime]::UtcNow -lt $deadline){Start-Sleep -Milliseconds 100}
 $result=Get-Content $output -Raw|ConvertFrom-Json
 if(!$result.registry -or !$result.machineGameKey -or !$result.port -or $result.actualPort -ne $e.udpPort -or !$result.foreignRoomRejected -or !$result.targetRoomAccepted){throw "Pool $name isolation probe failed"}
 $checks+=@{environment=$name;result=$result;evidence=$output}
}
$after=Get-ItemProperty $realKey|Select-Object InstallPath,PoolIsolationProbe|ConvertTo-Json -Compress
if($before -cne $after){throw 'Human registry changed during probes'}
@{checks=$checks;humanRegistryUnchanged=$true;utc=[datetime]::UtcNow.ToString('o')}|ConvertTo-Json -Depth 5|Set-Content (Join-Path $root 'isolation-probes.json') -Encoding UTF8
Write-Host 'PASS: A/B registry reads and writes isolated; machine Warcraft keys redirected; system Winsock works; distinct UDP ports; human registry unchanged.'
