param([Parameter(Mandatory=$true)][string]$SessionPath)
$ErrorActionPreference = 'Stop'
$manifest = Get-Content -LiteralPath (Join-Path $SessionPath 'session.json') -Raw | ConvertFrom-Json
$errors = @()
foreach ($client in $manifest.clientProcesses) {
    try {
        # A child shell contains Stop-Test.ps1's exit, so every client is processed.
        & powershell.exe -NoProfile -ExecutionPolicy Bypass -File 'C:/Users/41399/.codex/tools/war3-test-control/Stop-Test.ps1' -TestProcessId $client.pid -CreationUtcTicks $client.creationUtcTicks
        if ($LASTEXITCODE -ne 0) { throw "Client $($client.pid) cleanup failed" }
    } catch { $errors += $_.Exception.Message }
}
if ($manifest.hostPid) {
    try {
        $hostInfo = Get-CimInstance Win32_Process -Filter "ProcessId = $($manifest.hostPid)"
        if ($hostInfo) {
            $allowedHost = Join-Path $PSScriptRoot 'bin\ydhost.exe'
            if ($hostInfo.ExecutablePath -ine $allowedHost -or $hostInfo.CreationDate.ToUniversalTime().Ticks.ToString() -ne $manifest.hostCreationUtcTicks) { throw 'Host identity changed; refusing cleanup.' }
            Stop-Process -Id $manifest.hostPid -Force -ErrorAction Stop
        }
    } catch { $errors += $_.Exception.Message }
}
@{utc=[datetime]::UtcNow.ToString('o'); success=($errors.Count -eq 0); errors=$errors} | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $SessionPath 'cleanup.json') -Encoding UTF8
if ($errors.Count) { throw ($errors -join '; ') }
