param([string]$Root=$PSScriptRoot)
# Caller holds manual-startup.lock; defer while any game or launcher is present.
$active = @(Get-CimInstance Win32_Process | Where-Object Name -in 'war3.exe','ydhost.exe','YDWEConfig.exe')
if ($active.Count) { return }
$sessions = [IO.Path]::GetFullPath((Join-Path $Root 'sessions'))
foreach ($folder in Get-ChildItem -LiteralPath $sessions -Directory) {
    if ($folder.LinkType -or $folder.Name -notmatch '^\d{8}-\d{6}-[a-f0-9]{6}$') { continue }
    $we = Join-Path $folder.FullName 'WE'
    $map = Join-Path $folder.FullName 'single.w3x'
    if (!(Test-Path -LiteralPath $we) -and !(Test-Path -LiteralPath $map)) { continue }
    $record = Join-Path $folder.FullName 'session.json'
    if (!(Test-Path -LiteralPath $record)) { continue }
    $m = Get-Content -LiteralPath $record -Raw | ConvertFrom-Json -AsHashtable
    if ($m['launchMode'] -ne 'single' -or $m.session -ine $folder.FullName -or $m['launchedMap'] -ine $map) { continue }
    if (Test-Path -LiteralPath $we) {
        $item = Get-Item -LiteralPath $we
        if ($item.LinkType -or $item.FullName -ine (Join-Path $sessions ($folder.Name+'\WE'))) { continue }
        if (Get-ChildItem -LiteralPath $we -Recurse -Force | Where-Object LinkType) { continue }
        Remove-Item -LiteralPath $item.FullName -Recurse -Force
    }
    if ((Test-Path -LiteralPath $map) -and !(Get-Item -LiteralPath $map).LinkType -and (Get-FileHash -LiteralPath $map).Hash -eq $m.launchedMapSha256) {
        Remove-Item -LiteralPath $map
    }
    Write-Output $folder.FullName
}
