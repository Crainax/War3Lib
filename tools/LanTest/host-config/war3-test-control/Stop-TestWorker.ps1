$ErrorActionPreference = 'Stop'
$controlRoot = '__CONTROL_ROOT__'
$allowedSid = '__USER_SID__'
$allowedExe = 'D:\Program Files (x86)\Warcraft III Frozen Throne\war3.exe'
$requestPath = Join-Path $controlRoot 'request.json'
$resultPath = Join-Path $controlRoot 'result.json'
$result = [ordered]@{ RequestId = ''; Success = $false; Message = ''; ProcessId = 0 }
try {
    $file = Get-Item -LiteralPath $requestPath
    if ($file.Length -gt 4096) { throw 'Request exceeds size limit.' }
    $request = Get-Content -LiteralPath $requestPath -Raw | ConvertFrom-Json
    $result.RequestId = ([guid]$request.RequestId).ToString()
    $targetProcessId = [int]$request.ProcessId
    $result.ProcessId = $targetProcessId
    $age = ([datetime]::UtcNow - [datetime]::Parse($request.RequestedUtc).ToUniversalTime()).TotalSeconds
    if ($age -lt -5 -or $age -gt 60) { throw 'Request is expired or has a future timestamp.' }
    if ($targetProcessId -le 0) { throw 'Invalid process ID.' }
    $instance = Get-CimInstance Win32_Process -Filter "ProcessId = $targetProcessId"
    if (-not $instance) { throw 'Target no longer exists; nothing was stopped.' }
    if ($instance.Name -ine 'war3.exe' -or $instance.ExecutablePath -ine $allowedExe) { throw 'Target is not the allowlisted Warcraft executable.' }
    $owner = Invoke-CimMethod -InputObject $instance -MethodName GetOwnerSid
    if ($owner.ReturnValue -ne 0 -or $owner.Sid -ne $allowedSid) { throw 'Target belongs to another user.' }
    if ([int]$instance.SessionId -ne [int]$request.SessionId) { throw 'Target session changed.' }
    $expectedTicks = [long]$request.CreationUtcTicks
    if ($instance.CreationDate.ToUniversalTime().Ticks -ne $expectedTicks) { throw 'PID has been reused or creation time is incorrect.' }
    $process = Get-Process -Id $targetProcessId -ErrorAction Stop
    try {
        # Retain a handle while checking and stopping this process instance.
        $null = $process.Handle
        if ($process.ProcessName -ine 'war3' -or $process.MainModule.FileName -ine $allowedExe) { throw 'Process identity changed.' }
        # CIM timestamps have microsecond precision; .NET can retain 100 ns precision.
        if ([math]::Abs($process.StartTime.ToUniversalTime().Ticks - $expectedTicks) -gt 9) { throw 'Process start time changed.' }
        $process.Kill()
        if (-not $process.WaitForExit(10000)) { throw 'Process did not exit within ten seconds.' }
    } finally { $process.Dispose() }
    $result.Success = $true
    $result.Message = 'Verified test process terminated.'
} catch { $result.Message = $_.Exception.Message }
$result | ConvertTo-Json -Compress | Set-Content -LiteralPath $resultPath -Encoding UTF8
if (-not $result.Success) { exit 1 }
