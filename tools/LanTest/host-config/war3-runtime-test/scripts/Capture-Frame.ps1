param($Phase, $SessionPath, $GamePath, $MapPath, $Clients, $Options)
$ErrorActionPreference = 'Stop'
$session = Get-Item -LiteralPath $SessionPath
$poolRoot = $session.Parent.Parent
if ($poolRoot.FullName -notin 'D:\War3\tools\LanTest\pool\A','D:\War3\tools\LanTest\pool\B' -or
    $session.Parent.Name -ne 'sessions' -or $GamePath -ne (Join-Path $poolRoot.FullName 'Game') -or $Clients -ne 1) {
    throw 'Expected a single-client private pool session.'
}
$library = Join-Path $PSScriptRoot '../assets/opengl32.dll'
$dest = Join-Path $GamePath 'opengl32.dll'
$installed = Join-Path $SessionPath 'capture-installed'
$frame = Join-Path $SessionPath 'render.ppm'
function Find-CaptureClientCrash($Session) {
    $directory = Join-Path $Session.gamePath 'Errors'
    if (!(Test-Path -LiteralPath $directory -PathType Container)) { return }
    $since = ([datetimeoffset]$Session.startedUtc).UtcDateTime
    foreach ($file in Get-ChildItem -LiteralPath $directory -File -Filter '*Crash.dmp') {
        if ($file.LastWriteTimeUtc -lt $since) { continue }
        $reader = $null
        try {
            $reader = [IO.BinaryReader]::new([IO.File]::Open($file.FullName, 'Open', 'Read', 'ReadWrite'))
            if ($reader.ReadUInt32() -ne 0x504d444d) { continue }
            $reader.BaseStream.Position = 8
            $count = $reader.ReadUInt32()
            $directoryOffset = $reader.ReadUInt32()
            if ([long]$directoryOffset + 12L * $count -gt $reader.BaseStream.Length) { continue }
            for ($i = 0; $i -lt $count; $i++) {
                $reader.BaseStream.Position = [long]$directoryOffset + 12L * $i
                $type = $reader.ReadUInt32()
                $size = $reader.ReadUInt32()
                $offset = $reader.ReadUInt32()
                if ($type -ne 15 -or $size -lt 16) { continue }
                $reader.BaseStream.Position = $offset
                if ($reader.ReadUInt32() -lt 16 -or ($reader.ReadUInt32() -band 3) -ne 3) { break }
                $processId = $reader.ReadUInt32()
                $created = $reader.ReadUInt32()
                foreach ($client in $Session.clientProcesses) {
                    $time = [datetimeoffset]::new([long]$client.creationUtcTicks, [timespan]::Zero)
                    if ($client.pid -eq $processId -and $time.ToUnixTimeSeconds() -eq $created) {
                        return "客户端 $($client.expectedName) (PID $processId) 在等待截图时崩溃。转储 $($file.FullName)"
                    }
                }
                break
            }
        } catch [IO.IOException] {
            # 文件可能还在写入，下次轮询重读。
        } finally {
            if ($reader) { $reader.Dispose() }
        }
    }
}

switch ($Phase) {
    Prepare {
        $env:WAR3_FRAME_DIRECTORY = $SessionPath
        $hash = (Get-FileHash -LiteralPath $library).Hash
        [IO.File]::Copy($library, $dest, $false)
        try { [IO.File]::WriteAllText($installed, $hash) }
        catch { Remove-Item -LiteralPath $dest; throw }
    }
    Ready {
        $manifest = Get-Content (Join-Path $SessionPath 'session.json') -Raw | ConvertFrom-Json
        $start = ([datetime]$manifest.startedUtc).ToUniversalTime()
        $request = Join-Path $SessionPath 'capture.request'
        $deadline = [datetime]::UtcNow.AddSeconds($Options.TimeoutSeconds)
        $nextCrashCheck = [datetime]::UtcNow
        while (!(Test-Path -LiteralPath $frame)) {
            if ([datetime]::UtcNow -ge $nextCrashCheck) {
                $crash = Find-CaptureClientCrash $manifest
                if ($crash) { throw $crash }
                $nextCrashCheck = [datetime]::UtcNow.AddSeconds(2)
            }
            if ([datetime]::UtcNow -ge $deadline) { throw "Timed out waiting for scene '$($Options.Scene)' and its rendered frame." }
            if (!(Test-Path -LiteralPath $request)) {
                $log = Get-ChildItem -LiteralPath $manifest.clientLogDirectory -Filter '*-P1.log' -File |
                    Where-Object CreationTimeUtc -ge $start | Sort-Object LastWriteTimeUtc -Descending | Select-Object -First 1
                if ($log -and (Select-String -LiteralPath $log.FullName -Pattern $Options.ReadyPattern -Quiet)) {
                    [IO.File]::WriteAllText($request, $Options.Scene)
                }
            }
            Start-Sleep -Milliseconds 250
        }
        $folder = Join-Path 'D:/War3/Reports' $Options.Project 'UI截图' $Options.Scene
        $null = [IO.Directory]::CreateDirectory($folder)
        $preview = Join-Path $folder ($session.Name + '.jpg')
        & python (Join-Path $PSScriptRoot 'compress_frame.py') $frame $preview
        if ($LASTEXITCODE -ne 0) { throw 'Could not publish JPEG.' }
    }
    Finalize {
        if (Test-Path -LiteralPath $installed) {
            if ((Get-FileHash -LiteralPath $dest).Hash -ne (Get-Content -LiteralPath $installed -Raw)) {
                throw 'Capture library identity changed during this session.'
            }
            Remove-Item -LiteralPath $dest
        }
    }
}
