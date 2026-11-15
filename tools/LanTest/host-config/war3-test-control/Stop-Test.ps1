param(
    [Parameter(Mandatory=$true)][int]$TestProcessId,
    [Parameter(Mandatory=$true)][long]$CreationUtcTicks
)
$ErrorActionPreference = 'Stop'
$controlRoot = Join-Path $env:LOCALAPPDATA 'CodexWar3TestControl'
$service = New-Object -ComObject 'Schedule.Service'
$service.Connect()
$task = $service.GetFolder('\').GetTask('Codex-War3-StopTest')
$instance = Get-CimInstance Win32_Process -Filter "ProcessId = $TestProcessId"
if (-not $instance) { Write-Output 'Target already exited.'; exit 0 }
if ($instance.Name -ine 'war3.exe') { throw 'Only war3.exe is accepted.' }
if ($instance.CreationDate.ToUniversalTime().Ticks -ne $CreationUtcTicks) { throw 'Process creation time does not match the recorded test instance.' }
$null = New-Item -ItemType Directory -Path $controlRoot -Force
$lock = $null
try {
    $queueDeadline=[datetime]::UtcNow.AddSeconds(60)
    while (!$lock) {
        try { $lock = [IO.File]::Open((Join-Path $controlRoot 'client.lock'), 'OpenOrCreate', 'ReadWrite', 'None') }
        catch [IO.IOException] {
            if ([datetime]::UtcNow -ge $queueDeadline) { throw 'Cleanup queue timed out; no request was overwritten.' }
            Start-Sleep -Milliseconds 500
        }
    }
    while ($task.State -eq 4) {
        if ([datetime]::UtcNow -ge $queueDeadline) { throw 'Previous stop task still running; request preserved.' }
        Start-Sleep -Milliseconds 500
    }
    $instance = Get-CimInstance Win32_Process -Filter "ProcessId = $TestProcessId"
    if (!$instance) { Write-Output 'Target already exited.'; exit 0 }
    if ($instance.Name -ine 'war3.exe' -or $instance.CreationDate.ToUniversalTime().Ticks -ne $CreationUtcTicks) { throw 'Target identity changed while waiting; refusing cleanup.' }
    $requestId = [guid]::NewGuid().ToString()
    [ordered]@{
        RequestId = $requestId
        ProcessId = $TestProcessId
        CreationUtcTicks = $CreationUtcTicks.ToString()
        SessionId = [int]$instance.SessionId
        RequestedUtc = [datetime]::UtcNow.ToString('o')
    } | ConvertTo-Json -Compress | Set-Content -LiteralPath (Join-Path $controlRoot 'request.json') -Encoding UTF8
    $null = $task.Run($null)
    $deadline = [datetime]::UtcNow.AddSeconds(30)
    do {
        Start-Sleep -Milliseconds 500
        $response = $null
        try { $response = Get-Content -LiteralPath (Join-Path $controlRoot 'result.json') -Raw -ErrorAction Stop | ConvertFrom-Json } catch {}
        if ($response -and $response.RequestId -eq $requestId) {
            if (-not $response.Success) { throw $response.Message }
            $remaining = Get-CimInstance Win32_Process -Filter "ProcessId = $TestProcessId"
            if ($remaining -and $remaining.CreationDate.ToUniversalTime().Ticks -eq $CreationUtcTicks) { throw 'Worker claimed success but target is still running.' }
            Write-Output $response.Message
            exit 0
        }
    } while ([datetime]::UtcNow -lt $deadline)
    throw 'Timed out waiting for the scheduled task result; check task status before retrying.'
} finally { if ($lock) { $lock.Dispose() } }
