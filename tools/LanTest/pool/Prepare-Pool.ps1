param([ValidateSet('A','B')][string[]]$Environment=@('A','B'),[string]$Root='D:/War3/tools/LanTest/pool',
 [string]$GameSource='D:/Program Files (x86)/Warcraft III Frozen Throne',[string]$WESource='D:/WE/KKWE_Plugin')
$ErrorActionPreference='Stop'
foreach($name in $Environment){
 $homePath=[IO.Path]::GetFullPath((Join-Path $Root $name))
 if(@(Get-CimInstance Win32_Process | Where-Object {$_.ExecutablePath -and $_.ExecutablePath.StartsWith($homePath+'\',[StringComparison]::OrdinalIgnoreCase)}).Count){throw "Pool $name is occupied; do not update it."}
 $null=New-Item -ItemType Directory -Force $homePath
 $lock=[IO.File]::Open((Join-Path $homePath 'session.lock'),'OpenOrCreate','ReadWrite','None')
 try {
  $game=Join-Path $homePath 'Game';$we=Join-Path $homePath 'WE'
  $null=New-Item -ItemType Directory -Force $game,$we,(Join-Path $homePath 'bin'),(Join-Path $homePath 'Temp'),(Join-Path $homePath 'CloudScripts')
  # Physical copies only: no junctions/hardlinks to the human environment.
  foreach($f in Get-ChildItem -LiteralPath $GameSource -File | Where-Object {$_.Extension -in '.dll','.exe','.mpq','.ini','.cfg'}) {
   $dest=Join-Path $game $f.Name
   if(!(Test-Path $dest) -or (Get-FileHash $dest).Hash -ne (Get-FileHash $f.FullName).Hash){Copy-Item -LiteralPath $f.FullName -Destination $dest}
  }
  # Warcraft's Miles audio providers are in redist, not beside mss32.dll.
  # Omitting these causes a modal sound-device warning before LAN auto-enter.
  & robocopy (Join-Path $GameSource 'redist') (Join-Path $game 'redist') /E /COPY:DAT /R:1 /W:1 /NFL /NDL /NJH /NJS /NP
  if($LASTEXITCODE -ge 8){throw 'Copy game audio providers failed'}
  foreach($dir in 'bin','plugin','share','jass') {
   & robocopy (Join-Path $WESource $dir) (Join-Path $we $dir) /E /COPY:DAT /R:1 /W:1 /NFL /NDL /NJH /NJS /NP
   if($LASTEXITCODE -ge 8){throw "Copy WE/$dir failed"}
  }
  foreach($dir in 'Maps/Test','Save','Replay','Logs','War3Lib/日志','XwSupport'){ $null=New-Item -ItemType Directory -Force (Join-Path $game $dir) }
  $cfg=Join-Path $we 'bin/EverConfig.cfg';$text=Get-Content $cfg -Raw
  $text=[regex]::Replace($text,'(?m)^UserName\s*=[^\r\n]*','UserName =')
  $text=[regex]::Replace($text,'(?m)^MlScriptFolder\s*=[^\r\n]*',('MlScriptFolder = '+(Join-Path $homePath 'CloudScripts')))
  $text=[regex]::Replace($text,'(?m)^LaunchLockingMouse\s*=[^\r\n]*','LaunchLockingMouse = 0')
  [IO.File]::WriteAllText($cfg,$text,[Text.UTF8Encoding]::new($false))
  $entry=Join-Path $homePath 'CloudScripts/main.lua'
  if(!(Test-Path $entry)){[IO.File]::WriteAllText($entry,'-- Isolated pool entry; project handlers must be copied explicitly.')}
  $hive='Software\CodexWar3Pool\'+$name
  $virtual=Join-Path ('HKCU:\'+$hive) 'Software\Blizzard Entertainment\Warcraft III'
  if(!(Test-Path $virtual)) {
   $null=New-Item -Path (Split-Path $virtual) -Force
   Copy-Item -LiteralPath 'HKCU:\Software\Blizzard Entertainment\Warcraft III' -Destination $virtual -Recurse
  }
  Set-ItemProperty -LiteralPath $virtual -Name InstallPath -Value $game
  $port=if($name -eq 'A'){16112}else{16212}
  @{schema=1;name=$name;root=$homePath;game=$game;we=$we;registryHive=$hive;udpPort=$port;tcpPort=($port+1);sourceGame=$GameSource;sourceWE=$WESource;validated=$false} | ConvertTo-Json | Set-Content (Join-Path $homePath 'environment.json') -Encoding UTF8
  Write-Host "Prepared independent files and registry: $name ($homePath)"
 } finally {$lock.Dispose()}
}
