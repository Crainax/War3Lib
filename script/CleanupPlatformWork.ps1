param(
    [Parameter(Mandatory=$true)][string]$Project,
    [Parameter(Mandatory=$true)][ValidatePattern('^VERSION_[A-Z]+$')][string]$Version,
    [Parameter(Mandatory=$true)][string]$Keep
)
$ErrorActionPreference = 'Stop'
# Called only after a successful build while TaskLaunch holds the version lock.
$projectRoot = (Resolve-Path -LiteralPath $Project).ProviderPath
$parent = [IO.Path]::GetFullPath((Join-Path $projectRoot "Output/launcher/work/11/$Version"))
$keepPath = [IO.Path]::GetFullPath((Resolve-Path -LiteralPath $Keep).ProviderPath)
if ([IO.Path]::GetDirectoryName($keepPath) -ne $parent) { throw 'Keep directory must be a direct child of the version workspace.' }
$stampPattern = '^\d{8}-\d{6}(?:-\d+)?$'
if ([IO.Path]::GetFileName($keepPath) -notmatch $stampPattern) { throw 'Invalid workspace name.' }
# Refuse junctions/symlinks in the ancestry, so lexical containment is meaningful.
$ancestor = Get-Item -LiteralPath $parent -Force
while ($null -ne $ancestor) {
    if ($ancestor.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw 'Workspace ancestry contains a reparse point.' }
    $ancestor = $ancestor.Parent
}
function Assert-PlainTree([string]$Directory) {
    foreach ($item in Get-ChildItem -LiteralPath $Directory -Force) {
        if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "Refusing reparse point: $($item.FullName)" }
        if ($item.PSIsContainer) { Assert-PlainTree $item.FullName }
    }
}
$removed = 0
foreach ($entry in Get-ChildItem -LiteralPath $parent -Force -Directory) {
    $target = [IO.Path]::GetFullPath($entry.FullName)
    if ($target -eq $keepPath -or $entry.Name -notmatch $stampPattern) { continue }
    if ([IO.Path]::GetDirectoryName($target) -ne $parent) { throw 'Cleanup target escaped the version workspace.' }
    try {
        if ($entry.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw 'Workspace is a reparse point.' }
        Assert-PlainTree $target
        Remove-Item -LiteralPath $target -Recurse -Force
        $removed++
    } catch {
        Write-Warning "Retained $target : $_"
    }
}
Write-Output "[11 workspace cleanup] Removed $removed old directories; kept $keepPath"
