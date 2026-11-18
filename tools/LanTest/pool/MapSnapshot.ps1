function New-PoolMapSnapshot([string]$Source,[string]$Root,[string]$OwnerId) {
    $rootPath=[IO.Path]::GetFullPath($Root)
    $null=New-Item -ItemType Directory -Force $rootPath
    $directory=Join-Path $rootPath ([guid]::NewGuid().ToString('N'))
    $null=New-Item -ItemType Directory $directory
    $target=Join-Path $directory ('map'+[IO.Path]::GetExtension($Source))
    $inputFile=$null;$outputFile=$null
    try {
        # Deny writers for the whole copy, before joining the allocation queue.
        $inputFile=[IO.File]::Open($Source,'Open','Read','Read')
        $outputFile=[IO.File]::Open($target,'CreateNew','Write','None')
        $inputFile.CopyTo($outputFile);$outputFile.Dispose();$outputFile=$null
        $hash=(Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash
        $record=@{directory=$directory;path=$target;source=$Source;sha256=$hash;ownerId=$OwnerId;runnerPid=$PID}
        $record|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $directory 'snapshot.json') -Encoding utf8
        return $record
    } catch {
        if($outputFile){$outputFile.Dispose();$outputFile=$null}
        # These exact paths were created by this call and were never published.
        if(Test-Path -LiteralPath $target){Remove-Item -LiteralPath $target}
        $recordPath=Join-Path $directory 'snapshot.json'
        if(Test-Path -LiteralPath $recordPath){Remove-Item -LiteralPath $recordPath}
        Remove-Item -LiteralPath $directory
        throw
    } finally {
        if($outputFile){$outputFile.Dispose()};if($inputFile){$inputFile.Dispose()}
    }
}

function Remove-PoolMapSnapshot($Snapshot,[string]$Root,[string]$OwnerId) {
    $rootPath=[IO.Path]::GetFullPath($Root).TrimEnd('\','/')
    $directory=[IO.Path]::GetFullPath($Snapshot.directory)
    if((Split-Path $directory -Parent) -ine $rootPath -or (Split-Path $directory -Leaf) -notmatch '^[a-f0-9]{32}$' -or $Snapshot.ownerId -cne $OwnerId){throw 'Snapshot cleanup identity mismatch'}
    foreach($item in Get-ChildItem -LiteralPath $directory -Force){
        if($item.Attributes -band [IO.FileAttributes]::ReparsePoint -or $item.PSIsContainer){throw 'Unexpected snapshot contents preserved'}
        if($item.FullName -ine $Snapshot.path -and $item.Name -ne 'snapshot.json'){throw 'Foreign snapshot contents preserved'}
    }
    if((Get-Item -LiteralPath $directory).Attributes -band [IO.FileAttributes]::ReparsePoint){throw 'Linked snapshot preserved'}
    $record=Get-Content -LiteralPath (Join-Path $directory 'snapshot.json') -Raw|ConvertFrom-Json
    if($record.ownerId -cne $OwnerId -or $record.path -ine $Snapshot.path -or $record.sha256 -ne $Snapshot.sha256){throw 'Snapshot record changed; preserved'}
    if((Get-FileHash -LiteralPath $Snapshot.path).Hash -ne $Snapshot.sha256){throw 'Changed snapshot preserved'}
    Remove-Item -LiteralPath $Snapshot.path
    Remove-Item -LiteralPath (Join-Path $directory 'snapshot.json')
    Remove-Item -LiteralPath $directory
}

function Remove-PoolSessionMap($Manifest,[string]$Session) {
    $cleanup=Join-Path $Session 'cleanup.json'
    if(!(Test-Path $cleanup) -or !(Get-Content $cleanup -Raw|ConvertFrom-Json).success){return $false}
    $target=[IO.Path]::GetFullPath($Manifest.gameMap)
    $expected=Join-Path $Manifest.gamePath ('Maps\Test\'+(Split-Path $Session -Leaf)+[IO.Path]::GetExtension($target))
    if($target -ine $expected){throw 'Unexpected session map path preserved'}
    if(Test-Path -LiteralPath $target){
        if((Get-Item -LiteralPath $target).Attributes -band [IO.FileAttributes]::ReparsePoint -or (Get-FileHash -LiteralPath $target).Hash -ne $Manifest.sha256){throw 'Changed session map preserved'}
        Remove-Item -LiteralPath $target
    }
    @{success=$true;map=$target;utc=[datetime]::UtcNow.ToString('o')}|ConvertTo-Json|Set-Content (Join-Path $Session 'map-cleanup.json') -Encoding utf8
    return $true
}
