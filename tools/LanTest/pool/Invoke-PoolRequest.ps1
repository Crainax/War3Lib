# Preserve exact strings/switches when a Windows PowerShell caller bridges to pwsh.
param([Parameter(Mandatory)][string]$RequestPath)
$ErrorActionPreference='Stop'
$parameters=Import-Clixml -LiteralPath $RequestPath
if($parameters -isnot [System.Collections.IDictionary]){throw 'Invalid pool request'}
& (Join-Path $PSScriptRoot 'Start-PoolTest.ps1') @parameters
