$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'LocalTestProfile.ps1')
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
Add-Content (Join-Path $game 'dz_w3_plugin.ini') 'GameEdit=2'
Add-Content (Join-Path $game 'dz_w3_plugin_War3Lib.ini') 'ConflictingEdit=3'
$before=Get-ProfileHash $cfg
$blocked=$false
try{Switch-LocalTestProfile $lh $game $we}catch{if($_ -match 'Both active'){ $blocked=$true }else{throw}}
if(!$blocked -or (Get-ProfileHash $cfg) -ne $before){throw 'Conflict protection failed'}
Copy-Item (Join-Path $game 'dz_w3_plugin.ini') (Join-Path $game 'dz_w3_plugin_War3Lib.ini') -Force
Switch-LocalTestProfile $lh $game $we
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
try { Wait-ProfileGameLaunch $pending 1 } catch { if($_ -match 'startup unconfirmed'){$blocked=$true}else{throw} }
if(!$blocked -or !(Test-Path $pending)){throw 'Timed out launch became switchable'}
function Get-RunningProfileGame { [pscustomobject]@{ProcessName='war3'} }
Wait-ProfileGameLaunch $pending 1
if(Test-Path $pending){throw 'Observed launch did not clear marker'}
$blocked=$false
try { Switch-LocalTestProfile $lh $game $we } catch { if($_ -match 'Close Warcraft'){$blocked=$true}else{throw} }
if(!$blocked -or (Get-ProfileHash $active) -ne $before){throw 'Running game allowed a switch'}
Write-Host "PASS switching, persistence, manual edits, conflicts, initialization, atomic recovery, newer-data preservation, missing outgoing copy, pending/running launch. Fixtures: $testRoot"
