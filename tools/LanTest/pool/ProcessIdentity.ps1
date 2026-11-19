if(!('LanPoolProcessPath' -as [type])){
 Add-Type @'
using System;
using System.Text;
using System.Runtime.InteropServices;
public static class LanPoolProcessPath {
 [DllImport("kernel32.dll", SetLastError=true)] static extern IntPtr OpenProcess(uint access,bool inherit,int pid);
 [DllImport("kernel32.dll", CharSet=CharSet.Unicode,SetLastError=true)] static extern bool QueryFullProcessImageName(IntPtr process,uint flags,StringBuilder path,ref int length);
 [DllImport("kernel32.dll")] static extern bool CloseHandle(IntPtr handle);
 public static string Read(int pid){var h=OpenProcess(0x1000,false,pid);if(h==IntPtr.Zero)return null;try{var b=new StringBuilder(32768);int n=b.Capacity;return QueryFullProcessImageName(h,0,b,ref n)?b.ToString():null;}finally{CloseHandle(h);}}
}
'@
}
# Accept a client only when its own slot recorded this exact live process instance.
function Test-PoolClientIdentity($Process,$Launcher,[string]$Session,[string]$GameExe) {
 if (!$Process -or !$Launcher -or $Launcher.name -cnotmatch '^LanP[1-6]$' -or
     $Process.Name -ine 'war3.exe' -or $Process.ParentProcessId -ne $Launcher.pid) {return $false}
 $ticks=$Process.CreationDate.ToUniversalTime().Ticks
 if ($ticks -lt [long]$Launcher.creationUtcTicks -or ($Process.ExecutablePath -and $Process.ExecutablePath -ine $GameExe)) {return $false}
 $file=Join-Path $Session ("context-"+$Launcher.name+".log")
 if (!(Test-Path -LiteralPath $file -PathType Leaf)) {return $false}
 $pattern='^'+$Process.ProcessId+' [0-9]+ POOL_IDENTITY_V1 '+$ticks+' '+[regex]::Escape($GameExe)+'$'
 return [bool](Select-String -LiteralPath $file -Encoding utf8 -Pattern $pattern -Quiet -ErrorAction SilentlyContinue)
}

# Pin the process handle before comparing times so PID reuse cannot race the stop.
function Stop-PoolRecordedProcess([int]$ProcessId,[long]$CreationTicks,[string]$ExpectedPath) {
 $proc=Get-Process -Id $ProcessId -ErrorAction SilentlyContinue
 if (!$proc) {return}
 try {
  $null=$proc.Handle
  $ticks=$proc.StartTime.ToUniversalTime().Ticks
  if (($ticks-($ticks%10)) -ne $CreationTicks -or $proc.Path -ine $ExpectedPath) {throw 'Process identity changed; preserved.'}
  $proc.Kill()
  if (!$proc.WaitForExit(5000)) {throw 'Owned process did not exit.'}
 } finally {$proc.Dispose()}
}
function Get-PoolBusyProcesses([string]$PoolRoot,[string]$EnvironmentRoot){
 $games=@(Get-CimInstance Win32_Process | Where-Object Name -in 'war3.exe','ydhost.exe','YDWEConfig.exe')
 foreach($p in $games){
  $path=$p.ExecutablePath
  if(!$path){$path=[LanPoolProcessPath]::Read([int]$p.ProcessId)}
  if($path){
   # Only a known OTHER pool can run concurrently. Manual/legacy/outside paths
   # remain conservative blockers until human-game coexistence is accepted.
   $other=if((Split-Path $EnvironmentRoot -Leaf) -eq 'A'){'B'}else{'A'}
   $otherRoot=[IO.Path]::GetFullPath((Join-Path $PoolRoot $other))+'\'
   if(!$path.StartsWith($otherRoot,[StringComparison]::OrdinalIgnoreCase)){$p}
   continue
  }
  # Some KKWE builds hide image paths. Only exact recorded PID/creation identity
  # can classify such a process as belonging to the other pool; unknown stays busy.
  $knownRoot=$null
  foreach($name in 'A','B'){
   $sessions=Join-Path $PoolRoot "$name/sessions"
   if(!(Test-Path $sessions)){continue}
   foreach($file in Get-ChildItem $sessions -Filter session.json -Recurse){
    try{$m=Get-Content $file.FullName -Raw|ConvertFrom-Json}catch{continue}
    foreach($c in @($m.clientProcesses)+@($m.launchers)){
     if($c.pid -ne $p.ProcessId -or $c.creationUtcTicks -ne $p.CreationDate.ToUniversalTime().Ticks.ToString()){continue}
     if($p.Name -ieq 'war3.exe'){
      $slot=@($m.launchers | Where-Object name -ceq $c.expectedName)
      if($slot.Count -ne 1 -or !(Test-PoolClientIdentity $p $slot[0] $file.DirectoryName (Join-Path $PoolRoot "$name/Game/war3.exe"))){continue}
     }elseif($p.Name -ine 'YDWEConfig.exe' -or !$c.name){continue}
     $knownRoot=Join-Path $PoolRoot $name;break
    }
    if($knownRoot){break}
   }
   if($knownRoot){break}
  }
  if(!$knownRoot -or $knownRoot -ieq $EnvironmentRoot){$p}
 }
}
