function Resolve-PoolLogDirectory([string]$Directory,[string]$SourceGame,[string]$PoolGame){
 if(!$Directory){return (Join-Path $PoolGame 'War3Lib/日志')}
 $pool=[IO.Path]::GetFullPath($PoolGame).TrimEnd('\','/')
 $source=[IO.Path]::GetFullPath($SourceGame).TrimEnd('\','/')
 if([IO.Path]::IsPathRooted($Directory)){
  $full=[IO.Path]::GetFullPath($Directory).TrimEnd('\','/')
  if($full.StartsWith($source+'\',[StringComparison]::OrdinalIgnoreCase)){$relative=$full.Substring($source.Length+1)}
  elseif($full.StartsWith($pool+'\',[StringComparison]::OrdinalIgnoreCase)){$relative=$full.Substring($pool.Length+1)}
  else{throw 'ClientLogDirectory must be relative to the game directory or under the original/selected game directory.'}
 }else{$relative=$Directory}
 $target=[IO.Path]::GetFullPath((Join-Path $pool $relative))
 if(!$target.StartsWith($pool+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'Client log path escapes the selected pool game directory.'}
 return $target
}
function Set-PoolProject([string]$ProjectPath,$Environment,[string]$Session){
 # Snapshot cloud sources per session; never alter the checkout or human INIs.
 # Automatic tests snapshot the project's local-archive baseline each run,
 # avoiding A/B selection changing initial state or cross-task contamination.
 $cloud=Join-Path $Session 'CloudScripts';$null=New-Item -ItemType Directory $cloud
 if($ProjectPath){
  $project=(Resolve-Path -LiteralPath $ProjectPath).Path
  $id=Split-Path $project -Leaf
  if($id -notmatch '^[A-Za-z0-9_-]+$'){throw 'Invalid project profile name'}
  $source=Join-Path $project 'CloudScripts'
  if(Test-Path $source){
   if((Get-Item $source).Attributes -band [IO.FileAttributes]::ReparsePoint){throw 'CloudScripts root must not be a link'}
   if(@(Get-ChildItem $source -Recurse -Force|Where-Object {$_.Attributes -band [IO.FileAttributes]::ReparsePoint}).Count){throw 'CloudScripts links would escape the private snapshot'}
   Get-ChildItem $source -Force | Copy-Item -Destination $cloud -Recurse -Force
  }
 }else{$id='Standalone'}
 $entry=Join-Path $cloud 'main.lua'
 if(!(Test-Path $entry)){[IO.File]::WriteAllText($entry,'-- Empty private test cloud entry.')}
 # Shared profile switcher is intentionally not called: it switches the human
 # environment and blocks on every running game. Pool seeds stay private.
 $seeds=@{};$sourceGame=$Environment.sourceGame
 $guard=[IO.File]::Open((Join-Path $sourceGame 'local_test_profile.lock'),'OpenOrCreate','Read','Read')
 try{
  $statePath=Join-Path $sourceGame 'local_test_profile.json';$state=$null
  if(Test-Path $statePath){$state=Get-Content $statePath -Raw|ConvertFrom-Json}
  if(Test-Path (Join-Path $sourceGame 'local_test_profile.transaction.json')){throw 'Source local profile has an unresolved transaction; preserved.'}
  foreach($name in 'dz_w3_plugin','kkapi_local_plugin'){
   $seed=Join-Path $sourceGame ($name+'_'+$id+'.ini')
   if(!$ProjectPath -or ($state -and $state.owners.$name -eq $id)){$seed=Join-Path $sourceGame ($name+'.ini')}
   $target=Join-Path $Environment.game ($name+'.ini')
   if(Test-Path $seed){Copy-Item -LiteralPath $seed -Destination $target;$seeds[$name]=@{path=$seed;sha256=(Get-FileHash $target).Hash}}
   else{
    $content="[DzAPI]`r`n";if($name -eq 'kkapi_local_plugin'){$content+="MLS-MsGetEnvType=-1`r`n"}
    [IO.File]::WriteAllText($target,$content,[Text.UTF8Encoding]::new($false));$seeds[$name]=@{path=$null;sha256=(Get-FileHash $target).Hash}
   }
  }
 }finally{$guard.Dispose()}
 $config=Join-Path $Environment.we 'bin/EverConfig.cfg';$text=Get-Content $config -Raw
 $lines=[Collections.Generic.List[string]]::new();$inside=$false;$found=$false
 foreach($line in $text -split '\r?\n'){
  if($line -match '^\s*\[([^\]]+)\]'){
   $inside=$Matches[1] -eq 'MapTest';$lines.Add($line)
   if($inside){if($found){throw 'Duplicate MapTest section'};$found=$true;$lines.Add('EnableMlScript = 1');$lines.Add('MlScriptFolder = '+$cloud)}
  }elseif(!($inside -and $line -match '^\s*(EnableMlScript|MlScriptFolder)\s*=')){$lines.Add($line)}
 }
 if(!$found){throw 'Missing MapTest section in private WE config'}
 [IO.File]::WriteAllText($config,($lines -join "`r`n"),[Text.UTF8Encoding]::new($false))
 return @{project=$ProjectPath;profile=$id;cloudSnapshot=$cloud;archiveMode='source-snapshot-no-writeback';seeds=$seeds}
}
