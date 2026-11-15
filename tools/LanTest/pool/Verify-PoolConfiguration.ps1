$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'PoolConfiguration.ps1')
$root=Join-Path ([IO.Path]::GetTempPath()) ('war3-pool-config-'+[guid]::NewGuid().ToString('N'))
$source=Join-Path $root 'HumanGame';$project=Join-Path $root 'Project';$poolGame=Join-Path $root 'A/Game';$we=Join-Path $root 'A/WE'
$null=New-Item -ItemType Directory -Force $source,"$project/CloudScripts",$poolGame,"$we/bin","$root/session1","$root/session2"
function Assert($ok,$name){if(!$ok){throw $name};Write-Host "PASS: $name"}
[IO.File]::WriteAllText("$source/local_test_profile.lock",'')
[IO.File]::WriteAllText("$source/dz_w3_plugin.ini",'active human seed')
[IO.File]::WriteAllText("$source/kkapi_local_plugin.ini",'active human seed')
[IO.File]::WriteAllText("$source/dz_w3_plugin_Project.ini",'project seed')
@{owners=@{dz_w3_plugin='Other';kkapi_local_plugin='Other'}}|ConvertTo-Json|Set-Content "$source/local_test_profile.json"
[IO.File]::WriteAllText("$project/CloudScripts/main.lua",'-- project cloud source')
[IO.File]::WriteAllText("$we/bin/EverConfig.cfg","[MapTest]`nEnableMlScript = 0`nMlScriptFolder = human`n[Other]`nUserName = kept")
$e=@{game=$poolGame;we=$we;sourceGame=$source}
$a=Set-PoolProject $project $e "$root/session1"
Assert ((Get-Content "$poolGame/dz_w3_plugin.ini" -Raw) -eq 'project seed') 'project-specific seed selected instead of another active profile'
Assert ((Get-Content "$poolGame/kkapi_local_plugin.ini" -Raw) -match 'MLS-MsGetEnvType=-1') 'missing project seed initializes private local environment'
Assert ((Get-Content (Join-Path $a.cloudSnapshot 'main.lua') -Raw) -eq '-- project cloud source') 'cloud scripts copied to session snapshot'
[IO.File]::WriteAllText("$poolGame/dz_w3_plugin.ini",'modified by test')
$b=Set-PoolProject $project $e "$root/session2"
Assert ((Get-Content "$poolGame/dz_w3_plugin.ini" -Raw) -eq 'project seed') 'next task resets baseline instead of inheriting previous writes'
Assert ((Get-Content "$source/dz_w3_plugin.ini" -Raw) -eq 'active human seed' -and (Get-Content "$source/dz_w3_plugin_Project.ini" -Raw) -eq 'project seed') 'human and project seed files unchanged'
$mapped=Resolve-PoolLogDirectory "$source/War3Lib/日志" $source $poolGame
Assert ($mapped -eq [IO.Path]::GetFullPath("$poolGame/War3Lib/日志")) 'legacy absolute log path maps to private environment'
foreach($bad in @('../escape',"$root/foreign/logs")){
 $refused=$false;try{$null=Resolve-PoolLogDirectory $bad $source $poolGame}catch{$refused=$true}
 Assert $refused "foreign log path refused: $bad"
}
Write-Host "Synthetic configuration evidence: $root; human configuration not accessed."
