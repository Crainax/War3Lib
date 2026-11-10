$ErrorActionPreference = 'Stop'
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]$identity
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Run this installer once from an Administrator PowerShell.'
}
$expectedSid = 'S-1-5-21-3661576158-3837886264-504760446-1001'
if ($identity.User.Value -ne $expectedSid) { throw 'Use elevation of the original Windows user, not a different administrator account.' }
$taskName = 'Codex-War3-StopTest'
$controlRoot = Join-Path $env:LOCALAPPDATA 'CodexWar3TestControl'
$null = New-Item -ItemType Directory -Path $controlRoot -Force
$worker = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'Stop-TestWorker.ps1') -Raw
$worker = $worker.Replace('__CONTROL_ROOT__', $controlRoot.Replace("'", "''")).Replace('__USER_SID__', $expectedSid)
$encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($worker))
$service = New-Object -ComObject 'Schedule.Service'
$service.Connect()
$root = $service.GetFolder('\')
$definition = $service.NewTask(0)
$definition.RegistrationInfo.Description = 'On demand only. Terminates one explicitly requested Warcraft test PID after path, owner, session and creation-time validation. Worker code is embedded in the administrator-protected task.'
$definition.Principal.UserId = $expectedSid
$definition.Principal.LogonType = 3
$definition.Principal.RunLevel = 1
$definition.Settings.Enabled = $true
$definition.Settings.AllowDemandStart = $true
$definition.Settings.DisallowStartIfOnBatteries = $false
$definition.Settings.StopIfGoingOnBatteries = $false
$definition.Settings.ExecutionTimeLimit = 'PT1M'
$definition.Settings.MultipleInstances = 2
$action = $definition.Actions.Create(0)
$action.Path = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
# Windows PowerShell's -WindowStyle Hidden fails with exit -1 in this
# machine's Task Scheduler context, before the script starts. Do not add it.
$action.Arguments = '-NoProfile -NonInteractive -EncodedCommand ' + $encoded
# User may read/run; only elevated administrators and SYSTEM may change the task.
$sddl = "O:BAG:BAD:P(A;;GA;;;SY)(A;;GA;;;BA)(A;;GRGX;;;$expectedSid)"
# 6 = create/update; 16 prevents the scheduler adding a broader principal ACE.
$null = $root.RegisterTaskDefinition($taskName, $definition, 22, $expectedSid, $null, 3, $sddl)
Write-Output "Installed: $taskName"
# Exercise the elevated action using this non-game PID: it must refuse it.
$requestId = [guid]::NewGuid().ToString()
@{ RequestId=$requestId; ProcessId=$PID; CreationUtcTicks='0'; SessionId=0; RequestedUtc=[datetime]::UtcNow.ToString('o') } |
    ConvertTo-Json -Compress | Set-Content -LiteralPath (Join-Path $controlRoot 'request.json') -Encoding UTF8
$installed = $root.GetTask($taskName)
$null = $installed.Run($null)
$deadline = [datetime]::UtcNow.AddSeconds(15)
$response = $null
do {
    Start-Sleep -Milliseconds 500
    try { $response = Get-Content -LiteralPath (Join-Path $controlRoot 'result.json') -Raw -ErrorAction Stop | ConvertFrom-Json } catch {}
    if ($response -and $response.RequestId -eq $requestId) { break }
} while ([datetime]::UtcNow -lt $deadline)
if (-not $response -or $response.RequestId -ne $requestId) { throw "Task startup self-test failed. LastTaskResult=$($installed.LastTaskResult)" }
if ($response.Success -or $response.Message -ne 'Target is not the allowlisted Warcraft executable.') { throw "Unexpected self-test result: $($response.Message)" }
Write-Output 'PASS: scheduled worker started and safely refused a non-game process.'
Write-Output 'No schedule or startup trigger. No password stored. Ready for non-admin game testing.'
