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
        while (!(Test-Path -LiteralPath $frame)) {
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
