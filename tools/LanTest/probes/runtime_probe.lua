-- Disposable harness smoke assertions; not business-code coverage.
local j = require 'jass.common'
local log = require 'jass.log'
local timer = j.CreateTimer()
j.TimerStart(timer, 12, false, function()
    local count = 0
    for i=0,11 do
        if j.GetPlayerController(j.Player(i)) == j.MAP_CONTROL_USER and j.GetPlayerSlotState(j.Player(i)) == j.PLAYER_SLOT_STATE_PLAYING then count=count+1 end
    end
    log.info((count == 6 and 'PASS: ' or 'FAIL: ') .. 'RuntimeHarness six active humans; observed=' .. count)
    log.info('PASS: RuntimeHarness timer executed in game')
    log.info('[UT_DONE] RuntimeHarness local=P' .. (j.GetPlayerId(j.GetLocalPlayer())+1))
    j.DestroyTimer(timer)
end)
