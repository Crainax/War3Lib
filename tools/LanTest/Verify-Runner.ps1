$ErrorActionPreference='Stop'
Set-StrictMode -Version Latest
foreach($file in Get-ChildItem -LiteralPath $PSScriptRoot -Filter '*.ps1') {
    $tokens=$null; $errors=$null
    $null=[Management.Automation.Language.Parser]::ParseFile($file.FullName,[ref]$tokens,[ref]$errors)
    if($errors){throw ($errors | Out-String)}
}
$root=Join-Path $PSScriptRoot ('sessions/parser-test-'+[guid]::NewGuid().ToString('N'))
$null=New-Item -ItemType Directory -Path $root
$logs=Join-Path $root 'logs'
$null=New-Item -ItemType Directory -Path $logs
$self=Get-CimInstance Win32_Process -Filter "ProcessId = $PID"
@{clients=1;startedUtc=[datetime]::UtcNow.AddSeconds(-10).ToString('o');hostPid=$PID;clientProcesses=@(@{pid=$PID;creationUtcTicks=$self.CreationDate.ToUniversalTime().Ticks.ToString()})} | ConvertTo-Json -Depth 4 | Set-Content (Join-Path $root 'session.json')
function Check([string]$name,[string]$hostText,[string]$clientText,[string]$expected) {
    Set-Content -LiteralPath (Join-Path $root 'host-stdout.log') -Value $hostText
    Set-Content -LiteralPath (Join-Path $logs 'test-P1.log') -Value $clientText
    try { & (Join-Path $PSScriptRoot 'Wait-LanTest.ps1') -SessionPath $root -ClientLogDirectory $logs -CompletionPattern '\[UT_DONE\]' -TimeoutSeconds 1 | Out-Null } catch {}
    $result=Get-Content (Join-Path $root 'result.json') -Raw | ConvertFrom-Json
    if($result.status -ne $expected){throw "$name expected $expected got $($result.status)"}
    Write-Output "PASS: $name"
}
Check 'all-client completion' 'started loading with 1 players' 'PASS: test; [UT_DONE]' 'PASS'
Check 'OOS overrides completion' 'started loading with 1 players; desync detected' 'PASS: test; [UT_DONE]' 'FAIL'
Check 'assertion failure overrides completion' 'started loading with 1 players' 'FAIL: test; [UT_DONE]' 'FAIL'
Check 'zero assertions rejected' 'started loading with 1 players' '[UT_DONE]' 'FAIL'
Check 'missing completion times out' 'started loading with 1 players' 'PASS: test' 'FAIL'
Write-Output "Evidence: $root (synthetic parser tests, not gameplay evidence)"
