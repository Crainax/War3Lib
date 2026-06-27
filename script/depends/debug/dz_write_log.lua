local jass = require 'jass.common'
local g = require 'jass.globals'
local dbg = require 'jass.debug'

if not g.dzWriteLog_tr then
    g.dzWriteLog_tr = jass.CreateTrigger()
    dbg.handle_ref(g.dzWriteLog_tr)
    jass.TriggerAddCondition(g.dzWriteLog_tr, jass.Condition(function()
        print(tostring(g.dzWriteLog_msg or ''))
    end))
end

return true
