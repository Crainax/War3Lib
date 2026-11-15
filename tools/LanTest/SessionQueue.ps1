# FIFO admission for a shared game environment. Never terminates processes.
function Get-LanBusyProcesses {
    @(Get-Process -Name war3,'Warcraft III',ydhost -ErrorAction SilentlyContinue)
}
function Enter-LanQueue {
    param([string]$Root, [string]$OwnerId, [string]$MapPath,
          [int]$WaitSeconds=3600, [int]$PollMilliseconds=1000,
          [scriptblock]$BusyProbe={ Get-LanBusyProcesses })
    $dir=Join-Path $Root 'queue'
    $null=New-Item -ItemType Directory -Path $dir -Force
    $self=Get-CimInstance Win32_Process -Filter "ProcessId = $PID"
    $id=[datetime]::UtcNow.Ticks.ToString('D19')+'-'+[guid]::NewGuid().ToString('N')
    $file=Join-Path $dir ($id+'.json')
    $record=[ordered]@{id=$id;ownerId=$OwnerId;runnerPid=$PID;runnerCreationUtcTicks=$self.CreationDate.ToUniversalTime().Ticks.ToString();map=$MapPath;state='WAITING';reason='';heartbeatUtc='';sessionPath=$null}
    function Save-Ticket {
        $record.heartbeatUtc=[datetime]::UtcNow.ToString('o')
        $tmp=$file+'.tmp'
        [IO.File]::WriteAllText($tmp,($record | ConvertTo-Json),[Text.UTF8Encoding]::new($false))
        Move-Item -LiteralPath $tmp -Destination $file -Force
    }
    Save-Ticket
    $deadline=[datetime]::UtcNow.AddSeconds($WaitSeconds)
    $lock=$null; $lastReason=''
    try {
        do {
            $reason='another queued test'
            $ahead=$false
            foreach($ticket in Get-ChildItem -LiteralPath $dir -Filter '*.json' | Sort-Object Name) {
                if($ticket.Name -ge ($id+'.json')) { break }
                try { $other=Get-Content -LiteralPath $ticket.FullName -Raw | ConvertFrom-Json } catch { $ahead=$true; break }
                if($other.state -notin @('WAITING','RUNNING')) { continue }
                $process=Get-CimInstance Win32_Process -Filter "ProcessId = $($other.runnerPid)"
                if($process -and $process.CreationDate.ToUniversalTime().Ticks.ToString() -eq $other.runnerCreationUtcTicks) { $ahead=$true; break }
                # Dead waiter metadata does not own any live game: skip, never kill.
            }
            if(!$ahead) {
                try { $lock=[IO.File]::Open((Join-Path $Root 'session.lock'),'OpenOrCreate','ReadWrite','None') }
                catch [IO.IOException] { $reason='active test owns session.lock' }
                if($lock) {
                    if(@(& $BusyProbe).Count -eq 0) {
                        $record.state='RUNNING'; $record.reason='admitted'; Save-Ticket
                        return @{Lock=$lock;Ticket=$file;Id=$id;OwnerId=$OwnerId}
                    }
                    $lock.Dispose(); $lock=$null
                    $reason='existing game/host preserved; waiting for it to exit'
                }
            }
            $record.reason=$reason; Save-Ticket
            if($reason -ne $lastReason) { Write-Host "[LAN queue] $reason; ticket=$id"; $lastReason=$reason }
            if([datetime]::UtcNow -ge $deadline) { break }
            Start-Sleep -Milliseconds $PollMilliseconds
        } while($true)
        $record.state='DEFERRED'; $record.reason='Queue deadline reached; no existing game was stopped'; Save-Ticket
        throw "LAN_DEFERRED: queue deadline reached. Existing games preserved. Ticket: $file"
    } catch {
        if($lock) { $lock.Dispose() }
        if($record.state -eq 'WAITING') { $record.state='CANCELLED'; Save-Ticket }
        throw
    }
}
function Exit-LanQueue($Lease,[string]$SessionPath) {
    if(!$Lease) { return }
    try {
        $r=Get-Content -LiteralPath $Lease.Ticket -Raw | ConvertFrom-Json
        $r.state='FINISHED'; $r.sessionPath=$SessionPath; $r.heartbeatUtc=[datetime]::UtcNow.ToString('o')
        $r | ConvertTo-Json | Set-Content -LiteralPath $Lease.Ticket -Encoding UTF8
    } finally { $Lease.Lock.Dispose() }
}
