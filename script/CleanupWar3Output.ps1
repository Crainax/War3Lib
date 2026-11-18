param([switch]$Apply,[string]$ReportPath,[string]$KnownManualMap,[int]$KnownManualPid,[string]$KnownManualCreationTicks)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'LocalTestProfile.ps1')
$project=Split-Path $PSScriptRoot -Parent
$output=[IO.Path]::GetFullPath((Join-Path $project 'Output'))
if($KnownManualMap){
    $KnownManualMap=[IO.Path]::GetFullPath($KnownManualMap)
    if(!$KnownManualMap.StartsWith($output+'\',[StringComparison]::OrdinalIgnoreCase) -or [IO.Path]::GetExtension($KnownManualMap) -notin '.w3x','.w3m' -or !$KnownManualPid -or !$KnownManualCreationTicks -or !(Test-Path -LiteralPath $KnownManualMap)){
        throw 'Manual identity requires an existing Output map and exact PID/creation time'
    }
}
$locks=@();$records=@();$poolIdentities=@{};$manifestCache=@{}
try {
    $locks+=[IO.File]::Open((Join-Path $output 'agent_compile.lock'),'OpenOrCreate','ReadWrite','None')
    $lock=[IO.File]::Open((Join-Path $output 'launcher/.build.lock'),'OpenOrCreate','ReadWrite','ReadWrite')
    $lock.Lock(0,1);$locks+=$lock
    $candidates=@()
    foreach($engine in 'ydlua','innerjapi-1.49-9'){
        $path=Join-Path $output "launcher/engines/$engine"
        if(Test-Path $path){
            $candidates+=Get-ChildItem $path -Force | Where-Object Name -ne tests
            $candidates+=Get-ChildItem (Join-Path $path 'tests') -Directory -ErrorAction SilentlyContinue
        }
    }
    foreach($relative in 'launcher/incremental','font-native/WE','inner-font/WE'){
        $path=Join-Path $output $relative
        if(Test-Path -LiteralPath $path){$candidates+=Get-Item -LiteralPath $path}
    }
    foreach($relative in 'dz-font-memory','font-native','font-style','inner-font'){
        $path=Join-Path $output $relative
        if(Test-Path $path){$candidates+=Get-ChildItem $path -File | Where-Object Extension -in '.w3x','.obj','.o','.elf','.exp','.lib','.dll'}
    }
    $oldMap=Join-Path $output 'UITextFontUnlock-InnerJAPI.w3x'
    if(Test-Path $oldMap){$candidates+=Get-Item $oldMap}
    $tracked=@(& git -C $project -c core.quotepath=false ls-files -- Output output)
    foreach($candidate in $candidates){
        $target=[IO.Path]::GetFullPath($candidate.FullName)
        if(!$target.StartsWith($output+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'Cleanup target outside Output'}
        $relative=[IO.Path]::GetRelativePath($project,$target).Replace('\','/')
        $reason='';$files=@()
        if($KnownManualMap -and ([IO.Path]::GetFullPath($KnownManualMap).StartsWith($target+'\',[StringComparison]::OrdinalIgnoreCase) -or [IO.Path]::GetFullPath($KnownManualMap) -ieq $target)){$reason='confirmed manual map preserved'}
        if($candidate.PSIsContainer){$items=@(Get-ChildItem -LiteralPath $target -Recurse -Force);$files=@($items|Where-Object {!$_.PSIsContainer})}else{$items=@();$files=@($candidate)}
        if(@(@($candidate)+$items|Where-Object {$_.Attributes -band [IO.FileAttributes]::ReparsePoint}).Count){$reason='link preserved'}
        if(@($tracked|Where-Object {$_ -ieq $relative -or $_.StartsWith($relative+'/',[StringComparison]::OrdinalIgnoreCase)}).Count){$reason='tracked content preserved'}
        # Recheck immediately before each removal. Unknown game paths preserve all candidates.
        $processes=@(Get-CimInstance Win32_Process | Where-Object ProcessId -ne $PID)
        foreach($p in $processes){
            $known=$KnownManualMap -and $p.ProcessId -eq $KnownManualPid -and $p.CreationDate.ToUniversalTime().Ticks.ToString() -eq $KnownManualCreationTicks
            if($p.Name -ieq 'war3.exe' -and !$p.ExecutablePath -and !$known){
                $identity="$($p.ProcessId):$($p.CreationDate.ToUniversalTime().Ticks)"
                if(!$poolIdentities.ContainsKey($identity)){$poolIdentities[$identity]=Test-IsolatedProfileGame $p}
                $known=$poolIdentities[$identity]
            }
            if($p.Name -in 'war3.exe','ydhost.exe','YDWEConfig.exe' -and !$p.ExecutablePath -and !$known){$reason='unknown game identity preserved'}
            if(($p.ExecutablePath -and $p.ExecutablePath.StartsWith($target,[StringComparison]::OrdinalIgnoreCase)) -or ($p.CommandLine -and $p.CommandLine.Replace('/','\').IndexOf($target,[StringComparison]::OrdinalIgnoreCase) -ge 0)){$reason='live process reference'}
            if($p.Name -in 'lua.exe','w3x2lni-lua.exe','w2l.exe','vjassc.exe' -and $p.CommandLine -and $p.CommandLine.Replace('/','\').IndexOf($project,[StringComparison]::OrdinalIgnoreCase) -ge 0){$reason='project build active'}
        }
        foreach($environment in 'A','B'){
            foreach($manifestFile in Get-ChildItem "D:/War3/tools/LanTest/pool/$environment/sessions" -Filter session.json -Recurse){
                try{
                    $cached=$manifestCache[$manifestFile.FullName]
                    if(!$cached -or $cached.stamp -ne $manifestFile.LastWriteTimeUtc.Ticks){
                        $cached=@{stamp=$manifestFile.LastWriteTimeUtc.Ticks;data=(Get-Content $manifestFile.FullName -Raw|ConvertFrom-Json)}
                        $manifestCache[$manifestFile.FullName]=$cached
                    }
                    $manifest=$cached.data
                }catch{$reason='unreadable session manifest';continue}
                if($manifest.PSObject.Properties['runnerPid'] -and $processes.ProcessId -contains $manifest.runnerPid){
                    if($manifest.sourceMap -and [IO.Path]::GetFullPath($manifest.sourceMap).StartsWith($target,[StringComparison]::OrdinalIgnoreCase)){$reason='active session source preserved'}
                }
            }
        }
        foreach($queue in 'D:/War3/tools/LanTest/pool/queue','D:/War3/tools/LanTest/queue'){
            foreach($ticket in Get-ChildItem $queue -Filter '*.json' -ErrorAction SilentlyContinue){
                try{$r=Get-Content $ticket.FullName -Raw|ConvertFrom-Json}catch{$reason='unreadable queue ticket';continue}
                if($r.state -notin 'WAITING','RUNNING'){continue}
                if($processes.ProcessId -contains $r.runnerPid){
                    $json=($r|ConvertTo-Json -Depth 8).Replace('\\','\').Replace('/','\')
                    if($json.IndexOf($target,[StringComparison]::OrdinalIgnoreCase) -ge 0){$reason='live queue reference'}
                }
            }
        }
        if(!$reason){foreach($file in $files){try{$probe=[IO.File]::Open($file.FullName,'Open','Read','None');$probe.Dispose()}catch{$reason='file in use';break}}}
        $bytes=0L;foreach($file in $files){$bytes+=$file.Length}
        $status=if($reason){'PRESERVED'}elseif($Apply){'REMOVED'}else{'CANDIDATE'}
        if($status -eq 'REMOVED'){Remove-Item -LiteralPath $target -Recurse -Force}
        $records+=@{path=$target;bytes=$bytes;status=$status;reason=$reason}
    }
    if($Apply){
        foreach($relative in 'launcher/engines/ydlua/tests','launcher/engines/ydlua','launcher/engines/innerjapi-1.49-9/tests','launcher/engines/innerjapi-1.49-9'){
            $empty=[IO.Path]::GetFullPath((Join-Path $output $relative))
            if(!$empty.StartsWith($output+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'Empty directory outside Output'}
            if((Test-Path -LiteralPath $empty) -and !((Get-Item -LiteralPath $empty).Attributes -band [IO.FileAttributes]::ReparsePoint)){
                try{[IO.Directory]::Delete($empty,$false)}catch [IO.IOException]{} # A nonempty/newly used directory stays intact.
            }
        }
    }
}finally{foreach($item in $locks){$item.Dispose()}}
$removedBytes=0L;foreach($record in $records){if($record.status -eq 'REMOVED'){$removedBytes+=$record.bytes}}
$result=@{utc=[datetime]::UtcNow.ToString('o');apply=[bool]$Apply;items=$records;removedBytes=$removedBytes}
if($ReportPath){$result|ConvertTo-Json -Depth 8|Set-Content -LiteralPath $ReportPath -Encoding utf8}
$records|Select-Object status,path,@{n='MiB';e={[math]::Round($_.bytes/1MB,1)}},reason|Format-Table -AutoSize
Write-Host ('Removed MiB: '+[math]::Round($result.removedBytes/1MB,1))
