$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'LocalTestProfile.ps1')
function Get-RunningProfileGame {}
$testRoot=Join-Path $env:TEMP ('war3-profile-test-'+[char]0x6D4B+[guid]::NewGuid().ToString('N'))
$game=Join-Path $testRoot 'game'; $we=Join-Path $testRoot 'we'
New-Item -ItemType Directory -Path $game,(Join-Path $we 'bin') -Force | Out-Null
$cfg=Join-Path $we 'bin/EverConfig.cfg'
Write-ProfileText $cfg "[Other]`r`nKeep=1`r`n[MapTest]`r`nEnableMlScript=0`r`nMlScriptFolder=old`r`nWindow=1`r`n"
$state=@{version=1;owners=@{};hashes=@{}}
$originalHashes=@{}
foreach($name in $script:ProfileIniNames){
 $active=Join-Path $game ($name+'.ini')
 Write-ProfileText $active ("[DzAPI]`r`nOriginal=42`r`nChinese="+[char]0x6676+[char]0x77F3+"`r`nLong="+('z'*20000)+"`r`n")
 Copy-Item $active (Join-Path $game ($name+'_War3Lib.ini'))
 $state.owners[$name]='War3Lib';$state.hashes[$name]=Get-ProfileHash $active
 $originalHashes[$name]=Get-ProfileHash $active
}
Write-ProfileText (Join-Path $game 'local_test_profile.json') ($state|ConvertTo-Json)
$x=Join-Path $testRoot 'Xlimon';$w=Join-Path $testRoot 'War3Lib';$lh=Join-Path $testRoot 'LH'
Switch-LocalTestProfile $x $game $we
foreach($name in $script:ProfileIniNames){
 $active=Join-Path $game ($name+'.ini')
 if((Get-Content $active -Raw) -match 'Original'){throw 'Leaked old archive'}
 Add-Content $active 'GameWrite=189'
}
Switch-LocalTestProfile $w $game $we
foreach($name in $script:ProfileIniNames){
 if((Get-Content (Join-Path $game ($name+'_Xlimon.ini')) -Raw) -notmatch 'GameWrite=189'){throw 'Lost game write'}
 if((Get-ProfileHash (Join-Path $game ($name+'.ini'))) -ne $originalHashes[$name]){throw 'Lost original bytes (including Unicode and long content)'}
}
# Project file edits survive when active file did not change.
Add-Content (Join-Path $game 'dz_w3_plugin_War3Lib.ini') 'ManualEdit=1'
Switch-LocalTestProfile $w $game $we
if((Get-Content (Join-Path $game 'dz_w3_plugin.ini') -Raw) -notmatch 'ManualEdit=1'){throw 'Lost project edit'}
$stamp=[datetime]::UtcNow.AddDays(-1)
foreach($name in $script:ProfileIniNames){
 $active=Join-Path $game ($name+'.ini')
 $saved=Join-Path $game ($name+'_War3Lib.ini')
 Write-ProfileText $active 'game edit'
 Write-ProfileText $saved 'project edit'
 [IO.File]::SetLastWriteTimeUtc($active,$stamp)
 $offset=if($name -eq 'dz_w3_plugin'){-5}else{5}
 [IO.File]::SetLastWriteTimeUtc($saved,$stamp.AddMinutes($offset))
}
Switch-LocalTestProfile $lh $game $we
foreach($name in $script:ProfileIniNames){
 $expected=if($name -eq 'dz_w3_plugin'){'game edit'}else{'project edit'}
 if([IO.File]::ReadAllText((Join-Path $game ($name+'_War3Lib.ini'))) -ne $expected){throw "Wrong outgoing winner: $name"}
 if([IO.File]::ReadAllText((Join-Path $game ($name+'.ini'))) -match 'edit'){throw 'Outgoing edit leaked into LH'}
}
$active=Join-Path $game 'dz_w3_plugin.ini'
$saved=Join-Path $game 'dz_w3_plugin_LH.ini'
foreach($offset in 5,0){
 Write-ProfileText $active "game $offset"
 Write-ProfileText $saved "project $offset"
 [IO.File]::SetLastWriteTimeUtc($active,$stamp)
 [IO.File]::SetLastWriteTimeUtc($saved,$stamp.AddMinutes($offset))
 Switch-LocalTestProfile $lh $game $we
 $expected=if($offset){"project $offset"}else{"game $offset"}
 if([IO.File]::ReadAllText($active) -ne $expected -or [IO.File]::ReadAllText($saved) -ne $expected){throw "Wrong same-project winner: $offset"}
}
if(!(Test-Path (Join-Path $lh 'CloudScripts/main.lua'))){throw 'Missing empty entry'}
if((Get-Content $cfg -Raw) -notmatch 'Keep=1' -or (Get-Content $cfg -Raw) -notmatch 'Window=1'){throw 'Other config lost'}
if(Test-Path (Join-Path $game 'local_test_profile.transaction.json')){throw 'Journal leaked'}
# Deterministic interrupted-transaction recovery.
$active=Join-Path $game 'dz_w3_plugin.ini';$bytes=[IO.File]::ReadAllBytes($active)
$journal=Join-Path $game 'local_test_profile.transaction.json'
Write-ProfileText $journal (ConvertTo-Json -InputObject @(@{path=$active;existed=$true;data=[Convert]::ToBase64String($bytes);afterHash=(Get-ProfileBytesHash ([Text.Encoding]::UTF8.GetBytes('partial write')))}))
Write-ProfileText $active 'partial write'
Switch-LocalTestProfile $lh $game $we
if([Convert]::ToBase64String([IO.File]::ReadAllBytes($active)) -ne [Convert]::ToBase64String($bytes)){throw 'Recovery failed'}
# Newer data must block recovery before ANY record is restored.
$other=Join-Path $game 'kkapi_local_plugin.ini'
$oldOther=[IO.File]::ReadAllBytes($other)
Write-ProfileText $active 'newer-player-data'
Write-ProfileText $other 'transaction-write'
$records=@(
 @{path=$other;existed=$true;data=[Convert]::ToBase64String($oldOther);afterHash=(Get-ProfileHash $other)},
 @{path=$active;existed=$true;data=[Convert]::ToBase64String($bytes);afterHash=(Get-ProfileBytesHash ([Text.Encoding]::UTF8.GetBytes('transaction-write')))}
)
Write-ProfileText $journal (ConvertTo-Json -InputObject $records)
$blocked=$false
try { Restore-ProfileTransaction $journal } catch { if($_ -match 'Recovery conflict'){$blocked=$true}else{throw} }
if(!$blocked -or [IO.File]::ReadAllText($active) -ne 'newer-player-data' -or [IO.File]::ReadAllText($other) -ne 'transaction-write' -or !(Test-Path $journal)){throw 'Recovery overwrote newer data or partially restored'}
# Legacy journals lack an after-image: uncertain data must also remain untouched.
$records[1].Remove('afterHash')
Write-ProfileText $journal (ConvertTo-Json -InputObject $records)
$blocked=$false
try { Restore-ProfileTransaction $journal } catch { if($_ -match 'Recovery conflict'){$blocked=$true}else{throw} }
if(!$blocked -or [IO.File]::ReadAllText($active) -ne 'newer-player-data'){throw 'Unsafe legacy recovery'}
Remove-Item -LiteralPath $journal
Write-ProfileBytes $active $bytes
Write-ProfileBytes $other $oldOther
# Interrupted recovery is idempotent: one record already restored, another at after-image.
Write-ProfileText $other 'transaction-write'
$records[1].afterHash=Get-ProfileBytesHash ([Text.Encoding]::UTF8.GetBytes('transaction-write'))
Write-ProfileText $journal (ConvertTo-Json -InputObject $records)
Restore-ProfileTransaction $journal
if((Get-ProfileHash $other) -ne (Get-ProfileBytesHash $oldOther)){throw 'Interrupted recovery failed'}
# Missing outgoing copy is reconstructed from the latest active data, not treated as conflict.
Remove-Item -LiteralPath (Join-Path $game 'dz_w3_plugin_LH.ini')
Add-Content $active 'LastSession=999'
Switch-LocalTestProfile $w $game $we
if([IO.File]::ReadAllText((Join-Path $game 'dz_w3_plugin_LH.ini')) -notmatch 'LastSession=999'){throw 'Missing outgoing profile lost latest data'}
# Fail after one INI replacement: all transaction-owned changes must roll back exactly.
$beforeFiles=@{}
Get-ChildItem -LiteralPath $game -File | ForEach-Object {$beforeFiles[$_.FullName]=Get-ProfileHash $_.FullName}
$beforeFiles[$cfg]=Get-ProfileHash $cfg
$script:OriginalProfileWriter=${function:Write-ProfileBytes}
$script:IniWrites=0
function Write-ProfileBytes([string]$File, [byte[]]$Bytes) {
    if($File.EndsWith('.ini')) {
        $script:IniWrites++
        if($script:IniWrites -eq 2){throw 'Injected write failure'}
    }
    & $script:OriginalProfileWriter $File $Bytes
}
$blocked=$false
try { Switch-LocalTestProfile $lh $game $we } catch { if($_ -match 'Injected write failure'){$blocked=$true}else{throw} }
finally { Set-Item Function:Write-ProfileBytes $script:OriginalProfileWriter }
if(!$blocked){throw 'Failure was not injected'}
foreach($file in $beforeFiles.Keys){if((Get-ProfileHash $file) -ne $beforeFiles[$file]){throw "Rollback lost bytes: $file"}}
if(Test-Path $journal){throw 'Successful rollback left a journal'}
# A pending launch must prevent switching even when no game process is visible yet.
$pending=Join-Path $game 'local_test_profile.launching.json'
Write-ProfileText $pending '{}'
$before=Get-ProfileHash $active
$blocked=$false
try { Switch-LocalTestProfile $lh $game $we } catch { if($_ -match 'launch is unresolved'){$blocked=$true}else{throw} }
if(!$blocked -or (Get-ProfileHash $active) -ne $before){throw 'Pending launch allowed a switch'}
function Get-RunningProfileGame {}
$blocked=$false
try { Wait-ProfileGameLaunch $pending 123 ([datetime]::UtcNow.AddSeconds(-1)) 1 } catch { if($_ -match 'startup unconfirmed'){$blocked=$true}else{throw} }
if(!$blocked -or !(Test-Path $pending)){throw 'Timed out launch became switchable'}
function Get-RunningProfileGame { [pscustomobject]@{Name='war3.exe';ProcessId=124;ParentProcessId=123;CreationDate=[datetime]::UtcNow;ExecutablePath='D:\human\war3.exe'} }
Wait-ProfileGameLaunch $pending 123 ([datetime]::UtcNow.AddSeconds(-1)) 1
if(Test-Path $pending){throw 'Observed launch did not clear marker'}
$blocked=$false
try { Switch-LocalTestProfile $lh $game $we } catch { if($_ -match 'environment is busy'){$blocked=$true}else{throw} }
if(!$blocked -or (Get-ProfileHash $active) -ne $before){throw 'Running game allowed a switch'}
function Get-RunningProfileGame { foreach($name in 'A','B'){[pscustomobject]@{Name='war3.exe';ProcessId=10;ParentProcessId=20;CreationDate=[datetime]::UtcNow;ExecutablePath="D:\War3\tools\LanTest\pool\$name\Game\war3.exe"}} }
Switch-LocalTestProfile $lh $game $we
Write-ProfileText $pending '{}'
$blocked=$false
try { Wait-ProfileGameLaunch $pending 20 ([datetime]::UtcNow.AddSeconds(-1)) 1 } catch { $blocked=$true }
if(!$blocked -or !(Test-Path $pending)){throw 'Pool client mistaken for human launch'}
function Get-RunningProfileGame { [pscustomobject]@{Name='war3.exe';ProcessId=999999;ParentProcessId=0;CreationDate=[datetime]::UtcNow;ExecutablePath=$null} }
$blocked=$false
try { Assert-GameStopped } catch {$blocked=$true}
if(!$blocked){throw 'Unknown game bypassed profile protection'}
Write-Host 'PASS: A/B coexistence classification, unknown preservation and exact new-child confirmation'
$pool=Join-Path $testRoot 'pool';$session=Join-Path $pool 'A/sessions/fixture'
$null=New-Item -ItemType Directory -Force $session
$created=[datetime]::UtcNow
$hidden=[pscustomobject]@{Name='war3.exe';ProcessId=42;ParentProcessId=41;CreationDate=$created;ExecutablePath=$null}
$ticks=$created.ToUniversalTime().Ticks.ToString()
@{clientProcesses=@(@{pid=42;creationUtcTicks=$ticks;expectedName='LanP1'});launchers=@(@{pid=41;name='LanP1'})}|ConvertTo-Json -Depth 5|Set-Content (Join-Path $session 'session.json')
"42 123 POOL_IDENTITY_V1 $ticks $([IO.Path]::GetFullPath((Join-Path $pool 'A/Game/war3.exe')))"|Set-Content (Join-Path $session 'context-LanP1.log') -Encoding utf8
if(!(Test-IsolatedProfileGame $hidden $pool)){throw 'Exact hidden pool identity rejected'}
$hidden.CreationDate=$created.AddSeconds(1)
if(Test-IsolatedProfileGame $hidden $pool){throw 'Reused PID accepted'}
Write-Host 'PASS: hidden-path pool identity evidence and PID reuse rejection'
Write-Host "PASS switching, persistence, manual edits, conflicts, initialization, atomic recovery, newer-data preservation, missing outgoing copy, pending/running launch. Fixtures: $testRoot"
