param([Parameter(Mandatory=$true)][string]$WEPath)
$ErrorActionPreference='Stop'
$plugin=Join-Path $PSScriptRoot 'bin/lan_player_name.dll'
if (!(Test-Path $plugin)) { throw 'Build native/player_name.cpp with native/Build.ps1 before launching.' }
$target=Join-Path $PSScriptRoot 'runtime/WE'
$null=New-Item -ItemType Directory -Force $target
# The caller holds both launch locks and has refused all existing games.
$files=@{}
foreach($dir in @('bin','plugin','share','jass')) {
    $source=Join-Path $WEPath $dir
    foreach($file in Get-ChildItem -LiteralPath $source -File -Recurse) {
        $relative=$dir+'\'+$file.FullName.Substring($source.TrimEnd('\','/').Length+1)
        $files[$relative]=$true
        $dest=Join-Path $target $relative
        $null=New-Item -ItemType Directory -Force (Split-Path $dest)
        if (!(Test-Path $dest) -or (Get-FileHash $dest).Hash -ne (Get-FileHash $file.FullName).Hash) {
            Copy-Item -LiteralPath $file.FullName -Destination $dest -Force
        }
    }
}
# Remove only stale files in our fixed managed runtime; never delete a source tree.
foreach($file in Get-ChildItem -LiteralPath $target -File -Recurse) {
    $relative=$file.FullName.Substring($target.Length+1)
    if (!$files.ContainsKey($relative)) { Remove-Item -LiteralPath $file.FullName -Force }
}
Copy-Item $plugin (Join-Path $target 'plugin/warcraft3/lan_player_name.dll') -Force
$cfg=Join-Path $target 'bin/EverConfig.cfg'
$text=[IO.File]::ReadAllText($cfg)
if ($text -notmatch '(?m)^UserName\s*=') { throw 'Missing UserName setting' }
$text=[regex]::Replace($text,'(?m)^UserName\s*=[^\r\n]*','UserName =')
[IO.File]::WriteAllText($cfg,$text,[Text.UTF8Encoding]::new($false))
Add-Content (Join-Path $target 'plugin/warcraft3/config.cfg') "`nlan_player_name.dll = 1"
Write-Output $target
