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
function Get-PoolBusyProcesses([string]$PoolRoot,[string]$EnvironmentRoot){
 $games=@(Get-CimInstance Win32_Process | Where-Object Name -in 'war3.exe','ydhost.exe','YDWEConfig.exe')
 foreach($p in $games){
  $path=$p.ExecutablePath
  if(!$path){$path=[LanPoolProcessPath]::Read([int]$p.ProcessId)}
  if($path){if($path.StartsWith($EnvironmentRoot+'\',[StringComparison]::OrdinalIgnoreCase)){$p};continue}
  # Some KKWE builds hide image paths. Only exact recorded PID/creation identity
  # can classify such a process as belonging to the other pool; unknown stays busy.
  $knownRoot=$null
  foreach($name in 'A','B'){
   $sessions=Join-Path $PoolRoot "$name/sessions"
   if(!(Test-Path $sessions)){continue}
   foreach($file in Get-ChildItem $sessions -Filter session.json -Recurse){
    try{$m=Get-Content $file.FullName -Raw|ConvertFrom-Json}catch{continue}
    foreach($c in @($m.clientProcesses)+@($m.launchers)){
     if($c.pid -eq $p.ProcessId -and $c.creationUtcTicks -eq $p.CreationDate.ToUniversalTime().Ticks.ToString()){$knownRoot=Join-Path $PoolRoot $name;break}
    }
    if($knownRoot){break}
   }
   if($knownRoot){break}
  }
  if(!$knownRoot -or $knownRoot -ieq $EnvironmentRoot){$p}
 }
}
