$ErrorActionPreference = 'Stop'
foreach ($file in Get-ChildItem -LiteralPath $PSScriptRoot -Filter '*.ps1') {
    $tokens = $null
    $parseErrors = $null
    $null = [Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)
    if ($parseErrors) { throw ($parseErrors | Out-String) }
}
Write-Output 'PASS: PowerShell syntax'
$testRoot = Join-Path $env:TEMP ('War3StopValidation-' + [guid]::NewGuid())
$null = New-Item -ItemType Directory -Path $testRoot
$template = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'Stop-TestWorker.ps1') -Raw
$worker = $template.Replace('__CONTROL_ROOT__', $testRoot.Replace("'", "''")).Replace('__USER_SID__', [Security.Principal.WindowsIdentity]::GetCurrent().User.Value)
$encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($worker))
$powershell = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
$request = @{ RequestId=[guid]::NewGuid().ToString(); ProcessId=$PID; CreationUtcTicks='0'; SessionId=0; RequestedUtc=[datetime]::UtcNow.ToString('o') }
$request | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $testRoot 'request.json') -Encoding UTF8
& $powershell -NoProfile -NonInteractive -EncodedCommand $encoded
$response = Get-Content -LiteralPath (Join-Path $testRoot 'result.json') -Raw | ConvertFrom-Json
if ($LASTEXITCODE -ne 1 -or $response.Success -or $response.Message -ne 'Target is not the allowlisted Warcraft executable.') { throw 'Non-game rejection failed.' }
Write-Output 'PASS: Refused a real non-game PID without terminating it'
$request.RequestedUtc = [datetime]::UtcNow.AddMinutes(-2).ToString('o')
$request | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $testRoot 'request.json') -Encoding UTF8
& $powershell -NoProfile -NonInteractive -EncodedCommand $encoded
$response = Get-Content -LiteralPath (Join-Path $testRoot 'result.json') -Raw | ConvertFrom-Json
if ($LASTEXITCODE -ne 1 -or $response.Success -or $response.Message -ne 'Request is expired or has a future timestamp.') { throw 'Expired request rejection failed.' }
Write-Output 'PASS: Refused an expired request'
Write-Output "Task encoded payload length: $($encoded.Length)"
Remove-Item -LiteralPath (Join-Path $testRoot 'request.json'), (Join-Path $testRoot 'result.json')
Remove-Item -LiteralPath $testRoot
