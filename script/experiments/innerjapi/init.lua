-- Change this module name to select the next experiment.
local runner = require 'script.experiments.innerjapi.runner'
runner.start('script.experiments.innerjapi.cases.http_post')
-- In the local Lua console: require('script.experiments.innerjapi.runner').reload()
-- This trigger belongs to the stable runner entry, not the reloaded case.
local jass = require 'jass.common'
local humans, player = 0, nil
for i = 0, 11 do
    local p = jass.Player(i)
    if jass.GetPlayerSlotState(p) == jass.PLAYER_SLOT_STATE_PLAYING and jass.GetPlayerController(p) == jass.MAP_CONTROL_USER then
        humans, player = humans + 1, p
    end
end
if humans == 1 then
    local trigger = jass.CreateTrigger()
    jass.TriggerRegisterPlayerChatEvent(trigger, player, '-lua-reload', true)
    jass.TriggerAddAction(trigger, function()
        local ok, err = xpcall(runner.reload, debug.traceback)
        if not ok then print(err) end
    end)
    print('[InnerJapi实验]聊天输入 -lua-reload 重载当前用例')
else
    print('[InnerJapi实验]多人环境不注册热重载命令')
end
return runner
