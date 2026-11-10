param([switch]$Restore)
$ErrorActionPreference='Stop'
$dll='D:/WE/KKWE_Plugin/plugin/warcraft3/yd_loader.dll'
$backup=Join-Path $PSScriptRoot 'probes/yd_loader-before-delay.dll'
$originalHash='0F7368DC7367ECB0CBC98468A9F04C5BE92C5778FF56535F3794D1F32A5AA16A'
if (@(Get-Process war3,ydhost -ErrorAction SilentlyContinue).Count) { throw 'Close owned game sessions before updating the loader.' }
if (!(Test-Path -LiteralPath $backup)) {
    if ((Get-FileHash -LiteralPath $dll).Hash -ne $originalHash) { throw 'Unknown loader build; refusing patch.' }
    $null=New-Item -ItemType Directory -Path (Split-Path $backup) -Force
    Copy-Item -LiteralPath $dll -Destination $backup
}
if ((Get-FileHash -LiteralPath $backup).Hash -ne $originalHash) { throw 'Original loader backup hash mismatch.' }
$original=[IO.File]::ReadAllBytes($backup)
# PE RVA 0x1252: verified x86 push 300 in the auto_enter loop.
$pe=[BitConverter]::ToInt32($original,0x3c)
$sections=[BitConverter]::ToUInt16($original,$pe+6)
$sectionTable=$pe+24+[BitConverter]::ToUInt16($original,$pe+20)
$offset=$null
for($i=0;$i -lt $sections;$i++) {
    $at=$sectionTable+40*$i
    $rva=[BitConverter]::ToUInt32($original,$at+12)
    $size=[BitConverter]::ToUInt32($original,$at+16)
    if(0x1252 -ge $rva -and 0x1252 -lt ($rva+$size)) { $offset=[int](0x1252-$rva+[BitConverter]::ToUInt32($original,$at+20)); break }
}
if($null -eq $offset -or [BitConverter]::ToString($original,$offset,5) -ne '68-2C-01-00-00') { throw 'Unexpected instruction.' }
$patched=[byte[]]$original.Clone()
[BitConverter]::GetBytes([int]3000).CopyTo($patched,$offset+1)
$current=[IO.File]::ReadAllBytes($dll)
if([Convert]::ToBase64String($current) -notin @([Convert]::ToBase64String($original),[Convert]::ToBase64String($patched))) { throw 'Loader changed externally; refusing overwrite.' }
[IO.File]::WriteAllBytes($dll,$(if($Restore){$original}else{$patched}))
Write-Output $(if($Restore){'Restored original 300 ms auto-enter loop.'}else{'Installed 3000 ms auto-enter compatibility delay (only known loader build). Use -Restore to undo.'})
